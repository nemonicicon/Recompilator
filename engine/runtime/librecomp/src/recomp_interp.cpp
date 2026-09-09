// recomp_interp.cpp — General MIPS (R4300i) interpreter fallback for N64Recomp.
//
// THE PROBLEM (general to every N64Recomp port): some overlays contain executable
// code that the static recompiler never turned into C functions — e.g. overlays the
// decomp classified as pure `.data` (bin), or any code reached only through an
// indirect pointer the recompiler couldn't see. When the recompiled game does
// `LOOKUP_FUNC(addr)` into such code, `get_function` has nothing to return and the
// game crashes ("no recompiled function at N64 vaddr ...").
//
// THE FIX (works for ANY game): instead of crashing, interpret the MIPS code directly
// from RDRAM. The original instructions are present at the overlay's mapped vaddr (the
// game DMAs/decompresses them there), so we fetch + decode + execute them, operating on
// the SAME recomp_context registers and the SAME `rdram` memory the recompiled code uses
// (via CV64_PHYS / the LLE TLB). Calls out to RECOMPILED engine functions are dispatched
// natively (so hand-fixed recompiled functions keep their behaviour); calls to other
// un-recompiled code recurse back into the interpreter.
//
// This is intentionally faithful to N64Recomp's own semantics: it reuses recomp.h's
// helpers (ADD32, SIGNED, MEM_*, do_lwl, DMULT, ...) so an interpreted instruction
// behaves bit-identically to how the recompiler would have emitted it.

#include "recomp.h"
#include <atomic>
#include <cstdio>
#include <cstdlib>   // getenv/strtoull: RECOMP_INTERP_BUDGET
#include <cstdint>
#include <cstring>
#include <cmath>

// Forward declaration: this file carries a LATE #include (live_recompiler.h, ~line 1559) so the
// helper's definition lands below the instrument print sites it guards. Declared here, defined there.
static bool rc_trace_on(const char* var);

// Native function lookup that does NOT fall back to the interpreter or error — returns
// nullptr on miss. Defined in overlays.cpp. Used to decide native-call vs interpret.
extern "C" recomp_func_t* recomp_lookup_native(uint32_t addr);

// Forward decl: the interpreter entry (recurses for un-recompiled sub-calls).
extern "C" void recomp_interpret(uint8_t* rdram, recomp_context* ctx, uint32_t start_vaddr);

// Bare-metal cooperative-scheduler hook (baremetal_sched.cpp): when an interpreted NC handler reaches the
// scheduler's eret, route it to the fiber switch instead of continuing the interpreter at EPC (which would
// resume the task as throwaway-ctx interpretation rather than its real fiber).
extern "C" int  recomp_baremetal_enabled();
extern "C" void recomp_eret(uint8_t* rdram, recomp_context* ctx);

// COP0 / TLB backing — the SAME state the recompiler's emitted code uses (tlb.cpp / recomp.cpp),
// so an interpreted mtc0/mfc0/tlbwi behaves bit-identically to a recompiled one. Without this the
// interpreter silently dropped every COP0 op (logged "UNIMPL COP0"), so any game whose interpreted
// (un-recompiled / decompressed-overlay) code sets up Status/TLB never got its CPU state configured —
// the raw-hardware-port boot-to-black class (e.g. Extreme-G's interpreted TLB/exception init).
extern "C" void     recomp_cop0_tlb_write(int reg, uint32_t value);
extern "C" uint32_t recomp_cop0_tlb_read(int reg);
// Is vaddr covered by a VALID TLB entry? (tlb.cpp) — used by the jr/jalr guard to accept
// legitimately TLB-mapped code. NOT recomp_tlb_translate, which flat-maps misses.
extern "C" int      recomp_tlb_is_mapped(uint32_t vaddr, uint32_t* phys_out);
extern "C" void     recomp_baremetal_interp_poll(uint32_t pc);
extern "C" volatile int recomp_bm_edge_deferred;   // [edge-retake 2026-09-03] set by baremetal_sched.cpp when a mask/SR edge is deferred inside a native callee
extern "C" void     recomp_tlbwi(void);
extern "C" void     recomp_tlbwr(void);
extern "C" void     recomp_tlbp(void);
extern "C" void     recomp_tlbr(void);
extern "C" void     cop0_status_write(recomp_context* ctx, gpr value);
extern "C" gpr      cop0_status_read(recomp_context* ctx);

// Forward decl (defined at file scope below): does this vaddr hold something that looks like a
// MIPS instruction? Used by eret to reject a derailed resume PC (null / data) before jumping.
static bool looks_like_code(uint8_t* rdram, uint32_t addr);
// [guest-clock probe 2026-08-27, MEASUREMENT ONLY] Interpreted instructions retired, process-wide.
// The engine has no guest-progress clock at all (GUEST_CLOCK_PLAN.md): Count, osGetTime and the RCP
// completion floors all read the HOST wall clock, so "cycles elapsed" and "instructions retired" —
// the same quantity on silicon — are unrelated here. This counter is the interpreted half, added to
// test the model before any recompiler work: it lets us ask how many guest instructions actually
// elapse between a gfx submit and the game arming its wait, versus the ~58,000 CPU cycles hardware
// would have granted during that RDP job. One relaxed add per interpreted instruction.
std::atomic<uint64_t> g_guest_instr{0};        // published snapshot (cross-thread readable)
std::atomic<uint64_t> g_guest_sessions{0};     // recomp_interpret() entries — session churn
thread_local uint64_t tl_guest_instr = 0;      // hot-path counter: plain add, no lock
extern "C" uint64_t recomp_guest_instr(void) { return g_guest_instr.load(std::memory_order_relaxed); }
// [fn-trace] guest function-entry tracer (recomp.cpp) — the interpreted venues call in from here.
extern "C" int  recomp_fn_trace_active(void);
extern "C" void recomp_fn_trace_hit(uint8_t* rdram, const recomp_context* ctx, uint32_t vaddr, uint32_t ra, const char* venue);
extern "C" void recomp_fn_trace_expect_mark(uint32_t vaddr);
extern "C" uint64_t recomp_guest_sessions(void) { return g_guest_sessions.load(std::memory_order_relaxed); }


