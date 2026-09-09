/**
 * rsp.cpp — RSP microcode dispatch for AEROGAUGEPC (Aerogauge 64, USA). Console seam ported
 * from snowkidspc (2026-07-31 batch, starfox64pc port pattern).
 *
 * AUDIO: Aerogauge ships the SAME audio microcode as CV64/SM64/LoD — byte-identical
 * (verified in-ROM: aspMain text at PW rom 0x48E10 matches SM64 rom 0xE7740 for 0x100,
 * aspMainData command jump table at PW rom 0x51B80). The RSPRecomp output generated for
 * cv64pc/sm64pc is therefore reused verbatim (rsp/aspMain.cpp) — the recompiled code is a
 * function of the ucode bytes only. FOURTH game on the same shared Nintendo-era ucode.
 * GFX: desktop tier HLE-rendered by RT64 via send_dl; console tier LLE via the recompiled
 * F3DEX.NoN 1.23 artifact (RecompiledFuncs/f3dexnon123.cpp).
 */
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <mutex>
#include "librecomp/rsp.hpp"
#include "ultramodern/ultra64.h"

#define M_GFXTASK   1
#define M_AUDTASK   2

static RspExitReason rsp_noop_stub(uint8_t* /*rdram*/, uint32_t /*ucode_addr*/) {
    return RspExitReason::Broke;
}

// RSPRecomp-generated audio ucode (rsp/aspMain.cpp — shared CV64/SM64/LoD/PW bytes).
RspExitReason aspMain(uint8_t* rdram, uint32_t ucode_addr);

// Same wrapper policy as cv64pc/sm64pc: a watchdog bail (Unsupported) must not fatal-exit
// the runtime — degrade to silence for that task.
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

// ── LLE CONSOLE (console seam ported from snowkidspc, 2026-07-31 batch): F3DEX.NoN 1.23 ─────
// RecompiledFuncs/f3dexnon123.cpp — RSPRecomp artifact (f3dexnon123.toml; census: AeroGauge
// rides the F3DEX.NoN 1.23 family). The console tier consumes the UCODE REGISTRY; fallback =
// the direct artifact call. gfx registration is deferred to the organ's own [ucode-miss] lines
// from the first Pi run (bootstrap by design; F3DEX 1.x keys collide across sibling builds ⇒
// window constants must come from a live run).
RspExitReason f3dexnon123(uint8_t* rdram, uint32_t ucode_addr);

static RspUcodeFunc* aerogauge_gfx_ucode_for(uint8_t* rdram, const OSTask* task) {
    RspUcodeFunc* fn = recomp::rsp::dispatch_ucode(rdram, task);
    return fn != nullptr ? fn : f3dexnon123;
}

// Desktop/HLE tier: no LLE capture (RT64 renders via send_dl).
static void aerogauge_run_gfx_lle(uint8_t* /*rdram*/, const OSTask* /*task*/) {}

static RspUcodeFunc* aerogauge_get_rsp_microcode(const OSTask* task) {
    switch (task->t.type) {
    case M_AUDTASK:
        return aspMain_logged;
    case M_GFXTASK:
        // HLE tier: routed to RT64 via send_dl (not reached). Console tier: the registry/artifact
        // serve via aerogauge_run_gfx_capture; this documents the mapping and keeps the artifact linked.
        return f3dexnon123;
    default:
        fprintf(stderr, "[aerogaugepc] Unknown RSP task type %u — no-op stub\n",
                (unsigned)task->t.type);
        return rsp_noop_stub;
    }
}


