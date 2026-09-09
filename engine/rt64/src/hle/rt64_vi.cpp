//
// RT64
//

#include <cstring>   // memcmp, for the [vigeom] change detector
#include <algorithm>
#include <cassert>
#include <memory.h>
#include <stdio.h>

#include "common/rt64_common.h"
#include "gbi/rt64_f3d.h"

#include "rt64_vi.h"

namespace RT64 {
    // VI
    
    hlslpp::float4 VI::viewRectangle() const {
        // osViSetXScale/YScale: the game rendered at xScaleFactor of full width into the framebuffer and
        // asked the VI to stretch that sub-region to fill the active area (e.g. Lode Runner 3D renders
        // 320-wide into a 640 fb with osViSetXScale(0.5)). Expand the draw region by 1/factor so the
        // present's expand-viewport + scissor model (VIRenderer::getViewportAndScissor) draws the fb
        // wider and the scissor keeps only the rendered sub-region — stretching it to fill the window.
        // factor == 1.0 (every game that never calls osViSetXScale) => {0,0,1,1} = byte-identical default.
        const float wx = (xScaleFactor > 0.0f) ? (1.0f / xScaleFactor) : 1.0f;
        const float wy = (yScaleFactor > 0.0f) ? (1.0f / yScaleFactor) : 1.0f;
        return { 0.0f, 0.0f, wx, wy };
    }

    hlslpp::float4 VI::cropRectangle() const {
        return { 0.0f, 0.0f, 1.0f, 1.0f };
    }

    float VI::gamma() const {
        const float GammaCorrection = 1.0f / 2.2f;
        return status.gammaEnable ? GammaCorrection : 1.0f;
    }

    bool VI::compatibleWith(const VI &vi) const {
        return
            (width == vi.width) &&
            (hRegion.hStart == vi.hRegion.hStart) &&
            (hRegion.hEnd == vi.hRegion.hEnd) &&
            (vRegion.vStart == vi.vRegion.vStart) &&
            (vRegion.vEnd == vi.vRegion.vEnd) &&
            (xTransform.xScale == vi.xTransform.xScale) &&
            (xTransform.xOffset == vi.xTransform.xOffset) &&
            (yTransform.yScale == vi.yTransform.yScale) &&
            (yTransform.yOffset == vi.yTransform.yOffset);
    }

    bool VI::visible() const {
        return (status.type != VI_STATUS_TYPE_BLANK) && (hRegion.hStart > 0);
    }

    bool VI::operator!=(const VI &rhs) const {
        return
            (status.word != rhs.status.word) ||
            (origin != rhs.origin) ||
            (width != rhs.width) ||
            (intr != rhs.intr) ||
            (vCurrentLine != rhs.vCurrentLine) ||
            (burst.word != rhs.burst.word) ||
            (vSync != rhs.vSync) ||
            (hSync.word != rhs.hSync.word) ||
            (leap.word != rhs.leap.word) ||
            (hRegion.word != rhs.hRegion.word) ||
            (vRegion.word != rhs.vRegion.word) ||
            (vBurst.word != rhs.vBurst.word) ||
            (xTransform.word != rhs.xTransform.word) ||
            (yTransform.word != rhs.yTransform.word);
    }

    uint8_t VI::fbSiz() const {
        switch (status.type) {
        case VI_STATUS_TYPE_16_BIT:
            return G_IM_SIZ_16b;
        case VI_STATUS_TYPE_32_BIT:
            return G_IM_SIZ_32b;
        case VI_STATUS_TYPE_BLANK:
        default:
            return 0;
        }
    }

