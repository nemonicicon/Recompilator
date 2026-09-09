#include <chrono>
#include "ultramodern/ultra64.h"
#include "ultramodern/ultramodern.hpp"

#include "recomp.h"
#include "helpers.hpp"

#include <array>
#include <vector>
#include <cstdint>
#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <filesystem>
#include <mutex>

// [pak] diagnostic logging → stderr. The save path is rare (only on an actual save/load), so this
// never spams. Gated behind the N64PAK_DEBUG env var so it stays silent in normal runs; set
// N64PAK_DEBUG to any non-empty value to enable.
namespace {
inline bool pak_debug_enabled() {
    static const bool enabled = [] {
        const char* v = std::getenv("N64PAK_DEBUG");
        return v != nullptr && v[0] != '\0';
    }();
    return enabled;
}
}
#define PAKLOG(...) do { if (pak_debug_enabled()) { std::fprintf(stderr, "[pak] " __VA_ARGS__); std::fputc('\n', stderr); std::fflush(stderr); } } while (0)

// ── N64 Controller Pak (osPfs) emulation — general ───────────────────────────
// Many N64 games (CV64 and other western titles, etc.) save to the Controller Pak
// via the libultra osPfs* file API.  ultramodern was built for cart-save games
// (EEPROM/SRAM/Flash) and shipped this file as pure PFS_ERR_NOPACK stubs, so the
// pak was never present and such games could not save.  This implements a
// minimal-but-faithful single-pak filesystem (files keyed by company/game/name/ext,
// addressed by file_no), backed by a real file on disk so saves persist across runs.
//
// Game memory is accessed through the MEM_* helpers (the word-swizzled RDRAM
// layout), so byte buffers (file data, names) round-trip correctly.  Args 0-3 are
// r4-r7; args 4+ live on the caller's stack at sp(0x10),(0x14),(0x18) (MIPS O32).

namespace ultramodern { std::filesystem::path get_save_file_path(); }

namespace {

constexpr int      PFS_OK          = 0;
constexpr int      PFS_ERR_NOPACK  = 1;
constexpr int      PFS_ERR_INCONSISTENT = 3;   // os_pfs.h values
constexpr int      PFS_ERR_INVALID = 5;
constexpr int      PFS_ERR_BAD_DATA = 6;
constexpr int      PFS_DATA_FULL   = 7;
constexpr int      PFS_DIR_FULL    = 8;
constexpr int      PFS_ERR_EXIST   = 9;
constexpr int      PFS_INITIALIZED = 0x1;
constexpr uint8_t  PFS_READ        = 0;
constexpr uint8_t  PFS_WRITE       = 1;
constexpr int      NAME_LEN        = 16;
constexpr int      EXT_LEN         = 4;
constexpr size_t   MAX_FILES       = 16;
constexpr uint32_t PAK_FILE_MAGIC  = 0x43503634u; // "CP64" — on-disk format tag (unchanged value for back-compat)

struct PakFile {
    bool     used    = false;
    uint16_t company = 0;
    uint32_t game    = 0;
    uint8_t  name[NAME_LEN] = {};
    uint8_t  ext[EXT_LEN]   = {};
    std::vector<uint8_t> data;
};

std::array<PakFile, MAX_FILES> g_files;
std::recursive_mutex           g_mutex;
bool                           g_loaded = false;

std::filesystem::path pak_path() {
    // The save directory is already per-game (get_save_file_path().parent_path() →
    // %APPDATA%/<app>/), so a fixed generic filename is unique per game.
    std::filesystem::path base = ultramodern::get_save_file_path();
    if (base.empty()) {
        return {};
    }
    return base.parent_path() / "controller_pak.bin";
}

// Legacy CV64 path: cv64pc shipped its pak as "cv64_controller_pak.bin" in the same
// per-game directory.  On load we fall back to this if the generic file is absent, so
// existing CV64 saves are not orphaned.  (Subsequent persists write the generic name.)
std::filesystem::path legacy_pak_path() {
    std::filesystem::path base = ultramodern::get_save_file_path();
    if (base.empty()) {
        return {};
    }
    return base.parent_path() / "cv64_controller_pak.bin";
}

void pak_persist() {
    std::filesystem::path p = pak_path();
    if (p.empty()) {
        return;
    }
    std::error_code ec;
    std::filesystem::create_directories(p.parent_path(), ec);
    std::ofstream f(p, std::ios::binary | std::ios::trunc);
    if (!f) {
        return;
    }
    uint32_t magic = PAK_FILE_MAGIC;
    f.write(reinterpret_cast<const char*>(&magic), 4);
    uint32_t n = 0;
    for (const auto& pf : g_files) {
        if (pf.used) n++;
    }
    f.write(reinterpret_cast<const char*>(&n), 4);
    for (uint32_t i = 0; i < MAX_FILES; i++) {
        const PakFile& pf = g_files[i];
        if (!pf.used) continue;
        f.write(reinterpret_cast<const char*>(&i), 4);            // slot index (preserves file_no)
        f.write(reinterpret_cast<const char*>(&pf.company), 2);
        f.write(reinterpret_cast<const char*>(&pf.game), 4);
        f.write(reinterpret_cast<const char*>(pf.name), NAME_LEN);
        f.write(reinterpret_cast<const char*>(pf.ext), EXT_LEN);
        uint32_t len = static_cast<uint32_t>(pf.data.size());
        f.write(reinterpret_cast<const char*>(&len), 4);
        if (len) f.write(reinterpret_cast<const char*>(pf.data.data()), len);
    }
}

void pak_load() {
    if (g_loaded) {
        return;
    }
    g_loaded = true;
    std::filesystem::path p = pak_path();
    if (p.empty()) {
        return;
    }
    // Legacy fallback: if the generic per-game file is absent but the old CV64 file
    // exists in the same directory, load the old file so existing CV64 saves persist.
    std::error_code ec;
    if (!std::filesystem::exists(p, ec)) {
        std::filesystem::path legacy = legacy_pak_path();
        if (!legacy.empty() && std::filesystem::exists(legacy, ec)) {
            p = legacy;
        }
    }
    std::ifstream f(p, std::ios::binary);
    if (!f) {
        return;
    }
    uint32_t magic = 0;
    f.read(reinterpret_cast<char*>(&magic), 4);
    if (!f || magic != PAK_FILE_MAGIC) {
        return;
    }
    uint32_t n = 0;
    f.read(reinterpret_cast<char*>(&n), 4);
    for (uint32_t k = 0; k < n; k++) {
        uint32_t slot = 0;
        f.read(reinterpret_cast<char*>(&slot), 4);
        PakFile pf;
        pf.used = true;
        f.read(reinterpret_cast<char*>(&pf.company), 2);
        f.read(reinterpret_cast<char*>(&pf.game), 4);
        f.read(reinterpret_cast<char*>(pf.name), NAME_LEN);
        f.read(reinterpret_cast<char*>(pf.ext), EXT_LEN);
        uint32_t len = 0;
        f.read(reinterpret_cast<char*>(&len), 4);
        pf.data.resize(len);
        if (len) f.read(reinterpret_cast<char*>(pf.data.data()), len);
        if (!f) break;
        if (slot < MAX_FILES) g_files[slot] = std::move(pf);
    }
}

int find_slot(uint16_t company, uint32_t game, const uint8_t* name, const uint8_t* ext) {
    for (int i = 0; i < static_cast<int>(MAX_FILES); i++) {
        const PakFile& pf = g_files[i];
        if (pf.used && pf.company == company && pf.game == game &&
            std::memcmp(pf.name, name, NAME_LEN) == 0 &&
            std::memcmp(pf.ext, ext, EXT_LEN) == 0) {
            return i;
        }
    }
    return -1;
}

} // namespace

