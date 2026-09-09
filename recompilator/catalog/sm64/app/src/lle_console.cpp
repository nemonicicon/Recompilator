// lle_console.cpp — the RT64-free console renderer (see lle_console.h).
//
// Threading model: update_screen() runs on the gfx events thread (same thread that just ran the
// LLE render for the frame's tasks, so the RDRAM color image is complete — no tearing between
// render and scan-out). It decodes the VI into a shared ARGB buffer. blit_tick() runs on the MAIN
// thread (~1ms tick from the run loop) and owns all SDL window-surface calls — SDL video must stay
// on the window's thread (Wayland especially).
//
// Presentation geometry: default = aspect-correct letterbox (desktop windows). RDPC_LLE_STRETCH=1
// stretches to the full window — the CRT mode (composite pixels are not square; deviation #21
// anamorphic lesson).
#ifdef RDPC_CAPTURE_CHAIN

#include "lle_console.h"

#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <mutex>
#include <vector>

#include <SDL.h>

#include "ultramodern/ultramodern.hpp"
#include "softrdp/fb_present.h"

// RDP-parallel seam (rsp.cpp / ultramodern events.cpp): the console renderer defers DP
// completion to its render thread, which fires it when the render actually finishes.
extern "C" int g_dp_deferred_by_renderer;
void sm64_lle_console_submit();

namespace sm64 {
namespace lleconsole {

bool active() {
    static const bool on = [] {
        const char* e = std::getenv("RDPC_LLE_CONSOLE");
        return e != nullptr && e[0] == '1';
    }();
    return on;
}

// ── Frame handoff (events thread -> main thread) ─────────────────────────────
namespace {
    std::mutex g_m;
    std::vector<uint32_t> g_frame;   // ARGB8888, g_w x g_h (native N64 resolution)
    uint32_t g_w = 0, g_h = 0;
    bool g_dirty = false;

    std::vector<uint32_t> g_blit;    // main-thread copy (swap under lock, blit outside it)

    // Rendered-origin registry (events-thread only; see lle_console.h). Each entry carries
    // the blank-generation it was last rendered in: after every osViBlack window the VI
    // presents black until the displayed buffer has been re-rendered SINCE the blank began.
    // (Real hardware gets this ordering for free: cartridge-speed loads keep osViBlack up
    // for seconds, so the re-render always precedes the unblank. Our instant PI DMA
    // collapses that window and would flash whatever the load left in fb memory.)
    uint32_t g_rendered_ci[16];
    uint32_t g_rendered_gen[16];
    int g_rendered_n = 0;
    uint32_t g_blank_gen = 0;
}

void note_rendered_ci(uint32_t ci) {
    // Called from the RDP-parallel render thread; the VI gate reads on the events thread.
    std::lock_guard<std::mutex> lk(g_m);
    ci &= 0x7FFFFF;
    if (ci == 0) return;
    for (int i = 0; i < g_rendered_n; i++) {
        if (g_rendered_ci[i] == ci) {
            g_rendered_gen[i] = g_blank_gen;
            return;
        }
    }
    if (g_rendered_n < 16) {
        g_rendered_ci[g_rendered_n] = ci;
        g_rendered_gen[g_rendered_n] = g_blank_gen;
        g_rendered_n++;
    }
}

class ConsoleContext final : public ultramodern::renderer::RendererContext {
public:
    explicit ConsoleContext(uint8_t* rdram) : rdram_(rdram) {
        setup_result = ultramodern::renderer::SetupResult::Success;
        chosen_api = ultramodern::renderer::GraphicsApi::Auto;   // no graphics API at all
        g_dp_deferred_by_renderer = 1;   // our RDP thread delivers the honest dp_complete
        fprintf(stderr, "[lleconsole] console renderer up: rdpcore -> RDRAM -> fb_present scan-out (NO RT64, RDP-parallel)\n");
        fflush(stderr);
    }

