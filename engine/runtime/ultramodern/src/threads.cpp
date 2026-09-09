#include <cstdio>
#include <thread>
#include <cassert>
#include <string>
#include <set>
#include <mutex>
#include <unordered_map>
#include <cstdlib>  // [tcbwatch] getenv/strtoul (remove with the probe)

#include "ultramodern/ultra64.h"
#include "ultramodern/ultramodern.hpp"
#include "blockingconcurrentqueue.h"

#include "ultramodern/threads.hpp"

// ─── [tcbwatch] NC RUN 63 exit-path probe (DIAGNOSTIC, env-gated — REMOVE with the probe) ──────────
// RECOMP_TCB_WATCH=0xADDR (guest KSEG0 TCB, e.g. NC game thread 0x800BFA40). Four uncapped prints name
// which scheduler path the watched thread takes LAST before the wedge: (1) do_send wake-pop [mesgqueue],
// (2) run_next_thread / check_running_queue resume [threads/scheduling], (3) wait_for_resumed return —
// incl. the today-silent context-replaced -> osDestroyThread(NULL) self-terminate branch, (4) every
// osDestroyThread. Shared across the three TUs (extern-declared in mesgqueue.cpp / scheduling.cpp).
uint32_t recomp_tcb_watch() {
    static const uint32_t w = []{ const char* e = getenv("RECOMP_TCB_WATCH"); return e ? (uint32_t)strtoul(e, nullptr, 0) : 0u; }();
    return w;
}

// LIVE-CONTEXT REGISTRY (NC RUN 32, general): the host UltraThreadContext* lives INSIDE the guest
// TCB at +0x20 — which on real libultra is the START of __OSThreadContext (the saved-register
// area), memory the game may legally write (register saves, TCB priming, level-load reuse).
// One guest `sw` over the low dword turns the host pointer into rdram_base+guest_word and the
// next dispatch/wait dereferences it = process crash (observed: NC gameplay-entry, two threads
// dead on rdram+0x80067958). The null-context [schedfix] guard can't catch a NON-NULL garbage
// pointer, so: registry of every context this module allocated, exact membership = validity.
// A scribbled TCB then diverts to the same skip/terminate path as a destroyed thread — matching
// hardware, where scribbling a parked thread's saved context doesn't kill the OS.
// HOST-SIDE THREAD-CONTEXT MAP (NC RUN 35/36, general): additionally, the context pointer no
// longer LIVES in the guest TCB at all — Nightmare Creatures' level init heap-allocates its 2D
// render-record array (func_8007542C: alloc(0x3E80) via its own deterministic allocator) OVER the
// boot-thread TCBs, which is legal on hardware where a TCB is just memory. The context now lives
// host-side keyed by the guest TCB ADDRESS; the game can repurpose its RAM and the host thread
// keeps running, exactly like the silicon's CPU would. The TCB's `context` struct field remains
// declared for layout but is no longer read or written.
static std::unordered_map<int32_t, UltraThreadContext*> thread_contexts{};
static std::set<UltraThreadContext*> live_contexts{};
static std::mutex live_contexts_mutex{};
static void register_live_context(UltraThreadContext* c) {
    std::lock_guard lock{live_contexts_mutex};
    live_contexts.insert(c);
}
static void unregister_live_context(UltraThreadContext* c) {
    std::lock_guard lock{live_contexts_mutex};
    live_contexts.erase(c);
}
// non-static: check_running_queue's preemption path (scheduling.cpp) needs the same guard
bool context_pointer_valid(UltraThreadContext* c) {
    if (c == nullptr) {
        return false;
    }
    std::lock_guard lock{live_contexts_mutex};
    return live_contexts.find(c) != live_contexts.end();
}
// Host-side context lookup by guest TCB address. Non-static: scheduling.cpp uses it too.
UltraThreadContext* um_thread_context(int32_t t_) {
    std::lock_guard lock{live_contexts_mutex};
    auto it = thread_contexts.find(t_);
    return it == thread_contexts.end() ? nullptr : it->second;
}
static void um_set_thread_context(int32_t t_, UltraThreadContext* c) {
    std::lock_guard lock{live_contexts_mutex};
    if (c != nullptr) {
        thread_contexts[t_] = c;
    } else {
        thread_contexts.erase(t_);
    }
}

