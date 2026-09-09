// Runtime diagnostics flush (recompilator roadmap tool #1).
//
// On a RECOMP_DIAG run, write the runtime degrade report — the deduped gfgap/cartbus/kseg0 dispatch-miss
// events recorded via N64Recomp::diag::hit() PLUS the live-gap cache (the functions the static recompile
// missed but the runtime discovered) — to the per-game app-data dir at process exit. This is the runtime
// half of the structured diagnostics sink; the gap_cache[] it emits is the runtime->static feedback the
// gap-journal/reingest tool (#3) reads back into symbol_addrs/toml.
//
// No-op when RECOMP_DIAG is unset (baseline games pay nothing — the guard object just registers an atexit
// handler that returns immediately). See include/recompiler/diag_sink.h for the shared API.

#include "recompiler/diag_sink.h"
#include "ultramodern/ultramodern.hpp"

#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <string>
#include <system_error>
#include <typeinfo>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#endif

// Defined in recomp_live_gap.cpp — serializes g_gap_cache as a JSON array (thread-safe).
std::string recomp_diag_gap_cache_json();

// Externally callable so the engine can invoke it from its guaranteed-linked clean-shutdown path
// (recomp::start after the threads join). That call also force-links this TU (a static-init guard alone
// would be stripped by the linker, since nothing else references this object). atexit + the static dtor
// remain as fallbacks for exit paths that bypass recomp::start's return; the atomic_flag keeps it once-only.
// Writes the runtime gap report, overwriting any previous one. Safe to call repeatedly: the engine
// flushes this PERIODICALLY from recomp::start's main loop (recomp.cpp), because RT64's window-close path
// hard-exits the process from inside that loop — bypassing clean shutdown, the thread joins, AND atexit.
// Periodic writes mean the report always reflects recent runtime state regardless of how the process dies.
// No-op unless RECOMP_DIAG is set.
extern "C" void recomp_diag_runtime_flush() {
    if (!N64Recomp::diag::enabled()) {
        return;
    }

    std::filesystem::path save_path = ultramodern::get_save_file_path();
    if (save_path.empty()) {
        return; // no per-game save dir resolved (game never set one) — nowhere to write
    }
    std::filesystem::path dir = save_path.parent_path();
    std::error_code ec;
    std::filesystem::create_directories(dir, ec);
    std::filesystem::path out = dir / "gap_report.json";

    // Crash-marker lifecycle (2026-07-18): gap_reingest refuses a report whose sibling
    // gap_report.crashed is at least as new (a crashed run's gap_cache can hold garbage decodes
    // that poison symbol_addrs — the JIT-on-era candc/sc64 poisoning). A healthy run clears the
    // PREVIOUS run's marker on its first flush so its own report is consumable again.
    static std::atomic_flag s_marker_cleared = ATOMIC_FLAG_INIT;
    if (!s_marker_cleared.test_and_set()) {
        std::filesystem::remove(dir / "gap_report.crashed", ec);
    }

    // Append the live-gap cache as a top-level "gap_cache" array alongside the deduped events[].
    std::string extra = ",\n  \"gap_cache\": ";
    extra += recomp_diag_gap_cache_json();

    N64Recomp::diag::flush_to_file(out.string(), "runtime", extra);
}

#ifdef _WIN32
// Unhandled-exception filter: mark the diag dir with gap_report.crashed (exception code +
// faulting address for forensics) so tooling can tell a crashed run's report from a healthy
// one. The periodic flush means gap_report.json always exists after a crash — without this
// marker it is indistinguishable from a clean run's report. Chains to any previous filter and
// never swallows the exception, so observable crash behavior (dialog/WER) is unchanged.
// Windows-only for now: the desktop is the product path (doctrine); a Pi/Linux signal-based
// marker is a follow-up if reingest ever runs against Pi diag dirs.
namespace {
LPTOP_LEVEL_EXCEPTION_FILTER g_prev_exception_filter = nullptr;

LONG WINAPI recomp_diag_crash_filter(EXCEPTION_POINTERS* info) {
    if (N64Recomp::diag::enabled()) {
        std::filesystem::path save_path = ultramodern::get_save_file_path();
        if (!save_path.empty()) {
            std::filesystem::path marker = save_path.parent_path() / "gap_report.crashed";
            // fopen, not std::ofstream: keep the in-crash code path as small as possible.
            if (FILE* f = fopen(marker.string().c_str(), "w")) {
                unsigned long code = 0;
                void* addr = nullptr;
                if (info && info->ExceptionRecord) {
                    code = (unsigned long)info->ExceptionRecord->ExceptionCode;
                    addr = info->ExceptionRecord->ExceptionAddress;
                }
                fprintf(f, "{ \"exception_code\": \"0x%08lX\", \"address\": \"%p\" }\n", code, addr);
                fclose(f);
            }
        }
    }
    if (g_prev_exception_filter != nullptr) {
        return g_prev_exception_filter(info);
    }
    return EXCEPTION_CONTINUE_SEARCH;
}
} // namespace
#endif

// std::terminate deaths (uncaught C++ exception on any thread -> exit 0xE06D7363) bypass the
// SEH filter above, so they left NO marker (drmario JIT=1's ~68s exception, 2026-07-18). This
// handler writes the marker WITH the active exception's type and what() — which also makes the
// marker a first-line diagnostic: the throw's identity survives the process.
namespace {
std::terminate_handler g_prev_terminate_handler = nullptr;

[[noreturn]] void recomp_diag_terminate_handler() {
    if (N64Recomp::diag::enabled()) {
        std::filesystem::path save_path = ultramodern::get_save_file_path();
        if (!save_path.empty()) {
            std::filesystem::path marker = save_path.parent_path() / "gap_report.crashed";
            if (FILE* f = fopen(marker.string().c_str(), "w")) {
                const char* kind = "std::terminate (no active exception)";
                std::string detail;
                if (std::current_exception()) {
                    kind = "std::terminate (uncaught exception)";
                    try {
                        std::rethrow_exception(std::current_exception());
                    } catch (const std::exception& e) {
                        detail = std::string(typeid(e).name()) + ": " + e.what();
                    } catch (...) {
                        detail = "(non-std exception)";
                    }
                }
                fprintf(f, "{ \"kind\": \"%s\", \"detail\": \"%s\" }\n", kind, detail.c_str());
                fclose(f);
            }
        }
    }
    if (g_prev_terminate_handler != nullptr) {
        g_prev_terminate_handler();
    }
    std::abort();
}
} // namespace

namespace {
// Cover both normal-exit (atexit) and static-teardown ordering; idempotent via the atomic_flag above.
struct DiagFlushGuard {
    DiagFlushGuard()  {
        std::atexit(recomp_diag_runtime_flush);
#ifdef _WIN32
        g_prev_exception_filter = SetUnhandledExceptionFilter(recomp_diag_crash_filter);
#endif
        g_prev_terminate_handler = std::set_terminate(recomp_diag_terminate_handler);
    }
    ~DiagFlushGuard() { recomp_diag_runtime_flush(); }
};
DiagFlushGuard g_diag_flush_guard;
} // namespace
