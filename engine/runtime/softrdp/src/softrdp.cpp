// softrdp — Milestone A software RDP. Faithful-semantics-first; NEON/speed later.
// References: the RDP command formats and pipeline semantics per the public N64 documentation
// (triangle edge/attribute coefficient layout, combiner mux tables, blender mux, TMEM line
// interleave, N64 14-bit Z encoding). Known Milestone-A gaps (deliberate): coverage/AA, dither,
// LOD per-pixel (lod_frac = 0xFF), key/convert, copy-mode multi-texel nuances.

#include "softrdp/softrdp.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <algorithm>
#include <mutex>
#include <chrono>
#include <thread>
#include <condition_variable>
#ifdef _WIN32
#include <direct.h>
#endif
// SSE2 span vectorization (P2 Task 1). Native on x86; mapped to NEON on ARM via sse2neon,
// the same shim the recompiled RSP uses. softrdp/CMakeLists.txt adds the sse2neon include dir.
#if defined(__x86_64__) || defined(_M_X64) || defined(__i386__) || defined(_M_IX86)
#include <emmintrin.h>
#else
#include "sse2neon.h"
#endif

namespace softrdp {

static constexpr uint32_t RDRAM_MASK = 0x7FFFFF; // 8 MB

// ── RDRAM access (N64 byte order: ^3, like the rest of the engine) ─────────────────────────────
static uint8_t* g_rdram = nullptr;
// Shadow copy of every byte softrdp writes (same ^3 indexing). During bring-up another renderer
// (RT64's HLE writeback) shares the RDRAM color image, so the real buffer can't attribute pixels;
// the shadow dump shows ONLY softrdp's own output. Seen-mask resets each SyncFull.
static uint8_t* g_shadow = nullptr;
static uint8_t* g_shadow_seen = nullptr;

// ── Profiler (env RECOMP_SOFT_RDP_PROF=1): fill rate = the number that decides where to optimize ──
static int      g_prof = -1;        // -1 uninit; set from env on first process_commands
static uint64_t g_prof_pixels = 0;  // pixels that passed scissor (entered the per-pixel pipeline)
static uint64_t g_prof_tex = 0;     // of those, textured (gauges the perspective-divide/texel cost share)
static uint64_t g_prof_ns = 0;      // ns spent inside process_commands (raster wall time)
static uint64_t g_prof_fmt[64] = {};// census: texels fetched per (fmt<<3|siz) — where to focus the texel path
static uint64_t g_prof_bilerp = 0, g_prof_point = 0;
static int      g_notex = -1;       // RECOMP_SOFT_RDP_NOTEX=1: skip texel fetch (timing A/B — isolates fetch cost)
static int      g_nodiv = -1;       // RECOMP_SOFT_RDP_NODIV=1: skip perspective divide (isolates divide cost)
static int      g_noraster = -1;    // RECOMP_SOFT_RDP_NORASTER=1: skip triangle raster (measures the LLE+logic ceiling)
static int      g_nofb = -1;        // RECOMP_SOFT_RDP_NOFB=1: skip the framebuffer+Z memory RMW (keeps all compute) — isolates the MEMORY-bandwidth cost vs compute (the tile-render decision)
static int      g_cmbchk = -1;      // RECOMP_SOFT_RDP_CMBCHK=1: run the reference combiner/blender in lockstep, log any divergence (in-game pixel-exact gate)
static uint64_t g_cmbchk_bad = 0;
static int      g_oldcmb = -1;      // RECOMP_SOFT_RDP_OLDCMB=1: render via the OLD switch-dispatch combiner/blender (same-build A/B for the vectorization speedup)
static inline uint8_t rd8(uint32_t a) { return g_rdram[(a & RDRAM_MASK) ^ 3]; }
static inline void wr8(uint32_t a, uint8_t v) {
    uint32_t i = (a & RDRAM_MASK) ^ 3;
    g_rdram[i] = v;
    if (g_shadow) { g_shadow[i] = v; g_shadow_seen[i] = 1; }
}
// 16-bit RDRAM access — the framebuffer/Z read-modify-write is the profiler's memory-bound raster cost.
// For an ALIGNED (even) address the two `^3` bytes are adjacent (indices (a^2) and (a^2)+1 with the low
// byte first), so the whole 16-bit value is one aligned little-endian access at (a^2) instead of 2 byte
// reads/writes + shifts + XORs. Byte-identical to the 2-byte path (proven: 40M-addr desktop fuzz). memcpy
// = the portable single-load/store (no alignment/aliasing UB; compilers fold it). Odd addrs keep the path.
static inline uint16_t rd16(uint32_t a) {
    if ((a & 1) == 0) { uint16_t v; memcpy(&v, &g_rdram[(a & RDRAM_MASK) ^ 2], 2); return v; }
    return (uint16_t)((rd8(a) << 8) | rd8(a + 1));
}
static inline void wr16(uint32_t a, uint16_t v) {
    if ((a & 1) == 0) {
        uint32_t i = (a & RDRAM_MASK) ^ 2;
        memcpy(&g_rdram[i], &v, 2);
        if (g_shadow) { memcpy(&g_shadow[i], &v, 2); g_shadow_seen[i] = 1; g_shadow_seen[i + 1] = 1; }
        return;
    }
    wr8(a, (uint8_t)(v >> 8)); wr8(a + 1, (uint8_t)v);
}
static inline uint32_t rd32(uint32_t a) { return ((uint32_t)rd16(a) << 16) | rd16(a + 2); }
static inline void wr32(uint32_t a, uint32_t v) { wr16(a, (uint16_t)(v >> 16)); wr16(a + 2, (uint16_t)v); }

// ── Color helpers ───────────────────────────────────────────────────────────────────────────────
struct Col { int32_t r, g, b, a; }; // 0..255 lanes (a used 0..255)

static inline Col col_from_rgba32(uint32_t w) {
    return { (int32_t)((w >> 24) & 0xFF), (int32_t)((w >> 16) & 0xFF), (int32_t)((w >> 8) & 0xFF), (int32_t)(w & 0xFF) };
}
static inline uint16_t pack_5551(int r, int g, int b, int a1) {
    r = std::clamp(r, 0, 255) >> 3; g = std::clamp(g, 0, 255) >> 3; b = std::clamp(b, 0, 255) >> 3;
    return (uint16_t)((r << 11) | (g << 6) | (b << 1) | (a1 ? 1 : 0));
}
static inline Col unpack_5551(uint16_t p) {
    int r = (p >> 11) & 0x1F, g = (p >> 6) & 0x1F, b = (p >> 1) & 0x1F;
    return { (r << 3) | (r >> 2), (g << 3) | (g >> 2), (b << 3) | (b >> 2), (p & 1) ? 255 : 0 };
}

// ── RDP state ───────────────────────────────────────────────────────────────────────────────────
struct Tile {
    uint8_t fmt = 0, siz = 0;      // format/pixel size
    uint16_t line = 0;             // TMEM words (8B) per row
    uint16_t tmem = 0;             // TMEM word address (8B units)
    uint8_t palette = 0;
    uint8_t cmt = 0, cms = 0;      // clamp/mirror bits (bit1=clamp, bit0=mirror)
    uint8_t maskt = 0, masks = 0;
    uint8_t shiftt = 0, shifts = 0;
    // tile size (10.2 fixed)
    uint16_t sl = 0, tl = 0, sh = 0, th = 0;
};

struct State {
    // images
    uint32_t ci_addr = 0; uint8_t ci_fmt = 0, ci_siz = 2; uint32_t ci_width = 320;
    uint32_t zi_addr = 0;
    uint32_t ti_addr = 0; uint8_t ti_fmt = 0, ti_siz = 2; uint32_t ti_width = 0;
    // scissor (10.2)
    uint32_t sc_xh = 0, sc_yh = 0, sc_xl = 0, sc_yl = 0;
    // other modes
    uint64_t othermode = 0;
    // colors
    uint32_t fill_color = 0;
    Col fog_color{ 0,0,0,0 }, blend_color{ 0,0,0,0 }, prim_color{ 255,255,255,255 }, env_color{ 255,255,255,255 };
    uint8_t prim_lod_frac = 0;
    // combine mux
    uint32_t cmb_hi = 0, cmb_lo = 0;
    Tile tiles[8];
    uint8_t tmem[4096] = {};
    // stats
    uint64_t tri_count = 0, rect_count = 0, fill_count = 0, frame_count = 0;
};
// State is thread_local so each banding worker holds its own full RDP context + TMEM (it replays every
// command into its own S, but only rasterizes its interleaved scanlines). N=1 = the single-thread default.
thread_local State S;
thread_local int g_worker_idx = 0, g_worker_n = 1;   // this worker rasterizes scanlines where y % n == idx
thread_local bool g_saw_syncfull = false;            // set by worker 0 on SyncFull; frame-end runs after the barrier
static std::mutex g_mtx;
static int g_nthreads = -1;                           // RECOMP_SOFT_RDP_THREADS (1 = single-threaded)

// othermode field accessors (bit positions per the RDP SetOtherModes layout; word = hi<<32|lo)
static inline uint32_t om_cycle_type() { return (uint32_t)((S.othermode >> 52) & 3); } // 0=1cyc 1=2cyc 2=copy 3=fill
static inline bool om_persp_en()      { return (S.othermode >> 51) & 1; }
static inline bool om_bilerp0()       { return ((S.othermode >> 45) & 1) != 0; }      // TEXTFILT hi bit (44-45): set for BILERP(2)/AVERAGE(3), clear for POINT(0). Was `>>45 & 2` = bit46 = TLUT-IA (off-by-one → bilerp never engaged → blocky).
static inline bool om_tlut_en()       { return (S.othermode >> 47) & 1; }
static inline bool om_tlut_ia()       { return (S.othermode >> 46) & 1; }
static inline bool om_z_cmp()         { return (S.othermode >> 4) & 1; }
static inline bool om_z_upd()         { return (S.othermode >> 5) & 1; }
static inline bool om_alpha_cmp()     { return (S.othermode >> 0) & 1; }
static inline bool om_force_blend()   { return (S.othermode >> 14) & 1; }
static inline uint32_t om_zmode()     { return (uint32_t)((S.othermode >> 10) & 3); }

// Span-constant othermode flags, hoisted ONCE per primitive (like compile_combiner) so the per-pixel
// path (shade_pixel/sample_tile/fetch_texel) stops re-reading S.othermode + re-extracting ~10 bitfields
// EVERY pixel (om_tlut_ia is hit per TEXEL = 4×/pixel). Pixel-exact: identical values, evaluated once,
// then threaded by const& and held in registers. This is the plan's fix-order #2 (hoist the span-constant
// om_* flags out of the per-pixel loop) — the combiner/blender were already hoisted; these weren't.
struct OMConst {
    uint32_t cycle_type;   // 0=1cyc 1=2cyc 2=copy 3=fill
    uint32_t zmode;        // 0..3 (opaque/interpenetrate/xlu/decal)
    bool persp_en, bilerp, tlut_ia, z_cmp, z_upd, alpha_cmp;
};
static inline OMConst compile_om() {
    return OMConst{ om_cycle_type(), om_zmode(),
                    om_persp_en(), om_bilerp0(), om_tlut_ia(), om_z_cmp(), om_z_upd(), om_alpha_cmp() };
}

static inline uint32_t om_bl_m1a(int c) { return (uint32_t)((S.othermode >> (c ? 28 : 30)) & 3); }
static inline uint32_t om_bl_m1b(int c) { return (uint32_t)((S.othermode >> (c ? 24 : 26)) & 3); }
static inline uint32_t om_bl_m2a(int c) { return (uint32_t)((S.othermode >> (c ? 20 : 22)) & 3); }
static inline uint32_t om_bl_m2b(int c) { return (uint32_t)((S.othermode >> (c ? 16 : 18)) & 3); }

// ── N64 Z-buffer 14-bit format (3-bit exponent + 11-bit mantissa; stored <<2 with dz) ──────────
static inline uint16_t z_encode(uint32_t z18) { // z18 = 18-bit integer z (0..0x3FFFF)
    static const struct { uint32_t shift, add; } zf[8] = {
        {6, 0x00000}, {5, 0x20000}, {4, 0x30000}, {3, 0x38000},
        {2, 0x3C000}, {1, 0x3E000}, {0, 0x3F000}, {0, 0x3F800},
    };
    int exp = 0;
    uint32_t x = z18;
    // priority-encode leading ones (per hardware table)
    if      (x < 0x20000) exp = 0;
    else if (x < 0x30000) exp = 1;
    else if (x < 0x38000) exp = 2;
    else if (x < 0x3C000) exp = 3;
    else if (x < 0x3E000) exp = 4;
    else if (x < 0x3F000) exp = 5;
    else if (x < 0x3F800) exp = 6;
    else                  exp = 7;
    uint32_t mant = (x - zf[exp].add) >> zf[exp].shift;
    return (uint16_t)(((uint32_t)exp << 11) | (mant & 0x7FF));
}
static inline uint32_t z_decode(uint16_t zmem14) {
    static const struct { uint32_t shift, add; } zf[8] = {
        {6, 0x00000}, {5, 0x20000}, {4, 0x30000}, {3, 0x38000},
        {2, 0x3C000}, {1, 0x3E000}, {0, 0x3F000}, {0, 0x3F800},
    };
    uint32_t exp = (zmem14 >> 11) & 7, mant = zmem14 & 0x7FF;
    return (mant << zf[exp].shift) + zf[exp].add;
}

// ── TMEM texel fetch ────────────────────────────────────────────────────────────────────────────
// TMEM rows are 8-byte words; ODD rows store their two 32-bit halves swapped (the hardware
// interleave). tmem_off is a BYTE offset; line_parity = (t & 1).
static inline uint32_t tmem_addr_swz(uint32_t byte_off, int odd_line) {
    return odd_line ? (byte_off ^ 4) : byte_off;
}

static inline int wrap_coord(int c, int mask, int mirror, int clamp_bit, int lo, int hi) {
    // lo/hi in texel units (tile size); mask in bits.
    if (clamp_bit || mask == 0) {
        c = std::clamp(c, 0, hi - lo);
    }
    if (mask > 0) {
        int m = (1 << mask);
        if (mirror && (c & m)) c = (m - 1) - (c & (m - 1));
        else c &= (m - 1);
    }
    return c;
}

static Col fetch_texel(const Tile& t, int s, int tc, const OMConst& om) {
    int odd = tc & 1;
    if (g_prof > 0) g_prof_fmt[((t.fmt << 3) | t.siz) & 63]++;
    uint32_t row = (uint32_t)t.tmem * 8 + (uint32_t)tc * (uint32_t)t.line * 8;
    Col out{ 255, 0, 255, 255 }; // debug magenta
    switch ((t.fmt << 3) | t.siz) {
    case (0 << 3) | 2: { // RGBA16
        uint32_t off = row + (uint32_t)s * 2;
        off = tmem_addr_swz(off, odd) & 0xFFF;
        uint16_t px = (uint16_t)((S.tmem[off] << 8) | S.tmem[(off + 1) & 0xFFF]);
        out = unpack_5551(px);
        break;
    }
    case (0 << 3) | 3: { // RGBA32: RG in low half, BA in high half (tmem+0x800)
        uint32_t off = row + (uint32_t)s * 2;
        uint32_t lo = tmem_addr_swz(off, odd) & 0x7FF;
        uint32_t hi = 0x800 + (tmem_addr_swz(off, odd) & 0x7FF);
        out.r = S.tmem[lo]; out.g = S.tmem[(lo + 1) & 0xFFF];
        out.b = S.tmem[hi & 0xFFF]; out.a = S.tmem[(hi + 1) & 0xFFF];
        break;
    }
    case (2 << 3) | 1: { // CI8
        uint32_t off = row + (uint32_t)s;
        off = tmem_addr_swz(off, odd) & 0xFFF;
        uint8_t ci = S.tmem[off];
        uint32_t pal = 0x800 + (uint32_t)ci * 8; // TLUT: one entry per 8 bytes (4x replicated)
        uint16_t px = (uint16_t)((S.tmem[pal & 0xFFF] << 8) | S.tmem[(pal + 1) & 0xFFF]);
        if (om.tlut_ia) { int i = (px >> 8) & 0xFF; out = { i, i, i, px & 0xFF }; }
        else out = unpack_5551(px);
        break;
    }
    case (2 << 3) | 0: { // CI4
        uint32_t off = row + ((uint32_t)s >> 1);
        off = tmem_addr_swz(off, odd) & 0xFFF;
        uint8_t b = S.tmem[off];
        uint8_t ci = (s & 1) ? (b & 0xF) : (b >> 4);
        uint32_t pal = 0x800 + (((uint32_t)t.palette << 4) + ci) * 8;
        uint16_t px = (uint16_t)((S.tmem[pal & 0xFFF] << 8) | S.tmem[(pal + 1) & 0xFFF]);
        if (om.tlut_ia) { int i = (px >> 8) & 0xFF; out = { i, i, i, px & 0xFF }; }
        else out = unpack_5551(px);
        break;
    }
    case (3 << 3) | 2: { // IA16
        uint32_t off = row + (uint32_t)s * 2;
        off = tmem_addr_swz(off, odd) & 0xFFF;
        int i = S.tmem[off], a = S.tmem[(off + 1) & 0xFFF];
        out = { i, i, i, a };
        break;
    }
    case (3 << 3) | 1: { // IA8 (4+4)
        uint32_t off = row + (uint32_t)s;
        off = tmem_addr_swz(off, odd) & 0xFFF;
        uint8_t b = S.tmem[off];
        int i = (b >> 4) * 17, a = (b & 0xF) * 17;
        out = { i, i, i, a };
        break;
    }
    case (3 << 3) | 0: { // IA4 (3+1)
        uint32_t off = row + ((uint32_t)s >> 1);
        off = tmem_addr_swz(off, odd) & 0xFFF;
        uint8_t b = S.tmem[off];
        uint8_t n = (s & 1) ? (b & 0xF) : (b >> 4);
        int i = ((n >> 1) * 255) / 7, a = (n & 1) ? 255 : 0;
        out = { i, i, i, a };
        break;
    }
    case (4 << 3) | 1: { // I8
        uint32_t off = row + (uint32_t)s;
        off = tmem_addr_swz(off, odd) & 0xFFF;
        int i = S.tmem[off];
        out = { i, i, i, i };
        break;
    }
    case (4 << 3) | 0: { // I4
        uint32_t off = row + ((uint32_t)s >> 1);
        off = tmem_addr_swz(off, odd) & 0xFFF;
        uint8_t b = S.tmem[off];
        uint8_t n = (s & 1) ? (b & 0xF) : (b >> 4);
        int i = n * 17;
        out = { i, i, i, i };
        break;
    }
    default: break;
    }
    return out;
}

// Sample with tile clamp/wrap/mirror + optional 3-point bilerp. s,t in 10.5-ish texel fixed
// (we pass s32 texel coords with 5 fraction bits).
static Col sample_tile(int tile_idx, int32_t s_fp, int32_t t_fp, const OMConst& om) {
    const Tile& t = S.tiles[tile_idx & 7];
    // shift per tile
    auto shift_c = [](int32_t v, uint8_t sh) -> int32_t {
        if (sh < 11) return v >> sh;
        return v << (16 - sh);
    };
    s_fp = shift_c(s_fp, t.shifts);
    t_fp = shift_c(t_fp, t.shiftt);
    // relative to tile origin (sl/tl are 10.2 -> convert to .5 frac base)
    s_fp -= (int32_t)t.sl << 3;
    t_fp -= (int32_t)t.tl << 3;
    int s_i = s_fp >> 5, t_i = t_fp >> 5;
    int s_f = s_fp & 31, t_f = t_fp & 31;
    int s_hi = ((int)t.sh - (int)t.sl) >> 2, t_hi = ((int)t.th - (int)t.tl) >> 2;

    if (!om.bilerp || om.cycle_type == 2) {
        if (g_prof > 0) g_prof_point++;
        int si = wrap_coord(s_i, t.masks, t.cms & 1, t.cms & 2, 0, s_hi);
        int ti = wrap_coord(t_i, t.maskt, t.cmt & 1, t.cmt & 2, 0, t_hi);
        return fetch_texel(t, si, ti, om);
    }
    if (g_prof > 0) g_prof_bilerp++;
    // 3-point bilerp: the 4 texels use only 4 distinct wrapped coords (s_i, s_i+1, t_i, t_i+1) — wrap each
    // ONCE here instead of 8× (the old per-texel lambda re-wrapped every shared coord). Bit-identical.
    int ws0 = wrap_coord(s_i,     t.masks, t.cms & 1, t.cms & 2, 0, s_hi);
    int ws1 = wrap_coord(s_i + 1, t.masks, t.cms & 1, t.cms & 2, 0, s_hi);
    int wt0 = wrap_coord(t_i,     t.maskt, t.cmt & 1, t.cmt & 2, 0, t_hi);
    int wt1 = wrap_coord(t_i + 1, t.maskt, t.cmt & 1, t.cmt & 2, 0, t_hi);
    Col c00 = fetch_texel(t, ws0, wt0, om), c10 = fetch_texel(t, ws1, wt0, om),
        c01 = fetch_texel(t, ws0, wt1, om), c11 = fetch_texel(t, ws1, wt1, om);
    // 4-lane [r,g,b,a] bilerp (SSE2 → sse2neon on ARM). BYTE-IDENTICAL to the scalar it replaces: the
    // products s_f·Δ (|s_f|≤31, |Δ|≤255) and their sum fit exactly in float (< 2^24), so int→float mul→
    // int is lossless, and srai(5) reproduces the arithmetic `>> 5` (toward −∞) on the exact integer.
    Col out;
    const __m128i v00 = _mm_loadu_si128((const __m128i*)&c00), v10 = _mm_loadu_si128((const __m128i*)&c10),
                  v01 = _mm_loadu_si128((const __m128i*)&c01), v11 = _mm_loadu_si128((const __m128i*)&c11);
    __m128i base, dA, dB; float fa, fb;
    if (s_f + t_f < 32) { base = v00; dA = _mm_sub_epi32(v10, v00); dB = _mm_sub_epi32(v01, v00); fa = (float)s_f;        fb = (float)t_f; }
    else                { base = v11; dA = _mm_sub_epi32(v01, v11); dB = _mm_sub_epi32(v10, v11); fa = (float)(32 - s_f); fb = (float)(32 - t_f); }
    const __m128 term = _mm_add_ps(_mm_mul_ps(_mm_cvtepi32_ps(dA), _mm_set1_ps(fa)),
                                   _mm_mul_ps(_mm_cvtepi32_ps(dB), _mm_set1_ps(fb)));
    _mm_storeu_si128((__m128i*)&out, _mm_add_epi32(base, _mm_srai_epi32(_mm_cvttps_epi32(term), 5)));
    return out;
}

// ── Combiner (generic (A-B)*C+D, both cycles) ───────────────────────────────────────────────────
struct CmbIn { Col combined, tex0, tex1, shade; };

static int32_t cc_sel_rgb_A(uint32_t s, const CmbIn& I, int lane) {
    const Col* c = nullptr;
    switch (s & 15) {
    case 0: c = &I.combined; break; case 1: c = &I.tex0; break; case 2: c = &I.tex1; break;
    case 3: c = &S.prim_color; break; case 4: c = &I.shade; break; case 5: c = &S.env_color; break;
    case 6: return 255; case 7: return 128; // NOISE stub: mid-gray
    default: return 0;
    }
    return lane == 0 ? c->r : lane == 1 ? c->g : c->b;
}
static int32_t cc_sel_rgb_B(uint32_t s, const CmbIn& I, int lane) {
    const Col* c = nullptr;
    switch (s & 15) {
    case 0: c = &I.combined; break; case 1: c = &I.tex0; break; case 2: c = &I.tex1; break;
    case 3: c = &S.prim_color; break; case 4: c = &I.shade; break; case 5: c = &S.env_color; break;
    case 6: return 255; // KEY_CENTER unsupported -> treat as 1.0 sentinel not meaningful; rare
    default: return 0;
    }
    return lane == 0 ? c->r : lane == 1 ? c->g : c->b;
}
static int32_t cc_sel_rgb_C(uint32_t s, const CmbIn& I, int lane) {
    switch (s & 31) {
    case 0: return lane == 0 ? I.combined.r : lane == 1 ? I.combined.g : I.combined.b;
    case 1: return lane == 0 ? I.tex0.r : lane == 1 ? I.tex0.g : I.tex0.b;
    case 2: return lane == 0 ? I.tex1.r : lane == 1 ? I.tex1.g : I.tex1.b;
    case 3: return lane == 0 ? S.prim_color.r : lane == 1 ? S.prim_color.g : S.prim_color.b;
    case 4: return lane == 0 ? I.shade.r : lane == 1 ? I.shade.g : I.shade.b;
    case 5: return lane == 0 ? S.env_color.r : lane == 1 ? S.env_color.g : S.env_color.b;
    case 7: return I.combined.a; case 8: return I.tex0.a; case 9: return I.tex1.a;
    case 10: return S.prim_color.a; case 11: return I.shade.a; case 12: return S.env_color.a;
    case 13: return 255; /*LOD_FRAC*/ case 14: return S.prim_lod_frac;
    case 6: return 255; // KEY_SCALE unsupported
    default: return 0;
    }
}
static int32_t cc_sel_rgb_D(uint32_t s, const CmbIn& I, int lane) {
    const Col* c = nullptr;
    switch (s & 7) {
    case 0: c = &I.combined; break; case 1: c = &I.tex0; break; case 2: c = &I.tex1; break;
    case 3: c = &S.prim_color; break; case 4: c = &I.shade; break; case 5: c = &S.env_color; break;
    case 6: return 255;
    default: return 0;
    }
    return lane == 0 ? c->r : lane == 1 ? c->g : c->b;
}
static int32_t cc_sel_a(uint32_t s, const CmbIn& I, bool mulC) {
    switch (s & 7) {
    case 0: return mulC ? 255 /*LOD_FRAC slot differs*/ : I.combined.a;
    case 1: return I.tex0.a; case 2: return I.tex1.a;
    case 3: return S.prim_color.a; case 4: return I.shade.a; case 5: return S.env_color.a;
    case 6: return mulC ? S.prim_lod_frac : 255;
    default: return 0;
    }
}

static Col combine_cycle(const CmbIn& I, uint32_t a, uint32_t b, uint32_t c, uint32_t d,
                         uint32_t Aa, uint32_t Ab, uint32_t Ac, uint32_t Ad) {
    Col out;
    for (int lane = 0; lane < 3; lane++) {
        int32_t va = cc_sel_rgb_A(a, I, lane), vb = cc_sel_rgb_B(b, I, lane);
        int32_t vc = cc_sel_rgb_C(c, I, lane), vd = cc_sel_rgb_D(d, I, lane);
        int32_t v = ((va - vb) * vc) / 255 + vd;
        (lane == 0 ? out.r : lane == 1 ? out.g : out.b) = std::clamp(v, 0, 255);
    }
    int32_t aa = cc_sel_a(Aa, I, false), ab = cc_sel_a(Ab, I, false);
    int32_t ac = cc_sel_a(Ac, I, true), ad = cc_sel_a(Ad, I, false);
    out.a = std::clamp(((aa - ab) * ac) / 255 + ad, 0, 255);
    return out;
}

static Col run_combiner(const CmbIn& I0) {
    uint32_t hi = S.cmb_hi, lo = S.cmb_lo;
    uint32_t a0 = (hi >> 20) & 15, c0 = (hi >> 15) & 31, Aa0 = (hi >> 12) & 7, Ac0 = (hi >> 9) & 7;
    uint32_t a1 = (hi >> 5) & 15, c1 = hi & 31;
    uint32_t b0 = (lo >> 28) & 15, b1 = (lo >> 24) & 15, Aa1 = (lo >> 21) & 7, Ac1 = (lo >> 18) & 7;
    uint32_t d0 = (lo >> 15) & 7, Ab0 = (lo >> 12) & 7, Ad0 = (lo >> 9) & 7;
    uint32_t d1 = (lo >> 6) & 7, Ab1 = (lo >> 3) & 7, Ad1 = lo & 7;

    Col cyc0 = combine_cycle(I0, a0, b0, c0, d0, Aa0, Ab0, Ac0, Ad0);
    if (om_cycle_type() != 1) return cyc0;
    CmbIn I1 = I0; I1.combined = cyc0;
    return combine_cycle(I1, a1, b1, c1, d1, Aa1, Ab1, Ac1, Ad1);
}

// ── Compiled combiner: hoist the per-pixel mux switch-dispatch (the profiler's dominant cost) ─────
// The combiner selectors are SPAN-CONSTANT (change only on SetCombine/SetOtherModes), so decode them
// ONCE per triangle into CmbProg, then per pixel resolve each input by a branchless table lookup
// instead of the ~16-32 cc_sel_* switch calls run_combiner did. Arithmetic is byte-identical to
// run_combiner (proven: 20M-input desktop fuzz vs the reference above, 0 mismatches) AND this is the
// SIMD-ready straight-line kernel for the NEON span (P2 Task 1). Env RECOMP_SOFT_RDP_CMBCHK=1 runs the
// reference in lockstep and logs any divergence (in-game pixel-exact gate).
enum { CS_COMB=0, CS_T0, CS_T1, CS_PRIM, CS_SHADE, CS_ENV, CS_ONE, CS_HALF, CS_ZERO, CS_N };
static const uint8_t cs_A_map[16] = {0,1,2,3,4,5,CS_ONE,CS_HALF, CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO};
static const uint8_t cs_B_map[16] = {0,1,2,3,4,5,CS_ONE,CS_ZERO, CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO,CS_ZERO};
static const uint8_t cs_D_map[8]  = {0,1,2,3,4,5,CS_ONE,CS_ZERO};

struct CmbProg {
    uint8_t a[2], b[2], c[2], d[2];         // rgb selectors, cycle 0/1
    uint8_t Aa[2], Ab[2], Ac[2], Ad[2];     // alpha selectors, cycle 0/1
    int cycles;                              // 1 or 2
    bool uses_tex1;                          // does any selector read TEXEL1? if not, skip the 2nd tile fetch
};
static void compile_combiner(CmbProg& p) {
    uint32_t hi = S.cmb_hi, lo = S.cmb_lo;   // same field extraction as run_combiner (hoisted from per-pixel)
    p.a[0]=(hi>>20)&15; p.c[0]=(hi>>15)&31; p.Aa[0]=(hi>>12)&7; p.Ac[0]=(hi>>9)&7;
    p.a[1]=(hi>>5)&15;  p.c[1]=hi&31;
    p.b[0]=(lo>>28)&15; p.b[1]=(lo>>24)&15; p.Aa[1]=(lo>>21)&7; p.Ac[1]=(lo>>18)&7;
    p.d[0]=(lo>>15)&7;  p.Ab[0]=(lo>>12)&7; p.Ad[0]=(lo>>9)&7;
    p.d[1]=(lo>>6)&7;   p.Ab[1]=(lo>>3)&7;  p.Ad[1]=lo&7;
    p.cycles = (om_cycle_type() == 1) ? 2 : 1;
    // TEXEL1 = selector 2 for rgb A/B/D and alpha; selector 2 (rgb) or 9 (alpha) for C. If nothing reads
    // it, its whole tile fetch is dead (CV64's 2-cycle DLs often bind a garbage 2nd tile they never use).
    auto ut1 = [&](int c) {
        return p.a[c]==2 || p.b[c]==2 || p.d[c]==2 || p.c[c]==2 || p.c[c]==9 ||
               p.Aa[c]==2 || p.Ab[c]==2 || p.Ac[c]==2 || p.Ad[c]==2;
    };
    p.uses_tex1 = ut1(0) || (p.cycles == 2 && ut1(1));
}
// per-lane C-multiplier source as a Col (rgb used; alpha-of-source / consts broadcast) — matches cc_sel_rgb_C
static inline Col cs_c_source(uint32_t c, const Col* src, int prim_lod_frac) {
    c &= 31;
    if (c <= 5) return src[c];
    if (c == 6 || c == 13) return { 255,255,255,0 };
    if (c >= 7 && c <= 12) { int v = src[c-7].a; return { v,v,v,0 }; }
    if (c == 14) { int v = prim_lod_frac; return { v,v,v,0 }; }
    return { 0,0,0,0 };
}
// Build the 4-lane vector [col.r, col.g, col.b, aval]: rgb from the source Col (loaded as one __m128i),
// lane 3 replaced by the alpha-selector value (rgb & alpha use different combiner selectors).
static inline __m128i cs_mk4(const Col& col, int32_t aval) {
    const __m128i rgbmask = _mm_set_epi32(0, -1, -1, -1);   // lanes 0-2 = keep, lane 3 = replace
    __m128i v = _mm_loadu_si128((const __m128i*)&col);      // Col is 4×int32 = [r,g,b,a]
    return _mm_or_si128(_mm_and_si128(v, rgbmask), _mm_andnot_si128(rgbmask, _mm_set1_epi32(aval)));
}
// One combiner cycle, SSE2 AoS: all 4 channels [r,g,b,a] at once. The alpha combine shares the rgb form
// (A-B)*C/255+D, so lane 3 carries it. /255 is an exact float divide (cvttps truncates toward zero ==
// integer /255 for the (A-B)*C range; proven vs the reference by 15M-input desktop fuzz). packus clamps
// to [0,255]. Byte-identical to combine_cycle; maps to NEON on ARM via sse2neon.
static inline Col combine_cycle_c(const Col* src, const int32_t* aval_n, const int32_t* aval_c,
                                  int prim_lod_frac, uint32_t a, uint32_t b, uint32_t c, uint32_t d,
                                  uint32_t Aa, uint32_t Ab, uint32_t Ac, uint32_t Ad) {
    Col Ccol = cs_c_source(c, src, prim_lod_frac);
    __m128i A = cs_mk4(src[cs_A_map[a & 15]], aval_n[Aa & 7]);
    __m128i B = cs_mk4(src[cs_B_map[b & 15]], aval_n[Ab & 7]);
    __m128i C = cs_mk4(Ccol,                  aval_c[Ac & 7]);
    __m128i D = cs_mk4(src[cs_D_map[d & 7]],  aval_n[Ad & 7]);
    __m128i diff = _mm_sub_epi32(A, B);
    __m128 prod = _mm_mul_ps(_mm_cvtepi32_ps(diff), _mm_cvtepi32_ps(C));
    __m128i q = _mm_cvttps_epi32(_mm_div_ps(prod, _mm_set1_ps(255.0f)));
    __m128i res = _mm_add_epi32(q, D);
    __m128i r8 = _mm_packus_epi16(_mm_packs_epi32(res, res), _mm_setzero_si128()); // clamp [0,255]
    int rgba = _mm_cvtsi128_si32(r8);
    return Col{ rgba & 0xFF, (rgba >> 8) & 0xFF, (rgba >> 16) & 0xFF, (rgba >> 24) & 0xFF };
}
static Col run_combiner_c(const CmbProg& p, const CmbIn& I) {
    Col src[CS_N];
    src[CS_COMB]=I.combined; src[CS_T0]=I.tex0; src[CS_T1]=I.tex1;
    src[CS_PRIM]=S.prim_color; src[CS_SHADE]=I.shade; src[CS_ENV]=S.env_color;
    src[CS_ONE]={255,255,255,255}; src[CS_HALF]={128,128,128,128}; src[CS_ZERO]={0,0,0,0};
    int plf = S.prim_lod_frac;
    int32_t aval_n[8] = { src[CS_COMB].a, src[CS_T0].a, src[CS_T1].a, src[CS_PRIM].a, src[CS_SHADE].a, src[CS_ENV].a, 255, 0 };
    int32_t aval_c[8] = { 255,            src[CS_T0].a, src[CS_T1].a, src[CS_PRIM].a, src[CS_SHADE].a, src[CS_ENV].a, plf, 0 };
    Col cyc0 = combine_cycle_c(src, aval_n, aval_c, plf, p.a[0],p.b[0],p.c[0],p.d[0], p.Aa[0],p.Ab[0],p.Ac[0],p.Ad[0]);
    if (p.cycles == 1) return cyc0;
    src[CS_COMB] = cyc0; aval_n[CS_COMB] = cyc0.a;   // cycle-1 COMBINED feedback
    return combine_cycle_c(src, aval_n, aval_c, plf, p.a[1],p.b[1],p.c[1],p.d[1], p.Aa[1],p.Ab[1],p.Ac[1],p.Ad[1]);
}

// ── Blender ─────────────────────────────────────────────────────────────────────────────────────
// 2-cycle applies BOTH stages: cycle-0 is where FOG lives (fog*shade_a + pixel*(1-shade_a)); cycle-1
// does the framebuffer blend. The old code applied ONLY cycle-1 → fogged geometry stayed at full
// combiner brightness (this is what made softrdp look RT64-bright rather than N64-accurate; a second
// viewer confirmed RT64 is TOO bright). A mux G_BL_A_SHADE(2) = the fog coeff the RSP writes into
// shade ALPHA (plumbed via shade_a). Env RECOMP_SOFT_RDP_NOFOG=1 forces the old cycle-1-only path (A/B).
static bool blend_skip_cyc0() {
    static const bool s = [] { const char* e = getenv("RECOMP_SOFT_RDP_NOFOG"); return e && e[0] == '1'; }();
    return s;
}
static Col blend_pixel(Col cc, int32_t cc_a, int32_t shade_a, uint32_t x, uint32_t y) {
    uint32_t addr = S.ci_addr + (y * S.ci_width + x) * (S.ci_siz == 3 ? 4 : 2);
    Col mem;
    if (S.ci_siz == 3) mem = col_from_rgba32(rd32(addr));
    else mem = unpack_5551(rd16(addr));

    auto pm = [&](uint32_t s, const Col& in_col) -> Col {
        switch (s & 3) { case 0: return in_col; case 1: return mem; case 2: return S.blend_color; default: return S.fog_color; }
    };
    auto a_in = [&](uint32_t s) -> int32_t {
        switch (s & 3) { case 0: return cc_a; case 1: return S.fog_color.a; case 2: return shade_a; default: return 0; }
    };
    auto b_in = [&](uint32_t s, int32_t A) -> int32_t {
        switch (s & 3) { case 0: return 255 - A; case 1: return mem.a; case 2: return 255; default: return 0; }
    };
    auto do_cycle = [&](int c, const Col& in_col) -> Col {
        // N64 COVERAGE (Milestone-A gap softrdp models as "every drawn pixel is FULL coverage"): when the
        // B input is A_MEM (memory coverage, m2b==1) the RDP weights the blend by coverage, and when the
        // incoming + memory coverage overflow the near surface REPLACES — for full coverage `(P*cvg +
        // M*(8-cvg))/8` with cvg=8 = P. So a full-coverage OPAQUE pixel (cc_a==255) over the AA surface
        // blend replaces memory instead of averaging (the A_MEM average is only for partial-coverage
        // silhouette EDGES softrdp doesn't render). Without this, overlapping opaque geometry halves each
        // layer → the castle crush. Genuinely translucent pixels (cc_a<255) still blend.
        if (om_bl_m2b(c) == 1 && om_bl_m1a(c) == 0 && cc_a == 255) {
            Col o = pm(0, in_col); o.a = in_col.a; return o; // replace: out = pipeline IN
        }
        Col P = pm(om_bl_m1a(c), in_col);
        int32_t A = a_in(om_bl_m1b(c));
        Col M = pm(om_bl_m2a(c), in_col);
        int32_t B = b_in(om_bl_m2b(c), A);
        int denom = A + B; if (denom == 0) denom = 255;
        Col o;
        o.r = std::clamp((P.r * A + M.r * B) / denom, 0, 255);
        o.g = std::clamp((P.g * A + M.g * B) / denom, 0, 255);
        o.b = std::clamp((P.b * A + M.b * B) / denom, 0, 255);
        o.a = in_col.a;
        return o;
    };

    if (om_cycle_type() == 1 && !blend_skip_cyc0()) {
        Col c0 = do_cycle(0, cc);   // fog stage (CLR_IN = cc)
        Col out = do_cycle(1, c0);  // framebuffer blend (CLR_IN = fogged pixel)
        out.a = cc_a;
        return out;
    }
    // 1-cycle (or NOFOG A/B): single stage using the appropriate cycle's words + opaque fast path.
    int cyc = (om_cycle_type() == 1) ? 1 : 0;
    if (!om_force_blend() && a_in(om_bl_m1b(cyc)) == 255 && om_bl_m1a(cyc) == 0) return cc;
    Col out = do_cycle(cyc, cc);
    out.a = cc_a;
    return out;
}

// ── Compiled blender: same span-constant-hoist as the combiner (blender mux is per-SetOtherModes) ──
// Decode the om_bl_* selectors once per triangle; per pixel resolve pm()/a_in()/b_in() by table index
// instead of switch. Byte-identical to blend_pixel (20M-input fuzz, 0 mismatches); mem read + the
// data-dependent /denom stay per-pixel exactly as before.
struct BlProg {
    uint8_t m1a[2], m1b[2], m2a[2], m2b[2];  // blender mux per cycle
    int  cycle_type;
    bool nofog;
    bool force_blend;
};
static void compile_blender(BlProg& p) {
    for (int c = 0; c < 2; c++) {
        p.m1a[c]=(uint8_t)om_bl_m1a(c); p.m1b[c]=(uint8_t)om_bl_m1b(c);
        p.m2a[c]=(uint8_t)om_bl_m2a(c); p.m2b[c]=(uint8_t)om_bl_m2b(c);
    }
    p.cycle_type = om_cycle_type();
    p.nofog = blend_skip_cyc0();
    p.force_blend = om_force_blend();
}
static inline Col do_cycle_c(const BlProg& p, int c, const Col& in_col, const Col& mem, int32_t cc_a, int32_t shade_a) {
    const Col pm_tab[4] = { in_col, mem, S.blend_color, S.fog_color };   // pm(): CLR_IN / MEM / BLEND / FOG
    if (p.m2b[c] == 1 && p.m1a[c] == 0 && cc_a == 255) {                 // full-coverage replace (see blend_pixel)
        Col o = pm_tab[0]; o.a = in_col.a; return o;
    }
    const Col& P = pm_tab[p.m1a[c]];
    const Col& M = pm_tab[p.m2a[c]];
    int32_t a_tab[4] = { cc_a, S.fog_color.a, shade_a, 0 };              // a_in()
    int32_t A = a_tab[p.m1b[c]];
    int32_t b_tab[4] = { 255 - A, mem.a, 255, 0 };                      // b_in()
    int32_t B = b_tab[p.m2b[c]];
    int denom = A + B; if (denom == 0) denom = 255;
    Col o;
    if (denom == 255) {
        // The dominant path (standard alpha blend A + (255-A) = 255). Replace the A72 integer divide
        // (SDIV ~12cyc, unpipelined; 3ch × up-to-2cyc = 6/pixel) with the EXACT floor(n/255) identity
        // ((n+1)*257)>>16, valid for n in [0, ~16M] (here n = P*A+M*B ≤ 255*255 = 65025 since A+B=255,
        // all inputs ≥0). Bit-identical to the reference /255 — proven live by RECOMP_SOFT_RDP_CMBCHK.
        auto d255 = [](int32_t n) -> int32_t { return (int32_t)((((uint32_t)n + 1u) * 257u) >> 16); };
        o.r = std::clamp(d255(P.r * A + M.r * B), 0, 255);
        o.g = std::clamp(d255(P.g * A + M.g * B), 0, 255);
        o.b = std::clamp(d255(P.b * A + M.b * B), 0, 255);
    } else {
        o.r = std::clamp((P.r * A + M.r * B) / denom, 0, 255);
        o.g = std::clamp((P.g * A + M.g * B) / denom, 0, 255);
        o.b = std::clamp((P.b * A + M.b * B) / denom, 0, 255);
    }
    o.a = in_col.a;
    return o;
}
static Col blend_pixel_c(const BlProg& p, Col cc, int32_t cc_a, int32_t shade_a, uint32_t x, uint32_t y) {
    uint32_t addr = S.ci_addr + (y * S.ci_width + x) * (S.ci_siz == 3 ? 4 : 2);
    Col mem{ 0,0,0,0 };
    if (g_nofb) { /* isolate memory: skip the framebuffer read, keep the blend compute */ }
    else if (S.ci_siz == 3) mem = col_from_rgba32(rd32(addr));
    else mem = unpack_5551(rd16(addr));
    if (p.cycle_type == 1 && !p.nofog) {
        Col c0 = do_cycle_c(p, 0, cc, mem, cc_a, shade_a);  // fog stage
        Col out = do_cycle_c(p, 1, c0, mem, cc_a, shade_a); // framebuffer blend
        out.a = cc_a;
        return out;
    }
    int cyc = (p.cycle_type == 1) ? 1 : 0;
    int32_t a_tab[4] = { cc_a, S.fog_color.a, shade_a, 0 };
    if (!p.force_blend && a_tab[p.m1b[cyc]] == 255 && p.m1a[cyc] == 0) return cc;   // opaque fast path
    Col out = do_cycle_c(p, cyc, cc, mem, cc_a, shade_a);
    out.a = cc_a;
    return out;
}

static inline void write_color(uint32_t x, uint32_t y, const Col& c) {
    if (S.ci_siz == 3) {
        uint32_t addr = S.ci_addr + (y * S.ci_width + x) * 4;
        wr32(addr, ((uint32_t)std::clamp(c.r, 0, 255) << 24) | ((uint32_t)std::clamp(c.g, 0, 255) << 16) |
                   ((uint32_t)std::clamp(c.b, 0, 255) << 8) | (uint32_t)std::clamp(c.a, 0, 255));
    }
    else {
        uint32_t addr = S.ci_addr + (y * S.ci_width + x) * 2;
        wr16(addr, pack_5551(c.r, c.g, c.b, 1));
    }
}

// ── Per-pixel pipeline for triangles/rects ──────────────────────────────────────────────────────
static void shade_pixel(uint32_t x, uint32_t y, const Col& shade, int tile_idx, bool textured,
                        int32_t s_fp, int32_t t_fp, bool has_z, uint32_t z18,
                        const CmbProg& cprog, const BlProg& bprog, const OMConst& om) {
    // scissor (10.2 -> int)
    if (x < (S.sc_xh >> 2) || x >= (S.sc_xl >> 2) || y < (S.sc_yh >> 2) || y >= (S.sc_yl >> 2)) return;
    if (g_prof > 0 && g_worker_n <= 1) { g_prof_pixels++; if (textured) g_prof_tex++; }

    // Z test (kept even under NOFB so the fragment count / Z-cull workload stays identical to baseline —
    // NOFB isolates memory by skipping only the color read/write + Z write below, not this cull read).
    uint32_t zaddr = S.zi_addr + (y * S.ci_width + x) * 2;
    if (has_z && om.z_cmp) {
        uint16_t zm = rd16(zaddr);
        uint32_t old_z = z_decode((uint16_t)(zm >> 2));
        bool pass;
        switch (om.zmode) {
        case 1: pass = (z18 <= old_z); break;              // interpenetrating approx
        case 3: pass = (z18 <= old_z); break;              // decal approx (needs range check)
        default: pass = (z18 < old_z); break;              // opaque / xlu
        }
        if (!pass) return;
    }

    CmbIn I;
    I.shade = shade;
    I.combined = { 0,0,0,255 };
    if (textured) {
        if (g_notex > 0) { I.tex0 = I.tex1 = { 200,200,200,255 }; } // A/B: skip the fetch, keep the pipeline
        else {
            I.tex0 = sample_tile(tile_idx, s_fp, t_fp, om);
            // Only fetch the 2nd tile when the combiner actually reads TEXEL1 (else it's a dead fetch —
            // ~half of CV64's cutscene texels per the census). Pixel-exact: I.tex1 is unread when !uses_tex1.
            I.tex1 = (om.cycle_type == 1 && cprog.uses_tex1) ? sample_tile((tile_idx + 1) & 7, s_fp, t_fp, om) : I.tex0;
        }
    }
    else {
        I.tex0 = I.tex1 = { 0,0,0,0 };
    }

    Col cc = (g_oldcmb > 0) ? run_combiner(I) : run_combiner_c(cprog, I);   // OLDCMB = A/B baseline path

    // alpha compare (threshold mode)
    if (om.alpha_cmp && cc.a < S.blend_color.a) return;

    Col outc = (g_oldcmb > 0) ? blend_pixel(cc, cc.a, shade.a, x, y)
                              : blend_pixel_c(bprog, cc, cc.a, shade.a, x, y);
    // In-game pixel-exact gate: run the reference in lockstep (both blenders read the pre-write mem).
    if (g_cmbchk > 0 && g_worker_n <= 1) {
        Col cref = run_combiner(I);
        Col bref = blend_pixel(cref, cref.a, shade.a, x, y);
        if (cref.r!=cc.r||cref.g!=cc.g||cref.b!=cc.b||cref.a!=cc.a ||
            bref.r!=outc.r||bref.g!=outc.g||bref.b!=outc.b||bref.a!=outc.a) {
            if (g_cmbchk_bad++ < 40)
                fprintf(stderr, "[softrdp-cmbchk] MISMATCH cc ref(%d,%d,%d,%d) got(%d,%d,%d,%d) | blend ref(%d,%d,%d,%d) got(%d,%d,%d,%d)\n",
                        cref.r,cref.g,cref.b,cref.a, cc.r,cc.g,cc.b,cc.a,
                        bref.r,bref.g,bref.b,bref.a, outc.r,outc.g,outc.b,outc.a);
        }
    }
    if (!g_nofb) write_color(x, y, outc);
    if (has_z && om.z_upd && !g_nofb) {
        wr16(zaddr, (uint16_t)((z_encode(z18) << 2) | 3)); // dz stub = max
    }
}

// ── Triangle rasterization from RDP edge coefficients ──────────────────────────────────────────
struct AttrStep {
    double base[8], dx[8], de[8]; // r,g,b,a,s,t,w,z
    bool shade = false, tex = false, z = false;
};

static void draw_triangle(const uint8_t* cmd, bool shade, bool tex, bool zbuf) {
    auto w32 = [&](int i) { return ((uint32_t)cmd[i] << 24) | ((uint32_t)cmd[i + 1] << 16) | ((uint32_t)cmd[i + 2] << 8) | cmd[i + 3]; };
    uint32_t w0 = w32(0), w1 = w32(4);
    if (g_noraster > 0) { S.tri_count++; return; }   // ceiling measurement: LLE produced the cmd, we skip raster
    bool lft = (w0 >> 23) & 1;
    int tile_idx = (w0 >> 16) & 7;
    auto s14_2 = [](uint32_t v) { int32_t x = (int32_t)(v & 0x3FFF); if (x & 0x2000) x -= 0x4000; return x; };
    int32_t yl = s14_2(w0), ym = s14_2(w1 >> 16), yh = s14_2(w1);
    int32_t xl = (int32_t)w32(8), dxldy = (int32_t)w32(12);
    int32_t xh = (int32_t)w32(16), dxhdy = (int32_t)w32(20);
    int32_t xm = (int32_t)w32(24), dxmdy = (int32_t)w32(28);

    // Early scanline-ownership reject BEFORE the expensive coefficient parse: if none of this triangle's
    // scanlines fall on this worker's interleave, skip it. This is what makes banding scale on the
    // cutscene's many tiny triangles (otherwise every worker re-parses every triangle).
    if (g_worker_n > 1) {
        int _ys = (yh + 3) >> 2, _ye = yl >> 2;
        if (_ys >= _ye) return;
        int _off = ((g_worker_idx - (_ys % g_worker_n)) % g_worker_n + g_worker_n) % g_worker_n;
        if (_ys + _off >= _ye) { S.tri_count++; return; }
    }

    const uint8_t* p = cmd + 32;
    AttrStep A{};
    A.shade = shade; A.tex = tex; A.z = zbuf;
    auto load_attr_block = [&](int base_idx) {
        // layout: 4 int16 hi | 4 int16 next -> combined with fraction words per the RDP format
        auto rd = [&](int off) { return ((uint32_t)p[off] << 24) | ((uint32_t)p[off + 1] << 16) | ((uint32_t)p[off + 2] << 8) | p[off + 3]; };
        uint32_t i01 = rd(0), i23 = rd(4), dxi01 = rd(8), dxi23 = rd(12);
        uint32_t f01 = rd(16), f23 = rd(20), dxf01 = rd(24), dxf23 = rd(28);
        uint32_t dei01 = rd(32), dei23 = rd(36), dyi01 = rd(40), dyi23 = rd(44);
        uint32_t def01 = rd(48), def23 = rd(52), dyf01 = rd(56), dyf23 = rd(60);
        (void)dyi01; (void)dyi23; (void)dyf01; (void)dyf23; // Dy unused in scanline stepping
        auto mk = [](uint32_t hi, uint32_t frac, bool second) -> double {
            int32_t iv = second ? (int16_t)(hi & 0xFFFF) : (int16_t)(hi >> 16);
            uint32_t fv = second ? (frac & 0xFFFF) : (frac >> 16);
            return (double)iv + (double)fv / 65536.0;
        };
        A.base[base_idx + 0] = mk(i01, f01, false); A.base[base_idx + 1] = mk(i01, f01, true);
        A.base[base_idx + 2] = mk(i23, f23, false); A.base[base_idx + 3] = mk(i23, f23, true);
        A.dx[base_idx + 0] = mk(dxi01, dxf01, false); A.dx[base_idx + 1] = mk(dxi01, dxf01, true);
        A.dx[base_idx + 2] = mk(dxi23, dxf23, false); A.dx[base_idx + 3] = mk(dxi23, dxf23, true);
        A.de[base_idx + 0] = mk(dei01, def01, false); A.de[base_idx + 1] = mk(dei01, def01, true);
        A.de[base_idx + 2] = mk(dei23, def23, false); A.de[base_idx + 3] = mk(dei23, def23, true);
        p += 64;
    };
    if (shade) load_attr_block(0);
    if (tex) load_attr_block(4);
    double z_base = 0, z_dx = 0, z_de = 0;
    if (zbuf) {
        auto rd = [&](int off) { return ((uint32_t)p[off] << 24) | ((uint32_t)p[off + 1] << 16) | ((uint32_t)p[off + 2] << 8) | p[off + 3]; };
        z_base = (double)(int32_t)rd(0) / 65536.0;
        z_dx = (double)(int32_t)rd(4) / 65536.0;
        z_de = (double)(int32_t)rd(8) / 65536.0;
        p += 16;
    }

    int y_start = (yh + 3) >> 2, y_end = yl >> 2;
    double xh_f = (double)xh / 65536.0, xm_f = (double)xm / 65536.0, xl_f = (double)xl / 65536.0;
    double dxh = (double)dxhdy / 65536.0, dxm = (double)dxmdy / 65536.0, dxl = (double)dxldy / 65536.0;

    // Hoist the span-constant combiner/blender/othermode decode out of the per-pixel loop (once per tri).
    CmbProg cprog; compile_combiner(cprog);
    BlProg  bprog; compile_blender(bprog);
    OMConst om = compile_om();

    for (int y = y_start; y < y_end; y++) {
        if (g_worker_n > 1 && (y % g_worker_n) != g_worker_idx) continue;   // interleaved-scanline banding
        double yy = (double)(y * 4 - yh) / 4.0;             // lines since yh in pixel units
        double x_major = xh_f + dxh * yy;
        double x_minor;
        if (y * 4 < ym) x_minor = xm_f + dxm * yy;
        else            x_minor = xl_f + dxl * ((double)(y * 4 - ym) / 4.0);
        double x_l = lft ? x_major : x_minor;
        double x_r = lft ? x_minor : x_major;
        int xs = (int)std::ceil(x_l), xe = (int)std::ceil(x_r);
        if (xe <= xs) continue;

        // Attributes start on the MAJOR edge, step DxDe per line then DxDx across. The RDP edge-walks in
        // FIXED-POINT; the prior double per-pixel `base + dx*dxp` (8 double mul-adds + a double divide/px)
        // is half-rate on the A72 and NEON-unpackable. Compute each span's START in double (precise), then
        // walk it in FLOAT incrementally (+= dx) — full-rate FP, one divide/px instead of two, and ready
        // for 4-wide SIMD. Float ≈ hardware precision (RDP is ~fixed-point); verified vs the RDP-math
        // frame-dump + a CRT, not the old double CRC (which this intentionally re-baselines).
        double x0_major = x_major;
        double dxp0 = (double)xs - x0_major;
        alignas(16) float cur[8]; float dxf[8];
        for (int i = 0; i < 8; i++) { cur[i] = (float)(A.base[i] + A.de[i] * yy + A.dx[i] * dxp0); dxf[i] = (float)A.dx[i]; }
        float curz = (float)(z_base + z_de * yy + z_dx * dxp0), dzf = (float)z_dx;
        // Per-pixel attribute walk in 2×4-wide SIMD (r,g,b,a | s,t,w,z): bit-identical to the scalar
        // += (per-lane IEEE float add, same lane order), full-rate on NEON(sse2neon)/SSE. curz scalar.
        __m128 vcur0 = _mm_load_ps(&cur[0]), vcur1 = _mm_load_ps(&cur[4]);
        const __m128 vdx0 = _mm_loadu_ps(&dxf[0]), vdx1 = _mm_loadu_ps(&dxf[4]);
        for (int x = xs; x < xe; x++) {
            _mm_store_ps(&cur[0], vcur0);
            _mm_store_ps(&cur[4], vcur1);
            Col sh{ 255,255,255,255 };
            if (A.shade) {
                sh.r = std::clamp((int)cur[0], 0, 255);
                sh.g = std::clamp((int)cur[1], 0, 255);
                sh.b = std::clamp((int)cur[2], 0, 255);
                sh.a = std::clamp((int)cur[3], 0, 255);
            }
            int32_t s_fp = 0, t_fp = 0;
            if (A.tex) {
                float sD = cur[4], tD = cur[5], wD = cur[6];
                if (om.persp_en && wD != 0.0f) {
                    if (g_nodiv > 0) { sD *= 0.03f; tD *= 0.03f; }               // A/B: cheap mul instead of the divide
                    else { float inv = 32768.0f / wD; sD *= inv; tD *= inv; }    // 1 divide + 2 muls (RDP: 1/w then mul)
                }
                s_fp = (int32_t)(sD);       // S is 10.5-ish after persp divide per coeff scaling
                t_fp = (int32_t)(tD);
            }
            uint32_t z18 = 0;
            if (A.z) z18 = (uint32_t)std::clamp((int)curz, 0, (int)0x3FFFF);
            shade_pixel((uint32_t)x, (uint32_t)y, sh, tile_idx, A.tex, s_fp, t_fp, A.z, z18, cprog, bprog, om);
            vcur0 = _mm_add_ps(vcur0, vdx0);
            vcur1 = _mm_add_ps(vcur1, vdx1);
            curz += dzf;
        }
    }
    S.tri_count++;
}

// ── Frame dump (PPM, no deps) ───────────────────────────────────────────────────────────────────
static void dump_frame() {
    static const char* dir = [] {
        const char* d = getenv("RECOMP_SOFT_RDP_DIR");
        return d ? d : "softrdp_frames";
    }();
    static int every = [] {
        const char* e = getenv("RECOMP_SOFT_RDP_DUMP_EVERY");
        return e ? atoi(e) : 30;
    }();
    static int ring = [] { // RECOMP_SOFT_RDP_RING: slots to rotate through; 0 = keep every frame
        const char* r = getenv("RECOMP_SOFT_RDP_RING");
        return r ? atoi(r) : 8;
    }();
    if (every <= 0) return;
    S.frame_count++;
    if ((S.frame_count % (uint64_t)every) != 0) return;

    uint64_t slot = ring > 0 ? (S.frame_count / every % (uint64_t)ring) : S.frame_count;
    char path[512];
    snprintf(path, sizeof(path), "%s/frame_%06llu.ppm", dir, (unsigned long long)slot);
    FILE* f = fopen(path, "wb");
    if (!f) {
#ifdef _WIN32
        _mkdir(dir);
#else
        char cmd[600]; snprintf(cmd, sizeof(cmd), "mkdir -p '%s'", dir); int _ = system(cmd); (void)_;
#endif
        f = fopen(path, "wb");
        if (!f) return;
    }
    uint32_t w = S.ci_width ? S.ci_width : 320;
    uint32_t h = (w * 3) / 4; if (h == 0) h = 240;
    fprintf(f, "P6\n%u %u\n255\n", w, h);
    for (uint32_t y = 0; y < h; y++) {
        for (uint32_t x = 0; x < w; x++) {
            Col c;
            if (S.ci_siz == 3) c = col_from_rgba32(rd32(S.ci_addr + (y * w + x) * 4));
            else c = unpack_5551(rd16(S.ci_addr + (y * w + x) * 2));
            fputc(c.r, f); fputc(c.g, f); fputc(c.b, f);
        }
    }
    fclose(f);

    // Shadow twin: only softrdp's own writes this frame; untouched pixels = magenta canary.
    uint64_t seen_px = 0;
    if (g_shadow) {
        snprintf(path, sizeof(path), "%s/shadow_%06llu.ppm", dir, (unsigned long long)slot);
        if (FILE* sf = fopen(path, "wb")) {
            auto srd8 = [](uint32_t a) -> uint8_t { return g_shadow[(a & RDRAM_MASK) ^ 3]; };
            auto seen = [](uint32_t a, uint32_t n) {
                for (uint32_t i = 0; i < n; i++) if (!g_shadow_seen[((a + i) & RDRAM_MASK) ^ 3]) return false;
                return true;
            };
            fprintf(sf, "P6\n%u %u\n255\n", w, h);
            uint32_t bpp = (S.ci_siz == 3) ? 4 : 2;
            for (uint32_t y = 0; y < h; y++) {
                for (uint32_t x = 0; x < w; x++) {
                    uint32_t a = S.ci_addr + (y * w + x) * bpp;
                    Col c{ 255, 0, 255, 255 };
                    if (seen(a, bpp)) {
                        seen_px++;
                        if (bpp == 4) c = col_from_rgba32(((uint32_t)srd8(a) << 24) | ((uint32_t)srd8(a + 1) << 16)
                                                          | ((uint32_t)srd8(a + 2) << 8) | srd8(a + 3));
                        else c = unpack_5551((uint16_t)((srd8(a) << 8) | srd8(a + 1)));
                    }
                    fputc(c.r, sf); fputc(c.g, sf); fputc(c.b, sf);
                }
            }
            fclose(sf);
        }
    }

    fprintf(stderr, "[softrdp] frame %llu -> %s (ci=0x%06X %ux%u siz=%u) tris=%llu rects=%llu fills=%llu shadow=%u%%\n",
            (unsigned long long)S.frame_count, path, S.ci_addr, w, h, S.ci_siz,
            (unsigned long long)S.tri_count, (unsigned long long)S.rect_count, (unsigned long long)S.fill_count,
            (unsigned)(g_shadow ? seen_px * 100 / ((uint64_t)w * h) : 0));
    fflush(stderr);
}

// ── Command loop ────────────────────────────────────────────────────────────────────────────────
bool enabled() {
    static const bool on = [] {
        const char* e = getenv("RECOMP_SOFT_RDP");
        return e && e[0] == '1';
    }();
    return on;
}

// ── Multicore banding: a persistent worker pool; each worker owns interleaved scanlines ───────────
// RECOMP_SOFT_RDP_THREADS=N. Worker 0 is the calling (gfx) thread; workers 1..N-1 are pool threads.
// On each command range, all N replay it into their own thread_local State but rasterize only their
// scanlines, then barrier. Pixel-exact by construction (same code, disjoint pixel rows, no locks).
static void run_command_range(uint32_t addr, uint32_t stop);

namespace {
struct BandPool {
    int n = 1;
    std::mutex m;
    std::condition_variable cv_go, cv_done;
    uint64_t generation = 0;
    int remaining = 0;
    uint32_t task_start = 0, task_stop = 0;
    void start(int nn) {
        n = nn;
        for (int i = 1; i < n; i++) {
            std::thread([this, i] {
                g_worker_idx = i; g_worker_n = n;
                uint64_t seen = 0;
                for (;;) {
                    std::unique_lock<std::mutex> lk(m);
                    cv_go.wait(lk, [&] { return generation != seen; });
                    seen = generation;
                    uint32_t s = task_start, e = task_stop;
                    lk.unlock();
                    run_command_range(s, e);
                    lk.lock();
                    if (--remaining == 0) cv_done.notify_all();
                }
            }).detach();
        }
    }
    void dispatch(uint32_t s, uint32_t e) {
        {
            std::unique_lock<std::mutex> lk(m);
            task_start = s; task_stop = e; remaining = n - 1; generation++;
            cv_go.notify_all();
        }
        g_worker_idx = 0; g_worker_n = n;
        run_command_range(s, e);                 // the caller thread is worker 0
        std::unique_lock<std::mutex> lk(m);
        cv_done.wait(lk, [&] { return remaining == 0; });
    }
};
static BandPool* g_pool = nullptr;               // leaked (never destroyed) so the detached workers stay valid
}

// The per-worker command loop: replay every command into this thread's State S, rasterizing only the
// scanlines this worker owns (y % g_worker_n == g_worker_idx). Framebuffer/Z writes land on disjoint
// scanlines across workers, so no locks are needed. g_rdram is shared (read for commands/textures).
static void run_command_range(uint32_t addr, uint32_t stop) {
    uint8_t cmd[176]; // largest triangle = 0xB0 bytes
    int guard = 0;
    while (addr < stop && guard++ < 300000) {
        uint32_t w0 = rd32(addr);
        uint32_t op = (w0 >> 24) & 0x3F;
        uint32_t len = 8;
        if (op >= 0x08 && op <= 0x0F) {
            bool sh = op & 4, tx = op & 2, zb = op & 1;
            len = 0x20 + (sh ? 0x40 : 0) + (tx ? 0x40 : 0) + (zb ? 0x10 : 0);
        }
        else if (op == 0x24 || op == 0x25) len = 16;
        if (addr + len > stop) break;
        for (uint32_t i = 0; i < len && i < sizeof(cmd); i++) cmd[i] = rd8(addr + i);
        uint32_t w1 = rd32(addr + 4);

        switch (op) {
        case 0x08: case 0x09: case 0x0A: case 0x0B:
        case 0x0C: case 0x0D: case 0x0E: case 0x0F:
            draw_triangle(cmd, op & 4, op & 2, op & 1);
            break;
        case 0x24: case 0x25: { // TextureRectangle (+flip)
            uint32_t xl = (w0 >> 12) & 0xFFF, yl = w0 & 0xFFF;
            uint32_t tile = (w1 >> 24) & 7;
            uint32_t xh = (w1 >> 12) & 0xFFF, yh = w1 & 0xFFF;
            uint32_t w2 = rd32(addr + 8), w3 = rd32(addr + 12);
            int16_t s0 = (int16_t)(w2 >> 16), t0 = (int16_t)w2;
            int16_t dsdx = (int16_t)(w3 >> 16), dtdy = (int16_t)w3;
            int x0 = xh >> 2, y0 = yh >> 2, x1 = xl >> 2, y1 = yl >> 2;
            if (om_cycle_type() == 2) { x1++; y1++; dsdx /= 4; } // copy mode: inclusive + 4x step encoding
            CmbProg cprog; compile_combiner(cprog);
            BlProg  bprog; compile_blender(bprog);
            OMConst om = compile_om();
            double t_cur = (double)t0 / 32.0;
            for (int y = y0; y < y1; y++) {
                if (g_worker_n > 1 && (y % g_worker_n) != g_worker_idx) continue;
                double s_cur = (double)s0 / 32.0;
                for (int x = x0; x < x1; x++) {
                    int32_t s_fp = (int32_t)(s_cur * 32.0), t_fp = (int32_t)(t_cur * 32.0);
                    if (op == 0x25) std::swap(s_fp, t_fp);
                    Col sh{ 255,255,255,255 };
                    shade_pixel((uint32_t)x, (uint32_t)y, sh, (int)tile, true, s_fp, t_fp, false, 0, cprog, bprog, om);
                    s_cur += (double)dsdx / 1024.0;
                }
                t_cur += (double)dtdy / 1024.0;
            }
            S.rect_count++;
            break;
        }
        case 0x26: case 0x27: case 0x28: break; // syncs
        case 0x29: // SyncFull = end of frame. Frame-end accounting waits for the barrier (see process_commands).
            if (g_worker_idx == 0) g_saw_syncfull = true;
            break;
        case 0x2D: // SetScissor
            S.sc_xh = (w0 >> 12) & 0xFFF; S.sc_yh = w0 & 0xFFF;
            S.sc_xl = (w1 >> 12) & 0xFFF; S.sc_yl = w1 & 0xFFF;
            break;
        case 0x2F: S.othermode = ((uint64_t)(w0 & 0x00FFFFFF) << 32) | w1; break;
        case 0x30: { // LoadTLUT
            const Tile& t = S.tiles[(w1 >> 24) & 7];
            uint32_t sl = (w0 >> 12) & 0xFFF, sh_ = (w1 >> 12) & 0xFFF;
            uint32_t count = ((sh_ >> 2) - (sl >> 2)) + 1;
            uint32_t src = S.ti_addr + (sl >> 2) * 2;
            for (uint32_t i = 0; i < count && i < 256; i++) {
                uint16_t px = rd16(src + i * 2);
                uint32_t off = ((uint32_t)t.tmem * 8 + i * 8) & 0xFFF; // quad-replicated entries
                S.tmem[off] = (uint8_t)(px >> 8); S.tmem[(off + 1) & 0xFFF] = (uint8_t)px;
            }
            break;
        }
        case 0x32: { // SetTileSize
            Tile& t = S.tiles[(w1 >> 24) & 7];
            t.sl = (w0 >> 12) & 0xFFF; t.tl = w0 & 0xFFF;
            t.sh = (w1 >> 12) & 0xFFF; t.th = w1 & 0xFFF;
            break;
        }
        case 0x33: { // LoadBlock
            Tile& t = S.tiles[(w1 >> 24) & 7];
            uint32_t sl = (w0 >> 12) & 0xFFF, tl = w0 & 0xFFF;
            uint32_t sh_ = (w1 >> 12) & 0xFFF, dxt = w1 & 0xFFF;
            (void)tl;
            uint32_t texels = sh_ - sl + 1;
            uint32_t bytes = (texels << S.ti_siz) >> 1;
            uint32_t src = S.ti_addr;
            uint32_t dst = (uint32_t)t.tmem * 8;
            uint32_t t_accum = 0; int line = 0;
            for (uint32_t i = 0; i < bytes; i += 8) {
                int odd = line & 1;
                for (uint32_t b = 0; b < 8 && (i + b) < bytes; b++) {
                    uint32_t off = (dst + i + b);
                    S.tmem[tmem_addr_swz(off, odd) & 0xFFF] = rd8(src + i + b);
                }
                if (dxt) { t_accum += dxt; if (t_accum & 0x800) { t_accum &= 0x7FF; line++; } } // 1.11 accumulate
            }
            break;
        }
        case 0x34: { // LoadTile
            Tile& t = S.tiles[(w1 >> 24) & 7];
            uint32_t sl = ((w0 >> 12) & 0xFFF) >> 2, tl = (w0 & 0xFFF) >> 2;
            uint32_t sh_ = ((w1 >> 12) & 0xFFF) >> 2, th = (w1 & 0xFFF) >> 2;
            uint32_t bpp_shift = (S.ti_siz == 0) ? 0 : (S.ti_siz - 1); // bytes per texel shift (4b handled below)
            uint32_t row_bytes_src = (S.ti_width << S.ti_siz) >> 1;
            for (uint32_t ty = tl; ty <= th; ty++) {
                int odd = (int)((ty - tl) & 1);
                uint32_t src = S.ti_addr + ty * row_bytes_src + ((sl << S.ti_siz) >> 1);
                uint32_t dst = (uint32_t)t.tmem * 8 + (ty - tl) * (uint32_t)t.line * 8;
                uint32_t nbytes = (((sh_ - sl + 1) << S.ti_siz) >> 1);
                (void)bpp_shift;
                for (uint32_t b = 0; b < nbytes; b++) {
                    S.tmem[tmem_addr_swz(dst + b, odd) & 0xFFF] = rd8(src + b);
                }
            }
            break;
        }
        case 0x35: { // SetTile
            Tile& t = S.tiles[(w1 >> 24) & 7];
            t.fmt = (w0 >> 21) & 7; t.siz = (w0 >> 19) & 3;
            t.line = (w0 >> 9) & 0x1FF; t.tmem = w0 & 0x1FF;
            t.palette = (w1 >> 20) & 0xF;
            t.cmt = (w1 >> 18) & 3; t.maskt = (w1 >> 14) & 0xF; t.shiftt = (w1 >> 10) & 0xF;
            t.cms = (w1 >> 8) & 3; t.masks = (w1 >> 4) & 0xF; t.shifts = w1 & 0xF;
            break;
        }
        case 0x36: { // FillRectangle
            uint32_t xl = (w0 >> 12) & 0xFFF, yl = w0 & 0xFFF;
            uint32_t xh = (w1 >> 12) & 0xFFF, yh = w1 & 0xFFF;
            int x0 = xh >> 2, y0 = yh >> 2, x1 = (xl >> 2) + 1, y1 = (yl >> 2) + 1; // fill/copy inclusive
            if (om_cycle_type() < 2) { x1--; y1--; } // 1/2-cycle exclusive
            int scx0 = S.sc_xh >> 2, scy0 = S.sc_yh >> 2, scx1 = S.sc_xl >> 2, scy1 = S.sc_yl >> 2;
            x0 = std::max(x0, scx0); y0 = std::max(y0, scy0);
            x1 = std::min(x1, scx1); y1 = std::min(y1, scy1);
            for (int y = y0; y < y1; y++) {
                if (g_worker_n > 1 && (y % g_worker_n) != g_worker_idx) continue;
                for (int x = x0; x < x1; x++) {
                    if (S.ci_siz == 3) wr32(S.ci_addr + ((uint32_t)y * S.ci_width + x) * 4, S.fill_color);
                    else {
                        uint16_t px = (uint16_t)((x & 1) ? S.fill_color : (S.fill_color >> 16));
                        wr16(S.ci_addr + ((uint32_t)y * S.ci_width + x) * 2, px);
                    }
                }
            }
            S.fill_count++;
            break;
        }
        case 0x37: S.fill_color = w1; break;
        case 0x38: S.fog_color = col_from_rgba32(w1); break;
        case 0x39: S.blend_color = col_from_rgba32(w1); break;
        case 0x3A: S.prim_lod_frac = (uint8_t)(w0 & 0xFF); S.prim_color = col_from_rgba32(w1); break;
        case 0x3B: S.env_color = col_from_rgba32(w1); break;
        case 0x3C: S.cmb_hi = w0 & 0x00FFFFFF; S.cmb_lo = w1; break;
        case 0x3D: S.ti_fmt = (w0 >> 21) & 7; S.ti_siz = (w0 >> 19) & 3; S.ti_width = (w0 & 0x3FF) + 1; S.ti_addr = w1 & RDRAM_MASK; break;
        case 0x3E: S.zi_addr = w1 & RDRAM_MASK; break;
        case 0x3F: S.ci_fmt = (w0 >> 21) & 7; S.ci_siz = (w0 >> 19) & 3; S.ci_width = (w0 & 0x3FF) + 1; S.ci_addr = w1 & RDRAM_MASK; break;
        default: break;
        }
        addr += len;
    }
}

void process_commands(uint8_t* rdram, uint32_t start, uint32_t end) {
    std::lock_guard<std::mutex> lk(g_mtx);
    g_rdram = rdram;
    if (g_prof < 0) {
        const char* e = getenv("RECOMP_SOFT_RDP_PROF"); g_prof = (e && e[0] == '1') ? 1 : 0;
        g_notex = getenv("RECOMP_SOFT_RDP_NOTEX") ? 1 : 0;
        g_nodiv = getenv("RECOMP_SOFT_RDP_NODIV") ? 1 : 0;
        g_noraster = getenv("RECOMP_SOFT_RDP_NORASTER") ? 1 : 0;
        g_nofb = getenv("RECOMP_SOFT_RDP_NOFB") ? 1 : 0;
        g_cmbchk = getenv("RECOMP_SOFT_RDP_CMBCHK") ? 1 : 0;
        { const char* e = getenv("RECOMP_SOFT_RDP_OLDCMB"); g_oldcmb = (e && e[0] == '1') ? 1 : 0; } // value-checked A/B knob
    }
    if (g_nthreads < 0) {
        const char* t = getenv("RECOMP_SOFT_RDP_THREADS");
        g_nthreads = t ? atoi(t) : 1;
        if (g_nthreads < 1) g_nthreads = 1;
        if (g_nthreads > 8) g_nthreads = 8;
        if (g_nthreads > 1) { g_pool = new BandPool(); g_pool->start(g_nthreads); }
        fprintf(stderr, "[softrdp] threads=%d\n", g_nthreads); fflush(stderr);
    }
    static bool shadow_init = false;
    if (!shadow_init) { // RECOMP_SOFT_RDP_SHADOW=0 disables (perf runs); default on for bring-up
        shadow_init = true;
        const char* sh = getenv("RECOMP_SOFT_RDP_SHADOW");
        if (!sh || sh[0] != '0') {
            g_shadow = (uint8_t*)calloc(RDRAM_MASK + 1, 1);
            g_shadow_seen = (uint8_t*)calloc(RDRAM_MASK + 1, 1);
            if (!g_shadow || !g_shadow_seen) { free(g_shadow); free(g_shadow_seen); g_shadow = g_shadow_seen = nullptr; }
        }
    }
    uint32_t addr = start & RDRAM_MASK, stop = end & RDRAM_MASK;
    if (stop <= addr || (stop - addr) > 0x100000) return;
    auto _prof_t0 = std::chrono::steady_clock::now();
    if (g_nthreads <= 1) { g_worker_idx = 0; g_worker_n = 1; run_command_range(addr, stop); }
    else g_pool->dispatch(addr, stop);
    if (g_saw_syncfull) {   // a frame ended in this range; all workers finished (barrier) → the image is complete
        g_saw_syncfull = false;
        static auto _fps_t0 = std::chrono::steady_clock::now();
        static uint64_t _fps_n = 0, _fn = 0;
        _fps_n++; _fn++;
        double _dt = std::chrono::duration<double>(std::chrono::steady_clock::now() - _fps_t0).count();
        if (_dt >= 2.0) { fprintf(stderr, "[softrdp-fps] %.1f fps (threads=%d)\n", _fps_n / _dt, g_nthreads); fflush(stderr); _fps_n = 0; _fps_t0 = std::chrono::steady_clock::now(); }
        if (const char* vc = getenv("RECOMP_SOFT_RDP_CRC"); vc && vc[0] == '1' && (_fn % 100 == 0)) {
            uint32_t crc = 0, base = S.ci_addr, cnt = S.ci_width * 240u * 2u;   // hash the color image = pixel-exactness check
            for (uint32_t i = 0; i < cnt; i += 2) crc = crc * 1000003u + rd16(base + i);
            fprintf(stderr, "[softrdp-crc] frame=%llu crc=%08X\n", (unsigned long long)_fn, crc); fflush(stderr);
        }
        if (g_nthreads <= 1) { dump_frame(); if (g_shadow_seen) memset(g_shadow_seen, 0, RDRAM_MASK + 1); }
    }
    if (g_prof > 0 && g_nthreads <= 1) {   // profiler is single-thread; multicore is measured by wall fps
        g_prof_ns += (uint64_t)std::chrono::duration_cast<std::chrono::nanoseconds>(
                         std::chrono::steady_clock::now() - _prof_t0).count();
        if (g_prof_ns > 2000000000ull) {
            double secs = g_prof_ns / 1e9;
            fprintf(stderr, "[softrdp-prof] %.1f Mpix/s (%.1f Mpix in %.2fs raster; textured %.0f%%)\n",
                    g_prof_pixels / 1e6 / secs, g_prof_pixels / 1e6, secs,
                    g_prof_pixels ? 100.0 * g_prof_tex / g_prof_pixels : 0.0);
            uint64_t ft = 0; int top = 0; for (int f = 0; f < 64; f++) { ft += g_prof_fmt[f]; if (g_prof_fmt[f] > g_prof_fmt[top]) top = f; }
            static const char* fn[64] = {
                0,0,"RGBA16","RGBA32", 0,0,0,0, 0,0,0,0, 0,0,0,0,
                "CI4","CI8",0,0, 0,0,0,0, "IA4","IA8","IA16",0, 0,0,0,0, "I4","I8" };
            fprintf(stderr, "[softrdp-tex] texels=%llu bilerp=%llu point=%llu | top=%d(%s) %llu%% (RGBA16=%llu%% CI4=%llu%% CI8=%llu%% IA16=%llu%% I8=%llu%% I4=%llu%%)\n",
                    (unsigned long long)ft, (unsigned long long)g_prof_bilerp, (unsigned long long)g_prof_point,
                    top, fn[top] ? fn[top] : "?", (unsigned long long)(ft ? g_prof_fmt[top]*100/ft : 0),
                    (unsigned long long)(ft?g_prof_fmt[2]*100/ft:0), (unsigned long long)(ft?g_prof_fmt[16]*100/ft:0),
                    (unsigned long long)(ft?g_prof_fmt[17]*100/ft:0), (unsigned long long)(ft?g_prof_fmt[26]*100/ft:0),
                    (unsigned long long)(ft?g_prof_fmt[33]*100/ft:0), (unsigned long long)(ft?g_prof_fmt[32]*100/ft:0));
            fflush(stderr);
            for (int f = 0; f < 64; f++) g_prof_fmt[f] = 0; g_prof_bilerp = 0; g_prof_point = 0;
            g_prof_ns = 0; g_prof_pixels = 0; g_prof_tex = 0;
        }
    }
}

} // namespace softrdp

