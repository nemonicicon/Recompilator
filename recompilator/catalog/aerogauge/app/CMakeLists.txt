cmake_minimum_required(VERSION 3.20)
project(aerogaugepc LANGUAGES C CXX)

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
# N64Recomp outputs funcs_0.c … funcs_N.c (regenerable from ../aerogauge/aerogauge.toml).
# rsp/aspMain.cpp (audio ucode) + rsp/f3dex2.cpp are optional — the EXISTS guards skip them.
file(GLOB RECOMP_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs/funcs_*.c")
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/aspMain.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/aspMain.cpp")
endif()
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3dex2.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/rsp/f3dex2.cpp")
endif()

# console seam ported from snowkidspc (2026-07-31 batch): the recompiled F3DEX.NoN 1.23 gfx
# family artifact (RecompiledFuncs/f3dexnon123.cpp, from f3dexnon123.toml — census: AeroGauge).
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs/f3dexnon123.cpp")
    list(APPEND RECOMP_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs/f3dexnon123.cpp")
endif()

add_library(aerogauge_recomp STATIC ${RECOMP_SOURCES})

# On non-x86 (Pi/ARM) the recompiled RSP VU uses sse2neon (fleet pattern, see starfox64pc).
if (NOT (CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64|i.86|x86"))
    target_include_directories(aerogauge_recomp PUBLIC
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/thirdparty/sse2neon")
endif()


target_include_directories(aerogauge_recomp PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/N64Recomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/librecomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/ultramodern/include"
)

if (MSVC)
    target_compile_options(aerogauge_recomp PRIVATE /GL-)
endif()

# ── Main executable ───────────────────────────────────────────────────────────
add_executable(aerogaugepc WIN32
    src/main.cpp
    src/audio.cpp
    src/input.cpp
    src/rsp.cpp
    src/patches/os_stubs.c
    src/patches/math_patches.c
    src/patches/engine_shims.c
)

target_include_directories(aerogaugepc PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/librecomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/ultramodern/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/N64Recomp/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/RecompiledFuncs"
)
# console seam ported from snowkidspc (2026-07-31 batch)
if (NOT RDPC_CONSOLE_ONLY)
    # RT64 headers (incl. the bundled win32 SDL) exist only on the desktop tier — the console
    # build must never see them (Linux uses the system SDL2 via SDL2::SDL2).
    target_include_directories(aerogaugepc PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/hle"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/rhi"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/render"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/hlslpp/include"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/include")
endif()

if (NOT RDPC_CONSOLE_ONLY)
    target_sources(aerogaugepc PRIVATE src/rt64_renderer.cpp)
else()
    target_compile_definitions(aerogaugepc PRIVATE RDPC_CONSOLE_ONLY)
endif()

target_compile_definitions(aerogaugepc PRIVATE HLSL_CPU)
if (WIN32)
    target_compile_definitions(aerogaugepc PRIVATE WIN32_LEAN_AND_MEAN)
endif()

# ── Preservation-core RDP capture + LLE console (RDPC_CAPTURE=ON) ─────────────
# console seam ported from snowkidspc (2026-07-31 batch)
option(RDPC_CAPTURE "Compile the RDP capture chain + LLE console renderer" OFF)
if (RDPC_CAPTURE)
    target_compile_definitions(aerogaugepc PRIVATE RDPC_CAPTURE_CHAIN)
    target_sources(aerogaugepc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore.c")
    target_include_directories(aerogaugepc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore")
    set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore.c"
        PROPERTIES COMPILE_DEFINITIONS "RDPC_RDRAM_XOR=3")
    target_sources(aerogaugepc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore_gpu.c")
    target_sources(aerogaugepc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore_gpu_task.c")
    set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore_gpu_task.c"
        PROPERTIES COMPILE_DEFINITIONS "RDPC_GPU")
    set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/../rdpcore/rdpcore_gpu.c"
        PROPERTIES COMPILE_DEFINITIONS "RDPC_GPU")
    target_compile_definitions(aerogaugepc PRIVATE RDPC_GPU)
    target_link_libraries(aerogaugepc PRIVATE vulkan)
    # THE SHARED CONSOLE ORGAN (one copy, all games — reva arrangement, .bak_move1 lineage).
    target_sources(aerogaugepc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../preservation_core/lle_console.cpp")
    target_sources(aerogaugepc PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../preservation_core/console_input.cpp")
    target_include_directories(aerogaugepc PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/../preservation_core"
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/runtime/softrdp/include")
endif()

if (MSVC)
    target_link_options(aerogaugepc PRIVATE /MAP)
endif()

target_link_libraries(aerogaugepc PRIVATE
    aerogauge_recomp
    librecomp
    ultramodern
    softrdp   # GPU-free presenter (softrdp::present) for the console path
)
if (NOT RDPC_CONSOLE_ONLY)
    target_link_libraries(aerogaugepc PRIVATE rt64)
endif()
if (WIN32)
    target_link_libraries(aerogaugepc PRIVATE SDL2 SDL2main)
else()
    target_link_libraries(aerogaugepc PRIVATE SDL2::SDL2)   # system SDL2 (find_package)
endif()

if (WIN32)
    set(SDL2_DLL
        "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2-2.26.3/lib/x64/SDL2.dll")
    add_custom_command(TARGET aerogaugepc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${SDL2_DLL}" "$<TARGET_FILE_DIR:aerogaugepc>/SDL2.dll"
        COMMENT "Copying SDL2.dll")
    add_custom_command(TARGET aerogaugepc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/dxc/bin/x64/dxcompiler.dll"
            "$<TARGET_FILE_DIR:aerogaugepc>/dxcompiler.dll"
        COMMENT "Copying dxcompiler.dll")
    add_custom_command(TARGET aerogaugepc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_SOURCE_DIR}/../engine/rt64/src/contrib/dxc/bin/x64/dxil.dll"
            "$<TARGET_FILE_DIR:aerogaugepc>/dxil.dll"
        COMMENT "Copying dxil.dll")
endif()
