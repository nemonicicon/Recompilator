#include <memory>
#include <cstdio>
#include <cstdlib>
#include <ultramodern/ultra64.h>
#include <ultramodern/ultramodern.hpp>
#include <chrono>
#include "recomp.h"

// [badbufwho] host-stack walk (see osInvalDCache_recomp). Native return addresses do not lie the
// way guest func-marks do — cgenerator only marks func_XXXXXXXX names, so a name-matched caller is
// invisible to mark-based attribution (that is exactly how KI Gold's caller was misidentified).
#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <winternl.h>
#include <intrin.h>
#endif

// COP0 / TLB primitives implemented in tlb.cpp (reg numbers: 0=Index, 10=EntryHi, 11=Compare).
extern "C" void     recomp_cop0_tlb_write(int reg, uint32_t value);
extern "C" uint32_t recomp_cop0_tlb_read(int reg);
extern "C" void     recomp_tlbp(void);

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osInitialize_recomp(uint8_t * rdram, recomp_context * ctx) {
    osInitialize();
}
#endif  // RUNG157_SELF_HOSTED (osInitialize_recomp)

extern "C" void __osInitialize_common_recomp(uint8_t * rdram, recomp_context * ctx) {
    osInitialize();
}

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osCreateThread_recomp(uint8_t* rdram, recomp_context* ctx) {
    osCreateThread(rdram, (int32_t)ctx->r4, (OSId)ctx->r5, (int32_t)ctx->r6, (int32_t)ctx->r7,
        (int32_t)MEM_W(0x10, ctx->r29), (OSPri)MEM_W(0x14, ctx->r29));
}
#endif  // RUNG157_SELF_HOSTED (osCreateThread_recomp)

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osStartThread_recomp(uint8_t* rdram, recomp_context* ctx) {
    osStartThread(rdram, (int32_t)ctx->r4);
}
#endif  // RUNG157_SELF_HOSTED (osStartThread_recomp)

extern "C" void osStopThread_recomp(uint8_t * rdram, recomp_context * ctx) {
    osStopThread(rdram, (int32_t)ctx->r4);
}

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osDestroyThread_recomp(uint8_t * rdram, recomp_context * ctx) {
    osDestroyThread(rdram, (int32_t)ctx->r4);
}
#endif  // RUNG157_SELF_HOSTED (osDestroyThread_recomp)

// [osYieldThread 2026-09-06, Bust-A-Move 99 #98] was `assert(false);` with the call commented out,
// i.e. a SILENT NO-OP in Release (NDEBUG). ultramodern::osYieldThread now exists (scheduling.cpp).
extern "C" void osYieldThread_recomp(uint8_t * rdram, recomp_context * ctx) {
    (void)ctx;   // void osYieldThread(void) — no arguments, no return value
    osYieldThread(rdram);
}

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osSetThreadPri_recomp(uint8_t* rdram, recomp_context* ctx) {
    osSetThreadPri(rdram, (int32_t)ctx->r4, (OSPri)ctx->r5);
}
#endif  // RUNG157_SELF_HOSTED (osSetThreadPri_recomp)

extern "C" void osGetThreadPri_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = osGetThreadPri(rdram, (int32_t)ctx->r4);
}

extern "C" void osGetThreadId_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = osGetThreadId(rdram, (int32_t)ctx->r4);
}

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osCreateMesgQueue_recomp(uint8_t* rdram, recomp_context* ctx) {
    osCreateMesgQueue(rdram, (int32_t)ctx->r4, (int32_t)ctx->r5, (s32)ctx->r6);
}
#endif  // RUNG157_SELF_HOSTED (osCreateMesgQueue_recomp)

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osRecvMesg_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = osRecvMesg(rdram, (int32_t)ctx->r4, (int32_t)ctx->r5, (s32)ctx->r6);
}
#endif  // RUNG157_SELF_HOSTED (osRecvMesg_recomp)

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osSendMesg_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = osSendMesg(rdram, (int32_t)ctx->r4, (OSMesg)ctx->r5, (s32)ctx->r6);
}
#endif  // RUNG157_SELF_HOSTED (osSendMesg_recomp)

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osJamMesg_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = osJamMesg(rdram, (int32_t)ctx->r4, (OSMesg)ctx->r5, (s32)ctx->r6);
}
#endif  // RUNG157_SELF_HOSTED (osJamMesg_recomp)

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osSetEventMesg_recomp(uint8_t* rdram, recomp_context* ctx) {
    osSetEventMesg(rdram, (OSEvent)ctx->r4, (int32_t)ctx->r5, (OSMesg)ctx->r6);
}
#endif  // RUNG157_SELF_HOSTED (osSetEventMesg_recomp)

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osViSetEvent_recomp(uint8_t * rdram, recomp_context * ctx) {
    osViSetEvent(rdram, (int32_t)ctx->r4, (OSMesg)ctx->r5, (u32)ctx->r6);
}
#endif  // RUNG157_SELF_HOSTED (osViSetEvent_recomp)

