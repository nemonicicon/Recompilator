// fb_present — GPU-free presenter for the software RDP. See fb_present.h.
//
// Two scan-out paths share one decode core (present_argb, below):
//   • present_argb()  — fills a caller CPU buffer (ARGB8888). Feeds a Wayland/SDL window (the labwc
//                       compositor path a GPU-less target actually uses) OR any other software sink. Portable.
//   • present()       — Linux fbdev: writes /dev/fb0 directly (bare console / future DRM). Linux only.
#include "softrdp/fb_present.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

namespace softrdp {
namespace present {

namespace {
    // Read a 16-bit big-endian halfword from RDRAM at byte address `a`, honoring the N64 ^3 byte swizzle.
    inline uint16_t src16(const uint8_t* rd, uint32_t a) {
        uint32_t i = a & 0x7FFFFF;
        return (uint16_t)(((uint32_t)rd[i ^ 3] << 8) | rd[(i + 1) ^ 3]);
    }
    // Decode one source pixel (siz 2=RGBA5551, 3=RGBA8888) at RDRAM byte address `a` to r/g/b (0..255).
    inline void decode_px(const uint8_t* rdram, uint32_t a, uint32_t siz, int& r, int& g, int& b) {
        if (siz == 3) {
            uint32_t hi = src16(rdram, a), lo = src16(rdram, a + 2);
            uint32_t w = (hi << 16) | lo; // RGBA8888
            r = (w >> 24) & 0xFF; g = (w >> 16) & 0xFF; b = (w >> 8) & 0xFF;
        } else {
            uint16_t p = src16(rdram, a); // RGBA5551: R[15:11] G[10:6] B[5:1] A[0]
            int r5 = (p >> 11) & 0x1F, g5 = (p >> 6) & 0x1F, b5 = (p >> 1) & 0x1F;
            r = (r5 << 3) | (r5 >> 2); g = (g5 << 3) | (g5 >> 2); b = (b5 << 3) | (b5 >> 2);
        }
    }
}

void present_argb(const uint8_t* rdram, uint32_t vi_origin, uint32_t src_w, uint32_t src_h, uint32_t siz,
                  bool blank, uint32_t* out, uint32_t out_w, uint32_t out_h, uint32_t out_stride_px) {
    if (out == nullptr || out_w == 0 || out_h == 0) return;
    if (blank || src_w == 0 || src_h == 0 || rdram == nullptr) {
        // OPAQUE black (0xFF000000), never memset-zero: all-zero ARGB is ALPHA-0, and an
        // alpha-blending consumer (SDL blit) treats it as a no-op — the destination keeps
        // its previous/uninitialized contents. That was a framebuffer target's "arcade pattern"
        // in blank windows (2026-07-12, photographed via kmsgrab: unpainted shm buffers).
        for (uint32_t y = 0; y < out_h; y++) {
            uint32_t* row = out + (size_t)y * out_stride_px;
            for (uint32_t x = 0; x < out_w; x++) row[x] = 0xFF000000u;
        }
        return;
    }
    const uint32_t bytespp = (siz == 3) ? 4 : 2;
    for (uint32_t fy = 0; fy < out_h; fy++) {
        uint32_t sy = (uint32_t)((uint64_t)fy * src_h / out_h);
        const uint32_t row_base = vi_origin + sy * src_w * bytespp;
        uint32_t* dst = out + (size_t)fy * out_stride_px;
        for (uint32_t fx = 0; fx < out_w; fx++) {
            uint32_t sx = (uint32_t)((uint64_t)fx * src_w / out_w);
            int r, g, b;
            decode_px(rdram, row_base + sx * bytespp, siz, r, g, b);
            dst[fx] = 0xFF000000u | ((uint32_t)r << 16) | ((uint32_t)g << 8) | (uint32_t)b;
        }
    }
}

} // namespace present
} // namespace softrdp

#if defined(__linux__)
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <linux/fb.h>

namespace softrdp {
namespace present {

namespace {
    int          g_fd = -1;
    uint8_t*     g_map = nullptr;
    size_t       g_map_len = 0;
    fb_var_screeninfo g_var{};
    fb_fix_screeninfo g_fix{};
    bool         g_ok = false;
    // back buffer we compose into, then copy to the mmap in one shot (less tearing than per-pixel writes)
    uint8_t*     g_back = nullptr;
    size_t       g_back_len = 0;

