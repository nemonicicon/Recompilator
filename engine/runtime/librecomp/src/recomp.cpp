#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <memory>
#include <cmath>
#include <unordered_map>
#include <unordered_set>
#include <fstream>
#include <sstream>
#include <iostream>
#include <optional>
#include <mutex>
#include <thread>
#include <chrono>
#include <array>
#include <vector>
#include <cinttypes>
#include <cuchar>
#include <charconv>
#include <atomic>

#include "recomp.h"
#include "librecomp/overlays.hpp"
#include "librecomp/game.hpp"
#include "librecomp/cic.h"
#include "librecomp/pif.h"
#include "xxHash/xxh3.h"
#include "ultramodern/ultramodern.hpp"
#include "ultramodern/error_handling.hpp"
#include "librecomp/addresses.hpp"
#include "librecomp/mods.hpp"
#include "recompiler/live_recompiler.h"

// ── INSTRUMENTS ARE OFF UNLESS ASKED FOR ────────────────────────────────────────────────────────
// THE RULE: an environment gate is a game-specific hack by another name. That applies to
// BEHAVIOUR; the same law says ENV VARS ARE INSTRUMENTS. These are instruments, and they were not
// gated at all: a 20-second run of Turok 1 on 2026-09-08 wrote 20,225 lines from eight of them, to
// a file, unasked. That slows every shipped game, fills a user's disk, and breaks the project's own
// rule that an eyes verdict needs a clean run with all instruments off. Cached is pointless here -
// the call only happens when a rate limiter has already decided to print.
static bool rc_trace_on(const char* var) {
    const char* v = std::getenv(var);
    return v != nullptr && v[0] != '\0' && v[0] != '0';
}

#ifdef _WIN32
#    define WIN32_LEAN_AND_MEAN
#    include <Windows.h>
#else
#    include <sys/mman.h>
#endif

#if defined(_WIN32)
#define PATHFMT "%ls"
#else
#define PATHFMT "%s"
#endif

#ifdef _WIN32
// Windows 11 applies EcoQoS (PROCESS_POWER_THROTTLING_EXECUTION_SPEED) to a process once its
// windows stop being the foreground, parking it on the efficiency cores at a reduced clock. A
// recompiled N64 game is a REAL-TIME workload: the guest scheduler, the RSP tasks and VI pacing all
// keep running whether or not the window has focus, so that throttle shows up as the game visibly
// struggling the moment the user clicks away. Opt the process out for good, once, at startup.
// Deliberately NOT a priority-class change: raising priority would steal time from whatever else
// the user is running on this machine. This only declines a throttle; it takes nothing from anyone.
// kernel32 only, so no new link dependency.
static void recomp_disable_background_throttling() {
    PROCESS_POWER_THROTTLING_STATE state{};
    state.Version     = PROCESS_POWER_THROTTLING_CURRENT_VERSION;
    state.ControlMask = PROCESS_POWER_THROTTLING_EXECUTION_SPEED;
    state.StateMask   = 0;   // 0 = do NOT throttle execution speed
    SetProcessInformation(GetCurrentProcess(), ProcessPowerThrottling, &state, sizeof(state));
}

// ── Window geometry, remembered across runs and SHARED BY EVERY GAME ──────────────────────────
// Every game main creates its window with SDL_WINDOWPOS_CENTERED, which centres on whichever
// display Windows calls PRIMARY, and nothing moves it afterwards unless an external script does.
// On a multi-monitor desk that means every game opens on the wrong screen no matter how many times
// the user drags it. Persisting one geometry and restoring it for every game fixes that on ALL
// launch paths — harness, shortcut, or double-click — with no per-game code and no feature flag.
// The file is shared rather than per-game deliberately: position one game, and all of them follow.
static HWND g_recomp_main_window = nullptr;

static std::filesystem::path recomp_window_geometry_path() {
    const wchar_t* appdata = _wgetenv(L"APPDATA");   // standard OS variable, not a feature gate
    if (appdata == nullptr) {
        return {};
    }
    return std::filesystem::path(appdata) / L"N64PC" / L"window_geometry.txt";
}

static void recomp_restore_window_geometry(HWND hwnd) {
    if (hwnd == nullptr) {
        return;
    }
    const std::filesystem::path path = recomp_window_geometry_path();
    if (path.empty()) {
        return;
    }
    std::ifstream file(path);
    int x = 0, y = 0, w = 0, h = 0;
    if (!file || !(file >> x >> y >> w >> h)) {
        return;
    }
    if (w < 320 || h < 240) {
        return;   // ignore a nonsense or truncated record rather than shrink the window to nothing
    }
    // Only restore onto a monitor that still exists, so unplugging a screen can never strand the
    // window off-desktop where the user cannot reach it.
    RECT rect{ x, y, x + w, y + h };
    if (MonitorFromRect(&rect, MONITOR_DEFAULTTONULL) == nullptr) {
        return;
    }
    SetWindowPos(hwnd, nullptr, x, y, w, h, SWP_NOZORDER | SWP_NOACTIVATE);
}

static void recomp_save_window_geometry() {
    HWND hwnd = g_recomp_main_window;
    if (hwnd == nullptr || !IsWindow(hwnd) || IsIconic(hwnd)) {
        return;   // never persist a minimized or destroyed window's rect
    }
    RECT rect{};
    if (!GetWindowRect(hwnd, &rect)) {
        return;
    }
    const std::filesystem::path path = recomp_window_geometry_path();
    if (path.empty()) {
        return;
    }
    std::error_code ec;
    std::filesystem::create_directories(path.parent_path(), ec);
    std::ofstream file(path, std::ios::trunc);
    if (!file) {
        return;
    }
    file << rect.left << ' ' << rect.top << ' '
         << (rect.right - rect.left) << ' ' << (rect.bottom - rect.top) << '\n';
}
#endif

enum GameStatus {
    None,
    Running,
    Quit
};

// Mutexes
std::mutex game_roms_mutex;
std::mutex current_game_mutex;
std::mutex mod_context_mutex{};

// Global variables
std::filesystem::path config_path;
// Maps game_id to the game's entry.
std::unordered_map<std::u8string, recomp::GameEntry> game_roms {};
// The global mod context.
std::unique_ptr<recomp::mods::ModContext> mod_context = std::make_unique<recomp::mods::ModContext>();
// The project's version.
recomp::Version project_version;
// The current game's save type.
recomp::SaveType save_type = recomp::SaveType::None;

std::u8string recomp::GameEntry::stored_filename() const {
    return game_id + u8".z64";
}

void recomp::register_config_path(std::filesystem::path path) {
    config_path = path;
}

bool recomp::register_game(const recomp::GameEntry& entry) {
    // TODO verify that there's no game with this ID already.
    {
        std::lock_guard<std::mutex> lock(game_roms_mutex);
        game_roms.insert({ entry.game_id, entry });
    }
    if (!entry.mod_game_id.empty()) {
        std::lock_guard<std::mutex> lock(mod_context_mutex);
        mod_context->register_game(entry.mod_game_id);
    }

    return true;
}

void recomp::mods::initialize_mods() {
    N64Recomp::live_recompiler_init();
    std::filesystem::create_directories(config_path / mods_directory);
    std::filesystem::create_directories(config_path / mod_config_directory);
    mod_context->set_mods_config_path(config_path / "mods.json");
    mod_context->set_mod_config_directory(config_path / mod_config_directory);
}

void recomp::mods::register_embedded_mod(const std::string &mod_id, std::span<const uint8_t> mod_bytes) {
    std::lock_guard<std::mutex> lock(mod_context_mutex);
    mod_context->register_embedded_mod(mod_id, mod_bytes);
}

void recomp::mods::scan_mods() {
    std::vector<recomp::mods::ModOpenErrorDetails> mod_open_errors;
    {
        std::lock_guard mod_lock{ mod_context_mutex };
        mod_open_errors = mod_context->scan_mod_folder(config_path / mods_directory);
    }
    for (const auto& cur_error : mod_open_errors) {
        printf("Error opening mod " PATHFMT ": %s (%s)\n", cur_error.mod_path.c_str(), recomp::mods::error_to_string(cur_error.error).c_str(), cur_error.error_param.c_str());
    }

    mod_context->load_mods_config();
}

void recomp::mods::close_mods() {
    {
        std::lock_guard mod_lock{ mod_context_mutex };
        mod_context->close_mods();
    }
}

std::filesystem::path recomp::mods::get_mods_directory() {
    return config_path / mods_directory;
}

recomp::mods::ModContentTypeId recomp::mods::register_mod_content_type(const ModContentType& type) {
    std::lock_guard mod_lock{ mod_context_mutex };
    return mod_context->register_content_type(type);
}

bool recomp::mods::register_mod_container_type(const std::string& extension, const std::vector<ModContentTypeId>& content_types, bool requires_manifest) {
    std::lock_guard mod_lock{ mod_context_mutex };
    return mod_context->register_container_type(extension, content_types, requires_manifest);
}

std::string recomp::mods::get_mod_display_name(size_t mod_index) {
    std::lock_guard mod_lock{ mod_context_mutex };
    return mod_context->get_mod_display_name(mod_index);
}

std::filesystem::path recomp::mods::get_mod_path(size_t mod_index) {
    std::lock_guard mod_lock{ mod_context_mutex };
    return mod_context->get_mod_path(mod_index);
}

std::pair<std::string, std::string> recomp::mods::get_mod_import_info(size_t mod_index, size_t import_index) {
    std::lock_guard mod_lock{ mod_context_mutex };
    return mod_context->get_mod_import_info(mod_index, import_index);
}

recomp::mods::DependencyStatus recomp::mods::is_dependency_met(size_t mod_index, const std::string& dependency_id) {
    std::lock_guard mod_lock{ mod_context_mutex };
    return mod_context->is_dependency_met(mod_index, dependency_id);
}

