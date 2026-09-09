/**
 * recomp_module.h — THE GAME MODULE ABI (Recompilator UI step 3, 2026-09-06).
 *
 * ONE program: `Recompilator.exe` is the host (MSVC; it owns the window, the renderer, SDL audio
 * and SDL input, the catalog and the build driver). A game is a `<game>.dll` built by the bundled
 * llvm-mingw clang from the emitted C — nothing but the ROM-derived and per-game pieces.
 *
 * THE BOUNDARY IS PURE C, and it is C for a reason (toolchain_20260906.md §4.2):
 *   Rule 1 — no C++ crosses it. No mangled names (MSVC mangles differently from clang/Itanium),
 *            no std:: types, no exceptions, no RTTI. Everything below is a scalar, a pointer, or
 *            a POD struct of those.
 *   Rule 2 — no `long double` (MSVC 64-bit vs mingw 80-bit x87). Nothing here uses it.
 *   Rule 3 — one owner per allocation. Every pointer below is STATIC STORAGE inside the module;
 *            the host never frees anything the module hands it, and no FILE* crosses.
 *   Rule 4 — MS x64 calling convention on both sides, which is what makes this work at all.
 *
 * The module exports exactly ONE symbol:
 *
 *     const RecompModuleV1* recomp_module_query(uint32_t host_abi_version);
 *
 * It returns NULL if it cannot serve that ABI version. The descriptor and everything it points at
 * live for the life of the DLL.
 *
 * NEVER PER-GAME CODE IN THE HOST: every game-specific value the runtime needs is a field below.
 */
#ifndef RECOMPILATOR_MODULE_H
#define RECOMPILATOR_MODULE_H

#include <stdint.h>
#include <stddef.h>

#define RECOMP_MODULE_ABI_VERSION 1u

/* The name of the one exported symbol, so the host never spells it twice. */
#define RECOMP_MODULE_QUERY_SYMBOL "recomp_module_query"

#ifdef __cplusplus
extern "C" {
#endif

/* A recompiled guest function: `void f(uint8_t* rdram, recomp_context* ctx)`.
 * `recomp_context` is opaque here on purpose — the host casts to recomp_func_t*, the module casts
 * from its own recomp.h type. Both are the same POD pointer. */
typedef void (*RecompModuleGuestFunc)(uint8_t* rdram, void* ctx);

/* A recompiled RSP microcode entry: `RspExitReason f(uint8_t* rdram, uint32_t ucode_addr)`.
 * RspExitReason is an `enum class` with int underlying type — returned in EAX by both toolchains. */
typedef int (*RecompModuleUcodeFunc)(uint8_t* rdram, uint32_t ucode_addr);

/* `const OSTask*` is passed as void* so this header stays free of ultra64.h. The module includes
 * ultra64.h itself and casts; the layout is a plain C union in both builds. */
typedef RecompModuleUcodeFunc (*RecompModuleGetUcode)(const void* task);
typedef void (*RecompModuleCaptureGfx)(uint8_t* rdram, const void* task);

typedef void (*RecompModuleVoidFunc)(void);

/* recomp::SaveType, by value. Keep in step with librecomp/game.hpp. */
enum RecompModuleSaveType {
    RECOMP_MODULE_SAVE_NONE = 0,
    RECOMP_MODULE_SAVE_EEP4K = 1,
    RECOMP_MODULE_SAVE_EEP16K = 2,
    RECOMP_MODULE_SAVE_SRAM = 3,
    RECOMP_MODULE_SAVE_FLASHRAM = 4,
    RECOMP_MODULE_SAVE_ALLOW_ALL = 5
};

/* One entry of the content-hash ucode registry (librecomp rsp.hpp register_ucode).
 * verify_len == 0 means "no verify window" (the three-argument registration). */
typedef struct RecompModuleUcodeEntry {
    uint64_t              hash;
    const char*           name;
    RecompModuleUcodeFunc fn;
    uint32_t              verify_off;
    uint32_t              verify_len;
    uint64_t              verify_fnv;
} RecompModuleUcodeEntry;

/* One pre-extracted NI overlay content section (librecomp overlays.cpp NiSectionData).
 * Layout MUST match `struct NiSectionData { uint32_t lma; const uint8_t* data; uint32_t size; }`. */
typedef struct RecompModuleNiSection {
    uint32_t       lma;
    const uint8_t* data;
    uint32_t       size;
} RecompModuleNiSection;

typedef struct RecompModuleV1 {
    /* ── header ──────────────────────────────────────────────────────────────────────────── */
    uint32_t abi_version;   /* == RECOMP_MODULE_ABI_VERSION */
    uint32_t struct_size;   /* == sizeof(RecompModuleV1); a mismatch is a hard refusal */

    /* ── identity (recomp::GameEntry) ────────────────────────────────────────────────────── */
    uint64_t              rom_hash;            /* XXH3 of the ROM, as the catalog recorded it   */
    const char*           internal_name;       /* the cart header's name                        */
    const char*           game_id;             /* utf-8; becomes recomp::GameEntry::game_id     */
    const char*           mod_game_id;         /* "" when the game hosts no mods                */
    int32_t               save_type;           /* RecompModuleSaveType                          */
    uint32_t              entrypoint_address;  /* guest VRAM of the entrypoint                  */
    RecompModuleGuestFunc entrypoint;          /* recomp_entrypoint                             */
    RecompModuleGuestFunc thread_create_callback; /* may be NULL                                */
    RecompModuleGuestFunc on_init_callback;       /* may be NULL                                */

    /* ── the recompiled section tables (recomp_overlays.inl) ─────────────────────────────── */
    void*  code_sections;          /* SectionTableEntry[] — static storage in the module        */
    size_t num_code_sections;
    size_t total_num_sections;
    int*   overlays_by_index;
    size_t overlays_by_index_len;

    /* ── RSP ─────────────────────────────────────────────────────────────────────────────── */
    RecompModuleGetUcode          get_rsp_microcode;  /* required                               */
    RecompModuleCaptureGfx        capture_gfx;        /* may be NULL                            */
    const RecompModuleUcodeEntry* ucodes;             /* content-hash registry; may be NULL     */
    size_t                        num_ucodes;

    /* ── the engine debt, now carried BY THE GAME instead of by the host ─────────────────── */
    RecompModuleGuestFunc        gamestate_change;    /* CV64's NI boot hook; NULL for everyone else */
    const RecompModuleNiSection* ni_sections;         /* NI overlay content catalog; may be NULL */
    size_t                       num_ni_sections;

    /* ── ultramodern::MessageQueueControl ────────────────────────────────────────────────── */
    uint8_t requeue_timer;
    uint8_t requeue_sp;
    uint8_t requeue_si;
    uint8_t requeue_ai;
    uint8_t requeue_vi;
    uint8_t requeue_pi;
    uint8_t requeue_dp;
    uint8_t reserved_pad;

    /* ── lifecycle (either may be NULL) ──────────────────────────────────────────────────── */
    RecompModuleVoidFunc module_init;      /* called once, before start_game()                  */
    RecompModuleVoidFunc module_shutdown;  /* called once, after the game stops                 */
} RecompModuleV1;

typedef const RecompModuleV1* (*RecompModuleQueryFunc)(uint32_t host_abi_version);

#ifdef __cplusplus
}
#endif

#endif /* RECOMPILATOR_MODULE_H */
