//
// RT64
//
// [F3DDKR 2026-09-04] Rare's in-house "DMA" Fast3D: Diddy Kong Racing ("Version 7.7 29/09/97 15.00
// L.Schuneman"), Jet Force Gemini and Mickey's Speedway USA. Stock Fast3D opcodes for state, RDP and
// DL control; five reassigned opcodes for geometry, all of which DMA their payload from RDRAM:
//   0x01 DMA_MTX   load one of four model-view matrices (the game pre-multiplies the projection)
//   0x02 DMA_TEX_OFFSET
//   0x04 DMA_VTX   10-byte vertices (x,y,z,r,g,b,a - NO texture coordinates)
//   0x05 DMA_TRI   16-byte triangles carrying their own per-vertex s/t
//   0x07 DMA_DL    a sub-list executed for an explicit command COUNT
//   0xBF DMA_OFFSETS  base offsets added to vertex / matrix DMA addresses
// Command layouts follow GLideN64's F3DDKR (the open reference for this family); the byte layouts
// of the DMA'd records are read through this engine's ^3-swizzled RDRAM. Before this handler set
// existed the DL census on DKR read: 199,098 commands / 500 lists, DROPPED(no handler)=39,408 -
// every 0x05 and 0x07 - and the game drew flat white panels where its textured geometry belongs.

#pragma once

#include "rt64_gbi.h"

#define F3DDKR_G_DMA_MTX        0x01
#define F3DDKR_G_DMA_TEX_OFFSET 0x02
#define F3DDKR_G_DMA_VTX        0x04
#define F3DDKR_G_DMA_TRI        0x05
#define F3DDKR_G_DMA_DL         0x07
#define F3DDKR_G_DMA_OFFSETS    0xBF
#define F3DDKR_VTX_APPEND       0x00010000

// [F3DDKR98 2026-09-06] The 1998 revision of the same microcode ("Version 1.1 14/03/98 15:50 The
// Overlord" - Jet Force Gemini and Mickey's Speedway USA, byte-identical gfx ucode). Same DMEM
// dispatch tables, same records, same opcodes; two of the geometry commands changed their PARAMETER
// layout, derived by disassembling both carts' RSP text (see rt64_gbi_f3ddkr.cpp for the field table).
#define F3DDKR98_MTX_MULTIPLY   0x00800000

namespace RT64 {
    namespace GBI_F3DDKR {
        void setup(GBI *gbi);
    };
    namespace GBI_F3DDKR98 {
        void setup(GBI *gbi);
    };
};