#ifdef RDPC_CAPTURE_CHAIN
#include <vector>
#include <chrono>
#include <thread>
#include <condition_variable>
#include "lle_console.h"   // note_rendered_ci — the console VI's rendered-origin gate
extern "C" {
#include "rdpcore.h"
#include "rdpcore_gpu.h"   // optional compute backend, not built here
}
// ── PRESERVATION-CORE RENDERER (console seam ported from snowkidspc, 2026-07-31 batch) ─────────
// Ported verbatim from sm64pc/donkeykong64pc (the game-agnostic console machinery). The recompiled
// gfx ucode (aerogauge_recomp, f3dexnon123.cpp) runs per gfx task; DO_DP_END feeds the librecomp
// walker whose armed accumulator captures the faithful RDP stream; the RDP-parallel thread renders
// it through rdpcore workers straight into engine RDRAM (zero-copy, RDPC_RDRAM_XOR=3), and the
// console VI (lle_console.cpp) scans it out. Everything here is compiled ONLY under -DRDPC_CAPTURE=ON.
//   RDPC_LLE_CONSOLE=1    console mode — implies the whole chain (gfx LLE + LLE render)
//   RDPC_GFX_LLE=1        enable the LLE run without the console (measurement)
//   RDPC_DUMP_DIR=<dir>   touching <dir>/DUMP_NOW captures the NEXT gfx task as an N64RDPC1 and eats
//                         the marker (one touch = one capture; RDRAM snapshot is pre-task).

// == THE LLE RENDERER (RDPC_LLE_RENDER=1) =========================================
// Feeds each gfx task's accumulated RDP stream to rdpcore workers rendering STRAIGHT INTO ENGINE
// RDRAM (rdpcore.c compiles with RDPC_RDRAM_XOR=3 — the engine's swizzled convention — so this is
// zero-copy). RDPC_LLE_WORKERS=1..4 overrides the worker count per run (default 3: leaves one core
// for game+audio+OS on a small core).
static const int RDPC_LLE_MAX_WORKERS = 4;
static int g_lle_nworkers = 3;
static rdpcore_t g_lle_rc[RDPC_LLE_MAX_WORKERS];
static std::vector<uint8_t> g_lle_hidden;
static bool g_lle_ready = false;

// Threaded worker pool: whole-stream-per-worker, each worker renders its scanline interleave of the
// full task. Condvar wake; the calling thread doubles as worker 0.
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

