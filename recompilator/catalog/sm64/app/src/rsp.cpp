/**
 * rsp.cpp — RSP microcode dispatch for SM64PC.
 *
 * AUDIO: Super Mario 64 ships the SAME audio microcode as CV64/LoD —
 * byte-identical (verified against the SM64 ROM: aspMain text at rom 0xE7740
 * matches CV64's rom 0x91D30 for the full 0xE20, aspMainData at rom 0xF52C0
 * with the identical command jump table). The RSPRecomp output generated for
 * cv64pc is therefore reused verbatim (rsp/aspMain.cpp) — the recompiled code
 * is a function of the ucode bytes only.
 *
 * GFX: SM64 uses Fast3D (F3D), HLE-rendered by RT64 via send_dl (RT64's GBI
 * database includes rt64_gbi_f3d). No LLE graphics path is wired — cv64pc's
 * recompiled F3DEX2 would be the WRONG microcode for this game, so unlike
 * lodpc it is not linked at all.
 */

#include <cstdio>
#include <cstring>   // memcpy — stage the OSTask into DMEM for the general RSP
#include <cstdlib>   // getenv  — SM64_GFX_LLE gate
#include "librecomp/rsp.hpp"
#include "ultramodern/ultra64.h"

#define M_GFXTASK   1
#define M_AUDTASK   2

static RspExitReason rsp_noop_stub(uint8_t* /*rdram*/, uint32_t /*ucode_addr*/) {
    return RspExitReason::Broke;
}

// RSPRecomp-generated audio ucode (rsp/aspMain.cpp — shared CV64/LoD/SM64 bytes).
RspExitReason aspMain(uint8_t* rdram, uint32_t ucode_addr);

// Same wrapper policy as cv64pc/lodpc: a watchdog bail (Unsupported) must not
// fatal-exit the runtime — degrade to silence for that task.
static RspExitReason aspMain_logged(uint8_t* rdram, uint32_t ucode_addr) {
    static int bail_logs = 0;
    RspExitReason result = aspMain(rdram, ucode_addr);
    if (result != RspExitReason::Broke) {
        if (bail_logs < 5) {
            bail_logs++;
            fprintf(stderr, "[rsp] aspMain returned result=%d -- converting to Broke\n", (int)result);
            fflush(stderr);
        }
        return RspExitReason::Broke;
    }
    return result;
}

// ORACLE-RIG CAPTURE HOOK (2026-07-11, fresh — replaces the July interp/softrdp LLE body, which is
// kept in the lab; the rule: fresh code only, nothing
// inherited). rsp/f3d.cpp is SM64's Fast3D statically recompiled by OUR RSPRecomp (full overlay
// model from the ucode's own descriptor table — see f3d.toml). Runs ALONGSIDE RT64's HLE per gfx
// task; DO_DP_END feeds the librecomp walker, whose armed accumulator captures the faithful RDP
// stream. Everything here is compiled ONLY under -DRDPC_CAPTURE=ON (CMake): default builds contain
// none of this code (2026-07-11: compiled-out beats env-gated).
//   RDPC_GFX_LLE=1        enable the LLE run (inert otherwise)
//   RDPC_DUMP_DIR=<dir>   touching <dir>/DUMP_NOW captures the NEXT gfx task as an N64RDPC1
//                         container (pre-task RDRAM snapshot + stream) and eats the marker.
// Constraint: RECOMP_SOFT_RDP_PIPELINE must stay unset on capture runs (the pipelined walker
// returns before the accumulator).
#ifdef RDPC_CAPTURE_CHAIN
#include <vector>
#include <chrono>
#include <thread>
#include <condition_variable>
#include "lle_console.h"   // note_rendered_ci — the console VI's rendered-origin gate
extern "C" {
#include "rdpcore.h"
}
RspExitReason f3d(uint8_t* rdram, uint32_t ucode_addr);

