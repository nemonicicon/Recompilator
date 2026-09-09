
//;
// RT64
//

#if defined(_WIN32)

#include "rt64_shader_compiler.h"

#include "common/rt64_common.h"

namespace RT64 {
    // ShaderCompiler

    ShaderCompiler::ShaderCompiler() {
        HRESULT res = DxcCreateInstance(CLSID_DxcCompiler, __uuidof(IDxcCompiler), (void **)(&dxcCompiler));
        if (FAILED(res)) {
            fprintf(stderr, "DxcCreateInstance(DxcCompiler) failed with error code 0x%lX.\n", res);
            return;
        }

        res = DxcCreateInstance(CLSID_DxcUtils, __uuidof(IDxcUtils), (void **)(&dxcUtils));
        if (FAILED(res)) {
            fprintf(stderr, "DxcCreateInstance(DxcUtils) failed with error code 0x%lX.\n", res);
            return;
        }
    }

    ShaderCompiler::~ShaderCompiler() {
        if (dxcCompiler != nullptr) {
            dxcCompiler->Release();
        }

        if (dxcUtils != nullptr) {
            dxcUtils->Release();
        }
    }

    // A FAILED Compile()/Link() LEAVES result NULL. Both callers discarded the HRESULT and passed
    // the pointer straight in, so a shader that failed to build became a null dereference on
    // whichever worker thread was compiling it - and because the crash handler parks only the
    // faulting thread in a dialog, the app kept drawing while the real error message (the one DXC
    // wrote into the error buffer) was never read. Seen on Pilotwings 2026-09-07, two dialogs up
    // over a running game. Report the failure and return; the caller checks for null too.
    static bool checkResultForError(IDxcOperationResult *result, const char *stage, HRESULT callResult) {
        if (FAILED(callResult) || (result == nullptr)) {
            fprintf(stderr, "Shader %s failed with error code 0x%lX and produced no result object.\n", stage, callResult);
            fflush(stderr);
            return false;
        }

        HRESULT resultCode;
        result->GetStatus(&resultCode);
        if (FAILED(resultCode)) {
            IDxcBlobEncoding *error;
            HRESULT hr = result->GetErrorBuffer(&error);
            if (FAILED(hr)) {
                fprintf(stderr, "Shader %s failed and its error buffer could not be read (0x%lX).\n", stage, hr);
                fflush(stderr);
                return false;
            }

            // Convert error blob to a string.
            std::vector<char> infoLog(error->GetBufferSize() + 1);
            memcpy(infoLog.data(), error->GetBufferPointer(), error->GetBufferSize());
            infoLog[error->GetBufferSize()] = 0;

            RT64_LOG_PRINTF("Shader compilation error: %s\n", infoLog.data());
            throw std::runtime_error("Shader compilation error: " + std::string(infoLog.data()));
        }

        return true;
    }

    void ShaderCompiler::compile(const std::string &shaderCode, const std::wstring &entryName, const std::wstring &profile,
        RenderShaderFormat shaderFormat, IDxcBlob **shaderBlob) const
    {
        IDxcBlobEncoding *textBlob = nullptr;
        HRESULT res = dxcUtils->CreateBlobFromPinned((LPBYTE)shaderCode.c_str(), (uint32_t)shaderCode.size(), DXC_CP_ACP, &textBlob);
        if (FAILED(res)) {
            fprintf(stderr, "CreateBlobFromPinned failed with error code 0x%lX.\n", res);
            return;
        }

        std::vector<LPCWSTR> arguments;
        arguments.push_back(L"-Qstrip_debug");

        switch (shaderFormat) {
        case RenderShaderFormat::DXIL:
            arguments.push_back(L"-Qstrip_reflect");
            break;
        case RenderShaderFormat::SPIRV:
            arguments.push_back(L"-spirv");
            arguments.push_back(L"-fvk-use-dx-layout");

            if (profile.find(L"vs") != std::wstring::npos) {
                arguments.push_back(L"-fvk-invert-y");
            }
            else if (profile.find(L"lib") != std::wstring::npos) {
                arguments.push_back(L"-fspv-target-env=vulkan1.1spirv1.4");
                arguments.push_back(L"-fspv-extension=SPV_KHR_ray_tracing");
            }

            break;
        default:
            assert(false && "Unknown shader format.");
            return;
        }

        const std::scoped_lock<std::mutex> compilerLock(compilerMutex);
        IDxcOperationResult *result = nullptr;
        HRESULT compileResult = dxcCompiler->Compile(textBlob, L"", entryName.c_str(), profile.c_str(), arguments.data(), (UINT32)(arguments.size()), nullptr, 0, nullptr, &result);
        if (checkResultForError(result, "compilation", compileResult)) {
            result->GetResult(shaderBlob);
        }

        textBlob->Release();
    }

    void ShaderCompiler::link(const std::wstring &entryName, const std::wstring &profile, IDxcBlob **libraryBlobs,
        const wchar_t **libraryBlobNames, uint32_t libraryBlobCount, IDxcBlob **shaderBlob) const 
    {
        IDxcLinker *dxcLinker = nullptr;
        HRESULT res = DxcCreateInstance(CLSID_DxcLinker, __uuidof(IDxcLinker), (void **)(&dxcLinker));
        if (FAILED(res)) {
            fprintf(stderr, "DxcCreateInstance(DxcLinker) failed with error code 0x%lX.\n", res);
            return;
        }

        for (uint32_t i = 0; i < libraryBlobCount; i++) {
            res = dxcLinker->RegisterLibrary(libraryBlobNames[i], libraryBlobs[i]);
            if (FAILED(res)) {
                fprintf(stderr, "RegisterLibrary failed with error code 0x%lX.\n", res);
                return;
            }
        }

        const std::scoped_lock<std::mutex> compilerLock(compilerMutex);
        IDxcOperationResult *result = nullptr;
        HRESULT linkResult = dxcLinker->Link(entryName.c_str(), profile.c_str(), libraryBlobNames, libraryBlobCount, nullptr, 0, &result);
        if (checkResultForError(result, "linking", linkResult)) {
            result->GetResult(shaderBlob);
        }

        dxcLinker->Release();
    }
};

#endif