    uint32_t VI::deinterlacedWidth() const {
        // In interlaced (serrate) modes without deflickering, the VI_WIDTH register holds the DOUBLED
        // stride of the framebuffer; the framebuffer's real row is half of that. Detect that case and
        // return the real per-row width. Shared by fbAddress() and fbSize() so the row-offset estimate
        // and the reported size always agree.
        if (status.serrate) {
            const float estimatedWidth = (hRegion.hEnd - hRegion.hStart) / xScaleFloat();
            const float interlacedTolerance = 1.875f;
            // [vi-halve guard 2026-09-02, Top Gear Rally] osViBlack(1) zeroes the whole packed H_START word
            // (events.cpp VI_STATE_BLACK), so hEnd == hStart == 0 and estimatedWidth reads 0: the interlace
            // heuristic below then halves a 640-wide buffer to 320 and presents a tall left strip. A zero
            // h-region carries no width information; only judge when the region is real.
            const bool halve = (hRegion.hEnd != hRegion.hStart) && (estimatedWidth < (width / interlacedTolerance));
            // [deint] KI Gold 2026-08-29. If this heuristic does NOT trip, we present a
            // 1280-wide image out of a 640-wide buffer -- each output row consuming TWO source
            // rows, which is exactly the scanline striping seen with PresentEarly suppressed.
            // One line per distinct decision, so it cannot flood.
            {
                static uint32_t lastW = 0xFFFFFFFFu; static int lastHalve = -1;
                if (width != lastW || (int)halve != lastHalve) {
                    lastW = width; lastHalve = (int)halve;
                    fprintf(stderr, "[deint] serrate=1 VI_WIDTH=%u estimatedWidth=%.1f "
                                    "threshold=%.1f -> %s (presenting %u wide)\n",
                            width, estimatedWidth, width / interlacedTolerance,
                            halve ? "HALVE" : "KEEP", halve ? width / 2 : width);
                    fflush(stderr);
                }
            }
            if (halve) {
                return width / 2;
            }
        }

        return width;
    }

    uint32_t VI::fbAddress() const {
        uint8_t siz = fbSiz();

        // Estimate the origin is off by one or two rows.
        if (siz >= G_IM_SIZ_16b) {
            // Use the de-interlaced row width: in 480i, VI_WIDTH is the doubled deflicker stride, so
            // computing the row offset from the raw width subtracts TWO real rows instead of one and
            // lands the framebuffer base a row low (DK64 480i: game draws 0x34000 but the recovered
            // origin became 0x33B00 -> a never-drawn buffer is scanned out -> black screen).
            const bool interlacedStep = status.serrate && (vCurrentLine & 0x1);
            const uint32_t rowBytes = deinterlacedWidth() * (1U << (siz - 1));
            const uint32_t rowCount = interlacedStep ? 2 : 1;
            const uint32_t rowOffset = rowBytes * rowCount;
            if (origin >= rowOffset) {
                return origin - rowOffset;
            }
        }

        return origin;
    }

