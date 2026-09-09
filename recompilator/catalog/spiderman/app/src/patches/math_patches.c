/**
 * math_patches.c — Native impls for MIPS compiler helpers the recompiler
 *                  ignores by name (N64Recomp ignored_funcs).
 *
 * SPIDERMAN's recompiled code calls __d_to_ull (the link-time scorecard found it;
 * SPIDERMAN never references __f_to_ull). Register convention VERIFIED against the
 * SPIDERMAN caller (funcs_27.c func_8029D4D0: `sw $v0,0x18($sp); sw $v1,0x1C($sp)`
 * forming one big-endian 64-bit stack value) — o32 pair order: $v0 = HIGH 32,
 * $v1 = LOW 32. The lodpc-inherited __f_to_ull had the pair REVERSED;
 * corrected here (it is unreferenced in SPIDERMAN, kept for parity).
 */

#include <math.h>
#include <stdint.h>
#include "recomp.h"

/* float → unsigned long long. $f12 in; $v0 = HIGH 32, $v1 = LOW 32 (o32). */
RECOMP_FUNC void __f_to_ull_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    float f = ctx->f12.fl;
    uint64_t result;
    if (f < 0.0f)
        result = 0ULL;
    else if (f >= 18446744073709551616.0f)
        result = 0xFFFFFFFFFFFFFFFFULL;
    else
        result = (uint64_t)f;
    ctx->r2 = (uint32_t)((result >> 32) & 0xFFFFFFFFU);
    ctx->r3 = (uint32_t)(result & 0xFFFFFFFFU);
}

/* double → unsigned long long. $f12 in; $v0 = HIGH 32, $v1 = LOW 32 (o32). */
RECOMP_FUNC void __d_to_ull_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    double d = ctx->f12.d;
    uint64_t result;
    if (d < 0.0)
        result = 0ULL;
    else if (d >= 18446744073709551616.0)
        result = 0xFFFFFFFFFFFFFFFFULL;
    else
        result = (uint64_t)d;
    ctx->r2 = (uint32_t)((result >> 32) & 0xFFFFFFFFU);
    ctx->r3 = (uint32_t)(result & 0xFFFFFFFFU);
}
