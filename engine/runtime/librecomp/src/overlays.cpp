#include <algorithm>
#include <atomic>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <mutex>          // session 22: shared_mutex for func_map cross-thread safety
#include <shared_mutex>
#include <unordered_map>
#include <vector>

#include "recompiler/diag_sink.h"   // structured diagnostics sink (roadmap tool #1) — runtime dispatch-gap events

// NI overlay pre-extracted data (ni_section_data.c, compiled with cv64pc)
extern "C" {
    struct NiSectionData { uint32_t lma; const uint8_t* data; uint32_t size; };
    extern const NiSectionData ni_section_data_table[];
    extern const size_t ni_section_data_table_count;
}

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <intrin.h>   // cv64 S38: _AddressOfReturnAddress for the [gfstack] missing-fn stack scan
#endif

#include "ultramodern/ultramodern.hpp"

#include "recomp.h"
#include "recompiler/context.h"
#include "overlays.hpp"
#include "sections.h"
#include "librecomp/game.hpp"   // recomp::get_rom() — appended-overlay detection in init_overlays

// ── THE TWO CV64-SHAPED SYMBOLS THIS FILE USED TO DEMAND FROM EVERY APPLICATION ─────────────
extern "C" void gamestate_change(uint8_t* rdram, recomp_context* ctx);

// (Recompilator UI step 3, 2026-09-06.) `ni_section_data_table` / `_count` / `gamestate_change`
// were referenced unconditionally above, so every tree built on this engine — and even the
// launcher, which registers no game at all — had to carry an engine_shims.c defining them. A game
// that arrives as a LOADED MODULE cannot define a symbol in the host, so both are now indirected:
//
//   * an app that DEFINES them keeps working with no change at all — the references above still
//     bind to its own objects, and librecomp's fallbacks (src/default_ni_section_data.c,
//     src/default_gamestate_change.c) are library members the linker only reaches for when the
//     application left the symbol undefined;
//   * a HOST that loads games as modules links those fallbacks and lets each module register its
//     own through recomp_register_ni_section_data() / recomp_register_gamestate_change().
//
// Nothing else in the engine changes, and no game tree changes.
namespace {
    const NiSectionData* g_ni_table_override = nullptr;
    size_t               g_ni_count_override = 0;
    bool                 g_ni_overridden = false;
    recomp_func_t*       g_gamestate_change_override = nullptr;

    inline const NiSectionData* ni_table() {
        return g_ni_overridden ? g_ni_table_override : ni_section_data_table;
    }
    inline size_t ni_count() {
        return g_ni_overridden ? g_ni_count_override : ni_section_data_table_count;
    }
    inline void call_gamestate_change(uint8_t* rdram, recomp_context* ctx) {
        if (g_gamestate_change_override != nullptr) {
            g_gamestate_change_override(rdram, ctx);
        }
        else {
            gamestate_change(rdram, ctx);
        }
    }
}

extern "C" void recomp_register_ni_section_data(const void* table, size_t count) {
    g_ni_table_override = reinterpret_cast<const NiSectionData*>(table);
    g_ni_count_override = (table != nullptr) ? count : 0;
    g_ni_overridden = true;
    fprintf(stderr, "[overlays] NI section-content catalog registered: %zu entr%s\n",
            g_ni_count_override, g_ni_count_override == 1 ? "y" : "ies");
    fflush(stderr);
}

extern "C" void recomp_register_gamestate_change(recomp_func_t* fn) {
    g_gamestate_change_override = fn;
}

static recomp::overlays::overlay_section_table_data_t sections_info {};
static recomp::overlays::overlays_by_index_t overlays_info {};

static SectionTableEntry* patch_code_sections = nullptr;
size_t num_patch_code_sections = 0;
static std::vector<char> patch_data;

struct LoadedSection {
    int32_t loaded_ram_addr;
    size_t section_table_index;

    LoadedSection(int32_t loaded_ram_addr_, size_t section_table_index_) {
        loaded_ram_addr = loaded_ram_addr_;
        section_table_index = section_table_index_;
    }

    bool operator<(const LoadedSection& rhs) {
        return loaded_ram_addr < rhs.loaded_ram_addr;
    }
};

static std::unordered_map<uint32_t, uint16_t> code_sections_by_rom{};
static std::unordered_map<uint32_t, uint16_t> patch_code_sections_by_rom{};
static std::vector<LoadedSection> loaded_sections{};
// RDRAM the engine backs (the same 8 MB bound the raw-KSEG0 net below uses).
static constexpr uint32_t OVL_RDRAM_SIZE = 0x00800000u;
static std::unordered_map<int32_t, recomp_func_t*> func_map{};
/* session 22: protects func_map against cross-thread races. Multiple runtime
 * threads (game/recomp, RT64 gfx, audio, VI/scheduler) read func_map via
 * LOOKUP_FUNC; writes happen in load_overlay / unload_overlays / pinned setup.
 * std::unordered_map has no concurrent-safe guarantees — a parallel rehash on
 * insert can corrupt lookups happening on another thread without crashing.
 * shared_mutex: any number of concurrent readers (LOOKUP_FUNC), exclusive on
 * write. Principled runtime fix benefiting every N64Recomp port. */
static std::shared_mutex func_map_mtx{};
// Functions registered here are never erased by init_overlays() / func_map.clear().
// Use this for `ignored` functions that are called via indirect pointer (LOOKUP_FUNC)
// and therefore need a func_map entry even though N64Recomp generated no FuncEntry.
static std::unordered_map<int32_t, recomp_func_t*> pinned_funcs{};
static std::unordered_map<std::string, recomp_func_t*> base_exports{};
static std::unordered_map<std::string, recomp_func_ext_t*> ext_base_exports{};
static std::unordered_map<std::string, size_t> base_events;
static std::unordered_map<uint32_t, recomp_func_t*> manual_patch_symbols_by_vram;

extern "C" {
int32_t* section_addresses = nullptr;
}

void recomp::overlays::register_overlays(const overlay_section_table_data_t& sections, const overlays_by_index_t& overlays) {
    sections_info = sections;
    overlays_info = overlays;
}

void recomp::overlays::register_patches(const char* patch, std::size_t size, SectionTableEntry* sections, size_t num_sections) {
    patch_code_sections = sections;
    num_patch_code_sections = num_sections;

    patch_data.resize(size);
    std::memcpy(patch_data.data(), patch, size);

    patch_code_sections_by_rom.reserve(num_patch_code_sections);
    for (size_t i = 0; i < num_patch_code_sections; i++) {
        patch_code_sections_by_rom.emplace(patch_code_sections[i].rom_addr, i);
    }
}

void recomp::overlays::register_base_export(const std::string& name, recomp_func_t* func) {
    base_exports.emplace(name, func);
}

void recomp::overlays::register_ext_base_export(const std::string& name, recomp_func_ext_t* func) {
    ext_base_exports.emplace(name, func);
}

void recomp::overlays::register_base_exports(const FunctionExport* export_list) {
    std::unordered_map<uint32_t, recomp_func_t*> patch_func_vram_map{};

    // Iterate over all patch functions to set up a mapping of their vram address.
    for (size_t patch_section_index = 0; patch_section_index < num_patch_code_sections; patch_section_index++) {
        const SectionTableEntry* cur_section = &patch_code_sections[patch_section_index];

        for (size_t func_index = 0; func_index < cur_section->num_funcs; func_index++) {
            const FuncEntry* cur_func = &cur_section->funcs[func_index];
            patch_func_vram_map.emplace(cur_section->ram_addr + cur_func->offset, cur_func->func);
        }
    }

    // Iterate over exports, using the vram mapping to create a name mapping.
    for (const FunctionExport* cur_export = &export_list[0]; cur_export->name != nullptr; cur_export++) {
        auto it = patch_func_vram_map.find(cur_export->ram_addr);
        if (it == patch_func_vram_map.end()) {
            assert(false && "Failed to find exported function in patch function sections!");
        }
        base_exports.emplace(cur_export->name, it->second);
    }
}

recomp_func_t* recomp::overlays::get_base_export(const std::string& export_name) {
    auto it = base_exports.find(export_name);
    if (it == base_exports.end()) {
        return nullptr;
    }
    return it->second;
}

recomp_func_ext_t* recomp::overlays::get_ext_base_export(const std::string& export_name) {
    auto it = ext_base_exports.find(export_name);
    if (it == ext_base_exports.end()) {
        return nullptr;
    }
    return it->second;
}

void recomp::overlays::register_base_events(char const* const* event_names) {
    for (size_t event_index = 0; event_names[event_index] != nullptr; event_index++) {
        base_events.emplace(event_names[event_index], event_index);
    }
}

size_t recomp::overlays::get_base_event_index(const std::string& event_name) {
    auto it = base_events.find(event_name);
    if (it == base_events.end()) {
        return (size_t)-1;
    }
    return it->second;
}

size_t recomp::overlays::num_base_events() {
    return base_events.size();
}

const std::unordered_map<uint32_t, uint16_t>& recomp::overlays::get_vrom_to_section_map() {
    return code_sections_by_rom;
}

uint32_t recomp::overlays::get_section_ram_addr(uint16_t code_section_index) {
    return sections_info.code_sections[code_section_index].ram_addr;
}

std::span<const RelocEntry> recomp::overlays::get_section_relocs(uint16_t code_section_index) {
    if (code_section_index < sections_info.num_code_sections) {
        const auto& section = sections_info.code_sections[code_section_index];
        return std::span{ section.relocs, section.num_relocs };
    }
    assert(false);
    return {};
}

void recomp::overlays::add_loaded_function(int32_t ram, recomp_func_t* func) {
    std::unique_lock lock(func_map_mtx);
    func_map[ram] = func;
}

void recomp::overlays::register_pinned_function(int32_t vram, recomp_func_t* func) {
    // Survives func_map.clear() inside init_overlays().
    // Checked by get_function() before the "missing function" error path.
    pinned_funcs[vram] = func;
}

// The C face of the above, for a game that arrives as a MODULE (Recompilator, 2026-09-07).
// A module is built by the bundled clang and cannot name an MSVC-mangled C++ symbol, so the one
// registration the RAM-shadow class needs is offered under a plain C name. It writes the SAME map:
// there is no second registry and no per-game code anywhere in this path.
extern "C" void recomp_register_pinned_function(int32_t vram, recomp_func_t* func) {
    recomp::overlays::register_pinned_function(vram, func);
}

void load_overlay(size_t section_table_index, int32_t ram) {
    const SectionTableEntry& section = sections_info.code_sections[section_table_index];

    {
        std::unique_lock lock(func_map_mtx);
        for (size_t function_index = 0; function_index < section.num_funcs; function_index++) {
            const FuncEntry& func = section.funcs[function_index];
            func_map[ram + func.offset] = func.func;
        }
    }

    loaded_sections.emplace_back(ram, section_table_index);
    section_addresses[section.index] = ram;
}

static void load_special_overlay(const SectionTableEntry& section, int32_t ram) {
    std::unique_lock lock(func_map_mtx);
    for (size_t function_index = 0; function_index < section.num_funcs; function_index++) {
        const FuncEntry& func = section.funcs[function_index];
        func_map[ram + func.offset] = func.func;
    }
}

static void load_patch_functions() {
    if (patch_code_sections == nullptr) {
        debug_printf("[Patch] No patch section was registered\n");
        return;
    }
    for (size_t i = 0; i < num_patch_code_sections; i++) {
        load_special_overlay(patch_code_sections[i], patch_code_sections[i].ram_addr);
    }
}

void recomp::overlays::read_patch_data(uint8_t* rdram, gpr patch_data_address) {
    for (size_t i = 0; i < patch_data.size(); i++) {
        MEM_B(i, patch_data_address) = patch_data[i];
    }
}