    hlslpp::uint2 VI::fbSize() const {
        // [vigeom] KI Gold 2026-08-29. Report the geometry we actually present in interlaced
        // modes, once per distinct combination. Needed before touching the field handling: the
        // fix differs completely depending on whether the framebuffer holds a FULL 480-line frame
        // (then nothing needs weaving, only correct geometry) or a single 240-line FIELD.
        // [vigeom 2026-09-06, Recompilator step 4] vCurrentLine is NOT part of the change key: it is
        // the line counter, it changes every present, and with it in the key this fired per frame
        // (17,025 of a launcher log's 17,231 lines with no game running). Neither are the origin and
        // the fbAddress: a double-buffered game alternates them EVERY present (measured: two values,
        // 893 prints each, in 30 s of the launcher). Both are still printed at each geometry change;
        // per-present origin tracing is [rawvi]'s job (events.cpp).
        struct _G { uint32_t w,h,serr,vs,ve; };
        static _G _last = {};
        // In interlaced without deflickering, the stride of the framebuffer is usually double of
        // what its actual row size is. deinterlacedWidth() detects that case and returns half the width.
        hlslpp::uint2 size = { deinterlacedWidth(), 0 };

        // We can make a close estimate of the height the framebuffer will use by using the width
        // that was just fixed to eliminate interlacing.
        size.y = lround(float(vRegion.vEnd - vRegion.vStart) / (2.0f * yScaleFloat() * (float(size.x) / float(width))));

        if ((size.x > 0) && (size.y > 0)) {
            // Most of the time, the height is missing a few rows because the framebuffer is offset
            // at the origin and an extra row is left at the end to account for filtering.
            // We add two extra rows to whatever result we get and try to get the closest clean
            // multiplier of the specified Division factor.
            const uint32_t ExtraRows = 2;
            const uint32_t Divisor = 4;
            size.y += ExtraRows;
            size.y = lround(float(size.y) / Divisor) * Divisor;
            {
                _G g = { size.x, size.y, (uint32_t)status.serrate,
                         (uint32_t)vRegion.vStart, (uint32_t)vRegion.vEnd };
                // [vigeom 2026-09-05, Rage Wars #152] the visibility inputs too: visible() is
                // (type != BLANK) && (hStart > 0), and a raw-VI kernel can hand RT64 a snapshot whose
                // H_START is the blanking zero. Change-detected on these fields as well.
                static uint32_t _lastStatus = 0xFFFFFFFFu, _lastHRegion = 0xFFFFFFFFu;
                const bool visInputsChanged = (status.word != _lastStatus) || (hRegion.word != _lastHRegion);
                if (memcmp(&g, &_last, sizeof(g)) != 0 || visInputsChanged) {
                    _last = g;
                    _lastStatus = status.word;
                    _lastHRegion = hRegion.word;
                    fprintf(stderr, "[vigeom] serrate=%u present %ux%u origin=0x%08X -> fbAddress=0x%08X\n"
                                    "[vigeom]   VI_WIDTH=%u deinterlaced=%u vStart=%u vEnd=%u vCurrentLine=%u\n"
                                    "[vigeom]   VI_CONTROL=0x%08X type=%u hStart=%u hEnd=%u xScale=0x%03X yScale=0x%03X visible=%d\n",
                            g.serr, g.w, g.h, origin, fbAddress(), width, deinterlacedWidth(), g.vs, g.ve, (uint32_t)vCurrentLine,
                            status.word, (unsigned)status.type, (unsigned)hRegion.hStart, (unsigned)hRegion.hEnd,
                            (unsigned)xTransform.xScale, (unsigned)yTransform.yScale, visible() ? 1 : 0);
                    fflush(stderr);
                }
            }
            return size;
        } else {
            return hlslpp::uint2(0, 0);
        }
    }

    float VI::xScaleFloat() const {
        return (1024.0f / xTransform.xScale);
    }

    float VI::xOffsetFloat() const {
        return xTransform.xOffset / 1024.0f;
    }

    float VI::yScaleFloat() const {
        return (1024.0f / yTransform.yScale);
    }

    float VI::yOffsetFloat() const {
        return yTransform.yOffset / 1024.0f;
    }

    // VIHistory

    VIHistory::VIHistory() {
        historyCursor = 0;
        factorCursor = 0;
        history.fill({});
        factors.fill(0);
    }

    void VIHistory::pushVI(const VI &vi, uint32_t fbWidth) {
        historyCursor = (historyCursor + 1) % history.size();
        Present &entry = history[historyCursor];
        entry.vi = vi;
        entry.fbWidth = fbWidth;
    }

    void VIHistory::pushFactor(uint32_t factor) {
        factorCursor = (factorCursor + 1) % factors.size();
        factors[factorCursor] = factor;
    }

    uint32_t VIHistory::logicalRateFromFactors() {
        if ((factors[0] != 0) && std::all_of(factors.begin(), factors.end(), [&](uint32_t factor) { return factor == factors[0]; })) {
            const uint32_t FullRate = 60; // TODO: PAL support.
            return FullRate / factors[0];
        }
        else {
            return 0;
        }
    }

    const VIHistory::Present &VIHistory::top() const {
        return history[historyCursor];
    }
};