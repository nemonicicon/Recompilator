//
// RT64
//
// Optional, opt-in relaxation of the VI<->color-image strict width-equality
// predicates used during presentation. Some titles (e.g. Donkey Kong 64's
// intro) render a color image whose width is an integer MULTIPLE of the VI's
// reported framebuffer width (a 640-wide image presented through a 320-wide
// VI). The baseline strict "colorImg.width == fbSize.x" match rejects those,
// so RT64 falls back to a raw RDRAM reinterpretation that collapses the wide
// image vertically.
//
// DEFAULT ON (generalization worklist #7, 2026-07-01): the relaxation is strictly WIDENING —
// exact-equality matches behave identically, it only additionally accepts the integer-multiple
// case that hardware presents fine and the strict predicate wrongly rejected. Set
// RT64_WIDTH_RELAX=0 to restore the old strict-equality behavior.
//

#pragma once

#include <cstdint>
#include <cstdlib>
#include <cstring>

namespace RT64 {
    // Default ON; RT64_WIDTH_RELAX=0 opts back into strict equality. Cached on first use so this
    // stays cheap to call from hot present-path predicates.
    inline bool widthRelaxEnabled() {
        static const bool enabled = [] {
            const char* v = std::getenv("RT64_WIDTH_RELAX");
            return !(v != nullptr && std::strcmp(v, "0") == 0);
        }();
        return enabled;
    }

    // Width-match predicate shared by the presentation predicates.
    //
    // Baseline (flag unset): exact equality, identical to the previous
    // "imgWidth == viWidth" check.
    //
    // Relaxed (flag set): additionally accepts the color image being wider than
    // the VI window by an exact integer multiple (imgWidth % viWidth == 0 and
    // imgWidth > viWidth). The base address and pixel size are checked
    // separately by the caller, so this only loosens the width dimension.
    inline bool widthMatchesRelaxed(uint32_t imgWidth, uint32_t viWidth) {
        if (imgWidth == viWidth) {
            return true;
        }

        if (widthRelaxEnabled() && (viWidth > 0) && (imgWidth > viWidth) && ((imgWidth % viWidth) == 0)) {
            return true;
        }

        return false;
    }
};
