#include <cstdio>
#include <cstdlib>
#include <unordered_set>
#include <span>
#include <filesystem>
#include <optional>

#include "rabbitizer.hpp"
#include "fmt/format.h"
#include "fmt/ostream.h"

#include "recompiler/context.h"
#include "recompiler/diag_sink.h"
#include "config.h"
#include <set>
#include <sstream>
#include <cctype>

// GENERAL FIX (sweep): detect a `goto LABEL;` whose `LABEL:` is never defined in the same function body.
// A data static can recompile "successfully" (recompile_function returns true) yet emit such a dangling goto
// — e.g. a branch-likely whose target resolves to a runtime LOOKUP_FUNC, where the link-branch's `after_N:`
// label fell on an unhandled/INVALID delay slot and was never written. That fails to COMPILE, not recompile,
// so it slips past the failure-driven stub path. We scan the buffered static body and divert any such static
// to an empty stub. No false positives on real code: a genuine function always defines every label it gotos.
static bool body_has_dangling_goto(const std::string& body) {
    std::unordered_set<std::string> labels, gotos;
    auto is_ident = [](unsigned char c) { return std::isalnum(c) || c == '_'; };
    // labels: an identifier immediately followed by ':' at the start of a whitespace-trimmed line (not '::')
    size_t pos = 0;
    while (pos < body.size()) {
        size_t eol = body.find('\n', pos);
        if (eol == std::string::npos) eol = body.size();
        size_t a = pos;
        while (a < eol && (body[a] == ' ' || body[a] == '\t')) a++;
        size_t b = a;
        while (b < eol && is_ident((unsigned char)body[b])) b++;
        if (b > a && b < eol && body[b] == ':' && (b + 1 >= eol || body[b + 1] != ':')) {
            labels.insert(body.substr(a, b - a));
        }
        pos = eol + 1;
    }
    // gotos: `goto IDENT;`
    const std::string kw = "goto ";
    pos = 0;
    while ((pos = body.find(kw, pos)) != std::string::npos) {
        size_t a = pos + kw.size();
        while (a < body.size() && (body[a] == ' ' || body[a] == '\t')) a++;
        size_t b = a;
        while (b < body.size() && is_ident((unsigned char)body[b])) b++;
        if (b > a) gotos.insert(body.substr(a, b - a));
        pos = b;
    }
    for (const auto& g : gotos) if (!labels.contains(g)) return true;
    return false;
}

void add_manual_functions(N64Recomp::Context& context, const std::vector<N64Recomp::ManualFunction>& manual_funcs) {
    auto exit_failure = [](const std::string& error_str) {
        fmt::vprint(stderr, error_str, fmt::make_format_args());
        std::exit(EXIT_FAILURE);
    };

    // Build a lookup from section name to section index.
    std::unordered_map<std::string, size_t> section_indices_by_name{};
    section_indices_by_name.reserve(context.sections.size());

    for (size_t i = 0; i < context.sections.size(); i++) {
        section_indices_by_name.emplace(context.sections[i].name, i);
    }

    for (const N64Recomp::ManualFunction& cur_func_def : manual_funcs) {
        const auto section_find_it = section_indices_by_name.find(cur_func_def.section_name);
        if (section_find_it == section_indices_by_name.end()) {
            exit_failure(fmt::format("Manual function {} specified with section {}, which doesn't exist!\n", cur_func_def.func_name, cur_func_def.section_name));
        }
        size_t section_index = section_find_it->second;

        const auto func_find_it = context.functions_by_name.find(cur_func_def.func_name);
        if (func_find_it != context.functions_by_name.end()) {
            exit_failure(fmt::format("Manual function {} already exists!\n", cur_func_def.func_name));
        }

        if ((cur_func_def.size & 0b11) != 0) {
            exit_failure(fmt::format("Manual function {} has a size that isn't divisible by 4!\n", cur_func_def.func_name));
        }

        auto& section = context.sections[section_index];
        uint32_t section_offset = cur_func_def.vram - section.ram_addr;
        uint32_t rom_address = section_offset + section.rom_addr;

        std::vector<uint32_t> words;
        words.resize(cur_func_def.size / 4);
        const uint32_t* elf_words = reinterpret_cast<const uint32_t*>(context.rom.data() + context.sections[section_index].rom_addr + section_offset);

        words.assign(elf_words, elf_words + words.size());

        size_t function_index = context.functions.size();
        context.functions.emplace_back(
            cur_func_def.vram,
            rom_address,
            std::move(words),
            cur_func_def.func_name,
            uint16_t(section_index),
            false,
            false,
            false
        );

        context.section_functions[section_index].push_back(function_index);
        section.function_addrs.push_back(function_index);
        context.functions_by_vram[cur_func_def.vram].push_back(function_index);
        context.functions_by_name[cur_func_def.func_name] = function_index;
    }
}

bool read_list_file(const std::filesystem::path& filename, std::vector<std::string>& entries_out) {
    std::ifstream input_file{ filename };
    if (!input_file.good()) {
        return false;
    }

    std::string entry;

    while (input_file >> entry) {
        entries_out.emplace_back(std::move(entry));
    }

    return true;
}

bool compare_files(const std::filesystem::path& file1_path, const std::filesystem::path& file2_path) {
    static std::vector<char> file1_buf(65536);
    static std::vector<char> file2_buf(65536);

    std::ifstream file1(file1_path, std::ifstream::ate | std::ifstream::binary); //open file at the end
    std::ifstream file2(file2_path, std::ifstream::ate | std::ifstream::binary); //open file at the end
    const std::ifstream::pos_type fileSize = file1.tellg();

    file1.rdbuf()->pubsetbuf(file1_buf.data(), file1_buf.size());
    file2.rdbuf()->pubsetbuf(file2_buf.data(), file2_buf.size());

    if (fileSize != file2.tellg()) {
        return false; //different file size
    }

    file1.seekg(0); //rewind
    file2.seekg(0); //rewind

    std::istreambuf_iterator<char> begin1(file1);
    std::istreambuf_iterator<char> begin2(file2);

    return std::equal(begin1, std::istreambuf_iterator<char>(), begin2); //Second argument is end-of-range iterator
}

bool recompile_single_function(const N64Recomp::Context& context, size_t func_index, const std::string& recomp_include, const std::filesystem::path& output_path, std::span<std::vector<uint32_t>> static_funcs_out) {
    // Open the temporary output file
    std::filesystem::path temp_path = output_path;
    temp_path.replace_extension(".tmp");
    std::ofstream output_file{ temp_path };
    if (!output_file.good()) {
        fmt::print(stderr, "Failed to open file for writing: {}\n", temp_path.string() );
        return false;
    }

    // Write the file header
    fmt::print(output_file,
        "{}\n"
        "\n",
        recomp_include);

    if (!N64Recomp::recompile_function(context, func_index, output_file, static_funcs_out, false)) {
        return false;
    }
    
    output_file.close();

    // If a file of the target name exists and it's identical to the output file, delete the output file.
    // This prevents updating the existing file so that it doesn't need to be rebuilt.
    if (std::filesystem::exists(output_path) && compare_files(output_path, temp_path)) {
        std::filesystem::remove(temp_path);
    }
    // Otherwise, rename the new file to the target path.
    else {
        std::filesystem::rename(temp_path, output_path);
    }

    return true;
}

std::vector<std::string> reloc_names {
    "R_MIPS_NONE ",
    "R_MIPS_16",
    "R_MIPS_32",
    "R_MIPS_REL32",
    "R_MIPS_26",
    "R_MIPS_HI16",
    "R_MIPS_LO16",
    "R_MIPS_GPREL16",
};

