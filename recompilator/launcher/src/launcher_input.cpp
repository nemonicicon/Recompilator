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
 * Keyboard map, kept byte-for-byte identical to the port trees' src/input.cpp so that every
 * existing capture script and every player's muscle memory still works:
 *   Z = A · X = B · LSHIFT = Z · RETURN = START · arrows = D-pad · WASD = analog stick.
 */

#include <cstdint>
#include <cstdio>
#include <algorithm>

#include "SDL.h"
#include "ultramodern/input.hpp"
#include "ultramodern/ultramodern.hpp"

namespace {

// N64 button bit masks (libultra osContPad).
constexpr uint16_t N64_A      = 0x8000;
constexpr uint16_t N64_B      = 0x4000;
constexpr uint16_t N64_Z      = 0x2000;
constexpr uint16_t N64_START  = 0x1000;
constexpr uint16_t N64_DUP    = 0x0800;
constexpr uint16_t N64_DDOWN  = 0x0400;
constexpr uint16_t N64_DLEFT  = 0x0200;
constexpr uint16_t N64_DRIGHT = 0x0100;
constexpr uint16_t N64_L      = 0x0020;
constexpr uint16_t N64_R      = 0x0010;
constexpr uint16_t N64_CUP    = 0x0008;
constexpr uint16_t N64_CDOWN  = 0x0004;
constexpr uint16_t N64_CLEFT  = 0x0002;
constexpr uint16_t N64_CRIGHT = 0x0001;

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
        auto btn = [](SDL_GameControllerButton b) {
            return SDL_GameControllerGetButton(g_pad, b) != 0;
        };
        if (btn(SDL_CONTROLLER_BUTTON_A))             *buttons |= N64_A;
        if (btn(SDL_CONTROLLER_BUTTON_B))             *buttons |= N64_B;
        if (btn(SDL_CONTROLLER_BUTTON_BACK))          *buttons |= N64_Z;
        if (btn(SDL_CONTROLLER_BUTTON_START))         *buttons |= N64_START;
        if (btn(SDL_CONTROLLER_BUTTON_DPAD_UP))       *buttons |= N64_DUP;
        if (btn(SDL_CONTROLLER_BUTTON_DPAD_DOWN))     *buttons |= N64_DDOWN;
        if (btn(SDL_CONTROLLER_BUTTON_DPAD_LEFT))     *buttons |= N64_DLEFT;
        if (btn(SDL_CONTROLLER_BUTTON_DPAD_RIGHT))    *buttons |= N64_DRIGHT;
        if (btn(SDL_CONTROLLER_BUTTON_LEFTSHOULDER))  *buttons |= N64_L;
        if (btn(SDL_CONTROLLER_BUTTON_RIGHTSHOULDER)) *buttons |= N64_R;

        const Sint16 rx = SDL_GameControllerGetAxis(g_pad, SDL_CONTROLLER_AXIS_RIGHTX);
        const Sint16 ry = SDL_GameControllerGetAxis(g_pad, SDL_CONTROLLER_AXIS_RIGHTY);
        constexpr Sint16 DEAD = 12000;
        if (ry < -DEAD) *buttons |= N64_CUP;
        if (ry >  DEAD) *buttons |= N64_CDOWN;
        if (rx < -DEAD) *buttons |= N64_CLEFT;
        if (rx >  DEAD) *buttons |= N64_CRIGHT;

        const Sint16 lx = SDL_GameControllerGetAxis(g_pad, SDL_CONTROLLER_AXIS_LEFTX);
        const Sint16 ly = SDL_GameControllerGetAxis(g_pad, SDL_CONTROLLER_AXIS_LEFTY);
        *x =  (float)lx / 32767.0f;
        *y = -(float)ly / 32767.0f;   // N64 Y is inverted relative to SDL
        return true;
    }

    const Uint8* kb = SDL_GetKeyboardState(nullptr);
    if (kb == nullptr) return true;
    if (kb[SDL_SCANCODE_Z])      *buttons |= N64_A;
    if (kb[SDL_SCANCODE_X])      *buttons |= N64_B;
    if (kb[SDL_SCANCODE_LSHIFT]) *buttons |= N64_Z;
    if (kb[SDL_SCANCODE_RETURN]) *buttons |= N64_START;
    if (kb[SDL_SCANCODE_UP])     *buttons |= N64_DUP;
    if (kb[SDL_SCANCODE_DOWN])   *buttons |= N64_DDOWN;
    if (kb[SDL_SCANCODE_LEFT])   *buttons |= N64_DLEFT;
    if (kb[SDL_SCANCODE_RIGHT])  *buttons |= N64_DRIGHT;
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
