/**
 * rsp.cpp — RSP microcode dispatch for BOTTOM9PC (Bottom9 64, USA). Game #4.
 *
 * AUDIO: Bottom9 ships the SAME audio microcode as CV64/SM64/LoD — byte-identical
 * (verified in-ROM: aspMain text at PW rom 0x48E10 matches SM64 rom 0xE7740 for 0x100,
 * aspMainData command jump table at PW rom 0x51B80). The RSPRecomp output generated for
 * cv64pc/sm64pc is therefore reused verbatim (rsp/aspMain.cpp) — the recompiled code is a
 * function of the ucode bytes only. FOURTH game on the same shared Nintendo-era ucode.
 * GFX: HLE-rendered by RT64 via send_dl (RT64's GBI database covers F3D/F3DEX); no LLE path.
 */
#include <cstdio>
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

// No LLE gfx capture (F3D/F3DEX is HLE'd by RT64; no recompiled gfx ucode for this game).
static void bottom9_run_gfx_lle(uint8_t* /*rdram*/, const OSTask* /*task*/) {}

static RspUcodeFunc* bottom9_get_rsp_microcode(const OSTask* task) {
    switch (task->t.type) {
    case M_AUDTASK:
        return aspMain_logged;
    case M_GFXTASK:
        // GFX tasks are routed to RT64 via send_dl; this return is never run.
        return rsp_noop_stub;
    default:
        fprintf(stderr, "[bottom9pc] Unknown RSP task type %u — no-op stub\n",
                (unsigned)task->t.type);
        return rsp_noop_stub;
    }
}

recomp::rsp::callbacks_t get_rsp_callbacks() {
    return {
        .get_rsp_microcode = bottom9_get_rsp_microcode,
        .capture_gfx = bottom9_run_gfx_lle,
    };
}
