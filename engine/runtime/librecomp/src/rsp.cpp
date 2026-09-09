#include <cassert>
#include <cstring>
#include <cinttypes>
#include <cstdlib>
#include <set>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <deque>
#if defined(__linux__)
#include <pthread.h>
#include <sched.h>
#include <unistd.h>
#endif

#include "rsp.hpp"
#include "softrdp/softrdp.h"

// P2 Task 2 (chip-per-core): pin the calling thread to a dedicated CPU core. Affinity only — no privileges
// needed (unlike SCHED_FIFO); isolcpus on a Linux kernel cmdline makes it exclusive. No-op off-Linux/core<0.
static void pin_thread_to_core(int core) {
#if defined(__linux__)
    if (core < 0) return;
    cpu_set_t set; CPU_ZERO(&set); CPU_SET(core, &set);
    pthread_setaffinity_np(pthread_self(), sizeof(set), &set);
#else
    (void)core;
#endif
}

static recomp::rsp::callbacks_t rsp_callbacks {};

void recomp::rsp::set_callbacks(const callbacks_t& callbacks) {
    rsp_callbacks = callbacks;
}

uint8_t dmem[0x1000];
uint16_t rspReciprocals[512];
uint16_t rspInverseSquareRoots[512];

// CV64 Brick 3 (graphics-ucode LLE): serializes dmem[] between the audio task thread and the gfx LLE
// capture thread (both recompiled ucodes share the single global dmem[]). See rsp.hpp.
std::mutex g_rsp_dmem_mutex;

// CV64 Brick 3 (Option D): run the registered gfx-ucode LLE capture hook (if any) for a gfx task.
// The hook itself takes g_rsp_dmem_mutex around its dmem[] use.
// Forward decl (defined below, after the RdpPipe): the RSP∥RDP gfx-task boundary + lag bound.
extern "C" void recomp_softrdp_pipeline_end_task();

void recomp::rsp::capture_gfx_task(uint8_t* rdram, const OSTask* task) {
    // GFX ORACLE CAPTURE (2026-07-23, the ucode-catalog rung): RECOMP_GFX_DUMP=<dir> + touch
    // <dir>/DUMP_NOW captures the next N gfx tasks (RECOMP_GFX_CHAIN=<N>, default 1) as N64GFXC1
    // (OSTask + pre-task RDRAM, N64 physical byte order — same container shape as N64ASPC1).
    // Feeds the offline RSP A/B oracle: replay through rsp_interp (real microcode) vs the
    // RSPRecomp'd catalog ucode, diff the emitted RDP streams. Engine-level: EVERY game's gfx
    // tasks are capturable, HLE- and LLE-rendered alike (this hook runs before send_dl).
    // Instrument only — fully inert unless the env names a directory.
    {
        static const char* gfx_dir = getenv("RECOMP_GFX_DUMP");
        if (gfx_dir != nullptr) {
            static const int gfx_chain = [] {
                const char* c = getenv("RECOMP_GFX_CHAIN");
                int v = c ? atoi(c) : 0;
                return (v > 0 && v <= 64) ? v : 1;
            }();
            static int chain_left = 0;
            static uint32_t gfx_n = 0;
            char marker[512];
            snprintf(marker, sizeof(marker), "%s/DUMP_NOW", gfx_dir);
            if (FILE* mf = fopen(marker, "rb")) {
                fclose(mf);
                remove(marker);
                chain_left = gfx_chain;
            }
            if (chain_left > 0) {
                chain_left--;
                char gfx_path[512];
                snprintf(gfx_path, sizeof(gfx_path), "%s/gfx_task_%u.gfxc", gfx_dir, gfx_n++);
                if (FILE* f = fopen(gfx_path, "wb")) {
                    fwrite("N64GFXC1", 1, 8, f);
                    fwrite(task, sizeof(OSTask), 1, f);
                    uint32_t sz = 0x800000;
                    fwrite(&sz, 4, 1, f);
                    uint8_t chunk[4096];
                    for (uint32_t base = 0; base < 0x800000; base += 4096) {
                        for (uint32_t i = 0; i < 4096; i++) chunk[i] = rdram[(base + i) ^ 3];
                        fwrite(chunk, 1, sizeof(chunk), f);
                    }
                    fclose(f);
                    fprintf(stderr, "[gfxdump] pre-task -> %s (ucode=0x%08X data_ptr=0x%08X)\n",
                            gfx_path, (uint32_t)task->t.ucode, (uint32_t)task->t.data_ptr);
                    fflush(stderr);
                }
            }
        }
    }
    // Organ 3 standing counter on the GFX path too: name every distinct gfx ucode as catalog
    // HIT or MISS (once per hash). On the RT64 tier the result isn't executed (HLE renders the
    // DL) — the counter still tells us which catalog member each game's tasks would dispatch,
    // feeding the census. LLE lineages consume dispatch_ucode for real in their capture hooks.
    (void)dispatch_ucode(rdram, task);
    if (rsp_callbacks.capture_gfx != nullptr) {
        rsp_callbacks.capture_gfx(rdram, task);
    }
    // P2 Task 2 (RSP∥RDP): the task's DP ranges are all enqueued now; mark the boundary + bound the lag.
    // The capture callback has RETURNED, so the game's dmem mutex is released — a pipeline stall here can
    // never block the audio LLE. No-op unless RECOMP_SOFT_RDP_PIPELINE=1.
    recomp_softrdp_pipeline_end_task();
}

// CV64 Brick 3 (graphics-ucode LLE): DP command FIFO state (see rsp.hpp). Globals because the RDP is
// a single unit and the capture is a side effect; persists across overlay swaps without ctx plumbing.
uint32_t g_rsp_dpc_start = 0;
uint32_t g_rsp_dpc_end = 0;
uint32_t g_rsp_dpc_current = 0;

