#include <cstdio>
#include <cstdlib>

#include "recomp.h"
#include "librecomp/rsp.hpp"

// events.cpp: deliver the DP-done the RDP owes after it drains a directly-submitted command list.
extern "C" void recomp_dp_direct_complete(uint32_t delay_us);

enum class RDPStatusBit {
    XbusDmem = 0,
    Freeze = 1,
    Flush = 2,
    CommandBusy = 6,
    BufferReady = 7,
    DmaBusy = 8,
    EndValid = 9,
    StartValid = 10,
};

constexpr void update_bit(uint32_t& state, uint32_t flags, RDPStatusBit bit) {
    int reset_bit_pos = (int)bit * 2 + 0;
    int set_bit_pos = (int)bit * 2 + 1;
    bool set = (flags & (1U << set_bit_pos)) != 0;
    bool reset = (flags & (1U << reset_bit_pos)) != 0;

    if (set ^ reset) {
        if (set) {
            state |= (1U << (int)bit);
        }
        else {
            state &= ~(1U << (int)bit);
        }
    }
}

uint32_t rdp_state = 1 << (int)RDPStatusBit::BufferReady;

// s32 osDpSetNextBuffer(void* buf, u64 size) — hand a command list STRAIGHT to the RDP, no RSP task
// in front of it. Real libultra returns -1 if the DP is already busy, else writes DPC_START =
// phys(buf), DPC_END = phys(buf) + size; the RDP drains the list and raises the DP full-sync
// interrupt (OS_EVENT_DP) when it is done.
//
// This was `assert(false)` — which in a RELEASE build compiles to NOTHING. The call returned
// with $v0 holding whatever the previous call left, no list was ever submitted, and no DP-done was
// ever raised. KI Gold's scheduler (the resident one at 0x80001F2C) submits its list here, latches
// its "RDP busy" byte on the non-(-1) return, and then waits forever for the DP-done that closes
// it — its swap gate never re-opens, so osViSwapBuffer is never called. MEASURED 2026-08-28:
// exactly 1 [evtfire] DP-done in a 120 s run (the counter caps at 20, so below-cap is the exact
// total), D_8000D196 latched at 1 and D_8000D198 latched at 0 for the whole run.
//
// o32 argument note: the u64 `size` must land in an even register pair, so a1 is skipped and the
// size arrives in (a2,a3) = (high, low). KI Gold's caller sets a2=0/a3=size, and the guest's own
// (unused, name-intercepted) copy at 0x80003BB0 reads 0x30($sp)/0x34($sp) the same way.
extern "C" void osDpSetNextBuffer_recomp(uint8_t* rdram, recomp_context* ctx) {
    const uint32_t buf = (uint32_t)ctx->r4;
    const uint32_t size = (uint32_t)ctx->r7;   // low word of the u64 (a3); high word (a2) is padding here

    // Busy check, mirroring our DPC model: reads of DPC_STATUS are hardcoded idle (see mmio.cpp and
    // the falsified readable-status note there), so __osDpDeviceBusy is never true and we never
    // return -1. Kept explicit so it tracks the model if that ever gains a device-side lifecycle.
    const bool dp_busy = (rdp_state & (1u << (int)RDPStatusBit::CommandBusy)) != 0;
    if (dp_busy || size == 0) {
        ctx->r2 = (gpr)(int32_t)-1;
        return;
    }

    const uint32_t start = buf & 0x1FFFFFFFu;
    const uint32_t end = start + size;

    { static int _n = 0; if (_n++ < 24) {
        fprintf(stderr, "[dpdirect] #%d buf=0x%08X size=0x%X -> [0x%06X..0x%06X)%c",
                _n, buf, size, start & 0xFFFFFFu, end & 0xFFFFFFu, 0x0A);
        fflush(stderr); } }

    // Drain the list the way a DPC_END write does. On the RT64 desktop tier this is the decode/
    // telemetry pass (no pixels — RT64 draws from the HLE gfx task); on the softrdp tier it
    // rasterizes for real. Either way it is the existing raw-RDP consumer, bounds-guarded inside.
    rsp_process_rdp_commands(rdram, start, end);

    // The completion the RDP owes. Paced (not inline) so it cannot be observed before the guest
    // finishes arming — the same floor the RSP-task path uses.
    recomp_dp_direct_complete(50);

    ctx->r2 = 0;
}

extern "C" void osDpGetStatus_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = rdp_state;
}

// osDpGetCounters(OSDpCounters* r4): RDP timing counters (clock/cmd/pipe/tmem busy). The RDP is HLE'd so
// there are no real cycle counts; this is debug/profiling only. No-op. Surfaced by the GoldenEye
// decomp-driven recomp (__scHandleRDP). General libultra native.
extern "C" void osDpGetCounters_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram; (void)ctx;
}

extern "C" void osDpSetStatus_recomp(uint8_t* rdram, recomp_context* ctx) {
    update_bit(rdp_state, ctx->r4, RDPStatusBit::XbusDmem);
    update_bit(rdp_state, ctx->r4, RDPStatusBit::Freeze);
    update_bit(rdp_state, ctx->r4, RDPStatusBit::Flush);
}
