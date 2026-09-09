# THE MASTER BUILD — one engine, many games.
#
# WHY THIS EXISTS (2026-09-01): build the engine once and link every game back to it. That is
# the end goal of the product: one set-up that runs every NTSC N64 recompilation.
#
# Every <game>pc/CMakeLists.txt guards its engine include with `if (NOT TARGET rt64)` (or
# `librecomp`), so when a parent project has already added the engine the game skips its own
# copy and just links. Standalone builds of each tree are completely unaffected.
#
# COST THIS REMOVES: each tree otherwise recompiles the shared engine itself (~85 rt64 objects,
# ~8 min/tree; librecomp-only ~5 min). Here the engine is built ONCE and every game after it is
# a link. That is the difference between a title-screen sweep taking weeks and taking days.
#
# USAGE
#   cmake -S _masterbuild -B _masterbuild/build -G "Visual Studio 18 2026" -A x64 \
#         -DN64PC_GAMES="sm64;shadows;cv64;robotron"
#   cmake --build _masterbuild/build --config Release -- /m:2
#                                                          ^^^^^ ALWAYS. Other work runs on
#                                                          this desktop; gate.ps1 once defaulted to
#                                                          full parallelism and ran 13 cl processes.
#
# Add games by re-running the configure with a longer -DN64PC_GAMES list; already-built targets
# are not rebuilt.
#
# EXCLUDE cv64pc_v11 / cv64pc_v12 — they add_subdirectory their OWN rt64 copy, which would
#   collide with the shared `rt64` target. They are a small deliberate delta on a revision tree
#   (08-29) and are not part of the march.

cmake_minimum_required(VERSION 3.21)

# THESE TWO LINES ARE LOAD-BEARING — DO NOT "TIDY" THEM AWAY. 
# Every <game>pc/CMakePresets.json configures with CMAKE_CXX_FLAGS="/MP" CMAKE_C_FLAGS="/MP",
# which OVERRIDES CMake's stock MSVC default of "/DWIN32 /D_WINDOWS /EHsc". So every working
# binary this project has ever shipped was compiled **WITHOUT /EHsc**.
#
# MEASURED 2026-09-01: a master build that took the stock default (i.e. WITH /EHsc) produced a
# shadowspc.exe that DIED BEFORE t=15 ON 4 OF 4 RUNS, never rendering a frame — while the exact
# same source built per-tree (without /EHsc) ran at 36-37 fps. Three-way A/B: 08-30 binary runs,
# current-source per-tree build runs, current-source master build dies. The ONLY difference in the
# whole generated Release compile block was <ExceptionHandling>Sync vs empty.
# WHY IT MATTERS HERE: the bare-metal scheduler throws across FIBER boundaries to unwind threads
# (osDestroyThread throws thread_terminated by design; the C4297 warning there is expected).
# Changing the exception model changes unwinding, and the fiber games die.
# These must be set BEFORE project() so they are not overwritten by the platform defaults.
set(CMAKE_CXX_FLAGS "/MP" CACHE STRING "match <game>pc/CMakePresets.json — NOT the MSVC default" FORCE)
set(CMAKE_C_FLAGS   "/MP" CACHE STRING "match <game>pc/CMakePresets.json — NOT the MSVC default" FORCE)

project(n64pc_master LANGUAGES C CXX)

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(N64PC_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/.." CACHE PATH "N64PC root")
get_filename_component(N64PC_ROOT "${N64PC_ROOT}" ABSOLUTE)

# ── The same engine configuration every game tree sets for itself ─────────────
set(RT64_STATIC ON CACHE BOOL "" FORCE)
if (WIN32)
    set(SDL2_INCLUDE_DIRS
        "${N64PC_ROOT}/engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/include"
        CACHE STRING "" FORCE)
    set(SDL2_LIBRARIES "SDL2" "SDL2main" CACHE STRING "" FORCE)
    link_directories("${N64PC_ROOT}/engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/lib/x64")
    add_compile_definitions(NOMINMAX)
else()
    find_package(SDL2 REQUIRED)
endif()

# ── The engine, ONCE ──────────────────────────────────────────────────────────
# Release configuration (Recompilator step 4; PACKAGING_FIRST_GAME S5): one option, one definition the engine
# reads. OFF = the lab (F1..F4 dev tools on). ON = a shipped build: dev tools off. Configure a SEPARATE build
# directory for it - the engine objects differ.
option(N64PC_RELEASE "Release configuration: RT64 dev tools off (F1..F4)" OFF)
if (N64PC_RELEASE)
    add_compile_definitions(N64PC_RELEASE=1)
endif()
add_subdirectory("${N64PC_ROOT}/engine/rt64"    rt64_build)
add_subdirectory("${N64PC_ROOT}/engine/runtime" runtime_build)   # ultramodern + librecomp

# ── The games ─────────────────────────────────────────────────────────────────
set(N64PC_GAMES "" CACHE STRING "Semicolon-separated game tokens WITHOUT the pc suffix")

if (NOT N64PC_GAMES)
    message(FATAL_ERROR
        "No games selected. Pass -DN64PC_GAMES=\"sm64;shadows;cv64\" (tokens have NO 'pc' suffix).")
endif()

foreach(_g IN LISTS N64PC_GAMES)
    set(_tree "${N64PC_ROOT}/${_g}pc")
    if (NOT EXISTS "${_tree}/CMakeLists.txt")
        message(WARNING "master: skipping '${_g}' — no ${_g}pc/CMakeLists.txt")
        continue()
    endif()
    # Each game keeps its own binary dir so their generated/object trees never mix.
    add_subdirectory("${_tree}" "app_${_g}")

    # Emit the exe where the EXISTING harness already looks, so nothing downstream changes.
    # driver.ps1 hardcodes <tree>/build/windows-x64/Release/<game>pc.exe (and gate.ps1 /
    # game_run.ps1 use the same convention). Redirecting the runtime output means a
    # master-built exe is found by every existing tool with no edits to any of them.
    # The trees' own POST_BUILD steps copy SDL2/dxcompiler/dxil next to the exe via
    # $<TARGET_FILE_DIR:...>, so the DLLs follow the redirect automatically.
    if (TARGET "${_g}pc")
        set_target_properties("${_g}pc" PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${_tree}/build/windows-x64/Release"
            RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${_tree}/build/windows-x64/Debug"
            RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${_tree}/build/windows-x64/RelWithDebInfo")
        message(STATUS "master: added game '${_g}' -> ${_tree}/build/windows-x64/Release")
    else()
        message(WARNING "master: '${_g}' added but no target named '${_g}pc' — exe path not redirected")
    endif()
endforeach()

# ── The launcher: target `recompilator`, the one program's front door ─────────
# Not a game (no `pc` suffix, no ROM, no recompiled functions), so it is not in N64PC_GAMES; it
# links the same engine objects the games link. It sets its own RUNTIME_OUTPUT_DIRECTORY, so the
# exe lands at launcher/build/windows-x64/Release/recompilator.exe whoever builds it.
add_subdirectory("${N64PC_ROOT}/recompilator/launcher" app_launcher)