void dump_context(const N64Recomp::Context& context, const std::unordered_map<uint16_t, std::vector<N64Recomp::DataSymbol>>& data_syms, const std::filesystem::path& func_path, const std::filesystem::path& data_path) {
    std::ofstream func_context_file {func_path};
    std::ofstream data_context_file {data_path};
    
    fmt::print(func_context_file, "# Autogenerated from an ELF via N64Recomp\n");
    fmt::print(data_context_file, "# Autogenerated from an ELF via N64Recomp\n");

    auto print_section = [](std::ofstream& output_file, const std::string& name, uint32_t rom_addr, uint32_t ram_addr, uint32_t size) {
        if (rom_addr == (uint32_t)-1) {
            fmt::print(output_file,
                "[[section]]\n"
                "name = \"{}\"\n"
                "vram = 0x{:08X}\n"
                "size = 0x{:X}\n"
                "\n",
                name, ram_addr, size);
        }
        else {
            fmt::print(output_file,
                "[[section]]\n"
                "name = \"{}\"\n"
                "rom = 0x{:08X}\n"
                "vram = 0x{:08X}\n"
                "size = 0x{:X}\n"
                "\n",
                name, rom_addr, ram_addr, size);
        }
    };

    for (size_t section_index = 0; section_index < context.sections.size(); section_index++) {
        const N64Recomp::Section& section = context.sections[section_index];
        const std::vector<size_t>& section_funcs = context.section_functions[section_index];
        if (!section_funcs.empty()) {
            print_section(func_context_file, section.name, section.rom_addr, section.ram_addr, section.size);

            // Dump relocs into the function context file.
            if (!section.relocs.empty()) {
                fmt::print(func_context_file, "relocs = [\n");

                for (const N64Recomp::Reloc& reloc : section.relocs) {
                    if (reloc.target_section == section_index || reloc.target_section == section.bss_section_index) {
                        // TODO allow emitting MIPS32 relocs for specific sections via a toml option for TLB mapping support.
                        if (reloc.type == N64Recomp::RelocType::R_MIPS_HI16 || reloc.type == N64Recomp::RelocType::R_MIPS_LO16 || reloc.type == N64Recomp::RelocType::R_MIPS_26) {
                            fmt::print(func_context_file, "    {{ type = \"{}\", vram = 0x{:08X}, target_vram = 0x{:08X} }},\n",
                                reloc_names[static_cast<int>(reloc.type)], reloc.address, reloc.target_section_offset + section.ram_addr);
                        }
                    }
                }

                fmt::print(func_context_file, "]\n\n");
            }

            // Dump functions into the function context file.
            fmt::print(func_context_file, "functions = [\n");

            for (const size_t& function_index : section_funcs) {
                const N64Recomp::Function& func = context.functions[function_index];
                fmt::print(func_context_file, "    {{ name = \"{}\", vram = 0x{:08X}, size = 0x{:X} }},\n",
                    func.name, func.vram, func.words.size() * sizeof(func.words[0]));
            }

            fmt::print(func_context_file, "]\n\n");
        }
        
        const auto find_syms_it = data_syms.find((uint16_t)section_index);
        if (find_syms_it != data_syms.end() && !find_syms_it->second.empty()) {
            print_section(data_context_file, section.name, section.rom_addr, section.ram_addr, section.size);

            // Dump other symbols into the data context file.
            fmt::print(data_context_file, "symbols = [\n");

            for (const N64Recomp::DataSymbol& cur_sym : find_syms_it->second) {
                fmt::print(data_context_file, "    {{ name = \"{}\", vram = 0x{:08X} }},\n", cur_sym.name, cur_sym.vram);
            }
            
            fmt::print(data_context_file, "]\n\n");
        }
    }

    const auto find_abs_syms_it = data_syms.find(N64Recomp::SectionAbsolute);
    if (find_abs_syms_it != data_syms.end() && !find_abs_syms_it->second.empty()) {
        // Dump absolute symbols into the data context file.
        print_section(data_context_file, "ABSOLUTE_SYMS", (uint32_t)-1, 0, 0);
        fmt::print(data_context_file, "symbols = [\n");

        for (const N64Recomp::DataSymbol& cur_sym : find_abs_syms_it->second) {
            fmt::print(data_context_file, "    {{ name = \"{}\", vram = 0x{:08X} }},\n", cur_sym.name, cur_sym.vram);
        }

        fmt::print(data_context_file, "]\n\n");
    }
}

static std::vector<uint8_t> read_file(const std::filesystem::path& path) {
    std::vector<uint8_t> ret;

    std::ifstream file{ path, std::ios::binary};

    if (file.good()) {
        file.seekg(0, std::ios::end);
        ret.resize(file.tellg());
        file.seekg(0, std::ios::beg);

        file.read(reinterpret_cast<char*>(ret.data()), ret.size());
    }

    return ret;
}