namespace {

// [IE-rising edge 08-27] Set by an interpreted MTC0 that re-enables interrupts; consumed at the
// interpreter loop top, which is the next clean instruction boundary — hardware takes a pending
// interrupt there. See the MTC0 case for the aliasing failure this repairs.
thread_local bool g_ie_rise = false;

// PER TOP-LEVEL CALL WATCHDOG. 50M is a runaway guard, and it is the right default: an interpreted
// call that never returns is normally a derailed PC. But a cart whose GAMEPLAY MAIN LOOP lives in an
// undeclared overlay enters the interpreter once and legitimately never comes back, so the watchdog
// fires mid-frame and strands the guest (Saikyou Habu Shougi 2026-09-08: froze at exactly
// ginstr=50000000, its loop at 0x802B9700 reached through the raw-KSEG0 overlay net). Raising this
// is a DIAGNOSTIC, not a fix - the overlay wants declaring so it is recompiled natively - but it
// separates "interpretation is wrong" from "interpretation ran out of rope".
static const uint64_t kInstrBudget = [] {
    if (const char* e = std::getenv("RECOMP_INTERP_BUDGET")) {
        const unsigned long long v = strtoull(e, nullptr, 0);
        if (v != 0ull) {
            fprintf(stderr, "[interp] budget overridden to %llu instructions (RECOMP_INTERP_BUDGET)\n", v);
            fflush(stderr);
            return (uint64_t)v;
        }
    }
    return 50000000ull;
}();
// Recursion guard for nested interp calls. 64 was a runaway guard, but a guest with a
// continuation/bytecode-styled engine (SOTE's B1 stream backend) nests interp→native→gap-interp
// legitimately past it — at the cap every interp call silently no-ops, which starves whatever
// guest subsystem needed it (observed: stream ring overflow → guest assert; dispatcher k0 tear;
// a permanently-bailing VI service). True runaways are already bounded by kInstrBudget; the cap
// only protects the host stack, so it can be generous.
constexpr int      kMaxDepth     = 512;
thread_local int   g_interp_depth = 0;

// Start vaddr of the interpreted function currently executing (set by recomp_interpret on entry).
// Used only for the indirect-jump SAFETY GUARD log line, so a corrupt jr/jalr names its owning func.
thread_local uint32_t g_interp_start_vaddr = 0;

// THE SESSION'S RETURN SENTINEL (2026-08-28, KI Gold). A dispatch-gap entry from NATIVE code has
// no guest caller to return to, so recomp_interpret enters with ctx->r31 == 0 and ends the session
// on `pc == entry_ra` (see the loop-top check and "jr to entry_ra -> loop-top break next iter").
// But 0 is not a plausible code address, so the indirect-jump SAFETY GUARD in exec_one fired on the
// function's own epilogue `jr $ra` and aborted the session as a derail — killing the guest one
// instruction before it returned, AND skipping the jr's DELAY SLOT (usually the `addiu sp,sp,N`
// stack restore), so the caller resumed on a corrupted frame.
// Measured on KI Gold: the boot function at 0x80000450 (a dispatch gap inside section[0]) ran to
// completion, created its threads, then `jr $ra` at 0x800004A4 -> "CORRUPT JR target -> 0x00000000
// (rs=31)". Publishing the sentinel here lets the guard exempt exactly that one address.
// 0xFFFFFFFF = "no session" and is misaligned, so it can never match the aligned-target test.
thread_local uint32_t g_interp_entry_ra = 0xFFFFFFFFu;

// Diagnostic counters (light, capped) so we can see coverage without flooding the log.
thread_local uint64_t g_unimpl_count = 0;

// COP1 condition bit (FCR31 bit 23). The recompiler keeps this as a per-function
// local (c1cs); a thread-local matches that scoping for interpreted code, since the
// condition never legitimately crosses a call boundary on one thread.
// 2026-08-28: the ctx->c1cs unification (shared with cgenerator) measured WORSE on KI Gold and
// is reverted pending a clean A/B. The tier split it describes is REAL — see recomp.h's c1cs field.
thread_local bool g_c1cs = false;

// ── [icache-ghost] VR4300 I-CACHE INCOHERENCY MODEL (SOTE, 2026-08-26) ──────────────────────────
// The packed-title phase transition rewrites the kernel's RAM underneath threads still executing
// it. On hardware this is survivable for exactly one reason: the 16KB instruction cache — the old
// kernel's hot loops (idle check, osRecvMesg, the handler) keep executing AS A GHOST from cache
// while the wave rewrites RAM beneath them, because the game never invalidates. This engine had no
// I-cache, so interpreted fetches read through to rewritten RAM instantly — every parked thread's
// continuation zombied the moment the wave passed it (measured: the VI manager, dispatched
// perfectly by the frame-tick lane, executed garbage at its osRecvMesg resume pc and died).
// Model the ghost: at wave detection the kernel range is snapshotted, and INSTRUCTION FETCH is
// served from the snapshot while data reads/writes stay live — I-cache semantics, nothing more.
// Armed once per run via recomp_icache_ghost_arm (env-gated at the caller); zero cost unarmed.
static uint8_t* g_icache_ghost = nullptr;
static uint32_t g_icache_ghost_lo = 0, g_icache_ghost_hi = 0;
// [icache-ghost validity 2026-09-03] HARDWARE MODEL: a line serves stale bytes only if it was FETCHED before the
// rewrite and not invalidated since. One byte per 32-byte line over the fixed arm window; fetches are recorded
// from boot (so the arm knows which lines the CPU already held), an invalid line fills from live RDRAM on its
// first fetch, a CACHE op clears the line (Index_Invalidate_I clears them all). Before this the whole 1.6 MB
// window was 'cached' forever: 1080 relocated an overlay in place after the arm and executed the ROM's unlinked
// copy from the snapshot (a wild arena fill over its TCBs).
static const uint32_t GHOST_WIN_LO = 0x80000400u, GHOST_WIN_HI = 0x801A0000u;
static const uint32_t GHOST_LINES  = (GHOST_WIN_HI - GHOST_WIN_LO) >> 5;
static uint8_t* g_icache_ghost_valid = nullptr;   // 1 = line held in the modelled I-cache (serves the ghost bytes)
static uint8_t* ghost_fetched_map() {
    static uint8_t* m = (uint8_t*)calloc(GHOST_LINES, 1);
    return m;
}
static inline void ghost_invalidate_line(uint32_t vaddr) {
    if (g_icache_ghost_valid == nullptr || vaddr < g_icache_ghost_lo || vaddr >= g_icache_ghost_hi) return;
    g_icache_ghost_valid[(vaddr - g_icache_ghost_lo) >> 5] = 0;
}
static inline void ghost_invalidate_all() {
    if (g_icache_ghost_valid != nullptr) memset(g_icache_ghost_valid, 0, GHOST_LINES);
}
extern "C" void recomp_icache_ghost_arm(uint8_t* rdram, uint32_t lo, uint32_t hi) {
    if (g_icache_ghost != nullptr || hi <= lo) return;
    const uint32_t len = hi - lo;
    uint8_t* buf = (uint8_t*)malloc(len);
    if (buf == nullptr) return;
    memcpy(buf, rdram + (uint32_t)(lo - 0x80000000u), len);
    g_icache_ghost_lo = lo;
    g_icache_ghost_hi = hi;
    g_icache_ghost_valid = ghost_fetched_map();   // lines the CPU fetched before the arm are the ones it holds
    g_icache_ghost = buf;   // publish last
    uint32_t _held = 0; for (uint32_t i = 0; i < GHOST_LINES; i++) _held += g_icache_ghost_valid[i];
    if (rc_trace_on("RECOMP_ICACHE_GHOST")) fprintf(stderr, "[icache-ghost] armed: %u KB, instruction fetch in 0x%08X..0x%08X served from the pre-wave image for the %u lines fetched so far; other lines fill live on first fetch\n",
            len >> 10, lo, hi, _held);
    fflush(stderr);
}
extern "C" int recomp_icache_ghost_covers(uint32_t vaddr) {
    return (g_icache_ghost != nullptr && vaddr >= g_icache_ghost_lo && vaddr < g_icache_ghost_hi) ? 1 : 0;
}
extern "C" void recomp_icache_ghost_sync_all(uint8_t* rdram) {
    // [wave-settle] models the loader's mandatory post-wave cache invalidate (its native twin's
    // CACHE ops were dropped by the recompiler, so the interpreter never sees them): ghost := live
    // for the whole window. From here instruction fetch serves the NEW program's bytes.
    if (g_icache_ghost == nullptr) return;
    ghost_invalidate_all();   // every line refills from live RDRAM on its next fetch
    if (rc_trace_on("RECOMP_ICACHE_GHOST")) fprintf(stderr, "[icache-ghost] FULL SYNC (wave settled): ghost == live for 0x%08X..0x%08X%c", g_icache_ghost_lo, g_icache_ghost_hi, 0x0A);
    fflush(stderr);
}

extern "C" int recomp_baremetal_armed();   // baremetal_sched.cpp: fiber scheduler owns delivery
extern "C" int recomp_bm_wave_active();    // baremetal_sched.cpp: swap wave live ([pi-pace v2])
extern "C" void recomp_bm_budget_break(uint32_t pc);   // note a wave-era budget break for pump redispatch

// [ghoststale] 2026-08-28 — INSTRUMENT ONLY (env RECOMP_GHOST_STALE=1, default silent/zero-cost).
// The A/B on 08-27 proved divert-ON (interpreted, ghost-fetched) draws WRONG PIXELS where the
// native twin draws correct ones. Two candidate causes: (A) an interpreter semantic bug, or
// (B) the ghost is STALE for code the game legitimately reloaded — osInvalICache_recomp is a
// no-op, so a native invalidate never syncs the ghost. This counts EXECUTED fetches whose ghost
// word differs from live RDRAM and names the first N pcs. Silence => (A). Hits => (B).
std::atomic<uint64_t> g_ghost_stale_fetch{0};
std::atomic<uint64_t> g_ghost_fetch_total{0};
extern "C" uint64_t recomp_ghost_stale_fetches(void) { return g_ghost_stale_fetch.load(std::memory_order_relaxed); }
extern "C" uint64_t recomp_ghost_total_fetches(void) { return g_ghost_fetch_total.load(std::memory_order_relaxed); }
// [icache-ghost 2026-09-03] the two paths native code has to tell the ghost its code changed.
static std::atomic<int> g_ghost_full_sync_pending{0};   // set by an Index_Invalidate_I op; serviced at the next ghost fetch
extern "C" void recomp_icache_ghost_sync_range(uint8_t* rdram, uint32_t vaddr, uint32_t nbytes) {
    // The reimplemented osInvalICache(vaddr, nbytes) lands here (ultra_translation.cpp). nbytes >= the I-cache
    // size (0x4000) invalidates the whole cache on hardware => sync the whole window.
    if (g_icache_ghost == nullptr || g_icache_ghost_hi <= g_icache_ghost_lo) return;
    static uint64_t _gs = 0; ++_gs;
    if (nbytes >= 0x4000u) {
        recomp_icache_ghost_sync_all(rdram);
        if (_gs <= 12 || (_gs % 1000) == 0) { fprintf(stderr, "[ghost-sync] #%llu osInvalICache ALL (0x%08X +0x%X)\n", (unsigned long long)_gs, vaddr, nbytes); fflush(stderr); }
        return;
    }
    uint32_t lo = vaddr & ~0xFu, hi = (vaddr + nbytes + 0xFu) & ~0xFu;
    if (lo < g_icache_ghost_lo) lo = g_icache_ghost_lo;
    if (hi > g_icache_ghost_hi) hi = g_icache_ghost_hi;
    if (hi <= lo) return;
    for (uint32_t va = lo; va < hi; va += 32u) ghost_invalidate_line(va);
    if (_gs <= 12 || (_gs % 1000) == 0) { fprintf(stderr, "[ghost-sync] #%llu osInvalICache 0x%08X..0x%08X\n", (unsigned long long)_gs, lo, hi); fflush(stderr); }
}
extern "C" void recomp_cache_op(uint8_t* rdram, recomp_context* ctx, uint32_t op, uint32_t vaddr) {
    // Emitted by the recompiler for every native CACHE instruction (was a dropped no-op). Same model as the
    // interpreter's CACHE case: any op on a line inside the ghost window syncs that line from live RDRAM.
    // Index_Invalidate_I (op 0) names a cache INDEX, not code: libultra uses it for >= ICACHE_SIZE
    // invalidations = the whole cache, 512 ops per call -> one lazy full sync at the next ghost fetch.
    (void)ctx;
    if (g_icache_ghost == nullptr) return;
    if ((op & 0x1Fu) == 0x00u) { g_ghost_full_sync_pending.store(1, std::memory_order_relaxed); return; }
    uint32_t cva = vaddr & ~31u;
    if (cva < g_icache_ghost_lo || cva >= g_icache_ghost_hi) return;
    ghost_invalidate_line(cva);
    static std::atomic<uint64_t> _nc{0}; uint64_t k = ++_nc;
    if (k <= 4 || (k % 65536) == 0) { if (rc_trace_on("RECOMP_ICACHE_GHOST")) fprintf(stderr, "[icache-ghost] native CACHE op 0x%02X sync #%llu line 0x%08X\n", op & 0x1Fu, (unsigned long long)k, cva); fflush(stderr); }
}
static bool ghost_stale_on() {
    static const bool on = [] { const char* e = std::getenv("RECOMP_GHOST_STALE"); return e != nullptr && e[0] != '0'; }();
    return on;
}

inline uint32_t fetch_instr(uint8_t* rdram, uint32_t pc) {
    // 32-bit aligned read; rdram is stored so a native 32-bit load yields the N64 word.
    if (g_icache_ghost != nullptr && pc >= g_icache_ghost_lo && pc < g_icache_ghost_hi) {
        if (g_ghost_full_sync_pending.load(std::memory_order_relaxed)) { g_ghost_full_sync_pending.store(0, std::memory_order_relaxed); ghost_invalidate_all(); }   // [icache-ghost] an Index_Invalidate_I burst
        {
            const uint32_t _li = (pc - g_icache_ghost_lo) >> 5;
            if (g_icache_ghost_valid != nullptr && g_icache_ghost_valid[_li] == 0) {   // not held: fill the line from live RDRAM (hardware miss)
                const uint32_t _lva = pc & ~31u, _off = _lva - g_icache_ghost_lo;
                for (uint32_t _b = 0; _b < 32u && _off + _b + 4u <= (g_icache_ghost_hi - g_icache_ghost_lo); _b += 4u)
                    *(int32_t*)(g_icache_ghost + _off + _b) = (int32_t)MEM_W(0, _lva + _b);
                g_icache_ghost_valid[_li] = 1;
            }
        }
        uint32_t gw = (uint32_t)*(int32_t*)(g_icache_ghost + (pc - g_icache_ghost_lo));
        if (ghost_stale_on()) {
            g_ghost_fetch_total.fetch_add(1, std::memory_order_relaxed);
            uint32_t lw = (uint32_t)MEM_W(0, pc);
            if (lw != gw) {
                uint64_t n = g_ghost_stale_fetch.fetch_add(1, std::memory_order_relaxed) + 1;
                if (n <= 40 || (n % 100000) == 0) {
                    fprintf(stderr, "[ghoststale] #%llu pc=0x%08X ghost=%08X live=%08X%c",
                            (unsigned long long)n, pc, gw, lw, 0x0A);
                    fflush(stderr);
                }
            }
        }
        return gw;
    }
    // [icache-ghost] WAVE-ARM (2026-08-26): the transition wave is driven by the B1 loader loops
    // at 0x800012C0..0x8000130C — the only staged writer that rewrites kernel code in place.
    // Fetching there with the scheduler already armed IS wave detection (the boot-era pass through
    // this same loader runs pre-arm), and it precedes the first kernel-code overwrite. The hold-#1
    // arm site (handler stomp) is provably too late: the armfix run's wave rewrote osRecvMesg at
    // 0x800BD338+ under the executing VI manager BEFORE stomping the handler, and the interpreter
    // executed the fresh compressed bytes (UNIMPL 0xCAFFF6F6 @0x800BD384) and derailed.
    if (g_icache_ghost == nullptr && (pc & 0xFFFFF000u) == 0x80001000u
        && pc >= 0x800012C0u && pc < 0x80001340u) {
        static const bool ig_on = [] { const char* e = std::getenv("RECOMP_ICACHE_GHOST"); return (e == nullptr) || (e[0] != '0'); }();   // DEFAULT ON — see the AUTOBM-ARM site
        if (ig_on && recomp_baremetal_armed()) {
            recomp_icache_ghost_arm(rdram, 0x80000400u, 0x801A0000u);
        }
    }
    if (g_icache_ghost == nullptr && pc >= GHOST_WIN_LO && pc < GHOST_WIN_HI)
        ghost_fetched_map()[(pc - GHOST_WIN_LO) >> 5] = 1;   // [icache-ghost validity] the CPU now holds this line
    return (uint32_t)MEM_W(0, pc);
}

// ── TCB-corruption watchpoint (NC bare-metal diag; gated on recomp_baremetal_enabled) ──────────────
// Nightmare Creatures' scheduler current-task pointer at guest phys 0x000A36B0 (and the run-queue head
// node at 0x000A36A8) gets a TRUNCATED TCB written to it (e.g. 0x800BF090 -> 0x0001F090: the high half
// 0x800B clipped to 0x0001, low half intact). recomp_eret then reads a non-KSEG0 tcb and dead-ends, so the
// task that would call osCreateScheduler is skipped (black screen). This watchpoint fires on EVERY
// interpreted store that lands in the 8-byte window [0x000A36A8, 0x000A36B4) and writes a value whose top
// nibble != 0x8 and != 0 (i.e. a corrupt / truncated guest pointer), logging the EXACT guest PC + store
// width + value so we can name the culprit guest func. Baseline-safe: only active when the bare-metal
// scheduler is enabled (recomp_baremetal_enabled() != 0), which only NC-class games set.
extern "C" int recomp_baremetal_enabled();
extern "C" void recomp_baremetal_note_interp_eret(uint8_t* rdram);
inline void nc_tcb_watch(uint8_t* rdram, uint32_t phys, uint32_t value, int width, uint32_t cur) {
    // (Wave-1 purge: neutered — the NC-specific TCB watchpoint hardcoded game addresses into the
    // universal interpreter store path. SALVAGE NOTE for the generalization worklist: the idea —
    // detect a TRUNCATED KSEG0 pointer written over a known-good TCB pointer — chases a real
    // ENGINE bug class; if resurrected, aim it generically at registered TCB locations, not NC's.)
    // [storeval-watch 2026-08-06, defect-B value-birth hunt] env INTERP_STOREVAL_WATCH=<hex>:
    // log every interp store of that exact 32-bit value (phys + guest pc = the storer). Names
    // the birth site of a fabricated value (turok's 0x0C026020 thread-creation poison). Off =
    // one cached env test; silence under the watch = the storer runs NATIVE, also an answer.
    static uint32_t watch_val = []() {
        const char* e = std::getenv("INTERP_STOREVAL_WATCH");
        return e ? (uint32_t)strtoul(e, nullptr, 0) : 0u;
    }();
    if (watch_val != 0u && value == watch_val && width == 4) {
        static int _n = 0;
        if (_n++ < 40) {
            fprintf(stderr, "[storeval] 0x%08X stored at phys 0x%06X by interp pc=0x%08X\n", value, phys, cur);
            fflush(stderr);
        }
    }
    // [storeaddr-watch 2026-08-27] env RECOMP_STORE_WATCH=lo:hi (phys, hex): log every interp
    // store INTO the window (phys, value, width, guest pc). The address-window twin of the
    // value watch above — built for the [0x800CFEF4] audio-global lifecycle hunt (SOTE silence
    // chain, July decode) and generally the "who wrote this word" question the AdEL-trap note
    // wanted answered. Off = one cached env test per store.
    static uint32_t aw_lo = 0, aw_hi = 0;
    static const bool aw_on = []() {
        const char* e = std::getenv("RECOMP_STORE_WATCH");
        unsigned long lo = 0, hi = 0;
        if (e != nullptr && sscanf(e, "%lx:%lx", &lo, &hi) == 2 && hi > lo) {
            aw_lo = (uint32_t)lo; aw_hi = (uint32_t)hi;
            return true;
        }
        return false;
    }();
    if (aw_on && phys >= aw_lo && phys < aw_hi) {
        static int _an = 0;
        ++_an;
        if (_an <= 200 || (_an % 1000) == 0) {
            fprintf(stderr, "[storeaddr] phys=0x%06X <- 0x%08X (w=%d) by interp pc=0x%08X ginstr=%llu%c", phys, value, width, cur, (unsigned long long)g_guest_instr.load(std::memory_order_relaxed), 0x0A);
            fflush(stderr);
        }
    }
    (void)rdram; (void)width;
}

// Result of executing a single instruction: how control flow should proceed.
struct Step {
    bool is_branch = false;  // conditional branch (beq/bne/blez/.../regimm)
    bool taken     = false;  // branch condition result
    bool likely    = false;  // "branch likely" variant (nullifies delay slot if not taken)
    bool is_jump   = false;  // unconditional transfer (j / jr non-link)
    bool is_call   = false;  // jal / jalr (link) — dispatch as a subroutine call
    bool no_delay  = false;  // transfer has NO delay slot (eret) — don't run pc+4
    bool stop      = false;  // abort this interpret call (derail containment)
    uint32_t target = 0;     // branch/jump/call target vaddr
};

// Execute exactly one instruction. Register/memory side effects are applied immediately;
// control-flow intent is returned in `s`. `cur` is the vaddr of this instruction (needed
// for branch target + link address computation).
// [tlb-refill] raise a synchronous TLB-refill/invalid exception for an unmapped KUSEG data access
// (baremetal_sched.cpp). Returns the exception vector to jump to, or 0 to proceed with the access.
extern "C" uint32_t recomp_bm_raise_tlb_refill(uint8_t* rdram, recomp_context* ctx, uint32_t vaddr, int is_store, uint32_t epc);
// True while exec_one runs a delay-slot instruction: a raise there would be swallowed by
// run_delay_slot (which ignores a jump result), so the refill hook stands down inside a delay slot.
static thread_local bool g_interp_in_delayslot = false;
// Load (1) / store (2) / not-a-memory-op (0). All use base R[rs] + simm as the effective address.
static inline int interp_mem_op_kind(uint32_t op) {
    switch (op) {
        case 0x20: case 0x21: case 0x22: case 0x23: case 0x24: case 0x25: case 0x26: case 0x27:
        case 0x1A: case 0x1B: case 0x37: case 0x30: case 0x34: case 0x35: case 0x31: return 1;
        case 0x28: case 0x29: case 0x2A: case 0x2B: case 0x2C: case 0x2D: case 0x2E:
        case 0x38: case 0x39: case 0x3C: case 0x3D: case 0x3F: return 2;
        default: return 0;
    }
}

void exec_one(uint8_t* rdram, recomp_context* ctx, uint32_t insn, uint32_t cur, Step& s) {
    gpr* R = &ctx->r0;
    R[0] = 0; // $zero is always 0

    const uint32_t op    = insn >> 26;
    const uint32_t rs    = (insn >> 21) & 0x1F;
    const uint32_t rt    = (insn >> 16) & 0x1F;
    const uint32_t rd    = (insn >> 11) & 0x1F;
    const uint32_t sa    = (insn >> 6) & 0x1F;
    const uint32_t funct = insn & 0x3F;
    const uint16_t imm   = (uint16_t)(insn & 0xFFFF);
    const int32_t  simm  = (int32_t)(int16_t)imm;
    const uint32_t jtgt  = (cur & 0xF0000000u) | ((insn & 0x03FFFFFFu) << 2);

    auto setr = [&](uint32_t i, gpr v) { if (i != 0) R[i] = v; };

    // [tlb-refill] before executing a load/store, raise a TLB-refill exception if its KUSEG target
    // is unmapped and the guest installed a refill handler (bare-metal-armed games only; see the
    // helper). The handler installs the mapping and erets back to this instruction. Not in a delay
    // slot, where run_delay_slot would discard the redirect while the COP0 state was already set.
    if (!g_interp_in_delayslot) {
        const int _memkind = interp_mem_op_kind(op);
        if (_memkind != 0) {
            const uint32_t _va = (uint32_t)(R[rs] + (gpr)simm);
            const uint32_t _vec = recomp_bm_raise_tlb_refill(rdram, ctx, _va, _memkind == 2, cur);
            if (_vec != 0u) { s.is_jump = true; s.no_delay = true; s.target = _vec; return; }
        }
    }

    // ── [fpr-odd] VR4300 FR=0 SINGLE-PRECISION REGISTER ALIASING (2026-08-28) ──────────────
    // With Status.FR clear (every N64 game, SOTE included) the 32 single-precision FPRs are the
    // two halves of 16 physical 64-bit registers: ODD register N IS the HIGH half of the even
    // register N-1. The static recompiler models this exactly — cgenerator's fpr_u32l_to_string
    // emits ctx->f_odd[(N-1)*2] for an odd index (f_odd = &f0.u32h when FR=0, &f1.u32l when FR=1)
    // for mtc1/mfc1/lwc1/swc1/cvt.s.w/cvt.d.w/cvt.w.s/cvt.w.d/trunc/round/ceil/floor.
    // THIS INTERPRETER INDEXED A FLAT ARRAY instead, so every one of those instructions on an odd
    // register read or wrote the WRONG STORAGE, and — the damaging half — it did not ALIAS: a
    // double left in $fN kept a stale high word that hardware would have clobbered, and an odd
    // single written before a double read came back as whatever the flat slot happened to hold.
    // Silent wrong VALUES, not a crash. Measured consequence (08-27 A/B): interpreted text drawing
    // rendered solid bars where the native twin of the same bytes rendered correct glyphs.
    // Universal (not SOTE-specific): it is the hardware contract, and it is what native code does.
    auto fpr_u32l = [ctx](uint32_t idx) -> uint32_t* {
        if (idx & 1u) {
            uint32_t* base = ctx->f_odd ? ctx->f_odd
                           : (ctx->mips3_float_mode ? &ctx->f1.u32l : &ctx->f0.u32h);
            return base + (idx - 1u) * 2u;
        }
        return &(&ctx->f0)[idx].u32l;
    };


    switch (op) {
    case 0x00: { // SPECIAL
        switch (funct) {
        case 0x00: setr(rd, (gpr)(int32_t)((uint32_t)R[rt] << sa)); break;            // SLL
        case 0x02: setr(rd, (gpr)(int32_t)((uint32_t)R[rt] >> sa)); break;            // SRL
        case 0x03: setr(rd, (gpr)(int32_t)((int32_t)R[rt] >> sa)); break;             // SRA
        case 0x04: setr(rd, (gpr)(int32_t)((uint32_t)R[rt] << (R[rs] & 0x1F))); break;// SLLV
        case 0x06: setr(rd, (gpr)(int32_t)((uint32_t)R[rt] >> (R[rs] & 0x1F))); break;// SRLV
        case 0x07: setr(rd, (gpr)(int32_t)((int32_t)R[rt] >> (R[rs] & 0x1F))); break; // SRAV
        case 0x08:   // JR
        case 0x09: { // JALR
            // ── SAFETY GUARD (always-on, conservative) — corrupted indirect-jump containment ──────────
            // A wild value in rs (e.g. DK64's ~23s crash: a clobbered jr target derails the PC, then a host
            // dereference faults 0xC0000005). A REAL jr/jalr target is always a KSEG0 RDRAM code address:
            // word-aligned and inside [0x80000000, 0x80800000). If the target is OUTSIDE that range or
            // mis-aligned it is ALREADY broken — log it and break out of the interpreted run the SAME way
            // the kInstrBudget watchdog / eret-derail path does (s.stop -> the for(;;) loop breaks), instead
            // of following the PC off into garbage. Baseline-safe by construction: it can only fire on a
            // target that is NOT a plausible code address, so any game whose jumps are valid is unaffected.
            // Executable ranges: KSEG0 RDRAM, plus the CART WINDOW (PI domain-1, cached 0x90000000
            // and uncached 0xB0000000 views of the 64MB ROM space). The whole ROM is mirrored into
            // the rdram buffer at its physical cart address at init (the Robotron raw-PIO fix), and
            // CV64_PHYS maps both views onto it — so cart-window EXECUTION works end-to-end; only
            // these guards rejected it. Perfect Dark's boot runs bootloader code through the cached
            // cart window (its piracy check reads/executes the IPL region; see the n64decomp
            // perfect_dark piracychecks doc) and aborted here at 0x9000000C.
            // TLB-MAPPED CODE (2026-08-04, GoldenEye): the ranges above are the DIRECT-mapped
            // ones, but a cart may legitimately execute from KUSEG through its own TLB entries.
            // GoldenEye writes `hi=0x70000000 mask=0x007FE000 lo0=0x1F` (4 MB page, V set, PFN 0 —
            // i.e. 0x70000000..0x703FFFFF onto the bottom 4 MB of RDRAM) and then jumps to
            // 0x70000510, four instructions into boot. This guard called that "implausible" and
            // aborted, so the game died before it did anything — 0 flips, VI ticking, no origin.
            // Same shape as the Perfect Dark cart-window miss above: a real execution region the
            // guard simply did not know about.
            // Ask recomp_tlb_is_mapped, NEVER recomp_tlb_translate — translate flat-maps every
            // miss and so reports success for ANY address, which would disable containment
            // entirely. Require the resolved physical to land in RDRAM so a wild jump through a
            // stale mapping is still caught.
            uint32_t tgt = (uint32_t)R[rs];
            bool tgt_ok = ((tgt >= 0x80000000u && tgt < 0x80800000u) ||
                           (tgt >= 0x90000000u && tgt < 0x94000000u) ||
                           (tgt >= 0xB0000000u && tgt < 0xB4000000u)) && (tgt & 3u) == 0;
            if (!tgt_ok && (tgt & 3u) == 0) {
                uint32_t tphys = 0;
                if (recomp_tlb_is_mapped(tgt, &tphys) && (tphys + 4u) <= 0x00800000u) {
                    tgt_ok = true;
                    static int _tlbjmp = 0;
                    if (_tlbjmp++ < 8)
                        fprintf(stderr, "[interp] TLB-mapped %s target 0x%08X -> phys 0x%06X (allowed)\n",
                                (funct == 0x08) ? "JR" : "JALR", tgt, tphys);
                }
            }
            // THE SESSION RETURN IS NOT A DERAIL (2026-08-28, KI Gold). When the interpreter is
            // entered from NATIVE code through the dispatch-gap net there is no guest caller, so
            // the session's return sentinel is ctx->r31 as it stood at entry — normally 0. The
            // guest's own epilogue `jr $ra` therefore targets an address the range test above
            // rejects, and this guard used to abort the session AT THE RETURN, one instruction
            // before it would have ended cleanly, skipping the delay slot that restores $sp.
            // Let it through: the loop-top `pc == entry_ra` check ends the session properly and
            // the delay slot runs first. Requiring word alignment keeps the ERET-style entry
            // (no_stop_ra, sentinel 1) and the no-session value (0xFFFFFFFF) out of the exemption,
            // so containment is unchanged for every genuinely wild jump.
            if (!tgt_ok && tgt == g_interp_entry_ra && (g_interp_entry_ra & 3u) == 0u) {
                tgt_ok = true;
                static int _retsent = 0;
                if (_retsent++ < 8)
                    fprintf(stderr, "[interp] %s to session return sentinel 0x%08X (func start 0x%08X) — clean return\n",
                            (funct == 0x08) ? "JR" : "JALR", tgt, g_interp_start_vaddr);
            }
            if (!tgt_ok) {
                if (g_unimpl_count++ < 64)
                    fprintf(stderr,
                        "[interp] CORRUPT %s target @0x%08X (func start 0x%08X) -> 0x%08X (rs=%u) [implausible -> abort]\n",
                        (funct == 0x08) ? "JR" : "JALR", cur, g_interp_start_vaddr, tgt, rs);
                s.stop = true;
                break;
            }
            if (funct == 0x09) { setr(rd ? rd : 31, cur + 8); s.is_call = true; }  // JALR links
            else               { s.is_jump = true; }                              // JR
            s.target = tgt;
            break;
        }
        case 0x0C: /* SYSCALL */
            if (g_unimpl_count++ < 64) fprintf(stderr, "[interp] SYSCALL @0x%08X (ignored)\n", cur);
            break;
        case 0x0D: /* BREAK */ break;
        case 0x0F: /* SYNC */ break;
        case 0x10: setr(rd, ctx->hi); break;                                          // MFHI
        case 0x11: ctx->hi = R[rs]; break;                                            // MTHI
        case 0x12: setr(rd, ctx->lo); break;                                          // MFLO
        case 0x13: ctx->lo = R[rs]; break;                                            // MTLO
        // Doubleword variable shifts (shift amount = low 6 bits of rs). NOTE: funct 0x14 is
        // DSLLV, NOT DSLL32 (0x3C) — the prior code mislabeled it and silently mis-executed
        // every DSLLV as a shift-by-(sa+32). Surfaced by Extreme-G's interpreted 64-bit math.
        case 0x14: setr(rd, (gpr)(R[rt] << (R[rs] & 0x3F))); break;                   // DSLLV
        case 0x16: setr(rd, (gpr)(R[rt] >> (R[rs] & 0x3F))); break;                   // DSRLV (logical)
        case 0x17: setr(rd, (gpr)((int64_t)R[rt] >> (R[rs] & 0x3F))); break;          // DSRAV (arithmetic)
        case 0x18: { int64_t p=(int64_t)(int32_t)R[rs]*(int64_t)(int32_t)R[rt]; // MULT
                     ctx->lo=(uint64_t)(int64_t)(int32_t)(uint32_t)p;
                     ctx->hi=(uint64_t)(int64_t)(int32_t)(uint32_t)(p>>32); } break;
        case 0x19: { uint64_t p=(uint64_t)(uint32_t)R[rs]*(uint64_t)(uint32_t)R[rt];
                     ctx->lo=(uint64_t)(int64_t)(int32_t)(uint32_t)p;
                     ctx->hi=(uint64_t)(int64_t)(int32_t)(uint32_t)(p>>32); } break;   // MULTU
        case 0x1A: { int32_t a=(int32_t)R[rs], b=(int32_t)R[rt];
                     if (b!=0){ ctx->lo=(uint64_t)(int64_t)(a/b); ctx->hi=(uint64_t)(int64_t)(a%b);} } break; // DIV
        case 0x1B: { uint32_t a=(uint32_t)R[rs], b=(uint32_t)R[rt];
                     if (b!=0){ ctx->lo=(uint64_t)(int64_t)(int32_t)(a/b); ctx->hi=(uint64_t)(int64_t)(int32_t)(a%b);} } break; // DIVU
        // 64-bit multiply/divide — reuse recomp.h's exact helpers so an interpreted op is
        // bit-identical to recompiled codegen (incl. the VR4300 zero-divisor semantics in DDIV/DDIVU).
        case 0x1C: { int64_t  lo,hi; DMULT ((int64_t)R[rs],(int64_t)R[rt],&lo,&hi); ctx->lo=(uint64_t)lo; ctx->hi=(uint64_t)hi; } break; // DMULT
        case 0x1D: { uint64_t lo,hi; DMULTU(R[rs],R[rt],&lo,&hi);                   ctx->lo=lo;           ctx->hi=hi;           } break; // DMULTU
        case 0x1E: { int64_t  q,r;   DDIV  ((int64_t)R[rs],(int64_t)R[rt],&q,&r);   ctx->lo=(uint64_t)q;  ctx->hi=(uint64_t)r;  } break; // DDIV
        case 0x1F: { uint64_t q,r;   DDIVU (R[rs],R[rt],&q,&r);                     ctx->lo=q;            ctx->hi=r;            } break; // DDIVU
        case 0x20: setr(rd, ADD32(R[rs], R[rt])); break;                              // ADD
        case 0x21: setr(rd, ADD32(R[rs], R[rt])); break;                              // ADDU
        case 0x22: setr(rd, SUB32(R[rs], R[rt])); break;                              // SUB
        case 0x23: setr(rd, SUB32(R[rs], R[rt])); break;                              // SUBU
        case 0x24: setr(rd, R[rs] & R[rt]); break;                                    // AND
        case 0x25: setr(rd, R[rs] | R[rt]); break;                                    // OR
        case 0x26: setr(rd, R[rs] ^ R[rt]); break;                                    // XOR
        case 0x27: setr(rd, ~(R[rs] | R[rt])); break;                                 // NOR
        case 0x2A: setr(rd, (SIGNED(R[rs]) < SIGNED(R[rt])) ? 1 : 0); break;          // SLT
        case 0x2B: setr(rd, (R[rs] < R[rt]) ? 1 : 0); break;                          // SLTU
        case 0x2C: setr(rd, R[rs] + R[rt]); break;                                    // DADD  (no overflow trap under HLE)
        case 0x2D: setr(rd, R[rs] + R[rt]); break;                                    // DADDU
        case 0x2E: setr(rd, R[rs] - R[rt]); break;                                    // DSUB  (no overflow trap under HLE)
        case 0x2F: setr(rd, R[rs] - R[rt]); break;                                    // DSUBU
        // Conditional traps (TGE/TGEU/TLT/TLTU/TEQ/TNE). Hardware would trap to the general
        // exception vector; HLE has no exception delivery, so no-op (same philosophy as the
        // never-trap div-by-zero in recomp.h). These are assertion-class and rarely fire.
        case 0x30: case 0x31: case 0x32: case 0x33: case 0x34: case 0x36: break;
        // Doubleword immediate shifts (shift amount = sa, or sa+32 for the *32 variants).
        case 0x38: setr(rd, (gpr)(R[rt] << sa)); break;                               // DSLL
        case 0x3A: setr(rd, (gpr)(R[rt] >> sa)); break;                               // DSRL (logical)
        case 0x3B: setr(rd, (gpr)((int64_t)R[rt] >> sa)); break;                      // DSRA (arithmetic)
        case 0x3C: setr(rd, (gpr)(R[rt] << (sa + 32))); break;                        // DSLL32
        case 0x3E: setr(rd, (gpr)(R[rt] >> (sa + 32))); break;                        // DSRL32 (logical)
        case 0x3F: setr(rd, (gpr)((int64_t)R[rt] >> (sa + 32))); break;               // DSRA32 (arithmetic)
        default:
            if (g_unimpl_count++ < 64)
                fprintf(stderr, "[interp] UNIMPL SPECIAL funct=0x%02X insn=0x%08X @0x%08X\n", funct, insn, cur);
            break;
        }
        break;
    }
    case 0x01: { // REGIMM
        int64_t v = SIGNED(R[rs]);
        switch (rt) {
        case 0x00: s.is_branch=true; s.taken=(v<0);  s.target=cur+4+(simm<<2); break;            // BLTZ
        case 0x01: s.is_branch=true; s.taken=(v>=0); s.target=cur+4+(simm<<2); break;            // BGEZ
        case 0x02: s.is_branch=true; s.likely=true; s.taken=(v<0);  s.target=cur+4+(simm<<2); break; // BLTZL
        case 0x03: s.is_branch=true; s.likely=true; s.taken=(v>=0); s.target=cur+4+(simm<<2); break; // BGEZL
        case 0x10: s.is_branch=true; s.taken=(v<0);  s.target=cur+4+(simm<<2); setr(31,cur+8); break; // BLTZAL
        case 0x11: s.is_branch=true; s.taken=(v>=0); s.target=cur+4+(simm<<2); setr(31,cur+8); break; // BGEZAL
        default:
            if (g_unimpl_count++ < 64)
                fprintf(stderr, "[interp] UNIMPL REGIMM rt=0x%02X insn=0x%08X @0x%08X\n", rt, insn, cur);
            break;
        }
        break;
    }
    case 0x02: s.is_jump = true; s.target = jtgt; break;                              // J
    case 0x03: setr(31, cur + 8); s.is_call = true; s.target = jtgt; break;           // JAL
    case 0x04: s.is_branch=true; s.taken=(R[rs]==R[rt]); s.target=cur+4+(simm<<2); break;          // BEQ
    case 0x05: s.is_branch=true; s.taken=(R[rs]!=R[rt]); s.target=cur+4+(simm<<2); break;          // BNE
    case 0x06: s.is_branch=true; s.taken=(SIGNED(R[rs])<=0); s.target=cur+4+(simm<<2); break;      // BLEZ
    case 0x07: s.is_branch=true; s.taken=(SIGNED(R[rs])>0);  s.target=cur+4+(simm<<2); break;      // BGTZ
    case 0x08: setr(rt, ADD32(R[rs], simm)); break;                                   // ADDI
    case 0x09: setr(rt, ADD32(R[rs], simm)); break;                                   // ADDIU
    case 0x0A: setr(rt, (SIGNED(R[rs]) < (int64_t)simm) ? 1 : 0); break;              // SLTI
    case 0x0B: setr(rt, (R[rs] < (gpr)(int64_t)simm) ? 1 : 0); break;                 // SLTIU
    case 0x0C: setr(rt, R[rs] & (uint64_t)imm); break;                                // ANDI
    case 0x0D: setr(rt, R[rs] | (uint64_t)imm); break;                                // ORI
    case 0x0E: setr(rt, R[rs] ^ (uint64_t)imm); break;                                // XORI
    case 0x0F: setr(rt, (gpr)(int32_t)((uint32_t)imm << 16)); break;                  // LUI
    case 0x14: s.is_branch=true; s.likely=true; s.taken=(R[rs]==R[rt]); s.target=cur+4+(simm<<2); break; // BEQL
    case 0x15: s.is_branch=true; s.likely=true; s.taken=(R[rs]!=R[rt]); s.target=cur+4+(simm<<2); break; // BNEL
    case 0x16: s.is_branch=true; s.likely=true; s.taken=(SIGNED(R[rs])<=0); s.target=cur+4+(simm<<2); break; // BLEZL
    case 0x17: s.is_branch=true; s.likely=true; s.taken=(SIGNED(R[rs])>0);  s.target=cur+4+(simm<<2); break; // BGTZL
    // ── Loads ──
    case 0x20: setr(rt, (gpr)(int32_t)(int8_t)MEM_B(simm, R[rs])); break;             // LB
    case 0x21: setr(rt, (gpr)(int32_t)(int16_t)MEM_H(simm, R[rs])); break;            // LH
    case 0x22: setr(rt, do_lwl(rdram, R[rt], simm, R[rs])); break;                    // LWL
    // LW/LWU/SW route through LOAD_W/STORE_W (not bare MEM_W) so word accesses to the MMIO device-register
    // windows (0xA4xxxxxx RCP regs, 0xC0000000 GIO) hit recomp_mmio_load_w/store_w — exactly like the
    // RECOMPILED code does. Without this, an interpreted bare-metal exception handler reading MI_INTR
    // (0xA4300008) got 0 instead of the pending-interrupt bits, so it never saw the VI source / posted the
    // VI event -> the scheduler never resumed the render worker -> black screen (Nightmare Creatures, and the
    // whole interpreted-handler class). General + baseline-safe: non-device addresses fall through to the
    // identical MEM_W fast path inside LOAD_W/STORE_W.
    case 0x23: setr(rt, LOAD_W(simm, R[rs])); break;                                  // LW
    case 0x24: setr(rt, (gpr)(uint8_t)MEM_BU(simm, R[rs])); break;                    // LBU
    case 0x25: setr(rt, (gpr)(uint16_t)MEM_HU(simm, R[rs])); break;                   // LHU
    case 0x26: setr(rt, do_lwr(rdram, R[rt], simm, R[rs])); break;                    // LWR
    case 0x27: setr(rt, (gpr)(uint32_t)LOAD_W(simm, R[rs])); break;                   // LWU
    // ── The 64-bit unaligned family (2026-08-05) ──────────────────────────────────────────────
    // LDL/LDR/SDL/SDR and DADDI/DADDIU had NO cases here, so they fell to `default:` and became
    // SILENT NO-OPS: an interpreted unaligned doubleword copy left the destination register stale
    // or the destination memory unwritten, and a 64-bit pointer bump did nothing. No crash, and
    // after 64 messages the shared g_unimpl_count cap hides even the log line — so it presented as
    // unattributable garbage (textures / display lists / save data) far from the real cause.
    // The 32-bit halves of this family (LWL 0x22 / LWR 0x26 / SWL 0x2A / SWR 0x2E) were always
    // here; only the doubleword ones were missed. The helpers already existed in recomp.h and this
    // very file binds them for the JIT (jit_ldl/jit_sdl below) — exec_one just never called them.
    // The static recompiler handles all six, so this restores the parity this file's header claims.
    case 0x1A: setr(rt, do_ldl(rdram, R[rt], simm, R[rs])); break;                    // LDL
    case 0x1B: setr(rt, do_ldr(rdram, R[rt], simm, R[rs])); break;                    // LDR
    case 0x18: setr(rt, R[rs] + (gpr)(int64_t)simm); break;                           // DADDI  (no overflow trap under HLE, as DADD above)
    case 0x19: setr(rt, R[rs] + (gpr)(int64_t)simm); break;                           // DADDIU
    case 0x37: setr(rt, LD(simm, R[rs])); break;                                      // LD
    // ── Stores ──
    // nc_tcb_watch (NC bare-metal diag, gated): catch a truncated TCB written to the scheduler's
    // current-task ptr / run-queue head. Compute the LOGICAL phys addr (KSEG0 mask) BEFORE the
    // byte-swizzle so the window test is address-correct for every store width.
    case 0x28: { uint32_t _va=(uint32_t)(R[rs]+simm); nc_tcb_watch(rdram, _va & 0x1FFFFFFFu, (uint32_t)(uint8_t)R[rt], 1, cur);
                 MEM_B(simm, R[rs]) = (int8_t)R[rt]; } break;                         // SB
    case 0x29: { uint32_t _va=(uint32_t)(R[rs]+simm); nc_tcb_watch(rdram, _va & 0x1FFFFFFFu, (uint32_t)(uint16_t)R[rt], 2, cur);
                 MEM_H(simm, R[rs]) = (int16_t)R[rt]; } break;                        // SH
    case 0x2A: { uint32_t _va=(uint32_t)(R[rs]+simm); nc_tcb_watch(rdram, _va & 0x1FFFFFFFu, (uint32_t)R[rt], 4, cur);
                 do_swl(rdram, simm, R[rs], R[rt]); } break;                          // SWL
    case 0x2B: { uint32_t _va=(uint32_t)(R[rs]+simm); nc_tcb_watch(rdram, _va & 0x1FFFFFFFu, (uint32_t)R[rt], 4, cur);
                 STORE_W(simm, R[rs], (int32_t)R[rt]); } break;                       // SW
    case 0x2E: { uint32_t _va=(uint32_t)(R[rs]+simm); nc_tcb_watch(rdram, _va & 0x1FFFFFFFu, (uint32_t)R[rt], 4, cur);
                 do_swr(rdram, simm, R[rs], R[rt]); } break;                          // SWR
    // SDL/SDR — the doubleword half of SWL/SWR (see the LDL/LDR note above). Watch the high word
    // at width 8, matching SD's first nc_tcb_watch call.
    case 0x2C: { uint32_t _va=(uint32_t)(R[rs]+simm); nc_tcb_watch(rdram, _va & 0x1FFFFFFFu, (uint32_t)((uint64_t)R[rt] >> 32), 8, cur);
                 do_sdl(rdram, simm, R[rs], R[rt]); } break;                          // SDL
    case 0x2D: { uint32_t _va=(uint32_t)(R[rs]+simm); nc_tcb_watch(rdram, _va & 0x1FFFFFFFu, (uint32_t)((uint64_t)R[rt] >> 32), 8, cur);
                 do_sdr(rdram, simm, R[rs], R[rt]); } break;                          // SDR
    case 0x2F: /* CACHE */
        // [icache-ghost] hardware-true disarm: the loader ends the wave with CACHE invalidates —
        // on the VR4300 each one makes the NEXT fetch of that line come from memory. Model it per
        // 32-byte line: sync ghost <- live RDRAM. The ghost dissolves exactly as the real I-cache
        // does, and the NEW kernel's bytes take over line by line (any cache op on a line inside
        // the ghost window syncs it — erring toward live = hardware after an invalidate).
        if (g_icache_ghost != nullptr) {
            uint32_t _cva = (uint32_t)(R[rs] + simm) & ~31u;
            const uint32_t _cop = (insn >> 16) & 31u;
            if (_cop == 0x00u) ghost_invalidate_all();   // Index_Invalidate_I: the address is a cache index; libultra's >= ICACHE_SIZE path = the whole cache
            if (_cva >= g_icache_ghost_lo && _cva < g_icache_ghost_hi) {
                ghost_invalidate_line(_cva);   // [icache-ghost validity] the line refills from live on its next fetch
                static uint32_t _cs = 0;
                ++_cs;
                if (_cs <= 4 || (_cs % 4096u) == 0u)
                    { if (rc_trace_on("RECOMP_ICACHE_GHOST")) fprintf(stderr, "[icache-ghost] CACHE sync #%u line 0x%08X\n", _cs, _cva); fflush(stderr); }
            }
        }
        break;
    // ── LL / LLD / SC / SCD (2026-08-05) ─────────────────────────────────────────────────────────
    // All four were absent, so they fell to `default:` and did NOTHING: LL/LLD left the destination
    // register stale, SC/SCD wrote no memory AND left rt holding its pre-sc value. In the canonical
    // `ll / modify / sc / branch-if-zero retry` loop that means the update is silently LOST (rt is
    // normally non-zero, so the retry branch falls through and the loop "succeeds"), or spins
    // forever if the computed value happened to be 0.
    // The recompiler handles all four at N64Recomp/src/recompilation.cpp:957-981 — and its comment
    // says why they were added there: "runtime-discovered functions use these, and the
    // unhandled->nop fallback made them silently wrong" (the drmario materialization wall). That is
    // exactly the class of code the INTERPRETER is the default engine for, so the same fallback
    // hole survived here. Semantics mirror the recompiler: the load/store half, then rt = 1,
    // because with no other CPU contending there is nothing that can make the store conditional.
    case 0x30: setr(rt, LOAD_W(simm, R[rs])); break;                                  // LL   (= LW)
    case 0x34: setr(rt, LD(simm, R[rs])); break;                                      // LLD  (= LD)
    case 0x38: { uint32_t _va=(uint32_t)(R[rs]+simm); nc_tcb_watch(rdram, _va & 0x1FFFFFFFu, (uint32_t)R[rt], 4, cur);
                 STORE_W(simm, R[rs], (int32_t)R[rt]); setr(rt, 1); } break;          // SC   (store, then report success)
    case 0x3C: { uint32_t _va=(uint32_t)(R[rs]+simm);                                 // SCD
                 nc_tcb_watch(rdram, (_va+0) & 0x1FFFFFFFu, (uint32_t)((uint64_t)R[rt] >> 32), 8, cur);
                 nc_tcb_watch(rdram, (_va+4) & 0x1FFFFFFFu, (uint32_t)((uint64_t)R[rt] >>  0), 8, cur);
                 SD(R[rt], simm, R[rs]); setr(rt, 1); } break;
    case 0x3F: { uint32_t _va=(uint32_t)(R[rs]+simm);                                 // SD
                 // SD writes 8 bytes: high word -> [va..va+3], low word -> [va+4..va+7].
                 nc_tcb_watch(rdram, (_va+0) & 0x1FFFFFFFu, (uint32_t)((uint64_t)R[rt] >> 32), 8, cur);
                 nc_tcb_watch(rdram, (_va+4) & 0x1FFFFFFFu, (uint32_t)((uint64_t)R[rt] >>  0), 8, cur);
                 SD(R[rt], simm, R[rs]); } break;
    // ── COP1 (FPU) loads/stores ──
    case 0x31: *fpr_u32l(rt) = (uint32_t)LOAD_W(simm, R[rs]); break;                    // LWC1  [fpr-odd]
    case 0x39: STORE_W(simm, R[rs], (int32_t)*fpr_u32l(rt)); break;                     // SWC1  [fpr-odd] + STORE_W (cgenerator contract)
    case 0x35: { fpr* F=&ctx->f0; F[rt].u64 = (uint64_t)LD(simm, R[rs]); } break;     // LDC1
    case 0x3D: { fpr* F=&ctx->f0; SD(F[rt].u64, simm, R[rs]); } break;                // SDC1
    case 0x11: { // COP1 — full single/double arithmetic, conversions, compares, BC1 (SESSION 44).
        // Field mapping: fmt=rs, ft=rt, fs=rd, fd=sa. Registers accessed as whole 64-bit
        // fprs (uses_mips3_float_mode — matches how N64Recomp emits ctx->fN.fl / .d).
        fpr* F = &ctx->f0;
        const uint32_t fmt = rs, ft = rt, fs = rd, fd = sa;
        // Compare condition codes (funct 0x30+cond): cond bit1 = "equal" term,
        // cond bit2 = "less" term... concretely: eq-class {2,3,A,B}, lt-class {4,5,C,D},
        // le-class {6,7,E,F}; {0,1,8,9} are unordered-only → false for ordered inputs.
        auto fp_compare = [&](double a, double b, uint32_t cond) -> bool {
            if (a != a || b != b) return (cond & 1) != 0;   // NaN: unordered → UN-variants true
            switch (cond & 0xE) {
            case 0x2: case 0xA: return a == b;              // c.eq / c.seq class
            case 0x4: case 0xC: return a < b;               // c.olt / c.lt class
            case 0x6: case 0xE: return a <= b;              // c.ole / c.le class
            default:            return false;               // c.f / c.un(ordered) / c.sf
            }
        };
        switch (fmt) {
        case 0x00: setr(rt, (gpr)(int32_t)*fpr_u32l(fs)); break;                       // MFC1  [fpr-odd]
        case 0x01: setr(rt, (gpr)F[fs].u64); break;                                   // DMFC1
        case 0x04: *fpr_u32l(fs) = (uint32_t)R[rt]; break;                             // MTC1  [fpr-odd]
        case 0x05: F[fs].u64 = (uint64_t)R[rt]; break;                                // DMTC1
        case 0x02: setr(rt, g_c1cs ? (gpr)(1u << 23) : 0); break;                     // CFC1 (cond bit only)
        case 0x06: g_c1cs = ((uint32_t)R[rt] & (1u << 23)) != 0; break;               // CTC1
        case 0x08: {                                                                  // BC1F/T(L)
            bool taken = ((rt & 1) != 0) == g_c1cs;   // rt bit0: 0=BC1F, 1=BC1T
            s.is_branch = true;
            s.likely = (rt & 2) != 0;
            s.taken = taken;
            s.target = cur + 4 + (simm << 2);
            break;
        }
        case 0x10: { // fmt = S
            float a = F[fs].fl, b = F[ft].fl;
            if (funct >= 0x30) { g_c1cs = fp_compare((double)a, (double)b, funct & 0xF); break; }
            switch (funct) {
            case 0x00: F[fd].fl = a + b; break;                                       // ADD.S
            case 0x01: F[fd].fl = a - b; break;                                       // SUB.S
            case 0x02: F[fd].fl = a * b; break;                                       // MUL.S
            case 0x03: F[fd].fl = a / b; break;                                       // DIV.S
            case 0x04: F[fd].fl = sqrtf(a); break;                                    // SQRT.S
            case 0x05: F[fd].fl = fabsf(a); break;                                    // ABS.S
            case 0x06: F[fd].fl = a; break;                                           // MOV.S
            case 0x07: F[fd].fl = -a; break;                                          // NEG.S
            case 0x0C: *fpr_u32l(fd) = (uint32_t)(int32_t)lroundf(a); break;           // ROUND.W.S [fpr-odd]
            case 0x0D: *fpr_u32l(fd) = (uint32_t)(int32_t)a; break;                    // TRUNC.W.S [fpr-odd]
            case 0x0E: *fpr_u32l(fd) = (uint32_t)(int32_t)ceilf(a); break;             // CEIL.W.S [fpr-odd]
            case 0x0F: *fpr_u32l(fd) = (uint32_t)(int32_t)floorf(a); break;            // FLOOR.W.S [fpr-odd]
            case 0x21: F[fd].d = (double)a; break;                                    // CVT.D.S
            case 0x24: *fpr_u32l(fd) = (uint32_t)(int32_t)a; break;                    // CVT.W.S [fpr-odd]
            case 0x25: F[fd].u64 = (uint64_t)(int64_t)a; break;                       // CVT.L.S
            default:
                if (g_unimpl_count++ < 64)
                    fprintf(stderr, "[interp] UNIMPL COP1.S funct=0x%02X insn=0x%08X @0x%08X\n", funct, insn, cur);
                break;
            }
            break;
        }
        case 0x11: { // fmt = D
            double a = F[fs].d, b = F[ft].d;
            if (funct >= 0x30) { g_c1cs = fp_compare(a, b, funct & 0xF); break; }
            switch (funct) {
            case 0x00: F[fd].d = a + b; break;
            case 0x01: F[fd].d = a - b; break;
            case 0x02: F[fd].d = a * b; break;
            case 0x03: F[fd].d = a / b; break;
            case 0x04: F[fd].d = sqrt(a); break;
            case 0x05: F[fd].d = fabs(a); break;
            case 0x06: F[fd].d = a; break;
            case 0x07: F[fd].d = -a; break;
            case 0x0C: *fpr_u32l(fd) = (uint32_t)(int32_t)lround(a); break;            // ROUND.W.D [fpr-odd]
            case 0x0D: *fpr_u32l(fd) = (uint32_t)(int32_t)a; break;                    // TRUNC.W.D [fpr-odd]
            case 0x0E: *fpr_u32l(fd) = (uint32_t)(int32_t)ceil(a); break;              // CEIL.W.D [fpr-odd]
            case 0x0F: *fpr_u32l(fd) = (uint32_t)(int32_t)floor(a); break;             // FLOOR.W.D [fpr-odd]
            case 0x20: F[fd].fl = (float)a; break;                                    // CVT.S.D
            case 0x24: *fpr_u32l(fd) = (uint32_t)(int32_t)a; break;                    // CVT.W.D [fpr-odd]
            case 0x25: F[fd].u64 = (uint64_t)(int64_t)a; break;                       // CVT.L.D
            default:
                if (g_unimpl_count++ < 64)
                    fprintf(stderr, "[interp] UNIMPL COP1.D funct=0x%02X insn=0x%08X @0x%08X\n", funct, insn, cur);
                break;
            }
            break;
        }
        case 0x14: // fmt = W
            switch (funct) {
            case 0x20: F[fd].fl = (float)(int32_t)*fpr_u32l(fs); break;                // CVT.S.W [fpr-odd]
            case 0x21: F[fd].d  = (double)(int32_t)*fpr_u32l(fs); break;               // CVT.D.W [fpr-odd]
            default:
                if (g_unimpl_count++ < 64)
                    fprintf(stderr, "[interp] UNIMPL COP1.W funct=0x%02X insn=0x%08X @0x%08X\n", funct, insn, cur);
                break;
            }
            break;
        case 0x15: // fmt = L
            switch (funct) {
            case 0x20: F[fd].fl = (float)(int64_t)F[fs].u64; break;                   // CVT.S.L
            case 0x21: F[fd].d  = (double)(int64_t)F[fs].u64; break;                  // CVT.D.L
            default:
                if (g_unimpl_count++ < 64)
                    fprintf(stderr, "[interp] UNIMPL COP1.L funct=0x%02X insn=0x%08X @0x%08X\n", funct, insn, cur);
                break;
            }
            break;
        default:
            if (g_unimpl_count++ < 64)
                fprintf(stderr, "[interp] UNIMPL COP1 fmt=0x%02X insn=0x%08X @0x%08X\n", fmt, insn, cur);
            break;
        }
        break;
    }
    case 0x10: { /* COP0 — mfc0/mtc0 + TLB ops, routed to the same backing as recompiled code */
        // The "CO" bit (insn bit 25) selects a TLB op (tlbr/tlbwi/tlbwr/tlbp) over mfc0/mtc0.
        if (insn & 0x02000000u) {
            switch (funct) {
                case 0x01: recomp_tlbr();  break; // TLBR  — read indexed entry into EntryHi/Lo/PageMask
                case 0x02: recomp_tlbwi(); break; // TLBWI — write Index-selected entry
                case 0x06: recomp_tlbwr(); break; // TLBWR — write Random-selected entry
                case 0x08: recomp_tlbp();  break; // TLBP  — probe; sets Index (or P bit on miss)
                case 0x18: { // ERET — exception return (VR4300). Faithful: PC <- ErrorEPC if Status.ERL
                    // else EPC; clear the corresponding bit. No delay slot. This is how the game's own
                    // libultra (__osDispatchThread / __osException) context-switches into a thread, so
                    // without it the interpreter ran straight off the rails after the first dispatch.
                    // AUTO-ARM (worklist #8): an interpreted eret is PROOF the game runs its own OS —
                    // note it (and try the auto-arm) so the fiber scheduler can engage. Without this,
                    // fully-interpreted dispatchers (the fifa class: '[interp] ERET' with changing EPCs
                    // = live thread switching!) never latch the eret-seen gate.
                    recomp_baremetal_note_interp_eret(rdram);
                    if (recomp_baremetal_enabled()) {
                        // Bare-metal fiber scheduler: this eret is NC's cooperative context switch. The
                        // (interpreted) dispatcher already restored the target task's regs + set EPC/current-
                        // task; perform the fiber switch and end this interpret session (control transferred).
                        recomp_eret(rdram, ctx);
                        s.stop = true; s.target = cur;  // came back: end cleanly (no derail/abort path)
                        break;
                    }
                    uint32_t sr = (uint32_t)cop0_status_read(ctx);
                    if (sr & 0x4u) {                                  // ERL set → return via ErrorEPC (reg 30)
                        s.target = recomp_cop0_tlb_read(30);
                        cop0_status_write(ctx, sr & ~0x4u);
                    } else {                                          // normal → return via EPC (reg 14), clear EXL
                        s.target = recomp_cop0_tlb_read(14);
                        cop0_status_write(ctx, sr & ~0x2u);
                    }
                    // Derail containment: under HLE we don't deliver real interrupts to the game's own
                    // exception vector, so a watchdog-tripped / idle-spinning handler can leave EPC=0 (or
                    // garbage). Jumping there runs low-RDRAM junk and a wild store faults the host. A valid
                    // exception-return PC is nonzero, word-aligned, and points at an instruction; anything
                    // else is a derailed handler — abort this interpret call instead of following it.
                    if (s.target != 0 && (s.target & 3u) == 0 && looks_like_code(rdram, s.target)) {
                        s.is_jump = true; s.no_delay = true;
                    } else {
                        s.stop = true;
                    }
                    if (g_unimpl_count++ < 64)
                        fprintf(stderr, "[interp] ERET @0x%08X -> 0x%08X (sr=0x%08X)%s\n",
                                cur, s.target, sr, s.stop ? " [implausible -> abort]" : "");
                    break;
                }
                default:
                    if (g_unimpl_count++ < 64)
                        fprintf(stderr, "[interp] UNIMPL COP0 CO funct=0x%02X insn=0x%08X @0x%08X\n", funct, insn, cur);
                    break;
            }
            break;
        }
        // mfc0/mtc0: `rs` is the COP0 sub-opcode, `rd` is the COP0 register, `rt` is the GPR.
        // Mirror recompilation.cpp: Status (reg 12) goes through cop0_status_* (FR-bit handling),
        // every other reg goes through recomp_cop0_tlb_* (real TLB regs + a generic dummy file for
        // EPC/Cause/BadVaddr/Count/Compare/... which are HLE-inert but must read back what was written).
        switch (rs) {
            case 0x00: /* MFC0 — rt = CP0[rd] */
                if (rd == 12) { if (rt != 0) R[rt] = cop0_status_read(ctx); }
                else          { if (rt != 0) R[rt] = (gpr)(int32_t)recomp_cop0_tlb_read((int)rd); }
                break;
            case 0x04: /* MTC0 — CP0[rd] = rt */
                if (rd == 12) {
                    // [IE-rising edge 08-27] Hardware samples the interrupt line EVERY instruction,
                    // so the instant a critical section ends (Status.IE 0->1, EXL/ERL clear) any
                    // pending interrupt is taken. Our poll venue fires on a FIXED STRIDE of 16384
                    // instructions instead, which ALIASES against a fixed-length guest loop: SOTE's
                    // idle waits are __osDisableInt / check / __osRestoreInt loops, and the stride
                    // landed inside the interrupts-disabled window every single pass — delivery held
                    // forever, 100% CPU, pc parked at 0x800C3744 (measured, no-input boot).
                    // Note the edge here; the loop top takes it at a clean instruction boundary.
                    const uint32_t _sr_old = (uint32_t)cop0_status_read(ctx);
                    cop0_status_write(ctx, R[rt]);
                    const uint32_t _sr_new = (uint32_t)cop0_status_read(ctx);
                    if ((_sr_old & 0x1u) == 0u && (_sr_new & 0x1u) != 0u && (_sr_new & 0x6u) == 0u)
                        g_ie_rise = true;
                } else {
                    recomp_cop0_tlb_write((int)rd, (uint32_t)R[rt]);
                }
                break;
            default:
                if (g_unimpl_count++ < 64)
                    fprintf(stderr, "[interp] UNIMPL COP0 rs=0x%02X insn=0x%08X @0x%08X\n", rs, insn, cur);
                break;
        }
        break;
    }
    default:
        if (g_unimpl_count++ < 64)
            fprintf(stderr, "[interp] UNIMPL op=0x%02X insn=0x%08X @0x%08X\n", op, insn, cur);
        break;
    }
    R[0] = 0;
}

// Run the instruction in a delay slot (assumed not itself a control transfer).
inline void run_delay_slot(uint8_t* rdram, recomp_context* ctx, uint32_t addr) {
    uint32_t insn = fetch_instr(rdram, addr);
    Step ds{};
    g_interp_in_delayslot = true;
    exec_one(rdram, ctx, insn, addr, ds);
    g_interp_in_delayslot = false;
    if (ds.is_branch || ds.is_jump || ds.is_call) {
        if (g_unimpl_count++ < 64)
            fprintf(stderr, "[interp] WARN branch in delay slot @0x%08X insn=0x%08X\n", addr, insn);
    }
}

// Dispatch a call target: native if recompiled, else recurse into the interpreter.
// (do_call removed — calls are now flat within a session; see the is_call branch of the main loop.)

} // namespace

