/**
 * default_ni_section_data.c — THE FALLBACK NI SECTION-CONTENT CATALOG (2026-09-06).
 *
 * overlays.cpp reads `ni_section_data_table[] / ni_section_data_table_count` — CV64's generated
 * catalog of pre-extracted NI overlay contents. A CV64-family application defines them itself
 * (cv64pc/src/ni_section_data.c, or the empty pair in a scaffolded <game>pc/src/patches/
 * engine_shims.c) and this file is then NEVER LINKED: it is a member of librecomp.lib, and a
 * static library member is only pulled in when the application left the symbol undefined.
 *
 * That is the whole trick, and it is why no game tree had to change: an application that defines
 * these keeps its own; an application that does not — the Recompilator host, which registers no
 * game of its own and loads games as modules — gets this empty catalog and its modules then call
 * recomp_register_ni_section_data() to supply theirs.
 *
 * KEEP THIS FILE DEFINING NOTHING ELSE. Anything extra in here would be dragged into every link
 * that needs it and could collide with an application's own definitions.
 */

#include <stdint.h>
#include <stddef.h>

struct NiSectionData { uint32_t lma; const uint8_t* data; uint32_t size; };

/* count = 0; the single entry exists only so the array is not zero-sized. */
const struct NiSectionData ni_section_data_table[] = { { 0u, 0, 0u } };
const size_t ni_section_data_table_count = 0;
