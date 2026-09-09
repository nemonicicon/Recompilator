#include <cstdlib>   // getenv/strtoul for the [timerlist] init below
#include <ultramodern/ultramodern.hpp>
#include "recomp.h"
#include "helpers.hpp"

extern "C" void osViSetYScale_recomp(uint8_t* rdram, recomp_context * ctx) {
    osViSetYScale(ctx->f12.fl);
}

extern "C" void osViSetXScale_recomp(uint8_t* rdram, recomp_context * ctx) {
    osViSetXScale(ctx->f12.fl);
}

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osCreateViManager_recomp(uint8_t* rdram, recomp_context* ctx) {
    // [vi-init instrument 20260825, flipless-class dig] the HLE intentionally no-ops this;
    // log that the game ASKED, once — a game whose display expectations hinge on the manager
    // it thinks it created is a candidate for the black-screen families.
    static int cvm_count = 0;
    if (cvm_count++ < 2) {
        fprintf(stderr, "[vi] osCreateViManager #%d: pri=0x%X (HLE no-op)\n",
                cvm_count, (uint32_t)ctx->r4);
        fflush(stderr);
    }

    // [timerlist] THE GUEST-VISIBLE SIDE EFFECT THIS STUB DROPS (2026-08-28, KI Gold).
    // Real libultra's osCreateViManager calls __osTimerServicesInit(), which makes the guest's
    // __osTimerList a CIRCULAR SENTINEL (`p->prev = p; p->next = p->prev;` — osCreateViManager.c
    // calls it; osTimer.c does the assignment). No-opping the whole function drops that init.
    // Harmless for a title whose timer calls are all HLE-intercepted by name — but a game
    // carrying its OWN statically-linked libultra inside a runtime-decompressed overlay is NOT
    // intercepted, and its __osInsertTimer then walks a list whose head is still all zeros:
    // head->next == NULL != head, so it decides the list is non-empty and reads the 64-bit key
    // through a NULL pointer (vaddr 0x10/0x14) forever. Measured on KI Gold: one core pegged,
    // [hogsample] f=0x800051C8 dmarks=0 for the whole run, zero graphics tasks ever submitted.
    // RECOMP_TIMERLIST=0xADDR names the guest's __osTimerList POINTER variable (KI Gold:
    // 0x80006FE0, which holds the node 0x8000F670). Env-gated while the general form is designed.
    {
        static const char* tl = std::getenv("RECOMP_TIMERLIST");
        if (tl != nullptr && cvm_count == 1) {
            uint32_t listp = (uint32_t)strtoul(tl, nullptr, 0);
            if (listp >= 0x80000000u && listp < 0x80800000u) {
                uint32_t node = (uint32_t)MEM_W(0, listp);
                if (node >= 0x80000000u && node < 0x80800000u) {
                    uint32_t nx = (uint32_t)MEM_W(0x00, node);
                    MEM_W(0x00, node) = (int32_t)node;   // next = self
                    MEM_W(0x04, node) = (int32_t)node;   // prev = self
                    fprintf(stderr, "[timerlist] __osTimerList=0x%08X node=0x%08X: next was 0x%08X, "
                                    "now self-referential (libultra __osTimerServicesInit contract)\n",
                            listp, node, nx);
                    fflush(stderr);
                }
            }
        }
    }
}
#endif  // RUNG157_SELF_HOSTED (osCreateViManager_recomp)

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osViBlack_recomp(uint8_t* rdram, recomp_context* ctx) {
    // [vi-init instrument 20260825] blank-state transitions decide flips-but-black suspects.
    static int blk_count = 0;
    if (blk_count++ < 8) {
        fprintf(stderr, "[vi] osViBlack #%d: active=%u\n", blk_count, (uint32_t)ctx->r4);
        fflush(stderr);
    }
    osViBlack((uint32_t)ctx->r4);
}
#endif  // RUNG157_SELF_HOSTED (osViBlack_recomp)

extern "C" void osViRepeatLine_recomp(uint8_t* rdram, recomp_context* ctx) {
    osViRepeatLine(_arg<0, u8>(rdram, ctx));
}

