/**
 * input.cpp â€” SDL2 gamepad / keyboard input backend for SHADOWSPC.
 *
 * Maps SDL2 gamepad buttons to N64 controller buttons.
 * Keyboard is supported as a fallback controller.
 */

#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <algorithm>

#include "SDL.h"
#include "ultramodern/input.hpp"
#include "ultramodern/ultramodern.hpp"

// N64 button bit masks (from libultra osContPad definition).
#define N64_A      0x8000
#define N64_B      0x4000
#define N64_Z      0x2000
#define N64_START  0x1000
#define N64_DUP    0x0800
#define N64_DDOWN  0x0400
#define N64_DLEFT  0x0200
#define N64_DRIGHT 0x0100
#define N64_L      0x0020
#define N64_R      0x0010
#define N64_CUP    0x0008
#define N64_CDOWN  0x0004
#define N64_CLEFT  0x0002
#define N64_CRIGHT 0x0001

static SDL_GameController* controller = nullptr;
static bool rumble_active = false;

// Open the first available gamepad.
static void open_controller() {
    for (int i = 0; i < SDL_NumJoysticks(); i++) {
        if (SDL_IsGameController(i)) {
            controller = SDL_GameControllerOpen(i);
            if (controller) break;
        }
    }
}

void shadows_poll_input() {
    SDL_Event e;
    while (SDL_PollEvent(&e)) {
        switch (e.type) {
        case SDL_CONTROLLERDEVICEADDED:
            if (!controller) {
                controller = SDL_GameControllerOpen(e.cdevice.which);
            }
            break;
        case SDL_CONTROLLERDEVICEREMOVED:
            if (controller && SDL_GameControllerGetJoystick(controller) ==
                               SDL_JoystickFromInstanceID(e.cdevice.which)) {
                SDL_GameControllerClose(controller);
                controller = nullptr;
                open_controller();
            }
            break;
        case SDL_QUIT:
            fprintf(stderr, "[quitwatch] SDL_QUIT received in shadows_poll_input\n"); fflush(stderr);
            ultramodern::quit();
            break;
        default:
            break;
        }
    }
}