bool check_hash(const std::vector<uint8_t>& rom_data, uint64_t expected_hash) {
    uint64_t calculated_hash = XXH3_64bits(rom_data.data(), rom_data.size());
    return calculated_hash == expected_hash;
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

bool write_file(const std::filesystem::path& path, const std::vector<uint8_t>& data) {
    std::ofstream out_file{ path, std::ios::binary };

    if (!out_file.good()) {
        return false;
    }

    out_file.write(reinterpret_cast<const char*>(data.data()), data.size());

    return true;
}

bool check_stored_rom(const recomp::GameEntry& game_entry) {
    std::vector stored_rom_data = read_file(config_path / game_entry.stored_filename());

    if (!check_hash(stored_rom_data, game_entry.rom_hash)) {
        // Incorrect hash, remove the stored ROM file if it exists.
        std::filesystem::remove(config_path / game_entry.stored_filename());
        return false;
    }

    return true;
}

static std::unordered_set<std::u8string> valid_game_roms;

bool recomp::is_rom_valid(std::u8string& game_id) {
    return valid_game_roms.contains(game_id);
}

void recomp::check_all_stored_roms() {
    for (const auto& cur_rom_entry: game_roms) {
        if (check_stored_rom(cur_rom_entry.second)) {
            valid_game_roms.insert(cur_rom_entry.first);
        }
    }
}

bool recomp::load_stored_rom(std::u8string& game_id) {
    auto find_it = game_roms.find(game_id);

    if (find_it == game_roms.end()) {
        return false;
    }
    
    std::vector<uint8_t> stored_rom_data = read_file(config_path / find_it->second.stored_filename());

    if (!check_hash(stored_rom_data, find_it->second.rom_hash)) {
        // The ROM no longer has the right hash, delete it.
        std::filesystem::remove(config_path / find_it->second.stored_filename());
        return false;
    }

    recomp::set_rom_contents(std::move(stored_rom_data));
    return true;
}

const recomp::Version& recomp::get_project_version() {
    return project_version;
}

bool recomp::Version::from_string(const std::string& str, Version& out) {
    std::array<size_t, 2> period_indices;
    size_t cur_pos = 0;
    uint16_t major;
    uint16_t minor;
    uint16_t patch;
    std::string suffix;

    // Find the 2 required periods.
    cur_pos = str.find('.', cur_pos);
    period_indices[0] = cur_pos;
    cur_pos = str.find('.', cur_pos + 1);
    period_indices[1] = cur_pos;

    // Check that both were found.
    if (period_indices[0] == std::string::npos || period_indices[1] == std::string::npos) {
        return false;
    }

    // Parse the 3 numbers formed by splitting the string via the periods.
    std::array<std::from_chars_result, 3> parse_results; 
    std::array<size_t, 3> parse_starts { 0, period_indices[0] + 1, period_indices[1] + 1 };
    std::array<size_t, 3> parse_ends { period_indices[0], period_indices[1], str.size() };
    parse_results[0] = std::from_chars(str.data() + parse_starts[0], str.data() + parse_ends[0], major);
    parse_results[1] = std::from_chars(str.data() + parse_starts[1], str.data() + parse_ends[1], minor);
    parse_results[2] = std::from_chars(str.data() + parse_starts[2], str.data() + parse_ends[2], patch);

    // Check that the first two parsed correctly.
    auto did_parse = [&](size_t i) {
        return parse_results[i].ec == std::errc{} && parse_results[i].ptr == str.data() + parse_ends[i];
    };
    
    if (!did_parse(0) || !did_parse(1)) {
        return false;
    }

    // Check that the third had a successful parse, but not necessarily read all the characters.
    if (parse_results[2].ec != std::errc{}) {
        return false;
    }

    // Allow a plus or minus directly after the third number.
    if (parse_results[2].ptr != str.data() + parse_ends[2]) {
        if (*parse_results[2].ptr == '+' || *parse_results[2].ptr == '-') {
            suffix = str.substr(std::distance(str.data(), parse_results[2].ptr));
        }
        // Failed to parse, as nothing is allowed directly after the last number besides a plus or minus.
        else {
            return false;
        }
    }

    out.major = major;
    out.minor = minor;
    out.patch = patch;
    out.suffix = std::move(suffix);
    return true;
}

const std::array<uint8_t, 4> first_rom_bytes { 0x80, 0x37, 0x12, 0x40 };

enum class ByteswapType {
    NotByteswapped,
    Byteswapped4,
    Byteswapped2,
    Invalid
};

ByteswapType check_rom_start(const std::vector<uint8_t>& rom_data) {
    if (rom_data.size() < 4) {
        return ByteswapType::Invalid;
    }

    auto check_match = [&](uint8_t index0, uint8_t index1, uint8_t index2, uint8_t index3) {
        return
            rom_data[0] == first_rom_bytes[index0] &&
            rom_data[1] == first_rom_bytes[index1] &&
            rom_data[2] == first_rom_bytes[index2] &&
            rom_data[3] == first_rom_bytes[index3];
    };

    // Check if the ROM is already in the correct byte order.
    if (check_match(0,1,2,3)) {
        return ByteswapType::NotByteswapped;
    }

    // Check if the ROM has been byteswapped in groups of 4 bytes.
    if (check_match(3,2,1,0)) {
        return ByteswapType::Byteswapped4;
    }

    // Check if the ROM has been byteswapped in groups of 2 bytes.
    if (check_match(1,0,3,2)) {
        return ByteswapType::Byteswapped2;
    }

    // No match found.
    return ByteswapType::Invalid;
}

void byteswap_data(std::vector<uint8_t>& rom_data, size_t index_xor) {
    for (size_t rom_pos = 0; rom_pos < rom_data.size(); rom_pos += 4) {
        uint8_t temp0 = rom_data[rom_pos + 0];
        uint8_t temp1 = rom_data[rom_pos + 1];
        uint8_t temp2 = rom_data[rom_pos + 2];
        uint8_t temp3 = rom_data[rom_pos + 3];

        rom_data[rom_pos + (0 ^ index_xor)] = temp0;
        rom_data[rom_pos + (1 ^ index_xor)] = temp1;
        rom_data[rom_pos + (2 ^ index_xor)] = temp2;
        rom_data[rom_pos + (3 ^ index_xor)] = temp3;
    }
}

recomp::RomValidationError recomp::select_rom(const std::filesystem::path& rom_path, std::u8string& game_id) {
    auto find_it = game_roms.find(game_id);

    if (find_it == game_roms.end()) {
        return recomp::RomValidationError::OtherError;
    }

    const recomp::GameEntry& game_entry = find_it->second;

    std::vector<uint8_t> rom_data = read_file(rom_path);

    if (rom_data.empty()) {
        return recomp::RomValidationError::FailedToOpen;
    }

    // Pad the rom to the nearest multiple of 4 bytes.
    rom_data.resize((rom_data.size() + 3) & ~3);

    ByteswapType byteswap_type = check_rom_start(rom_data);

    switch (byteswap_type) {
        case ByteswapType::Invalid:
            return recomp::RomValidationError::NotARom;
        case ByteswapType::Byteswapped2:
            byteswap_data(rom_data, 1);
            break;
        case ByteswapType::Byteswapped4:
            byteswap_data(rom_data, 3);
            break;
        case ByteswapType::NotByteswapped:
            break;
    }

    if (!check_hash(rom_data, game_entry.rom_hash)) {
        const std::string_view name{ reinterpret_cast<const char*>(rom_data.data()) + 0x20, game_entry.internal_name.size()};
        if (name == game_entry.internal_name) {
            return recomp::RomValidationError::IncorrectVersion;
        }
        else {
            if (game_entry.is_enabled && std::string_view{ reinterpret_cast<const char*>(rom_data.data()) + 0x20, 19 } == game_entry.internal_name) {
                return recomp::RomValidationError::NotYet;
            }
            else {
                return recomp::RomValidationError::IncorrectRom;
            }
        }
    }

    write_file(config_path / game_entry.stored_filename(), rom_data);
    
    return recomp::RomValidationError::Good;
}

extern "C" void osGetMemSize_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = 8 * 1024 * 1024;
}

enum class StatusReg {
    FR = 0x04000000,
};

// Bare-metal enable-edge delivery venue (baremetal_sched.cpp): self-gated; called on SR writes
// that clear EXL (below) and on MI mask writes that expose a pending line (mmio.cpp).
extern "C" void recomp_baremetal_mask_poll(void);

// ── Per-fiber register files (the bare-metal per-thread-context redesign, 2026-08-05) ──────────
// baremetal_sched.cpp treats recomp_context as opaque; these helpers own the type details.
// Generated code is pure write-through (every op reads/writes ctx->rN), so a full-struct copy at
// a switch is observably identical to hardware's dispatcher moving a thread's state through the
// ONE physical register file. f_odd is a SELF-REFERENTIAL pointer (&ctx->f1.u32l / &ctx->f0.u32h)
// — a raw memcpy would alias the SOURCE context's float fields — so it is re-derived from the
// copied FR mode, mirroring cop0_status_write's FR handling.
extern "C" recomp_context* bm_ctx_alloc(void) {
    return (recomp_context*)calloc(1, sizeof(recomp_context));
}
extern "C" void bm_ctx_copy(recomp_context* dst, const recomp_context* src) {
    if (dst == nullptr || src == nullptr || dst == src) return;
    memcpy(dst, src, sizeof(recomp_context));
    dst->f_odd = dst->mips3_float_mode ? &dst->f1.u32l : &dst->f0.u32h;
}

extern "C" void recomp_interp_ring_dump(const char* reason);   // [pc-ring] path dump (recomp_interp.cpp)

extern "C" void cop0_status_write(recomp_context* ctx, gpr value) {
    uint32_t old_sr = ctx->status_reg;
    uint32_t new_sr = (uint32_t)value;
    uint32_t changed = old_sr ^ new_sr;

    // [sr-poison] (SOTE residual-tear hunt): a KSEG-pointer-shaped Status value is never a real
    // SR — it means a register carrying a saved-SR got torn/overwritten upstream (the kernel's
    // int-disable/restore APIs carry SR through registers across critical sections, and the
    // dispatcher restores from TCB+280). Name the moment: value + the caller-ish state (ra/k0/sp
    // identify which guest path and which TCB). Diagnostic only — the write still proceeds.
    if ((new_sr & 0xF0000000u) == 0x80000000u) {
        static int _sp = 0;
        if (_sp++ < 12) {
            const uint64_t* r = (const uint64_t*)ctx;
            fprintf(stderr, "[sr-poison] SR <= 0x%08X (ptr-shaped!) old=0x%08X ra=0x%08X k0=0x%08X k1=0x%08X sp=0x%08X a0=0x%08X\n",
                    new_sr, old_sr, (uint32_t)r[31], (uint32_t)r[26], (uint32_t)r[27], (uint32_t)r[29], (uint32_t)r[4]);
            fflush(stderr);
        }
    }

    // Check if the FR bit changed
    if (changed & (uint32_t)StatusReg::FR) {
        // Check if the FR bit was set
        if (new_sr & (uint32_t)StatusReg::FR) {
            // FR = 1, odd single floats point to their own registers
            ctx->f_odd = &ctx->f1.u32l;
            ctx->mips3_float_mode = true;
        }
        // Otherwise, it was cleared
        else {
            // FR = 0, odd single floats point to the upper half of the previous register
            ctx->f_odd = &ctx->f0.u32h;
            ctx->mips3_float_mode = false;
        }

        // Remove the FR bit from the changed bits as it's been handled
        changed &= ~(uint32_t)StatusReg::FR;
    }

    // FR (handled above) is the only Status bit with codegen-visible semantics. The rest —
    // IE/EXL/ERL/KSU/UX/SX/KX, the IM interrupt mask, CU0-3 coprocessor-enable — drive the real
    // VR4300 exception/interrupt/privilege machinery, which HLE does not run. HLE-libultra games
    // never reach here (their mtc0 $12 lives inside HLE'd __osDisableInt/osSetIntMask natives);
    // raw-hardware ports (PSX/arcade ports that manage the COP0 directly) DO write Status straight,
    // so we must STORE those bits faithfully and carry on rather than abort. Log unmodeled bits once
    // for visibility. (General engine hardening — companion to the COP0 register-file generalization.)
    if (changed) {
        static bool logged = false;
        if (!logged) {
            printf("[cop0] Status: storing unmodeled bits 0x%08X (HLE-inert: interrupt/exception/mode)\n", changed);
            logged = true;
        }
    }

    // [sr-trace 2026-08-06, defect-B dig] first writes + every IE-falling/zero write: who
    // installs the SR images the drain gate lives by. ra identifies the guest writer.
    if (changed) {
        static std::atomic<long> _st{0}; long n = ++_st;
        bool ie_fell = (changed & 0x1u) && !(new_sr & 0x1u);
        if (n <= 40 || new_sr == 0u || (ie_fell && n <= 400)) {
            const uint64_t* r = (const uint64_t*)ctx;
            if (rc_trace_on("RECOMP_SR_TRACE")) fprintf(stderr, "[sr-trace] #%ld 0x%08X -> 0x%08X ctx=%p ra=0x%08X%s\n",
                    n, old_sr, new_sr, (void*)ctx, (uint32_t)r[31],
                    new_sr == 0u ? "  <-- ZERO" : (ie_fell ? "  (IE falls)" : ""));
            fflush(stderr);
        }
    }

    // Update the status register in the context
    ctx->status_reg = new_sr;

    // EXL-falling-edge delivery (fifa 2026-08-05): EA-class kernels bracket their idle with EXL
    // itself (measured steady state SR=0xFF02 — IM=all, IE=0, EXL=1; 11M drain-gate refusals in
    // one 40s boot). On hardware, pending interrupts are taken the INSTANT an mtc0 drops EXL —
    // the guest's open-bracket write is the delivery moment, and every other venue samples only
    // inside the closed bracket. The bare-metal venue self-gates (enabled/autobm/tl guards +
    // pending∩mask), so this is a no-op for HLE titles and during handler-context SR restores
    // (tl_eret_drain held). Store-first order matters: the venue's drain gate re-reads SR.
    // IE-RISING edge added 2026-08-06: stock-libultra kernels bracket with SR.IE instead
    // (__osDisableInt/__osRestoreInt) — hardware takes pending interrupts the instant the
    // restore's mtc0 sets IE, the companion moment to the drain gate's full take-condition
    // (turok, [venue-census]: IE=0 delivery tore osStartThread's critical section).
    {
        bool exl_fell = (changed & 0x2u) != 0u && (new_sr & 0x2u) == 0u;
        bool ie_rose  = (changed & 0x1u) != 0u && (new_sr & 0x1u) != 0u;
        if (exl_fell || ie_rose) {
            recomp_baremetal_mask_poll();
        }
    }
}

extern "C" gpr cop0_status_read(recomp_context* ctx) {
    return (gpr)(int32_t)ctx->status_reg;
}

// Count (cop0 reg 9): the VR4300 cycle counter, read inline for timing/RNG. Sourced from the
// same clock osGetCount uses; write is a no-op (host clock origin can't reset — monotonic read
// gives plausible elapsed-time deltas; faithful-enough, game-agnostic).
extern "C" uint32_t osGetCount();
extern "C" gpr cop0_count_read(recomp_context* ctx) {
    (void)ctx;
    return (gpr)(int32_t)osGetCount();
}
extern "C" void cop0_count_write(recomp_context* ctx, gpr value) {
    (void)ctx;
    (void)value;
}

