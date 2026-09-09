/**
 * launcher_ui.cpp — the launcher's screen, drawn with ImGui on RT64's own present.
 *
 * HOW THE IMGUI FRAME IS REACHED (no engine change):
 *   RT64 already exposes a public draw hook — engine/rt64/src/rhi/rt64_render_hooks.h
 *   `SetRenderHooks(init, draw, deinit)`. PresentQueue::threadLoop calls it once per present,
 *   AFTER the swap-chain framebuffer is bound and cleared and the VI image (if any) is drawn, and
 *   BEFORE the inspector's own draw:  engine/rt64/src/hle/rt64_present_queue.cpp:442.
 *   The VI thread pushes a present ~60 times a second even with no game running (it sets a dummy
 *   VI whose framebuffer alternates — engine/runtime/ultramodern/src/events.cpp:509-517), so the
 *   hook fires at 60 Hz from the moment the window is up.
 *
 * WHY A SECOND IMGUI CONTEXT: the F1 inspector's ImGui frame is opened from State::inspect(),
 * which only runs while a game is submitting display lists (rt64_state.cpp:1758 / :2081). With no
 * game there is no inspector frame to draw into, and the inspector object itself does not exist
 * until F1 is pressed. So the launcher creates its own ImGui context, initialised the same way the
 * inspector initialises its own (rt64_inspector.cpp:64-142), and makes it current only for the
 * duration of its own hook. It cannot fight the inspector's context: the launcher turns
 * developerMode off on its RT64 Application, so F1..F4 do nothing in this window.
 */

#include "launcher_app.hpp"

#include <algorithm>
#include <atomic>
#include <cfloat>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <memory>
#include <string>
#include <thread>
#include <vector>

#if defined(_WIN32)
#  include <unknwn.h>
#  include <wtypes.h>
#  include <Windows.h>
#endif

#include "SDL.h"

#include "ultramodern/ultramodern.hpp"

#include "imgui/imgui.h"
#include "rhi/rt64_render_hooks.h"
#include "hle/rt64_application.h"
#include "gui/rt64_file_dialog.h"

#if defined(_WIN32)
#  include "imgui/backends/imgui_impl_dx12.h"
#  include "plume_d3d12.h"
#endif

namespace fs = std::filesystem;

