// OPTIONAL engine natives — deliberately in their OWN translation unit.
//
// Static-lib pull semantics make these overridable per app: the linker only extracts this object
// from librecomp.lib when one of these symbols is otherwise UNRESOLVED. Apps that ship their own
// definitions (desktop sm64pc/cv64pc os_stubs.c + math_patches.c) never pull this object — no
// LNK2005 — while apps built engine-only (from-ROM builds, which drop the app patch files)
// resolve them from here. Ported from an earlier engine branch (2026-07-03 P1c
// re-convergence — see recompilator/PI_NATIVE_CONSOLE_PLAN.md). Do NOT merge these into
// ultra_stubs.cpp/math_routines.cpp: those objects are always pulled, and the collision returns.

#include "recomp.h"

extern "C" void recomp_tlb_map(uint32_t vaddr, uint32_t paddr, uint32_t size);

extern "C" void osMapTLB_recomp(uint8_t * rdram, recomp_context * ctx) {
    // osMapTLB(index, pagemask, vaddr, evenpaddr, oddpaddr, asid): faithful enough for the
    // boot-time fixed mappings games use — feed the live LLE TLB registry.
    uint32_t pagemask = (uint32_t)ctx->r5;
    uint32_t vaddr = (uint32_t)ctx->r6;
    uint32_t evenpaddr = (uint32_t)ctx->r7;
    recomp_tlb_map(vaddr, evenpaddr, (pagemask | 0x1FFF) + 1);
}

extern "C" void __osGetCause_recomp(uint8_t * rdram, recomp_context * ctx) {
    // No pending cop0 cause bits in the HLE machine.
    ctx->r2 = 0;
}

// The real joybus engine (librecomp/src/si.cpp): executes the 64-byte PIF command block in place,
// polls live host input, and writes the controller/pak responses back into the block.
extern "C" void recomp_si_dma(uint8_t* rdram, uint32_t is_read);

extern "C" void __osSiRawStartDma_recomp(uint8_t * rdram, recomp_context * ctx) {
    // __osSiRawStartDma(s32 dir, void* dramAddr). On hardware: latch SI_DRAM_ADDR, then kick
    // SI_PIF_WR64 (RDRAM -> PIF) or SI_PIF_RD64 (PIF -> RDRAM, carrying the responses).
    //
    // This used to be a no-op that reported success, which was true only while the osCont* entry
    // points were HLE'd -- that path read the host pad directly and never needed a real transfer.
    // Once a game runs its OWN recompiled osContStartReadData (LLE runtime), that function calls
    // here expecting PIF RAM to be filled; a lying stub left the block untouched, so the game saw
    // no buttons and no controller pak. Games that recompile their own __osSiRawStartDma drive the
    // SI registers through mmio.cpp instead and never reach this object (optional-native pull
    // semantics). General "fix the N64": this is the SI DMA hardware contract, not a per-game patch.
    const uint32_t dir  = (uint32_t)ctx->r4;                 // OS_READ = 0, OS_WRITE = 1
    const uint32_t dram = (uint32_t)ctx->r5 & 0x1FFFFFFFu;   // strip KSEG -> physical

    // Mirror SI_DRAM_ADDR where si.cpp's si_dram_addr() reads it (mmio.cpp does the same before
    // its kick), then run the transfer in the matching direction.
    *reinterpret_cast<uint32_t*>(rdram + 0x04800000u) = dram;
    recomp_si_dma(rdram, dir == 0u ? 1u : 0u);

    ctx->r2 = 0;
}

// double -> unsigned long long (SM64-class IDO runtime helper).
extern "C" void __d_to_ull_recomp(uint8_t * rdram, recomp_context * ctx) {
    uint64_t ret = (uint64_t)ctx->f12.d;

    ctx->r2 = (int32_t)(ret >> 32);
    ctx->r3 = (int32_t)(ret >> 0);
}