// Forward decls — the pak FS operates on the raw 32KB g_pak_image (defined far below). The osPfs* HLE
// wrappers next are thin RDRAM shells over these, so the high-level API and the game's OWN low-level pak
// code (__osContRam* -> recomp_pak_raw_*) share ONE coherent image. ([[project_controller_pak_unification]])
static void pak_image_load();
static void pak_image_persist();
static void pak_fill_pfs(uint8_t* rdram, gpr pfs_va, gpr queue_va, int channel);
namespace {
int  pakfs_find(uint16_t company, uint32_t game, const uint8_t* name16, const uint8_t* ext4);
int  pakfs_alloc(uint16_t company, uint32_t game, const uint8_t* name16, const uint8_t* ext4, int sizeBytes);
int  pakfs_rw(int fileno, bool write, int offset, int size, uint8_t* host);
int  pakfs_delete(uint16_t company, uint32_t game, const uint8_t* name16, const uint8_t* ext4);
int  pakfs_free_bytes();
int  pakfs_numfiles();
bool pakfs_state(int fileno, uint32_t* game, uint16_t* company, uint8_t ext4[4], uint8_t name16[16], uint32_t* sizeBytes);
}

// ── osPfs API ─────────────────────────────────────────────────────────────────


// ── [pakcensus 2026-08-28] instrument only, env RECOMP_PAK_CENSUS=1, default silent ─────────────
// WHY: SOTE reaches Stage One and then sits behind a pause/SAVE screen that never dismisses
// (08-28: the 2D overlay persists, the save screen never goes away, radar still
// updating). The uncapped renderer census proved the world is drawn EVERY frame (29-31 perspective
// pairs/sec, all into the presented buffer), so the 3D is behind a live overlay, not missing.
// A save screen that will not close is the shape of a game blocked on the Controller Pak -- and
// this whole file had exactly ONE fprintf, so "no pak lines in the log" proved nothing either way.
// Count every entry point, uncapped, and report on a 1s beat: silence here EXONERATES the pak.
static void pak_census(const char* who) {
    static const bool on = [] { const char* e = std::getenv("RECOMP_PAK_CENSUS"); return (e != nullptr) && (e[0] != '0'); }();
    if (!on) return;
    static const char* names[24]; static unsigned long long counts[24]; static int n = 0;
    static std::chrono::steady_clock::time_point t0 = std::chrono::steady_clock::now();
    int k = -1;
    for (int i = 0; i < n; i++) if (names[i] == who) { k = i; break; }
    if (k < 0 && n < 24) { k = n++; names[k] = who; counts[k] = 0; }
    if (k >= 0) counts[k]++;
    const auto now = std::chrono::steady_clock::now();
    if (std::chrono::duration_cast<std::chrono::milliseconds>(now - t0).count() >= 1000) {
        t0 = now;
        fprintf(stderr, "[pakcensus]");
        for (int i = 0; i < n; i++) fprintf(stderr, " %s=%llu", names[i], (unsigned long long)counts[i]);
        fprintf(stderr, "%c", 0x0A);
        fflush(stderr);
    }
}

extern "C" void osPfsInitPak_recomp(uint8_t* rdram, recomp_context* ctx) {
    pak_census("osPfsInitPak");
    // (OSMesgQueue* r4, OSPfs* r5, int channel r6)
    gpr queue_va = ctx->r4;
    gpr pfs_va  = ctx->r5;
    int channel = static_cast<int>(ctx->r6);
    std::lock_guard lock(g_mutex);
    pak_image_load();                     // load/format the one shared 32KB pak image
    pak_fill_pfs(rdram, pfs_va, queue_va, channel);   // the FULL struct, as libultra leaves it
    ctx->r2 = PFS_OK;
    PAKLOG("InitPak ch=%d -> r2=%d", channel, (int)ctx->r2);
}

// osPfsInit(OSMesgQueue* r4, OSPfs* r5, int channel r6) — the public Controller-Pak init; same effect as
// osPfsInitPak for our single-pak HLE filesystem. Surfaced by the GoldenEye decomp-driven recomp
// (joyRumblePakInit). General libultra native.
extern "C" void osPfsInit_recomp(uint8_t* rdram, recomp_context* ctx) {
    osPfsInitPak_recomp(rdram, ctx);
}

extern "C" void osPfsIsPlug_recomp(uint8_t* rdram, recomp_context* ctx) {
    // (OSMesgQueue* r4, u8* pattern r5)
    // Report controller 0 has a working Controller Pak plugged in. The game
    // polls this to verify the pak before each save; bit i = controller i.
    gpr pattern_va = ctx->r5;
    if (pattern_va != 0) {
        MEM_B(0x0, pattern_va) = 0x01; // bit0 = controller 0 has a pak
    }
    ctx->r2 = PFS_OK;
    PAKLOG("IsPlug -> pattern=0x01 r2=%d", (int)ctx->r2);
}