// Native APIs only used to set thread names for easier debugging
#ifdef _WIN32
#include <Windows.h>
#endif

static ultramodern::threads::callbacks_t threads_callbacks;

void ultramodern::threads::set_callbacks(const callbacks_t& callbacks) {
    threads_callbacks = callbacks;
}

std::string ultramodern::threads::get_game_thread_name(const OSThread* t) {
    if (threads_callbacks.get_game_thread_name == nullptr) {
        return "Game Thread " + std::to_string(t->id);
    }
    return threads_callbacks.get_game_thread_name(t);
}

extern "C" void bootproc();

thread_local bool is_main_thread = false;
// Whether this thread is part of the game (i.e. the start thread or one spawned by osCreateThread)
thread_local bool is_game_thread = false;
thread_local PTR(OSThread) thread_self = NULLPTR;

void ultramodern::set_main_thread() {
    ::is_game_thread = true;
    is_main_thread = true;
}

bool ultramodern::is_game_thread() {
    return ::is_game_thread;
}

#if 0
int main(int argc, char** argv) {
    ultramodern::set_main_thread();

    bootproc();
}
#endif

#if 1
// [thread-gp 2026-09-06] last arg = the guest OSThread pointer, so the callee can restore $gp from
// the thread's saved context (__osDispatchThread's job on hardware). See librecomp/src/recomp.cpp.
void run_thread_function(uint8_t* rdram, uint64_t addr, uint64_t sp, uint64_t arg, uint32_t thread_ptr);
#else
#define run_thread_function(func, sp, arg, thread_ptr) func(arg)
#endif

#if defined(_WIN32)
void ultramodern::set_native_thread_name(const std::string& name) {
    std::wstring wname{name.begin(), name.end()};

    HRESULT r;
    r = SetThreadDescription(
        GetCurrentThread(),
        wname.c_str()
    );
}

void ultramodern::set_native_thread_priority(ThreadPriority pri) {
    int nPriority = THREAD_PRIORITY_NORMAL;

    // Convert ThreadPriority to Win32 priority
    switch (pri) {
        case ThreadPriority::Low:
            nPriority = THREAD_PRIORITY_BELOW_NORMAL;
            break;
        case ThreadPriority::Normal:
            nPriority = THREAD_PRIORITY_NORMAL;
            break;
        case ThreadPriority::High:
            nPriority = THREAD_PRIORITY_ABOVE_NORMAL;
            break;
        case ThreadPriority::VeryHigh:
            nPriority = THREAD_PRIORITY_HIGHEST;
            break;
        case ThreadPriority::Critical:
            nPriority = THREAD_PRIORITY_TIME_CRITICAL;
            break;
        default:
            throw std::runtime_error("Invalid thread priority!");
            break;
    }
    // SetThreadPriority(GetCurrentThread(), nPriority);
}
#elif defined(__linux__)
#include <sys/prctl.h>

void ultramodern::set_native_thread_name(const std::string& name) {
    if (name.length() > 15) {
        // Linux only accepts up to 16 characters including the null terminator for a thread name.
        debug_printf("[Thread] The thread name '%s' will be truncated to 15 characters", name.c_str());
    }

    prctl(PR_SET_NAME, name.c_str());
}

void ultramodern::set_native_thread_priority(ThreadPriority pri) {
    // TODO linux thread priority
    // printf("set_native_thread_priority unimplemented\n");
    // int nPriority = THREAD_PRIORITY_NORMAL;

    // // Convert ThreadPriority to Win32 priority
    // switch (pri) {
    //     case ThreadPriority::Low:
    //         nPriority = THREAD_PRIORITY_BELOW_NORMAL;
    //         break;
    //     case ThreadPriority::Normal:
    //         nPriority = THREAD_PRIORITY_NORMAL;
    //         break;
    //     case ThreadPriority::High:
    //         nPriority = THREAD_PRIORITY_ABOVE_NORMAL;
    //         break;
    //     case ThreadPriority::VeryHigh:
    //         nPriority = THREAD_PRIORITY_HIGHEST;
    //         break;
    //     case ThreadPriority::Critical:
    //         nPriority = THREAD_PRIORITY_TIME_CRITICAL;
    //         break;
    //     default:
    //         throw std::runtime_error("Invalid thread priority!");
    //         break;
    // }
}
#elif defined(__APPLE__)
void ultramodern::set_native_thread_name(const std::string& name) {
    if (name.length() > 15) {
        // Macs seem to only accept up to 16 characters including the null terminator for a thread name.
        debug_printf("[Thread] The thread name '%s' will be truncated to 15 characters", name.c_str());
    }

    pthread_setname_np(name.c_str());
}