extern "C" void load_overlays(uint32_t rom, int32_t ram_addr, uint32_t size) {
    // Search for the first section that's included in the loaded rom range
    // Sections were sorted by `init_overlays` so we can use the bounds functions
    auto lower = std::lower_bound(&sections_info.code_sections[0], &sections_info.code_sections[sections_info.num_code_sections], rom,
        [](const SectionTableEntry& entry, uint32_t addr) {
            return entry.rom_addr < addr;
        }
    );
    auto upper = std::upper_bound(&sections_info.code_sections[0], &sections_info.code_sections[sections_info.num_code_sections], (uint32_t)(rom + size),
        [](uint32_t addr, const SectionTableEntry& entry) {
            return addr < entry.size + entry.rom_addr;
        }
    );
    // Load the overlays that were found.
    // SM64PC SESSION 45: `it < upper`, NOT `it != upper` — when a (chunked) DMA
    // range lies strictly INSIDE one section without containing any whole
    // section, lower lands PAST upper (lower = first start >= rom is the NEXT
    // section; upper = first end > rom+size is the CURRENT one). `!=` then
    // walks forward off the end of the section table into garbage entries
    // (SM64's 0x1000-chunk audio-library DMA crashed here reading rom=-1).
    // `<` makes the degenerate range empty = the correct "no whole sections
    // in this DMA" answer.
    for (auto it = lower; it < upper; ++it) {
        load_overlay(std::distance(&sections_info.code_sections[0], it), it->rom_addr - rom + ram_addr);
    }
}

// Forward declarations — defined further below in the NI boot-phase stub section
static void ni_stub_gamenote_delete_mgr(uint8_t* rdram, recomp_context* ctx);
static void ni_stub_title_screen(uint8_t* rdram, recomp_context* ctx);

// Called from do_dma after a ROM→RDRAM copy. Finds every code section whose
// ROM address falls within [rom, rom+size) and registers it in func_map at the
// section's DEFAULT virtual RAM address (section.ram_addr) rather than at the
// DMA destination.
//
// This is necessary because CV64's NisitenmaIchigo overlay system uses MIPS
// kuseg virtual addresses (e.g. 0x0F000000) for function pointers, while the
// DMA physically writes to the KSEG0 mirror (0x8F000000). Using the default
// ram_addr ensures that get_function(0x0F000000) returns the right function.
//
// For standard overlay sections that DMA to their canonical KSEG0 address
// (MORI at 0x8018EB10, Reinhardt at 0x803D13E0, etc.) the default ram_addr
// already matches the DMA destination, so this is equally correct there.
// ── NI overlay: compressed-ROM → decompressed-ROM address translation ─────────
// CV64's NisitenmaIchigo file catalog stores ROM positions in the COMPRESSED
// baserom.z64.  The ELF linker uses DECOMPRESSED positions (from the splat
// YAML `start:` values) as the section LMA, which N64Recomp then stores as
// `rom_addr` in the section table.
//
// For three overlays that were previously type:bin and are now type:code the
// compressed address ≠ decompressed address.  Map them so the binary search
// in load_overlays_from_dma can find the correct section table entry.
//
//  Compressed (NI catalog)  →  Decompressed (ELF LMA / section rom_addr)
//   0x00B5140E                   0x00E509C0   ni_B5140E  (GAMENOTE_DELETE)
//   0x00B5166E                   0x00E50D40   ni_ovl_title_screen
//   0x00B528BA                   0x00E52700   ni_B528BA  (DATA_MENU)
static uint32_t translate_ni_rom_addr(uint32_t compressed_rom) {
    switch (compressed_rom) {
    case 0x00B5140E: return 0x00E509C0;  // ni_B5140E  (GAMENOTE_DELETE)
    case 0x00B5166E: return 0x00E50D40;  // ni_ovl_title_screen
    case 0x00B528BA: return 0x00E52700;  // ni_B528BA  (DATA_MENU)
    default:         return compressed_rom;
    }
}

extern "C" void load_overlays_from_dma(uint32_t rom, uint32_t size) {
    uint32_t rom_lookup = translate_ni_rom_addr(rom);

    // ── NI overlay path: compressed ROM → decompressed ELF address ────────────
    // The DMA size is the COMPRESSED overlay size; the section table stores the
    // DECOMPRESSED size.  The range-based binary search fails because the section
    // extends beyond (rom_lookup + compressed_size).  Use an exact hash-map lookup
    // instead — translate_ni_rom_addr gives us the precise ELF rom_addr.
    if (rom_lookup != rom) {
        fprintf(stderr, "[overlay] load_overlays_from_dma: NI translate 0x%08X → 0x%08X\n",
                rom, rom_lookup);
        fflush(stderr);
        auto it = code_sections_by_rom.find(rom_lookup);
        if (it != code_sections_by_rom.end()) {
            size_t section_index = it->second;
            const SectionTableEntry& section = sections_info.code_sections[section_index];
            fprintf(stderr, "[overlay]   → NI exact match: section[%zu] rom=0x%08X size=0x%X vram=0x%08X\n",
                    section_index, section.rom_addr, section.size, (uint32_t)section.ram_addr);
            fflush(stderr);
            load_overlay(section_index, (int32_t)section.ram_addr);

            // GAMENOTE_DELETE: needs NI catalog (TLB-mapped ROM) to load its UI
            // assets — catalog is inaccessible on PC.  This overlay is a Controller
            // Pak save-data integrity check; on PC (no pak) it should be an instant
            // pass.  Override its entry to call gamestate_change(KONAMI_LOGO)
            // directly, then let everything else in the section stay in func_map.
            if (rom_lookup == 0x00E509C0u) {
                {
                    std::unique_lock lock(func_map_mtx);
                    func_map[(int32_t)section.ram_addr] = ni_stub_gamenote_delete_mgr;
                }
                fprintf(stderr, "[overlay]   → GAMENOTE_DELETE entry 0x%08X → stub\n",
                        (uint32_t)section.ram_addr);
                fflush(stderr);
            }
        } else {
            fprintf(stderr, "[overlay]   → NI: no section with rom_addr=0x%08X in table\n", rom_lookup);
            fflush(stderr);
        }
        return;
    }

    // ── Standard DMA path: range-based binary search ──────────────────────────
    // Works because the DMA brings in the full (uncompressed) section: the
    // section's rom_addr and size are both within [rom, rom+size).
    auto lower = std::lower_bound(
        &sections_info.code_sections[0],
        &sections_info.code_sections[sections_info.num_code_sections],
        rom_lookup,
        [](const SectionTableEntry& entry, uint32_t addr) {
            return entry.rom_addr < addr;
        }
    );
    auto upper = std::upper_bound(
        &sections_info.code_sections[0],
        &sections_info.code_sections[sections_info.num_code_sections],
        (uint32_t)(rom_lookup + size),
        [](uint32_t addr, const SectionTableEntry& entry) {
            return addr < entry.size + entry.rom_addr;
        }
    );
    if (lower >= upper) {
        fprintf(stderr, "[overlay] load_overlays_from_dma: rom=0x%08X size=0x%X → no sections\n",
                rom_lookup, size);
    }
    // SM64PC SESSION 45: `it < upper`, NOT `it != upper` — see load_overlays
    // above for the degenerate interior-chunk case (lower past upper → `!=`
    // walks off the table; SM64's first boot crashed exactly here).
    for (auto it = lower; it < upper; ++it) {
        size_t section_index = std::distance(&sections_info.code_sections[0], it);
        int32_t default_ram  = (int32_t)it->ram_addr;
        fprintf(stderr, "[overlay]   → registering section idx=%zu (rom=0x%08X size=0x%X) at vram=0x%08X\n",
                section_index, it->rom_addr, it->size, (uint32_t)default_ram);
        load_overlay(section_index, default_ram);
    }
}

// Copy decompressed NI overlay data to RDRAM using MEM_B byte-swapping (XOR 3).
// Called from mapOverlay (funcs_84.c) after load_overlays_from_dma registers functions.
// Without this, data sections (jump tables, rodata) are zero in RDRAM → null-ptr crash.
extern "C" void ni_populate_rdram(uint8_t* rdram, uint32_t compressed_rom) {
    uint32_t lma = translate_ni_rom_addr(compressed_rom);
    if (lma == compressed_rom) {
        // Not a translated NI overlay — no data to populate
        return;
    }

    for (size_t i = 0; i < ni_count(); i++) {
        if (ni_table()[i].lma != lma) continue;

        // Get the overlay's vram base from the section table
        uint32_t vram_base = 0x0F000000u;
        auto it = code_sections_by_rom.find(lma);
        if (it != code_sections_by_rom.end()) {
            vram_base = (uint32_t)sections_info.code_sections[it->second].ram_addr;
        }

        const uint8_t* data = ni_table()[i].data;
        uint32_t sz = ni_table()[i].size;

        // (cont.19: stripped the per-populate [overlay] success log — ~22k fflush'd lines/run during
        //  the overlay-thrash; keeps the rare "no data entry" error below.)
        // MEM_B byte-swap: MIPS big-endian byte j → rdram[(vram+j) ^ 3]
        for (uint32_t j = 0; j < sz; j++) {
            rdram[(vram_base + j) ^ 3u] = data[j];
        }
        return;
    }

    fprintf(stderr, "[overlay] ni_populate_rdram: no data entry for lma=0x%08X\n", lma);
    fflush(stderr);
}

// Populate RDRAM directly from the ELF-embedded NI section data, given the
// section's decompressed LMA (ELF rom_addr).  Called by ni_populate_rdram_from_section.
static void ni_populate_rdram_by_lma(uint8_t* rdram, uint32_t lma) {
    for (size_t i = 0; i < ni_count(); i++) {
        if (ni_table()[i].lma != lma) continue;

        uint32_t vram_base = 0x0F000000u;
        auto it = code_sections_by_rom.find(lma);
        if (it != code_sections_by_rom.end()) {
            vram_base = (uint32_t)sections_info.code_sections[it->second].ram_addr;
        }

        const uint8_t* data = ni_table()[i].data;
        uint32_t sz = ni_table()[i].size;
        // (cont.19: stripped the per-populate [overlay] success log.)
        for (uint32_t j = 0; j < sz; j++) {
            rdram[(vram_base + j) ^ 3u] = data[j];
        }
        return;
    }
    fprintf(stderr, "[overlay] ni_populate_rdram_by_lma: no data entry for lma=0x%08X\n", lma);
    fflush(stderr);
}

// Find the NI section currently loaded at `vram` (e.g. 0x0F000000) and write
// its data into RDRAM.  Called by mapOverlay when the segment-address table
// contains a TLB virtual address instead of a KSEG0 ROM address (which happens
// for all NI overlay entries because the original N64 code stores the TLB
// virtual target in that table rather than the physical ROM source).
extern "C" void ni_populate_rdram_from_section(uint8_t* rdram, uint32_t vram) {
    // NI overlays share the same vram (0x0F000000). Iterate in reverse so the
    // most recently loaded section wins over older ones still in loaded_sections.
    for (auto it = loaded_sections.rbegin(); it != loaded_sections.rend(); ++it) {
        const auto& section = sections_info.code_sections[it->section_table_index];
        if ((uint32_t)section.ram_addr != vram) continue;
        ni_populate_rdram_by_lma(rdram, section.rom_addr);
        return;
    }
    fprintf(stderr, "[overlay] ni_populate_rdram_from_section: no section at vram=0x%08X\n", vram);
    fflush(stderr);
}

// Called by mapOverlay for NI overlays (0x0F000000 and 0x0E000000 vram ranges).
// Finds the unique ELF section matching (vram, exact_size), registers its recompiled
// functions in func_map if not already done, populates ONLY this section's data bytes
// into RDRAM, and returns the section's LMA (ELF rom_addr) so mapOverlay can record
// the entity→LMA mapping.  Returns 0 if no matching section is found.
//
// We do NOT repopulate peer sections here.  Multiple NI entities can be alive at the
// same vram simultaneously (e.g. title_screen=0x19C0 and cutscene_02=0x6880 both at
// 0x0F000000 during GAMESTATE_INTRO_CUTSCENE).  The N64 TLB remapped vram per-call
// so each entity saw only its own data.  We emulate that by populating only the
// current entity's data immediately before its function runs.  Dying entities (whose
// mapOverlay fires with file_id=0 and returns early before reaching here) are handled
// by mapOverlay using the entity→LMA table it maintains.
// ── cont.39 (the Renon stall): CONTENT-verified section matching ─────────────────
// Two NI overlays can share the exact (vram, decompressed size) — cutscene_03 "Bridge Lowers" and
// cutscene_0B "Renon's First Appearance" are BOTH (0x0E000000, 0x18C0) — so the (vram,size) match
// alone picks whichever section comes FIRST: Renon's cutscene loaded the bridge cutscene's CODE and
// dispatched garbage (fn-ptr 0xFFA7002D) forever. The census shows SIX such colliding pairs at
// 0x0E000000 alone. The game has already decompressed the TRUE file into its own buffer
// (loaded_files_ptr[t2]) — the ground truth the hardware would execute — so verify each candidate by
// comparing the section's extracted ELF bytes against that buffer (RDRAM is ^3-swizzled). Faithful by
// construction: we load exactly the code the game decompressed. buf_phys==0 (buffer unknown) or no
// extracted data for the section -> accept (legacy behavior, can't verify).
// cont.40 [nimatch] DIAGNOSIS (SESSION 37, Renon still absent): log each unique (lma, buf, verdict)
// ONCE so a single logged run discriminates the three suspects: SKIP-nobuf everywhere = the gate
// never engages (loaded_files_ptr empty for cutscene files); REJECT for every candidate = a
// buffer<->section byte offset (e.g. file header) starves both passes into the silent fallback;
// ACCEPT of cs0B (lma 0x00E759D0) at the contract pickup with the stall persisting = second root.
static void cv64_nimatch_log(uint32_t lma, uint32_t buf, const char* verdict, uint32_t detail) {
    static uint32_t seen[1024]; static int seen_n = 0;
    uint32_t h = lma ^ (buf << 16) ^ (buf >> 16) ^ ((uint32_t)(uint8_t)verdict[0] << 24);
    for (int i = 0; i < seen_n; i++) if (seen[i] == h) return;
    if (seen_n >= 1024) return;
    seen[seen_n++] = h;
    fprintf(stderr, "[nimatch] %s lma=0x%08X buf=0x%08X detail=0x%X\n", verdict, lma, buf, detail);
    fflush(stderr);
}

