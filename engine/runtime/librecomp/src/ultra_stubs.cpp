#include <ultramodern/ultra64.h>
#include <ultramodern/ultramodern.hpp>
#include "recomp.h"

// None of these functions need to be reimplemented, so stub them out
extern "C" void osUnmapTLBAll_recomp(uint8_t * rdram, recomp_context * ctx) {
    // TODO this will need to be implemented in the future for any games that actually use the TLB
}

extern "C" void osVoiceInit_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = 11; // CONT_ERR_DEVICE
}

extern "C" void osVoiceSetWord_recomp(uint8_t * rdram, recomp_context * ctx) {
    assert(false);
}

extern "C" void osVoiceCheckWord_recomp(uint8_t * rdram, recomp_context * ctx) {
    assert(false);
}

extern "C" void osVoiceStopReadData_recomp(uint8_t * rdram, recomp_context * ctx) {
    assert(false);
}

extern "C" void osVoiceMaskDictionary_recomp(uint8_t * rdram, recomp_context * ctx) {
    assert(false);
}

extern "C" void osVoiceStartReadData_recomp(uint8_t * rdram, recomp_context * ctx) {
    assert(false);
}

extern "C" void osVoiceControlGain_recomp(uint8_t * rdram, recomp_context * ctx) {
    assert(false);
}

extern "C" void osVoiceGetReadData_recomp(uint8_t * rdram, recomp_context * ctx) {
    assert(false);
}

extern "C" void osVoiceClearDictionary_recomp(uint8_t * rdram, recomp_context * ctx) {
    assert(false);
}


// kdebugserver / rmon — the N64 DEV-HOST DEBUG SERVER (rmon/gameshark debug interface). These are in
// N64Recomp's ignored_funcs (the decomp ships their bodies but the runtime is expected to provide them),
// and they are DEAD on a retail console (no dev host attached) — same class as the RDB/RAMROM dev interface.
// Decomp games (SM64's crash-command processor) reference them; provide inert stubs. General (no game-side
// definition exists to collide with — they were always expected from the runtime).
extern "C" void send_recomp(uint8_t * rdram, recomp_context * ctx) {
    // Debug-server serial send — no host on retail, so drop it.
}

extern "C" void string_to_u32_recomp(uint8_t * rdram, recomp_context * ctx) {
    // Debug command-parser helper (string -> u32). Only used by the dev-debug command path; return 0.
    ctx->r2 = 0;
}
