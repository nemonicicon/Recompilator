//
// RT64
//

#include "rt64_rsp.h"

#include <cassert>
#include <cstdio>   // cv64: diagnostic probes (matrixCommon / drawIndexedTri)
#include <cstdint>
#include <cstdlib>  // getenv: env-gated viewport diagnostic (RT64_VP_LOG)

// For the full GBIUCode definition (rt64_rsp.h only forward-declares it). Lets
// setGBI() record the active microcode and branchZ/branchW gate the global
// forceBranch enhancement to the F3DEX2 family.
#include "gbi/rt64_gbi.h"

// cv64 (TLB LLE, P3b): the GPU resolves overlay-window (0x0E/0x0F) segmented
// addresses through the SAME TLB as the CPU (recomp_tlb_translate in librecomp's
// tlb.cpp). This keeps CPU and GPU in agreement once overlays move to unique
// physical slabs. Inert while TLB mappings are identity. Resolved at final link.
extern "C" uint32_t recomp_tlb_translate(uint32_t vaddr);
// [ovlres] overlay 0x0F TLB-slot diagnostics (defined in librecomp tlb.cpp).
extern "C" volatile uint32_t g_ovl_cur_buffer;
extern "C" volatile uint32_t g_ovl_map_count;
// SESSION 28 cont.13 — render-collision fix. recomp_overlay_base_for (librecomp tlb.cpp) returns the
// overlay buffer that owns a given physical address; g_cv64_cur_dl_phys is the physical address of the DL
// command RT64 is currently walking (set per-command by Interpreter::processDisplayLists). Together they
// let a 0x0F ref resolve to the overlay buffer that OWNS the current DL instead of the stale shared slot.
extern "C" uint32_t recomp_overlay_base_for(uint32_t phys);
extern "C" { volatile uint32_t g_cv64_cur_dl_phys = 0u; }
// CV64 Brick 4 (Option D): the LLE F3DEX2's faithful per-triangle screen-Z (defined in
// librecomp/src/rsp.cpp), consumed here by ORDINAL correlation. g_lle_z_consume_idx is reset per gfx
// task in RT64Context::send_dl (before processDisplayLists); drawTriangle increments it per perspective
// triangle and overrides that triangle's depth with the real N64 value (no-op unless CV64_GFX_LLE ran).
extern "C" { extern float g_lle_faithful_z[131072]; extern volatile uint32_t g_lle_faithful_z_count; }
extern "C" { uint32_t g_lle_z_consume_idx = 0u; }

// ─── cv64 S41: HARDWARE-TIMING FIDELITY LAYER (the DK64-vine class; the narrator-skip cure) ────────
// Our N64's RDP is infinitely fast; the real one wasn't. Games tuned content to the resulting lag (the
// CV64 intro: voice trigger at tick 940 assumes ≈21fps actual against a 30fps cap — real hardware
// footage). We model the real RDP's frame cost from HARDWARE CONSTANTS (no per-game/per-scene logic):
//   RDP clock 62.5 MHz · 1-cycle ≈ 1 pixel/clock · 2-cycle ≈ 2 clocks/pixel · fill ≈ 0.25 (16-bit)
//   · copy ≈ 0.5 · triangle setup ≈ 200 clocks · ×RDRAM-contention factor ≈ 2.5 (Z+blend read-modify-
//   write share the bus with CPU/VI — the documented real-world throughput gap vs theoretical).
// rt64 accumulates the estimated cycles per submitted DL here; ultramodern's gfx thread then delays
// dp_complete until the real RDP would have finished → the game's OWN pacing logic drops frames exactly
// like hardware → lag-tuned content (voice triggers, demos, the DK64 vines) lands correctly. Faithful,
// game-agnostic; the script/data is never touched. Gate: env RECOMP_AUTHENTIC_TIMING (default off).
extern "C" { double g_rdp_estimated_cost_cycles = 0.0; }
// Calibration v2 (S41, from a measured run): v1's 2.5x contention stacked on the 2-cycle cost pinned the
// intro at the 100ms clamp (10fps) vs the measured ~21fps hardware truth — the real RDP's span buffers
// absorb much of the RDRAM contention. 1.5x + 120-cycle setup lands the intro in the 17-25fps band and
// leaves light scenes (menus ~8ms) at their authored rate.
// v3 calib (S41): contention 1.0 = the pure documented pipeline rate (1 pix/clock 1-cycle, 2 clocks
// 2-cycle), no added memory penalty. Anchored against real-hardware footage: the intro's true mix is
// ~17% 2-VI / 83% 3-VI frames (910 ticks in 43s); at 1.0 the lighter intro frames fall under the 33ms
// VI line reproducing the mix, and normal gameplay frames return to the authored 30fps.
static const double RDP_TRI_SETUP_CYCLES = 120.0;
static const double RDP_CONTENTION = 1.0;

// TIMING_FIDELITY_DESIGN P1 — v2 counting-mode accumulators. LOG-ONLY: no consumer acts on these
// (A1 inertness); they exist so P2 calibration has real per-mode pixel/span data. Buckets:
// [0]=FILL [1]=COPY [2]=1CYCLE [3]=2CYCLE. lines = scissor-clamped scanline count (the span count
// the real RDP walks). setup = per-primitive setup cycles (tri 120 / rect 64, v1's constants).
// Reset + report in ultramodern events.cpp around send_dl. Same extern-"C" bridge as v1 above.
extern "C" {
double g_rdptime2_pix[4] = {0.0, 0.0, 0.0, 0.0};
double g_rdptime2_lines = 0.0;
double g_rdptime2_setup = 0.0;
unsigned long long g_rdptime2_prims = 0;
}

// cv64 (session 10/11): 3D-pipeline diagnostics + forced-bright-ambient visual test.
// NEAR-PLANE SHARDS: a vertex with clip w <= 0 is behind or at the near plane, and the perspective
// divide then throws it to a screen corner, so triangles touching the plane stretch into shards.
// The real RSP near-clips those triangles before the divide; this HLE path does not.
//
// DO NOT RE-ENABLE the CPU-side clip. Two CPU attempts and one shader attempt all regressed: even
// with the triangle-count accounting fixed it made Wave Race WORSE, with popping textures from
// injected-vertex stream corruption. Geometry grazing a water plane needs a different approach,
// starting from a capture of triangle CONNECTIVITY - every prior analysis paired non-adjacent
// vertices. The Rare DMA Fast3D families DO get a faithful near-plane clip, because their own
// microcode performs one; that is [dkrnearclip] further down and is unrelated to this.

#include "../include/rt64_extended_gbi.h"
#include "common/rt64_common.h"
#include "common/rt64_math.h"
#include "gbi/rt64_f3d.h"
#include "shared/rt64_rsp_fog.h"

#include "rt64_interpreter.h"
#include "rt64_state.h"

//#define LOG_SPECIAL_MATRIX_OPERATIONS

namespace RT64 {
    // RSP

    constexpr float DepthRange = 1024.0f;

    RSP::RSP(State *state) {
        this->state = state;

        NoN = false;
        cullBothMask = 0;
        cullFrontMask = 0;
        projMask = 0;
        loadMask = 0;
        pushMask = 0;
        shadingSmoothMask = 0;
        currentUCode = GBIUCode::Unknown;

        segments.fill(0);
        reset();
    }

    void RSP::reset() {
        modelMatrixStackSize = 1;
        projectionMatrixStackSize = 1;
        viewportStackSize = 1;
        geometryModeStackSize = 1;
        otherModeStackSize = 1;
        modelMatrixStack.fill(hlslpp::float4x4(0.0f));
        modelMatrixSegmentedAddressStack.fill(0);
        modelMatrixPhysicalAddressStack.fill(0);
        viewMatrixStack[0] = hlslpp::float4x4(0.0f);
        projMatrixStack[0] = hlslpp::float4x4(0.0f);
        viewProjMatrixStack[0] = hlslpp::float4x4(0.0f);
        invViewProjMatrixStack[0] = hlslpp::float4x4(0.0f);
        vertices.fill({});
        indices.fill(0);
        used.reset();
        lights.fill({});
        segments.fill(0);
        viewportStack[0] = {};
        clipRatios[0] = 1;
        clipRatios[1] = 1;
        clipRatios[2] = -1;
        clipRatios[3] = -1;
        textureState = {};
        curViewProjIndex = 0;
        curTransformIndex = 0;
        curFogIndex = 0;
        curLightIndex = 0;
        curLightCount = 0;
        curLookAtIndex = 0;
        projectionIndex = -1;
        projectionMatrixChanged = false;
        projectionMatrixInversed = false;
        viewportChanged = false;
        modelViewProjMatrix = hlslpp::float4x4(0.0f);
        modelViewProjChanged = false;
        modelViewProjInserted = false;
        lightCount = 0;
        lightsChanged = false;
        vertexFogIndex = 0;
        vertexLightIndex = 0;
        vertexLightCount = 0;
        vertexLookAtIndex = 0;
        vertexColorPDAddress = 0;
        fog.mul = 0.0f;
        fog.offset = 0.0f;
        lookAt.x = { 0.0f, 0.0f, 0.0f };
        lookAt.y = { 0.0f, 0.0f, 0.0f };
        otherModeStack[0].L = 0x0;
        otherModeStack[0].H = 0x080CFF;
        geometryModeStack[0] = G_CLIPPING;
        fogChanged = true;
        lookAtChanged = true;

        clearExtended();
    }

    constexpr uint32_t ExtendedMask = 0x80000000U;

    // Masks addresses as the RSP DMA hardware would.
    template<uint32_t mask> uint32_t RSP::maskPhysicalAddress(uint32_t address) {
        if (state->extended.extendRDRAM && ((address & ExtendedMask) == ExtendedMask)) {
            return address - ExtendedMask;
        }
        else {
            return address & mask;
        }
    }

    // Performs a lookup in the segment table to convert the given address.
    uint32_t RSP::fromSegmented(uint32_t segAddress) {
        if (state->extended.extendRDRAM && ((segAddress & ExtendedMask) == ExtendedMask)) {
            return segAddress;
        }
        else {
            // cv64 (session 11): if a segment slot was never initialized by gSPSegment
            // (segments[N] == 0), fall back to identity (segment N → 0x0N000000).
            // On real N64 with TLB, segments like 0xF would resolve via TLB to wherever the
            // OS mapped them; our flat-RDRAM port places overlay data at rdram[0x0N000000+offset]
            // directly, so identity defaults give the game the addresses it expects. Without
            // this, cutscene_01 (which assumes seg 0xF maps to its overlay data) submits sub-DLs
            // resolving to rdram[0x00000470] (boot ROM zeros) → infinite DL loop → 346 BAILs/run.
            const uint32_t seg = (segAddress >> 24) & 0x0F;
            uint32_t base = segments[seg];
            if (base == 0) base = seg << 24;
            return base + (segAddress & 0x00FFFFFF);
        }
    }

    // Converts the given segmented address and then applies the RSP DMA physical address mask.
    // Used in cases where the RSP performs a DMA with a segmented address as the input.
    // cv64 (session 20): the session-11 wide mask (0x1FFFFFF8) was the bug behind the post-prologue
    // freeze. CV64's figure code builds segment bases as fileBase + segmentedOffset, e.g.
    // 0x80274378 + 0x06000040 = 0x862743B8 — the 0x06 segment nibble leaks into the high byte. On
    // real N64 this is harmless: the RSP masks segment-resolved addresses to 24-bit physical RDRAM
    // (0x862743B8 -> 0x2743B8). The wide 512MB mask kept the leaked nibble (-> 0x062743B8, a wild
    // read) -> corrupt DL pointers -> dlguard bail -> graphics/main thread deadlock -> black screen.
    // Fix: mask to 24-bit physical like the hardware, BUT preserve the 0x0E/0x0F overlay window that
    // our flat-RDRAM port populates at rdram[0x0E000000..0x0FFFFFFF] (identity-defaulted segs 0xE/0xF).
    uint32_t RSP::fromSegmentedMasked(uint32_t segAddress) {
        uint32_t addr = fromSegmented(segAddress);
        if ((addr & 0xFE000000u) == 0x0E000000u) {
            // Overlay window: resolve through the LLE TLB (same as the CPU's CV64_PHYS).
            // The TLB output is already clean physical, so a 29-bit mask is safe here
            // (it allows overlay slabs above the 0x0F window) — unlike masking the raw
            // segmented address, which was the session-20 leaked-nibble bug. 8-byte align.
            // [ovlres] PROVE the collision: ONE shared 0x0F slot, re-pointed per-entity by the CPU,
            // read async by this render thread. Log when the slot's target buffer changes: how many
            // overlay-window resolves used the previous buffer, vs how many times the CPU re-mapped
            // the slot. Many draws against a buffer the CPU has long since moved past = the glitch.
            static uint32_t _ovl_last = 0xFFFFFFFFu, _ovl_draws = 0u; static int _ovl_n = 0;
            uint32_t cur = g_ovl_cur_buffer;
            if (cur != _ovl_last) {
                if (_ovl_n < 250) {
                    _ovl_n++;
                    fprintf(stderr, "[ovlres] GPU overlay buffer 0x%08X -> 0x%08X after %u resolves | CPU re-mapped 0x0F slot %u times total\n",
                        _ovl_last, cur, _ovl_draws, (unsigned)g_ovl_map_count);
                    fflush(stderr);
                }
                _ovl_last = cur; _ovl_draws = 0u;
            } else {
                _ovl_draws++;
            }
            // cont.13: resolve to the overlay buffer that OWNS the DL currently being walked
            // (g_cv64_cur_dl_phys), not the stale shared slot — the render-collision fix. 'addr' is the
            // identity-defaulted 0x0F000000+off here, so (addr & 0xFFFFFF) is the overlay-relative offset.
            uint32_t _ovlBase = recomp_overlay_base_for(g_cv64_cur_dl_phys);
            static uint32_t _cCont=0u,_cTlb=0u,_cTot=0u; static int _ccl=0;   // [ovl0f] resolution-path census
            if ((++_cTot % 4000u)==0u && _ccl++ < 30) { fprintf(stderr,"[ovl0f] census container=%u tlb=%u (tot=%u)\n",_cCont,_cTlb,_cTot); fflush(stderr); }
            if (_ovlBase != 0u) { _cCont++; return (_ovlBase + (addr & 0x00FFFFFFu)) & 0x1FFFFFF8u; }   // cont.13: DL container
            // cont.38 FAITHFUL: frame-DL 0x0F ref — the GPU is in the TOP-LEVEL frame DL, not inside an
            // overlay buffer, so the container path can't bind it. Resolve through the REAL page-granular
            // hardware TLB (recomp_tlb_translate), exactly as the RCP would on hardware. This DELETES the
            // cont.36b/37 seg6-1 BAND-AID, which guessed the base from segments[6] and added the FULL 24-bit
            // offset (base + 0x6640) — overshooting for cutscene_01/02's intro DL into zeroed RAM (0x2A7A68)
            // → a 1,000,000-NOOP runaway DL → dlguard bail EVERY frame → the intro castle scene never cleared
            // (the intro castle scene did not clear; skipping it, the game was fine after). The page-granular
            // TLB matches the hardware mapping (0x0F006640 → 0x2A1640), and it's the SAME path that
            // fromSegmentedMaskedPD already uses (its seg6 path was disabled in cont.36). Faithful,
            // game-agnostic — no per-figure/per-scene logic. If a multi-figure scene (weretiger) needs the
            // build-time TLB state (async staleness), that is a deeper faithful layer, not the seg6-1 guess.
            _cTlb++;
            uint32_t _tlb = recomp_tlb_translate(addr) & 0x1FFFFFF8u;
            { static int _o = 0; if (_o++ < 80) {
                fprintf(stderr, "[ovl0f] FRAME-DL seg=0x%08X dlphys=0x%08X -> tlb=0x%08X (seg6=0x%08X ovlCur=0x%08X)\n",
                    segAddress, (unsigned)g_cv64_cur_dl_phys, _tlb, segments[6], (unsigned)g_ovl_cur_buffer); fflush(stderr); } }
            return _tlb;
        }
        return maskPhysicalAddress<0x00FFFFF8>(addr);       // normal: hardware-faithful 24-bit mask
    }

    uint32_t RSP::fromSegmentedMaskedPD(uint32_t segAddress) {
        uint32_t addr = fromSegmented(segAddress);
        if ((addr & 0xFE000000u) == 0x0E000000u) {
            uint32_t _ovlBase = recomp_overlay_base_for(g_cv64_cur_dl_phys);   // cont.13 (see fromSegmentedMasked)
            if (_ovlBase != 0u) return (_ovlBase + (addr & 0x00FFFFFFu)) & 0x1FFFFFFCu;
            uint32_t _fileBasePD = 0u;  // cont.36: seg6 path DISABLED (wrong premise — see fromSegmentedMasked)
            if (_fileBasePD != 0u) return (_fileBasePD + (addr & 0x00FFFFFFu)) & 0x1FFFFFFCu;
            return recomp_tlb_translate(addr) & 0x1FFFFFFCu; // fallback (KEPT): shared slot, 4-byte align
        }
        return maskPhysicalAddress<0x00FFFFFC>(addr);
    }