static bool cv64_ni_section_content_matches(uint8_t* rdram, uint32_t lma, uint32_t buf_phys) {
    if (buf_phys == 0u) { cv64_nimatch_log(lma, 0u, "SKIP-nobuf", 0u); return true; }
    for (size_t i = 0; i < ni_count(); i++) {
        if (ni_table()[i].lma != lma) continue;
        const uint8_t* data = ni_table()[i].data;
        uint32_t n = ni_table()[i].size;
        if (n > 0x300u) n = 0x300u;   // a few hundred bytes is decisive; keeps the per-dispatch re-match cheap
        for (uint32_t k = 0; k < n; k++) {
            if (data[k] != rdram[(size_t)((buf_phys + k) ^ 3u)]) {
                cv64_nimatch_log(lma, buf_phys, "REJECT", k);   // detail = first differing offset
                return false;
            }
        }
        cv64_nimatch_log(lma, buf_phys, "ACCEPT", n);
        return true;
    }
    cv64_nimatch_log(lma, buf_phys, "ACCEPT-nodata", 0u);
    return true;
}

extern "C" uint32_t load_and_populate_ni_overlay(uint8_t* rdram, uint32_t vram, uint32_t exact_size, uint32_t buf_phys) {
    for (size_t i = 0; i < sections_info.num_code_sections; i++) {
        const SectionTableEntry& section = sections_info.code_sections[i];
        if ((uint32_t)section.ram_addr != vram) continue;
        if (section.size != exact_size) continue;
        if (!cv64_ni_section_content_matches(rdram, (uint32_t)section.rom_addr, buf_phys)) continue;   // cont.39

        bool already_loaded = false;
        for (const auto& ls : loaded_sections) {
            if (ls.section_table_index == i) { already_loaded = true; break; }
        }
        if (!already_loaded) {
            load_overlay(i, (int32_t)section.ram_addr);
            fprintf(stderr, "[overlay] load_and_populate_ni_overlay: loaded section[%zu] rom=0x%08X vram=0x%08X size=0x%X\n",
                    i, section.rom_addr, vram, exact_size);
            fflush(stderr);
        } else {
            // Re-register this section's functions in func_map on every call.
            // Multiple NI sections can share the same vram (e.g. 0x0F000000).
            // When load_overlay runs for a later section it overwrites the func_map
            // entries the earlier section set (both have funcs at offset 0x0, 0x70,
            // etc.).  mapOverlay is called immediately before each entity's behavior
            // function, so re-registering here ensures this entity's implementations
            // are in func_map by the time the game dispatches through NI_TABLE.
            // load_special_overlay does only the func_map writes, no loaded_sections
            // bookkeeping, so there is no risk of duplicate loaded_sections entries.
            load_special_overlay(section, (int32_t)section.ram_addr);
        }

        ni_populate_rdram_by_lma(rdram, (uint32_t)section.rom_addr);
        return (uint32_t)section.rom_addr;
    }
    // ── Second pass: NI overlay compiled for a DIFFERENT segment than requested ──
    // Some cutscene overlays are loaded by the game at a vram that differs from their
    // ELF section ram_addr.  Concrete case: the narrator prologue (NI file 0xD2,
    // "Cutscene 10") = section "ni_ovl_title_demo", ELF ram_addr=0x0F000000 size=0x2460,
    // but the game's NI function table points its entry at vram=0x0E000000.  The exact
    // (ram_addr==vram && size) match above therefore misses it.  These sections are
    // position-independent (num_relocs=0; load_overlay sets section_addresses[index]=ram
    // so every intra-overlay code/data reference relocates to the load base).  Match by
    // size within the NI overlay window (0x0E/0x0F) and load at the REQUESTED vram,
    // copying the section's data bytes there too (NOT to its ELF ram_addr).
    for (size_t i = 0; i < sections_info.num_code_sections; i++) {
        const SectionTableEntry& section = sections_info.code_sections[i];
        uint32_t sram = (uint32_t)section.ram_addr;
        if (sram < 0x0E000000u || sram >= 0x10000000u) continue;  // NI overlay window only
        if (section.size != exact_size) continue;                 // size discriminator
        if (!cv64_ni_section_content_matches(rdram, (uint32_t)section.rom_addr, buf_phys)) continue;   // cont.39

        // The overlay's recompiled code references its OWN data via absolute `lui`
        // (e.g. `lui $t9,0x0F00; lw $t9,0x2438($t9)` — a jump table at 0x0F002438), so
        // both the code's intra-section refs AND its data MUST live at the section's
        // NATIVE ram_addr (sram, e.g. 0x0F000000).  load_overlay(i, sram) registers funcs
        // at sram+offset and sets section_addresses[index]=sram so all of that resolves.
        bool already_loaded = false;
        for (const auto& ls : loaded_sections) {
            if (ls.section_table_index == i) { already_loaded = true; break; }
        }
        if (!already_loaded) load_overlay(i, (int32_t)sram);
        else                 load_special_overlay(section, (int32_t)sram);

        // The game's NI function table points obj 0x203B's entry at the REQUESTED vram
        // (0x0E000000), which differs from the section's native base.  Alias every func at
        // the requested vram too, so the game's entry call (and any vram-based call) resolves
        // to the same recompiled functions.  (Harmless duplicate func_map entries.)
        if ((uint32_t)sram != vram) load_special_overlay(section, (int32_t)vram);

        // Populate the section's data at its NATIVE ram_addr (where the absolute `lui` refs
        // read it).  ni_populate_rdram_by_lma copies to the ELF ram_addr (=sram) — correct here.
        ni_populate_rdram_by_lma(rdram, (uint32_t)section.rom_addr);

        fprintf(stderr, "[overlay] load_and_populate_ni_overlay: SIZE-MATCH section[%zu] rom=0x%08X nativeram=0x%08X (entry aliased @vram=0x%08X) size=0x%X\n",
                i, section.rom_addr, sram, vram, exact_size);
        fflush(stderr);
        return (uint32_t)section.rom_addr;
    }

    // Dump first few matching sections so we can see their actual sizes
    fprintf(stderr, "[overlay] load_and_populate_ni_overlay: no section for vram=0x%08X size=0x%X — dumping candidates:\n", vram, exact_size);
    int shown = 0;
    for (size_t i = 0; i < sections_info.num_code_sections && shown < 10; i++) {
        const SectionTableEntry& s = sections_info.code_sections[i];
        if ((uint32_t)s.ram_addr == vram) {
            fprintf(stderr, "  section[%zu] rom=0x%08X ram=0x%08X size=0x%X\n", i, s.rom_addr, (uint32_t)s.ram_addr, s.size);
            shown++;
        }
    }
    fflush(stderr);
    return 0;
}

// Repopulate a single NI section's RDRAM data given its LMA.  Called by mapOverlay
// for dying entities (file_id=0) that skip load_and_populate_ni_overlay but still
// need their data restored before their cleanup function runs.
extern "C" void ni_repopulate_by_lma(uint8_t* rdram, uint32_t lma) {
    ni_populate_rdram_by_lma(rdram, lma);
}

extern "C" void unload_overlay_by_id(uint32_t id) {
    uint32_t section_table_index = overlays_info.table[id];
    const SectionTableEntry& section = sections_info.code_sections[section_table_index];

    auto find_it = std::find_if(loaded_sections.begin(), loaded_sections.end(), [section_table_index](const LoadedSection& s) { return s.section_table_index == section_table_index; });

    if (find_it != loaded_sections.end()) {
        // Determine where each function was loaded to and remove that entry from the function map
        {
            std::unique_lock lock(func_map_mtx);
            for (size_t func_index = 0; func_index < section.num_funcs; func_index++) {
                const auto& func = section.funcs[func_index];
                uint32_t func_address = func.offset + find_it->loaded_ram_addr;
                func_map.erase(func_address);
            }
        }
        // Reset the section's address in the address table
        section_addresses[section.index] = section.ram_addr;
        // Remove the section from the loaded section map
        loaded_sections.erase(find_it);
    }
}

extern "C" void load_overlay_by_id(uint32_t id, uint32_t ram_addr) {
    uint32_t section_table_index = overlays_info.table[id];
    const SectionTableEntry& section = sections_info.code_sections[section_table_index];
    int32_t prev_address = section_addresses[section.index];
    if (/*ram_addr >= 0x80000000 && ram_addr < 0x81000000) {*/ prev_address == section.ram_addr) {
        load_overlay(section_table_index, ram_addr);
    }
    else {
        int32_t new_address = prev_address + ram_addr;
        unload_overlay_by_id(id);
        load_overlay(section_table_index, new_address);
    }
}

extern "C" void unload_overlays(int32_t ram_addr, uint32_t size) {
    for (auto it = loaded_sections.begin(); it != loaded_sections.end();) {
        const auto& section = sections_info.code_sections[it->section_table_index];

        // Check if the unloaded region overlaps with the loaded section
        if (ram_addr < (it->loaded_ram_addr + section.size) && (ram_addr + size) >= it->loaded_ram_addr) {
            // Check if the section isn't entirely in the loaded region
            if (ram_addr > it->loaded_ram_addr || (ram_addr + size) < (it->loaded_ram_addr + section.size)) {
                fprintf(stderr,
                    "Cannot partially unload section\n"
                    "  rom: 0x%08X size: 0x%08X loaded_addr: 0x%08X\n"
                    "  unloaded_ram: 0x%08X unloaded_size : 0x%08X\n",
                        section.rom_addr, section.size, it->loaded_ram_addr, ram_addr, size);
                assert(false);
                std::exit(EXIT_FAILURE);
            }
            // Determine where each function was loaded to and remove that entry from the function map
            {
                std::unique_lock lock(func_map_mtx);
                for (size_t func_index = 0; func_index < section.num_funcs; func_index++) {
                    const auto& func = section.funcs[func_index];
                    uint32_t func_address = func.offset + it->loaded_ram_addr;
                    func_map.erase(func_address);
                }
            }
            // Reset the section's address in the address table
            section_addresses[section.index] = section.ram_addr;
            // Remove the section from the loaded section map
            it = loaded_sections.erase(it);
            // Skip incrementing the iterator
            continue;
        }
        ++it;
    }
}

