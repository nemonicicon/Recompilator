/**
 * main.cpp — RECOMPILATOR, the one program's front door (step 1: the skeleton).
 *
 * The brief (2026-09-06): one program, presented like an emulator, that lets you select a ROM,
 * recompile and build it, then play it.
 *
 * This boots the engine EXACTLY as a port's main.cpp does — SDL window -> recomp::start(cfg) with
 * the same callbacks — and then does NOT call recomp::start_game(). With no game registered the VI
 * thread still runs a dummy VI at 60 Hz, RT64 still presents, and the launcher draws the LIBRARY /
 * ADD ROM / BUILD / PLAY states with ImGui on RT64's own present (see launcher_ui.cpp).
 *
 * NEVER PER-GAME CODE IN THIS HOST. Everything a game needs comes from its catalog entry
 * (recompilator/catalog/<game>/entry.json) and the path of its built exe.
 */

#if defined(_WIN32)
#  include <Windows.h>
#endif

#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <mutex>
#include <string>

#define SDL_MAIN_HANDLED
#include "SDL.h"
#include "SDL_syswm.h"

#include "recomp.h"
#include "librecomp/game.hpp"
#include "librecomp/rsp.hpp"
#include "ultramodern/ultramodern.hpp"
#include "ultramodern/renderer_context.hpp"
#include "ultramodern/error_handling.hpp"

#include "rt64_renderer.hpp"
#include "launcher_app.hpp"

namespace fs = std::filesystem;

static SDL_Window* g_window = nullptr;

// The engine's own present-FPS counter (ultramodern/src/events.cpp).
extern std::atomic<double> g_cv64_present_fps;

// ── error box ────────────────────────────────────────────────────────────────
static void show_error(const char* title, const char* msg) {
#if defined(_WIN32)
    MessageBoxA(nullptr, msg, title, MB_ICONERROR | MB_OK);
#else
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, title, msg, nullptr);
#endif
}
static void launcher_message_box(const char* msg) { show_error("Recompilator", msg); }

// ── gfx callbacks ────────────────────────────────────────────────────────────
static ultramodern::gfx_callbacks_t::gfx_data_t create_gfx() {
    if (SDL_InitSubSystem(SDL_INIT_VIDEO) != 0) {
        show_error("SDL_InitSubSystem Error", SDL_GetError());
    }
    return nullptr;
}

// The window opens on the PRIMARY display: the one whose bounds start at the desktop origin,
// matched by bounds rather than by index or device name so a renumber cannot move it. Anything
// that wants the window elsewhere (a test bench with a spare panel) moves it after creation.
static bool pick_panel(int* x, int* y, int* w, int* h) {
    const int count = SDL_GetNumVideoDisplays();
    int best = -1;
    for (int i = 0; i < count; i++) {
        SDL_Rect b{};
        if (SDL_GetDisplayBounds(i, &b) != 0) continue;
        if (b.x == 0 && b.y == 0) { best = i; break; }
    }
    if (best < 0 && count > 0) best = 0;
    if (best < 0) return false;

    SDL_Rect usable{};
    if (SDL_GetDisplayUsableBounds(best, &usable) != 0) {
        if (SDL_GetDisplayBounds(best, &usable) != 0) return false;
    }
    const int margin = 40;
    *x = usable.x + margin;
    *y = usable.y + margin;
    *w = usable.w - margin * 2;
    *h = usable.h - margin * 2;
    if (*w < 640) *w = 640;
    if (*h < 480) *h = 480;
    fprintf(stderr, "[launcher] display %d bounds usable=(%d,%d) %dx%d -> window (%d,%d) %dx%d\n",
            best, usable.x, usable.y, usable.w, usable.h, *x, *y, *w, *h);
    return true;
}

