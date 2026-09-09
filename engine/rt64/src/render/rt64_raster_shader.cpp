//
// RT64
//

#include "rt64_raster_shader.h"

#include "xxHash/xxh3.h"

#include "shaders/RenderParams.hlsli.rw.h"
#include "shaders/RasterPSDynamic.hlsl.spirv.h"
#include "shaders/RasterPSDynamicMS.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstant.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantMS.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantFlat.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantFlatMS.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantSS.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantMSSS.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantFlatSS.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantFlatMSSS.hlsl.spirv.h"
#include "shaders/RasterPSDynamicSSST.hlsl.spirv.h"
#include "shaders/RasterPSDynamicMSSSST.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantSSST.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantMSSSST.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantFlatSSST.hlsl.spirv.h"
#include "shaders/RasterPSSpecConstantFlatMSSSST.hlsl.spirv.h"
#include "shaders/RasterVSDynamic.hlsl.spirv.h"
#include "shaders/RasterVSSpecConstant.hlsl.spirv.h"
#include "shaders/RasterVSSpecConstantFlat.hlsl.spirv.h"
#include "shaders/PostBlendDitherNoiseAddPS.hlsl.spirv.h"
#include "shaders/PostBlendDitherNoiseSubPS.hlsl.spirv.h"
#include "shaders/PostBlendDitherNoiseSubNegativePS.hlsl.spirv.h"
#ifdef _WIN32
#   include "shaders/RasterPSLibrary.hlsl.dxil.h"
#   include "shaders/RasterPSLibraryMS.hlsl.dxil.h"
#   include "shaders/RasterVSLibrary.hlsl.dxil.h"
#   include "shaders/RasterPSDynamic.hlsl.dxil.h"
#   include "shaders/RasterPSDynamicMS.hlsl.dxil.h"
#   include "shaders/RasterVSDynamic.hlsl.dxil.h"
#   include "shaders/PostBlendDitherNoiseAddPS.hlsl.dxil.h"
#   include "shaders/PostBlendDitherNoiseSubPS.hlsl.dxil.h"
#   include "shaders/PostBlendDitherNoiseSubNegativePS.hlsl.dxil.h"
#elif defined(__APPLE__)
#   include "shaders/RasterPSDynamic.hlsl.metal.h"
#   include "shaders/RasterPSDynamicMS.hlsl.metal.h"
#   include "shaders/RasterPSSpecConstant.hlsl.metal.h"
#   include "shaders/RasterPSSpecConstantMS.hlsl.metal.h"
#   include "shaders/RasterPSSpecConstantFlat.hlsl.metal.h"
#   include "shaders/RasterPSSpecConstantFlatMS.hlsl.metal.h"
#   include "shaders/RasterVSDynamic.hlsl.metal.h"
#   include "shaders/RasterVSSpecConstant.hlsl.metal.h"
#   include "shaders/RasterVSSpecConstantFlat.hlsl.metal.h"
#   include "shaders/PostBlendDitherNoiseAddPS.hlsl.metal.h"
#   include "shaders/PostBlendDitherNoiseSubPS.hlsl.metal.h"
#   include "shaders/PostBlendDitherNoiseSubNegativePS.hlsl.metal.h"
#endif
#include "shared/rt64_raster_params.h"

#include "rt64_descriptor_sets.h"
#include "rt64_render_target.h"

// CV64 cont.23 — BRICK 1 of Option D (accurate-RDP depth gate). Single C++-side toggle for the ROV opaque
// depth gate: drives BOTH the optimized variant's inline gate (generateShaderText) AND the fixed-function
// depth-compare neutralization (createPipeline). MUST be flipped together with the HLSL RECOMP_AB_RDPZ in
// RasterPS.hlsl (which gates the uber/spec-constant variants). 0 = stock behavior.

// CV64 cont.23 Brick 1 REACH-TEST (DIAGNOSTIC — set 0 to restore the faithful tolerance compare). Must match
// Parked: 1 arbitrates opaque depth through the ROV and neutralises the fixed-function
// compare. Must be flipped together with RECOMP_AB_RDPZ in RasterPS.hlsl.
#define RECOMP_AB_RDPZ 0

namespace RT64 {
    static const RenderFormat RasterPositionFormat = RenderFormat::R32G32B32A32_FLOAT;
    static const RenderFormat RasterTexcoordFormat = RenderFormat::R32G32_FLOAT;
    static const RenderFormat RasterColorFormat = RenderFormat::R32G32B32A32_FLOAT;

    static const RenderInputSlot RasterInputSlots[3] = {
        RenderInputSlot(0, RenderFormatSize(RasterPositionFormat)),
        RenderInputSlot(1, RenderFormatSize(RasterTexcoordFormat)),
        RenderInputSlot(2, RenderFormatSize(RasterColorFormat))
    };

    static const RenderInputElement RasterInputElements[3] = {
        RenderInputElement("POSITION", 0, 0, RasterPositionFormat, 0, 0),
        RenderInputElement("TEXCOORD", 0, 1, RasterTexcoordFormat, 1, 0),
        RenderInputElement("COLOR", 0, 2, RasterColorFormat, 2, 0)
    };

    // OptimizerCacheSPIRV

