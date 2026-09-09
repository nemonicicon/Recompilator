// trace.cpp — per-thread execution-flow tracer for N64Recomp `trace_mode = true` recomps.
//
// trace.h (included only in trace-mode recomp output) routes TRACE_ENTER(__func__)/TRACE_RETURN() here.
// Each recompiled-game thread runs on its own host thread, so a THREAD-LOCAL stack gives that thread's
// exact live call path with no locking. recomp_trace_dump() prints the calling thread's current stack —
// call it from a blocking point (e.g. ultramodern do_recv when a thread parks on a queue that never
// gets fed) to see precisely how the game got there.
//
// Cost: one thread-local array write per recompiled function entry/exit; no I/O until a dump. The hooks
// are emitted ONLY for games whose toml sets trace_mode, so non-trace games are byte-for-byte unaffected.
// These symbols are always linked (so do_recv can call recomp_trace_dump unconditionally); for a
// non-trace game the stack simply stays shallow/empty.

#include <cstdio>

namespace {
    constexpr int TRACE_MAX = 1024;            // max nesting captured; real N64 stacks are far shallower
    thread_local const char* g_stack[TRACE_MAX];
    thread_local int g_depth = 0;              // counts past TRACE_MAX too, so push/pop stay balanced
}

extern "C" void recomp_trace_enter(const char* func_name) {
    if (g_depth >= 0 && g_depth < TRACE_MAX) {
        g_stack[g_depth] = func_name;
    }
    g_depth++;
}

extern "C" void recomp_trace_return(void) {
    if (g_depth > 0) {
        g_depth--;
    }
}

extern "C" void recomp_trace_dump(const char* tag) {
    const int top = (g_depth < TRACE_MAX) ? g_depth : TRACE_MAX;
    fprintf(stderr, "[trace] %s -- live call stack on this thread (depth=%d, outermost first):\n",
            tag ? tag : "(dump)", g_depth);
    for (int i = 0; i < top; i++) {
        fprintf(stderr, "[trace]   #%-3d %s\n", i, g_stack[i] ? g_stack[i] : "?");
    }
    if (g_depth > TRACE_MAX) {
        fprintf(stderr, "[trace]   ... (+%d deeper frames truncated)\n", g_depth - TRACE_MAX);
    }
    fflush(stderr);
}