// Heuristic: does the vaddr hold something that plausibly starts a MIPS function?
// Overlays interleave code with data (pointer tables, rodata) at the same shared vaddrs;
// previously those misses were silently no-op'd. We only interpret when the first word
// looks like an instruction, not a data word, so we never regress the working boot path.
static bool looks_like_code(uint8_t* rdram, uint32_t addr) {
    uint32_t w = fetch_instr(rdram, addr);
    // Leading NOPs are real code (alignment padding folded into a symbol, hand-patched entry
    // stubs). drmario 2026-07-18: a DMA'd-overlay function starting with nop failed this gate
    // and get_function FATALED on a live jal. Skip up to 4 leading zero words and judge the
    // first non-zero one; an all-zero run is still data/padding.
    for (int nops = 0; w == 0 && nops < 4; nops++) {
        addr += 4;
        w = fetch_instr(rdram, addr);
    }
    if (w == 0) return false;                 // padding / NULL slot
    uint32_t top = w >> 24;
    // Reject only words that decode as PLAUSIBLE POINTER VALUES, not whole opcode ranges.
    // S44 run-3 lesson: MIPS load/store opcodes also live in 0x80-0xBF (lw $v0,0($a0) =
    // 0x8C820000, sw $a1,4($sp) = 0xAFA50004) — the old blanket 0x80-0xBF reject silently
    // no-op'd every dispatched function that STARTS with a load/store (leaf getters!),
    // which broke LoD's interpreted frame-DL build (million-NOOP black screen).
    //  - 0x0E/0x0F######: NI overlay-window pointers (the colliding encoding is a function
    //    STARTING with jal — implausible).
    //  - 0x80000000-0x807FFFFF: a valid KSEG0 RDRAM address (the colliding encodings are
    //    $zero-based lb/lh with nonsense operands — real code never starts that way).
    if (top == 0x0Eu || top == 0x0Fu) return false;
    if (w >= 0x80000000u && w < 0x80800000u) return false;
    return true;
}