    // [dkrvtxalign 2026-09-06] Rare's DMA Fast3D vertex fetch is TWO-byte granular, not eight.
    // The RSP's DMA engine can only start a transfer on an 8-byte RDRAM boundary, so both dialects
    // of the microcode DMA from (w1 & ~7) into the DMEM scratch at 0x870 and then read the first
    // record at 0x870 + w0[17:18]*2 - and w0[17:18]*2 is exactly (w1 & 6) in every G_VTX the three
    // carts emit (measured with [dkrcensus-vtx]: DKR w1=0x1D9770 sub=0, w1=0x1D97AC sub=2;
    // Mickey w1=0x2A7DE0/0x2A7E8A/0x2A7DF4/0x2A7E9E sub=0/1/2/3; JFG w1=...030C sub=2). The net
    // effective source address is therefore w1 itself. Because the vertex record is TEN bytes,
    // three batches in four start off an 8-byte boundary, and resolving them through the general
    // 8-byte physical mask shifts x, y, z and rgba of every vertex in the batch by 2, 4 or 6 bytes
    // (proved on Mickey: the record at 0x2A7E8A read at 0x2A7E88 returned the previous record's
    // last two colour bytes as x). Same 24-bit physical mask as fromSegmentedMasked, 2-byte align.
    uint32_t RSP::fromSegmentedMaskedDKR(uint32_t segAddress) {
        const uint32_t addr = fromSegmented(segAddress);
        if ((addr & 0xFE000000u) == 0x0E000000u) {
            // The CV64 overlay window keeps its own resolution path untouched.
            return fromSegmentedMasked(segAddress);
        }

        return maskPhysicalAddress<0x00FFFFFE>(addr);
    }

    // cv64 S39 [fire]: ring of the last 8 gsSPSegment(5,...) values — the variable-texture patches.
    // Dumped by the flame-push probe (rt64_interpreter) to see whether the flame's own patch arrives
    // (expected ~0x861D82xx = fileBase + 0x0600C200 + frame*0x800) and what overwrites it.
    extern "C" { uint32_t g_cv64_seg5_ring[8]; uint32_t g_cv64_seg5_ring_idx = 0; }

    void RSP::setSegment(uint32_t seg, uint32_t address) {
        assert(seg < RSP_MAX_SEGMENTS);
        segments[seg] = address;
        if (seg == 5) { g_cv64_seg5_ring[(g_cv64_seg5_ring_idx++) & 7u] = address; }
        // cont.37 FAITHFUL probe (Bug C, source-level): what does CV64 write to the RSP segment table?
        // Ground-truth for the hardware question — is seg 0x0F (or seg 0x0E) ever set in the DL stream
        // (the faithful way the RCP resolves overlay refs), and is it set PER FIGURE? If yes → RT64 must
        // honor it (we currently force the TLB). If it's NEVER set → the refs resolve some other faithful
        // way RT64 isn't reproducing. Logs seg + addr (capped).
        // Skip seg 0 (identity) and seg 6 (per-figure asset, already understood) so the cap captures the
        // INTERESTING segments during gameplay — esp. any 0x0E/0x0F set per figure.
        // cont.38: also skip seg 8 + 0xA (the intro cutscene sets these 150x each → they exhausted the
        // 300 cap before reaching Forest gameplay). Now the cap captures the INTERESTING gameplay segments
        // — above all any 0xE/0xF set per figure (the Bug C gating question).
        { static int _ss = 0; if (seg != 0 && seg != 6 && seg != 8 && seg != 0xA && _ss++ < 300) {
            fprintf(stderr, "[setseg] seg=0x%X addr=0x%08X\n", seg, address); fflush(stderr); } }
    }

    void RSP::matrixCommon(const hlslpp::float4x4 &floatMatrix, uint32_t address, uint8_t params) {
        // cv64 (session 15, Alucard): log EVERY matrix call with raw params + masks (gated).
        // Projection matrix.
        hlslpp::float4x4 &viewMatrix = viewMatrixStack[projectionMatrixStackSize - 1];
        hlslpp::float4x4 &projMatrix = projMatrixStack[projectionMatrixStackSize - 1];
        hlslpp::float4x4 &viewProjMatrix = viewProjMatrixStack[projectionMatrixStackSize - 1];
        uint32_t &projectionMatrixSegmentedAddress = projectionMatrixSegmentedAddressStack[projectionMatrixStackSize - 1];
        uint32_t &projectionMatrixPhysicalAddress = projectionMatrixPhysicalAddressStack[projectionMatrixStackSize - 1];
        if (params & projMask) {
            if (params & loadMask) {
                viewProjMatrix = floatMatrix;

                if (isMatrixViewProj(floatMatrix)) {
                    matrixDecomposeViewProj(floatMatrix, viewMatrix, projMatrix);
                }
                else {
                    projMatrix = floatMatrix;
                    viewMatrix = hlslpp::float4x4::identity();
                }
            }
            else {
                viewProjMatrix = hlslpp::mul(floatMatrix, viewProjMatrix);

                if (isMatrixAffine(floatMatrix) && !isMatrixIdentity(floatMatrix)) {
                    viewMatrix = hlslpp::mul(floatMatrix, viewMatrix);
                }
                else {
                    projMatrix = hlslpp::mul(floatMatrix, projMatrix);
                }
            }

            projectionMatrixSegmentedAddress = address;
            projectionMatrixPhysicalAddress = fromSegmentedMasked(address);
            projectionMatrixChanged = true;
            projectionMatrixInversed = false;

            // cv64 probe: log projection-matrix loads/muls and their shape.
            // perspProj test (see getCurrentProjectionType) = projM[3][3]==0 && |projM[1][1]|>1e-6.
        }
        // Modelview matrix.
        else {
            if ((params & pushMask) && (modelMatrixStackSize < RSP_MATRIX_STACK_SIZE)) {
                modelMatrixStackSize++;
                modelMatrixStack[modelMatrixStackSize - 1] = modelMatrixStack[modelMatrixStackSize - 2];
            }

            if (params & loadMask) {
                modelMatrixStack[modelMatrixStackSize - 1] = floatMatrix;
            }
            else {
                modelMatrixStack[modelMatrixStackSize - 1] = hlslpp::mul(floatMatrix, modelMatrixStack[modelMatrixStackSize - 1]);
            }

            modelMatrixSegmentedAddressStack[modelMatrixStackSize - 1] = address;
            modelMatrixPhysicalAddressStack[modelMatrixStackSize - 1] = fromSegmentedMasked(address);

            // cv64 (session 15, Alucard): log each DISTINCT modelview load's scale+trans (gated).
        }

        modelViewProjChanged = true;
    }

    void RSP::matrix(uint32_t address, uint8_t params) {
        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const FixedMatrix *fixedMatrix = reinterpret_cast<FixedMatrix *>(state->fromRDRAM(rdramAddress));
        const hlslpp::float4x4 floatMatrix = fixedMatrix->toMatrix4x4();
        matrixCommon(floatMatrix, address, params);
    }

    void RSP::matrixFloat(uint32_t address, uint8_t params) {
        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const float *floats = reinterpret_cast<float *>(state->fromRDRAM(rdramAddress));
        const hlslpp::float4x4 floatMatrix(
            floats[0], floats[1], floats[2], floats[3],
            floats[4], floats[5], floats[6], floats[7],
            floats[8], floats[9], floats[10], floats[11],
            floats[12], floats[13], floats[14], floats[15]
        );

        matrixCommon(floatMatrix, address, params);
    }

    void RSP::popMatrix(uint32_t count) {
        while (count--) {
            if (modelMatrixStackSize > 1) {
                modelMatrixStackSize--;
                modelViewProjChanged = true;
            }
        }
    }

    void RSP::pushProjectionMatrix() {
        if (projectionMatrixStackSize < RSP_EXTENDED_STACK_SIZE) {
            viewMatrixStack[projectionMatrixStackSize] = viewMatrixStack[projectionMatrixStackSize - 1];
            projMatrixStack[projectionMatrixStackSize] = projMatrixStack[projectionMatrixStackSize - 1];
            viewProjMatrixStack[projectionMatrixStackSize] = viewProjMatrixStack[projectionMatrixStackSize - 1];
            invViewProjMatrixStack[projectionMatrixStackSize] = invViewProjMatrixStack[projectionMatrixStackSize - 1];
            projectionMatrixSegmentedAddressStack[projectionMatrixStackSize] = projectionMatrixSegmentedAddressStack[projectionMatrixStackSize - 1];
            projectionMatrixPhysicalAddressStack[projectionMatrixStackSize] = projectionMatrixPhysicalAddressStack[projectionMatrixStackSize - 1];
            projectionMatrixStackSize++;
        }
    }

    void RSP::popProjectionMatrix() {
        if (projectionMatrixStackSize > 1) {
            projectionMatrixStackSize--;
            modelViewProjChanged = true;
            projectionMatrixChanged = true;
            projectionMatrixInversed = false;
        }
    }
    
    void RSP::insertMatrix(uint32_t address, uint32_t value) {
#   ifdef LOG_SPECIAL_MATRIX_OPERATIONS
        RT64_LOG_PRINTF("RSP::insertMatrix(dst %u, value %u)", dst, value);
#   endif

        // We assume unaligned addresses or overlapping is impossible until we have verification
        // from the microcode itself if this is allowed or not due to how much more complex
        // the implementation could get.
        assert(((address & 0x3) == 0) && "Unaligned addresses for insert matrix are not currently supported.");

        // Copies a 32-bit value into the location occupied by the fixed point matrices.
        const uint16_t MatrixSize = 0x40;
        const uint16_t FractionalMatrixAddress = MatrixSize / 2;
        const uint16_t ModelAddress = 0x0;
        const uint16_t ViewProjAddress = ModelAddress + MatrixSize;
        const uint16_t ModelViewProjAddress = ViewProjAddress + MatrixSize;

        // According to the microcode, the address requires this kind of wrapping
        // to access the real destination.
        uint32_t dstAddr = (address + ModelViewProjAddress) & 0xFFFFU;

        // Figure out which matrix should be modified and compute a relative address to it.
        uint32_t relAddr = 0;
        hlslpp::float4x4 *dstMat = nullptr;
        hlslpp::float4x4 &viewProjMatrix = viewProjMatrixStack[projectionMatrixStackSize - 1];
        if (dstAddr >= (ModelViewProjAddress + MatrixSize)) {
            assert(false && "Undefined behavior due to destination address extending outside of the allowed bounds.");
            return;
        }
        if (dstAddr >= ModelViewProjAddress) {
            dstMat = &modelViewProjMatrix;
            relAddr = dstAddr - ModelViewProjAddress;
            modelViewProjInserted = true;
        }
        else if (dstAddr >= ViewProjAddress) {
            dstMat = &viewProjMatrix;
            relAddr = dstAddr - ViewProjAddress;
            projectionMatrixChanged = true;
            projectionMatrixInversed = false;
        }
        else if (dstAddr >= ModelAddress) {
            dstMat = &modelMatrixStack[modelMatrixStackSize - 1];
            relAddr = dstAddr - ModelAddress;
        }

        // Modify two fractional parts or two integer parts.
        const bool modifyFractional = relAddr >= FractionalMatrixAddress;
        if (modifyFractional) {
            relAddr -= FractionalMatrixAddress;
        }

        const uint32_t index = relAddr / 2;
        const uint32_t row = index / 4;
        const uint32_t column = index % 4;
        if (modifyFractional) {
            FixedMatrix::modifyMatrix4x4Fraction(*dstMat, row, column, uint16_t((value >> 16U) & 0xFFFFU));
            FixedMatrix::modifyMatrix4x4Fraction(*dstMat, row, column + 1, uint16_t(value & 0xFFFFU));
        }
        else {
            FixedMatrix::modifyMatrix4x4Integer(*dstMat, row, column, int16_t((value >> 16) & 0xFFFF));
            FixedMatrix::modifyMatrix4x4Integer(*dstMat, row, column + 1, int16_t(value & 0xFFFF));
        }
    }

    void RSP::forceMatrix(uint32_t address) {
#   ifdef LOG_SPECIAL_MATRIX_OPERATIONS
        RT64_LOG_PRINTF("RSP::forceMatrix(0x%08X)", address);
#   endif

        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const FixedMatrix *fixedMatrix = reinterpret_cast<FixedMatrix *>(state->fromRDRAM(rdramAddress));
        modelViewProjMatrix = fixedMatrix->toMatrix4x4();
        modelViewProjInserted = true;
        modelViewProjChanged = false;
    }

    static void setExtendedMatrixFloat(RSP &rsp, uint32_t address, hlslpp::float4x4 &matrix, hlslpp::float4x4 &invMatrix) {
        const uint32_t rdramAddress = rsp.fromSegmentedMasked(address);
        const float *floatMatrix = reinterpret_cast<float *>(rsp.state->fromRDRAM(rdramAddress));
        for (uint32_t j = 0; j < 4; j++) {
            for (uint32_t i = 0; i < 4; i++) {
                matrix[j][i] = floatMatrix[j * 4 + i];
            }
        }

        invMatrix = hlslpp::inverse(matrix);

        rsp.extended.viewProjMatrix = hlslpp::mul(rsp.extended.viewMatrix, rsp.extended.projMatrix);
        rsp.extended.viewProjRotationMatrix = hlslpp::float3x3(rsp.extended.viewProjMatrix);
        rsp.extended.invViewProjMatrix = hlslpp::inverse(rsp.extended.viewProjMatrix);
        rsp.projectionMatrixChanged = true;
        rsp.modelViewProjChanged = true;
        rsp.lightsChanged = true;
        rsp.lookAtChanged = true;
    }

    void RSP::setProjectionMatrixFloat(uint32_t address) {
        setExtendedMatrixFloat(*this, address, extended.projMatrix, extended.invProjMatrix);
    }

    void RSP::setViewMatrixFloat(uint32_t address) {
        setExtendedMatrixFloat(*this, address, extended.viewMatrix, extended.invViewMatrix);
    }

    void RSP::computeModelViewProj() {
        const hlslpp::float4x4 &viewProjMatrix = viewProjMatrixStack[projectionMatrixStackSize - 1];
        modelViewProjMatrix = hlslpp::mul(modelMatrixStack[modelMatrixStackSize - 1], viewProjMatrix);
        modelViewProjInserted = false;
        modelViewProjChanged = false;
    }

    void RSP::specialComputeModelViewProj() {
#   ifdef LOG_SPECIAL_MATRIX_OPERATIONS
        RT64_LOG_PRINTF("RSP::specialComputeModelViewProj()");
#   endif

        computeModelViewProj();
    }

    void RSP::setModelViewProjChanged(bool changed) {
#   ifdef LOG_SPECIAL_MATRIX_OPERATIONS
        RT64_LOG_PRINTF("RSP::setModelViewProjChanged(%d)", changed);
#   endif

        modelViewProjChanged = changed;
    }

    // cv64 S41 [fire9]: lightning-fire vertex-slot markers (setVertex sets, drawIndexedTri consumes).
    int g_cv64_fire9_min = -1, g_cv64_fire9_max = -1, g_cv64_fire9_ttl = 0;

    void RSP::setVertex(uint32_t address, uint32_t vtxCount, uint32_t dstIndex) {
        if ((dstIndex >= RSP_MAX_VERTICES) || ((dstIndex + vtxCount) > RSP_MAX_VERTICES)) {
            assert(false && "Vertex indices are not valid. DL is possibly corrupted.");
            return;
        }

        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const Vertex *dlVerts = reinterpret_cast<const Vertex *>(state->fromRDRAM(rdramAddress));
        memcpy(&vertices[dstIndex], dlVerts, sizeof(Vertex) * vtxCount);
        // cv64 S41 [fire9] — the LIGHTNING-FIRE's quad loads vertices from seg6 file+0x031020 (layer 2:
        // +0x030FA0), UNIQUE to the Fire effect (torches load elsewhere). Mark the dst slots so the
        // following tris can be attributed to the FIRE specifically ([fire5] was combiner-keyed = torch
        // data mixed in). Logs the raw model-space verts too.
        if (((address >> 24) & 0xFFu) == 0x06u &&
            (address & 0x00FFFFFFu) >= 0x030F00u && (address & 0x00FFFFFFu) <= 0x031100u) {
            g_cv64_fire9_min = (int)dstIndex; g_cv64_fire9_max = (int)(dstIndex + vtxCount); g_cv64_fire9_ttl = 8;
            static int _f9v = 0;
            if (_f9v++ < 24) {
                const Vertex &v0 = vertices[dstIndex];
                fprintf(stderr, "[fire9] VTX seg=0x%08X rdram=0x%08X n=%u dst=%u v0=(%d,%d,%d)\n",
                        address, rdramAddress, vtxCount, dstIndex, (int)v0.x, (int)v0.y, (int)v0.z);
                fflush(stderr);
            }
        }
        setVertexCommon<true, sizeof(Vertex)>(rdramAddress, dstIndex, dstIndex + vtxCount);
    }
    
