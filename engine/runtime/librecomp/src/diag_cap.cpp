/* See diag_cap.h. Engine-side because launcher discipline only works when someone remembers,
 * and a game left running by accident is exactly when nobody does (2026-07-26 -- twice
 * this filled repc's 3.1GB card, and the second time it cratered the fps being measured). */
#include "librecomp/diag_cap.h"

#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <thread>
#include <chrono>

#ifndef _WIN32
#include <sys/stat.h>
#include <unistd.h>
#endif

namespace {
    std::atomic<bool> g_armed{false};
}

void recomp::diag_log_cap(const std::string& path) {
#ifndef _WIN32
    if (g_armed.exchange(true)) return;          /* once per process */

    long long cap_mb = 64;
    if (const char* e = std::getenv("RECOMP_DIAG_MAX_MB")) {
        char* end = nullptr;
        long long v = std::strtoll(e, &end, 10);
        if (end != e && v >= 0) cap_mb = v;
    }
    if (cap_mb == 0) return;                     /* explicitly disabled */

    const long long cap = cap_mb * 1024 * 1024;
    std::string p = path;
    std::thread([p, cap, cap_mb]() {
        for (;;) {
            std::this_thread::sleep_for(std::chrono::seconds(20));
            struct stat st;
            if (stat(p.c_str(), &st) != 0) continue;
            if (!S_ISREG(st.st_mode)) continue;  /* symlinked to /dev/null: nothing to do */
            if (st.st_size < cap) continue;
            /* Truncate IN PLACE: the process keeps writing through its existing fd, which stays
             * valid. Losing the older half of a diagnostic log is always better than losing the
             * disk out from under a running game. */
            if (truncate(p.c_str(), 0) == 0) {
                std::fprintf(stderr, "[diag] log passed %lld MB - truncated in place "
                                     "(RECOMP_DIAG_MAX_MB=%lld, 0 disables)\n", cap_mb, cap_mb);
                std::fflush(stderr);
            }
        }
    }).detach();
#else
    (void)path;
#endif
}