// Exported probe so get_function can decide interpret-vs-fatal for unresolved
// KSEG0 targets (raw code overlays DMA'd into high RDRAM — the LoD class).
extern "C" int recomp_interp_is_code(uint8_t* rdram, uint32_t addr) {
    return looks_like_code(rdram, addr) ? 1 : 0;
}

// Per-fiber interp-depth swap (bare-metal fiber scheduler): g_interp_depth is a THREAD local,
// but fibers share the host thread — a fiber suspended mid-session leaves its increments stuck
// in the shared counter for every other fiber (observed: depth pinned at the 64 cap, all interp
// bailing while the pump ran). The scheduler swaps the counter at every fiber-switch boundary so
// each fiber sees only its own nesting.
extern "C" int recomp_interp_swap_depth(int new_depth) {
    int old = g_interp_depth;
    g_interp_depth = new_depth;
    return old;
}

// [depth-probe A] read-only peek for the scheduler's leak probes.
extern "C" int recomp_interp_peek_depth(void) { return g_interp_depth; }

// [venue-census 2026-08-06] The interpreter's LIVE pc — the address of the instruction the
// innermost session is about to execute. THREAD-local like g_interp_depth (fibers share the
// host thread), so a reader must gate on the CURRENT fiber's swapped-in depth being nonzero;
// a depth-0 read may see a pc some other fiber's session stored. Purpose: hardware latches
// EPC = the interrupted instruction at exception entry; drain venues that cannot name the
// live pc present a STALE EPC to the guest (defect B, COMPRESSED_CLASS_ROSTER.md 08-06).
static thread_local uint32_t g_interp_live_pc = 0;
extern "C" uint32_t recomp_interp_peek_pc(void) { return g_interp_live_pc; }
// [gt-pulse] cross-thread mirror of the game thread's interp pc, updated at poll cadence (every
// 16384 instructions) — a frozen value under a live VI thread means the game thread entered a
// NATIVE path that never returns to any venue; the frozen pc is the last interpreted site before
// it, which names the callee chain statically. Sampled 1Hz by the VI thread (events.cpp).
std::atomic<uint32_t> g_interp_pc_shared{0};
extern "C" uint32_t recomp_interp_pc_shared(void) { return g_interp_pc_shared.load(std::memory_order_relaxed); }

