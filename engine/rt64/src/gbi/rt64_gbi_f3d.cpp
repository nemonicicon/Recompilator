//
// RT64
//

#include "rt64_gbi_f3d.h"

#include <cassert>
#include <cstdlib>

#include "../include/rt64_extended_gbi.h"
#include "hle/rt64_interpreter.h"

#include "rt64_f3d.h"
#include "rt64_gbi_extended.h"
#include "rt64_gbi_rdp.h"

namespace RT64 {
    namespace GBI_F3D {
        void matrix(State *state, DisplayList **dl) {
            state->rsp->matrix((*dl)->w1, (*dl)->p0(16, 8));
        }

        void popMatrix(State *state, DisplayList **dl) {
            if ((*dl)->w1 == 0) {
                state->rsp->popMatrix(1);
            }
        }
        
        void moveMem(State *state, DisplayList **dl) {
            switch ((*dl)->p0(16, 8)) {
            case F3D_G_MV_VIEWPORT:
                state->rsp->setViewport((*dl)->w1);
                break;
            case F3D_G_MV_MATRIX_1:
                state->rsp->forceMatrix((*dl)->w1);
                *dl = *dl + 3;
                break;
            case F3D_G_MV_L0:
                state->rsp->setLight(0, (*dl)->w1);
                break;
            case F3D_G_MV_L1:
                state->rsp->setLight(1, (*dl)->w1);
                break;
            case F3D_G_MV_L2:
                state->rsp->setLight(2, (*dl)->w1);
                break;
            case F3D_G_MV_L3:
                state->rsp->setLight(3, (*dl)->w1);
                break;
            case F3D_G_MV_L4:
                state->rsp->setLight(4, (*dl)->w1);
                break;
            case F3D_G_MV_L5:
                state->rsp->setLight(5, (*dl)->w1);
                break;
            case F3D_G_MV_L6:
                state->rsp->setLight(6, (*dl)->w1);
                break;
            case F3D_G_MV_L7:
                state->rsp->setLight(7, (*dl)->w1);
                break;
            case F3D_G_MV_LOOKATX:
                state->rsp->setLookAt(0, (*dl)->w1);
                break;
            case F3D_G_MV_LOOKATY:
                state->rsp->setLookAt(1, (*dl)->w1);
                break;
            default:
                assert(false && "Unimplemented move mem.");
                break;
            }
        }
        
        void vertex(State *state, DisplayList **dl) {
            // [vtxraw 2026-08-28] instrument only, env RECOMP_VTX_RAW=1, default silent.
            // SOTE's tri1 was already MEASURED to pack its vertex indices as index*5 rather than
            // stock Fast3D's index*10 (raw bytes 0,5,10,...,75). Its microcode predates the retail
            // SDK, so G_VTX's parameter layout is not guaranteed to match stock either -- and if
            // the destination index or count is decoded from the wrong bits, vertices land in the
            // wrong cache slots and every triangle reads data that was never written, which is
            // exactly the observed "geometry enters the pipeline and emits no pixels".
            // Log the whole command word plus every plausible field layout at once, and the gcd of
            // the wide index field: a gcd of 5 would say the index arrives in STRIDE units too.
            {
                static const bool on = [] { const char *e = std::getenv("RECOMP_VTX_RAW"); return (e != nullptr) && (e[0] == '1'); }();
                if (on) {
                    static unsigned long long n = 0; static uint32_t gIdx8 = 0; static uint32_t maxIdx8 = 0, maxCnt = 0;
                    const uint32_t w0 = (*dl)->w0;
                    const uint32_t idx4 = (*dl)->p0(16, 4), cnt4 = (*dl)->p0(20, 4) + 1;
                    const uint32_t idx8 = (*dl)->p0(16, 8);
                    const uint32_t exCnt = (*dl)->p0(10, 6), exIdx = (*dl)->p0(17, 7);
                    uint32_t x = gIdx8, y = idx8;
                    while (y != 0) { uint32_t t = y; y = x % y; x = t; }
                    gIdx8 = x;
                    if (idx8 > maxIdx8) maxIdx8 = idx8;
                    if (cnt4 > maxCnt) maxCnt = cnt4;
                    n++;
                    if (n <= 10 || (n % 200000ULL) == 0) {
                        fprintf(stderr, "[vtxraw] n=%llu w0=%08X | stock(idx=%u,cnt=%u) | idx8=%u gcdIdx8=%u maxIdx8=%u maxCnt=%u | ex(cnt=%u,idx=%u)%c",
                                n, w0, idx4, cnt4, idx8, gIdx8, maxIdx8, maxCnt, exCnt, exIdx, 0x0A);
                        fflush(stderr);
                    }
                }
            }
            const GBI *gbi = state->ext.interpreter->hleGBI;
            const bool lenEnc = (gbi != nullptr) && gbi->flags.vtxLengthEncoded;
            if (lenEnc) {
                // SOTE's pre-SDK layout, measured: bits 0-7 = n*16-1, bits 9-15 = v0+n.
                const uint32_t n = (((*dl)->p0(0, 8) + 1u) >> 4);
                const uint32_t end = (*dl)->p0(9, 7);
                if ((n > 0u) && (end >= n)) {
                    state->rsp->setVertex((*dl)->w1, n, end - n);
                    return;
                }
                // Fall through to the stock decode if the command does not fit the layout, so a
                // malformed one degrades exactly as before instead of vanishing.
            }
            state->rsp->setVertex((*dl)->w1, (*dl)->p0(20, 4) + 1, (*dl)->p0(16, 4));
        }

