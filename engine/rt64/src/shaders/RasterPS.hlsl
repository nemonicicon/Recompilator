//
// RT64
//

#include "shared/rt64_blender.h"
#include "shared/rt64_color_combiner.h"
#include "shared/rt64_raster_params.h"

#include "Depth.hlsli"
#include "FbRendererCommon.hlsli"
#include "Library.hlsli"
#include "Random.hlsli"
#include "TextureSampler.hlsli"

[[vk::push_constant]] ConstantBuffer<RasterParams> gConstants : register(b0, space0);

// CV64 cont.23 — BRICK 1 of Option D (accurate-RDP depth gate, faithful LLE graphics). Toggles the real
// N64 RDP opaque depth compare (coplanar/dz tolerance, the same machinery RT64 already runs for DECALS at
// RasterPS() L83-104) for OPAQUE geometry, arbitrated per-pixel via a rasterizer-ordered N64 depth store
// instead of the GPU's fixed-function LESS_EQUAL (which loses the castle's coplanar ties to the last-drawn
// surface). MUST be flipped together with the C++ RECOMP_AB_RDPZ in rt64_raster_shader.cpp (which neutralizes
// the GPU's fixed-function depth COMPARE so the ROV is the sole arbiter). 0 = stock behavior.

// A RasterizerOrderedView crashes dxc's SPIR-V backend when the target env lacks fragment-shader-interlock
// (these pixel shaders build for vulkan1.0). CV64 runs on D3D12 (DXIL), so the ROV path is gated to the
// non-SPIR-V compiles. (A future Vulkan port needs -fspv-extension=SPV_EXT_fragment_shader_interlock +
// vulkan1.1.) __spirv__ is defined by dxc only when targeting SPIR-V.
#define RECOMP_AB_RDPZ 0      // 1 arbitrates opaque depth through the ROV instead of the GPU's
                        // fixed-function LESS_EQUAL. Parked. Flip WITH the C++ side.
#if RECOMP_AB_RDPZ && !defined(__spirv__)
#define RDP_DEPTH_GATE 1
#else
#define RDP_DEPTH_GATE 0
#endif

// CV64 cont.23 Brick 1 REACH-TEST (DIAGNOSTIC — set 0 to restore the faithful tolerance compare). Replaces
// the gate's coplanar-tolerance compare with strict LESS via the ROV: discard any opaque fragment at-or-
// behind the stored surface. Reproduces cont.23's fixed-function "strict LESS vanishes the castle" THROUGH
// the new ROV chain. Castle vanishes -> the ROV gate truly controls the castle's depth (the permissive
// "no change" was a real elimination of the compare -> Brick 3); everything vanishes -> the clear isn't
// running; no change -> the ROV isn't reaching the castle draws.

#if defined(MULTISAMPLING)
Texture2DMS<float> gBackgroundDepth : register(t2, space3);

float sampleBackgroundDepth(int2 pixelPos, uint sampleCount) {
    float v = gBackgroundDepth.Load(pixelPos, 0);
    if (sampleCount >= 2) {
        v += gBackgroundDepth.Load(pixelPos, 1);
    }

    if (sampleCount >= 4) {
        v += gBackgroundDepth.Load(pixelPos, 2);
        v += gBackgroundDepth.Load(pixelPos, 3);
    }

    if (sampleCount >= 8) {
        v += gBackgroundDepth.Load(pixelPos, 4);
        v += gBackgroundDepth.Load(pixelPos, 5);
        v += gBackgroundDepth.Load(pixelPos, 6);
        v += gBackgroundDepth.Load(pixelPos, 7);
    }

    return v / float(sampleCount);
}
#elif defined(DYNAMIC_RENDER_PARAMS) || defined(SPEC_CONSTANT_RENDER_PARAMS) || defined(LIBRARY)
Texture2D<float> gBackgroundDepth : register(t2, space3);

float sampleBackgroundDepth(int2 pixelPos, uint sampleCount) {
    return gBackgroundDepth.Load(int3(pixelPos, 0));
}
#endif

#if RDP_DEPTH_GATE && (defined(DYNAMIC_RENDER_PARAMS) || defined(SPEC_CONSTANT_RENDER_PARAMS))
// CV64 cont.23 Brick 1: the programmable N64 depth store (FramebufferRendererDescriptorFramebufferSet u3).
// RasterizerOrderedTexture2D makes the opaque read-modify-write primitive-ordered across draws — the same
// in-order coverage/Z guarantee the real RDP has — so no per-draw UAV barrier is needed. Declared ONLY in the
// pixel-shader entry-point variants (NOT the LIBRARY build — a ROV crashes dxc's library compiler).
RasterizerOrderedTexture2D<float> gN64Depth : register(u3, space3);
#endif