void ultramodern::set_native_thread_priority(ThreadPriority pri) {}
#endif

void wait_for_resumed(RDRAM_ARG UltraThreadContext* thread_context) {
    const bool _tw = recomp_tcb_watch() && (uint32_t)ultramodern::this_thread() == recomp_tcb_watch();  // [tcbwatch]
    // CV64 (session 28 cont.13): if this thread's context was already nulled (it was destroyed by
    // another thread while it was the running thread), thread_context is null here and waiting on a
    // null semaphore crashes (READ 0x10 in LightweightSemaphore::wait, observed at the weretiger
    // death / platform-raise). Treat a null context as "already destroyed" and terminate this
    // thread, matching the context-replaced cleanup path below.
    if (thread_context == nullptr) {
        if (_tw) { fprintf(stderr, "[tcbwatch] (3) wait_for_resumed watched thread 0x%08X: NULL context -> terminate\n", (uint32_t)ultramodern::this_thread()); fflush(stderr); }  // [tcbwatch]
        static int _sf = 0;
        if (_sf++ < 32) {
            fprintf(stderr, "[schedfix] wait_for_resumed got a null context -> terminating thread\n");
            fflush(stderr);
        }
        throw ultramodern::thread_terminated{};
    }
    // Live-context registry guard: a NON-NULL garbage context (guest scribbled the TCB's host-pointer
    // field — legal __OSThreadContext memory on hardware) would crash in wait(). Same remedy as null.
    if (!context_pointer_valid(thread_context)) {
        if (_tw) { fprintf(stderr, "[tcbwatch] (3) wait_for_resumed watched thread 0x%08X: CORRUPT context %p -> terminate\n", (uint32_t)ultramodern::this_thread(), (void*)thread_context); fflush(stderr); }  // [tcbwatch]
        static int _sg = 0;
        if (_sg++ < 32) {
            fprintf(stderr, "[schedfix] wait_for_resumed got a corrupt context %p (TCB scribbled) -> terminating thread\n",
                    (void*)thread_context);
            fflush(stderr);
        }
        throw ultramodern::thread_terminated{};
    }
    thread_context->running.wait();
    // If this thread's context was replaced by another thread or deleted, destroy it again from its own context.
    // This will trigger thread cleanup instead.
    if (um_thread_context(ultramodern::this_thread()) != thread_context) {
        // DK64 boot-regression hunt (2026-07-12): the host-side thread-context map (94149a3) changed
        // um_thread_context to a host map; this "context replaced" check may now false-positive on DK64's
        // threading -> a SILENT self-terminate hangs it. Instrument (always) + RECOMP_TCB_REPLACE_GUARD=0
        // makes it RESUME instead of terminate, to test whether this guard is the regression.
        static const bool replace_guard = [] {
            const char* e = std::getenv("RECOMP_TCB_REPLACE_GUARD");
            return e == nullptr || e[0] != '0';   // default ON (standard ultramodern cleanup)
        }();
        static int _sr = 0;
        if (_sr++ < 32) {
            fprintf(stderr, "[schedfix] thread 0x%08X WOKE but context REPLACED (map=%p != ctx=%p) -> %s\n",
                    (uint32_t)ultramodern::this_thread(),
                    (void*)um_thread_context(ultramodern::this_thread()), (void*)thread_context,
                    replace_guard ? "self-terminate" : "RESUME (guard off)");
            fflush(stderr);
        }
        if (_tw) { fprintf(stderr, "[tcbwatch] (3) wait_for_resumed watched thread 0x%08X: WOKE but context REPLACED (map=%p != ctx=%p) -> osDestroyThread(NULL) SILENT SELF-TERMINATE\n", (uint32_t)ultramodern::this_thread(), (void*)um_thread_context(ultramodern::this_thread()), (void*)thread_context); fflush(stderr); }  // [tcbwatch] PRIME SUSPECT
        if (replace_guard) {
            osDestroyThread(PASS_RDRAM NULLPTR);
        }
    } else if (_tw) {
        fprintf(stderr, "[tcbwatch] (3) wait_for_resumed watched thread 0x%08X: WOKE, resumed normally\n", (uint32_t)ultramodern::this_thread()); fflush(stderr);  // [tcbwatch]
    }
}