namespace launcher {

// ── state ─────────────────────────────────────────────────────────────────────
UiState& ui() { static UiState s; return s; }

double now_seconds() {
    static const auto t0 = std::chrono::steady_clock::now();
    return std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
}

static RT64::Application*                 g_app = nullptr;
static ImGuiContext*                      g_ctx = nullptr;
static std::unique_ptr<RenderDescriptorSet> g_imgui_descriptor_set;
static std::atomic<bool>                  g_ready{ false };
// STEP 3: set once a GAME MODULE has taken this window. The launcher then draws nothing at all
// (the game owns every pixel) and main.cpp routes every key to the game instead of the menu.
static std::atomic<bool>                  g_game_in_process{ false };
static SDL_Window*                        g_window = nullptr;
// The size of the framebuffer the last frame was laid out in, so the pump can turn an SDL window
// coordinate into the pixel coordinate the hit rectangles are written in.
static std::atomic<int>                   g_fb_w{ 0 };
static std::atomic<int>                   g_fb_h{ 0 };
#if defined(_WIN32)
static PROCESS_INFORMATION                g_child{};
static bool                               g_child_live = false;
#endif

void ui_set_window(void* sdl_window) {
    g_window = (SDL_Window*)sdl_window;
    // THE POINTER MUST BE VISIBLE over the front door. A stranger who unzips this and double-clicks
    // it will reach for the mouse first, so the system cursor stays on for the whole time the
    // launcher owns the window, and is turned off the moment a game module takes it.
    SDL_ShowCursor(SDL_ENABLE);
}

// ── the palette: black + one accent, N64-era colours only in the starfield ────
static const ImU32 COL_TEXT   = IM_COL32(226, 231, 240, 255);
static const ImU32 COL_DIM    = IM_COL32(126, 134, 150, 255);
static const ImU32 COL_ACCENT = IM_COL32(255, 176,  64, 255);
static const ImU32 COL_PANEL  = IM_COL32(  9,  10,  14, 128);   // the starfield must read through
static const ImU32 COL_BAR    = IM_COL32( 16,  18,  25, 245);
static const ImU32 COL_ROWSEL = IM_COL32(255, 176,  64,  46);
// HOVER is the selection fill at half strength - the same colour, not a new visual language.
static const ImU32 COL_ROWHOV = IM_COL32(255, 176,  64,  22);
static const ImU32 COL_BTNBOX = IM_COL32(255, 176,  64,  55);
static const ImU32 COL_PLAYS  = IM_COL32(110, 220, 140, 255);
static const ImU32 COL_NOTR   = IM_COL32(214, 108, 108, 255);

static ImU32 state_colour(const std::string& label) {
    if (label == "PLAYS")     return COL_PLAYS;
    if (label == "TITLE")     return COL_ACCENT;
    if (label == "NOT BUILT") return COL_DIM;
    return COL_NOTR;
}

// ── the 3D starfield ─────────────────────────────────────────────────────────
// A few hundred points flying toward the camera, projected by hand and drawn as short streaks on
// ImGui's background draw list. No shader, no second renderer.
namespace {

struct Star { float x, y, z; ImU32 col; };

uint32_t rng_state = 0x1234567u;
float frand() {
    rng_state ^= rng_state << 13; rng_state ^= rng_state >> 17; rng_state ^= rng_state << 5;
    return (float)(rng_state & 0xFFFFFF) / (float)0xFFFFFF;
}

// N64-era palette: the console's own logo colours plus a plain white.
const ImU32 STAR_COLS[] = {
    IM_COL32(255, 255, 255, 255),
    IM_COL32(255,  92,  92, 255),
    IM_COL32( 92, 168, 255, 255),
    IM_COL32( 92, 224, 140, 255),
    IM_COL32(255, 214,  92, 255),
    IM_COL32(210, 120, 255, 255),
    IM_COL32( 92, 236, 236, 255),
};

const float Z_FAR = 6.0f;
std::vector<Star> g_stars;

void respawn(Star& s, bool anywhere) {
    s.x = (frand() - 0.5f) * 7.0f;
    s.y = (frand() - 0.5f) * 7.0f;
    s.z = anywhere ? (0.15f + frand() * (Z_FAR - 0.15f)) : Z_FAR;
    s.col = STAR_COLS[(size_t)(frand() * 6.999f)];
}

void starfield(ImDrawList* dl, float w, float h, float dt) {
    if (g_stars.empty()) {
        g_stars.resize(520);
        for (Star& s : g_stars) respawn(s, true);
    }
    const float cx = w * 0.5f, cy = h * 0.5f;
    const float f  = h * 0.85f;
    const float speed  = 1.7f;
    const float streak = 5.0f;   // the tail is where the star was `streak` frames ago

    for (Star& s : g_stars) {
        s.z -= speed * dt;
        if (s.z <= 0.12f) { respawn(s, false); continue; }
        const float z_prev = s.z + speed * dt * streak;

        const float sx = cx + s.x / s.z * f;
        const float sy = cy + s.y / s.z * f;
        if (sx < -80.0f || sx > w + 80.0f || sy < -80.0f || sy > h + 80.0f) continue;

        const float px = cx + s.x / z_prev * f;
        const float py = cy + s.y / z_prev * f;

        const float near_t = 1.0f - (s.z / Z_FAR);          // 0 far, 1 close
        const int   a  = (int)(45.0f + 210.0f * near_t);
        const float th = 1.0f + 2.4f * near_t * near_t;
        const ImU32 c  = (s.col & 0x00FFFFFFu) | ((ImU32)std::min(a, 255) << IM_COL32_A_SHIFT);
        dl->AddLine(ImVec2(px, py), ImVec2(sx, sy), c, th);
    }
}

} // namespace

// ── small drawing helpers ────────────────────────────────────────────────────
namespace {

ImFont* g_font = nullptr;

void text(ImDrawList* dl, float x, float y, float size, ImU32 col, const std::string& s) {
    dl->AddText(g_font, size, ImVec2(x, y), col, s.c_str());
}

float text_w(float size, const std::string& s) {
    return g_font->CalcTextSizeA(size, FLT_MAX, 0.0f, s.c_str()).x;
}

std::string clip(float size, std::string s, float max_w) {
    if (text_w(size, s) <= max_w) return s;
    while (s.size() > 1 && text_w(size, s + "...") > max_w) s.pop_back();
    return s + "...";
}

std::string mmss(double secs) {
    if (secs < 0) secs = 0;
    const int m = (int)(secs / 60.0);
    const double s = secs - m * 60.0;
    char buf[32];
    std::snprintf(buf, sizeof(buf), "%02d:%04.1f", m, s);
    return buf;
}

// The one place a clickable rectangle is written down. The draw pass calls this for every thing it
// draws that the mouse may act on; the main-thread pump reads the list back and tests the pointer.
void hit_add(UiState& s, float x0, float y0, float x1, float y1, HitKind kind, int index,
             Action action) {
    HitRect r{};
    r.x0 = x0; r.y0 = y0; r.x1 = x1; r.y1 = y1;
    r.kind = kind; r.index = index; r.action = action;
    s.hit.push_back(r);
}

void panel(ImDrawList* dl, float x0, float y0, float x1, float y1) {
    dl->AddRectFilled(ImVec2(x0, y0), ImVec2(x1, y1), COL_PANEL, 2.0f);
    dl->AddRect(ImVec2(x0, y0), ImVec2(x1, y1), IM_COL32(255, 176, 64, 90), 2.0f, 0, 1.0f);
}

// The ZSNES-style top bar. Each item's rectangle is recorded: a click on it is Left/Right's effect
// without the walking.
void top_bar(ImDrawList* dl, float w, float sc, UiState& s) {
    const float h = 46.0f * sc;
    dl->AddRectFilled(ImVec2(0, 0), ImVec2(w, h), COL_BAR);
    dl->AddLine(ImVec2(0, h), ImVec2(w, h), COL_ACCENT, 2.0f);

    // ARCHIVE is where the games are and where the program opens. The other three are the settings
    // a person actually looks for. The old GAME/CONFIG/MISC bar moved a highlight and nothing else
    // (2026-09-07: selecting CONFIG did nothing).
    static const char* items[4] = { "ARCHIVE", "VIDEO", "AUDIO", "CONTROLS" };
    float x = 26.0f * sc;
    const float fs = 24.0f * sc;
    for (int i = 0; i < 4; i++) {
        const float tw = text_w(fs, items[i]);
        const float bx0 = x - 10 * sc, bx1 = x + tw + 10 * sc;
        if (i == s.menu) {
            dl->AddRectFilled(ImVec2(bx0, 7 * sc), ImVec2(bx1, h - 7 * sc), COL_ACCENT, 1.0f);
            text(dl, x, 10 * sc, fs, IM_COL32(12, 12, 16, 255), items[i]);
        } else {
            if (i == s.hover_tab) {
                dl->AddRectFilled(ImVec2(bx0, 7 * sc), ImVec2(bx1, h - 7 * sc), COL_ROWSEL, 1.0f);
            }
            text(dl, x, 10 * sc, fs, i == s.hover_tab ? COL_ACCENT : COL_TEXT, items[i]);
        }
        hit_add(s, bx0, 4 * sc, bx1, h - 4 * sc, HitKind::Tab, i, Action::None);
        x += tw + 46.0f * sc;
    }
    const std::string brand = "RECOMPILATOR";
    text(dl, w - text_w(fs, brand) - 26 * sc, 10 * sc, fs, COL_ACCENT, brand);
}

// One item of the hint bar. `action` == None is a legend (UP/DOWN, LEFT/RIGHT): it says what a key
// does and is not clickable. Everything else is a real button that runs the SAME action the key
// runs - and it keeps the key letter in its label, because this stays a keyboard-first UI.
struct HintItem {
    const char* label;
    Action      action;
};

void hint_bar(ImDrawList* dl, float w, float h, float sc, const HintItem* items, int count,
              const std::string& right, UiState& s) {
    const float bh = 40.0f * sc;
    dl->AddRectFilled(ImVec2(0, h - bh), ImVec2(w, h), COL_BAR);
    dl->AddLine(ImVec2(0, h - bh), ImVec2(w, h - bh), IM_COL32(255, 176, 64, 110), 1.0f);
    const float fs = 18.0f * sc;
    const float ty = h - bh + 10 * sc;
    const float pad = 9.0f * sc;

    float x = 26 * sc;
    for (int i = 0; i < count; i++) {
        const std::string label = items[i].label;
        const float tw = text_w(fs, label);
        if (items[i].action == Action::None) {
            text(dl, x, ty, fs, COL_DIM, label);
            x += tw + 26.0f * sc;
            continue;
        }
        const bool hov = (s.hover_hint == i);
        const float bx0 = x - pad, bx1 = x + tw + pad;
        const float by0 = h - bh + 5 * sc, by1 = h - 5 * sc;
        dl->AddRectFilled(ImVec2(bx0, by0), ImVec2(bx1, by1), hov ? COL_ROWSEL : IM_COL32(0, 0, 0, 0), 2.0f);
        dl->AddRect(ImVec2(bx0, by0), ImVec2(bx1, by1), hov ? COL_ACCENT : COL_BTNBOX, 2.0f, 0, 1.0f);
        text(dl, x, ty, fs, hov ? COL_ACCENT : COL_TEXT, label);
        hit_add(s, bx0, by0, bx1, by1, HitKind::Hint, i, items[i].action);
        x += tw + 26.0f * sc + pad;
    }
    text(dl, w - text_w(fs, right) - 26 * sc, ty, fs, COL_DIM, right);
}

} // namespace

// ── the screens ──────────────────────────────────────────────────────────────
namespace {

void draw_archive(ImDrawList* dl, float w, float h, float sc, UiState& s) {
    top_bar(dl, w, sc, s);

    const float x0 = 34 * sc, x1 = w - 34 * sc;
    const float y0 = 70 * sc, y1 = h - 118 * sc;
    panel(dl, x0, y0, x1, y1);

    const float fs_head = 18.0f * sc;
    const float fs_row  = 24.0f * sc;
    const float col_title = x0 + 22 * sc;
    const float col_rel   = x0 + (x1 - x0) * 0.56f;
    const float col_state = x0 + (x1 - x0) * 0.76f;

    // ADD GAME, at the top of the archive where a person looks for it (2026-09-07). It runs
    // the same Action the A key runs - there is one path, and the button is on it.
    {
        const float fs_b = 20.0f * sc;
        const std::string label = "+  ADD GAME";
        const float tw = text_w(fs_b, label);
        const float bx1 = x1 - 16 * sc, bx0 = bx1 - tw - 28 * sc;
        const float by0 = y0 + 8 * sc,  by1 = y0 + 36 * sc;
        const bool hov = (s.hover_hint == 0);
        dl->AddRectFilled(ImVec2(bx0, by0), ImVec2(bx1, by1), hov ? COL_ACCENT : COL_ROWSEL, 2.0f);
        dl->AddRect(ImVec2(bx0, by0), ImVec2(bx1, by1), COL_ACCENT, 2.0f, 0, 1.0f);
        text(dl, bx0 + 14 * sc, by0 + 4 * sc, fs_b,
             hov ? IM_COL32(12, 12, 16, 255) : COL_ACCENT, label);
        hit_add(s, bx0, by0, bx1, by1, HitKind::Hint, 0, Action::AddRom);
    }

    text(dl, col_title, y0 + 14 * sc, fs_head, COL_DIM, "GAME");
    text(dl, col_rel,   y0 + 14 * sc, fs_head, COL_DIM, "RELEASED");
    text(dl, col_state, y0 + 14 * sc, fs_head, COL_DIM, "STATE");
    dl->AddLine(ImVec2(x0 + 12 * sc, y0 + 40 * sc), ImVec2(x1 - 12 * sc, y0 + 40 * sc),
                IM_COL32(255, 176, 64, 70), 1.0f);

    const float row_h = 40.0f * sc;
    const float y_first = y0 + 52 * sc;

    // How many rows the panel fits, and therefore how far the wheel may scroll. Measured here, in
    // the pass that actually lays the rows out, and handed to the wheel handler through the state.
    const int fits = (int)std::floor((y1 - y_first) / row_h);
    s.rows_visible = fits > 0 ? fits : 1;
    const int max_first = std::max(0, (int)s.entries.size() - s.rows_visible);
    if (s.list_scroll > max_first) s.list_scroll = max_first;
    if (s.list_scroll < 0)         s.list_scroll = 0;

    float y = y_first;
    for (size_t i = (size_t)s.list_scroll; i < s.entries.size(); i++) {
        if (y + row_h > y1) break;
        const CatalogEntry& e = s.entries[i];
        const bool sel = ((int)i == s.selected);
        const bool hov = ((int)i == s.hover_row);
        if (sel || hov) {
            dl->AddRectFilled(ImVec2(x0 + 8 * sc, y - 4 * sc), ImVec2(x1 - 8 * sc, y + row_h - 8 * sc),
                              sel ? COL_ROWSEL : COL_ROWHOV, 1.0f);
        }
        if (sel) {
            dl->AddRectFilled(ImVec2(x0 + 8 * sc, y - 4 * sc), ImVec2(x0 + 12 * sc, y + row_h - 8 * sc),
                              COL_ACCENT);
        }
        text(dl, col_title, y, fs_row, sel ? COL_ACCENT : COL_TEXT,
             clip(fs_row, e.title, col_rel - col_title - 20 * sc));
        text(dl, col_rel, y + 2 * sc, 20.0f * sc, COL_DIM, e.release.empty() ? "-" : e.release);
        text(dl, col_state, y + 2 * sc, 20.0f * sc, state_colour(e.state_label), e.state_label);
        // The row's own band, edge to edge and with no gap to the next one.
        hit_add(s, x0 + 8 * sc, y - 4 * sc, x1 - 8 * sc, y + row_h - 4 * sc, HitKind::Row, (int)i,
                Action::None);
        y += row_h;
    }

    // The list is longer than the panel: say so, and say what scrolls it.
    if ((int)s.entries.size() > s.rows_visible) {
        char more[96];
        std::snprintf(more, sizeof(more), "%d more below - mouse wheel scrolls",
                      (int)s.entries.size() - s.list_scroll - s.rows_visible);
        if ((int)s.entries.size() - s.list_scroll - s.rows_visible > 0) {
            text(dl, col_title, y1 - 24 * sc, 16.0f * sc, COL_DIM, more);
        }
    }

    if (s.entries.empty()) {
        // The FIRST screen of a fresh install: a release ships no games (2026-09-07), so this
        // is what every new user sees. Say what to do, not what is missing.
        text(dl, col_title, y0 + 56 * sc, fs_row, COL_TEXT,
             "No games yet.");
        text(dl, col_title, y0 + 84 * sc, fs_row, COL_DIM,
             "Press A to add a ROM you own - it is recompiled and built here, on this machine.");
    }

    // The selected entry's ROM hash + last played.
    const float fs_small = 18.0f * sc;
    float dy = y1 + 10 * sc;
    if (!s.entries.empty() && s.selected >= 0 && s.selected < (int)s.entries.size()) {
        const CatalogEntry& e = s.entries[s.selected];
        text(dl, x0 + 2 * sc, dy, fs_small, COL_DIM, "ROM SHA1  " + (e.sha1.empty() ? "-" : e.sha1));
        text(dl, x0 + 2 * sc, dy + 22 * sc, fs_small, COL_DIM,
             "LAST PLAYED  " + e.last_played + "     TREE  " + e.game + "pc" +
             (e.exe_path.empty() ? "  (no exe built)" : ""));
    }

    static const HintItem LIB_HINTS[] = {
        { "UP/DOWN select",  Action::None   },
        { "ENTER play",      Action::Enter  },
        { "A add rom",       Action::AddRom },
        { "B build",         Action::Build  },
        { "LEFT/RIGHT menu", Action::None   },
        { "Q quit",          Action::Quit   },
    };
    hint_bar(dl, w, h, sc, LIB_HINTS, (int)(sizeof(LIB_HINTS) / sizeof(LIB_HINTS[0])), s.status, s);
}

void draw_addrom(ImDrawList* dl, float w, float h, float sc, UiState& s) {
    top_bar(dl, w, sc, s);

    const float x0 = w * 0.12f, x1 = w * 0.88f;
    const float y0 = h * 0.24f, y1 = h * 0.70f;
    panel(dl, x0, y0, x1, y1);

    const float fs_h = 26.0f * sc, fs = 21.0f * sc;
    text(dl, x0 + 26 * sc, y0 + 20 * sc, fs_h, COL_ACCENT, "ADD ROM");
    dl->AddLine(ImVec2(x0 + 22 * sc, y0 + 56 * sc), ImVec2(x1 - 22 * sc, y0 + 56 * sc),
                IM_COL32(255, 176, 64, 70), 1.0f);

    float y = y0 + 76 * sc;
    if (s.add_busy) {
        text(dl, x0 + 26 * sc, y, fs, COL_TEXT, "the file dialog is open - choose a ROM");
    } else {
        text(dl, x0 + 26 * sc, y, fs, COL_DIM, "FILE");
        text(dl, x0 + 130 * sc, y, fs, COL_TEXT,
             clip(fs, s.add_path.empty() ? "(none)" : s.add_path, x1 - x0 - 160 * sc));
        y += 34 * sc;
        if (!s.add_member.empty()) {
            text(dl, x0 + 26 * sc, y, fs, COL_DIM, "MEMBER");
            text(dl, x0 + 130 * sc, y, fs, COL_TEXT, clip(fs, s.add_member, x1 - x0 - 160 * sc));
            y += 34 * sc;
        }
        text(dl, x0 + 26 * sc, y, fs, COL_DIM, "SHA1");
        text(dl, x0 + 130 * sc, y, fs, COL_TEXT, s.add_sha1.empty() ? "-" : s.add_sha1);
        y += 34 * sc;
        // WHAT THE CART SAYS ABOUT ITSELF - the only thing the program knows about a new game.
        if (!s.add_cart.empty()) {
            text(dl, x0 + 26 * sc, y, fs, COL_DIM, "CART");
            text(dl, x0 + 130 * sc, y, fs, COL_TEXT, clip(fs, s.add_cart, x1 - x0 - 160 * sc));
            y += 34 * sc;
        }
        y += 12 * sc;
        const bool ok = s.add_verdict.rfind("Recognised", 0) == 0;
        text(dl, x0 + 26 * sc, y, 26.0f * sc, ok ? COL_PLAYS : COL_ACCENT, s.add_verdict);
        y += 40 * sc;
        for (const std::string& m : s.add_matches) {
            text(dl, x0 + 46 * sc, y, fs, COL_DIM, m);
            y += 28 * sc;
        }
        if (s.add_unknown) {
            text(dl, x0 + 46 * sc, y, fs, COL_TEXT,
                 "ENTER recompiles it here, from the cartridge's own bytes.");
            y += 28 * sc;
            text(dl, x0 + 46 * sc, y, fs, COL_DIM,
                 "Nothing about this game shipped with the program; nothing is downloaded.");
        } else if (ok) {
            // THE CHOICE IS THE USER'S. A recipe is what this project worked out about one dump of
            // the game; blind is the program reading the cartridge in hand. Offer both, say which
            // is which, and keep both builds.
            text(dl, x0 + 46 * sc, y, fs, COL_TEXT,
                 "ENTER builds it from the shipped recipe: notes on how this cartridge is laid out.");
            y += 28 * sc;
            text(dl, x0 + 46 * sc, y, fs, COL_DIM,
                 "B sets the recipe aside and works the cartridge out from its own bytes instead.");
        }
    }

    // While the NATIVE file dialog is up it owns the mouse, so this screen offers no buttons then.
    static const HintItem ADD_UNKNOWN[] = {
        { "ENTER build this cartridge", Action::Enter  },
        { "ESC back",                   Action::Escape },
    };
    static const HintItem ADD_KNOWN[] = {
        { "ENTER build from the recipe", Action::Enter  },
        { "B build blind instead",       Action::Build  },
        { "ESC back",                    Action::Escape },
    };
    if (s.add_busy) {
        static const HintItem ADD_BUSY[] = { { "choose a ROM in the file dialog", Action::None } };
        hint_bar(dl, w, h, sc, ADD_BUSY, 1, s.status, s);
    } else if (s.add_unknown) {
        hint_bar(dl, w, h, sc, ADD_UNKNOWN, 2, s.status, s);
    } else {
        hint_bar(dl, w, h, sc, ADD_KNOWN, 3, s.status, s);
    }
}

// The BUILD screen is the console's TELEMETRY TERMINAL, in its image. STEP 2: every row, every
// time and every evidence string below comes from a STAGE line printed by
// recompilator/tools/build_entry.ps1 — the launcher fabricates nothing and runs no pipeline logic.
//
// The seed list is only what is shown as `waiting` before the driver's first line arrives; the
// driver's own STAGE lines name and number the rows it actually runs (a catalog entry carrying
// tools/gen_ni_data.py runs one more, which is why NI SECTION DATA is seeded conditionally).
const char* const SEED_STAGES[] = {
    "RECOGNISED", "BYTE-EXACT ELF", "SYMBOLS + RECOMPILER", "RSP MICROCODE", "COMPILE", "RESULT",
};

// A CART IN NO CATALOG runs the blind path, which has two more rows: the tree is authored from the
// cartridge's own bytes, and the code-vs-data segmentation is refined until it holds. In a release,
// where no catalog ships, this is the list every build starts from.
const char* const BLIND_SEED_STAGES[] = {
    "RECOGNISED", "BRING-UP", "BYTE-EXACT ELF", "SEGMENTATION",
    "SYMBOLS + RECOMPILER", "RSP MICROCODE", "COMPILE", "RESULT",
};

void draw_build(ImDrawList* dl, float w, float h, float sc, UiState& s, double t) {
    top_bar(dl, w, sc, s);

    const float x0 = w * 0.06f, x1 = w * 0.94f;
    const float y0 = h * 0.11f, y1 = h - 56 * sc;
    dl->AddRectFilled(ImVec2(x0, y0), ImVec2(x1, y1), IM_COL32(4, 6, 8, 235), 2.0f);
    dl->AddRect(ImVec2(x0, y0), ImVec2(x1, y1), COL_ACCENT, 2.0f, 0, 1.5f);

    const float fs_h = 24.0f * sc, fs = 21.0f * sc, fs_s = 16.0f * sc;
    text(dl, x0 + 24 * sc, y0 + 14 * sc, fs_h, COL_ACCENT,
         "RECOMPILATOR // BUILD   " + s.build_title);
    text(dl, x0 + 24 * sc, y0 + 42 * sc, fs_s, COL_DIM,
         clip(fs_s, s.build_cmd, x1 - x0 - 48 * sc));
    // THE PROGRESS BAR, and it is a real one (2026-09-07: a real progress bar, not
    // a dummy animation). No stage knows its own duration in advance, so there is nothing honest
    // to say about how far through a stage we are - but STAGES DONE OUT OF STAGES TOTAL is exactly
    // true, and it is what a person wants to know. The bar fills a stage at a time and the label
    // says which one is running.
    {
        const int total = (int)s.build_stages.size();
        int done = 0, working = -1;
        for (int i = 0; i < total; i++) {
            if (s.build_stages[i].status == StageStatus::Ok)   done++;
            if (s.build_stages[i].status == StageStatus::Working && working < 0) working = i;
        }
        const float bx0 = x0 + 24 * sc, bx1 = x1 - 24 * sc;
        const float by = y0 + 74 * sc, bh = 16.0f * sc;
        const float frac = total > 0 ? (float)done / (float)total : 0.0f;
        dl->AddRectFilled(ImVec2(bx0, by), ImVec2(bx1, by + bh), IM_COL32(255, 255, 255, 24), 2.0f);
        if (frac > 0.0f) {
            dl->AddRectFilled(ImVec2(bx0, by), ImVec2(bx0 + (bx1 - bx0) * frac, by + bh),
                              s.build_failed ? COL_NOTR : COL_PLAYS, 2.0f);
        }
        // the stage now running, drawn as the next slot lit dimly - never past what has finished
        if (working >= 0 && total > 0) {
            const float sw = (bx1 - bx0) / (float)total;
            const float wx = bx0 + sw * (float)working;
            dl->AddRectFilled(ImVec2(wx, by), ImVec2(wx + sw, by + bh), IM_COL32(255, 176, 64, 70), 2.0f);
        }
        dl->AddRect(ImVec2(bx0, by), ImVec2(bx1, by + bh), IM_COL32(255, 176, 64, 110), 2.0f, 0, 1.0f);

        char lab[128];
        if (s.build_failed) {
            snprintf(lab, sizeof(lab), "STOPPED after %d of %d", done, total);
        } else if (working >= 0) {
            snprintf(lab, sizeof(lab), "STEP %d OF %d   %s", working + 1, total,
                     s.build_stages[working].name.c_str());
        } else if (total > 0 && done == total) {
            snprintf(lab, sizeof(lab), "DONE   %d of %d", done, total);
        } else {
            snprintf(lab, sizeof(lab), "%d of %d", done, total);
        }
        text(dl, bx0, by + bh + 5 * sc, fs_s, COL_DIM, lab);
        const std::string pct = std::to_string((int)(frac * 100.0f + 0.5f)) + "%";
        text(dl, bx1 - text_w(fs_s, pct), by + bh + 5 * sc, fs_s, COL_DIM, pct);
    }
    dl->AddLine(ImVec2(x0 + 20 * sc, y0 + 116 * sc), ImVec2(x1 - 20 * sc, y0 + 116 * sc),
                IM_COL32(255, 176, 64, 90), 1.0f);

    const float cx_stage  = x0 + 30 * sc;
    const float cx_status = x0 + (x1 - x0) * 0.60f;
    const float cx_time   = x1 - 150 * sc;
    text(dl, cx_stage,  y0 + 126 * sc, fs_s, COL_DIM, "STAGE");
    text(dl, cx_status, y0 + 126 * sc, fs_s, COL_DIM, "STATUS");
    text(dl, cx_time,   y0 + 126 * sc, fs_s, COL_DIM, "ELAPSED");

    float y = y0 + 152 * sc;
    const float row = 50.0f * sc;

    for (size_t i = 0; i < s.build_stages.size(); i++) {
        const BuildStage& st = s.build_stages[i];
        ImU32 col = COL_DIM;
        std::string status = "waiting";
        double shown = 0.0;
        bool have_time = false;
        float frac = 0.0f;

        switch (st.status) {
        case StageStatus::Working:
            col = COL_ACCENT;
            status = ((int)(t * 2.0) % 2 == 0) ? "working _" : "working";
            shown = t - st.started; have_time = true;
            // No duration is known in advance, so the rail SWEEPS rather than lying about a fraction.
            frac = 0.5f + 0.5f * std::sin((float)t * 2.2f);
            break;
        case StageStatus::Ok:
            col = COL_PLAYS; status = "OK"; shown = st.seconds; have_time = true; frac = 1.0f;
            break;
        case StageStatus::Fail:
            col = COL_NOTR; status = "FAIL"; shown = st.seconds; have_time = true; frac = 1.0f;
            break;
        default: break;
        }

        text(dl, cx_stage,  y, fs, col, st.name);
        text(dl, cx_status, y, fs, col, status);
        text(dl, cx_time,   y, fs, col, have_time ? mmss(shown) : "  --  ");

        const float rx0 = cx_stage, rx1 = cx_status - 30 * sc;
        dl->AddRectFilled(ImVec2(rx0, y + 25 * sc), ImVec2(rx1, y + 28 * sc), IM_COL32(255, 255, 255, 22));
        if (st.status == StageStatus::Working) {
            const float ww = (rx1 - rx0) * 0.22f;
            const float rx = rx0 + (rx1 - rx0 - ww) * frac;
            dl->AddRectFilled(ImVec2(rx, y + 25 * sc), ImVec2(rx + ww, y + 28 * sc), col);
        } else if (st.status != StageStatus::Waiting) {
            dl->AddRectFilled(ImVec2(rx0, y + 25 * sc), ImVec2(rx1, y + 28 * sc), col);
        }

        // The evidence line the stage ended on, verbatim from the driver.
        if (!st.evidence.empty()) {
            text(dl, cx_stage + 14 * sc, y + 30 * sc, fs_s,
                 st.status == StageStatus::Fail ? COL_NOTR : COL_DIM,
                 clip(fs_s, st.evidence, x1 - cx_stage - 60 * sc));
        }
        y += row;
    }

    // TOTAL, live while the child runs; the RESULT line once it has printed one.
    const double total = (s.build_end > 0.0) ? (s.build_end - s.build_start) : (t - s.build_start);
    y += 8 * sc;
    if (!s.build_result.empty()) {
        text(dl, cx_stage, y, fs, s.build_failed ? COL_NOTR : COL_PLAYS,
             clip(fs, s.build_result, x1 - cx_stage - 40 * sc));
    } else {
        text(dl, cx_stage, y, fs, COL_DIM, "TOTAL   " + mmss(total));
    }
    y += 34 * sc;

    // The child's non-protocol output (PowerShell errors and the like), last lines only.
    if (!s.build_tail.empty()) {
        dl->AddLine(ImVec2(x0 + 20 * sc, y - 6 * sc), ImVec2(x1 - 20 * sc, y - 6 * sc),
                    IM_COL32(255, 176, 64, 50), 1.0f);
        for (const std::string& l : s.build_tail) {
            if (y + 20 * sc > y1) break;
            text(dl, cx_stage, y, fs_s, COL_DIM, clip(fs_s, l, x1 - cx_stage - 40 * sc));
            y += 20 * sc;
        }
    }

    // The ONLY clickable thing on this screen, by design: cancel while it runs, back when it is done.
    static const HintItem BUILD_RUNNING[] = {
        { "ESC cancel (the whole build is killed)", Action::Escape },
    };
    static const HintItem BUILD_DONE[] = {
        { "ENTER / ESC back to the library", Action::Escape },
    };
    if (s.build_running) hint_bar(dl, w, h, sc, BUILD_RUNNING, 1, s.status, s);
    else                 hint_bar(dl, w, h, sc, BUILD_DONE,    1, s.status, s);
}

void draw_play(ImDrawList* dl, float w, float h, float sc, UiState& s) {
    top_bar(dl, w, sc, s);
    const float x0 = w * 0.18f, x1 = w * 0.82f;
    const float y0 = h * 0.38f, y1 = h * 0.58f;
    panel(dl, x0, y0, x1, y1);
    text(dl, x0 + 26 * sc, y0 + 22 * sc, 26.0f * sc, COL_ACCENT, "PLAYING   " + s.play_title);
    text(dl, x0 + 26 * sc, y0 + 62 * sc, 19.0f * sc, COL_DIM,
         clip(19.0f * sc, s.play_exe, x1 - x0 - 52 * sc));
    text(dl, x0 + 26 * sc, y0 + 92 * sc, 19.0f * sc, COL_DIM,
         "the launcher is minimised while the game runs; it returns here when the game exits");
    static const HintItem PLAY_HINTS[] = { { "ESC  leave the game", Action::None } };
    hint_bar(dl, w, h, sc, PLAY_HINTS, 1, s.status, s);
}

// LEAVE THE GAME? — drawn OVER the running game, because that is when it is asked. Esc, or the
// pad's middle button, puts it up; it never drops a game without asking (2026-09-07).
// Two builds are the same GAME when the cartridges call themselves the same thing. Not by id:
// ids are disambiguated with a numeric suffix, and "turok" + "2" is Turok 2, a different game
// entirely, so grouping on the suffix would file unrelated titles together.
std::string rev_group_key(const CatalogEntry& e) {
    std::string k = e.title.empty() ? e.game : e.title;
    std::string out;
    for (char c : k) {
        if (std::isalnum((unsigned char)c)) out += (char)std::tolower((unsigned char)c);
    }
    return out;
}

// Every build of the game on the given row, that row included, in list order.
std::vector<int> rev_siblings_locked(const UiState& s, int row) {
    std::vector<int> out;
    if (row < 0 || row >= (int)s.entries.size()) return out;
    const std::string key = rev_group_key(s.entries[row]);
    for (int i = 0; i < (int)s.entries.size(); i++) {
        if (rev_group_key(s.entries[i]) == key) out.push_back(i);
    }
    return out;
}

void draw_rev_prompt(ImDrawList* dl, float w, float h, float sc, UiState& s) {
    dl->AddRectFilled(ImVec2(0, 0), ImVec2(w, h), IM_COL32(0, 0, 0, 150));
    const int rows = (int)s.rev_rows.size();
    const float bw = 760 * sc;
    const float bh = (150 + 46 * rows) * sc;
    const float x0 = (w - bw) * 0.5f, y0 = (h - bh) * 0.5f, x1 = x0 + bw, y1 = y0 + bh;
    dl->AddRectFilled(ImVec2(x0, y0), ImVec2(x1, y1), IM_COL32(10, 12, 18, 245), 3.0f);
    dl->AddRect(ImVec2(x0, y0), ImVec2(x1, y1), COL_ACCENT, 3.0f, 0, 2.0f);

    const float fs = 26.0f * sc, fs_s = 17.0f * sc, fs_r = 20.0f * sc;
    std::string head = "Which one?";
    if (!s.rev_rows.empty()) {
        const CatalogEntry& first = s.entries[s.rev_rows[0]];
        head = first.title.empty() ? first.game : first.title;
    }
    text(dl, x0 + (bw - text_w(fs, head)) * 0.5f, y0 + 22 * sc, fs, COL_ACCENT, head);
    const std::string sub = "this game is here more than once - pick the cartridge to start";
    text(dl, x0 + (bw - text_w(fs_s, sub)) * 0.5f, y0 + 58 * sc, fs_s, COL_DIM, sub);

    float ry = y0 + 92 * sc;
    for (int i = 0; i < rows; i++) {
        const CatalogEntry& e = s.entries[s.rev_rows[i]];
        const bool on = (i == s.rev_sel);
        const float p0 = x0 + 22 * sc, p1 = x1 - 22 * sc, q0 = ry, q1 = ry + 40 * sc;
        if (on) dl->AddRectFilled(ImVec2(p0, q0), ImVec2(p1, q1), COL_ROWSEL, 2.0f);
        // The id and the cartridge's own hash are what actually tell two dumps apart.
        std::string left = e.game;
        std::string right = (e.sha1.size() >= 8 ? e.sha1.substr(0, 8) : e.sha1);
        if (right.empty()) right = "no hash";
        right += e.module_path.empty() && e.exe_path.empty() ? "   NOT BUILT" : "   BUILT";
        text(dl, p0 + 12 * sc, q0 + 9 * sc, fs_r, on ? COL_ACCENT : COL_TEXT, left);
        text(dl, p1 - 12 * sc - text_w(fs_r, right), q0 + 9 * sc, fs_r, COL_DIM, right);
        hit_add(s, p0, q0, p1, q1, HitKind::Hint, i, Action::Enter);
        ry += 46 * sc;
    }
    const std::string foot = "ENTER start    ESC cancel";
    text(dl, x0 + (bw - text_w(fs_s, foot)) * 0.5f, y1 - 32 * sc, fs_s, COL_DIM, foot);
}

void draw_exit_prompt(ImDrawList* dl, float w, float h, float sc, UiState& s) {
    dl->AddRectFilled(ImVec2(0, 0), ImVec2(w, h), IM_COL32(0, 0, 0, 150));
    const float bw = 560 * sc, bh = 200 * sc;
    const float x0 = (w - bw) * 0.5f, y0 = (h - bh) * 0.5f, x1 = x0 + bw, y1 = y0 + bh;
    dl->AddRectFilled(ImVec2(x0, y0), ImVec2(x1, y1), IM_COL32(10, 12, 18, 245), 3.0f);
    dl->AddRect(ImVec2(x0, y0), ImVec2(x1, y1), COL_ACCENT, 3.0f, 0, 2.0f);

    const float fs = 26.0f * sc;
    const std::string q = "Leave the game?";
    text(dl, x0 + (bw - text_w(fs, q)) * 0.5f, y0 + 26 * sc, fs, COL_ACCENT, q);
    const float fs_s = 17.0f * sc;
    const std::string sub = s.play_in_process
        ? "the program restarts and you land back on the archive"
        : "the game closes and you go back to the archive";
    text(dl, x0 + (bw - text_w(fs_s, sub)) * 0.5f, y0 + 66 * sc, fs_s, COL_DIM, sub);

    const char* labels[2] = { "YES", "NO" };
    const float bwid = 150 * sc, bhei = 48 * sc;
    const float gap = 30 * sc;
    float bx = x0 + (bw - (bwid * 2 + gap)) * 0.5f;
    for (int i = 0; i < 2; i++) {
        const bool on = (i == 0) == s.exit_yes;
        const float p0 = bx, p1 = bx + bwid, q0 = y1 - bhei - 26 * sc, q1 = q0 + bhei;
        dl->AddRectFilled(ImVec2(p0, q0), ImVec2(p1, q1), on ? COL_ACCENT : COL_ROWSEL, 2.0f);
        dl->AddRect(ImVec2(p0, q0), ImVec2(p1, q1), COL_ACCENT, 2.0f, 0, 1.0f);
        const float lw = text_w(fs, labels[i]);
        text(dl, p0 + (bwid - lw) * 0.5f, q0 + 8 * sc, fs,
             on ? IM_COL32(12, 12, 16, 255) : COL_TEXT, labels[i]);
        hit_add(s, p0, q0, p1, q1, HitKind::Hint, i, i == 0 ? Action::Enter : Action::Escape);
        bx += bwid + gap;
    }
}

// ── the settings screens ──────────────────────────────────────────────────────
// One row is one setting that DOES something. There are no placeholder rows and no gauges that
// show a number nothing reads: a row exists here only because Enter on it changes the running
// program (2026-09-07: no dummy gauges).
void option_row(ImDrawList* dl, float x0, float x1, float y, float sc, UiState& s, int idx,
                const std::string& name, const std::string& value, const std::string& note) {
    const float fs = 22.0f * sc, fs_s = 16.0f * sc;
    const bool sel = (idx == s.opt_sel);
    if (sel) {
        dl->AddRectFilled(ImVec2(x0 + 8 * sc, y - 5 * sc), ImVec2(x1 - 8 * sc, y + 34 * sc),
                          COL_ROWSEL, 1.0f);
        dl->AddRectFilled(ImVec2(x0 + 8 * sc, y - 5 * sc), ImVec2(x0 + 12 * sc, y + 34 * sc), COL_ACCENT);
    }
    text(dl, x0 + 26 * sc, y, fs, sel ? COL_ACCENT : COL_TEXT, name);
    if (!value.empty()) {
        text(dl, x0 + (x1 - x0) * 0.56f, y, fs, sel ? COL_ACCENT : COL_TEXT, value);
    }
    if (!note.empty()) text(dl, x0 + 26 * sc, y + 20 * sc, fs_s, COL_DIM, note);
}

void settings_frame(ImDrawList* dl, float w, float h, float sc, UiState& s,
                    const std::string& heading, float& x0, float& x1, float& y) {
    top_bar(dl, w, sc, s);
    x0 = 34 * sc; x1 = w - 34 * sc;
    const float y0 = 70 * sc, y1 = h - 118 * sc;
    panel(dl, x0, y0, x1, y1);
    text(dl, x0 + 22 * sc, y0 + 14 * sc, 18.0f * sc, COL_DIM, heading);
    dl->AddLine(ImVec2(x0 + 12 * sc, y0 + 40 * sc), ImVec2(x1 - 12 * sc, y0 + 40 * sc),
                IM_COL32(255, 176, 64, 70), 1.0f);
    y = y0 + 58 * sc;
}

void draw_video(ImDrawList* dl, float w, float h, float sc, UiState& s) {
    float x0 = 0, x1 = 0, y = 0;
    settings_frame(dl, w, h, sc, s, "VIDEO", x0, x1, y);
    const float row = 52 * sc;
    int n = 0;
    if (g_app != nullptr) {
        const RT64::UserConfiguration& c = g_app->userConfig;
        char buf[64];
        snprintf(buf, sizeof(buf), "%.1fx", c.resolutionMultiplier);
        static const char* AA[] = { "off", "MSAA 2x", "MSAA 4x", "MSAA 8x" };
        static const char* FI[] = { "nearest", "linear", "anti-aliased pixel scaling" };
        static const char* AR[] = { "original 4:3", "expand to the window", "manual" };
        static const char* DB[] = { "double", "triple" };
        const int ia = std::clamp((int)c.antialiasing, 0, 3);
        const int fi = std::clamp((int)c.filtering, 0, 2);
        const int ar = std::clamp((int)c.aspectRatio, 0, 2);
        const int db = std::clamp((int)c.displayBuffering, 0, 1);
        option_row(dl, x0, x1, y, sc, s, n++, "Internal resolution", buf,
                   "how much detail the game is drawn at before it reaches your screen"); y += row;
        option_row(dl, x0, x1, y, sc, s, n++, "Antialiasing", AA[ia],
                   "smooths the stepped edges of polygons"); y += row;
        option_row(dl, x0, x1, y, sc, s, n++, "Texture filtering", FI[fi],
                   "nearest keeps the original hard pixels"); y += row;
        option_row(dl, x0, x1, y, sc, s, n++, "Aspect ratio", AR[ar],
                   "original is the shape the game was made for"); y += row;
        option_row(dl, x0, x1, y, sc, s, n++, "Display buffering", DB[db],
                   "triple can be smoother and adds a little delay"); y += row;
        option_row(dl, x0, x1, y, sc, s, n++, "Three-point filtering",
                   c.threePointFiltering ? "on" : "off",
                   "the console's own way of blending texture pixels"); y += row;
    } else {
        text(dl, x0 + 26 * sc, y, 20.0f * sc, COL_DIM, "the renderer is not up yet");
    }
    option_row(dl, x0, x1, y + 14 * sc, sc, s, -1, "Everything else", "F1",
               "F1 opens the renderer's own options, at any time, including while a game runs");
    s.opt_count = n;
    if (s.opt_sel >= n) s.opt_sel = n > 0 ? n - 1 : 0;
    static const HintItem HINTS[] = {
        { "UP/DOWN  choose", Action::None }, { "ENTER  change", Action::Enter },
        { "LEFT/RIGHT  tab", Action::None }, { "ESC  archive", Action::Escape },
    };
    hint_bar(dl, w, h, sc, HINTS, 4, s.status, s);
}

void draw_audio(ImDrawList* dl, float w, float h, float sc, UiState& s) {
    float x0 = 0, x1 = 0, y = 0;
    settings_frame(dl, w, h, sc, s, "AUDIO", x0, x1, y);
    const float row = 52 * sc;
    char hz[64];
    snprintf(hz, sizeof(hz), "%u Hz", (unsigned)launcher::audio_frequency());
    option_row(dl, x0, x1, y, sc, s, -1, "Output rate", hz,
               "set by the game, not by you: each cartridge asks for its own rate"); y += row;
    option_row(dl, x0, x1, y, sc, s, -1, "Volume", "system",
               "the Windows volume mixer controls this program like any other"); y += row;
    option_row(dl, x0, x1, y, sc, s, -1, "Microcode", "from the cartridge",
               "each game's own sound program is recompiled from the cartridge you supplied");
    s.opt_count = 0;
    s.opt_sel = 0;
    static const HintItem HINTS[] = {
        { "LEFT/RIGHT  tab", Action::None }, { "ESC  archive", Action::Escape },
    };
    hint_bar(dl, w, h, sc, HINTS, 2, s.status, s);
}

void draw_controls(ImDrawList* dl, float w, float h, float sc, UiState& s) {
    float x0 = 0, x1 = 0, y = 0;
    settings_frame(dl, w, h, sc, s, "CONTROLS", x0, x1, y);
    const float row = 40 * sc;
    struct Bind { const char* what; const char* pad; const char* key; };
    static const Bind BINDS[] = {
        { "A",            "A",              "Z" },
        { "B",            "B",              "X" },
        { "Z",            "Back",           "Left Shift" },
        { "Start",        "Start",          "Enter" },
        { "L / R",        "Shoulders",      "A / S" },
        { "Stick",        "Left stick",     "Arrow keys" },
        { "C buttons",    "Right stick",    "I J K L" },
        { "D-pad",        "D-pad",          "Numpad" },
        { "Leave a game", "-",              "Esc" },
    };
    const float fs = 21.0f * sc, fs_h = 16.0f * sc;
    const float cw = x0 + (x1 - x0) * 0.40f, ck = x0 + (x1 - x0) * 0.68f;
    text(dl, x0 + 26 * sc, y, fs_h, COL_DIM, "N64");
    text(dl, cw,           y, fs_h, COL_DIM, "GAMEPAD");
    text(dl, ck,           y, fs_h, COL_DIM, "KEYBOARD");
    y += 30 * sc;
    for (const Bind& b : BINDS) {
        const bool leave = (b.what[0] == 'L' && b.what[1] == 'e');
        text(dl, x0 + 26 * sc, y, fs, leave ? COL_ACCENT : COL_TEXT, b.what);
        text(dl, cw,           y, fs, leave ? COL_ACCENT : COL_TEXT, b.pad);
        text(dl, ck,           y, fs, leave ? COL_ACCENT : COL_TEXT, b.key);
        y += row;
    }
    text(dl, x0 + 26 * sc, y + 10 * sc, 16.0f * sc, COL_DIM,
         "fixed for now - these are what the program reads, written down so you do not have to guess");
    s.opt_count = 0;
    s.opt_sel = 0;
    static const HintItem HINTS[] = {
        { "LEFT/RIGHT  tab", Action::None }, { "ESC  archive", Action::Escape },
    };
    hint_bar(dl, w, h, sc, HINTS, 2, s.status, s);
}

} // namespace

// ── the render hook ──────────────────────────────────────────────────────────
static void draw_hook(RenderCommandList* list, RenderFramebuffer* swapChainFramebuffer) {
    if (!g_ready.load(std::memory_order_acquire) || g_ctx == nullptr || list == nullptr ||
        swapChainFramebuffer == nullptr) {
        return;
    }

    ImGuiContext* previous = ImGui::GetCurrentContext();
    ImGui::SetCurrentContext(g_ctx);

    const float w = (float)swapChainFramebuffer->getWidth();
    const float h = (float)swapChainFramebuffer->getHeight();
    if (w < 8.0f || h < 8.0f) { ImGui::SetCurrentContext(previous); return; }

    // The framebuffer this frame was laid out in. SDL reports the mouse in WINDOW coordinates, and
    // the two are only equal while no scaling is in play, so the pump converts through this pair.
    g_fb_w.store((int)w, std::memory_order_relaxed);
    g_fb_h.store((int)h, std::memory_order_relaxed);

    static double last_t = now_seconds();
    const double t  = now_seconds();
    float dt = (float)(t - last_t);
    last_t = t;
    if (dt <= 0.0f)  dt = 1.0f / 60.0f;
    if (dt > 0.25f)  dt = 0.25f;

    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize = ImVec2(w, h);
    io.DeltaTime   = dt;

#if defined(_WIN32)
    ImGui_ImplDX12_NewFrame();
#endif
    ImGui::NewFrame();

    // A game module is drawing this window: the launcher must not paint one pixel over it. This
    // is the whole difference between "the game runs in the launcher's window" and "the launcher
    // covers the game with a starfield".
    //
    // ONE EXCEPTION: the leave-the-game question. It is asked WHILE the game is on screen, so it
    // is the only thing that may be drawn over one - and without this the question was invisible,
    // which is why Esc looked like it did nothing (2026-09-07: neither Esc nor the pad's
    // middle button appeared to work).
    if (g_game_in_process.load(std::memory_order_acquire)) {
        bool asking = false;
        {
            UiState& s = ui();
            std::lock_guard<std::mutex> lock(s.mutex);
            asking = s.exit_prompt;
        }
        if (!asking) {
            ImGui::EndFrame();
            ImGui::SetCurrentContext(previous);
            return;
        }
        ImDrawList* dl_q = ImGui::GetBackgroundDrawList();
        const float sc_q = std::clamp(h / 900.0f, 0.70f, 2.2f);
        {
            UiState& s = ui();
            std::lock_guard<std::mutex> lock(s.mutex);
            s.hit.clear();
            draw_exit_prompt(dl_q, w, h, sc_q, s);
        }
        ImGui::Render();
#if defined(_WIN32)
        ImDrawData* qdata = ImGui::GetDrawData();
        if (qdata != nullptr) {
            D3D12CommandList* qlist = static_cast<D3D12CommandList*>(list);
            qlist->checkDescriptorHeaps();
            ImGui_ImplDX12_RenderDrawData(qdata, qlist->d3d);
        }
#endif
        ImGui::SetCurrentContext(previous);
        return;
    }

    ImDrawList* dl = ImGui::GetBackgroundDrawList();
    dl->AddRectFilled(ImVec2(0, 0), ImVec2(w, h), IM_COL32(0, 0, 0, 255));
    starfield(dl, w, h, dt);

    const float sc = std::clamp(h / 900.0f, 0.70f, 2.2f);
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        // The hit rectangles are only ever the ones THIS frame drew: cleared here, refilled by the
        // screen below, read by the main-thread pump on the next mouse event or tick.
        s.hit.clear();
        switch (s.screen) {
        case Screen::Archive:  draw_archive (dl, w, h, sc, s); break;
        case Screen::AddRom:   draw_addrom  (dl, w, h, sc, s); break;
        case Screen::Build:    draw_build   (dl, w, h, sc, s, t); break;
        case Screen::Play:     draw_play    (dl, w, h, sc, s); break;
        case Screen::Video:    draw_video   (dl, w, h, sc, s); break;
        case Screen::Audio:    draw_audio   (dl, w, h, sc, s); break;
        case Screen::Controls: draw_controls(dl, w, h, sc, s); break;
        }
        // The leave-the-game question is drawn LAST, over whatever is beneath it.
        if (s.exit_prompt) draw_exit_prompt(dl, w, h, sc, s);
        if (s.rev_prompt)  draw_rev_prompt(dl, w, h, sc, s);

        // WHAT THIS FRAME MADE CLICKABLE, written down once per layout — not once per frame. It is
        // the mouse's own evidence (the bench aims its clicks at these numbers) and the only way to
        // see, without eyes on the screen, that a rectangle is where the pixels are.
        {
            size_t hsh = (size_t)s.screen * 1315423911u + s.hit.size() * 2654435761u;
            for (const HitRect& r : s.hit) {
                hsh = hsh * 1000003u ^ (size_t)(int)(r.x0 * 4.0f);
                hsh = hsh * 1000003u ^ (size_t)(int)(r.y0 * 4.0f);
                hsh = hsh * 1000003u ^ (size_t)(int)(r.x1 * 4.0f);
                hsh = hsh * 1000003u ^ (size_t)(int)(r.y1 * 4.0f);
                hsh = hsh * 1000003u ^ (size_t)(r.index * 131 + (int)r.kind * 17 + (int)r.action);
            }
            static size_t last_hash = 0;
            if (hsh != last_hash) {
                last_hash = hsh;
                fprintf(stderr, "[launcher] hitlayout screen=%d fb=%dx%d rects=%d\n",
                        (int)s.screen, (int)w, (int)h, (int)s.hit.size());
                for (size_t i = 0; i < s.hit.size(); i++) {
                    const HitRect& r = s.hit[i];
                    fprintf(stderr,
                            "[launcher] hitrect %d kind=%d index=%d action=%d rect=%.0f,%.0f,%.0f,%.0f\n",
                            (int)i, (int)r.kind, r.index, (int)r.action, r.x0, r.y0, r.x1, r.y1);
                }
                fflush(stderr);
            }
        }
    }

