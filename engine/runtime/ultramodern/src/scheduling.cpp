#include <cstdlib>
#include <cstdio>   // [pauseself]/[yieldpoll] MKT boot-stall probe (remove with the probe)
#include <set>      // [yieldpoll] dedup of spinning func vrams (remove with the probe)
#include "ultramodern/ultramodern.hpp"

bool context_pointer_valid(UltraThreadContext* c);        // threads.cpp live-context registry
UltraThreadContext* um_thread_context(int32_t t_);        // threads.cpp host-side context map
uint32_t recomp_tcb_watch();                              // threads.cpp — [tcbwatch] exit-path probe (remove with the probe)
extern "C" void recomp_cop0_tlb_write(int reg, uint32_t value);  // EPC latch for bare-metal drains (tlb.cpp)

void ultramodern::schedule_running_thread(RDRAM_ARG PTR(OSThread) t_) {
    debug_printf("[Scheduling] Adding thread %d to the running queue\n", TO_PTR(OSThread, t_)->id);
    thread_queue_insert(PASS_RDRAM running_queue, t_);
    TO_PTR(OSThread, t_)->state = OSThreadState::QUEUED;
}

void swap_to_thread(RDRAM_ARG OSThread *to) {
    debug_printf("[Scheduling] Thread %d giving execution to thread %d\n", TO_PTR(OSThread, ultramodern::this_thread())->id, to->id);
    // Insert this thread in the running queue.
    ultramodern::thread_queue_insert(PASS_RDRAM ultramodern::running_queue, ultramodern::this_thread());
    TO_PTR(OSThread, ultramodern::this_thread())->state = OSThreadState::QUEUED;
    // Unpause the target thread and wait for this one to be unpaused.
    ultramodern::resume_thread_and_wait(PASS_RDRAM to);
}

void dequeue_external_messages(RDRAM_ARG1);   // mesgqueue.cpp (external linkage, no header) - [evtpump]
void ultramodern::check_running_queue(RDRAM_ARG1) {
    // [evtpump 2026-09-03] Every scheduling point is an interrupt-delivery point. External event messages
    // (VI retrace, SP/DP done, AI, PI, SI) were pumped into guest queues only inside osSend/Jam/RecvMesg;
    // a guest thread looping on OTHER OS calls never pumped them (Iggy's pri-10 worker toggles osSetThreadPri
    // around an empty-list poll at 11M iterations/s: the pri-18 scheduler thread received 19 messages in
    // 40 s, its VI queue full, no SP-done ever forwarded, black). Hardware delivers regardless of what the
    // CPU executes; the honest points we own are the OS entries that can reschedule, which all pass here.
    {
        static thread_local bool _in_pump = false;
        if (!_in_pump) { _in_pump = true; dequeue_external_messages(PASS_RDRAM1); _in_pump = false; }
    }
    // Check if there are any threads in the running queue.
    while (!thread_queue_empty(PASS_RDRAM running_queue)) {
        // Check if the highest priority thread in the queue is higher priority than the current thread.
        PTR(OSThread) next_thread_ = ultramodern::thread_queue_peek(PASS_RDRAM running_queue);
        OSThread* next_thread = TO_PTR(OSThread, next_thread_);
        // A thread destroyed via osDestroyThread (context erased) or that self-terminated can be left in
        // the running queue (its t->queue field didn't point at the running queue, so it was never
        // removed). Resuming it would signal a dead context. run_next_thread() already skips these on the
        // POP path; this PREEMPTION path needs the same guard. (General dead-thread scheduler fix; first
        // hit by Blast Corps' boot — same class as the CV64 weretiger-death crash run_next_thread fixed.)
        if (um_thread_context(next_thread_) == nullptr) {   // destroyed / never created (host-side map)
            ultramodern::thread_queue_pop(PASS_RDRAM running_queue);
            continue;
        }
        // Host-cached priorities (NC RUN 63): the TCB priority field is game-writable — a scribbled
        // 0 there let a woken thread rank below its game's idle spinner forever (pop starvation).
        if (ultramodern::thread_queue_priority(PASS_RDRAM next_thread_)
                > ultramodern::thread_queue_priority(PASS_RDRAM ultramodern::this_thread())) {
            ultramodern::thread_queue_pop(PASS_RDRAM running_queue);
            if (recomp_tcb_watch() && (uint32_t)next_thread_ == recomp_tcb_watch()) {   // [tcbwatch]
                fprintf(stderr, "[tcbwatch] (2) check_running_queue PREEMPT-RESUMING watched thread 0x%08X pri=%d\n", (uint32_t)next_thread_, (int)next_thread->priority); fflush(stderr);
            }
            // Swap to the higher priority thread.
            swap_to_thread(PASS_RDRAM next_thread);
        }
        break;
    }
}

