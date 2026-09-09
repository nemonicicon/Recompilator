// ── N64 TLB (LLE) ────────────────────────────────────────────────────────────
// True low-level emulation of the VR4300 TLB, used by CV64 to map Nisitenma-Ichigo
// overlays into the KUSEG window (0x0F000000 / 0x0E000000) per entity.
//
// PHASE 1 (current): state + populate only. The recompiler now emits real cop0
// TLB-register writes and `tlbwi`/`tlbwr`/`tlbp`/`tlbr`, which land here and keep
// a faithful 32-entry TLB. Address translation (recomp_tlb_translate) is still a
// FLAT physical map (vaddr & 0x1FFFFFFF) so behavior is unchanged vs. the old
// CV64_PHYS macro. Phase 2 will route KUSEG accesses through g_tlb.
//
// Hardware reference (VR4300):
//   - 32 entries. Each maps one (VPN2, PageMask) pair to two physical pages:
//     EntryLo0 = even page, EntryLo1 = odd page (PFN<<6 | flags: G/V/D/C).
//   - cop0 regs: Index(0) Random(1) EntryLo0(2) EntryLo1(3) PageMask(5)
//     Wired(6) EntryHi(10).

#include <atomic>
#include <cstdint>
#include <cstdio>
#include <cstdlib>

// [lowvawho] (2026-08-28, KI Gold): name the NATIVE function that is dereferencing a near-null
// guest pointer. Same mechanism as overlays.cpp's [gapcaller] walk — scan the host stack for
// return addresses inside the game exe and print their RVAs, which resolve against <game>pc.map.
// Env-gated (RECOMP_LOWVA_WHO=1), capped, default-silent: an instrument, never a behavior change.
#ifdef _WIN32
#include <windows.h>
#include <winternl.h>
#include <intrin.h>

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
#endif

// Count (cop0 reg 9) is the VR4300 free-running cycle counter, sourced from the same monotonic host
// clock osGetCount/osGetTime use (timer.cpp, 46.875 MHz-equivalent). See recomp_cop0_tlb_read reg 9.
extern "C" uint32_t osGetCount();
// COMPARE (reg 11) writes re-arm the bare-metal deadline waiter (baremetal_sched.cpp) so the timer
// line (Cause IP7) is delivered at the programmed deadline instead of the next RCP note. Inert for
// non-bm titles (the waiter gates on bm-enabled + autobm).
extern "C" void recomp_baremetal_compare_write(uint32_t value);
// CAUSE (reg 13) composition, below. The RCP interrupt line (Cause IP2) is asserted while any
// MI source is BOTH pending and unmasked — the same two registers mmio.cpp already models.
extern "C" uint32_t recomp_mi_intr_pending();
extern "C" uint32_t recomp_mi_intr_mask();
// recomp.cpp: the guest function currently executing on this thread (EMIT_WATCH builds; 0 else).
// Reliable HERE because CV64_PHYS calls us from inside the accessing function, after its entry mark.
extern "C" uint32_t recomp_current_guest_func();

namespace {
struct TlbEntry {
    uint32_t entryHi;    // VPN2 | ASID
    uint32_t pageMask;   // page size mask
    uint32_t entryLo0;   // PFN0<<6 | flags (even page)
    uint32_t entryLo1;   // PFN1<<6 | flags (odd page)
    bool     valid;
};

constexpr int TLB_ENTRIES = 32;
TlbEntry g_tlb[TLB_ENTRIES] = {};

// Set when the guest arms the CP0 timer by writing COMPARE (reg 11); read by the CAUSE (reg 13)
// composition to decide whether IP7 may assert. Never armed => a game that does not use the CP0
// timer can never see a spurious timer bit.
bool g_cop0_timer_armed = false;

// cop0 TLB-related registers (global hardware state)
uint32_t g_cop0_index    = 0;                  // reg 0
uint32_t g_cop0_random   = TLB_ENTRIES - 1;    // reg 1
uint32_t g_cop0_entrylo0 = 0;                  // reg 2
uint32_t g_cop0_entrylo1 = 0;                  // reg 3
uint32_t g_cop0_pagemask = 0;                  // reg 5
uint32_t g_cop0_wired    = 0;                  // reg 6
uint32_t g_cop0_entryhi  = 0;                  // reg 10
// Generic backing for the remaining COP0 registers (EPC/Cause/BadVaddr/Context/Compare/...).
// These are exception-state regs that are meaningless under HLE (librecomp replaces the
// exception path), but a recompiled libultra handler may still read/write them, so back them
// with a plain register file so write-then-read is consistent.
uint32_t g_cop0_misc[32]  = {};

void tlb_commit(int index) {
    if (index < 0 || index >= TLB_ENTRIES) return;
    g_tlb[index].entryHi  = g_cop0_entryhi;
    g_tlb[index].pageMask = g_cop0_pagemask;
    g_tlb[index].entryLo0 = g_cop0_entrylo0;
    g_tlb[index].entryLo1 = g_cop0_entrylo1;
    g_tlb[index].valid    = true;
    static int dbg = 0;
    if (dbg++ < 96) {
        fprintf(stderr, "[tlb] write idx=%d hi=0x%08X mask=0x%08X lo0=0x%08X lo1=0x%08X\n",
                index, g_cop0_entryhi, g_cop0_pagemask, g_cop0_entrylo0, g_cop0_entrylo1);
        fflush(stderr);
    }
}
} // namespace