// Inverse of TO_PTR for a KSEG0 TCB: host OSThread* back to the guest address the context map is keyed by.
static PTR(OSThread) thread_to_ptr(RDRAM_ARG OSThread* t) {
    return (PTR(OSThread))(int32_t)(0x80000000u | (uint32_t)((uint8_t*)t - rdram));
}

void resume_thread(RDRAM_ARG PTR(OSThread) t_) {
    OSThread* t = TO_PTR(OSThread, t_);
    debug_printf("[Thread] Resuming execution of thread %d\n", t->id);
    UltraThreadContext* c = um_thread_context(t_);
    // A destroyed thread (map entry erased) has no host thread to wake — skip, like the old null check.
    if (c == nullptr) {
        static int _sg = 0;
        if (_sg++ < 32) {
            fprintf(stderr, "[schedfix] resume_thread t=%d has no live context -> skipping resume\n", (int)t->id);
            fflush(stderr);
        }
        return;
    }
    c->running.signal();
}

// STALE-INTERRUPT DISPATCH FIX (NC RUN 24, general): external interrupt messages (VI/AI/SP/DP/PI)
// pile in the host-side queue and are delivered into guest queues only at osSendMesg/osRecvMesg
// boundaries — so a dispatch decision (who runs next) can be made while several frames of undelivered
// interrupts exist, running a lower-priority thread ahead of the higher-priority handler hardware
// would already have dispatched. Concretely (Nightmare Creatures): 4 undelivered VI retraces let
// osStartThread swap to a fresh pri-50 audio thread; its own blocking recv then delivered the stale
// batch to the pri-127 OSSched, which forwarded a retrace to the JUST-registered client — the client
// thread ticked into a not-yet-initialized voice list (its creator, pri 10, hadn't finished init) and
// spun forever, starving the world. On hardware a retrace is fully handled within microseconds of
// firing; no client can receive a retrace that predates its registration. Invariant restored here:
// deliver all pending external messages BEFORE any dispatch decision (run_next_thread pop,
// osStartThread's check_running_queue).
void dequeue_external_messages(RDRAM_ARG1);   // mesgqueue.cpp (external linkage, no header decl)

