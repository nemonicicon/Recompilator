cmake_minimum_required(VERSION 3.20)
project(dragonkingpc LANGUAGES C CXX)

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
if (NOT TARGET rt64)
    add_subdirectory(../engine/rt64 rt64_build)
    add_subdirectory(../engine/runtime runtime_build)   # adds ultramodern + librecomp
endif()

# ── Recompiled C functions library ────────────────────────────────────────────
# N64Recomp outputs funcs_0.c … funcs_N.c (regenerable from ../dragonking/dragonking.toml).
# rsp/aspMain.cpp (audio ucode) + rsp/f3dex2.cpp are optional — the EXISTS guards skip them.
file(GLOB RECOMP_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs/funcs_*.c")
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/aspMain.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/aspMain.cpp")
endif()
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3dex2.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3dex2.cpp")
endif()

add_library(dragonking_recomp STATIC ${RECOMP_SOURCES})

target_include_directories(dragonking_recomp PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/N64Recomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/librecomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/ultramodern/include"
)

if (MSVC)
    target_compile_options(dragonking_recomp PRIVATE /GL-)
endif()

# ── Main executable ───────────────────────────────────────────────────────────
add_executable(dragonkingpc WIN32
    src/main.cpp
    src/rt64_renderer.cpp
    src/audio.cpp
    src/input.cpp
    src/rsp.cpp
    src/patches/os_stubs.c
    src/patches/math_patches.c
    src/patches/engine_shims.c
)

target_include_directories(dragonkingpc PRIVATE
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

target_compile_definitions(dragonkingpc PRIVATE HLSL_CPU)
if (WIN32)
    target_compile_definitions(dragonkingpc PRIVATE WIN32_LEAN_AND_MEAN)
endif()

if (MSVC)
    target_link_options(dragonkingpc PRIVATE /MAP)
endif()

target_link_libraries(dragonkingpc PRIVATE
    dragonking_recomp
    librecomp
    ultramodern
    rt64
)
if (WIN32)
    target_link_libraries(dragonkingpc PRIVATE SDL2 SDL2main)
else()
    target_link_libraries(dragonkingpc PRIVATE SDL2::SDL2)   # system SDL2 (find_package)
endif()

if (WIN32)
    set(SDL2_DLL
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/lib/x64/SDL2.dll")
    add_custom_command(TARGET dragonkingpc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${SDL2_DLL}" "$<TARGET_FILE_DIR:dragonkingpc>/SDL2.dll"
        COMMENT "Copying SDL2.dll")
    add_custom_command(TARGET dragonkingpc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/dxc/bin/x64/dxcompiler.dll"
            "$<TARGET_FILE_DIR:dragonkingpc>/dxcompiler.dll"
        COMMENT "Copying dxcompiler.dll")
    add_custom_command(TARGET dragonkingpc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/dxc/bin/x64/dxil.dll"
            "$<TARGET_FILE_DIR:dragonkingpc>/dxil.dll"
        COMMENT "Copying dxil.dll")
endif()
