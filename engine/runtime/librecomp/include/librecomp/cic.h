// cic.h — LLE model of the N64 CIC (Checking Integrated Circuit) lock chip.
//
// The CIC is a Sharp SM5 4-bit MCU that sits on the cartridge and talks to the console's PIF over a
// 1-bit serial bus (DCLK/DIO). At boot it emits a region id, an encrypted seed, and an encrypted
// checksum of the cart's IPL3; the PIF verifies them or the console won't boot. The 6105 variant
// (DK64 / Conker / Banjo-Tooie / Majora's Mask / OoT / Perfect Dark / Jet Force) additionally runs a
// continuous challenge/response during operation, and games in that club re-check it as anti-piracy.
//
// This is a faithful behavioral port of the public UltraCIC_C reference (jago85 / Mike Ryan /
// John McMaster / marshallh) — the actual SM5 algorithm, minus the pin-level GPIO (ReadBit/WriteBit),
// which our HLE PIF replaces with direct nibble exchange. Every produced value (seed, checksum,
// InitRam, the 6105 challenge response) is COMPUTED by this model, not hardcoded.
#pragma once
#include <cstdint>
#include <cstddef>

namespace recomp::cic {

enum class CicType {
    Unknown,
    Cic6101,        // 6101 / 7102-NTSC star fox
    Cic6102,        // 6102 / 7101 — the common one
    Cic6103,        // 6103 / 7103
    Cic6105,        // 6105 / 7105 — the anti-piracy "club" (DK64 et al.)
    Cic6106,        // 6106 / 7106
};

// Identify the CIC from the cart's IPL3 bootcode (ROM 0x40..0x1000) by its CRC32. Returns Unknown if
// the bootcode matches no known CIC (e.g. a homebrew/raw cart) — callers should leave CIC behavior off.
CicType detect_from_rom(const uint8_t* rom, size_t size);

// Select which CIC this cart carries. Drives seed/checksum/InitRam and the challenge variant.
void set_type(CicType type);
CicType get_type();

// The seed byte the CIC reports (IPL3 reads it from PIF RAM 0x24/0x25 region on real HW).
uint8_t seed();

// osBootInfo.cicId (RDRAM 0x80000310) for the current CIC — the decimal model number (6105 -> 0x17D9).
// IPL3 derives it from the CIC; the 6105-club anti-piracy reads it (DK64: `if (D_80000310 != 0x17D9)`).
uint16_t boot_cic_id();

// The 6 checksum bytes (12 nibbles) the CIC reports. out must hold 6 bytes (hi nibble first per byte).
void checksum(uint8_t out[6]);

// The CIC's power-on internal RAM (32 nibbles), region-dependent — the seed for compare-mode rounds.
void init_ram(uint8_t mem[32], bool pal);

// The 6105 runtime challenge: the game writes 30 challenge nibbles to PIF RAM, the CIC transforms them
// in place and writes them back (Cic6105Algo). nib holds 30 nibbles (one per byte, low 4 bits).
void challenge_6105(uint8_t nib[30]);

// Not every IPL3 jumps straight to the game. The 6106 bootcode's TAIL XOR-decrypts its own SECOND STAGE
// out of the bootcode into low RDRAM and jumps there, so at game entry that decrypted image is RESIDENT
// in RDRAM — observable state a static recomp that boots past IPL3 would otherwise leave as zeros.
// Decrypts that stage for the CURRENT CIC type into `out` (which must hold kIpl3Stage2MaxWords words),
// reports the RDRAM physical address it lands at in `rdram_base`, and returns the word count; returns 0
// for CIC types whose IPL3 has no such stage (6101/6102/6103/6105), leaving those carts untouched.
inline constexpr size_t kIpl3Stage2MaxWords = 0xB0;
size_t ipl3_stage2(const uint8_t* rom, size_t rom_size, uint32_t* out, uint32_t& rdram_base);

} // namespace recomp::cic