LIBRARY_EXPORT bool RasterPS(const RenderParams rp, float4 vertexPosition, float2 vertexUV, float4 vertexSmoothColor, float4 vertexFlatColor,
    bool isFrontFace, out float4 resultColor, out float4 resultAlpha) 
{
    const OtherMode otherMode = { rp.omL, rp.omH };
#if defined(DYNAMIC_RENDER_PARAMS)
    if ((otherMode.cycleType() != G_CYC_COPY) && renderFlagCulling(rp.flags) && isFrontFace) {
        return false;
    }
#endif
    
    const uint instanceIndex = instanceRenderIndices[gConstants.renderIndex].instanceIndex;
    const float4 vertexColor = renderFlagSmoothShade(rp.flags) ? vertexSmoothColor : float4(vertexFlatColor.rgb, vertexSmoothColor.a);
    const ColorCombiner colorCombiner = { rp.ccL, rp.ccH };
    const bool depthClampNear = renderFlagNoN(rp.flags);
    const bool depthDecal = (otherMode.zMode() == ZMODE_DEC);
    const bool zSourcePrim = (otherMode.zSource() == G_ZS_PRIM);
    int2 pixelPosSeed = floor(vertexPosition.xy);
    uint randomSeed = initRand(FrParams.frameCount, instanceIndex * pixelPosSeed.y * pixelPosSeed.x, 16); // TODO: Review seed.

    // Handle no-nearclipping by clamping the minimum depth and manually clipping above the maximum.
    if (depthClampNear) {
        // Since depth clip is disabled on the PSO so near clip can be ignored, we manually clip any values above the allowed depth.
        if (vertexPosition.z > 1.0f) {
            return false;
        }
    }
#ifdef DYNAMIC_RENDER_PARAMS
    // We emulate depth clip on the dynamic version of the shader.
    else {
        if ((vertexPosition.z < 0.0f) || (vertexPosition.z > 1.0f)) {
            return false;
        }
    }
#endif

    if (depthDecal) {
        // Sample the depth buffer for this pixel to compare for the decal check.
        int2 pixelPos = floor(vertexPosition.xy);
        uint sampleCount = 1U << renderFlagSampleCount(rp.flags);
        float surfaceDepth = sampleBackgroundDepth(pixelPos, sampleCount);

        // Calculate the decal depth tolerance based on the depth derivatives (or the prim dz value if prim depth source is enabled).
        float dz;
        if (zSourcePrim) {
            dz = instanceRDPParams[instanceIndex].primDepth.y;
        }
        else {
            dz = (abs(ddx(vertexPosition.z)) + abs(ddy(vertexPosition.z))) * FbParams.resolutionScale.y;
        }

        // Perform the decal depth tolerance check.
        const float DepthTolerance = max(CoplanarDepthTolerance(surfaceDepth), dz);
        const float pixelDepth = select(depthClampNear, max(vertexPosition.z, 0.0f), vertexPosition.z);
        if (abs(pixelDepth - surfaceDepth) > DepthTolerance) {
            return false;
        }
    }
    
    float2 ddxVertexUV = ddx(vertexUV);
    float2 ddyVertexUV = ddy(vertexUV);
    float2 lowResUV = vertexUV;
    if (!renderFlagUpscale2D(rp.flags)) {
        float2 screenPos = floor(vertexPosition.xy);
        screenPos.x += FbParams.horizontalMisalignment;
        lowResUV -= fmod(screenPos.xy, FbParams.resolutionScale.yy) * float2(ddxVertexUV.x, ddyVertexUV.y);
    }
    
    int tileIndex0 = 0;
    int tileIndex1 = 1;
    float lodFraction;
    float lodScale = 1.0f;
    if (!renderFlagUpscaleLOD(rp.flags)) {
        lodScale = FbParams.resolutionScale.y;
    }
    
    computeLOD(otherMode, instanceRenderIndices[gConstants.renderIndex].rdpTileCount, instanceRDPParams[instanceIndex].primLOD, lodScale, ddxVertexUV, ddyVertexUV, tileIndex0, tileIndex1, lodFraction);

    float4 texVal0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
    float4 texVal1 = float4(0.0f, 0.0f, 0.0f, 1.0f);
    if (renderFlagUsesTexture0(rp.flags)) {
        const uint globalTileIndex = instanceRenderIndices[gConstants.renderIndex].rdpTileIndex + tileIndex0;
        RDPTile rdpTile = RDPTiles[globalTileIndex];
        if (!renderFlagDynamicTiles(rp.flags)) {
            rdpTile.cms = renderCMS0(rp.flags);
            rdpTile.cmt = renderCMT0(rp.flags);
            rdpTile.nativeSampler = renderFlagNativeSampler0(rp.flags);
        }
        
        const GPUTile gpuTile = GPUTiles[globalTileIndex];
        const float2 textureUV = gpuTileFlagHighRes(gpuTile.flags) ? vertexUV : lowResUV;
        texVal0 = sampleTexture(RT64_TEX_ARG(gTexture0) otherMode, rp.flags, textureUV, ddxVertexUV, ddyVertexUV, rdpTile, gpuTile, false);
    }
    
    if (renderFlagUsesTexture1(rp.flags)) {
        const bool oneCycleHardwareBug = (otherMode.cycleType() == G_CYC_1CYCLE);
        const uint globalTileIndex = instanceRenderIndices[gConstants.renderIndex].rdpTileIndex + (oneCycleHardwareBug ? tileIndex0 : tileIndex1);
        RDPTile rdpTile = RDPTiles[globalTileIndex];
        if (!renderFlagDynamicTiles(rp.flags)) {
            rdpTile.cms = oneCycleHardwareBug ? renderCMS0(rp.flags) : renderCMS1(rp.flags);
            rdpTile.cmt = oneCycleHardwareBug ? renderCMT0(rp.flags) : renderCMT1(rp.flags);
            rdpTile.nativeSampler = oneCycleHardwareBug ? renderFlagNativeSampler0(rp.flags) : renderFlagNativeSampler1(rp.flags);
        }
        
        const GPUTile gpuTile = GPUTiles[globalTileIndex];
        const float2 textureUV = gpuTileFlagHighRes(gpuTile.flags) ? vertexUV : lowResUV;
        const uint nativeSampler = renderFlagNativeSampler1(rp.flags);
        texVal1 = sampleTexture(RT64_TEX_ARG(gTexture1) otherMode, rp.flags, textureUV, ddxVertexUV, ddyVertexUV, rdpTile, gpuTile, oneCycleHardwareBug);
    }
    
    // CV64 cont.20 A/B (THROWAWAY — set CV64_AB_TEXA1 0 to restore stock): force texture alpha opaque.
    // If Malus's translucent shell goes SOLID -> his shell alpha = TEXEL0 (texture/TLUT alpha), and that
    // alpha is low/corrupt = the overlay-collision texture path. If still translucent -> alpha comes from
    // prim/env/shade or the blender, not the texture. Decisive: this picks which layer the faithful fix
    // lives in.

    // Color combiner.
    float4 shadeColor = vertexColor;
    // CV64 cont.20 lighting bypass (THROWAWAY — set CV64_AB_FULLBRIGHT 0 to restore). Group viz proved
    // the opaque core wins depth (green) at the belly from every angle, so it's not order/geometry — the
    // core's SHADED color is going to black against the black bg. Force shade to full-bright for 3D draws
    // (keep texture/combiner/fog). If Malus's belly comes back lit/textured from every angle -> LIGHTING
    // was darkening it (front normals away from the scene light) = the layer to fix faithfully. If still
    // gone -> fog or combiner.
    float4 combinerColor;
    float alphaCompareValue;
    ColorCombiner::Inputs ccInputs;
    ccInputs.otherMode = otherMode;
    ccInputs.alphaOnly = false;
    ccInputs.texVal0 = texVal0;
    ccInputs.texVal1 = texVal1;
    ccInputs.primColor = instanceRDPParams[instanceIndex].primColor;
    ccInputs.shadeColor = shadeColor;
    ccInputs.envColor = instanceRDPParams[instanceIndex].envColor;
    ccInputs.keyCenter = instanceRDPParams[instanceIndex].keyCenter;
    ccInputs.keyScale = instanceRDPParams[instanceIndex].keyScale;
    ccInputs.lodFraction = lodFraction;
    ccInputs.primLodFrac = instanceRDPParams[instanceIndex].primLOD.x;
    ccInputs.noise = nextRand(randomSeed);
    ccInputs.K4 = (instanceRDPParams[instanceIndex].convertK[4] / 255.0f);
    ccInputs.K5 = (instanceRDPParams[instanceIndex].convertK[5] / 255.0f);
    colorCombiner.run(ccInputs, combinerColor, alphaCompareValue);

    // cv64 S41 [fireviz] THROWAWAY A/B — flame-combiner-keyed MAGENTA (zero-GUI raster proof).
    // Key = the flame's SETCOMBINE exactly as RT64 packs it (L = w0 incl. FC byte, H = w1 — the S40b
    // probe-key lesson). Stage 1 (here): override the combiner OUTPUT so texture/combiner inputs can't
    // zero it and coverage stays full (no discard). Stage 2 (final output below) beats fog/blend.
    // Magenta on screen => rasterization/present work, kill is in the INPUTS. Nothing => pre-PS kill.
    
#if 0
    // Alpha dither.
    // TODO: To avoid increasing the alpha values here, the only viable choice would be to drop the precision down to 5-bit.
    // Since we'd rather keep the full precision of the alpha channel from the texture, this step is ignored for now.
    if (otherMode.alphaDither() != G_AD_DISABLE) {
        uint rgbDither = (otherMode.rgbDither() >> G_MDSFT_RGBDITHER) & 0x3;
        uint alphaDither = (otherMode.alphaDither() >> G_MDSFT_ALPHADITHER) & 0x3;
        float alphaDitherFloat = (AlphaDitherValue(rgbDither, alphaDither, floor(vertexPosition.xy), randomSeed) / 255.0f);
        if (!otherMode.alphaCvgSel()) {
            combinerColor.a += alphaDitherFloat;
        }
        
        shadeColor.a += alphaDitherFloat;
        alphaCompareValue += alphaDitherFloat;
    }
#endif
    
    // Alpha compare.
    // CV64 cont.20 A/B (THROWAWAY — set CV64_AB_NODISCARD 0 to restore stock): never DROP a pixel
    // for low/garbage combiner alpha (alpha-compare cutout + coverage discard). Tests the hypothesis
    // that Malus's "see-through" = his skin pixels are being discarded for a corrupt texture/TLUT
    // alpha. If Malus renders SOLID (guts hidden) -> alpha-discard confirmed (-> chase the corrupt
    // texture/TLUT, overlay-collision suspect). If he STAYS hollow -> not discard (front geometry
    // missing, or XLU blend). Translucent BLEND is left intact so fades/overlays stay readable.
    if (otherMode.alphaCompare() == G_AC_DITHER) {
        if (alphaCompareValue < nextRand(randomSeed)) {
            return false;
        }
    }
    else if (otherMode.alphaCompare() == G_AC_THRESHOLD) {
        if (alphaCompareValue < instanceRDPParams[instanceIndex].blendColor.a) {
            return false;
        }
    }

    // Compute coverage estimation.
    const bool usesHDR = renderFlagUsesHDR(rp.flags);
    const float cvgRange = usesHDR ? 65535.0f : 255.0f;
    float resultCvg = (8.0f / cvgRange) * (otherMode.cvgXAlpha() ? combinerColor.a : 1.0f);

    // Discard all pixels without coverage.
    const float CoverageThreshold = 1.0f / cvgRange;
    if (resultCvg < CoverageThreshold) {
        return false;
    }
    
    // Add the blender if it can be replicated with simple emulation.
    Blender::Inputs blInputs;
    blInputs.blendColor = instanceRDPParams[instanceIndex].blendColor;
    blInputs.fogColor = instanceRDPParams[instanceIndex].fogColor;
    blInputs.shadeAlpha = shadeColor.a;
    resultColor = Blender::run(otherMode, rp.flags, blInputs, combinerColor, false);
    resultAlpha = 1.0f;
    
    // When using alpha blending, we store the blending factor into the dedicated output so the main one can be used for coverage.
    const bool alphaBlend = (otherMode.cycleType() != G_CYC_COPY) && Blender::usesAlphaBlend(otherMode);
    if (alphaBlend) {
        // CV64 cont.23 — CORRECT-BY-CONSTRUCTION general N64 fix. When ALPHA_CVG_SEL is set, the N64
        // blender's alpha INPUT is COVERAGE, not the combiner alpha. usesAlphaBlend() returns true for
        // AA-opaque modes because they read the framebuffer for EDGE anti-aliasing, but the interior is
        // full-coverage = OPAQUE. RT64 fed the combiner alpha here; CV64's castle stonework is ZMODE_OPA
        // with ALPHA_CVG_SEL=1 and combiner alpha < 1, so the whole opaque wall went TRANSLUCENT (the
        // castle looked translucent, with a ghost in the water — and the translucent front not hiding the back
        // was the misread "back-of-castle-on-front" depth symptom). In the raster path every pixel is full
        // coverage, so the blend factor is 1.0 for ALPHA_CVG_SEL surfaces. Genuine XLU (ALPHA_CVG_SEL=0,
        // e.g. the violin sheen primA=0.69) still uses the combiner alpha = correctly translucent.
        resultAlpha.a = otherMode.alphaCvgSel() ? 1.0f : resultColor.a;
    }
    // CV64 cont.22 A/B (THROWAWAY — set CV64_AB_OPAQUE_BLEND 0 to restore): force the GPU dual-source
    // blend factor (SRC1_ALPHA, rt64_raster_shader.cpp:377) to FULLY OPAQUE for every draw. NODISCARD
    // already ruled out the alpha CUTOUT; this tests the alpha BLEND — whether RT64 is alpha-blending
    // surfaces (with a low blend-alpha) that the N64 renders OPAQUE, making present + depth-correct
    // geometry render see-through. SHARED render-state across every figure/context (Malus, castle,
    // post-menu, post-load). If they all go SOLID together -> the shared blend-state IS the disease
    // (fix the blend classification / alpha source). If nothing changes -> not the blend; pivot to depth/setup.
    
    // Preserve the value in the destination.
    if (otherMode.cvgDst() == CVG_DST_SAVE) {
        resultColor.a = 0.0f;
    }
    // Write a full coverage value regardless of the computed coverage.
    else if (otherMode.cvgDst() == CVG_DST_FULL) {
        resultColor.a = 7.0f / cvgRange;
    }
    // Write the coverage value clamped to the full value allowed.
    else if (otherMode.cvgDst() == CVG_DST_CLAMP) {
        resultColor.a = min(resultCvg, 7.0f / cvgRange);
    }
    // Write out the computed coverage. It'll be added on wrap mode.
    else {
        resultColor.a = resultCvg;
    }
    
    // Add highlight color to the last step.
    uint highlightColorUint = instanceRenderIndices[gConstants.renderIndex].highlightColor;
    if (highlightColorUint > 0) {
        float4 highlightColor = RGBA32ToFloat4(highlightColorUint);
        resultColor = lerp(resultColor, highlightColor, highlightColor.a);
    }

    // cv64 S41 [fireviz] stage 2: final-output override for the flame draw — beats fog/blend/coverage.
    
#ifdef DYNAMIC_RENDER_PARAMS
    if (FrParams.viewUbershaders) {
        resultColor.rgb = lerp(resultColor.rgb, float3(1.0f, 0.0f, 0.0f), 0.5f);
    }
#endif

    // CV64 cont.20 magenta in the SHARED RasterPS() function (THROWAWAY — set CV64_AB_MAGENTA_FN 0 to
    // restore). The prior paint lived in PSMain, which only exists in SOME shader variants, so it missed
    // Malus's title figure (rendered normally, only transitions flashed). This function is
    // called by EVERY raster variant. Gated to non-rect (3D) so 2D UI stays readable. Pair with the
    // [pcensus] CPU counters on his ccL signatures = proof the paint reaches his draws. If his torso is
    // MAGENTA from every angle -> tris rasterize (color-path bug). If a HOLE -> not rasterizing.
    // CV64 cont.20 color-path isolation (THROWAWAY — set CV64_AB_SHOWSHADE 0 to restore). The magenta
    // test proved Malus's tris RASTERIZE, so the view-dependent loss is in the COLOR path. Show the
    // SHADE (per-vertex LIT color) directly for 3D draws. If his front torso is BLACK when facing the
    // camera -> N64 LIGHTING is darkening it into the black bg (front normals turn away from the scene
    // light + near-zero night ambient) = the layer. If it stays bright/colored -> NOT lighting (fog or
    // combiner next).
    // CV64 cont.20 group viz (THROWAWAY — set CV64_AB_GROUPVIZ 0 to restore). Order is faithful (see
    // rt64_framebuffer_pair/renderer), so the suspect is the DEPTH winner between Malus's two groups at
    // the tied far plane. Color them: opaque core (zUpd=1, writes Z) = GREEN, shell/no-write (zUpd=0) =
    // RED, both forced opaque so the depth winner is unambiguous. Watch his torso as he faces you:
    //  GREEN = core wins (expected),  RED = shell overwrites the core,  flips GREEN<->RED with angle =
    //  the tied-depth winner is unstable (the LESS_EQUAL / dz-tolerance gap),  BLACK = both lose (occluded).
    // CV64 cont.20 FACE viz (THROWAWAY — set CV64_AB_FACEVIZ 0 to restore). Paired with cull OFF (both
    // faces drawn). FRONT-facing = GREEN, BACK-facing = RED. If Malus's belly is RED when he faces you ->
    // a BACK-face (the cape inside) is winning over the front torso -> the N64 culls it and RT64 isn't ->
    // winding/cull fix. If GREEN -> it's a front surface tying in depth -> depth-semantics fix. (If ALL
    // red, his draw path doesn't get a real SV_IsFrontFace -> tell me and I'll switch methods.)
    // CV64 cont.22 DEPTH-DISTRIBUTION viz (THROWAWAY — set CV64_AB_DEPTHVIZ 0 to restore). The disease is
    // OCCLUSION FAILURE: near planes stop hiding the far map ("I see the entire map"). Hypothesis: distant
    // geometry's screen-Z collapses to a TIE at the far plane (pixelDepth = saturate(vertexPosition.z) pins
    // everything >= 1.0 to exactly 1.0). This paints the depth of the VISIBLE (depth-winning) surface:
    //   z >= 0.9995 (the far-plane tie zone) = RED;  else [0.95,1.0] expanded to a dark->light grayscale ramp.
    // Read it where planes go invisible:
    //   - the see-through areas are UNIFORM RED / near-white = depths are tied at the far plane -> CONFIRMED,
    //     the fix is the depth MAPPING (stop the far collapse so near stays distinctly < far).
    //   - a clear dark->light gradient (near walls visibly DARKER than the far map) = depths are distinct ->
    //     it's NOT a depth-value tie; the occlusion failure is in the compare/pass and I look there.
    // 2D rects / UI left normal so you can orient.

    // CV64 cont.25/26 DEPTH-BAND viz (THROWAWAY — set CV64_AB_DEPTHBAND 0 to restore). THE Brick-1-vs-Brick-3
    // decider. Paints every 3D fragment by its screen-Z as HARD rainbow bands, one color step every 0.004 of
    // depth — so the castle's crushed far-plane span (~[0.973..0.994], 0.02 wide) shows ~5 distinct color
    // steps IF the depths are separable, and ONE flat color if they coincide. Read it in the see-through
    // ("ghost") areas:
    //   - the ghosted BACK wall is a DIFFERENT color band than the FRONT geometry around it
    //       -> front & back screen-Z are SEPARABLE (the back is measurably farther yet wins) -> the COMPARE
    //          is the bug -> BRICK 1 still has a win (a faithful gate/ordering can hide it).
    //   - the ghost region is ONE FLAT color, same band as the front
    //       -> front & back screen-Z COINCIDE -> no compare can ever separate them -> the depth VALUES are
    //          wrong -> BRICK 3 (LLE the RSP). This also exposes the cont.25 strict anomaly: any near-depth
    //          element drawn before the castle (backdrop/skybox) shows as a distinct NEAR band (red/orange).
    // Hard boundaries make a 0.004 depth difference an obvious color jump (a smooth gray ramp was too subtle).
    // Reaches EVERY raster variant (shared RasterPS, the cont.20 magenta proof). 2D rects/UI left normal to orient.

    // CV64 cont.23 DECISIVE coverage / read-back-alpha test (THROWAWAY — set CV64_AB_OPAQUE_OUT 0 to
    // restore). Magenta (full opaque color+alpha override) -> SOLID; OPAQUE_BLEND (resultAlpha.a=1.0
    // ALONE, the on-screen dual-source blend factor) -> NO fix. The only channel left between them is
    // resultColor.a = the N64 COVERAGE (~0.03), written to the framebuffer ALPHA and copied back to RDRAM
    // for CV64's darkness/fog read-back compositing. Force BOTH output alphas opaque, KEEP the real
    // combiner color, 3D (non-rect) draws only:
    //   SOLID with real textures -> the read-back coverage-alpha IS the shared disease (fix the
    //                               copyNativeToRAM coverage->framebuffer-alpha encoding / read-back path).
    //   still see-through        -> it's resultColor.rgb (the Blender), not the alpha; pivot there.

    // CV64 cont.23 REACH-TEST (THROWAWAY — set CV64_AB_REACHTEST 0 to restore). Force every 3D (non-rect)
    // pixel that flows through this shared RasterPS() to SOLID OPAQUE MAGENTA. This proves (a) whether my
    // edits even reach the castle/Malus draws, and (b) whether the "ghost in the water" is the SAME
    // geometry through this shader or a SEPARATE render pass. EXPECT: castle + Malus + all 3D = solid
    // magenta. If any translucent/ghost part SURVIVES forced opaque magenta -> it's a separate pass/path
    // this shader does not own (the real culprit). 2D UI stays normal so the screen is readable.

    return true;
}

