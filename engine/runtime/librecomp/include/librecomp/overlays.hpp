#ifndef __RECOMP_OVERLAYS_H__
#define __RECOMP_OVERLAYS_H__

#include <cstdint>
#include <cstddef>
#include <string>
#include <unordered_map>
#include <span>
#include "sections.h"

namespace recomp {
    namespace overlays {
        struct overlay_section_table_data_t {
            SectionTableEntry* code_sections;
            size_t num_code_sections;
            size_t total_num_sections;
        };

        struct overlays_by_index_t {
            int* table;
            size_t len;
        };

        void register_overlays(const overlay_section_table_data_t& sections, const overlays_by_index_t& overlays);

        void register_patches(const char* patch_data, size_t patch_size, SectionTableEntry* code_sections, size_t num_sections);
        void register_base_export(const std::string& name, recomp_func_t* func);
        void register_ext_base_export(const std::string& name, recomp_func_ext_t* func);
        void register_base_exports(const FunctionExport* exports);
        void register_base_events(char const* const* event_names);
        void register_manual_patch_symbols(const ManualPatchSymbol* manual_patch_symbols);
        void read_patch_data(uint8_t* rdram, gpr patch_data_address);

        void init_overlays();
        const std::unordered_map<uint32_t, uint16_t>& get_vrom_to_section_map();
        uint32_t get_section_ram_addr(uint16_t code_section_index);
        std::span<const RelocEntry> get_section_relocs(uint16_t code_section_index);
        recomp_func_t* get_func_by_section_rom_function_vram(uint32_t section_rom, uint32_t function_vram);
        bool get_func_entry_by_section_index_function_offset(uint16_t code_section_index, uint32_t function_offset, FuncEntry& func_out);
        recomp_func_t* get_func_by_section_index_function_offset(uint16_t code_section_index, uint32_t function_offset);
        recomp_func_t* get_base_export(const std::string& export_name);
        recomp_func_ext_t* get_ext_base_export(const std::string& export_name);
        size_t get_base_event_index(const std::string& event_name);
        size_t num_base_events();

        void add_loaded_function(int32_t ram_addr, recomp_func_t* func);

        // Register a function that must survive func_map.clear() in init_overlays().
        // Use for functions marked `ignored` in cv64.toml that are called via an
        // indirect pointer (LOOKUP_FUNC → get_function) at runtime.
        void register_pinned_function(int32_t vram, recomp_func_t* func);

        struct BasePatchedFunction {
            size_t patch_section;
            size_t function_index;
        };

        std::unordered_map<recomp_func_t*, BasePatchedFunction> get_base_patched_funcs();
        const std::unordered_map<uint32_t, uint16_t>& get_patch_vrom_to_section_map();
        uint32_t get_patch_section_ram_addr(uint16_t patch_code_section_index);
        uint32_t get_patch_section_rom_addr(uint16_t patch_code_section_index);
        const FuncEntry* get_patch_function_entry(uint16_t patch_code_section_index, size_t function_index);
        bool get_patch_func_entry_by_section_index_function_offset(uint16_t code_section_index, uint32_t function_offset, FuncEntry& func_out);
        std::span<const RelocEntry> get_patch_section_relocs(uint16_t patch_code_section_index);
        std::span<const uint8_t> get_patch_binary();
    }
};

extern "C" void load_overlays(uint32_t rom, int32_t ram_addr, uint32_t size);
extern "C" void unload_overlays(int32_t ram_addr, uint32_t size);

// ── For a host that loads games as MODULES rather than linking one in (Recompilator, 2026-09-06).
// overlays.cpp used to reference three CV64-shaped application symbols unconditionally
// (ni_section_data_table, ni_section_data_table_count, gamestate_change); a loaded module cannot
// define a symbol in its host, so it registers them here instead. An application that defines them
// the old way needs no change and must not call these.
//
// `table` points at an array of { uint32_t lma; const uint8_t* data; uint32_t size; } that must
// outlive the game (the module owns it; librecomp never copies or frees it).
extern "C" void recomp_register_ni_section_data(const void* table, size_t count);
extern "C" void recomp_register_gamestate_change(recomp_func_t* fn);

// The C face of recomp::overlays::register_pinned_function, for the same reason: a module built by
// a different toolchain cannot name a C++-mangled engine symbol. A game whose recompiled set is
// merged from a RAM image (merge_recomp_sets.py's ram_shadow_pins.inl) pins those functions so they
// survive init_overlays()'s func_map.clear(); an exe calls the C++ overload directly, a module
// reaches the identical map through this. Same semantics, same map, no second registry.
extern "C" void recomp_register_pinned_function(int32_t vram, recomp_func_t* func);

#endif