    void RSP::setVertexPD(uint32_t address, uint32_t vtxCount, uint32_t dstIndex) {
        if ((dstIndex >= RSP_MAX_VERTICES) || ((dstIndex + vtxCount) > RSP_MAX_VERTICES)) {
            assert(false && "Vertex indices are not valid. DL is possibly corrupted.");
            return;
        }

        const uint32_t rdramAddress = fromSegmentedMaskedPD(address);
        const VertexPD *dlVerts = reinterpret_cast<const VertexPD *>(state->fromRDRAM(rdramAddress));
        for (uint32_t i = 0; i < vtxCount; i++) {
            Vertex &dst = vertices[dstIndex + i];
            const VertexPD &src = dlVerts[i];
            const uint8_t *col = state->fromRDRAM(vertexColorPDAddress + (src.ci & 0xFFU));
            dst.x = src.x;
            dst.y = src.y;
            dst.z = src.z;
            dst.s = src.s;
            dst.t = src.t;
            dst.color.r = col[3];
            dst.color.g = col[2];
            dst.color.b = col[1];
            dst.color.a = col[0];
        }

        setVertexCommon<true, sizeof(VertexPD)>(rdramAddress, dstIndex, dstIndex + vtxCount);
    }

    // ── [F3DDKR 2026-09-04] Rare's DMA Fast3D ─────────────────────────────────────────────────────
    // RDRAM here is ^3-swizzled: an N64 byte at address A lives at host A^3, an N64 big-endian
    // halfword at even A is the native halfword at host A^2 (the same convention GLideN64 uses
    // with its `[address ^ 2]` / `[address ^ 3]` reads for this very microcode).
    static inline int16_t dkrRead16(const uint8_t *rdram, uint32_t address) {
        return *reinterpret_cast<const int16_t *>(rdram + (address ^ 2u));
    }

    static inline uint8_t dkrRead8(const uint8_t *rdram, uint32_t address) {
        return rdram[address ^ 3u];
    }

    // 10-byte vertex: x, y, z (int16) then r, g, b, a (uint8). No texture coordinates, no flag.
    void RSP::setVertexDKR(uint32_t address, uint32_t vtxCount, uint32_t dstIndex) {
        if ((dstIndex >= RSP_MAX_VERTICES) || ((dstIndex + vtxCount) > RSP_MAX_VERTICES)) {
            assert(false && "Vertex indices are not valid. DL is possibly corrupted.");
            return;
        }

        // [dkrvtxalign 2026-09-06] TWO-byte granular, not eight - see fromSegmentedMaskedDKR. The
        // ten-byte record puts three batches in four off an 8-byte boundary, and the general mask
        // was shifting every field of every vertex in those batches by 2, 4 or 6 bytes.
        const uint32_t rdramAddress = (dkrVertexOffset + fromSegmentedMaskedDKR(address)) & 0x00FFFFFEu;
        const uint8_t *rdram = state->fromRDRAM(0);
        uint32_t src = rdramAddress;
        for (uint32_t i = 0; i < vtxCount; i++, src += 10u) {
            Vertex &dst = vertices[dstIndex + i];
            dst.x = dkrRead16(rdram, src + 0u);
            dst.y = dkrRead16(rdram, src + 2u);
            dst.z = dkrRead16(rdram, src + 4u);
            dst.flag = 0;
            dst.s = 0;
            dst.t = 0;
            dst.color.r = dkrRead8(rdram, src + 6u);
            dst.color.g = dkrRead8(rdram, src + 7u);
            dst.color.b = dkrRead8(rdram, src + 8u);
            dst.color.a = dkrRead8(rdram, src + 9u);
            // Billboard mode changes only WHERE appended vertices land (slot 1 onward, handled by
            // the GBI layer); the reference (GLideN64 gSPDMAVertex) applies no positional offset.
            // A first draft added slot 0's position here and scattered geometry across the screen.
        }
        // [dkrvtx] capped raw-record dump: the first loads, exactly as read, so a wrong stride,
        // byte order or field guess is visible in one boot instead of inferred from a picture.
        {
            static int _n = 0;
            if (_n++ < 6) {
                const Vertex &v = vertices[dstIndex];
                fprintf(stderr, "[dkrvtx] #%d src=0x%06X (w1=0x%08X off=0x%06X align=%u) n=%u dst=%u v0=(%d,%d,%d) rgba=%02X%02X%02X%02X\n",
                        _n, rdramAddress, address, dkrVertexOffset, rdramAddress & 7u, vtxCount, dstIndex,
                        (int)v.x, (int)v.y, (int)v.z,
                        v.color.r, v.color.g, v.color.b, v.color.a);
                fflush(stderr);
            }
        }

        setVertexCommon<true, 10>(rdramAddress, dstIndex, dstIndex + vtxCount);
    }

    // [dkrnearclip 2026-09-06] The near plane, in the microcode's own w units (the DKR-family matrix
    // is a complete MVP, so w is the view depth with the camera distance baked into [3][3]: ~500 for
    // Mickey's scenes, 200 for DKR's). 1/32 of a unit is far below any real geometry and above the
    // rounding noise of the int16 vertex record, which the clip loop re-checks anyway.
    static constexpr float DKR_NEAR_W = 1.0f / 32.0f;

    // 16-byte triangle: flag, v0, v1, v2 (uint8) then s0, t0, s1, t1, s2, t2 (int16, s10.5 texels -
    // the same units Vertex::s/t carry). flag bit 0x40 clear = back-face culled, set = no culling.
    // The three referenced vertices are re-emitted through three scratch slots with this triangle's
    // s/t so a vertex shared by several triangles can wear different texture coordinates in each.
    void RSP::drawTrianglesDKR(uint32_t address, uint32_t triCount, uint32_t textureOn) {
        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const uint8_t *rdram = state->fromRDRAM(0);
        const uint32_t scratch = RSP_MAX_VERTICES - 3u;
        textureState.on = (textureOn != 0u) ? 1 : 0;
        uint32_t tri = rdramAddress;
        for (uint32_t i = 0; i < triCount; i++, tri += 16u) {
            const uint8_t flag = dkrRead8(rdram, tri + 0u);
            const uint32_t v0 = dkrRead8(rdram, tri + 1u);
            const uint32_t v1 = dkrRead8(rdram, tri + 2u);
            const uint32_t v2 = dkrRead8(rdram, tri + 3u);
            if ((v0 >= scratch) || (v1 >= scratch) || (v2 >= scratch)) {
                continue;
            }
            {   // [dkrclip] capped: where the current matrix actually sends these three vertices
                static int _c = 0;
                if (_c++ < 6) {
                    const hlslpp::float4x4 &m = dkrMatrix[dkrMatrixIndex];
                    const uint32_t idx[3] = { v0, v1, v2 };
                    for (int k = 0; k < 3; k++) {
                        const Vertex &vv = vertices[idx[k]];
                        const hlslpp::float4 p = hlslpp::mul(hlslpp::float4(float(vv.x), float(vv.y), float(vv.z), 1.0f), m);
                        fprintf(stderr, "[dkrclip] tri#%d v%d=(%d,%d,%d) -> clip=(%.2f, %.2f, %.2f, w=%.2f)%s\n",
                                _c, k, (int)vv.x, (int)vv.y, (int)vv.z, (float)p.x, (float)p.y, (float)p.z, (float)p.w,
                                ((float)p.w > 0.0f && fabsf((float)p.x) <= fabsf((float)p.w) && fabsf((float)p.y) <= fabsf((float)p.w)) ? "  on-screen" : "  OFF");
                    }
                    fflush(stderr);
                }
            }
            {   // [dkrcensus-tri] instrument only, env RT64_GBI_CENSUS=1, default silent. The 1997
                // and 1998 microcodes both compute per-vertex clip codes and hand any triangle that
                // straddles a frustum plane to a clipping overlay (JFG: IMEM 0x870, reached from the
                // draw routine at 0x1A90 when the OR of the three codes hits its mask), and DROP one
                // whose three codes share an outside bit. RT64's HLE does neither, so this counts how
                // much geometry that would be: triangles with a vertex behind the eye (w <= 0) and
                // triangles wholly outside one plane. A number here decides whether a faithful clip
                // is worth a build, instead of a guess from a screenshot.
                static const bool on = [] { const char *e = std::getenv("RT64_GBI_CENSUS"); return (e != nullptr) && (e[0] == '1'); }();
                if (on) {
                    static unsigned long long nT = 0, nBehind = 0, nStraddle = 0, nAllOut = 0, nWide = 0;
                    const hlslpp::float4x4 &m = dkrMatrix[dkrMatrixIndex];
                    const uint32_t idx[3] = { v0, v1, v2 };
                    int behind = 0; float maxAbsNdc = 0.0f;
                    int outL = 0, outR = 0, outB = 0, outT = 0;
                    for (int k = 0; k < 3; k++) {
                        const Vertex &vv = vertices[idx[k]];
                        const hlslpp::float4 p = hlslpp::mul(hlslpp::float4(float(vv.x), float(vv.y), float(vv.z), 1.0f), m);
                        const float pw = (float)p.w, px = (float)p.x, py = (float)p.y;
                        if (pw <= 0.0f) { behind++; continue; }
                        if (px < -pw) outL++;
                        if (px > pw) outR++;
                        if (py < -pw) outB++;
                        if (py > pw) outT++;
                        const float ax = fabsf(px / pw), ay = fabsf(py / pw);
                        if (ax > maxAbsNdc) maxAbsNdc = ax;
                        if (ay > maxAbsNdc) maxAbsNdc = ay;
                    }
                    nT++;
                    if (behind > 0) nBehind++;
                    if (behind > 0 && behind < 3) nStraddle++;
                    if (outL == 3 || outR == 3 || outB == 3 || outT == 3 || behind == 3) nAllOut++;
                    if (maxAbsNdc > 8.0f) nWide++;
                    if (nT <= 4 || (nT % 100000ULL) == 0) {
                        fprintf(stderr, "[dkrcensus-tri] tris=%llu anyBehind=%llu straddling=%llu whollyOutside=%llu ndcOver8=%llu\n",
                                nT, nBehind, nStraddle, nAllOut, nWide);
                        fflush(stderr);
                    }
                    // [dkrcensus-tri2 2026-09-06] the SAME sample, but printing WHAT transformed it:
                    // the slot in use, that slot's matrix in full, how RT64 classified it after
                    // matrixDecomposeViewProj, and where the three vertices actually land. Without
                    // this the only matrix on record is [dkrmtx]'s first four loads (the boot logo).
                    if (nT <= 3 || (nT % 200000ULL) == 0) {
                        const hlslpp::float4x4 &pm = projMatrixStack[projectionMatrixStackSize - 1];
                        const Projection::Type pt = getCurrentProjectionType();
                        fprintf(stderr, "[dkrcensus-tri2] tris=%llu slot=%u proj=%s projM[1][1]=%.5f projM[3][3]=%.5f  current matrix:\n"
                                        "  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n",
                                nT, dkrMatrixIndex,
                                (pt == Projection::Type::Perspective) ? "Persp" : (pt == Projection::Type::Orthographic) ? "Ortho" : "Other",
                                (float)pm[1][1], (float)pm[3][3],
                                (float)m[0][0], (float)m[0][1], (float)m[0][2], (float)m[0][3],
                                (float)m[1][0], (float)m[1][1], (float)m[1][2], (float)m[1][3],
                                (float)m[2][0], (float)m[2][1], (float)m[2][2], (float)m[2][3],
                                (float)m[3][0], (float)m[3][1], (float)m[3][2], (float)m[3][3]);
                        for (int k = 0; k < 3; k++) {
                            const Vertex &vv = vertices[idx[k]];
                            const hlslpp::float4 p = hlslpp::mul(hlslpp::float4(float(vv.x), float(vv.y), float(vv.z), 1.0f), m);
                            const float pw = (float)p.w;
                            fprintf(stderr, "    v%d=(%d,%d,%d) clip=(%.2f,%.2f,%.2f,w=%.4f) ndc=(%.3f,%.3f)\n",
                                    k, (int)vv.x, (int)vv.y, (int)vv.z, (float)p.x, (float)p.y, (float)p.z, pw,
                                    (pw != 0.0f) ? (float)p.x / pw : 0.0f, (pw != 0.0f) ? (float)p.y / pw : 0.0f);
                        }
                        fprintf(stderr, "    selects: fromLoad=%llu fromMoveWord=%llu | billboardOn=%d texOffset=0x%08X (%llu cmds) mtxOff=0x%06X vtxOff=0x%06X (%llu cmds) | moveword idx:",
                                dkrSelectFromLoad, dkrSelectFromMoveWord, (int)dkrBillboard, dkrTexOffset, dkrTexOffsetCmds,
                                dkrMatrixOffset, dkrVertexOffset, dkrOffsetsCmds);
                        for (int k = 0; k < 256; k++) {
                            if (dkrMoveWordIndex[k] != 0ULL) fprintf(stderr, " 0x%02X=%llu", k, dkrMoveWordIndex[k]);
                        }
                        fprintf(stderr, "%c", 0x0A);
                        fflush(stderr);
                    }
                }
            }
            {   // [dkrtri] capped raw-record dump, paired with [dkrvtx]
                static int _n = 0;
                if (_n++ < 6) {
                    fprintf(stderr, "[dkrtri] #%d at=0x%06X flag=%02X v=(%u,%u,%u) st0=(%d,%d) st1=(%d,%d) st2=(%d,%d) tex=%u\n",
                            _n, tri, flag, v0, v1, v2,
                            (int)dkrRead16(rdram, tri + 4u), (int)dkrRead16(rdram, tri + 6u),
                            (int)dkrRead16(rdram, tri + 8u), (int)dkrRead16(rdram, tri + 10u),
                            (int)dkrRead16(rdram, tri + 12u), (int)dkrRead16(rdram, tri + 14u), textureOn);
                    fflush(stderr);
                }
            }
            if ((flag & 0x40u) == 0u) {
                setGeometryMode(cullBothMask & ~cullFrontMask);   // G_CULL_BACK
            }
            else {
                clearGeometryMode(cullBothMask);
            }
            // [dkrnearclip 2026-09-06] THE NEAR PLANE. Both dialects of Rare's DMA Fast3D compute
            // per-vertex clip codes in the transform loop (stored at output-record +0x24, from two
            // vch/vcl passes against w and a scaled w), then at the draw routine DROP a triangle
            // whose three codes share an outside bit and hand a straddling one to the clipper
            // overlay (IMEM 0x870 on the 1998 build, 0x7D8 on DKR's). RT64's HLE did neither, so
            // every triangle crossing or behind the eye reached the rasterizer with w <= 0 and its
            // xy/w exploded across the screen. MEASURED on Mickey's Speedway (RT64_GBI_CENSUS +
            // RECOMP_VTX_CENSUS, 90 s): of 1,700,000 triangles, 998,259 have a vertex with w <= 0,
            // 71,135 straddle, and only 104,191 of 1,600,000 put any vertex inside the frustum -
            // i.e. the screen was being painted by geometry the RSP never draws. Clipping is done
            // in MODEL space: w is an affine function of (x,y,z), so the parameter at which w
            // crosses the plane gives the exact model-space point, and colour and s/t interpolate
            // linearly there. The polygon is at most a quad and is emitted as a fan through the
            // same three scratch slots, so an unclipped triangle takes exactly the old path.
            {
                const hlslpp::float4x4 &cm = dkrMatrix[dkrMatrixIndex];
                const float cw0 = (float)cm[0][3], cw1 = (float)cm[1][3], cw2 = (float)cm[2][3], cw3 = (float)cm[3][3];
                auto wOf = [&](const Vertex &vv) {
                    return float(vv.x) * cw0 + float(vv.y) * cw1 + float(vv.z) * cw2 + cw3;
                };
                const uint32_t triIdx[3] = { v0, v1, v2 };
                Vertex iv[3];
                float iw[3];
                for (int k = 0; k < 3; k++) {
                    iv[k] = vertices[triIdx[k]];
                    iv[k].s = dkrRead16(rdram, tri + 4u + uint32_t(k) * 4u);
                    iv[k].t = dkrRead16(rdram, tri + 6u + uint32_t(k) * 4u);
                    iw[k] = wOf(iv[k]);
                }

                Vertex poly[4];
                int polyN = 0;
                for (int k = 0; (k < 3) && (polyN < 4); k++) {
                    const int k2 = (k + 1) % 3;
                    const bool inA = (iw[k] >= DKR_NEAR_W);
                    const bool inB = (iw[k2] >= DKR_NEAR_W);
                    if (inA) {
                        poly[polyN++] = iv[k];
                    }

                    if ((inA != inB) && (polyN < 4)) {
                        const float denom = iw[k2] - iw[k];
                        float t = (denom != 0.0f) ? ((DKR_NEAR_W - iw[k]) / denom) : 0.0f;
                        t = std::min(1.0f, std::max(0.0f, t));
                        // The clipped point has to fit the int16 vertex record, and that rounding
                        // can push it back across the plane; walk it toward the vertex that IS in
                        // front until the rounded point is provably in front too (bounded).
                        const float toward = inA ? -1.0f : 1.0f;
                        Vertex nv = iv[k];
                        for (int guard = 0; guard < 20; guard++) {
                            auto lerp16 = [&](int16_t p, int16_t q) {
                                const float f = float(p) + (float(q) - float(p)) * t;
                                return int16_t((f >= 0.0f) ? (f + 0.5f) : (f - 0.5f));
                            };
                            auto lerp8 = [&](uint8_t p, uint8_t q) {
                                const float f = float(p) + (float(q) - float(p)) * t;
                                return uint8_t(std::min(255.0f, std::max(0.0f, f + 0.5f)));
                            };
                            nv.x = lerp16(iv[k].x, iv[k2].x);
                            nv.y = lerp16(iv[k].y, iv[k2].y);
                            nv.z = lerp16(iv[k].z, iv[k2].z);
                            nv.s = lerp16(iv[k].s, iv[k2].s);
                            nv.t = lerp16(iv[k].t, iv[k2].t);
                            nv.flag = 0;
                            nv.color.r = lerp8(iv[k].color.r, iv[k2].color.r);
                            nv.color.g = lerp8(iv[k].color.g, iv[k2].color.g);
                            nv.color.b = lerp8(iv[k].color.b, iv[k2].color.b);
                            nv.color.a = lerp8(iv[k].color.a, iv[k2].color.a);
                            if (wOf(nv) >= (DKR_NEAR_W * 0.5f)) {
                                break;
                            }

                            t += toward * 0.05f;
                            t = std::min(1.0f, std::max(0.0f, t));
                        }
                        poly[polyN++] = nv;
                    }
                }

                {   // [dkrnearclip] instrument only, env RT64_GBI_CENSUS=1, default silent.
                    static const bool on = [] { const char *e = std::getenv("RT64_GBI_CENSUS"); return (e != nullptr) && (e[0] == '1'); }();
                    if (on) {
                        static unsigned long long nSeen = 0, nDropped = 0, nClipped = 0;
                        nSeen++;
                        if (polyN < 3) nDropped++;
                        else if (polyN > 3) nClipped++;
                        if ((nSeen % 200000ULL) == 0) {
                            fprintf(stderr, "[dkrnearclip] seen=%llu droppedBehindNear=%llu clippedToQuad=%llu\n",
                                    nSeen, nDropped, nClipped);
                            fflush(stderr);
                        }
                    }
                }

                if (polyN < 3) {
                    continue;   // wholly behind the near plane: the RSP never draws this triangle
                }

                for (int f = 1; (f + 1) < polyN; f++) {
                    vertices[scratch + 0] = poly[0];
                    vertices[scratch + 1] = poly[f];
                    vertices[scratch + 2] = poly[f + 1];
                    setVertexCommon<true, 16>(tri, scratch, scratch + 3u);
                    drawIndexedTri(scratch + 0, scratch + 1, scratch + 2);
                }
            }
        }
    }