static ultramodern::renderer::WindowHandle
create_window(ultramodern::gfx_callbacks_t::gfx_data_t /*gfx_data*/)
{
    Uint32 flags = SDL_WINDOW_RESIZABLE;
#if !defined(_WIN32)
    flags |= SDL_WINDOW_VULKAN;
#endif
    int x = SDL_WINDOWPOS_CENTERED, y = SDL_WINDOWPOS_CENTERED, w = 1360, h = 820;
    pick_panel(&x, &y, &w, &h);

    g_window = SDL_CreateWindow("Recompilator", x, y, w, h, flags);
    if (!g_window) {
        show_error("Window Creation Error", SDL_GetError());
        std::exit(1);
    }
    launcher::ui_set_window(g_window);

#if defined(_WIN32)
    SDL_SysWMinfo wm_info;
    SDL_VERSION(&wm_info.version);
    SDL_GetWindowWMInfo(g_window, &wm_info);
    return ultramodern::renderer::WindowHandle{ wm_info.info.win.window, GetCurrentThreadId() };
#elif defined(__APPLE__)
    SDL_SysWMinfo wm_info;
    SDL_VERSION(&wm_info.version);
    SDL_GetWindowWMInfo(g_window, &wm_info);
    SDL_MetalView mv = SDL_Metal_CreateView(g_window);
    return ultramodern::renderer::WindowHandle{ wm_info.info.cocoa.window, SDL_Metal_GetLayer(mv) };
#else
    return g_window;
#endif
}

// ── input: keyboard + one pad, straight into the launcher's state machine ────
static SDL_GameController* g_pad = nullptr;

static void open_pad() {
    for (int i = 0; i < SDL_NumJoysticks(); i++) {
        if (SDL_IsGameController(i)) {
            g_pad = SDL_GameControllerOpen(i);
            if (g_pad) { launcher::input_set_pad(g_pad); return; }
        }
    }
    launcher::input_set_pad(g_pad);
}

static void poll_pad() {
    if (!g_pad) return;
    // A module owns the window: the pad is the game's, not the menu's. LEAVING a game is the
    // Esc key and nothing else - the pad's middle button was tried and is a poor fit on a PC
    // (2026-09-07: the Esc key on the keyboard, and
    // leave it at that). While the leave-or-not question is up the pad still drives it, because that
    // question is what is on screen.
    if (launcher::ui_game_in_process() && !launcher::ui_exit_prompt()) return;
    struct Bind { SDL_GameControllerButton btn; launcher::Action action; };
    static const Bind binds[] = {
        { SDL_CONTROLLER_BUTTON_DPAD_UP,    launcher::Action::Up     },
        { SDL_CONTROLLER_BUTTON_DPAD_DOWN,  launcher::Action::Down   },
        { SDL_CONTROLLER_BUTTON_DPAD_LEFT,  launcher::Action::Left   },
        { SDL_CONTROLLER_BUTTON_DPAD_RIGHT, launcher::Action::Right  },
        { SDL_CONTROLLER_BUTTON_A,          launcher::Action::Enter  },
        { SDL_CONTROLLER_BUTTON_START,      launcher::Action::Enter  },
        { SDL_CONTROLLER_BUTTON_B,          launcher::Action::Escape },
        { SDL_CONTROLLER_BUTTON_Y,          launcher::Action::AddRom },
        { SDL_CONTROLLER_BUTTON_X,          launcher::Action::Build   },
    };
    static bool held[SDL_arraysize(binds)] = {};
    for (size_t i = 0; i < SDL_arraysize(binds); i++) {
        const bool down = SDL_GameControllerGetButton(g_pad, binds[i].btn) != 0;
        if (down && !held[i]) launcher::ui_action(binds[i].action);
        held[i] = down;
    }
}