extern "C" uint32_t recomp_interp_peek_pc(void);
extern "C" void recomp_bm_epc_restore_hook(void);   // baremetal_sched: latch k0 = the dispatcher's TCB
extern "C" void recomp_cop0_tlb_write(int reg, uint32_t value) {
    // [epc-writers] bounded trace (turok2 Count-in-EPC dig 2026-08-06): name every writer of
    // the EPC cell — the guest's exception save stores whatever sits here into TCB+0x11C,
    // and a Count-shaped value was observed there. Remove once the writer is named.
    if (reg == 14) {
        static int _ew = 0;
        if (_ew++ < 96) {
            if (rc_trace_on("RECOMP_EPC_WRITERS")) fprintf(stderr, "[epc-writers] #%d EPC <- 0x%08X (interp pc 0x%08X)\n",
                    _ew, value, recomp_interp_peek_pc());
            fflush(stderr);
        }
        // A guest EPC restore is the dispatcher naming its thread: every libultra-family
        // dispatcher does `lw kX, savedPC(TCB); mtc0 kX, $14` with k0 = the TCB still live,
        // then clobbers k0 with the MI address before eret (turok2 decode 2026-08-06). Latch
        // k0 NOW so the eret venue can identify the thread the guest actually dispatched.
        recomp_bm_epc_restore_hook();
    }
    switch (reg) {
        case 0:  g_cop0_index    = value; break;
        case 1:  g_cop0_random   = value; break;
        case 2:  g_cop0_entrylo0 = value; break;
        case 3:  g_cop0_entrylo1 = value; break;
        case 5:  g_cop0_pagemask = value; break;
        case 6:  g_cop0_wired    = value; break;
        case 10: g_cop0_entryhi  = value; break;
        default: g_cop0_misc[reg & 31] = value; break; // EPC/Cause/BadVaddr/... dummy register file
    }
    // COMPARE (reg 11) write == the hardware ACK of the CP0 timer interrupt: it deasserts IP7 and
    // arms the next deadline. Without the ack a handler that services the tick would re-enter
    // immediately, because CAUSE (reg 13) recomputes IP7 from Count-vs-Compare on every read.
    if (reg == 11) g_cop0_timer_armed = true;
    if (reg == 11) recomp_baremetal_compare_write(value);   // re-arm the deadline waiter
    // ── [timertrace] COMPARE-write probe (SOTE sequencer dig, 2026-07-19; RECOMP_TIMER_TRACE=1) ──
    // The SOTE-class kernel paces its timer list off the CP0 COMPARE interrupt (arm routine:
    // compare = count + interval; IP7 handler acks by rewriting COMPARE and posts service code 3).
    // Log the arm cadence + programmed interval so the delivered tick rate can be compared against
    // the guest's request. delta/46.875 = interval in µs at the VR4300 half-clock.
    if (reg == 11) {
        static int _tt_on = -1;
        if (_tt_on < 0) { const char* e = getenv("RECOMP_TIMER_TRACE"); _tt_on = (e && *e && *e != '0') ? 1 : 0; }
        if (_tt_on) {
            static int _n = 0;
            _n++;
            if (_n <= 40 || (_n % 200) == 0) {
                uint32_t now = osGetCount();
                int32_t delta = (int32_t)(value - now);
                fprintf(stderr, "[timertrace] COMPARE write #%d val=0x%08X count=0x%08X delta=%d (%.1f us)\n",
                        _n, value, now, delta, (double)delta / 46.875);
                fflush(stderr);
            }
        }
    }
}

extern "C" uint32_t recomp_cop0_tlb_read(int reg) {
    switch (reg) {
        case 0:  return g_cop0_index;
        case 1:  return g_cop0_random;
        case 2:  return g_cop0_entrylo0;
        case 3:  return g_cop0_entrylo1;
        case 5:  return g_cop0_pagemask;
        case 6:  return g_cop0_wired;
        // Count (reg 9): the cycle counter. Games read it via raw `mfc0 $9` for frame delta-timing,
        // RNG seeds, profilers, and busy-wait loops (`while (Count < target)`). The old default routed
        // it to the dummy register file below, where it stayed FROZEN (only `mtc0` ever wrote it) —
        // disconnected from the real clock, so delta-timing read 0 and busy-waits could spin forever.
        // Source it from the same monotonic host clock as the osGetCount/osGetTime HLE (timer.cpp). This
        // is the read path for BOTH recompiled code and the interpreter (recomp_interp.cpp). General/
        // hardware-faithful; the curated baselines (sm64/cv64/snowkids) never read reg 9, so unaffected.
        case 9:  return osGetCount();
        case 10: return g_cop0_entryhi;
        // ── CAUSE (reg 13): compose the LIVE interrupt-pending bits ──────────────────────────────
        // An exception handler exists to read this register: it is how the guest learns WHY it was
        // entered. It used to fall to the dummy file below, frozen at whatever `mtc0` last wrote —
        // so a game running its OWN __osException (the LLE runtime) dispatched on a stale word and
        // could not tell an RCP interrupt from a timer tick. Hardware drives the IP bits from the
        // interrupt lines, so compose them from the state we already model:
        //   IP2 (0x0400) — the RCP line: asserted while any MI source is pending AND unmasked.
        //                  Same two registers mmio.cpp keeps, and the same bit baremetal_sched
        //                  hands its dispatcher (g_cause = 0x400, "the stock-libultra dispatch bit").
        //   IP7 (0x8000) — the CP0 timer: set once Count has passed Compare, cleared when the guest
        //                  re-arms by writing Compare (the hardware ack, see the write path).
        // Bits the guest itself owns (IP0/IP1 software interrupts, and the ExcCode field it may have
        // staged) are preserved from the register file and OR'd through, so a handler that raises a
        // software interrupt still sees it.
        case 13: {
            uint32_t cause = g_cop0_misc[13] & ~0x0000C400u;   // keep SW bits + ExcCode, drop IP2/IP7
            if (recomp_mi_intr_pending() & recomp_mi_intr_mask()) cause |= 0x00000400u;   // IP2: RCP
            if (g_cop0_timer_armed) {
                // Count wraps at 32 bits; the signed delta is the wrap-correct "has it passed" test.
                if ((int32_t)(osGetCount() - g_cop0_misc[11]) >= 0) cause |= 0x00008000u; // IP7: timer
            }
            return cause;
        }
        default: return g_cop0_misc[reg & 31]; // EPC/BadVaddr/... dummy register file
    }
}

