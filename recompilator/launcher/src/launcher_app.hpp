/**
 * launcher_app.hpp — the Recompilator launcher's shared state.
 *
 * STEP 2 (the BUILD screen drives the real pipeline). One window, one renderer: the host boots the
 * engine exactly as a port's main.cpp does (SDL window -> recomp::start(cfg)) but never calls
 * start_game(); the four launcher states are drawn with ImGui on RT64's own present, through the
 * public render-hook API (engine/rt64/src/rhi/rt64_render_hooks.h). No engine source is modified.
 *
 * BUILD spawns recompilator/tools/build_entry.ps1 as a child process and drives the stage table
 * from the STAGE/RESULT lines it prints on stdout. The launcher runs no pipeline logic of its own.
 *
 * RULE: never per-game code in the host. Everything about a game comes from its catalog entry
 * (recompilator/catalog/<game>/entry.json) and the path of its built exe.
 */

#pragma once

#include <cstdint>
#include <mutex>
#include <string>
#include <vector>

#include "ultramodern/ultramodern.hpp"
#include "ultramodern/input.hpp"

namespace launcher {

// ── The four states from RECOMPILATOR_UI_PLAN.md ──────────────────────────────
enum class Screen {
    Archive,    // THE LIBRARY, and where the program starts: the games you have, played from here
    AddRom,     // native file dialog -> SHA1 -> catalog match
    Build,      // the recompile-and-build screen, with the stage progress
    Play,       // the game runs (in this window as a module, or as a child exe)
    Video,      // renderer settings
    Audio,      // sound settings
    Controls,   // what the keyboard and the pad are bound to
};

// The top bar, left to right. The bar index IS the screen: selecting a tab shows that screen,
// which is what the report that nothing happened on CONFIG (2026-09-07) was about - the old
// GAME/CONFIG/MISC bar moved a highlight and nothing else.
inline Screen screen_for_tab(int tab) {
    switch (tab) {
    case 1:  return Screen::Video;
    case 2:  return Screen::Audio;
    case 3:  return Screen::Controls;
    default: return Screen::Archive;
    }
}

inline int tab_for_screen(Screen s) {
    switch (s) {
    case Screen::Video:    return 1;
    case Screen::Audio:    return 2;
    case Screen::Controls: return 3;
    default:               return 0;
    }
}

// One catalog entry, read whole from recompilator/catalog/<game>/entry.json.
struct CatalogEntry {
    std::string game;        // the tree token, e.g. "cv64blind" (exe = <game>pc/build/.../<game>pc.exe)
    std::string title;       // sweep.title, or the token when the entry carries no sweep block
    std::string release;     // sweep.release
    std::string sweep;       // sweep.sweep ("PASS" / ...)
    std::string state_text;  // sweep.state (the long sentence)
    std::string reached;     // sweep.reached: "gameplay" or "title", the fact an entry carries
    std::string sha1;        // rom.sha1, lowercase hex
    std::string xxh3;        // rom.xxh3_64
    std::string entrypoint;  // rom.entrypoint
    std::string exe_path;    // the built exe, empty when there is none
    std::string module_path; // the built GAME MODULE <game>pc/module/<game>.dll, empty when none
    std::string rom_path;    // <game>/baserom.z64, where the build driver installs the cart
    std::string state_label; // PLAYS / TITLE / NOT BUILT / NOT REACHED
    std::string last_played; // from the launcher's own record, "never" when there is none
    // TRUE when the entry carries tools/gen_ni_data.py — the driver then runs one extra stage.
    // This keys on the FILE, never on a game name: the launcher seeds one more waiting row.
    bool has_ni_data = false;
};

// A build-screen stage row (the console's telemetry terminal, in its image).
// Step 2: every field is filled from the driver's STAGE lines; nothing here is fabricated.
enum class StageStatus { Waiting, Working, Ok, Fail };

struct BuildStage {
    std::string name;
    StageStatus status  = StageStatus::Waiting;
    double      started = 0.0;    // launcher clock at the START line (0 = never started)
    double      seconds = 0.0;    // the driver's own measured seconds, at OK/FAIL
    std::string evidence;         // the driver's one-line evidence / reason
};

// ── input actions ─────────────────────────────────────────────────────────────
// Declared before UiState because the mouse hit rectangles carry one. The keyboard and the pad in
// main.cpp map onto exactly these, and so does every mouse click: there is ONE action path.
enum class Action { None, Up, Down, Left, Right, Enter, Escape, AddRom, Build, Quit };

// ── mouse hit-testing ─────────────────────────────────────────────────────────
// This UI is drawn as raw rectangles on ImGui's background draw list, so there are no widgets to
// hit-test against. Instead the DRAW pass records the rectangle of everything clickable it just
// drew, and the SDL pump on the main thread tests the pointer against those rectangles. The look
// does not change by one pixel; the hit rectangles are the ones already being drawn.
enum class HitKind { None, Row, Tab, Hint };

struct HitRect {
    float x0 = 0, y0 = 0, x1 = 0, y1 = 0;   // in FRAMEBUFFER pixels (what the draw pass works in)
    HitKind kind  = HitKind::None;
    int    index  = 0;                      // Row: the entry index · Tab: 0/1/2 · Hint: item ordinal
    Action action = Action::None;           // Hint: the key this item stands for
};

struct UiState {
    std::mutex mutex;                  // guards everything below (main thread writes, present thread reads)