// VR4300 `syscall` instruction handler. N64Recomp emits a call to this for every `syscall` it
// recompiles (cgenerator.cpp), but nothing defined it -> any syscall-using game failed to link
// (e.g. Dr. Mario 64). libultra uses syscall only on rare __osException paths; a no-op is safe so
// the game links and runs. (Elaborate to dispatch real exceptions if a game ever needs it.)
extern "C" void recomp_syscall_handler(uint8_t* rdram, recomp_context* ctx, int32_t instruction_vram) {
    (void)rdram;
    (void)ctx;
    (void)instruction_vram;
}

extern "C" uint8_t* g_rdram_base;   // defined below; needed by the jump-table dump

extern "C" void switch_error(const char* func, uint32_t vram, uint32_t jtbl) {
    printf("Switch-case out of bounds in %s at 0x%08X for jump table at 0x%08X\n", func, vram, jtbl);
    // ── [jtbl] (SOTE 2026-08-26) — instrument only; this function still exits exactly as before.
    // WHY: the message names the SITE but never the INDEX or the table, so "the recompiler
    // enumerated too few cases" and "the guest computed a wild index" are indistinguishable from
    // the log alone — and this path kills the process, so there is no second chance to look.
    // Dump the live table so the true entry count is readable: a word that is a plausible guest
    // code address (0x8xxxxxxx, 4-byte aligned) is a REAL target the emitted switch must cover.
    // Motivating case: SOTE's exception handler dispatches the Cause IP bits through a byte table
    // -> selector -> word table; the recompiler emitted 9 cases and the guest reached a 10th.
    if (g_rdram_base != nullptr) {
        const uint32_t tphys = jtbl & 0x00FFFFFFu;
        fprintf(stderr, "[jtbl] word table @0x%08X (a plausible 0x8xxxxxxx aligned word = a real target):\n", jtbl);
        uint32_t plausible = 0;
        for (uint32_t i = 0; i < 32u; i++) {
            const uint32_t off = tphys + i * 4u;
            if (off + 4u > 0x00800000u) break;
            const uint32_t w = *(const uint32_t*)(g_rdram_base + off);
            const bool ok = ((w >> 28) == 0x8u) && ((w & 3u) == 0u);
            if (ok) plausible = i + 1u;
            fprintf(stderr, "%s[%2u]=%08X%s", (i % 6) ? "  " : "\n  ", i, w, ok ? "*" : " ");
        }
        fprintf(stderr, "\n[jtbl] highest plausible target index = %u  => the switch needs %u cases\n",
                plausible ? plausible - 1u : 0u, plausible);
        // The selector byte table sits just below the word table in this dispatch shape; dump the
        // window so the SELECTORS the guest can actually produce are visible next to the targets.
        const uint32_t bphys = (jtbl - 0x20u) & 0x00FFFFFFu;
        fprintf(stderr, "[jtbl] byte table @0x%08X (selectors; /4 = the case index):", jtbl - 0x20u);
        for (uint32_t i = 0; i < 32u; i++) {
            const uint32_t off = bphys + i;
            if (off >= 0x00800000u) break;
            fprintf(stderr, "%s%02X", (i % 16) ? " " : "\n  ", g_rdram_base[off ^ 3u]);
        }
        fprintf(stderr, "\n");
        // THE EXCEPTION VECTOR, at fault time. If the guest advanced to a new phase it will have
        // installed a NEW handler here — while auto-baremetal latched g_handler ONCE at boot
        // ("AUTOBM ARMED handler=0x... vector preamble-decoded") and keeps invoking the stale one,
        // which then reads dispatch tables the new phase has repurposed. Dumping the vector makes a
        // changed handler visible instead of inferred. (SOTE is a fully packed ROM whose runtime
        // code image is rebuilt as it unpacks — see shadows/overlay_manifest.txt.)
        fprintf(stderr, "[jtbl] exception vector @0x80000180:");
        for (uint32_t i = 0; i < 8u; i++) {
            fprintf(stderr, " %08X", *(const uint32_t*)(g_rdram_base + 0x180u + i * 4u));
        }
        fprintf(stderr, "\n[jtbl] words at the latched handler 0x800C37C0:");
        for (uint32_t i = 0; i < 8u; i++) {
            fprintf(stderr, " %08X", *(const uint32_t*)(g_rdram_base + 0x000C37C0u + i * 4u));
        }
        fprintf(stderr, "\n");
        fflush(stderr);
    }
    // ── [faultsnap] (2026-08-26) — env RECOMP_FAULT_SNAPSHOT=1, off by default ──────────────────
    // This path is FATAL, so the machine state that produced it is about to be lost. For a PACKED
    // title whose runtime code image is built by its own unpacker (SOTE's "B1" class), the fault is
    // the only GUARANTEED post-unpack moment: a timer-armed RECOMP_RAM_SNAPSHOT races the fault and
    // loses (measured 04:38 — armed at 240s, process exited at 189s, no file written). Dump RDRAM in
    // ROM byte order so `COMPRESSED_TITLE_PIPELINE.md` can consume it directly as a second-set
    // source. Written before the exit below; unset env = zero cost.
    if (const char* fs = std::getenv("RECOMP_FAULT_SNAPSHOT")) {
        if ((fs[0] == '1') && (g_rdram_base != nullptr)) {
            std::filesystem::path base_path = ultramodern::get_save_file_path();
            if (!base_path.empty()) {
                std::filesystem::path out = base_path.parent_path() / "ram_snapshot_fault.bin";
                if (FILE* f = fopen(out.string().c_str(), "wb")) {
                    const uint32_t phys_base = 0x400u;      // vaddr 0x80000400
                    const uint32_t bytes     = 0x3FFC00u;   // same span as the July build input
                    for (uint32_t i = 0; i < bytes; i += 4) {
                        const uint32_t w = *reinterpret_cast<uint32_t*>(g_rdram_base + phys_base + i);
                        const uint32_t be = ((w & 0x000000FFu) << 24) | ((w & 0x0000FF00u) << 8)
                                          | ((w & 0x00FF0000u) >> 8)  | ((w & 0xFF000000u) >> 24);
                        fwrite(&be, 4, 1, f);
                    }
                    fclose(f);
                    fprintf(stderr, "[faultsnap] wrote %s (0x%X bytes @ vaddr 0x80000400)\n",
                            out.string().c_str(), bytes);
                    fflush(stderr);
                }
            }
        }
    }
    assert(false);
    exit(EXIT_FAILURE);
}

extern "C" void do_break(uint32_t vram) {
    // A MIPS `break` in recompiled code. For bare-metal/PSX-port boots the common case is the
    // "main must never return" guard right after the entrypoint's jal to the boot proc: on real
    // hardware, osStartThread of the higher-priority game thread context-switches away and the boot
    // stack is abandoned, so the break is never reached; under ultramodern's cooperative scheduler
    // the boot thread returns to the stub and hits it. Terminating THIS thread (the boot/entry
    // thread is caught by the entrypoint's try/catch in start_game; a game thread by _thread_func's)
    // is the faithful outcome — the spawned game threads keep running. thread_terminated already
    // unwinds through recompiled frames (osStopThread/osDestroyThread throw it), so this is
    // consistent; working HLE games never reach a break. (General bare-metal-port fix.)
    // Can't throw thread_terminated here: do_break is extern "C" and the runtime is built /EHsc
    // (extern "C" => assumed nothrow), so an escaping exception hits std::terminate. Instead PARK
    // this thread forever — the boot/entry thread has handed off to the spawned game threads (real
    // std::threads that run independently) and must not execute game code again. It runs on the
    // dedicated recomp run-thread (not the SDL/UI thread), so parking it is inert. (General
    // bare-metal-port fix; working HLE games never reach a break.)
    printf("Encountered break at original vram 0x%08X — parking this thread (game threads continue)\n", vram);
    fflush(stdout);
    for (;;) std::this_thread::sleep_for(std::chrono::hours(24));
}

std::optional<std::u8string> current_game = std::nullopt;
std::atomic<GameStatus> game_status = GameStatus::None;

void run_thread_function(uint8_t* rdram, uint64_t addr, uint64_t sp, uint64_t arg, uint32_t thread_ptr) {
    auto find_it = game_roms.find(current_game.value());
    const recomp::GameEntry& game_entry = find_it->second;

    recomp_context ctx{};
    ctx.r29 = sp;
    ctx.r4 = arg;
    ctx.mips3_float_mode = 0;
    ctx.f_odd = &ctx.f0.u32h;

    // [thread-gp 2026-09-06, Starshot #113] Restore $gp from the thread's SAVED CONTEXT, the way
    // __osDispatchThread does on hardware. libultra's osCreateThread writes pc/a0/sp/ra/sr/rcp/fpcsr
    // into OSThread.context and deliberately leaves `gp` alone (verified against the SDK source,
    // engine/references/libreultra/lib/src/osCreateThread.c), so a game compiled with IDO small-data
    // (-G) hands each thread its own $gp by storing it into OSThread.context.gp right before
    // osStartThread. Offset: OSThread.context is at +0x20 and __OSThreadContext.gp is at +0xC8
    // (PR/os_thread.h), so context.gp is the u64 at thread+0xE8. Our HLE model spawns a host thread
    // with a ZEROED recomp_context and restores none of the saved context, so every created thread
    // ran with $gp = 0 and every gp-relative access landed in low RDRAM instead of the small-data
    // window. Starshot: boot sets $gp = 0x800B8500, main() stores it into the idle thread's context
    // and the idle thread stores it into the game thread's, and the run carries ~1,600 gp-relative
    // ops whose targets showed up as [tlb_lowva] 0x750 / 0xFC0 / 0xFD4 / 0xFF8 = gp+imm with gp = 0.
    // GENERAL + baseline-safe: the field is untouched by libultra, so it reads 0 on every game that
    // does not set it and the seed is then a no-op (explicitly gated on non-zero below).
    if ((thread_ptr & 0xC0000000u) == 0x80000000u && ((thread_ptr & 0x1FFFFFFFu) + 0xF0u) < 0x00800000u) {
        uint32_t gp_hi = (uint32_t)MEM_W(0xE8, thread_ptr);
        uint32_t gp_lo = (uint32_t)MEM_W(0xEC, thread_ptr);
        uint64_t saved_gp = ((uint64_t)gp_hi << 32) | (uint64_t)gp_lo;
        if (saved_gp != 0) {
            ctx.r28 = (int64_t)saved_gp;
            static uint32_t _tgp = 0;
            if (++_tgp <= 16) {
                fprintf(stderr, "[thread-gp] thr=0x%08X entry=0x%08X gp=0x%016llX (from context.gp)\n",
                        thread_ptr, (uint32_t)addr, (unsigned long long)saved_gp);
                fflush(stderr);
            }
        }
    }

    // Seed the CP0 Status interrupt-mask field to the libultra power-on / osCreateThread default. Real HW:
    // osCreateThread stores SR (IE + the IM field) into the OSThread's saved context, and __osDispatchThread
    // restores it into CP0 Status on every dispatch. Our native-thread HLE model has no saved-SR field and
    // no __osDispatchThread, so a freshly-created thread's status_reg was left 0 -> any game that READS its
    // own thread's Status for control flow saw 0. Blast Corps' render thread gates its whole render path on
    // (Status & OS_IM_PRENMI == 0x1000); with status_reg=0 it took the osViBlack(1)+pause_self park forever
    // (black screen). 0xFF01 = IE(0x1) + full IM field (0xFF00, incl 0x1000). The FR bit (0x04000000) is left
    // clear so float mode is untouched (set independently above). GENERAL + baseline-safe: the IM field is
    // HLE-inert (it drives the VR4300 interrupt machinery the HLE never runs), so it changes behavior ONLY
    // for games that branch on their own thread's Status bits — and for those the seed is the correct HW
    // value. Seeded BEFORE the thread_create_callback so a game-specific callback can still override.
    ctx.status_reg = 0xFF01u;

    if (game_entry.thread_create_callback != nullptr) {
        game_entry.thread_create_callback(rdram, &ctx);
    }

    recomp_func_t* func = get_function(addr);
    func(rdram, &ctx);
}