// ORACLE-RIG CAPTURE accumulator + ucode diagnostic trace (see rsp.hpp; 2026-07-11). Single-threaded
// with the walker (both on the gfx events thread), so no locking. Inert unless armed.
static std::vector<uint8_t> g_rdpc_stream;
static bool g_rdpc_armed = false;
void rdpc_stream_begin() { g_rdpc_stream.clear(); g_rdpc_armed = true; }
const std::vector<uint8_t>& rdpc_stream_take() { g_rdpc_armed = false; return g_rdpc_stream; }
uint32_t g_rsp_jump_ring[64];
uint32_t g_rsp_jump_ring_idx = 0;
uint32_t g_rsp_break_vram = 0;

// CV64 Brick 4 (Option D): the faithful per-triangle screen-Z the LLE F3DEX2 computes, captured in
// RDP-emit (draw) order for the CURRENT gfx task. cv64_run_gfx_lle resets _count before running the
// ucode; RT64's interpreter — which renders the SAME task's DL sequentially right after, on the same
// events thread (see events.cpp capture_gfx_task -> send_dl) — consumes g_lle_faithful_z[idx] per
// depth triangle to OVERRIDE its collapsed HLE depth with the real N64 value. Fixed array sized for one
// task's triangles; overflow is bounded + counted (never OOB). Cross-module: defined here (librecomp),
// externed in src/rsp.cpp (clear) + rt64 (consume).
extern "C" {
    float g_lle_faithful_z[131072];
    volatile uint32_t g_lle_faithful_z_count = 0;
    volatile uint32_t g_lle_faithful_z_overflow = 0;
}

// ── P2 Task 2: RSP∥RDP concurrency ────────────────────────────────────────────────────────────────
// Env RECOMP_SOFT_RDP_PIPELINE=1: run softrdp on a DEDICATED consumer thread instead of inline on the
// gfx/events thread, so the LLE(frame N+1) + game overlap softrdp's raster(frame N) — frame time goes
// from ~(RSP + RDP) toward ~max(RSP, RDP). Producer = rsp_process_rdp_commands (enqueues each DP range);
// the boundary is the gfx TASK (cv64_run_gfx_lle calls end_task after f3dex2 returns — no SyncFull parse
// needed). Bounded to ≤1 task in flight so the consumer never lags past CV64's double-buffered DL. The
// consumer runs process_commands single-threaded (assumes THREADS=1; the parked banding is a different
// model). Hazard oracle = the softrdp CRC: pipelined must still == the serial baseline (7D078800), else
// the LLE overwrote RDRAM (a texture/DL buffer) a queued range still needed.
namespace {
struct RdpPipe {
    uint64_t max_in_flight = 1;   // RECOMP_SOFT_RDP_INFLIGHT: gfx tasks the game may run ahead of the raster.
                                  // 1 = only intra-task overlap; >1 = inter-frame overlap (bounded so the
                                  // game can't reuse an RDRAM buffer a queued range still needs — CRC gates it).
    struct Item { uint32_t start, end; bool boundary; };
    std::thread worker;
    std::mutex m;
    std::condition_variable cv_work, cv_done;
    std::deque<Item> q;
    uint8_t* rdram = nullptr;
    uint64_t range_enq = 0, range_done = 0;   // ranges (for present drain)
    uint64_t task_enq = 0, task_done = 0;      // gfx tasks (for the in-flight bound)
    bool stop = false;
    int rsp_core = -1, rdp_core = -1;          // chip-per-core affinity (-1 = unpinned)
    void start() {
        if (const char* e = getenv("RECOMP_SOFT_RDP_PIN"); e && e[0] == '1') { rdp_core = 3; rsp_core = 2; }
        if (const char* c = getenv("RECOMP_SOFT_RDP_RDPCORE")) rdp_core = atoi(c);
        if (const char* c = getenv("RECOMP_SOFT_RDP_RSPCORE")) rsp_core = atoi(c);
        if (const char* c = getenv("RECOMP_SOFT_RDP_INFLIGHT")) { long v = atol(c); max_in_flight = v > 0 ? (uint64_t)v : 1; }
        worker = std::thread([this] {
            pin_thread_to_core(rdp_core);   // the softrdp consumer (RDP) gets its own core
            for (;;) {
                Item it;
                {
                    std::unique_lock<std::mutex> lk(m);
                    cv_work.wait(lk, [this] { return stop || !q.empty(); });
                    if (stop && q.empty()) return;
                    it = q.front(); q.pop_front();
                }
                if (it.boundary) {
                    std::unique_lock<std::mutex> lk(m);
                    task_done++; cv_done.notify_all();
                } else {
                    softrdp::process_commands(rdram, it.start, it.end);
                    std::unique_lock<std::mutex> lk(m);
                    range_done++; cv_done.notify_all();
                }
            }
        });
    }
    void enqueue(uint8_t* rd, uint32_t s, uint32_t e) {
        std::unique_lock<std::mutex> lk(m);
        rdram = rd;
        q.push_back({ s, e, false });
        range_enq++;
        cv_work.notify_one();
    }
    void end_task() {   // gfx-task boundary: mark it, then block if the consumer is too far behind
        static thread_local bool pinned = false;   // pin the RSP/events (producer) thread to its core, once
        if (!pinned) { pin_thread_to_core(rsp_core); pinned = true; }
        std::unique_lock<std::mutex> lk(m);
        q.push_back({ 0, 0, true });
        task_enq++;
        cv_work.notify_one();
        cv_done.wait(lk, [this] { return (task_enq - task_done) <= max_in_flight; });
    }
    void sync() {       // present drain: wait until every range enqueued so far is rasterized
        std::unique_lock<std::mutex> lk(m);
        uint64_t target = range_enq;
        cv_done.wait(lk, [this, target] { return range_done >= target; });
    }
    void shutdown_worker() {   // clean stop on quit: drain + exit the consumer BEFORE RDRAM is torn down
        if (!worker.joinable()) return;
        { std::unique_lock<std::mutex> lk(m); stop = true; cv_work.notify_all(); }
        worker.join();
    }
};
static RdpPipe* g_rdp_pipe = nullptr;
static int g_pipeline = -1;   // RECOMP_SOFT_RDP_PIPELINE
}

