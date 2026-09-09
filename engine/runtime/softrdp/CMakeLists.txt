# softrdp — the GPU-free software RDP (see include/softrdp/softrdp.h).
add_library(softrdp STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/src/softrdp.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/fb_present.cpp"  # GPU-free presenter (the VI); Linux fbdev, stub elsewhere
)

target_include_directories(softrdp PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")
# NEON mapping for the SSE2 span vectorization on ARM. Harmless on x86 (uses <emmintrin.h>).
target_include_directories(softrdp PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../thirdparty/sse2neon")
target_compile_features(softrdp PRIVATE cxx_std_20)

# The softrdp span is THE hot path — tune codegen for the Cortex-A72 (instruction selection +
# scheduling + the NEON pipeline). CRC-exact (scheduling only; no -ffast-math). ARM-only; x86 desktop
# keeps generic -O3. Falls back cleanly if the compiler doesn't know -mcpu=cortex-a72.
if (CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm")
    include(CheckCXXCompilerFlag)
    check_cxx_compiler_flag("-mcpu=cortex-a72" SOFTRDP_HAS_MCPU_A72)
    if (SOFTRDP_HAS_MCPU_A72)
        target_compile_options(softrdp PRIVATE -mcpu=cortex-a72)
    endif()
endif()