int main(int argc, char** argv) {
    auto exit_failure = [] (const std::string& error_str) {
        fmt::vprint(stderr, error_str, fmt::make_format_args());
        std::exit(EXIT_FAILURE);
    };

    bool dumping_context = false;

    if (argc < 2) {
        fmt::print("Usage: {} <config file> [--dump-context]\n", argv[0]);
        return EXIT_SUCCESS;
    }

    const char* config_path = argv[1];

    for (size_t i = 2; i < argc; i++) {
        std::string_view cur_arg = argv[i];
        if (cur_arg == "--dump-context") {
            dumping_context = true;
        }
        else {
            fmt::print("Unknown argument \"{}\"\n", cur_arg);
            return EXIT_FAILURE;
        }
    }

    N64Recomp::Config config{ config_path };
    if (!config.good()) {
        exit_failure(fmt::format("Failed to load config file: {}\n", config_path));
    }

    RabbitizerConfig_Cfg.pseudos.pseudoMove = false;
    RabbitizerConfig_Cfg.pseudos.pseudoBeqz = false;
    RabbitizerConfig_Cfg.pseudos.pseudoBnez = false;
    RabbitizerConfig_Cfg.pseudos.pseudoNot = false;
    RabbitizerConfig_Cfg.pseudos.pseudoBal = false;

    std::vector<std::string> relocatable_sections_ordered{};

    if (!config.relocatable_sections_path.empty()) {
        if (!read_list_file(config.relocatable_sections_path, relocatable_sections_ordered)) {
            exit_failure(fmt::format("Failed to load the relocatable section list file: {}\n", (const char*)config.relocatable_sections_path.u8string().c_str()));
        }
    }

    std::unordered_set<std::string> relocatable_sections{};
    relocatable_sections.insert(relocatable_sections_ordered.begin(), relocatable_sections_ordered.end());

    std::unordered_set<std::string> ignored_syms_set{};
    ignored_syms_set.insert(config.ignored_funcs.begin(), config.ignored_funcs.end());

    N64Recomp::Context context{};
    
    if (!config.elf_path.empty() && !config.symbols_file_path.empty()) {
        exit_failure("Config file cannot provide both an elf and a symbols file\n");
    }

    // Build a context from the provided elf file.
    if (!config.elf_path.empty()) {
        // Lists of data symbols organized by section, only used if dumping context.
        std::unordered_map<uint16_t, std::vector<N64Recomp::DataSymbol>> data_syms;

        // Import symbols from any reference symbols files that were provided.
        if (!config.func_reference_syms_file_path.empty()) {
            {
                // Create a new temporary context to read the function reference symbol file into, since it's the same format as the recompilation symbol file.
                std::vector<uint8_t> dummy_rom{};
                N64Recomp::Context reference_context{};
                if (!N64Recomp::Context::from_symbol_file(config.func_reference_syms_file_path, std::move(dummy_rom), reference_context, false)) {
                    exit_failure("Failed to load provided function reference symbol file\n");
                }

                // Use the reference context to build a reference symbol list for the actual context.
                if (!context.import_reference_context(reference_context)) {
                    exit_failure("Internal error: Failed to import reference context. Please report this issue.\n");
                }
            }

            for (const std::filesystem::path& cur_data_sym_path : config.data_reference_syms_file_paths) {
                if (!context.read_data_reference_syms(cur_data_sym_path)) {
                    exit_failure(fmt::format("Failed to load provided data reference symbol file: {}\n", cur_data_sym_path.string()));
                }
            }
        }

        N64Recomp::ElfParsingConfig elf_config {
            .bss_section_suffix = config.bss_section_suffix,
            .relocatable_sections = std::move(relocatable_sections),
            .ignored_syms = std::move(ignored_syms_set),
            .mdebug_text_map = config.mdebug_text_map,
            .mdebug_data_map = config.mdebug_data_map,
            .mdebug_rodata_map = config.mdebug_rodata_map,
            .mdebug_bss_map = config.mdebug_bss_map,
            .has_entrypoint = config.has_entrypoint,
            .entrypoint_address = config.entrypoint,
            .use_absolute_symbols = config.use_absolute_symbols,
            .unpaired_lo16_warnings = config.unpaired_lo16_warnings,
            .all_sections_relocatable = false,
            .use_mdebug = config.use_mdebug,
        };

        for (const auto& func_size : config.manual_func_sizes) {
            elf_config.manually_sized_funcs.emplace(func_size.func_name, func_size.size_bytes);
        }
        // Exact-size funcs: derive each one's vram from its address-encoded name (func_<hex>) so
        // from_elf_file can treat it as a hard, non-extendable boundary. (Only func_<hex>-named entries
        // carry their vram in the name; a non-address name is skipped — exact sizing for those would
        // need an extra pass and isn't needed by the carved-dispatch use case.)
        for (const std::string& nm : config.exact_size_funcs) {
            if (nm.rfind("func_", 0) == 0) {
                uint32_t v = (uint32_t)std::strtoul(nm.c_str() + 5, nullptr, 16);
                if (v != 0) {
                    elf_config.exact_size_func_vrams.insert(v);
                }
            }
        }
        // Config-stubbed/ignored funcs are hard boundaries too: the config declaring an opinion about
        // a function is ground truth that its symbol is a REAL carve point, so the severed-fix
        // extension must neither extend it nor absorb it into a falls-off-end neighbor. (The j-target-
        // continuation extension absorbed toml-stubbed func_ symbols, dropping them from
        // functions_by_name, and the stub check below then killed the whole recomp — duke64/
        // wwfnomercy/triple2000 + 6 more in the 2026-07-01 sweep.)
        for (const auto* carve_list : { &config.stubbed_funcs, &config.ignored_funcs }) {
            for (const std::string& nm : *carve_list) {
                if (nm.rfind("func_", 0) == 0) {
                    uint32_t v = (uint32_t)std::strtoul(nm.c_str() + 5, nullptr, 16);
                    if (v != 0) {
                        elf_config.exact_size_func_vrams.insert(v);
                    }
                }
            }
        }

        bool found_entrypoint_func;
        if (!N64Recomp::Context::from_elf_file(config.elf_path, context, elf_config, dumping_context, data_syms, found_entrypoint_func)) {
            exit_failure("Failed to parse elf\n");
        }

        // Add any manual functions
        add_manual_functions(context, config.manual_functions);

        // A manual function can supply the entrypoint when the ELF only has a NON-FUNC symbol
        // at that address — e.g. SM64's boot stub is labeled `entry_point` as an OBJECT (glabel
        // with no size), so from_elf_file leaves found_entrypoint_func=false. Re-check after the
        // manual-functions pass so a manual func at the entrypoint vram counts. General.
        if (config.has_entrypoint && !found_entrypoint_func) {
            auto entry_it = context.functions_by_vram.find(config.entrypoint);
            if (entry_it != context.functions_by_vram.end() && !entry_it->second.empty()) {
                // from_elf_file renames the FUNC symbol at the entrypoint to "recomp_entrypoint" (the
                // name the app links against). SM64's entry is an OBJECT symbol (not a FUNC), so the boot
                // stub is supplied via manual_funcs and from_elf_file never renamed it. Do the rename here:
                // pick the body-bearing function at the entry vram (skip 0-size marker symbols like
                // _mainSegmentStart that can share the address) and rename it to recomp_entrypoint. General.
                size_t entry_func_index = entry_it->second[0];
                for (size_t fi : entry_it->second) {
                    if (!context.functions[fi].words.empty()) { entry_func_index = fi; break; }
                }
                N64Recomp::Function& entry_func = context.functions[entry_func_index];
                context.functions_by_name.erase(entry_func.name);
                entry_func.name = "recomp_entrypoint";
                context.functions_by_name["recomp_entrypoint"] = entry_func_index;
                found_entrypoint_func = true;
            }
        }

        if (config.has_entrypoint && !found_entrypoint_func) {
            exit_failure("Could not find entrypoint function\n");
        }
        
        if (dumping_context) {
            fmt::print("Dumping context\n");
            // Sort the data syms by address so the output is nicer.
            for (auto& [section_index, section_syms] : data_syms) {
                std::sort(section_syms.begin(), section_syms.end(),
                    [](const N64Recomp::DataSymbol& a, const N64Recomp::DataSymbol& b) {
                        return a.vram < b.vram;
                    }
                );
            }

            dump_context(context, data_syms, "dump.toml", "data_dump.toml");
            return 0;
        }
    }
    // Build a context from the provided symbols file.
    else if (!config.symbols_file_path.empty()) {
        if (config.rom_file_path.empty()) {
            exit_failure("A ROM file must be provided when using a symbols file\n");
        }

        if (dumping_context) {
            exit_failure("Cannot dump context when using a symbols file\n");
        }

        std::vector<uint8_t> rom = read_file(config.rom_file_path);
        if (rom.empty()) {
            exit_failure("Failed to load ROM file: " + config.rom_file_path.string() + "\n");
        }
        
        if (!N64Recomp::Context::from_symbol_file(config.symbols_file_path, std::move(rom), context, true)) {
            exit_failure("Failed to load symbols file\n");
        }

        auto rename_function = [&context](size_t func_index, const std::string& new_name) {
            N64Recomp::Function& func = context.functions[func_index];

            context.functions_by_name.erase(func.name);
            func.name = new_name;
            context.functions_by_name[func.name] = func_index;
        };

        for (size_t func_index = 0; func_index < context.functions.size(); func_index++) {
            N64Recomp::Function& func = context.functions[func_index];
            if (N64Recomp::reimplemented_funcs.contains(func.name)) {
                rename_function(func_index, func.name + "_recomp");
                func.reimplemented = true;
                func.ignored = true;
            } else if (N64Recomp::ignored_funcs.contains(func.name)) {
                rename_function(func_index, func.name + "_recomp");
                func.ignored = true;
            } else if (N64Recomp::renamed_funcs.contains(func.name)) {
                rename_function(func_index, func.name + "_recomp");
                func.ignored = false;
            }
        }


        if (config.has_entrypoint) {
            bool found_entrypoint = false;

            for (uint32_t func_index : context.functions_by_vram[config.entrypoint]) {
                auto& func = context.functions[func_index];
                if (func.rom == 0x1000) {
                    rename_function(func_index, "recomp_entrypoint");
                    found_entrypoint = true;
                    break;
                }
            }

            if (!found_entrypoint) {
                exit_failure("No entrypoint provided in symbol file\n");
            }
        }

    }
    else {
        exit_failure("Config file must provide either an elf or a symbols file\n");
    }


    fmt::print("Function count: {}\n", context.functions.size());

    std::filesystem::create_directories(config.output_func_path);

    std::ofstream func_header_file{ config.output_func_path / "funcs.h" };

    fmt::print(func_header_file,
        "{}\n"
        "\n"
        "#ifdef __cplusplus\n"
        "extern \"C\" {{\n"
        "#endif\n"
        "\n",
        config.recomp_include
    );

    std::vector<std::vector<uint32_t>> static_funcs_by_section{ context.sections.size() };

    fmt::print("Working dir: {}\n", std::filesystem::current_path().string());

    // Stub out any functions specified in the config file.
    for (const std::string& stubbed_func : config.stubbed_funcs) {
        // Check if the specified function exists.
        auto func_find = context.functions_by_name.find(stubbed_func);
        if (func_find == context.functions_by_name.end()) {
            // Hand-named entries keep the fatal (typo protection). Auto-named func_<hex> entries come
            // from gen_toml and may lawfully vanish (e.g. absorbed/merged boundaries on a re-splat) —
            // a stale auto entry must not kill an otherwise-good recomp.
            if (stubbed_func.rfind("func_", 0) == 0) {
                fmt::print(stderr, "[stub-skip] {} is stubbed in the config but does not exist; skipping\n", stubbed_func);
                continue;
            }
            exit_failure(fmt::format("Function {} is stubbed out in the config file but does not exist!", stubbed_func));
        }
        // Mark the function as stubbed.
        context.functions[func_find->second].stubbed = true;
    }

    // Ignore any functions specified in the config file.
    for (const std::string& ignored_func : config.ignored_funcs) {
        // Check if the specified function exists.
        auto func_find = context.functions_by_name.find(ignored_func);
        if (func_find == context.functions_by_name.end()) {
            // Same policy as stubs: auto-named func_<hex> entries may lawfully vanish; warn-and-skip.
            if (ignored_func.rfind("func_", 0) == 0) {
                fmt::print(stderr, "[ignore-skip] {} is ignored in the config but does not exist; skipping\n", ignored_func);
                continue;
            }
            exit_failure(fmt::format("Function {} is set as ignored in the config file but does not exist!", ignored_func));
        }
        // Mark the function as ignored.
        context.functions[func_find->second].ignored = true;
    }

    // Rename any functions specified in the config file.
    for (const std::string& renamed_func : config.renamed_funcs) {
        // Check if the specified function exists.
        auto func_find = context.functions_by_name.find(renamed_func);
        if (func_find == context.functions_by_name.end()) {
            // Function doesn't exist, present an error to the user instead of silently failing to rename it.
            // This helps prevent typos in the config file or functions renamed between versions from causing issues.
            exit_failure(fmt::format("Function {} is set as renamed in the config file but does not exist!", renamed_func));
        }
        // Rename the function.
        N64Recomp::Function* func = &context.functions[func_find->second];
        func->name = func->name + "_recomp";
    }

    // Propogate the trace mode parameter.
    context.trace_mode = config.trace_mode;

    // Apply any single-instruction patches.
    for (const N64Recomp::InstructionPatch& patch : config.instruction_patches) {
        // Check if the specified function exists.
        auto func_find = context.functions_by_name.find(patch.func_name);
        if (func_find == context.functions_by_name.end()) {
            // Function doesn't exist, present an error to the user instead of silently failing to stub it out.
            // This helps prevent typos in the config file or functions renamed between versions from causing issues.
            exit_failure(fmt::format("Function {} has an instruction patch but does not exist!", patch.func_name));
        }

        N64Recomp::Function& func = context.functions[func_find->second];
        int32_t func_vram = func.vram;

        // Check that the function actually contains this vram address.
        if (patch.vram < func_vram || patch.vram >= func_vram + func.words.size() * sizeof(func.words[0])) {
            exit_failure(fmt::format("Function {} has an instruction patch for vram 0x{:08X} but doesn't contain that vram address!", patch.func_name, (uint32_t)patch.vram));
        }

        // Calculate the instruction index and modify the instruction.
        size_t instruction_index = (static_cast<size_t>(patch.vram) - func_vram) / sizeof(uint32_t);
        func.words[instruction_index] = byteswap(patch.value);
    }

    // Apply any function hooks.
    for (const N64Recomp::FunctionTextHook& patch : config.function_hooks) {
        // Check if the specified function exists.
        auto func_find = context.functions_by_name.find(patch.func_name);
        if (func_find == context.functions_by_name.end()) {
            // Function doesn't exist, present an error to the user instead of silently failing to stub it out.
            // This helps prevent typos in the config file or functions renamed between versions from causing issues.
            exit_failure(fmt::format("Function {} has a function hook but does not exist!", patch.func_name));
        }

        N64Recomp::Function& func = context.functions[func_find->second];
        int32_t func_vram = func.vram;

        // Check that the function actually contains this vram address.
        if (patch.before_vram < func_vram || patch.before_vram >= func_vram + func.words.size() * sizeof(func.words[0])) {
            exit_failure(fmt::format("Function {} has a function hook for vram 0x{:08X} but doesn't contain that vram address!", patch.func_name, (uint32_t)patch.before_vram));
        }

        // No after_vram means this will be placed at the start of the function
        size_t instruction_index = -1;

        // Calculate the instruction index.
        if (patch.before_vram != 0) {
          instruction_index = (static_cast<size_t>(patch.before_vram) - func_vram) / sizeof(uint32_t);
        }

        // Check if a function hook already exits for that instruction index.
        auto hook_find = func.function_hooks.find(instruction_index);
        if (hook_find != func.function_hooks.end()) {
            exit_failure(fmt::format("Function {} already has a function hook for vram 0x{:08X}!", patch.func_name, (uint32_t)patch.before_vram));
        }

        func.function_hooks[instruction_index] = patch.text;
    }

    std::ofstream current_output_file;
    size_t output_file_count = 0;
    size_t cur_file_function_count = 0;
    
    auto open_new_output_file = [&config, &current_output_file, &output_file_count, &cur_file_function_count]() {
        current_output_file = std::ofstream{config.output_func_path / fmt::format("funcs_{}.c", output_file_count)};
        // Write the file header
        fmt::print(current_output_file,
            "{}\n"
            "#include \"funcs.h\"\n"
            "\n",
            config.recomp_include);

        // Print the extern for the base event index and the define to rename it if exports are allowed.
        if (config.allow_exports) {
            fmt::print(current_output_file,
                "extern uint32_t builtin_base_event_index;\n"
                "#define base_event_index builtin_base_event_index\n"
                "\n"
            );
        }

        cur_file_function_count = 0;
        output_file_count++;
    };

    if (config.single_file_output) {
        current_output_file.open(config.output_func_path / config.elf_path.stem().replace_extension(".c"));
        // Write the file header
        fmt::print(current_output_file,
            "{}\n"
            "#include \"funcs.h\"\n"
            "\n",
            config.recomp_include);

        // Print the extern for the base event index and the define to rename it if exports are allowed.
        if (config.allow_exports) {
            fmt::print(current_output_file,
                "extern uint32_t builtin_base_event_index;\n"
                "#define base_event_index builtin_base_event_index\n"
                "\n"
            );
        }
    }
    else if (config.functions_per_output_file > 1) {
        open_new_output_file();
    }

    std::unordered_map<size_t, size_t> function_index_to_event_index{};

    // If exports are enabled, scan all the relocs and modify ones that point to an event function.
    if (config.allow_exports) {
        // First, find the event section by scanning for a section with the special name.
        bool event_section_found = false;
        size_t event_section_index = 0;
        uint32_t event_section_vram = 0;
        for (size_t section_index = 0; section_index < context.sections.size(); section_index++) {
            const auto& section = context.sections[section_index];
            if (section.name == N64Recomp::EventSectionName) {
                event_section_found = true;
                event_section_index = section_index;
                event_section_vram = section.ram_addr;
                break;
            }
        }

        // If an event section was found, proceed with the reloc scanning.
        if (event_section_found) {
            for (auto& section : context.sections) {
                for (auto& reloc : section.relocs) {
                    // Event symbols aren't reference symbols, since they come from the elf itself.
                    // Therefore, skip reference symbol relocs.
                    if (reloc.reference_symbol) {
                        continue;
                    }

                    // Ignore R_MIPS_NONE relocs, which get produced during symbol parsing for non-relocatable reference sections.
                    if (reloc.type == N64Recomp::RelocType::R_MIPS_NONE) {
                        continue;
                    }

                    // Check if the reloc points to the event section.
                    if (reloc.target_section == event_section_index) {
                        // It does, so find the function it's pointing at.
                        size_t func_index = context.find_function_by_vram_section(reloc.target_section_offset + event_section_vram, event_section_index);

                        if (func_index == (size_t)-1) {
                            exit_failure(fmt::format("Failed to find event function with vram {}.\n", reloc.target_section_offset + event_section_vram));
                        }

                        // Ensure the reloc is a MIPS_R_26 one before modifying it, since those are the only type allowed to reference
                        if (reloc.type != N64Recomp::RelocType::R_MIPS_26) {
                            const auto& function = context.functions[func_index];
                            exit_failure(fmt::format("Function {} is an import and cannot have its address taken.\n",
                                function.name));
                        }

                        // Check if this function has been assigned an event index already, and assign it if not.
                        size_t event_index;
                        auto find_event_it = function_index_to_event_index.find(func_index);
                        if (find_event_it != function_index_to_event_index.end()) {
                            event_index = find_event_it->second;
                        }
                        else {
                            event_index = function_index_to_event_index.size();
                            function_index_to_event_index.emplace(func_index, event_index);
                        }

                        // Modify the reloc's fields accordingly.
                        reloc.target_section_offset = 0;
                        reloc.symbol_index = event_index;
                        reloc.target_section = N64Recomp::SectionEvent;
                        reloc.reference_symbol = true;
                    }
                }
            }
        }
    }

    // ---- AN IGNORED FUNCTION THAT SOMETHING ACTUALLY REACHES MUST STILL BE BUILT --------------
    //
    // ignored_funcs means "do not recompile this; the host provides it". reimplemented_funcs is the
    // list the host really does provide (it is exactly the *_recomp names in the host ABI, checked
    // 2026-09-07: 104 of 104). ignored_funcs carries 201 more names that NOTHING implements - they
    // are libultra routines upstream expected a different runtime to supply.
    //
    // A call site is emitted whatever the callee's state: it always writes name_recomp(rdram, ctx).
    // So an ignored-and-unimplemented function that some emitted function jumps to is a call to a
    // function that exists nowhere, and the C compiler stops. That is Super Mario 64 on 2026-09-07:
    // one recompiled function tail-jumps into __osDequeueThread, which nothing defines. Removing
    // names from the list by hand just moves the failure to the next name (osTimerServicesInit was
    // the one before it).
    //
    // The cart carries the code. If something reaches it, recompile it from the cart - that is what
    // this pipeline does with every other function. Only what is REACHED is un-ignored, which is why
    // this is a scan and not a blanket switch: ignored_funcs also names microcode text blobs
    // (gspF3DEX2_fifoTextStart, rspbootTextStart) that are data wearing a function symbol. Nothing
    // jumps to those, so they stay ignored and are never fed to the instruction decoder.
    //
    // Repeated to a fixed point: a function un-ignored here can reach another one.
    {
        // WHAT THE HOST REALLY IMPLEMENTS is recompilator/launcher/recomp_host_abi.txt, derived from
        // the built engine by tools/make_host_abi.ps1. reimplemented_funcs is a hand-kept list and it
        // is SHORTER: on 2026-09-07 the host exported 155 *_recomp entries against 104 names here, so
        // trusting the list alone un-ignored osMapTLB, __osGetCause and __d_to_ull - all three already
        // in the host - and the module linked two definitions of each. The file is the answer; the list
        // is only the fallback for a caller that does not pass one.
        std::unordered_set<std::string> host_provided;
        if (const char* abi_path = std::getenv("RECOMPILATOR_HOST_ABI")) {
            std::ifstream abi_file{abi_path};
            if (abi_file.good()) {
                std::string abi_line;
                while (std::getline(abi_file, abi_line)) {
                    while (!abi_line.empty() && (abi_line.back() == 0x0D || abi_line.back() == 0x20 || abi_line.back() == 0x09)) {
                        abi_line.pop_back();
                    }
                    if (abi_line.empty() || abi_line[0] == 0x23) {
                        continue;
                    }
                    size_t data_at = abi_line.rfind(" DATA");
                    if (data_at != std::string::npos && data_at + 5 == abi_line.size()) {
                        abi_line.resize(data_at);
                    }
                    size_t eq_at = abi_line.find(0x3D);
                    if (eq_at != std::string::npos) {
                        abi_line.resize(eq_at);
                    }
                    if (!abi_line.empty()) {
                        host_provided.insert(abi_line);
                    }
                }
                fmt::print("host ABI: {} symbol(s) from {}\\n", host_provided.size(), abi_path);
            }
            else {
                fmt::print(stderr, "[host-abi] cannot read {} -- falling back to reimplemented_funcs\\n", abi_path);
            }
        }
        auto host_has = [&](const N64Recomp::Function& f) {
            if (f.reimplemented) {
                return true;
            }
            return !host_provided.empty() && host_provided.count(f.name) != 0;
        };
        size_t unignored_total = 0;
        bool changed = true;
        while (changed) {
            changed = false;
            for (const N64Recomp::Function& func : context.functions) {
                if (func.ignored || func.words.size() == 0) {
                    continue;
                }
                for (size_t w = 0; w < func.words.size(); w++) {
                    uint32_t instr = byteswap(func.words[w]);
                    uint32_t op = instr >> 26;
                    if (op != 2 && op != 3) { // j, jal - the only direct-target forms
                        continue;
                    }
                    uint32_t pc = func.vram + (uint32_t)(w * 4);
                    uint32_t target = (pc & 0xF0000000u) | ((instr & 0x03FFFFFFu) << 2);
                    auto vram_find = context.functions_by_vram.find(target);
                    if (vram_find == context.functions_by_vram.end()) {
                        continue;
                    }
                    for (size_t callee_index : vram_find->second) {
                        N64Recomp::Function& callee = context.functions[callee_index];
                        if (!callee.ignored || host_has(callee) || callee.words.size() == 0) {
                            continue;
                        }
                        callee.ignored = false;
                        unignored_total++;
                        changed = true;
                        fmt::print(stderr, "[unignore] {} is reached from {} and nothing implements it; "
                            "recompiling it from the cart\\n", callee.name, func.name);
                    }
                }
                // AND the FALL-THROUGH edge. A function whose last word is a plain instruction runs
                // straight on into the one after it, and recompilation.cpp emits a tail call for that
                // with no jump anywhere in the words - so the scan above cannot see it. Super Mario 64
                // reaches __osTimerServicesInit exactly this way. The guard below is the same one that
                // decides whether the edge is emitted at all (recompilation.cpp, "ADJACENT functions"):
                // the last instruction owns no delay slot and is not eret, and the one before it is not
                // an unconditional non-linking transfer that already ended the function.
                {
                    size_t n = func.words.size();
                    rabbitizer::InstructionCpu last(byteswap(func.words[n - 1]), func.vram + (uint32_t)((n - 1) * 4));
                    bool prev_terminates = false;
                    if (n >= 2) {
                        rabbitizer::InstructionCpu prev(byteswap(func.words[n - 2]), func.vram + (uint32_t)((n - 2) * 4));
                        if (prev.hasDelaySlot() && !prev.doesLink()) {
                            rabbitizer::InstrId::UniqueId id = prev.getUniqueId();
                            prev_terminates = id == rabbitizer::InstrId::UniqueId::cpu_j
                                           || id == rabbitizer::InstrId::UniqueId::cpu_jr
                                           || prev.isUnconditionalBranch();
                        }
                    }
                    if (!last.hasDelaySlot() && !prev_terminates
                        && last.getUniqueId() != rabbitizer::InstrId::UniqueId::cpu_eret) {
                        uint32_t next_vram = func.vram + (uint32_t)(n * 4);
                        auto ft = context.functions_by_vram.find(next_vram);
                        if (next_vram != 0 && ft != context.functions_by_vram.end() && !ft->second.empty()) {
                            N64Recomp::Function& callee = context.functions[ft->second[0]];
                            if (callee.ignored && !host_has(callee) && !callee.words.empty()
                                && !callee.name.empty() && callee.name.rfind("L_", 0) != 0
                                && callee.name.rfind("D_", 0) != 0 && callee.name.rfind("_binary_", 0) != 0) {
                                callee.ignored = false;
                                unignored_total++;
                                changed = true;
                                fmt::print(stderr, "[unignore] {} is FALLEN INTO from {} and nothing "
                                    "implements it; recompiling it from the cart\\n", callee.name, func.name);
                            }
                        }
                    }
                }
            }
        }
        if (unignored_total != 0) {
            fmt::print("un-ignored {} reached function(s) the host does not implement\\n", unignored_total);
        }
    }

    std::vector<size_t> export_function_indices{};

    bool failed_strict_mode = false;
    bool any_function_failed = false;

    //#pragma omp parallel for
    for (size_t i = 0; i < context.functions.size(); i++) {
        const auto& func = context.functions[i];

        if (!func.ignored && func.words.size() != 0) {
            fmt::print(func_header_file,
                "void {}(uint8_t* rdram, recomp_context* ctx);\n", func.name);
            bool result;
            const auto& func_section = context.sections[func.section_index];
            // Apply strict patch mode validation if enabled.
            if (config.strict_patch_mode) {
                bool in_normal_patch_section = func_section.name == N64Recomp::PatchSectionName;
                bool in_force_patch_section = func_section.name == N64Recomp::ForcedPatchSectionName;
                bool in_patch_section = in_normal_patch_section || in_force_patch_section;
                N64Recomp::SymbolReference dummy_ref;
                bool reference_symbol_found = context.reference_symbol_exists(func.name);

                // This is a patch function, but no corresponding symbol was found in the original symbol list.
                if (in_patch_section && !reference_symbol_found) {
                    fmt::print(stderr, "Function {} is marked as a replacement, but no function with the same name was found in the reference symbols!\n", func.name);
                    failed_strict_mode = true;
                    continue;
                }
                // This is not a patch function, but it has the same name as a function in the original symbol list.
                else if (!in_patch_section && reference_symbol_found) {
                    fmt::print(stderr, "Function {} is not marked as a replacement, but a function with the same name was found in the reference symbols!\n", func.name);
                    failed_strict_mode = true;
                    continue;
                }
            }
            // Check if this is an export and add it to the list if exports are enabled.
            if (config.allow_exports && func_section.name == N64Recomp::ExportSectionName) {
                export_function_indices.push_back(i);
            }

            // Recompile the function.
            if (config.single_file_output || config.functions_per_output_file > 1) {
                result = N64Recomp::recompile_function(context, i, current_output_file, static_funcs_by_section, false);
                if (!config.single_file_output) {
                    cur_file_function_count++;
                    if (cur_file_function_count >= config.functions_per_output_file) {
                        open_new_output_file();
                    }
                }
            }
            else {
                result = recompile_single_function(context, i, config.recomp_include, config.output_func_path / (func.name + ".c"), static_funcs_by_section);
            }
            if (result == false) {
                fmt::print(stderr, "Error recompiling {}\n", func.name);
                // Keep going so one run reports every failing function (the autostub loop
                // consumes them all at once); the exit below still fails the run.
                any_function_failed = true;
            }
        } else if (func.reimplemented) {
            fmt::print(func_header_file,
                       "void {}(uint8_t* rdram, recomp_context* ctx);\n", func.name);
        }
    }

    if (failed_strict_mode) {
        if (config.single_file_output || config.functions_per_output_file > 1) {
            current_output_file.close();
            std::error_code ec;
            std::filesystem::remove(config.output_func_path / config.elf_path.stem().replace_extension(".c"), ec);
        }
        exit_failure("Strict mode validation failed!\n");
    }

    for (size_t section_index = 0; section_index < context.sections.size(); section_index++) {
        auto& section = context.sections[section_index];
        auto& section_funcs = section.function_addrs;

        // Sort the section's functions
        std::sort(section_funcs.begin(), section_funcs.end());
        // Sort and deduplicate the static functions via a set
        std::set<uint32_t> statics_set{ static_funcs_by_section[section_index].begin(), static_funcs_by_section[section_index].end() };
        std::vector<uint32_t> section_statics{};
        section_statics.assign(statics_set.begin(), statics_set.end());

        // Static end boundaries must be REAL function starts (functions that have instructions),
        // not the lookup dummies from_elf_file records for every NOTYPE/OBJECT symbol. Assembler
        // branch labels (L_*) land in function_addrs as dummies; sizing a static to one truncates
        // it mid-body and the emitted C falls off the end — SOTE's kernel-init static died at a
        // beq label this way (boot chain's silent guest-thread death). Boundaries built from the
        // section's actual functions keep stub carves (real FUNC symbols) intact.
        std::vector<uint32_t> real_func_starts;
        real_func_starts.reserve(context.section_functions[section_index].size());
        for (size_t real_fi : context.section_functions[section_index]) {
            if (!context.functions[real_fi].words.empty()) {
                real_func_starts.push_back(context.functions[real_fi].vram);
            }
        }
        std::sort(real_func_starts.begin(), real_func_starts.end());

        for (size_t static_func_index = 0; static_func_index < section_statics.size(); static_func_index++) {
            uint32_t static_func_addr = section_statics[static_func_index];

            // Determine the end of this static function
            uint32_t cur_func_end = static_cast<uint32_t>(section.size + section.ram_addr);

            // Search for the closest real function at or after this static
            size_t closest_func_index = 0;
            while (closest_func_index < real_func_starts.size() && real_func_starts[closest_func_index] <= static_func_addr) {
                closest_func_index++;
            }

            // Check if there's a nonstatic function after this one
            if (closest_func_index < real_func_starts.size()) {
                // If so, use that function's address as the end of this one
                cur_func_end = real_func_starts[closest_func_index];
            }

            // GENERAL FIX (sweep): a static is a JAL target that often lands MID real-function (a function
            // reached at multiple entry points). Sizing it only to the next real-function boundary (above)
            // severs it before its own FORWARD BRANCHES, which then land outside the static -> "Unhandled
            // branch in static_..." -> recomp abort (the dominant class-C straggler: Conker, bombhero,
            // mkmyth, ...). Extend cur_func_end to cover the static's forward branch targets, even across
            // intervening (spurious) boundaries, iterating since the extended range can reveal more. Bounded
            // by the section end. Overlapping statics duplicate code but recompile correctly.
            {
                uint32_t section_end = static_cast<uint32_t>(section.size + section.ram_addr);
                bool grew = true;
                while (grew && cur_func_end < section_end) {
                    grew = false;
                    const uint32_t* scan = reinterpret_cast<const uint32_t*>(
                        context.rom.data() + (static_func_addr - section.ram_addr + section.rom_addr));
                    uint32_t count = (cur_func_end - static_func_addr) / sizeof(uint32_t);
                    for (uint32_t i = 0; i < count; i++) {
                        uint32_t insn = byteswap(scan[i]);
                        uint32_t op = insn >> 26;
                        // beq/bne/blez/bgtz (+ their *l likely forms) and REGIMM bltz/bgez/bltzal/bgezal
                        bool is_branch = (op >= 4 && op <= 7) || (op >= 0x14 && op <= 0x17) || op == 1;
                        if (is_branch) {
                            uint32_t va = static_func_addr + i * sizeof(uint32_t);
                            int32_t off = static_cast<int16_t>(insn & 0xFFFF);
                            uint32_t tgt = va + 4 + (off << 2);
                            if (tgt >= cur_func_end && tgt < section_end) {
                                cur_func_end = (tgt + 2 * static_cast<uint32_t>(sizeof(uint32_t)) + 3u) & ~3u;
                                grew = true;
                            }
                        }
                    }
                }
            }

            uint32_t rom_addr = static_cast<uint32_t>(static_func_addr - section.ram_addr + section.rom_addr);
            const uint32_t* func_rom_start = reinterpret_cast<const uint32_t*>(context.rom.data() + rom_addr);

            std::vector<uint32_t> insn_words((cur_func_end - static_func_addr) / sizeof(uint32_t));
            insn_words.assign(func_rom_start, func_rom_start + insn_words.size());

            // Create the new function and add it to the context.
            size_t new_func_index = context.functions.size();
            context.functions.emplace_back(
                static_func_addr,
                rom_addr,
                std::move(insn_words),
                fmt::format("static_{}_{:08X}", section_index, static_func_addr),
                static_cast<uint16_t>(section_index),
                false
            );
            const N64Recomp::Function& new_func = context.functions[new_func_index];

            fmt::print(func_header_file,
                       "void {}(uint8_t* rdram, recomp_context* ctx);\n", new_func.name);

            bool result;
            size_t prev_num_statics = static_funcs_by_section[new_func.section_index].size();
            if (config.single_file_output || config.functions_per_output_file > 1) {
                // GENERAL FIX (sweep, class-C static MASTER KEY): an auto-created static_ at a DATA jal-target can
                // fail to recompile two ways — invalid opcodes (analysis fails) OR valid opcodes with a garbage
                // control-flow transfer, e.g. a j/jal landing mid-data ("Unhandled branch", which fires DEEP in
                // the emit loop after a partial function is already written to the shared funcs_N.c). A static has
                // no toml entry, so recomp_autostub can't catch it. Buffer the static's recompile through a
                // stringstream: commit it on success; on ANY failure, discard the partial and emit a clean empty
                // stub instead. The jal caller still links and a data target is never genuinely executed as code.
                // This subsumes a primary-opcode heuristic and needs no replication of the emitter's branch logic.
                std::stringstream static_buf;
                result = N64Recomp::recompile_function(context, new_func_index, static_buf, static_funcs_by_section, false);
                // A "successful" recompile of a data static can still emit a dangling goto that won't COMPILE
                // (see body_has_dangling_goto). Treat that as a failure so the stub path below neutralizes it.
                if (result && body_has_dangling_goto(static_buf.str())) {
                    result = false;
                }
                if (!result) {
                    // EMPTY-STUB FIX (NC RUN-30, the silent-thread-death class): don't emit an empty
                    // body — route through the live-gap dispatch so a real-code target (cross-function
                    // branch to a non-entry, splat mis-split) actually executes at runtime. Genuine
                    // data still degrades to a no-op inside the trampoline (fail-safe preserved).
                    context.functions[new_func_index].gap_dispatch = true;
                    std::stringstream stub_buf;
                    result = N64Recomp::recompile_function(context, new_func_index, stub_buf, static_funcs_by_section, false);
                    current_output_file << stub_buf.str();
                    N64Recomp::diag::hit({ .kind = "static-stub", .vaddr = new_func.vram, .func = new_func.name, .detail = "gap-dispatch", .a = new_func.rom, .b = (uint32_t)section.ram_addr, .c = (uint32_t)section.rom_addr, .section_index = new_func.section_index });
                    fmt::print(stderr, "[static-stub] {} unbuildable statically -> emitted as live-gap dispatch stub\n", new_func.name);
                }
                else {
                    current_output_file << static_buf.str();
                }
                if (!config.single_file_output) {
                    cur_file_function_count++;
                    if (cur_file_function_count >= config.functions_per_output_file) {
                        open_new_output_file();
                    }
                }
            }
            else {
                result = recompile_single_function(context, new_func_index, config.recomp_include, config.output_func_path / (new_func.name + ".c"), static_funcs_by_section);
                if (!result) {
                    // Same EMPTY-STUB FIX as the multi-file path above: live-gap dispatch, not a no-op.
                    context.functions[new_func_index].gap_dispatch = true;
                    result = recompile_single_function(context, new_func_index, config.recomp_include, config.output_func_path / (new_func.name + ".c"), static_funcs_by_section);
                    N64Recomp::diag::hit({ .kind = "static-stub", .vaddr = new_func.vram, .func = new_func.name, .detail = "gap-dispatch", .a = new_func.rom, .b = (uint32_t)section.ram_addr, .c = (uint32_t)section.rom_addr, .section_index = new_func.section_index });
                    fmt::print(stderr, "[static-stub] {} unrecompilable statically -> emitted as live-gap dispatch stub\n", new_func.name);
                }
            }

            // Add any new static functions that were found while recompiling this one.
            size_t cur_num_statics = static_funcs_by_section[new_func.section_index].size();
            if (cur_num_statics != prev_num_statics) {
                for (size_t new_static_index = prev_num_statics; new_static_index < cur_num_statics; new_static_index++) {
                    uint32_t new_static_vram = static_funcs_by_section[new_func.section_index][new_static_index];

                    if (!statics_set.contains(new_static_vram)) {
                        statics_set.emplace(new_static_vram);
                        section_statics.push_back(new_static_vram);
                    }
                }
            }

            if (result == false) {
                fmt::print(stderr, "Error recompiling {}\n", new_func.name);
                std::exit(EXIT_FAILURE);
            }
        }
    }

    if (any_function_failed) {
        // Every function was attempted and each failure was reported above; fail the run
        // before finalizing output so nothing downstream consumes the partial files.
        exit_failure("One or more functions failed to recompile.\n");
    }

    if (config.has_entrypoint) {
        std::ofstream lookup_file{ config.output_func_path / "lookup.cpp" };
        
        fmt::print(lookup_file,
            "{}\n"
            "\n",
            config.recomp_include
        );

        fmt::print(lookup_file,
            "gpr get_entrypoint_address() {{ return (gpr)(int32_t)0x{:08X}u; }}\n"
            "\n"
            "const char* get_rom_name() {{ return \"{}\"; }}\n"
            "\n",
            static_cast<uint32_t>(config.entrypoint),
            config.elf_path.filename().replace_extension(".z64").string()
        );
    }

    {
        std::ofstream overlay_file(config.output_func_path / "recomp_overlays.inl");
        std::string section_load_table = "static SectionTableEntry section_table[] = {\n";

        fmt::print(overlay_file, 
            "{}\n"
            "#include \"funcs.h\"\n"
            "#include \"librecomp/sections.h\"\n"
            "\n",
            config.recomp_include
        );

        std::unordered_map<std::string, size_t> relocatable_section_indices{};
        size_t written_sections = 0;

        for (size_t section_index = 0; section_index < context.sections.size(); section_index++) {
            const auto& section = context.sections[section_index];
            const auto& section_funcs = context.section_functions[section_index];
            const auto& section_relocs = section.relocs;

            if (section.has_mips32_relocs || !section_funcs.empty()) {
                std::string_view section_name_view{ section.name };

                if (section.relocatable) {
                    relocatable_section_indices.emplace(section.name, written_sections);
                }

                while (section_name_view.size() > 0 && section_name_view[0] == '.') {
                    section_name_view.remove_prefix(1);
                }

                // Sanitize into a valid C identifier: replace EVERY non-identifier character
                // (not just the leading dots) with '_'. Decomp ELFs in the OoT class have
                // sections with internal dots — e.g. "..makerom.ent", "..code.bss" — which
                // would otherwise emit `section_4_makerom.ent_funcs` (a '.' in an identifier =
                // a C syntax error). The section_index prefix keeps the names unique. General.
                std::string section_name_trimmed{ section_name_view };
                for (char& c : section_name_trimmed) {
                    if (!(std::isalnum((unsigned char)c) || c == '_')) {
                        c = '_';
                    }
                }

                std::string section_funcs_array_name = fmt::format("section_{}_{}_funcs", section_index, section_name_trimmed);
                std::string section_relocs_array_name = section_relocs.empty() ? "nullptr" : fmt::format("section_{}_{}_relocs", section_index, section_name_trimmed);
                std::string section_relocs_array_size = section_relocs.empty() ? "0" : fmt::format("ARRLEN({})", section_relocs_array_name);

                // Write the section's table entry.
                section_load_table += fmt::format("    {{ .rom_addr = 0x{0:08X}, .ram_addr = 0x{1:08X}, .size = 0x{2:08X}, .funcs = {3}, .num_funcs = ARRLEN({3}), .relocs = {4}, .num_relocs = {5}, .index = {6} }},\n",
                                                  section.rom_addr, section.ram_addr, section.size, section_funcs_array_name,
                                                  section_relocs_array_name, section_relocs_array_size, section_index);

                // Write the section's functions.
                fmt::print(overlay_file, "static FuncEntry {}[] = {{\n", section_funcs_array_name);

                for (size_t func_index : section_funcs) {
                    const auto& func = context.functions[func_index];
                    size_t func_size = func.reimplemented ? 0 : func.words.size() * sizeof(func.words[0]);

                    if (func.reimplemented || (!func.name.empty() && !func.ignored && func.words.size() != 0)) {
                        fmt::print(overlay_file, "    {{ .func = {}, .offset = 0x{:08X}, .rom_size = 0x{:08X} }},\n",
                            func.name, func.rom - section.rom_addr, func_size);
                    }
                }

                fmt::print(overlay_file, "}};\n");

                // Write the section's relocations.
                if (!section_relocs.empty()) {
                    // Determine if reference symbols are being used.
                    bool reference_symbol_mode = !config.func_reference_syms_file_path.empty();

                    fmt::print(overlay_file, "static RelocEntry {}[] = {{\n", section_relocs_array_name);

                    for (const N64Recomp::Reloc& reloc : section_relocs) {
                        bool emit_reloc = false;
                        uint16_t target_section = reloc.target_section;
                        // In reference symbol mode, only emit relocations into the table that point to
                        // non-absolute reference symbols, events, or manual patch symbols.
                        if (reference_symbol_mode) {
                            bool manual_patch_symbol = N64Recomp::is_manual_patch_symbol(reloc.target_section_offset);
                            bool is_absolute = reloc.target_section == N64Recomp::SectionAbsolute;
                            emit_reloc = (reloc.reference_symbol && !is_absolute) || target_section == N64Recomp::SectionEvent || manual_patch_symbol;
                        }
                        // Otherwise, emit all relocs.
                        else {
                            emit_reloc = true;
                        }
                        if (emit_reloc) {
                            uint32_t target_section_offset;
                            if (reloc.target_section == N64Recomp::SectionEvent) {
                                target_section_offset = reloc.symbol_index;
                            }
                            else {
                                target_section_offset = reloc.target_section_offset;
                            }
                            fmt::print(overlay_file, "    {{ .offset = 0x{:08X}, .target_section_offset = 0x{:08X}, .target_section = {}, .type = {} }}, \n",
                                reloc.address - section.ram_addr, target_section_offset, reloc.target_section, reloc_names[static_cast<size_t>(reloc.type)] );
                        }
                    }

                    fmt::print(overlay_file, "}};\n");
                }

                written_sections++;
            }
        }
        section_load_table += "};\n";

        fmt::print(overlay_file, "{}", section_load_table);

        fmt::print(overlay_file, "const size_t num_sections = {};\n", context.sections.size());


        fmt::print(overlay_file, "static int overlay_sections_by_index[] = {{\n");
        if (relocatable_sections_ordered.empty()) {
            fmt::print(overlay_file, "    -1,\n");
        } else {
            for (const std::string& section : relocatable_sections_ordered) {
                // Check if this is an empty overlay
                if (section == "*") {
                    fmt::print(overlay_file, "    -1,\n");
                }
                else {
                    auto find_it = relocatable_section_indices.find(section);
                    if (find_it == relocatable_section_indices.end()) {
                        fmt::print(stderr, "Failed to find written section index of relocatable section: {}\n", section);
                        std::exit(EXIT_FAILURE);
                    }
                    fmt::print(overlay_file, "    {},\n", relocatable_section_indices[section]);
                }
            }
        }
        fmt::print(overlay_file, "}};\n");

        if (config.allow_exports) {
            // Emit the exported function table.
            fmt::print(overlay_file, 
                "\n"
                "static FunctionExport export_table[] = {{\n"
            );
            for (size_t func_index : export_function_indices) {
                const auto& func = context.functions[func_index];
                fmt::print(overlay_file, "    {{ \"{}\", 0x{:08X} }},\n", func.name, func.vram);
            }
            // Add a dummy element at the end to ensure the array has a valid length because C doesn't allow zero-size arrays.
            fmt::print(overlay_file, "    {{ NULL, 0 }}\n");
            fmt::print(overlay_file, "}};\n");

            // Emit the event table.
            std::vector<size_t> functions_by_event{};
            functions_by_event.resize(function_index_to_event_index.size());
            for (auto [func_index, event_index] : function_index_to_event_index) {
                functions_by_event[event_index] = func_index;
            }

            fmt::print(overlay_file,
                "\n"
                "static const char* event_names[] = {{\n"
            );
            for (size_t func_index : functions_by_event) {
                const auto& func = context.functions[func_index];
                fmt::print(overlay_file, "    \"{}\",\n", func.name);
            }
            // Add a dummy element at the end to ensure the array has a valid length because C doesn't allow zero-size arrays.
            fmt::print(overlay_file, "    NULL\n");
            fmt::print(overlay_file, "}};\n");

            // Collect manual patch symbols.
            std::vector<std::pair<uint32_t, std::string>> manual_patch_syms{};

            for (const auto& func : context.functions) {
                if (func.words.empty() && N64Recomp::is_manual_patch_symbol(func.vram)) {
                    manual_patch_syms.emplace_back(func.vram, func.name);
                }
            }            

            // Sort the manual patch symbols by vram.
            std::sort(manual_patch_syms.begin(), manual_patch_syms.end(), [](const auto& lhs, const auto& rhs) {
                return lhs.first < rhs.first;
            });

            // Emit the manual patch symbols.
            fmt::print(overlay_file,
                "\n"
                "static const ManualPatchSymbol manual_patch_symbols[] = {{\n"
            );
            for (const auto& manual_patch_sym_entry : manual_patch_syms) {
                fmt::print(overlay_file, "    {{ 0x{:08X}, {} }},\n", manual_patch_sym_entry.first, manual_patch_sym_entry.second);

                fmt::print(func_header_file,
                    "void {}(uint8_t* rdram, recomp_context* ctx);\n", manual_patch_sym_entry.second);
            }
            // Add a dummy element at the end to ensure the array has a valid length because C doesn't allow zero-size arrays.
            fmt::print(overlay_file, "    {{ 0, NULL }}\n");
            fmt::print(overlay_file, "}};\n");
        }
    }

    fmt::print(func_header_file,
        "\n"
        "#ifdef __cplusplus\n"
        "}}\n"
        "#endif\n"
    );

    if (!config.output_binary_path.empty()) {
        std::ofstream output_binary{config.output_binary_path, std::ios::binary};
        output_binary.write(reinterpret_cast<const char*>(context.rom.data()), context.rom.size());
    }

    // Structured diagnostics sink (roadmap tool #1): on a RECOMP_DIAG run, write the deduped degrade
    // report next to the recompiled output. No-op when RECOMP_DIAG is unset (baseline builds pay nothing).
    if (N64Recomp::diag::enabled()) {
        std::filesystem::path failures_path = std::filesystem::path(config.output_func_path) / "failures.json";
        N64Recomp::diag::flush_to_file(failures_path.string(), "build", "");
    }

    return 0;
}