// ── Static data-section loading (general, for decomp-driven recomps) ────────────────────────────────
// A recompiled game's CODE is C functions, but its STATIC DATA (.data/.rodata) must be in RDRAM before the
// game reads it. For a normal cart that data lives uncompressed in the ROM and the game's boot DMAs it in;
// for a COMPRESSED decomp game (Perfect Dark: .data is .datazip, inflated by boot() — which the static
// recomp can't run faithfully), nothing populates it and the game reads garbage pointers. This lets an app
// register its decompressed data sections (emitted from the decomp ELF as a C array); init() copies them
// into RDRAM with the MIPS-big-endian byte swizzle (XOR 3) before the game runs. Non-decomp games register
// nothing → zero overhead. Generalizes the cv64 ni_section_data mechanism to any decomp-driven recomp.
namespace {
    struct StaticDataSection { uint32_t vram; const uint8_t* data; uint32_t size; };
    StaticDataSection g_static_data[16];
    int g_static_data_count = 0;
}
extern "C" void recomp_register_static_data(uint32_t vram, const uint8_t* data, uint32_t size) {
    if (g_static_data_count < 16 && data != nullptr && size != 0) {
        g_static_data[g_static_data_count++] = StaticDataSection{ vram, data, size };
    }
}

void init(uint8_t* rdram, recomp_context* ctx, gpr entrypoint) {
    // Initialize the overlays
    recomp::overlays::init_overlays();

    // Load overlays in the first 1MB
    load_overlays(0x1000, (int32_t)entrypoint, 1024 * 1024);

    // Initial 1MB DMA (rom address 0x1000 = physical address 0x10001000)
    recomp::do_rom_read(rdram, (gpr)(int32_t)entrypoint, 0x10001000, 0x100000);

    // Read in any extra data from patches
    recomp::overlays::read_patch_data(rdram, (gpr)recomp::patch_rdram_start);

    // Set up context floats
    ctx->f_odd = &ctx->f0.u32h;
    ctx->mips3_float_mode = false;

    // Initialize variables normally set by IPL3
    constexpr int32_t osTvType = 0x80000300;
    //constexpr int32_t osRomType = 0x80000304;
    constexpr int32_t osRomBase = 0x80000308;
    constexpr int32_t osResetType = 0x8000030c;
    //constexpr int32_t osCicId = 0x80000310; // now written by recomp::pif::cic_boot (model-driven)
    //constexpr int32_t osVersion = 0x80000314;
    constexpr int32_t osMemSize = 0x80000318;
    //constexpr int32_t osAppNMIBuffer = 0x8000031c;
    MEM_W(osTvType, 0) = 1; // NTSC
    MEM_W(osRomBase, 0) = 0xB0000000u; // standard rom base
    MEM_W(osResetType, 0) = 0; // cold reset
    MEM_W(osMemSize, 0) = 8 * 1024 * 1024; // 8MB

    // ── PIF↔CIC power-on boot (LLE) — drive the CIC chip model and lay down its boot state ───────────
    // The PIF model (recomp::pif::cic_boot) identifies the cart's CIC from its IPL3 bootcode CRC, runs
    // the CIC chip model's power-on exchange (recomp::cic), and writes the CIC/IPL3-derived state the
    // game reads:
    //   • osBootInfo.cicId (0x80000310) = the CIC's model number (6105 -> 0x17D9). The 6105-club
    //     anti-piracy reads it and SUBTLY DEGRADES when it differs (DK64: `if (D_80000310 != 0x17D9)`
    //     -> osSetTime(garbage)/zeroed durations).
    //   • the 6105 IPL3 RSP boot-handshake word at RDRAM 0x002FE1C0 (DK64 dk64_boot_1050.c spins on it:
    //     `while (0xAD170014 != *(u32*)0xA02FE1C0)`), gated on the model's detected 6105 type.
    // We boot from the game ENTRY past the real IPL3, so without this every 6105 cart hangs/degrades at
    // boot. Every value is sourced from the CIC chip model, not hardcoded per game; 6105-only effects
    // are gated on the detected CIC type, so non-6105 / baseline HLE carts are untouched.
    {
        std::span<const uint8_t> rom = recomp::get_rom();
        recomp::pif::cic_boot(rdram, rom.data(), rom.size());
    }

    // ── Boot-state seed table — GENERAL anti-piracy / preamble-state reproduction ────────────────────
    // A static recomp enters past the cart's real IPL3 / CIC / preamble, so any RDRAM the boot sequence
    // would have seeded reads 0. A whole CLASS of late-era N64 titles then runs an anti-tamper guard of
    // the shape `if (read(addr) != magic) while (1);` and hangs forever (Perfect Dark's boot() is the
    // first one we hit; this pattern is expected across many carts). Rather than a per-game `if` in engine
    // code, this is a DATA table keyed by ROM header game-code (@ROM 0x3B, 4 bytes "NPDE" etc.): seed the
    // exact word the preamble would leave. Adding a newly-identified title is ONE ROW here, not new code.
    // (The CIC-6105 handshake above stays separate: it is SIGNATURE-gated and applies to the whole 6105
    // family, not a single game-code.) Each row should be retired when the game's decomp is rebuilt with
    // the check compiled out (e.g. PD PIRACYCHECKS=0); until then this keeps the bridge general + tidy.
    struct BootSeed { char game_code[5]; int32_t addr; uint32_t value; const char* note; };
    static const BootSeed boot_seeds[] = {
        // Perfect Dark (NTSC): boot.c (PIRACYCHECKS=1) does `if (IO_READ(0xa00002e8)!=0xc86e2000) while(1);`
        { "NPDE", (int32_t)0x800002E8, 0xC86E2000u, "Perfect Dark anti-piracy boot word" },
        // Donkey Kong 64 (NTSC): same Rare anti-piracy boot word. func_80611730 reads 0xA00002E8 (via an
        // obfuscated address) and, if it != 0xC86E2000, stops draining its RDP/async queue (0x807F5A58) —
        // the game survives boot/intro/demo but hangs forever in the busy-wait func_8061138C the moment the
        // queue fills (e.g. DK's water-jump effect). IPL3 is skipped on static recomp so the word is never
        // seeded; this row reproduces it. (Confirmed at runtime: RDRAM[0x2E8] read 0 every frame, never matched.)
        { "NDOE", (int32_t)0x800002E8, 0xC86E2000u, "Donkey Kong 64 anti-piracy boot word (same Rare word as Perfect Dark)" },
    };
    {
        std::span<const uint8_t> hdr = recomp::get_rom();
        if (hdr.size() >= 0x40) {
            for (const BootSeed& s : boot_seeds) {
                if (hdr[0x3B] == (uint8_t)s.game_code[0] && hdr[0x3C] == (uint8_t)s.game_code[1]
                 && hdr[0x3D] == (uint8_t)s.game_code[2] && hdr[0x3E] == (uint8_t)s.game_code[3]) {
                    MEM_W(s.addr, 0) = s.value;
                }
            }
        }
    }

    // Load any app-registered static data sections into RDRAM (decomp .data/.rodata the compressed-boot
    // path can't populate). MEM_B byte-swizzle (XOR 3) so MIPS-big-endian bytes land correctly in our RDRAM.
    for (int si = 0; si < g_static_data_count; si++) {
        const StaticDataSection& s = g_static_data[si];
        uint32_t phys = s.vram & 0x1FFFFFFFu;
        for (uint32_t j = 0; j < s.size; j++) {
            rdram[(phys + j) ^ 3u] = s.data[j];
        }
    }

    // Mirror the cartridge ROM into RDRAM at its physical cart-bus address (PI domain-1 base
    // 0x10000000). Most games only touch the cart through osPiStartDma (which we HLE), but some
    // read the cartridge DIRECTLY via osRomBase|0xA0000000 uncached PIO -- e.g. Robotron 64's
    // hand-rolled raw-PI IO driver -- and would otherwise read zeros and stall. On real hardware
    // the cart is memory-mapped here; this makes our RDRAM faithfully mirror that. do_rom_read
    // applies the recompiler's byte-swap so subsequent MEM_W/MEM_B reads return correct data.
    {
        size_t rom_size = recomp::get_rom().size();
        if (rom_size != 0) {
            recomp::do_rom_read(rdram, (gpr)(int32_t)0xB0000000u, recomp::rom_base, rom_size);
        }
    }
}

std::u8string recomp::current_game_id() {
    std::lock_guard<std::mutex> lock(current_game_mutex);
    return current_game.value();
};

std::string recomp::current_mod_game_id() {
    auto find_it = game_roms.find(current_game_id());
    const recomp::GameEntry& game_entry = find_it->second;

    return game_entry.mod_game_id;
}

void recomp::start_game(const std::u8string& game_id) {
    std::lock_guard<std::mutex> lock(current_game_mutex);
    current_game = game_id;
    game_status.store(GameStatus::Running);
    game_status.notify_all();
}

bool ultramodern::is_game_started() {
    return game_status.load() != GameStatus::None;
}

std::atomic_bool exited = false;
moodycamel::LightweightSemaphore graphics_shutdown_ready;

void ultramodern::quit() {
#if defined(_WIN32)
    // cont.33: clean ATOMIC exit on quit (= window close in this game). The graceful teardown
    // (recomp::start frees the renderer BEFORE stopping the CV64 game threads, recomp.cpp:847 vs 849)
    // races those still-running threads on MULTIPLE freed objects (the renderer, its SDL listener, runtime
    // queues) -> use-after-free crash on close (the game thread does a wild READ in func_80018FF0).
    // ExitProcess terminates every thread atomically BEFORE any teardown runs -> no race, no crash, clean
    // exit. cv64 saves persist synchronously on write (pak.cpp Controller Pak) so nothing is lost; the OS
    // reclaims all memory + GPU resources. (This game only calls quit() on SDL_QUIT = window close.)
    fflush(stderr); fflush(stdout);
    ExitProcess(0);
#endif
    exited.store(true);
    GameStatus desired = GameStatus::None;
    game_status.compare_exchange_strong(desired, GameStatus::Quit);
    game_status.notify_all();
    std::lock_guard<std::mutex> lock(current_game_mutex);
    current_game.reset();
}

void recomp::mods::enable_mod(const std::string& mod_id, bool enabled) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->enable_mod(mod_id, enabled, true);
}

bool recomp::mods::is_mod_enabled(const std::string& mod_id) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->is_mod_enabled(mod_id);
}

bool recomp::mods::is_mod_auto_enabled(const std::string& mod_id) {
    std::lock_guard lock{ mod_context_mutex };
    return mod_context->is_mod_auto_enabled(mod_id);
}

const recomp::mods::ConfigSchema &recomp::mods::get_mod_config_schema(const std::string &mod_id) {
    std::lock_guard lock{ mod_context_mutex };
    return mod_context->get_mod_config_schema(mod_id);
}

const std::vector<char> &recomp::mods::get_mod_thumbnail(const std::string &mod_id) {
    std::lock_guard lock{ mod_context_mutex };
    return mod_context->get_mod_thumbnail(mod_id);
}

void recomp::mods::set_mod_config_value(size_t mod_index, const std::string &option_id, const ConfigValueVariant &value) {
    std::lock_guard lock{ mod_context_mutex };
    return mod_context->set_mod_config_value(mod_index, option_id, value);
}

void recomp::mods::set_mod_config_value(const std::string &mod_id, const std::string &option_id, const ConfigValueVariant &value) {
    std::lock_guard lock{ mod_context_mutex };
    return mod_context->set_mod_config_value(mod_id, option_id, value);
}

recomp::mods::ConfigValueVariant recomp::mods::get_mod_config_value(size_t mod_index, const std::string &option_id) {
    std::lock_guard lock{ mod_context_mutex };
    return mod_context->get_mod_config_value(mod_index, option_id);
}

recomp::mods::ConfigValueVariant recomp::mods::get_mod_config_value(const std::string &mod_id, const std::string &option_id) {
    std::lock_guard lock{ mod_context_mutex };
    return mod_context->get_mod_config_value(mod_id, option_id);
}

std::string recomp::mods::get_mod_id_from_filename(const std::filesystem::path& mod_filename) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->get_mod_id_from_filename(mod_filename);
}

std::filesystem::path recomp::mods::get_mod_filename(const std::string& mod_id) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->get_mod_filename(mod_id);
}

size_t recomp::mods::get_mod_order_index(const std::string& mod_id) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->get_mod_order_index(mod_id);
}

size_t recomp::mods::get_mod_order_index(size_t mod_index) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->get_mod_order_index(mod_index);
}

std::optional<recomp::mods::ModDetails> recomp::mods::get_details_for_mod(const std::string& mod_id) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->get_details_for_mod(mod_id);
}

std::vector<recomp::mods::ModDetails> recomp::mods::get_all_mod_details(const std::string& mod_game_id) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->get_all_mod_details(mod_game_id);
}

recomp::Version recomp::mods::get_mod_version(size_t mod_index) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->get_mod_version(mod_index);
}

std::string recomp::mods::get_mod_id(size_t mod_index) {
    std::lock_guard lock { mod_context_mutex };
    return mod_context->get_mod_id(mod_index);
}