    void OptimizerCacheSPIRV::initialize() {
        rasterVS.parse(RasterVSSpecConstantBlobSPIRV, std::size(RasterVSSpecConstantBlobSPIRV));
        rasterVSFlat.parse(RasterVSSpecConstantFlatBlobSPIRV, std::size(RasterVSSpecConstantFlatBlobSPIRV));
        rasterPS.parse(RasterPSSpecConstantBlobSPIRV, std::size(RasterPSSpecConstantBlobSPIRV));
        rasterPSMS.parse(RasterPSSpecConstantMSBlobSPIRV, std::size(RasterPSSpecConstantMSBlobSPIRV));
        rasterPSFlat.parse(RasterPSSpecConstantFlatBlobSPIRV, std::size(RasterPSSpecConstantFlatBlobSPIRV));
        rasterPSFlatMS.parse(RasterPSSpecConstantFlatMSBlobSPIRV, std::size(RasterPSSpecConstantFlatMSBlobSPIRV));
        rasterPS_SS.parse(RasterPSSpecConstantSSBlobSPIRV, std::size(RasterPSSpecConstantSSBlobSPIRV));
        rasterPSMS_SS.parse(RasterPSSpecConstantMSSSBlobSPIRV, std::size(RasterPSSpecConstantMSSSBlobSPIRV));
        rasterPSFlat_SS.parse(RasterPSSpecConstantFlatSSBlobSPIRV, std::size(RasterPSSpecConstantFlatSSBlobSPIRV));
        rasterPSFlatMS_SS.parse(RasterPSSpecConstantFlatMSSSBlobSPIRV, std::size(RasterPSSpecConstantFlatMSSSBlobSPIRV));
        rasterPS_SS_ST.parse(RasterPSSpecConstantSSSTBlobSPIRV, std::size(RasterPSSpecConstantSSSTBlobSPIRV));
        rasterPSMS_SS_ST.parse(RasterPSSpecConstantMSSSSTBlobSPIRV, std::size(RasterPSSpecConstantMSSSSTBlobSPIRV));
        rasterPSFlat_SS_ST.parse(RasterPSSpecConstantFlatSSSTBlobSPIRV, std::size(RasterPSSpecConstantFlatSSSTBlobSPIRV));
        rasterPSFlatMS_SS_ST.parse(RasterPSSpecConstantFlatMSSSSTBlobSPIRV, std::size(RasterPSSpecConstantFlatMSSSSTBlobSPIRV));
        assert(!rasterVS.empty());
        assert(!rasterVSFlat.empty());
        assert(!rasterPS.empty());
        assert(!rasterPSMS.empty());
        assert(!rasterPSFlat.empty());
        assert(!rasterPSFlatMS.empty());
        assert(!rasterPS_SS.empty());
        assert(!rasterPSMS_SS.empty());
        assert(!rasterPSFlat_SS.empty());
        assert(!rasterPSFlatMS_SS.empty());
    }

    // RasterShader