    ImGui::Render();

#if defined(_WIN32)
    ImDrawData* draw_data = ImGui::GetDrawData();
    if (draw_data != nullptr) {
        D3D12CommandList* d3d_list = static_cast<D3D12CommandList*>(list);
        d3d_list->checkDescriptorHeaps();
        ImGui_ImplDX12_RenderDrawData(draw_data, d3d_list->d3d);
    }
#endif

    ImGui::SetCurrentContext(previous);
}

// ── attach / detach ──────────────────────────────────────────────────────────
void ui_attach(void* rt64_application) {
    RT64::Application* app = (RT64::Application*)rt64_application;
    if (app == nullptr || app->device == nullptr || app->swapChain == nullptr) {
        fprintf(stderr, "[launcher] ui_attach: no RT64 device/swapchain — the UI will not draw\n");
        return;
    }
    g_app = app;

    // F1 OPENS RT64's OWN OPTIONS, and it must keep working for a person playing a game
    // (2026-09-07: it must remain accessible to users). It used to be turned off
    // here on the grounds that F1..F4 belong to a debug session; they do not - F1 is where the
    // renderer's real settings live, and the VIDEO screen deliberately points at it.
    //
    // The two ImGui contexts still must not fight. The inspector's context is created lazily, the
    // first time F1 is pressed, and the launcher's own hook makes its context current only for the
    // duration of its own draw and restores the previous one after, so both can exist.
    app->userConfig.developerMode = true;

    ImGuiContext* previous = ImGui::GetCurrentContext();
    IMGUI_CHECKVERSION();
    g_ctx = ImGui::CreateContext();
    ImGui::SetCurrentContext(g_ctx);
    ImGui::StyleColorsDark();

    ImGuiIO& io = ImGui::GetIO();
    io.IniFilename = nullptr;                 // the launcher keeps no imgui.ini
    io.MouseDrawCursor = false;
    io.DisplaySize = ImVec2((float)app->swapChain->getWidth(), (float)app->swapChain->getHeight());

    // ImGui's default font at x2. A pixel font can replace this later without touching anything else.
    ImFontConfig fc;
    fc.SizePixels   = 26.0f;
    fc.OversampleH  = 1;
    fc.OversampleV  = 1;
    fc.PixelSnapH   = true;
    g_font = io.Fonts->AddFontDefault(&fc);

#if defined(_WIN32)
    // A CARTRIDGE'S TITLE IS NOT ALWAYS LATIN (2026-09-07: Saikyou Habu Shougi (Japan)).
    // ImGui's default font has Latin glyphs only, so a Japanese title draws as boxes. MERGE a
    // Japanese face into the same font rather than replacing it: Latin text keeps the look it has,
    // and only the characters the default font cannot draw come from the merged face. The file is
    // the USER'S OWN system font - Windows ships all of these - so nothing is bundled and nothing
    // is redistributed. MS Gothic first: it is on every Windows, and its fixed pitch matches this
    // screen. If none is present the launcher simply keeps Latin-only, which is what it did before.
    {
        ImFontConfig jp;
        jp.MergeMode    = true;
        jp.SizePixels   = 26.0f;
        jp.OversampleH  = 1;
        jp.OversampleV  = 1;
        jp.PixelSnapH   = true;
        const char* faces[] = {
            "C:\\Windows\\Fonts\\msgothic.ttc",
            "C:\\Windows\\Fonts\\YuGothM.ttc",
            "C:\\Windows\\Fonts\\meiryo.ttc",
        };
        const ImWchar* ranges = io.Fonts->GetGlyphRangesJapanese();
        bool merged = false;
        for (const char* f : faces) {
            FILE* probe = nullptr;
            if (fopen_s(&probe, f, "rb") == 0 && probe != nullptr) {
                fclose(probe);
                if (io.Fonts->AddFontFromFileTTF(f, 26.0f, &jp, ranges) != nullptr) {
                    fprintf(stderr, "[launcher] japanese glyphs merged from %s\n", f);
                    merged = true;
                    break;
                }
            }
        }
        if (!merged) {
            fprintf(stderr, "[launcher] no japanese system font found - latin glyphs only\n");
        }
        fflush(stderr);
    }
#endif

#if defined(_WIN32)
    if (app->chosenGraphicsAPI == RT64::UserConfiguration::GraphicsAPI::D3D12) {
        D3D12Device* device = static_cast<D3D12Device*>(app->device.get());
        const D3D12SwapChain* swap = static_cast<const D3D12SwapChain*>(app->swapChain.get());
        RenderDescriptorRange range(RenderDescriptorRangeType::TEXTURE, 0, 1);
        g_imgui_descriptor_set = device->createDescriptorSet(RenderDescriptorSetDesc(&range, 1));
        D3D12DescriptorSet* set = static_cast<D3D12DescriptorSet*>(g_imgui_descriptor_set.get());
        const D3D12_CPU_DESCRIPTOR_HANDLE cpu = device->viewHeapAllocator->getCPUHandleAt(set->viewAllocation.offset);
        const D3D12_GPU_DESCRIPTOR_HANDLE gpu = device->viewHeapAllocator->getGPUHandleAt(set->viewAllocation.offset);
        if (!ImGui_ImplDX12_Init(device->d3d, 2, swap->nativeFormat,
                                 device->viewHeapAllocator->heap, cpu, gpu)) {
            fprintf(stderr, "[launcher] ImGui_ImplDX12_Init failed\n");
            ImGui::SetCurrentContext(previous);
            return;
        }
    } else {
        fprintf(stderr, "[launcher] graphics API is not D3D12 (%d) — step 1 draws only on D3D12\n",
                (int)app->chosenGraphicsAPI);
        ImGui::SetCurrentContext(previous);
        return;
    }
#endif

    ImGui::SetCurrentContext(previous);
    RT64::SetRenderHooks(nullptr, draw_hook, nullptr);
    g_ready.store(true, std::memory_order_release);
    fprintf(stderr, "[launcher] ImGui overlay attached (own context, RT64 present draw hook)\n");
    fflush(stderr);
}