void recomp::mods::set_mod_index(const std::string &mod_game_id, const std::string &mod_id, size_t index) {
    std::lock_guard lock{ mod_context_mutex };
    return mod_context->set_mod_index(mod_game_id, mod_id, index);
}

bool wait_for_game_started(uint8_t* rdram, recomp_context* context) {
    game_status.wait(GameStatus::None);

    switch (game_status.load()) {
        // TODO refactor this to allow a project to specify what entrypoint function to run for a give game.
        case GameStatus::Running:
            {
                if (!recomp::load_stored_rom(current_game.value())) {
                    ultramodern::error_handling::message_box("Error opening stored ROM! Please restart this program.");
                }

                auto find_it = game_roms.find(current_game.value());
                const recomp::GameEntry& game_entry = find_it->second;

                init(rdram, context, game_entry.entrypoint_address);
                if (game_entry.on_init_callback) {
                    game_entry.on_init_callback(rdram, context);
                }

                uint32_t mod_ram_used = 0;
                if (!game_entry.mod_game_id.empty()) {
                    std::vector<recomp::mods::ModLoadErrorDetails> mod_load_errors;
                    {
                        std::lock_guard lock { mod_context_mutex };
                        mod_load_errors = mod_context->load_mods(game_entry, rdram, recomp::mod_rdram_start, mod_ram_used);
                    }

                    if (!mod_load_errors.empty()) {
                        std::ostringstream mod_error_stream;
                        mod_error_stream << "Error loading mods:\n\n";
                        for (const auto& cur_error : mod_load_errors) {
                            auto mod_details = recomp::mods::get_details_for_mod(cur_error.mod_id);
                            if (mod_details) {
                                mod_error_stream << mod_details->display_name;
                            }
                            else {
                                mod_error_stream << cur_error.mod_id.c_str();
                            }
                            mod_error_stream << ": " << recomp::mods::error_to_string(cur_error.error);
                            if (!cur_error.error_param.empty()) {
                                mod_error_stream << " (" << cur_error.error_param.c_str() << ")";
                            }
                            mod_error_stream << "\n";                                
                        }
                        ultramodern::error_handling::message_box(mod_error_stream.str().c_str());
                        game_status.store(GameStatus::None);
                        return false;
                    }
                }

                recomp::init_heap(rdram, recomp::mod_rdram_start + mod_ram_used);

                save_type = game_entry.save_type;
                ultramodern::init_saving(rdram);

                try {
                    game_entry.entrypoint(rdram, context);
                } catch (ultramodern::thread_terminated& terminated) {

                }
            }
            return true;

        case GameStatus::Quit:
            return true;

        case GameStatus::None:
            return true;
    }
}

recomp::SaveType recomp::get_save_type() {
    return save_type;
}

bool recomp::eeprom_allowed() {
    return
        save_type == SaveType::Eep4k || 
        save_type == SaveType::Eep16k ||
        save_type == SaveType::AllowAll;
}

bool recomp::sram_allowed() {
    return
        save_type == SaveType::Sram || 
        save_type == SaveType::AllowAll;
}

bool recomp::flashram_allowed() {
    return
        save_type == SaveType::Flashram || 
        save_type == SaveType::AllowAll;
}

// cv64 SESSION 38e: rdram base for diagnostic paths with no rdram parameter
// (overlays.cpp get_function [gfgap] dump). Set once in recomp::start after allocation.
extern "C" void recomp_pi_pacer_tick(void);   // pi.cpp: [pi-pace] deferred DMA completions
extern "C" uint8_t* g_rdram_base = nullptr;

// --- store-watch diagnostic (paired with cgenerator's RECOMP_EMIT_WATCH recomp-time flag). recomp_func_mark
// records the current guest func vram at entry; recomp_store_watch_h (emitted after each store in a watch
// build) names the writer of a write into [g_swatch_lo, g_swatch_hi). No-op unless RECOMP_SWATCH_ADDR set. ---
static thread_local uint32_t g_swatch_cur_func = 0;
static thread_local uint32_t g_swatch_caller = 0;   // 1-deep: the func that called the current func
static bool g_swatch_active = false;
static uint32_t g_swatch_lo = 0, g_swatch_hi = 0;
static const char* g_swatch_log = nullptr;
static const char* g_mtx_log = nullptr;             // RECOMP_MTX_LOG: targeted func_8000A6C0 viewport probe
// hog-sampler (NC RUN 24): the swatch marks are thread_local, so a sampler on the VI thread can't see
// which guest func a starving hog thread is spinning in. When RECOMP_HOG_SAMPLE is set (runtime env,
// requires a RECOMP_EMIT_WATCH recomp), every mark also publishes (host-thread-ordinal<<32 | vram) to a
// process-global atomic plus a mark counter; the VI thread prints it at 60Hz (events.cpp [hogsample]).
// dmarks==0 across frames ⇒ the hog spins a back-edge INSIDE the last-named func (no calls/entries).
static bool g_hog_sampler = false;
static std::atomic<uint64_t> g_hog_mark{0};
static std::atomic<uint64_t> g_hog_mark_count{0};
static std::atomic<uint32_t> g_hog_tid_next{0};
// mark-watch (companion): env RECOMP_MARK_WATCH=0xVRAM — count entries of ONE function (answers
// "does func X ever run?" for a watch-recompiled build). Printed by the VI-thread sampler.
static uint32_t g_mark_watch_vram = 0;
static std::atomic<uint64_t> g_mark_watch_hits{0};
// mqtrace companion: the guest function the CALLING thread is currently inside (last mark on this
// thread). Lets the [mqtrace] park line name the recv CALLER — "which function contains the wait" —
// in one boot on an EMIT_WATCH build. 0 on builds without marks.
extern "C" uint32_t recomp_current_guest_func() { return g_swatch_cur_func; }
// 1-deep CALLER of the above. When a leaf spins, naming the leaf is useless — every probe already
// says "you are in the leaf". The caller is the frame that decided to keep calling it, and that is
// the one worth finding (KI Gold 2026-08-28: __osPiRawStartDma at ~345k calls/s; the leaf name was
// known within a minute and told us nothing). Only meaningful on EMIT_WATCH builds; 0 otherwise.
extern "C" uint32_t recomp_current_guest_caller() { return g_swatch_caller; }
// --- [fn-trace] guest FUNCTION-ENTRY tracer (2026-09-04, Turok 2 attempt 4: the GUEST message-queue
// tracer). RECOMP_MQ_TRACE / SEND_WATCH / RECV_WATCH only see HLE osSendMesg/osRecvMesg; a self-hosted
// kernel (the Acclaim window class, the Midway/Williams coswitch class) does its queue ops in GUEST code,
// so the only general hook is the function boundary. env RECOMP_FN_TRACE=0xVRAM[,0xVRAM...] (up to 16;
// INTERP_TRACE_FN is honoured as an alias): on every ENTRY to a listed guest function — recompiled (via
// the RECOMP_EMIT_WATCH mark) or interpreted (session entry, flat jal, interp->native dispatch) — print
// a0-a3, ra, sp, the bare-metal current TCB, the venue, and the first six words behind a0 and a1 when
// they point into RDRAM (a queue's count/head/size/buffer, a message's type word). The recompiled venue
// needs an EMIT_WATCH emission (no marks = interpreted venues only; the venue tag on each line makes
// silence on the recomp venue an answer, not a mystery). The mark is ALSO re-emitted after every call
// inside a function (emit_func_remark), so a mark is taken as an ENTRY only when the instruction at
// ra-8 is `jal <this vram>` or a `jalr` whose source register still holds it — exact for direct calls,
// near-exact for indirect ones; tail-jump entries (j, not jal) are not seen.
// Cap: RECOMP_FN_TRACE_MAX lines (default 20000), then every 1000th; every line carries the running
// total #n so a capped print is never mistaken for the whole count (memory: lying_instruments).
extern "C" recomp_context* recomp_baremetal_exec_ctx(void);   // baremetal_sched.cpp: the EXECUTING register file
extern "C" uint32_t recomp_baremetal_current_tcb(void);       // baremetal_sched.cpp: g_current_tcb
extern "C" uint64_t recomp_guest_instr(void);                 // recomp_interp.cpp: published guest instruction count
extern "C" int recomp_tlb_is_mapped(uint32_t vaddr, uint32_t* phys_out);   // tlb.cpp
static uint32_t g_fn_trace[16];
static int      g_fn_trace_n = 0;
static uint64_t g_fn_trace_bloom = 0;        // quick reject in the hot mark path: bit (vram>>2)&63
static uint64_t g_fn_trace_max = 20000;
static std::atomic<uint64_t> g_fn_trace_count{0};
static thread_local uint32_t tl_fn_trace_pending = 0;   // interp->native dispatch already printed this entry
static void fn_trace_init() {
    static bool done = false;
    if (done) return;
    done = true;
    const char* e = std::getenv("RECOMP_FN_TRACE");
    if (e == nullptr) e = std::getenv("INTERP_TRACE_FN");
    if (e == nullptr) return;
    char buf[512]; strncpy(buf, e, sizeof buf - 1); buf[sizeof buf - 1] = 0;
    for (char* t = strtok(buf, ", ;"); t && g_fn_trace_n < 16; t = strtok(nullptr, ", ;")) {
        uint32_t v = (uint32_t)strtoul(t, nullptr, 0);
        if (v == 0) continue;
        g_fn_trace[g_fn_trace_n++] = v;
        g_fn_trace_bloom |= 1ull << ((v >> 2) & 63u);
    }
    if (const char* m = std::getenv("RECOMP_FN_TRACE_MAX")) g_fn_trace_max = strtoull(m, nullptr, 0);
    if (g_fn_trace_n > 0) {
        fprintf(stderr, "[fn-trace] armed: %d function(s) — %s (cap %llu lines, then every 1000th)\n",
                g_fn_trace_n, e, (unsigned long long)g_fn_trace_max);
        fflush(stderr);
    }
}
static inline bool fn_trace_match(uint32_t vram) {
    for (int i = 0; i < g_fn_trace_n; i++) if (g_fn_trace[i] == vram) return true;
    return false;
}
// Guest vaddr -> host pointer for a diagnostic read, or nullptr. KSEG0/1 direct; KUSEG only through a
// VALID TLB mapping (never the flat fallback — a flat-mapped unmapped KUSEG pointer prints garbage as
// if it were data). n words must fit inside the 8 MB RDRAM.
static const uint8_t* fn_trace_ptr(const uint8_t* rdram, uint32_t va, uint32_t nbytes) {
    if (rdram == nullptr) return nullptr;
    uint32_t phys;
    if ((va & 0xC0000000u) == 0x80000000u) phys = va & 0x1FFFFFFFu;
    else if ((va & 0x80000000u) == 0u) { if (!recomp_tlb_is_mapped(va, &phys)) return nullptr; }
    else return nullptr;
    phys &= ~3u;
    if (phys + nbytes > 0x00800000u) return nullptr;
    return rdram + phys;   // words are host-native at their phys offset (MEM_W)
}
extern "C" void recomp_fn_trace_hit(uint8_t* rdram, const recomp_context* ctx, uint32_t vaddr, uint32_t ra, const char* venue) {
    if (g_fn_trace_n == 0 || !fn_trace_match(vaddr)) return;
    const uint64_t n = g_fn_trace_count.fetch_add(1, std::memory_order_relaxed) + 1;
    if (n > g_fn_trace_max && (n % 1000u) != 0u) return;
    char line[640]; int pos = 0;
    pos += snprintf(line + pos, sizeof(line) - pos, "[fn-trace] #%llu 0x%08X", (unsigned long long)n, vaddr);
    if (ctx != nullptr) {
        const uint64_t* r = (const uint64_t*)ctx;   // r0..r31 lead the struct (recomp_context)
        pos += snprintf(line + pos, sizeof(line) - pos, "(a0=0x%08X a1=0x%08X a2=0x%08X a3=0x%08X) ra=0x%08X sp=0x%08X",
                        (uint32_t)r[4], (uint32_t)r[5], (uint32_t)r[6], (uint32_t)r[7], ra, (uint32_t)r[29]);
    } else {
        pos += snprintf(line + pos, sizeof(line) - pos, "(no register file) ra=0x%08X", ra);
    }
    pos += snprintf(line + pos, sizeof(line) - pos, " tcb=0x%08X venue=%s ginstr=%llu",
                    recomp_baremetal_current_tcb(), venue ? venue : "?", (unsigned long long)recomp_guest_instr());
    if (ctx != nullptr) {
        const uint64_t* r = (const uint64_t*)ctx;
        for (int a = 4; a <= 5; a++) {
            const uint8_t* p = fn_trace_ptr(rdram, (uint32_t)r[a], 24);
            if (p == nullptr) continue;
            pos += snprintf(line + pos, sizeof(line) - pos, " *a%d=[", a - 4);
            for (int i = 0; i < 6 && pos < (int)sizeof(line) - 12; i++) {
                uint32_t w; memcpy(&w, p + 4 * i, 4);
                pos += snprintf(line + pos, sizeof(line) - pos, "%s%08X", i ? " " : "", w);
            }
            pos += snprintf(line + pos, sizeof(line) - pos, "]");
        }
    }
    fprintf(stderr, "%s\n", line);
    fflush(stderr);
}
extern "C" int recomp_fn_trace_active(void) { return g_fn_trace_n > 0 ? 1 : 0; }
// interp->native dispatch of a traced function: the interpreter prints the entry itself (the target
// may have no mark); the mark that follows must not print it twice.
extern "C" void recomp_fn_trace_expect_mark(uint32_t vaddr) { tl_fn_trace_pending = vaddr; }
// The recompiled venue. Called from recomp_func_mark on every mark whose vram passes the bloom.
static void fn_trace_recomp_hit(uint32_t vram) {
    if (!fn_trace_match(vram)) return;
    if (tl_fn_trace_pending == vram) { tl_fn_trace_pending = 0; return; }   // printed at interp->native
    recomp_context* ctx = recomp_baremetal_exec_ctx();
    if (ctx == nullptr) { recomp_fn_trace_hit(g_rdram_base, nullptr, vram, 0, "recomp"); return; }
    const uint64_t* r = (const uint64_t*)ctx;
    const uint32_t ra = (uint32_t)r[31];
    // entry vs remark: decode the call instruction the ra points past.
    const uint8_t* cp = fn_trace_ptr(g_rdram_base, ra - 8u, 4);
    if (cp == nullptr) return;
    uint32_t insn; memcpy(&insn, cp, 4);
    const uint32_t op = insn >> 26;
    bool entry = false;
    if (op == 3u) {                                                        // jal target
        entry = ((((ra - 8u) & 0xF0000000u) | ((insn & 0x03FFFFFFu) << 2)) == vram);
    } else if (op == 0u && (insn & 0x3Fu) == 9u) {                         // jalr rs
        entry = ((uint32_t)r[(insn >> 21) & 31u] == vram);
    }
    if (!entry) return;
    recomp_fn_trace_hit(g_rdram_base, ctx, vram, ra, "recomp");
}
extern "C" void recomp_func_mark(uint32_t vram) {
    if (g_fn_trace_n > 0 && (g_fn_trace_bloom & (1ull << ((vram >> 2) & 63u)))) fn_trace_recomp_hit(vram);   // [fn-trace]
    g_swatch_caller = g_swatch_cur_func; g_swatch_cur_func = vram;
    if (g_hog_sampler) {
        static thread_local uint32_t tl_tid = ++g_hog_tid_next;
        g_hog_mark.store(((uint64_t)tl_tid << 32) | vram, std::memory_order_relaxed);
        g_hog_mark_count.fetch_add(1, std::memory_order_relaxed);
    }
    if (vram == g_mark_watch_vram) g_mark_watch_hits.fetch_add(1, std::memory_order_relaxed);
}
extern "C" uint64_t recomp_mark_watch_hits(uint32_t* vram) {
    if (vram) *vram = g_mark_watch_vram;
    return g_mark_watch_hits.load(std::memory_order_relaxed);
}
extern "C" int recomp_hog_sampler_active() { return g_hog_sampler ? 1 : 0; }
extern "C" uint64_t recomp_hog_sample(uint64_t* marks) {
    if (marks) *marks = g_hog_mark_count.load(std::memory_order_relaxed);
    return g_hog_mark.load(std::memory_order_relaxed);
}
// hog-chain diagnostic (companion to the sampler): env RECOMP_HOG_CHAIN=0xADDR[:0xOFF][:N] walks a guest
// pointer chain node = *(node+OFF) from ADDR (default OFF=4, N=24) and prints it — names a corrupted/
// cyclic/null linked list (the shape a list-walk hog spins on) in one boot. Reads are racy-but-aligned
// (diagnostic only). Called ~1/s by the VI thread when set; inert otherwise.
static uint32_t g_hog_chain_addr = 0, g_hog_chain_off = 4;
static int g_hog_chain_n = 24;
extern "C" void recomp_hog_chain_dump() {
    if (g_hog_chain_addr == 0 || g_rdram_base == nullptr) return;
    char line[768]; int pos = 0;
    pos += snprintf(line + pos, sizeof(line) - pos, "[hogchain] 0x%08X:", g_hog_chain_addr);
    uint32_t seen[64]; int nseen = 0;
    uint32_t node = g_hog_chain_addr;
    for (int i = 0; i < g_hog_chain_n && pos < (int)sizeof(line) - 24; i++) {
        uint32_t next;
        memcpy(&next, g_rdram_base + (((node + g_hog_chain_off) & 0x00FFFFFCu)), 4);
        pos += snprintf(line + pos, sizeof(line) - pos, " ->0x%08X", next);
        bool cycle = false;
        for (int j = 0; j < nseen; j++) if (seen[j] == next) cycle = true;
        if (next == g_hog_chain_addr) { pos += snprintf(line + pos, sizeof(line) - pos, " (HEAD)"); break; }
        if (next == 0)                { pos += snprintf(line + pos, sizeof(line) - pos, " (NULL)"); break; }
        if (cycle)                    { pos += snprintf(line + pos, sizeof(line) - pos, " (CYCLE)"); break; }
        if (nseen < 64) seen[nseen++] = next;
        node = next;
    }
    fprintf(stderr, "%s\n", line);
    fflush(stderr);
}
// targeted probe (hand-added at func_8000A6C0 entry): logs the CALLER + source floats when it writes the
// cutscene Vp_t region — to find which viewport-mode function feeds the bad Y. No-op unless RECOMP_MTX_LOG set.
extern "C" void recomp_mtx_probe(uint8_t* rdram, uint32_t dest, uint32_t src) {
    if (g_mtx_log == nullptr) return;
    uint32_t d = dest & 0x00FFFFFFu, s = src & 0x00FFFFFFu;
    static uint64_t seen[256]; static int nseen = 0;   // dedup by (caller,dest): log each viewport mode once
    uint64_t key = ((uint64_t)g_swatch_caller << 24) | d;
    for (int i = 0; i < nseen; i++) if (seen[i] == key) return;
    if (nseen < 256) seen[nseen++] = key; else return;
    if (FILE* f = fopen(g_mtx_log, "a")) {
        fprintf(f, "[mtx] caller=func_%08X dest=0x%06X floats=", g_swatch_caller, d);
        for (int i = 0; i < 8; i++) { float v; memcpy(&v, rdram + ((s + i * 4) & 0x7FFFFFu), 4); fprintf(f, "%.2f ", (double)v); }
        fprintf(f, "\n"); fclose(f);
    }
}
extern "C" void recomp_store_watch_h(uint8_t* /*rdram*/, uint64_t addr, uint32_t val) {
    if (!g_swatch_active) return;
    uint32_t a = (uint32_t)addr & 0x00FFFFFFu;
    if (a < g_swatch_lo || a >= g_swatch_hi) return;
    if (FILE* f = fopen(g_swatch_log, "a")) {
        fprintf(f, "[sw] writer=func_%08X addr=0x%06X val=0x%X (s16=%d)\n",
                g_swatch_cur_func, a, val, (int)(int16_t)val);
        fclose(f);
    }
}