extern "C" void osPfsFreeBlocks_recomp(uint8_t* rdram, recomp_context* ctx) {
    pak_census("osPfsFreeBlocks");
    // (OSPfs* r4, s32* bytes_not_used r5)
    gpr bytes_va = ctx->r5;
    std::lock_guard lock(g_mutex);
    pak_image_load();
    int freeBytes = pakfs_free_bytes();
    MEM_W(0x0, bytes_va) = freeBytes;
    ctx->r2 = PFS_OK;
    PAKLOG("FreeBlocks -> free=%d r2=%d", freeBytes, (int)ctx->r2);
}

extern "C" void osPfsAllocateFile_recomp(uint8_t* rdram, recomp_context* ctx) {
    // (OSPfs* r4, u16 company r5, u32 game r6, u8* name r7, u8* ext sp+0x10, int length sp+0x14, s32* fileno sp+0x18)
    uint16_t company   = static_cast<uint16_t>(ctx->r5);
    uint32_t game      = static_cast<uint32_t>(ctx->r6);
    gpr      name_va   = ctx->r7;
    gpr      ext_va    = MEM_W(0x10, ctx->r29);
    int      length    = static_cast<int>(MEM_W(0x14, ctx->r29));
    gpr      fileno_va = MEM_W(0x18, ctx->r29);

    uint8_t name[NAME_LEN], ext[EXT_LEN];
    std::lock_guard lock(g_mutex);
    pak_image_load();
    for (int i = 0; i < NAME_LEN; i++) name[i] = MEM_BU((gpr)i, name_va);
    for (int i = 0; i < EXT_LEN; i++)  ext[i]  = MEM_BU((gpr)i, ext_va);

    int r = pakfs_alloc(company, game, name, ext, length);
    if (r < 0) { ctx->r2 = -r; PAKLOG("AllocateFile company=0x%04X game=0x%08X len=%d -> err %d", company, game, length, -r); return; }
    MEM_W(0x0, fileno_va) = r;
    pak_image_persist();
    ctx->r2 = PFS_OK;
    PAKLOG("AllocateFile company=0x%04X game=0x%08X len=%d -> slot=%d", company, game, length, r);
}

extern "C" void osPfsDeleteFile_recomp(uint8_t* rdram, recomp_context* ctx) {
    // (OSPfs* r4, u16 company r5, u32 game r6, u8* name r7, u8* ext sp+0x10)
    uint16_t company = static_cast<uint16_t>(ctx->r5);
    uint32_t game    = static_cast<uint32_t>(ctx->r6);
    gpr      name_va = ctx->r7;
    gpr      ext_va  = MEM_W(0x10, ctx->r29);

    uint8_t name[NAME_LEN], ext[EXT_LEN];
    std::lock_guard lock(g_mutex);
    pak_image_load();
    for (int i = 0; i < NAME_LEN; i++) name[i] = MEM_BU((gpr)i, name_va);
    for (int i = 0; i < EXT_LEN; i++)  ext[i]  = MEM_BU((gpr)i, ext_va);

    int r = pakfs_delete(company, game, name, ext);
    if (r != PFS_OK) { ctx->r2 = r; PAKLOG("DeleteFile company=0x%04X game=0x%08X -> NOT FOUND", company, game); return; }
    pak_image_persist();
    ctx->r2 = PFS_OK;
    PAKLOG("DeleteFile company=0x%04X game=0x%08X -> r2=%d", company, game, (int)ctx->r2);
}

extern "C" void osPfsFileState_recomp(uint8_t* rdram, recomp_context* ctx) {
    pak_census("osPfsFileState");
    // (OSPfs* r4, s32 fileno r5, OSPfsState* r6)
    int fileno = static_cast<int>(ctx->r5);
    gpr st_va  = ctx->r6;
    std::lock_guard lock(g_mutex);
    pak_image_load();
    uint32_t game, size; uint16_t company; uint8_t ext[EXT_LEN], name[NAME_LEN];
    if (!pakfs_state(fileno, &game, &company, ext, name, &size)) {
        ctx->r2 = PFS_ERR_INVALID;
        PAKLOG("FileState fileno=%d -> INVALID", fileno);
        return;
    }
    // OSPfsState { u32 file_size@0; u32 game_code@4; u16 company_code@8; char ext_name[4]@0xA; char game_name[16]@0xE; }
    MEM_W(0x0, st_va) = static_cast<int32_t>(size);
    MEM_W(0x4, st_va) = static_cast<int32_t>(game);
    MEM_H(0x8, st_va) = static_cast<int16_t>(company);
    for (int i = 0; i < EXT_LEN; i++)  MEM_B((gpr)(0xA + i), st_va) = static_cast<int8_t>(ext[i]);
    for (int i = 0; i < NAME_LEN; i++) MEM_B((gpr)(0xE + i), st_va) = static_cast<int8_t>(name[i]);
    ctx->r2 = PFS_OK;
    PAKLOG("FileState fileno=%d -> OK", fileno);
}

extern "C" void osPfsFindFile_recomp(uint8_t* rdram, recomp_context* ctx) {
    // (OSPfs* r4, u16 company r5, u32 game r6, u8* name r7, u8* ext sp+0x10, s32* fileno sp+0x14)
    uint16_t company   = static_cast<uint16_t>(ctx->r5);
    uint32_t game      = static_cast<uint32_t>(ctx->r6);
    gpr      name_va   = ctx->r7;
    gpr      ext_va    = MEM_W(0x10, ctx->r29);
    gpr      fileno_va = MEM_W(0x14, ctx->r29);

    uint8_t name[NAME_LEN], ext[EXT_LEN];
    std::lock_guard lock(g_mutex);
    pak_image_load();
    for (int i = 0; i < NAME_LEN; i++) name[i] = MEM_BU((gpr)i, name_va);
    for (int i = 0; i < EXT_LEN; i++)  ext[i]  = MEM_BU((gpr)i, ext_va);

    int slot = pakfs_find(company, game, name, ext);
    if (slot < 0) { ctx->r2 = PFS_ERR_INVALID; PAKLOG("FindFile company=0x%04X game=0x%08X -> NOT FOUND", company, game); return; }
    MEM_W(0x0, fileno_va) = slot;
    ctx->r2 = PFS_OK;
    PAKLOG("FindFile company=0x%04X game=0x%08X -> slot=%d", company, game, slot);
}

