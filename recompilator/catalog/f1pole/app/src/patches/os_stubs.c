/**
 * os_stubs.c — PC-port natives for libultra functions the recompiler ignores
 *              by name (N64Recomp symbol_lists.cpp ignored_funcs).
 *
 * SESSION 44: identified in F1POLE by signature (tools/match_libultra.py); these
 * four are the ones F1POLE's recompiled code actually calls.
 *
 * MIPS o32 in N64Recomp: args ctx->r4..r7 ($a0..$a3), stack args at
 * MEM_W(0x10+, ctx->r29); return ctx->r2 ($v0).
 */

#include <stdint.h>
#include <stdio.h>
#include "recomp.h"

/* ── osMapTLB — FAITHFUL: program the engine's LLE TLB. ─────────────────────
 * Unlike cv64pc (which no-op'd this and populated the TLB from its native
 * mapOverlay HLE), f1polepc has no game patches — the game's own recompiled
 * overlay mapper calls osMapTLB, and we route it to the runtime's real TLB
 * (librecomp tlb.cpp recomp_tlb_map: encodes EntryHi/PageMask/EntryLo0/1 and
 * commits via tlbwi; also registers the overlay range for the GPU's 0x0E/0x0F
 * resolution). This is the libultra semantic, engine-wide.
 *
 *   s32 osMapTLB(s32 index, OSPageMask pm, void* vaddr, u32 evenpaddr,
 *                u32 oddpaddr, s32 asid)
 *   a0=index a1=pagemask a2=vaddr a3=evenpaddr  stack+0x10=oddpaddr +0x14=asid
 *
 * recomp_tlb_map maps the page PAIR from one contiguous physical base
 * (odd = even + pagesize). Overlay loads are contiguous buffers, so this
 * matches; a game passing a discontiguous odd page (rare) would need the
 * index-level API — log-visible if it ever happens ([tlb] write lines).
 */
void recomp_tlb_map(uint32_t vaddr, uint32_t paddr, uint32_t size);

RECOMP_FUNC void osMapTLB_recomp(uint8_t* rdram, recomp_context* ctx) {
    uint32_t pagemask  = (uint32_t)ctx->r5;
    uint32_t vaddr     = (uint32_t)ctx->r6;
    uint32_t evenpaddr = (uint32_t)ctx->r7;
    /* pair span covered by this entry: pagemask | 0x1FFF is the pair mask */
    uint32_t pair_size = (pagemask | 0x1FFFu) + 1u;

    static int logged = 0;
    if (logged < 16) {
        logged++;
        uint32_t oddpaddr = MEM_W(0x10, ctx->r29);
        fprintf(stderr, "[osMapTLB] idx=%d vaddr=0x%08X even=0x%08X odd=0x%08X pm=0x%08X span=0x%X\n",
                (int)ctx->r4, vaddr, evenpaddr, oddpaddr, pagemask, pair_size);
        fflush(stderr);
    }
    recomp_tlb_map(vaddr, evenpaddr, pair_size);
    ctx->r2 = 0; /* success */
}

/* ── osUnmapTLB — the engine TLB has no invalidate API; remaps overwrite by
 * VPN2 match (cv64 ran 40+ sessions with unmap as a no-op). Logged no-op. ── */
RECOMP_FUNC void osUnmapTLB_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    static int logged = 0;
    if (logged < 4) {
        logged++;
        fprintf(stderr, "[osUnmapTLB] idx=%d (no-op)\n", (int)ctx->r4);
        fflush(stderr);
    }
    ctx->r2 = 0;
}

/* ── __osContAddressCrc — Controller Pak address CRC; pak handled natively. ── */
RECOMP_FUNC void __osContAddressCrc_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = 0;
}

/* ── __osGetCause — COP0 Cause read. ultramodern delivers interrupts out of
 * band; no cause bits are ever pending from recompiled code's view. ────────── */
RECOMP_FUNC void __osGetCause_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = 0;
}

/* ── __osSiRawStartDma — 64-byte PIF DMA. Stub: real SI traffic goes through
 * librecomp's named natives (osContInit/osEepromRead/...); dead at runtime behind
 * them. Logged so a live call is visible. ── */
RECOMP_FUNC void __osSiRawStartDma_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    static int logged = 0;
    if (logged < 8) {
        logged++;
        fprintf(stderr, "[osSiRawStartDma] dir=%d dram=0x%08X (stub)\n",
                (int)ctx->r4, (uint32_t)ctx->r5);
        fflush(stderr);
    }
    ctx->r2 = 0;
}