extern "C" int  recomp_baremetal_enabled();
extern "C" int  recomp_baremetal_eret_seen();
extern "C" void recomp_baremetal_idle();

// PRE-ERET GATE (2026-07-02, the NC hybrid fix, same invariant as pi.cpp/si.cpp): the bare-metal
// yield branches divert to recomp_baremetal_idle(), which is a NO-OP until the fiber world
// bootstraps (g_ctx captured at the first eret). A hybrid title (NC: HLE threads + baremetal envs
// set) that poll-yields pre-eret would spin into that no-op forever WITHOUT pumping externals —
// the proven RUN-24 livelock: 3 thread resumes in 75s, the scheduler starved of its retraces.
// Divert only once erets are live; pre-eret the HLE pump is both safe and the only thing that works.
static inline bool baremetal_live() {
    return recomp_baremetal_enabled() && recomp_baremetal_eret_seen();
}

extern "C" void pause_self(RDRAM_ARG uint32_t pc_vram) {
    if (baremetal_live()) {
        // Bare-metal cooperative idle (the NC class): the game has no libultra thread scheduler. Drain pending
        // RCP interrupts by running the game's own exception handler on THIS (game) thread — it posts its
        // events + reschedules, and the eret fiber-switches into the woken task. Loop as the idle.
        // EPC latch (SOTE wall 4): pc_vram = the guest `b .` halt instruction this call replaces. Latch it
        // before EVERY drain — the handler's context save must park the task AT its halt loop, exactly as a
        // hardware interrupt would. The unlatched drain here was the last stale-EPC venue: it saved the
        // CURRENT registers with a pc from a long-dead poll guard, and the task later resumed at that pc
        // with foreign registers, derailing into data (the B1-container cascade → get_function fatal).
        // pc_vram==0 = legacy caller with no pc — keep the old don't-touch-EPC behavior for it.
        { static int _pb = 0; if (_pb++ < 6) { fprintf(stderr, "[pauseself] baremetal idle loop entered (halt pc=0x%08X)\n", pc_vram); fflush(stderr); } }
        for (;;) {
            if (pc_vram != 0u) recomp_cop0_tlb_write(14, pc_vram);
            recomp_baremetal_idle();
            ultramodern::wait_for_external_message_timed(PASS_RDRAM1, 1); // ~1ms idle, then re-check pending
        }
    }
    // [pauseself] (MKT boot-stall, throwaway): does the idle thread ever reach its pump?
    static const int _scap = [](){ const char* e = std::getenv("RECOMP_SCHED_LOG_N"); return e ? atoi(e) : 4; }();
    { static int _ps = 0; if (_scap == 0 || _ps++ < _scap) { fprintf(stderr, "[pauseself] t=%d idle pump ENTERED (iter %d)\n", (int)TO_PTR(OSThread, ultramodern::this_thread())->id, _ps); fflush(stderr); } }
    while (true) {
        // Wait until an external message arrives, then allow the next thread to run.
        ultramodern::wait_for_external_message(PASS_RDRAM1);
        { static int _pl = 0; if (_scap == 0 || _pl++ < 8) { fprintf(stderr, "[pauseself] t=%d pumped one external (loop %d)\n", (int)TO_PTR(OSThread, ultramodern::this_thread())->id, _pl); fflush(stderr); } }
        ultramodern::check_running_queue(PASS_RDRAM1);
    }
}