#if RDP_DEPTH_GATE && (defined(DYNAMIC_RENDER_PARAMS) || defined(SPEC_CONSTANT_RENDER_PARAMS))
// CV64 cont.23 Brick 1 — the real RDP OPAQUE depth gate, arbitrated per-pixel by the rasterizer-ordered N64
// depth store instead of the GPU's fixed-function LESS_EQUAL. This lives in the PIXEL-SHADER ENTRY-POINT
// translation units (DYNAMIC = the uber shader, SPEC_CONSTANT = the per-material variant) and NEVER in the
// LIBRARY build — a RasterizerOrderedTexture2D crashes dxc's library compiler, which is why the shared
// RasterPS() can't host it (and why the optimized path replicates this same logic in its generated PSMain in
// rt64_raster_shader.cpp). Runs AFTER RasterPS() has accepted the fragment (so a color/alpha/coverage-killed
// pixel never touches depth) and only for NON-decal draws that compare and/or write Z. The tolerance is the
// SAME coplanar/dz machinery the decal path uses: CoplanarDepthTolerance encodes the N64's coarse 16-bit Z
// bands; dz is the per-primitive depth delta — faithful to the RDP, not a per-game fudge. Returns false to
// request a discard.
bool n64DepthGate(RenderParams rp, float4 vertexPosition) {
    const OtherMode otherMode = { rp.omL, rp.omH };
    if ((otherMode.zMode() == ZMODE_DEC) || !(otherMode.zCmp() || otherMode.zUpd())) {
        return true;
    }

    const uint instanceIndex = instanceRenderIndices[gConstants.renderIndex].instanceIndex;
    int2 n64Pixel = floor(vertexPosition.xy);
    float storedDepth = gN64Depth[n64Pixel];
    float newDepth = renderFlagNoN(rp.flags) ? max(vertexPosition.z, 0.0f) : vertexPosition.z;
    float dz;
    if (otherMode.zSource() == G_ZS_PRIM) {
        dz = instanceRDPParams[instanceIndex].primDepth.y;
    }
    else {
        dz = (abs(ddx(vertexPosition.z)) + abs(ddy(vertexPosition.z))) * FbParams.resolutionScale.y;
    }

    const float DepthTolerance = max(CoplanarDepthTolerance(storedDepth), dz);
    if (otherMode.zCmp() && (newDepth > (storedDepth + DepthTolerance))) {
        return false;
    }

    // RDP image-write: the passing fragment's Z becomes the stored surface depth when Z-update is on.
    if (otherMode.zUpd()) {
        gN64Depth[n64Pixel] = newDepth;
    }

    return true;
}
#endif

