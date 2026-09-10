/**
 * launcher_input.cpp — THE HOST'S controller backend (Recompilator UI step 3, 2026-09-06).
 *
 * One SDL gamepad (or the keyboard) mapped to N64 port 0, shared by every game the host loads as a
 * module. A HOST SERVICE, not per-game code — the mapping is identical in every scaffolded port
 * tree, which is exactly why it belongs here now that there is one window and one input path.
 *
 * `poll_input` is deliberately EMPTY. It is called from the guest's controller-read path, which is
 * not the main thread, and SDL_PollEvent must only run on the thread that made the window. The
 * launcher's own update_gfx pump (main.cpp) already drains the event queue every frame, which is
 * what refreshes SDL_GetKeyboardState() and the cached gamepad state read below.
 *
 * The bindings themselves live in launcher_controls.cpp: the CONTROLS screen edits them and
 * they are read here through controls::read_pad / read_keys. Only the analog stick is fixed
 * (the left stick, or W A S D).
 */

#include <cstdint>
#include <cstdio>
#include <algorithm>

#include "SDL.h"
#include "launcher_controls.hpp"
#include "ultramodern/input.hpp"
#include "ultramodern/ultramodern.hpp"

namespace {


SDL_GameController* g_pad = nullptr;

void poll_input() {
    // Intentionally empty; see the file header.
}

bool get_input(int controller_num, uint16_t* buttons, float* x, float* y) {
    if (controller_num != 0) return false;

    *buttons = 0;
    *x = 0.0f;
    *y = 0.0f;

    if (g_pad != nullptr) {
        *buttons |= launcher::controls::read_pad(g_pad);

        const Sint16 lx = SDL_GameControllerGetAxis(g_pad, SDL_CONTROLLER_AXIS_LEFTX);
        const Sint16 ly = SDL_GameControllerGetAxis(g_pad, SDL_CONTROLLER_AXIS_LEFTY);
        *x =  (float)lx / 32767.0f;
        *y = -(float)ly / 32767.0f;   // N64 Y is inverted relative to SDL
        return true;
    }

    const Uint8* kb = SDL_GetKeyboardState(nullptr);
    if (kb == nullptr) return true;
    *buttons |= launcher::controls::read_keys(kb);
    if (kb[SDL_SCANCODE_A]) *x -= 1.0f;
    if (kb[SDL_SCANCODE_D]) *x += 1.0f;
    if (kb[SDL_SCANCODE_W]) *y += 1.0f;
    if (kb[SDL_SCANCODE_S]) *y -= 1.0f;
    *x = std::clamp(*x, -1.0f, 1.0f);
    *y = std::clamp(*y, -1.0f, 1.0f);
    return true;
}

void set_rumble(int controller_num, bool rumble) {
    if (controller_num != 0 || g_pad == nullptr) return;
    const Uint16 strength = rumble ? 0xFFFF : 0;
    SDL_GameControllerRumble(g_pad, strength, strength, rumble ? 0xFFFF : 0);
}

ultramodern::input::connected_device_info_t get_connected_device(int controller_num) {
    if (controller_num != 0) {
        return { ultramodern::input::Device::None, ultramodern::input::Pak::None };
    }
    // Port 0 always reports a controller: get_input() supplies keyboard state when no pad is
    // present, and a game told port 0 is empty never reads buttons and starts its attract demo.
    return { ultramodern::input::Device::Controller, ultramodern::input::Pak::None };
}

} // namespace

namespace launcher {

// main.cpp owns the pad handle for the menu; this keeps the game's view of it in step.
void input_set_pad(void* pad) { g_pad = (SDL_GameController*)pad; }

ultramodern::input::callbacks_t input_callbacks() {
    return ultramodern::input::callbacks_t{
        .poll_input                = poll_input,
        .get_input                 = get_input,
        .set_rumble                = set_rumble,
        .get_connected_device_info = get_connected_device,
    };
}

} // namespace launcher
