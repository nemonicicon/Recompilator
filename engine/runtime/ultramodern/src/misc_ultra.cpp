#include <cstdio>
#include "ultramodern/ultra64.h"

#define K0BASE        0x80000000
#define K1BASE        0xA0000000
#define K2BASE        0xC0000000
#define IS_KSEG0(x)   ((u32)(x) >= K0BASE && (u32)(x) < K1BASE)
#define IS_KSEG1(x)   ((u32)(x) >= K1BASE && (u32)(x) < K2BASE)
#define K0_TO_PHYS(x) ((u32)(x)&0x1FFFFFFF)
#define K1_TO_PHYS(x) ((u32)(x)&0x1FFFFFFF)

// cv64 SESSION 38: the LLE TLB (librecomp tlb.cpp), populated per-entity by the game's own
// mapOverlay/osMapTLB chain. Resolved at final link (same pattern rt64 uses).
extern "C" uint32_t recomp_tlb_translate(uint32_t vaddr);

u32 osVirtualToPhysical(PTR(void) addr) {
    uintptr_t addr_val = (uintptr_t)addr;
    if (IS_KSEG0(addr_val)) {
        return K0_TO_PHYS(addr_val);
    } else if (IS_KSEG1(addr_val)) {
        return K1_TO_PHYS(addr_val);
    } else {
        // cv64 SESSION 38 — THE Bug C ORIGIN, fixed faithfully. This was `// TODO handle TLB mappings`
        // returning the RAW VIRTUAL: a TLB-mapped KUSEG pointer (CV64's per-entity 0x0F overlay window)
        // passed through unchanged, so the game wrote raw 0x0Fxxxxxx VIRTUALS into its display lists.
        // The async renderer then had to GUESS which entity's buffer each ref meant = the unsolvable
        // render-time keying problem (16 sessions of collisions: weretiger glitches, invisible Renon,
        // the Villa-courtyard freeze: DLPUSH 0x0F0023C0 -> million-NOOP march -> dlguard bail x4808).
        // Real libultra PROBES THE TLB here (__osProbeTLB) and returns the true physical, so on hardware
        // the DL carries the per-entity PHYSICAL address and no collision can exist. We have the same
        // TLB state the hardware had (recomp_tlb_map runs per-entity right before its behavior builds
        // the DL), so probe it exactly like the hardware. Unmapped KUSEG falls back flat inside
        // recomp_tlb_translate = the old behavior, so this cannot regress non-TLB addresses.
        u32 phys = recomp_tlb_translate((u32)addr_val);
        {   // capped proof-of-path log: only when the TLB actually changed a 0x0E/0x0F-window address
            static int _n = 0;
            if (phys != (u32)addr_val && ((u32)addr_val & 0xFE000000u) == 0x0E000000u && _n++ < 40) {
                fprintf(stderr, "[v2p] TLB-baked 0x%08X -> 0x%08X (build-time per-entity physical)\n",
                        (u32)addr_val, phys);
                fflush(stderr);
            }
        }
        return phys;
    }
}