        void runDl(State *state, DisplayList **dl) {
            if ((*dl)->p0(16, 1) == 0) {
                state->pushReturnAddress(*dl);
            }

            const uint32_t rdramAddress = state->rsp->fromSegmentedMasked((*dl)->w1);
            *dl = reinterpret_cast<DisplayList *>(state->fromRDRAM(rdramAddress)) - 1;
        }

        void endDl(State *state, DisplayList **dl) {
            *dl = state->popReturnAddress();
        }

        void sprite2DBase(State *state, DisplayList **dl) {
            // TODO
        }

        // Vertex-index stride for the triangle commands, from the matched microcode (see GBIFlags).
        // Stock Fast3D = 10; SOTE's pre-SDK microcode = 5, measured from its raw command bytes.
        static inline uint32_t triIndexDivisor(State *state) {
            // RECOMP_TRI_DIV overrides the profile value so the stride can be A/B'd on ONE binary
            // (off-instrument; unset = the microcode profile decides, which is the shipped path).
            static const uint32_t envDiv = [] {
                const char *e = std::getenv("RECOMP_TRI_DIV");
                return (e != nullptr) ? (uint32_t)strtoul(e, nullptr, 10) : 0u;
            }();
            if (envDiv != 0u) return envDiv;
            const GBI *g = state->ext.interpreter->hleGBI;
            const uint32_t d = (g != nullptr) ? g->flags.triIndexDivisor : 10u;
            return (d != 0u) ? d : 10u;
        }

        void tri1(State *state, DisplayList **dl) {
            // [tri1raw 2026-08-28] instrument only, env RECOMP_TRI1_RAW=1, default silent.
            // Stock F3D packs each vertex index as index*10 (the 10-byte DMEM vertex stride), which
            // is why this divides by 10. SOTE's microcode predates the retail SDK, and its geometry
            // is 75.8% DEGENERATE after transform (all three vertices projecting to one point,
            // measured by [vtxcensus]) -- exactly what a wrong stride does, since dividing a
            // smaller stride by 10 maps many distinct indices onto the same slot. Log the RAW
            // bytes: their greatest common divisor IS the real stride.
            {
                static const bool on = [] { const char *e = std::getenv("RECOMP_TRI1_RAW"); return (e != nullptr) && (e[0] == '1'); }();
                if (on) {
                    static unsigned long long n = 0; static uint32_t g = 0; static uint32_t maxRaw = 0;
                    const uint32_t r0 = (*dl)->p1(16, 8), r1 = (*dl)->p1(8, 8), r2 = (*dl)->p1(0, 8);
                    const uint32_t raws[3] = { r0, r1, r2 };
                    for (int i = 0; i < 3; i++) {
                        uint32_t v = raws[i];
                        if (v > maxRaw) maxRaw = v;
                        uint32_t x = g, y = v;            // gcd
                        while (y != 0) { uint32_t t = y; y = x % y; x = t; }
                        g = x;
                    }
                    n++;
                    if (n <= 8 || (n % 500000ULL) == 0) {
                        fprintf(stderr, "[tri1raw] n=%llu raw=(%u,%u,%u) gcd=%u maxRaw=%u -> /10 gives (%u,%u,%u)%c",
                                n, r0, r1, r2, g, maxRaw, r0 / 10, r1 / 10, r2 / 10, 0x0A);
                        fflush(stderr);
                    }
                }
            }
            const uint32_t vd = triIndexDivisor(state);
            state->rsp->drawIndexedTri((*dl)->p1(16, 8) / vd, (*dl)->p1(8, 8) / vd, (*dl)->p1(0, 8) / vd);
        }
        