extern "C" void osPfsReadWriteFile_recomp(uint8_t* rdram, recomp_context* ctx) {
    pak_census("osPfsReadWriteFile");
    // (OSPfs* r4, s32 fileno r5, u8 flag r6, int offset r7, int size sp+0x10, u8* buf sp+0x14)
    int     fileno = static_cast<int>(ctx->r5);
    uint8_t flag   = static_cast<uint8_t>(ctx->r6);
    int     offset = static_cast<int>(ctx->r7);
    int     size   = static_cast<int>(MEM_W(0x10, ctx->r29));
    gpr     buf_va = MEM_W(0x14, ctx->r29);

    std::lock_guard lock(g_mutex);
    pak_image_load();
    bool write = (flag == PFS_WRITE);
    if (size <= 0) { ctx->r2 = PFS_ERR_INVALID; return; }
    std::vector<uint8_t> host(static_cast<size_t>(size));
    if (write) for (int i = 0; i < size; i++) host[i] = MEM_BU((gpr)i, buf_va);
    int r = pakfs_rw(fileno, write, offset, size, host.data());
    if (r == PFS_OK && !write) for (int i = 0; i < size; i++) MEM_B((gpr)i, buf_va) = static_cast<int8_t>(host[i]);
    if (r == PFS_OK && write)  pak_image_persist();
    ctx->r2 = r;
    PAKLOG("ReadWriteFile %s fileno=%d off=%d size=%d -> r2=%d", write ? "WRITE" : "READ", fileno, offset, size, r);
}

extern "C" void osPfsChecker_recomp(uint8_t* rdram, recomp_context* ctx) {
    pak_census("osPfsChecker");
    ctx->r2 = PFS_OK;
    PAKLOG("Checker -> r2=%d", (int)ctx->r2);
}

extern "C" void osPfsNumFiles_recomp(uint8_t* rdram, recomp_context* ctx) {
    pak_census("osPfsNumFiles");
    // (OSPfs* r4, s32* max r5, s32* used r6)
    gpr max_va  = ctx->r5;
    gpr used_va = ctx->r6;
    std::lock_guard lock(g_mutex);
    pak_image_load();
    int used = pakfs_numfiles();
    MEM_W(0x0, max_va)  = 16;
    MEM_W(0x0, used_va) = used;
    ctx->r2 = PFS_OK;
    PAKLOG("NumFiles -> max=16 used=%d r2=%d", used, (int)ctx->r2);
}

extern "C" void osPfsRepairId_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = PFS_OK;
    PAKLOG("RepairId -> r2=%d", (int)ctx->r2);
}

// ── Low-level Controller-Pak / SI internals (osPfs LLE building blocks) ───────
// GENERAL libultra natives surfaced by the Perfect Dark decomp-driven recomp: PD ships its OWN
// Controller-Pak layer (osPfsInitPak2 / osPfsReSizeFile / osGbpakInit) that calls these __os* internals
// DIRECTLY rather than going through libultra's high-level osPfs* API (which this runtime HLE's at the
// file level above). The runtime never implemented these raw building blocks, so the PD link failed on
// 10 unresolved __os*_recomp externals. ultramodern originally shipped the whole pak file as
// PFS_ERR_NOPACK stubs; matching that, these report "no Controller Pak inserted" so a game's own pak
// layer cleanly falls back to defaults and BOOTS (saves via such a private layer are a later concern —
// the high-level osPfs* HLE above already backs cart/standard-API saves). Any game using the standard
// libultra osPfs* API is unaffected (it never reaches these). NOPACK is the most robustly-handled case
// in N64 titles (playing without a memory pak), so this is the safe general default.
//
// ── Raw 32KB Controller Pak image (low-level block I/O) ───────────────────────
// The high-level osPfs* HLE above serves file-level saves. Two LOW-LEVEL paths move raw 32-byte blocks
// and must hit ONE shared image so detection + saves stay consistent: (1) the raw-SI joybus 0x02/0x03
// commands (si.cpp, for hand-rolled controller drivers like KI Gold), and (2) libultra's
// __osContRamRead/Write below (used by games with a private pak layer, e.g. Perfect Dark). The image is
// lazily zero-created + persisted to controller_pak_image.bin in the per-game save dir; a blank pak reads
// as "needs format" and the game formats it through these writes, exactly like a fresh pak on hardware.
static std::array<uint8_t, 0x8000> g_pak_image{};
static bool                        g_pak_image_loaded = false;

static std::filesystem::path pak_image_path() {
    std::filesystem::path base = ultramodern::get_save_file_path();
    if (base.empty()) return {};
    // ONE CONTROLLER PAK PER GAME AND PER REVISION.
    //
    // This used to be a FIXED name in the save directory, on the belief - stated in the comment at
    // pak_path() - that the directory is already per-game. It is not: the save files are named
    // <game>_<region>.bin inside ONE shared folder, so every title that ever ran shared a single
    // 32 KB pak. A real Controller Pak holds 16 notes across 123 pages, so it fills, and then every
    // game that wants to save stops on its own "pak full" prompt while still rendering happily.
    //
    // MEASURED 2026-09-08, the shared image on this machine: 7 of 16 directory entries used and
    // 13 of 123 pages free. Turok: Rage Wars sat on "CONTROLLER PAK 1 FULL / GAME CANNOT BE SAVED"
    // at 30.5 fps, which is the documented 19-game class this file's own header describes, and is
    // why a pak notice on the regression trio has always been treated as red.
    //
    // The save file name already encodes the game AND its revision, so its stem is the right key -
    // no new identity, no guessing. Games that ran before keep their notes in the old shared file,
    // which is left on disk untouched; each game now starts from a freshly formatted empty pak.
    std::string stem = base.stem().string();
    if (stem.empty()) stem = "controller";
    return base.parent_path() / (stem + "_controller_pak.bin");
}
static void pak_image_persist();