extern "C" void recomp_softrdp_pipeline_end_task() { if (g_rdp_pipe) g_rdp_pipe->end_task(); }
extern "C" void recomp_softrdp_pipeline_sync() {
    static int nodrain = -1;   // RECOMP_SOFT_RDP_NODRAIN=1: skip the present drain (measures the drain's cost; may tear)
    if (nodrain < 0) { const char* e = getenv("RECOMP_SOFT_RDP_NODRAIN"); nodrain = (e && e[0] == '1') ? 1 : 0; }
    if (g_rdp_pipe && !nodrain) g_rdp_pipe->sync();
}
extern "C" void recomp_softrdp_pipeline_stop() { if (g_rdp_pipe) g_rdp_pipe->shutdown_worker(); }

// Brick 4 (Option D): DECODE the LLE F3DEX2's RDP command stream. The [start, end) RDRAM range is the
// block of 64-bit RDP commands the recompiled graphics ucode just emitted (via DPC_END). The whole
// point of LLE-ing the RSP is the FAITHFUL screen-Z: for z-buffered triangle commands the RSP-computed
// depth lives in the Z-buffer coefficient block (the value the HLE RT64 only approximates, and the
// castle-ghost hypothesis says diverges). We walk the FIFO, decode commands, and extract that Z so it
// can be compared against RT64's HLE depth (figz) and, next, routed into an RDP. Decode-only for now.
//
// RDP command lengths: most are 8 bytes (1 doubleword). The exceptions are triangles (0x08-0x0F,
// variable: edge 0x20 + shade 0x40 + texture 0x40 + zbuf 0x10, gated by opcode bits 4/2/1) and the two
// texture-rectangle ops (0x24/0x25, 16 bytes). Triangle Z block (when present) is LAST; its first word
// is Z in s15.16. RDRAM is the recompiler's ^3-swizzled image, so read bytes through (a ^ 3).
void rsp_process_rdp_commands(uint8_t* rdram, uint32_t start, uint32_t end) {
    // THE SOFTWARE RDP (GPU-free native renderer, env RECOMP_SOFT_RDP=1): rasterize this exact
    // command range into the game's color image in RDRAM, like the silicon. The decode/telemetry
    // below stays as-is (independent read-only pass). Plan: memory/project_pi_native_console.md.
    if (softrdp::enabled()) {
        if (g_pipeline < 0) {   // one-time init on the first DP range (events thread, pre-concurrency)
            const char* e = getenv("RECOMP_SOFT_RDP_PIPELINE");
            g_pipeline = (e && e[0] == '1') ? 1 : 0;
            if (g_pipeline) { g_rdp_pipe = new RdpPipe(); g_rdp_pipe->start(); }
        }
        if (g_pipeline) g_rdp_pipe->enqueue(rdram, start, end);   // RSP∥RDP: rasterize on the consumer thread
        else softrdp::process_commands(rdram, start, end);
    }

    // When pipelining (the software-RDP render path), skip the RT64-only faithful-Z telemetry below: it's
    // dead weight there (no RT64 to consume g_lle_faithful_z) and it's serial events-thread work that
    // steals overlap headroom from the RSP∥RDP pipeline.
    if (g_pipeline > 0) return;

    // Defensive bounds (the LLE can still produce garbage DPC pointers mid-bringup; a bad [start,end)
    // must never read out of RDRAM and crash the gfx thread). RDRAM is 8 MB; reject implausible ranges.
    const uint32_t RDRAM_SIZE = 0x800000;
    const uint32_t s = start & 0xFFFFFF;
    const uint32_t e = end & 0xFFFFFF;
    if (e <= s || e > RDRAM_SIZE || (e - s) > 0x10000) {
        static int _bad = 0;
        if (++_bad <= 16) {
            fprintf(stderr, "[rdp_decode] SKIP implausible range [0x%08X..0x%08X)\n", start, end);
            fflush(stderr);
        }
        return;
    }
    // ORACLE-RIG CAPTURE (2026-07-11): when armed, append this plausible range un-^3-swizzled
    // (N64 physical byte order per the N64RDPC1 container spec).
    if (g_rdpc_armed) {
        g_rdpc_stream.reserve(g_rdpc_stream.size() + (e - s));
        for (uint32_t a = s; a < e; a++) {
            g_rdpc_stream.push_back(rdram[a ^ 3]);
        }
    }
    auto rd_w = [&](uint32_t a) -> uint32_t {
        a &= (RDRAM_SIZE - 1); // hard-clamp every read into RDRAM
        uint32_t v = 0;
        for (int i = 0; i < 4; i++) {
            v = (v << 8) | rdram[((a + i) & (RDRAM_SIZE - 1)) ^ 3];
        }
        return v;
    };

    uint32_t addr = s;
    uint32_t stop = e;
    int n_tri = 0, n_tri_z = 0, n_other = 0, n_cmd = 0;
    float z_min = 1e30f, z_max = -1e30f;
    uint32_t z0_raw = 0;
    int guard = 0;
    // cont.28 THE DECISIVE MEASUREMENT — global faithful-Z distribution across the WHOLE session.
    // The crux of Option D: does the LLE's faithful screen-Z SEPARATE foreground (near) from the far
    // castle (the depth-collapse Reinhardt proved in the HLE), or is it collapsed too? Track global
    // screen-Z (= z-buffer value / 0x3FFF, range 0..1) min/max + a coarse histogram. WIDE spread (lots
    // of triangles well below 0.9) = separation = the castle fix is real. All bunched at 0.97-1.0 like
    // the HLE = the collapse is inherent, NOT an HLE artifact (rethink before Brick 4).
    static float g_sz_min = 1e30f, g_sz_max = -1e30f;
    static uint64_t g_szbucket[6] = {0,0,0,0,0,0}; // <0.5 | 0.5-0.8 | 0.8-0.9 | 0.9-0.97 | 0.97-0.99 | >=0.99
    while (addr < stop && guard++ < 200000) {
        const uint32_t w0 = rd_w(addr);
        const uint32_t op = (w0 >> 24) & 0x3F;
        uint32_t len = 8;
        n_cmd++;
        if (op >= 0x08 && op <= 0x0F) {
            const bool shade = (op & 0x04) != 0, tex = (op & 0x02) != 0, zbuf = (op & 0x01) != 0;
            const uint32_t z_block_off = 0x20u + (shade ? 0x40u : 0u) + (tex ? 0x40u : 0u);
            len = z_block_off + (zbuf ? 0x10u : 0u);
            n_tri++;
            if (zbuf) {
                n_tri_z++;
                const uint32_t zraw = rd_w(addr + z_block_off);
                const float z = (float)(int32_t)zraw / 65536.0f; // s15.16 -> z-buffer units (0..0x3FFF)
                if (z < z_min) z_min = z;
                if (z > z_max) z_max = z;
                if (n_tri_z == 1) z0_raw = zraw;
                // Global screen-Z distribution (z-buffer units / 0x3FFF -> 0..1).
                const float sz = z / 16383.0f;
                // CV64 Brick 4: record EVERY z-tri's faithful screen-Z in draw order so the Nth LLE
                // z-tri lines up with RT64's Nth depth triangle (unconditional — even outliers — to keep
                // the ordinal alignment exact).
                if (g_lle_faithful_z_count < 131072u) g_lle_faithful_z[g_lle_faithful_z_count++] = sz;
                else g_lle_faithful_z_overflow++;
                if (sz > -1.0f && sz < 2.0f) { // ignore wild outliers from any stray garbage tri (histogram only)
                    if (sz < g_sz_min) g_sz_min = sz;
                    if (sz > g_sz_max) g_sz_max = sz;
                    int b = (sz < 0.5f) ? 0 : (sz < 0.8f) ? 1 : (sz < 0.9f) ? 2
                          : (sz < 0.97f) ? 3 : (sz < 0.99f) ? 4 : 5;
                    g_szbucket[b]++;
                }
            }
        }
        else if (op == 0x24 || op == 0x25) {
            len = 16;
        }
        else {
            n_other++;
        }
        addr += len;
    }

    static int batch = 0;
    static int tri_batches = 0;
    static uint64_t total_tris = 0, total_ztris = 0;
    batch++;
    total_tris += n_tri;
    total_ztris += n_tri_z;
    // Log the first few batches for context AND every triangle-bearing batch (the 3D geometry — what
    // we actually want), plus a periodic running total so we can confirm whether the LLE EVER emits
    // triangles even after the per-batch log cap.
    bool log_it = (batch <= 8) || (n_tri > 0 && tri_batches < 96);
    if (n_tri > 0) tri_batches++;
    if (log_it) {
        fprintf(stderr, "[rdp_decode] #%d [0x%08X..0x%08X) cmds=%d tris=%d ztris=%d other=%d  faithful-Z=[%.4f..%.4f] z0=0x%08X\n",
                batch, start, end, n_cmd, n_tri, n_tri_z, n_other,
                (n_tri_z ? z_min : 0.0f), (n_tri_z ? z_max : 0.0f), z0_raw);
        fflush(stderr);
    }
    if ((batch % 256) == 0) {
        fprintf(stderr, "[rdp_decode] TOTAL batches=%d totalTris=%llu totalZtris=%llu triBatches=%d\n",
                batch, (unsigned long long)total_tris, (unsigned long long)total_ztris, tri_batches);
        // THE CRUX: faithful screen-Z spread. Buckets = how many z-tris fall in each depth band.
        // Wide (big counts <0.9) => LLE separates near/far => castle fix is real. All in [0.97,1.0] =>
        // collapsed like the HLE => the collapse is inherent (don't assume Brick 4 fixes the castle).
        fprintf(stderr, "[rdp_decode] Z-DIST screenZ=[%.4f..%.4f]  <0.5:%llu  0.5-0.8:%llu  0.8-0.9:%llu  0.9-0.97:%llu  0.97-0.99:%llu  >=0.99:%llu\n",
                (g_sz_min < 2.0f ? g_sz_min : 0.0f), (g_sz_max > -1.0f ? g_sz_max : 0.0f),
                (unsigned long long)g_szbucket[0], (unsigned long long)g_szbucket[1],
                (unsigned long long)g_szbucket[2], (unsigned long long)g_szbucket[3],
                (unsigned long long)g_szbucket[4], (unsigned long long)g_szbucket[5]);
        fflush(stderr);
    }
}