extern "C" void recomp_tlbwi(void) {
    tlb_commit((int)(g_cop0_index & 0x3F));
}

extern "C" void recomp_tlbwr(void) {
    // VR4300: TLBWR writes the entry indexed by Random -- a READ-ONLY register that decrements every
    // cycle and wraps back to TLB_ENTRIES-1 when it reaches Wired. g_cop0_random was a plain cell that
    // NOTHING ever advanced (initialised to 31; only an mtc0 no game issues could change it), so every
    // tlbwr overwrote entry 31 and a demand-paging kernel could keep exactly ONE page resident.
    // Measured on GoldenEye 007 #19 (2026-09-06): its pager sets Wired = 2 and refills through tlbwr,
    // so all 30 non-wired entries collapsed onto one slot. Advance Random over [Wired, 31] as hardware
    // does. Games that map with tlbwi (osMapTLB and every overlay window) are untouched.
    uint32_t wired = g_cop0_wired & 0x3Fu;
    if (wired >= (uint32_t)TLB_ENTRIES) wired = 0u;
    uint32_t idx = g_cop0_random & 0x3Fu;
    if (idx < wired || idx >= (uint32_t)TLB_ENTRIES) idx = (uint32_t)(TLB_ENTRIES - 1);
    tlb_commit((int)idx);
    g_cop0_random = (idx <= wired) ? (uint32_t)(TLB_ENTRIES - 1) : (idx - 1u);
}

extern "C" void recomp_tlbp(void) {
    uint32_t vpn2 = g_cop0_entryhi & 0xFFFFE000u;
    for (int i = 0; i < TLB_ENTRIES; i++) {
        if (g_tlb[i].valid && (g_tlb[i].entryHi & 0xFFFFE000u) == vpn2) {
            g_cop0_index = (uint32_t)i;
            return;
        }
    }
    g_cop0_index = 0x80000000u; // probe miss (P bit)
}

extern "C" void recomp_tlbr(void) {
    int i = (int)(g_cop0_index & 0x3F);
    if (i < 0 || i >= TLB_ENTRIES) return;
    g_cop0_entryhi  = g_tlb[i].entryHi;
    g_cop0_pagemask = g_tlb[i].pageMask;
    g_cop0_entrylo0 = g_tlb[i].entryLo0;
    g_cop0_entrylo1 = g_tlb[i].entryLo1;
}

// ── P2 scaffold ───────────────────────────────────────────────────────────────
// Install a faithful TLB entry for [vaddr, vaddr+size) → [paddr, ...]. Called from
// our HLE mapOverlay per dispatch so the TLB is POPULATED the way the real
// mapOverlay→osMapTLB chain would (which is still HLE'd). Produces the same raw
// EntryHi/PageMask/EntryLo0/EntryLo1 format as recomp_tlbwi from real game code,
// so P3's recomp_tlb_translate can decode either source uniformly.
// Reuses the existing slot for a VPN2 (per-entity context switch), else allocates.
// [ovlres] diagnostic: expose the overlay-window (0x0E/0x0F) TLB slot's current target
// buffer + a monotonic re-map counter. The GPU (rt64 fromSegmentedMasked) reads the SAME
// single slot asynchronously, so logging these on the GPU side proves it resolves overlay
// geometry against a stale (last-mapped) buffer instead of the one that built each draw.
extern "C" { volatile uint32_t g_ovl_cur_buffer = 0u; volatile uint32_t g_ovl_map_count = 0u; }