// ── Faithful N64 Controller Pak FORMAT (a fresh image is born VALID, not all-zeros) ───────────────
// A blank (all-zero) pak fails the game's own libultra init: osPfsInitPak -> __osCheckId reads the ID
// block, the checksum mismatches (PFS_ID_BROKEN), and it bails before ever saving. So we format a fresh
// image as a valid empty N64 Controller Pak, bit-exact to libultra
// (oot_decomp/src/libultra/io/{contpfs,pfsinitpak,pfschecker}.c). 1-bank 32KB pak, BLOCKSIZE=32, 8
// blocks/page, 128 pages: page0=ID/label, page1=inode, page2=minode-mirror, pages3-4=dir(16 entries),
// pages5-127=data. Block addrs: ID copies @1,3,4,6 (PFS_ID_*AREA), label @7, inode @8, minode @16,
// dir @24, inodeStartPage=5. Both the high-level osPfs* HLE and the raw __osContRam* path share this
// one image, so the pak is one coherent device. ([[project_controller_pak_unification]])
namespace {
constexpr uint32_t PAK_BLK_SIZE   = 32;
constexpr uint32_t PAK_DEF_DIR_PG = 2;   // DEF_DIR_PAGES
constexpr uint16_t PAK_PG_FREE    = 3;   // PFS_PAGE_NOT_USED
inline uint16_t pak_be16(const uint8_t* p){ return (uint16_t)((p[0] << 8) | p[1]); }
inline void     pak_wbe16(uint8_t* p, uint16_t v){ p[0] = (uint8_t)(v >> 8); p[1] = (uint8_t)v; }
inline void     pak_wbe32(uint8_t* p, uint32_t v){ pak_wbe16(p, (uint16_t)(v >> 16)); pak_wbe16(p + 2, (uint16_t)v); }
inline uint8_t* pak_blk(uint32_t blk){ return &g_pak_image[blk * PAK_BLK_SIZE]; }   // blk 0..1023

// libultra __osIdCheckSum: sum / sum-of-complements over the first 28 bytes (14 u16 words) of the ID.
void pak_id_checksum(const uint8_t* id, uint16_t* cksum, uint16_t* icksum) {
    uint16_t c = 0, ic = 0;
    for (int i = 0; i < 28; i += 2) { uint16_t d = pak_be16(id + i); c = (uint16_t)(c + d); ic = (uint16_t)(ic + (uint16_t)~d); }
    *cksum = c; *icksum = ic;
}
bool pak_image_is_formatted() {
    const uint8_t* id = pak_blk(1);            // PFS_ID_0AREA
    uint16_t ck, ick; pak_id_checksum(id, &ck, &ick);
    return pak_be16(id + 0x1C) == ck && pak_be16(id + 0x1E) == ick && (pak_be16(id + 0x18) & 1);
}
void pak_image_format() {
    g_pak_image.fill(0);
    // ID block (__OSPackId, big-endian): deviceid bit0=1 (valid device) REQUIRED; banks=1; checksums.
    uint8_t id[PAK_BLK_SIZE] = {0};
    pak_wbe32(id + 0x00, 0xFFFFFFFFu);         // repaired = -1
    pak_wbe16(id + 0x18, 0x0001u);             // deviceid (bit0 = valid)
    id[0x1A] = 1;                              // banks
    id[0x1B] = 0;                              // version (OS_PFS_VERSION_LO)
    uint16_t ck, ick; pak_id_checksum(id, &ck, &ick);
    pak_wbe16(id + 0x1C, ck); pak_wbe16(id + 0x1E, ick);
    for (uint32_t b : {1u, 3u, 4u, 6u}) std::memcpy(pak_blk(b), id, PAK_BLK_SIZE);  // PFS_ID_{0,1,2,3}AREA
    // inode table (page1=blk8) + mirror (page2=blk16): u16 page entries; data pages [5..127]=free(3),
    // inodePage[0].page byte = __osSumcalc(entries[5..127]).
    uint8_t inode[256] = {0};
    const int start_pg = 1 + (int)PAK_DEF_DIR_PG + 2 * 1;   // inodeStartPage = 5
    for (int pg = start_pg; pg < 128; pg++) pak_wbe16(inode + pg * 2, PAK_PG_FREE);
    uint32_t sum = 0;
    for (int b = start_pg * 2; b < 128 * 2; b++) sum += inode[b];
    inode[1] = (uint8_t)(sum & 0xFF);          // __OSInodeUnit{bank@0, page@1}: checksum in .page
    std::memcpy(pak_blk(8),  inode, 256);
    std::memcpy(pak_blk(16), inode, 256);
    // dir table (pages 3-4 = blocks 24..39): 16 __OSDir entries, all zero (company=0,game=0 => empty).
}

// ── The re-homed single-bank N64 pak filesystem ON g_pak_image (faithful to libultra osPfs*) ──────
// The high-level osPfs* HLE (wrappers below) call these; the game's OWN low-level code hits the SAME
// g_pak_image via __osContRam* -> recomp_pak_raw_* (identical byte offsets), so the two are coherent.
// 1-bank geometry: inode @blk8, minode @blk16, dir @blk24 (16 entries), data pages 5..127.
inline uint32_t pak_be32(const uint8_t* p){ return ((uint32_t)pak_be16(p) << 16) | pak_be16(p + 2); }
constexpr int FS_INODE_BLK = 8, FS_MINODE_BLK = 16, FS_DIR_BLK = 24, FS_NDIR = 16, FS_FIRST_DATA = 5, FS_NPAGE = 128;
constexpr uint16_t FS_IP_EOF = 1, FS_IP_FREE = 3;   // PFS_EOF / PFS_PAGE_NOT_USED
constexpr uint8_t  FS_DIR_WRITTEN = 2;              // PFS_WRITTEN
inline uint16_t fs_ino(int pg){ return pak_be16(pak_blk(FS_INODE_BLK) + pg * 2); }
inline void fs_ino_set(int pg, uint16_t v){ pak_wbe16(pak_blk(FS_INODE_BLK) + pg * 2, v); pak_wbe16(pak_blk(FS_MINODE_BLK) + pg * 2, v); }
inline void fs_ino_resum(){
    const uint8_t* it = pak_blk(FS_INODE_BLK); uint32_t s = 0;
    for (int b = FS_FIRST_DATA * 2; b < FS_NPAGE * 2; b++) s += it[b];
    pak_blk(FS_INODE_BLK)[1] = (uint8_t)s; pak_blk(FS_MINODE_BLK)[1] = (uint8_t)s;
}
inline uint8_t* fs_dir(int i){ return pak_blk(FS_DIR_BLK + i); }   // __OSDir, 32 bytes

// find a file by company/game/(name)/(ext); company==0&&game==0 finds a FREE dir slot. returns idx or -1.
int pakfs_find(uint16_t company, uint32_t game, const uint8_t* name16, const uint8_t* ext4){
    for (int i = 0; i < FS_NDIR; i++){
        const uint8_t* d = fs_dir(i);
        if (pak_be16(d + 4) == company && pak_be32(d + 0) == game){
            bool ok = true;
            if (name16) for (int k = 0; k < 16; k++) if (d[0x10 + k] != name16[k]){ ok = false; break; }
            if (ok && ext4) for (int k = 0; k < 4; k++) if (d[0x0C + k] != ext4[k]){ ok = false; break; }
            if (ok) return i;
        }
    }
    return -1;
}
int pakfs_free_bytes(){ int pg = 0; for (int p = FS_FIRST_DATA; p < FS_NPAGE; p++) if (fs_ino(p) == FS_IP_FREE) pg++; return pg * 256; }
int pakfs_numfiles(){ int u = 0; for (int i = 0; i < FS_NDIR; i++){ const uint8_t* d = fs_dir(i); if (pak_be16(d + 4) || pak_be32(d + 0)) u++; } return u; }

// allocate a file: free dir slot + chain enough free pages. returns dir idx, or negative PFS_* error.
int pakfs_alloc(uint16_t company, uint32_t game, const uint8_t* name16, const uint8_t* ext4, int sizeBytes){
    if (company == 0 || game == 0) return -PFS_ERR_INVALID;
    if (pakfs_find(company, game, name16, ext4) >= 0) return -PFS_ERR_EXIST;
    int need = (sizeBytes + 255) / 256;
    if (need <= 0) return -PFS_ERR_INVALID;
    if (sizeBytes > pakfs_free_bytes()) return -PFS_DATA_FULL;
    int slot = pakfs_find(0, 0, nullptr, nullptr);
    if (slot < 0) return -PFS_DIR_FULL;
    int pages[FS_NPAGE]; int n = 0;
    for (int p = FS_FIRST_DATA; p < FS_NPAGE && n < need; p++) if (fs_ino(p) == FS_IP_FREE) pages[n++] = p;
    if (n < need) return -PFS_ERR_INCONSISTENT;
    for (int k = 0; k < need; k++) fs_ino_set(pages[k], (k + 1 < need) ? (uint16_t)pages[k + 1] : FS_IP_EOF);
    fs_ino_resum();
    uint8_t* d = fs_dir(slot); std::memset(d, 0, 32);
    pak_wbe32(d + 0, game); pak_wbe16(d + 4, company);
    d[0x06] = 0; d[0x07] = (uint8_t)pages[0];   // start_page = bank0, first page
    if (ext4)  std::memcpy(d + 0x0C, ext4, 4);
    if (name16) std::memcpy(d + 0x10, name16, 16);
    return slot;
}
// block-granular file read/write (host buffer <-> data pages), traversing the inode page-chain.
int pakfs_rw(int fileno, bool write, int offset, int size, uint8_t* host){
    if (fileno < 0 || fileno >= FS_NDIR) return PFS_ERR_INVALID;
    if (size <= 0 || (size % 32) || offset < 0 || (offset % 32)) return PFS_ERR_INVALID;
    uint8_t* d = fs_dir(fileno);
    if (pak_be16(d + 4) == 0 || pak_be32(d + 0) == 0) return PFS_ERR_INVALID;
    int curPage = d[0x07];
    if (curPage < FS_FIRST_DATA || curPage >= 0x80) return PFS_ERR_INCONSISTENT;
    if (!write && !(d[0x08] & FS_DIR_WRITTEN)) return PFS_ERR_BAD_DATA;
    int curBlock = offset / 32;
    while (curBlock >= 8){ uint16_t nx = fs_ino(curPage); if (nx < FS_FIRST_DATA || nx >= 0x80) return (nx == FS_IP_EOF) ? PFS_ERR_INVALID : PFS_ERR_INCONSISTENT; curPage = nx; curBlock -= 8; }
    for (int blocks = size / 32; blocks > 0; blocks--){
        if (curBlock == 8){ uint16_t nx = fs_ino(curPage); if (nx < FS_FIRST_DATA || nx >= 0x80) return (nx == FS_IP_EOF) ? PFS_ERR_INVALID : PFS_ERR_INCONSISTENT; curPage = nx; curBlock = 0; }
        uint8_t* img = pak_blk(curPage * 8 + curBlock);
        if (write) std::memcpy(img, host, 32); else std::memcpy(host, img, 32);
        host += 32; curBlock++;
    }
    if (write && !(d[0x08] & FS_DIR_WRITTEN)) d[0x08] |= FS_DIR_WRITTEN;
    return PFS_OK;
}
int pakfs_delete(uint16_t company, uint32_t game, const uint8_t* name16, const uint8_t* ext4){
    int i = pakfs_find(company, game, name16, ext4);
    if (i < 0) return PFS_ERR_INVALID;
    uint8_t* d = fs_dir(i);
    for (int pg = d[0x07], guard = 0; pg >= FS_FIRST_DATA && pg < 0x80 && guard < FS_NPAGE; guard++){
        uint16_t nx = fs_ino(pg); fs_ino_set(pg, FS_IP_FREE); if (nx == FS_IP_EOF) break; pg = nx;
    }
    fs_ino_resum(); std::memset(d, 0, 32);
    return PFS_OK;
}
// fill OSPfsState-style fields; returns false if the slot is empty. size = page-count * 256.
bool pakfs_state(int fileno, uint32_t* game, uint16_t* company, uint8_t ext4[4], uint8_t name16[16], uint32_t* sizeBytes){
    if (fileno < 0 || fileno >= FS_NDIR) return false;
    const uint8_t* d = fs_dir(fileno);
    if (pak_be16(d + 4) == 0 && pak_be32(d + 0) == 0) return false;
    *game = pak_be32(d + 0); *company = pak_be16(d + 4);
    std::memcpy(ext4, d + 0x0C, 4); std::memcpy(name16, d + 0x10, 16);
    int pages = 0, pg = d[0x07];
    while (pg >= FS_FIRST_DATA && pg < 0x80 && pages <= FS_NPAGE){ pages++; uint16_t nx = fs_ino(pg); if (nx == FS_IP_EOF) break; pg = nx; }
    *sizeBytes = (uint32_t)pages * 256;
    return true;
}

// One-time migration: import any legacy CP64 virtual store (controller_pak.bin / g_files) into the shared
// image, so games that previously saved through the old high-level HLE (e.g. cv64) keep their saves.
void pakfs_migrate_legacy(){
    pak_load();   // controller_pak.bin -> g_files (no-op if the legacy file is absent, e.g. amshpc)
    for (size_t i = 0; i < g_files.size(); i++){
        const PakFile& pf = g_files[i];
        if (!pf.used) continue;
        int slot = pakfs_alloc(pf.company, pf.game, pf.name, pf.ext, (int)pf.data.size());
        if (slot < 0) continue;
        size_t padded = (pf.data.size() + 31) & ~size_t(31);   // pad up to a 32-byte block
        if (padded){ std::vector<uint8_t> buf(padded, 0); std::memcpy(buf.data(), pf.data.data(), pf.data.size()); pakfs_rw(slot, true, 0, (int)padded, buf.data()); }
    }
}
} // namespace