void ui_detach() {
    g_ready.store(false, std::memory_order_release);
    RT64::SetRenderHooks(nullptr, nullptr, nullptr);
}

// ── the BUILD child: recompilator/tools/build_entry.ps1 ──────────────────────
// The launcher runs NO pipeline logic. It spawns the one driver, reads its stdout line by line on
// its own thread, and turns the STAGE/RESULT lines into the table. Everything the driver does
// (docker, gen_toml, N64Recomp, cmake) lives in the driver, for every game the same way.
namespace {

#if defined(_WIN32)
HANDLE              g_build_job  = nullptr;
PROCESS_INFORMATION g_build_pi{};
HANDLE              g_build_read = nullptr;
std::mutex          g_build_handles;
#endif
std::atomic<bool>   g_build_live{ false };      // a child is spawned and not yet reaped
std::atomic<bool>   g_build_exited{ false };    // the child has exited (reader thread is done)

std::vector<std::string> split_ws(const std::string& s) {
    std::vector<std::string> out;
    size_t i = 0;
    while (i < s.size()) {
        while (i < s.size() && (s[i] == ' ' || s[i] == '\t')) i++;
        size_t b = i;
        while (i < s.size() && s[i] != ' ' && s[i] != '\t') i++;
        if (i > b) out.push_back(s.substr(b, i - b));
    }
    return out;
}

std::string join_from(const std::vector<std::string>& t, size_t a, size_t b) {
    std::string r;
    for (size_t i = a; i < b && i < t.size(); i++) {
        if (!r.empty()) r += " ";
        r += t[i];
    }
    return r;
}

void tail_push(UiState& s, const std::string& line) {
    std::string l = line;
    while (!l.empty() && (l.back() == '\r' || l.back() == ' ')) l.pop_back();
    if (l.empty()) return;
    if (l.size() > 220) l = l.substr(0, 220);
    s.build_tail.push_back(l);
    while (s.build_tail.size() > 5) s.build_tail.erase(s.build_tail.begin());
}

// One line of the driver's stdout. The stage NAME may contain spaces, so the verb is found by
// scanning for the first START / OK / FAIL token after the stage number.
void handle_build_line(const std::string& raw) {
    std::string line = raw;
    while (!line.empty() && (line.back() == '\r' || line.back() == ' ')) line.pop_back();
    if (line.empty()) return;

    const std::vector<std::string> t = split_ws(line);
    UiState& s = ui();

    if (t.size() >= 4 && t[0] == "STAGE") {
        const int n = std::atoi(t[1].c_str());
        size_t k = 2;
        while (k < t.size() && t[k] != "START" && t[k] != "OK" && t[k] != "FAIL") k++;
        if (n <= 0 || n > 64 || k >= t.size()) {
            std::lock_guard<std::mutex> lock(s.mutex);
            tail_push(s, line);
            return;
        }
        const std::string name = join_from(t, 2, k);
        const std::string verb = t[k];
        const std::string rest = join_from(t, k + 1, t.size());

        std::lock_guard<std::mutex> lock(s.mutex);
        if ((int)s.build_stages.size() < n) s.build_stages.resize(n);
        BuildStage& st = s.build_stages[(size_t)n - 1];
        st.name = name;
        if (verb == "START") {
            st.status  = StageStatus::Working;
            st.started = now_seconds();
            st.seconds = 0.0;
            st.evidence.clear();
            s.status = "building: " + name;
        } else {
            // OK/FAIL carry "<seconds> <evidence...>" — the seconds are the DRIVER's measurement.
            const std::vector<std::string> r = split_ws(rest);
            st.seconds  = r.empty() ? 0.0 : std::atof(r[0].c_str());
            st.evidence = join_from(r, 1, r.size());
            st.status   = (verb == "OK") ? StageStatus::Ok : StageStatus::Fail;
        }
        return;
    }

    if (t.size() >= 2 && t[0] == "RESULT") {
        std::lock_guard<std::mutex> lock(s.mutex);
        s.build_end = now_seconds();
        if (t[1] == "OK" && t.size() >= 5) {
            // RESULT OK <exe path (may contain spaces)> <bytes> <total seconds>
            s.build_exe    = join_from(t, 2, t.size() - 2);
            s.build_failed = false;
            s.build_result = "BUILD COMPLETE   " + t[t.size() - 1] + " s   " +
                             t[t.size() - 2] + " bytes   " + s.build_exe;
            s.status       = "built " + s.build_game;
        } else {
            s.build_failed = true;
            s.build_result = "BUILD FAILED at " + join_from(t, 2, t.size());
            s.status       = "build failed";
        }
        return;
    }

    std::lock_guard<std::mutex> lock(s.mutex);
    tail_push(s, line);
}

#if defined(_WIN32)
void build_reader() {
    std::string acc;
    char buf[4096];
    for (;;) {
        DWORD n = 0;
        if (!ReadFile(g_build_read, buf, (DWORD)sizeof(buf), &n, nullptr) || n == 0) break;
        acc.append(buf, n);
        size_t pos;
        while ((pos = acc.find('\n')) != std::string::npos) {
            handle_build_line(acc.substr(0, pos));
            acc.erase(0, pos + 1);
        }
        if (acc.size() > 8192) { handle_build_line(acc); acc.clear(); }
    }
    if (!acc.empty()) handle_build_line(acc);

    DWORD code = 0;
    {
        std::lock_guard<std::mutex> lock(g_build_handles);
        if (g_build_pi.hProcess) {
            WaitForSingleObject(g_build_pi.hProcess, 20000);
            GetExitCodeProcess(g_build_pi.hProcess, &code);
            CloseHandle(g_build_pi.hProcess);
            CloseHandle(g_build_pi.hThread);
            g_build_pi = PROCESS_INFORMATION{};
        }
        if (g_build_read) { CloseHandle(g_build_read); g_build_read = nullptr; }
        if (g_build_job)  { CloseHandle(g_build_job);  g_build_job  = nullptr; }
    }

    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.build_running = false;
        if (s.build_end <= 0.0) {
            // No RESULT line: the child died or was cancelled.
            s.build_end = now_seconds();
            s.build_failed = true;
            if (s.build_result.empty()) {
                s.build_result = "BUILD ENDED with no RESULT line (exit " + std::to_string((int)code) + ")";
            }
        }
        fprintf(stderr, "[launcher] build child exited, code %lu\n", (unsigned long)code);
        fflush(stderr);
    }
    g_build_exited.store(true, std::memory_order_release);
    g_build_live.store(false, std::memory_order_release);
}
#endif