    // The game hands the RSP a full model-view-projection per object and selects among four of
    // them; RT64 sees each as the model matrix with an identity projection (the matrix already
    // carries the projection, exactly as the microcode uses it).
    void RSP::dkrLoadMatrix(uint32_t address, uint32_t dstIndex, uint32_t srcIndex, bool multiply) {
        const uint32_t rdramAddress = (dkrMatrixOffset + fromSegmentedMasked(address)) & 0x00FFFFFFu;
        const FixedMatrix *fixedMatrix = reinterpret_cast<const FixedMatrix *>(state->fromRDRAM(rdramAddress));
        hlslpp::float4x4 floatMatrix = fixedMatrix->toMatrix4x4();
        const uint32_t index = dstIndex & 0x7u;
        if (multiply) {
            // The microcode's matrix multiply takes the freshly DMA'd matrix as the left operand and
            // the selected slot as the right one (IMEM 0x3FC: the scalars come from the DMA buffer,
            // the rows from the slot), which is this engine's row-vector order: p * (new * old).
            floatMatrix = hlslpp::mul(floatMatrix, dkrMatrix[srcIndex & 0x7u]);
        }
        dkrMatrix[index] = floatMatrix;
        {   // [dkrcensus-mtx2 2026-09-06] instrument only, env RT64_GBI_CENSUS=1, default silent.
            // [dkrmtx] below is capped at the first four loads, i.e. the boot screen only; this one
            // samples the STEADY state so "what matrix is actually current when the game draws" is a
            // number. On a multiply it prints both operands and the product, because the operand
            // ORDER is the one field of the 1998 G_MTX that a picture cannot disambiguate.
            static const bool on = [] { const char *e = std::getenv("RT64_GBI_CENSUS"); return (e != nullptr) && (e[0] == '1'); }();
            if (on) {
                static unsigned long long n = 0;
                n++;
                if ((n % 20000ULL) == 0) {
                    const hlslpp::float4x4 &m = floatMatrix;
                    fprintf(stderr, "[dkrcensus-mtx2] #%llu dst=%u src=%u mul=%d addr=0x%06X result:\n  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n",
                            n, index, srcIndex & 0x7u, (int)multiply, rdramAddress,
                            (float)m[0][0], (float)m[0][1], (float)m[0][2], (float)m[0][3],
                            (float)m[1][0], (float)m[1][1], (float)m[1][2], (float)m[1][3],
                            (float)m[2][0], (float)m[2][1], (float)m[2][2], (float)m[2][3],
                            (float)m[3][0], (float)m[3][1], (float)m[3][2], (float)m[3][3]);
                    if (multiply) {
                        const hlslpp::float4x4 l = fixedMatrix->toMatrix4x4();
                        const hlslpp::float4x4 &s = dkrMatrix[srcIndex & 0x7u];
                        fprintf(stderr, "  loaded [%9.4f %9.4f %9.4f %9.4f][%9.4f %9.4f %9.4f %9.4f][%9.4f %9.4f %9.4f %9.4f][%9.4f %9.4f %9.4f %9.4f]\n"
                                        "  slot   [%9.4f %9.4f %9.4f %9.4f][%9.4f %9.4f %9.4f %9.4f][%9.4f %9.4f %9.4f %9.4f][%9.4f %9.4f %9.4f %9.4f]\n",
                                (float)l[0][0], (float)l[0][1], (float)l[0][2], (float)l[0][3],
                                (float)l[1][0], (float)l[1][1], (float)l[1][2], (float)l[1][3],
                                (float)l[2][0], (float)l[2][1], (float)l[2][2], (float)l[2][3],
                                (float)l[3][0], (float)l[3][1], (float)l[3][2], (float)l[3][3],
                                (float)s[0][0], (float)s[0][1], (float)s[0][2], (float)s[0][3],
                                (float)s[1][0], (float)s[1][1], (float)s[1][2], (float)s[1][3],
                                (float)s[2][0], (float)s[2][1], (float)s[2][2], (float)s[2][3],
                                (float)s[3][0], (float)s[3][1], (float)s[3][2], (float)s[3][3]);
                    }
                    fflush(stderr);
                }
            }
        }
        {   // [dkrmtx] capped: the matrix exactly as loaded, so "is the MVP sane" is read, not inferred
            static int _n = 0;
            if (_n++ < 4) {
                const hlslpp::float4x4 &m = floatMatrix;
                fprintf(stderr, "[dkrmtx] #%d dst=%u src=%u mul=%d addr=0x%06X\n  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n  [%9.4f %9.4f %9.4f %9.4f]\n",
                        _n, index, srcIndex & 0x7u, (int)multiply, rdramAddress,
                        (float)m[0][0], (float)m[0][1], (float)m[0][2], (float)m[0][3],
                        (float)m[1][0], (float)m[1][1], (float)m[1][2], (float)m[1][3],
                        (float)m[2][0], (float)m[2][1], (float)m[2][2], (float)m[2][3],
                        (float)m[3][0], (float)m[3][1], (float)m[3][2], (float)m[3][3]);
                fflush(stderr);
            }
        }
        dkrSelectFromLoad++;
        dkrSelectMatrix(index);
    }

    void RSP::dkrSelectMatrix(uint32_t index) {
        // The DKR matrix is a complete model-view-PROJECTION. RT64 classifies every draw's projection
        // (perspective vs orthographic, and therefore how w is treated) from the matrix in its
        // PROJECTION slot, so the DKR matrix goes there - RT64 then decomposes it into view and
        // projection exactly as it does for a stock G_MTX_PROJECTION load - and the model slot holds
        // identity. The first draft did the reverse (model = DKR matrix, projection = identity): the
        // identity read as orthographic and the scene came out as giant stretched polygons.
        dkrMatrixIndex = index & 0x7u;
        matrixCommon(dkrMatrix[dkrMatrixIndex], 0, uint8_t(projMask | loadMask));
        matrixCommon(hlslpp::float4x4::identity(), 0, uint8_t(loadMask));
    }

    void RSP::setVertexEXV1(uint32_t address, uint32_t vtxCount, uint32_t dstIndex) {
        if ((dstIndex >= RSP_MAX_VERTICES) || ((dstIndex + vtxCount) > RSP_MAX_VERTICES)) {
            assert(false && "Vertex indices are not valid. DL is possibly corrupted.");
            return;
        }

        const int workloadCursor = state->ext.workloadQueue->writeCursor;
        Workload &workload = state->ext.workloadQueue->workloads[workloadCursor];
        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const VertexEXV1 *dlVerts = reinterpret_cast<const VertexEXV1 *>(state->fromRDRAM(rdramAddress));
        auto &velFloats = workload.drawData.velFloats;
        auto &tcVelFloats = workload.drawData.tcVelFloats;
        for (uint32_t i = 0; i < vtxCount; i++) {
            const VertexEXV1 &src = dlVerts[i];
            velFloats.emplace_back(float(src.v.x - src.xp));
            velFloats.emplace_back(float(src.v.y - src.yp));
            velFloats.emplace_back(float(src.v.z - src.zp));
            tcVelFloats.emplace_back(0.0f);
            tcVelFloats.emplace_back(0.0f);
            vertices[dstIndex + i] = src.v;
        }

        setVertexCommon<false, sizeof(VertexEXV1)>(rdramAddress, dstIndex, dstIndex + vtxCount);
    }

    void RSP::setVertexColorPD(uint32_t address) {
        vertexColorPDAddress = fromSegmentedMasked(address);
    }

    void RSP::setVertexSegmentV1(bool isEnabled, uint32_t vertexElement, uint32_t vertexAddress, uint32_t baseSegmentAddress) {
        extended.vertexAddresses[vertexElement] = vertexAddress;
        extended.baseSegmentAddresses[vertexElement] = baseSegmentAddress;
        extended.vertexSegmentEnabled[vertexElement] = isEnabled;
    }

    Projection::Type RSP::getCurrentProjectionType() const {
        const hlslpp::float4x4 &projMatrix = projMatrixStack[projectionMatrixStackSize - 1];

        // Standard check: projMatrix[3][3] == 0 with a valid Y-scale means perspective.
        const bool perspProj = (projMatrix[3][3] == 0.0f) && (abs(projMatrix[1][1]) > 1e-6f);
        if (perspProj) {
            return Projection::Type::Perspective;
        }
        // [F3DDKR 2026-09-04, TRIED AND REVERTED] Classifying by "w depends on z" ([2][3] != 0) so a
        // full model-view-projection with the camera baked into row 3 ([3][3] = 200 on DKR) reads as
        // perspective made NO visible difference to DKR's stretched geometry - so it is not the wall,
        // and an unproven change to a core classification stays out. Lead recorded on DKR's row.

        return Projection::Type::Orthographic;
    }
    
    void RSP::addCurrentProjection(Projection::Type type) {
        const int workloadCursor = state->ext.workloadQueue->writeCursor;
        Workload &workload = state->ext.workloadQueue->workloads[workloadCursor];
        if (extended.viewProjMatrixIdStackChanged) {
            extended.curViewProjMatrixIdGroupIndex = int(workload.drawData.transformGroups.size());
            workload.drawData.transformGroups.emplace_back(extended.viewProjMatrixIdStack[extended.viewProjMatrixIdStackSize - 1]);
            extended.viewProjMatrixIdStackChanged = false;
        }

        FramebufferPair &fbPair = workload.fbPairs[workload.currentFramebufferPairIndex()];
        if (projectionMatrixChanged || viewportChanged) {
            DrawData &drawData = workload.drawData;
            uint32_t transformsIndex = uint32_t(drawData.viewTransforms.size());
            curViewProjIndex = transformsIndex;

            uint32_t physicalAddress = projectionMatrixPhysicalAddressStack[projectionMatrixStackSize - 1];
            workload.physicalAddressTransformMap.emplace(physicalAddress, uint32_t(drawData.viewProjTransformGroups.size()));
            drawData.viewTransforms.emplace_back(hlslpp::mul(extended.invViewMatrix, viewMatrixStack[projectionMatrixStackSize - 1]));
            drawData.projTransforms.emplace_back(hlslpp::mul(extended.invProjMatrix, projMatrixStack[projectionMatrixStackSize - 1]));
            drawData.viewProjTransforms.emplace_back(hlslpp::mul(extended.invViewProjMatrix, viewProjMatrixStack[projectionMatrixStackSize - 1]));
            drawData.viewProjTransformGroups.emplace_back(extended.curViewProjMatrixIdGroupIndex);
            drawData.rspViewports.emplace_back(viewportStack[viewportStackSize - 1]);
            drawData.viewportOrigins.emplace_back(extended.viewportOriginStack[viewportStackSize - 1]);

            for (uint32_t j = 0; j < 4; j++) {
                drawData.viewportClipRatios.emplace_back(clipRatios[j]);
            }

            projectionMatrixChanged = false;
            viewportChanged = false;
        }

        projectionIndex = fbPair.changeProjection(curViewProjIndex, type);
    }

    template<uint32_t floatCount, uint32_t vertexSize>
    void RSP::readExtendedVertexSegment(uint32_t rdramAddress, uint32_t dstIndex, uint32_t dstMax, uint32_t globalIndex, uint32_t vertexElement, std::vector<float> &floatsVector) {
        if (!extended.vertexSegmentEnabled[vertexElement]) {
            return;
        }

        uint32_t vertexRdramAddress = fromSegmentedMasked(extended.vertexAddresses[vertexElement]);
        uint32_t baseRdramAddress = fromSegmentedMasked(extended.baseSegmentAddresses[vertexElement]);
        float *vertexFloats = (float *)(state->fromRDRAM(vertexRdramAddress));
        uint32_t j = globalIndex * floatCount;
        uint32_t k = ((rdramAddress - baseRdramAddress) / vertexSize) * floatCount;
        for (uint32_t i = dstIndex; i < dstMax; i++) {
            for (uint32_t f = 0; f < floatCount; f++) {
                floatsVector[j++] = vertexFloats[k++];
            }
        }
    }

