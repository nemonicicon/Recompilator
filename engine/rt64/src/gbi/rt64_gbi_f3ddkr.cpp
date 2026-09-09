//
// RT64
//

#include "rt64_gbi_f3ddkr.h"

#include "hle/rt64_interpreter.h"

#include "rt64_gbi_f3d.h"

#include <cstdio>
#include <cstdlib>

namespace RT64 {
    // [dkrcensus 2026-09-06] instrument only, env RECOMP_DKR_CENSUS=1, default silent. It exists
    // because every DKR-family field guess costs a full build: it prints the RAW w0/w1 of the first
    // matrix and vertex commands plus a running histogram of the decoded fields, so "which bits carry
    // the matrix destination / the vertex count" is read off one boot instead of inferred from a
    // picture. Shared by both dialects so the two can be compared on the same stream.
    namespace GBI_DKRCensus {
        static bool enabled() {
            static const bool on = [] { const char *e = std::getenv("RECOMP_DKR_CENSUS"); return (e != nullptr) && (e[0] == '1'); }();
            return on;
        }

        static void matrix(const char *tag, uint32_t w0, uint32_t w1) {
            if (!enabled()) return;
            static unsigned long long n = 0, mul = 0;
            static unsigned long long dstHist[8] = {}, srcHist[8] = {}, lenHist[4] = {};
            n++;
            const uint32_t dst = (w0 >> 16) & 0x7u, src = (w0 >> 19) & 0x7u;
            const bool m = ((w0 & F3DDKR98_MTX_MULTIPLY) != 0u);
            dstHist[dst]++; srcHist[src]++; if (m) mul++;
            lenHist[((w0 & 0x1FFu) == 64u) ? 0 : 1]++;
            lenHist[((w0 & 0xFFFFu) == 64u) ? 2 : 3]++;
            if (n <= 12 || (n % 20000ULL) == 0) {
                fprintf(stderr, "[dkrcensus-mtx] %s #%llu w0=%08X w1=%08X dst=%u src=%u mul=%d len9=%u | mul=%llu dst{%llu,%llu,%llu,%llu,%llu,%llu,%llu,%llu} src{%llu,%llu,%llu,%llu,%llu,%llu,%llu,%llu} len9ok=%llu len16ok=%llu\n",
                        tag, n, w0, w1, dst, src, (int)m, (w0 & 0x1FFu), mul,
                        dstHist[0], dstHist[1], dstHist[2], dstHist[3], dstHist[4], dstHist[5], dstHist[6], dstHist[7],
                        srcHist[0], srcHist[1], srcHist[2], srcHist[3], srcHist[4], srcHist[5], srcHist[6], srcHist[7],
                        lenHist[0], lenHist[2]);
                fflush(stderr);
            }
        }

        static void vertex(const char *tag, uint32_t w0, uint32_t w1) {
            if (!enabled()) return;
            static unsigned long long n = 0, bit16 = 0, maxDst7 = 0, maxDst5 = 0, maxCount = 0;
            n++;
            const uint32_t cnt = (w0 >> 19) & 0x1Fu, dst7 = (w0 >> 9) & 0x7Fu, dst5 = (w0 >> 9) & 0x1Fu;
            if ((w0 & 0x00010000u) != 0u) bit16++;
            if (dst7 > maxDst7) maxDst7 = dst7;
            if (dst5 > maxDst5) maxDst5 = dst5;
            if (cnt > maxCount) maxCount = cnt;
            if (n <= 12 || (n % 20000ULL) == 0) {
                fprintf(stderr, "[dkrcensus-vtx] %s #%llu w0=%08X w1=%08X cnt=%u dst7=%u sub=%u bit16=%u len9=%u | bit16set=%llu maxDst7=%llu maxDst5=%llu maxCnt=%llu\n",
                        tag, n, w0, w1, cnt, dst7, (w0 >> 17) & 0x3u, (w0 >> 16) & 0x1u, (w0 & 0x1FFu),
                        bit16, maxDst7, maxDst5, maxCount);
                fflush(stderr);
            }
        }
    };

    namespace GBI_F3DDKR {
        // 0x01: G_MTX reassigned. DERIVED 2026-09-06 from DKR's own RSP text (handler at IMEM 0x358):
        // the handler stores w0[16:23] straight into the "current matrix" cell and uses it as a BYTE
        // OFFSET into the four-matrix table at DMEM 0x210, so the slot is w0[22:23] and the low six
        // bits of that byte are always zero. There is no source index and no multiply in this 1997
        // build - it copies the DMA'd 64 bytes into the slot and returns. w0[0:8] is the DMA length
        // (64); w1 is the matrix address, with the DMA offset applied (a no-op on DKR: its 0xBF
        // handler is a bare return, so DKR never sets one).
        void dmaMatrix(State *state, DisplayList **dl) {
            const uint32_t w0 = (*dl)->w0;
            GBI_DKRCensus::matrix("dkr", w0, (*dl)->w1);
            if ((w0 & 0xFFFFu) != 64u) {
                return;
            }
            state->rsp->dkrLoadMatrix((*dl)->w1, (w0 >> 22) & 0x3u, 0, false);
        }