void recomp::overlays::init_overlays() {
    {
        std::unique_lock lock(func_map_mtx);
        func_map.clear();
    }
    section_addresses = (int32_t *)calloc(sections_info.total_num_sections, sizeof(int32_t));

    // Sort the executable sections by rom address
    std::sort(&sections_info.code_sections[0], &sections_info.code_sections[sections_info.num_code_sections],
        [](const SectionTableEntry& a, const SectionTableEntry& b) {
            return a.rom_addr < b.rom_addr;
        }
    );

    for (size_t section_index = 0; section_index < sections_info.num_code_sections; section_index++) {
        SectionTableEntry* code_section = &sections_info.code_sections[section_index];

        section_addresses[sections_info.code_sections[section_index].index] = code_section->ram_addr;
        code_sections_by_rom[code_section->rom_addr] = section_index;
    }

    // SM64PC SESSION 45: register STATIC (non-overlapping) sections at init.
    // func_map population was previously DMA-driven only (load_overlays*),
    // which assumes the game DMAs whole sections in single transfers (true for
    // CV64/LoD). SM64 streams its segments in 0x1000-byte CHUNKS — no chunk
    // ever contains a whole section, so nothing was ever registered and the
    // game's first pointer dispatch (the audio per-frame entry 0x8037EE48,
    // from a pointer table in lib_data) hit the gfgap recovery net forever =
    // the boot-#2 black-screen stall. On hardware a function is callable once
    // its bytes are in place; for sections with UNIQUE vram ranges, registering
    // at init is exactly that semantic — the byte-exact recomp gate guarantees
    // the game's DMA'd bytes match the recompiled code. Sections whose vram
    // range overlaps another's (CV64-style shared 0x0E/0x0F overlay windows)
    // keep the dynamic DMA/mapOverlay-driven registration path.
    for (size_t i = 0; i < sections_info.num_code_sections; i++) {
        const SectionTableEntry& si = sections_info.code_sections[i];
        bool overlaps = false;
        for (size_t j = 0; j < sections_info.num_code_sections && !overlaps; j++) {
            if (i == j) continue;
            const SectionTableEntry& sj = sections_info.code_sections[j];
            uint32_t ai = (uint32_t)si.ram_addr, bi = ai + si.size;
            uint32_t aj = (uint32_t)sj.ram_addr, bj = aj + sj.size;
            overlaps = (ai < bj) && (aj < bi);
        }
        // Init census (permanent, bounded): one line per static section verdict. Born on
        // turok2's window-model bring-up, where "which sections actually registered" had to
        // be inferred instead of read — this is the read.
        if (i < 16) {
            fprintf(stderr, "[overlay] init: section[%zu] vram=0x%08X size=0x%X funcs=%zu -> %s\n",
                    i, (uint32_t)si.ram_addr, si.size, si.num_funcs,
                    overlaps ? "SKIPPED (vram overlap, DMA-driven path)" : "registered");
            fflush(stderr);
        }
        if (!overlaps) {
            load_overlay(i, (int32_t)si.ram_addr);
        }
    }

    // DECOMPRESSED-OVERLAY POST-PASS (2026-07-18, SOTE class): a section whose rom_addr lies
    // BEYOND the pristine ROM end is an APPENDED decompressed/snapshot overlay
    // (decompress_overlays.py / the RAM-snapshot recipe) — it carries the RUNTIME-TRUE bytes for
    // its vram range. Register it at init even when its vram overlaps resident sections, LAST,
    // so its func_map entries OVERRIDE any resident functions recompiled from the compressed
    // garbage that statically occupies those addresses (the fictional-function hazard, proven on
    // drmario/SOTE: the ROM's mapped bytes at those vram are packed data, not the code that runs).
    // Ordinary swapped overlays (cv64 NI class) have rom_addr INSIDE the ROM -> untouched, they
    // keep the DMA-driven path.
    {
        // RECOMP_SNAP_OVERLAY_OFF=1: skip the force-registration so a capture run behaves like
        // the pre-materialization world (gap nets execute the TRUE code) — used to (re)take the
        // RAM snapshot that the overlay itself is built from, without the chicken-and-egg of a
        // half-poisoned overlay stalling the boot before the unpack completes.
        const char* snap_off = std::getenv("RECOMP_SNAP_OVERLAY_OFF");
        size_t rom_size = (snap_off != nullptr && snap_off[0] == '1') ? 0 : recomp::get_rom().size();
        for (size_t i = 0; i < sections_info.num_code_sections; i++) {
            const SectionTableEntry& si = sections_info.code_sections[i];
            if (rom_size != 0 && (size_t)si.rom_addr >= rom_size) {
                fprintf(stderr, "[overlay] init: appended overlay section[%zu] rom=0x%08X vram=0x%08X "
                                "size=0x%X — force-registered (runtime-true bytes)\n",
                        i, si.rom_addr, (uint32_t)si.ram_addr, si.size);
                fflush(stderr);
                load_overlay(i, (int32_t)si.ram_addr);
            }
        }
    }

    load_patch_functions();

    // init_overlays() has just cleared func_map, so this is the moment at which the pinned map is
    // the only thing keeping a RAM-shadow set's functions reachable. Say how many there are: with
    // a game linked into the exe the count comes from src/main.cpp's register_ram_shadow_pins(),
    // with a game loaded as a MODULE it comes from that module's module_init() through
    // recomp_register_pinned_function() -- and a silent 0 here is exactly the failure that turns a
    // RAM-shadow cart into an all-interpreter one with no other symptom.
    fprintf(stderr, "[overlay] init: %zu code section(s) registered, %zu pinned function(s)\n",
            sections_info.num_code_sections, pinned_funcs.size());
    fflush(stderr);
}

// Finds a function given a section's index and the function's offset into the section.
bool recomp::overlays::get_func_entry_by_section_index_function_offset(uint16_t code_section_index, uint32_t function_offset, FuncEntry& func_out) {
    if (code_section_index >= sections_info.num_code_sections) {
        return false;
    }

    SectionTableEntry* section = &sections_info.code_sections[code_section_index];
    if (function_offset >= section->size) {
        return false;
    }
    
    // TODO avoid a linear lookup here.
    for (size_t func_index = 0; func_index < section->num_funcs; func_index++) {
        if (section->funcs[func_index].offset == function_offset) {
            func_out = section->funcs[func_index];
            return true;
        }
    }

    return false;
}

void recomp::overlays::register_manual_patch_symbols(const ManualPatchSymbol* manual_patch_symbols) {
    for (size_t i = 0; manual_patch_symbols[i].func != nullptr; i++) {
        if (!manual_patch_symbols_by_vram.emplace(manual_patch_symbols[i].ram_addr, manual_patch_symbols[i].func).second) {
            printf("Duplicate manual patch symbol address: %08X\n", manual_patch_symbols[i].ram_addr);
            ultramodern::error_handling::message_box("Duplicate manual patch symbol address (syms.ld)!");
            assert(false && "Duplicate manual patch symbol address (syms.ld)!");
            ultramodern::error_handling::quick_exit(__FILE__, __LINE__, __FUNCTION__);
        }
    }
}

// TODO use N64Recomp::is_manual_patch_symbol instead after updating submodule.
bool is_manual_patch_symbol(uint32_t vram) {
    return vram >= 0x8F000000 && vram < 0x90000000;
}

// Finds a function given a section's index and the function's offset into the section and returns its native pointer.
recomp_func_t* recomp::overlays::get_func_by_section_index_function_offset(uint16_t code_section_index, uint32_t function_offset) {
    FuncEntry entry;
    
    if (get_func_entry_by_section_index_function_offset(code_section_index, function_offset, entry)) {
        return entry.func;
    }

    if (code_section_index == N64Recomp::SectionAbsolute && is_manual_patch_symbol(function_offset)) {
        auto find_it = manual_patch_symbols_by_vram.find(function_offset);
        if (find_it != manual_patch_symbols_by_vram.end()) {
            return find_it->second;
        }
    }

    return nullptr;
}

// Finds a function given a section's rom address and the function's vram address.
recomp_func_t* recomp::overlays::get_func_by_section_rom_function_vram(uint32_t section_rom, uint32_t function_vram) {
    auto find_section_it = code_sections_by_rom.find(section_rom);
    if (find_section_it == code_sections_by_rom.end()) {
        return nullptr;
    }

    SectionTableEntry* section = &sections_info.code_sections[find_section_it->second];
    int32_t func_offset = function_vram - section->ram_addr;
    
    return get_func_by_section_index_function_offset(find_section_it->second, func_offset);
}

// ── gamestate_change — defined in src/patches/misc.c ──────────────────────────
extern "C" void gamestate_change(uint8_t* rdram, recomp_context* ctx);

// ── ni_register_vaddr_noop ────────────────────────────────────────────────────
// Called by mapOverlay (misc.c) to replace a specific NI virtual address with a
// permanent no-op in func_map.  Used to prevent cutscene entities that have
// blocking state machines from hanging the main thread in TITLE_SCREEN context.
static void ni_entity_noop(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram; (void)ctx;
}

extern "C" void ni_register_vaddr_noop(uint32_t vaddr) {
    std::unique_lock lock(func_map_mtx);
    func_map[(int32_t)vaddr] = ni_entity_noop;
}

// ── NI overlay stubs (get_function fallbacks) ─────────────────────────────────
// These stubs fire ONLY on a func_map miss for the NI address range
// (0x0E000000–0x0FFFFFFF).  When native code loads successfully via
// load_overlays_from_dma → load_overlay, func_map is populated and these
// stubs are never reached.
//
// They exist as a safety net for the case where an NI section fails to load
// (e.g. translate_ni_rom_addr doesn't cover that ROM offset) so the game
// doesn't soft-lock at a blank screen forever.
//
// Phase enum drives which stub fires for which entry vaddr:
//   Phase 0 (GAMENOTE_DELETE) — fallback at 0x0F000000 if section fails to load
//   Phase 1 (TITLE_SCREEN)    — fallback at 0x0F0004F0 if section fails to load
//   Phase 2 (DONE)            — all remaining NI misses → noop (gameplay overlays)

enum class NiBootPhase : uint8_t { GAMENOTE_DELETE, TITLE_SCREEN, DONE };
static std::atomic<NiBootPhase> ni_boot_phase{NiBootPhase::GAMENOTE_DELETE};

static void ni_stub_gamenote_delete_mgr(uint8_t* rdram, recomp_context* ctx) {
    // NI_OVL_GAMENOTE_DELETE_MGR — boot save-data integrity check.
    // On real hardware: reads Controller Pak, may show "delete corrupt data"
    // prompt, then calls gamestate_change(GAMESTATE_KONAMI_LOGO).
    // PC port: no Controller Pak; skip check and advance immediately.
    fprintf(stderr,
        "[overlay] ni_stub GAMENOTE_DELETE_MGR (0x0F000000): "
        "advancing to GAMESTATE_KONAMI_LOGO\n");
    fflush(stderr);
    ni_boot_phase.store(NiBootPhase::TITLE_SCREEN, std::memory_order_release);
    ctx->r4 = 1; // GAMESTATE_KONAMI_LOGO
    call_gamestate_change(rdram, ctx);
}

static void ni_stub_title_screen(uint8_t* rdram, recomp_context* ctx) {
    // NI_OVL_TITLE_SCREEN — title screen UI (type:bin, no native code).
    // On real hardware: renders title + waits for Start, then calls
    // gamestate_change(GAMESTATE_DATA_MENU).
    // PC port: DATA_MENU is also type:bin — skip both, land at STAGE_SELECT.
    fprintf(stderr,
        "[overlay] ni_stub TITLE_SCREEN (0x0F0004F0): "
        "advancing to GAMESTATE_STAGE_SELECT\n");
    fflush(stderr);
    ni_boot_phase.store(NiBootPhase::DONE, std::memory_order_release);
    ctx->r4 = 4; // GAMESTATE_STAGE_SELECT
    call_gamestate_change(rdram, ctx);
}

static void ni_stub_noop(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram; (void)ctx;
}

// General MIPS-interpreter fallback (recomp_interp.cpp): runs un-recompiled overlay code.
extern "C" void recomp_interp_set_target(uint32_t vaddr);
extern "C" void recomp_interp_trampoline(uint8_t* rdram, recomp_context* ctx);

// LiveRecompiler-backed gap fallback (recomp_live_gap.cpp): JITs the target with the same
// codegen as the static recompiler instead of interpreting it. Same trampoline shape.
extern "C" void recomp_live_gap_set_target(uint32_t vaddr);
extern "C" void recomp_live_gap_trampoline(uint8_t* rdram, recomp_context* ctx);

// Choose the dispatch-gap handler for un-recompiled code reached at runtime. The
// LiveRecompiler (recomp_live_gap.cpp) is the better path — same codegen as static recomp,
// native speed, and FAIL-SAFE on non-code (no wild-store crash like the interpreter).
// DEFAULT ON since 2026-07-01 (generalization worklist #3): code reached at runtime must
// execute with recompiled semantics for every game, not only hand-env'd ones (fixed 1080 to
// 60fps). RECOMP_LIVE_GAP=0 opts back into the legacy interpreter (bring-up comparison only).
// Regression-gated on cv64's 0x0F NI-overlay render path (the previously interpreter-
// load-bearing consumer) + sm64 + robotron.
static recomp_func_t* dispatch_gap_target(uint32_t vaddr) {
    static const bool use_live = []{
        const char* e = std::getenv("RECOMP_LIVE_GAP");
        return !(e != nullptr && e[0] == '0');
    }();
    if (use_live) {
        recomp_live_gap_set_target(vaddr);
        return recomp_live_gap_trampoline;
    }
    recomp_interp_set_target(vaddr);
    return recomp_interp_trampoline;
}

