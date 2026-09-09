/**
 * math_patches.c — Native impls for MIPS compiler helpers the recompiler
 *                  ignores by name (N64Recomp ignored_funcs).
 *
 * LoD's recompiled code calls __f_to_ull (identified by signature, S44).
 * Unlike cv64pc, sinf/__cosf are NOT named in LoD's blind ELF, so they
 * recompile as ordinary functions — no native needed.
 */

#include <math.h>
#include <stdint.h>
#include "recomp.h"

/* float → unsigned long long. $f12 in; $v0 = low 32, $v1 = high 32. */
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
    ctx->r2 = (uint32_t)(result & 0xFFFFFFFFU);
    ctx->r3 = (uint32_t)((result >> 32) & 0xFFFFFFFFU);
}