    Screen screen = Screen::Archive;   // the program opens on the ARCHIVE (09-07)
    std::vector<CatalogEntry> entries;
    int  selected = 0;
    int  menu = 0;                     // 0 ARCHIVE · 1 VIDEO · 2 AUDIO · 3 CONTROLS
    std::string root;                  // the N64PC root this launcher found

    // ADD ROM
    std::string add_path;              // the file the user picked
    std::string add_sha1;              // its SHA1 (of the .z64 member when the pick is a zip)
    std::string add_member;            // the zip member that was hashed, empty for a bare ROM
    std::string add_verdict;           // "Recognised: <title>" / "Not in the catalog"
    std::vector<std::string> add_matches;  // every catalog entry carrying that sha1
    bool add_busy = false;             // the modal dialog is up on the main thread
    // THE UNKNOWN CART. A release ships no catalog, so this is the normal case, not the error case:
    // the program says what the cartridge is FROM ITS OWN HEADER and offers to build it blind.
    bool add_unknown = false;          // no catalog entry carries this sha1
    std::string add_rom_path;          // the file to hand the driver as -RomPath
    std::string add_game;              // the catalog entry this cart matched, if any. The library
                                       // lists only games the user HAS, so a recognised cart is
                                       // usually not in it yet and cannot be found by selection.
    std::string add_cart;              // one line of what the cart says about itself

    // BUILD — driven by recompilator/tools/build_entry.ps1 (step 2)
    double build_start = 0.0;          // launcher clock when the child was spawned
    double build_end   = 0.0;          // launcher clock at RESULT (0 while running)
    std::string build_title;
    std::string build_game;            // the tree token handed to the driver ("" for a blind build:
                                       // the cart decides its own id, and build_sha1 finds it after)
    std::string build_sha1;            // the cart's sha1, for a build started from a ROM alone
    std::string build_cmd;             // the exact command line spawned (shown on screen)
    std::vector<BuildStage> build_stages;
    bool build_running  = false;
    bool build_failed   = false;
    std::string build_result;          // the rendered RESULT line
    std::string build_exe;             // RESULT OK's exe path
    std::vector<std::string> build_tail;  // the child's non-protocol output, last lines only

    // LEAVING A GAME. Esc, or the pad's middle (Guide) button, asks before it drops the game -
    // never silently, and never without a way back (09-07).
    int  opt_sel   = 0;                // the focused row on VIDEO/AUDIO/CONTROLS
    int  opt_count = 0;                // how many rows that screen drew

    bool exit_prompt = false;          // the yes/no overlay is up over the running game

    // WHICH REVISION AM I STARTING? (2026-09-08: when a game has several
    // revisions, the person starting it must be able to choose which one.) Two dumps of the
    // same game - a US cart and its Japanese release, a rev 0 and a rev 1 - are separate builds
    // with separate ids, and until now pressing Enter simply started whichever row the cursor sat
    // on with nothing to say the other existed. Grouped by the CARTRIDGE'S OWN title, which is the
    // thing the two share and the reason their ids collided in the first place.
    bool rev_prompt = false;           // the revision chooser is on screen
    std::vector<int> rev_rows;         // indices into `entries`, every build of this game
    int  rev_sel = 0;                  // which of rev_rows is highlighted
    bool exit_yes    = true;           // which of the two the pointer/stick is on

    // PLAY
    std::string play_title;
    std::string play_exe;
    bool play_running = false;
    // TRUE when PLAY loaded a MODULE into this process (the game draws in the launcher's window)
    // rather than spawning <game>pc.exe. The UI stops drawing over the game, and every key goes to
    // the game instead of the menu, while this is set.
    bool play_in_process = false;

    // MOUSE. The draw pass fills `hit` (and clamps `list_scroll`); the main-thread pump writes the
    // pointer position and the hover result. Everything here is dead while a game module owns the
    // window - the launcher then consumes no mouse input at all, exactly as it consumes no keys.
    std::vector<HitRect> hit;          // rebuilt by the draw pass every frame
    float mouse_x = -1.0f;             // pointer in framebuffer pixels; -1 = not over the window
    float mouse_y = -1.0f;
    int   hover_row  = -1;             // the library row under the pointer (entry index)
    int   hover_tab  = -1;             // 0/1/2 when the pointer is over a top-bar item
    int   hover_hint = -1;             // the hint-bar item ordinal under the pointer
    int   list_scroll   = 0;           // first library row drawn (the wheel moves this)
    int   rows_visible  = 0;           // how many rows the panel fits, measured by the draw pass