void run_next_thread(RDRAM_ARG1) {
    dequeue_external_messages(PASS_RDRAM1);   // stale-interrupt dispatch fix: pop with fresh info
    // CV64 (session 28 cont.13): a thread destroyed via osDestroyThread (context nulled) or that
    // self-terminated can be left in the running queue if it wasn't removed from it (e.g. its
    // t->queue field didn't point at the running queue). Popping such a dead thread and
    // dereferencing its null context crashes (WRITE 0x10 here, at the weretiger death/platform-raise).
    // Skip any dead thread (null context) and resume the next live one instead of crashing.
    OSThread* to_run = nullptr;
    UltraThreadContext* to_run_context = nullptr;
    for (;;) {
        // Bare-metal ports (NC/Robotron/Space Invaders) may have NO dedicated idle thread: the sole
        // game thread blocks on the VI queue and there is nothing else runnable. Rather than crash
        // ("No threads left to run!"), wait for an external event (VI/AI/SI retrace, timer) — do_send
        // inside wait_for_external_message delivers it to the blocked thread's queue and reschedules
        // it into the running queue, so the loop then finds it. Normal HLE games always have a
        // runnable idle thread, so the queue is never empty and this wait is never entered.
        // (General bare-metal-port scheduler fix.)
        while (ultramodern::thread_queue_empty(PASS_RDRAM ultramodern::running_queue)) {
            // [schedpump] (MKT boot-stall, throwaway): the empty-running-queue external pump.
            { static int _sp = 0; static const int _pcap = [](){ const char* e = std::getenv("RECOMP_SCHED_LOG_N"); return e ? atoi(e) : 40; }(); if (_pcap == 0 || _sp++ < _pcap) { fprintf(stderr, "[schedpump] t=%d running_queue EMPTY -> pump external #%d\n", (int)TO_PTR(OSThread, thread_self)->id, _sp); fflush(stderr); } }
            ultramodern::wait_for_external_message(PASS_RDRAM1);
        }
        PTR(OSThread) to_run_ = ultramodern::thread_queue_pop(PASS_RDRAM ultramodern::running_queue);
        to_run = TO_PTR(OSThread, to_run_);
        to_run_context = (to_run != nullptr) ? um_thread_context(to_run_) : nullptr;
        if (to_run_context != nullptr) {
            // [schednext] (MKT boot-stall, throwaway): which thread the scheduler resumes, in order.
            { static int _rn = 0; static const int _rcap = [](){ const char* e = std::getenv("RECOMP_SCHED_LOG_N"); return e ? atoi(e) : 80; }(); if (_rcap == 0 || _rn++ < _rcap) { fprintf(stderr, "[schednext] resume t=%d pri=%d\n", (int)to_run->id, (int)to_run->priority); fflush(stderr); } }
            if (recomp_tcb_watch() && (uint32_t)to_run_ == recomp_tcb_watch()) {   // [tcbwatch]
                fprintf(stderr, "[tcbwatch] (2) run_next_thread RESUMING watched thread 0x%08X pri=%d\n", (uint32_t)to_run_, (int)to_run->priority); fflush(stderr);
            }
            break;
        }
        static int _sf = 0;
        if (_sf++ < 32) {
            fprintf(stderr, "[schedfix] skipped a destroyed thread (no live context) left in the running queue\n");
            fflush(stderr);
        }
    }
    debug_printf("[Scheduling] Resuming execution of thread %d\n", to_run->id);
    to_run_context->running.signal();
}

void ultramodern::run_next_thread_and_wait(RDRAM_ARG1) {
    UltraThreadContext* cur_context = um_thread_context(thread_self);
    run_next_thread(PASS_RDRAM1);
    wait_for_resumed(PASS_RDRAM cur_context);
}

void ultramodern::resume_thread_and_wait(RDRAM_ARG OSThread *t) {
    UltraThreadContext* cur_context = um_thread_context(thread_self);
    resume_thread(PASS_RDRAM thread_to_ptr(PASS_RDRAM t));
    wait_for_resumed(PASS_RDRAM cur_context);
}

static void _thread_func(RDRAM_ARG PTR(OSThread) self_, PTR(thread_func_t) entrypoint, PTR(void) arg, UltraThreadContext* thread_context) {
    OSThread *self = TO_PTR(OSThread, self_);
    debug_printf("[Thread] Thread created: %d\n", self->id);
    thread_self = self_;
    is_game_thread = true;

    // Set the thread name
    ultramodern::set_native_thread_name(ultramodern::threads::get_game_thread_name(self));
    ultramodern::set_native_thread_priority(ultramodern::ThreadPriority::High);

    // Signal the initialized semaphore to indicate that this thread can be started.
    thread_context->initialized.signal();

    debug_printf("[Thread] Thread waiting to be started: %d\n", self->id);

    // Wait until the thread is marked as running.
    try {
        wait_for_resumed(PASS_RDRAM thread_context);
    } catch (ultramodern::thread_terminated& terminated) {
    }

    // Make sure the thread wasn't replaced or destroyed before it was started.
    if (um_thread_context(self_) == thread_context) {
        debug_printf("[Thread] Thread started: %d\n", self->id);
        try {
            // Run the thread's function with the provided argument.
            run_thread_function(PASS_RDRAM entrypoint, self->sp, arg, (uint32_t)self_);
        } catch (ultramodern::thread_terminated& terminated) {
        }
    }
    else {
        debug_printf("[Thread] Thread destroyed before being started: %d\n", self->id);
    }

    // Check if the thread hasn't been destroyed or replaced. If so, then the thread terminated or destroyed itself,
    // so mark this thread as destroyed and run the next queued thread.
    if (um_thread_context(self_) == thread_context) {
        um_set_thread_context(self_, nullptr);
        run_next_thread(PASS_RDRAM1);
    }

    // Dispose of this thread now that it's completed or terminated.
    ultramodern::cleanup_thread(thread_context);
}