    bool valid() override { return true; }

    bool update_config(const ultramodern::renderer::GraphicsConfig&,
                       const ultramodern::renderer::GraphicsConfig&) override { return true; }

    void enable_instant_present() override {}

    // capture_gfx (same thread, just before this) ran the f3d ucode and stashed the RDP
    // stream; hand it to the RDP-parallel thread, which renders and fires the honest
    // dp_complete when the drawing is genuinely done.
    void send_dl(const OSTask*) override { sm64_lle_console_submit(); }

    void update_screen() override {
        // VI model rev-2 (2026-07-12): the COMPLETE law, transcribed from RT64's rt64_vi.cpp
        // (visible / deinterlacedWidth / fbAddress / fbSize) — the tested in-house reference.
        auto* vi = ultramodern::renderer::get_vi_regs();
        const uint32_t status = vi->VI_STATUS_REG;
        const uint32_t origin = vi->VI_ORIGIN_REG & 0x7FFFFF;
        const uint32_t vwidth = vi->VI_WIDTH_REG & 0xFFF;
        const uint32_t type   = status & 0x3;      // 0/1 = blank, 2 = 16-bit, 3 = 32-bit
        const bool serrate    = (status & 0x40) != 0;

        // visible(): type != BLANK && hStart > 0 (osViBlack lands here as hStart==0 via
        // events.cpp update_vi). Plus our engine-side boot gate.
        bool blank = (type < 2) || vwidth == 0 || vi->VI_H_START_REG == 0 ||
                     !ultramodern::is_game_started();

        // deinterlacedWidth(): in serrate modes without deflicker, VI_WIDTH is the doubled
        // stride; detect via the hRegion/xScale estimate and halve.
        uint32_t w = vwidth;
        if (serrate && !blank) {
            const uint32_t hs = (vi->VI_H_START_REG >> 16) & 0x3FF;
            const uint32_t he = vi->VI_H_START_REG & 0x3FF;
            const uint32_t xscale = vi->VI_X_SCALE_REG & 0xFFF;
            if (xscale != 0) {
                const float est = (float)(he - hs) / (1024.0f / (float)xscale);
                if (est < (float)vwidth / 1.875f) w = vwidth / 2;
            }
        }
        const uint32_t siz = (type == 3) ? 3 : 2;
        const uint32_t bytespp = (siz == 3) ? 4 : 2;

        // fbAddress(): the VI origin carries a one-row offset (two on the odd interlaced
        // field) — subtract it to land on the framebuffer base the RDP actually drew.
        uint32_t fb = origin;
        {
            const uint32_t row_bytes = w * bytespp *
                ((serrate && (vi->VI_V_CURRENT_LINE_REG & 1)) ? 2 : 1);
            if (fb >= row_bytes) fb -= row_bytes;
        }

        // fbSize(): height from the vRegion and yScale (+2 rows, rounded to a multiple of 4).
        uint32_t h = (w * 3) / 4;   // fallback shape if the regs are degenerate
        {
            const uint32_t vs = (vi->VI_V_START_REG >> 16) & 0x3FF;
            const uint32_t ve = vi->VI_V_START_REG & 0x3FF;
            const uint32_t yscale = vi->VI_Y_SCALE_REG & 0xFFF;
            if (ve > vs && yscale != 0 && w != 0) {
                const float ysf = 1024.0f / (float)yscale;
                float fh = (float)(ve - vs) / (2.0f * ysf * ((float)w / (float)vwidth));
                uint32_t hh = (uint32_t)(fh + 0.5f) + 2;
                hh = ((hh + 2) / 4) * 4;
                if (hh >= 4 && hh <= 720) h = hh;
            }
        }

        // Rendered-origin gate (RT64's structural protection) + blank-generation stamp:
        // only scan framebuffers the LLE rendered, and after an osViBlack window only ones
        // re-rendered SINCE the blank began — the unblank never exposes load-time contents.
        // Under g_m: the RDP-parallel thread writes the registry via note_rendered_ci.
        {
            std::lock_guard<std::mutex> lk(g_m);
            static bool was_blank = false;
            if (blank && !was_blank) g_blank_gen++;
            was_blank = blank;
            if (!blank) {
                bool rendered = false;
                for (int i = 0; i < g_rendered_n && !rendered; i++) {
                    const uint32_t base = g_rendered_ci[i];
                    if (fb >= base && fb < base + w * h * bytespp &&
                        g_rendered_gen[i] == g_blank_gen) rendered = true;
                }
                if (!rendered) blank = true;
            }
        }
        if (blank) { w = 320; h = 240; }

        // Present-work dedup (~04:45, the contention lever): the VI runs 60Hz but SM64 swaps
        // buffers at 30Hz — re-decoding and re-blitting an UNCHANGED origin burns ~a third
        // of a core that the render workers need. Skip when nothing observable changed.
        // (A single-buffered game that draws into the fronted buffer would need this off —
        // note for the 296 census; SM64 double-buffers.)
        {
            static uint32_t lo = 0xFFFFFFFFu, lst = 0, lwd = 0;
            static bool lbk = true, first = true;
            if (!first && fb == lo && status == lst && vwidth == lwd && blank == lbk) {
                return;
            }
            first = false; lo = fb; lst = status; lwd = vwidth; lbk = blank;
        }
        // TRUE CONSOLE SCANOUT (RDPC_LLE_FBDEV=1, Linux): present straight to /dev/fb0 via
        // fb_present's fbdev path — no SDL, no compositor, no shm pools. The launcher stops
        // the display manager first (the compositor owns DRM otherwise). This is the CRT
        // mode the plan meant: rdpcore -> RDRAM -> fbdev scanout, GPU-free end to end.
        static const bool fbdev_mode = [] {
            const char* e = std::getenv("RDPC_LLE_FBDEV");
            bool on = e != nullptr && e[0] == '1';
            if (on) {
                bool ok = softrdp::present::init();
                fprintf(stderr, "[lleconsole] fbdev scanout %s\n", ok ? "UP" : "UNAVAILABLE (falling back to SDL)");
                fflush(stderr);
                return ok;
            }
            return false;
        }();
        if (fbdev_mode) {
            softrdp::present::present(rdram_, fb, w, h, siz, blank);
            return;
        }

        {
            std::lock_guard<std::mutex> lk(g_m);
            g_frame.resize((size_t)w * h);
            softrdp::present::present_argb(rdram_, fb, w, h, siz, blank,
                                           g_frame.data(), w, h, w);
            // DEBUG probe (RDPC_LLE_BLANKCOLOR=1): paint OUR blank presents magenta so a
            // capture can tell them from the compositor's black / an unpainted SDL buffer.
            static const bool blankprobe = [] {
                const char* e = std::getenv("RDPC_LLE_BLANKCOLOR");
                return e != nullptr && e[0] == '1';
            }();
            if (blank && blankprobe) {
                for (size_t i = 0; i < (size_t)w * h; i++) g_frame[i] = 0xFFFF00FFu;
            }
            g_w = w; g_h = h; g_dirty = true;
        }

        static uint32_t n = 0;
        // Stale-scanout hunt (an "arcade pattern" in some black scenes SURVIVES the
        // osViBlack fix): log every VI reg-state change (swap-rotation origins excluded)
        // plus a per-second luma census of what we actually presented. A garbage window
        // shows up as blank=0 + high luma variance right after a state change — the logged
        // regs name the mechanism (fade? repeatline? yscale? something else).
        {
            static uint32_t ls = 0xFFFFFFFF, lhs = 0xFFFFFFFF, lw = 0xFFFFFFFF;
            static bool lb = false;
            const uint32_t hs = vi->VI_H_START_REG;
            if (status != ls || hs != lhs || vwidth != lw || blank != lb) {
                fprintf(stderr, "[lleconsole] state @vi%u: origin=0x%06X fb=0x%06X %ux%u "
                        "status=0x%08X hstart=0x%08X yscale=0x%X blank=%d rendered_n=%d\n",
                        n, origin, fb, w, h, status, hs, vi->VI_Y_SCALE_REG,
                        blank ? 1 : 0, g_rendered_n);
                fflush(stderr);
                ls = status; lhs = hs; lw = vwidth; lb = blank;
            }
            // NOISE DETECTOR (the "arcade pattern" hunt, 2026-07-12 ~03:30): raw data shown
            // as pixels has huge adjacent-pixel deltas EVERYWHERE; rendered frames are mostly
            // smooth. Frames tripping the detector get dumped as PPM + regs — machine eyes on
            // exactly what keeps being caught on screen. First 8 dumps to ~/vi_noise (Linux) / cwd.
            if (!blank) {
                uint32_t hi = 0;
                const size_t npx = (size_t)w * h;
                for (uint32_t k = 0; k < 256; k++) {
                    size_t idx = ((size_t)k * 977u) % (npx - 1);
                    uint32_t p0 = g_frame[idx], p1 = g_frame[idx + 1];
                    int d = 0;
                    d += ((p0 >> 16) & 0xFF) > ((p1 >> 16) & 0xFF) ? ((p0 >> 16) & 0xFF) - ((p1 >> 16) & 0xFF) : ((p1 >> 16) & 0xFF) - ((p0 >> 16) & 0xFF);
                    d += ((p0 >> 8) & 0xFF) > ((p1 >> 8) & 0xFF) ? ((p0 >> 8) & 0xFF) - ((p1 >> 8) & 0xFF) : ((p1 >> 8) & 0xFF) - ((p0 >> 8) & 0xFF);
                    d += (p0 & 0xFF) > (p1 & 0xFF) ? (p0 & 0xFF) - (p1 & 0xFF) : (p1 & 0xFF) - (p0 & 0xFF);
                    if (d > 180) hi++;
                }
                if (hi > 160) {   // >62% of sampled neighbor pairs wildly discontinuous = noise
                    static uint32_t noise_dumps = 0, noise_total = 0;
                    noise_total++;
                    fprintf(stderr, "[lleconsole] NOISE frame @vi%u (#%u): fb=0x%06X origin=0x%06X %ux%u "
                            "status=0x%08X hstart=0x%08X gen=%u hi=%u/256\n",
                            n, noise_total, fb, origin, w, h, status, vi->VI_H_START_REG,
                            g_blank_gen, hi);
                    if (noise_dumps < 8) {
                        char path[256];
#ifdef _WIN32
                        snprintf(path, sizeof(path), "vi_noise_%u.ppm", noise_dumps);
#else
                        system("mkdir -p ~/vi_noise 2>/dev/null");
                        snprintf(path, sizeof(path), "%s/vi_noise/vi%u.ppm",
                                 getenv("HOME") ? getenv("HOME") : ".", n);
#endif
                        if (FILE* f = fopen(path, "wb")) {
                            fprintf(f, "P6\n%u %u\n255\n", w, h);
                            for (size_t i = 0; i < npx; i++) {
                                uint8_t rgb[3] = { (uint8_t)(g_frame[i] >> 16),
                                                   (uint8_t)(g_frame[i] >> 8),
                                                   (uint8_t)g_frame[i] };
                                fwrite(rgb, 1, 3, f);
                            }
                            fclose(f);
                            noise_dumps++;
                            fprintf(stderr, "[lleconsole] NOISE dumped: %s\n", path);
                        }
                    }
                    fflush(stderr);
                }
            }

            static uint64_t luma_sum = 0, luma_max = 0;
            static uint32_t luma_n = 0, blank_n = 0;
            if (!blank) {
                uint64_t s = 0;
                for (uint32_t k = 0; k < 64; k++) {
                    uint32_t px = g_frame[(size_t)(k * 1009u) % ((size_t)w * h)];
                    s += ((px >> 16) & 0xFF) + ((px >> 8) & 0xFF) + (px & 0xFF);
                }
                s /= (64 * 3);
                luma_sum += s;
                if (s > luma_max) luma_max = s;
                luma_n++;
            } else {
                blank_n++;
            }
            if ((n % 60) == 59) {
                fprintf(stderr, "[lleconsole] sec @vi%u: luma avg=%llu max=%llu (%u frames, %u blank)\n",
                        n, luma_n ? (unsigned long long)(luma_sum / luma_n) : 0,
                        (unsigned long long)luma_max, luma_n, blank_n);
                fflush(stderr);
                luma_sum = 0; luma_max = 0; luma_n = 0; blank_n = 0;
            }
        }
        n++;
    }