// == P3: THE LLE RENDERER (RDPC_LLE_RENDER=1) =====================================
// Feeds each gfx task's accumulated RDP stream to rdpcore workers rendering STRAIGHT
// INTO ENGINE RDRAM (rdpcore.c compiles with RDPC_RDRAM_XOR=3 — the engine's swizzled
// convention — so this is zero-copy). RT64 still owns the window; this path proves the
// console pipeline live and measures it. RDPC_LLE_PPM_DIR=<dir> dumps the current
// color image as PPM every 128 tasks for eyeball verification.
// Worker count: default 3 (leaves one core for game+audio+OS on a small core). RDPC_LLE_WORKERS=1..4
// overrides per run — the bench says 4T cuts the worst frame under the 33ms VI budget (26.5ms)
// at the cost of saturating all cores during render bursts. Runtime-tunable so the experiment
// is a launcher toggle, not a rebuild.
static const int RDPC_LLE_MAX_WORKERS = 4;
static int g_lle_nworkers = 3;
static rdpcore_t g_lle_rc[RDPC_LLE_MAX_WORKERS];
static std::vector<uint8_t> g_lle_hidden;
static bool g_lle_ready = false;

// Threaded worker pool: whole-stream-per-worker, the oracle's own parallel shape
// (each worker renders its scanline interleave of the full task). Condvar wake — the
// few-microsecond latency is nothing against multi-ms tasks, and idle workers sleep
// instead of burning the game's cores. Calling thread doubles as worker 0.
struct LLEPool {
    std::mutex m;
    std::condition_variable cv, cv_done;
    uint32_t gen = 0, done = 0;
    const uint8_t* data = nullptr;
    uint32_t len = 0;
    bool quit = false;
    std::vector<std::thread> threads;

    void start() {
        for (int w = 1; w < g_lle_nworkers; w++)
            threads.emplace_back([this, w] {
                uint32_t seen = 0;
                for (;;) {
                    {
                        std::unique_lock<std::mutex> lk(m);
                        cv.wait(lk, [&] { return quit || gen != seen; });
                        if (quit) return;
                        seen = gen;
                    }
                    rdpcore_process(&g_lle_rc[w], data, len);
                    {
                        std::lock_guard<std::mutex> lk(m);
                        done++;
                    }
                    cv_done.notify_one();
                }
            });
    }
    void run(const uint8_t* d, uint32_t l) {
        {
            std::lock_guard<std::mutex> lk(m);
            data = d;
            len = l;
            done = 0;
            gen++;
        }
        cv.notify_all();
        rdpcore_process(&g_lle_rc[0], d, l);
        std::unique_lock<std::mutex> lk(m);
        cv_done.wait(lk, [&] { return done == (uint32_t)(g_lle_nworkers - 1); });
    }
};
static LLEPool g_lle_pool;