    template<bool addEmptyVelocity, uint32_t vertexSize>
    void RSP::setVertexCommon(uint32_t rdramAddress, uint32_t dstIndex, uint32_t dstMax) {
        const int workloadCursor = state->ext.workloadQueue->writeCursor;
        Workload &workload = state->ext.workloadQueue->workloads[workloadCursor];

        if (extended.modelMatrixIdStackChanged) {
            const int stackIndex = extended.modelMatrixIdStackSize - 1;
            extended.curModelMatrixIdGroupIndex = int(workload.drawData.transformGroups.size());
            workload.drawData.transformGroups.emplace_back(extended.modelMatrixIdStack[stackIndex]);
            extended.modelMatrixIdStackChanged = false;
        }
        
        // ModelViewProj is only updated when a vertex is processed and the flag is enabled.
        auto &worldTransforms = workload.drawData.worldTransforms;
        auto &worldTransformGroups = workload.drawData.worldTransformGroups;
        auto &worldTransformSegmentedAddresses = workload.drawData.worldTransformSegmentedAddresses;
        auto &worldTransformPhysicalAddresses = workload.drawData.worldTransformPhysicalAddresses;
        auto &worldTransformVertexIndices = workload.drawData.worldTransformVertexIndices;
        bool addWorldTransform = (modelViewProjChanged || modelViewProjInserted);
        if (modelViewProjChanged) {
            computeModelViewProj();
            curTransformIndex = static_cast<uint16_t>(worldTransforms.size());
            worldTransforms.emplace_back(hlslpp::mul(modelMatrixStack[modelMatrixStackSize - 1], extended.viewProjMatrix));
        }
        else if (modelViewProjInserted) {
#       ifdef LOG_SPECIAL_MATRIX_OPERATIONS
            RT64_LOG_PRINTF("RSP::setVertexCommon(dstIndex %u, dstMax %u): An MVP was inserted and must be inversed.", dstIndex, dstMax);
#       endif

            modelViewProjInserted = false;

            if (!projectionMatrixInversed) {
                invViewProjMatrixStack[projectionMatrixStackSize - 1] = hlslpp::inverse(viewProjMatrixStack[projectionMatrixStackSize - 1]);
                projectionMatrixInversed = true;
            }

            curTransformIndex = static_cast<uint16_t>(worldTransforms.size());
            worldTransforms.emplace_back(hlslpp::mul(hlslpp::mul(modelViewProjMatrix, invViewProjMatrixStack[projectionMatrixStackSize - 1]), extended.viewProjMatrix));
        }

        if (addWorldTransform) {
            uint32_t physicalAddress = modelMatrixPhysicalAddressStack[modelMatrixStackSize - 1];
            workload.physicalAddressTransformMap.emplace(physicalAddress, uint32_t(worldTransformGroups.size()));
            worldTransformGroups.emplace_back(extended.curModelMatrixIdGroupIndex);
            worldTransformSegmentedAddresses.emplace_back(modelMatrixSegmentedAddressStack[modelMatrixStackSize - 1]);
            worldTransformPhysicalAddresses.emplace_back(physicalAddress);
            worldTransformVertexIndices.emplace_back(workload.drawData.vertexCount());
        }

        // Push a new projection if it's changed.
        if ((projectionIndex < 0) || projectionMatrixChanged || viewportChanged) {
            state->flush();
            addCurrentProjection(getCurrentProjectionType());
        }

        // We push a new set of lights if a vertex actually uses it.
        const GBI *curGBI = state->ext.interpreter->hleGBI;
        uint32_t &geometryMode = geometryModeStack[geometryModeStackSize - 1];
        const bool usesLighting = (geometryMode & G_LIGHTING);
        const bool usesPointLighting = curGBI->flags.pointLighting && (geometryMode & G_POINT_LIGHTING);
        if (usesLighting) {
            // cv64 probe: are lit-geometry lights actually populated? lightCount=0 or all-zero
            // colors => lit geometry renders BLACK (prime suspect for the black cutscene).
            if (lightsChanged) {
                auto &rspLights = workload.drawData.rspLights;
                vertexLightIndex = static_cast<uint32_t>(rspLights.size());
                vertexLightCount = lightCount + 1;
                for (int l = 0; l < lightCount + 1; l++) {
                    const Light &light = lights[l];

                    // Decode light into easier to use parameters.
                    interop::RSPLight rspLight;
                    rspLight.col = {
                        light.dir.colr / 255.0f,
                        light.dir.colg / 255.0f,
                        light.dir.colb / 255.0f
                    };

                    rspLight.colc = {
                        light.dir.colcr / 255.0f,
                        light.dir.colcg / 255.0f,
                        light.dir.colcb / 255.0f
                    };

                    // cv64 DEBUG TEST (session 10): force the ambient light (last light) to
                    // full white. Ambient is normal-independent, so if the cutscene geometry
                    // is actually present, this makes it light up bright regardless of normals
                    // or light direction. CONFIRMED: user saw the water render bright -> 3D
                    // geometry/normals/textures/presentation all work. Gated off by default;
                    // flip CV64_3D_DEBUG to 1 to reproduce the bright visual confirmation.

                    if (usesPointLighting && (light.pos.kc > 0)) {
                        rspLight.posDir = {
                            static_cast<float>(light.pos.posx),
                            static_cast<float>(light.pos.posy),
                            static_cast<float>(light.pos.posz)
                        };

                        rspLight.kc = light.pos.kc;
                        rspLight.kl = light.pos.kl;
                        rspLight.kq = light.pos.kq;
                    }
                    else {
                        rspLight.posDir = {
                             static_cast<float>(light.dir.dirx),
                             static_cast<float>(light.dir.diry),
                             static_cast<float>(light.dir.dirz)
                        };

                        rspLight.posDir = hlslpp::mul(rspLight.posDir, extended.viewProjRotationMatrix);
                        rspLight.kc = 0;
                        rspLight.kl = 0;
                        rspLight.kq = 0;
                    }

                    rspLights.push_back(rspLight);
                }

                state->updateDrawStatusAttribute(DrawAttribute::Lights);
                lightsChanged = false;
            }

            curLightIndex = vertexLightIndex;
            curLightCount = vertexLightCount;
        }
        else {
            curLightIndex = 0;
            curLightCount = 0;
        }

        const bool usesFog = (geometryMode & G_FOG);
        if (usesFog) {
            if (fogChanged) {
                auto &rspFogVector = workload.drawData.rspFog;
                vertexFogIndex = static_cast<uint32_t>(rspFogVector.size());
                rspFogVector.emplace_back(fog);
                fogChanged = false;
            }

            // Fog index is encoded as the real index + 1 to use 0 as the "fog disabled" index.
            curFogIndex = vertexFogIndex + 1;
        }
        else {
            curFogIndex = 0;
        }

        const uint32_t textureGenMask = G_LIGHTING | G_TEXTURE_GEN;
        const bool usesTextureGen = (geometryMode & textureGenMask) == textureGenMask;
        if (usesTextureGen) {
            if (lookAtChanged) {
                auto &rspLookAtVector = workload.drawData.rspLookAt;
                interop::RSPLookAt vertexLookAt = lookAt;
                vertexLookAtIndex = static_cast<uint32_t>(rspLookAtVector.size());
                vertexLookAt.x = hlslpp::mul(vertexLookAt.x, extended.viewProjRotationMatrix);
                vertexLookAt.y = hlslpp::mul(vertexLookAt.y, extended.viewProjRotationMatrix);
                rspLookAtVector.emplace_back(vertexLookAt);
                lookAtChanged = false;
            }

            // Look at index is encoded with one bit to determine if texture gen is enabled, another bit 
            // to determine if it's linear texture gen or not, and the rest of the bits to hold the real index.
            curLookAtIndex = RSP_LOOKAT_INDEX_ENABLED;
            curLookAtIndex |= (geometryMode & G_TEXTURE_GEN_LINEAR) ? RSP_LOOKAT_INDEX_LINEAR : 0x0;
            curLookAtIndex |= (vertexLookAtIndex << RSP_LOOKAT_INDEX_SHIFT);
        }
        else {
            curLookAtIndex = 0;
        }

        auto &posFloats = workload.drawData.posFloats;
        auto &velFloats = workload.drawData.velFloats;
        auto &tcFloats = workload.drawData.tcFloats;
        auto &tcVelFloats = workload.drawData.tcVelFloats;
        auto &normColBytes = workload.drawData.normColBytes;
        auto &viewProjIndices = workload.drawData.viewProjIndices;
        auto &worldIndices = workload.drawData.worldIndices;
        auto &fogIndices = workload.drawData.fogIndices;
        auto &lightIndices = workload.drawData.lightIndices;
        auto &lightCounts = workload.drawData.lightCounts;
        auto &lookAtIndices = workload.drawData.lookAtIndices;
        auto &posTransformed = workload.drawData.posTransformed;
        auto &posScreen = workload.drawData.posScreen;
        const auto &mvp = modelViewProjMatrix;
        const uint32_t globalIndex = workload.drawData.vertexCount();
        for (uint32_t i = dstIndex; i < dstMax; i++) {
            auto &v = vertices[i];
            posFloats.emplace_back(v.x);
            posFloats.emplace_back(v.y);
            posFloats.emplace_back(v.z);
            // cv64 (session 11 retry): force non-lit vertex colors to white ONLY for
            // PERSPECTIVE projection drawcalls. Excludes orthographic menus (the broken
            // cyan title screen from last attempt) and lit water (already visible).
            // Goal: make the cutscene's castle/bat geometry visible. These submit ~2753
            // tris/frame, render to a presented framebuffer, but stay invisible because
            // their vertex colors are dark to look moonlit -- forced ambient doesn't reach
            // non-lit geometry (it modulates lighting, not vertex_color * texture).
            {
                normColBytes.emplace_back(v.color.r);
                normColBytes.emplace_back(v.color.g);
                normColBytes.emplace_back(v.color.b);
                normColBytes.emplace_back(v.color.a);
            }
            viewProjIndices.emplace_back(curViewProjIndex);
            worldIndices.emplace_back(curTransformIndex);
            fogIndices.emplace_back(curFogIndex);
            lightIndices.emplace_back(curLightIndex);
            lightCounts.emplace_back(curLightCount);
            lookAtIndices.emplace_back(curLookAtIndex);
            indices[i] = uint32_t(globalIndex) + (i - dstIndex);
            used[i] = false;

            if constexpr (addEmptyVelocity) {
                velFloats.emplace_back(0.0f);
                velFloats.emplace_back(0.0f);
                velFloats.emplace_back(0.0f);
                tcVelFloats.emplace_back(0.0f);
                tcVelFloats.emplace_back(0.0f);
            }
        }

        readExtendedVertexSegment<3, vertexSize>(rdramAddress, dstIndex, dstMax, globalIndex, G_EX_VERTEX_POSITION, posFloats);
        readExtendedVertexSegment<3, vertexSize>(rdramAddress, dstIndex, dstMax, globalIndex, G_EX_VERTEX_VELOCITY, velFloats);

        uint32_t floatIndex = globalIndex * 3;
        for (uint32_t i = dstIndex; i < dstMax; i++) {
            const hlslpp::float4 tfPos = hlslpp::mul(hlslpp::float4(posFloats[floatIndex + 0], posFloats[floatIndex + 1], posFloats[floatIndex + 2], 1.0f), mvp);
            const interop::RSPViewport &viewport = viewportStack[viewportStackSize - 1];
            posTransformed.emplace_back(tfPos);
            posScreen.emplace_back((tfPos.xyz / hlslpp::float3(tfPos.w, -tfPos.w, tfPos.w)) * viewport.scale + viewport.translate);
            // CV64 cont.22 [zmap] (THROWAWAY): the depth viz showed the WHOLE scene at screen-Z ~1.0
            // (all red) = depth collapsed to the far plane = occlusion dead. Log the actual mapping for
            // the first perspective verts: NDC z (tfPos.z/tfPos.w), the viewport depth scale/translate,
            // and the resulting screen-Z. Distinguishes a bad VIEWPORT (scaleZ~0 / transZ~1) from an
            // out-of-range NDC z (the PROJECTION). One quick run -> read [zmap] -> the fix.
            {
                static unsigned long long _pv = 0;
                static float _mnSZ = 2.0f, _mxSZ = -2.0f, _mnNZ = 9.0f, _mxNZ = -9.0f, _mnW = 1e30f, _mxW = -1e30f;
                if ((int)getCurrentProjectionType() == 2) { // perspective only
                    const float _sz = (float)posScreen.back().z, _nz = (float)(tfPos.z / tfPos.w), _w = (float)tfPos.w;
                    if (_sz < _mnSZ) _mnSZ = _sz;  if (_sz > _mxSZ) _mxSZ = _sz;
                    if (_nz < _mnNZ) _mnNZ = _nz;  if (_nz > _mxNZ) _mxNZ = _nz;
                    if (_w  < _mnW)  _mnW  = _w;    if (_w  > _mxW)  _mxW  = _w;
                    if ((++_pv % 2000ULL) == 0) {
                        fprintf(stderr, "[zmap] perspVerts=%llu screenZ[%.4f..%.4f] ndcz[%.4f..%.4f] w[%.2f..%.2f]\n",
                                _pv, _mnSZ, _mxSZ, _mnNZ, _mxNZ, _mnW, _mxW);
                        fflush(stderr);
                    }
                }
            }
            floatIndex += 3;
        }

        if (usesTextureGen) {
            const float TextureSc = static_cast<float>(textureState.sc);
            const float TextureTc = static_cast<float>(textureState.tc);
            for (uint32_t i = dstIndex; i < dstMax; i++) {
                tcFloats.emplace_back(TextureSc);
                tcFloats.emplace_back(TextureTc);
            }
        }
        else {
            const int32_t TextureSc = (int32_t)(textureState.sc);
            const int32_t TextureTc = (int32_t)(textureState.tc);
            const double Divisor = 65536.0f * 32.0f;
            for (uint32_t i = dstIndex; i < dstMax; i++) {
                tcFloats.emplace_back((float)((double)((vertices[i].s) * TextureSc) / Divisor));
                tcFloats.emplace_back((float)((double)((vertices[i].t) * TextureTc) / Divisor));
            }
        }
    }

    void RSP::modifyVertex(uint16_t dstIndex, uint16_t dstAttribute, uint32_t value) {
        if (dstIndex >= RSP_MAX_VERTICES) {
            assert(false && "Vertex index is not valid. DL is possibly corrupted.");
            return;
        }

        // If the vertex was used already in the frame, then we create a new copy instead.
        const int workloadCursor = state->ext.workloadQueue->writeCursor;
        Workload &workload = state->ext.workloadQueue->workloads[workloadCursor];
        auto &normColBytes = workload.drawData.normColBytes;
        auto &tcFloats = workload.drawData.tcFloats;
        auto &tcVelFloats = workload.drawData.tcVelFloats;
        auto &fogIndices = workload.drawData.fogIndices;
        auto &lightIndices = workload.drawData.lightIndices;
        auto &lightCounts = workload.drawData.lightCounts;
        auto &lookAtIndices = workload.drawData.lookAtIndices;
        auto &modifyPosUints = workload.drawData.modifyPosUints;
        auto &posScreen = workload.drawData.posScreen;
        uint32_t globalIndex = indices[dstIndex];
        if (used[dstIndex]) {
            auto &posFloats = workload.drawData.posFloats;
            auto &velFloats = workload.drawData.velFloats;
            auto &viewProjIndices = workload.drawData.viewProjIndices;
            auto &worldIndices = workload.drawData.worldIndices;
            auto &posTransformed = workload.drawData.posTransformed;
            const uint32_t newIndex = workload.drawData.vertexCount();
            posFloats.emplace_back(posFloats[globalIndex * 3 + 0]);
            posFloats.emplace_back(posFloats[globalIndex * 3 + 1]);
            posFloats.emplace_back(posFloats[globalIndex * 3 + 2]);
            velFloats.emplace_back(velFloats[globalIndex * 3 + 0]);
            velFloats.emplace_back(velFloats[globalIndex * 3 + 1]);
            velFloats.emplace_back(velFloats[globalIndex * 3 + 2]);
            normColBytes.emplace_back(normColBytes[globalIndex * 4 + 0]);
            normColBytes.emplace_back(normColBytes[globalIndex * 4 + 1]);
            normColBytes.emplace_back(normColBytes[globalIndex * 4 + 2]);
            normColBytes.emplace_back(normColBytes[globalIndex * 4 + 3]);
            tcFloats.emplace_back(tcFloats[globalIndex * 2 + 0]);
            tcFloats.emplace_back(tcFloats[globalIndex * 2 + 1]);
            tcVelFloats.emplace_back(tcVelFloats[globalIndex * 2 + 0]);
            tcVelFloats.emplace_back(tcVelFloats[globalIndex * 2 + 1]);
            viewProjIndices.emplace_back(viewProjIndices[globalIndex]);
            worldIndices.emplace_back(worldIndices[globalIndex]);
            fogIndices.emplace_back(fogIndices[globalIndex]);
            lightIndices.emplace_back(lightIndices[globalIndex]);
            lightCounts.emplace_back(lightCounts[globalIndex]);
            lookAtIndices.emplace_back(lookAtIndices[globalIndex]);
            posTransformed.emplace_back(posTransformed[globalIndex]);
            posScreen.emplace_back(posScreen[globalIndex]);
            indices[dstIndex] = newIndex;
            used[dstIndex] = false;
            globalIndex = indices[dstIndex];
        }

        // Modify the attributes.
        switch (dstAttribute) {
        case G_MWO_POINT_RGBA: {
            normColBytes[globalIndex * 4 + 0] = (value >> 24) & 0xFF;
            normColBytes[globalIndex * 4 + 1] = (value >> 16) & 0xFF;
            normColBytes[globalIndex * 4 + 2] = (value >> 8) & 0xFF;
            normColBytes[globalIndex * 4 + 3] = value & 0xFF;
            fogIndices[globalIndex] = 0;
            lightIndices[globalIndex] = 0;
            lightCounts[globalIndex] = 0;
            break;
        }
        case G_MWO_POINT_ST: {
            const float s = int16_t((value >> 16) & 0xFFFF) / 32.0f;
            const float t = int16_t(value & 0xFFFF) / 32.0f;
            tcFloats[globalIndex * 2 + 0] = s;
            tcFloats[globalIndex * 2 + 1] = t;
            lookAtIndices[globalIndex] = 0;
            break;
        }
        case G_MWO_POINT_XYSCREEN: {
            // First bit being 0 indicates it should modify only XY.
            modifyPosUints.emplace_back(globalIndex << 1);
            modifyPosUints.emplace_back(value);

            // We decode on the CPU anyway for draw area tracking and the debugger.
            const uint16_t extX = (value >> 16) & 0xFFFF;
            const uint16_t extY = value & 0xFFFF;
            posScreen[globalIndex][0] = int16_t(extX) / 4.0f;
            posScreen[globalIndex][1] = int16_t(extY) / 4.0f;
            break;
        }
        case G_MWO_POINT_ZSCREEN: {
            // First bit being 1 indicates it should modify only Z.
            modifyPosUints.emplace_back((globalIndex << 1) | 0x1);
            modifyPosUints.emplace_back(value);

            // We decode on the CPU anyway for depth tracking, branchZ and the debugger.
            posScreen[globalIndex][2] = value / 65536.0f;
            break;
        }
        default:
            assert(false && "Unsupported modify vertex");
            break;
        }
    }
    
    // The global EnhancementConfiguration::F3DEX::forceBranch is a CV64-flavored
    // hardcode baked into every app's rt64_renderer.cpp ("CV64 uses F3DEX2"). It is
    // only correct for the F3DEX2 microcode family that cv64 runs; honoring it on a
    // non-F3DEX2 game (the sweep library spans F3DEX/S2DEX/Factor-5/Rare custom
    // ucodes) would force an unconditional DL branch and mis-route the list. Gate the
    // *config* override on the detected ucode; the game's own runtime request via the
    // extended-GBI G_EX_FORCEBRANCH_V1 command (extended.forceBranch) is always honored.
    bool RSP::forceBranchEnabled() const {
        const bool isF3DEX2Family = (currentUCode == GBIUCode::F3DEX2) || (currentUCode == GBIUCode::F3DZEX2);
        const bool configForce = isF3DEX2Family && state->ext.enhancementConfig->f3dex.forceBranch;
        return configForce || extended.forceBranch;
    }

