// fb_present — GPU-free presenter (the "VI") for the software RDP. Scans the N64 color image out of
// RDRAM to a Linux fbdev/DRM display each vsync, replacing RT64 on a framebuffer target. No GPU anywhere.
// On non-Linux this is a stub (RT64 stays the desktop path).
#pragma once
#include <cstdint>

namespace softrdp {
namespace present {

// Open the display (env RECOMP_FB_PRESENT_DEV overrides "/dev/fb0"). Returns false if unavailable.
bool init();
bool available();

// Present ONE frame: scan the N64 color image at `vi_origin` (physical RDRAM byte address) out to the
// display. `rdram` is the host RDRAM base (N64 ^3 byte swizzle). `src_w`/`src_h` = the game's color
// image dimensions in pixels; `siz` = 2 (16-bit RGBA5551) or 3 (32-bit RGBA8888). Nearest-neighbour
// scales the source to the display size. `blank` = present black (VI_STATE_BLACK / width 0).
void present(const uint8_t* rdram, uint32_t vi_origin, uint32_t src_w, uint32_t src_h, uint32_t siz, bool blank);

void shutdown();

// Platform-independent core: scan the N64 color image into a caller-provided ARGB8888 buffer instead of
// a display device. `out` is `out_h` rows of `out_w` pixels, each row `out_stride_px` uint32s wide;
// pixels are 0xFFRRGGBB. Nearest-neighbour scales the source (`src_w`x`src_h`) to `out_w`x`out_h`.
// This is what lets the same softrdp scan-out feed a Wayland/SDL window (compositor path) OR fbdev/DRM.
void present_argb(const uint8_t* rdram, uint32_t vi_origin, uint32_t src_w, uint32_t src_h, uint32_t siz,
                  bool blank, uint32_t* out, uint32_t out_w, uint32_t out_h, uint32_t out_stride_px);

} // namespace present
} // namespace softrdp