// --- unaligned-access trap reporter (engine-hardening queue #3, ENGINE_LEDGER 2026-07-23).
// Called from recomp.h's RECOMP_ALIGN_TRAP builds on every misaligned lw/lwu/sw/lh/lhu/sh/ld/sd
// virtual address — accesses a real VR4300 answers with AdEL/AdES, so ANY hit is a hardware
// divergence worth a look (SOTE's a0=0x21 class). Logs the first 64 hits to stderr with the
// current guest func when the tree carries EMIT_WATCH marks (0 otherwise), then a running-count
// heartbeat. RECOMP_ALIGN_ABORT=1 = abort on first hit, the exception analog. Defined
// unconditionally (dead code in non-trap builds); size-mask: 1=half 3=word 7=double. ---
extern "C" void recomp_align_trap_hit(uint32_t vaddr, uint32_t mask) {
    static std::atomic<uint64_t> total{0};
    static std::atomic<uint32_t> logged{0};
    uint64_t n = total.fetch_add(1, std::memory_order_relaxed) + 1;
    if (logged.fetch_add(1, std::memory_order_relaxed) < 64) {
        fprintf(stderr, "[aligntrap] #%llu vaddr=0x%08X size=%u func=0x%08X\n",
                (unsigned long long)n, vaddr, mask + 1u, recomp_current_guest_func());
        fflush(stderr);
    } else if ((n & 0xFFFFFu) == 0) {
        fprintf(stderr, "[aligntrap] running total=%llu\n", (unsigned long long)n);
        fflush(stderr);
    }
    static const bool abort_on_hit =
        [] { const char* e = std::getenv("RECOMP_ALIGN_ABORT"); return e && *e && *e != '0'; }();
    if (abort_on_hit) {
        fprintf(stderr, "[aligntrap] ABORT (AdEL/AdES analog) vaddr=0x%08X size=%u\n", vaddr, mask + 1u);
        fflush(stderr);
        abort();
    }
}

// Structured diagnostics sink (roadmap tool #1) — runtime gap-report flush, defined in recomp_diag_flush.cpp.
extern "C" void recomp_diag_runtime_flush();

// RAM-snapshot instrument (see the run-loop call site): one-shot dump of a guest RAM region,
// ROM byte order, for capture-backed overlay materialization of custom-unpacker games.
// ── [transit] TRANSITION SAMPLER (SOTE, 2026-08-26) — env RECOMP_TRANSITION_PROBE=1 ─────────────
// A packed title rebuilds its code image at a phase change, and the 04:38 fault dump proved the
// engine can deliver an interrupt into the middle of that rebuild (guest vector still aimed at
// 0x800C37C0 while the bytes there were already packed fill — a state hardware never lets an
// interrupt observe). This samples four RDRAM windows every ~64 loop ticks and logs ON CHANGE, so
// one driven run yields the true ORDER of the transition: when the old handler is stomped, when
// new code materialises at 0x80300400/0x8035E400, and whether the exception vector is ever
// re-pointed. Read-only, env-gated, a few FNVs per second when armed; zero cost unset.
static void recomp_transition_probe(uint8_t* rdram, uint32_t tick) {
    static const bool on = [] { const char* e = std::getenv("RECOMP_TRANSITION_PROBE"); return (e != nullptr) && (e[0] == '1'); }();
    if (!on || ((tick & 63u) != 0u)) return;
    struct Win { const char* name; uint32_t phys; uint64_t last; int logged; };
    static Win wins[] = {
        { "vector@80000180",  0x000180u, 0u, 0 },
        { "handler@800C37C0", 0x0C33C0u, 0u, 0 },
        { "newcode@80300400", 0x300400u, 0u, 0 },
        { "newcode@8035E400", 0x35E400u, 0u, 0 },
    };
    static auto t0 = std::chrono::steady_clock::now();
    for (Win& w : wins) {
        uint64_t h = 1469598103934665603ull;
        for (uint32_t i = 0; i < 0x40u; i++) { h ^= rdram[w.phys + i]; h *= 1099511628211ull; }
        if (h != w.last) {
            const long long ms = std::chrono::duration_cast<std::chrono::milliseconds>(
                std::chrono::steady_clock::now() - t0).count();
            if (w.logged < 12) {
                w.logged++;
                fprintf(stderr, "[transit] t=%lldms %s %s first=%08X %08X %08X %08X\n",
                        ms, w.name, (w.last == 0u) ? "initial" : "CHANGED",
                        *(const uint32_t*)(rdram + w.phys),      *(const uint32_t*)(rdram + w.phys + 4),
                        *(const uint32_t*)(rdram + w.phys + 8),  *(const uint32_t*)(rdram + w.phys + 12));
                fflush(stderr);
            }
            w.last = h;
        }
    }
}