    void RSP::branchZ(uint32_t branchDl, uint16_t vtxIndex, uint32_t zValue, DisplayList **dl) {
        const bool forceBranch = forceBranchEnabled();
        const int workloadCursor = state->ext.workloadQueue->writeCursor;
        const Workload &workload = state->ext.workloadQueue->workloads[workloadCursor];
        const uint32_t globalIndex = indices[vtxIndex];
        const float screenZ = workload.drawData.posScreen[globalIndex][2] * DepthRange;
        const float zValueFloat = zValue / 65536.0f;
        if (forceBranch || (screenZ < zValueFloat)) {
            const uint32_t rdramAddress = fromSegmentedMasked(branchDl);
            *dl = reinterpret_cast<DisplayList *>(state->fromRDRAM(rdramAddress)) - 1;
        }
    }

    void RSP::branchW(uint32_t branchDl, uint16_t vtxIndex, uint32_t wValue, DisplayList **dl) {
        const bool forceBranch = forceBranchEnabled();
        const int workloadCursor = state->ext.workloadQueue->writeCursor;
        const Workload &workload = state->ext.workloadQueue->workloads[workloadCursor];
        const uint32_t globalIndex = indices[vtxIndex];
        const float posW = workload.drawData.posTransformed[globalIndex][3];
        if (forceBranch || (posW < static_cast<float>(wValue))) {
            const uint32_t rdramAddress = fromSegmentedMasked(branchDl);
            *dl = reinterpret_cast<DisplayList *>(state->fromRDRAM(rdramAddress)) - 1;
        }
    }

    void RSP::setGeometryMode(uint32_t mask) {
        geometryModeStack[geometryModeStackSize - 1] |= mask;
        state->updateDrawStatusAttribute(DrawAttribute::GeometryMode);
    }

    void RSP::pushGeometryMode() {
        if (geometryModeStackSize < RSP_EXTENDED_STACK_SIZE) {
            geometryModeStack[geometryModeStackSize] = geometryModeStack[geometryModeStackSize - 1];
            geometryModeStackSize++;
        }
    }

    void RSP::popGeometryMode() {
        if (geometryModeStackSize > 1) {
            geometryModeStackSize--;
            state->updateDrawStatusAttribute(DrawAttribute::GeometryMode);
        }
    }

    void RSP::clearGeometryMode(uint32_t mask) {
        geometryModeStack[geometryModeStackSize - 1] &= ~mask;
        state->updateDrawStatusAttribute(DrawAttribute::GeometryMode);
    }

    void RSP::modifyGeometryMode(uint32_t offMask, uint32_t onMask) {
        uint32_t &geometryMode = geometryModeStack[geometryModeStackSize - 1];
        geometryMode &= offMask;
        geometryMode |= onMask;
        state->updateDrawStatusAttribute(DrawAttribute::GeometryMode);
    }

    void RSP::setObjRenderMode(uint32_t value) {
        objRenderMode = value;
        state->updateDrawStatusAttribute(DrawAttribute::ObjRenderMode);
    }

    void RSP::setViewport(uint32_t address) {
        setViewport(address, extended.global.viewportOrigin, extended.global.viewportOffsetX, extended.global.viewportOffsetY);
    }
    
    void RSP::setViewport(uint32_t address, uint16_t ori, int16_t offx, int16_t offy) {
        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const Vp_t *vp = reinterpret_cast<const Vp_t *>(state->fromRDRAM(rdramAddress));
        interop::RSPViewport &viewport = viewportStack[viewportStackSize - 1];
        viewport.scale.x = float(vp->vscale[1]) / 4.0f;
        viewport.scale.y = float(vp->vscale[0]) / 4.0f;
        viewport.scale.z = float(vp->vscale[3]) / DepthRange;
        viewport.translate.x = float(state->rdp->movedFromOrigin(vp->vtrans[1], ori) + offx) / 4.0f;
        viewport.translate.y = float(vp->vtrans[0] + offy) / 4.0f;
        viewport.translate.z = float(vp->vtrans[3]) / DepthRange;
        extended.viewportOriginStack[viewportStackSize - 1] = ori;
        viewportChanged = true;
        // cv64 (session 12) viewport diagnostic — env-gated to a FILE (the GUI exe has no usable
        // stderr; same reason the recomp diag sinks write files). Set RT64_VP_LOG=<path> to capture.
        // A correct 320x240 viewport = scale(160,120,*) translate(160,120,*); geometry squished into a
        // corner shows up here as a bad viewport scale/translate. Baseline-safe (no-op when unset).
        {
            static const char *vp_log = std::getenv("RT64_VP_LOG");
            if (vp_log != nullptr) {
                static unsigned long long s_vp = 0;
                s_vp++;
                if (s_vp <= 40 || (s_vp % 500ULL) == 0) {
                    if (FILE *f = fopen(vp_log, "a")) {
                        fprintf(f, "[rt64_vp] #%llu seg=0x%08X rdram=0x%08X scale=(%.2f,%.2f,%.4f) "
                                "trans=(%.2f,%.2f,%.4f) vscale_raw=[%d,%d,%d,%d] vtrans_raw=[%d,%d,%d,%d]\n",
                                s_vp, address, rdramAddress,
                                (float)viewport.scale.x, (float)viewport.scale.y, (float)viewport.scale.z,
                                (float)viewport.translate.x, (float)viewport.translate.y, (float)viewport.translate.z,
                                (int)vp->vscale[0], (int)vp->vscale[1], (int)vp->vscale[2], (int)vp->vscale[3],
                                (int)vp->vtrans[0], (int)vp->vtrans[1], (int)vp->vtrans[2], (int)vp->vtrans[3]);
                        fclose(f);
                    }
                }
            }
        }
    }

    void RSP::pushViewport() {
        if (viewportStackSize < RSP_EXTENDED_STACK_SIZE) {
            viewportStack[viewportStackSize] = viewportStack[viewportStackSize - 1];
            extended.viewportOriginStack[viewportStackSize] = extended.viewportOriginStack[viewportStackSize - 1];
            viewportStackSize++;
        }
    }

    void RSP::popViewport() {
        if (viewportStackSize > 1) {
            viewportStackSize--;
            viewportChanged = true;
        }
    }
    
    void RSP::setLight(uint8_t index, uint32_t address) {
        assert((index >= 0) && (index <= RSP_MAX_LIGHTS));
        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const uint8_t *data = reinterpret_cast<const uint8_t *>(state->fromRDRAM(rdramAddress));
        memcpy(&lights[index], data, sizeof(Light));
        lightsChanged = true;
    }

    void RSP::setLightColor(uint8_t index, uint32_t value) {
        assert((index >= 0) && (index <= RSP_MAX_LIGHTS));
        auto &rawLight = lights[index].raw;
        rawLight.words[0] = value;
        rawLight.words[1] = value;
        lightsChanged = true;
    }

    void RSP::setLightCount(uint8_t count) {
        lightCount = count;
        lightsChanged = true;
    }

    void RSP::setClipRatioEdge(uint8_t index, int16_t value) {
        assert(index < clipRatios.size());
        clipRatios[index] = value;
        viewportChanged = true;
    }

    void RSP::setClipRatioAll(int16_t value) {
        setClipRatioEdge(0, value);
        setClipRatioEdge(1, value);
        setClipRatioEdge(2, -value);
        setClipRatioEdge(3, -value);
    }

    void RSP::setPerspNorm(uint32_t perspNorm) {
        // TODO
    }

    void RSP::setLookAt(uint8_t index, uint32_t address) {
        assert(index < 2);
        const uint32_t rdramAddress = fromSegmentedMasked(address);
        const DirLight *dirLight = reinterpret_cast<const DirLight *>(state->fromRDRAM(rdramAddress));
        auto &dstLookAt = (index == 1) ? lookAt.y : lookAt.x;
        if ((dirLight->dirx != 0) || (dirLight->diry != 0) || (dirLight->dirz != 0)) {
            dstLookAt = hlslpp::normalize(hlslpp::float3(float(dirLight->dirx), float(dirLight->diry), float(dirLight->dirz)));
        }
        else {
            dstLookAt = { 0.0f, 0.0f, 0.0f };
        }

        lookAtChanged = true;
    }

    void RSP::setLookAtVectors(interop::float3 x, interop::float3 y) {
        lookAt.x = x;
        lookAt.y = y;
        lookAtChanged = true;
    }

    void RSP::setFog(int16_t mul, int16_t offset) {
        fog.mul = mul;
        fog.offset = offset;
        fogChanged = true;
    }
    
    void RSP::setTexture(uint8_t tile, uint8_t level, uint8_t on, uint16_t sc, uint16_t tc) {
        textureState.tile = tile;
        textureState.levels = level + 1;
        textureState.on = on;
        textureState.sc = sc;
        textureState.tc = tc;
    }

    void RSP::setOtherMode(uint32_t high, uint32_t low) {
        interop::OtherMode &otherMode = otherModeStack[otherModeStackSize - 1];
        otherMode.H = high;
        otherMode.L = low;
        state->rdp->setOtherMode(otherMode.H, otherMode.L);
    }

    void RSP::pushOtherMode() {
        if (otherModeStackSize < RSP_EXTENDED_STACK_SIZE) {
            otherModeStack[otherModeStackSize] = otherModeStack[otherModeStackSize - 1];
            otherModeStackSize++;
        }
    }

    void RSP::popOtherMode() {
        if (otherModeStackSize > 1) {
            otherModeStackSize--;
            const interop::OtherMode &otherMode = otherModeStack[otherModeStackSize - 1];
            state->rdp->setOtherMode(otherMode.H, otherMode.L);
        }
    }

    void RSP::setOtherModeL(uint32_t size, uint32_t off, uint32_t data) {
        interop::OtherMode &otherMode = otherModeStack[otherModeStackSize - 1];
        const uint32_t mask = (((uint64_t)(1) << size) - 1) << off;
        otherMode.L = (otherMode.L & (~mask)) | data;
        state->rdp->setOtherMode(otherMode.H, otherMode.L);
    }

    void RSP::setOtherModeH(uint32_t size, uint32_t off, uint32_t data) {
        interop::OtherMode &otherMode = otherModeStack[otherModeStackSize - 1];
        const uint32_t mask = (((uint64_t)(1) << size) - 1) << off;
        otherMode.H = (otherMode.H & (~mask)) | data;
        state->rdp->setOtherMode(otherMode.H, otherMode.L);
    }

    void RSP::setColorImage(uint8_t fmt, uint8_t siz, uint16_t width, uint32_t segAddress) {
        state->rdp->setColorImage(fmt, siz, width, fromSegmented(segAddress));
    }

    void RSP::setDepthImage(uint32_t segAddress) {
        state->rdp->setDepthImage(fromSegmented(segAddress));
    }

    void RSP::setTextureImage(uint8_t fmt, uint8_t siz, uint16_t width, uint32_t segAddress) {
        state->rdp->setTextureImage(fmt, siz, width, fromSegmented(segAddress));
    }