extern "C" void osViSetSpecialFeatures_recomp(uint8_t* rdram, recomp_context* ctx) {
    osViSetSpecialFeatures((uint32_t)ctx->r4);
}

extern "C" void osViGetCurrentFramebuffer_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = (gpr)(int32_t)osViGetCurrentFramebuffer();
    // [vi-init instrument 20260825] what we ANSWER during boot is what the game builds its
    // framebuffer chain from (hexen swapped 0x80000400 — did it come from us?).
    static int gcf_count = 0;
    if (gcf_count++ < 8) {
        fprintf(stderr, "[vi] osViGetCurrentFramebuffer #%d -> 0x%08X\n",
                gcf_count, (uint32_t)ctx->r2);
        fflush(stderr);
    }
}

extern "C" void osViGetNextFramebuffer_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = (gpr)(int32_t)osViGetNextFramebuffer();
    static int gnf_count = 0;
    if (gnf_count++ < 8) {
        fprintf(stderr, "[vi] osViGetNextFramebuffer #%d -> 0x%08X\n",
                gnf_count, (uint32_t)ctx->r2);
        fflush(stderr);
    }
}

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osViSwapBuffer_recomp(uint8_t* rdram, recomp_context* ctx) {
    uint32_t phys = (uint32_t)(ctx->r4) & 0x1FFFFFFFu;
    static int swap_count = 0;
    if (swap_count++ < 8) {
        fprintf(stderr, "[vi] osViSwapBuffer #%d: r4=0x%08X phys=0x%08X\n",
                swap_count, (uint32_t)(ctx->r4), phys);
        fflush(stderr);
    }
    osViSwapBuffer(rdram, (int32_t)ctx->r4);
}
#endif  // RUNG157_SELF_HOSTED (osViSwapBuffer_recomp)

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osViSetMode_recomp(uint8_t* rdram, recomp_context* ctx) {
    uint32_t mode_va = (uint32_t)(ctx->r4);
    uint32_t mode_phys = mode_va & 0x1FFFFFFFu;
    // Read ctrl and hStart directly from RDRAM to show what RT64 will see.
    // OSViMode layout: [padding:3][type:1][ctrl:4][width:4][burst:4][vSync:4]
    //                  [hSync:4][leap:4][hStart:4][xScale:4][vCurrent:4] ...
    uint32_t ctrl   = *(uint32_t*)(rdram + mode_phys + 4);   // comRegs.ctrl
    uint32_t width  = *(uint32_t*)(rdram + mode_phys + 8);   // comRegs.width
    uint32_t hStart = *(uint32_t*)(rdram + mode_phys + 28);  // comRegs.hStart
    static int mode_count = 0;
    if (mode_count++ < 4) {
        fprintf(stderr, "[vi] osViSetMode #%d: mode_va=0x%08X ctrl=0x%08X width=0x%08X hStart=0x%08X\n",
                mode_count, mode_va, ctrl, width, hStart);
        fflush(stderr);
    }
    osViSetMode(rdram, (int32_t)ctx->r4);
}
#endif  // RUNG157_SELF_HOSTED (osViSetMode_recomp)

extern uint64_t total_vis;

extern "C" void wait_one_frame(uint8_t* rdram, recomp_context* ctx) {
    static std::atomic<uint32_t> wof_count{0};
    uint32_t n = wof_count.fetch_add(1, std::memory_order_relaxed);
    if (n < 16 || n % 300 == 0) {
        fprintf(stderr, "[vi] wait_one_frame #%u: total_vis=%llu\n", n, (unsigned long long)total_vis);
        fflush(stderr);
    }
    uint64_t cur_vis = total_vis;
    while (cur_vis == total_vis) {
        std::this_thread::yield();
    }
    if (n < 16 || n % 300 == 0) {
        fprintf(stderr, "[vi] wait_one_frame #%u: returned, total_vis=%llu\n", n, (unsigned long long)total_vis);
        fflush(stderr);
    }
}