    RasterShader::RasterShader(RenderDevice *device, const ShaderDescription &desc, const RenderPipelineLayout *pipelineLayout, RenderShaderFormat shaderFormat, const RenderMultisampling &multisampling, 
        const ShaderCompiler *shaderCompiler, const OptimizerCacheSPIRV *optimizerCacheSPIRV)
    {
        assert(device != nullptr);

        this->device = device;
        this->desc = desc;
        
        const bool useMSAA = (multisampling.sampleCount > 1);
        std::unique_ptr<RenderShader> vertexShader;
        std::unique_ptr<RenderShader> pixelShader;
#ifdef __APPLE__
        std::vector<RenderSpecConstant> specConstants;
#endif
        if (shaderFormat == RenderShaderFormat::SPIRV) {
            // Choose the pre-compiled shader permutations.
            const respv::Shader *VS = nullptr;
            const respv::Shader *PS = nullptr;
            VS = desc.flags.smoothShade ? &optimizerCacheSPIRV->rasterVS : &optimizerCacheSPIRV->rasterVSFlat;

            // Pick the correct SPIR-V based on the configuration. On GPUs without dual-source
            // blending (e.g. a GPU without dual-source blending), use the single-source permutation that folds the
            // blend coefficient into the one output (matched by the single-source blend below).
            // GPUs additionally lacking descriptorIndexing (the single-texture profile) use the combined
            // single-source + single-texture permutation (per-draw bound tile textures).
            const bool singleSrc = !device->getCapabilities().dualSrcBlend;
            const bool singleTex = !device->getCapabilities().descriptorIndexing;
            assert((!singleTex || singleSrc) && "single-texture permutations are only built combined with single-source blend (the single-texture profile)");
            if (desc.flags.smoothShade) {
                if (singleTex)      PS = useMSAA ? &optimizerCacheSPIRV->rasterPSMS_SS_ST : &optimizerCacheSPIRV->rasterPS_SS_ST;
                else if (singleSrc) PS = useMSAA ? &optimizerCacheSPIRV->rasterPSMS_SS    : &optimizerCacheSPIRV->rasterPS_SS;
                else                PS = useMSAA ? &optimizerCacheSPIRV->rasterPSMS       : &optimizerCacheSPIRV->rasterPS;
            }
            else {
                if (singleTex)      PS = useMSAA ? &optimizerCacheSPIRV->rasterPSFlatMS_SS_ST : &optimizerCacheSPIRV->rasterPSFlat_SS_ST;
                else if (singleSrc) PS = useMSAA ? &optimizerCacheSPIRV->rasterPSFlatMS_SS    : &optimizerCacheSPIRV->rasterPSFlat_SS;
                else                PS = useMSAA ? &optimizerCacheSPIRV->rasterPSFlatMS       : &optimizerCacheSPIRV->rasterPSFlat;
            }

            thread_local std::vector<respv::SpecConstant> specConstants;
            thread_local bool specConstantsSetup = false;
            thread_local std::vector<uint8_t> optimizedVS;
            thread_local std::vector<uint8_t> optimizedPS;
            if (!specConstantsSetup) {
                for (uint32_t i = 0; i < 5; i++) {
                    specConstants.push_back(respv::SpecConstant(i, { 0 }));
                }

                specConstantsSetup = true;
            }
            
            specConstants[0].values[0] = desc.otherMode.L;
            specConstants[1].values[0] = desc.otherMode.H;
            specConstants[2].values[0] = desc.colorCombiner.L;
            specConstants[3].values[0] = desc.colorCombiner.H;
            specConstants[4].values[0] = desc.flags.value;
            
            bool vsRun = respv::Optimizer::run(*VS, specConstants.data(), uint32_t(specConstants.size()), optimizedVS);
            bool psRun = respv::Optimizer::run(*PS, specConstants.data(), uint32_t(specConstants.size()), optimizedPS);
            assert(vsRun && psRun && "Shader optimization must always succeed as the inputs are always the same.");

            vertexShader = device->createShader(optimizedVS.data(), optimizedVS.size(), "VSMain", shaderFormat);
            pixelShader = device->createShader(optimizedPS.data(), optimizedPS.size(), "PSMain", shaderFormat);
        }
        else if (shaderFormat == RenderShaderFormat::METAL) {
#       ifdef __APPLE__
            // Choose the pre-compiled shader permutations.
            const void *VSBlob = nullptr;
            const void *PSBlob = nullptr;
            uint32_t VSBlobSize = 0;
            uint32_t PSBlobSize = 0;
            if (desc.flags.smoothShade) {
                VSBlob = RasterVSSpecConstantBlobMSL;
                VSBlobSize = uint32_t(std::size(RasterVSSpecConstantBlobMSL));
            }
            else {
                VSBlob = RasterVSSpecConstantFlatBlobMSL;
                VSBlobSize = uint32_t(std::size(RasterVSSpecConstantFlatBlobMSL));
            }

            // Pick the correct MSL based on the configuration.
            if (desc.flags.smoothShade) {
                PSBlob = useMSAA ? RasterPSSpecConstantMSBlobMSL : RasterPSSpecConstantBlobMSL;
                PSBlobSize = uint32_t(useMSAA ? std::size(RasterPSSpecConstantMSBlobMSL) : std::size(RasterPSSpecConstantBlobMSL));
            }
            else {
                PSBlob = useMSAA ? RasterPSSpecConstantFlatMSBlobMSL : RasterPSSpecConstantFlatBlobMSL;
                PSBlobSize = uint32_t(useMSAA ? std::size(RasterPSSpecConstantFlatMSBlobMSL) : std::size(RasterPSSpecConstantFlatBlobMSL));
            }

            vertexShader = device->createShader(VSBlob, VSBlobSize, "VSMain", shaderFormat);
            pixelShader = device->createShader(PSBlob, PSBlobSize, "PSMain", shaderFormat);

            // Spec constants should replace the constants embedded in the shader directly.
            specConstants.emplace_back(0, desc.otherMode.L);
            specConstants.emplace_back(1, desc.otherMode.H);
            specConstants.emplace_back(2, desc.colorCombiner.L);
            specConstants.emplace_back(3, desc.colorCombiner.H);
            specConstants.emplace_back(4, desc.flags.value);
#       else
            assert(false && "This platform does not support METAL shaders.");
#       endif
        }
        else {
#       if defined(_WIN32)
            RasterShaderText shaderText = generateShaderText(desc, useMSAA);

            // Compile both shaders from text with the constants hard-coded in.
            static const wchar_t *blobVSLibraryNames[] = { L"RasterVSEntry", L"RasterVSLibrary" };
            static const wchar_t *blobPSLibraryNames[] = { L"RasterPSEntry", L"RasterPSLibrary" };
            IDxcBlob *blobVSLibraries[] = { nullptr, nullptr };
            IDxcBlob *blobPSLibraries[] = { nullptr, nullptr };
            shaderCompiler->dxcUtils->CreateBlobFromPinned(RasterVSLibraryBlobDXIL, sizeof(RasterVSLibraryBlobDXIL), DXC_CP_ACP, (IDxcBlobEncoding **)(&blobVSLibraries[1]));

            const void *PSLibraryBlob = useMSAA ? RasterPSLibraryMSBlobDXIL : RasterPSLibraryBlobDXIL;
            uint32_t PSLibraryBlobSize = useMSAA ? sizeof(RasterPSLibraryMSBlobDXIL) : sizeof(RasterPSLibraryBlobDXIL);
            shaderCompiler->dxcUtils->CreateBlobFromPinned(PSLibraryBlob, PSLibraryBlobSize, DXC_CP_ACP, (IDxcBlobEncoding **)(&blobPSLibraries[1]));
                
            // Compile both the vertex and pixel shader functions as libraries.
            const std::wstring VertexShaderName = L"VSMain";
            const std::wstring PixelShaderName = L"PSMain";
            shaderCompiler->compile(shaderText.vertexShader, VertexShaderName, L"lib_6_3", shaderFormat, &blobVSLibraries[0]);
            shaderCompiler->compile(shaderText.pixelShader, PixelShaderName, L"lib_6_3", shaderFormat, &blobPSLibraries[0]);

            // Link the vertex and pixel shaders with the libraries that define their main functions.
            IDxcBlob *blobVS = nullptr;
            IDxcBlob *blobPS = nullptr;
            shaderCompiler->link(VertexShaderName, L"vs_6_3", blobVSLibraries, blobVSLibraryNames, std::size(blobVSLibraries), &blobVS);
            shaderCompiler->link(PixelShaderName, L"ps_6_3", blobPSLibraries, blobPSLibraryNames, std::size(blobPSLibraries), &blobPS);

            vertexShader = device->createShader(blobVS->GetBufferPointer(), blobVS->GetBufferSize(), "VSMain", shaderFormat);
            pixelShader = device->createShader(blobPS->GetBufferPointer(), blobPS->GetBufferSize(), "PSMain", shaderFormat);

            // Blobs can be discarded once the shaders are created.
            blobVSLibraries[0]->Release();
            blobVSLibraries[1]->Release();
            blobPSLibraries[0]->Release();
            blobPSLibraries[1]->Release();
            blobPS->Release();
            blobVS->Release();
#       else
            assert(false && "This platform does not support runtime shader compilation.");
#       endif
        }
        
        // Create root signature and PSO.
        const bool copyMode = (desc.otherMode.cycleType() == G_CYC_COPY);
        PipelineCreation creation;
        creation.device = device;
        creation.pipelineLayout = pipelineLayout;
        creation.vertexShader = vertexShader.get();
        creation.pixelShader = pixelShader.get();
        creation.alphaBlend = !copyMode && interop::Blender::usesAlphaBlend(desc.otherMode);
        // Additive framebuffer blends (M=framebuffer, B=ONE) keep the full framebuffer + add the source;
        // they must use dstBlend = ONE, not the default alpha-over INV_SRC1_ALPHA (see createPipeline).
        creation.additiveBlend = creation.alphaBlend && interop::Blender::usesFramebufferAdditiveBlend(desc.otherMode);
        creation.culling = !copyMode && desc.flags.culling;
        creation.zCmp = !copyMode && desc.otherMode.zCmp() && (desc.otherMode.zMode() != ZMODE_DEC);
        creation.zUpd = !copyMode && desc.otherMode.zUpd();
        creation.cvgAdd = (desc.otherMode.cvgDst() == CVG_DST_WRAP) || (desc.otherMode.cvgDst() == CVG_DST_SAVE);
        creation.NoN = desc.flags.NoN;
        creation.usesHDR = desc.flags.usesHDR;
#ifdef __APPLE__
        creation.specConstants = specConstants;
#endif
        creation.multisampling = multisampling;
        pipeline = createPipeline(creation);
    }

    RasterShader::~RasterShader() { }