static void sm64_lle_render(uint8_t* rdram, const std::vector<uint8_t>& stream,
                            uint32_t task_n) {
    static const char* ppm_dir = std::getenv("RDPC_LLE_PPM_DIR");
    const uint32_t RDRAM_SIZE = 0x800000;
    if (!g_lle_ready) {
        if (const char* e = std::getenv("RDPC_LLE_WORKERS")) {
            long v = atol(e);
            if (v >= 1 && v <= RDPC_LLE_MAX_WORKERS) g_lle_nworkers = (int)v;
        }
        g_lle_hidden.resize(RDRAM_SIZE / 2);
        for (int w = 0; w < g_lle_nworkers; w++) {
            rdpcore_init(&g_lle_rc[w], rdram, RDRAM_SIZE, g_lle_hidden.data());
            if (g_lle_nworkers > 1) {
                g_lle_rc[w].stride = (uint8_t)g_lle_nworkers;
                g_lle_rc[w].woffset = (uint8_t)w;
                g_lle_rc[w].rseed = 3 + (uint32_t)w * 13;
            }
        }
        g_lle_pool.start();
        g_lle_ready = true;
        fprintf(stderr, "[rdpclle] renderer up: %d threaded workers, zero-copy into engine rdram\n",
                g_lle_nworkers);
        fflush(stderr);
    }

    // Pacing-governor cost baseline: zero worker-0's counters (every worker counts the
    // same whole-prim totals; one copy is the frame truth).
    memset(g_lle_rc[0].cost_px, 0, sizeof(g_lle_rc[0].cost_px));
    g_lle_rc[0].cost_prims = 0;

    auto t0 = std::chrono::steady_clock::now();
    g_lle_pool.run(stream.data(), (uint32_t)stream.size());
    double ms = std::chrono::duration<double, std::milli>(
        std::chrono::steady_clock::now() - t0).count();

    // What the REAL RDP would have charged (RT64's v3 model, calibrated against
    // real-hardware footage): 62.5MHz; 1CYC = 1 clk/px, 2CYC = 2, COPY = 0.5, FILL = 0.25;
    // 120 clks per walked primitive; contention 1.0. cost_px is indexed by cycle_type.
    const double hw_cycles = (double)g_lle_rc[0].cost_prims * 120.0
                           + (double)g_lle_rc[0].cost_px[0] * 1.0
                           + (double)g_lle_rc[0].cost_px[1] * 2.0
                           + (double)g_lle_rc[0].cost_px[2] * 0.5
                           + (double)g_lle_rc[0].cost_px[3] * 0.25;
    const double hw_ms = hw_cycles / 62500.0;
    {
        static double hw_sum = 0, wall_sum = 0, wait_sum = 0;
        static uint32_t pace_n = 0, faster_n = 0;
        hw_sum += hw_ms; wall_sum += ms; pace_n++;
        if (ms < hw_ms) { faster_n++; wait_sum += hw_ms - ms; }
        if ((pace_n % 256) == 0) {
            fprintf(stderr, "[rdpcpace] %u tasks: hw avg %.2f ms vs wall avg %.2f ms; "
                    "faster-than-hw %u%% (avg wait-owed %.2f ms)\n",
                    pace_n, hw_sum / pace_n, wall_sum / pace_n,
                    faster_n * 100 / pace_n, faster_n ? wait_sum / faster_n : 0.0);
            fflush(stderr);
        }
    }

    // Report every color image this task drew to the console VI's rendered-origin gate
    // (never-rendered buffers present black, like RT64's own present path).
    for (uint32_t k = 0; k + 8 <= stream.size();) {
        uint8_t op = stream[k] & 0x3F;
        uint32_t nlen = 8;
        if (op >= 0x08 && op <= 0x0F)
            nlen = 0x20 + ((op & 4) ? 0x40 : 0) + ((op & 2) ? 0x40 : 0) + ((op & 1) ? 0x10 : 0);
        else if (op == 0x24 || op == 0x25)
            nlen = 16;
        if (op == 0x3F) {
            uint32_t ci = ((uint32_t)stream[k + 5] << 16) | ((uint32_t)stream[k + 6] << 8) | stream[k + 7];
            sm64::lleconsole::note_rendered_ci(ci);
        }
        k += nlen;
    }

    static double ms_sum = 0, ms_max = 0;
    static uint32_t ms_n = 0;
    ms_sum += ms;
    ms_n++;
    if (ms > ms_max) ms_max = ms;
    if ((ms_n % 256) == 0) {
        fprintf(stderr, "[rdpclle] %u tasks rendered: avg %.2f ms, max %.2f ms\n",
                ms_n, ms_sum / ms_n, ms_max);
        fflush(stderr);
    }

    if (ppm_dir && (task_n % 128) == 0) {
        // find the last color image the stream set (matches the judge's scan)
        uint32_t ci = 0, w = 320;
        for (uint32_t k = 0; k + 8 <= stream.size();) {
            uint8_t op = stream[k] & 0x3F;
            uint32_t n = 8;
            if (op >= 0x08 && op <= 0x0F)
                n = 0x20 + ((op & 4) ? 0x40 : 0) + ((op & 2) ? 0x40 : 0) + ((op & 1) ? 0x10 : 0);
            else if (op == 0x24 || op == 0x25)
                n = 16;
            if (op == 0x3F) {
                w = ((((uint32_t)stream[k + 2] << 8) | stream[k + 3]) & 0x3FF) + 1;
                ci = ((uint32_t)stream[k + 5] << 16) | ((uint32_t)stream[k + 6] << 8) | stream[k + 7];
            }
            k += n;
        }
        if (ci) {
            char path[512];
            snprintf(path, sizeof(path), "%s/lle_task_%u.ppm", ppm_dir, task_n);
            if (FILE* f = fopen(path, "wb")) {
                uint32_t h = 240;
                fprintf(f, "P6\n%u %u\n255\n", w, h);
                for (uint32_t y = 0; y < h; y++)
                    for (uint32_t x = 0; x < w; x++) {
                        uint32_t a = ci + (y * w + x) * 2;
                        uint16_t px = (uint16_t)((rdram[a ^ 3] << 8) | rdram[(a + 1) ^ 3]);
                        uint8_t rgb[3] = {
                            (uint8_t)(((px >> 11) & 0x1F) << 3),
                            (uint8_t)(((px >> 6) & 0x1F) << 3),
                            (uint8_t)(((px >> 1) & 0x1F) << 3)
                        };
                        fwrite(rgb, 1, 3, f);
                    }
                fclose(f);
                fprintf(stderr, "[rdpclle] PPM dumped: %s (ci=%06X w=%u, %.2f ms this task)\n",
                        path, ci, w, ms);
                fflush(stderr);
            }
        }
    }
}

