//
// RT64
//

#include "shared/rt64_other_mode.h"
#include "shared/rt64_raster_params.h"
#include "shared/rt64_render_flags.h"

#include "FbRendererCommon.hlsli"
#include "Library.hlsli"

[[vk::push_constant]] ConstantBuffer<RasterParams> gConstants : register(b0, space0);

LIBRARY_EXPORT void RasterVS(const RenderParams rp, in float4 iPosition, in float2 iUV, in float4 iColor, out float4 oPosition, out float2 oUV, out float4 oSmoothColor, out float4 oFlatColor) {
    float4 ndcPos = iPosition;
    
    // Skip any sort of transformation on the coordinates when rendering rects.
    if (!renderFlagRect(rp.flags)) {
        ndcPos.xy -= float2(FbParams.resolution / 2);
        ndcPos.xy /= float2(FbParams.resolution.x / 2.0f, FbParams.resolution.y / -2.0f);
        ndcPos.xyz *= ndcPos.w;
    }
    
    // Apply screen scale and offset.
    ndcPos.xy = (ndcPos.xy * gConstants.screenScale) + gConstants.screenOffset * ndcPos.w;
    
    // Output a fixed depth value for the entire triangle.
    const OtherMode otherMode = { rp.omL, rp.omH };
    const bool copyMode = (otherMode.cycleType() == G_CYC_COPY);
    const bool zSourcePrim = (otherMode.zSource() == G_ZS_PRIM);
    // CV64 cont.33 — castle ghost fix. Primitive depth (G_ZS_PRIM / gDPSetPrimDepth) is only meaningful
    // for RECTANGLES (texrect/fillrect), which carry no per-vertex Z. CV64 also sets G_ZS_PRIM with
    // primDepth=far on perspective TRIANGLE geometry (the entire castle cutscene: 181/181 opaque draws),
    // which pins every surface to the far plane → the Z-buffer can't separate them → painter's-order
    // "translucent castle" ghost (16-session bug). Triangles DO carry a real per-vertex Z, so apply the
    // primDepth override ONLY to rects; triangles keep their vertex Z. General + safe: every primDepth
    // value CV64 sets game-wide is far (verified), so no scene relies on a distinct primDepth for tris.
    if (!copyMode && zSourcePrim && renderFlagRect(rp.flags)) {
        const uint instanceIndex = instanceRenderIndices[gConstants.renderIndex].instanceIndex;
        ndcPos.z = instanceRDPParams[instanceIndex].primDepth.x * ndcPos.w;
    }

    oPosition = ndcPos;
    oUV = iUV;
    oSmoothColor = iColor;
    oFlatColor = iColor;
}

#if defined(DYNAMIC_RENDER_PARAMS)
RenderParams getRenderParams() {
    uint instanceIndex = instanceRenderIndices[gConstants.renderIndex].instanceIndex;
    return DynamicRenderParams[instanceIndex];
}
#elif defined(SPEC_CONSTANT_RENDER_PARAMS)
#   include "RenderParamsSpecConstants.hlsli"
#endif

#if defined(DYNAMIC_RENDER_PARAMS) || defined(SPEC_CONSTANT_RENDER_PARAMS)
void VSMain(
    in float4 iPosition : POSITION
    , in float2 iUV : TEXCOORD
    , in float4 iColor : COLOR
    , out float4 oPosition : SV_POSITION
    , out float2 oUV : TEXCOORD
    , out float4 oSmoothColor : COLOR0
#if defined(DYNAMIC_RENDER_PARAMS) || defined(VERTEX_FLAT_COLOR)
    , out float4 oFlatColor : COLOR1
#endif
)
{
#if !defined(DYNAMIC_RENDER_PARAMS) && !defined(VERTEX_FLAT_COLOR)
    float4 oFlatColor;
#endif
    RasterVS(getRenderParams(), iPosition, iUV, iColor, oPosition, oUV, oSmoothColor, oFlatColor);
}
#endif