// From Ares emulator. For license details, see rsp_vu.h
void recomp::rsp::constants_init() {
    rspReciprocals[0] = u16(~0);
    for (u16 index = 1; index < 512; index++) {
        u64 a = index + 512;
        u64 b = (u64(1) << 34) / a;
        rspReciprocals[index] = u16((b + 1) >> 8);
    }

    for (u16 index = 0; index < 512; index++) {
        u64 a = (index + 512) >> ((index % 2 == 1) ? 1 : 0);
        u64 b = 1 << 17;
        //find the largest b where b < 1.0 / sqrt(a)
        while (a * (b + 1) * (b + 1) < (u64(1) << 44)) b++;
        rspInverseSquareRoots[index] = u16(b >> 1);
    }
}

// ── UCODE CATALOG REGISTRY (2026-07-24, ENGINE_COMPLETION organ 3 — the dispatch mechanism) ────
// Games embed catalog ucodes and switch them PER TASK (census: Mario Party 2 ships five gfx
// ucodes) — so dispatch is by CONTENT HASH, never by game or task type. Registration happens at
// game init (before the task threads start — append-only, unlocked reads afterwards). An empty
// registry costs nothing and changes nothing (legacy get_rsp_microcode path). Misses are the
// organ's unsupported-counter AND the bootstrap: the log line names the exact hash to register.
// verify_len == 0 ⇒ no verify window (key-only member). See rsp.hpp: verify windows are the
// per-member discriminator against key-sharing sibling builds (SERVED_ROSTER witnesses).
static struct UcodeRegEntry {
    uint64_t hash; const char* name; RspUcodeFunc* fn;
    uint32_t verify_off; uint32_t verify_len; uint64_t verify_fnv;
} s_ucode_reg[64];
static int s_ucode_reg_n = 0;