        void quad(State *state, DisplayList **dl) {
            const uint32_t vd = triIndexDivisor(state);
            const uint8_t v0 = (*dl)->p1(24, 8) / vd;
            const uint8_t v1 = (*dl)->p1(16, 8) / vd;
            const uint8_t v2 = (*dl)->p1(8, 8) / vd;
            const uint8_t v3 = (*dl)->p1(0, 8) / vd;
            state->rsp->drawIndexedTri(v0, v1, v2);
            state->rsp->drawIndexedTri(v0, v2, v3);
        }

        void cullDl(State *state, DisplayList **dl) {
            // TODO
        }

        void moveWord(State *state, DisplayList **dl) {
            uint8_t type = (*dl)->p0(0, 8);
            switch (type) {
            case G_MW_MATRIX:
                assert(false);
                // TODO
                break;
            case G_MW_NUMLIGHT:
                state->rsp->setLightCount((((*dl)->w1 - 0x80000000) >> 5) - 1);
                break;
            case G_MW_CLIP:
                state->rsp->setClipRatioEdge(((*dl)->p0(8, 16) - G_MWO_CLIP_RNX) / 8, int16_t((*dl)->w1 & 0xFFFFU));
                break;
            case G_MW_SEGMENT:
                state->rsp->setSegment((*dl)->p0(10, 4), (*dl)->w1);
                break;
            case G_MW_FOG:
                state->rsp->setFog((int16_t)((*dl)->p1(16, 16)), (int16_t)((*dl)->p1(0, 16)));
                break;
            case G_MW_LIGHTCOL:
                state->rsp->setLightColor((*dl)->p0(8, 16) / 32, (*dl)->w1);
                break;
            case F3D_G_MW_POINTS: 
                state->rsp->modifyVertex((*dl)->p0(8, 16) / 40, (*dl)->p0(8, 16) % 40, (*dl)->w1);
                break;
            case G_MW_PERSPNORM:
                // TODO
                break;
            default:
                break;
            }
        }

        void texture(State *state, DisplayList **dl) {
            uint8_t tile = (*dl)->p0(8, 3);
            uint8_t level = (*dl)->p0(11, 3);
            uint8_t on = (*dl)->p0(0, 8);
            uint16_t sc = (*dl)->p1(16, 16);
            uint16_t tc = (*dl)->p1(0, 16);
            state->rsp->setTexture(tile, level, on, sc, tc);
        }

        void setOtherModeH(State *state, DisplayList **dl) {
            state->rsp->setOtherModeH((*dl)->p0(0, 8), (*dl)->p0(8, 8), (*dl)->w1);
        }

        void setOtherModeL(State *state, DisplayList **dl) {
            state->rsp->setOtherModeL((*dl)->p0(0, 8), (*dl)->p0(8, 8), (*dl)->w1);
        }

        void setGeometryMode(State *state, DisplayList **dl) {
            state->rsp->setGeometryMode((*dl)->w1);
        }

        void clearGeometryMode(State *state, DisplayList **dl) {
            state->rsp->clearGeometryMode((*dl)->w1);
        }

        void rdpHalf1(State *state, DisplayList **dl) {
            state->microcode.half1 = (*dl)->w1;
        }

        void rdpHalf2(State *state, DisplayList **dl) {
            state->microcode.half2 = (*dl)->w1;
        }