// [defect-B round 6, 2026-08-06] When the interpreter calls a NATIVE callee (the flat-call
// lookup hit), the callee executes with g_interp_live_pc FROZEN at the caller's jal. A drain
// venue firing inside that callee would latch EPC = the jal — a PAST instruction — and the
// guest's resume then RE-EXECUTES the call: a non-idempotent kernel primitive runs twice
// (measured on turok: osCreateThread re-entered mid-flight → double-enqueue → cyclic run
// queue → the __osEnqueueThread spin; the re-run's stores carried mid-callee register values
// = the fused 0x0C026020-class garbage). Venues must DEFER while this is nonzero.
// thread-local like the depth counter, NOT yet swapped per fiber: a fiber parked inside a
// native callee leaks its count to the next fiber on this host thread until it resumes —
// stale >0 only WIDENS deferral (delay, safe); stale 0 with a real native callee parked is
// the residual dishonest window — swap alongside interp_depth if the wedge shape demands it.
static thread_local int g_interp_native_call_depth = 0;
extern "C" int recomp_interp_in_native_callee(void) { return g_interp_native_call_depth; }
// Per-fiber swaps for the two companions of g_interp_depth (same law, same venues): a fiber
// parked mid-execution must not leak its live-pc / native-callee state to the next fiber on
// this host thread, or venues latch another fiber's truth (round 6's residual window).
extern "C" int recomp_interp_swap_native(int new_depth) {
    int old = g_interp_native_call_depth; g_interp_native_call_depth = new_depth; return old;
}
extern "C" uint32_t recomp_interp_swap_live_pc(uint32_t new_pc) {
    uint32_t old = g_interp_live_pc; g_interp_live_pc = new_pc; return old;
}
// fiber_proc's continuation chase calls natives outside this file — count them the same way.
extern "C" void recomp_interp_native_enter(void) { g_interp_native_call_depth++; }
extern "C" void recomp_interp_native_exit(void)  { g_interp_native_call_depth--; }

