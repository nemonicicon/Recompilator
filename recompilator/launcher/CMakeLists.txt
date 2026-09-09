# RECOMPILATOR — the launcher (the one program's front door).
#
# This is NOT a game tree: no recompiled functions, no ROM, no <game>pc suffix. It is a port that
# never calls start_game(). It links the SAME engine objects every game links (rt64 + librecomp +
# ultramodern), so under _masterbuild the engine is built once and this is just another link.
#
# Standalone:
#   cmake -S launcher -B launcher/build/windows-x64 -G "Visual Studio 18 2026" -A x64
#   cmake --build launcher/build/windows-x64 --config Release -- /m:2
# Through the master (engine objects reused):
#   cmake -S _masterbuild -B <builddir> -G "Visual Studio 18 2026" -A x64 -DN64PC_GAMES="cv64blind"
#   cmake --build <builddir> --config Release --target recompilator -- /m:2
#
# Either way the exe lands at launcher/build/windows-x64/Release/recompilator.exe.

cmake_minimum_required(VERSION 3.20)

# /EHsc MUST STAY OFF — the same load-bearing rule as _masterbuild/CMakeLists.txt (and
# memory/build_gotchas). MSVC's stock default is "/DWIN32 /D_WINDOWS /EHsc"; every working binary
# this project has shipped was compiled WITHOUT it, and the fiber scheduler dies when the exception
# model changes. Under the master these are already "/MP"; set them here only when this tree is the
# top-level project, and before project() so the platform defaults cannot overwrite them.
if (CMAKE_HOST_WIN32 AND (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR))
    set(CMAKE_CXX_FLAGS "/MP" CACHE STRING "match the master build — NOT the MSVC default" FORCE)
    set(CMAKE_C_FLAGS   "/MP" CACHE STRING "match the master build — NOT the MSVC default" FORCE)
endif()

project(recompilator LANGUAGES C CXX)

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ── RT64 configuration (identical to every game tree) ────────────────────────
set(RT64_STATIC ON CACHE BOOL "" FORCE)
if (WIN32)
    set(SDL2_INCLUDE_DIRS
        "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/include"
        CACHE STRING "" FORCE)
    set(SDL2_LIBRARIES "SDL2" "SDL2main" CACHE STRING "" FORCE)
    link_directories(
        "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/lib/x64")
    add_compile_definitions(NOMINMAX)
else()
    find_package(SDL2 REQUIRED)
endif()

# ── The agnostic engine (skipped when a parent project already added it) ─────
if (NOT TARGET rt64)
    add_subdirectory(../../engine/rt64 rt64_build)
    add_subdirectory(../../engine/runtime runtime_build)   # ultramodern + librecomp
endif()

add_executable(recompilator WIN32
    src/main.cpp
    src/rt64_renderer.cpp
    src/launcher_ui.cpp
    src/launcher_catalog.cpp
    src/launcher_hash.cpp
    src/launcher_module.cpp   # STEP 3: loads <game>pc/module/<game>.dll and starts the game here
    src/launcher_audio.cpp    # the host's SDL audio backend, shared by every module
    src/launcher_input.cpp    # the host's SDL controller backend, shared by every module
)
# src/engine_shims.c is GONE. It existed because librecomp referenced three CV64-shaped
# application symbols unconditionally; librecomp now carries its own fallbacks as library members
# (engine/runtime/librecomp/src/default_{ni_section_data,gamestate_change}.c) and a game MODULE
# registers its own through recomp_register_ni_section_data() / recomp_register_gamestate_change().
# Every existing <game>pc.exe still defines them itself and still links exactly as before.

target_include_directories(recompilator PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/hle"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/rhi"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/render"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/imgui"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/hlslpp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/nativefiledialog-extended/src/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/runtime/librecomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/runtime/ultramodern/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/runtime/N64Recomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../include"          # recomp_module.h -- THE GAME MODULE ABI
)

target_compile_definitions(recompilator PRIVATE HLSL_CPU)
if (WIN32)
    target_compile_definitions(recompilator PRIVATE WIN32_LEAN_AND_MEAN)
endif()

if (MSVC)
    target_link_options(recompilator PRIVATE /MAP)
endif()

# ── THE HOST ABI: what a game module imports from this exe ────────────────────
# A <game>.dll built by the bundled llvm-mingw clang calls back into the host for every libultra
# HLE entry and every recomp runtime primitive. Those are exported from THIS EXE (the Windows
# loader resolves an import whose named module is an already-loaded exe), and the module links
# against an import library llvm-dlltool makes from the same list -- one source of truth:
#
#     recompilator/launcher/recomp_host_abi.txt, generated by tools/make_host_abi.ps1
#
# A line is "name" or "name=internal_name" (MSVC mangles C++-linkage global variables; the Itanium
# ABI clang uses does not, so dmem is exported as dmem= its MSVC mangling), each optionally
# followed by " DATA" -- which matters only on the module's side of the .def, not here.
if (WIN32)
    set(_abi_file "${CMAKE_CURRENT_SOURCE_DIR}/recomp_host_abi.txt")
    if (EXISTS "${_abi_file}")
        file(STRINGS "${_abi_file}" _abi_lines)
        set(_abi_count 0)
        foreach (_line IN LISTS _abi_lines)
            string(STRIP "${_line}" _line)
            if (_line STREQUAL "" OR _line MATCHES "^#")
                continue()
            endif()
            string(REGEX REPLACE " DATA$" "" _line "${_line}")
            target_link_options(recompilator PRIVATE "/EXPORT:${_line}")
            math(EXPR _abi_count "${_abi_count}+1")
        endforeach()
        message(STATUS "recompilator: exporting ${_abi_count} host-ABI symbols for game modules")
        # /EXPORT: from an exe makes the linker emit an import library beside it; harmless, and it
        # keeps the "unresolved external" story honest if a symbol on the list ever disappears.
    else()
        message(WARNING "recompilator: ${_abi_file} missing -- game modules will not load")
    endif()
endif()

target_link_libraries(recompilator PRIVATE
    librecomp
    ultramodern
    rt64
    nfd          # nativefiledialog-extended, added by engine/rt64/CMakeLists.txt
)
if (WIN32)
    target_link_libraries(recompilator PRIVATE SDL2 SDL2main)
else()
    target_link_libraries(recompilator PRIVATE SDL2::SDL2)
endif()

# The exe lands in the tree's own build/windows-x64/<config> whichever project builds it, so the
# master build needs exactly one add_subdirectory line and nothing downstream has to learn a path.
set_target_properties(recompilator PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_CURRENT_SOURCE_DIR}/build/windows-x64/Release"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_CURRENT_SOURCE_DIR}/build/windows-x64/Debug"
    RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_CURRENT_SOURCE_DIR}/build/windows-x64/RelWithDebInfo")

if (WIN32)
    add_custom_command(TARGET recompilator POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/lib/x64/SDL2.dll"
            "$<TARGET_FILE_DIR:recompilator>/SDL2.dll"
        COMMENT "Copying SDL2.dll")
    add_custom_command(TARGET recompilator POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/dxc/bin/x64/dxcompiler.dll"
            "$<TARGET_FILE_DIR:recompilator>/dxcompiler.dll"
        COMMENT "Copying dxcompiler.dll")
    add_custom_command(TARGET recompilator POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../../engine/rt64/src/contrib/dxc/bin/x64/dxil.dll"
            "$<TARGET_FILE_DIR:recompilator>/dxil.dll"
        COMMENT "Copying dxil.dll")
endif()