static void pak_image_load() {
    if (g_pak_image_loaded) return;
    g_pak_image_loaded = true;
    g_pak_image.fill(0);
    std::filesystem::path p = pak_image_path();
    bool valid = false;
    if (!p.empty() && std::filesystem::exists(p)) {
        std::ifstream f(p, std::ios::binary);
        f.read(reinterpret_cast<char*>(g_pak_image.data()), (std::streamsize)g_pak_image.size());
        valid = pak_image_is_formatted();   // reject the legacy all-zero/garbage image
        PAKLOG("loaded controller_pak_image.bin (formatted=%d)", (int)valid);
    }
    if (!valid) {
        pak_image_format();                 // born as a valid empty N64 Controller Pak
        pakfs_migrate_legacy();             // import any legacy CP64 (controller_pak.bin) saves so cv64 etc. keep them
        pak_image_persist();
        PAKLOG("formatted a fresh empty Controller Pak image");
    }
}
static void pak_image_persist() {
    std::filesystem::path p = pak_image_path();
    if (p.empty()) return;
    std::error_code ec; std::filesystem::create_directories(p.parent_path(), ec);
    std::ofstream f(p, std::ios::binary | std::ios::trunc);
    if (f) f.write(reinterpret_cast<const char*>(g_pak_image.data()), (std::streamsize)g_pak_image.size());
}