// [pc-ring 2026-08-06, defect-B round 10] env INTERP_TRACE_RING=<vaddr>: keep the last 64
// interpreted pcs (thread-local ring) and DUMP the path when a flat-call dispatches natively
// to that target — names the exact branch where an interp'd flow diverged into code it could
// never reach on hardware (turok: entry-less arrival at the exception complex's k0 cases).
// 4096, not 64: a derail INTO a data segment (rather than out of RDRAM) can run for thousands of
// interpreted instructions before anything notices, so a 64-entry window shows only the wreck and
// never the turn. Saikyou Habu Shougi 2026-09-08: all 64 entries were already inside the data.
// CALL RING. A pc ring answers "where did it end up"; it cannot answer "which call went wrong",
// because by the time execution is visibly in the weeds the return address was already garbage
// (Saikyou Habu Shougi 2026-09-08: ra=0x800B67D0, itself data, on the FIRST entry to the region).
// Record every transfer with its source, target and the ra in force, so the last entry whose
// target is real code names the call that returned into nowhere.
struct InterpCall { uint32_t from, to, ra; uint32_t kind; };   // kind: 0=call 1=jump
static thread_local InterpCall g_call_ring[512];
static thread_local uint32_t g_call_ring_n = 0;
static void call_push(uint32_t from, uint32_t to, uint32_t ra, uint32_t kind) {
    g_call_ring[g_call_ring_n++ & 511] = InterpCall{ from, to, ra, kind };
}
extern "C" void recomp_interp_callring_dump(const char* reason) {
    const uint32_t count = g_call_ring_n < 512u ? g_call_ring_n : 512u;
    const uint32_t start = g_call_ring_n < 512u ? 0u : g_call_ring_n - 512u;
    fprintf(stderr, "[call-ring] dump (%s): last %u transfers (oldest first)%c", reason, count, 0x0A);
    for (uint32_t i = 0; i < count; i++) {
        const InterpCall& c = g_call_ring[(start + i) & 511];
        fprintf(stderr, "  %s from=0x%08X to=0x%08X ra=0x%08X%c",
                c.kind ? "jump" : "CALL", c.from, c.to, c.ra, 0x0A);
    }
    fflush(stderr);
}

static thread_local uint32_t g_pc_ring[4096];
static thread_local uint32_t g_pc_ring_n = 0;
static uint32_t ring_target() {
    static uint32_t t = []() {
        const char* e = std::getenv("INTERP_TRACE_RING");
        return e ? (uint32_t)strtoul(e, nullptr, 0) : 0u;
    }();
    return t;
}
static void ring_push(uint32_t pc) { g_pc_ring[g_pc_ring_n++ & 4095] = pc; }
extern "C" void recomp_interp_ring_dump(const char* reason) {
    static int _rx = 0;
    if (_rx++ >= 4) return;
    uint32_t count = g_pc_ring_n < 4096 ? g_pc_ring_n : 4096;
    uint32_t start = g_pc_ring_n < 4096 ? 0 : g_pc_ring_n - 4096;
    fprintf(stderr, "[pc-ring] dump (%s): last %u interp pcs (oldest first):", reason, count);
    for (uint32_t i = 0; i < count; i++)
        fprintf(stderr, "%s0x%08X", (i % 8) ? " " : "\n  ", g_pc_ring[(start + i) & 4095]);
    fprintf(stderr, "\n");
    fflush(stderr);
}

static void ring_dump(uint32_t target) {
    static int _rd = 0;
    if (_rd++ >= 4) return;
    fprintf(stderr, "[pc-ring] #%d flat-call -> 0x%08X; last %u interp pcs (oldest first):\n",
            _rd, target, g_pc_ring_n < 4096 ? g_pc_ring_n : 4096);
    uint32_t count = g_pc_ring_n < 4096 ? g_pc_ring_n : 4096;
    uint32_t start = g_pc_ring_n < 4096 ? 0 : g_pc_ring_n - 4096;
    for (uint32_t i = 0; i < count; i++) {
        fprintf(stderr, "%s0x%08X", (i % 8) ? " " : "\n  ", g_pc_ring[(start + i) & 4095]);
    }
    fprintf(stderr, "\n");
    fflush(stderr);
}

// tl_interp_no_stop_ra: the next recomp_interpret call is an ERET-STYLE ENTRY (a jump to an EPC),
// not a function call — there is no caller to return to, so the pc==entry_ra session-end check
// must be disabled. Needed because a kernel may create loop-style tasks with saved ra == entry pc
// (SOTE tcb 0x80112A80: ra=EPC=0x800C0744), which made a call-contract session end before
// executing a single instruction. One-shot: consumed and cleared by the next entry.
static thread_local bool tl_interp_no_stop_ra = false;
extern "C" void recomp_interpret_mark_eret_entry(void) { tl_interp_no_stop_ra = true; }

