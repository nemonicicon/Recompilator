cmake_minimum_required(VERSION 3.20)

project(librecomp)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS OFF)

# Define the library
add_library(librecomp STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/src/ai.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/cont.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/diag_cap.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/dp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/eep.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/euc-jp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/extensions.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/files.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/flash.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/heap.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/math_routines.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mods.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mod_events.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mod_hooks.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mod_manifest.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mod_config_api.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/overlays.cpp"
    # Fallbacks for the two CV64-shaped symbols overlays.cpp references. Each is ALONE in its own
    # translation unit on purpose: as library members they are linked ONLY when the application has
    # not defined the symbol itself, so every existing <game>pc.exe keeps its own and only a host
    # that loads games as modules (Recompilator) picks these up. Never merge them into one file.
    "${CMAKE_CURRENT_SOURCE_DIR}/src/default_ni_section_data.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/default_gamestate_change.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/pak.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/patcher.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/pi.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/pif.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mmio.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/baremetal_sched.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/coswitch.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/cic.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/print.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/recomp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/recomp_interp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/recomp_live_gap.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/recomp_diag_flush.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/rsp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/rsp_interp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/rsp_dynarec.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/si.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/sp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/trace.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/tlb.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/ultra_optional_natives.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/ultra_stubs.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/ultra_translation.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/vi.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../thirdparty/o1heap/o1heap/o1heap.c"
)

target_include_directories(librecomp PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${PROJECT_SOURCE_DIR}/../ultramodern/include"
    "${PROJECT_SOURCE_DIR}/../thirdparty"
    "${PROJECT_SOURCE_DIR}/../thirdparty/concurrentqueue"
    "${PROJECT_SOURCE_DIR}/../thirdparty/o1heap"
    # rsp_interp.cpp (the general-RSP interpreter) pulls in rsp_vu.hpp which #include <sse2neon.h> on
    # ARM (translates SSE intrinsics to NEON). Harmless on x86 (the header isn't referenced there).
    # Belongs here since rsp_interp.cpp is compiled inside librecomp — so every app that links it builds.
    "${PROJECT_SOURCE_DIR}/../thirdparty/sse2neon"
    # rsp_dynarec.cpp (the live RSP recompiler) includes sljitLir.h. sljit is compiled into the
    # LiveRecomp target (which librecomp links); expose its headers here so the dynarec TU builds.
    "${PROJECT_SOURCE_DIR}/../N64Recomp/lib/sljit/sljit_src"
)
target_include_directories(librecomp PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/include/librecomp"
)

if (NOT MSVC)
    target_compile_options(librecomp PRIVATE
    #    -Wall
    #    -Wextra
        -Wno-unused-parameter
    )
endif()

if (WIN32)
    add_compile_definitions(NOMINMAX)
endif()

add_subdirectory(${PROJECT_SOURCE_DIR}/../thirdparty/miniz ${CMAKE_CURRENT_BINARY_DIR}/miniz)
add_subdirectory(${PROJECT_SOURCE_DIR}/../N64Recomp ${CMAKE_CURRENT_BINARY_DIR}/N64Recomp EXCLUDE_FROM_ALL)

target_link_libraries(librecomp PRIVATE ultramodern N64Recomp LiveRecomp N64RecompDiag softrdp)
target_link_libraries(librecomp PUBLIC miniz)

# ── RUNG 157: self-hosted guest OS ───────────────────────────────────────────────────────────────
# librecomp/src/ultra_translation.cpp guards 15 natives behind RUNG157_SELF_HOSTED (5bb1059,
# 4ca833e) so the CARTRIDGE's own threads/queues/timers/VI/exception code runs instead. Those
# guards shipped "inert by default" — but nothing ever DEFINED the macro, so the rung was
# unreachable. This wires the switch. Pair it with the matching symbol_lists.cpp state (the
# [RUNG157] names must be commented out) or the natives and the cartridge bodies collide.
# OFF = byte-identical to before.
option(RECOMP_SELF_HOSTED_OS "Rung 157: run the cartridge's own libultra (threads, queues, timers, VI, exceptions)" OFF)
if (RECOMP_SELF_HOSTED_OS)
    target_compile_definitions(librecomp PRIVATE RUNG157_SELF_HOSTED)
    message(STATUS "librecomp: RUNG157_SELF_HOSTED enabled - cartridge-hosted OS")
endif()