extern "C" void osStartThread(RDRAM_ARG PTR(OSThread) t_) {
    OSThread* t = TO_PTR(OSThread, t_);
    debug_printf("[os] Start Thread %d\n", t->id);
    // [thrstart] Companion to [thrcreate]. A game can hand work to an ALREADY-CREATED thread with
    // osStartThread alone, so counting only osCreateThread can show "no new threads" while the game
    // is in fact starting one. KI Gold 2026-08-29: its game thread t=73 self-destructs at the fight
    // transition and NO thrcreate follows -- this says whether anything is STARTED after that.
    fprintf(stderr, "[thrstart] t=%d thr=0x%08X pri=%d state=%u\n",
            (int)t->id, (uint32_t)t_, (int)t->priority, (unsigned)t->state);
    fflush(stderr);

    // If this is a game thread, insert the new thread into the running queue and then check the running queue.
    if (thread_self) {
        // stale-interrupt dispatch fix (see dequeue_external_messages above): deliver pending external
        // interrupts first so the preemption check sees every thread hardware would have already woken —
        // a started thread must not run ahead of a higher-priority handler with pending interrupts.
        dequeue_external_messages(PASS_RDRAM1);
        ultramodern::schedule_running_thread(PASS_RDRAM t_);
        ultramodern::check_running_queue(PASS_RDRAM1);
    }
    // Otherwise, immediately start the thread and terminate this one.
    else {
        t->state = OSThreadState::QUEUED;
        resume_thread(PASS_RDRAM t_);
        //throw ultramodern::thread_terminated{};
    }
}

extern "C" void osCreateThread(RDRAM_ARG PTR(OSThread) t_, OSId id, PTR(thread_func_t) entrypoint, PTR(void) arg, PTR(void) sp, OSPri pri) {
    debug_printf("[os] Create Thread %d\n", id);
    // [thrcreate] (Robotron boot-stall, remove after): map thread id -> entry func vram + priority.
    fprintf(stderr, "[thrcreate] t=%d thr=0x%08X pri=%d entry=0x%08X arg=0x%08X\n",
            (int)id, (uint32_t)t_, (int)pri, (uint32_t)(uintptr_t)entrypoint, (uint32_t)(uintptr_t)arg);
    fflush(stderr);
    OSThread *t = TO_PTR(OSThread, t_);
    
    t->next = NULLPTR;
    t->queue = NULLPTR;
    t->priority = pri;
    ultramodern::thread_queue_note_priority(t_, pri);   // host-cached pri: the API-surface snapshot
    t->id = id;
    t->state = OSThreadState::STOPPED;
    t->sp = sp - 0x10; // Set up the first stack frame

    // Spawn a new thread, which will immediately pause itself and wait until it's been started.
    // Pass the context as an argument to the thread function to ensure that it can't get cleared before the thread captures its value.
    UltraThreadContext* context = new UltraThreadContext{};
    register_live_context(context);
    um_set_thread_context(t_, context);   // host-side map — nothing host-owned lives in the guest TCB
    context->host_thread = std::thread{_thread_func, PASS_RDRAM t_, entrypoint, arg, context};

    // Wait until the thread is initialized to indicate that it's ready to be started.
    context->initialized.wait();
    debug_printf("[os] Thread %d is ready to be started\n", t->id);
}

extern "C" void osStopThread(RDRAM_ARG PTR(OSThread) t_) {
    if (t_ == NULLPTR) {
        t_ = thread_self;
    }
    // Check if the thread is stopping itself (arg is null or thread_self).
    if (t_ == thread_self) {
        ultramodern::run_next_thread_and_wait(PASS_RDRAM1);
    }
    else {
        assert(false);
    }
}