// SESSION 28 cont.13 — OVERLAY-BUFFER REGISTRY: the render-collision fix.
// All NI overlays share vaddr 0x0F000000 through ONE TLB slot (g_ovl_cur_buffer = the LAST overlay
// mapped). But the GPU walks a frame DL whose 0x0F refs belong to MANY overlays — each figure's model
// DL (and its internal 0x0F sub-DL / root refs) lives inside its OWN decompressed buffer [paddr,paddr+size).
// Register every overlay buffer range as mapOverlay maps it, and let the GPU resolver find the buffer that
// CONTAINS the DL it is currently walking (recomp_overlay_base_for) and resolve 0x0F+off against THAT
// overlay's base. Correct-by-construction for EVERY 0x0F ref (figures AND root sub-DLs) — no shared-slot
// collision, and (unlike binding seg 0x0F) it never touches refs outside an overlay buffer.
namespace {
    // cont.39: `win` = the 0x0E/0x0F overlay-window vaddr this buffer is TLB-mapped at
    // (0 = plain asset-file buffer registered by the mapOverlay scan, never window-mapped).
    // Lets get_function resolve a KSEG0 pointer INTO the buffer to the window vaddr where
    // the recompiled functions are registered (hardware KSEG0 aliasing, see overlays.cpp).
    struct OvlRange { uint32_t base; uint32_t end; uint32_t win; };
    constexpr int CV64_OVL_MAX = 320;   // cont.36: holds ALL loaded NI file buffers (~255) for the container path
    OvlRange cv64_ovl_ranges[CV64_OVL_MAX];
    volatile int cv64_ovl_range_count = 0;   // x86: append writes fields THEN count (stores are ordered)
    uint32_t cv64_ovl_cache_base = 0u, cv64_ovl_cache_end = 0u;   // cont.36 perf cache (namespace so the rebuild can invalidate it)

    // cont.39 [ovlgran] Bug-C SCOPING: how many DISTINCT 0x0F-window buffers does the shared slot take
    // per FRAME (between gfx tasks)? 1 => per-task staging would fix Option D; many => per-entity (the wall).
    uint32_t cv64_gran_set[128];
    int cv64_gran_count = 0;     // distinct buffers this frame
    int cv64_gran_overflow = 0;  // distinct buffers beyond the 128 cap
    int cv64_gran_maps = 0;      // total 0x0F maps this frame (incl. repeats)
}

// cont.36 — accumulation fix: clear the registry so mapOverlay can REBUILD it from the CURRENT loaded
// files each scan. Without this it only ever grows → stale ranges for unloaded/reused buffers → resolution
// rots over time (the progressive corruption after boss deaths). Invalidates the perf cache too.
extern "C" void cv64_clear_overlay_ranges() {
    cv64_ovl_range_count = 0;
    cv64_ovl_cache_base = 0u;
    cv64_ovl_cache_end = 0u;
}

// cont.39 [ovlgran] Bug-C scoping report — called per gfx task (frame boundary, sp.cpp). Logs how many
// DISTINCT 0x0F buffers the shared slot took during the frame just built, then resets. Frames with >1
// distinct buffer are the Bug-C collision frames (the top-level frame-DL 0x0F refs that fall to the
// stale shared slot resolve to only the LAST of these). The per-frame count = the staging granularity.
extern "C" void cv64_ovlgran_report() {
    static int frame = 0; frame++;
    if (cv64_gran_count > 1 && frame < 8000) {
        fprintf(stderr, "[ovlgran] frame#%d: %d distinct 0x0F buffers / %d maps (overflow=%d):",
                frame, cv64_gran_count, cv64_gran_maps, cv64_gran_overflow);
        for (int i = 0; i < cv64_gran_count && i < 20; i++) fprintf(stderr, " 0x%06X", cv64_gran_set[i]);
        fprintf(stderr, "\n"); fflush(stderr);
    }
    cv64_gran_count = 0; cv64_gran_overflow = 0; cv64_gran_maps = 0;
}

static void cv64_register_overlay_range(uint32_t base, uint32_t size, uint32_t win) {
    if (size == 0u) return;
    base &= 0x1FFFFFFFu;
    uint32_t end = base + size;
    int n = cv64_ovl_range_count;
    for (int i = 0; i < n; i++) {
        if (cv64_ovl_ranges[i].base == base) {
            cv64_ovl_ranges[i].end = end;
            // win is STICKY: the periodic all-files scan re-registers with win=0; don't
            // erase a known window association (only a new non-zero mapping updates it).
            if (win != 0u) cv64_ovl_ranges[i].win = win;
            return;
        }
    }
    if (n < CV64_OVL_MAX) {
        cv64_ovl_ranges[n].base = base;
        cv64_ovl_ranges[n].end  = end;
        cv64_ovl_ranges[n].win  = win;
        cv64_ovl_range_count = n + 1;
    }
}

// cont.39: translate a physical addr inside a WINDOW-MAPPED overlay buffer to the overlay-window
// vaddr it aliases (window base + offset), or 0 if it isn't inside any window-mapped buffer.
// Outermost-containing match, same rule as recomp_overlay_base_for.
extern "C" uint32_t recomp_overlay_window_vaddr_for(uint32_t phys) {
    phys &= 0x1FFFFFFFu;
    uint32_t best = 0u, bestWin = 0u;
    int n = cv64_ovl_range_count;
    for (int i = 0; i < n; i++) {
        if (cv64_ovl_ranges[i].win != 0u && phys >= cv64_ovl_ranges[i].base && phys < cv64_ovl_ranges[i].end) {
            if (best == 0u || cv64_ovl_ranges[i].base < best) { best = cv64_ovl_ranges[i].base; bestWin = cv64_ovl_ranges[i].win; }
        }
    }
    return (best != 0u) ? (bestWin + (phys - best)) : 0u;
}

