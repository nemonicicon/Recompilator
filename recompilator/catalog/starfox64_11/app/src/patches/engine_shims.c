/**
 * engine_shims.c - the three engine symbols every game tree defines.
 *
 * The runtime and the renderer reference three symbols that belong to one overlay format's
 * boot machinery, so any tree built against them must define them; a game without that format
 * supplies these defaults. They are findings, not fixes: the cure is for the engine to take
 * these through registered callbacks with library defaults, which the module host already does.
 *
 *  1. librecomp/src/overlays.cpp calls gamestate_change() from the overlay boot path. It never
 *     fires for a game without that overlay format; if it does, it says so on stderr.
 *  2. librecomp/src/overlays.cpp reads ni_section_data_table[] to verify overlay content. An
 *     empty table selects the legacy accept path, which is right for a static-only game.
 *  3. rt64/src/hle/rt64_application_window.cpp calls a retired diagnostic hook at setup.
 */

#include <stdint.h>
#include <stdio.h>
#include "recomp.h"

/* 1 - overlay boot-stub hook; loud if it ever fires for a game without that overlay format. */
RECOMP_FUNC void gamestate_change(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    fprintf(stderr, "[engine_shim] gamestate_change(%d) called - the overlay boot-stub path fired for a game without overlays?\n",
            (int)ctx->r4);
    fflush(stderr);
}

/* 2 - empty overlay section-content catalog (count = 0; the entry is never read). */
struct NiSectionData { uint32_t lma; const uint8_t* data; uint32_t size; };
const struct NiSectionData ni_section_data_table[] = { { 0u, 0, 0u } };
const size_t ni_section_data_table_count = 0;

/* 3 - retired diagnostic hook. */
void cv64_set_wild_store_watch(void* addr) {
    (void)addr;
}

/* Console-only build (RDPC_CONSOLE_ONLY, 2026-07-24): the S41 timing-fidelity cost accumulator
 * is DEFINED in rt64 (rt64_rsp.cpp) on the desktop tier; ultramodern's events.cpp reads it.
 * The RT64-free console carries no estimator — 0.0 = "no estimated cost" (the timing layer
 * idles; the console's pacing comes from the real rdpcore pipeline instead). */
#ifdef RDPC_CONSOLE_ONLY
double g_rdp_estimated_cost_cycles = 0.0;
#endif