    // Pack r/g/b (0..255) into the framebuffer's pixel format via its bitfields.
    inline uint32_t fb_pack(int r, int g, int b) {
        uint32_t pr = (uint32_t)(r >> (8 - g_var.red.length))   << g_var.red.offset;
        uint32_t pg = (uint32_t)(g >> (8 - g_var.green.length)) << g_var.green.offset;
        uint32_t pb = (uint32_t)(b >> (8 - g_var.blue.length))  << g_var.blue.offset;
        return pr | pg | pb;
    }
}

bool init() {
    if (g_ok) return true;
    const char* dev = getenv("RECOMP_FB_PRESENT_DEV");
    if (!dev) dev = "/dev/fb0";
    g_fd = open(dev, O_RDWR);
    if (g_fd < 0) { fprintf(stderr, "[fbpresent] open %s failed\n", dev); return false; }
    if (ioctl(g_fd, FBIOGET_VSCREENINFO, &g_var) < 0 || ioctl(g_fd, FBIOGET_FSCREENINFO, &g_fix) < 0) {
        fprintf(stderr, "[fbpresent] FBIOGET_*SCREENINFO failed\n"); close(g_fd); g_fd = -1; return false;
    }
    g_map_len = g_fix.smem_len ? g_fix.smem_len : (size_t)g_fix.line_length * g_var.yres_virtual;
    g_map = (uint8_t*)mmap(nullptr, g_map_len, PROT_READ | PROT_WRITE, MAP_SHARED, g_fd, 0);
    if (g_map == MAP_FAILED) { fprintf(stderr, "[fbpresent] mmap failed\n"); close(g_fd); g_fd = -1; g_map = nullptr; return false; }
    g_back_len = (size_t)g_fix.line_length * g_var.yres;
    g_back = (uint8_t*)malloc(g_back_len);
    g_ok = (g_back != nullptr);
    fprintf(stderr, "[fbpresent] %s %ux%u %ubpp line=%u  R%u@%u G%u@%u B%u@%u  %s\n",
            dev, g_var.xres, g_var.yres, g_var.bits_per_pixel, g_fix.line_length,
            g_var.red.length, g_var.red.offset, g_var.green.length, g_var.green.offset,
            g_var.blue.length, g_var.blue.offset, g_ok ? "OK" : "no-backbuf");
    return g_ok;
}

bool available() { return g_ok; }

void present(const uint8_t* rdram, uint32_t vi_origin, uint32_t src_w, uint32_t src_h, uint32_t siz, bool blank) {
    if (!g_ok) return;
    const uint32_t fw = g_var.xres, fh = g_var.yres, bpp = g_var.bits_per_pixel;
    const uint32_t stride = g_fix.line_length;
    if (blank || src_w == 0 || src_h == 0 || rdram == nullptr) {
        memset(g_back, 0, g_back_len);
        memcpy(g_map, g_back, g_back_len);
        return;
    }
    const uint32_t bytespp = (siz == 3) ? 4 : 2;
    for (uint32_t fy = 0; fy < fh; fy++) {
        uint32_t sy = (uint32_t)((uint64_t)fy * src_h / fh);
        const uint32_t row_base = vi_origin + sy * src_w * bytespp;
        uint8_t* dst = g_back + (size_t)fy * stride;
        for (uint32_t fx = 0; fx < fw; fx++) {
            uint32_t sx = (uint32_t)((uint64_t)fx * src_w / fw);
            int r, g, b;
            decode_px(rdram, row_base + sx * bytespp, siz, r, g, b);
            uint32_t px = fb_pack(r, g, b);
            if (bpp == 16) { *reinterpret_cast<uint16_t*>(dst + fx * 2) = (uint16_t)px; }
            else if (bpp == 32) { *reinterpret_cast<uint32_t*>(dst + fx * 4) = px; }
            else { dst[fx * (bpp / 8)] = (uint8_t)px; }
        }
    }
    memcpy(g_map, g_back, g_back_len);
}

void shutdown() {
    if (g_map && g_map != MAP_FAILED) munmap(g_map, g_map_len);
    if (g_back) free(g_back);
    if (g_fd >= 0) close(g_fd);
    g_map = nullptr; g_back = nullptr; g_fd = -1; g_ok = false;
}

} // namespace present
} // namespace softrdp

#else // ── non-Linux: fbdev stub (RT64 is the desktop presenter). present_argb above stays portable. ──

namespace softrdp {
namespace present {
bool init() { return false; }
bool available() { return false; }
void present(const uint8_t*, uint32_t, uint32_t, uint32_t, uint32_t, bool) {}
void shutdown() {}
} // namespace present
} // namespace softrdp

#endif