// HASH LAW v1: FNV-1a64 over ucode TEXT [0,0x80) then UCODE_DATA [0,0x100), N64 byte order.
// Sizes are fixed BY LAW: OSTask size fields lie (SK1 reports ucode_size=0), and hashing deeper
// text risks spilling past short ucodes into volatile RAM (the RECOMP_UCODE_PROBE lesson above —
// its 0x80 text prefix is proven stable). data[0,0x100) adds the header + GBI dispatch table =
// the revision fingerprint. AUDIT GATE before fleet-wide reliance: extend ucode_census.py to
// compute this law over all 377 ROMs and prove the 93 revisions collide nowhere.
uint64_t recomp::rsp::hash_task_ucode(uint8_t* rdram, const OSTask* task) {
    uint64_t h = 1469598103934665603ull;
    const uint32_t tphys = (uint32_t)task->t.ucode & 0x00FFFFFFu;
    const uint32_t dphys = (uint32_t)task->t.ucode_data & 0x00FFFFFFu;
    for (uint32_t i = 0; i < 0x80 && (tphys + i) < 0x800000u; i++) {
        h ^= (uint8_t)rdram[(tphys + i) ^ 3]; h *= 1099511628211ull;
    }
    for (uint32_t i = 0; i < 0x100 && (dphys + i) < 0x800000u; i++) {
        h ^= (uint8_t)rdram[(dphys + i) ^ 3]; h *= 1099511628211ull;
    }
    return h;
}

void recomp::rsp::register_ucode(uint64_t hash, const char* name, RspUcodeFunc* fn,
                                 uint32_t verify_off, uint32_t verify_len, uint64_t verify_fnv) {
    if (s_ucode_reg_n >= (int)(sizeof(s_ucode_reg) / sizeof(s_ucode_reg[0]))) {
        fprintf(stderr, "[ucode-reg] registry FULL, dropping %s\n", name ? name : "?");
        return;
    }
    s_ucode_reg[s_ucode_reg_n++] = { hash, name ? name : "?", fn, verify_off, verify_len, verify_fnv };
    fprintf(stderr, "[ucode-reg] #%d %s hash=%016llX%s\n", s_ucode_reg_n,
            name ? name : "?", (unsigned long long)hash, verify_len ? " +verify" : "");
}

void recomp::rsp::register_ucode(uint64_t hash, const char* name, RspUcodeFunc* fn) {
    register_ucode(hash, name, fn, 0, 0, 0);
}

RspUcodeFunc* recomp::rsp::dispatch_ucode(uint8_t* rdram, const OSTask* task) {
    // No empty-registry early-out ON PURPOSE: the once-per-hash MISS counter is the organ's
    // standing census feed AND the registration bootstrap — it must name ucodes even before
    // any are registered. The hash is ~0x180 bytes of FNV per task: noise, even on a small core.
    const uint64_t h = hash_task_ucode(rdram, task);
    for (int i = 0; i < s_ucode_reg_n; i++) {
        if (s_ucode_reg[i].hash == h) {
            // PER-MEMBER VERIFY (see rsp.hpp): key windows are small by the volatile-RAM law, so
            // sibling builds can share a key. Hash the member's discriminator window over the
            // task's actual text bytes; mismatch ⇒ this is a KEY-SHARING SIBLING, not the member
            // — fall through as a MISS (legacy path). Never mis-dispatch on a shared key.
            if (s_ucode_reg[i].verify_len != 0) {
                uint64_t v = 1469598103934665603ull;
                const uint32_t tphys = (uint32_t)task->t.ucode & 0x00FFFFFFu;
                const uint32_t off = s_ucode_reg[i].verify_off;
                for (uint32_t k = 0; k < s_ucode_reg[i].verify_len && (tphys + off + k) < 0x800000u; k++) {
                    v ^= (uint8_t)rdram[(tphys + off + k) ^ 3]; v *= 1099511628211ull;
                }
                if (v != s_ucode_reg[i].verify_fnv) {
                    static uint64_t vmiss_logged[64]; static int vmiss_n = 0;
                    bool vseen = false;
                    for (int k = 0; k < vmiss_n; k++) if (vmiss_logged[k] == v) { vseen = true; break; }
                    if (!vseen) {
                        if (vmiss_n < 64) vmiss_logged[vmiss_n++] = v;
                        fprintf(stderr, "[ucode-verify-MISS] key=%016llX matches %s but verify window "
                                "[0x%X,+0x%X) got %016llX (sibling build — legacy fallback)\n",
                                (unsigned long long)h, s_ucode_reg[i].name,
                                s_ucode_reg[i].verify_off, s_ucode_reg[i].verify_len,
                                (unsigned long long)v);
                        fflush(stderr);
                    }
                    continue; // keep scanning — a sibling member may share this key with its
                              // own verify window; otherwise the MISS path below names the key
                }
            }
            static uint64_t hit_logged[64]; static int hit_n = 0;   // one HIT line per distinct hash
            bool seen = false;
            for (int k = 0; k < hit_n; k++) if (hit_logged[k] == h) { seen = true; break; }
            if (!seen) {
                if (hit_n < 64) hit_logged[hit_n++] = h;
                fprintf(stderr, "[ucode-dispatch] HIT %s hash=%016llX (task type=%u)\n",
                        s_ucode_reg[i].name, (unsigned long long)h, (unsigned)task->t.type);
                fflush(stderr);
            }
            return s_ucode_reg[i].fn;
        }
    }
    // MISS — the organ's unsupported-counter. One line per distinct hash; the line IS the
    // registration bootstrap (paste the hash into register_ucode once the family is judged).
    static uint64_t miss_logged[64]; static int miss_n = 0;
    bool seen = false;
    for (int k = 0; k < miss_n; k++) if (miss_logged[k] == h) { seen = true; break; }
    if (!seen) {
        if (miss_n < 64) miss_logged[miss_n++] = h;
        fprintf(stderr, "[ucode-miss] hash=%016llX task type=%u ucode=0x%08X data=0x%08X (not in catalog registry)\n",
                (unsigned long long)h, (unsigned)task->t.type,
                (unsigned)(uint32_t)task->t.ucode, (unsigned)(uint32_t)task->t.ucode_data);
        fflush(stderr);
    }
    return nullptr;
}