static void update_gfx(ultramodern::gfx_callbacks_t::gfx_data_t /*gfx_data*/) {
    SDL_Event e;
    while (SDL_PollEvent(&e)) {
        switch (e.type) {
        case SDL_QUIT:
            ultramodern::quit();
            break;
        case SDL_CONTROLLERDEVICEADDED:
            if (!g_pad) { g_pad = SDL_GameControllerOpen(e.cdevice.which); launcher::input_set_pad(g_pad); }
            break;
        case SDL_CONTROLLERDEVICEREMOVED:
            if (g_pad) { SDL_GameControllerClose(g_pad); g_pad = nullptr; open_pad(); }
            break;
        case SDL_KEYDOWN:
            // STEP 3: once a game module has taken this window, EVERY key is the game's. The game
            // reads SDL_GetKeyboardState(), which this very pump refreshes, so the launcher simply
            // stops consuming keys rather than forwarding them.
            // ...except ESC, which is how you leave a game, and every key once the
            // leave-or-not question is up.
            if (launcher::ui_game_in_process() && !launcher::ui_exit_prompt()) {
                if (e.key.keysym.sym == SDLK_ESCAPE) launcher::ui_action(launcher::Action::Escape);
                break;
            }
            switch (e.key.keysym.sym) {
            case SDLK_UP:       launcher::ui_action(launcher::Action::Up);     break;
            case SDLK_DOWN:     launcher::ui_action(launcher::Action::Down);   break;
            case SDLK_LEFT:     launcher::ui_action(launcher::Action::Left);   break;
            case SDLK_RIGHT:    launcher::ui_action(launcher::Action::Right);  break;
            case SDLK_RETURN:
            case SDLK_KP_ENTER: launcher::ui_action(launcher::Action::Enter);  break;
            case SDLK_ESCAPE:   launcher::ui_action(launcher::Action::Escape); break;
            case SDLK_a:        launcher::ui_action(launcher::Action::AddRom); break;
            case SDLK_b:        launcher::ui_action(launcher::Action::Build);   break;
            case SDLK_q:        launcher::ui_action(launcher::Action::Quit);   break;
            default: break;
            }
            break;

        // ── the mouse ────────────────────────────────────────────────────────────────────────
        // THE SAME RULE AS THE KEYBOARD, for the same reason: once a game module has taken this
        // window every mouse event belongs to the game, so the launcher stops consuming them
        // rather than forwarding them. Nothing above this point changed — a key still travels
        // exactly the path it travelled before, which is what the bench's PostMessage'd keys drive.
        case SDL_MOUSEMOTION:
            if (launcher::ui_game_in_process()) break;
            launcher::ui_mouse_move((float)e.motion.x, (float)e.motion.y);
            break;
        case SDL_MOUSEBUTTONDOWN:
            if (launcher::ui_game_in_process()) break;
            if (e.button.button == SDL_BUTTON_LEFT) {
                launcher::ui_mouse_click((float)e.button.x, (float)e.button.y, (int)e.button.clicks);
            }
            break;
        case SDL_MOUSEWHEEL:
            if (launcher::ui_game_in_process()) break;
            launcher::ui_mouse_wheel((float)e.wheel.y);
            break;
        case SDL_WINDOWEVENT:
            // The pointer left the window: nothing may stay highlighted behind it.
            if (e.window.event == SDL_WINDOWEVENT_LEAVE && !launcher::ui_game_in_process()) {
                launcher::ui_mouse_move(-1.0f, -1.0f);
            }
            break;

        default: break;
        }
    }
    poll_pad();
    launcher::ui_tick_main();

    // With a module running, the launcher's window IS the game's window, so it carries the game's
    // name and its present rate the way every <game>pc.exe title bar always has. The counter is the
    // engine's own (ultramodern/src/events.cpp), not a number this file computes.
    if (launcher::ui_game_in_process() && g_window != nullptr) {
        static std::string game_title;
        if (game_title.empty()) {
            launcher::UiState& s = launcher::ui();
            std::lock_guard<std::mutex> lock(s.mutex);
            game_title = s.play_title.empty() ? "game" : s.play_title;
        }
        static double last_fps = -1.0;
        const double fps = g_cv64_present_fps.load(std::memory_order_relaxed);
        if (fps != last_fps) {
            last_fps = fps;
            char title[160];
            snprintf(title, sizeof(title), "Recompilator  -  %s  -  %.1f FPS", game_title.c_str(), fps);
            SDL_SetWindowTitle(g_window, title);
        }
    }
}

// ── the rest of the port contract ────────────────────────────────────────────
static void vi_callback() {}
static void gfx_init_callback() {}
static std::string get_thread_name(const OSThread* t) {
    return "recompilator_" + std::to_string(t->id);
}
// Until a game module registers its own dispatch (launcher_module.cpp calls
// recomp::rsp::set_callbacks with the module's), no RSP task can arrive: there is no game.
static RspUcodeFunc* get_rsp_microcode(const OSTask* /*task*/) { return nullptr; }