// GPU (rt64 fromSegmentedMasked) calls this with the physical address of the DL currently being walked.
// Returns the overlay buffer base whose [base,end) contains it, or 0 if it isn't inside a known overlay
// buffer (e.g. the top-level frame DL) — in which case the caller falls back to the shared slot.
extern "C" uint32_t recomp_overlay_base_for(uint32_t phys) {
    phys &= 0x1FFFFFFFu;
    // cont.36 perf: 1-range cache. Consecutive 0x0F resolves walk the SAME buffer, so the last matched
    // range hits almost every time — avoids the O(n) scan over ~255 registered files (the stutter cause).
    if (cv64_ovl_cache_base != 0u && phys >= cv64_ovl_cache_base && phys < cv64_ovl_cache_end) return cv64_ovl_cache_base;
    // Return the OUTERMOST (smallest-base) containing range. With all files registered, a small code
    // overlay and a larger enclosing buffer can both contain an address; the owning buffer is the
    // outermost, so an inner/spurious sub-range never wins (the cont.35 castle-regression mode).
    uint32_t best = 0u, bestEnd = 0u;
    int n = cv64_ovl_range_count;
    for (int i = 0; i < n; i++) {
        if (phys >= cv64_ovl_ranges[i].base && phys < cv64_ovl_ranges[i].end) {
            if (best == 0u || cv64_ovl_ranges[i].base < best) { best = cv64_ovl_ranges[i].base; bestEnd = cv64_ovl_ranges[i].end; }
        }
    }
    if (best != 0u) { cv64_ovl_cache_base = best; cv64_ovl_cache_end = bestEnd; }
    return best;
}

// cont.36: register EVERY loaded NI file buffer (called from mapOverlay) so the game-agnostic CONTAINER
// path (recomp_overlay_base_for of the DL's own buffer) resolves model DLs that branch into asset files.
extern "C" void cv64_register_file_range(uint32_t base, uint32_t size) {
    cv64_register_overlay_range(base, size, 0u);   // plain asset file, not window-mapped
}

extern "C" void recomp_tlb_map(uint32_t vaddr, uint32_t paddr, uint32_t size) {
    if (size == 0u) size = 1u;
    if ((vaddr & 0xFE000000u) == 0x0E000000u) {   // overlay window (0x0E/0x0F)
        g_ovl_cur_buffer = paddr & 0x1FFFFFFFu;
        g_ovl_map_count++;
        cv64_register_overlay_range(paddr, size, vaddr);   // cont.13: register for GPU per-DL 0x0F resolution (+cont.39: remember the window vaddr)
        // cont.39 [ovlgran] tally distinct buffers this frame
        { uint32_t pb = paddr & 0x1FFFFFFFu; cv64_gran_maps++;
          bool seen = false;
          for (int i = 0; i < cv64_gran_count; i++) if (cv64_gran_set[i] == pb) { seen = true; break; }
          if (!seen) { if (cv64_gran_count < 128) cv64_gran_set[cv64_gran_count++] = pb; else cv64_gran_overflow++; } }
    }
    // Smallest N64 page size (4K,16K,64K,...,16M) whose page-pair (2x) covers size.
    uint32_t pagesize = 0x1000u;
    while ((2u * pagesize) < size && pagesize < 0x1000000u) pagesize <<= 2;
    uint32_t pairmask = 2u * pagesize - 1u;
    uint32_t vpn2     = vaddr & ~pairmask;
    uint32_t pfn0     = (paddr & 0x1FFFFFFFu) >> 12;
    uint32_t pfn1     = ((paddr + pagesize) & 0x1FFFFFFFu) >> 12;

    int idx = -1;
    for (int i = 0; i < TLB_ENTRIES; i++)
        if (g_tlb[i].valid && (g_tlb[i].entryHi & ~pairmask) == vpn2) { idx = i; break; }
    if (idx < 0)
        for (int i = 0; i < TLB_ENTRIES; i++) if (!g_tlb[i].valid) { idx = i; break; }
    if (idx < 0) idx = 31; // all full (shouldn't happen — few overlay windows)

    g_cop0_index    = (uint32_t)idx;
    g_cop0_entryhi  = vpn2;
    g_cop0_pagemask = pairmask & ~0x1FFFu;      // PageMask field
    g_cop0_entrylo0 = (pfn0 << 6) | 0x7u;       // G|V|D, cacheable
    g_cop0_entrylo1 = (pfn1 << 6) | 0x7u;
    recomp_tlbwi();                              // commit + [tlb] log
}