    RasterShaderText RasterShader::generateShaderText(const ShaderDescription &desc, bool multisampling) {
        const std::string renderParamsCode = desc.toShader();

        // Generate vertex shader.
        std::stringstream vss;
        vss << std::string_view(RenderParamsText, sizeof(RenderParamsText));
        vss << "RenderParams getRenderParams() {" + renderParamsCode + "; return rp; }";
        vss <<
            "void RasterVS(const RenderParams, in float4, in float2, in float4, out float4, out float2, out float4, out float4);"
            "[shader(\"vertex\")]"
            "void VSMain("
            "   in float4 iPosition : POSITION,"
            "   in float2 iUV : TEXCOORD,"
            "   in float4 iColor : COLOR,"
            "   out float4 oPosition : SV_POSITION,"
            "   out float2 oUV : TEXCOORD,"
            "   out float4 oSmoothColor : COLOR0";

        if (!desc.flags.smoothShade) {
            vss << ", out float4 oFlatColor : COLOR1) {";
        }
        else {
            vss << ") { float4 oFlatColor;";
        }

        vss <<
            "   RasterVS(getRenderParams(), iPosition, iUV, iColor, oPosition, oUV, oSmoothColor, oFlatColor);"
            "}";

        // Generate pixel shader.
        std::stringstream pss;
        pss << std::string_view(RenderParamsText, sizeof(RenderParamsText));
        pss << "RenderParams getRenderParams() {" + renderParamsCode + "; return rp; }";
        // CV64 cont.22 GENDEPTH (set genDepth=false to restore stock): the castle/Malus render through THIS
        // runtime-LINKED pixel variant, whose generated PSMain wrote only color/alpha and let depth default to
        // interpolated SV_Position.z -> that's WHY every depth fix in RasterPS.hlsl PSMain did NOTHING to the
        // castle (PSMain isn't compiled into this variant). Inject the N64 16-bit screen-Z quantizer + an
        // explicit SV_Depth here so coplanar far surfaces the game expects to TIE (N64 coarse Z + LESS_EQUAL)
        // tie on the GPU too, instead of the back winning by a D32 hair. Encoder copied from Depth.hlsli
        // FloatToDepth16/Depth16ToFloat (dz=0). Pairs with RasterPS.hlsl NDEPTH=1 so the whole buffer is one space.
        // cont.22 RESULT: with this quant reaching the castle (both uber=RasterPSDynamic via NDEPTH and this
        // optimized linked path), the N64 16-bit depth quantization produced NO on-screen change -> the castle
        // ghost is NOT a depth-VALUE problem; it's a coincident-surface TIE resolved by compare/draw-order.
        // Reverted to false (no benefit; global quant risks the cont.20 turret regression elsewhere). The
        // SV_Depth plumbing is kept available for a future per-pixel depth fix that must reach THIS variant.
        const bool genDepth = false;
        if (genDepth) {
            pss <<
                "uint _n64ToFixed(float i){ return round(i*(32768.0f*8.0f-1)); }"
                "uint _n64Exp(uint d){ uint s=d<<14; int fz=firstbithigh(~s); return (uint)clamp(31-fz,0,7); }"
                "uint _n64ToD16(float z){ uint zf=_n64ToFixed(saturate(z)); uint e=_n64Exp(zf); uint m=zf>>(6u-min(6u,e)); return (e<<13)|((m<<2)&0x1FFCu); }"
                "float _n64Quant(float z){ uint i=_n64ToD16(z); uint e=(i&0xE000u)>>13; uint m=(i&0x1FFCu)>>2; uint sm=m<<(6u-min(6u,e)); uint mb=0x40000u-(0x40000u>>e); return (sm+mb)/(32768.0f*8.0f-1); }";
        }
        // CV64 cont.23 Brick 1 — the OPTIMIZED variant links the library RasterPS (which cannot host a ROV),
        // so this generated PSMain carries its own ROV + inline opaque depth gate. The ROV declaration and
        // CoplanarDepthTolerance (copied verbatim from Depth.hlsli) are self-contained because this generated
        // source only sees the RenderParams struct — not FbRendererCommon / Depth.hlsli. dz uses the raw
        // screen derivative (resolutionScale ~ 1) since FbParams/instanceRDPParams aren't visible here;
        // CoplanarDepthTolerance dominates the tolerance anyway. The uber variant (RasterPS.hlsl n64DepthGate)
        // is the fully-faithful reference.
        // __spirv__ guard: a ROV crashes dxc's SPIR-V backend without fragment-shader-interlock; CV64 runs
        // DXIL on D3D12, so the runtime DXIL compile gets the gate and a hypothetical Vulkan/SPIR-V runtime
        // compile excludes it. Mirrors RDP_DEPTH_GATE in RasterPS.hlsl.
        const bool genRDPZ = RECOMP_AB_RDPZ;
        if (genRDPZ) {
            pss <<
                "\n#ifndef __spirv__\n"
                "RasterizerOrderedTexture2D<float> gN64Depth : register(u3, space3);"
                "uint _rdpzFixed(float i){ return (uint)round(saturate(i)*(32768.0f*8.0f-1)); }"
                "float _rdpzCoplanarTol(float i){ uint df=_rdpzFixed(i); uint ds=df<<14; int fz=firstbithigh(~ds); uint e=(uint)clamp(31-fz,0,7); return 0.0005f/pow(2.0f,(float)min(e,3u)); }"
                "\n#endif\n";
        }
        pss <<
            "bool RasterPS(const RenderParams, float4, float2, float4, float4, bool, out float4, out float4);"
            "[shader(\"pixel\")]"
            "void PSMain("
            "  in float4 vertexPosition : SV_POSITION"
            ", in float2 vertexUV : TEXCOORD"
            ", in float4 vertexSmoothColor : COLOR0";

        if (!desc.flags.smoothShade) {
            pss << ", nointerpolation in float4 vertexFlatColor : COLOR1";
        }

        pss <<
            ", out float4 pixelColor : SV_TARGET0"
            ", out float4 pixelAlpha : SV_TARGET1";
        if (genDepth) {
            pss << ", out float pixelDepth : SV_Depth";
        }
        pss << ") {";

        if (desc.flags.smoothShade) {
            pss << "float4 vertexFlatColor = vertexSmoothColor;";
        }
        
        pss <<
            "   float4 resultColor;"
            "   float4 resultAlpha;"
            "   if (!RasterPS(getRenderParams(), vertexPosition, vertexUV, vertexSmoothColor, vertexFlatColor, false, resultColor, resultAlpha)) discard;";
        if (genRDPZ) {
            // The real RDP opaque depth gate (sole arbiter; the fixed-function compare is forced ALWAYS in
            // createPipeline). omL/flags are compile-time constants here, so the branches fold away per-pipeline.
            pss <<
                "\n#ifndef __spirv__\n"
                "   { RenderParams _rp = getRenderParams();"
                "     bool _zCmp = (_rp.omL & 0x10u) != 0u;"
                "     bool _zUpd = (_rp.omL & 0x20u) != 0u;"
                "     bool _decal = (_rp.omL & 0xc00u) == 0xc00u;"
                "     bool _noN = ((_rp.flags >> 1u) & 0x1u) != 0u;"
                "     if (!_decal && (_zCmp || _zUpd)) {"
                "       int2 _px = (int2)floor(vertexPosition.xy);"
                "       float _stored = gN64Depth[_px];"
                "       float _nd = _noN ? max(vertexPosition.z, 0.0f) : vertexPosition.z;"
                "       float _dz = abs(ddx(vertexPosition.z)) + abs(ddy(vertexPosition.z));"
                "       float _tol = max(_rdpzCoplanarTol(_stored), _dz);"
                "       if (_zCmp && (_nd > (_stored + _tol))) discard;"
                "       if (_zUpd) gN64Depth[_px] = _nd;"
                "     } }"
                "\n#endif\n";
        }
        pss <<
            "   pixelColor = resultColor;"
            "   pixelAlpha = resultAlpha;";
        if (genDepth) {
            pss << "   pixelDepth = _n64Quant(vertexPosition.z);";
        }
        pss << "}";

        return { vss.str(), pss.str() };
    }
    