// Runs a recompiled RSP microcode
bool recomp::rsp::run_task(uint8_t* rdram, const OSTask* task) {
    assert(rsp_callbacks.get_rsp_microcode != nullptr);
    // Organ path first: content-keyed catalog dispatch (nullptr when the registry is empty or
    // the hash is unknown — then the legacy per-game glue decides, unchanged).
    RspUcodeFunc* ucode_func = dispatch_ucode(rdram, task);
    if (ucode_func == nullptr) ucode_func = rsp_callbacks.get_rsp_microcode(task);

    // --- ucode discovery probe (env RECOMP_UCODE_PROBE=1) -------------------------------------
    // Fingerprint every dispatched RSP microcode to map the library's DISTINCT ucodes: one ucode
    // recompiled covers every game whose bytes hash the same (Track A clustering). A game that never
    // reaches here for an audio task is the raw-AI / MMIO-audio class (Track B). Logging-only +
    // env-gated => behaviour-neutral when unset; pure runtime change (no recompiler impact).
    {
        static const char* probe_path = [] () -> const char* {
            const char* e = std::getenv("RECOMP_UCODE_PROBE");
            if (!(e && e[0] == '1')) return nullptr;
            const char* p = std::getenv("RECOMP_UCODE_LOG");
            return p ? p : "ucode_probe.log";   // default: a file in the exe's cwd (GUI exe has no stderr)
        }();
        if (probe_path) {
            static std::mutex probe_mtx;
            static std::set<uint64_t> seen;
            uint32_t uphys = (uint32_t)task->t.ucode & 0x00FFFFFFu;
            const uint32_t HASHLEN = 0x80u;                                  // static ucode-ENTRY prefix only
            uint64_t h = 1469598103934665603ull;                             // (the tail spills into the per-frame
            uint8_t  head[16] = {0};                                         //  audio command buffer => unstable)
            for (uint32_t i = 0; i < HASHLEN && (uphys + i) < 0x800000u; i++) {
                uint8_t b = (uint8_t)rdram[(uphys + i) ^ 3];                  // ^3 = N64 byte order
                h ^= b; h *= 1099511628211ull;                               // FNV-1a over the ucode entry
                if (i < 16) head[i] = b;
            }
            uint64_t key = ((uint64_t)task->t.type << 56) ^ h;
            std::lock_guard<std::mutex> lk(probe_mtx);
            if (seen.insert(key).second) {
                if (FILE* f = fopen(probe_path, "a")) {                              // file sink: GUI exe has no stderr
                    fprintf(f, "[ucode] type=%u ucode=0x%08X hash=%016llX head=",
                            (unsigned)task->t.type, (unsigned)(uint32_t)task->t.ucode,
                            (unsigned long long)h);
                    for (int i = 0; i < 16; i++) fprintf(f, "%02X", head[i]);
                    fprintf(f, "\n");
                    fclose(f);
                }
            }
        }
    }

    if (ucode_func == nullptr) {
        // Capped: with the task thread degrading failures instead of exiting (events.cpp), an
        // unregistered ucode repeats every task — don't let it flood the log.
        static int null_ucode_logs = 0;
        if (null_ucode_logs < 3) {
            null_ucode_logs++;
            fprintf(stderr, "No registered RSP ucode for %" PRIu32 " (returned `nullptr`)\n", task->t.type);
        }
        return false;
    }

    // One-time aspMain TEXT dump (env RECOMP_UCODE_DUMP=<path>) — verifies whether this game's audio
    // ucode bytes are byte-identical to the shared CV64/SM64 aspMain, and provides the real bytes for
    // RSPRecomp if they differ. Dumps in ROM (big-endian) byte order. Baseline-safe (no-op when unset).
    if (task->t.type == 2 /* M_AUDTASK */) {
        static bool ucode_dumped = false;
        const char* dump_path = std::getenv("RECOMP_UCODE_DUMP");
        if (dump_path && !ucode_dumped) {
            ucode_dumped = true;
            uint32_t uphys = (uint32_t)task->t.ucode & 0x00FFFFFFu;
            const uint32_t DUMP_LEN = 0x2000u;
            if (FILE* f = fopen(dump_path, "wb")) {
                for (uint32_t i = 0; i < DUMP_LEN && (uphys + i) < 0x800000u; i++)
                    fputc(rdram[(uphys + i) ^ 3], f);   // ^3 = N64 big-endian byte order
                fclose(f);
                fprintf(stderr, "[ucode_dump] wrote 0x%X bytes of aspMain text from ucode=0x%08X -> %s\n",
                        DUMP_LEN, (unsigned)task->t.ucode, dump_path);
                fflush(stderr);
            }
        }
    }

    // CV64 Brick 3: serialize dmem[] against the gfx-ucode LLE capture (runs on the gfx thread).
    std::lock_guard<std::mutex> dmem_lock(g_rsp_dmem_mutex);

    // Load the OSTask into DMEM
    memcpy(&dmem[0xFC0], task, sizeof(OSTask));

    // Load the ucode data into DMEM.
    // cv64 (session 15, Alucard): was a hardcoded 0xF80, which OVER-READS the audio task's
    // ucode_data (ucode_data_size=0x800) by ~0x780 bytes — pulling whatever RDRAM follows the
    // audio data buffer into DMEM[0x800..0xF7F]. Real hardware loads exactly ucode_data_size.
    // Honor it (clamped to DMEM minus the OSTask area at 0xFC0; fall back to 0xF80 if unset).
    uint32_t ud_size = task->t.ucode_data_size;
    if (ud_size == 0 || ud_size > 0xF80) ud_size = 0xF80;
    dma_rdram_to_dmem(rdram, 0x0000, task->t.ucode_data, ud_size - 1);

    // ASP ORACLE CAPTURE (2026-07-12, the sustain hunt): RECOMP_ASP_DUMP=<dir> + touch
    // <dir>/DUMP_NOW. v1: captures ONE task as N64ASPC1 (OSTask + pre-RDRAM). v2 (chain/race
    // mode, RECOMP_ASP_CHAIN=<N>): one touch captures the next N consecutive audio tasks as
    // N64ASPC2 (OSTask + pre-RDRAM + POST-RDRAM). Replaying pre must reproduce post
    // bit-exactly; any mismatch = the game mutated task inputs MID-RUN (the race), at the
    // exact addresses reported. Bit-exact everywhere = inputs were wrong BEFORE the task
    // (game-side audio driver state) — each verdict eliminates a layer.
    bool asp_dump_this = false;
    char asp_path[512];
    if (task->t.type == 2) {
        static const char* asp_dir = getenv("RECOMP_ASP_DUMP");
        static const int asp_chain = [] {
            const char* c = getenv("RECOMP_ASP_CHAIN");
            int v = c ? atoi(c) : 0;
            return (v > 0 && v <= 64) ? v : 0;
        }();
        static int chain_left = 0;
        static uint32_t asp_n = 0;
        if (asp_dir != nullptr) {
            char marker[512];
            snprintf(marker, sizeof(marker), "%s/DUMP_NOW", asp_dir);
            if (FILE* mf = fopen(marker, "rb")) {
                fclose(mf);
                remove(marker);
                chain_left = asp_chain > 0 ? asp_chain : 1;
            }
            if (chain_left > 0) {
                chain_left--;
                asp_dump_this = true;
                snprintf(asp_path, sizeof(asp_path), "%s/asp_task_%u.aspc", asp_dir, asp_n++);
                if (FILE* f = fopen(asp_path, "wb")) {
                    fwrite(asp_chain > 0 ? "N64ASPC2" : "N64ASPC1", 1, 8, f);
                    fwrite(task, sizeof(OSTask), 1, f);
                    uint32_t sz = 0x800000;
                    fwrite(&sz, 4, 1, f);
                    uint8_t chunk[4096];
                    for (uint32_t base = 0; base < 0x800000; base += 4096) {
                        for (uint32_t i = 0; i < 4096; i++) chunk[i] = rdram[(base + i) ^ 3];
                        fwrite(chunk, 1, sizeof(chunk), f);
                    }
                    fclose(f);
                    fprintf(stderr, "[aspdump] pre-task -> %s (data=0x%08X)%s\n",
                            asp_path, (uint32_t)task->t.data_ptr,
                            asp_chain > 0 ? " [chain: post follows]" : "");
                    fflush(stderr);
                }
                if (asp_chain == 0) asp_dump_this = false;   // v1: pre only
            }
        }
    }

    // ===== Phase A: librecomp_rsp_audio_compat diagnostic probe (cv64 session 14) =====
    // Dumps OSTask fields + key DMEM windows for audio tasks. Answers the question:
    // "is the first command chunk pre-staged into DMEM[0x380] via ucode_data, or not?"
    // Reusable across any custom-RSP-ucode game (CV64, F-Zero X, MusyX, Rare, ...).
    // Gated to first 3 audio tasks to avoid log explosion.
    {
        static int probe_count = 0;
        if (task->t.type == 2 /* M_AUDTASK */ && probe_count < 3) {
            probe_count++;
            fprintf(stderr,
                "[rsp_audio_probe] #%d OSTask:\n"
                "  type=%u flags=0x%08X\n"
                "  ucode      =0x%08X size=0x%X\n"
                "  ucode_data =0x%08X size=0x%X\n"
                "  data_ptr   =0x%08X size=0x%X\n"
                "  dram_stack =0x%08X size=0x%X\n"
                "  output_buff=0x%08X size=0x%X\n",
                probe_count,
                (unsigned)task->t.type, (unsigned)task->t.flags,
                (unsigned)task->t.ucode,        (unsigned)task->t.ucode_size,
                (unsigned)task->t.ucode_data,   (unsigned)task->t.ucode_data_size,
                (unsigned)task->t.data_ptr,     (unsigned)task->t.data_size,
                (unsigned)task->t.dram_stack,   (unsigned)task->t.dram_stack_size,
                (unsigned)task->t.output_buff,  (unsigned)task->t.output_buff_size);

            auto dump_dmem = [&](const char* label, uint32_t off, int n) {
                fprintf(stderr, "  DMEM[0x%03X..]:%s", off, label);
                for (int i = 0; i < n; i++) fprintf(stderr, " %02X", dmem[off + i]);
                fprintf(stderr, "\n");
            };
            dump_dmem(" jump-table     ", 0x010, 32);
            dump_dmem(" boot-chunk?    ", 0x380, 32);
            // DK64 audio-command dispatch (aspMain.cpp:154) reads handler offsets from the table at
            // DMEM[0], indexed by (cmd>>23)&0xFE. Dump the full 0x100-byte table and print the
            // normalized jump targets ((v|0x1000)&0x1FFF) so the RSPRecomp config can register them all.
            {
                fprintf(stderr, "  [jtbl] DMEM[0x000..0x100] normalized targets:");
                for (int e = 0; e < 0x100; e += 2) {
                    uint16_t v = (uint16_t)((dmem[e + 1] << 8) | dmem[e]);   // dmem[] stores halfwords byte-swapped
                    uint16_t norm = (uint16_t)((v | 0x1000) & 0x1FFF);
                    if (norm >= 0x1080 && norm < 0x1F00) fprintf(stderr, " 0x%04X", norm);
                }
                fprintf(stderr, "\n");
            }

            // First bytes of the actual command list in RDRAM (where data_ptr points).
            // Goes through the same RDRAM->host mask the runtime uses so endianness is right.
            fprintf(stderr, "  RDRAM[data_ptr]: ");
            uint32_t base = task->t.data_ptr & 0x00FFFFFF;
            for (int i = 0; i < 32; i++) {
                fprintf(stderr, " %02X", rdram[(base + i) ^ 3]); // ^3 for big-endian byte swap
            }
            fprintf(stderr, "\n  RDRAM[data_ptr+0x140]: ");
            for (int i = 0; i < 32; i++) {
                fprintf(stderr, " %02X", rdram[(base + 0x140 + i) ^ 3]);
            }
            fprintf(stderr, "\n");

            // cv64 (session 18, Reinhardt): SETVOL scanner. Walks the entire raw cmd list
            // in RDRAM, dumps every op-9 (A_SETVOL) command byte-for-byte. The session-17
            // [env] probe established that the dry-left/right voice vol arriving at the RSP
            // is 0x0001 (collapsing the envelope ramp). This scanner answers: did the CPU
            // genuinely write 0x0001 to RDRAM, or did our staging path (B-shim / dma_rdram_to_dmem)
            // mangle a different value into 0x0001 between RDRAM and the dispatcher seeing it?
            // Each cmd is 8 bytes; SETVOL starts with byte 0x09. Cap output at 24 SETVOLs
            // (about 5 voices' worth at 5 SETVOLs each).
            {
                fprintf(stderr, "  RDRAM setvol scan (data_size=0x%X):\n",
                        (unsigned)task->t.data_size);
                int setvol_count = 0;
                uint32_t scan_end = (task->t.data_size < 0x800) ? task->t.data_size : 0x800;
                for (uint32_t off = 0; off + 8 <= scan_end && setvol_count < 24; off += 8) {
                    uint8_t op = rdram[(base + off) ^ 3];
                    if (op == 0x09) {
                        uint8_t b[8];
                        for (int k = 0; k < 8; k++) b[k] = rdram[(base + off + k) ^ 3];
                        // Per aSetVolume macro: w0 = op|flags<<16|v, w1 = t<<16|r
                        // For dry vol cmds (flags A_VOL|A_LEFT=0x06 or A_VOL|A_RIGHT=0x04),
                        // the volume value is in w0 bits 0..15 = bytes 2..3.
                        uint16_t flags = b[1];
                        uint16_t vw0 = (uint16_t)((b[2] << 8) | b[3]);
                        uint16_t vw1_hi = (uint16_t)((b[4] << 8) | b[5]);
                        uint16_t vw1_lo = (uint16_t)((b[6] << 8) | b[7]);
                        fprintf(stderr,
                                "    @0x%04X: %02X %02X %02X %02X | %02X %02X %02X %02X  "
                                "flags=0x%02X w0lo=0x%04X w1=(0x%04X,0x%04X)\n",
                                (unsigned)off,
                                b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7],
                                (unsigned)flags, (unsigned)vw0,
                                (unsigned)vw1_hi, (unsigned)vw1_lo);
                        setvol_count++;
                    }
                }
                if (setvol_count == 0) {
                    fprintf(stderr, "    (no SETVOL ops found in first 0x%X bytes)\n",
                            (unsigned)scan_end);
                }
            }
            fflush(stderr);
        }
    }
    // ===== end Phase A probe =====

    // ===== Phase B-shim: pre-stage first command chunk into DMEM[0x380] =====
    // KCEK aspMain (and likely stock Nintendo aspMain too) assumes the first 0x140 bytes
    // of the audio command list are already at DMEM[0x380] when the dispatcher fires.
    // The boot path has no visible route to L_10D4 (the in-ucode chunk loader) on iter 1.
    // Phase A confirmed: ucode_data does NOT contain a chunk at offset 0x380; data_ptr
    // holds the real commands. So pre-stage chunk #1 ourselves before launching the RSP.
    // This is the "first-chunk shim" — a clean runtime intervention that doesn't touch
    // generated code, and will become a UcodeContract entry in Phase C.
    if (task->t.type == 2 /* M_AUDTASK */ && task->t.data_ptr != 0 && task->t.data_size >= 0x140) {
        dma_rdram_to_dmem(rdram, 0x380, task->t.data_ptr, 0x140 - 1);
        static int shim_count = 0;
        if (++shim_count <= 3) {
            fprintf(stderr, "[rsp_audio_shim] #%d pre-staged 0x140 bytes from data_ptr=0x%08X into DMEM[0x380]\n",
                    shim_count, (unsigned)task->t.data_ptr);
            fflush(stderr);
        }
    }
    // ===== end Phase B-shim =====

    // ===== Phase B-persist: REMOVED (cv64 session 15, Alucard) =====
    // This hack restored a DMEM snapshot from the previous audio task over DMEM[0x300..0x37F]
    // and [0x4C0..0xFBF] each task, on the false premise that "DMEM persists across osSpTask
    // calls." It does NOT — real hardware reloads ucode_data into DMEM[0x000..0xF7F] every task
    // (exactly what our line 49 dma_rdram_to_dmem does). So B-persist wasn't emulating hardware;
    // it was clobbering the fresh, CPU-staged audio command scratch at 0x360 with a stale value
    // (0x80342318) snapshotted from a prior task — identical every task, poisoning the synthesis
    // handler's inputs. Removing it lets the correct fresh ucode_data scratch through, like HW.

    // Run the ucode
    RspExitReason exit_reason = ucode_func(rdram, task->t.ucode);

    // ASP chain capture (v2): append the POST-task RDRAM to this task's container. The
    // offline replay of the pre-snapshot must reproduce this post-state bit-exactly.
    if (asp_dump_this) {
        if (FILE* f = fopen(asp_path, "ab")) {
            uint8_t chunk[4096];
            for (uint32_t base = 0; base < 0x800000; base += 4096) {
                for (uint32_t i = 0; i < 4096; i++) chunk[i] = rdram[(base + i) ^ 3];
                fwrite(chunk, 1, sizeof(chunk), f);
            }
            fclose(f);
            fprintf(stderr, "[aspdump] post-task appended (exit=%d)\n", (int)exit_reason);
            fflush(stderr);
        }
    }

    // Ensure that the ucode exited correctly. A non-Broke exit (UnhandledJumpTarget on a VARIANT
    // microcode, watchdog bail, ...) reports FAILED to the task thread, which completes the task
    // as a no-op instead of killing the process (events.cpp). No assert — the degrade must hold
    // in every build config — and capped logging, since a variant ucode fails EVERY task.
    if (exit_reason != RspExitReason::Broke) {
        static int bad_exit_logs = 0;
        if (bad_exit_logs < 3) {
            bad_exit_logs++;
            fprintf(stderr, "RSP ucode %" PRIu32 " exited unexpectedly. exit_reason: %i\n", task->t.type, static_cast<int>(exit_reason));
        }
        return false;
    }

    return true;
}
