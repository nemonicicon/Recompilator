/**
 * default_gamestate_change.c — THE FALLBACK CV64 NI BOOT HOOK (2026-09-06).
 *
 * overlays.cpp's NI boot stubs call `gamestate_change()`, CV64's own game-side state machine. A
 * CV64-family application defines it (cv64pc/src/patches/misc.c; scaffolded trees define a loud
 * no-op in src/patches/engine_shims.c) and this file is then NEVER LINKED — it is a member of
 * librecomp.lib, reached only when the application left the symbol undefined.
 *
 * The Recompilator host registers no game of its own, so it links this; a game module supplies its
 * own through recomp_register_gamestate_change(), which overlays.cpp prefers when it is set.
 *
 * KEEP THIS FILE DEFINING NOTHING ELSE (see default_ni_section_data.c for why).
 */

#include <stdint.h>
#include <stdio.h>
#include "recomp.h"

void gamestate_change(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram; (void)ctx;
    /* Unreachable unless a CV64-family NI boot stub fires with no game module registered — which
     * would mean the NI path ran without a game. Loud, never silent. */
    fprintf(stderr, "[overlays] gamestate_change: no game registered one -- NI boot stub fired "
                    "with no handler (this should be impossible)\n");
    fflush(stderr);
}