    std::unique_ptr<RenderPipeline> RasterShader::createPipeline(const PipelineCreation &c) {
        RenderGraphicsPipelineDesc pipelineDesc;
        pipelineDesc.renderTargetBlend[0] = RenderBlendDesc::Copy();
        pipelineDesc.renderTargetFormat[0] = RenderTarget::colorBufferFormat(c.usesHDR);
        pipelineDesc.renderTargetCount = 1;
        // CV64 cont.20 cull test (THROWAWAY — set CV64_AB_CULL_OFF 0 to restore): force GPU cull OFF.
        // Paired with the CPU N.z cull disabled in rt64_rsp.cpp. If Malus's front torso is now solid from
        // EVERY angle -> the view-dependent loss was backface CULLING (front faces wrongly culled when they
        // face the camera) -> fix is to make the figure cull match the N64. If still view-dependent ->
        // not culling.
// cv64 S41: GPU-cull-off CONFIRMATION TEST for the lightning-fire. [fire9] proved the fire's tris are
// healthy + on-screen + in the scene pair, pass the CPU winding cull (N.z=+48.3), yet never rasterize —
// and the pipeline FRONT-cull below is the only stage left (it also explains why even the final-output
// magenta never showed: pipeline cull precedes all shading). The fire's billboard winds opposite to
// normal CULL_BACK models (mirrored billboard matrix); hardware's RSP cull keeps it, RT64's GPU cull
// eats it. If the fire APPEARS with this on: the faithful fix = trust the CPU-side hardware cull
// (already winding-exact) and stop double-culling on the GPU.
        pipelineDesc.cullMode = c.culling ? RenderCullMode::FRONT : RenderCullMode::NONE;
        // CV64 cont.20 depth-CLIP test (THROWAWAY — set CV64_AB_NOCLIP 0 to restore !c.NoN): the N64 does
        // NOT hard-clip at the far plane; D3D depthClip DISCARDS tris crossing near/far. [figz] shows the
        // figure projects to screenZ outside [0,1], so far-plane torso faces get clipped away view-
        // dependently (survives depth-ALWAYS + cull-off because it's neither compare nor cull). false =
        // clamp instead of clip = N64-faithful. If Malus's front torso is now solid from every angle, THIS
        // is the layer (general, all games).
        // CV64 cont.22 FORCECLIP on-screen TEST (THROWAWAY — set CV64_AB_FORCECLIP 0 to restore !c.NoN):
        // [zsrc] proved the castle's depth spills because ndc_z exceeds [-1,1] (near-plane-crossing geometry;
        // dominant class has NEGATIVE clip-w → the perspective divide sign-flips a NEAR surface to the FAR
        // end). The castle draws carry NoN, so RT64 sets depthClipEnabled=!c.NoN=false → the GPU CLAMPS that
        // out-of-range depth instead of CLIPPING it → near & far surfaces collapse to a tie at the boundary →
        // see-through. Forcing depthClipEnabled=true makes the GPU CLIP the crossing geometry instead of
        // clamping → if the ghost resolves, the diagnosis is confirmed and the faithful fix is per-direction
        // near clipping. NOTE: forcing true CLIPS rather than draws near-crossing geometry (NoN's purpose),
        // so some near-edge geometry may instead vanish — that on-screen distinction picks the final fix.
        pipelineDesc.depthClipEnabled = !c.NoN;
        pipelineDesc.depthEnabled = c.zCmp || c.zUpd;
        // CV64 cont.20 A/B (THROWAWAY — set CV64_AB_STRICT_LESS 0 to restore the session-22 LESS_EQUAL):
        // tests the hypothesis that Malus's translucent front/rear shell is a DUPLICATE "ghost"
        // copy (0x0F overlay collision) drawn at the SAME depth as the real opaque body. With strict
        // LESS the tied-depth ghost fails -> should vanish, leaving the solid body. WATCH the opening
        // CASTLE cutscene too: if it goes dark/figures vanish, strict LESS re-breaks it (expected) and
        // is NOT a usable fix -> then the ghost theory is confirmed but the real cure is killing the
        // collision (per-overlay memory), not the depth compare.
// CV64 cont.20 belly diagnostic (THROWAWAY): CV64_AB_DEPTH_ALWAYS forces the depth compare to ALWAYS
// (opaque still writes Z but is never occluded). If Malus's GRAY belly APPEARS -> it was depth-FAILING
// (tied-depth / far-plane precision = the faithful-coarse-Z fix's domain). If it STAYS a hole ->
// geometry isn't being submitted (figure/overlay-data layer, not depth). Scene loses occlusion globally
// (painter's order) — read ONLY whether the belly fills in. Set to 0 to restore.
// CV64 cont.32 WRITE-ACCUMULATION FORK (THROWAWAY): strict LESS on opaque zCmp draws. RESULT: castle
// VANISHED (only zCmp-off water/fog left) ⟹ writes DO land AND everything is at ONE depth (ties fail
// strict LESS). Root found: castle uses G_ZS_PRIM (omL bit2) → depth = constant primDepth, not vertex z.
        // CV64 cont.23 BRICK 1 (Option D accurate-RDP depth gate) — pairs with the HLSL RECOMP_AB_RDPZ in
        // RasterPS.hlsl. When on, the rasterizer-ordered N64 depth store in RasterPS() is the SOLE opaque
        // depth arbiter (it applies the real RDP coplanar/dz compare), so the GPU's fixed-function depth
        // COMPARE must not ALSO reject — force it ALWAYS. Depth WRITE stays on (depthWriteEnabled=zUpd below)
        // so the HW depth buffer still tracks the ROV-passing fragments (ROV-failed fragments discard
        // in-shader before the HW depth write), keeping decals / framebuffer read-back consistent until
        // Increment 5 repoints them at the ROV. RECOMP_AB_RDPZ is defined at file scope (top of this file).
        pipelineDesc.depthFunction = c.zCmp ? RenderComparisonFunction::LESS_EQUAL : RenderComparisonFunction::ALWAYS; // RE-APPLIED session 22 after empirical test: LLE TLB (P3d-1) was NOT sufficient to remove this. cutscene_01 goes dark / 3D figures disappear with strict LESS. The far-plane figures genuinely tie the backdrop's depth in CV64's geometry — N64 hardware's depth precision is coarser than D3D's so we need LESS_EQUAL to match real-HW visibility. This is NOT a hack masking a fixed problem; it's compensating for a real precision difference between N64 and modern GPUs.
        pipelineDesc.depthWriteEnabled = c.zUpd;
        pipelineDesc.depthTargetFormat = RenderFormat::D32_FLOAT;
        pipelineDesc.multisampling = c.multisampling;
        pipelineDesc.inputSlots = RasterInputSlots;
        pipelineDesc.inputSlotsCount = uint32_t(std::size(RasterInputSlots));
        pipelineDesc.inputElements = RasterInputElements;
        pipelineDesc.inputElementsCount = uint32_t(std::size(RasterInputElements));
        pipelineDesc.pipelineLayout = c.pipelineLayout;
        pipelineDesc.primitiveTopology = RenderPrimitiveTopology::TRIANGLE_LIST;
        pipelineDesc.vertexShader = c.vertexShader;
        pipelineDesc.pixelShader = c.pixelShader;
        pipelineDesc.specConstants = c.specConstants.data();
        pipelineDesc.specConstantsCount = uint32_t(c.specConstants.size());

        // Alpha blending uses dual-source blending (the blend factor is the secondary output). GPUs
        // without dualSrcBlend (e.g. a GPU without dual-source blending) ran the single-source PS permutation that
        // folded the factor into the one output, so blend single-source SRC_ALPHA here to match.
        RenderBlendDesc &targetBlend = pipelineDesc.renderTargetBlend[0];
        if (c.alphaBlend) {
            targetBlend.blendEnabled = true;
            // Additive framebuffer blends (M=framebuffer, B=ONE) preserve the full framebuffer and ADD the
            // source: dstBlend = ONE instead of the alpha-over INV_SRC*_ALPHA. This makes a black/zero source
            // contribute nothing (transparent) and a bright source glow — the correct N64 behavior for
            // shield/glow effects, vs. the old opaque-over that overwrote the framebuffer wherever src alpha
            // was 1.0 (the Space Invaders shield black box).
            const RenderBlend additiveDst = RenderBlend::ONE;
            if (c.device->getCapabilities().dualSrcBlend) {
                targetBlend.srcBlend = RenderBlend::SRC1_ALPHA;
                targetBlend.dstBlend = c.additiveBlend ? additiveDst : RenderBlend::INV_SRC1_ALPHA;
                targetBlend.blendOp = RenderBlendOperation::ADD;
            }
            else {
                targetBlend.srcBlend = RenderBlend::SRC_ALPHA;
                targetBlend.dstBlend = c.additiveBlend ? additiveDst : RenderBlend::INV_SRC_ALPHA;
                targetBlend.blendOp = RenderBlendOperation::ADD;
                targetBlend.srcBlendAlpha = RenderBlend::ONE;
                targetBlend.dstBlendAlpha = RenderBlend::INV_SRC_ALPHA;
                targetBlend.blendOpAlpha = RenderBlendOperation::ADD;
            }
        }

        // Emulating coverage wrap requires turning the alpha blending into an additive mode.
        if (c.cvgAdd) {
            targetBlend.blendEnabled = true;
            targetBlend.dstBlendAlpha = RenderBlend::ONE;
        }

        return c.device->createGraphicsPipeline(pipelineDesc);
    }
    
