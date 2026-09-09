cmake_minimum_required(VERSION 3.20)
project(sm64pc LANGUAGES C CXX)

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
endif()

if (WIN32)
    add_compile_definitions(NOMINMAX)
endif()

# ── Third-party subdirectories ────────────────────────────────────────────────
# [RUNG157] the self-hosted OS experiment (2026-08-06: LINKS, BOOTS, kernel runs native —
# see COMPRESSED_CLASS_ROSTER). To re-arm: uncomment the definition, restore
# symbol_lists.cpp.RUNG157_WORKING_20260806 over the tracked file, rebuild the CLI, re-emit.
# The engine guards in librecomp/src/ultra_translation.cpp are inert without the define.
# add_compile_definitions(RUNG157_SELF_HOSTED)   # re-arm per the roster recipe
# Built ONCE. Under a master project (one build tree holding the engine + many games) the
# engine targets already exist, so this is skipped — no rebuild, no double-definition.
# Built standalone, the engine is added here exactly as before.
if (NOT TARGET rt64)
    add_subdirectory(../engine/rt64 rt64_build)
    add_subdirectory(../engine/runtime runtime_build)   # adds ultramodern + librecomp
endif()

# ── Recompiled C functions library ────────────────────────────────────────────
# N64Recomp outputs funcs_0.c … funcs_N.c (regenerable from sm64.toml).
# rsp/aspMain.cpp + rsp/f3dex2.cpp are the RSPRecomp outputs for the Konami
# audio ucode and F3DEX2 — byte-identical microcode between CV64 and SM64, so
# the cv64pc-generated recompilations are reused verbatim (tracked in git).
file(GLOB RECOMP_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs/funcs_*.c")
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/aspMain.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/aspMain.cpp")
endif()
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3dex2.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3dex2.cpp")
endif()
# rsp/f3d.cpp = SM64's Fast3D statically recompiled by OUR RSPRecomp (f3d.toml carries the full
# overlay model read from the ucode's own descriptor table; the July output is kept outside this tree
# for reference). Compiled ONLY with -DRDPC_CAPTURE=ON — the default build contains
# zero capture-chain code (2026-07-11: compiled-out beats env-gated). Capture builds go to
# a SEPARATE build dir (build-capture); build/Release is the golden's home and is never rebuilt.
option(RDPC_CAPTURE "Compile the RDP capture chain (oracle rig corpus source)" OFF)
if (RDPC_CAPTURE AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3d.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3d.cpp")
endif()

add_library(sm64_recomp STATIC ${RECOMP_SOURCES})

target_include_directories(sm64_recomp PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/N64Recomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/librecomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/ultramodern/include"
)

# RECOMP_FUNC expands to __declspec(noinline); no whole-program optimisation.
if (MSVC)
    target_compile_options(sm64_recomp PRIVATE /GL-)
endif()

# ── Main executable ───────────────────────────────────────────────────────────
add_executable(sm64pc WIN32
    src/main.cpp
    src/rt64_renderer.cpp
    src/audio.cpp
    src/input.cpp
    src/rsp.cpp
    src/patches/os_stubs.c
    src/patches/math_patches.c
    src/patches/engine_shims.c
)

target_include_directories(sm64pc PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/hle"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/rhi"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/render"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/hlslpp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/librecomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/ultramodern/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/N64Recomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs"
)

# WIN32_LEAN_AND_MEAN scoped to sm64pc (RT64's DXC headers need COM types).
# HLSL_CPU required by RT64's shared headers.
target_compile_definitions(sm64pc PRIVATE WIN32_LEAN_AND_MEAN HLSL_CPU)
if (RDPC_CAPTURE)
    target_compile_definitions(sm64pc PRIVATE RDPC_CAPTURE_CHAIN)
    # P3: the LLE renderer rides the capture chain (RDPC_LLE_RENDER=1 at runtime).
    # rdpcore compiles with the engine's swizzled-RDRAM convention (^3 = host-LE u32
    # words) for zero-copy rendering straight into engine memory.
    target_sources(sm64pc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore.c")
    target_include_directories(sm64pc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore")
    set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore.c"
        PROPERTIES COMPILE_DEFINITIONS "RDPC_RDRAM_XOR=3")
    # P3 console mode (RDPC_LLE_CONSOLE=1 at runtime): the RT64-free preservation-core
    # renderer — VI scan-out of rdpcore's RDRAM frames via softrdp's fb_present decode.
    target_sources(sm64pc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/src/lle_console.cpp")
    target_include_directories(sm64pc PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/softrdp/include")
endif()

# MAP file so crash RVAs resolve to function names.
if (MSVC)
    target_link_options(sm64pc PRIVATE /MAP)
endif()

# sm64_recomp before librecomp so recompiled symbols take priority.
target_link_libraries(sm64pc PRIVATE
    sm64_recomp
    librecomp
    ultramodern
    rt64
    SDL2
    SDL2main
)

if (WIN32)
    set(SDL2_DLL
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/lib/x64/SDL2.dll")
    add_custom_command(TARGET sm64pc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${SDL2_DLL}"
            "$<TARGET_FILE_DIR:sm64pc>/SDL2.dll"
        COMMENT "Copying SDL2.dll")
    add_custom_command(TARGET sm64pc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/dxc/bin/x64/dxcompiler.dll"
            "$<TARGET_FILE_DIR:sm64pc>/dxcompiler.dll"
        COMMENT "Copying dxcompiler.dll")
    add_custom_command(TARGET sm64pc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/dxc/bin/x64/dxil.dll"
            "$<TARGET_FILE_DIR:sm64pc>/dxil.dll"
        COMMENT "Copying dxil.dll")
endif()
