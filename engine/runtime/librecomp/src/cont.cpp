#include "ultramodern/ultramodern.hpp"

#include "helpers.hpp"

#include <cstdio>
#include <cstdlib>   // getenv (N64PAK_DEBUG-gated status probe)

#define MAXCONTROLLERS 4

extern "C" void recomp_set_current_frame_poll_id(uint8_t* rdram, recomp_context* ctx) {
    // TODO reimplement the system for tagging polls with IDs to handle games with multithreaded input polling.
}

extern "C" void recomp_measure_latency(uint8_t* rdram, recomp_context* ctx) {
    ultramodern::measure_input_latency();
}

#if 0  // [RUNG3-LLE-SI] retired: the cartridge's own recompiled driver now serves this
extern "C" void osContInit_recomp(uint8_t* rdram, recomp_context* ctx) {
    PTR(OSMesgQueue) mq = _arg<0, PTR(OSMesgQueue)>(rdram, ctx);
    PTR(u8) bitpattern = _arg<1, PTR(u8)>(rdram, ctx);
    PTR(OSContStatus) data = _arg<2, PTR(OSContStatus)>(rdram, ctx);
    u8 bitpattern_local = 0;

    s32 ret = osContInit(PASS_RDRAM mq, &bitpattern_local, data);

    MEM_B(0, bitpattern) = bitpattern_local;

    // Report a Controller Pak inserted in controller 0 at BOOT too, mirroring
    // osContGetQuery_recomp. Some games' controller_status[] is filled here by osContInit and read
    // DIRECTLY by their save-init path (without always re-querying first), so without setting the
    // bit here the pak only appears after a later osContGetQuery refresh. Setting it at boot makes
    // the pak status consistent from the start (game-agnostic; the engine already defaults the
    // single accessory slot to a Controller Pak in ultramodern/input.cpp).
    // OSContStatus = { u16 type@0; u8 status@2; u8 err@3 }; CONT_CARD_ON = 0x01.
    // Only flag it when controller 0 is actually present (type != 0).
    if (MEM_HU(0, data) != 0) {
        MEM_BU(2, data) = (uint8_t)(MEM_BU(2, data) | 0x01);
    }
    { static const bool dbg = std::getenv("N64PAK_DEBUG") != nullptr; static int _n = 0;
      if (dbg && _n++ < 12) { fprintf(stderr, "[pakdbg] osContInit   cont0: present(HU0)=0x%04X  status_bytes[0..3]=%02X %02X %02X %02X\n",
          (unsigned)MEM_HU(0,data),(unsigned)MEM_BU(0,data),(unsigned)MEM_BU(1,data),(unsigned)MEM_BU(2,data),(unsigned)MEM_BU(3,data)); fflush(stderr); } }

    _return<s32>(ctx, ret);
}
#endif  // [RUNG3-LLE-SI]

extern "C" void osContReset_recomp(uint8_t* rdram, recomp_context* ctx) {
    PTR(OSMesgQueue) mq = _arg<0, PTR(OSMesgQueue)>(rdram, ctx);
    PTR(OSContStatus) data = _arg<1, PTR(OSContStatus)>(rdram, ctx);

    s32 ret = osContReset(PASS_RDRAM mq, data);

    _return<s32>(ctx, ret);
}

#if 0  // [RUNG3-LLE-SI] retired: the cartridge's own recompiled driver now serves this
extern "C" void osContStartReadData_recomp(uint8_t* rdram, recomp_context* ctx) {
    PTR(OSMesgQueue) mq = _arg<0, PTR(OSMesgQueue)>(rdram, ctx);

    s32 ret = osContStartReadData(PASS_RDRAM mq);

    _return<s32>(ctx, ret);
}
#endif  // [RUNG3-LLE-SI]

