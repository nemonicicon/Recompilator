//
// RT64
//

#pragma once

#if defined(_WIN32)

#include <Windows.h>
#include <dxcapi.h>

#include <mutex>
#include <string>

#include "common/rt64_plume.h"

namespace RT64 {
    struct ShaderCompiler {
        IDxcCompiler *dxcCompiler = nullptr;
        IDxcUtils *dxcUtils = nullptr;

        // ONE IDxcCompiler, SHARED BY EVERY COMPILATION THREAD - and IDxcCompiler is not
        // thread-safe. RasterShaderCache starts threadsAvailable/2 CompilationThreads and hands
        // each of them this same object, with nothing serialising the calls. Concurrent Compile()
        // corrupts DXC internal state and faults INSIDE dxcompiler.dll, on whichever worker thread
        // lost the race - a small null offset (READ 0x18, READ 0x20), a different thread id every
        // time, and no frame of our own code on the stack to point at.
        //
        // It takes a burst of new shader permutations arriving at once to lose that race, which is
        // why frame interpolation (RefreshRate::Display) is what exposed it: Pilotwings, 2026-09-07.
        // mutable because both entry points are const.
        mutable std::mutex compilerMutex;

        ShaderCompiler();
        ~ShaderCompiler();

        void compile(const std::string &shaderCode, const std::wstring &entryName, const std::wstring &profile,
            RenderShaderFormat shaderFormat, IDxcBlob **shaderBlob) const;

        void link(const std::wstring &entryName, const std::wstring &profile, IDxcBlob **libraryBlobs,
            const wchar_t **libraryBlobNames, uint32_t libraryBlobCount, IDxcBlob **shaderBlob) const;
    };
};

#else

// Shader compiler is not required on other platforms at runtime.

namespace RT64 {
    typedef void* ShaderCompiler;
};

#endif

