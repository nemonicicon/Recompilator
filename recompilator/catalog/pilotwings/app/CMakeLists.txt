cmake_minimum_required(VERSION 3.20)
project(pilotwingspc LANGUAGES C CXX)

# console seam ported from snowkidspc (2026-07-31 batch)
# GPU-less target build (PLAN V3 amendment A): preservation core only, RT64 excluded entirely.
option(RDPC_CONSOLE_ONLY "Console-only build: no RT64 anywhere (implies RDPC_CAPTURE)" OFF)
if (RDPC_CONSOLE_ONLY)
    set(RDPC_CAPTURE ON CACHE BOOL "" FORCE)
endif()

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ── RT64 configuration ────────────────────────────────────────────────────────
set(RT64_STATIC ON CACHE BOOL "" FORCE)
if (WIN32)
    set(SDL2_INCLUDE_DIRS
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/include"
        CACHE STRING "" FORCE)
    set(SDL2_LIBRARIES "SDL2" "SDL2main" CACHE STRING "" FORCE)
    link_directories(
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/lib/x64")
else()
    # Linux / macOS: use the system SDL2 (the bundled win32 deps are Windows-only).
    find_package(SDL2 REQUIRED)
endif()

if (WIN32)
    add_compile_definitions(NOMINMAX)
endif()

# ── The agnostic engine (single shared copy: ../engine) ───────────────────────
# Built ONCE. Under the sweep master project (recompilator builds many games in one
# tree) the engine targets already exist, so this is skipped — no rebuild, no
# double-definition. Built standalone, the engine is added here as before.
if (NOT TARGET librecomp)
    if (NOT RDPC_CONSOLE_ONLY)
        add_subdirectory(../engine/rt64 rt64_build)
    endif()
    add_subdirectory(../engine/runtime runtime_build)   # adds ultramodern + librecomp
endif()

# ── Recompiled C functions library ────────────────────────────────────────────
# N64Recomp outputs funcs_0.c … funcs_N.c (regenerable from ../pilotwings/pilotwings.toml).
# rsp/aspMain.cpp (audio ucode) + rsp/f3dex2.cpp are optional — the EXISTS guards skip them.
file(GLOB RECOMP_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs/funcs_*.c")
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/aspMain.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/aspMain.cpp")
endif()
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3dex2.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3dex2.cpp")
endif()
# rsp/f3d.cpp = Pilotwings' Fast3D (a +0x20 variant of sm64's) statically recompiled by our
# RSPRecomp (f3d.toml; 2026-07-12 bring-up). Compiled ONLY with -DRDPC_CAPTURE=ON — the default
# build is RT64 and contains zero capture-chain code.
option(RDPC_CAPTURE "Compile the RDP capture chain / preservation-core renderer" OFF)
if (RDPC_CAPTURE AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3d.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3d.cpp")
endif()

add_library(pilotwings_recomp STATIC ${RECOMP_SOURCES})

target_include_directories(pilotwings_recomp PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/N64Recomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/librecomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/ultramodern/include"
)

if (MSVC)
    target_compile_options(pilotwings_recomp PRIVATE /GL-)
endif()
if (NOT MSVC)
    # gcc 14 promotes implicit-function-declaration to an ERROR; recompiled C funcs call libultra
    # natives not all declared (MSVC only warns — why the desktop build passes). Match that leniency
    # (C files only) so the build reaches link; a genuinely-missing native then shows as a link error.
    target_compile_options(pilotwings_recomp PRIVATE
        $<$<COMPILE_LANGUAGE:C>:-Wno-error=implicit-function-declaration -Wno-implicit-function-declaration>)
    # FP CORRECTNESS (GENERAL — every FP-heavy game needs this on ARM/gcc): gcc at -O2 defaults to
    # -ffp-contract=fast, contracting a*b+c into a fused multiply-add and rounding ONCE instead of twice.
    # The N64 VR4300 has no FMA (each mul/add rounds separately) and the desktop MSVC build does NOT
    # contract, so ARM-gcc diverges bit-for-bit on FP-heavy recompiled math (Pilotwings' flight/camera).
    # A drifted float flips a game-logic branch and the render loop stops. Turn contraction OFF so the
    # recompiled FP matches the hardware (and the desktop). sm64 survives without it only because it is
    # far less FP-intensive.
    target_compile_options(pilotwings_recomp PRIVATE -ffp-contract=off)
    # ARM: the recompiled RSP VU (rsp_vu.hpp via rsp.hpp in aspMain.cpp) uses sse2neon.h to map
    # SSE intrinsics to NEON (x86 uses native intrinsics). Mirrors cv64pc. ARM-only.
    if (NOT (CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64|i.86|x86"))
        target_include_directories(pilotwings_recomp PUBLIC
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/thirdparty/sse2neon")
    endif()
endif()

# ── Main executable ───────────────────────────────────────────────────────────
add_executable(pilotwingspc WIN32
    src/main.cpp
    src/audio.cpp
    src/input.cpp
    src/rsp.cpp
    src/patches/os_stubs.c
    src/patches/math_patches.c
    src/patches/engine_shims.c
)

target_include_directories(pilotwingspc PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/librecomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/ultramodern/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/N64Recomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs"
)
# console seam ported from snowkidspc (2026-07-31 batch)
if (NOT RDPC_CONSOLE_ONLY)
    # RT64 headers exist only on the desktop tier — the console build must never see them.
    target_include_directories(pilotwingspc PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/hle"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/rhi"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/render"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/hlslpp/include")
endif()

if (NOT RDPC_CONSOLE_ONLY)
    target_sources(pilotwingspc PRIVATE src/rt64_renderer.cpp)
else()
    target_compile_definitions(pilotwingspc PRIVATE RDPC_CONSOLE_ONLY)
endif()

# Linux/macOS (incl. aarch64 cross): search system SDL2 FIRST so SDL.h / SDL_syswm.h resolve to the
# platform SDL, not the bundled win32-deps SDL (whose SDL_syswm.h needs windows.h). (2026-07-14)
if (NOT WIN32)
    target_include_directories(pilotwingspc BEFORE PRIVATE /usr/include/SDL2)
else()
    # Windows: the 07-14 cross fix removed the unconditional win32 SDL include; the app target
    # still needs it here (found by the 2026-07-15 sweep BUILD_FAIL: SDL.h not found).
    target_include_directories(pilotwingspc PRIVATE ${SDL2_INCLUDE_DIRS})
endif()

target_compile_definitions(pilotwingspc PRIVATE HLSL_CPU)
if (WIN32)
    target_compile_definitions(pilotwingspc PRIVATE WIN32_LEAN_AND_MEAN)
endif()

# ── Preservation-core RDP capture + LLE console (RDPC_CAPTURE=ON) ─────────────
# console seam ported from snowkidspc (2026-07-31 batch): the per-game src/lle_console.cpp
# copy (sm64::lleconsole generation) is retired — moved aside as .pre_organ_20260731; the
# SHARED CONSOLE ORGAN (../preservation_core) serves instead, one copy for all games.
if (RDPC_CAPTURE)
    target_compile_definitions(pilotwingspc PRIVATE RDPC_CAPTURE_CHAIN)
    target_sources(pilotwingspc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore.c")
    target_include_directories(pilotwingspc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore")
    set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore.c"
        PROPERTIES COMPILE_DEFINITIONS "RDPC_RDRAM_XOR=3")
    target_sources(pilotwingspc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore_gpu.c")
    target_sources(pilotwingspc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore_gpu_task.c")
    set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore_gpu_task.c"
        PROPERTIES COMPILE_DEFINITIONS "RDPC_GPU")
    set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore_gpu.c"
        PROPERTIES COMPILE_DEFINITIONS "RDPC_GPU")
    target_compile_definitions(pilotwingspc PRIVATE RDPC_GPU)
    target_link_libraries(pilotwingspc PRIVATE vulkan)
    # THE SHARED CONSOLE ORGAN (one copy, all games — reva arrangement, .bak_move1 lineage).
    target_sources(pilotwingspc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../preservation_core/lle_console.cpp")
    target_sources(pilotwingspc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../preservation_core/console_input.cpp")
    target_include_directories(pilotwingspc PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/../preservation_core"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/softrdp/include")
endif()

if (MSVC)
    target_link_options(pilotwingspc PRIVATE /MAP)
endif()

target_link_libraries(pilotwingspc PRIVATE
    pilotwings_recomp
    librecomp
    ultramodern
    softrdp   # GPU-free presenter (softrdp::present) for the console path
)
if (NOT RDPC_CONSOLE_ONLY)
    target_link_libraries(pilotwingspc PRIVATE rt64)
endif()
if (WIN32)
    target_link_libraries(pilotwingspc PRIVATE SDL2 SDL2main)
else()
    target_link_libraries(pilotwingspc PRIVATE SDL2::SDL2)   # system SDL2 (find_package)
endif()

if (WIN32)
    set(SDL2_DLL
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/lib/x64/SDL2.dll")
    add_custom_command(TARGET pilotwingspc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${SDL2_DLL}" "$<TARGET_FILE_DIR:pilotwingspc>/SDL2.dll"
        COMMENT "Copying SDL2.dll")
    add_custom_command(TARGET pilotwingspc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/dxc/bin/x64/dxcompiler.dll"
            "$<TARGET_FILE_DIR:pilotwingspc>/dxcompiler.dll"
        COMMENT "Copying dxcompiler.dll")
    add_custom_command(TARGET pilotwingspc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/dxc/bin/x64/dxil.dll"
            "$<TARGET_FILE_DIR:pilotwingspc>/dxil.dll"
        COMMENT "Copying dxil.dll")
endif()