void cancel_build() {
#if defined(_WIN32)
    std::lock_guard<std::mutex> lock(g_build_handles);
    // The job object was created with KILL_ON_JOB_CLOSE and the child assigned to it, so this takes
    // powershell AND everything it started (cmake, MSBuild, cl.exe, the docker client) with it.
    if (g_build_job) TerminateJobObject(g_build_job, 1);
#endif
}

// ONE spawn for both kinds of build. `game` empty + `rom` set is the BLIND path: the driver reads
// the cartridge, works out what it is and brings it up. The launcher still runs no pipeline logic -
// it hands the driver a file and reads its stage lines.
void spawn_driver(const std::string& root, const std::string& game, const std::string& rom,
                  const std::string& title, bool has_ni, const std::string& sha1, bool blind = false) {
    if (g_build_live.load(std::memory_order_acquire)) return;
#if defined(_WIN32)
    if (g_child_live) return;               // never a build while a game runs

    std::string script;
    script = (fs::path(root) / "recompilator" / "tools" / "build_entry.ps1").string();
    if (!fs::exists(script)) {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.status = "no driver at " + script;
        return;
    }

    SECURITY_ATTRIBUTES sa{};
    sa.nLength = sizeof(sa);
    sa.bInheritHandle = TRUE;
    HANDLE rd = nullptr, wr = nullptr;
    if (!CreatePipe(&rd, &wr, &sa, 1 << 16)) {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.status = "could not create the build pipe";
        return;
    }
    SetHandleInformation(rd, HANDLE_FLAG_INHERIT, 0);
    HANDLE nul = CreateFileW(L"NUL", GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, &sa,
                             OPEN_EXISTING, 0, nullptr);

    const std::wstring wscript = fs::path(script).wstring();
    const std::wstring wgame(game.begin(), game.end());
    std::wstring cmd = L"powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"" + wscript +
                       L"\" " + wgame;
    if (!rom.empty()) {
        cmd += L" -RomPath \"" + fs::path(rom).wstring() + L"\"";
    }
    if (blind) cmd += L" -Blind";          // the user's choice: the cartridge alone, no recipe
    std::vector<wchar_t> cmdbuf(cmd.begin(), cmd.end());
    cmdbuf.push_back(L'\0');

    STARTUPINFOW si{};
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdOutput = wr;
    si.hStdError  = wr;
    si.hStdInput  = (nul == INVALID_HANDLE_VALUE) ? nullptr : nul;
    PROCESS_INFORMATION pi{};
    const std::wstring wroot = fs::path(root).wstring();

    HANDLE job = CreateJobObjectW(nullptr, nullptr);
    if (job) {
        JOBOBJECT_EXTENDED_LIMIT_INFORMATION jl{};
        jl.BasicLimitInformation.LimitFlags = JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
        SetInformationJobObject(job, JobObjectExtendedLimitInformation, &jl, sizeof(jl));
    }

    const BOOL ok = CreateProcessW(nullptr, cmdbuf.data(), nullptr, nullptr, TRUE,
                                   CREATE_NO_WINDOW | CREATE_SUSPENDED, nullptr,
                                   wroot.c_str(), &si, &pi);
    CloseHandle(wr);
    if (nul != INVALID_HANDLE_VALUE) CloseHandle(nul);
    if (!ok) {
        CloseHandle(rd);
        if (job) CloseHandle(job);
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.status = "could not start powershell for the build";
        return;
    }
    if (job) AssignProcessToJobObject(job, pi.hProcess);
    ResumeThread(pi.hThread);

    {
        std::lock_guard<std::mutex> lock(g_build_handles);
        g_build_pi   = pi;
        g_build_read = rd;
        g_build_job  = job;
    }

    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.screen        = Screen::Build;
        s.build_start   = now_seconds();
        s.build_end     = 0.0;
        s.build_title   = title;
        s.build_game    = game;
        s.build_sha1    = sha1;
        s.build_running = true;
        s.build_failed  = false;
        s.build_result.clear();
        s.build_exe.clear();
        s.build_tail.clear();
        s.build_cmd = "tools/build_entry.ps1 " + (game.empty() ? ("-RomPath " + rom) : game) +
                      (blind ? " -Blind" : "") + "   (powershell -NoProfile -File, stdout parsed live)";
        s.build_stages.clear();
        // The seed list is only what is shown as `waiting` before the driver's first line arrives.
        // A blind build runs more stages than a catalog build and names them itself, so seed the
        // blind list when there is no entry - the driver's own STAGE lines replace either.
        std::vector<std::string> seeds;
        if (game.empty()) {
            for (const char* n : BLIND_SEED_STAGES) seeds.push_back(n);
        } else {
            for (const char* n : SEED_STAGES) seeds.push_back(n);
        }
        for (const std::string& n : seeds) {
            // The conditional stage is seeded from the entry's FILES, never from a game name.
            if (has_ni && n == "RSP MICROCODE") {
                BuildStage ni{}; ni.name = "NI SECTION DATA";
                s.build_stages.push_back(ni);
            }
            BuildStage st{}; st.name = n;
            s.build_stages.push_back(st);
        }
        s.status = game.empty() ? ("bringing up " + title + " from its own bytes") : ("building " + game);
    }
    g_build_exited.store(false, std::memory_order_release);
    g_build_live.store(true, std::memory_order_release);
    fprintf(stderr, "[launcher] BUILD: spawned %ls\n", cmd.c_str());
    fflush(stderr);
    std::thread(build_reader).detach();