        void dmaTexOffset(State *state, DisplayList **dl) {
            state->rsp->dkrTexOffset = (*dl)->w1;
            state->rsp->dkrTexOffsetCmds++;   // [dkrcensus] counter only
        }

        // 0x04: G_VTX reassigned. w0[16] = append (continue after the vertices already loaded; in
        // billboard mode appended vertices start at slot 1 because slot 0 is the billboard origin),
        // w0[19:23] = count - 1, w0[9:13] = extra destination offset. w1 = vertex DMA address.
        void dmaVertex(State *state, DisplayList **dl) {
            const uint32_t w0 = (*dl)->w0;
            GBI_DKRCensus::vertex("dkr", w0, (*dl)->w1);
            RSP *rsp = state->rsp.get();
            if ((w0 & F3DDKR_VTX_APPEND) != 0u) {
                if (rsp->dkrBillboard) {
                    rsp->dkrVertexIndex = 1;
                }
            }
            else {
                rsp->dkrVertexIndex = 0;
            }
            const uint32_t count = ((w0 >> 19) & 0x1Fu) + 1u;
            const uint32_t dst = rsp->dkrVertexIndex + ((w0 >> 9) & 0x1Fu);
            rsp->setVertexDKR((*dl)->w1, count, dst);
            rsp->dkrVertexIndex += count;
        }

        // 0x05: triangles DMA'd from RDRAM, each carrying its own s/t. w0[16:19] = texture on,
        // w0[20:23] = count - 1, w1 = triangle list address.
        void dmaTriangles(State *state, DisplayList **dl) {
            const uint32_t w0 = (*dl)->w0;
            const uint32_t texOn = (w0 >> 16) & 0xFu;
            const uint32_t count = ((w0 >> 20) & 0xFu) + 1u;
            state->rsp->drawTrianglesDKR((*dl)->w1, count, texOn);
            state->rsp->dkrVertexIndex = 0;
        }

        // 0x07: run a sub-list for exactly w0[16:23] commands (it need not end in G_ENDDL). The
        // commands are dispatched through the same map the walker uses, so a nested G_DL / G_ENDDL
        // inside the counted list pushes and pops the return stack exactly as it would at top level.
        void dmaDisplayList(State *state, DisplayList **dl) {
            const uint32_t count = ((*dl)->w0 >> 16) & 0xFFu;
            const uint32_t rdramAddress = state->rsp->fromSegmentedMasked((*dl)->w1);
            if ((rdramAddress == 0u) || (count == 0u)) {
                return;
            }
            GBI *gbi = state->ext.interpreter->hleGBI;
            if (gbi == nullptr) {
                return;
            }
            DisplayList *sub = reinterpret_cast<DisplayList *>(state->fromRDRAM(rdramAddress));
            for (uint32_t i = 0; i < count; i++, sub++) {
                const uint8_t opCode = uint8_t(sub->w0 >> 24);
                if (opCode == F3D_G_ENDDL) {
                    break;
                }
                GBIFunction func = gbi->map[opCode];
                if (func != nullptr) {
                    func(state, &sub);
                }
            }
        }

        // 0xBF: base offsets folded into every matrix (w0[0:23]) and vertex (w1[0:23]) DMA address.
        void dmaOffsets(State *state, DisplayList **dl) {
            state->rsp->dkrMatrixOffset = (*dl)->w0 & 0x00FFFFFFu;
            state->rsp->dkrVertexOffset = (*dl)->w1 & 0x00FFFFFFu;
            state->rsp->dkrOffsetsCmds++;   // [dkrcensus] counter only
        }

        // 0xBC: two extra move-word indices. 0x02 = billboard mode (w1 & 1); 0x0A = select which of
        // the four loaded model-view matrices transforms the vertices that follow (w1[6:7]).
        void moveWord(State *state, DisplayList **dl) {
            const uint32_t index = (*dl)->w0 & 0xFFu;
            state->rsp->dkrMoveWordIndex[index & 0xFFu]++;   // [dkrcensus] counter only
            switch (index) {
            case 0x02:
                state->rsp->dkrBillboard = (((*dl)->w1 & 0x1u) != 0u);
                break;
            case 0x0A:
                state->rsp->dkrSelectFromMoveWord++;   // [dkrcensus] counter only
                state->rsp->dkrSelectMatrix(((*dl)->w1 >> 6) & 0x3u);
                break;
            default:
                GBI_F3D::moveWord(state, dl);
                break;
            }
        }

        void setup(GBI *gbi) {
            GBI_F3D::setup(gbi);

            gbi->map[F3DDKR_G_DMA_MTX] = &dmaMatrix;
            gbi->map[F3DDKR_G_DMA_TEX_OFFSET] = &dmaTexOffset;
            gbi->map[F3DDKR_G_DMA_VTX] = &dmaVertex;
            gbi->map[F3DDKR_G_DMA_TRI] = &dmaTriangles;
            gbi->map[F3DDKR_G_DMA_DL] = &dmaDisplayList;
            gbi->map[F3DDKR_G_DMA_OFFSETS] = &dmaOffsets;   // replaces F3D's G_TRI1 slot: DKR never emits TRI1
            gbi->map[F3D_G_MOVEWORD] = &moveWord;
        }
    }