extern "C" void osGetCount_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = osGetCount();
}

// __osSetCompare(u32 value): write the COP0 Compare register (reg 11). The VR4300
// timer interrupt (CAUSE.IP7) is not delivered under HLE, so this just records the
// value the way every other COP0 store does (osGetCompare reads it back). Faithful
// no-side-effect behavior — used by libultra's profiler/timer setup.
extern "C" void __osSetCompare_recomp(uint8_t * rdram, recomp_context * ctx) {
    recomp_cop0_tlb_write(11, (uint32_t)ctx->r4);
}

// __osProbeTLB(void *vaddr) -> s32: faithful TLBP against our 32-entry TLB. Load the
// probed vaddr into EntryHi, run the probe, read Index back; Index bit31 set = no
// match -> return -1, else the matched entry index. EntryHi is preserved as the real
// libultra routine does.
extern "C" void __osProbeTLB_recomp(uint8_t * rdram, recomp_context * ctx) {
    uint32_t saved_hi = recomp_cop0_tlb_read(10);
    recomp_cop0_tlb_write(10, (uint32_t)ctx->r4);
    recomp_tlbp();
    uint32_t index = recomp_cop0_tlb_read(0);
    recomp_cop0_tlb_write(10, saved_hi);
    ctx->r2 = (index & 0x80000000u) ? (gpr)(int32_t)-1 : (gpr)(int32_t)(index & 0x3F);
}

extern "C" void osSetCount_recomp(uint8_t * rdram, recomp_context * ctx) {
    osSetCount(ctx->r4);
}

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osGetTime_recomp(uint8_t * rdram, recomp_context * ctx) {
    uint64_t total_count = osGetTime();
    ctx->r2 = (int32_t)(total_count >> 32);
    ctx->r3 = (int32_t)(total_count >> 0);
}
#endif  // RUNG157_SELF_HOSTED (osGetTime_recomp)

extern "C" void osSetTime_recomp(uint8_t * rdram, recomp_context * ctx) {
    uint64_t t = ((uint64_t)(ctx->r4) << 32) | ((ctx->r5) & 0xFFFFFFFFu);
    osSetTime(t);
}

#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osSetTimer_recomp(uint8_t * rdram, recomp_context * ctx) {
    uint64_t countdown = ((uint64_t)(ctx->r6) << 32) | ((ctx->r7) & 0xFFFFFFFFu);
    uint64_t interval = load_doubleword(rdram, ctx->r29, 0x10);
    // [settimer] capped, always-on: what the guest actually asks for. OSTime is 46.875 MHz, so a
    // per-frame tick should be ~781,250 counts (16.67 ms). A game that ends up ticking far slower
    // than it intends is the tell that the countdown is being read or scaled wrong.
    { static int _n = 0; if (_n++ < 24) {
        fprintf(stderr, "[settimer] countdown=%llu (%.3f ms) interval=%llu mq=0x%08X msg=0x%08X\n",
                (unsigned long long)countdown, (double)countdown / 46875.0,
                (unsigned long long)interval, (uint32_t)MEM_W(0x18, ctx->r29), (uint32_t)MEM_W(0x1C, ctx->r29));
        fflush(stderr); } }
    ctx->r2 = osSetTimer(rdram, (int32_t)ctx->r4, countdown, interval, (int32_t)MEM_W(0x18, ctx->r29), (OSMesg)MEM_W(0x1C, ctx->r29));
}
#endif  // RUNG157_SELF_HOSTED (osSetTimer_recomp)

extern "C" void osStopTimer_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = osStopTimer(rdram, (int32_t)ctx->r4);
}

