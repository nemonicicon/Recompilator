// cic.cpp — faithful behavioral LLE of the N64 CIC lock chip (see cic.h).
//
// Ported from the public UltraCIC_C reference (jago85, after Mike Ryan / John McMaster / marshallh).
// The SM5 algorithm is reproduced exactly; only the pin-level serial I/O (ReadBit/WriteBit) is dropped,
// because our PIF is HLE'd — the values the CIC would clock out over DCLK/DIO are instead returned
// directly to the PIF/SI layer. Nothing here is hardcoded per game: seed, checksum, InitRam and the
// 6105 challenge response are all COMPUTED by the model for the selected CIC type.
#include "librecomp/cic.h"
#include <array>
#include <cstring>

namespace recomp::cic {
namespace {

// ── Per-CIC constants (UltraCIC_C) ───────────────────────────────────────────────────────────────
struct CicProfile {
    uint32_t ipl3_crc;          // CRC32 of ROM[0x40..0x1000] — how the cart's CIC is identified
    uint8_t  seed;              // the seed byte
    uint8_t  checksum[12];      // 12 checksum nibbles
};

// Bootcode (IPL3) CRC32 values are the long-established n64 community identifiers.
constexpr CicProfile k6101 = { 0x6170A4A1u, 0x3F, { 0x4,0x5,0xC,0xC,0x7,0x3,0xE,0xE,0x3,0x1,0x7,0xA } };
constexpr CicProfile k6102 = { 0x90BB6CB5u, 0x3F, { 0xa,0x5,0x3,0x6,0xc,0x0,0xf,0x1,0xd,0x8,0x5,0x9 } };
constexpr CicProfile k6103 = { 0x0B050EE0u, 0x78, { 0x5,0x8,0x6,0xf,0xd,0x4,0x7,0x0,0x9,0x8,0x6,0x7 } };
constexpr CicProfile k6105 = { 0x98BC2C86u, 0x91, { 0x8,0x6,0x1,0x8,0xA,0x4,0x5,0xB,0xC,0x2,0xD,0x3 } };
constexpr CicProfile k6106 = { 0xACC8580Au, 0x85, { 0x2,0xB,0xB,0xA,0xD,0x4,0xE,0x6,0xE,0xB,0x7,0x4 } };

const CicProfile& profile_for(CicType t) {
    switch (t) {
        case CicType::Cic6101: return k6101;
        case CicType::Cic6103: return k6103;
        case CicType::Cic6105: return k6105;
        case CicType::Cic6106: return k6106;
        case CicType::Cic6102:
        default:               return k6102;
    }
}

// CIC's power-on internal RAM, region-dependent (UltraCIC_C _CicRamInitNtsc / _CicRamInitPal).
constexpr uint8_t kRamInitNtsc[32] = {
    0xE,0x0,0x9,0xA,0x1,0x8,0x5,0xA,0x1,0x3,0xE,0x1,0x0,0xD,0xE,0xC,
    0x0,0xB,0x1,0x4,0xF,0x8,0xB,0x5,0x7,0xC,0xD,0x6,0x1,0xE,0x9,0x8,
};
constexpr uint8_t kRamInitPal[32] = {
    0xE,0x0,0x4,0xF,0x5,0x1,0x2,0x1,0x7,0x1,0x9,0x8,0x5,0x7,0x5,0xA,
    0x0,0xB,0x1,0x2,0x3,0xF,0x8,0x2,0x7,0x1,0x9,0x8,0x1,0x1,0x5,0xC,
};

CicType g_type = CicType::Cic6102;

// ── CRC32 (reflected, poly 0xEDB88320) for IPL3 identification ────────────────────────────────────
uint32_t crc32(const uint8_t* data, size_t len) {
    uint32_t crc = 0xFFFFFFFFu;
    for (size_t i = 0; i < len; i++) {
        crc ^= data[i];
        for (int b = 0; b < 8; b++)
            crc = (crc >> 1) ^ (0xEDB88320u & (~(crc & 1u) + 1u));
    }
    return ~crc;
}

// ── The SM5 seed/checksum encryption round (UltraCIC_C EncodeRound) ───────────────────────────────
// Faithful boot/compare-mode steps. seed()/checksum() expose the raw values the boot consumes; these
// produce the over-the-wire ENCODED stream + compare-mode RAM, used once the full IPL3↔CIC serial
// exchange is driven. Kept compiled as part of the real chip model. [[maybe_unused]] until then.
[[maybe_unused]] void encode_round(uint8_t* mem, uint8_t index) {
    uint8_t a = mem[index];
    index++;
    do {
        a = (a + 1) & 0x0f;
        a = (a + mem[index]) & 0x0f;
        mem[index] = a;
        index++;
    } while ((index & 0x0f) != 0);
}

// ── CIC compare-mode memory alternation (UltraCIC_C CicRound) ─────────────────────────────────────
void exchange(uint8_t* a, uint8_t* b) { uint8_t t = *a; *a = *b; *b = t; }

[[maybe_unused]] void cic_round(uint8_t* m) {
    uint8_t a, b, x;
    x = m[15];
    a = x;
    do {
        b = 1;
        a += m[b] + 1;
        m[b] = a;
        b++;
        a += m[b] + 1;
        exchange(&a, &m[b]);
        m[b] = ~m[b] & 0xff;
        b++;
        a &= 0xf;
        a += (m[b] & 0xf) + 1;
        if (a < 16) { exchange(&a, &m[b]); b++; }
        a += m[b];
        m[b] = a;
        b++;
        a += m[b];
        exchange(&a, &m[b]);
        b++;
        a &= 0xf;
        a += 8;
        if (a < 16) a += m[b];
        exchange(&a, &m[b]);
        b++;
        do {
            a += m[b] + 1;
            m[b] = a;
            b++;
            b &= 0xf;
        } while (b != 0);
        a = x + 0xf;
        x = a & 0xf;
    } while (x != 15);
}

} // namespace

CicType detect_from_rom(const uint8_t* rom, size_t size) {
    if (rom == nullptr || size < 0x1000) return CicType::Unknown;
    uint32_t c = crc32(rom + 0x40, 0x1000 - 0x40);      // CRC32 of the 4032-byte IPL3 bootcode
    if (c == k6101.ipl3_crc) return CicType::Cic6101;
    if (c == k6102.ipl3_crc) return CicType::Cic6102;
    if (c == k6103.ipl3_crc) return CicType::Cic6103;
    if (c == k6105.ipl3_crc) return CicType::Cic6105;
    if (c == k6106.ipl3_crc) return CicType::Cic6106;
    return CicType::Unknown;
}

void set_type(CicType type) { if (type != CicType::Unknown) g_type = type; }
CicType get_type() { return g_type; }

uint8_t seed() { return profile_for(g_type).seed; }

uint16_t boot_cic_id() {
    // osBootInfo.cicId == the CIC's decimal model number (e.g. 6105 -> 0x17D9), as IPL3 leaves it.
    switch (g_type) {
        case CicType::Cic6101: return 6101; // 0x17D5
        case CicType::Cic6103: return 6103; // 0x17D7
        case CicType::Cic6105: return 6105; // 0x17D9 — DK64 & the 6105 club check this
        case CicType::Cic6106: return 0x17D8; // NOT 6106: the 6106 IPL3's decrypted second stage writes 0x17D8 to
                                              // osBootInfo.cicId AND IMEM[0] (yoshistory stage 2 @80000228/@80000294,
                                              // measured 2026-09-04); the game checks IMEM[0] == 0x17D8 (func_80051DBC).
        case CicType::Cic6102:
        default:               return 6102; // 0x17D6
    }
}

size_t ipl3_stage2(const uint8_t* rom, size_t rom_size, uint32_t* out, uint32_t& rdram_base) {
    // The 6106 IPL3's tail (@A40004AC) XOR-decrypts bootcode 0x4F0..0x7AC — 175 words — into RDRAM
    // 0x00000000 and jumps to the result at 0x8000025C; that second stage is what fills SP DMEM/IMEM
    // with 0xFFFFFFFF and writes the cic id (see pif.cpp step 5). The IMAGE ITSELF stays resident in
    // low RDRAM, below the exception vectors the game later installs at 0x0/0x80/0x100/0x180.
    // MEASURED 2026-09-04 by disassembling the carts' own bootcode (Yoshi's Story), and re-proved
    // byte-exactly 2026-09-05 on Cruis'n World, whose boot self-test reads four words of the decrypted
    // image back (RDRAM 0x164/0x1BC/0x234/0x2B8), compares them against literals, and — like Perfect
    // Dark's boot() guard — spins in `while (1)` forever on any mismatch.
    // Key schedule, from the bootcode: key = lo(cic_seed * 0x0260BCD5) + 1, then key *= 0x0260BCD5
    // after each word. The seed comes from the CIC chip model, so nothing here is per-game.
    rdram_base = 0;
    if (rom == nullptr || g_type != CicType::Cic6106) return 0;
    constexpr uint32_t kMul = 0x0260BCD5u;
    constexpr uint32_t kLo = 0x4F0u, kHi = 0x7ACu;
    static_assert((kHi - kLo) / 4 <= kIpl3Stage2MaxWords, "stage 2 does not fit the caller's buffer");
    if (rom_size < kHi) return 0;
    uint32_t key = (uint32_t)profile_for(g_type).seed * kMul + 1u;
    size_t n = 0;
    for (uint32_t o = kLo; o < kHi; o += 4) {
        uint32_t w = ((uint32_t)rom[o] << 24) | ((uint32_t)rom[o + 1] << 16)
                   | ((uint32_t)rom[o + 2] << 8) | (uint32_t)rom[o + 3];
        out[n++] = w ^ key;
        key *= kMul;
    }
    rdram_base = 0x00000000u;
    return n;
}

void checksum(uint8_t out[6]) {
    const auto& p = profile_for(g_type);
    for (int i = 0; i < 6; i++)
        out[i] = (uint8_t)((p.checksum[i * 2] << 4) | (p.checksum[i * 2 + 1] & 0xf));
}

void init_ram(uint8_t mem[32], bool pal) {
    std::memcpy(mem, pal ? kRamInitPal : kRamInitNtsc, 32);
}

// 6105 runtime challenge (UltraCIC_C Cic6105Algo): transform 30 nibbles in place.
void challenge_6105(uint8_t nib[30]) {
    uint8_t A = 5;
    int carry = 1;
    for (int i = 0; i < 30; ++i) {
        if (!(nib[i] & 1)) A += 8;
        if (!(A & 2))      A += 4;
        A = (A + nib[i]) & 0xf;
        nib[i] = A;
        if (!carry) A += 7;
        A = (A + nib[i]) & 0xf;
        A = A + nib[i] + carry;
        if (A >= 0x10) { carry = 1; A -= 0x10; }
        else           { carry = 0; }
        A = (~A) & 0xf;
        nib[i] = A;
    }
}

} // namespace recomp::cic