// Native-only function lookup used by the interpreter to decide native-call vs interpret.
// Same resolution as get_function's success/pinned paths, but returns nullptr on miss
// (no NI stub, no interpreter, no error). Acquires its own shared_lock.
extern "C" recomp_func_t* recomp_lookup_native(uint32_t addr) {
    if (addr == 0) return nullptr;
    std::shared_lock<std::shared_mutex> _lk(func_map_mtx);
    auto it = func_map.find((int32_t)addr);
    if (it != func_map.end()) return it->second;
    auto pin = pinned_funcs.find((int32_t)addr);
    if (pin != pinned_funcs.end()) return pin->second;
    return nullptr;
}

// cont.39 (tlb.cpp): buffer-phys -> overlay-window vaddr translation for window-mapped NI buffers.
extern "C" uint32_t recomp_overlay_window_vaddr_for(uint32_t phys);
extern "C" uint32_t recomp_tlb_vaddr_for_phys(uint32_t phys);   // tlb.cpp: reverse translation
// Conker (cart-bus window): LLE-TLB vaddr->phys translation (tlb.cpp) for the cart-bus code-dispatch recovery.
extern "C" uint32_t recomp_tlb_translate(uint32_t vaddr);
// tlb.cpp: VALID-mapping test (translate flat-maps every miss, so it cannot answer this).
extern "C" int recomp_tlb_is_mapped(uint32_t vaddr, uint32_t* phys_out);
// cv64 SESSION 38e (recomp.cpp): rdram base for the [gfgap] live-byte dump.
extern "C" uint8_t* g_rdram_base;
// SESSION 44: first-word code probe (recomp_interp.cpp) for the raw-KSEG0-overlay net.
extern "C" int recomp_interp_is_code(uint8_t* rdram, uint32_t addr);


// ══ RUNTIME-RELOCATED OVERLAY BINDER ══ (mechanism: see the call site inside get_function)
static inline uint32_t ovl_read_word(uint32_t vaddr) {
    const uint32_t phys = vaddr & 0x1FFFFFFFu;
    const uint8_t* r = g_rdram_base;
    return ((uint32_t)r[(size_t)((phys + 0u) ^ 3u)] << 24) |
           ((uint32_t)r[(size_t)((phys + 1u) ^ 3u)] << 16) |
           ((uint32_t)r[(size_t)((phys + 2u) ^ 3u)] <<  8) |
           ((uint32_t)r[(size_t)((phys + 3u) ^ 3u)]);
}

// A section is "runtime-relocated" when it carries relocations and its canonical vram is not RAM.
static inline bool ovl_is_runtime_relocated(const SectionTableEntry& s) {
    return s.num_relocs > 0 && ((uint32_t)s.ram_addr - 0x80000000u) >= OVL_RDRAM_SIZE;
}

struct OvlProbe { uint32_t offset; uint32_t target_off; uint32_t type; };
static std::vector<std::vector<OvlProbe>> ovl_probes{};
static std::unordered_map<uint32_t, uint32_t> ovl_bind_failed{};   // addr -> generation it failed in
static uint32_t ovl_bind_generation = 1;
static bool ovl_any_runtime_relocated = false;

static void ovl_build_probes() {
    ovl_probes.resize(sections_info.num_code_sections);
    for (size_t i = 0; i < sections_info.num_code_sections; i++) {
        const SectionTableEntry& s = sections_info.code_sections[i];
        if (!ovl_is_runtime_relocated(s)) {
            continue;
        }
        ovl_any_runtime_relocated = true;
        // Self-referencing R_MIPS_32 / R_MIPS_26 relocations only: those two carry the whole
        // relocated value in one word, so a single guest read decides them (HI16 needs its LO16).
        for (size_t k = 0; k < s.num_relocs && ovl_probes[i].size() < 4; k++) {
            const RelocEntry& r = s.relocs[k];
            if (r.target_section != s.index) continue;
            if (r.type != R_MIPS_32 && r.type != R_MIPS_26) continue;
            if (r.offset + 4u > s.size) continue;
            ovl_probes[i].push_back(OvlProbe{ r.offset, r.target_section_offset, (uint32_t)r.type });
        }
    }
    if (ovl_any_runtime_relocated) {
        size_t n = 0, probed = 0;
        for (size_t i = 0; i < sections_info.num_code_sections; i++) {
            if (!ovl_is_runtime_relocated(sections_info.code_sections[i])) continue;
            n++;
            if (ovl_probes[i].size() >= 2) probed++;
        }
        fprintf(stderr, "[ovlbind] %zu runtime-relocated section(s) declared, %zu with >=2 "
                        "self-relocation probes -- binder armed\n", n, probed);
        fflush(stderr);
    }
}

// Does live RDRAM at `base` hold section `i` after the game's own relocation pass?
static bool ovl_matches_at(size_t i, uint32_t base) {
    const SectionTableEntry& s = sections_info.code_sections[i];
    if (base < 0x80000000u) return false;
    if ((uint64_t)(base - 0x80000000u) + s.size > OVL_RDRAM_SIZE) return false;
    const std::vector<OvlProbe>& probes = ovl_probes[i];
    for (size_t k = 0; k < probes.size(); k++) {
        const uint32_t word = ovl_read_word(base + probes[k].offset);
        const uint32_t expect = base + probes[k].target_off;
        if (probes[k].type == R_MIPS_32) {
            if (word != expect) return false;
        } else {                                          // R_MIPS_26
            const uint32_t op = word >> 26;
            if (op != 2u && op != 3u) return false;       // j / jal
            if (((word & 0x03FFFFFFu) << 2) != (expect & 0x0FFFFFFFu)) return false;
        }
    }
    return true;
}

// Drop a section's func_map entries and its loaded_sections row, wherever it is bound now.
static void ovl_unbind(size_t section_table_index) {
    const SectionTableEntry& s = sections_info.code_sections[section_table_index];
    for (auto it = loaded_sections.begin(); it != loaded_sections.end(); ) {
        if (it->section_table_index != section_table_index) { ++it; continue; }
        {
            std::unique_lock lock(func_map_mtx);
            for (size_t k = 0; k < s.num_funcs; k++) {
                auto f = func_map.find(s.funcs[k].offset + it->loaded_ram_addr);
                if (f != func_map.end() && f->second == s.funcs[k].func) func_map.erase(f);
            }
        }
        it = loaded_sections.erase(it);
    }
    section_addresses[s.index] = s.ram_addr;
}

static std::mutex ovl_bind_mtx{};

static recomp_func_t* try_bind_runtime_overlay(int32_t addr) {
    if (g_rdram_base == nullptr || section_addresses == nullptr) return nullptr;
    std::unique_lock<std::mutex> bind_lock(ovl_bind_mtx);
    if (ovl_probes.empty()) {
        ovl_build_probes();
    }
    if (!ovl_any_runtime_relocated) return nullptr;       // inert for every other cart
    const uint32_t uaddr = (uint32_t)addr;
    if (uaddr < 0x80000000u || (uaddr - 0x80000000u) >= OVL_RDRAM_SIZE) return nullptr;
    {
        auto seen = ovl_bind_failed.find(uaddr);
        if (seen != ovl_bind_failed.end() && seen->second == ovl_bind_generation) return nullptr;
    }
    for (size_t i = 0; i < sections_info.num_code_sections; i++) {
        if (ovl_probes[i].size() < 2) continue;           // too few self-relocs to be decisive
        const SectionTableEntry& s = sections_info.code_sections[i];
        for (size_t k = 0; k < s.num_funcs; k++) {
            const uint32_t base = uaddr - s.funcs[k].offset;
            if (!ovl_matches_at(i, base)) continue;
            ovl_unbind(i);                                // it is force-registered at its link vram
            // Anything else bound over this address range is gone from RAM: drop it too, so a
            // recycled heap block cannot dispatch the previous tenant's code.
            for (size_t j = 0; j < sections_info.num_code_sections; j++) {
                if (j == i) continue;
                const SectionTableEntry& o = sections_info.code_sections[j];
                if (!ovl_is_runtime_relocated(o)) continue;
                const uint32_t ob = (uint32_t)section_addresses[o.index];
                if (ob == (uint32_t)o.ram_addr) continue; // not bound anywhere
                if (base < ob + o.size && ob < base + s.size) ovl_unbind(j);
            }
            load_overlay(i, (int32_t)base);
            ovl_bind_generation++;
            ovl_bind_failed.clear();
            static uint32_t nb = 0;
            if (nb++ < 32) {
                fprintf(stderr, "[ovlbind] section[%zu] vram=0x%08X size=0x%X funcs=%zu bound at "
                                "0x%08X (entry 0x%08X = +0x%X)\n",
                        i, (uint32_t)s.ram_addr, s.size, s.num_funcs, base, uaddr,
                        s.funcs[k].offset);
                fflush(stderr);
            }
            N64Recomp::diag::hit({ .kind = "ovlbind", .vaddr = uaddr, .a = base,
                                   .b = (uint32_t)s.ram_addr, .section_index = (uint32_t)i });
            {
                std::shared_lock lock(func_map_mtx);
                auto found = func_map.find(addr);
                if (found != func_map.end()) return found->second;
            }
            return nullptr;
        }
    }
    ovl_bind_failed[uaddr] = ovl_bind_generation;
    return nullptr;
}