#if defined(DYNAMIC_RENDER_PARAMS)
RenderParams getRenderParams() {
    uint instanceIndex = instanceRenderIndices[gConstants.renderIndex].instanceIndex;
    return DynamicRenderParams[instanceIndex];
}
#elif defined(SPEC_CONSTANT_RENDER_PARAMS)
#   include "RenderParamsSpecConstants.hlsli"
#endif

#if defined(DYNAMIC_RENDER_PARAMS) || defined(SPEC_CONSTANT_RENDER_PARAMS)
void PSMain(
      in float4 vertexPosition : SV_POSITION
    , in float2 vertexUV : TEXCOORD
    , in float4 vertexSmoothColor : COLOR0
#if defined(DYNAMIC_RENDER_PARAMS) || defined(VERTEX_FLAT_COLOR)
    , nointerpolation in float4 vertexFlatColor : COLOR1
#endif
#if defined(DYNAMIC_RENDER_PARAMS)
    , bool isFrontFace : SV_IsFrontFace
#endif
    , [[vk::location(0)]] [[vk::index(0)]] out float4 pixelColor : SV_TARGET0
#if !defined(RT64_SINGLE_SRC_BLEND)
    , [[vk::location(0)]] [[vk::index(1)]] out float4 pixelAlpha : SV_TARGET1
#endif
    , out float pixelDepth : SV_Depth
)
{
#if !defined(DYNAMIC_RENDER_PARAMS)
#if !defined(VERTEX_FLAT_COLOR)
    float4 vertexFlatColor = 0.0f;
#endif
    bool isFrontFace = false;
#endif
    float4 resultColor;
    float4 resultAlpha;
    if (!RasterPS(getRenderParams(), vertexPosition, vertexUV, vertexSmoothColor, vertexFlatColor, isFrontFace, resultColor, resultAlpha)) {
        discard;
    }

#if RDP_DEPTH_GATE
    // CV64 cont.23 Brick 1: the real RDP opaque depth gate is the sole depth arbiter when RECOMP_AB_RDPZ is on
    // (the GPU fixed-function compare is forced ALWAYS in rt64_raster_shader.cpp createPipeline).
    if (!n64DepthGate(getRenderParams(), vertexPosition)) {
        discard;
    }
#endif

#if defined(RT64_SINGLE_SRC_BLEND)
    // Without dualSrcBlend: fold the dual-source blend coefficient (resultAlpha.a) into the single
    // output's alpha; the pipeline blends single-source SRC_ALPHA / INV_SRC_ALPHA to match.
    pixelColor = float4(resultColor.rgb, resultAlpha.a);
#else
    pixelColor = resultColor;
    pixelAlpha = resultAlpha;
#endif

    // CV64 cont.20 magenta geometry separator (THROWAWAY — set CV64_AB_MAGENTA 0 to restore): paint
    // every rasterized pixel solid OPAQUE magenta, bypassing combiner/fog/lighting/blend. Decides the
    // layer of the view-dependent torso loss: if Malus's front torso shows MAGENTA from every angle ->
    // the geometry RASTERIZES and the loss is in the COLOR path (fog/lighting/combiner/blend). If it
    // stays a black HOLE -> the geometry isn't rasterizing (transform / W-clip / submission).

    // SESSION 28 cont.20 — REVERTED the cont.18h N64-coarse depth quantization. It fed RT64's OWN
    // GPU NDC depth (vertexPosition.z) into the N64 16-bit encoder, which expects the N64's screen-Z
    // (a different non-linear curve). Where RT64's curve is coarser, DISTINCT mid-scene depths collapse
    // into ties → with LESS_EQUAL the later-drawn surface wins → "back turrets drawn as front / violin
    // on top of bow" (opening castle cutscene). The GPU's finer native depth resolves that
    // ordering correctly. (If far-surface-vs-backdrop see-through returns, the real fix is to quantize
    // the N64's TRUE screen-Z, not RT64's NDC z — not this wrong-space round-trip.)
    // CV64 cont.23 — RE-APPLY the N64 16-bit depth quantization (cont.18h), now DATA-INFORMED by the
    // measured castle depth: screenZ crushed into [0.973..0.994], span 0.02. On N64's coarse far-end
    // 16-bit float-Z the coplanar far surfaces TIE and draw (LESS_EQUAL); on native D32 they land a hair
    // apart so the front fails LESS_EQUAL vs the backdrop -> "back of castle on front" see-through.
    // cont.21 PROVED vertexPosition.z IS the N64 screen-Z (RasterVS feeds posScreen as iPosition;
    // SV_Position.z = sz), so quantizing it through the N64 encoder is the CORRECT space (this retracts
    // cont.20's "NDC z" revert-reasoning). A faithful quantizer fixes the see-through WITHOUT breaking
    // distinct-depth ordering (turrets/violin stay in separate buckets). DUAL TEST in the opening castle
    // cutscene: (a) back-of-castle-on-front should CLEAR; (b) turret/violin layering must STAY correct.
    // If (b) regresses, the encoder is tying surfaces the N64 separates -> needs work. CV64_AB_NDEPTH 0 restores.
    pixelDepth = saturate(vertexPosition.z);
}
#endif