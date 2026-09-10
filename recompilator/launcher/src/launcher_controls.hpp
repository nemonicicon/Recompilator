/**
 * launcher_controls.hpp — what the pad and the keyboard are bound to, and where that is kept.
 *
 * One table for the whole program: the CONTROLS screen edits it, the input backend reads it for
 * every game the host loads, and it is written to controls.ini in the launcher's own settings
 * folder so it survives a restart. Nothing here knows which game is running.
 */

#pragma once

#include <cstdint>
#include <string>

#include "SDL.h"

namespace launcher {
namespace controls {

// The N64 controller's buttons, in the order the CONTROLS screen lists them.
enum class Btn { A, B, Z, Start, L, R, CUp, CDown, CLeft, CRight, DUp, DDown, DLeft, DRight, Count };
constexpr int COUNT = (int)Btn::Count;

// What on the gamepad a button is bound to: a button, or one direction of an axis (a trigger).
struct PadBind {
    int kind  = 0;    // 0 = nothing · 1 = SDL_GameControllerButton in `index` · 2 = SDL_GameControllerAxis
    int index = -1;
    int sign  = 1;    // for an axis: +1 = pushed past the threshold, -1 = pulled the other way
};

struct Binding {
    PadBind pad;
    int     key = 0;  // SDL_Scancode, 0 = nothing
};

const char* name(Btn b);          // "A", "B", "Z", "Start", "L", "R", "C up", ..., "D-pad right"
uint16_t    mask(Btn b);          // the libultra button bit

Binding get(Btn b);
void    set_pad(Btn b, PadBind p);
void    set_key(Btn b, int scancode);
void    reset_defaults();

// controls.ini under `dir`. load() leaves the defaults in place when there is no file.
bool load(const std::string& dir);
bool save(const std::string& dir);

// Labels for the screen: "LB", "Back", "LT", "Left Shift", "-" when unbound.
std::string pad_label(const PadBind& p);
std::string key_label(int scancode);

// The N64 button word read through the current bindings. The right stick always adds the C
// buttons on top of whatever they are bound to; the control stick itself is read by the caller.
uint16_t read_pad(SDL_GameController* pad);
uint16_t read_keys(const uint8_t* keyboard_state);

} // namespace controls
} // namespace launcher