extern "C" recomp_func_t * get_function(int32_t addr) {
    // vaddr 0 = uninitialised NI table slot (NI_ASSETS_* not yet loaded).
    // Return a no-op so callers that read NI_TABLE[file_id]==0 don't crash.
    if (addr == 0) {
        return ni_stub_noop;
    }
    // ── [jitrange] (2026-08-26) — env RECOMP_JIT_RANGE=lo:hi, unset = no effect ─────────────────
    // Force the LiveRecompiler for addresses in [lo,hi), bypassing the static set on a HIT.
    // WHY: a PACKED title that rebuilds its code image at runtime (SOTE's "B1" class) leaves the
    // static function STALE — the emission was recompiled from one RAM snapshot of an earlier
    // phase, so a func_map hit returns that phase's code for memory the game has since rewritten.
    // Measured 2026-08-26: 928 KB contiguous at 0x80000400-0x800E8400 (55% of all 4KB blocks)
    // differs between the intro snapshot the emission was built from and a post-transition capture,
    // including the exception handler itself. The gap JIT already compiles from LIVE RDRAM — but it
    // only fires on a func_map MISS, and a stale hit never misses. Routing a range here tests
    // whether stale hits are what actually gate the transition, and is the proof-of-concept for a
    // general fix (validity-checked dispatch) for the multi-phase compressed-title class.
    {
        struct JitRange { bool on; uint32_t lo, hi; };
        static const JitRange jr = []() -> JitRange {
            const char* e = std::getenv("RECOMP_JIT_RANGE");
            unsigned long lo = 0, hi = 0;
            if ((e != nullptr) && (sscanf(e, "%lx:%lx", &lo, &hi) == 2) && (hi > lo)) {
                fprintf(stderr, "[jitrange] forcing LiveRecomp for 0x%08lX..0x%08lX (static set bypassed there)\n", lo, hi);
                fflush(stderr);
                return JitRange{ true, (uint32_t)lo, (uint32_t)hi };
            }
            return JitRange{ false, 0u, 0u };
        }();
        if (jr.on) {
            const uint32_t ua = (uint32_t)addr;
            if ((ua >= jr.lo) && (ua < jr.hi)) {
                // [phase2-pins 2026-08-26] range-override, pin-first: the phase-2 static set
                // (shadows_ram → RecompiledFuncsRAM, registered as pinned functions) WINS over the
                // resident stale twins inside the ranged region — the same-address program swap the
                // miss-only pin path cannot express. Native phase-2 code, compiled from the settled
                // capture; only addresses with no pin fall to the live-gap lane below.
                {
                    auto pin_it = pinned_funcs.find(addr);
                    if (pin_it != pinned_funcs.end()) {
                        static std::atomic<uint32_t> p2_hits{0};
                        const uint32_t n = ++p2_hits;
                        if (n <= 8 || (n % 20000u) == 0u) {
                            fprintf(stderr, "[phase2] #%u pin-hit 0x%08X -> phase-2 native\n", n, ua);
                            fflush(stderr);
                        }
                        return pin_it->second;
                    }
                }
                static std::atomic<uint32_t> jr_hits{0};
                const uint32_t n = ++jr_hits;
                if (n <= 8 || (n % 20000u) == 0u) {
                    fprintf(stderr, "[jitrange] #%u routing 0x%08X to LiveRecomp\n", n, ua);
                    fflush(stderr);
                }
                recomp_live_gap_set_target(ua);
                return recomp_live_gap_trampoline;
            }
        }
    }
    /* session 22: shared_lock over the function body — any number of concurrent
     * readers, blocks writers. Protects all func_map.find() below against parallel
     * rehash from load_overlay/unload/clear on other threads. */
    std::shared_lock<std::shared_mutex> _gf_lock(func_map_mtx);
    /* (Wave-1 purge: removed the [gf_obj3] session-22 trap — a CV64 vaddr compare on EVERY
     * function dispatch of EVERY game, for a concluded investigation.) */
    static const uint32_t gf_trace = [] { const char* e = std::getenv("RECOMP_GF_TRACE"); return e ? (uint32_t)strtoul(e, nullptr, 16) : 0u; }();   // [gftrace] temp 09-02
    auto func_find = func_map.find(addr);
    if (gf_trace && (uint32_t)addr == gf_trace) { fprintf(stderr, "[gftrace] 0x%08X func_map %s%c", (uint32_t)addr, func_find == func_map.end() ? "MISS" : "HIT", 0x0A); fflush(stderr); }
    if (func_find == func_map.end()) {
        uint32_t uaddr = (uint32_t)addr;

        // ── NI overlay range (kuseg 0x0E000000–0x0FFFFFFF) ───────────────────
        // All NI overlays share load vaddrs (0x0F000000 for gameplay overlays,
        // 0x0E000000 for cutscenes).  Do NOT cache the stub in func_map — the
        // ROM content at that vaddr changes each time a different NI overlay is
        // loaded, so a cached boot stub would misfire for every enemy/boss.
        if (uaddr >= 0x0E000000u && uaddr < 0x10000000u) {
            // SESSION 44 (LoD): the NI boot-phase stubs are CV64-PROFILE behavior (they skip
            // CV64's Controller-Pak note screen by vaddr coincidence). Gate them on the game
            // actually shipping an NI content catalog (CV64: 139 entries; LoD: 0) so a
            // different game's first overlay dispatch is never swallowed by CV64 boot logic.
            NiBootPhase phase = ni_boot_phase.load(std::memory_order_acquire);
            if (ni_count() != 0) {
            if (uaddr == 0x0F000000u && phase == NiBootPhase::GAMENOTE_DELETE) {
                fprintf(stderr, "[get_function] NI STUB fired: GAMENOTE_DELETE at 0x0F000000 (func_map miss)\n");
                fflush(stderr);
                return ni_stub_gamenote_delete_mgr;
            }
            if (uaddr == 0x0F0004F0u && phase == NiBootPhase::TITLE_SCREEN) {
                fprintf(stderr, "[get_function] NI STUB fired: TITLE_SCREEN at 0x0F0004F0 (func_map miss)\n");
                fflush(stderr);
                return ni_stub_title_screen;
            }
            }
            // Log every distinct NI vaddr seen after boot so we know what's
            // being called during gameplay (visible in diag log after killing).
            static std::unordered_map<uint32_t, uint32_t> ni_call_counts;
            uint32_t cnt = ++ni_call_counts[uaddr];
            if (cnt == 1 || cnt % 300 == 0) {
                fprintf(stderr, "[ni-noop] vaddr=0x%08X call#%u phase=%u\n",
                    uaddr, cnt, (unsigned)phase);
                fflush(stderr);
            }
            // Un-recompiled overlay code: interpret it (general MIPS-interpreter fallback)
            // instead of silently no-op'ing. The trampoline self-gates via looks_like_code
            // and behaves exactly like the old ni_stub_noop for data (non-code) addresses,
            // so this cannot regress anything that legitimately resolved to a no-op before.
            return dispatch_gap_target(uaddr);
        }

        // ── Pinned functions (ignored in cv64.toml, called via pointer) ─────
        {
            auto pin_it = pinned_funcs.find(addr);
            if (gf_trace && (uint32_t)addr == gf_trace) { fprintf(stderr, "[gftrace] 0x%08X pinned %s (pins=%zu)%c", (uint32_t)addr, pin_it != pinned_funcs.end() ? "HIT" : "MISS", pinned_funcs.size(), 0x0A); fflush(stderr); }
            if (pin_it != pinned_funcs.end()) {
                return pin_it->second;
            }
        }

        // ── CV64: corrupt / UNALIGNED function pointer — recover, don't crash ──
        // Real MIPS function entry points are 4-byte aligned, so an UNALIGNED target is a
        // CORRUPTED pointer — e.g. overlay-collision garbage, or a big-endian pointer read with
        // its two halfwords transposed (0x80168800 -> 0x88008016, the weretiger-actor crash,
        // session 28 cont.13). Don't fatal-exit on these:
        //   - if the halfword-swap IS a real registered function, dispatch there (recovers the
        //     corruption — likely the right actor fn);
        //   - otherwise no-op the call so the game stays playable (the caller continues; the actor
        //     just skips one dispatch) instead of std::exit().
        // Gated on UNALIGNED only, so a genuine unregistered-but-aligned function still hits the
        // hard error below (we don't want to silently mask a real missing overlay/pin). Root cause
        // is the 0x0F overlay collision (see memory/project_render_collision_strategy.md).
        if ((uaddr & 3u) != 0u) {
            uint32_t swapped = ((uaddr & 0xFFFFu) << 16) | ((uaddr >> 16) & 0xFFFFu);
            static int _gp = 0;
            auto swap_it = func_map.find((decltype(addr))swapped);
            if (swap_it != func_map.end()) {
                if (_gp++ < 64) {
                    fprintf(stderr, "[gptr] corrupt fn-ptr 0x%08X -> halfword-swap 0x%08X RESOLVES; dispatching there\n",
                            uaddr, swapped);
                    fflush(stderr);
                }
                return swap_it->second;
            }
            if (_gp++ < 64) {
                fprintf(stderr, "[gptr] corrupt (unaligned) fn-ptr 0x%08X (swap 0x%08X unresolved) -> no-op\n",
                        uaddr, swapped);
                fflush(stderr);
            }
            static recomp_func_t* _cv64_corrupt_ptr_noop = +[](uint8_t*, recomp_context*) {};
            return _cv64_corrupt_ptr_noop;
        }

        // ── CV64: corrupt overlay fn-ptr with bit 31 (KSEG0) spuriously set — recover ──
        // e.g. 0x8F00A260 dispatched in the gilles_de_rais ("Dracula") cutscene (session 35): the
        // intended overlay fn is (addr & 0x7FFFFFFF) = 0x0F00A260, which IS registered in the loaded
        // overlay. On real HW 0x8F00A260 is KSEG0 -> physical 0x0F00A260 = out of RDRAM -> would also
        // fault, so the high bit is genuinely wrong (overlay-collision corruption, same class as the
        // unaligned case above). ONLY recover when the masked address lands in the 0x0E/0x0F overlay
        // window AND resolves -- so a real missing KSEG0 fn (0x80xxxxxx -> masked 0x00xxxxxx) still
        // hits the hard error below.
        if ((uaddr & 0x80000000u) != 0u) {
            uint32_t masked = uaddr & 0x7FFFFFFFu;
            if (masked >= 0x0E000000u && masked < 0x10000000u) {
                static int _gh = 0;
                auto m_it = func_map.find((decltype(addr))masked);
                if (m_it != func_map.end()) {
                    if (_gh++ < 64) {
                        fprintf(stderr, "[gptr] corrupt fn-ptr 0x%08X (bit31 set) -> overlay 0x%08X RESOLVES; dispatching there\n",
                                uaddr, masked);
                        fflush(stderr);
                    }
                    return m_it->second;
                }
                if (_gh++ < 64) {
                    fprintf(stderr, "[gptr] corrupt fn-ptr 0x%08X (bit31, masked 0x%08X unresolved) -> no-op\n",
                            uaddr, masked);
                    fflush(stderr);
                }
                static recomp_func_t* _cv64_hibit_ptr_noop = +[](uint8_t*, recomp_context*) {};
                return _cv64_hibit_ptr_noop;
            }
        }

        // ── CV64 (cont.39, FAITHFUL): KSEG0 pointer INTO a TLB-mapped NI overlay BUFFER ──
        // Villa-cutscene crash: the game dispatched 0x802DEA14 = the DECOMPRESSED-BUFFER address
        // of overlay code that is also TLB-mapped at the 0x0E/0x0F window. On real hardware KSEG0
        // is direct-mapped, so calling the buffer address executes the IDENTICAL bytes the window
        // maps — a legal alias, not corruption. Our recompiled fns are registered only at their
        // window vaddrs, so translate buffer-phys -> window vaddr (registry kept by recomp_tlb_map)
        // and resolve. Unresolved (data offset / stale buffer) -> log + no-op like the recoveries
        // above; non-overlay KSEG0 misses (win==0) still hit the hard error below.
        // ── TLB-WINDOW ALIAS (2026-08-06, Acclaim London class: turok2/3) ────────────────────
        // Physical address is the identity of code; a vaddr is a view. A game linked at TLB
        // window vaddrs registers its functions there, so a call arriving through the KSEG0
        // view of the same bytes misses — and the caller then INTERPRETS code that is fully
        // recompiled. Measured on turok2: the kernel's own primitives ran interpreted, one
        // session derailed into zeroed RAM (pc sliding ~48K instrs/poll) and its wild pc was
        // latched as EPC into the guest's TCB — the dispatcher then eret'd to garbage. Ask the
        // live TLB for the other view before any recovery net. (recomp_tlb_vaddr_for_phys
        // returns 0 when nothing maps the phys, so KSEG0-linked games are unaffected.)
        if ((uaddr & 0xC0000000u) == 0x80000000u) {
            uint32_t alias = recomp_tlb_vaddr_for_phys(uaddr & 0x1FFFFFFFu);
            if (alias != 0u && alias != uaddr) {
                auto a_it = func_map.find((decltype(addr))alias);
                if (a_it != func_map.end()) {
                    static int _wa = 0;
                    if (_wa++ < 32) {
                        fprintf(stderr, "[winalias] KSEG0 0x%08X -> TLB-window view 0x%08X RESOLVES; dispatching there\n",
                                uaddr, alias);
                        fflush(stderr);
                    }
                    return a_it->second;
                }
            }
        }

        if ((uaddr & 0x80000000u) != 0u && uaddr < 0xC0000000u) {
            uint32_t win = recomp_overlay_window_vaddr_for(uaddr & 0x1FFFFFFFu);
            if (win != 0u) {
                static int _gk = 0;
                auto w_it = func_map.find((decltype(addr))win);
                if (w_it != func_map.end()) {
                    if (_gk++ < 64) {
                        fprintf(stderr, "[gptr] KSEG0 buffer fn-ptr 0x%08X -> window alias 0x%08X RESOLVES; dispatching there\n",
                                uaddr, win);
                        fflush(stderr);
                    }
                    return w_it->second;
                }
                if (_gk++ < 64) {
                    fprintf(stderr, "[gptr] KSEG0 buffer fn-ptr 0x%08X (window alias 0x%08X unresolved) -> no-op\n",
                            uaddr, win);
                    fflush(stderr);
                }
                static recomp_func_t* _cv64_bufptr_noop = +[](uint8_t*, recomp_context*) {};
                return _cv64_bufptr_noop;
            }
        }

        // ── KUSEG CODE DISPATCH via the LLE TLB (general; worklist "TLB-aware dispatch") ─────
        // On hardware, EVERY bit31-clear vaddr reaches code through the TLB (or the identity
        // idiom for unmapped low KUSEG). This block was born window-gated to Conker's cart-bus
        // (0x10000000-0x14000000: boot stub maps the window onto low RDRAM and `jr`s into the
        // alias — 0x10001050 executes the bytes resident at 0x80001050), but the SAME hardware
        // rule serves every KUSEG code target: naboo maps+jumps through 0x40000000, the
        // Acclaim/Iguana engine (turok2/armorines/nflqbclub2001) runs code at low KUSEG vaddrs.
        // GENERALIZED 2026-07-01: any bit31-clear target (except the 0x0E/0x0F NI window, handled
        // above with its own registry) translates through the live LLE TLB (recomp_tlb_translate —
        // the same 32-entry table the recompiled tlbwi and recomp_tlb_map feed; unmapped KUSEG
        // falls back to the identity phys map, matching the engine's data path), forms the KSEG0
        // alias (phys | 0x80000000) and dispatches func_<alias>. Unresolved alias that looks like
        // real MIPS code JITs via the gap handler; a wild target still falls through to the nets
        // below. KSEG2/3 (0xC0000000+) stays untouched (device territory, e.g. NC's RCP window).
        // (uaddr >= 0x1000: the null page is corruption — a null-ish fn ptr must keep hitting the
        // hard-error nets, not get aliased into the exception-vector bytes at RDRAM 0.)
        // KSEG2/KSEG3 ARE TLB-MAPPED TOO (2026-09-06, Gauntlet Legends #120). On the VR4300 the
        // 32-bit kernel address space translates ksseg 0xC0000000-0xDFFFFFFF AND kseg3
        // 0xE0000000-0xFFFFFFFF through the TLB, exactly like kuseg; only kseg0/kseg1 are direct.
        // recomp_tlb_translate has always honoured that (its direct fast path is
        // (va & 0xC0000000) == 0x80000000, so kseg2/3 fall through to the walk), so the DATA path
        // already reads and writes through such a window - but this dispatch block excluded it,
        // and the first CALL through the window hit the fatal Missing Function modal. Gauntlet
        // Legends links its whole self-hosted kernel at KSEG3 and installs ONE entry for it
        // (func_802018B0: index 30, PageMask 0x7FE000 = 4 MB pages, EntryHi 0xE0000000,
        // phys 0 / 0x400000, G+V+D set) - its scheduler's first eret resumes a thread at
        // 0xE0002900 and died there. Same rule, same code path, one more segment.
        // The GIO/RDB device window mmio.cpp owns (0xC0000000..0xC000FFFF, Nightmare Creatures)
        // stays excluded: that one really is device territory, not code.
        const bool kuseg_code  = (uaddr & 0x80000000u) == 0u && uaddr >= 0x1000u &&
                                 !(uaddr >= 0x0E000000u && uaddr < 0x10000000u);
        const bool kseg23_code = uaddr >= 0xC0000000u && (uaddr & 0xFFFF0000u) != 0xC0000000u;
        if (kuseg_code || kseg23_code) {
            uint32_t phys  = recomp_tlb_translate(uaddr) & 0x1FFFFFFFu;
            uint32_t kseg0 = phys | 0x80000000u;
            static int _gc = 0;
            auto c_it = func_map.find((decltype(addr))kseg0);
            if (c_it != func_map.end()) {
                if (_gc++ < 64) {
                    fprintf(stderr, "[tlbcode] fn 0x%08X -> TLB phys 0x%08X -> KSEG0 alias 0x%08X RESOLVES; dispatching there\n",
                            uaddr, phys, kseg0);
                    fflush(stderr);
                }
                N64Recomp::diag::hit({ .kind = "tlbcode-resolved", .vaddr = uaddr, .a = phys, .b = kseg0 });
                return c_it->second;
            }
            // Unresolved alias: if the resident bytes look like real MIPS code, interpret them
            // (raw-overlay net, self-gating on the first word) before the hard error; a genuinely
            // wild target (data word / out of RDRAM) still falls through to the section/KSEG0 nets.
            if (phys < 0x800000u && g_rdram_base != nullptr &&
                recomp_interp_is_code(g_rdram_base, kseg0)) {
                // A TLB-MAPPED TARGET IS INTERPRETED AT ITS OWN VADDR (2026-09-04, Turok 2 #76).
                // MIPS J/JAL take the top four target bits from the pc, so window-linked code run at
                // its KSEG0 alias mis-forms every region-relative jump: interpreting vaddr 0x0029BC04
                // at 0x8009BC04 turned `jal 0x0029E010` into 0x8029E010 (zeroed RAM -> the session
                // nop-slid through the whole host buffer to BUDGET exhaustion, the sliding pcs
                // 0x802AE008..0x889ADFB0) and `jal 0x002005B0` into 0x802005B0 ("does NOT look like
                // code" -> a silently dropped call), and linked $ra = alias+8 into the guest's register
                // file. Every mid-function resume (eret epc inside the 0x00200000 window) derailed this
                // way. Hardware executes the bytes at the vaddr the guest named: fetch_instr already
                // translates KUSEG through the same live TLB (MEM_W -> CV64_PHYS -> recomp_tlb_translate),
                // the JR/JALR guard admits mapped targets, and J/JAL targets then resolve to the
                // window-named bodies (func_0029E010). Only a VALID mapping changes venue; an unmapped
                // (flat-fallback) KUSEG target keeps the alias it always had.
                uint32_t mapped_phys = 0;
                const bool mapped = recomp_tlb_is_mapped(uaddr, &mapped_phys) != 0;
                const uint32_t venue = mapped ? uaddr : kseg0;
                if (_gc++ < 64) {
                    fprintf(stderr, "[tlbcode] fn 0x%08X -> KSEG0 alias 0x%08X unresolved but looks like code - interpreting at 0x%08X (%s)\n",
                            uaddr, kseg0, venue, mapped ? "TLB-mapped: own vaddr" : "unmapped: alias");
                    fflush(stderr);
                }
                N64Recomp::diag::hit({ .kind = "tlbcode-fallback-code", .vaddr = uaddr, .a = phys, .b = venue });
                return dispatch_gap_target(venue);
            }
            if (_gc++ < 64) {
                fprintf(stderr, "[tlbcode] fn 0x%08X (TLB phys 0x%08X / KSEG0 alias 0x%08X) unresolved — falling through\n",
                        uaddr, phys, kseg0);
                fflush(stderr);
            }
            N64Recomp::diag::hit({ .kind = "cartbus-unresolved-fallthrough", .vaddr = uaddr, .a = phys, .b = kseg0 });
        }

        // ── cv64 SESSION 38e: SECTION-GAP dispatch (the 0x8015628C ambience-callback miss) ──
        // The new-level chain mapMgr_setupMap -> stopMapAmbienceSounds jalr'd TABLE[map_id]
        // (0x80186710) = a vaddr INSIDE section_8_common's range but BETWEEN emitted FUNCs
        // (the static ELF bytes there are a data table). On hardware this dispatch works, so
        // whatever sits there AT RUNTIME matters — dump the live RDRAM bytes (names the truth:
        // still the static data table = the WRITER stored a bogus/UB pointer; real MIPS code =
        // something copies code there at runtime and we must find its ROM source). Recover with
        // a logged no-op (S35-style net: keeps the game playable, does NOT cure the root) ONLY
        // for in-section gaps; genuinely wild pointers (outside every section) still hard-error.
        {
            int32_t sec_idx = -1;
            for (size_t i = 0; i < sections_info.num_code_sections; i++) {
                const SectionTableEntry& s = sections_info.code_sections[i];
                uint32_t ram = (uint32_t)s.ram_addr;
                if (ram <= uaddr && uaddr < ram + s.size) { sec_idx = (int32_t)i; break; }
            }
            if (sec_idx >= 0) {
                const SectionTableEntry& s = sections_info.code_sections[sec_idx];
                static int _gg = 0;
                if (_gg++ < 16) {
                    fprintf(stderr, "[gfgap] vaddr 0x%08X is INSIDE section[%d] (rom=0x%08X ram=0x%08X size=0x%X) but between FUNCs — dispatch gap\n",
                            uaddr, sec_idx, s.rom_addr, (uint32_t)s.ram_addr, s.size);
                    if (g_rdram_base != nullptr) {
                        fprintf(stderr, "[gfgap] live RDRAM bytes @0x%08X:", uaddr);
                        for (uint32_t k = 0; k < 16; k++) {
                            uint32_t w = 0;
                            for (int b2 = 0; b2 < 4; b2++)
                                w = (w << 8) | g_rdram_base[(size_t)(((uaddr & 0x1FFFFFFFu) + k*4 + b2) ^ 3u)];
                            fprintf(stderr, " %08X", w);
                        }
                        fprintf(stderr, "\n");
                    }
                    fprintf(stderr, "[gfgap] -> interpreting from RDRAM (S44: static dispatch-gap net)\n");
                    fflush(stderr);
                }
                // SESSION 44: the gap bytes ARE the real function (byte-exact static code the
                // blind recon just never symbolized — e.g. pointer-only dispatch targets).
                // Run them through the MIPS interpreter instead of no-op'ing; looks_like_code
                // self-gates so a data word still degrades to the old no-op behavior.
                if (N64Recomp::diag::enabled()) {
                    uint32_t _dump[16] = {0};
                    bool _have = (g_rdram_base != nullptr);
                    if (_have) {
                        for (uint32_t k = 0; k < 16; k++) {
                            uint32_t w = 0;
                            for (int b2 = 0; b2 < 4; b2++)
                                w = (w << 8) | g_rdram_base[(size_t)(((uaddr & 0x1FFFFFFFu) + k*4 + b2) ^ 3u)];
                            _dump[k] = w;
                        }
                    }
                    N64Recomp::diag::record({ .kind = "gfgap-section-miss", .vaddr = uaddr,
                        .a = s.rom_addr, .b = (uint32_t)s.ram_addr, .c = s.size,
                        .section_index = (uint32_t)sec_idx,
                        .words = (_have ? _dump : nullptr), .word_count = (_have ? 16u : 0u) });
                }
#ifdef _WIN32
                // STEP-1 DIAG (2026-07-12, build 035b24226de502b757d149716e23197e): settle the
                // "0x80619B80 internal-goto vs 32 interp-enters" contradiction by naming the
                // RECOMPILED function that dispatched this section-gap target. A native caller
                // RVA here PROVES the interpreter was reached via a LOOKUP_FUNC (get_function)
                // CALL from native code — NOT an internal goto (an internal goto never calls
                // get_function). Resolve the RVAs against build-capture/Release/donkeykong64pc.map.
                // Reuses the working [gfstack] stack-walk verbatim; capped so it cannot flood.
                {
                    static thread_local uint32_t _gapc = 0;
                    if (_gapc++ < 48) {
                        HMODULE exe = GetModuleHandleA(nullptr);
                        if (exe != nullptr) {
                            const uintptr_t* sp = (const uintptr_t*)_AddressOfReturnAddress();
                            const uintptr_t* stack_top = (const uintptr_t*)((NT_TIB*)NtCurrentTeb())->StackBase;
                            fprintf(stderr, "[gapcaller] target=0x%08X via=SECTION-GAP-net->dispatch_gap_target (mechanism=LOOKUP_FUNC call, base=%p); native call sites (RVA -> donkeykong64pc.map):\n",
                                    uaddr, (void*)exe);
                            int found = 0;
                            for (int i = 0; i < 256 && found < 8 && &sp[i] < stack_top; i++) {
                                uintptr_t ret = sp[i];
                                HMODULE m = nullptr;
                                if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                                       GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                                       (LPCSTR)ret, &m) && m == exe) {
                                    fprintf(stderr, "[gapcaller]   #%d stack+0x%03X RVA=0x%08llX\n",
                                            found, (unsigned)(i * 8), (unsigned long long)(ret - (uintptr_t)exe));
                                    found++;
                                }
                            }
                            fprintf(stderr, "[gapcaller] (%d native call sites for target 0x%08X)\n", found, uaddr);
                            fflush(stderr);
                        }
                    }
                }
#endif
                return dispatch_gap_target(uaddr);
            }
        }

        // ── RUNTIME-RELOCATED OVERLAY BINDER (2026-09-06) ────────────────
        // A cart that stores its overlays COMPRESSED in its file table never DMAs an overlay's
        // bytes to the address it runs at. Measured on Ocarina of Time (2026-09-06): the guest
        // streams the compressed file in 0x400-byte PI reads into ONE fixed window (0x80008490),
        // decompresses it itself into a heap block it allocated, and then applies the overlay's
        // own relocation list. So load_overlays() (bind at the DMA destination) and
        // load_overlays_from_dma() (bind at the canonical vram) both see nothing they can use --
        // 11,311 "no sections" lines in a 90 s run -- and a correctly declared relocatable section
        // stays unbound while its code runs interpreted.
        //
        // The overlay's OWN RELOCATIONS are the evidence that identifies it. After the guest's
        // relocation pass the word at (base + reloc.offset) must hold exactly what the section
        // table predicts for that base: an R_MIPS_32 holds (base + target_section_offset); an
        // R_MIPS_26 holds a j/jal whose 28-bit target is (base + target_section_offset). Two of
        // those pin the load base with no guessing, and they can be checked against live RDRAM
        // (the ROM holds only the COMPRESSED bytes, so a content compare is not available).
        //
        // GENERAL, and inert for every cart that does not need it: a section is a candidate only
        // when it carries relocations AND its canonical vram lies OUTSIDE RDRAM -- a link-only
        // address, which is exactly the mark of an overlay whose RAM the game allocates at run
        // time. A cart with no such section never reaches the scan.
        {
            // get_function holds _gf_lock (shared, func_map_mtx) over its whole body and
            // std::shared_mutex is NOT recursive: load_overlay()/ovl_unbind() take the writer
            // lock, so the bind must run with the reader lock released.
            if (_gf_lock.owns_lock()) {
                _gf_lock.unlock();
            }
            recomp_func_t* bound = try_bind_runtime_overlay(addr);
            if (bound != nullptr) {
                return bound;
            }
            _gf_lock.lock();
        }

        // ── Genuine missing-function error ────────────────────────────────────