    RenderMultisampling RasterShader::generateMultisamplingPattern(RenderSampleCounts sampleCount, bool sampleLocationsSupported) {
#   if SAMPLE_LOCATIONS_REQUIRED
        if (!sampleLocationsSupported) {
            return RenderMultisampling();
        }
#   endif

        RenderMultisampling multisampling;
        multisampling.sampleCount = sampleCount;

        if ((sampleCount > 1) && sampleLocationsSupported) {
            multisampling.sampleLocationsEnabled = true;
            
            // These were roughly translated from this article (https://learn.microsoft.com/en-us/windows/win32/api/d3d11/ne-d3d11-d3d11_standard_multisample_quality_levels)
            // into the bottom right corner of the pixel area to account for the half pixel offset problem.
            auto &locations = multisampling.sampleLocations;
            switch (sampleCount) {
            case 2:
                locations[0] = { 2, 2 };
                locations[1] = { 6, 6 };
                break;
            case 4:
                locations[0] = { 3, 1 };
                locations[1] = { 7, 3 };
                locations[2] = { 1, 5 };
                locations[3] = { 5, 7 };
                break;
            case 8:
                locations[0] = { 4, 2 };
                locations[1] = { 3, 5 };
                locations[2] = { 6, 4 };
                locations[3] = { 2, 1 };
                locations[4] = { 1, 6 };
                locations[5] = { 0, 3 };
                locations[6] = { 5, 7 };
                locations[7] = { 7, 0 };
                break;
            default:
                assert(false && "Unknown sample count.");
                break;
            }
        }

        return multisampling;
    }

    // RasterShaderUber

#if defined(_WIN32)
    const uint64_t RasterShaderUber::RasterVSLibraryHash = XXH3_64bits(RasterVSLibraryBlobDXIL, sizeof(RasterVSLibraryBlobDXIL));
    const uint64_t RasterShaderUber::RasterPSLibraryHash = XXH3_64bits(RasterPSLibraryBlobDXIL, sizeof(RasterPSLibraryBlobDXIL));
#else
    // Shader hashes are not required in other platforms as they don't use a shader cache.
    const uint64_t RasterShaderUber::RasterVSLibraryHash = 0;
    const uint64_t RasterShaderUber::RasterPSLibraryHash = 0;
#endif