// PHASE 3 (P3a): LIVE translation for KUSEG (0x00000000-0x7FFFFFFF) through g_tlb;
// KSEG0/KSEG1 stay direct-mapped. While mappings are identity (P3a) this returns
// the same physical as the old flat macro (no behavior change). Unmapped KUSEG
// addresses fall back to flat so nothing that doesn't use the TLB can break.
// NOTE: KSEG is fast-pathed inline in the CV64_PHYS macro, so this function is
// only called for KUSEG addresses in practice.
// The TLB walk itself, shared so translate() and is_mapped() can never drift apart. Returns 1 and
// writes the physical address on a VALID mapping; returns 0 on a miss and writes nothing — NO flat
// fallback, because the whole point is to let a caller distinguish "mapped" from "not mapped".
static inline int tlb_walk(uint32_t vaddr, uint32_t* phys_out) {
    for (int i = 0; i < TLB_ENTRIES; i++) {
        if (!g_tlb[i].valid) continue;
        uint32_t pmask    = g_tlb[i].pageMask | 0x1FFFu;   // low 13 bits always masked
        uint32_t pagesize = (pmask + 1u) >> 1;             // one (even/odd) page
        if ((vaddr & ~pmask) == (g_tlb[i].entryHi & ~pmask)) {
            uint32_t lo = (vaddr & pagesize) ? g_tlb[i].entryLo1 : g_tlb[i].entryLo0;
            if (!(lo & 0x2u)) return 0;                    // V bit clear → invalid
            uint32_t pfn = lo >> 6;
            *phys_out = ((pfn << 12) + (vaddr & (pagesize - 1u))) & 0x1FFFFFFFu;
            return 1;
        }
    }
    return 0;
}

// Does vaddr resolve through a VALID TLB entry? (phys_out optional.)
//
// `recomp_tlb_translate` CANNOT answer this — it flat-maps every miss, so it never reports
// failure and every KUSEG address looks translatable. Any caller that needs "is this real?" (the
// interpreter's jump guard) must use THIS, or it silently accepts everything.
extern "C" int recomp_tlb_is_mapped(uint32_t vaddr, uint32_t* phys_out) {
    uint32_t p = 0;
    if ((vaddr & 0xC0000000u) == 0x80000000u) {            // KSEG0/1 are always mapped, direct
        p = vaddr & 0x1FFFFFFFu;
    } else if (!tlb_walk(vaddr, &p)) {
        return 0;
    }
    if (phys_out) *phys_out = p;
    return 1;
}

// TRI-STATE TLB PROBE for the exception path (2026-09-06, GoldenEye 007 #19).
// tlb_walk collapses two different hardware events into "miss": NO matching entry (a TLB *Refill*,
// which vectors to the refill vector) and a MATCHING entry whose V bit is clear (a TLB *Invalid*,
// which vectors to the general vector with the same TLBL/TLBS code). That is right for translation
// and wrong for dispatch. A demand pager depends on the distinction: GoldenEye's fast refill installs
// whatever its page table holds, and a page that is not resident yet has a zero PTE, i.e. V = 0 --
// the retry must then take the Invalid so the kernel's fault path can DMA the page in.
// Returns 1 = valid mapping, 2 = matched entry with V clear, 0 = no matching entry.
extern "C" int recomp_tlb_match_state(uint32_t vaddr) {
    if ((vaddr & 0xC0000000u) == 0x80000000u) return 1;         // KSEG0/1 never TLB-fault
    for (int i = 0; i < TLB_ENTRIES; i++) {
        if (!g_tlb[i].valid) continue;
        uint32_t pmask    = g_tlb[i].pageMask | 0x1FFFu;
        uint32_t pagesize = (pmask + 1u) >> 1;
        if ((vaddr & ~pmask) == (g_tlb[i].entryHi & ~pmask)) {
            uint32_t lo = (vaddr & pagesize) ? g_tlb[i].entryLo1 : g_tlb[i].entryLo0;
            return (lo & 0x2u) ? 1 : 2;
        }
    }
    return 0;
}

// REVERSE TRANSLATION (2026-08-06, the window-alias class — turok2/3 / Acclaim London).
// Physical address is the IDENTITY of code; a virtual address is only a view of it. A game
// whose code is linked at TLB-window vaddrs registers its functions under those vaddrs, so a
// call that arrives by the KSEG0 view of the same bytes misses the lookup — the caller then
// interprets, and an interp session that derails walks RAM forever (measured: turok2's pc
// sliding ~48K instructions per poll through zeroed RAM, latching wild EPCs into the guest's
// TCB). Given a phys, return the FIRST mapped vaddr that translates to it (0 if none), so a
// lookup can try the other view before giving up. Scans the same 32 entries as tlb_walk.
extern "C" uint32_t recomp_tlb_vaddr_for_phys(uint32_t phys) {
    phys &= 0x1FFFFFFFu;
    for (int i = 0; i < TLB_ENTRIES; i++) {
        if (!g_tlb[i].valid) continue;
        uint32_t pmask    = g_tlb[i].pageMask | 0x1FFFu;
        uint32_t pagesize = (pmask + 1u) >> 1;
        uint32_t vbase    = g_tlb[i].entryHi & ~pmask;
        for (int half = 0; half < 2; half++) {
            uint32_t lo = half ? g_tlb[i].entryLo1 : g_tlb[i].entryLo0;
            if (!(lo & 0x2u)) continue;                       // V bit clear
            uint32_t pbase = (lo >> 6) << 12;
            if (phys >= pbase && phys < pbase + pagesize) {
                return vbase + (half ? pagesize : 0u) + (phys - pbase);
            }
        }
    }
    return 0u;
}