#ifdef _WIN32
        void* caller = _ReturnAddress(); // MSVC intrinsic
#else
        void* caller = __builtin_return_address(0);
#endif
        // SESSION 44 (LoD): RAW KSEG0 CODE OVERLAYS — LoD direct-DMAs uncompressed code
        // blobs from the asset region straight into high RDRAM and dispatches them
        // (e.g. rom 0x745230 → 0x801CAEA0, size 0x7AE0, right after the Expansion Pak
        // resolution select). The bytes are real MIPS sitting in RDRAM — run them through
        // the interpreter net instead of the fatal exit. recomp_interp_is_code gates on
        // the first word, so a genuinely wild pointer (data word / null) still falls
        // through to the hard error below.
        {
            uint32_t kaddr = (uint32_t)addr;
            if (kaddr >= 0x80000000u && kaddr < 0x80800000u && g_rdram_base != nullptr) {
                if (recomp_interp_is_code(g_rdram_base, kaddr)) {
                    static int _ki = 0;
                    if (_ki++ < 24) {
                        fprintf(stderr, "[kseg0-interp] unresolved 0x%08X looks like code — interpreting "
                                        "(raw KSEG0 overlay net; recompile it in the game front-end for speed)\n",
                                kaddr);
                        fflush(stderr);
                    }
                    // OVERLAY CAPTURE (env RECOMP_OVERLAY_DUMP=<vaddr>:<bytes>:<path>). An overlay
                    // the blind path never declared is only ever SEEN here, in RDRAM, at the moment
                    // the interpreter is asked to run it. A timer-armed RECOMP_RAM_SNAPSHOT cannot
                    // catch it: that fires from guest-side code, and a game frozen in an interpreted
                    // overlay never reaches the venue that would write it. Dump on the first hit so
                    // the bytes can be matched back to their ROM offset and declared as real code.
                    {
                        static bool dumped = false;
                        const char* spec = std::getenv("RECOMP_OVERLAY_DUMP");
                        if (!dumped && (spec != nullptr)) {
                            unsigned long dv = 0, db = 0;
                            char dpath[512] = { 0 };
                            if (sscanf(spec, "%lx:%lx:%511s", &dv, &db, dpath) == 3 && db != 0) {
                                dumped = true;
                                uint32_t phys = (uint32_t)dv & 0x7FFFFFu;
                                if (FILE* df = fopen(dpath, "wb")) {
                                    for (uint32_t i = 0; i < (uint32_t)db; i++) {
                                        fputc(g_rdram_base[(phys + i) ^ 3], df);   // un-swizzle to ROM order
                                    }
                                    fclose(df);
                                    fprintf(stderr, "[overlay-dump] wrote 0x%lX bytes from 0x%08lX to %s\n", db, dv, dpath);
                                    fflush(stderr);
                                }
                            }
                        }
                    }
                    N64Recomp::diag::hit({ .kind = "kseg0-raw-overlay", .vaddr = kaddr });
                    return dispatch_gap_target(kaddr);
                }
                // Implausible first word at an in-RAM KSEG0 target: stay CONTAINED instead of
                // fataling (drmario 2026-07-18: a JIT'd caller's jal hit this modal while the
                // interpreter path would have no-op'd the same call via its own gate). The gap
                // net's trampolines re-check is_code and act as a no-op on genuine data, which
                // is exactly the interpreter-tier semantics; the diag event keeps the forensics.
                // The fatal modal below still fires for non-KSEG0 wild dispatches.
                static int _kn = 0;
                if (_kn++ < 24) {
                    fprintf(stderr, "[kseg0-interp] unresolved 0x%08X does NOT look like code — "
                                    "contained no-op dispatch (was: fatal modal)\n", kaddr);
                    fflush(stderr);
                }
                N64Recomp::diag::hit({ .kind = "kseg0-implausible-dispatch", .vaddr = kaddr });
                return dispatch_gap_target(kaddr);
            }
        }

        // Name the ACTUAL running app/map, not a hardcoded game (this runtime is shared by every
        // title — the old "cv64pc.map"/"CV64PC" strings mislabeled every other game's dialog).
        char exe_base[64] = "the app";
        char map_ref[80]  = "the .map";
        char title[96]    = "Missing Function";
