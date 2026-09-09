/* Bound the diagnostic log so a forgotten game cannot fill the disk.
 * Truncates in place, so the running process's stderr fd stays valid. */
#ifndef RECOMP_DIAG_CAP_H
#define RECOMP_DIAG_CAP_H
#include <string>
namespace recomp {
    /* Start a watchdog that truncates `path` whenever it exceeds the cap.
     * Cap: RECOMP_DIAG_MAX_MB (default 64; 0 disables). Safe to call once per process. */
    void diag_log_cap(const std::string& path);
}
#endif