// [rdram-wrap r3] the same physical fence as recomp.h CV64_PHYS_KSEG: phys below the cart window
// is flat (month-proven map incl. device backing + slack); cart window flat within the ROM mirror;
// anything past it -> the junk cell (hardware: ROM-domain writes dropped, past-ROM reads open-bus).
// Without this, a garbage guest pointer through the FLAT FALLBACK below produced phys up to 512MB
// into a ~268MB allocation (measured: SOTE reload-era READ AV at phys 0x18090000, RVA 0x17C16C5).
static inline uint32_t tlb_phys_fence(uint32_t phys) {
    phys &= 0x1FFFFFFFu;
    if (phys < 0x10000000u) return phys;
    if (phys - 0x10000000u < 0x00C00000u) return phys;
    return 0x03E00000u;
}

extern "C" uint32_t recomp_tlb_translate(uint32_t vaddr) {
    if ((vaddr & 0xC0000000u) == 0x80000000u) return tlb_phys_fence(vaddr); // KSEG0/1 direct fast path only (KSEG2/3 fall through to TLB)
    {
        uint32_t phys = 0;
        if (tlb_walk(vaddr, &phys)) return phys;
    }
    // ── ALL-VADDR MISS PROBE (KI Gold, 2026-08-29) ────────────────────────────────────────────
    // The low-vaddr probe below only fires for vaddr < 0x1000, so a miss ANYWHERE ELSE in KUSEG is
    // completely SILENT — it flat-maps and the guest reads whatever happens to live at that
    // physical address. That blind spot covers exactly the window KI Gold remaps at its freeze
    // (virtual 0x10000 -> 0x30000). Report the distinct missing PAGES (not every access, which
    // would be millions) so one run answers: "is the guest reading through an unmapped TLB window
    // after the remap?" Capped and page-deduped; silent when nothing misses.
    if (vaddr >= 0x1000u) {
        static std::atomic<uint64_t> _miss_total{0};
        const uint64_t mt = _miss_total.fetch_add(1, std::memory_order_relaxed) + 1u;
        static std::atomic<uint32_t> _seen_pages[16];
        static std::atomic<uint32_t> _nseen{0};
        const uint32_t page = vaddr >> 13;                 // 8KB granule = one TLB entry
        bool known = false;
        const uint32_t n = _nseen.load(std::memory_order_relaxed);
        for (uint32_t i = 0; i < n && i < 16u; i++)
            if (_seen_pages[i].load(std::memory_order_relaxed) == page) { known = true; break; }
        if (!known && n < 16u) {
            _seen_pages[n].store(page, std::memory_order_relaxed);
            _nseen.store(n + 1u, std::memory_order_relaxed);
            fprintf(stderr, "[tlbmiss] UNMAPPED KUSEG page 0x%08X (vaddr 0x%08X) -> flat 0x%06X (total=%llu) func=0x%08X\n",
                    page << 13, vaddr, vaddr & 0x1FFFFFFFu, (unsigned long long)mt,
                    recomp_current_guest_func());
            fflush(stderr);
#ifdef _WIN32
            // Walk the host stack for the first few distinct pages. KI Gold spins 2.36 BILLION
            // times on 0xE9000000 (measured 2026-08-29) and the guest func-mark alone does not say
            // which call path BUILT that pointer. Native return addresses do; resolve them with
            // recompilator/bench/resolve_rva.py against <game>pc.map. Same pattern as [lowvawho].
            if (n < 6u) {
                HMODULE exe2 = GetModuleHandleA(nullptr);
                if (exe2 != nullptr) {
                    const uintptr_t* sp2 = (const uintptr_t*)_AddressOfReturnAddress();
                    const uintptr_t* top2 = (const uintptr_t*)((NT_TIB*)NtCurrentTeb())->StackBase;
                    int f2 = 0;
                    for (int i = 0; i < 512 && f2 < 8 && &sp2[i] < top2; i++) {
                        uintptr_t ret2 = sp2[i]; HMODULE m2 = nullptr;
                        if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                               GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                               (LPCSTR)ret2, &m2) && m2 == exe2) {
                            fprintf(stderr, "[tlbmisswho] page=0x%08X #%d RVA=0x%08llX\n",
                                    page << 13, f2, (unsigned long long)(ret2 - (uintptr_t)exe2));
                            f2++;
                        }
                    }
                    fflush(stderr);
                }
            }
#endif
        } else if ((mt & 0xFFFFFu) == 0u) {
            fprintf(stderr, "[tlbmiss] running total=%llu (last vaddr 0x%08X) func=0x%08X\n",
                    (unsigned long long)mt, vaddr, recomp_current_guest_func());
            fflush(stderr);
        }
    }

    // LOW-VADDR PROBE (SOTE osBootInfo clobber hunt, 2026-07-19). On real hardware an unmapped
    // KUSEG access raises a TLB-miss exception; here it silently flat-maps, so a guest store
    // through a NULL/small base register (the classic uninitialized-pointer bzero) lands cleanly
    // on physical 0x300 and wipes the IPL3 boot block. This also explains why a snapshot scan for
    // literal 0x8000xxxx/0xA000xxxx store bases found nothing: the base is register-computed, so
    // there is no lui to find. Report the low-vaddr fallbacks; the accompanying host backtrace
    // question is answered by which of these two probes fires ([rsp_dma_lowdst] vs this).
    if (vaddr < 0x1000u) {
        // THE CAP MUST SATURATE, NOT WRAP (2026-08-28, KI Gold). This was `static int _lowva`
        // with `if (++_lowva <= 24)`. A guest spinning on a NULL pointer reaches 2^31 low-vaddr
        // translations in about a minute; the signed increment then wrapped to INT_MIN and the
        // cap re-opened for another ~2.1 billion lines. Measured on KI Gold: 24 lines, then a
        // contiguous flood — 231,409 lines in one 120s run, 98.6% of the log, with an fflush on
        // every one. That is not just noise: the VI rate decayed 60/s -> 7/s as the log grew, so
        // a probe that is supposed to be silent after 24 hits became the dominant load in the
        // process and corrupted every timing reading taken alongside it.
        // Uncapped total, so the flood is COUNTABLE even though it is not printable. This is the
        // number that matters: "24 lines" and "2.1 billion translations" look identical in a log
        // with a capped print, and that is exactly how the overflow above hid for so long.
        static std::atomic<uint64_t> _lowva_total{0};
        const uint64_t total = _lowva_total.fetch_add(1, std::memory_order_relaxed) + 1u;

        static std::atomic<uint32_t> _lowva{0};
        uint32_t seen = _lowva.load(std::memory_order_relaxed);
        if (seen < 24u && _lowva.fetch_add(1, std::memory_order_relaxed) < 24u) {
            fprintf(stderr, "[tlb_lowva] unmapped-KUSEG flat fallback vaddr=0x%08X -> phys 0x%06X (total=%llu)\n",
                    vaddr, vaddr & 0x1FFFFFFFu, (unsigned long long)total);
            fflush(stderr);
        }
        {
#ifdef _WIN32
            // RECOMP_LOWVA_WHO=1: name the native caller. A guest that spins on a null pointer
            // shows the same RVA set every time, which is the whole answer to "who deref'd 0".
            static const bool who_on = [] { const char* e = std::getenv("RECOMP_LOWVA_WHO");
                                            return e != nullptr && e[0] != '0'; }();
            // Sample the FIRST few hits (the boot-time sites) AND then periodically (the SPINNING
            // site, which only shows up millions of hits later). Walking only the first N would
            // name boot and miss the spin entirely — the thing actually worth naming.
            static std::atomic<uint32_t> _walks{0};
            const bool due = (total <= 32u) || ((total & 0xFFFFFu) == 0u);
            if (who_on && due && _walks.fetch_add(1, std::memory_order_relaxed) < 40u) {
                HMODULE exe = GetModuleHandleA(nullptr);
                if (exe != nullptr) {
                    const uintptr_t* sp = (const uintptr_t*)_AddressOfReturnAddress();
                    const uintptr_t* stack_top = (const uintptr_t*)((NT_TIB*)NtCurrentTeb())->StackBase;
                    fprintf(stderr, "[lowvawho] #%llu vaddr=0x%08X native call sites (RVA -> <game>pc.map, base=%p):\n",
                            (unsigned long long)total, vaddr, (void*)exe);
                    int found = 0;
                    for (int i = 0; i < 256 && found < 8 && &sp[i] < stack_top; i++) {
                        uintptr_t ret = sp[i];
                        HMODULE m = nullptr;
                        if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                               GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                               (LPCSTR)ret, &m) && m == exe) {
                            fprintf(stderr, "[lowvawho]   #%d RVA=0x%08llX\n", found,
                                    (unsigned long long)(ret - (uintptr_t)exe));
                            found++;
                        }
                    }
                    fflush(stderr);
                }
            }