// ── THE OSPfs STRUCT CONTRACT ────────────────────────────────────────────────────────────────────
// osPfsInitPak's real product is not its return code — it is the CALLER'S OSPfs, which libultra
// leaves fully described (queue, channel, the 32-byte pak id, the label, and the whole filesystem
// geometry). This runtime used to write two fields, status and channel, leaving `queue` NULL and
// every geometry field zero.
//
// That is invisible for as long as a game stays inside our osPfs* HLE, and fatal the moment the
// game's OWN low-level pak code runs — which is the common case, because a cart's __osContRamRead
// is rarely name-matched and so is recompiled as anonymous guest code. It issues its SI DMA and
// then blocks on `pfs->queue`; a NULL there is received against a wild queue and dropped. Caught
// verbatim in razorfreestylescoo's log, the two lines adjacent:
//     [pakcmd] READ  ch=0 addr=0x0035 blk=0x0020 tx=3 rx=33 -> FFFFFFFF crc=52
//     [mq_guard] do_recv DROP wild queue mq=0x00000000 func=0x00000000
// The read never completes for the guest, its pak layer concludes the device is unusable, and the
// game parks on a "no / bad / full Controller Pak" prompt while still rendering at 60fps — which
// is exactly the 19-game class on the 08-16 eyes board (and why the prompts disagree with each
// other: each title words its own probe's failure differently).
//
// Every field below is derived the way libultra derives it (osPfsInitPak), from the SAME image the
// raw joybus path serves, so the high-level HLE and the game's own low-level code are describing
// ONE coherent device rather than two.
//   OSPfs (PR/os_pfs.h): status@0 queue@4 channel@8 id[32]@0xC label[32]@0x2C version@0x4C
//   dir_size@0x50 inode_table@0x54 minode_table@0x58 dir_table@0x5C inode_start_page@0x60
//   banks@0x64 activebank@0x65
static void pak_fill_pfs(uint8_t* rdram, gpr pfs_va, gpr queue_va, int channel) {
    if (pfs_va == 0) {
        PAKLOG("fill_pfs: NULL OSPfs pointer, nothing to describe");
        return;
    }
    constexpr int PFS_ONE_PAGE = 8;     // blocks per page
    constexpr int DEF_DIR_PAGES = 2;
    const uint8_t* id    = pak_blk(1);  // PFS_ID_0AREA — the same block the joybus path serves
    const uint8_t* label = pak_blk(7);  // PFS_LABEL_AREA
    // banks/version come from the image's own id block; a 0 bank count would zero the geometry
    // below, so fall back to the 1-bank 32KB pak this runtime formats.
    const int banks   = id[0x1A] ? id[0x1A] : 1;
    const int version = id[0x1B];

    MEM_W(0x00, pfs_va) = PFS_INITIALIZED;
    MEM_W(0x04, pfs_va) = static_cast<int32_t>(queue_va);   // ← the field whose absence killed the class
    MEM_W(0x08, pfs_va) = channel;
    for (int i = 0; i < 32; i++) MEM_B((gpr)(0x0C + i), pfs_va) = static_cast<int8_t>(id[i]);
    for (int i = 0; i < 32; i++) MEM_B((gpr)(0x2C + i), pfs_va) = static_cast<int8_t>(label[i]);
    MEM_W(0x4C, pfs_va) = version;
    MEM_W(0x50, pfs_va) = DEF_DIR_PAGES * PFS_ONE_PAGE;             // dir_size   = 16 entries
    MEM_W(0x54, pfs_va) = 1 * PFS_ONE_PAGE;                         // inode_table  = block 8
    MEM_W(0x58, pfs_va) = (1 + banks) * PFS_ONE_PAGE;               // minode_table = block 16
    MEM_W(0x5C, pfs_va) = (1 + banks) * PFS_ONE_PAGE + banks * PFS_ONE_PAGE;  // dir_table = block 24
    MEM_W(0x60, pfs_va) = 1 + DEF_DIR_PAGES + 2 * banks;            // inode_start_page = 5
    MEM_B(0x64, pfs_va) = static_cast<int8_t>(banks);
    MEM_B(0x65, pfs_va) = 0;                                        // activebank (libultra selects 0)
    PAKLOG("fill_pfs pfs=0x%08X queue=0x%08X ch=%d banks=%d ver=%d dir=%d inode=%d minode=%d dirtbl=%d start=%d",
           (uint32_t)pfs_va, (uint32_t)queue_va, channel, banks, version,
           (int)MEM_W(0x50, pfs_va), (int)MEM_W(0x54, pfs_va), (int)MEM_W(0x58, pfs_va),
           (int)MEM_W(0x5C, pfs_va), (int)MEM_W(0x60, pfs_va));
}

