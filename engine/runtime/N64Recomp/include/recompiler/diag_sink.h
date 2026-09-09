#ifndef N64RECOMP_DIAG_SINK_H
#define N64RECOMP_DIAG_SINK_H

// Structured diagnostics sink (recompilator roadmap tool #1).
//
// Replaces the scattered, per-site-capped `fprintf(stderr, ...)` warnings at every recompiler/runtime
// graceful-degrade site with ONE deduped, machine-readable JSON record. This is the foundation the rest
// of the self-correction loop consumes (tool #2 verify_diff_to_forcedata, tool #3 gap-journal/reingest).
//
// ONE API, ONE implementation (src/diag_sink.cpp, built as the leaf lib N64RecompDiag and linked into
// both the recompiler N64Recomp.exe and the runtime librecomp/game.exe). The implementation is
// thread-safe (the runtime calls record() from multiple game threads). Only the FLUSH wrappers differ:
//   - build  : N64Recomp main() calls diag::flush_to_file(<output_func_path>/failures.json, "build", "")
//   - runtime: librecomp at process exit calls diag::flush_to_file(<appdata>/<game>_gap_report.json,
//              "runtime", ",\"gap_cache\":[...]") with the serialized g_gap_cache appended.
//
// NO-OP BY DEFAULT: enabled() is false unless the env var RECOMP_DIAG is set. hit() folds to a single
// cached-bool branch when disabled, so baseline games/builds (sm64/cv64/robotron) pay nothing — the
// degrade sites are cold to begin with, and no map/string/file work happens unless RECOMP_DIAG is on.
//
// Events dedup by (kind | vaddr) and carry a hit_count. The four numeric slots a/b/c/d are reused
// per-kind; their meaning is documented at each call site and below. Strings in Event are NOT owned
// (string_view) — record() copies what it retains. Optional words[] carries a live-RDRAM dump (gfgap).
//
// Per-kind field meaning (so tool #3 can parse a/b/c/d):
//   unhandled-opcode              detail=opcode name
//   function-unanalyzable         a=func.vram, b=func.words.size()
//   static-stub                   detail=reason, a=rom, b=section.ram_addr, c=section.rom_addr
//   jal-nomatch/ambiguous/error   a=target_func_vram
//   branch-out-of-function        a=branch_target, b=func.vram
//   unconditional-branch-unhandled a=branch_target, b=func.vram
//   unsupported-reloc-type        a=(int)reloc_type
//   reloc-addend-mismatch         a=reloc_target_section_offset, b=ref_symbol.section_offset
//   severed-extend                detail=cause, a=before_words, b=after_words
//   rom-bounds-clamp              a=rom_address, b=before_words, c=after_words, d=rom.size()
//   jtbl-size-fail                a=jr_vram, b=func.vram, c=func.rom
//   gfgap-section-miss            a=rom_addr, b=ram_addr, c=sec_size, words=first 16 RDRAM words
//   cartbus-*/kseg0-raw-overlay   a=phys/rom, b=kseg0/ram

#include <cstdint>
#include <string>
#include <string_view>

namespace N64Recomp::diag {

struct Event {
    std::string_view kind;                  // dedup key part 1 (stable string literal)
    uint32_t vaddr = 0;                      // dedup key part 2
    std::string_view func;                   // optional: owning function name
    std::string_view detail;                 // optional: opcode / reloc text / free note
    uint32_t a = 0, b = 0, c = 0, d = 0;     // optional numeric slots (per-kind meaning, see header)
    uint32_t section_index = UINT32_MAX;      // optional (UINT32_MAX = omitted)
    uint32_t func_index = UINT32_MAX;         // optional (UINT32_MAX = omitted)
    const uint32_t* words = nullptr;          // optional live-RDRAM dump (not owned)
    uint32_t word_count = 0;
};

// True iff env RECOMP_DIAG is set (cached on first call). Default: false → fully no-op.
bool enabled();

// Dedup by (kind|vaddr), increment hit_count, retain a copy of the first sighting's strings/words.
// Thread-safe. Callers normally use hit() so the work folds away when disabled.
void record(const Event& e);

// Write the accumulated events to `path` as JSON. `stage` tags the file ("build"/"runtime").
// `extra_top_level_json` is spliced in before the closing brace (e.g. the runtime gap_cache array,
// as ",\"gap_cache\":[ ... ]"); pass "" for none. Returns true on a successful write. Safe to call
// when disabled (it just no-ops if there are no events).
bool flush_to_file(const std::string& path, std::string_view stage, std::string_view extra_top_level_json);

// Number of distinct (kind|vaddr) events currently held (for tests / sanity logging).
size_t event_count();

inline void hit(const Event& e) { if (enabled()) record(e); }

} // namespace N64Recomp::diag

#endif // N64RECOMP_DIAG_SINK_H
