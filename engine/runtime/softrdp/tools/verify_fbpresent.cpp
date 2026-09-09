// verify_fbpresent — mechanical gate for the presenter's decode laws (PLAN_V2 P3: "VERIFY RGBA5551
// byte order vs the ^3 swizzle before anything hits the screen").
//
// Property: for arbitrary RDRAM contents, present_argb() reading the ENGINE convention (host buffer
// where sw[i^3] = plain N64 byte i) must equal an INDEPENDENT decode of the plain N64 bytes:
//   siz=2: pixel at byte a = plain[a]<<8|plain[a+1], RGBA5551 R[15:11] G[10:6] B[5:1], 5->8 replicate
//   siz=3: R=plain[a] G=plain[a+1] B=plain[a+2]
// The law bytes match the PPM dumper judged pixel-perfect by eye (N64PC lle_ppm2, 2026-07-12);
// the replicate expansion ((v<<3)|(v>>2)) is fb_present's — applied identically on both sides here,
// so a byte-order or swizzle defect cannot cancel out.
//
// Build (desktop): cl /nologo /O2 /EHsc /I..\include verify_fbpresent.cpp ..\src\fb_present.cpp
// Build (ARM):      g++ -O2 -I../include -o verify_fbpresent verify_fbpresent.cpp ../src/fb_present.cpp
// Exit 0 + "VERIFY OK" = green. Any mismatch prints the first offending pixel and exits 1.

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

#include "softrdp/fb_present.h"

static const uint32_t RDRAM_SIZE = 0x800000;

// Deterministic bytes (LCG) — same stream every run on every platform.
static uint32_t lcg = 0x2026'0712u;
static uint8_t next_byte() {
    lcg = lcg * 1664525u + 1013904223u;
    return (uint8_t)(lcg >> 24);
}

static inline int rep5(int v5) { return (v5 << 3) | (v5 >> 2); }

// The independent law: decode pixel (x,y) straight from PLAIN N64 bytes.
static uint32_t law_pixel(const uint8_t* plain, uint32_t origin, uint32_t w, uint32_t siz,
                          uint32_t x, uint32_t y) {
    const uint32_t bytespp = (siz == 3) ? 4 : 2;
    uint32_t a = (origin & 0x7FFFFF) + (y * w + x) * bytespp;
    int r, g, b;
    if (siz == 3) {
        r = plain[a]; g = plain[a + 1]; b = plain[a + 2];
    } else {
        uint16_t p = (uint16_t)((plain[a] << 8) | plain[a + 1]);
        r = rep5((p >> 11) & 0x1F); g = rep5((p >> 6) & 0x1F); b = rep5((p >> 1) & 0x1F);
    }
    return 0xFF000000u | ((uint32_t)r << 16) | ((uint32_t)g << 8) | (uint32_t)b;
}

int main() {
    std::vector<uint8_t> plain(RDRAM_SIZE), sw(RDRAM_SIZE);
    for (uint32_t i = 0; i < RDRAM_SIZE; i++) plain[i] = next_byte();
    // The engine convention: host-little-endian u32 words = plain N64 bytes at index^3.
    for (uint32_t i = 0; i < RDRAM_SIZE; i++) sw[i ^ 3] = plain[i];

    struct Case { uint32_t origin, w, h, siz; const char* name; };
    const Case cases[] = {
        { 0x38F800, 320, 240, 2, "sm64-real-fb 320x240x16" },        // SM64's actual framebuffer
        { 0x100000, 640, 480, 2, "640x480x16" },
        { 0x2494F2, 320, 240, 2, "origin%4==2 320x240x16" },        // halfword-aligned, crosses u32 words
        { 0x300000, 320, 240, 3, "320x240x32" },
        { 0x654321 & ~1u, 316, 237, 2, "odd-dims 316x237x16" },
        { 0x8038F800u, 320, 240, 2, "kseg0-origin (mask check)" }, // KSEG0 fb pointer -> & 0x7FFFFF
    };

    uint64_t checked = 0, bad = 0;
    std::vector<uint32_t> out;
    for (const Case& c : cases) {
        // Identity scale: out dims == src dims, so every output pixel maps 1:1 to a source pixel.
        out.assign((size_t)c.w * c.h, 0xDEADBEEFu);
        softrdp::present::present_argb(sw.data(), c.origin, c.w, c.h, c.siz,
                                       /*blank=*/false, out.data(), c.w, c.h, c.w);
        for (uint32_t y = 0; y < c.h && bad < 8; y++) {
            for (uint32_t x = 0; x < c.w; x++) {
                uint32_t want = law_pixel(plain.data(), c.origin, c.w, c.siz, x, y);
                uint32_t got = out[(size_t)y * c.w + x];
                checked++;
                if (got != want) {
                    if (bad < 8)
                        fprintf(stderr, "MISMATCH %s (%u,%u): got %08X want %08X\n",
                                c.name, x, y, got, want);
                    bad++;
                }
            }
        }
        printf("  %-28s %s\n", c.name, bad ? "FAIL" : "ok");
        if (bad) break;
    }

    // Nearest-neighbour scale case (320x240 -> 704x480, the CRT-ish shape): law with sx/sy mapping.
    if (!bad) {
        const Case c = { 0x38F800, 320, 240, 2, "scale 320x240->704x480" };
        const uint32_t ow = 704, oh = 480;
        out.assign((size_t)ow * oh, 0xDEADBEEFu);
        softrdp::present::present_argb(sw.data(), c.origin, c.w, c.h, c.siz,
                                       false, out.data(), ow, oh, ow);
        for (uint32_t fy = 0; fy < oh && bad < 8; fy++) {
            uint32_t sy = (uint32_t)((uint64_t)fy * c.h / oh);
            for (uint32_t fx = 0; fx < ow; fx++) {
                uint32_t sx = (uint32_t)((uint64_t)fx * c.w / ow);
                uint32_t want = law_pixel(plain.data(), c.origin, c.w, c.siz, sx, sy);
                uint32_t got = out[(size_t)fy * ow + fx];
                checked++;
                if (got != want) { if (bad < 8) fprintf(stderr, "MISMATCH scale (%u,%u)\n", fx, fy); bad++; }
            }
        }
        printf("  %-28s %s\n", c.name, bad ? "FAIL" : "ok");
    }

    // Blank must paint OPAQUE black (0xFF000000) — alpha-0 black is a real bug: an
    // alpha-blending consumer no-ops it and shows uninitialized memory (found live on the
    // GPU-less target 2026-07-12; the law is exact now).
    if (!bad) {
        out.assign(320 * 240, 0xDEADBEEFu);
        softrdp::present::present_argb(sw.data(), 0x38F800, 320, 240, 2, /*blank=*/true,
                                       out.data(), 320, 240, 320);
        for (uint32_t i = 0; i < 320 * 240; i++) {
            checked++;
            if (out[i] != 0xFF000000u) { bad++; break; }
        }
        printf("  %-28s %s\n", "blank (opaque)", bad ? "FAIL" : "ok");
    }

    if (bad) {
        fprintf(stderr, "VERIFY FAILED: %llu mismatches of %llu checked\n",
                (unsigned long long)bad, (unsigned long long)checked);
        return 1;
    }
    printf("VERIFY OK: %llu pixels checked, 0 mismatches (RGBA5551 + RGBA8888 vs ^3 swizzle)\n",
           (unsigned long long)checked);
    return 0;
}
