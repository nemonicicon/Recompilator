/**
 * launcher_catalog.cpp — the catalog read.
 *
 * The launcher knows NOTHING about any game. Every row in the LIBRARY comes from
 * recompilator/catalog/<game>/entry.json plus the presence of <game>pc/build/windows-x64/Release/
 * <game>pc.exe on disk. Adding a game to the launcher is adding a directory to the catalog.
 */

#include <cstdio>
#include "launcher_app.hpp"

#include <algorithm>
#include <cctype>
#include <chrono>
#include <ctime>
#include <filesystem>
#include <fstream>
#include <map>
#include <sstream>

#include <json/json.hpp>   // RT64 bundles nlohmann/json (engine/rt64/src/contrib/json)

#if defined(_WIN32)
#  include <Windows.h>
#endif

namespace fs = std::filesystem;
using json = nlohmann::json;

namespace launcher {

static std::string upper(std::string s) {
    for (char& c : s) c = (char)std::toupper((unsigned char)c);
    return s;
}

std::string config_dir() {
#if defined(_WIN32)
    const char* appdata = std::getenv("APPDATA");
    fs::path p = fs::path(appdata ? appdata : ".") / "recompilator";
#else
    const char* xdg = std::getenv("XDG_CONFIG_HOME");
    const char* home = std::getenv("HOME");
    fs::path base = (xdg && *xdg) ? fs::path(xdg)
                                  : (home ? fs::path(home) / ".config" : fs::path("."));
    fs::path p = base / "recompilator";
#endif
    std::error_code ec;
    fs::create_directories(p, ec);
    return p.string();
}

static fs::path played_path() { return fs::path(config_dir()) / "last_played.txt"; }

static std::map<std::string, std::string> read_played() {
    std::map<std::string, std::string> m;
    std::ifstream f(played_path());
    std::string line;
    while (std::getline(f, line)) {
        auto eq = line.find('=');
        if (eq == std::string::npos) continue;
        m[line.substr(0, eq)] = line.substr(eq + 1);
    }
    return m;
}

void note_played(const std::string& game) {
    auto m = read_played();
    std::time_t t = std::time(nullptr);
    char buf[32] = {};
    std::tm tmv{};
#if defined(_WIN32)
    localtime_s(&tmv, &t);
#else
    localtime_r(&t, &tmv);
#endif
    std::strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M", &tmv);
    m[game] = buf;
    std::ofstream f(played_path(), std::ios::trunc);
    for (const auto& kv : m) f << kv.first << "=" << kv.second << "\n";
}

// A RELEASE SHIPS NO CATALOG (2026-09-07: no game ships with the program).
// The program recompiles whatever ROM the user brings; the catalog is written on THIS machine as
// ROMs are added, so it cannot be the thing we root ourselves on. Root on what always ships: the
// pipeline driver the BUILD screen runs. `recompilator/catalog` is still accepted so the lab tree
// (where the driver may sit beside a much larger workbench) keeps working unchanged.
static bool is_root(const fs::path& p) {
    std::error_code ec;
    return fs::exists(p / "recompilator" / "tools" / "build_entry.ps1", ec)
        || fs::exists(p / "recompilator" / "catalog", ec);
}

std::string find_root() {
    if (const char* env = std::getenv("RECOMPILATOR_ROOT")) {
        if (*env && is_root(fs::path(env))) return env;
    }
    fs::path here;
#if defined(_WIN32)
    wchar_t buf[MAX_PATH] = {};
    GetModuleFileNameW(nullptr, buf, MAX_PATH);
    here = fs::path(buf).parent_path();
#else
    here = fs::current_path();
#endif
    for (int i = 0; i < 10 && !here.empty(); i++) {
        if (is_root(here)) return here.string();
        if (!here.has_parent_path() || here.parent_path() == here) break;
        here = here.parent_path();
    }
    // Last resort: the working directory chain.
    fs::path cwd = fs::current_path();
    for (int i = 0; i < 10 && !cwd.empty(); i++) {
        if (is_root(cwd)) return cwd.string();
        if (!cwd.has_parent_path() || cwd.parent_path() == cwd) break;
        cwd = cwd.parent_path();
    }
    return std::string();
}

// THE STATE COLUMN, from the entry alone:
//   no built exe                       -> NOT BUILT
//   sweep.sweep == PASS + gameplay     -> PLAYS
//   sweep.sweep == PASS                -> TITLE
//   anything else (incl. no sweep)     -> NOT REACHED
static std::string state_label_for(const CatalogEntry& e) {
    // Either artifact counts as built: the GAME MODULE (what the bundled-clang stage 5 produces and
    // what PLAY prefers) or the legacy <game>pc.exe (what MSBuild produces and the sweep runs).
    if (e.exe_path.empty() && e.module_path.empty()) return "NOT BUILT";
    // A LOCALLY AUTHORED ENTRY (export_catalog_entry.py --authored writes sweep = "LOCAL") has no
    // lab verdict and never will: the program built it on this machine from the user's own cart.
    // Saying NOT REACHED about a game that is sitting there built would be a lying instrument; the
    // honest label is what the artifacts on disk actually say, which is BUILT.
    if (upper(e.sweep) == "LOCAL") return "BUILT";
    if (upper(e.sweep) == "PASS") {
        std::string s = upper(e.state_text);
        if (upper(e.reached) == "GAMEPLAY" || s.find("GAMEPLAY") != std::string::npos || s.find("PLAYABLE") != std::string::npos) {
            return "PLAYS";
        }
        return "TITLE";
    }
    return "NOT REACHED";
}

static std::string js(const json& j, const char* key) {
    auto it = j.find(key);
    if (it == j.end() || it->is_null()) return std::string();
    if (it->is_string()) return it->get<std::string>();
    return it->dump();
}

// WHERE ENTRIES LIVE. Two places, and both are read:
//   recompilator/catalog/  the recipes that SHIP - replaced wholesale by every export
//   archive/               the games the user built HERE, entry beside the game itself
// The second exists because an entry written into the first is thrown away the next time
// the program is refreshed, which is how a locally built library kept disappearing
// (2026-09-07). Duplicates resolve to the archive: the user's own build wins.
static std::vector<fs::path> entry_dirs(const std::string& root) {
    std::error_code ec;
    std::vector<fs::path> out;
    for (const fs::path& base : { fs::path(root) / "recompilator" / "catalog",
                                  fs::path(root) / "archive" }) {
        if (!fs::exists(base, ec)) continue;
        for (const auto& dir : fs::directory_iterator(base, ec)) {
            if (!dir.is_directory()) continue;
            if (fs::exists(dir.path() / "entry.json", ec)) out.push_back(dir.path());
        }
    }
    return out;
}


// Recognition must see the WHOLE catalog, not just the games the user has: a fresh install owns
// nothing, and the entry that matches their cartridge is exactly the one scan_catalog leaves out.
// Reads the entries on disk and answers by sha1.
bool lookup_entry_by_sha1(const std::string& root, const std::string& sha1,
                          std::string* game, std::string* title, bool* has_ni) {
    if (root.empty() || sha1.empty()) return false;
    std::string want = sha1;
    std::transform(want.begin(), want.end(), want.begin(),
                   [](unsigned char c) { return (char)std::tolower(c); });
    std::error_code ec;
    for (const fs::path& d : entry_dirs(root)) {
        const fs::path ej = d / "entry.json";
        std::ifstream f(ej);
        json j;
        try { f >> j; } catch (...) { continue; }
        if (!j.contains("rom") || !j["rom"].is_object()) continue;
        std::string have = js(j["rom"], "sha1");
        std::transform(have.begin(), have.end(), have.begin(),
                       [](unsigned char c) { return (char)std::tolower(c); });
        if (have != want) continue;
        std::string g = js(j, "game");
        if (g.empty()) g = d.filename().string();
        std::string ti;
        if (j.contains("sweep") && j["sweep"].is_object()) ti = js(j["sweep"], "title");
        if (ti.empty()) ti = g;
        if (game)   *game = g;
        if (title)  *title = ti;
        if (has_ni) *has_ni = fs::exists(d / "tools" / "gen_ni_data.py", ec) ||
                              fs::exists(d / "app" / "tools" / "gen_ni_data.py", ec);
        return true;
    }
    return false;
}

std::vector<CatalogEntry> scan_catalog(const std::string& root) {
    std::vector<CatalogEntry> out;
    if (root.empty()) return out;

    std::error_code ec;
    // The ARCHIVE is where games the user builds go, entry and all. Make it on first run so
    // there is somewhere for them to land; an empty library is the truth, not an error.
    fs::create_directories(fs::path(root) / "archive", ec);

    const auto played = read_played();

    for (const fs::path& dirp : entry_dirs(root)) {
        const fs::path entry_json = dirp / "entry.json";

        std::ifstream f(entry_json);
        json j;
        try {
            f >> j;
        } catch (...) {
            continue;   // a malformed entry is skipped, never fatal
        }

        CatalogEntry e{};
        e.game = js(j, "game");
        if (e.game.empty()) e.game = dirp.filename().string();
        // Which of the two places did this come from? A shipped recipe describes SOME dump of the
        // game; the archive entry describes the cartridge this user actually has.
        const bool from_archive = (dirp.parent_path().filename() == "archive");

        if (j.contains("rom") && j["rom"].is_object()) {
            e.sha1       = js(j["rom"], "sha1");
            e.xxh3       = js(j["rom"], "xxh3_64");
            e.entrypoint = js(j["rom"], "entrypoint");
        }
        if (j.contains("sweep") && j["sweep"].is_object()) {
            e.title      = js(j["sweep"], "title");
            e.release    = js(j["sweep"], "release");
            e.sweep      = js(j["sweep"], "sweep");
            if (e.sweep.empty()) e.sweep = js(j["sweep"], "verdict");
            // Exporters write the prose under different keys; take whatever this entry carries.
            e.state_text = js(j["sweep"], "state") + " " + js(j["sweep"], "verdict_line");
            e.reached    = js(j["sweep"], "reached");
        }
        if (e.title.empty()) e.title = e.game;
        std::transform(e.sha1.begin(), e.sha1.end(), e.sha1.begin(),
                       [](unsigned char c) { return (char)std::tolower(c); });

        // WHERE A GAME LIVES. Games are created under <root>/archive/ so the folder the program
        // sits in is not a pile of per-game directories (2026-09-07). Anything built before
        // that is still at <root>/, and must keep being found and played exactly where it is - so
        // both are checked, archive first, and nothing on anyone's disk has to move.
        const fs::path arch = fs::path(root) / "archive";
        auto find_first = [&](const fs::path& tail) {
            std::error_code e2;
            fs::path a = arch / tail;
            if (fs::exists(a, e2)) return a;
            fs::path b = fs::path(root) / tail;
            if (fs::exists(b, e2)) return b;
            return fs::path();
        };

        // The built exe, by the project's one convention.
        const fs::path exe = find_first(fs::path(e.game + "pc") / "build" / "windows-x64" /
                                        "Release" / (e.game + "pc.exe"));
        if (!exe.empty()) e.exe_path = exe.string();

        // STEP 3: the GAME MODULE, by the same one convention. When it is there, PLAY loads it
        // into this process and the game runs in the launcher's own window; when it is not, PLAY
        // falls back to spawning the exe. Both are decided by a FILE, never by a game name.
        const fs::path dll = find_first(fs::path(e.game + "pc") / "module" / (e.game + ".dll"));
        if (!dll.empty()) e.module_path = dll.string();

        // The cart, where the build driver installs it (build_entry.ps1 stage 1).
        const fs::path rom = find_first(fs::path(e.game) / "baserom.z64");
        if (!rom.empty()) e.rom_path = rom.string();

        // The one conditional stage in the pipeline, decided by a FILE in the entry and never by a
        // game name: a decomp-shaped entry ships tools/gen_ni_data.py, so the driver runs one more
        // stage and the BUILD table shows one more row.
        e.has_ni_data = fs::exists(dirp / "tools" / "gen_ni_data.py", ec) ||
                        fs::exists(dirp / "app" / "tools" / "gen_ni_data.py", ec);

        // THE LIBRARY IS THE USER'S GAMES, NOT A LIST OF WHAT THE PROGRAM HAS HEARD OF.
        // 2026-09-07: a game that can be neither played nor built must not appear here. A shipped entry is a RECIPE - it holds nothing of
        // the cartridge - so until the user has added that cartridge there is nothing here for them
        // to play, and a row that can neither be played nor built is worse than no row. An entry
        // earns its place the moment the user has any of: a built module, a built exe, or the cart
        // itself in the tree. A fresh install therefore shows an empty library, which is the truth.
        if (e.module_path.empty() && e.exe_path.empty() && e.rom_path.empty()) {
            continue;
        }

        e.state_label = state_label_for(e);
        auto it = played.find(e.game);
        e.last_played = (it == played.end()) ? "never" : it->second;

        // ONE ROW PER GAME, AND THE USER'S OWN BUILD WINS. entry_dirs() reads both places and
        // nothing here ever resolved the overlap, so a game with a shipped recipe AND a local
        // build got TWO rows - and the recipe's row, which carries a different cartridge's sha1,
        // is the one that sorts into view (a local entry has no release date and sinks to the
        // end). Pressing build on it asked the user to "choose your copy" of a game they had
        // already added and built, because the row was describing a dump they do not own.
        // Measured 2026-09-08: Blast Corps and Wave Race each had two rows.
        auto dup = std::find_if(out.begin(), out.end(),
                                [&](const CatalogEntry& x) { return x.game == e.game; });
        if (dup != out.end()) {
            if (from_archive) *dup = std::move(e);   // the local build replaces the recipe
            continue;                                 // otherwise keep what is already there
        }
        out.push_back(std::move(e));
    }

    // Release order (the march order); entries without a release date sit at the end.
    std::sort(out.begin(), out.end(), [](const CatalogEntry& a, const CatalogEntry& b) {
        const bool ea = a.release.empty(), eb = b.release.empty();
        if (ea != eb) return !ea;
        if (a.release != b.release) return a.release < b.release;
        return a.title < b.title;
    });
    return out;
}

} // namespace launcher
