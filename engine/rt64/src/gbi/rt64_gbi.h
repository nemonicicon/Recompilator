//
// RT64
//

#pragma once

#include "hle/rt64_state.h"

#include "rt64_display_list.h"
#include "rt64_f3d.h"

#define UCODE_MAP_SIZE 256

namespace RT64 {
    typedef void (*GBIReset)(State *state);
    typedef void (*GBIFunction)(State *state, DisplayList **dl);

    enum class GBIUCode : uint32_t {
        Unknown = 0,
        RDP,
        F3D,
        F3DGOLDEN,
        F3DPD,
        F3DWAVE,
        F3DDKR,
        F3DDKR98,
        F3DEX,
        F3DEX2,
        F3DZEX2,
        S2DEX,
        S2DEX2,
        L3DEX2,
        Count
    };

    struct GBIFlags {
        bool LowP = false;
        bool NoN = false;
        bool ReJ = false;
        bool computeMVP = false;
        bool pointLighting = false;
        // Vertex-index stride used by the triangle commands. Stock Fast3D packs each index as
        // index * 10 (its DMEM vertex stride), so the handlers divide by 10. SOTE's microcode
        // predates the retail SDK and packs index * 5 -- MEASURED 2026-08-28 from the raw command
        // bytes: (0,5,10) (15,20,25) (30,35,40) (45,50,55) (60,65,70), gcd 5, max 75 = index 15,
        // which matches F3D's 4-bit index field exactly. Dividing those by 10 collapses adjacent
        // indices onto one slot, so 75.8% of its triangles came out DEGENERATE (all three vertices
        // projecting to a single point) and rasterised to nothing -- the game's entire 3D world.
        // Default 10 keeps every other Fast3D title byte-identical.
        uint32_t triIndexDivisor = 10;
        // G_VTX parameter layout. Stock Fast3D puts the destination index in bits 16-19 and
        // (count-1) in bits 20-23. SOTE's pre-SDK microcode puts NOTHING there -- MEASURED
        // 2026-08-28: across 1,800,000 vertex commands bits 16-23 are ALWAYS ZERO, so the stock
        // decode reads every single one as "load 1 vertex into slot 0" and fifteen of the sixteen
        // cache slots are never written. Its real parameters live in the low 16 bits:
        //     bits 0-7   = n * 16 - 1   (the DMA byte length, minus one)
        //     bits 9-15  = v0 + n       (the END index, i.e. F3DEX's (v0+n)*2 convention)
        // Observed w0 0x0400107F / 0x040020FF / 0x0400149F give n = 8 / 16 / 10 and v0 = 0, and
        // n <= 16 matches the 16-entry cache that tri1's 0..15 indices address. Fits every sample.
        bool vtxLengthEncoded = false;
    };

    struct GBIInstance {
        const char *name = "";
        GBIUCode ucode = GBIUCode::Unknown;
        GBIFlags flags;
    };

    struct GBISegment {
        uint32_t hashLength = 0;
        uint64_t hashValue = 0;
        std::vector<const GBIInstance *> instances;

        bool operator<(const GBISegment &other) const {
            return hashLength < other.hashLength;
        }
    };

    struct GBI {
        GBIUCode ucode = GBIUCode::Unknown;
        GBIReset resetFromTask = nullptr;
        GBIReset resetFromLoad = nullptr;
        GBIFunction map[UCODE_MAP_SIZE] = {};
        std::unordered_map<F3DENUM, uint32_t> constants;
        GBIFlags flags;
    };

    struct GBIManager {
        std::array<GBI, static_cast<uint32_t>(GBIUCode::Count)> gbiCache;

        GBIManager();
        ~GBIManager();
        GBI *getGBIForRDP();
        GBI *getGBIForUCode(uint8_t *RDRAM, uint32_t textAddress, uint32_t dataAddress);
        void deduceGBIInformation(uint8_t *RDRAM, uint32_t textAddress, uint32_t dataAddress);
        GBIFunction getExtendedFunction() const;
    };
};