    // ── [F3DDKR98 2026-09-06] the 1998 revision ("The Overlord"): JFG + Mickey's Speedway ─────────
    // Everything below is READ OUT OF THE MICROCODE, not inferred from a picture. Both carts' RSP
    // text was disassembled (rabbitizer, RSP category) after recovering the IMEM layout from each
    // ucode's own overlay table at DMEM 0x00: the main body loads at IMEM 0x080, a 0x88-byte overlay
    // at 0x000 holds the DL fetch loop and the reciprocal, and the clipper overlay loads at 0x870
    // (JFG) / 0x7D8 (DKR). Commands 0x00-0x3F share one entry: the ucode DMAs w0[0:8] BYTES from
    // (base + w1) into DMEM 0x870 - base = DMEM 0x210 for 0x01 and DMEM 0x214 for 0x04, both set by
    // 0xBF - then dispatches through the halfword table at DMEM 0xC4 + cmd*2. The two commands whose
    // PARAMETERS changed between the 1997 and 1998 builds:
    //
    //   cmd  field        DKR 1997 (IMEM 0x358 / 0x46C)      JFG 1998 (IMEM 0x3A8 / 0x514)
    //   0x01 slot table   DMEM 0x210, 4 slots                DMEM 0x220, 8 slots
    //        destination  w0[22:23] (byte offset w0[16:23])  w0[16:18]
    //        source       -                                  w0[19:21]
    //        multiply     -                                  w0[23]: slot[dst] = DMA'd x slot[src]
    //   0x04 count        w0[19:23] + 1                      w0[19:23]  (0 still loads one)
    //        destination  w0[16] ? running index : 0         w0[9:15], absolute
    //        sub-offset   w0[17:18] * 2                      w0[17:18] * 2   (same; RT64 reads the
    //                                                        exact byte address so it needs neither)
    //
    // The multiply is the 1998 build's model/view split: the DMA'd matrix is the LEFT operand, so in
    // this engine's row-vector convention it is applied first - mul(loaded, slot[src]) - exactly the
    // order dkrLoadMatrix already used. Decoding JFG with DKR's layout put every matrix in slot 0,
    // never composed one, and loaded count+1 vertices at an index that drifted with a counter the
    // 1998 ucode does not have; the triangles that follow then index vertices that were never loaded.
    namespace GBI_F3DDKR98 {
        // 0x01: w0[16:18] destination, w0[19:21] source, w0[23] multiply, w0[0:8] DMA length (64).
        void dmaMatrix(State *state, DisplayList **dl) {
            const uint32_t w0 = (*dl)->w0;
            GBI_DKRCensus::matrix("98", w0, (*dl)->w1);
            if ((w0 & 0x1FFu) != 64u) {
                return;
            }
            state->rsp->dkrLoadMatrix((*dl)->w1, (w0 >> 16) & 0x7u, (w0 >> 19) & 0x7u,
                                      (w0 & F3DDKR98_MTX_MULTIPLY) != 0u);
        }

        // 0x04: w0[19:23] = vertex count (the 1998 build dropped DKR's +1; a zero count still writes
        // one vertex because the ucode stores the first before testing the counter), w0[9:15] = the
        // absolute destination slot in the 24-entry DMEM vertex buffer at 0x370.
        void dmaVertex(State *state, DisplayList **dl) {
            const uint32_t w0 = (*dl)->w0;
            GBI_DKRCensus::vertex("98", w0, (*dl)->w1);
            uint32_t count = (w0 >> 19) & 0x1Fu;
            if (count == 0u) {
                count = 1u;
            }
            RSP *rsp = state->rsp.get();
            const uint32_t dst = (w0 >> 9) & 0x7Fu;
            rsp->setVertexDKR((*dl)->w1, count, dst);
            rsp->dkrVertexIndex = dst + count;
        }

        // 0xBC index 0x0A selects among EIGHT matrices here (the move-word writes the byte offset
        // into the same DMEM 0x148 cell the matrix command writes, and the table is 8 x 64 bytes).
        void moveWord(State *state, DisplayList **dl) {
            const uint32_t index = (*dl)->w0 & 0xFFu;
            if (index == 0x0Au) {
                state->rsp->dkrMoveWordIndex[index & 0xFFu]++;   // [dkrcensus] counter only
                state->rsp->dkrSelectFromMoveWord++;             // [dkrcensus] counter only
                state->rsp->dkrSelectMatrix(((*dl)->w1 >> 6) & 0x7u);
                return;
            }
            GBI_F3DDKR::moveWord(state, dl);
        }

        void setup(GBI *gbi) {
            GBI_F3DDKR::setup(gbi);

            gbi->map[F3DDKR_G_DMA_MTX] = &dmaMatrix;
            gbi->map[F3DDKR_G_DMA_VTX] = &dmaVertex;
            gbi->map[F3D_G_MOVEWORD] = &moveWord;
        }
    }
};