#endif
        }
    }
    // [kseg23-noalias 2026-09-06, A Bug's Life #97] KUSEG's flat fallback above is deliberate and
    // load-bearing ([rdram-wrap r3]). KSEG2/KSEG3 is NOT the same case: hardware TLB-maps
    // 0xC0000000-0xFFFFFFFF, so an access there with no matching entry FAULTS and can never reach
    // RDRAM. Masking it with 0x1FFFFFFF aliased the TOP of the address space straight onto
    // PHYSICAL PAGE 0 - the exception vectors and libultra's boot block (osTvType 0x80000300,
    // osMemSize 0x80000318, the IPL3 block). Measured on A Bug's Life: a guest pointer walk that
    // runs off the end of the cart window into 0xC0000000 wrote 0xB08D1800 over physical 0 at
    // 8-byte stride 545,259,520 times in one run ([tlbmiss] running total; [fb-content] phys=0x000000
    // first=[B08D1800 00000000 ...]), erasing the resident image the guest is executing from.
    // Send an unmapped KSEG2/3 access to the SAME junk cell tlb_phys_fence already uses for
    // past-ROM physical addresses: reads are open-bus-ish, writes go nowhere real, RDRAM survives.
    // A KSEG2/3 address WITH a mapping never reaches here (tlb_walk above returns it), so a guest
    // kernel linked at kseg2/kseg3 (Gauntlet Legends #120) is unaffected; KUSEG is untouched.
    if (vaddr >= 0xC0000000u) return 0x03E00000u;
    return tlb_phys_fence(vaddr); // unmapped KUSEG: flat fallback, physically fenced ([rdram-wrap r3])
}