extern "C" void recomp_interpret(uint8_t* rdram, recomp_context* ctx, uint32_t start_vaddr) {
    const bool no_stop_ra = tl_interp_no_stop_ra;
    tl_interp_no_stop_ra = false;
    if (!looks_like_code(rdram, start_vaddr)) {
        static thread_local uint64_t s_skip = 0;
        if (s_skip++ < 32)
            fprintf(stderr, "[interp] skip non-code 0x%08X word=0x%08X (acting as no-op)\n",
                    start_vaddr, fetch_instr(rdram, start_vaddr));
        return; // behaves like the old ni_stub_noop
    }
    if (g_interp_depth >= kMaxDepth) {
        fprintf(stderr, "[interp] depth limit (%d, cur=%d) hit at 0x%08X — bailing\n", kMaxDepth, g_interp_depth, start_vaddr);
        return;
    }
    // High-water tracker (leak-vs-legitimate-nesting discriminator): a slow monotonic climb over
    // minutes = a depth leak across fiber switches; a quick plateau = the guest's real call depth.
    {
        static thread_local int hw = 0;
        if (g_interp_depth > hw) {
            hw = g_interp_depth;
            if (hw >= 16 && (hw & (hw - 1)) == 0)   // log at powers of two from 16 up
                fprintf(stderr, "[interp] depth high-water %d (enter 0x%08X)\n", hw, start_vaddr);
        }
    }
    // Unwind-safe depth + start_vaddr bookkeeping: a BmFiberRedispatch (bare-metal eret
    // re-dispatch) unwinds interp sessions via C++ exception; the old manual decrement at the
    // function tail leaked one depth level per unwound session until the cap pinned at 64 and
    // every interp call bailed instantly (drains alive but the handler could never run).
    struct InterpScope {
        uint32_t prev_start;
        uint32_t prev_entry_ra;   // nested sessions must restore the OUTER session's return sentinel
        uint32_t sv_;
        InterpScope(uint32_t sv) : prev_start(g_interp_start_vaddr), prev_entry_ra(g_interp_entry_ra), sv_(sv) { g_interp_depth++; g_interp_start_vaddr = sv;
            g_guest_sessions.fetch_add(1, std::memory_order_relaxed);   // [guest-clock probe] session churn
        }
        ~InterpScope() {
            // [guest-clock probe] publish at session END too: if sessions are SHORT the
            // poll-cadence publish (every 16384 instructions) would never fire at all.
            g_guest_instr.store(tl_guest_instr, std::memory_order_relaxed);
            g_interp_start_vaddr = prev_start;
            g_interp_entry_ra    = prev_entry_ra;
            // [depth-probe B] a dtor about to underflow = this scope's increment was saved into a
            // DIFFERENT counter view than the one now current — the lost-decrement mirror of the
            // ghost increments seen pinning fiber slots. Names the session; do not clamp (the
            // negative residue must stay visible in the slots to be counted).
            if (g_interp_depth <= 0) {
                static thread_local int _ub = 0;
                if (_ub++ < 40)
                    fprintf(stderr, "[interp] UNBALANCED scope dtor (cur=%d) start=0x%08X\n", g_interp_depth, sv_);
            }
            g_interp_depth--;
        }
    } _interp_scope(start_vaddr);

    // returning here == return to caller; 1 is an impossible pc (unaligned), i.e. never stops
    const uint32_t entry_ra = no_stop_ra ? 1u : (uint32_t)ctx->r31;
    g_interp_entry_ra = entry_ra;   // publish for exec_one's indirect-jump guard (see its decl)
    uint32_t pc = start_vaddr;
    uint64_t budget = kInstrBudget;

    static thread_local uint64_t s_calls = 0;
    if (s_calls++ < 32)
        fprintf(stderr, "[interp] enter 0x%08X (ra=0x%08X depth=%d)\n", start_vaddr, entry_ra, g_interp_depth);

    // [fn-trace] guest function-entry tracer, interpreted venue: a session that STARTS at a listed vaddr
    // (RECOMP_FN_TRACE, alias INTERP_TRACE_FN — the 07-18 per-function argument trace, now shared with
    // the recompiled venue in recomp.cpp so one env var covers both). Flat jal entries and interp->native
    // dispatches are traced at the is_call branch of the main loop below.
    if (recomp_fn_trace_active()) recomp_fn_trace_hit(rdram, ctx, start_vaddr, (uint32_t)ctx->r31, "interp");

    // [poll-cadence 08-27] TRIED thread_local (cadence surviving across sessions — hardware samples
    // the interrupt line every instruction, so the session boundary is our artifact) and REVERTED
    // same-day: the venue then fired, but delivery still declined at the gate and pending climbed
    // to 8000+ with no behaviour change. The finding stands and is worth re-attempting AFTER the
    // gate is understood — as a local, the venue only ever fires inside a LONG session, so a guest
    // running many short sessions never reaches 16384 in one go. See dossier 08-27 ~13:00.
    uint64_t poll_tick = 0;
    // [pc-ring/derail 2026-08-26] Hoist the env check OUT of the hot loop. It was TWO guarded
    // static-init function calls per interpreted instruction, which slowed the interpreter enough
    // to move timing — an armed run stalled early where an unarmed one did not (seen on screen,
    // 03:18). An instrument must never change behaviour: one call per session, a plain bool in
    // the loop. See [[measured-vs-concluded]] — the arming itself was the variable.
    const bool ringOn = (ring_target() != 0u);
    for (;;) {
        // Session end = the guest RETURNED to the native caller: pc reached entry_ra AND the guest
        // $ra still names it (a MIPS return is always `jr $ra`). The ra qualifier matters in flat-
        // call mode: the session's pc now sweeps through in-session callees, and a callee body
        // merely PASSING through the entry_ra address (guest recursion into the session's own
        // caller) must not end the session.
        if (pc == entry_ra && (uint32_t)ctx->r31 == entry_ra) break;
        if (budget-- == 0) {
            // [budget-continue 2026-08-26] bare-metal: the break ABANDONED the rest of the guest
            // function (measured: the B1 zero-fill loop cut mid-flight at 0x80001304; with the
            // wave having eaten the guest scheduler, nothing could ever re-dispatch the loader —
            // 28,000 undeliverable VI drains later the transition was dead). Hardware has no
            // budget: the CPU keeps running and interrupts are serviced in-loop — which is what
            // the pump venue every 16K instructions below already provides. Renew and continue;
            // the break remains the non-bare-metal watchdog behavior.
            // SCOPED to the swap wave (2026-08-26 16:08): unconditional renewal broke the BOOT —
            // the session-end/fiber-return cycle is itself one of the model's drain venues, and the
            // intro starved to 2 flips total. The wave is the only era whose thread of control must
            // never be cut (no guest scheduler left to re-dispatch it); boot keeps the break.
            if (recomp_baremetal_enabled() && recomp_bm_wave_active()) {
                // [atomic-guard 08-27, LANE_UNIFICATION_PLAN.md] A budget break is a preemption
                // HARDWARE CANNOT PERFORM while the guest has interrupts off: the kernel wraps
                // its queue/scheduler mutations in osDisableInt exactly because nothing on
                // silicon can interrupt them. Parking mid-critical-section tore an enqueue
                // (menu corpse, oracle-diffed: worker st=WAITING queue=0x8013C2E0 while that
                // queue's waiter list says EMPTY — unwakeable; truth has the worker RUNNING).
                // With IE off or EXL/ERL set, renew and keep executing — the guest re-enables
                // interrupts in microseconds of guest time; the break waits for that edge.
                {
                    const uint32_t sr = (uint32_t)cop0_status_read(ctx);
                    if ((sr & 0x1u) == 0u || (sr & 0x6u) != 0u) {
                        static uint32_t _ag = 0;
                        ++_ag;
                        if (_ag <= 8 || (_ag % 5000u) == 0u) {
                            fprintf(stderr, "[atomic-guard] #%u budget wall inside IE-off window at 0x%08X (sr=0x%08X) — renewed, not parked\n", _ag, pc, sr);
                            fflush(stderr);
                        }
                        budget = kInstrBudget;
                        continue;
                    }
                }
                static uint32_t _br = 0;
                ++_br;
                if (_br <= 8 || (_br % 2000u) == 0u) {
                    fprintf(stderr, "[interp] budget renewed #%u at 0x%08X (start 0x%08X) — bare-metal continue\n", _br, pc, start_vaddr);
                    fflush(stderr);
                }
                recomp_bm_budget_break((uint32_t)pc);   // round 3: NOTE the break; the root pump
                break;                                   // redispatches this fiber at this pc after
                                                         // draining (renewal starved the pump: 0
                                                         // post-wave drains; the break IS the venue)
            } else {
                // [idle-renew 2026-09-05, Rage Wars #152] A bare-metal idle thread spins `j .` in the
                // interpreter at 4-6M iterations/s between interrupts (libultra's boot idiom: setpri 0,
                // then jump-to-self forever). The per-session budget therefore expires ~10-14 s into a
                // healthy run, and this non-wave branch used to BREAK the session: fiber_proc then chased
                // the idle thread's stale $ra into a KSEG0 alias of window code with the wrong register
                // file and the guest's current-task word became 0x00043F10 (measured twice: the 4-s wedge
                // before epc-wins, and the 22-s wedge after it, both `BUDGET exhausted at 0x00292F38`).
                // Hardware's idle loop simply keeps spinning until an interrupt; the interp-poll venue
                // every 16K instructions IS that interrupt delivery (HANDLER counted 60/s throughout),
                // so on an unconditional self-jump renew the budget and stay. Scoped to the self-loop
                // shape so SOTE's boot keeps its session-end drain venue on every other exhaustion.
                if (recomp_baremetal_enabled()) {
                    const uint32_t w = (uint32_t)MEM_W(0, pc);
                    const bool self_j  = ((w >> 26) == 2u) && ((((w & 0x03FFFFFFu) << 2) | ((uint32_t)pc & 0xF0000000u)) == (uint32_t)pc);
                    const bool self_b  = (w == 0x1000FFFFu) || (w == 0x0411FFFFu);   /* b . / bal . */
                    if (self_j || self_b) {
                        static uint32_t _ir = 0;
                        ++_ir;
                        if (_ir <= 8 || (_ir % 1000u) == 0u) {
                            fprintf(stderr, "[idle-renew] #%u budget exhausted on a self-loop at 0x%08X (insn 0x%08X) - renewed, still idling%c", _ir, pc, w, 0x0A);
                            fflush(stderr);
                        }
                        budget = kInstrBudget;
                        continue;
                    }
                }
                fprintf(stderr, "[interp] BUDGET exhausted at 0x%08X (start 0x%08X)\n", pc, start_vaddr);
                break;
            }
        }
        // Bare-metal pump venue: an interpreted spin/wait loop has no poll guard, so without this
        // a parked guest starves the interrupt drain forever (see recomp_baremetal_interp_poll).
        // Every 16384 instructions ≈ hardware-interrupt cadence at interp speeds; a no-op check
        // for non-bare-metal games.
        // [pc-trigger 2026-08-27] env RECOMP_PC_TRIGGER=<hexaddr>: first time the interpreter
        // executes the target pc, dump the FULL register file + the last pcs to stderr, then
        // continue. The engine-side twin of the cen64 oracle's EX-stage trigger — register-level
        // provenance without a debugger. Off = one cached compare per instruction.
        {
            static const uint32_t trig = []() {
                const char* e = std::getenv("RECOMP_PC_TRIGGER");
                return e ? (uint32_t)strtoul(e, nullptr, 16) : 0u;
            }();
            static bool fired = false;
            // [pc-trace 2026-08-27] RECOMP_PC_TRACE_N=<count>: after the trigger fires, log the
            // next N interpreted pcs (8/line). If the "done" marker never prints, execution left
            // the interpreter mid-window — the last line names the exit.
            static int64_t traceLeft = 0;
            static const int64_t traceN = []() {
                const char* e = std::getenv("RECOMP_PC_TRACE_N");
                return e ? (int64_t)strtoll(e, nullptr, 10) : 0;
            }();
            // RECOMP_PC_TRIGGER_HI turns the trigger into a RANGE: fire on the FIRST pc inside
            // [RECOMP_PC_TRIGGER, RECOMP_PC_TRIGGER_HI]. A derail into a data segment runs for many
            // thousands of instructions before anything notices, so an exact-pc trigger and even a
            // 4096-deep ring only ever show the wreck. Firing on ENTRY to the region catches the
            // instruction that jumped there, which is the whole question.
            static const uint32_t trig_hi = []() {
                const char* e = std::getenv("RECOMP_PC_TRIGGER_HI");
                return e ? (uint32_t)strtoul(e, nullptr, 16) : 0u;
            }();
            const bool trig_match = (trig_hi != 0u) ? (pc >= trig && pc <= trig_hi) : (pc == trig);
            if (trig != 0u && !fired && trig_match) {
                fired = true;
                traceLeft = traceN;
                const gpr* R = &ctx->r0;
                static const char* rn[32] = {"r0","at","v0","v1","a0","a1","a2","a3","t0","t1","t2","t3","t4","t5","t6","t7","s0","s1","s2","s3","s4","s5","s6","s7","t8","t9","k0","k1","gp","sp","fp","ra"};
                fprintf(stderr, "[pc-trigger] HIT 0x%08X — register file:%c", pc, 0x0A);
                for (int ri = 0; ri < 32; ri += 4)
                    fprintf(stderr, "  %s=%08X %s=%08X %s=%08X %s=%08X%c",
                        rn[ri], (uint32_t)R[ri], rn[ri+1], (uint32_t)R[ri+1],
                        rn[ri+2], (uint32_t)R[ri+2], rn[ri+3], (uint32_t)R[ri+3], 0x0A);
                // AND THE PATH IN. The register file alone says the context is already wrong (a
                // return address of 2, instruction words sitting in t7/s1/t9) but not WHERE it went
                // wrong. The ring holds the last 64 interpreted pcs, and its own derail dump only
                // fires for a pc OUTSIDE RDRAM - a derail INTO a data segment still inside RDRAM
                // (Saikyou Habu Shougi 2026-09-08, pc=0x800B4654) never reaches it. Dump it here too.
                if (std::getenv("INTERP_TRACE_RING") != nullptr) {
                    recomp_interp_ring_dump("pc-trigger");
                    recomp_interp_callring_dump("pc-trigger");
                // AND RDRAM AT THIS INSTANT. A dump taken at startup showed RAM identical to ROM,
                // but that proves nothing about the moment of failure - the region may be written
                // later. RECOMP_TRIGGER_RAMDUMP=<vaddr>:<bytes>:<path> captures it HERE, with
                // execution actually standing in the disputed region.
                if (const char* rd = std::getenv("RECOMP_TRIGGER_RAMDUMP")) {
                    unsigned long dv = 0, db = 0;
                    char dpath[512] = { 0 };
                    if (sscanf(rd, "%lx:%lx:%511s", &dv, &db, dpath) == 3 && db != 0) {
                        if (FILE* df = fopen(dpath, "wb")) {
                            const uint32_t phys = (uint32_t)dv & 0x7FFFFFu;
                            for (uint32_t k = 0; k < (uint32_t)db; k++) {
                                fputc(rdram[(phys + k) ^ 3], df);
                            }
                            fclose(df);
                            fprintf(stderr, "[trigger-ramdump] 0x%lX bytes from 0x%08lX -> %s\n", db, dv, dpath);
                            fflush(stderr);
                        }
                    }
                }
                }
                fflush(stderr);
            }
            if (traceLeft > 0) {
                static int col = 0;
                fprintf(stderr, "%s%08X", (col == 0) ? "[pc-trace] " : " ", pc);
                if (++col == 8) { fputc(0x0A, stderr); col = 0; }
                if (--traceLeft == 0) { fprintf(stderr, "%c[pc-trace] done%c", 0x0A, 0x0A); fflush(stderr); }
            }
        }
        g_interp_live_pc = pc;   // venue-census: the innermost session's live pc (see accessor
                                 // above); stored BEFORE the poll so a drain inside it reads
                                 // THIS instruction, not the previous iteration's
        if (ringOn) ring_push(pc);   // [pc-ring] path capture (env-gated)
        // ── [derail] (SOTE, 2026-08-26) — instrument only, armed by INTERP_TRACE_RING ────────────
        // A session that ends up outside RDRAM did not WALK there — it jumped, through a register
        // holding garbage. The budget guard above only reports where it finally ran out, thousands
        // of instructions later and far downstream of the cause. Catch the FIRST out-of-range pc,
        // print the live register file's return/stack pointers, and dump the pc ring — the last
        // in-range entries name the exact instruction that jumped. Motivating case: SOTE resumes a
        // thread mid-function at osRecvMesg's post-yield point 0x800BD338 and lands at 0x8FFFBFC4.
        if (ringOn) {
            const uint32_t derailPhys = pc & 0x1FFFFFFFu;
            if (derailPhys >= 0x00800000u) {
                static thread_local int derailReported = 0;
                if (derailReported < 4) {
                    derailReported++;
                    fprintf(stderr, "[derail] #%d session start=0x%08X LEFT RDRAM at pc=0x%08X (phys 0x%08X) | ra=0x%08X sp=0x%08X t1=0x%08X\n",
                            derailReported, start_vaddr, pc, derailPhys,
                            (uint32_t)ctx->r31, (uint32_t)ctx->r29, (uint32_t)ctx->r9);
                    fflush(stderr);
                    recomp_interp_ring_dump("first-out-of-RDRAM");
                }
            }
        }
        // [IE-rising edge 08-27] REVERTED SAME-DAY (measured: venue fired, delivery still declined
        // at the gate, pending climbed to 8761, rendering DROPPED 16s->7s). The edge note is still
        // taken in MTC0 and left unconsumed here — harmless, and ready if the gate is fixed first.
        ++tl_guest_instr;                                        // [guest-clock probe] retired (plain)
        if ((++poll_tick & 0x3FFFu) == 0u) { g_interp_pc_shared.store(pc, std::memory_order_relaxed); g_guest_instr.store(tl_guest_instr, std::memory_order_relaxed); recomp_baremetal_interp_poll(pc); }
        uint32_t insn = fetch_instr(rdram, pc);
        Step s{};
        exec_one(rdram, ctx, insn, pc, s);

        if (s.stop) {                         // derail contained (e.g. eret to a null/garbage PC)
            static thread_local uint64_t s_abort = 0;
            if (s_abort++ < 64)
                fprintf(stderr, "[interp] abort at 0x%08X (start 0x%08X) — derail contained\n", pc, start_vaddr);
            break;
        }
        if (s.is_call) {
            if (ringOn) call_push(pc, s.target, (uint32_t)ctx->r31, 0u);
            run_delay_slot(rdram, ctx, pc + 4);
            // FLAT CALLS (SOTE wall 4 round 3): recursing into a nested session for every guest
            // jal whose target has no native left one abandoned C frame per call whenever the
            // guest LEFT the callee by a context switch instead of a return (coroutine-styled
            // kernels: observed climbing to the depth cap in minutes, then every interp call
            // no-op'd and the world wedged). A call the interpreter will interpret anyway is
            // just a jump with a link register — exec_one already linked, so continue THIS
            // session inside the callee: zero stack growth, and a switch-out abandons nothing.
            // Native targets still nest natively (they are C functions; bounded by real
            // mixed-mode alternation, not guest call depth).
            recomp_func_t* nf = recomp_lookup_native(s.target);
            // [ghost-interleave] (2026-08-26, the interleave build): while the I-cache ghost is
            // armed, ghost-range calls STAY INTERPRETED even when a native twin exists. Two
            // reasons, both measured today: (1) the native twin executes the ~compile-time~ bytes
            // and walks live kernel data with UNGUARDED loops — the post-transition spin at
            // 0x800174B0 froze the game thread for good (holds stopped at #2, one frame-tick ever);
            // (2) the interpreter polls every 16,384 instructions, so interpreted execution IS the
            // preemption that lets the frame beat (DIRECT post → FRAME-TICK dispatch) interleave
            // with the wave's frame-synced stages — the schedule hardware gets from real interrupts.
            // Ghost fetch serves the same pre-wave bytes the native twin was compiled from, so
            // semantics are identical; only schedulability changes. Unarmed ghost = untouched path.
            if (nf != nullptr && g_icache_ghost != nullptr
                && s.target >= g_icache_ghost_lo && s.target < g_icache_ghost_hi) {
                // (14:06) the memcmp stale-only refinement is REVERTED: the 13:39 run — the only
                // one whose pump survived the wall — ran with ALWAYS-divert, and the interp
                // execution's polls ARE the pump's heartbeat. Slow interp'd fill is the price of
                // a live world; FF makes it tolerable. Original refinement text kept below, dead:
                // (08-27) the 14:06 edit left this body EMPTY — the twin kept running native and
                // every interp-side instrument went blind for a day. The divert must be actual:
                static int _gd2 = 0;
                ++_gd2;
                if (_gd2 <= 8 || (_gd2 % 20000) == 0) {
                    fprintf(stderr, "[ghost-interleave] #%d keeping 0x%08X interpreted (native twin bypassed)\n", _gd2, s.target);
                    fflush(stderr);
                }
                nf = nullptr;
            } else if (false
                // refinement (13:45): divert ONLY when the live bytes DIFFER from the ghost —
                // a stale twin. Code whose live bytes still match (the boot set: the loader's
                // giant zero-fill, the decompressor) is identical either way and must run NATIVE:
                // forcing it interpreted turned a ~50ms hardware clear into a 30s crawl and made
                // the by-design transition look like a runaway sweep.
                && memcmp(g_icache_ghost + (s.target - g_icache_ghost_lo),
                          rdram + (uint32_t)(s.target - 0x80000000u), 16) != 0) {
                static int _gi = 0;
                ++_gi;
                if (_gi <= 8 || (_gi % 20000) == 0) {
                    fprintf(stderr, "[ghost-interleave] #%d keeping 0x%08X interpreted (native twin bypassed)\n", _gi, s.target);
                    fflush(stderr);
                }
                nf = nullptr;
            }
            if (nf != nullptr) {
                if (ringOn && s.target == ring_target()) ring_dump(s.target);
                // RAII: BmFiberRedispatch unwinds through native callees — the counter must
                // rebalance on that path too (defect-B round 6, see accessor above).
                const int _base_depth = g_interp_native_call_depth;   // [edge-retake] fiber_proc brackets a whole
                                                                      // interp session at depth 1 -- compare to
                                                                      // the depth OUTSIDE this callee, not to 0
                {
                struct NativeScope {
                    NativeScope()  { g_interp_native_call_depth++; }
                    ~NativeScope() { g_interp_native_call_depth--; }
                } _ns;
                if (recomp_fn_trace_active()) { recomp_fn_trace_hit(rdram, ctx, s.target, (uint32_t)(pc + 8u), "interp->native"); recomp_fn_trace_expect_mark(s.target); }   // [fn-trace]
                nf(rdram, ctx);
                recomp_fn_trace_expect_mark(0);   // [fn-trace] the callee had no mark: drop the latch
                }
                pc += 8;                      // native callee returned; resume after the delay slot
                // [edge-retake 2026-09-03] an IE-rising / mask edge fired INSIDE that callee and was deferred
                // (no representable EPC in native code). The callee has returned: THIS pc is a legal interrupted
                // pc with a coherent file -- take it now, as hardware already would have. (1080: osYieldThread's
                // __osRestoreInt runs native beneath an interp frame -- 25M deferrals/min, 0 deliveries; the
                // every-16K-instruction poll never reaches a ten-instruction loop.)
                static const bool _er_on = [] { const char* e = getenv("RECOMP_BM_EDGERETAKE"); return !(e && e[0] == '0'); }();   // off-instrument for bisects
                if (_er_on && recomp_bm_edge_deferred != 0 && g_interp_native_call_depth == _base_depth) {
                    recomp_bm_edge_deferred = 0;
                    recomp_baremetal_interp_poll(pc);
                }
            } else {
                budget = kInstrBudget;        // a progressing (calling) guest re-arms the runaway watchdog
                if (recomp_fn_trace_active()) recomp_fn_trace_hit(rdram, ctx, s.target, (uint32_t)(pc + 8u), "interp-flat");   // [fn-trace]
                pc = s.target;
            }
        } else if (s.is_branch) {
            if (s.likely && !s.taken) {
                pc += 8;                      // branch-likely: delay slot nullified
            } else {
                // [loopff 2026-09-02, DKR] a taken BNE whose target is the instruction just before it, where that
                // instruction is `addiu rc,rc,imm` and the delay slot is a nop, is a pure counting delay loop
                // (`for (v0=0; v0!=v1; v0+=4)`). Hardware burns the cycles; interpreting them one at a time
                // turned a ~0.2 s calibration into minutes (2.2B interpreted instrs). Solve it: counter = limit,
                // charge n*3 instructions to the guest clock, fall out past the delay slot. Register-only, so exact.
                static const bool _loopff = [] { const char* e = getenv("RECOMP_INTERP_LOOPFF"); return !(e && e[0] == '0'); }();
                if (_loopff && s.taken && s.target == pc - 4u && (insn >> 26) == 0x05u) {
                    const uint32_t head = fetch_instr(rdram, pc - 4u), slot = fetch_instr(rdram, pc + 4u);
                    if (slot == 0u && (head >> 26) == 0x09u && ((head >> 21) & 31u) == ((head >> 16) & 31u)) {
                        const uint32_t rc = (head >> 16) & 31u; const int32_t step = (int32_t)(int16_t)(head & 0xFFFFu);
                        const uint32_t brs = (insn >> 21) & 31u, brt = (insn >> 16) & 31u;
                        const uint32_t rl = (brs == rc) ? brt : (brt == rc) ? brs : 32u;
                        if (rc != 0u && rl != 32u && rl != rc && step != 0) {
                            gpr* Rf = &ctx->r0;
                            const uint32_t c = (uint32_t)Rf[rc], l = (uint32_t)Rf[rl];
                            uint64_t n = 0; bool ok = false;
                            if (step > 0) { const uint32_t d = l - c, su = (uint32_t)step;  if (d % su == 0u) { n = d / su; ok = true; } }
                            else          { const uint32_t d = c - l, su = (uint32_t)(-step); if (d % su == 0u) { n = d / su; ok = true; } }
                            if (ok && n > 0u) {
                                Rf[rc] = (gpr)(int32_t)l;
                                tl_guest_instr += n * 3u;
                                static uint64_t _lf = 0; ++_lf;
                                if (_lf <= 20u || (_lf % 1000u) == 0u) {
                                    fprintf(stderr, "[loopff] #%llu pc=0x%08X counter r%u 0x%08X -> limit r%u 0x%08X step %d: skipped %llu iterations%c",
                                            (unsigned long long)_lf, (uint32_t)pc, rc, c, rl, l, step, (unsigned long long)n, 0x0A);
                                    fflush(stderr);
                                }
                                pc += 8u;
                                continue;
                            }
                        }
                    }
                }
                run_delay_slot(rdram, ctx, pc + 4);
                pc = s.taken ? s.target : (pc + 8);
            }
        } else if (s.is_jump) {
            if (ringOn) call_push(pc, s.target, (uint32_t)ctx->r31, 1u);
            if (!s.no_delay) run_delay_slot(rdram, ctx, pc + 4); // eret has no delay slot
            pc = s.target;                    // jr to entry_ra → loop-top break next iter
        } else {
            pc += 4;
        }
    }
    // depth/start_vaddr restored by _interp_scope (unwind-safe — see its comment).
}