// [osYieldThread 2026-09-06, Bust-A-Move 99 #98] libultra's yield, implemented in the engine for
// the first time: ultra64.h declared osYieldThread and NOTHING defined it, and the shim in
// librecomp/src/ultra_translation.cpp was `assert(false);` with the real call commented out — so
// in a Release build (NDEBUG) every named osYieldThread was a SILENT NO-OP (doom64 and lod name it
// today and get that no-op).
//
// libultra (sm64_decomp/lib/src/osYieldThread.c, byte-identical shape at bam99's 0x80098530):
//     saveMask = __osDisableInt();
//     __osRunningThread->state = OS_STATE_RUNNABLE;   // 2
//     __osEnqueueAndYield(&__osRunQueue);
//     __osRestoreInt(saveMask);
// __osEnqueueThread inserts the yielding thread AFTER every queued thread of equal-or-higher
// priority and __osDispatchThread then runs the queue head, so a yield hands the CPU to an
// EQUAL-priority peer — that round-robin IS the whole point of the call. check_running_queue()
// deliberately preempts only on STRICTLY-higher priority (correct for every other OS entry, none
// of which gives up its slice), so a faithful yield needs its own >= comparison. Without it the
// classic rendezvous `while (flag) osYieldThread();` between two pri-10 threads never lets the
// peer clear the flag: bam99 measured 416k no-op yields/s and 4 fps at its legal card.
extern "C" void osYieldThread(RDRAM_ARG1) {
    // Every scheduling point is an interrupt-delivery point (see check_running_queue): deliver
    // without blocking, and take the strictly-higher preemption through the vetted path first.
    ultramodern::wait_for_external_message_timed(PASS_RDRAM1, 0);
    ultramodern::check_running_queue(PASS_RDRAM1);
    // Then the yield proper: hand the slice to an equal-priority peer if one is queued.
    while (!ultramodern::thread_queue_empty(PASS_RDRAM ultramodern::running_queue)) {
        PTR(OSThread) next_thread_ = ultramodern::thread_queue_peek(PASS_RDRAM ultramodern::running_queue);
        // Same dead-thread guard check_running_queue carries: a destroyed or self-terminated
        // thread can be left in the queue and resuming it would signal a dead context.
        if (um_thread_context(next_thread_) == nullptr) {
            ultramodern::thread_queue_pop(PASS_RDRAM ultramodern::running_queue);
            continue;
        }
        if (ultramodern::thread_queue_priority(PASS_RDRAM next_thread_)
                >= ultramodern::thread_queue_priority(PASS_RDRAM ultramodern::this_thread())) {
            ultramodern::thread_queue_pop(PASS_RDRAM ultramodern::running_queue);
            swap_to_thread(PASS_RDRAM TO_PTR(OSThread, next_thread_));
        }
        break;
    }
}

extern "C" void yield_self(RDRAM_ARG1) {
    { static const bool _yl = std::getenv("RECOMP_SCHED_LOG_N") != nullptr; static int _yn = 0; if (_yl && _yn++ < 4000) { fprintf(stderr, "[schedyield] t=%d yield_self (blocking pump)\n", (int)TO_PTR(OSThread, ultramodern::this_thread())->id); fflush(stderr); } }
    ultramodern::wait_for_external_message(PASS_RDRAM1);
    ultramodern::check_running_queue(PASS_RDRAM1);
}

