// pif.cpp — PIF↔CIC boot model. Drives the CIC chip model (cic.cpp) through the power-on exchange and
// lays down the CIC/IPL3-derived boot state the game reads.
//
// On real hardware: at power-on the PIF clocks the CIC's region id / encrypted seed / encrypted checksum
// / InitRam out over the serial bus; IPL3 reads the seed+checksum from PIF RAM and verifies the cart's
// bootcode, the 6105's IPL3 runs an RSP routine that leaves a handshake word in RDRAM, and IPL3 writes
// osBootInfo (incl. cicId). Our PIF and IPL3 are HLE'd — the recompiler boots from the game ENTRY past
// IPL3 — so this reproduces the OBSERVABLE RESULTS of that exchange, every value sourced from the CIC
// chip model rather than hardcoded per game.
#include "librecomp/pif.h"
#include "librecomp/cic.h"

namespace recomp::pif {

namespace {
// RDRAM stores each 32-bit word byte-swapped vs. the N64's big-endian view: the byte at N64 physical
// address `a` lives at host offset `a ^ 3`. Write a word in true (big-endian) byte order.
inline void wr8(uint8_t* rdram, uint32_t a, uint8_t v) { rdram[a ^ 3] = v; }
inline void wr32(uint8_t* rdram, uint32_t phys, uint32_t v) {
    wr8(rdram, phys + 0, (uint8_t)(v >> 24));
    wr8(rdram, phys + 1, (uint8_t)(v >> 16));
    wr8(rdram, phys + 2, (uint8_t)(v >> 8));
    wr8(rdram, phys + 3, (uint8_t)(v));
}
} // namespace

void cic_boot(uint8_t* rdram, const uint8_t* rom, size_t rom_size) {
    // 1. The PIF identifies the cart's CIC from its IPL3 bootcode CRC and arms the chip model.
    cic::CicType ct = cic::detect_from_rom(rom, rom_size);
    if (ct != cic::CicType::Unknown) cic::set_type(ct);

    // 2. Clock the CIC's power-on output off the chip model (seed, encrypted checksum, InitRam). On HW
    //    these cross the serial bus and IPL3 verifies the checksum; our HLE IPL3 doesn't re-verify, but
    //    exercising the real model keeps the boot state below model-sourced. (A literal IPL3 run, when
    //    wired, reads exactly these from PIF RAM.)
    uint8_t seed = cic::seed();
    uint8_t cksum[6];   cic::checksum(cksum);
    uint8_t initram[32]; cic::init_ram(initram, /*pal=*/false);
    (void)seed; (void)cksum; (void)initram;

    // 3. osBootInfo.cicId (RDRAM 0x80000310) — what IPL3 leaves from the CIC = the model number (6105
    //    -> 0x17D9). The 6105-club anti-piracy reads it (DK64: `if (D_80000310 != 0x17D9) <degrade>`).
    wr32(rdram, 0x00000310, cic::boot_cic_id());

    // 4. The 6105 IPL3's RSP boot routine leaves a handshake word at RDRAM 0x002FE1C0; the game spins on
    //    it (DK64 dk64_boot_1050.c: `while (0xAD170014 != *(u32*)0xA02FE1C0); *... = 0xF0F0F0F0`). This
    //    IS the "6105 RSP at boot" — reproduce its result for 6105 carts (gated on the model's type).
    if (cic::get_type() == cic::CicType::Cic6105) {
        wr32(rdram, 0x002FE1C0, 0xAD170014u);
    }

    // 5. SP DMEM/IMEM as IPL3 leaves them — the CPU-visible window (phys 0x04000000-0x04001FFF, the RDRAM
    //    mirror recomp_mmio_load_w falls through to). MEASURED 2026-09-04 from the carts' own bootcode:
    //    the 6102 IPL3 (sm64 @A4000734) zero-fills both memories; the 6103 IPL3 (banjokazooie @A400070C)
    //    and the 6106 IPL3's XOR-encrypted second stage (yoshistory, key lo(seed*0x0260BCD5)+1, stage 2
    //    @8000025C) fill BOTH with 0xFFFFFFFF and then write the CIC id word to IMEM[0] (6103 -> 0x17D7,
    //    6106 -> 0x17D8). Games of the 6103/6106 class read this back as a boot-integrity check: Yoshi's
    //    Story records DMEM[0]/IMEM[0] at boot (func_80067284 -> 0x80108628/2C), runs its castManager
    //    initialisation ONLY when DMEM[0] == -1 (func_80051504) and flags IMEM[0] == 0x17D8 (func_80051DBC);
    //    with zeroed SP memory the init is skipped and the game asserts HungUp("castManager.c", 588) at
    //    t = 0.6 s. Gated on the model's detected type; 6101/6102 keep the zero fill; 6105 is unmeasured
    //    here and left zero. (The RSP's own dmem[] in rsp.cpp is untouched — every ucode DMAs its data in.)
    {
        uint32_t fill = 0u;
        bool id_word = false;
        switch (cic::get_type()) {
            case cic::CicType::Cic6103:
            case cic::CicType::Cic6106: fill = 0xFFFFFFFFu; id_word = true; break;
            default: break;
        }
        for (uint32_t off = 0; off < 0x2000u; off += 4) {
            wr32(rdram, 0x04000000u + off, fill);
        }
        if (id_word) {
            wr32(rdram, 0x04001000u, cic::boot_cic_id());
        }
    }

    // 6. LOW RDRAM as IPL3 leaves it. Step 5 reproduces what the 6106 IPL3's second stage DID; this
    //    lays down the second stage ITSELF, which is resident in RDRAM at game entry because the 6106
    //    bootcode tail decrypts it there (bootcode 0x4F0..0x7AC -> RDRAM 0x00000000) and jumps into it.
    //    Booting past IPL3 leaves that window zeroed, and the class checks it: Cruis'n World's boot
    //    self-test (func_802E0A90, one call site off the boot chain) ORs a failure bit per check into
    //    0x803BDE2C and, if ANY bit is set, spins forever at 0x802E0D98 — four of its eleven checks read
    //    RDRAM 0x164/0x1BC/0x234/0x2B8 and compare against words of this image (verified byte-exact on
    //    the cart's own bootcode, 2026-09-05). Same shape as Perfect Dark's boot() guard below.
    //    Gated on the CIC model: types whose IPL3 has no decrypted stage return 0 words and are untouched.
    {
        uint32_t stage2[cic::kIpl3Stage2MaxWords];
        uint32_t base = 0;
        size_t n = cic::ipl3_stage2(rom, rom_size, stage2, base);
        for (size_t i = 0; i < n; ++i) {
            wr32(rdram, base + (uint32_t)(i * 4), stage2[i]);
        }
    }
}

} // namespace recomp::pif