    void RSP::drawIndexedTri(uint32_t a, uint32_t b, uint32_t c, bool rawGlobalIndices) {
        // Copy mode is not supported when drawing regular tris and crashes the hardware.
        const uint32_t cycleType = state->rdp->otherMode.cycleType();
        assert(cycleType != G_CYC_COPY);

        // Don't draw anything if both tris are being culled.
        const uint32_t &geometryMode = geometryModeStack[geometryModeStackSize - 1];

        // cv64 probe: count ALL triangle submissions (RSP path) BEFORE the cull early-out.
        // Answers: are 3D triangles even reaching the renderer, and what projType + cull status.

        // [tricensus 2026-08-28] instrument only, env RECOMP_TRI_CENSUS=1, default silent.
        // THE QUESTION: SOTE walks 3,098,973 TRI1 commands and 380,160 matrix loads per census
        // window, RT64 reports NO unknown opcodes -- and yet every projection it forms is a
        // Rectangle and no 3D appears. The early-out directly below drops a triangle when BOTH
        // cull bits are set, and that would produce exactly this picture: 2D rects still draw
        // (they never come through here) while 100% of the geometry is discarded silently.
        // Suspect: SOTE's microcode predates the retail SDK, and the DL census shows
        // G_SETGEOMETRYMODE(0xB7) and G_CLEARGEOMETRYMODE(0xB6) arriving in EXACTLY equal counts
        // (341747 each) -- if those two are swapped relative to stock F3D, every "clear" sets and
        // the cull bits latch on. This counts calls, culls, projection types and the distinct
        // geometryMode values so the answer is a number, not a guess.
        {
            static const bool on = [] { const char *e = std::getenv("RECOMP_TRI_CENSUS"); return (e != nullptr) && (e[0] == '1'); }();
            if (on) {
                static unsigned long long nCall = 0, nCull = 0, nPersp = 0, nOrtho = 0, nOther = 0;
                static uint32_t gmSeen[16]; static unsigned long long gmCnt[16]; static int gmN = 0;
                nCall++;
                const bool culledNow = ((geometryMode & cullBothMask) == cullBothMask);
                if (culledNow) nCull++;
                const Projection::Type pt = getCurrentProjectionType();
                if (pt == Projection::Type::Perspective) nPersp++;
                else if (pt == Projection::Type::Orthographic) nOrtho++;
                else nOther++;
                int gi = -1;
                for (int k = 0; k < gmN; k++) if (gmSeen[k] == geometryMode) { gi = k; break; }
                if (gi < 0 && gmN < 16) { gi = gmN++; gmSeen[gi] = geometryMode; gmCnt[gi] = 0; }
                if (gi >= 0) gmCnt[gi]++;
                if (nCall <= 5 || (nCall % 200000ULL) == 0) {
                    fprintf(stderr, "[tricensus] calls=%llu culled=%llu (cullBothMask=0x%08X) proj{persp,ortho,other}={%llu,%llu,%llu} gm:",
                            nCall, nCull, (unsigned)cullBothMask, nPersp, nOrtho, nOther);
                    for (int k = 0; k < gmN; k++) fprintf(stderr, " 0x%08X=%llu", gmSeen[k], gmCnt[k]);
                    fprintf(stderr, "%c", 0x0A);
                    fflush(stderr);
                }
            }
        }
        // [vtxcensus 2026-08-28] instrument only, env RECOMP_VTX_CENSUS=1, default silent.
        // Established so far: 8.36M perspective triangles reach here with culled=0, every
        // perspective pair renders into a VI-PRESENTED buffer, the Z clear never stalls -- and yet
        // suppressing the 2D leaves a PURE BLACK screen. So the triangles produce NO PIXELS. The
        // remaining question is purely geometric: where do these vertices land after transform?
        // Transform happens on the GPU at flush, so do it here on the CPU with the same matrices
        // (mvp = mul(model, viewProj), row-vector) and count how many vertices fall inside the
        // clip volume. All-outside => a matrix/vertex decode problem; all-inside => the loss is
        // downstream in raster/blend, not geometry.
        {
            static const bool on = [] { const char *e = std::getenv("RECOMP_VTX_CENSUS"); return (e != nullptr) && (e[0] == '1'); }();
            if (on) {
                static unsigned long long nT = 0, nIn = 0, nBehind = 0, nDegen = 0, nWzero = 0;
                nT++;
                const hlslpp::float4x4 mvp = hlslpp::mul(modelMatrixStack[modelMatrixStackSize - 1], viewProjMatrixStack[projectionMatrixStackSize - 1]);
                const uint32_t idx[3] = { a, b, c };
                float sx[3] = {0,0,0}, sy[3] = {0,0,0};
                bool anyIn = false, anyBehind = false, anyW0 = false;
                for (int i = 0; i < 3; i++) {
                    const Vertex &v = vertices[idx[i] % RSP_MAX_VERTICES];
                    hlslpp::float4 pos((float)v.x, (float)v.y, (float)v.z, 1.0f);
                    hlslpp::float4 clip = hlslpp::mul(pos, mvp);
                    const float cw = (float)clip.w, cx = (float)clip.x, cy = (float)clip.y;
                    if (cw <= 0.0f) { anyBehind = true; if (cw == 0.0f) anyW0 = true; sx[i] = sy[i] = 0.0f; continue; }
                    sx[i] = cx / cw; sy[i] = cy / cw;
                    if (sx[i] >= -1.0f && sx[i] <= 1.0f && sy[i] >= -1.0f && sy[i] <= 1.0f) anyIn = true;
                }
                if (anyIn) nIn++;
                if (anyBehind) nBehind++;
                if (anyW0) nWzero++;
                if ((sx[0] == sx[1] && sx[1] == sx[2]) && (sy[0] == sy[1] && sy[1] == sy[2])) nDegen++;
                if (nT <= 6 || (nT % 400000ULL) == 0) {
                    fprintf(stderr, "[vtxcensus] tris=%llu inFrustum=%llu behind=%llu w0=%llu degenerate=%llu | ndc a=(%.3f,%.3f) b=(%.3f,%.3f) c=(%.3f,%.3f)%c",
                            nT, nIn, nBehind, nWzero, nDegen, sx[0], sy[0], sx[1], sy[1], sx[2], sy[2], 0x0A);
                    fflush(stderr);
                }
            }
        }
        if ((geometryMode & cullBothMask) == cullBothMask) {
            return;
        }
        
        state->rdp->checkFramebufferPair();
        
        // We must add the current projection again if we're not in the right state.
        const int workloadCursor = state->ext.workloadQueue->writeCursor;
        Workload &workload = state->ext.workloadQueue->workloads[workloadCursor];
        FramebufferPair &fbPair = workload.fbPairs[workload.currentFramebufferPairIndex()];
        const Projection::Type projType = getCurrentProjectionType();
        if (!fbPair.inProjection(curViewProjIndex, projType)) {
            state->flush();
            addCurrentProjection(projType);
        }

        // Check if the texture needs to be updated.
        auto &drawCall = state->drawCall;
        if ((drawCall.textureOn != textureState.on) || (drawCall.textureTile != textureState.tile) || (drawCall.textureLevels != textureState.levels)) {
            drawCall.textureOn = textureState.on;
            drawCall.textureTile = textureState.tile;
            drawCall.textureLevels = textureState.levels;
            state->updateDrawStatusAttribute(DrawAttribute::Texture);
        }

        if (state->checkDrawState()) {
            state->loadDrawState();
        }

        const bool usesShade = geometryMode & G_SHADE;
        const bool usesLighting = geometryMode & G_LIGHTING;
        const bool usesFog = geometryMode & G_FOG;
        const bool computeSmoothNormals = !usesLighting;

        // Swap the indices around if and only if front face culling is enabled.
        if ((geometryMode & cullBothMask) == cullFrontMask) {
            uint8_t swap = c;
            c = a;
            a = swap;
        }
        
        auto &faceIndices = workload.drawData.faceIndices;
        auto &viewProjIndices = workload.drawData.viewProjIndices;
        auto &worldIndices = workload.drawData.worldIndices;
        auto &posScreen = workload.drawData.posScreen;
        auto &tcFloats = workload.drawData.tcFloats;
        auto &minMatrix = drawCall.minWorldMatrix;
        auto &maxMatrix = drawCall.maxWorldMatrix;
        uint32_t globalIndices[3];
        if (rawGlobalIndices) {
            globalIndices[0] = a;
            globalIndices[1] = b;
            globalIndices[2] = c;
        }
        else {
            globalIndices[0] = indices[a];
            globalIndices[1] = indices[b];
            globalIndices[2] = indices[c];
            used[a] = used[b] = used[c] = true;
        }


        // cv64 S41 timing layer: accumulate this triangle's estimated real-RDP cost (screen-space area
        // in native framebuffer pixels × cycles-per-pixel by cycle type + setup). posScreen is the CPU
        // shadow projection in N64 framebuffer coordinates.
        {
            const auto &_ps = workload.drawData.posScreen;
            const float _x0 = float(_ps[globalIndices[0]].x), _y0 = float(_ps[globalIndices[0]].y);
            const float _x1 = float(_ps[globalIndices[1]].x), _y1 = float(_ps[globalIndices[1]].y);
            const float _x2 = float(_ps[globalIndices[2]].x), _y2 = float(_ps[globalIndices[2]].y);
            double _area = 0.5 * fabs(double(_x1 - _x0) * double(_y2 - _y0) - double(_y1 - _y0) * double(_x2 - _x0));
            if (!(_area >= 0.0)) _area = 0.0;  // NaN/garbage guard
            // Hardware truth: the RDP only spends cycles on pixels INSIDE the scissor. Bound the tri's cost
            // by its bounding box intersected with the current scissor (both in fb pixels; scissor is ×4
            // fixed-point). The old code clamped any oversized tri to a WHOLE screen (76800) and billed it,
            // so off-screen / phantom (uninitialized-vert) triangles — hundreds per heavy frame — inflated
            // the estimate ~60x (1000ms phantom frames). A genuine on-screen tri is unaffected: its
            // bbox∩scissor always covers its area. This makes the per-DL cost track the REAL RDP work, so
            // the authentic-timing tempo is derived correctly from the game's own display lists.
            {
                const FixedRect &_sc = state->rdp->scissorRectStack[state->rdp->scissorStackSize - 1];
                const double _scx0 = _sc.ulx / 4.0, _scy0 = _sc.uly / 4.0, _scx1 = _sc.lrx / 4.0, _scy1 = _sc.lry / 4.0;
                const double _bx0 = std::max(_scx0, double(std::min(std::min(_x0, _x1), _x2)));
                const double _by0 = std::max(_scy0, double(std::min(std::min(_y0, _y1), _y2)));
                const double _bx1 = std::min(_scx1, double(std::max(std::max(_x0, _x1), _x2)));
                const double _by1 = std::min(_scy1, double(std::max(std::max(_y0, _y1), _y2)));
                const double _vis = std::max(0.0, _bx1 - _bx0) * std::max(0.0, _by1 - _by0);
                if (_area > _vis) _area = _vis;
                // P1 v2 counting (TIMING_FIDELITY_DESIGN): pixels by cycle-type bucket +
                // scissor-clamped scanline (span) count. Log-only — nothing acts on these.
                {
                    const double _lines2 = std::max(0.0, _by1 - _by0);
                    const int _b2 = (cycleType == G_CYC_FILL) ? 0 : (cycleType == G_CYC_COPY) ? 1
                                  : (cycleType == G_CYC_2CYCLE) ? 3 : 2;
                    g_rdptime2_pix[_b2] += _area;
                    g_rdptime2_lines += _lines2;
                    g_rdptime2_setup += RDP_TRI_SETUP_CYCLES;
                    g_rdptime2_prims++;
                }
            }
            const double _pixCycles = (cycleType == G_CYC_2CYCLE) ? 2.0 : 1.0;
            ::g_rdp_estimated_cost_cycles += RDP_TRI_SETUP_CYCLES + _area * _pixCycles * RDP_CONTENTION;
        }

        // cv64 S41 [fire9]: FIRE-attributed triangles (vertex-source-keyed — see setVertex). Dumps the
        // CPU-shadow screen positions + the projection/fbPair context for the lightning-fire's own tris.
        {
            if (g_cv64_fire9_ttl > 0 && !rawGlobalIndices &&
                (int)a >= g_cv64_fire9_min && (int)a < g_cv64_fire9_max) {
                g_cv64_fire9_ttl--;
                static int _f9t = 0;
                if (_f9t++ < 40) {
                    auto &ps = workload.drawData.posScreen;
                    const Projection::Type _pt = getCurrentProjectionType();
                    fprintf(stderr, "[fire9] TRI proj=%s vpIdx=%d fb=%d gm=0x%08X scr:(%.1f,%.1f,%.4f)(%.1f,%.1f,%.4f)(%.1f,%.1f,%.4f)\n",
                        (_pt == Projection::Type::Perspective) ? "Persp" : (_pt == Projection::Type::Orthographic) ? "Ortho" : "Other",
                        (int)curViewProjIndex, (int)workload.currentFramebufferPairIndex(), geometryMode,
                        float(ps[globalIndices[0]].x), float(ps[globalIndices[0]].y), float(ps[globalIndices[0]].z),
                        float(ps[globalIndices[1]].x), float(ps[globalIndices[1]].y), float(ps[globalIndices[1]].z),
                        float(ps[globalIndices[2]].x), float(ps[globalIndices[2]].y), float(ps[globalIndices[2]].z));
                    fflush(stderr);
                }
            }
        }

        // cv64 SESSION 40c [fire5]: the [fire4] dump proved the flame's resolved DRAW STATE is healthy
        // (tiles valid, blender = fogged XLU, prim/env right, tris flushed) — so the kill must be in what
        // the state dump can't see: the VERTEX layer (degenerate/offscreen billboard quad) or the GPU-side
        // texel decode. Dump the flame tris' screen positions + texcoords. Keyed on the flame combiner
        // (L=w0 incl. FC byte, H=w1 — the S40b lesson); cap counts only WITHIN the condition (can't
        // pre-burn — the S39 lesson).
        {
            const auto &_cc = state->rdp->colorCombinerStack[state->rdp->colorCombinerStackSize - 1];
            if ((_cc.L & 0xFFFFFFu) == 0x151660u && _cc.H == 0x2515257Fu) {
                static int _f5 = 0;
                if (_f5++ < 48) {
                    auto &ps = workload.drawData.posScreen;
                    auto &tc = workload.drawData.tcFloats;
                    fprintf(stderr, "[fire5] tri v(%u,%u,%u) screen: (%.2f,%.2f,%.4f) (%.2f,%.2f,%.4f) (%.2f,%.2f,%.4f) tc: (%.1f,%.1f) (%.1f,%.1f) (%.1f,%.1f)\n",
                        globalIndices[0], globalIndices[1], globalIndices[2],
                        float(ps[globalIndices[0]].x), float(ps[globalIndices[0]].y), float(ps[globalIndices[0]].z),
                        float(ps[globalIndices[1]].x), float(ps[globalIndices[1]].y), float(ps[globalIndices[1]].z),
                        float(ps[globalIndices[2]].x), float(ps[globalIndices[2]].y), float(ps[globalIndices[2]].z),
                        float(tc[globalIndices[0] * 2]), float(tc[globalIndices[0] * 2 + 1]),
                        float(tc[globalIndices[1] * 2]), float(tc[globalIndices[1] * 2 + 1]),
                        float(tc[globalIndices[2] * 2]), float(tc[globalIndices[2] * 2 + 1]));
                    fflush(stderr);
                }
            }
        }

        // [figz] cont.20: figure (perspective) screen-Z distribution. Are the figures' surfaces COLLAPSED into
        // a tiny Z range (=> z-fighting + no occlusion, the depth-tie/precision class) or well-separated?
        if (getCurrentProjectionType() == Projection::Type::Perspective) {
            static float _zmin = 1e9f, _zmax = -1e9f; static unsigned _zn = 0; static int _zl = 0;
            const float _z0 = float(posScreen[globalIndices[0]].z), _z1 = float(posScreen[globalIndices[1]].z), _z2 = float(posScreen[globalIndices[2]].z);
            if (_z0 < _zmin) _zmin = _z0; if (_z0 > _zmax) _zmax = _z0;
            if (_z1 < _zmin) _zmin = _z1; if (_z1 > _zmax) _zmax = _z1;
            if (_z2 < _zmin) _zmin = _z2; if (_z2 > _zmax) _zmax = _z2;
            if ((++_zn % 2000u) == 0u && _zl++ < 40) {
                fprintf(stderr, "[figz] persp tris=%u  screenZ all-time[%.5f..%.5f] span=%.6f  thisTri z=%.5f,%.5f,%.5f\n",
                    _zn, _zmin, _zmax, _zmax - _zmin, _z0, _z1, _z2);
                fflush(stderr);
            }
        }

        // CV64 Brick 4 (Option D) — ROUTE THE FAITHFUL LLE SCREEN-Z INTO RT64'S DEPTH. The HLE transform
        // collapses the visible scene to a single depth band (Reinhardt's depth-band viz); the LLE F3DEX2
        // computes the REAL, separated screen-Z (Z-DIST [0.146..1.09]). Both interpret THIS same DL in the
        // same order, sequentially on the events thread (capture_gfx_task -> send_dl), so the Nth
        // perspective triangle here == the Nth LLE z-tri -> override the 3 verts' depth by ordinal index.
        // No-op unless the LLE ran (count>0, i.e. CV64_GFX_LLE=1). First cut = flat per-triangle Z (shared
        // verts resolve to the last writer; ~each vert ends at its own neighborhood depth, fine for the
        // foreground/background separation that fixes the castle). Refine to per-vertex / Z-plane next.
        // THROWAWAY toggle (set CV64_AB_LLE_Z 0 to restore stock).
// CV64 Brick 4 override: DISABLED (set 1 to re-enable). The capture + cross-module routing WORK (the
// faithful-Z buffer populates), but neither posScreen (CPU-only) nor the modifyPos mechanism lands the
// depth on screen — forcing ALL persp tris to a constant 0.5 via modifyPos produced NO visual change,
// i.e. a screenPos->render disconnect (frame-interpolation / separate raster buffer) that needs a live
// GPU capture to crack. Capture infra kept; this override parked until that's resolved. See cont.31.

        // [zsep] cont.22 (Bug A — castle depth-tie discriminator). The ONE missing measurement: within
        // the crushed castle screenZ range ([figz] proved span~0.02), is the FRONT wall physically in
        // front of the inner/back wall (a pure TIE we just resolve to the back), or is the BACK computed
        // NEARER (a projection/winding bug)? Ground truth for "physically nearer" = camera-space w
        // (posTransformed[gi][3], the exact value branchW reads). screenZ (posScreen[gi][2]) = what we
        // feed the depth buffer. Per coarse screen cell, track the NEAREST surface (min w) and FARTHEST
        // (max w) and each one's screenZ; a spire's front wall vs its visible inner/back wall land in the
        // same cells with a big w gap. Verdict per cell: TIE (|dz|~0 despite big w gap -> precision crush
        // -> tie-break/quantize, threaded through the shared RasterPS), INVERT (near surface got the
        // FARTHER screenZ -> projection/winding bug), OK (ordering correct -> depth VALUES aren't the bug).
        // Pure RSP-side geometry, before any pixel shader -> sidesteps the shader-variant gotcha for the
        // MEASUREMENT. THROWAWAY probe (strip on cleanup). Opening cutscene = all-perspective = the castle.
        if (getCurrentProjectionType() == Projection::Type::Perspective) {
            static const int ZS_COLS = 20, ZS_ROWS = 15, ZS_N = ZS_COLS * ZS_ROWS; // 16px cells over 320x240
            static float zs_nearW[ZS_N], zs_nearZ[ZS_N], zs_farW[ZS_N], zs_farZ[ZS_N];
            static uint32_t zs_cnt[ZS_N];
            static bool zs_init = false;
            static unsigned zs_tris = 0; static int zs_dumped = 0;
            static float zs_wmin = 1e30f, zs_wmax = -1e30f, zs_zmin = 1e30f, zs_zmax = -1e30f;
            auto zs_reset = [&]() {
                for (int i = 0; i < ZS_N; ++i) { zs_nearW[i] = 1e30f; zs_farW[i] = -1e30f; zs_nearZ[i] = 0.0f; zs_farZ[i] = 0.0f; zs_cnt[i] = 0u; }
                zs_tris = 0u; zs_wmin = 1e30f; zs_wmax = -1e30f; zs_zmin = 1e30f; zs_zmax = -1e30f;
            };
            if (!zs_init) { zs_reset(); zs_init = true; }

            auto &posT = workload.drawData.posTransformed;
            const float sx = (float(posScreen[globalIndices[0]][0]) + float(posScreen[globalIndices[1]][0]) + float(posScreen[globalIndices[2]][0])) / 3.0f;
            const float sy = (float(posScreen[globalIndices[0]][1]) + float(posScreen[globalIndices[1]][1]) + float(posScreen[globalIndices[2]][1])) / 3.0f;
            const float cz = (float(posScreen[globalIndices[0]][2]) + float(posScreen[globalIndices[1]][2]) + float(posScreen[globalIndices[2]][2])) / 3.0f;
            const float cw = (float(posT[globalIndices[0]][3]) + float(posT[globalIndices[1]][3]) + float(posT[globalIndices[2]][3])) / 3.0f;
            if (cw > 0.0f && sx >= 0.0f && sx < 320.0f && sy >= 0.0f && sy < 240.0f) {
                const int cell = (int(sy) / 16) * ZS_COLS + (int(sx) / 16);
                if (cell >= 0 && cell < ZS_N) {
                    if (cw < zs_nearW[cell]) { zs_nearW[cell] = cw; zs_nearZ[cell] = cz; }
                    if (cw > zs_farW[cell])  { zs_farW[cell]  = cw; zs_farZ[cell]  = cz; }
                    zs_cnt[cell]++;
                    if (cw < zs_wmin) zs_wmin = cw; if (cw > zs_wmax) zs_wmax = cw;
                    if (cz < zs_zmin) zs_zmin = cz; if (cz > zs_zmax) zs_zmax = cz;
                    zs_tris++;
                }
                // Dump ~every frame-and-a-half of castle so each snapshot is a coherent camera pose;
                // multiple dumps reveal whether the verdict is stable as the cutscene camera pans.
                if (zs_tris >= 4000u && zs_dumped < 6) {
                    zs_dumped++;
                    fprintf(stderr, "[zsep] DUMP #%d  tris=%u  globalW[%.3f..%.3f] globalScreenZ[%.5f..%.5f]\n",
                            zs_dumped, zs_tris, zs_wmin, zs_wmax, zs_zmin, zs_zmax);
                    for (int pick = 0; pick < 8; ++pick) {
                        int best = -1; float bestGap = -1.0f;
                        for (int i = 0; i < ZS_N; ++i) {
                            if (zs_cnt[i] < 4u) continue;            // need real coverage, not a stray tri
                            const float gap = zs_farW[i] - zs_nearW[i];
                            if (gap > bestGap) { bestGap = gap; best = i; }
                        }
                        if (best < 0) break;
                        const float dz = zs_nearZ[best] - zs_farZ[best];   // <0 = near in front (OK); >0 = near behind (INVERT)
                        const float adz = dz < 0.0f ? -dz : dz;
                        const char *verdict = (adz < 0.0008f) ? "TIE   " : (dz > 0.0f ? "INVERT" : "OK    ");
                        fprintf(stderr, "  [zsep] cell(%2d,%2d) cnt=%4u  near{w=%.3f z=%.5f} far{w=%.3f z=%.5f}  dz(near-far)=%+.6f  %s\n",
                                best % ZS_COLS, best / ZS_COLS, zs_cnt[best],
                                zs_nearW[best], zs_nearZ[best], zs_farW[best], zs_farZ[best], dz, verdict);
                        zs_cnt[best] = 0u; // exclude this cell from the next pick
                    }
                    fflush(stderr);
                    zs_reset();
                }
            }
        }

        // [zoor] cont.22 (Bug A — pin the spill SOURCE). [figz] showed the castle's depth-buffer screenZ
        // spilling to [-0.17..1.08] (out of [0,1] -> clamp -> occlusion collapse), while [zmap]'s mvp path
        // is healthy. So a SPECIFIC projection/path produces the out-of-range NDC z. Bucket perspective
        // tris by viewProjIndex (and note worldIndex): if the spill (OORverts>0, screenZ outside [0,1])
        // concentrates in one/few vpi -> THAT projection's depth range is wrong (fix its near/far or the
        // viewport depth map; reaches any shader variant since it's pre-raster). If ALL vpi spill -> a
        // global viewport.scale.z/translate.z / DepthRange issue. Also logs per-bucket w to settle whether
        // these are real perspective-w verts or the w~1 path. THROWAWAY probe (strip on cleanup).
        if (getCurrentProjectionType() == Projection::Type::Perspective) {
            static const int ZO_MAX = 24;
            static uint32_t zo_vpi[ZO_MAX], zo_wi[ZO_MAX], zo_cnt[ZO_MAX], zo_oor[ZO_MAX];
            static float zo_szmin[ZO_MAX], zo_szmax[ZO_MAX], zo_wmin[ZO_MAX], zo_wmax[ZO_MAX];
            static int zo_nv = 0; static unsigned zo_tris = 0; static int zo_dumped = 0;
            auto &posTo = workload.drawData.posTransformed;
            const uint32_t vpi = viewProjIndices[globalIndices[0]];
            int slot = -1;
            for (int i = 0; i < zo_nv; ++i) { if (zo_vpi[i] == vpi) { slot = i; break; } }
            if (slot < 0 && zo_nv < ZO_MAX) {
                slot = zo_nv++;
                zo_vpi[slot] = vpi; zo_wi[slot] = worldIndices[globalIndices[0]];
                zo_cnt[slot] = 0u; zo_oor[slot] = 0u;
                zo_szmin[slot] = 1e30f; zo_szmax[slot] = -1e30f; zo_wmin[slot] = 1e30f; zo_wmax[slot] = -1e30f;
            }
            if (slot >= 0) {
                zo_cnt[slot]++;
                for (int k = 0; k < 3; ++k) {
                    const float z = float(posScreen[globalIndices[k]][2]);
                    const float w = float(posTo[globalIndices[k]][3]);
                    if (z < zo_szmin[slot]) zo_szmin[slot] = z; if (z > zo_szmax[slot]) zo_szmax[slot] = z;
                    if (w < zo_wmin[slot]) zo_wmin[slot] = w; if (w > zo_wmax[slot]) zo_wmax[slot] = w;
                    if (z < 0.0f || z > 1.0f) zo_oor[slot]++;
                }
            }
            if ((++zo_tris % 8000u) == 0u && zo_dumped < 5) {
                zo_dumped++;
                fprintf(stderr, "[zoor] DUMP #%d  %d viewProj buckets:\n", zo_dumped, zo_nv);
                for (int i = 0; i < zo_nv; ++i) {
                    fprintf(stderr, "  [zoor] vpi=%u wi=%u tris=%u screenZ[%.4f..%.4f] w[%.2f..%.2f] OORverts=%u\n",
                            zo_vpi[i], zo_wi[i], zo_cnt[i], zo_szmin[i], zo_szmax[i], zo_wmin[i], zo_wmax[i], zo_oor[i]);
                }
                fflush(stderr);
            }
        }

        // [zsrc] cont.22 (Bug A — CLIP vs VIEWPORT, the fix-decider). screenZ = ndc_z*scale.z + translate.z,
        // ndc_z = tfPos.z/tfPos.w. [zoor] proved the castle's screenZ spills out of [0,1] on a SINGLE
        // projection with NEGATIVE clip-w. Pin the spill SOURCE: for each perspective vertex whose screenZ
        // is out of [0,1], log the raw {tfPos.z, tfPos.w, ndc_z, screenZ}, and tally categories.
        //   - ndc_z itself OUT of [-1,1]  -> near/far-CLIP problem (geometry crosses the planes; the faithful
        //     fix is N64 near-clip / a depth clamp), OR
        //   - ndc_z IN [-1,1] but screenZ spills -> the VIEWPORT depth map (scale.z/translate.z over
        //     DepthRange=1024) is wrong -> a single-transform fix at setViewport (L1192/1195).
        // All inputs already in scope (posTransformed = clip-space float4, posScreen.z = screenZ).
        // THROWAWAY probe (strip on cleanup).
        if (getCurrentProjectionType() == Projection::Type::Perspective) {
            static unsigned zr_tot = 0, zr_wneg = 0, zr_ndcGt1 = 0, zr_ndcLtm1 = 0, zr_szGt1 = 0, zr_szLt0 = 0;
            static int zr_logged = 0; static unsigned zr_tris = 0; static int zr_dumped = 0;
            auto &posTr = workload.drawData.posTransformed;
            for (int k = 0; k < 3; ++k) {
                const uint32_t gi = globalIndices[k];
                const float tz = float(posTr[gi][2]), tw = float(posTr[gi][3]);
                const float ndcz = (tw != 0.0f) ? tz / tw : 0.0f;
                const float sz = float(posScreen[gi][2]);
                zr_tot++;
                if (tw < 0.0f) zr_wneg++;
                if (ndcz > 1.0f) zr_ndcGt1++;
                if (ndcz < -1.0f) zr_ndcLtm1++;
                if (sz > 1.0f) zr_szGt1++;
                if (sz < 0.0f) zr_szLt0++;
                if ((sz > 1.0f || sz < 0.0f) && zr_logged < 40) {
                    zr_logged++;
                    fprintf(stderr, "  [zsrc] OOR vert  tfPosZ=%.3f  tfPosW=%.3f  ndcz=%+.5f  screenZ=%+.5f\n", tz, tw, ndcz, sz);
                }
            }
            if ((++zr_tris % 8000u) == 0u && zr_dumped < 5) {
                zr_dumped++;
                fprintf(stderr, "[zsrc] TALLY #%d  verts=%u  w<0:%u  ndcz>1:%u  ndcz<-1:%u  screenZ>1:%u  screenZ<0:%u\n",
                        zr_dumped, zr_tot, zr_wneg, zr_ndcGt1, zr_ndcLtm1, zr_szGt1, zr_szLt0);
                fflush(stderr);
            }
        }


        // Indicates the vertex has been used in a tri. Whatever routines modify the vertex afterwards must use a new index instead.

        // Number of triangles actually emitted to faceIndices for this call. CRITICAL: the draw's index
        // range is computed downstream as triangleCount*3 (rt64_state.cpp `faceIndex += triangleCount*3`),
        // NOT faceIndices.size() — so triangleCount MUST equal the real emitted-tri count or EVERY later
        // draw reads a shifted index range (= the "acid trip" global smear). Default 1 (one tri/call).
        int emittedTris = 1;
        for (int i = 0; i < 3; i++) {
            // TODO: Figure out how to handle texcoord tracking on TEXGEN cases.
            const uint32_t globalIndex = globalIndices[i];
            state->rdp->updateCallTexcoords(tcFloats[globalIndex * 2 + 0], tcFloats[globalIndex * 2 + 1]);
            faceIndices.push_back(globalIndices[i]);
            minMatrix = std::min(minMatrix, worldIndices[globalIndex]);
            maxMatrix = std::max(maxMatrix, worldIndices[globalIndex]);
        }

        bool visibleTri = true;
        const bool usesCulling = geometryMode & cullBothMask;
        // Re-fetch posScreen FRESH: the CV64_NEARCLIP injection above may have reallocated drawData vectors,
        // dangling the cached `posScreen` ref. globalIndices are the original verts (valid, unmoved values).
        const auto &posScreenFresh = workload.drawData.posScreen;
        // CV64 cont.20 cull test (THROWAWAY — set CV64_AB_CULL_OFF 0 to restore): disable the CPU N.z
        // backface cull. Paired with GPU cull OFF in rt64_raster_shader.cpp. See note there.
        if (usesCulling) {
            const hlslpp::float3 U = posScreenFresh[globalIndices[1]] - posScreenFresh[globalIndices[0]];
            const hlslpp::float3 V = posScreenFresh[globalIndices[2]] - posScreenFresh[globalIndices[0]];
            const hlslpp::float3 N = hlslpp::cross(V, U);
            visibleTri = (N.z >= 0.0f);
        }

        const FixedRect &scissorRect = state->rdp->scissorRectStack[state->rdp->scissorStackSize - 1];
        if (visibleTri && !scissorRect.isNull()) {
            fbPair.scissorRect.merge(scissorRect);

            FixedRect drawRect;
            for (int i = 0; i < 3; i++) {
                const hlslpp::float3 &v = posScreenFresh[globalIndices[i]];
                drawRect.ulx = std::min(drawRect.ulx, int32_t(v[0] * 4.0f));
                drawRect.uly = std::min(drawRect.uly, int32_t(v[1] * 4.0f));
                drawRect.lrx = std::max(drawRect.lrx, int32_t(hlslpp::ceil(v.x).x * 4.0f));
                drawRect.lry = std::max(drawRect.lry, int32_t(hlslpp::ceil(v.y).x * 4.0f));
            }

            drawRect = scissorRect.intersection(drawRect);
            if (!drawRect.isNull()) {
                fbPair.drawColorRect.merge(drawRect);
                if (otherModeStack[otherModeStackSize - 1].zUpd()) {
                    fbPair.drawDepthRect.merge(drawRect);
                }
            }
        }

        drawCall.triangleCount += emittedTris;   // MUST match faceIndices emitted (see emittedTris note)
    }

