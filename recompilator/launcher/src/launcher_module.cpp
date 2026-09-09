/**
 * launcher_module.cpp — THE HOST SIDE OF THE GAME MODULE ABI (Recompilator UI step 3, 2026-09-06).
 *
 * PLAY used to spawn `<game>pc.exe`. Here it loads `<game>pc/module/<game>.dll` into THIS process,
 * asks it for its descriptor (recompilator/include/recomp_module.h), hands the descriptor's
 * contents to the already-running engine, and calls recomp::start_game(). One window, one
 * renderer, one input path — the game draws in the launcher's window.
 *
 * NEVER PER-GAME CODE. Every value below comes out of the module or out of the catalog entry;
 * there is not one game name, address or hash in this file.
 *
 * WHY THIS WORKS AT ALL, mechanically: recomp::start() (librecomp/src/recomp.cpp) spawns the game
 * thread and parks it in wait_for_game_started() on the `game_status` atomic, then runs the window
 * loop calling gfx_callbacks.update_gfx forever. The launcher's UI ticks inside that update_gfx.
 * So everything below runs on the main thread while the game thread is still parked, and
 * start_game() is the one call that releases it. Registration therefore CANNOT race the game.
 */

#if defined(_WIN32)
#  define WIN32_LEAN_AND_MEAN
#  include <Windows.h>
#endif

#include <cstdio>
#include <filesystem>
#include <string>

#include "recomp.h"
#include "librecomp/game.hpp"
#include "librecomp/overlays.hpp"
#include "librecomp/rsp.hpp"
#include "librecomp/sections.h"
#include "ultramodern/ultramodern.hpp"

#include "recomp_module.h"
#include "launcher_app.hpp"

namespace fs = std::filesystem;

