#include <cstdio>
#include <fstream>
#include <ultramodern/ultramodern.hpp>
#include "recomp.h"
#include "recompiler/diag_sink.h"

#if 0  // [RUNG6-LLE-SP] retired: the cartridge's own RSP task driver serves this
extern "C" void osSpTaskLoad_recomp(uint8_t* rdram, recomp_context* ctx) {
    // Nothing to do here
}
#endif  // [RUNG6-LLE-SP]

bool dump_frame = false;

#if 0  // [RUNG6-LLE-SP] retired: the cartridge's own RSP task driver serves this
extern "C" void osSpTaskStartGo_recomp(uint8_t* rdram, recomp_context* ctx) {
    OSTask* task = TO_PTR(OSTask, ctx->r4);
    // Diag-gated: the sweep classifier reads these lines (gfx = "osSpTaskStartGo"+"type=1"), but a
    // normal run must not pay a format+fflush syscall on EVERY task submit (Wave-1 hot-path purge).
    if (N64Recomp::diag::enabled()) {
        fprintf(stderr, "[sp] osSpTaskStartGo: ptr=0x%08X type=%u ucode=0x%08X\n",
                (uint32_t)ctx->r4, (unsigned)task->t.type, (uint32_t)task->t.ucode);
        fflush(stderr);
    }
    // For debugging
    if (dump_frame) {
        char addr_str[32];
        constexpr size_t ram_size = 0x800000;
        std::unique_ptr<char[]> ram_unswapped = std::make_unique<char[]>(ram_size);
        snprintf(addr_str, sizeof(addr_str) - 1, "%08X", task->t.data_ptr);
        addr_str[sizeof(addr_str) - 1] = '\0';
        std::ofstream dump_file{ "ramdump" + std::string{ addr_str } + ".bin", std::ios::binary};

        for (size_t i = 0; i < ram_size; i++) {
            ram_unswapped[i] = rdram[i ^ 3];
        }

        dump_file.write(ram_unswapped.get(), ram_size);
        dump_frame = false;
    }
    ultramodern::submit_rsp_task(rdram, ctx->r4);
}
#endif  // [RUNG6-LLE-SP]

#if 0  // [RUNG6-LLE-SP] retired: the cartridge's own RSP task driver serves this
extern "C" void osSpTaskYield_recomp(uint8_t* rdram, recomp_context* ctx) {
    // Ignore yield requests (acts as if the task completed before it received the yield request)
}
#endif  // [RUNG6-LLE-SP]

#if 0  // [RUNG6-LLE-SP] retired: the cartridge's own RSP task driver serves this
extern "C" void osSpTaskYielded_recomp(uint8_t* rdram, recomp_context* ctx) {
    // Task yield requests are ignored, so always return 0 as tasks will never be yielded
    ctx->r2 = 0;
}
#endif  // [RUNG6-LLE-SP]

// __osSpSetStatus: write the SP_STATUS register (set/clear bits). HLE owns the RSP — tasks run
// synchronously via submit_rsp_task and the SP is never mid-task while the CPU runs — so the game's
// direct status pokes (e.g. OoT's RcpUtils_Reset) are inert. No-op. General (libultra surface).
#if 0  // [RUNG6-LLE-SP] retired: the cartridge's own RSP task driver serves this
extern "C" void __osSpSetStatus_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram; (void)ctx;
}
#endif  // [RUNG6-LLE-SP]

// __osSpGetStatus: read the SP_STATUS register. Report HALTED/idle (bit0 set), since our RSP is never
// busy when the recompiled CPU is executing. Used by debug/status readers (OoT's RcpUtils). General.
#if 0  // [RUNG6-LLE-SP] retired: the cartridge's own RSP task driver serves this
extern "C" void __osSpGetStatus_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = 0x1;
}
#endif  // [RUNG6-LLE-SP]

#if 0  // [RUNG6-LLE-SP] retired: the cartridge's own RSP task driver serves this
extern "C" void __osSpSetPc_recomp(uint8_t* rdram, recomp_context* ctx) {
    assert(false);
}
#endif  // [RUNG6-LLE-SP]
