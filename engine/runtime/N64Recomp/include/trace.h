#ifndef RECOMP_TRACE_H
#define RECOMP_TRACE_H

// Execution-flow tracing for N64Recomp `trace_mode = true` recomps.
//
// When a game's toml sets `trace_mode = true`, config.cpp appends `#include "trace.h"` to the recomp
// output (after recomp.h) and the C generator emits TRACE_ENTER() at every function prologue and
// TRACE_RETURN() before every return. recomp.h defines those as no-ops by default (zero cost for
// non-trace games); this header #undefs them and routes them to the per-thread call-stack tracer
// implemented in librecomp/src/trace.cpp.
//
// The tracer maintains a THREAD-LOCAL live call stack (push on enter, pop on return). Call
// recomp_trace_dump("tag") from any point — e.g. ultramodern do_recv when a thread parks on a stuck
// message queue — to print THAT thread's exact call path into the stall. Cheap: one array write per
// call, no I/O until you dump. General: works for any game that enables trace_mode.

#ifdef __cplusplus
extern "C" {
#endif
void recomp_trace_enter(const char* func_name);
void recomp_trace_return(void);
void recomp_trace_dump(const char* tag);  // print the current thread's live call stack
#ifdef __cplusplus
}
#endif

// The recompiler emits TRACE_ENTRY() at each function prologue and TRACE_RETURN() before each return
// (both gated on toml trace_mode, both WITHOUT a trailing ';' — so define them WITH one here).
#undef TRACE_ENTRY
#undef TRACE_RETURN
#define TRACE_ENTRY() recomp_trace_enter(__func__);
#define TRACE_RETURN() recomp_trace_return();

#endif // RECOMP_TRACE_H