extern "C" void osVirtualToPhysical_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = osVirtualToPhysical((int32_t)ctx->r4);
}

extern "C" uint32_t recomp_current_guest_func();     // recomp.cpp
extern "C" uint32_t recomp_current_guest_caller();   // recomp.cpp — 1-deep

extern "C" void osInvalDCache_recomp(uint8_t * rdram, recomp_context * ctx) {
    // ── BAD-BUFFER PROBE (KI Gold, 2026-08-29) ────────────────────────────────────────────────
    // Report any cache-invalidate over a buffer OUTSIDE the 8 MB of RDRAM. That is never legal on
    // hardware, and it is the earliest point at which KI Gold's broken cart read is visible: its
    // blocking read wrapper (func_80000740) does osInvalDCache(vAddr, nbytes) BEFORE the DMA, so a
    // bogus vAddr shows up here one call earlier than in the PI path.
    // WHY THE CALLER IS TRUSTWORTHY *HERE* specifically: osInvalDCache is the FIRST call the
    // wrapper makes, so cgenerator's emit_func_remark has not yet re-marked the wrapper over the
    // caller slot. Everywhere later in that function the 1-deep caller is destroyed (measured), but
    // at this exact site it still names who called the wrapper. func= should read 0x80000740.
    const uint32_t vaddr = (uint32_t)ctx->r4;
    const uint32_t phys  = vaddr & 0x1FFFFFFFu;
    if (phys >= 0x00800000u && phys < 0x04000000u) {   // RDRAM region, above installed 8 MB
        static int _n = 0;
        if (_n++ < 32) {
            // func=/caller= are MARK-based and therefore only valid when the true caller is
            // func_XXXXXXXX-named. On KI Gold caller= reported func_801C47E0, which turned out to
            // be a STALE mark (that function never touches this path). Trust the RVAs below.
            fprintf(stderr, "[badbuf] osInvalDCache vaddr=0x%08X (phys 0x%06X, PAST 8MB) size=0x%X "
                            "func=0x%08X caller=0x%08X(mark, may be stale)\n",
                    vaddr, phys, (uint32_t)ctx->r5,
                    recomp_current_guest_func(), recomp_current_guest_caller());
            fflush(stderr);
#ifdef _WIN32
            // The authoritative answer: walk the host stack for return addresses inside the game
            // exe and print them as module RVAs. Resolve with recompilator/bench/resolve_rva.py
            // against <game>pc.map. Same technique as [lowvawho] in tlb.cpp.
            HMODULE exe = GetModuleHandleA(nullptr);
            if (exe != nullptr) {
                const uintptr_t* sp = (const uintptr_t*)_AddressOfReturnAddress();
                const uintptr_t* stack_top = (const uintptr_t*)((NT_TIB*)NtCurrentTeb())->StackBase;
                int found = 0;
                for (int i = 0; i < 512 && found < 10 && &sp[i] < stack_top; i++) {
                    uintptr_t ret = sp[i];
                    HMODULE m = nullptr;
                    if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                           GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                           (LPCSTR)ret, &m) && m == exe) {
                        fprintf(stderr, "[badbufwho]   #%d RVA=0x%08llX\n", found,
                                (unsigned long long)(ret - (uintptr_t)exe));
                        found++;
                    }
                }
                fflush(stderr);
            }
#endif
        }
    }
}

extern "C" void recomp_icache_ghost_sync_range(uint8_t* rdram, uint32_t vaddr, uint32_t nbytes);   // recomp_interp.cpp [ghost-sync]
extern "C" void osInvalICache_recomp(uint8_t * rdram, recomp_context * ctx) {
    // [ghost-sync 2026-09-03] osInvalICache(void* vaddr, s32 nbytes): the game just wrote code here. This
    // reimplementation was a no-op, so a game binding it never told the icache ghost its code changed.
    recomp_icache_ghost_sync_range(rdram, (uint32_t)ctx->r4, (uint32_t)ctx->r5);
}

extern "C" void osWritebackDCache_recomp(uint8_t * rdram, recomp_context * ctx) {
    ;
}

extern "C" void osWritebackDCacheAll_recomp(uint8_t * rdram, recomp_context * ctx) {
    ;
}