// == THE RDP-PARALLEL RENDER THREAD (console mode) ================================
// The 03:00 diagnosis: video stutter and audio stutter co-occur because renders ran ON
// the events thread — one heavy frame stalled VI presents AND the serial-RSP completion
// chain together. Hardware shape restored: the RDP is its own engine. capture_gfx stashes
// the stream; ConsoleContext::send_dl submits it here (depth-1 mailbox, backpressure only
// if the previous render is still going — rare at 30fps/18.5ms); THIS thread renders and
// then fires dp_complete, so DP-done means the RDP genuinely finished (truer than the old
// inline dp, which fired before the render). Safe against the old decoupling disease: the
// task-descriptor snapshot (events.cpp SpQueueEntry) killed that race at the root.
void dp_complete();   // ultramodern events.cpp — external linkage; timer threads already call it cross-thread
namespace {
    std::mutex g_rdp_m;
    std::condition_variable g_rdp_cv, g_rdp_done_cv;
    std::vector<uint8_t> g_rdp_pending, g_rdp_job;
    uint8_t* g_rdp_rdram = nullptr;
    uint32_t g_rdp_pending_n = 0, g_rdp_job_n = 0;
    bool g_rdp_busy = false, g_rdp_thread_up = false;
}

static void sm64_lle_stash(uint8_t* rdram, const std::vector<uint8_t>& stream, uint32_t task_n) {
    std::lock_guard<std::mutex> lk(g_rdp_m);
    g_rdp_rdram = rdram;
    g_rdp_pending = stream;          // copy — the accumulator reuses its buffer next task
    g_rdp_pending_n = task_n;
}