        void setColorImage(State *state, DisplayList **dl) {
            const uint8_t fmt = (*dl)->p0(21, 3);
            const uint8_t siz = (*dl)->p0(19, 2);
            const uint16_t width = (*dl)->p0(0, 12) + 1;
            const uint32_t address = (*dl)->w1;
            // [cimgraw] KI Gold 2026-08-29. See the twin in rt64_gbi_rdp.cpp -- THIS is the copy
            // that fires for F3D, which routes SETCIMG through RSP::setColorImage rather than the
            // RDP handler. Putting it only on the RDP path produced ZERO lines while
            // [badcolorimg] fired 32 times in the same run: same condition, different dispatch.
            // Why: [badcolorimg] rejects width 1000..3900 while fmt/siz decode SANE (0/2 =
            // RGBA/16-bit). A wholly corrupt word would corrupt all three fields, so the low 12
            // bits are suspect specifically -- the signature of a ucode keeping stock opcodes but
            // moving parameter bits (ucode_param_layouts, which cracked SOTE).
            // Capped at 24, and the cap is REPORTED so a count at the cap is never read as data.
            if (width == 0u || width > 1024u) {
                static int _n = 0;
                if (_n++ < 24) {
                    fprintf(stderr, "[cimgraw] #%d RAW w0=0x%08X w1=0x%08X -> fmt=%u siz=%u width=%u addr=0x%08X%s",
                            _n, (*dl)->w0, (*dl)->w1, (unsigned)fmt, (unsigned)siz,
                            (unsigned)width, address,
                            (_n == 24) ? "   <-- CAP REACHED, further lines suppressed\n" : "\n");
                    fflush(stderr);
                }
            }
            state->rsp->setColorImage(fmt, siz, width, address);
        }

        void setDepthImage(State *state, DisplayList **dl) {
            const uint32_t address = (*dl)->w1;
            state->rsp->setDepthImage(address);
        }

        void setTextureImage(State *state, DisplayList **dl) {
            const uint8_t fmt = (*dl)->p0(21, 3);
            const uint8_t siz = (*dl)->p0(19, 2);
            const uint16_t width = (*dl)->p0(0, 12) + 1;
            const uint32_t address = (*dl)->w1;
            state->rsp->setTextureImage(fmt, siz, width, address);
        }

        void reset(State *state) {
            state->rsp->setLookAtVectors(hlslpp::float3(0.0f, 1.0f, 0.0f), hlslpp::float3(1.0f, 0.0f, 0.0f));
            state->rsp->setFog(0x0100, 0x0000);
        }

        void setup(GBI *gbi) {
            gbi->constants = {
                { F3DENUM::G_MTX_MODELVIEW, 0x00 },
                { F3DENUM::G_MTX_PROJECTION, 0x01 },
                { F3DENUM::G_MTX_MUL, 0x00 },
                { F3DENUM::G_MTX_LOAD, 0x02 },
                { F3DENUM::G_MTX_NOPUSH, 0x00 },
                { F3DENUM::G_MTX_PUSH, 0x04 },
                { F3DENUM::G_TEXTURE_ENABLE, 0x00000002 },
                { F3DENUM::G_SHADING_SMOOTH, 0x00000200 },
                { F3DENUM::G_CULL_FRONT, 0x00001000 },
                { F3DENUM::G_CULL_BACK, 0x00002000 },
                { F3DENUM::G_CULL_BOTH, 0x00003000 }
            };
            
            gbi->map[F3D_G_SPNOOP] = &GBI_EXTENDED::noOpHook;
            gbi->map[F3D_G_MTX] = &matrix;
            gbi->map[F3D_G_MOVEMEM] = &moveMem;
            gbi->map[F3D_G_VTX] = &vertex;
            gbi->map[F3D_G_DL] = &runDl;
            gbi->map[F3D_G_ENDDL] = &endDl;
            gbi->map[F3D_G_SPRITE2D_BASE] = &sprite2DBase;
            gbi->map[F3D_G_TRI1] = &tri1;
            gbi->map[F3D_G_QUAD] = &quad;
            gbi->map[F3D_G_CULLDL] = &cullDl;
            gbi->map[F3D_G_POPMTX] = &popMatrix;
            gbi->map[F3D_G_MOVEWORD] = &moveWord;
            gbi->map[F3D_G_TEXTURE] = &texture;
            gbi->map[F3D_G_SETOTHERMODE_H] = &setOtherModeH;
            gbi->map[F3D_G_SETOTHERMODE_L] = &setOtherModeL;
            gbi->map[F3D_G_SETGEOMETRYMODE] = &setGeometryMode;
            gbi->map[F3D_G_CLEARGEOMETRYMODE] = &clearGeometryMode;
            gbi->map[F3D_G_RDPHALF_1] = &rdpHalf1;
            gbi->map[F3D_G_RDPHALF_2] = &rdpHalf2;
            gbi->map[G_SETCIMG] = &setColorImage;
            gbi->map[G_SETZIMG] = &setDepthImage;
            gbi->map[G_SETTIMG] = &setTextureImage;
            gbi->map[G_RDPNOOP] = &GBI_RDP::noOp;

            gbi->resetFromTask = &reset;
        }
    }
};