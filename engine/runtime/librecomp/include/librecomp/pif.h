// pif.h — PIF (Peripheral InterFace) boot model. The PIF is the console-side SM5 chip that talks to
// the cartridge CIC over a serial bus at power-on and hosts the joybus (controllers). This declares the
// PIF↔CIC boot exchange; the runtime joybus lives in si.cpp.
#pragma once
#include <cstdint>
#include <cstddef>

namespace recomp::pif {

// Run the PIF↔CIC power-on boot exchange (driven by the CIC chip model, librecomp/cic.cpp) and lay down
// the CIC/IPL3-derived boot state the game reads from rdram. rom = the cart image (for CIC identification).
void cic_boot(uint8_t* rdram, const uint8_t* rom, size_t rom_size);

} // namespace recomp::pif