static void recomp_ram_snapshot_tick(uint8_t* rdram, uint32_t tick) {
    static int state = 0;              // 0=unchecked 1=armed 2=done/disabled
    static uint32_t vaddr = 0, size = 0, delay_ticks = 0;
    static std::chrono::steady_clock::time_point armed_at;   // set when the env is parsed (see below)
    if (state == 2) return;
    if (state == 0) {
        state = 2;
        const char* e = std::getenv("RECOMP_RAM_SNAPSHOT");
        if (e == nullptr) return;
        unsigned long v = 0, s = 0, d = 0;
        if (sscanf(e, "%lx:%lx:%lu", &v, &s, &d) != 3 || s == 0) {
            fprintf(stderr, "[ramsnap] bad RECOMP_RAM_SNAPSHOT (want vaddr:size:delay_ms): %s\n", e);
            return;
        }
        vaddr = (uint32_t)v; size = (uint32_t)s; delay_ticks = (uint32_t)d;
        armed_at = std::chrono::steady_clock::now();
        state = 1;
        fprintf(stderr, "[ramsnap] armed: vaddr=0x%08X size=0x%X after %ums (real time)\n", vaddr, size, delay_ticks);
        fflush(stderr);
    }
    if (state != 1) return;
    // 2026-08-26 FIX: this compared the env's DELAY_MS against `tick`, a LOOP-ITERATION counter.
    // The enclosing loop calls update_gfx every pass and is vsync-bound, so a tick is ~16.7ms, not
    // 1ms — an arm for "260000ms" would actually have fired around 72 MINUTES in, and a 300s run
    // produced no snapshot at all while reporting itself correctly armed. Measure real elapsed time
    // so the documented `vaddr:size:delay_ms` contract is true. (void)tick keeps the signature.
    (void)tick;
    const auto elapsed_ms = std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::steady_clock::now() - armed_at).count();
    if (elapsed_ms < (long long)delay_ticks) return;
    state = 2;
    uint32_t phys = vaddr & 0x1FFFFFFFu;
    if ((uint64_t)phys + size > 0x00800000u) {
        fprintf(stderr, "[ramsnap] region out of installed RDRAM — not dumped\n");
        return;
    }
    std::filesystem::path save_path = ultramodern::get_save_file_path();
    if (save_path.empty()) return;
    char name[64];
    snprintf(name, sizeof name, "ram_snapshot_%08X.bin", vaddr);
    std::filesystem::path out = save_path.parent_path() / name;
    if (FILE* f = fopen(out.string().c_str(), "wb")) {
        for (uint32_t i = 0; i < size; i += 4) {
            uint32_t be = byteswap(*reinterpret_cast<uint32_t*>(rdram + phys + i));
            fwrite(&be, 4, 1, f);
        }
        fclose(f);
        fprintf(stderr, "[ramsnap] wrote %s (0x%X bytes @ vaddr 0x%08X)\n", out.string().c_str(), size, vaddr);
        fflush(stderr);
    }
}

void recomp::start(const recomp::Configuration& cfg) {
    project_version = cfg.project_version;
    recomp::check_all_stored_roms();

    recomp::rsp::set_callbacks(cfg.rsp_callbacks);

    static const ultramodern::rsp::callbacks_t ultramodern_rsp_callbacks {
        .init = recomp::rsp::constants_init,
        .run_task = recomp::rsp::run_task,
        // CV64 Brick 3 (Option D): gfx-ucode LLE capture (no-op unless the game registers a hook).
        .capture_gfx_task = recomp::rsp::capture_gfx_task,
    };

    ultramodern::set_callbacks(ultramodern_rsp_callbacks, cfg.renderer_callbacks, cfg.audio_callbacks, cfg.input_callbacks, cfg.gfx_callbacks, cfg.events_callbacks, cfg.error_handling_callbacks, cfg.threads_callbacks);

    ultramodern::gfx_callbacks_t gfx_callbacks = cfg.gfx_callbacks;

    ultramodern::gfx_callbacks_t::gfx_data_t gfx_data{};

#ifdef _WIN32
    // Before any window exists, so the process is never throttled even briefly.
    recomp_disable_background_throttling();
#endif

    if (gfx_callbacks.create_gfx) {
        gfx_data = gfx_callbacks.create_gfx();
    }

    auto window_handle = cfg.window_handle;
    if (window_handle == ultramodern::renderer::WindowHandle{}) {
        if (gfx_callbacks.create_window) {
            window_handle = gfx_callbacks.create_window(gfx_data);
        }
        else {
            assert(false && "No create_window callback provided");
        }
#ifdef _WIN32
        g_recomp_main_window = window_handle.window;
        recomp_restore_window_geometry(g_recomp_main_window);
        std::atexit(recomp_save_window_geometry);
#endif
    }

    ultramodern::set_message_queue_control(cfg.message_queue_control);

    recomp::mods::initialize_mods();
    recomp::mods::scan_mods();

    // Allocate rdram without comitting it. Use a platform-specific virtual allocation function
    // that initializes to zero. Protect the region above the memory size to catch accesses to invalid addresses.
    uint8_t* rdram;
    bool alloc_failed;
#ifdef _WIN32
    rdram = reinterpret_cast<uint8_t*>(VirtualAlloc(nullptr, allocation_size, MEM_COMMIT | MEM_RESERVE, PAGE_NOACCESS));
    DWORD old_protect = 0;
    alloc_failed = (rdram == nullptr);
    if (!alloc_failed) {
        // VirtualProtect returns 0 on failure.
        alloc_failed = (VirtualProtect(rdram, mem_size, PAGE_READWRITE, &old_protect) == 0);
        if (alloc_failed) {
            VirtualFree(rdram, 0, MEM_RELEASE);
        }
    }
#else
    rdram = (uint8_t*)mmap(NULL, allocation_size, PROT_NONE, MAP_ANON | MAP_PRIVATE, -1, 0);
    alloc_failed = rdram == reinterpret_cast<uint8_t*>(MAP_FAILED);
    if (!alloc_failed) {
        // mprotect returns -1 on failure.
        alloc_failed = (mprotect(rdram, mem_size, PROT_READ | PROT_WRITE) == -1);
        if (alloc_failed) {
            munmap(rdram, allocation_size);
        }
    }
#endif

    if (alloc_failed) {
        ultramodern::error_handling::message_box("Failed to allocate memory!");
        return;
    }

    // cv64 SESSION 38e: publish the rdram base so diagnostic paths that have no rdram
    // parameter (get_function's missing-function dump, overlays.cpp) can read game memory.
    g_rdram_base = rdram;
    fn_trace_init();   // [fn-trace] RECOMP_FN_TRACE (alias INTERP_TRACE_FN)

    // store-watch diagnostic init (env RECOMP_SWATCH_ADDR=0xPHYS [+ optional _SIZE] + RECOMP_SWATCH_LOG):
    // arms recomp_store_watch_h to NAME the guest func writing into the watched range (watch-recompiled build).
    if (const char *sa = std::getenv("RECOMP_SWATCH_ADDR")) {
        if (const char *sl = std::getenv("RECOMP_SWATCH_LOG")) {
            g_swatch_lo = (uint32_t)strtoul(sa, nullptr, 0) & 0x00FFFFF0u;
            const char *ss = std::getenv("RECOMP_SWATCH_SIZE");
            uint32_t sz = ss ? (uint32_t)strtoul(ss, nullptr, 0) : 0x10u;
            g_swatch_hi = g_swatch_lo + (sz ? sz : 0x10u);
            g_swatch_log = sl;   // getenv pointer is valid for process lifetime (env not modified)
            g_swatch_active = true;
        }
    }
    g_mtx_log = std::getenv("RECOMP_MTX_LOG");   // targeted func_8000A6C0 viewport probe (paired w/ hand-add)
    g_hog_sampler = std::getenv("RECOMP_HOG_SAMPLE") != nullptr;   // hog-sampler (NC RUN 24; see recomp_func_mark)
    if (const char* mw = std::getenv("RECOMP_MARK_WATCH")) g_mark_watch_vram = (uint32_t)strtoul(mw, nullptr, 0);
    if (const char* hc = std::getenv("RECOMP_HOG_CHAIN")) {        // hog-chain list-walk diagnostic
        g_hog_chain_addr = (uint32_t)strtoul(hc, nullptr, 0);
        if (const char* c1 = strchr(hc, ':')) {
            g_hog_chain_off = (uint32_t)strtoul(c1 + 1, nullptr, 0);
            if (const char* c2 = strchr(c1 + 1, ':')) g_hog_chain_n = (int)strtol(c2 + 1, nullptr, 0);
            if (g_hog_chain_n < 1 || g_hog_chain_n > 64) g_hog_chain_n = 24;
        }
    }

    // --- env-gated RDRAM watchpoint (diagnostic, no-op unless RECOMP_WATCH_ADDR+RECOMP_WATCH_LOG set).
    // A poll thread logs every change to a 16-byte window at the watched physical RDRAM address, with a
    // timestamp. Answers "single discrete write (jump) vs gradual ramp" for a value like DK64's cutscene
    // viewport Vp_t (vtrans Y). Reads are racy-but-atomic-enough for a diagnostic; baseline-safe when unset.
    if (const char *wa = std::getenv("RECOMP_WATCH_ADDR")) {
        const char *wlog = std::getenv("RECOMP_WATCH_LOG");
        if (wlog != nullptr) {
            uint32_t watch_phys = (uint32_t)strtoul(wa, nullptr, 0) & 0x00FFFFF0u;
            // RECOMP_WATCH_SPAN=N (bytes, default 16, capped 64KB): watch a WIDE region and log a
            // compact digest instead of a hex dump. Answers "targeted store vs large block clear"
            // in one run — the decisive question when hunting a memory clobberer (SOTE osBootInfo
            // wipe, 2026-07-19). Digest = nonzero-byte count + first/last changed offset.
            uint32_t span = 16;
            if (const char *ws = std::getenv("RECOMP_WATCH_SPAN")) {
                unsigned long v = strtoul(ws, nullptr, 0);
                if (v >= 4 && v <= 65536) span = (uint32_t)v;
            }
            std::thread{[watch_phys, wlog, span](uint8_t *rd) {
                ultramodern::set_native_thread_name("RDRAM Watchpoint");
                auto t0 = std::chrono::steady_clock::now();
                std::vector<unsigned char> prev(span), cur(span);
                bool have = false; unsigned long n = 0;
                for (;;) {
                    memcpy(cur.data(), rd + watch_phys, span);
                    if (!have || memcmp(cur.data(), prev.data(), span) != 0) {
                        double ms = std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - t0).count();
                        if (FILE *f = fopen(wlog, "a")) {
                            if (span <= 16) {
                                fprintf(f, "[wp] t=%9.1fms #%lu @0x%06X = ", ms, n, watch_phys);
                                for (uint32_t i = 0; i < span; i++) fprintf(f, "%02X%s", cur[i], (i % 2) ? " " : "");
                                fprintf(f, "\n");
                            } else {
                                uint32_t nz = 0; long first = -1, last = -1;
                                for (uint32_t i = 0; i < span; i++) {
                                    if (cur[i]) nz++;
                                    if (have && cur[i] != prev[i]) { if (first < 0) first = (long)i; last = (long)i; }
                                }
                                fprintf(f, "[wp] t=%9.1fms #%lu @0x%06X span=0x%X nonzero=%u/%u changed=[0x%lX..0x%lX]\n",
                                        ms, n, watch_phys, span, nz, span, first, last);
                            }
                            fclose(f);
                        }
                        memcpy(prev.data(), cur.data(), span); have = true; n++;
                    }
                    std::this_thread::sleep_for(std::chrono::microseconds(25));
                }
            }, rdram}.detach();
        }
    }

    // --- env-gated osBootInfo KEEPALIVE (DIAGNOSTIC ONLY — RECOMP_BOOTINFO_KEEPALIVE=1) -------------
    // THIS IS NOT A FIX. It restores the IPL3 boot-info block (0x80000300: osTvType/osRomType/
    // osRomBase/osResetType/osMemSize) whenever something zeroes it, and logs the event. Purpose:
    // prove causation for the SOTE silence chain (2026-07-19) — osRomBase is correct at boot (582ms)
    // and WIPED at ~2958ms [machine: RECOMP_WATCH_ADDR=0x300], after which the game's PI DMA routine
    // (guest 0x800C9F58: cart = ([0x80000308] | rom_offset) & 0x1FFFFFFF) computes a BARE ROM offset,
    // the raw-PI path finds it outside the cart domain, and every audio-stream DMA reads open bus ->
    // total silence. Nothing on real hardware writes this block; whatever does it here is a real bug
    // that must still be found and fixed at its source. Keep this OFF by default and never ship it
    // --- env-gated TRAPPING watchpoint (RECOMP_WATCH_TRAP=<phys>): names the NATIVE storer. ----
    // The polling watch above answers WHEN a cell changes; this answers WHO — the missing half
    // when the storer is recompiled native code (the interp-side storeval watch sees only interp
    // stores). PAGE_GUARD on the page holding the watched cell + a vectored handler: the first
    // guard fault whose target lands in the watched 16-byte window logs the faulting RIP as a
    // module RVA (resolve against <game>.map) and disarms; faults elsewhere on the page re-arm
    // via single-step (EFLAGS.TF + STATUS_SINGLE_STEP), so unrelated traffic passes through.
    // Diagnostic only, no-op unless set. (turok 08-06: the k0-value store into the run-queue
    // head cell at t≈1638ms — interp storeval watch silent ⇒ native storer, unnameable until this.)