bool shadows_get_input(int controller_num, uint16_t* buttons, float* x, float* y) {
    if (controller_num != 0) return false;

    *buttons = 0;
    *x = 0.0f;
    *y = 0.0f;

    if (controller) {
        // Gamepad
        auto btn = [](SDL_GameController* c, SDL_GameControllerButton b) {
            return SDL_GameControllerGetButton(c, b) != 0;
        };
        if (btn(controller, SDL_CONTROLLER_BUTTON_A))             *buttons |= N64_A;
        if (btn(controller, SDL_CONTROLLER_BUTTON_B))             *buttons |= N64_B;
        if (btn(controller, SDL_CONTROLLER_BUTTON_BACK))          *buttons |= N64_Z;
        if (btn(controller, SDL_CONTROLLER_BUTTON_START))         *buttons |= N64_START;
        if (btn(controller, SDL_CONTROLLER_BUTTON_DPAD_UP))       *buttons |= N64_DUP;
        if (btn(controller, SDL_CONTROLLER_BUTTON_DPAD_DOWN))     *buttons |= N64_DDOWN;
        if (btn(controller, SDL_CONTROLLER_BUTTON_DPAD_LEFT))     *buttons |= N64_DLEFT;
        if (btn(controller, SDL_CONTROLLER_BUTTON_DPAD_RIGHT))    *buttons |= N64_DRIGHT;
        if (btn(controller, SDL_CONTROLLER_BUTTON_LEFTSHOULDER))  *buttons |= N64_L;
        if (btn(controller, SDL_CONTROLLER_BUTTON_RIGHTSHOULDER)) *buttons |= N64_R;
        // C-buttons mapped to right stick cardinal directions
        Sint16 rx = SDL_GameControllerGetAxis(controller, SDL_CONTROLLER_AXIS_RIGHTX);
        Sint16 ry = SDL_GameControllerGetAxis(controller, SDL_CONTROLLER_AXIS_RIGHTY);
        constexpr Sint16 DEAD = 12000;
        if (ry < -DEAD) *buttons |= N64_CUP;
        if (ry >  DEAD) *buttons |= N64_CDOWN;
        if (rx < -DEAD) *buttons |= N64_CLEFT;
        if (rx >  DEAD) *buttons |= N64_CRIGHT;

        // Left analog stick â†’ N64 stick (-1.0 â€¦ +1.0)
        Sint16 lx = SDL_GameControllerGetAxis(controller, SDL_CONTROLLER_AXIS_LEFTX);
        Sint16 ly = SDL_GameControllerGetAxis(controller, SDL_CONTROLLER_AXIS_LEFTY);
        *x =  (float)lx / 32767.0f;
        *y = -(float)ly / 32767.0f;  // N64 Y is inverted vs SDL
    } else {
        // Keyboard fallback
        const Uint8* kb = SDL_GetKeyboardState(nullptr);
        if (kb[SDL_SCANCODE_Z])      *buttons |= N64_A;
        if (kb[SDL_SCANCODE_X])      *buttons |= N64_B;
        if (kb[SDL_SCANCODE_LSHIFT]) *buttons |= N64_Z;
        if (kb[SDL_SCANCODE_RETURN]) *buttons |= N64_START;
        if (kb[SDL_SCANCODE_UP])     *buttons |= N64_DUP;
        if (kb[SDL_SCANCODE_DOWN])   *buttons |= N64_DDOWN;
        if (kb[SDL_SCANCODE_LEFT])   *buttons |= N64_DLEFT;
        if (kb[SDL_SCANCODE_RIGHT])  *buttons |= N64_DRIGHT;

        // WASD â†’ analog stick
        if (kb[SDL_SCANCODE_A]) *x -= 1.0f;
        if (kb[SDL_SCANCODE_D]) *x += 1.0f;
        if (kb[SDL_SCANCODE_W]) *y += 1.0f;
        if (kb[SDL_SCANCODE_S]) *y -= 1.0f;
        *x = std::clamp(*x, -1.0f, 1.0f);
        *y = std::clamp(*y, -1.0f, 1.0f);
    }
    // [autopress 08-27] MOVED OUT of the keyboard-fallback branch. It lived inside the `else`,
    // so with a gamepad connected it never fired — every unattended "pressed START, nothing
    // happened" measurement on this bench was really "no button was ever pressed". Synthetic
    // presses now OR into the real pad state regardless of which device is present.
    // RECOMP_AUTOPRESS=1 arms it; RECOMP_AP_MASK: 'a' = A only, 's' = START only, unset = both.
    {
        static const bool ap_on = [] { const char* e = std::getenv("RECOMP_AUTOPRESS"); return (e != nullptr) && (e[0] == '1'); }();
        static const char ap_mask = [] { const char* e = std::getenv("RECOMP_AP_MASK"); return (e != nullptr) ? e[0] : 'b'; }();
        if (ap_on) {
            static uint32_t ap_tick = 0;
            static bool announced = false;
            if (!announced) {
                announced = true;
                fprintf(stderr, "[autopress] armed (mask=%c) with %s present\n",
                        ap_mask, controller ? "GAMEPAD" : "keyboard-only");
                fflush(stderr);
            }
            ++ap_tick;
            // [mask 'p' = PLAY] release EVERYTHING once the menus are walked: A-spam thrashes
            // the pause/resume transition in-level (measured: duplicate "Return to Battle!"
            // banners, mission timer frozen at 2:08). After tick 9000 'p' presses nothing, so
            // the game sits in-level untouched and a screenshot lands on real gameplay.
            // Gate on WALL TIME, not tick count: ap_tick counts input polls, so at SOTE's 30fps a
            // 9000-tick window is 300s -- longer than a whole bench run, and the release never
            // happened (measured: every burst frame still landed on the pause menu). Seconds are
            // frame-rate independent. RECOMP_AP_SECS overrides the default.
            static const unsigned ap_secs = [] {
                const char* e = std::getenv("RECOMP_AP_SECS");
                return (e != nullptr) ? (unsigned)strtoul(e, nullptr, 10) : 200u;
            }();
            static const auto ap_t0 = std::chrono::steady_clock::now();
            const unsigned ap_elapsed = (unsigned)std::chrono::duration_cast<std::chrono::seconds>(
                std::chrono::steady_clock::now() - ap_t0).count();
            const bool ap_live = (ap_mask != 'p') || (ap_elapsed < ap_secs);
            if (ap_mask != 's' && ap_live && (ap_tick % 30u) < 4u) *buttons |= N64_A;
            // START at the cutscene goes straight to the main menu on hardware (a cen64
            // observation) — press it every ~4s after the first 8s.
            // [mask 'p' = PLAY, 2026-08-28] 'b' keeps pressing START forever, so once a level is
            // loaded every screenshot lands on the PAUSE menu (measured: 10 burst frames, all
            // paused, while the mission timer advanced underneath). 'p' presses START only long
            // enough to walk the intro/menus/briefing, then stops — A keeps firing. Bench
            // instrument for capturing real in-level frames; changes no engine behaviour.
            const bool ap_start_window = ap_live;
            if (ap_mask != 'a' && ap_start_window && ap_tick > 240u && (ap_tick % 120u) < 4u) *buttons |= N64_START;
        }
    }
    return true;
}

void shadows_set_rumble(int controller_num, bool rumble) {
    if (controller_num != 0 || !controller) return;
    rumble_active = rumble;
    Uint16 strength = rumble ? 0xFFFF : 0;
    SDL_GameControllerRumble(controller, strength, strength, rumble ? 0xFFFF : 0);
}

ultramodern::input::connected_device_info_t shadows_get_connected_device(int controller_num) {
    if (controller_num != 0) {
        return { ultramodern::input::Device::None, ultramodern::input::Pak::None };
    }
    // Always report port 0 as having a controller.  shadows_get_input() already supplies
    // keyboard input when no SDL gamepad is present (via the else-branch).  If we
    // return Device::None here, the game treats port 0 as empty, never reads buttons,
    // and immediately starts the demo-attract countdown â€” making the title screen
    // appear non-interactive even though keyboard is fully mapped.
    return { ultramodern::input::Device::Controller, ultramodern::input::Pak::None };
}

void shadows_input_init() {
    SDL_InitSubSystem(SDL_INIT_GAMECONTROLLER);
    open_controller();
}

ultramodern::input::callbacks_t get_input_callbacks() {
    return {
        .poll_input              = shadows_poll_input,
        .get_input               = shadows_get_input,
        .set_rumble              = shadows_set_rumble,
        .get_connected_device_info = shadows_get_connected_device,
    };
}