#endif
}

// AFTER A BUILD, re-read the catalog from disk and keep the game that was built selected. The
// entry may be brand new (a blind build authored it), so it is found by the tree token when there
// was one and by the CART'S SHA-1 when the cart named itself - the launcher never invents an id.
// Called from both ways off the finished BUILD screen: the automatic drop-back and a key press.
void refresh_catalog(const std::string& built_game, const std::string& built_sha1) {
    std::string root;
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        root = s.root;
    }
    std::vector<CatalogEntry> fresh = scan_catalog(root);
    UiState& s = ui();
    std::lock_guard<std::mutex> lock(s.mutex);
    if (!fresh.empty()) s.entries = std::move(fresh);
    for (size_t i = 0; i < s.entries.size(); i++) {
        const bool by_game = !built_game.empty() && s.entries[i].game == built_game;
        const bool by_sha  = !built_sha1.empty() && s.entries[i].sha1 == built_sha1;
        if (by_game || by_sha) { s.selected = (int)i; break; }
    }
}

// B on the library: rebuild the selected catalog entry.
void start_build() {
    std::string root, game, title, rom, need;
    bool has_ni = false;
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        root = s.root;
        // A cart just recognised on the ADD ROM screen is usually NOT in the library yet - the
        // library lists games the user has, and they do not have this one until it is built. So
        // build what was recognised when there is one, and the selected row otherwise.
        if (!s.add_game.empty() && !s.add_rom_path.empty()) {
            game = s.add_game;
            rom = s.add_rom_path;
            title = s.add_cart.empty() ? s.add_game : s.add_game;
            std::string g2, t2; bool ni2 = false;
            if (lookup_entry_by_sha1(root, s.add_sha1, &g2, &t2, &ni2)) { title = t2; has_ni = ni2; }
        } else {
            if (s.entries.empty() || s.selected < 0 || s.selected >= (int)s.entries.size()) return;
            const CatalogEntry& e = s.entries[s.selected];
            game = e.game; title = e.title; has_ni = e.has_ni_data;
        // THE ENTRY IS A RECIPE, NOT A GAME: it holds no cartridge data, so a build needs the
        // user's own ROM. Take the file they just identified when it IS this game, fall back to a
        // ROM left in the tree by an earlier build, and otherwise say what is needed rather than
        // starting a build that cannot work.
            // ...AND GAMES LIVE UNDER <root>/archive/ SINCE 2026-09-07. This check was left
            // pointing at <root>/<game>/, so the fallback never fired: a cart the program had
            // itself copied into the tree on an earlier build was invisible here, and pressing
            // build on a game the user demonstrably owns answered "press A and choose your copy
            // of <game>". Check both places, archive first, exactly as launcher_catalog.cpp
            // does - anything built before the move must keep working where it sits.
            std::error_code ec;
            const fs::path in_archive = fs::path(root) / "archive" / game / "baserom.z64";
            const fs::path in_root    = fs::path(root) / game / "baserom.z64";
            if (fs::exists(in_archive, ec))      rom = in_archive.string();
            else if (fs::exists(in_root, ec))    rom = in_root.string();
            else {
                need = "press A and choose your copy of " + title;
                s.status = need;
            }
        }
    }
    if (!need.empty()) {
        fprintf(stderr, "[launcher] BUILD %s needs the cartridge: %s\n", game.c_str(), need.c_str());
        fflush(stderr);
        return;
    }
    spawn_driver(root, game, rom, title, has_ni, std::string());
}

// ENTER on an unknown cart: hand the driver the FILE and nothing else. This is THE loop - the
// program has never seen this cartridge and no entry for it exists anywhere, so everything from
// here on comes out of the cart's own bytes.
void start_build_unknown() {
    std::string root, rom, title, sha1;
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        if (!s.add_unknown || s.add_rom_path.empty()) return;
        root = s.root; rom = s.add_rom_path; sha1 = s.add_sha1;
        title = s.add_cart.empty() ? s.add_rom_path : s.add_cart;
    }
    spawn_driver(root, std::string(), rom, title, false, sha1);
}

// B on the ADD ROM screen: the user's choice to set a shipped recipe aside and have this cartridge
// worked out from its own bytes. A recipe is the lab's notes on one dump of a game; the blind path
// is the program's own reading of the cartridge in hand. Both are legitimate, and which one a person
// wants is theirs to decide, per game - so both are offered whenever a recipe exists (2026-09-09).
// The two builds land in different trees (the recipe's id, the cartridge's own name) and both stay.
void start_build_blind() {
    std::string root, rom, title, sha1;
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        if (s.add_rom_path.empty()) return;
        root = s.root; rom = s.add_rom_path; sha1 = s.add_sha1;
        title = !s.add_cart.empty() ? s.add_cart : (!s.add_game.empty() ? s.add_game : s.add_rom_path);
    }
    spawn_driver(root, std::string(), rom, title, false, sha1, true);
}

} // namespace

// ── main-thread actions ──────────────────────────────────────────────────────
namespace {

void enter_add_rom() {
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.screen = Screen::AddRom;
        s.add_busy = true;
        s.add_path.clear(); s.add_sha1.clear(); s.add_member.clear();
        s.add_verdict.clear(); s.add_matches.clear();
        s.add_unknown = false; s.add_rom_path.clear(); s.add_cart.clear();
        s.status = "choosing a ROM";
    }

    // RT64 already wraps nativefiledialog-extended and flags the dialog as open.
    fprintf(stderr, "[launcher] ADD ROM: opening the file dialog\n"); fflush(stderr);
    RT64::FileDialog::initialize();   // NFD_Init is per-thread COM; the Application ran it on the gfx thread
    const fs::path picked = RT64::FileDialog::getOpenFilename({ RT64::FileFilter("N64 ROM / archive", "z64,n64,v64,zip") });
    fprintf(stderr, "[launcher] ADD ROM: picked '%s'\n", picked.string().c_str()); fflush(stderr);

    UiState& s = ui();
    if (picked.empty()) {
        std::lock_guard<std::mutex> lock(s.mutex);
        s.add_busy = false;
        s.screen = Screen::Archive;
        s.status = "add rom cancelled";
        return;
    }

    // WHAT IS THIS CARTRIDGE? Read out of the file itself: its SHA-1 and its own ROM header.
    std::string error;
    RomIdentity id{};
    const bool read_ok = rom_identity(picked.string(), id, error);