    RasterShaderUber::RasterShaderUber(RenderDevice *device, RenderShaderFormat shaderFormat, const RenderMultisampling &multisampling, const ShaderLibrary *shaderLibrary, uint32_t threadCount) {
        assert(device != nullptr);

        // Create the shaders.
        const void *VSBlob = nullptr;
        const void *PSBlob = nullptr;
        uint32_t VSBlobSize = 0;
        uint32_t PSBlobSize = 0;
        const bool useMSAA = (multisampling.sampleCount > 1);
        switch (shaderFormat) {
#   ifdef _WIN32
        case RenderShaderFormat::DXIL:
            VSBlob = RasterVSDynamicBlobDXIL;
            PSBlob = useMSAA ? RasterPSDynamicMSBlobDXIL : RasterPSDynamicBlobDXIL;
            VSBlobSize = uint32_t(std::size(RasterVSDynamicBlobDXIL));
            PSBlobSize = uint32_t(useMSAA ? std::size(RasterPSDynamicMSBlobDXIL) : std::size(RasterPSDynamicBlobDXIL));
            break;
#   endif
        case RenderShaderFormat::SPIRV:
            VSBlob = RasterVSDynamicBlobSPIRV;
            VSBlobSize = uint32_t(std::size(RasterVSDynamicBlobSPIRV));
            // The single-texture profile (no dualSrcBlend + no descriptorIndexing) needs the ubershader PS in
            // its single-source + single-texture form, or every uber pipeline is invalid on-device.
            if (!device->getCapabilities().descriptorIndexing) {
                assert(!device->getCapabilities().dualSrcBlend && "single-texture ubershader is only built combined with single-source blend (the single-texture profile)");
                PSBlob = useMSAA ? RasterPSDynamicMSSSSTBlobSPIRV : RasterPSDynamicSSSTBlobSPIRV;
                PSBlobSize = uint32_t(useMSAA ? std::size(RasterPSDynamicMSSSSTBlobSPIRV) : std::size(RasterPSDynamicSSSTBlobSPIRV));
            }
            else {
                PSBlob = useMSAA ? RasterPSDynamicMSBlobSPIRV : RasterPSDynamicBlobSPIRV;
                PSBlobSize = uint32_t(useMSAA ? std::size(RasterPSDynamicMSBlobSPIRV) : std::size(RasterPSDynamicBlobSPIRV));
            }
            break;
#   ifdef __APPLE__
        case RenderShaderFormat::METAL:
            VSBlob = RasterVSDynamicBlobMSL;
            PSBlob = useMSAA ? RasterPSDynamicMSBlobMSL : RasterPSDynamicBlobMSL;
            VSBlobSize = uint32_t(std::size(RasterVSDynamicBlobMSL));
            PSBlobSize = uint32_t(useMSAA ? std::size(RasterPSDynamicMSBlobMSL) : std::size(RasterPSDynamicBlobMSL));
            break;
#   endif
        default:
            assert(false && "Unknown shader format.");
            return;
        }

        vertexShader = device->createShader(VSBlob, VSBlobSize, "VSMain", shaderFormat);
        pixelShader = device->createShader(PSBlob, PSBlobSize, "PSMain", shaderFormat);

        FramebufferRendererDescriptorCommonSet descriptorCommonSet(shaderLibrary->samplerLibrary, device->getCapabilities().raytracing);
        FramebufferRendererDescriptorTextureSet descriptorTextureSet;
        FramebufferRendererDescriptorSingleTextureSet descriptorSingleTextureSet;
        FramebufferRendererDescriptorFramebufferSet descriptorFramebufferSet;
        RenderPipelineLayoutBuilder layoutBuilder;
        layoutBuilder.begin(false, true);
        layoutBuilder.addPushConstant(0, 0, sizeof(interop::RasterParams), RenderShaderStageFlag::VERTEX | RenderShaderStageFlag::PIXEL);
        layoutBuilder.addDescriptorSet(descriptorCommonSet);
        if (device->getCapabilities().descriptorIndexing) {
            layoutBuilder.addDescriptorSet(descriptorTextureSet);
            layoutBuilder.addDescriptorSet(descriptorTextureSet);
        }
        else {
            // single-texture mode: sets 1/2 are 1-slot texture sets bound per-draw.
            layoutBuilder.addDescriptorSet(descriptorSingleTextureSet);
            layoutBuilder.addDescriptorSet(descriptorSingleTextureSet);
        }
        layoutBuilder.addDescriptorSet(descriptorFramebufferSet);
        layoutBuilder.end();
        pipelineLayout = layoutBuilder.create(device);

        // Generate all possible combinations of pipeline creations and assign them to each thread. Skip the ones that are invalid.
        uint32_t pipelineCount = uint32_t(std::size(pipelines));
        pipelineThreadCreations.clear();
        pipelineThreadCreations.resize(std::min(threadCount, pipelineCount));

        PipelineCreation creation;
        creation.device = device;
        creation.pipelineLayout = pipelineLayout.get();
        creation.vertexShader = vertexShader.get();
        creation.pixelShader = pixelShader.get();
        creation.alphaBlend = true;
        creation.culling = false;
        creation.NoN = true;
        creation.usesHDR = shaderLibrary->usesHDR;
        creation.multisampling = multisampling;

        uint32_t threadIndex = 0;
        for (uint32_t i = 0; i < pipelineCount; i++) {
            creation.zCmp = i & (1 << 0);
            creation.zUpd = i & (1 << 1);
            creation.cvgAdd = i & (1 << 2);

            pipelineThreadCreations[threadIndex].emplace_back(creation);
            threadIndex = (threadIndex + 1) % threadCount;
        }

        // Spawn the threads that will compile all the pipelines.
        pipelineThreads.clear();
        pipelineThreads.resize(pipelineThreadCreations.size());
        for (uint32_t i = 0; i < uint32_t(pipelineThreads.size()); i++) {
            pipelineThreads[i] = std::make_unique<std::thread>(&RasterShaderUber::threadCreatePipelines, this, i);
        }

        // Create the pipelines for post blend operations.
        std::unique_ptr<RenderShader> postBlendAddPixelShader;
        std::unique_ptr<RenderShader> postBlendSubPixelShader;
        std::unique_ptr<RenderShader> postBlendSubNegativePixelShader;
        switch (shaderFormat) {
#   ifdef _WIN32
        case RenderShaderFormat::DXIL:
            postBlendAddPixelShader = device->createShader(PostBlendDitherNoiseAddPSBlobDXIL, std::size(PostBlendDitherNoiseAddPSBlobDXIL), "PSMain", shaderFormat);
            postBlendSubPixelShader = device->createShader(PostBlendDitherNoiseSubPSBlobDXIL, std::size(PostBlendDitherNoiseSubPSBlobDXIL), "PSMain", shaderFormat);
            postBlendSubNegativePixelShader = device->createShader(PostBlendDitherNoiseSubNegativePSBlobDXIL, std::size(PostBlendDitherNoiseSubNegativePSBlobDXIL), "PSMain", shaderFormat);
            break;
#   endif
        case RenderShaderFormat::SPIRV:
            postBlendAddPixelShader = device->createShader(PostBlendDitherNoiseAddPSBlobSPIRV, std::size(PostBlendDitherNoiseAddPSBlobSPIRV), "PSMain", shaderFormat);
            postBlendSubPixelShader = device->createShader(PostBlendDitherNoiseSubPSBlobSPIRV, std::size(PostBlendDitherNoiseSubPSBlobSPIRV), "PSMain", shaderFormat);
            postBlendSubNegativePixelShader = device->createShader(PostBlendDitherNoiseSubNegativePSBlobSPIRV, std::size(PostBlendDitherNoiseSubNegativePSBlobSPIRV), "PSMain", shaderFormat);
            break;
#   ifdef __APPLE__
        case RenderShaderFormat::METAL:
            postBlendAddPixelShader = device->createShader(PostBlendDitherNoiseAddPSBlobMSL, std::size(PostBlendDitherNoiseAddPSBlobMSL), "PSMain", shaderFormat);
            postBlendSubPixelShader = device->createShader(PostBlendDitherNoiseSubPSBlobMSL, std::size(PostBlendDitherNoiseSubPSBlobMSL), "PSMain", shaderFormat);
            postBlendSubNegativePixelShader = device->createShader(PostBlendDitherNoiseSubNegativePSBlobMSL, std::size(PostBlendDitherNoiseSubNegativePSBlobMSL), "PSMain", shaderFormat);
            break;
#   endif
        default:
            assert(false && "Unknown shader format.");
            return;
        }

        RenderGraphicsPipelineDesc postBlendDesc;
        postBlendDesc.renderTargetBlend[0] = RenderBlendDesc::Copy();
        postBlendDesc.renderTargetFormat[0] = RenderTarget::colorBufferFormat(shaderLibrary->usesHDR);
        postBlendDesc.renderTargetCount = 1;
        postBlendDesc.cullMode = RenderCullMode::NONE;
        postBlendDesc.depthTargetFormat = RenderFormat::D32_FLOAT;
        postBlendDesc.multisampling = multisampling;
        postBlendDesc.inputSlots = RasterInputSlots;
        postBlendDesc.inputSlotsCount = uint32_t(std::size(RasterInputSlots));
        postBlendDesc.inputElements = RasterInputElements;
        postBlendDesc.inputElementsCount = uint32_t(std::size(RasterInputElements));
        postBlendDesc.pipelineLayout = pipelineLayout.get();
        postBlendDesc.primitiveTopology = RenderPrimitiveTopology::TRIANGLE_LIST;
        postBlendDesc.vertexShader = vertexShader.get();
        postBlendDesc.pixelShader = postBlendAddPixelShader.get();

        RenderBlendDesc &targetBlend = postBlendDesc.renderTargetBlend[0];
        targetBlend.blendEnabled = true;
        targetBlend.srcBlend = RenderBlend::ONE;
        targetBlend.dstBlend = RenderBlend::ONE;
        targetBlend.blendOp = RenderBlendOperation::ADD;
        targetBlend.srcBlendAlpha = RenderBlend::ZERO;
        targetBlend.dstBlendAlpha = RenderBlend::ONE;
        targetBlend.blendOpAlpha = RenderBlendOperation::ADD;

        postBlendDitherNoiseAddPipeline = device->createGraphicsPipeline(postBlendDesc);

        postBlendDesc.pixelShader = postBlendSubPixelShader.get();
        targetBlend.blendOp = RenderBlendOperation::REV_SUBTRACT;
        postBlendDitherNoiseSubPipeline = device->createGraphicsPipeline(postBlendDesc);

        postBlendDesc.pixelShader = postBlendSubNegativePixelShader.get();
        postBlendDitherNoiseSubNegativePipeline = device->createGraphicsPipeline(postBlendDesc);
    }