    void shutdown() override {}
    uint32_t get_display_framerate() const override { return 60; }
    float get_resolution_scale() const override { return 1.0f; }

private:
    uint8_t* rdram_;
};

std::unique_ptr<ultramodern::renderer::RendererContext> create_console_context(uint8_t* rdram) {
    return std::make_unique<ConsoleContext>(rdram);
}

void blit_tick(SDL_Window* window) {
    if (!active() || window == nullptr) {
        return;
    }
    uint32_t w, h;
    {
        std::lock_guard<std::mutex> lk(g_m);
        if (!g_dirty || g_w == 0) {
            return;
        }
        g_blit = g_frame;            // ~300 KB at 320x240; trivial next to a VI period
        w = g_w; h = g_h;
        g_dirty = false;
    }

    SDL_Surface* win_surf = SDL_GetWindowSurface(window);
    if (win_surf == nullptr) {
        return;                      // minimized / surface unavailable this tick
    }
    SDL_Surface* src = SDL_CreateRGBSurfaceWithFormatFrom(
        g_blit.data(), (int)w, (int)h, 32, (int)w * 4, SDL_PIXELFORMAT_ARGB8888);
    if (src == nullptr) {
        return;
    }
    // COPY, never blend: with the default BLEND mode an alpha-0 source pixel leaves the
    // destination untouched — on a fresh shm pool buffer that means uninitialized memory
    // goes to the screen (the blank-window arcade pattern, root-caused 2026-07-12).
    SDL_SetSurfaceBlendMode(src, SDL_BLENDMODE_NONE);

    static const bool stretch = [] {   // CRT mode: fill the raster, anamorphic like composite
        const char* e = std::getenv("RDPC_LLE_STRETCH");
        return e != nullptr && e[0] == '1';
    }();

    SDL_Rect dst;
    if (stretch) {
        dst = SDL_Rect{ 0, 0, win_surf->w, win_surf->h };
    } else {
        // Largest centered 4:3 rect; clear the borders whenever geometry changes.
        int fit_w = win_surf->w, fit_h = (win_surf->w * 3) / 4;
        if (fit_h > win_surf->h) { fit_h = win_surf->h; fit_w = (win_surf->h * 4) / 3; }
        dst = SDL_Rect{ (win_surf->w - fit_w) / 2, (win_surf->h - fit_h) / 2, fit_w, fit_h };
        static int last_w = -1, last_h = -1;
        if (last_w != win_surf->w || last_h != win_surf->h) {
            SDL_FillRect(win_surf, nullptr, SDL_MapRGB(win_surf->format, 0, 0, 0));
            last_w = win_surf->w; last_h = win_surf->h;
        }
    }

    SDL_BlitScaled(src, nullptr, win_surf, &dst);
    SDL_FreeSurface(src);
    SDL_UpdateWindowSurface(window);
}

} // namespace lleconsole
} // namespace sm64

#endif // RDPC_CAPTURE_CHAIN
