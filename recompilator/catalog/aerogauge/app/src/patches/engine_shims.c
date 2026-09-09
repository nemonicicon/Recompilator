/**
 * engine_shims.c — ENGINE-DEBT SHIMS (SESSION 44 scorecard findings).
 *
 * The pinned engine is not yet fully game-agnostic: librecomp and rt64
 * reference three CV64-game-side symbols unconditionally, so any game built
 * on these pins must define them. Each shim below is a finding, not a fix —
 * the real cure is moving these behind game callbacks in the engine
 * (the census-then-strip class). Recorded in the lab notes.
 *
 *  1. librecomp/src/overlays.cpp ni_stub_gamenote_delete_mgr calls
 *     gamestate_change() — CV64's NI boot-phase machinery living in the
 *     engine. Keyed to CV64 boot conditions; must never fire for AEROGAUGE.
 *  2. librecomp/src/overlays.cpp cv64_ni_section_content_matches reads
 *     ni_section_data_table[] — CV64's generated overlay-content catalog
 *     (the S36 content-verified matching). Empty table = legacy-accept path,
 *     correct for static-only AEROGAUGE (overlay recompilation is PHASE 3).
 *  3. rt64/src/hle/rt64_application_window.cpp ApplicationWindow::setup calls
 *     cv64_set_wild_store_watch() — a retired CV64 diagnostic hook (S31-33).
 */

#include <stdint.h>
#include <stdio.h>
#include "recomp.h"

/* Console-only build (RDPC_CONSOLE_ONLY): the S41 timing-fidelity cost accumulator is DEFINED
 * in rt64 (rt64_rsp.cpp) on the desktop tier; ultramodern's events.cpp reads it. The RT64-free
 * console carries no estimator — 0.0 = "no estimated cost" (the timing layer idles; the
 * console's pacing comes from the real rdpcore pipeline instead).
 * console seam ported from snowkidspc (2026-07-31 batch) */
#ifdef RDPC_CONSOLE_ONLY
double g_rdp_estimated_cost_cycles = 0.0;
#endif

/* 1 — CV64 NI boot-stub hook; loudly visible if it ever fires for AEROGAUGE. */
RECOMP_FUNC void gamestate_change(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    fprintf(stderr, "[engine_shim] gamestate_change(%d) called — CV64 NI boot-stub path fired for AEROGAUGE?!\n",
            (int)ctx->r4);
    fflush(stderr);
}

/* 2 — empty NI section-content catalog (count = 0; the entry is never read). */
struct NiSectionData { uint32_t lma; const uint8_t* data; uint32_t size; };
const struct NiSectionData ni_section_data_table[] = { { 0u, 0, 0u } };
const size_t ni_section_data_table_count = 0;

/* 3 — retired CV64 diagnostic hook. */
void cv64_set_wild_store_watch(void* addr) {
    (void)addr;
}