#ifdef _WIN32
        {
            char exe_path[MAX_PATH];
            if (GetModuleFileNameA(GetModuleHandleA(nullptr), exe_path, sizeof(exe_path)) > 0) {
                const char* slash = strrchr(exe_path, '\\');
                const char* base = slash ? slash + 1 : exe_path;
                snprintf(exe_base, sizeof(exe_base), "%s", base);
                char stem[64]; snprintf(stem, sizeof(stem), "%s", base);
                char* dot = strrchr(stem, '.'); if (dot) *dot = '\0';
                snprintf(map_ref, sizeof(map_ref), "%s.map", stem);
                snprintf(title, sizeof(title), "%s – Missing Function", stem);
            }
        }
#endif
        char msg[512];
        snprintf(msg, sizeof(msg),
            "get_function: no recompiled function at N64 vaddr 0x%08X\n"
            "This is usually a missing overlay registration or an\n"
            "unregistered function pointer call.\n\n"
            "Check: is this address in an overlay that hasn't been loaded?\n\n"
            "Caller address (look up in %s): %p",
            (uint32_t)addr, map_ref, caller);
        fprintf(stderr, "%s\n", msg);
#ifdef _WIN32
        // cv64 S38: name the dispatch chain BEFORE dying. The raw caller host address is useless after
        // the process exits (ASLR); scan the stack for return addresses inside cv64pc.exe and print their
        // RVAs — they resolve directly in build/Release/cv64pc.map and name the recompiled fn whose
        // LOOKUP_FUNC read the garbage pointer (then read its C to see WHICH field held it). Same
        // technique as main.cpp's [crashstack].
        {
            HMODULE exe = GetModuleHandleA(nullptr);
            if (exe != nullptr) {
                const uintptr_t* sp = (const uintptr_t*)_AddressOfReturnAddress();
                // Bound the scan to the committed stack: fewer than 256*8 bytes can sit between
                // sp and the top of a slim task-thread stack, and walking past StackBase AVs
                // INSIDE this error report — masking the informative missing-function modal with
                // an UNHANDLED EXCEPTION box (nflblitzse's wild 0x275AECE4 dispatch, 2026-07-03:
                // AV READ at exactly the 64KB stack boundary above Rsp). TEB StackBase = stack top.
                const uintptr_t* stack_top = (const uintptr_t*)((NT_TIB*)NtCurrentTeb())->StackBase;
                fprintf(stderr, "[gfstack] call sites in %s (base=%p):\n", exe_base, (void*)exe);
                int found = 0;
                for (int i = 0; i < 256 && found < 16 && &sp[i] < stack_top; i++) {
                    uintptr_t ret = sp[i];
                    HMODULE m = nullptr;
                    if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                           GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                           (LPCSTR)ret, &m) && m == exe) {
                        fprintf(stderr, "[gfstack]   stack+0x%03X  RVA=0x%08llX\n",
                                (unsigned)(i * 8), (unsigned long long)(ret - (uintptr_t)exe));
                        found++;
                    }
                }
                fprintf(stderr, "[gfstack] (%d call sites)\n", found);
            }
            fflush(stderr);
        }
        MessageBoxA(nullptr, msg, title, MB_ICONERROR | MB_OK);
#endif
        std::exit(EXIT_FAILURE);
    }
    return func_find->second;
}

std::unordered_map<recomp_func_t*, recomp::overlays::BasePatchedFunction> recomp::overlays::get_base_patched_funcs() {
    std::unordered_map<recomp_func_t*, BasePatchedFunction> ret{};

    // Collect the set of all functions in the patches.
    std::unordered_map<recomp_func_t*, BasePatchedFunction> all_patch_funcs{};
    for (size_t patch_section_index = 0; patch_section_index < num_patch_code_sections; patch_section_index++) {
        const auto& patch_section = patch_code_sections[patch_section_index];
        for (size_t func_index = 0; func_index < patch_section.num_funcs; func_index++) {
            all_patch_funcs.emplace(patch_section.funcs[func_index].func, BasePatchedFunction{ .patch_section = patch_section_index, .function_index = func_index });
        }
    }

    // Check every vanilla function against the full patch function set.
    // Any functions in both are patched.
    for (size_t code_section_index = 0; code_section_index < sections_info.num_code_sections; code_section_index++) {
        const auto& code_section = sections_info.code_sections[code_section_index];
        for (size_t func_index = 0; func_index < code_section.num_funcs; func_index++) {
            recomp_func_t* cur_func = code_section.funcs[func_index].func;
            // If this function also exists in the patches function set then it's a vanilla function that was patched.
            auto find_it = all_patch_funcs.find(cur_func);
            if (find_it != all_patch_funcs.end()) {
                ret.emplace(cur_func, find_it->second);
            }
        }
    }

    return ret;
}

const std::unordered_map<uint32_t, uint16_t>& recomp::overlays::get_patch_vrom_to_section_map() {
    return patch_code_sections_by_rom;
}

uint32_t recomp::overlays::get_patch_section_ram_addr(uint16_t patch_code_section_index) {
    if (patch_code_section_index < num_patch_code_sections) {
        return patch_code_sections[patch_code_section_index].ram_addr;
    }
    assert(false);
    return -1;
}

uint32_t recomp::overlays::get_patch_section_rom_addr(uint16_t patch_code_section_index) {
    if (patch_code_section_index < num_patch_code_sections) {
        return patch_code_sections[patch_code_section_index].rom_addr;
    }
    assert(false);
    return -1;
}

const FuncEntry* recomp::overlays::get_patch_function_entry(uint16_t patch_code_section_index, size_t function_index) {
    if (patch_code_section_index < num_patch_code_sections) {
        const auto& section = patch_code_sections[patch_code_section_index];
        if (function_index < section.num_funcs) {
            return &section.funcs[function_index];
        }
    }
    assert(false);
    return nullptr;
}

// Finds a base patched function given a patch section's index and the function's offset into the section.
bool recomp::overlays::get_patch_func_entry_by_section_index_function_offset(uint16_t patch_code_section_index, uint32_t function_offset, FuncEntry& func_out) {
    if (patch_code_section_index >= num_patch_code_sections) {
        return false;
    }

    SectionTableEntry* section = &patch_code_sections[patch_code_section_index];
    if (function_offset >= section->size) {
        return false;
    }
    
    // TODO avoid a linear lookup here.
    for (size_t func_index = 0; func_index < section->num_funcs; func_index++) {
        if (section->funcs[func_index].offset == function_offset) {
            func_out = section->funcs[func_index];
            return true;
        }
    }

    return false;
}

std::span<const RelocEntry> recomp::overlays::get_patch_section_relocs(uint16_t patch_code_section_index) {
    if (patch_code_section_index < num_patch_code_sections) {
        const auto& section = patch_code_sections[patch_code_section_index];
        return std::span{ section.relocs, section.num_relocs };
    }
    assert(false);
    return {};
}

std::span<const uint8_t> recomp::overlays::get_patch_binary() {
    return std::span{ reinterpret_cast<const uint8_t*>(patch_data.data()), patch_data.size() };
}