    std::lock_guard<std::mutex> lock(s.mutex);
    s.add_busy = false;
    s.add_path = picked.string();
    s.add_member = id.member;
    s.add_sha1 = id.sha1;
    s.add_matches.clear();
    s.add_unknown = false;
    s.add_rom_path.clear();
    s.add_cart.clear();
    if (!read_ok || id.sha1.empty()) {
        s.add_verdict = "Could not read the file: " + (error.empty() ? std::string("unknown error") : error);
        s.status = "could not read the ROM";
        return;
    }
    {
        std::string name = id.internal_name.empty() ? std::string("(no internal name)") : id.internal_name;
        char sz[48] = {};
        std::snprintf(sz, sizeof(sz), "%.1f MB", (double)id.size / (1024.0 * 1024.0));
        s.add_cart = name + "   serial " + (id.serial.empty() ? std::string("----") : id.serial) +
                     "   entry " + id.entrypoint + "   " + sz;
    }
    // The library lists only games the user HAS, so the entry that matches a freshly added
    // cartridge is usually not in it. Ask the catalog on disk as well.
    s.add_game.clear();
    {
        std::string g, ti; bool ni = false;
        if (lookup_entry_by_sha1(s.root, id.sha1, &g, &ti, &ni)) {
            s.add_game = g;
            s.add_matches.push_back(g + "   " + ti);
        }
    }
    int first = -1;
    for (size_t i = 0; i < s.entries.size(); i++) {
        if (s.entries[i].sha1 == id.sha1) {
            if (first < 0) first = (int)i;
            s.add_matches.push_back(s.entries[i].game + "   " + s.entries[i].title +
                                    "   [" + s.entries[i].state_label + "]");
        }
    }
    if (!s.add_game.empty()) {
        if (first >= 0) s.selected = first;
        s.add_verdict = "Recognised: " + (first >= 0 ? s.entries[first].title : s.add_game);
        // REMEMBER THE FILE. A catalog entry is a recipe and carries nothing of the cartridge, so
        // BUILD needs the user's ROM just as much as an unknown cart does. Forgetting it here is why
        // Build on a shipped entry died with "no ROM given" on the first real install (seen
        // 2026-09-07): on this machine the tree always already had one.
        s.add_rom_path = picked.string();
        s.status = "recognised - ENTER builds it from the recipe   B builds it blind instead";
    } else {
        // NOT AN ERROR. A release ships no catalog, so this is the ordinary case: the program has
        // never seen this cart, and ENTER builds it from its own bytes.
        s.add_verdict = "New cartridge - nothing about this game shipped with the program";
        s.add_unknown = true;
        s.add_rom_path = picked.string();
        s.status = "ENTER builds it from the cartridge itself   ESC cancels";
    }
    fprintf(stderr, "[launcher] ADD ROM: member='%s' sha1=%s -> %s (%zu match(es))\n",
            s.add_member.c_str(), s.add_sha1.c_str(), s.add_verdict.c_str(), s.add_matches.size());
    fflush(stderr);
}

void start_play() {
    // Never a game during a build: the driver's COMPILE stage owns the machine while it runs.
    if (g_build_live.load(std::memory_order_acquire)) {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.status = "a build is running - ESC on the build screen cancels it";
        return;
    }
    std::string exe, title, game, module_path, rom_path;
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        if (s.entries.empty() || s.selected < 0 || s.selected >= (int)s.entries.size()) return;
        const CatalogEntry& e = s.entries[s.selected];
        exe = e.exe_path; title = e.title; game = e.game;
        module_path = e.module_path; rom_path = e.rom_path;
        if (exe.empty() && module_path.empty()) {
            s.status = "nothing built for " + e.game + "pc - press B for the build screen";
            return;
        }
    }

    // ── STEP 3: the game is a MODULE, and it runs in THIS window ──────────────────────────────
    // Preferred whenever the module exists. The engine is already up (recomp::start() is the call
    // this launcher never returned from), its game thread is parked on `game_status`, and
    // module_play() registers the module's game, sections, ucodes and RSP dispatch before
    // releasing it. No second process, no second window, no focus dance for the keyboard.
    if (!module_path.empty()) {
        std::string err;
        const bool ok = module_play(module_path, rom_path, err);
        UiState& s = ui();
        if (!ok) {
            std::lock_guard<std::mutex> lock(s.mutex);
            s.status = "module: " + err;
            fprintf(stderr, "[launcher] module_play FAILED: %s\n", err.c_str());
            fflush(stderr);
            return;
        }
        note_played(game);
        {
            std::lock_guard<std::mutex> lock(s.mutex);
            s.screen = Screen::Play;
            s.play_title = title;
            s.play_exe = module_path;
            s.play_running = true;
            s.play_in_process = true;
            s.status = "running (module)";
        }
        g_game_in_process.store(true, std::memory_order_release);
        // The game owns the window from here: no cursor drawn over it, no hover left behind, and
        // the pump stops handing this file mouse events at all (main.cpp, same gate as the keys).
        SDL_ShowCursor(SDL_DISABLE);
        {
            std::lock_guard<std::mutex> lock(s.mutex);
            s.hit.clear();
            s.mouse_x = -1.0f; s.mouse_y = -1.0f;
            s.hover_row = -1; s.hover_tab = -1; s.hover_hint = -1;
        }
        fprintf(stderr, "[launcher] mouse: the game module owns the window - cursor off, no hover, "
                        "no clicks consumed\n");
        fflush(stderr);
        return;
    }
#if defined(_WIN32)
    if (g_child_live) return;
    STARTUPINFOW si{}; si.cb = sizeof(si);
    PROCESS_INFORMATION pi{};
    const std::wstring wexe = fs::path(exe).wstring();
    const std::wstring wdir = fs::path(exe).parent_path().wstring();
    const std::wstring quoted = L"\"" + wexe + L"\"";        // the path may contain spaces
    std::vector<wchar_t> cmd(quoted.begin(), quoted.end());
    cmd.push_back(L'\0');
    const BOOL ok = CreateProcessW(nullptr, cmd.data(), nullptr, nullptr, FALSE, 0, nullptr,
                                   wdir.c_str(), &si, &pi);
    UiState& s = ui();
    if (!ok) {
        std::lock_guard<std::mutex> lock(s.mutex);
        s.status = "could not start " + exe;
        return;
    }
    g_child = pi;
    g_child_live = true;
    note_played(game);
    {
        std::lock_guard<std::mutex> lock(s.mutex);
        s.screen = Screen::Play;
        s.play_title = title;
        s.play_exe = exe;
        s.play_running = true;
        s.status = "running";
    }
    if (g_window) SDL_MinimizeWindow(g_window);
#endif
}

// LEAVING A GAME AND GETTING BACK TO THE ARCHIVE.
//
// A game launched as its own exe is a child process: end it, and the existing watcher drops the
// screen back on its own.
//
// A game loaded as a MODULE runs in THIS process, and the runtime has no way to stop one. There is
// only start_game(); ultramodern::quit() calls ExitProcess outright, deliberately, because the
// graceful teardown raced the still-running game threads and crashed. Unwinding it properly is an
// engine change, not a launcher one.
//
// So do the honest thing that gets the user what they asked for: start a fresh copy of the program
// and end this one. They land back on the ARCHIVE, with their library intact because it is on disk
// now. It costs the few seconds of a reload and it cannot crash on the way out.
void leave_game() {
    bool in_process = false;
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        in_process = s.play_in_process;
        s.exit_prompt = false;
    }
#if defined(_WIN32)
    if (!in_process) {
        if (g_child.hProcess) {
            TerminateProcess(g_child.hProcess, 0);
            fprintf(stderr, "[launcher] left the game: child ended, back to the archive\n");
        }
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.screen = Screen::Archive;
        s.menu = 0;
        s.play_running = false;
        s.status = "back from " + s.play_title;
        return;
    }
    wchar_t self[MAX_PATH] = {};
    if (GetModuleFileNameW(nullptr, self, MAX_PATH)) {
        STARTUPINFOW si{}; si.cb = sizeof(si);
        PROCESS_INFORMATION pi{};
        if (CreateProcessW(self, nullptr, nullptr, nullptr, FALSE, 0, nullptr, nullptr, &si, &pi)) {
            CloseHandle(pi.hThread);
            CloseHandle(pi.hProcess);
            fprintf(stderr, "[launcher] left the game: restarting to the archive\n");
            fflush(stderr);
            ExitProcess(0);
        }
        fprintf(stderr, "[launcher] could not restart (%lu); staying in the game\n", GetLastError());
    }
#endif
}

// ONE SETTING, CHANGED. Enter on a focused row advances it to its next value and applies it to the
// live renderer, which is what the VIDEO screen's rows are: RT64's own configuration, the same
// fields its F1 options edit. Nothing here is a placeholder - a row exists only if changing it
// does something.
void cycle_option() {
    if (g_app == nullptr) return;
    RT64::UserConfiguration& c = g_app->userConfig;
    int sel = 0; Screen sc = Screen::Video;
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        sel = s.opt_sel; sc = s.screen;
    }
    if (sc != Screen::Video) return;           // AUDIO and CONTROLS have nothing to cycle yet
    using UC = RT64::UserConfiguration;
    switch (sel) {
    case 0: {   // internal resolution multiplier
        const double steps[] = { 1.0, 1.5, 2.0, 3.0, 4.0 };
        int i = 0;
        for (int k = 0; k < 5; k++) if (c.resolutionMultiplier >= steps[k] - 0.01) i = k;
        c.resolutionMultiplier = steps[(i + 1) % 5];
        break;
    }
    case 1:     // antialiasing
        c.antialiasing = (UC::Antialiasing)(((int)c.antialiasing + 1) % (int)UC::Antialiasing::OptionCount);
        break;
    case 2:     // texture filtering
        c.filtering = (UC::Filtering)(((int)c.filtering + 1) % (int)UC::Filtering::OptionCount);
        break;
    case 3:     // aspect ratio
        c.aspectRatio = (UC::AspectRatio)(((int)c.aspectRatio + 1) % (int)UC::AspectRatio::OptionCount);
        break;
    case 4:     // display buffering
        c.displayBuffering =
            (UC::DisplayBuffering)(((int)c.displayBuffering + 1) % (int)UC::DisplayBuffering::OptionCount);
        break;
    case 5:     // three-point filtering, the N64's own
        c.threePointFiltering = !c.threePointFiltering;
        break;
    default: return;
    }
    // APPLY IT, AND KEEP IT. Writing the struct changes nothing on its own: the render queues read
    // their own copy, so the change has to be pushed to them, and it has to be written to disk or
    // it is gone at the next launch. RT64's own options do exactly these two things (rt64_state.cpp
    // "Update renderer configuration"), and nothing here did either - so a setting appeared to do
    // nothing, and nothing ever persisted (2026-09-07, and the reason the config file did not
    // exist at all: the only path that saves one runs from F1, which had been turned off).
    c.validate();
    if (g_app->sharedQueueResources != nullptr) {
        g_app->sharedQueueResources->setUserConfig(c, true);   // true: resolution/aspect changed
    }
    const bool saved = g_app->saveConfiguration();
    UiState& s = ui();
    std::lock_guard<std::mutex> lock(s.mutex);
    s.status = saved ? "applied and saved" : "applied (not saved - no writable config path)";
}

} // namespace

bool ui_game_in_process() { return g_game_in_process.load(std::memory_order_acquire); }

bool ui_exit_prompt() {
    UiState& s = ui();
    std::lock_guard<std::mutex> lock(s.mutex);
    return s.exit_prompt;
}

// Move the list window so the selected row is inside it. Wrapping selection (the modulo
// above) means this also jumps the view to the far end, which is what a person expects when
// UP from the first row lands on the last.
static void scroll_to_selection(UiState& s) {
    const int rows = s.rows_visible > 0 ? s.rows_visible : 1;
    if (s.selected < s.list_scroll)                     s.list_scroll = s.selected;
    else if (s.selected > s.list_scroll + rows - 1)     s.list_scroll = s.selected - rows + 1;
    if (s.list_scroll < 0) s.list_scroll = 0;
}