    void RSP::drawIndexedTri(uint32_t a, uint32_t b, uint32_t c) {
        drawIndexedTri(a, b, c, false);
    }

    void RSP::setViewportAlign(uint16_t ori, int16_t offx, int16_t offy) {
        extended.global.viewportOrigin = ori;
        extended.global.viewportOffsetX = offx;
        extended.global.viewportOffsetY = offy;
    }

    void RSP::vertexTestZ(uint8_t vtxIndex) {
        extended.drawExtendedType = DrawExtendedType::VertexTestZ;
        extended.drawExtendedData.vertexTestZ.vertexIndex = indices[vtxIndex];
        state->updateDrawStatusAttribute(DrawAttribute::ExtendedType);
        drawIndexedTri(vtxIndex, vtxIndex, vtxIndex, false);
        extended.drawExtendedType = DrawExtendedType::None;
        state->updateDrawStatusAttribute(DrawAttribute::ExtendedType);
    }

    void RSP::endVertexTestZ() {
        uint32_t vtxIndex = extended.drawExtendedData.vertexTestZ.vertexIndex;
        extended.drawExtendedType = DrawExtendedType::EndVertexTestZ;
        state->updateDrawStatusAttribute(DrawAttribute::ExtendedType);
        drawIndexedTri(vtxIndex, vtxIndex, vtxIndex, true);
        extended.drawExtendedType = DrawExtendedType::None;
        state->updateDrawStatusAttribute(DrawAttribute::ExtendedType);
    }

    void RSP::matrixId(uint32_t id, bool push, bool proj, bool decompose, uint8_t pos, uint8_t rot, uint8_t scale, uint8_t skew, uint8_t persp, uint8_t vpos, uint8_t vtc, uint8_t tile, uint8_t lookat, uint8_t order, uint8_t aspect, uint8_t editable, bool idIsAddress, bool editGroup) {
        assert((idIsAddress == editGroup) && "This case is not supported yet.");

        auto setGroupProperties = [=](TransformGroup* dstGroup, bool newGroup) {
            if (newGroup || (dstGroup->editable == G_EX_EDIT_ALLOW)) {
                dstGroup->decompose = decompose;
                dstGroup->positionInterpolation = pos;
                dstGroup->rotationInterpolation = rot;
                dstGroup->scaleInterpolation = scale;
                dstGroup->skewInterpolation = skew;
                dstGroup->perspectiveInterpolation = persp;
                dstGroup->vertexInterpolation = vpos;
                dstGroup->texcoordInterpolation = vtc;
                dstGroup->tileInterpolation = tile;
                dstGroup->lookAtInterpolation = lookat;
                dstGroup->ordering = order;
                dstGroup->aspectMode = aspect;
                dstGroup->editable = editable;
            }
        };

        if (idIsAddress && editGroup) {
            const uint32_t rdramAddress = fromSegmentedMasked(id);
            const int workloadCursor = state->ext.workloadQueue->writeCursor;
            Workload &workload = state->ext.workloadQueue->workloads[workloadCursor];

            auto range = workload.physicalAddressTransformMap.equal_range(rdramAddress);
            for (auto it = range.first; it != range.second; it++) {
                uint32_t matrix_id = it->second;
                if (proj && (matrix_id < workload.drawData.viewProjTransformGroups.size())) {
                    uint32_t groupIndex = workload.drawData.viewProjTransformGroups[matrix_id];
                    setGroupProperties(&workload.drawData.transformGroups[groupIndex], false);
                }
                else if (matrix_id < workload.drawData.worldTransformGroups.size()) {
                    uint32_t groupIndex = workload.drawData.worldTransformGroups[matrix_id];
                    setGroupProperties(&workload.drawData.transformGroups[groupIndex], false);
                }
            }
        }
        else {
            auto &stack = proj ? extended.viewProjMatrixIdStack : extended.modelMatrixIdStack;
            int &stackSize = proj ? extended.viewProjMatrixIdStackSize : extended.modelMatrixIdStackSize;
            bool &stackChanged = proj ? extended.viewProjMatrixIdStackChanged : extended.modelMatrixIdStackChanged;
            if (push) {
                if (size_t(stackSize) < stack.size()) {
                    stackSize++;
                }
                else {
                    assert(false && "Stack is full.");
                }
            }

            const int stackIndex = stackSize - 1;
            TransformGroup* dstGroup = &stack[stackIndex];
            dstGroup->matrixId = id;
            setGroupProperties(dstGroup, true);
            stackChanged = true;
        }
    }

    void RSP::popMatrixId(uint8_t count, bool proj) {
        int &stackSize = proj ? extended.viewProjMatrixIdStackSize : extended.modelMatrixIdStackSize;
        bool &stackChanged = proj ? extended.viewProjMatrixIdStackChanged : extended.modelMatrixIdStackChanged;
        assert((count <= stackSize) && "Pop has requested a larger amount of matrices than the ones present in the stack.");
        while ((count > 0) && (stackSize > 1)) {
            count--;
            stackSize--;
            stackChanged = true;
        }
    }

    void RSP::forceBranch(bool force) {
        extended.forceBranch = force;
    }

    void RSP::clearExtended() {
        extended.drawExtendedType = DrawExtendedType::None;
        extended.drawExtendedData = {};
        extended.viewportOriginStack[0] = G_EX_ORIGIN_NONE;
        extended.global.viewportOrigin = G_EX_ORIGIN_NONE;
        extended.global.viewportOffsetX = 0;
        extended.global.viewportOffsetY = 0;
        extended.modelMatrixIdStack[0] = TransformGroup();
        extended.modelMatrixIdStackSize = 1;
        extended.modelMatrixIdStackChanged = false;
        extended.curModelMatrixIdGroupIndex = 0;
        extended.viewProjMatrixIdStack[0] = TransformGroup();
        extended.viewProjMatrixIdStackSize = 1;
        extended.viewProjMatrixIdStackChanged = false;
        extended.curViewProjMatrixIdGroupIndex = 0;
        extended.viewMatrix = hlslpp::float4x4::identity();
        extended.projMatrix = hlslpp::float4x4::identity();
        extended.viewProjMatrix = hlslpp::float4x4::identity();
        extended.viewProjRotationMatrix = hlslpp::float3x3::identity();
        extended.invViewMatrix = hlslpp::float4x4::identity();
        extended.invProjMatrix = hlslpp::float4x4::identity();
        extended.invViewProjMatrix = hlslpp::float4x4::identity();
        extended.vertexAddresses = {};
        extended.baseSegmentAddresses = {};
        extended.vertexSegmentEnabled = {};
        extended.forceBranch = false;
    }

    void RSP::setGBI(GBI *gbi) {
        currentUCode = gbi->ucode;
        NoN = gbi->flags.NoN;
        cullBothMask = gbi->constants[F3DENUM::G_CULL_BOTH];
        cullFrontMask = gbi->constants[F3DENUM::G_CULL_FRONT];
        projMask = gbi->constants[F3DENUM::G_MTX_PROJECTION];
        loadMask = gbi->constants[F3DENUM::G_MTX_LOAD];
        pushMask = gbi->constants[F3DENUM::G_MTX_PUSH];
        shadingSmoothMask = gbi->constants[F3DENUM::G_SHADING_SMOOTH];
    }

    void RSP::setNoN(bool NoN) {
        if (this->NoN != NoN) {
            state->flush();
            this->NoN = NoN;
        }
    }
};