// Called by ConsoleContext::send_dl (lle_console.cpp), on the events thread, once per gfx task.
void sm64_lle_console_submit() {
    std::unique_lock<std::mutex> lk(g_rdp_m);
    if (!g_rdp_thread_up) {
        g_rdp_thread_up = true;
        std::thread([] {
            for (;;) {
                std::vector<uint8_t> job;
                uint32_t n;
                uint8_t* rdram;
                {
                    std::unique_lock<std::mutex> lk2(g_rdp_m);
                    g_rdp_cv.wait(lk2, [] { return g_rdp_busy; });
                    job = std::move(g_rdp_job);
                    n = g_rdp_job_n;
                    rdram = g_rdp_rdram;
                }
                if (!job.empty() && rdram != nullptr) {
                    sm64_lle_render(rdram, job, n);
                }
                dp_complete();       // hardware-true DP-done: the RDP actually finished
                {
                    std::lock_guard<std::mutex> lk2(g_rdp_m);
                    g_rdp_busy = false;
                }
                g_rdp_done_cv.notify_all();
            }
        }).detach();
        fprintf(stderr, "[rdpclle] RDP-parallel thread up (honest dp_complete)\n");
        fflush(stderr);
    }
    g_rdp_done_cv.wait(lk, [] { return !g_rdp_busy; });   // depth-1 backpressure
    g_rdp_job = std::move(g_rdp_pending);
    g_rdp_job_n = g_rdp_pending_n;
    g_rdp_pending.clear();
    g_rdp_busy = true;
    lk.unlock();
    g_rdp_cv.notify_one();
}