// N64 controller-pak 8-bit data CRC over a 32-byte block (the canonical cen64/MAME algorithm; runs one
// extra trailing iteration with no data bit). libultra's __osContRamRead/Write verify the CRC byte the
// pak returns — a wrong value reads as PFS_ERR_CONTRFAIL, so this must match hardware exactly.
extern "C" uint8_t recomp_pak_data_crc(const uint8_t* data) {
    uint8_t crc = 0;
    for (int i = 0; i <= 32; i++) {
        for (int bit = 0x80; bit != 0; bit >>= 1) {
            uint8_t xor_tap = (crc & 0x80) ? (uint8_t)0x85 : (uint8_t)0x00;
            crc = (uint8_t)(crc << 1);
            if (i < 32 && (data[i] & bit)) crc |= 1u;
            crc ^= xor_tap;
        }
    }
    return crc;
}

// Raw 32-byte block read/write at a joybus pak ADDRESS (low 5 bits = address-CRC, masked off here to get
// the byte offset: block = addr>>5, byte_off = block*32 = addr&0xFFE0). Shared by si.cpp (joybus 0x02/0x03)
// and __osContRamRead/Write below. One virtual pak (controller 0); the status layer only advertises a pak
// on ch0, so callers only target it.
extern "C" void recomp_pak_raw_read(int channel, uint16_t addr, uint8_t* out32) {
    (void)channel;
    std::lock_guard lock(g_mutex);
    pak_image_load();
    uint32_t off = (uint32_t)(addr & 0xFFE0u);
    for (int k = 0; k < 32; k++) out32[k] = (off + (uint32_t)k < g_pak_image.size()) ? g_pak_image[off + k] : (uint8_t)0;
}
extern "C" void recomp_pak_raw_write(int channel, uint16_t addr, const uint8_t* in32) {
    (void)channel;
    std::lock_guard lock(g_mutex);
    pak_image_load();
    uint32_t off = (uint32_t)(addr & 0xFFE0u);
    for (int k = 0; k < 32; k++) if (off + (uint32_t)k < g_pak_image.size()) g_pak_image[off + k] = in32[k];
    pak_image_persist();
}

// __osContRamRead/Write(OSMesgQueue* mq r4, int channel r5, u16 addr r6, u8* buffer r7) -> s32 error.
// Real 32-byte block I/O against the shared pak image (was: PFS_ERR_NOPACK). Baseline games use the
// high-level osPfs* HLE and never reach these; games with a private pak layer (Perfect Dark) do.
extern "C" void __osContRamRead_recomp(uint8_t* rdram, recomp_context* ctx) {
    int      channel = (int)ctx->r5;
    uint16_t addr    = (uint16_t)ctx->r6;
    gpr      buf_va  = ctx->r7;
    uint8_t data[32];
    recomp_pak_raw_read(channel, addr, data);
    for (int k = 0; k < 32; k++) MEM_B((gpr)k, buf_va) = (int8_t)data[k];
    ctx->r2 = PFS_OK;
    PAKLOG("__osContRamRead ch=%d addr=0x%04X -> OK", channel, (unsigned)addr);
}
extern "C" void __osContRamWrite_recomp(uint8_t* rdram, recomp_context* ctx) {
    int      channel = (int)ctx->r5;
    uint16_t addr    = (uint16_t)ctx->r6;
    gpr      buf_va  = ctx->r7;
    uint8_t data[32];
    for (int k = 0; k < 32; k++) data[k] = (uint8_t)MEM_BU((gpr)k, buf_va);
    recomp_pak_raw_write(channel, addr, data);
    ctx->r2 = PFS_OK;
    PAKLOG("__osContRamWrite ch=%d addr=0x%04X -> OK", channel, (unsigned)addr);
}
// __osPfsGetStatus / __osPfsSelectBank / __osPfsRWInode -> s32 PFS error.
extern "C" void __osPfsGetStatus_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = PFS_ERR_NOPACK;
    PAKLOG("__osPfsGetStatus -> NOPACK");
}
extern "C" void __osPfsSelectBank_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = PFS_ERR_NOPACK;
    PAKLOG("__osPfsSelectBank -> NOPACK");
}
extern "C" void __osPfsRWInode_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = PFS_ERR_NOPACK;
    PAKLOG("__osPfsRWInode -> NOPACK");
}
// __osCheckId / __osCheckPackId / __osRepairPackId -> s32 PFS error (no valid pak id present).
extern "C" void __osCheckId_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = PFS_ERR_NOPACK;
    PAKLOG("__osCheckId -> NOPACK");
}
extern "C" void __osCheckPackId_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = PFS_ERR_NOPACK;
    PAKLOG("__osCheckPackId -> NOPACK");
}
extern "C" void __osRepairPackId_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = PFS_ERR_NOPACK;
    PAKLOG("__osRepairPackId -> NOPACK");
}
// __osSiGetAccess / __osSiRelAccess: the internal SI-bus access mutex. The SI is HLE'd and always
// available, so acquire succeeds (0) and release is a no-op. (These gate pak access but don't fail it.)
#if 0  // [RUNG3-LLE-SI] retired: the cartridge's own recompiled driver now serves this
extern "C" void __osSiGetAccess_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram;
    ctx->r2 = 0; // SI access granted
}
#endif  // [RUNG3-LLE-SI]
#if 0  // [RUNG3-LLE-SI] retired: the cartridge's own recompiled driver now serves this
extern "C" void __osSiRelAccess_recomp(uint8_t* rdram, recomp_context* ctx) {
    (void)rdram; (void)ctx; // release: no-op
}
#endif  // [RUNG3-LLE-SI]