namespace launcher {

namespace {

// One loaded module per process: this engine has one RDRAM, one overlay table and one game thread,
// and its quit path terminates the process, so a second game is not a thing that can happen.
HMODULE                g_module = nullptr;
const RecompModuleV1*  g_desc = nullptr;
std::u8string          g_game_id;

std::u8string to_u8(const char* s) {
    return std::u8string(reinterpret_cast<const char8_t*>(s ? s : ""));
}

recomp::SaveType save_type_from(int32_t v) {
    switch (v) {
    case RECOMP_MODULE_SAVE_EEP4K:     return recomp::SaveType::Eep4k;
    case RECOMP_MODULE_SAVE_EEP16K:    return recomp::SaveType::Eep16k;
    case RECOMP_MODULE_SAVE_SRAM:      return recomp::SaveType::Sram;
    case RECOMP_MODULE_SAVE_FLASHRAM:  return recomp::SaveType::Flashram;
    case RECOMP_MODULE_SAVE_ALLOW_ALL: return recomp::SaveType::AllowAll;
    default:                           return recomp::SaveType::None;
    }
}

} // namespace

bool module_loaded() { return g_desc != nullptr; }

// Load <dll_path>, validate it, register everything it declares, install the ROM, and start it.
// `error_out` carries the reason on a false return; nothing is left half-registered on failure
// before start_game(), because every step before it is a pure registration.
bool module_play(const std::string& dll_path, const std::string& rom_path, std::string& error_out) {
#if !defined(_WIN32)
    error_out = "game modules are Windows-only so far";
    return false;
#else
    if (g_desc != nullptr) {
        error_out = "a game module is already loaded in this process";
        return false;
    }

    const fs::path dll = fs::absolute(fs::path(dll_path));
    if (!fs::exists(dll)) { error_out = "no module at " + dll.string(); return false; }

    // The same flags librecomp's own native-mod loader uses (mods.cpp): the module's own directory
    // is searched for its dependencies, and nothing is taken off the ambient PATH.
    g_module = LoadLibraryExW(dll.c_str(), nullptr,
                              LOAD_LIBRARY_SEARCH_DEFAULT_DIRS | LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR);
    if (g_module == nullptr) {
        // The commonest failure by far is the host ABI: the module imports the host's exported C
        // symbols by name, so a host built without them fails here with ERROR_PROC_NOT_FOUND.
        char msg[256];
        snprintf(msg, sizeof(msg), "LoadLibraryEx failed (GetLastError=%lu)", (unsigned long)GetLastError());
        error_out = msg;
        return false;
    }
    fprintf(stderr, "[launcher] module loaded: %s (HMODULE %p)\n", dll.string().c_str(), (void*)g_module);

    auto query = (RecompModuleQueryFunc)GetProcAddress(g_module, RECOMP_MODULE_QUERY_SYMBOL);
    if (query == nullptr) {
        error_out = "module exports no " RECOMP_MODULE_QUERY_SYMBOL;
        FreeLibrary(g_module); g_module = nullptr;
        return false;
    }

    const RecompModuleV1* m = query(RECOMP_MODULE_ABI_VERSION);
    if (m == nullptr) {
        error_out = "module refused ABI version " + std::to_string(RECOMP_MODULE_ABI_VERSION);
        FreeLibrary(g_module); g_module = nullptr;
        return false;
    }
    if (m->abi_version != RECOMP_MODULE_ABI_VERSION || m->struct_size != sizeof(RecompModuleV1)) {
        char msg[192];
        snprintf(msg, sizeof(msg),
                 "module ABI mismatch: it says v%u/%u bytes, this host is v%u/%u bytes",
                 m->abi_version, m->struct_size, RECOMP_MODULE_ABI_VERSION, (unsigned)sizeof(RecompModuleV1));
        error_out = msg;
        FreeLibrary(g_module); g_module = nullptr;
        return false;
    }
    if (m->entrypoint == nullptr || m->code_sections == nullptr || m->get_rsp_microcode == nullptr) {
        error_out = "module descriptor is missing an entrypoint, section table or RSP dispatch";
        FreeLibrary(g_module); g_module = nullptr;
        return false;
    }

    fprintf(stderr, "[launcher] module descriptor: id=%s name=\"%s\" rom_hash=0x%016llX "
                    "entry=0x%08X sections=%zu/%zu ucodes=%zu ni=%zu\n",
            m->game_id ? m->game_id : "(null)", m->internal_name ? m->internal_name : "(null)",
            (unsigned long long)m->rom_hash, m->entrypoint_address,
            m->num_code_sections, m->total_num_sections, m->num_ucodes, m->num_ni_sections);
    fflush(stderr);

    g_desc = m;
    g_game_id = to_u8(m->game_id);

    // ── 1. the game itself ────────────────────────────────────────────────────────────────────
    recomp::GameEntry entry{};
    entry.rom_hash               = m->rom_hash;
    entry.internal_name          = m->internal_name ? m->internal_name : "";
    entry.game_id                = g_game_id;
    entry.mod_game_id            = m->mod_game_id ? m->mod_game_id : "";
    entry.save_type              = save_type_from(m->save_type);
    entry.is_enabled             = true;
    entry.entrypoint_address     = m->entrypoint_address;
    entry.entrypoint             = (void (*)(uint8_t*, recomp_context*))m->entrypoint;
    entry.thread_create_callback = (void (*)(uint8_t*, recomp_context*))m->thread_create_callback;
    entry.on_init_callback       = (void (*)(uint8_t*, recomp_context*))m->on_init_callback;
    recomp::register_game(entry);

    // ── 2. the recompiled section tables ──────────────────────────────────────────────────────
    recomp::overlays::register_overlays(
        recomp::overlays::overlay_section_table_data_t{
            .code_sections      = (SectionTableEntry*)m->code_sections,
            .num_code_sections  = m->num_code_sections,
            .total_num_sections = m->total_num_sections,
        },
        recomp::overlays::overlays_by_index_t{
            .table = m->overlays_by_index,
            .len   = m->overlays_by_index_len,
        });

    // ── 3. the engine debt the module now carries instead of the host ─────────────────────────
    if (m->gamestate_change != nullptr) {
        recomp_register_gamestate_change((recomp_func_t*)m->gamestate_change);
    }
    if (m->ni_sections != nullptr && m->num_ni_sections != 0) {
        recomp_register_ni_section_data(m->ni_sections, m->num_ni_sections);
    }

    // ── 4. RSP: the content-hash ucode registry, then the dispatch callbacks ──────────────────
    for (size_t i = 0; i < m->num_ucodes; i++) {
        const RecompModuleUcodeEntry& u = m->ucodes[i];
        RspUcodeFunc* fn = (RspUcodeFunc*)u.fn;
        if (u.verify_len != 0) {
            recomp::rsp::register_ucode(u.hash, u.name, fn, u.verify_off, u.verify_len, u.verify_fnv);
        } else {
            recomp::rsp::register_ucode(u.hash, u.name, fn);
        }
        fprintf(stderr, "[launcher] module ucode registered: %s hash=0x%016llX\n",
                u.name ? u.name : "(unnamed)", (unsigned long long)u.hash);
    }
    recomp::rsp::callbacks_t rsp_cbs{};
    rsp_cbs.get_rsp_microcode = (recomp::rsp::callbacks_t::get_rsp_microcode_t*)m->get_rsp_microcode;
    rsp_cbs.capture_gfx       = (recomp::rsp::callbacks_t::capture_gfx_t*)m->capture_gfx;
    recomp::rsp::set_callbacks(rsp_cbs);

    // ── 5. the message-queue requeue policy this cart's kernel needs ──────────────────────────
    ultramodern::MessageQueueControl mqc{};
    mqc.requeue_timer = m->requeue_timer != 0;
    mqc.requeue_sp    = m->requeue_sp    != 0;
    mqc.requeue_si    = m->requeue_si    != 0;
    mqc.requeue_ai    = m->requeue_ai    != 0;
    mqc.requeue_vi    = m->requeue_vi    != 0;
    mqc.requeue_pi    = m->requeue_pi    != 0;
    mqc.requeue_dp    = m->requeue_dp    != 0;
    ultramodern::set_message_queue_control(mqc);

    // ── 6. the ROM ────────────────────────────────────────────────────────────────────────────
    recomp::check_all_stored_roms();
    if (!recomp::is_rom_valid(g_game_id)) {
        if (rom_path.empty() || !fs::exists(fs::path(rom_path))) {
            error_out = "no ROM for this game (looked for " + rom_path + ")";
            g_desc = nullptr;
            return false;
        }
        std::u8string id_copy = g_game_id;
        const recomp::RomValidationError err = recomp::select_rom(fs::path(rom_path), id_copy);
        if (err != recomp::RomValidationError::Good) {
            error_out = "ROM at " + rom_path + " did not validate for this module";
            g_desc = nullptr;
            return false;
        }
        recomp::check_all_stored_roms();
        if (!recomp::is_rom_valid(g_game_id)) {
            error_out = "ROM validation failed after install";
            g_desc = nullptr;
            return false;
        }
    }

    if (m->module_init != nullptr) m->module_init();

    fprintf(stderr, "[launcher] start_game(%s) -- the game thread takes this window now\n",
            m->game_id ? m->game_id : "");
    fflush(stderr);
    recomp::start_game(g_game_id);
    return true;
#endif
}

} // namespace launcher