void ui_action(Action a) {
    // Once a module owns the window every key belongs to the game; main.cpp gates on
    // ui_game_in_process() as well, and this is the belt to that pair of braces.
    if (g_game_in_process.load(std::memory_order_acquire)) return;
    if (a == Action::Quit)   { ultramodern::quit(); return; }
    if (a == Action::AddRom) { enter_add_rom(); return; }

    UiState& s = ui();
    bool play = false;
    bool build = false;
    bool build_unknown = false;
    bool build_blind = false;
    bool cancel = false;
    bool leave = false;
    bool opt_cycle = false;
    bool refresh = false;
    std::string refresh_game, refresh_sha1;
    {
        std::lock_guard<std::mutex> lock(s.mutex);
        const int n = (int)s.entries.size();
        switch (s.screen) {
        case Screen::Archive:
            // THE REVISION CHOOSER OWNS THE KEYS WHILE IT IS UP.
            if (s.rev_prompt) {
                const int rn = (int)s.rev_rows.size();
                switch (a) {
                case Action::Up:    if (rn) s.rev_sel = (s.rev_sel + rn - 1) % rn; break;
                case Action::Down:  if (rn) s.rev_sel = (s.rev_sel + 1) % rn;      break;
                case Action::Escape: s.rev_prompt = false;                          break;
                case Action::Enter:
                    if (rn) {
                        s.selected = s.rev_rows[s.rev_sel];
                        scroll_to_selection(s);
                        play = true;
                    }
                    s.rev_prompt = false;
                    break;
                default: break;
                }
                break;
            }
            switch (a) {
            // KEEP THE SELECTION IN VIEW. list_scroll was moved by the mouse wheel and by
            // nothing else, so UP/DOWN walked the highlight straight off the panel: past the
            // first screenful NO row was highlighted, and the footer described one game while
            // the list showed another. In a keyboard-first program (the brief: ZSNES-simple,
            // keyboard-first) that makes the library unusable past row 16, and it is why a
            // scripted walk of the list looked incoherent. 2026-09-08.
            case Action::Up:
                if (n) { s.selected = (s.selected + n - 1) % n; scroll_to_selection(s); }
                break;
            case Action::Down:
                if (n) { s.selected = (s.selected + 1) % n;     scroll_to_selection(s); }
                break;
            case Action::Left:  s.menu = (s.menu + 3) % 4; s.screen = screen_for_tab(s.menu); break;
            case Action::Right: s.menu = (s.menu + 1) % 4; s.screen = screen_for_tab(s.menu); break;
            // ONE BUILD STARTS IT; SEVERAL ASK WHICH. See UiState::rev_prompt.
            case Action::Enter: {
                std::vector<int> sib = rev_siblings_locked(s, s.selected);
                if (sib.size() > 1) {
                    s.rev_rows = sib;
                    s.rev_sel = 0;
                    for (int i = 0; i < (int)sib.size(); i++) if (sib[i] == s.selected) s.rev_sel = i;
                    s.rev_prompt = true;
                } else {
                    play = true;
                }
                break;
            }
            case Action::Build: build = true;                                 break;
            // Esc is "back", and the library IS the back stop — it must never be the key that
            // kills the front door by accident. Quitting is Q, or the window's close button.
            case Action::Escape: s.menu = 0; s.screen = Screen::Archive; s.status = "Q or the close button quits"; break;
            case Action::Quit:   ultramodern::quit();                                  break;
            default: break;
            }
            break;

        case Screen::AddRom:
            // ENTER BUILDS, whichever kind of cartridge this is. The library only lists games the
            // user actually has, so "recognised" cannot mean "go back and find it in the list" -
            // there is nothing in the list yet. Recognised means we have a recipe for this cart and
            // the build is a short one; unknown means the cart is worked out from its own bytes.
            // Either way the next step is the same and the user should not have to know which.
            if (!s.add_busy && a == Action::Build && !s.add_rom_path.empty()) {
                build_blind = true;        // B: set any recipe aside and read the cartridge itself
            } else if (!s.add_busy && a == Action::Enter && s.add_unknown) {
                build_unknown = true;
            } else if (!s.add_busy && a == Action::Enter && !s.add_rom_path.empty()) {
                build = true;              // a recognised cart: build it from the recipe
            } else if (!s.add_busy && (a == Action::Escape || a == Action::Enter)) {
                s.screen = Screen::Archive;
                s.status.clear();
            }
            break;

        case Screen::Build:
            // While the child runs, Esc kills it (job object). Once it has finished, Esc/Enter is
            // simply "back to the library".
            if (a == Action::Escape || a == Action::Enter) {
                if (s.build_running) {
                    if (a == Action::Escape) { cancel = true; s.status = "cancelling the build"; }
                } else {
                    s.screen = Screen::Archive;
                    // Leaving the finished screen by hand must refresh the library exactly as the
                    // automatic drop-back does, or a game that was just built is not there.
                    if (!s.build_failed) { refresh = true; refresh_game = s.build_game; refresh_sha1 = s.build_sha1; }
                    s.status = s.build_failed ? "build failed - see the log"
                                              : "built " + (s.build_game.empty() ? s.build_title : s.build_game);
                }
            }
            break;

        case Screen::Video:
        case Screen::Audio:
        case Screen::Controls:
            switch (a) {
            case Action::Left:  s.menu = (s.menu + 3) % 4; s.screen = screen_for_tab(s.menu); break;
            case Action::Right: s.menu = (s.menu + 1) % 4; s.screen = screen_for_tab(s.menu); break;
            case Action::Up:    if (s.opt_sel > 0) s.opt_sel--;                               break;
            case Action::Down:  if (s.opt_sel < s.opt_count - 1) s.opt_sel++;                 break;
            case Action::Enter: opt_cycle = true;                                             break;
            case Action::Escape: s.menu = 0; s.screen = Screen::Archive; s.opt_sel = 0;       break;
            case Action::Quit:   ultramodern::quit();                                         break;
            default: break;
            }
            break;

        case Screen::Play:
            // LEAVING A GAME. Esc (and the pad's middle button, which main.cpp sends here as the
            // same action) asks first and drops the game only on yes - never silently, and never
            // without a way back to the archive (2026-09-07).
            if (!s.exit_prompt) {
                if (a == Action::Escape) { s.exit_prompt = true; s.exit_yes = true; }
            } else {
                switch (a) {
                case Action::Left:
                case Action::Right: s.exit_yes = !s.exit_yes;              break;
                case Action::Escape: s.exit_prompt = false;                break;
                case Action::Enter:
                    s.exit_prompt = false;
                    if (s.exit_yes) leave = true;
                    break;
                default: break;
                }
            }
            break;
        }
    }
    if (refresh)       refresh_catalog(refresh_game, refresh_sha1);
    if (play)          start_play();
    if (build)         start_build();
    if (build_unknown) start_build_unknown();
    if (build_blind)   start_build_blind();
    if (cancel)        cancel_build();
    if (leave)         leave_game();
    if (opt_cycle)     cycle_option();
}

// ── the mouse (main thread, from the SDL pump in main.cpp) ───────────────────
// The draw pass wrote down every rectangle it drew that the pointer may act on; this is the other
// half of that pair. A click has NO code path of its own: it resolves to a row, a top-bar item or
// an Action, and the Action goes through ui_action() — the very function the keyboard and the pad
// call. That is why adding the mouse could not change what a key does.
namespace {

// SDL reports the pointer in WINDOW coordinates; the hit rectangles are in the framebuffer pixels
// the frame was laid out in. They are equal today, and this survives the day they are not.
void window_to_fb(float& x, float& y) {
    if (x < 0.0f || y < 0.0f) return;
    int ww = 0, wh = 0;
    if (g_window) SDL_GetWindowSize(g_window, &ww, &wh);
    const int fw = g_fb_w.load(std::memory_order_relaxed);
    const int fh = g_fb_h.load(std::memory_order_relaxed);
    if (ww > 0 && wh > 0 && fw > 0 && fh > 0) {
        x = x * (float)fw / (float)ww;
        y = y * (float)fh / (float)wh;
    }
}

int hit_at(const UiState& s, float x, float y) {
    if (x < 0.0f || y < 0.0f) return -1;
    for (size_t i = 0; i < s.hit.size(); i++) {
        const HitRect& r = s.hit[i];
        if (x >= r.x0 && x <= r.x1 && y >= r.y0 && y <= r.y1) return (int)i;
    }
    return -1;
}

// Recomputed from the STORED pointer position, not only when the pointer moves: what is under a
// still cursor changes when the list scrolls, when a build ends, when the screen changes.
void update_hover_locked(UiState& s) {
    s.hover_row = -1; s.hover_tab = -1; s.hover_hint = -1;
    const int i = hit_at(s, s.mouse_x, s.mouse_y);
    if (i < 0) return;
    const HitRect& r = s.hit[(size_t)i];
    switch (r.kind) {
    case HitKind::Row:  s.hover_row  = r.index; break;
    case HitKind::Tab:  s.hover_tab  = r.index; break;
    case HitKind::Hint: s.hover_hint = r.index; break;
    default: break;
    }
}

} // namespace

void ui_mouse_move(float x, float y) {
    // A module owns the window: the pointer is the game's, exactly as every key is.
    if (g_game_in_process.load(std::memory_order_acquire)) return;
    window_to_fb(x, y);
    UiState& s = ui();
    std::lock_guard<std::mutex> lock(s.mutex);
    s.mouse_x = x; s.mouse_y = y;
    update_hover_locked(s);
}

void ui_mouse_wheel(float dy) {
    if (g_game_in_process.load(std::memory_order_acquire)) return;
    if (dy == 0.0f) return;
    UiState& s = ui();
    std::lock_guard<std::mutex> lock(s.mutex);
    if (s.screen != Screen::Archive) return;
    const int fits = s.rows_visible > 0 ? s.rows_visible : 1;
    const int max_first = std::max(0, (int)s.entries.size() - fits);
    if (max_first == 0) return;                 // the whole library fits: there is nothing to scroll
    int step = (int)std::lround((double)dy);
    if (step == 0) step = (dy > 0.0f) ? 1 : -1;
    int first = s.list_scroll - step * 3;       // wheel away = up the list
    if (first < 0) first = 0;
    if (first > max_first) first = max_first;
    s.list_scroll = first;
    update_hover_locked(s);
}

void ui_mouse_click(float x, float y, int clicks) {
    if (g_game_in_process.load(std::memory_order_acquire)) return;
    window_to_fb(x, y);

    int    row  = -1;
    int    tab  = -1;
    Action act  = Action::None;
    bool   play = false;
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.mouse_x = x; s.mouse_y = y;
        update_hover_locked(s);
        const int i = hit_at(s, x, y);
        if (i >= 0) {
            const HitRect r = s.hit[(size_t)i];
            switch (r.kind) {
            case HitKind::Row:
                if (s.screen == Screen::Archive && r.index >= 0 && r.index < (int)s.entries.size()) {
                    row = r.index;
                    // A click on the row that is ALREADY selected plays it, and so does a double
                    // click — the two gestures a stranger will actually try.
                    play = (s.selected == r.index) || (clicks >= 2);
                    s.selected = r.index;
                }
                break;
            case HitKind::Tab:
                // A click goes straight to the item it names; LEFT/RIGHT still walk, unchanged.
                tab = r.index;
                if (tab >= 0 && tab < 4) { s.menu = tab; s.screen = screen_for_tab(tab); }
                break;
            case HitKind::Hint:
                act = r.action;
                break;
            default: break;
            }
        }
    }
    fprintf(stderr, "[launcher] mouse click (%.0f,%.0f) clicks=%d -> row=%d tab=%d action=%d play=%d\n",
            x, y, clicks, row, tab, (int)act, play ? 1 : 0);
    fflush(stderr);

    // ONE action path: whatever the pointer landed on ends up in the same call a key would make.
    if (play)                      ui_action(Action::Enter);
    else if (act != Action::None)  ui_action(act);
}

// --play <game>, set once before the engine starts (see launcher_app.hpp for why this exists).
static std::string g_pending_play;
void ui_request_play(const std::string& game) { g_pending_play = game; }

void ui_tick_main() {
    // THE COMMAND-LINE PLAY, taken on the first tick that has a catalog to look in. It must happen
    // here and not at startup: start_play() -> module_play() -> recomp::start_game(), and the engine
    // is only up once the main loop is running. Fires at most once either way, so a game the user
    // quits back out of does not relaunch itself.
    if (!g_pending_play.empty()) {
        static bool tried = false;
        if (!tried && !g_game_in_process.load(std::memory_order_acquire)) {
            const std::string want = g_pending_play;
            std::string lo_want;
            for (char c : want) lo_want += (char)std::tolower((unsigned char)c);
            int found = -1;
            bool have_entries = false;
            {
                UiState& s = ui();
                std::lock_guard<std::mutex> lock(s.mutex);
                have_entries = !s.entries.empty();
                for (size_t i = 0; i < s.entries.size(); i++) {
                    std::string lo;
                    for (char c : s.entries[i].game) lo += (char)std::tolower((unsigned char)c);
                    if (lo == lo_want) { found = (int)i; break; }
                }
                if (found >= 0) s.selected = found;
            }
            if (have_entries) {
                tried = true;                 // one attempt, whatever the outcome
                if (found >= 0) {
                    fprintf(stderr, "[launcher] --play %s -> row %d\n", want.c_str(), found);
                    fflush(stderr);
                    start_play();             // NOT under the lock: it takes the lock itself
                } else {
                    fprintf(stderr, "[launcher] --play %s: no game with that id in the library\n",
                            want.c_str());
                    fflush(stderr);
                    UiState& s = ui();
                    std::lock_guard<std::mutex> lock(s.mutex);
                    s.status = "no game called '" + want + "' - check the id in archive/";
                }
            }
        }
    }
    // The hover must stay honest between mouse events: the frame under a still pointer changes on
    // its own (a build finishes, the catalog is re-read, the list scrolls).
    {
        UiState& s = ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        if (g_game_in_process.load(std::memory_order_acquire)) {
            s.hover_row = -1; s.hover_tab = -1; s.hover_hint = -1;
        } else {
            update_hover_locked(s);
        }
    }
#if defined(_WIN32)
    // ── the BUILD child: when it has finished OK, the entry is now built. Re-read the catalog from
    //    disk (the exe is what makes a row BUILT, so this is the honest refresh), keep the game we
    //    built selected, and drop back to the library after a hold long enough to read the result.
    {
        bool go_library = false;
        std::string built_game;
        std::string built_sha1;
        {
            UiState& s = ui();
            std::lock_guard<std::mutex> lock(s.mutex);
            if (s.screen == Screen::Build && !s.build_running && !s.build_failed &&
                s.build_end > 0.0 && (now_seconds() - s.build_end) > 10.0) {
                go_library = true;
                built_game = s.build_game;
                built_sha1 = s.build_sha1;
            }
        }
        if (go_library) {
            // A BLIND BUILD NAMED ITSELF: the launcher never chose the id, the cart did, so the row
            // is found by the cart's SHA-1 - the one thing the launcher does know about it.
            refresh_catalog(built_game, built_sha1);
            UiState& s = ui();
            std::lock_guard<std::mutex> lock(s.mutex);
            if (built_game.empty() && s.selected >= 0 && s.selected < (int)s.entries.size()) {
                built_game = s.entries[s.selected].title;
            }
            s.screen = Screen::Archive;
            s.status = "built " + built_game + " - ENTER to play it";
        }
    }

    if (!g_child_live) return;
    if (WaitForSingleObject(g_child.hProcess, 0) != WAIT_OBJECT_0) return;
    CloseHandle(g_child.hProcess);
    CloseHandle(g_child.hThread);
    g_child = PROCESS_INFORMATION{};
    g_child_live = false;
    if (g_window) { SDL_RestoreWindow(g_window); SDL_RaiseWindow(g_window); }
    UiState& s = ui();
    std::lock_guard<std::mutex> lock(s.mutex);
    s.screen = Screen::Archive;
    s.play_running = false;
    s.status = "back from " + s.play_title;
    for (CatalogEntry& e : s.entries) {
        if (e.title == s.play_title) e.last_played = "just now";
    }
#endif
}

} // namespace launcher
