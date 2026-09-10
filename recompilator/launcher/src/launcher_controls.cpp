/**
 * launcher_controls.cpp — the binding table, its defaults, its file, and the two reads.
 *
 * The defaults put the N64's Z on the LEFT BUMPER, where a thumb resting on a modern pad expects a
 * trigger-like button, and L on Back. Everything is rebindable from the CONTROLS screen; the file
 * is plain text, one line per N64 button, and a line the program cannot read is skipped.
 */

#include "launcher_controls.hpp"

#include <cstdio>
#include <cstring>
#include <fstream>
#include <string>

namespace launcher {
namespace controls {

namespace {

// libultra osContPad button bits.
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

constexpr int AXIS_THRESHOLD = 16000;   // of 32767: a trigger half-way is a press
constexpr int STICK_DEAD     = 12000;

Binding g_bind[COUNT];

PadBind button(SDL_GameControllerButton b) { return PadBind{ 1, (int)b, 1 }; }

const char* FILE_NAME = "controls.ini";

std::string join(const std::string& dir, const char* file) {
    if (dir.empty()) return file;
    const char last = dir.back();
    return (last == '/' || last == '\\') ? dir + file : dir + "/" + file;
}

// The names the file uses for a pad binding: SDL's own strings, which are stable across versions.
std::string pad_to_string(const PadBind& p) {
    if (p.kind == 1) {
        const char* s = SDL_GameControllerGetStringForButton((SDL_GameControllerButton)p.index);
        return s ? s : "none";
    }
    if (p.kind == 2) {
        const char* s = SDL_GameControllerGetStringForAxis((SDL_GameControllerAxis)p.index);
        return std::string("axis:") + (s ? s : "none") + (p.sign < 0 ? "-" : "+");
    }
    return "none";
}

bool pad_from_string(const std::string& s, PadBind& out) {
    if (s.empty() || s == "none") { out = PadBind{}; return true; }
    if (s.rfind("axis:", 0) == 0 && s.size() > 6) {
        const char signc = s.back();
        const std::string axis = s.substr(5, s.size() - 6);
        const SDL_GameControllerAxis a = SDL_GameControllerGetAxisFromString(axis.c_str());
        if (a == SDL_CONTROLLER_AXIS_INVALID) return false;
        out = PadBind{ 2, (int)a, signc == '-' ? -1 : 1 };
        return true;
    }
    const SDL_GameControllerButton b = SDL_GameControllerGetButtonFromString(s.c_str());
    if (b == SDL_CONTROLLER_BUTTON_INVALID) return false;
    out = button(b);
    return true;
}

} // namespace

const char* name(Btn b) {
    switch (b) {
    case Btn::A:      return "A";
    case Btn::B:      return "B";
    case Btn::Z:      return "Z";
    case Btn::Start:  return "Start";
    case Btn::L:      return "L";
    case Btn::R:      return "R";
    case Btn::CUp:    return "C up";
    case Btn::CDown:  return "C down";
    case Btn::CLeft:  return "C left";
    case Btn::CRight: return "C right";
    case Btn::DUp:    return "D-pad up";
    case Btn::DDown:  return "D-pad down";
    case Btn::DLeft:  return "D-pad left";
    case Btn::DRight: return "D-pad right";
    default:          return "?";
    }
}

uint16_t mask(Btn b) {
    switch (b) {
    case Btn::A:      return N64_A;
    case Btn::B:      return N64_B;
    case Btn::Z:      return N64_Z;
    case Btn::Start:  return N64_START;
    case Btn::L:      return N64_L;
    case Btn::R:      return N64_R;
    case Btn::CUp:    return N64_CUP;
    case Btn::CDown:  return N64_CDOWN;
    case Btn::CLeft:  return N64_CLEFT;
    case Btn::CRight: return N64_CRIGHT;
    case Btn::DUp:    return N64_DUP;
    case Btn::DDown:  return N64_DDOWN;
    case Btn::DLeft:  return N64_DLEFT;
    case Btn::DRight: return N64_DRIGHT;
    default:          return 0;
    }
}

Binding get(Btn b) { return g_bind[(int)b]; }
void set_pad(Btn b, PadBind p)   { g_bind[(int)b].pad = p; }
void set_key(Btn b, int scancode) { g_bind[(int)b].key = scancode; }

void reset_defaults() {
    g_bind[(int)Btn::A]      = { button(SDL_CONTROLLER_BUTTON_A),             SDL_SCANCODE_Z };
    g_bind[(int)Btn::B]      = { button(SDL_CONTROLLER_BUTTON_B),             SDL_SCANCODE_X };
    g_bind[(int)Btn::Z]      = { button(SDL_CONTROLLER_BUTTON_LEFTSHOULDER),  SDL_SCANCODE_LSHIFT };
    g_bind[(int)Btn::Start]  = { button(SDL_CONTROLLER_BUTTON_START),         SDL_SCANCODE_RETURN };
    g_bind[(int)Btn::L]      = { button(SDL_CONTROLLER_BUTTON_BACK),          SDL_SCANCODE_Q };
    g_bind[(int)Btn::R]      = { button(SDL_CONTROLLER_BUTTON_RIGHTSHOULDER), SDL_SCANCODE_E };
    g_bind[(int)Btn::CUp]    = { PadBind{},                                    SDL_SCANCODE_I };
    g_bind[(int)Btn::CDown]  = { PadBind{},                                    SDL_SCANCODE_K };
    g_bind[(int)Btn::CLeft]  = { PadBind{},                                    SDL_SCANCODE_J };
    g_bind[(int)Btn::CRight] = { PadBind{},                                    SDL_SCANCODE_L };
    g_bind[(int)Btn::DUp]    = { button(SDL_CONTROLLER_BUTTON_DPAD_UP),       SDL_SCANCODE_UP };
    g_bind[(int)Btn::DDown]  = { button(SDL_CONTROLLER_BUTTON_DPAD_DOWN),     SDL_SCANCODE_DOWN };
    g_bind[(int)Btn::DLeft]  = { button(SDL_CONTROLLER_BUTTON_DPAD_LEFT),     SDL_SCANCODE_LEFT };
    g_bind[(int)Btn::DRight] = { button(SDL_CONTROLLER_BUTTON_DPAD_RIGHT),    SDL_SCANCODE_RIGHT };
}

bool load(const std::string& dir) {
    reset_defaults();
    std::ifstream in(join(dir, FILE_NAME));
    if (!in) return false;
    std::string line;
    int read = 0;
    while (std::getline(in, line)) {
        while (!line.empty() && (line.back() == '\r' || line.back() == ' ')) line.pop_back();
        if (line.empty() || line[0] == '#') continue;
        // <name> pad=<sdl name> key=<scancode name>   — the key name runs to the end of the line
        const size_t sp = line.find(' ');
        if (sp == std::string::npos) continue;
        const std::string who = line.substr(0, sp);
        int which = -1;
        for (int i = 0; i < COUNT; i++) {
            std::string n = name((Btn)i);
            for (char& c : n) if (c == ' ') c = '_';
            if (n == who) { which = i; break; }
        }
        if (which < 0) continue;
        const size_t pp = line.find(" pad=");
        const size_t kp = line.find(" key=");
        if (pp != std::string::npos) {
            const size_t end = (kp != std::string::npos && kp > pp) ? kp : line.size();
            PadBind p;
            if (pad_from_string(line.substr(pp + 5, end - (pp + 5)), p)) g_bind[which].pad = p;
        }
        if (kp != std::string::npos) {
            const std::string kn = line.substr(kp + 5);
            g_bind[which].key = kn.empty() || kn == "none" ? 0 : (int)SDL_GetScancodeFromName(kn.c_str());
        }
        read++;
    }
    return read > 0;
}

bool save(const std::string& dir) {
    std::ofstream out(join(dir, FILE_NAME), std::ios::trunc);
    if (!out) return false;
    out << "# Recompilator controls. One line per N64 button: pad=<SDL game controller name or axis:<name>+/->, key=<key name>.\n";
    out << "# Delete this file to go back to the defaults.\n";
    for (int i = 0; i < COUNT; i++) {
        std::string n = name((Btn)i);
        for (char& c : n) if (c == ' ') c = '_';
        const Binding& b = g_bind[i];
        out << n << " pad=" << pad_to_string(b.pad)
            << " key=" << (b.key ? SDL_GetScancodeName((SDL_Scancode)b.key) : "none") << "\n";
    }
    return (bool)out;
}

std::string pad_label(const PadBind& p) {
    if (p.kind == 1) {
        switch ((SDL_GameControllerButton)p.index) {
        case SDL_CONTROLLER_BUTTON_A:             return "A";
        case SDL_CONTROLLER_BUTTON_B:             return "B";
        case SDL_CONTROLLER_BUTTON_X:             return "X";
        case SDL_CONTROLLER_BUTTON_Y:             return "Y";
        case SDL_CONTROLLER_BUTTON_BACK:          return "Back";
        case SDL_CONTROLLER_BUTTON_GUIDE:         return "Guide";
        case SDL_CONTROLLER_BUTTON_START:         return "Start";
        case SDL_CONTROLLER_BUTTON_LEFTSTICK:     return "Left stick click";
        case SDL_CONTROLLER_BUTTON_RIGHTSTICK:    return "Right stick click";
        case SDL_CONTROLLER_BUTTON_LEFTSHOULDER:  return "LB";
        case SDL_CONTROLLER_BUTTON_RIGHTSHOULDER: return "RB";
        case SDL_CONTROLLER_BUTTON_DPAD_UP:       return "D-pad up";
        case SDL_CONTROLLER_BUTTON_DPAD_DOWN:     return "D-pad down";
        case SDL_CONTROLLER_BUTTON_DPAD_LEFT:     return "D-pad left";
        case SDL_CONTROLLER_BUTTON_DPAD_RIGHT:    return "D-pad right";
        default: {
            const char* s = SDL_GameControllerGetStringForButton((SDL_GameControllerButton)p.index);
            return s ? s : "?";
        }
        }
    }
    if (p.kind == 2) {
        switch ((SDL_GameControllerAxis)p.index) {
        case SDL_CONTROLLER_AXIS_TRIGGERLEFT:  return "LT";
        case SDL_CONTROLLER_AXIS_TRIGGERRIGHT: return "RT";
        case SDL_CONTROLLER_AXIS_LEFTX:        return p.sign < 0 ? "Left stick left"  : "Left stick right";
        case SDL_CONTROLLER_AXIS_LEFTY:        return p.sign < 0 ? "Left stick up"    : "Left stick down";
        case SDL_CONTROLLER_AXIS_RIGHTX:       return p.sign < 0 ? "Right stick left" : "Right stick right";
        case SDL_CONTROLLER_AXIS_RIGHTY:       return p.sign < 0 ? "Right stick up"   : "Right stick down";
        default: {
            const char* s = SDL_GameControllerGetStringForAxis((SDL_GameControllerAxis)p.index);
            return std::string(s ? s : "?") + (p.sign < 0 ? " -" : " +");
        }
        }
    }
    return "-";
}

std::string key_label(int scancode) {
    if (scancode <= 0) return "-";
    const char* s = SDL_GetScancodeName((SDL_Scancode)scancode);
    return (s && s[0]) ? s : "-";
}

uint16_t read_pad(SDL_GameController* pad) {
    if (pad == nullptr) return 0;
    uint16_t out = 0;
    for (int i = 0; i < COUNT; i++) {
        const PadBind& p = g_bind[i].pad;
        bool down = false;
        if (p.kind == 1) {
            down = SDL_GameControllerGetButton(pad, (SDL_GameControllerButton)p.index) != 0;
        } else if (p.kind == 2) {
            const int v = (int)SDL_GameControllerGetAxis(pad, (SDL_GameControllerAxis)p.index) * p.sign;
            down = v > AXIS_THRESHOLD;
        }
        if (down) out |= mask((Btn)i);
    }
    // The right stick is the C buttons, always, on top of any button bound to them.
    const int rx = SDL_GameControllerGetAxis(pad, SDL_CONTROLLER_AXIS_RIGHTX);
    const int ry = SDL_GameControllerGetAxis(pad, SDL_CONTROLLER_AXIS_RIGHTY);
    if (ry < -STICK_DEAD) out |= N64_CUP;
    if (ry >  STICK_DEAD) out |= N64_CDOWN;
    if (rx < -STICK_DEAD) out |= N64_CLEFT;
    if (rx >  STICK_DEAD) out |= N64_CRIGHT;
    return out;
}

uint16_t read_keys(const uint8_t* kb) {
    if (kb == nullptr) return 0;
    uint16_t out = 0;
    for (int i = 0; i < COUNT; i++) {
        const int k = g_bind[i].key;
        if (k > 0 && k < SDL_NUM_SCANCODES && kb[k]) out |= mask((Btn)i);
    }
    return out;
}

} // namespace controls
} // namespace launcher