#if 1  // [RUNG1A-LLE-INTMASK] retired: the game manages its own interrupt mask
#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void osSetIntMask_recomp(uint8_t * rdram, recomp_context * ctx) {
    // HLE runs no real interrupts, but the *visible* CP0 Status interrupt-mask must stay faithful for
    // games that READ Status for control flow. The real osSetIntMask writes SR's IM field (bits 8-15)
    // from the requested OSIntMask (whose bits 8-15 map 1:1 onto the SR IM field). Blast Corps' render
    // thread gates its entire render path on (Status & OS_IM_PRENMI), i.e. bit 0x1000; with the old
    // no-op, status_reg stayed 0 there, so it took the screen-BLANK path (osViBlack(1)) every frame and
    // never rendered -> permanent black screen. Set the IM field, preserve IE/other bits, and return the
    // prior mask bits in v0. GENERAL (any game that reads Status); baseline HLE games that never read
    // Status are unaffected, and the previous return value was garbage so nothing depended on it.
    uint32_t mask = (uint32_t)ctx->r4;             // a0 = requested OSIntMask
    uint32_t old_sr = ctx->status_reg;
    ctx->r2 = old_sr & 0xFF01u;                    // v0 = previous IE+IM bits (~ the prior OSIntMask)
    ctx->status_reg = (old_sr & ~0xFF00u) | (mask & 0xFF00u);
}
#endif  // RUNG157_SELF_HOSTED (osSetIntMask_recomp)
#endif  // [RUNG1A-LLE-INTMASK]

#if 1  // [RUNG1A-LLE-INTMASK] retired: the game manages its own interrupt mask
#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void __osDisableInt_recomp(uint8_t * rdram, recomp_context * ctx) {
    // Real __osDisableInt clears Status IE and returns the prior IE bit (consumed by __osRestoreInt).
    uint32_t old_sr = ctx->status_reg;
    ctx->status_reg = old_sr & ~0x1u;
    ctx->r2 = old_sr & 0x1u;
}
#endif  // RUNG157_SELF_HOSTED (__osDisableInt_recomp)
#endif  // [RUNG1A-LLE-INTMASK]

#if 1  // [RUNG1A-LLE-INTMASK] retired: the game manages its own interrupt mask
#ifndef RUNG157_SELF_HOSTED   // [RUNG157] the cartridge's own body replaces this native
extern "C" void __osRestoreInt_recomp(uint8_t * rdram, recomp_context * ctx) {
    // Real __osRestoreInt ORs the saved IE bit back into Status.
    ctx->status_reg |= ((uint32_t)ctx->r4 & 0x1u);
}
#endif  // RUNG157_SELF_HOSTED (__osRestoreInt_recomp)
#endif  // [RUNG1A-LLE-INTMASK]

extern "C" void __osSetFpcCsr_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = 0;
}

// For the Mario Party games (not working)
//extern "C" void longjmp_recomp(uint8_t * rdram, recomp_context * ctx) {
//    RecompJmpBuf* buf = TO_PTR(RecompJmpBuf, ctx->r4);
//
//    // Check if this is a buffer that was set up with setjmp
//    if (buf->magic == SETJMP_MAGIC) {
//        // If so, longjmp to it
//        // Setjmp/longjmp does not work across threads, so verify that this buffer was made by this thread
//        assert(buf->owner == ultramodern::this_thread());
//        longjmp(buf->storage->buffer, ctx->r5);
//    } else {
//        // Otherwise, check if it was one built manually by the game with $ra pointing to a function
//        gpr sp = MEM_W(0, ctx->r4);
//        gpr ra = MEM_W(4, ctx->r4);
//        ctx->r29 = sp;
//        recomp_func_t* target = LOOKUP_FUNC(ra);
//        if (target == nullptr) {
//            fprintf(stderr, "Failed to find function for manual longjmp\n");
//            std::quick_exit(EXIT_FAILURE);
//        }
//        target(rdram, ctx);
//
//        // TODO kill this thread if the target function returns
//        assert(false);
//    }
//}
//
//#undef setjmp_recomp
//extern "C" void setjmp_recomp(uint8_t * rdram, recomp_context * ctx) {
//    fprintf(stderr, "Program called setjmp_recomp\n");
//    std::quick_exit(EXIT_FAILURE);
//}
//
//extern "C" int32_t osGetThreadEx(void) {
//    return ultramodern::this_thread();
//}