static int launcher_main(int argc, char** argv) {
    SDL_SetMainReady();

    // --play <game> / --play=<game>: open that game and skip the library. See launcher_app.hpp.
    std::string play_game;
    for (int i = 1; i < argc; i++) {
        const std::string a = (argv && argv[i]) ? argv[i] : "";
        if ((a == "--play" || a == "-p") && i + 1 < argc) play_game = argv[++i];
        else if (a.rfind("--play=", 0) == 0)              play_game = a.substr(7);
    }

    const fs::path config_path = launcher::config_dir();
    {
        FILE* f = nullptr;
        const std::string diag = (config_path / "recompilator_diag.log").string();
#if defined(_WIN32)
        freopen_s(&f, diag.c_str(), "w", stderr);
#else
        f = freopen(diag.c_str(), "w", stderr);
#endif
        if (f) { setvbuf(f, nullptr, _IONBF, 0); fprintf(stderr, "[launcher] diagnostic log started\n"); }
    }

    recomp::register_config_path(config_path);

    // The catalog IS the launcher's content. No game is registered with librecomp.
    {
        launcher::UiState& s = launcher::ui();
        std::lock_guard<std::mutex> lock(s.mutex);
        s.root = launcher::find_root();
        s.entries = launcher::scan_catalog(s.root);
        s.selected = 0;
        s.status = s.root.empty() ? "N64PC root not found" : "";
        fprintf(stderr, "[launcher] root=%s entries=%zu\n", s.root.c_str(), s.entries.size());
        for (const auto& e : s.entries) {
            fprintf(stderr, "[launcher]   %-22s %-10s %-12s %s\n", e.game.c_str(),
                    e.release.c_str(), e.state_label.c_str(),
                    e.exe_path.empty() ? "(no exe)" : e.exe_path.c_str());
        }
    }

    SDL_InitSubSystem(SDL_INIT_GAMECONTROLLER);
    open_pad();
    // The host's own audio device, opened before recomp::start() because ultramodern takes the
    // audio and input callbacks once, at start(), and a game module arrives long after that.
    launcher::audio_init();

    recomp::Configuration cfg{};
    cfg.project_version    = { 0, 1, 0, "" };
    cfg.rsp_callbacks      = { .get_rsp_microcode = get_rsp_microcode };
    cfg.renderer_callbacks = { .create_render_context = launcher::renderer::create_render_context };
    // STEP 3: the HOST owns the audio and input backends now (launcher_audio.cpp /
    // launcher_input.cpp). They are silent and idle until a module registers a game; from then on
    // they are that game's, and there is no second window to hand the keyboard to.
    cfg.audio_callbacks    = launcher::audio_callbacks();
    cfg.input_callbacks    = launcher::input_callbacks();
    cfg.gfx_callbacks      = {
        .create_gfx    = create_gfx,
        .create_window = create_window,
        .update_gfx    = update_gfx,
    };
    cfg.events_callbacks   = { .vi_callback = vi_callback, .gfx_init_callback = gfx_init_callback };
    cfg.error_handling_callbacks = { .message_box = launcher_message_box };
    cfg.threads_callbacks  = { .get_game_thread_name = get_thread_name };
    cfg.message_queue_control = {
        .requeue_timer = true,
        .requeue_sp    = true,
        .requeue_si    = true,
        .requeue_ai    = false,
        .requeue_vi    = false,
        .requeue_pi    = false,
        .requeue_dp    = true,
    };

    // Boots the engine and runs the main loop. start_game() is DELIBERATELY not called: the
    // launcher owns the window until the user picks something. (Step 3 turns PLAY into a
    // start_game() in this same window; step 1 spawns the game's own exe.)
    if (!play_game.empty()) launcher::ui_request_play(play_game);

    recomp::start(cfg);

    SDL_Quit();
    return 0;
}

#if defined(_WIN32)
int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int) {
    return launcher_main(__argc, __argv);
}
#else
int main(int argc, char** argv) { return launcher_main(argc, argv); }
#endif
