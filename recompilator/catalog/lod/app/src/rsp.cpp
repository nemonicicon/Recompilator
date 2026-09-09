/**
 * rsp.cpp — RSP microcode dispatch for LODPC.
 *
 * Legacy of Darkness ships the SAME RSP microcodes as CV64, byte-identical
 * (verified against the LoD ROM: Konami aspMain audio ucode at rom 0xACE00,
 * F3DEX2 fifo 2.06 at rom 0xABA70). The RSPRecomp outputs generated for cv64pc
 * are therefore reused verbatim (rsp/aspMain.cpp, rsp/f3dex2.cpp) — the
 * recompiled code is a function of the ucode bytes only.
 *
 * GFX tasks are HLE-rendered by RT64 via send_dl; the LLE F3DEX2 capture path
 * is kept (gated off, LOD_GFX_LLE=1 to enable) for parity with cv64pc.
 */

#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <mutex>
#include "librecomp/rsp.hpp"
#include "ultramodern/ultra64.h"

#define M_GFXTASK   1
#define M_AUDTASK   2

static RspExitReason rsp_noop_stub(uint8_t* /*rdram*/, uint32_t /*ucode_addr*/) {
    return RspExitReason::Broke;
}

// RSPRecomp-generated Konami audio ucode (rsp/aspMain.cpp).
RspExitReason aspMain(uint8_t* rdram, uint32_t ucode_addr);

// Same wrapper policy as cv64pc: a watchdog bail (Unsupported) must not
// fatal-exit the runtime — degrade to silence for that task.
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

// RSPRecomp-generated F3DEX2 (rsp/f3dex2.cpp) — capture-only LLE, gated off.
RspExitReason f3dex2(uint8_t* rdram, uint32_t ucode_addr);

extern "C" { extern float g_lle_faithful_z[131072]; extern volatile uint32_t g_lle_faithful_z_count; }

void lod_run_gfx_lle(uint8_t* rdram, const OSTask* task) {
    static const bool enabled = [] {
        const char* e = std::getenv("LOD_GFX_LLE");
        return e != nullptr && e[0] == '1';
    }();
    if (!enabled) {
        return;
    }
    std::lock_guard<std::mutex> dmem_lock(g_rsp_dmem_mutex);
    memcpy(&dmem[0xFC0], task, sizeof(OSTask));
    uint32_t ud_size = task->t.ucode_data_size;
    if (ud_size == 0 || ud_size > 0xF80) ud_size = 0xF80;
    dma_rdram_to_dmem(rdram, 0x0000, task->t.ucode_data, ud_size - 1);
    g_lle_faithful_z_count = 0;
    RspExitReason r = f3dex2(rdram, task->t.ucode);
    static int n = 0;
    n++;
    if (n <= 8) {
        fprintf(stderr, "[gfxlle] #%d F3DEX2 ucode=0x%08X exit=%d ztris=%u\n",
                n, (unsigned)task->t.ucode, (int)r, (unsigned)g_lle_faithful_z_count);
        fflush(stderr);
    }
}

RspUcodeFunc* lod_get_rsp_microcode(const OSTask* task) {
    switch (task->t.type) {
    case M_AUDTASK:
        return aspMain_logged;
    case M_GFXTASK:
        // GFX tasks are routed to RT64 via send_dl; this keeps f3dex2 linked.
        return f3dex2;
    default:
        fprintf(stderr, "[lodpc] Unknown RSP task type %u — returning no-op stub\n",
                (unsigned)task->t.type);
        return rsp_noop_stub;
    }
}

recomp::rsp::callbacks_t get_rsp_callbacks() {
    return {
        .get_rsp_microcode = lod_get_rsp_microcode,
        .capture_gfx = lod_run_gfx_lle,
    };
}