static void sm64_run_gfx_lle(uint8_t* rdram, const OSTask* task) {
    static const char* dump_dir = std::getenv("RDPC_DUMP_DIR");
    static const bool enabled = [] {
        const char* e = std::getenv("RDPC_GFX_LLE");
        const char* c = std::getenv("RDPC_LLE_CONSOLE");   // console mode implies the whole chain
        bool on = (e != nullptr && e[0] == '1') || (c != nullptr && c[0] == '1');
        fprintf(stderr, "[f3dlle] gate %s (RDPC_GFX_LLE / RDPC_LLE_CONSOLE)\n", on ? "ENABLED" : "DISABLED");
        fflush(stderr);
        return on;
    }();
    if (!enabled) {
        return;
    }
    static uint32_t task_n = 0;
    task_n++;
    int last_exit = -1;

    // Dump trigger: marker checked before the run so the RDRAM snapshot is pre-task.
    bool dump = false;
    char marker[512];
    if (dump_dir != nullptr) {
        snprintf(marker, sizeof(marker), "%s/DUMP_NOW", dump_dir);
        if (FILE* mf = fopen(marker, "rb")) { fclose(mf); dump = true; }
    }
    static const bool lle_render = [] {
        const char* e = std::getenv("RDPC_LLE_RENDER");
        const char* c = std::getenv("RDPC_LLE_CONSOLE");   // console mode implies the LLE render
        bool on = (e != nullptr && e[0] == '1') || (c != nullptr && c[0] == '1');
        fprintf(stderr, "[rdpclle] LLE render %s (RDPC_LLE_RENDER / RDPC_LLE_CONSOLE)\n", on ? "ENABLED" : "disabled");
        fflush(stderr);
        return on;
    }();

    static std::vector<uint8_t> rdram_snap;             // un-swizzled, N64 physical byte order
    const uint32_t RDRAM_SIZE = 0x800000;
    if (dump) {
        rdram_snap.resize(RDRAM_SIZE);
        for (uint32_t a = 0; a < RDRAM_SIZE; a++) {
            rdram_snap[a] = rdram[a ^ 3];
        }
    }
    if (dump || lle_render) {
        rdpc_stream_begin();
    }

    // Stage and run the recompiled ucode (dmem shared with the audio LLE — serialize).
    {
        std::lock_guard<std::mutex> dmem_lock(g_rsp_dmem_mutex);
        memcpy(&dmem[0xFC0], task, sizeof(OSTask));
        uint32_t ud_size = task->t.ucode_data_size;
        if (ud_size == 0 || ud_size > 0xF80) ud_size = 0xF80;
        dma_rdram_to_dmem(rdram, 0x0000, task->t.ucode_data, ud_size - 1);
        // Raw (KSEG0) base: the overlay-swap wrapper computes dram - ucode_addr and the DMA
        // register carries the raw task pointer; masking here breaks that subtraction.
        RspExitReason r = f3d(rdram, task->t.ucode);
        static int runs_logged = 0;
        if (runs_logged < 4) {
            runs_logged++;
            fprintf(stderr, "[f3dlle] task #%u exit=%d\n", task_n, (int)r);
            fflush(stderr);
        }
        // Exit-reason census: Broke is the only clean end; anything else is a silent bail.
        static uint32_t exit_counts[8] = {};
        exit_counts[(int)r < 8 ? (int)r : 0]++;
        static int bails_logged = 0;
        if (r != RspExitReason::Broke && bails_logged < 16) {
            bails_logged++;
            fprintf(stderr, "[f3dlle] BAIL task #%u exit=%d\n", task_n, (int)r);
            fflush(stderr);
        }
        if ((task_n % 256) == 0) {
            fprintf(stderr, "[f3dlle] census inv=%u broke=%u imem=%u ujt=%u unsup=%u swap=%u urt=%u\n",
                    exit_counts[0], exit_counts[1], exit_counts[2], exit_counts[3],
                    exit_counts[4], exit_counts[5], exit_counts[6]);
            fflush(stderr);
        }
        last_exit = (int)r;
    }

    if (lle_render && !dump) {
        if (sm64::lleconsole::active()) {
            // Console mode: stash for the RDP-parallel thread; ConsoleContext::send_dl
            // submits it and the RDP thread fires the honest dp_complete.
            sm64_lle_stash(rdram, rdpc_stream_take(), task_n);
        } else {
            sm64_lle_render(rdram, rdpc_stream_take(), task_n);
        }
    }
    if (dump) {
        const std::vector<uint8_t>& stream = rdpc_stream_take();
        if (lle_render) sm64_lle_render(rdram, stream, task_n);
        char path[512];
        snprintf(path, sizeof(path), "%s/sm64_task_%u.rdpc", dump_dir, task_n);
        if (FILE* f = fopen(path, "wb")) {
            char meta[256];
            int meta_len = snprintf(meta, sizeof(meta),
                "game=sm64 tree=N64PC-july src=f3d-LLE(ours,2026-07-11) task=%u", task_n);
            uint32_t sz = RDRAM_SIZE, slen = (uint32_t)stream.size(), mlen = (uint32_t)meta_len;
            fwrite("N64RDPC1", 1, 8, f);
            fwrite(&sz, 4, 1, f);
            fwrite(rdram_snap.data(), 1, RDRAM_SIZE, f);
            fwrite(&slen, 4, 1, f);
            fwrite(stream.data(), 1, slen, f);
            fwrite(&mlen, 4, 1, f);
            fwrite(meta, 1, mlen, f);
            fclose(f);
            fprintf(stderr, "[f3dlle] DUMPED task #%u: %u stream bytes (exit=%d) -> %s\n", task_n, slen, last_exit, path);
            fprintf(stderr, "[f3dlle] break_vram=0x%04X jumps(oldest->newest):", g_rsp_break_vram);
            for (uint32_t k = 0; k < 64; k++) {
                fprintf(stderr, " %04X", g_rsp_jump_ring[(g_rsp_jump_ring_idx + k) & 63]);
            }
            fprintf(stderr, "\n");
        } else {
            fprintf(stderr, "[f3dlle] dump FAILED to open %s\n", path);
        }
        fflush(stderr);
        remove(marker);   // one touch = one capture
    }
}
#endif // RDPC_CAPTURE_CHAIN

static RspUcodeFunc* sm64_get_rsp_microcode(const OSTask* task) {
    switch (task->t.type) {
    case M_AUDTASK:
        return aspMain_logged;
    case M_GFXTASK:
        // GFX tasks are routed to RT64 via send_dl; this return is never run.
        return rsp_noop_stub;
    default:
        fprintf(stderr, "[sm64pc] Unknown RSP task type %u — returning no-op stub\n",
                (unsigned)task->t.type);
        return rsp_noop_stub;
    }
}

recomp::rsp::callbacks_t get_rsp_callbacks() {
    return {
        .get_rsp_microcode = sm64_get_rsp_microcode,
#ifdef RDPC_CAPTURE_CHAIN
        .capture_gfx = sm64_run_gfx_lle,
#endif
    };
}