#if 0  // [RUNG3-LLE-SI] retired: the cartridge's own recompiled driver now serves this
extern "C" void osContGetReadData_recomp(uint8_t* rdram, recomp_context* ctx) {
    PTR(OSContPad) data = _arg<0, PTR(OSContPad)>(rdram, ctx);

    OSContPad dummy_data[MAXCONTROLLERS];

    osContGetReadData(dummy_data);

    for (int controller = 0; controller < MAXCONTROLLERS; controller++) {
        if (dummy_data[controller].err_no == 0) {
            MEM_H(6 * controller + 0, data) = dummy_data[controller].button;
            MEM_B(6 * controller + 2, data) = dummy_data[controller].stick_x;
            MEM_B(6 * controller + 3, data) = dummy_data[controller].stick_y;
            MEM_B(6 * controller + 4, data) = dummy_data[controller].err_no;
        }
    }
}
#endif  // [RUNG3-LLE-SI]

extern "C" void osContStartQuery_recomp(uint8_t * rdram, recomp_context * ctx) {
    PTR(OSMesgQueue) mq = _arg<0, PTR(OSMesgQueue)>(rdram, ctx);

    s32 ret = osContStartQuery(PASS_RDRAM mq);

    _return<s32>(ctx, ret);
}

extern "C" void osContGetQuery_recomp(uint8_t * rdram, recomp_context * ctx) {
    PTR(OSContStatus) data = _arg<0, PTR(OSContStatus)>(rdram, ctx);

    osContGetQuery(PASS_RDRAM data);

    // Report a Controller Pak inserted in controller 0 so the game's save-init path
    // proceeds (games gate osPfsInitPak on CONT_CARD_ON in the controller status; osPfs*
    // then does the actual save/load). Game-agnostic — the engine already defaults the
    // single accessory slot to a Controller Pak in ultramodern/input.cpp.
    // OSContStatus = { u16 type@0; u8 status@2; u8 err@3 }; CONT_CARD_ON = 0x01.
    // Only flag it when controller 0 is actually present (type != 0).
    if (MEM_HU(0, data) != 0) {
        MEM_BU(2, data) = (uint8_t)(MEM_BU(2, data) | 0x01);
    }
    { static const bool dbg = std::getenv("N64PAK_DEBUG") != nullptr; static int _n = 0;
      if (dbg && _n++ < 12) { fprintf(stderr, "[pakdbg] osContGetQuery cont0: present(HU0)=0x%04X  status_bytes[0..3]=%02X %02X %02X %02X\n",
          (unsigned)MEM_HU(0,data),(unsigned)MEM_BU(0,data),(unsigned)MEM_BU(1,data),(unsigned)MEM_BU(2,data),(unsigned)MEM_BU(3,data)); fflush(stderr); } }
}

extern "C" void osContSetCh_recomp(uint8_t* rdram, recomp_context* ctx) {
    u8 ch = _arg<0, u8>(rdram, ctx);

    s32 ret = osContSetCh(PASS_RDRAM ch);

    _return<s32>(ctx, ret);
}

extern "C" void __osMotorAccess_recomp(uint8_t* rdram, recomp_context* ctx) {
    PTR(OSPfs) pfs = _arg<0, PTR(OSPfs)>(rdram, ctx);
    s32 flag = _arg<1, s32>(rdram, ctx);

    s32 ret = __osMotorAccess(PASS_RDRAM pfs, flag);

    _return<s32>(ctx, ret);
}

extern "C" void osMotorInit_recomp(uint8_t* rdram, recomp_context* ctx) {
    PTR(OSMesgQueue) mq = _arg<0, PTR(OSMesgQueue)>(rdram, ctx);
    PTR(OSPfs) pfs = _arg<1, PTR(OSPfs)>(rdram, ctx);
    int channel = _arg<2, s32>(rdram, ctx);

    s32 ret = osMotorInit(PASS_RDRAM mq, pfs, channel);

    _return<s32>(ctx, ret);
}

extern "C" void osMotorStart_recomp(uint8_t* rdram, recomp_context* ctx) {
    PTR(OSPfs) pfs = _arg<0, PTR(OSPfs)>(rdram, ctx);

    s32 ret = osMotorStart(PASS_RDRAM pfs);

    _return<s32>(ctx, ret);
}

extern "C" void osMotorStop_recomp(uint8_t* rdram, recomp_context* ctx) {
    PTR(OSPfs) pfs = _arg<0, PTR(OSPfs)>(rdram, ctx);

    s32 ret = osMotorStop(PASS_RDRAM pfs);

    _return<s32>(ctx, ret);
}