    std::string status;                // the one-line message on the bottom bar
};

UiState& ui();

// Seconds since the launcher started (monotonic).
double now_seconds();

// ── catalog (launcher_catalog.cpp) ────────────────────────────────────────────
// Find the N64PC root by walking up from the exe until recompilator/catalog exists.
std::string find_root();
// Read every recompilator/catalog/*/entry.json under `root`, resolve each exe and state label.
std::vector<CatalogEntry> scan_catalog(const std::string& root);

// Look a cartridge up in the catalog ON DISK by its sha1, whether or not the user owns it yet.
// scan_catalog returns only games the user has; recognition has to see all of them.
bool lookup_entry_by_sha1(const std::string& root, const std::string& sha1,
                          std::string* game, std::string* title, bool* has_ni);
// The launcher's own writable directory (%APPDATA%\recompilator on Windows, $XDG_CONFIG_HOME else).
std::string config_dir();
// Record that a game was played now (the LIBRARY's "last played" column).
void note_played(const std::string& game);

// ── hashing (launcher_hash.cpp) ───────────────────────────────────────────────
// SHA1 of a ROM the user picked. A .zip is opened in memory (miniz, bundled in RT64) and the
// first .z64/.n64/.v64 member is hashed; `member_out` names it. A .n64/.v64 image is byte-swapped
// into z64 order before hashing so it matches the catalog's sha1. Returns "" on failure.
std::string rom_sha1(const std::string& path, std::string& member_out, std::string& error_out);

// WHAT THE CARTRIDGE SAYS ABOUT ITSELF. The same read as rom_sha1, plus the ROM header's own
// fields, so ADD ROM can name a cart that is in no catalog - which, in a release, is every cart.
struct RomIdentity {
    std::string sha1;
    std::string member;         // the zip member, empty for a bare ROM
    std::string internal_name;  // header 0x20..0x34
    std::string serial;         // header 0x3B..0x3F (the game code)
    std::string entrypoint;     // header 0x08, as "0x80000400"
    uint64_t    size = 0;
};
bool rom_identity(const std::string& path, RomIdentity& out, std::string& error_out);

// ── ui (launcher_ui.cpp) ──────────────────────────────────────────────────────
// Create the launcher's own ImGui context on RT64's device and install the present draw hook.
// Called from the renderer context once RT64::Application::setup() has succeeded.
namespace RT64Bridge { struct DeviceInfo; }
void ui_attach(void* rt64_application);
void ui_detach();
// The launcher's SDL window (main.cpp owns it; the UI minimises/restores it around PLAY).
void ui_set_window(void* sdl_window);

// Input, all from the main thread (SDL pump in update_gfx). `Action` is declared above, with the
// hit rectangles that carry it.
void ui_action(Action a);

// MOUSE, also from the main thread's SDL pump. Coordinates are SDL WINDOW coordinates; the UI
// converts them to framebuffer pixels itself. A move to (-1,-1) means the pointer left the window.
// Each of these is a no-op while a game module owns the window.
void ui_mouse_move(float x, float y);
void ui_mouse_click(float x, float y, int clicks);
void ui_mouse_wheel(float dy);

// Called every main-thread tick: pumps the PLAY child process and the BUILD child process.
void ui_tick_main();

// OPEN ONE GAME DIRECTLY, BY ITS id. Without this the only way to start a game is to walk the
// library with simulated arrow keys - 175 rows in a full install - which is slow, visibly cycles
// the menu, and has twice produced a capture of the WRONG GAME because the row index went stale as
// the library grew. It is also a real convenience: `Recompilator.exe --play supermario64` is a
// desktop shortcut per game. The play happens on the first tick, once the engine is up and the
// catalog is read; an unknown id says so on stderr and leaves the library on screen.
void ui_request_play(const std::string& game);
// TRUE once a game module has taken this window (main.cpp stops routing keys to the menu).
bool ui_game_in_process();

// -- the host's audio + input backends (launcher_audio.cpp / launcher_input.cpp) --------------
// Generic SDL backends shared by every game the host loads. Wired into recomp::start()'s config at
// boot, because ultramodern takes them once and a game module arrives later.
void audio_init();
ultramodern::audio_callbacks_t audio_callbacks();
ultramodern::input::callbacks_t input_callbacks();
void input_set_pad(void* sdl_game_controller);

// -- the game module (launcher_module.cpp) ----------------------------------------------------
// Load <dll_path>, register everything its descriptor declares with the running engine, install
// `rom_path` if the ROM is not already stored, and call recomp::start_game(). On false, `error_out`
// says why and nothing has started.
bool module_play(const std::string& dll_path, const std::string& rom_path, std::string& error_out);
bool module_loaded();

bool ui_exit_prompt();        // the leave-the-game question is on screen
uint32_t audio_frequency();   // the rate the audio device is open at

} // namespace launcher