extern "C" void osDestroyThread(RDRAM_ARG PTR(OSThread) t_) {
    if (t_ == NULLPTR) {
        t_ = thread_self;
    }
    if (recomp_tcb_watch()) {   // [tcbwatch] (4) every osDestroyThread; the watched game thread is flagged
        fprintf(stderr, "[tcbwatch] (4) osDestroyThread t=0x%08X%s%s\n", (uint32_t)t_,
                ((uint32_t)t_ == recomp_tcb_watch()) ? " == WATCHED game thread" : "",
                (t_ == thread_self) ? " (self)" : ""); fflush(stderr);
    }
    OSThread* t = TO_PTR(OSThread, t_);
    // Check if the thread is destroying itself (arg is null or thread_self)
    if (t_ == thread_self) {
        throw ultramodern::thread_terminated{};
    }
    // Otherwise if the thread isn't stopped, remove it from its currrent queue.,
    if (t->state != OSThreadState::STOPPED) {
        // Host membership map is the authority (t->queue is game-writable and may be scribbled).
        ultramodern::thread_queue_remove(PASS_RDRAM ultramodern::thread_queue_membership(t_), t_);
    }
    // Check if the thread has already been destroyed to prevent destroying it again.
    UltraThreadContext* cur_context = um_thread_context(t_);
    if (cur_context != nullptr) {
        // Mark the target thread as destroyed and resume it. When it starts it'll check this and terminate itself instead of resuming.
        um_set_thread_context(t_, nullptr);
        cur_context->running.signal();
    }
}

extern "C" void osSetThreadPri(RDRAM_ARG PTR(OSThread) t_, OSPri pri) {
    if (t_ == NULLPTR) {
        t_ = thread_self;
    }
    OSThread* t = TO_PTR(OSThread, t_);

    // Unconditional API snapshot: the guest field may be scribbled to coincide with pri, which would
    // skip the change-check below — the cache must still record what the game just asked for.
    ultramodern::thread_queue_note_priority(t_, pri);

    if (t->priority != pri) {
        t->priority = pri;

        if (t_ != ultramodern::this_thread() && t->state != OSThreadState::STOPPED) {
            // Re-slot at the new priority. The host membership map is the authority on which queue
            // the thread sits on (t->queue is game-writable memory and may be scribbled).
            PTR(PTR(OSThread)) q = ultramodern::thread_queue_membership(t_);
            if (q != NULLPTR) {
                ultramodern::thread_queue_remove(PASS_RDRAM q, t_);
                ultramodern::thread_queue_insert(PASS_RDRAM q, t_);
            }
        }

        ultramodern::check_running_queue(PASS_RDRAM1);
    }
}

extern "C" OSPri osGetThreadPri(RDRAM_ARG PTR(OSThread) t) {
    if (t == NULLPTR) {
        t = thread_self;
    }
    return TO_PTR(OSThread, t)->priority;
}

extern "C" OSId osGetThreadId(RDRAM_ARG PTR(OSThread) t) {
    if (t == NULLPTR) {
        t = thread_self;
    }
    return TO_PTR(OSThread, t)->id;
}

PTR(OSThread) ultramodern::this_thread() {
    return thread_self;
}

static std::thread thread_cleaner_thread;
static moodycamel::BlockingConcurrentQueue<UltraThreadContext*> deleted_threads{};
extern std::atomic_bool exited;

void thread_cleaner_func() {
    using namespace std::chrono_literals;
    while (!exited) {
        UltraThreadContext* to_delete;
        if (deleted_threads.wait_dequeue_timed(to_delete, 10ms)) {
            debug_printf("[Cleanup] Deleting thread context %p\n", to_delete);

            to_delete->host_thread.join();
            unregister_live_context(to_delete);
            delete to_delete;
        }
    }
}

void ultramodern::init_thread_cleanup() {
    thread_cleaner_thread = std::thread{thread_cleaner_func};
}

void ultramodern::cleanup_thread(UltraThreadContext *cur_context) {
    deleted_threads.enqueue(cur_context);
}

void ultramodern::join_thread_cleaner_thread() {
    thread_cleaner_thread.join();
}