static void aerogauge_lle_render(uint8_t* rdram, const std::vector<uint8_t>& stream,
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

    memset(g_lle_rc[0].cost_px, 0, sizeof(g_lle_rc[0].cost_px));
    g_lle_rc[0].cost_prims = 0;

    auto t0 = std::chrono::steady_clock::now();
    // RUNG C: offer the WHOLE task to the tiled GPU rasteriser first. It returns 0 for any
    // task containing a primitive it cannot do, and then the judged CPU pool runs exactly as
    // before -- a buffer is never half-CPU half-GPU, which is what keeps draw order correct.
    if (!rdpcore_gpu_try_task(stream.data(), (uint32_t)stream.size(), 0x400000u))
        g_lle_pool.run(stream.data(), (uint32_t)stream.size());

    double ms = std::chrono::duration<double, std::milli>(
        std::chrono::steady_clock::now() - t0).count();

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
            preservation_core::lleconsole::note_rendered_ci(ci);
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
// capture_gfx stashes the stream; ConsoleContext::send_dl submits it here (depth-1 mailbox); THIS
// thread renders and then fires dp_complete, so DP-done means the RDP genuinely finished.
void dp_complete();   // ultramodern events.cpp — external linkage; called cross-thread
namespace {
    std::mutex g_rdp_m;
    std::condition_variable g_rdp_cv, g_rdp_done_cv;
    std::vector<uint8_t> g_rdp_pending, g_rdp_job;
    uint8_t* g_rdp_rdram = nullptr;
    uint32_t g_rdp_pending_n = 0, g_rdp_job_n = 0;
    bool g_rdp_busy = false, g_rdp_thread_up = false;
}

static void aerogauge_lle_stash(uint8_t* rdram, const std::vector<uint8_t>& stream, uint32_t task_n) {
    // TITLE-BLINK FIX (SK1 pilot, 2026-07-24, a visible black blink on the title):
    // note every color image at SUBMIT time, not render-complete. The game unblanks the VI
    // as soon as it has queued the task (hardware's RDP would already be writing the buffer);
    // our async RDP thread could lag a 53ms spike behind, and the rendered-origin gate then
    // presented BLACK past the unblank. Submit-time stamping matches the hardware window —
    // worst case is a hardware-authentic partially-drawn buffer, never a black flash.
    // (The post-render note in aerogauge_lle_render stays; the registry dedups.)
    for (uint32_t k = 0; k + 8 <= stream.size();) {
        uint8_t op = stream[k] & 0x3F;
        uint32_t nlen = 8;
        if (op >= 0x08 && op <= 0x0F)
            nlen = 0x20 + ((op & 4) ? 0x40 : 0) + ((op & 2) ? 0x40 : 0) + ((op & 1) ? 0x10 : 0);
        else if (op == 0x24 || op == 0x25)
            nlen = 16;
        if (op == 0x3F) {
            uint32_t ci = ((uint32_t)stream[k + 5] << 16) | ((uint32_t)stream[k + 6] << 8) | stream[k + 7];
            preservation_core::lleconsole::note_rendered_ci(ci);
        }
        k += nlen;
    }
    std::lock_guard<std::mutex> lk(g_rdp_m);
    g_rdp_rdram = rdram;
    g_rdp_pending = stream;          // copy — the accumulator reuses its buffer next task
    g_rdp_pending_n = task_n;
}

// Called by ConsoleContext::send_dl (lle_console.cpp), on the events thread, once per gfx task.
// Registered with the organ via set_submit_callback (main.cpp, organ Move 1).
void aerogauge_lle_console_submit() {
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
                    aerogauge_lle_render(rdram, job, n);
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

static void aerogauge_run_gfx_capture(uint8_t* rdram, const OSTask* task) {
    static const char* dump_dir = std::getenv("RDPC_DUMP_DIR");
    static const bool enabled = [] {
        const char* e = std::getenv("RDPC_GFX_LLE");
        const char* c = std::getenv("RDPC_LLE_CONSOLE");   // console mode implies the whole chain
        bool on = (e != nullptr && e[0] == '1') || (c == nullptr || c[0] != '0');   // console default ON (env sweep 2026-07-23)
        fprintf(stderr, "[nonlle] gate %s (RDPC_GFX_LLE / RDPC_LLE_CONSOLE)\n", on ? "ENABLED" : "DISABLED");
        fflush(stderr);
        return on;
    }();
    if (!enabled) return;
    static uint32_t task_n = 0;
    task_n++;
    int last_exit = -1;

    // Dump trigger checked BEFORE the run so the RDRAM snapshot is pre-task.
    bool dump = false;
    char marker[512];
    if (dump_dir != nullptr) {
        snprintf(marker, sizeof(marker), "%s/DUMP_NOW", dump_dir);
        if (FILE* mf = fopen(marker, "rb")) { fclose(mf); dump = true; }
    }
    static const bool lle_render = [] {
        const char* e = std::getenv("RDPC_LLE_RENDER");
        const char* c = std::getenv("RDPC_LLE_CONSOLE");   // console mode implies the LLE render
        bool on = (e != nullptr && e[0] == '1') || (c == nullptr || c[0] != '0');   // console default ON (env sweep 2026-07-23)
        fprintf(stderr, "[rdpclle] LLE render %s (RDPC_LLE_RENDER / RDPC_LLE_CONSOLE)\n", on ? "ENABLED" : "disabled");
        fflush(stderr);
        return on;
    }();

    static std::vector<uint8_t> rdram_snap;             // un-swizzled, N64 physical byte order
    const uint32_t RDRAM_SIZE = 0x800000;
    if (dump) {
        rdram_snap.resize(RDRAM_SIZE);
        for (uint32_t a = 0; a < RDRAM_SIZE; a++) rdram_snap[a] = rdram[a ^ 3];
    }
    if (dump || lle_render) {
        rdpc_stream_begin();
    }

    // Stage + run the recompiled gfx ucode (shared dmem[] with the audio LLE — serialize).
    {
        std::lock_guard<std::mutex> dmem_lock(g_rsp_dmem_mutex);
        memcpy(&dmem[0xFC0], task, sizeof(OSTask));
        uint32_t ud_size = task->t.ucode_data_size;
        if (ud_size == 0 || ud_size > 0xF80) ud_size = 0xF80;
        dma_rdram_to_dmem(rdram, 0x0000, task->t.ucode_data, ud_size - 1);
        // Console tier serves through the UCODE REGISTRY (dispatch_ucode HIT = the judged
        // artifact; MISS = the legacy direct call). Same staging either way.
        RspExitReason r = aerogauge_gfx_ucode_for(rdram, task)(rdram, task->t.ucode);
        last_exit = (int)r;
        static uint32_t exit_counts[8] = {};
        exit_counts[(int)r < 8 ? (int)r : 0]++;
        static int bails_logged = 0;
        if (r != RspExitReason::Broke && bails_logged < 16) {
            bails_logged++;
            fprintf(stderr, "[nonlle] BAIL task #%u exit=%d\n", task_n, (int)r);
            fflush(stderr);
        }
        if ((task_n % 256) == 0) {
            fprintf(stderr, "[nonlle] census inv=%u broke=%u imem=%u ujt=%u unsup=%u swap=%u urt=%u\n",
                    exit_counts[0], exit_counts[1], exit_counts[2], exit_counts[3],
                    exit_counts[4], exit_counts[5], exit_counts[6]);
            fflush(stderr);
        }
    }

    if (lle_render && !dump) {
        if (preservation_core::lleconsole::active()) {
            // Console mode: stash for the RDP-parallel thread; ConsoleContext::send_dl
            // submits it and the RDP thread fires the honest dp_complete.
            aerogauge_lle_stash(rdram, rdpc_stream_take(), task_n);
        } else {
            aerogauge_lle_render(rdram, rdpc_stream_take(), task_n);
        }
    }
    if (dump) {
        const std::vector<uint8_t>& stream = rdpc_stream_take();
        if (lle_render) aerogauge_lle_render(rdram, stream, task_n);
        char path[512];
        snprintf(path, sizeof(path), "%s/aerogauge_task_%u.rdpc", dump_dir, task_n);
        if (FILE* f = fopen(path, "wb")) {
            char meta[256];
            int meta_len = snprintf(meta, sizeof(meta),
                "game=aerogauge tree=N64PC src=f3dexnon123-LLE(RSPRecomp) task=%u", task_n);
            uint32_t sz = RDRAM_SIZE, slen = (uint32_t)stream.size(), mlen = (uint32_t)meta_len;
            fwrite("N64RDPC1", 1, 8, f);
            fwrite(&sz, 4, 1, f);
            fwrite(rdram_snap.data(), 1, RDRAM_SIZE, f);
            fwrite(&slen, 4, 1, f);
            fwrite(stream.data(), 1, slen, f);
            fwrite(&mlen, 4, 1, f);
            fwrite(meta, 1, mlen, f);
            fclose(f);
            fprintf(stderr, "[nonlle] DUMPED task #%u: %u stream bytes (exit=%d) -> %s\n",
                    task_n, slen, last_exit, path);
        } else {
            fprintf(stderr, "[nonlle] dump FAILED to open %s\n", path);
        }
        fflush(stderr);
        remove(marker);   // one touch = one capture
    }
}
#endif // RDPC_CAPTURE_CHAIN

recomp::rsp::callbacks_t get_rsp_callbacks() {
    // UCODE CATALOG REGISTRY (organ 3): content-hash dispatch, law v1 + verify windows.
    // aspMain: Tetrisphere ships a KEY-colliding sibling (text diverges at 0xDAF) — window
    // [0xD80,+0xA0) FNV discriminates: SK1 = sm64 = spaceinv = 19D507EA3E34D5F6 (proven
    // offline, SERVED_ROSTER rung, ENGINE_LEDGER 07-24). Aerogauge ships the byte-identical
    // artifact (rsp/aspMain.cpp md5-matches snowkidspc's); a differing data window would
    // verify-MISS to the legacy direct call — safe either way.
    recomp::rsp::register_ucode(0xEE85B9F8C730AF02ull, "aspMain", aspMain_logged,
                                0xD80, 0xA0, 0x19D507EA3E34D5F6ull);
    return {
        .get_rsp_microcode = aerogauge_get_rsp_microcode,
        // Console tier (-DRDPC_CAPTURE=ON): the preservation-core chain — recompiled F3DEX.NoN
        // via the registry -> rdpcore -> console VI. Desktop tier: inert no-op alongside RT64.
#ifdef RDPC_CAPTURE_CHAIN
        .capture_gfx = aerogauge_run_gfx_capture,
#else
        .capture_gfx = aerogauge_run_gfx_lle,
#endif
    };
}