    RasterShaderUber::~RasterShaderUber() {
        waitForPipelineCreation();
    }

    void RasterShaderUber::threadCreatePipelines(uint32_t threadIndex) {
        // Delay the creation of all other pipelines until the first pipeline is created. This can help the
        // driver reuse its shader cache between pipelines and achieve a much lower creation time than if
        // all threads started at the same time.
        if (threadIndex > 0) {
            std::unique_lock<std::mutex> lock(firstPipelineMutex);
            firstPipelineCondition.wait(lock, [this]() {
                return (pipelines[0] != nullptr);
            });
        }

        for (const PipelineCreation &creation : pipelineThreadCreations[threadIndex]) {
            uint32_t pipelineIndex = pipelineStateIndex(creation.zCmp, creation.zUpd, creation.cvgAdd);

            if (pipelineIndex == 0) {
                firstPipelineMutex.lock();
                pipelines[pipelineIndex] = RasterShader::createPipeline(creation);
                firstPipelineMutex.unlock();
                firstPipelineCondition.notify_all();
            }
            else {
                pipelines[pipelineIndex] = RasterShader::createPipeline(creation);
            }
        }
    }

    void RasterShaderUber::waitForPipelineCreation() {
        if (!pipelinesCreated) {
            for (std::unique_ptr<std::thread> &thread : pipelineThreads) {
                thread->join();
            }

            pipelineThreads.clear();
            pipelineThreadCreations.clear();
            vertexShader.reset();
            pixelShader.reset();
            pipelinesCreated = true;
        }
    }

    uint32_t RasterShaderUber::pipelineStateIndex(bool zCmp, bool zUpd, bool cvgAdd) const {
        return
            (uint32_t(zCmp)         << 0) |
            (uint32_t(zUpd)         << 1) |
            (uint32_t(cvgAdd)       << 2);
    }

    const RenderPipeline *RasterShaderUber::getPipeline(bool zCmp, bool zUpd, bool cvgAdd) const {
        return pipelines[pipelineStateIndex(zCmp, zUpd, cvgAdd)].get();
    }
};