// ── Trampoline so get_function can hand back a recomp_func_t* on a miss ────────────────
// get_function sets the target vaddr (thread-local) immediately before returning this;
// LOOKUP_FUNC calls the returned pointer on the very next statement, same thread, so the
// handoff is race-free.
thread_local uint32_t g_interp_pending_target = 0;

extern "C" void recomp_interp_set_target(uint32_t vaddr) { g_interp_pending_target = vaddr; }

extern "C" void recomp_interp_trampoline(uint8_t* rdram, recomp_context* ctx) {
    recomp_interpret(rdram, ctx, g_interp_pending_target);
}

// ── Live-JIT guest-memory shims ────────────────────────────────────────────────────────
// The live-gap JIT emits a call to one of these for EVERY guest load/store
// (live_generator.cpp do_load_op/do_unaligned_load_op/do_store_call), so JIT'd code's
// memory semantics are BY CONSTRUCTION identical to this interpreter and to static
// recomp output: all three expand the same recomp.h macros (CV64_PHYS virtual->physical
// translation, LOAD_W/STORE_W MMIO device windows, open-bus, byte-order XOR, and the
// do_lwl/do_lwr/do_ldl/do_ldr merges). Where the interpreter deviates from the static
// contract, the shims follow STATIC (cgenerator routes SWC1 through STORE_W; the
// interpreter's SWC1 uses bare MEM_W): static output is the product path the JIT stands
// in for. The nc_tcb_watch store diagnostic is interpreter-only and not mirrored here.
#include "recompiler/live_recompiler.h"

// ── INSTRUMENTS ARE OFF UNLESS ASKED FOR ────────────────────────────────────────────────────────
// THE RULE: an environment gate is a game-specific hack by another name. That applies to
// BEHAVIOUR; the same law says ENV VARS ARE INSTRUMENTS. These are instruments, and they were not
// gated at all: a 20-second run of Turok 1 on 2026-09-08 wrote 20,225 lines from eight of them, to
// a file, unasked. That slows every shipped game, fills a user's disk, and breaks the project's own
// rule that an eyes verdict needs a clean run with all instruments off. Cached is pointless here -
// the call only happens when a rate limiter has already decided to print.
static bool rc_trace_on(const char* var) {
    const char* v = std::getenv(var);
    return v != nullptr && v[0] != '\0' && v[0] != '0';
}

namespace {

uint64_t jit_lw (uint8_t* rdram, uint64_t vaddr) { return (uint64_t)LOAD_W(0, (gpr)vaddr); }
uint64_t jit_lwu(uint8_t* rdram, uint64_t vaddr) { return (uint64_t)(uint32_t)LOAD_W(0, (gpr)vaddr); }
uint64_t jit_lh (uint8_t* rdram, uint64_t vaddr) { return (uint64_t)(gpr)(int32_t)(int16_t)MEM_H(0, (gpr)vaddr); }
uint64_t jit_lhu(uint8_t* rdram, uint64_t vaddr) { return (uint64_t)(gpr)(uint16_t)MEM_HU(0, (gpr)vaddr); }
uint64_t jit_lb (uint8_t* rdram, uint64_t vaddr) { return (uint64_t)(gpr)(int32_t)(int8_t)MEM_B(0, (gpr)vaddr); }
uint64_t jit_lbu(uint8_t* rdram, uint64_t vaddr) { return (uint64_t)(gpr)(uint8_t)MEM_BU(0, (gpr)vaddr); }
uint64_t jit_ld (uint8_t* rdram, uint64_t vaddr) { return (uint64_t)LD(0, (gpr)vaddr); }

uint64_t jit_lwl(uint8_t* rdram, uint64_t vaddr, uint64_t initial) { return (uint64_t)do_lwl(rdram, (gpr)initial, 0, (gpr)vaddr); }
uint64_t jit_lwr(uint8_t* rdram, uint64_t vaddr, uint64_t initial) { return (uint64_t)do_lwr(rdram, (gpr)initial, 0, (gpr)vaddr); }
uint64_t jit_ldl(uint8_t* rdram, uint64_t vaddr, uint64_t initial) { return (uint64_t)do_ldl(rdram, (gpr)initial, 0, (gpr)vaddr); }
uint64_t jit_ldr(uint8_t* rdram, uint64_t vaddr, uint64_t initial) { return (uint64_t)do_ldr(rdram, (gpr)initial, 0, (gpr)vaddr); }

void jit_sw (uint8_t* rdram, uint64_t vaddr, uint64_t value) { STORE_W(0, (gpr)vaddr, (int32_t)value); }
void jit_sh (uint8_t* rdram, uint64_t vaddr, uint64_t value) { MEM_H(0, (gpr)vaddr) = (int16_t)value; }
void jit_sb (uint8_t* rdram, uint64_t vaddr, uint64_t value) { MEM_B(0, (gpr)vaddr) = (int8_t)value; }
void jit_sd (uint8_t* rdram, uint64_t vaddr, uint64_t value) { SD(value, 0, (gpr)vaddr); }
void jit_swl(uint8_t* rdram, uint64_t vaddr, uint64_t value) { do_swl(rdram, 0, (gpr)vaddr, (gpr)value); }
void jit_swr(uint8_t* rdram, uint64_t vaddr, uint64_t value) { do_swr(rdram, 0, (gpr)vaddr, (gpr)value); }
void jit_sdl(uint8_t* rdram, uint64_t vaddr, uint64_t value) { do_sdl(rdram, 0, (gpr)vaddr, (gpr)value); }
void jit_sdr(uint8_t* rdram, uint64_t vaddr, uint64_t value) { do_sdr(rdram, 0, (gpr)vaddr, (gpr)value); }

// Install at static-init: the table is zero-initialized (static storage) before any
// dynamic initializer runs, and JIT emission only happens at runtime long after.
struct LiveJitMemOpsInstaller {
    LiveJitMemOpsInstaller() {
        recomp_live_jit_mem_ops.lw  = jit_lw;
        recomp_live_jit_mem_ops.lwu = jit_lwu;
        recomp_live_jit_mem_ops.lh  = jit_lh;
        recomp_live_jit_mem_ops.lhu = jit_lhu;
        recomp_live_jit_mem_ops.lb  = jit_lb;
        recomp_live_jit_mem_ops.lbu = jit_lbu;
        recomp_live_jit_mem_ops.ld  = jit_ld;
        recomp_live_jit_mem_ops.lwl = jit_lwl;
        recomp_live_jit_mem_ops.lwr = jit_lwr;
        recomp_live_jit_mem_ops.ldl = jit_ldl;
        recomp_live_jit_mem_ops.ldr = jit_ldr;
        recomp_live_jit_mem_ops.sw  = jit_sw;
        recomp_live_jit_mem_ops.sh  = jit_sh;
        recomp_live_jit_mem_ops.sb  = jit_sb;
        recomp_live_jit_mem_ops.sd  = jit_sd;
        recomp_live_jit_mem_ops.swl = jit_swl;
        recomp_live_jit_mem_ops.swr = jit_swr;
        recomp_live_jit_mem_ops.sdl = jit_sdl;
        recomp_live_jit_mem_ops.sdr = jit_sdr;
    }
};
LiveJitMemOpsInstaller s_live_jit_mem_ops_installer;

} // namespace