#ifdef _WIN32
    if (const char *wt = std::getenv("RECOMP_WATCH_TRAP")) {
        static uint8_t*  s_trap_rdram = rdram;
        static uintptr_t s_trap_page = 0;
        static uintptr_t s_trap_lo = 0, s_trap_hi = 0;
        static volatile LONG s_trap_armed = 1;
        uint32_t phys = (uint32_t)strtoul(wt, nullptr, 0) & 0x00FFFFF0u;
        s_trap_lo = (uintptr_t)(rdram + phys);
        s_trap_hi = s_trap_lo + 16;
        // RECOMP_WATCH_TRAP_OFF=<n>[,<count>]: narrow to bytes [n, n+count) of the window and
        // skip the first (count-1)... no — fire only on that sub-range (e.g. the head cell at
        // +8..+11), so bulk byte-writers (the decompressor) don't burn the one-shot.
        if (const char *wo = std::getenv("RECOMP_WATCH_TRAP_OFF")) {
            unsigned long off = strtoul(wo, nullptr, 0);
            if (off < 16) { s_trap_lo += off; s_trap_hi = s_trap_lo + 4; }
        }
        s_trap_page = s_trap_lo & ~(uintptr_t)0xFFF;
        // RECOMP_WATCH_TRAP_VAL=<hex>: value filter — a watched-cell write only trips the report
        // when the POST-STORE word equals this value (single-step through the store, then check).
        // Without it, the first watched-cell write reports (the raw one-shot). RDRAM words are
        // host-native (MEM_W stores directly — see the keepalive note), compare raw.
        static uint32_t s_trap_val = 0;
        if (const char *wv = std::getenv("RECOMP_WATCH_TRAP_VAL")) s_trap_val = (uint32_t)strtoul(wv, nullptr, 0);
        AddVectoredExceptionHandler(1, [](PEXCEPTION_POINTERS xp) -> LONG {
            static thread_local bool rearm_pending = false;
            static thread_local bool check_pending = false;
            static thread_local uintptr_t pending_rip = 0;
            auto* rec = xp->ExceptionRecord;
            if (rec->ExceptionCode == STATUS_GUARD_PAGE_VIOLATION) {
                uintptr_t target = (uintptr_t)rec->ExceptionInformation[1];
                bool is_write = rec->ExceptionInformation[0] == 1;
                if (is_write && target >= s_trap_lo && target < s_trap_hi && s_trap_armed) {
                    if (s_trap_val == 0) {
                        InterlockedExchange(&s_trap_armed, 0);   // raw one-shot
                        HMODULE mod = nullptr;
                        GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                           GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                           (LPCSTR)xp->ContextRecord->Rip, &mod);
                        fprintf(stderr, "[watch-trap] WRITE to watched cell +0x%llX by RIP=%p RVA=0x%08llX (resolve vs the exe .map)\n",
                                (unsigned long long)(target - s_trap_lo), (void*)xp->ContextRecord->Rip,
                                (unsigned long long)(xp->ContextRecord->Rip - (uintptr_t)mod));
                        fflush(stderr);
                        return EXCEPTION_CONTINUE_EXECUTION;     // guard auto-disarmed by the fault
                    }
                    // value-filtered: step through the store, check the landed word after
                    check_pending = true;
                    pending_rip = (uintptr_t)xp->ContextRecord->Rip;
                    xp->ContextRecord->EFlags |= 0x100;
                    return EXCEPTION_CONTINUE_EXECUTION;
                }
                // unrelated access on the guarded page: let it proceed, re-arm after the instruction
                if (s_trap_armed) { rearm_pending = true; xp->ContextRecord->EFlags |= 0x100; }
                return EXCEPTION_CONTINUE_EXECUTION;
            }
            if (rec->ExceptionCode == STATUS_SINGLE_STEP && (rearm_pending || check_pending)) {
                if (check_pending) {
                    check_pending = false;
                    uint32_t landed; memcpy(&landed, (const void*)s_trap_lo, 4);
                    if (landed == s_trap_val && s_trap_armed) {
                        InterlockedExchange(&s_trap_armed, 0);
                        HMODULE mod = nullptr;
                        GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                           GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                           (LPCSTR)pending_rip, &mod);
                        fprintf(stderr, "[watch-trap] VALUE 0x%08X landed in watched cell; storer RIP=%p RVA=0x%08llX\n",
                                landed, (void*)pending_rip,
                                (unsigned long long)(pending_rip - (uintptr_t)mod));
                        fflush(stderr);
                        // [watch-trap-who 2026-09-04] the storer's CALLERS: walk the faulting thread's stack
                        // (from the exception context's RSP) for return addresses inside the exe, exactly
                        // as [tlbmisswho] does from its own frame. A guest kernel's enqueue routine stores
                        // whatever pointer its caller handed it; the RIP alone names the routine, the walk
                        // names who built the value (resolve with recompilator/bench/resolve_rva.py).
                        {
                            HMODULE exe2 = GetModuleHandleA(nullptr);
                            const uintptr_t* sp2 = (const uintptr_t*)xp->ContextRecord->Rsp;
                            const uintptr_t* top2 = (const uintptr_t*)((NT_TIB*)NtCurrentTeb())->StackBase;
                            int f2 = 0;
                            for (int i = 0; i < 2048 && f2 < 10 && exe2 != nullptr && &sp2[i] < top2; i++) {
                                uintptr_t ret2 = sp2[i]; HMODULE m2 = nullptr;
                                if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                                       GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                                       (LPCSTR)ret2, &m2) && m2 == exe2) {
                                    fprintf(stderr, "[watch-trap-who] #%d RVA=0x%08llX\n", f2,
                                            (unsigned long long)(ret2 - (uintptr_t)exe2));
                                    f2++;
                                }
                            }
                            fflush(stderr);
                        }
                        recomp_interp_ring_dump("watch-trap");   // the interp path that led here
                        return EXCEPTION_CONTINUE_EXECUTION;     // stay disarmed: evidence banked
                    }
                }
                rearm_pending = false;
                if (s_trap_armed) {
                    DWORD old;
                    VirtualProtect((LPVOID)s_trap_page, 0x1000, PAGE_READWRITE | PAGE_GUARD, &old);
                }
                return EXCEPTION_CONTINUE_EXECUTION;
            }
            return EXCEPTION_CONTINUE_SEARCH;
        });
        // RECOMP_WATCH_TRAP_DELAY_MS=<n>: arm after n ms — skip benign early bulk writes
        // (payload decompression staging covers kernel-global addresses before the kernel exists).
        unsigned long delay_ms = 0;
        if (const char *wd = std::getenv("RECOMP_WATCH_TRAP_DELAY_MS")) delay_ms = strtoul(wd, nullptr, 0);
        std::thread{[delay_ms]() {
            if (delay_ms) std::this_thread::sleep_for(std::chrono::milliseconds(delay_ms));
            DWORD old;
            VirtualProtect((LPVOID)s_trap_page, 0x1000, PAGE_READWRITE | PAGE_GUARD, &old);
            fprintf(stderr, "[watch-trap] armed (+%lums)\n", delay_ms);
            fflush(stderr);
        }}.detach();
        fprintf(stderr, "[watch-trap] configured on phys 0x%06X (page %p) delay=%lums\n", phys, (void*)s_trap_page, delay_ms);
        (void)s_trap_rdram;
    }
#endif

    // as the remedy.
    if (const char *bk = std::getenv("RECOMP_BOOTINFO_KEEPALIVE")) {
        if (*bk && *bk != '0') {
            std::thread{[](uint8_t *rd) {
                ultramodern::set_native_thread_name("osBootInfo Keepalive");
                auto t0 = std::chrono::steady_clock::now();
                // RDRAM stores 32-bit words HOST-NATIVE (recomp.h: MEM_W is a direct
                // *(int32_t*)(rdram + phys) — no byte swap; only MEM_B/MEM_H apply the ^3/^2
                // swizzle). An earlier version of this probe byte-swapped here and therefore
                // mis-read a CORRECT osRomBase as corrupt and then wrote the swapped value back,
                // corrupting the block it was meant to protect. Read/write words directly.
                auto rd_w = [&](uint32_t p) {
                    uint32_t v; memcpy(&v, rd + p, 4); return v;
                };
                auto wr_w = [&](uint32_t p, uint32_t v) {
                    memcpy(rd + p, &v, 4);
                };
                unsigned long fixes = 0;
                for (;;) {
                    if (rd_w(0x308) != 0xB0000000u) {
                        double ms = std::chrono::duration<double, std::milli>(
                                        std::chrono::steady_clock::now() - t0).count();
                        uint32_t was = rd_w(0x308);
                        wr_w(0x300, 1);            // osTvType = NTSC
                        wr_w(0x308, 0xB0000000u);  // osRomBase
                        wr_w(0x30C, 0);            // osResetType = cold
                        wr_w(0x318, 8 * 1024 * 1024); // osMemSize
                        if (++fixes <= 20 || (fixes % 500) == 0) {
                            fprintf(stderr, "[bootinfo] RESTORED #%lu at t=%.1fms (osRomBase was 0x%08X)\n",
                                    fixes, ms, was);
                            fflush(stderr);
                        }
                    }
                    std::this_thread::sleep_for(std::chrono::microseconds(50));
                }
            }, rdram}.detach();
        }
    }

    recomp::register_heap_exports();
    recomp::mods::register_config_exports();
    recomp::mods::register_hook_exports();

    std::thread game_thread{[](ultramodern::renderer::WindowHandle window_handle, uint8_t* rdram) {
        debug_printf("[Recomp] Starting\n");

        ultramodern::set_native_thread_name("Game Start Thread");

        ultramodern::preinit(rdram, window_handle);

        recomp_context context{};

        // Loop until the game starts.
        while (!wait_for_game_started(rdram, &context)) {}
    }, window_handle, rdram};

    uint32_t diag_flush_tick = 0;
    while (!exited) {
        ultramodern::sleep_milliseconds(1);
        if (gfx_callbacks.update_gfx != nullptr) {
            gfx_callbacks.update_gfx(gfx_data);
        }
        // (Wave-1 purge: removed the DK64 cksum/fault probes — one-shot investigation whose answer
        // is productized in the boot-seed/preamble model; DK64 addresses do not belong in the
        // universal run loop, and the gate called getenv every frame.)
        // Roadmap tool #1: periodically flush the runtime gap report (~every 3s). RT64's window-close path
        // hard-exits the process from inside this loop, bypassing the joins below + atexit, so periodic
        // flushing is the only reliable way the report survives. No-op unless RECOMP_DIAG is set.
        if ((++diag_flush_tick % 3000u) == 0u) {
            recomp_diag_runtime_flush();
        }
        // RAM-SNAPSHOT instrument (2026-07-18, the materialization recipe's compression-agnostic
        // source): RECOMP_RAM_SNAPSHOT="vaddr:size:delay_ms" dumps rdram[phys..phys+size] in ROM
        // byte order to saves/ram_snapshot_<vaddr>.bin ONCE, ~delay_ms after this loop starts.
        // For games whose hidden code is decompressed into RAM by a custom unpacker (SOTE's "B1"
        // class), the snapshot IS the decompressed segment — no offline format decode needed;
        // decompress_overlays.py consumes it as an overlay source. Env unset = zero cost.
        recomp_ram_snapshot_tick(rdram, diag_flush_tick);
        recomp_transition_probe(rdram, diag_flush_tick);
        recomp_pi_pacer_tick();   // [pi-pace] deferred DMA completions
    }

    graphics_shutdown_ready.signal();

    game_thread.join();
    ultramodern::join_event_threads();
    ultramodern::join_thread_cleaner_thread();
    ultramodern::join_saving_thread();

    // Flush the runtime diagnostics gap report now that the game has exited and all threads are joined
    // (g_gap_cache is final, no races). No-op unless RECOMP_DIAG is set. See recomp_diag_flush.cpp.
    recomp_diag_runtime_flush();
    
    // Free rdram.
    bool free_failed;
#ifdef _WIN32
    // VirtualFree returns zero on failure.
    free_failed = (VirtualFree(rdram, 0, MEM_RELEASE) == 0);
#else
    // munmap returns -1 on failure.
    free_failed = (munmap(rdram, allocation_size) == -1);
#endif

    if (free_failed) {
        printf("Failed to free rdram\n");
    }
}