extern "C" void yield_self_1ms(RDRAM_ARG uint32_t pc_vram) {
    if (baremetal_live()) {
        // Bare-metal poll-loop yield (the NC class): a task is spinning on a flag that only a higher-priority
        // task or an RCP interrupt can change, but there is NO libultra scheduler to switch to — the HLE
        // wait below is a no-op. Instead, drain any pending RCP interrupt by running the game's OWN exception
        // handler on the game thread (recomp_baremetal_idle): it posts the awaited event and reschedules via
        // its eret, emulating the async interrupt preemption the spin expects on hardware. Without this a
        // cooperative bare-metal busy-poll holds the game thread forever and the event is never posted.
        // Latch EPC = the guard's back-edge pc first (hardware: exception entry latches the interrupted
        // instruction). Draining with a STALE EPC made the handler save a wrong resume pc; the re-entered
        // task derailed and poisoned its saved SR (the SOTE residual tear, caught by [sr-poison]).
        // pc_vram==0 = legacy caller with no pc — keep the old don't-touch-EPC behavior for it.
        if (pc_vram != 0u) recomp_cop0_tlb_write(14, pc_vram);
        recomp_baremetal_idle();
        return;
    }
    ultramodern::wait_for_external_message_timed(PASS_RDRAM1, 1);
    ultramodern::check_running_queue(PASS_RDRAM1);
}

// Non-blocking cooperative yield for CALLING poll-loops — the drain/poll idiom the load-only
// detector misses (e.g. an arcade-port main thread spinning on a software work-list drain
// function). Deliver any pending external interrupt WITHOUT blocking (0ms timeout) and let a
// now-ready higher-priority thread run, then return. Semantically free (hardware delivers
// interrupts / preempts at any instruction boundary) and cheap, so it is safe even if a genuine
// >100k-iteration work loop that calls a function happens to trip the guard.
extern "C" void yield_self_poll(RDRAM_ARG uint32_t func_vram, uint32_t ra, uint32_t pc_vram) {
    // [yieldpoll] (MKT boot-stall, throwaway): NAMES each function whose loop spins >100k + its caller
    // ra. For the game's halt/panic func (while(1)) ra = the ASSERT SITE (it makes no calls, so r31 is
    // preserved from entry). Deduped by (func, ra).
    {
        static std::set<uint64_t> _seen;
        uint64_t key = ((uint64_t)func_vram << 32) | ra;
        if (_seen.size() < 40 && _seen.insert(key).second) {
            fprintf(stderr, "[yieldpoll] spin in func 0x%08X (caller ra=0x%08X)\n", func_vram, ra); fflush(stderr);
        }
    }
    if (baremetal_live()) {
        // Bare-metal calling-poll yield: same as yield_self_1ms — drain pending RCP interrupts via the game's
        // exception handler so the spinner's awaited event gets posted (no libultra scheduler to switch to).
        // EPC latch: see yield_self_1ms — the stale-EPC drain here was the SOTE residual-tear source.
        { static int _yp = 0; if (_yp++ < 6) { fprintf(stderr, "[ypoll] baremetal drain from calling-poll guard func=0x%08X pc=0x%08X\n", func_vram, pc_vram); fflush(stderr); } }
        if (pc_vram != 0u) recomp_cop0_tlb_write(14, pc_vram);
        recomp_baremetal_idle();
        return;
    }
    ultramodern::wait_for_external_message_timed(PASS_RDRAM1, 0);
    ultramodern::check_running_queue(PASS_RDRAM1);
}


// [legacy-arity 2026-09-02] see recomp.h: short-form calls from emissions that predate ra / pc_vram. Same behaviour
// those emissions had when they were built (pc_vram = 0 -> no EPC latch).
extern "C" void yield_self_poll_legacy3(uint8_t *rdram, uint32_t func_vram, uint32_t ra) { yield_self_poll(rdram, func_vram, ra, 0u); }
extern "C" void yield_self_1ms_legacy1(uint8_t *rdram) { yield_self_1ms(rdram, 0u); }
extern "C" void pause_self_legacy1(uint8_t *rdram) { pause_self(rdram, 0u); }
