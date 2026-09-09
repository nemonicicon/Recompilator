//
// RT64
//
// CV64 cont.23 — BRICK 1 of Option D (accurate-RDP depth gate). Clears the programmable N64 depth store
// (the rasterizer-ordered UAV that RasterPS() read-modify-writes with the real RDP coplanar/dz compare) to a
// given far value over a rectangle, mirroring the game's Z-buffer FillRect so the two depth representations
// stay in lockstep. Stock RT64 has no UAV-clear primitive (plume only exposes clearColor/clearDepthStencil
// on attachments), hence this minimal compute pass. The thread grid is sized to the rect; coords are
// absolute pixels offset by the rect origin.

struct ClearN64DepthCB {
    float depthValue;
    uint left;
    uint top;
    uint right;
    uint bottom;
    uint pad0;
    uint pad1;
    uint pad2;
};

[[vk::push_constant]] ConstantBuffer<ClearN64DepthCB> gConstants : register(b0, space0);

RWTexture2D<float> gN64Depth : register(u0, space0);

[numthreads(8, 8, 1)]
void CSMain(uint3 coord : SV_DispatchThreadID) {
    uint2 pixel = uint2(gConstants.left, gConstants.top) + coord.xy;
    if ((pixel.x >= gConstants.right) || (pixel.y >= gConstants.bottom)) {
        return;
    }

    gN64Depth[pixel] = gConstants.depthValue;
}
