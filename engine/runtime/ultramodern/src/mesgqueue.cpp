#include <atomic>   // periodic-interrupt coalescing in-flight counters
#include <bitset>
#include <thread>
#include <set>      // [recvblock] Robotron boot-stall probe (remove with the probe)
#include <map>      // [mqsend]/[recvwake] MKT boot-stall probe (remove with the probe)
#include <cstdlib>  // getenv/strtoul for the RECOMP_TRACE_MQ trace-dump gate
// Execution-flow tracer (librecomp/src/trace.cpp). Always linked; prints the calling thread's recompiled
// call stack, but only meaningful when the game was recompiled with toml trace_mode = true. Called below
// when a thread parks on the queue named by env RECOMP_TRACE_MQ (general; no per-game address baked in).
extern "C" void recomp_trace_dump(const char* tag);

#include "blockingconcurrentqueue.h"

#include "ultramodern/ultra64.h"
#include "ultramodern/ultramodern.hpp"

struct QueuedMessage {
    PTR(OSMesgQueue) mq;
    OSMesg mesg;
    bool jam;
    bool requeue_if_blocked;
    // Which interrupt source produced this message (None = not interrupt-sourced). Carried so the
    // periodic-interrupt COALESCING below can account for in-flight messages per source.
    ultramodern::EventMessageSource src = static_cast<ultramodern::EventMessageSource>(-1);
    int retries = 0;   // [boundedrequeue] delivery attempts that found the guest queue FULL
};

static moodycamel::BlockingConcurrentQueue<QueuedMessage> external_messages {};
std::bitset<32> requeue_enabled;

// RDRAM base (recomp.cpp) — lets the coalescing read the target queue's msgCount without an
// RDRAM_ARG on enqueue_external_message_src (whose many callers don't thread rdram through).
extern "C" uint8_t* g_rdram_base;

// PERIODIC-INTERRUPT COALESCING (hardware semantics, derived blind — snowkids surfaced it):
// RCP interrupts are PENDING BITS in MI_INTR, not FIFOs. A VI retrace that fires while the previous
// one is unserviced coalesces into the already-set bit; libultra's ISR then sends ONE message
// (NOBLOCK, dropped if full). A guest thread can therefore NEVER observe several retraces delivered
// in the same instant — but our host-side buffer accumulated every per-frame enqueue while the guest
// was busy (measured: 5 retraces delivered in ONE dequeue on snowkids bad boots), converting a
// level-triggered interrupt into a counted event stream. Rule restored: at most ONE undelivered
// message in flight per PERIODIC source (Vi retrace, per-retrace Ai tick — the two ticks the VI
// thread synthesizes each frame). Coalescing engages only when the guest is not consuming — exactly
// when hardware would coalesce. Completion sources (Sp/Dp/Si/Pi/Timer) are 1:1 with operations and
// are never coalesced.
static std::atomic<int> g_pending_vi{0};
static std::atomic<int> g_pending_ai{0};
static std::atomic<int>* pending_counter_for(ultramodern::EventMessageSource src) {
    if (src == ultramodern::EventMessageSource::Vi) return &g_pending_vi;
    if (src == ultramodern::EventMessageSource::Ai) return &g_pending_ai;
    return nullptr;
}
// RECOMP_VI_COALESCE=0 disables periodic-interrupt coalescing (default ON = hardware-faithful, snowkids
// needs it). DK64 boot-regression hunt (2026-07-12): confirm whether the coalescing is what hangs DK64.
static bool coalesce_periodic_enabled() {
    static const bool on = [] {
        const char* e = std::getenv("RECOMP_VI_COALESCE");
        bool v = (e == nullptr || e[0] != '0');
        fprintf(stderr, "[coalesce] periodic-interrupt coalescing %s (RECOMP_VI_COALESCE)\n", v ? "ON" : "OFF");
        fflush(stderr);
        return v;
    }();
    return on;
}
static void note_message_left_flight(const QueuedMessage& m) {   // delivered OR dropped
    if (!coalesce_periodic_enabled()) return;
    if (std::atomic<int>* c = pending_counter_for(m.src)) c->fetch_sub(1, std::memory_order_relaxed);
}
static void note_message_requeued(const QueuedMessage& m) {      // back in flight
    if (!coalesce_periodic_enabled()) return;
    if (std::atomic<int>* c = pending_counter_for(m.src)) c->fetch_add(1, std::memory_order_relaxed);
}

void ultramodern::set_message_queue_control(const ultramodern::MessageQueueControl& mqc) {
    requeue_enabled.reset();
    requeue_enabled.set(static_cast<int>(EventMessageSource::Timer), mqc.requeue_timer);
    requeue_enabled.set(static_cast<int>(EventMessageSource::Sp), mqc.requeue_sp);
    requeue_enabled.set(static_cast<int>(EventMessageSource::Si), mqc.requeue_si);
    requeue_enabled.set(static_cast<int>(EventMessageSource::Ai), mqc.requeue_ai);
    requeue_enabled.set(static_cast<int>(EventMessageSource::Vi), mqc.requeue_vi);
    requeue_enabled.set(static_cast<int>(EventMessageSource::Pi), mqc.requeue_pi);
    requeue_enabled.set(static_cast<int>(EventMessageSource::Dp), mqc.requeue_dp);
}

void ultramodern::enqueue_external_message_src(PTR(OSMesgQueue) mq, OSMesg msg, bool jam, EventMessageSource src) {
    // (cont.19: stripped the per-enqueue [mq_ext] scheduler-queue logging — ~22k fflush'd lines/run,
    //  a real frame-rate drain; the deadlock it diagnosed is fixed.)
    // Periodic-interrupt coalescing (see the block above): if the previous tick from this source is
    // still undelivered, this one coalesces into it — the MI pending bit is already set on hardware.
    if (coalesce_periodic_enabled()) {
        if (std::atomic<int>* c = pending_counter_for(src)) {
            // Cap in-flight periodic messages at the TARGET queue's capacity, not a hard 1.
            // Hardware only drops a retrace when the game's OSMesgQueue is FULL; the VI manager
            // otherwise delivers every retrace. A hard cap of 1 starves a game whose VI queue
            // holds many — DK64's are depth 8..16, so it saw ~1/N of its retraces and its
            // VI-paced boot logic froze (2026-07-12 boot regression). Cap at the queue's own
            // msgCount: depth-1 queues (the snowkids case this coalescing was written for) keep
            // the old at-most-1 behavior, deeper queues get what hardware would give them, and
            // host-side burst is still bounded to the depth the game itself allocated.
            int cap = 1;
            if (mq && g_rdram_base) {
                uint32_t _phys = (uint32_t)mq & 0x1FFFFFFFu;
                if (_phys >= 0x80u && _phys < 0x800000u) {
                    uint8_t* rdram = g_rdram_base;   // TO_PTR expands to use `rdram`
                    int mc = TO_PTR(OSMesgQueue, mq)->msgCount;
                    if (mc >= 1 && mc <= 64) cap = mc;
                }
            }
            if (c->load(std::memory_order_relaxed) >= cap) {
                static int _co = 0;
                if (_co++ < 4) {
                    fprintf(stderr, "[coalesce] %s tick coalesced (%d in flight >= queue cap %d)\n",
                            src == EventMessageSource::Vi ? "VI" : "AI",
                            c->load(std::memory_order_relaxed), cap);
                    fflush(stderr);
                }
                return;
            }
            c->fetch_add(1, std::memory_order_relaxed);
        }
    }
    {   // [extq 2026-09-02] trace completion enqueues (RECOMP_EXTQ_TRACE=1)
        static const bool _tr = getenv("RECOMP_EXTQ_TRACE") != nullptr;
        if (_tr && (src == EventMessageSource::Dp || src == EventMessageSource::Sp)) {
            fprintf(stderr, "[extq] ENQUEUE src=%d mq=0x%08X msg=0x%08X%c", (int)src, (uint32_t)mq, (uint32_t)msg, 0x0A); fflush(stderr);
        }
    }
    external_messages.enqueue({mq, msg, jam, requeue_enabled[static_cast<int>(src)], src});
}

void ultramodern::enqueue_external_message(PTR(OSMesgQueue) mq, OSMesg msg, bool jam, bool requeue_if_blocked) {
    external_messages.enqueue({mq, msg, jam, requeue_if_blocked});
}

bool do_send(RDRAM_ARG PTR(OSMesgQueue) mq_, OSMesg msg, bool jam, bool block);
extern "C" bool recomp_deliver_unmodeled_event(RDRAM_ARG PTR(OSMesgQueue) mq_); // events.cpp
extern "C" uint32_t recomp_current_guest_func();  // recomp.cpp — [mqtrace] recv-caller naming
uint32_t recomp_tcb_watch();  // threads.cpp — [tcbwatch] game-thread exit-path probe (remove with the probe)

// SM64PC S45 boot#11 (engine, game-agnostic): a queue that is PERMANENTLY unsendable — a wild
// address or a corrupt msgCount, the same conditions do_send drops on — must NEVER have its
// message requeued. Requeue exists for a transiently-FULL *valid* queue (retry next pump). But a
// Timer/SP/SI/DP message (requeue_if_blocked=true) to a DEAD queue would requeue forever: the
// external-message pump live-locks (measured pump=3.1M while the real game threads starve →
// freeze; mild form = half-speed). SM64 hit this via an orphaned osEepromLongRead timer (it
// sleeps 12ms/block on a timer queue whose creator native we replaced → msgCount=0). Dropping
// the undeliverable message is correct — a dead queue can never receive it.
static bool queue_permanently_unsendable(RDRAM_ARG PTR(OSMesgQueue) mq_) {
    const uint32_t _phys = (uint32_t)mq_ & 0x1FFFFFFFu;
    if (_phys < 0x80u || _phys >= 0x800000u) {
        return true;
    }
    OSMesgQueue* mq = TO_PTR(OSMesgQueue, mq_);
    return (mq->msgCount <= 0 || mq->msgCount > 4096);
}

// [boundedrequeue 2026-09-04, War Gods] Requeue exists to cover OUR delivery delay: an interrupt
// message is produced on a host thread and only lands in the guest queue at the guest's next pump,
// so a queue that is momentarily full gets one more chance. Unbounded, that becomes a live-lock the
// moment a game never drains the queue at all — War Gods waits for RSP completion by polling
// SP_STATUS & HALT and never receives from its OS_EVENT_SP queue, so every SP-done after the first
// found it full and was retried at EVERY pump forever: MEASURED 599 SP completions, 201,487 failed
// deliveries in 30 s (RECOMP_EXTQ_TRACE), the pump spinning on one undeliverable message while the
// game crawled at 4-5 fps. Hardware never retries: libultra's ISR posts once, NOBLOCK, and a full
// queue simply loses the message (osSendMesg.c; the periodic-coalescing note above says the same).
// A guest that has passed kMaxRequeuePumps scheduling points without draining the queue is
// demonstrably not waiting on it, and hardware would have dropped the message long before. Bounded
// retry keeps the transient-full case (the reason requeue was added) and removes the live-lock.
static constexpr int kMaxRequeuePumps = 16;
static bool requeue_allowed(RDRAM_ARG QueuedMessage& m) {
    if (!m.requeue_if_blocked) return false;
    if (queue_permanently_unsendable(PASS_RDRAM m.mq)) return false;
    if (++m.retries <= kMaxRequeuePumps) return true;
    static std::atomic<uint32_t> dropped{0};
    const uint32_t n = dropped.fetch_add(1, std::memory_order_relaxed) + 1;
    if (n <= 8u || (n % 1000u) == 0u) {
        fprintf(stderr, "[mqdrop] #%u src=%d mq=0x%08X still FULL after %d pumps - dropped (hardware: an ISR send to a full queue is lost)\n",
                n, (int)m.src, (uint32_t)m.mq, kMaxRequeuePumps);
        fflush(stderr);
    }
    return false;
}

void dequeue_external_messages(RDRAM_ARG1) {
    QueuedMessage to_send;
    std::vector<QueuedMessage> requeued_messages{};
    while (external_messages.try_dequeue(to_send)) {
        note_message_left_flight(to_send);   // periodic-interrupt coalescing accounting
        if (!do_send(PASS_RDRAM to_send.mq, to_send.mesg, to_send.jam, false) && requeue_allowed(PASS_RDRAM to_send)) {
            requeued_messages.push_back(to_send);
        }
    }
    for (QueuedMessage& cur_mesg : requeued_messages) {
        note_message_requeued(cur_mesg);     // back in flight
        external_messages.enqueue(cur_mesg);
    }
}

void ultramodern::wait_for_external_message(RDRAM_ARG1) {
    QueuedMessage to_send;
    external_messages.wait_dequeue(to_send);
    note_message_left_flight(to_send);       // periodic-interrupt coalescing accounting
    {   // [extq 2026-09-02] trace completion delivery
        static const bool _tr = getenv("RECOMP_EXTQ_TRACE") != nullptr;
        if (_tr && (to_send.src == ultramodern::EventMessageSource::Dp || to_send.src == ultramodern::EventMessageSource::Sp)) {
            bool _ok = do_send(PASS_RDRAM to_send.mq, to_send.mesg, to_send.jam, false);
            fprintf(stderr, "[extq] DELIVER src=%d mq=0x%08X do_send=%d%c", (int)to_send.src, (uint32_t)to_send.mq, (int)_ok, 0x0A); fflush(stderr);
            if (!_ok && requeue_allowed(PASS_RDRAM to_send)) { note_message_requeued(to_send); external_messages.enqueue(to_send); }
            return;
        }
    }
    if (!do_send(PASS_RDRAM to_send.mq, to_send.mesg, to_send.jam, false) && requeue_allowed(PASS_RDRAM to_send)) {
        note_message_requeued(to_send);
        external_messages.enqueue(to_send);
    }
}

void ultramodern::wait_for_external_message_timed(RDRAM_ARG u32 millis) {
    QueuedMessage to_send;
    if (external_messages.wait_dequeue_timed(to_send, std::chrono::milliseconds{millis})) {
        note_message_left_flight(to_send);   // periodic-interrupt coalescing accounting
        if (!do_send(PASS_RDRAM to_send.mq, to_send.mesg, to_send.jam, false) && requeue_allowed(PASS_RDRAM to_send)) {
            note_message_requeued(to_send);
            external_messages.enqueue(to_send);
        }
    }
}

extern "C" void osCreateMesgQueue(RDRAM_ARG PTR(OSMesgQueue) mq_, PTR(OSMesg) msg, s32 count) {
    OSMesgQueue *mq = TO_PTR(OSMesgQueue, mq_);
    mq->blocked_on_recv = NULLPTR;
    mq->blocked_on_send = NULLPTR;
    // Queue re-init drops stale parked members (the guest head-field zeroing above used to do this
    // implicitly when membership lived in guest memory; host-side state needs it explicit).
    ultramodern::thread_queue_clear(PASS_RDRAM GET_MEMBER(OSMesgQueue, mq_, blocked_on_recv));
    ultramodern::thread_queue_clear(PASS_RDRAM GET_MEMBER(OSMesgQueue, mq_, blocked_on_send));
    mq->msgCount = count;
    mq->msg = msg;
    mq->validCount = 0;
    mq->first = 0;
    // A zero-capacity queue create is a general anomaly worth one line (corruption / re-create bug
    // signature). (Wave-1 purge: dropped the MKT-investigation hardcoded 0x800AC108-0x800AC9D0
    // range logging — a game-specific address baked into every game's queue-create path.)
    if (count == 0) {
        fprintf(stderr, "[mqcreate] osCreateMesgQueue mq=0x%08X count=%d\n", (uint32_t)mq_, count);
        fflush(stderr);
    }
}

s32 MQ_GET_COUNT(OSMesgQueue *mq) {
    return mq->validCount;
}

s32 MQ_IS_EMPTY(OSMesgQueue *mq) {
    return mq->validCount == 0;
}

s32 MQ_IS_FULL(OSMesgQueue* mq) {
    return MQ_GET_COUNT(mq) >= mq->msgCount;
}

// [sendwatch]/[recvwatch] full-ledger mode (env RECOMP_WATCH_FULL=1): print EVERY event on the
// watched queue, uncapped. The default cap-then-sample-1/64 mode made a 60/s retrace-notify queue
// swallow the one type-2 reply line the NC lost-wake hunt needed (three false conclusions on
// 07-02 came from sampled watches). A single watched queue at ~120 lines/s is an acceptable diag.
static bool watch_full() {
    static const bool _wf = getenv("RECOMP_WATCH_FULL") != nullptr;
    return _wf;
}

bool do_send(RDRAM_ARG PTR(OSMesgQueue) mq_, OSMesg msg, bool jam, bool block) {
    // [sendwatch] env RECOMP_SEND_WATCH=0xADDR: one line per send targeting that queue (any path —
    // guest osSendMesg/osJamMesg AND external delivery all funnel through do_send). Answers "does
    // ANYONE ever send to queue X, and what value?" — the question every lost-reply hunt ends at.
    static const uint32_t _swq = [] { const char* e = getenv("RECOMP_SEND_WATCH"); return e ? (uint32_t)strtoul(e, nullptr, 0) : 0u; }();
    const bool _sw_hit = _swq && ((uint32_t)mq_ == _swq);
    {
        static int _swn = 0;
        if (_sw_hit && (watch_full() || _swn++ < 40 || (_swn & 63) == 0)) {
            // validCount deref is safe here: the watched address is one we chose, a known-valid queue.
            fprintf(stderr, "[sendwatch] from t=%d send to mq=0x%08X msg=0x%08X jam=%d block=%d valid=%d func=0x%08X\n", (int)((ultramodern::this_thread() != NULLPTR) ? TO_PTR(OSThread, ultramodern::this_thread())->id : -1),
                    (uint32_t)mq_, (uint32_t)(uintptr_t)msg, (int)jam, (int)block,
                    (int)TO_PTR(OSMesgQueue, mq_)->validCount, recomp_current_guest_func());
            fflush(stderr);
        }
    }
    // Crash guard (RDRAM-pointer / msgCount invariant): memory corruption can hand do_send a queue whose
    // pointer or fields got scribbled (observed msgCount=0x80008000). Reject a wild queue ADDRESS and a
    // corrupt msgCount BEFORE any deref/buffer-index, so we drop the message and recover instead of crashing.
    {
        const uint32_t _phys = (uint32_t)mq_ & 0x1FFFFFFFu;
        if (_phys < 0x80u || _phys >= 0x800000u) {
            static int _bq = 0;
            // caller vram names the guest function that loaded the wild pointer (perfectdark 2026-07-16:
            // the wild value was the LOW HALF OF A HOST POINTER — an HLE seam wrote it guest-side).
            if (_bq++ < 16) { fprintf(stderr, "[mq_guard] do_send DROP wild queue mq=0x%08X func=0x%08X\n", (uint32_t)mq_, recomp_current_guest_func()); fflush(stderr); }
            return false;
        }
    }
    OSMesgQueue* mq = TO_PTR(OSMesgQueue, mq_);
    if (mq->msgCount <= 0 || mq->msgCount > 4096) {
        static int _bc = 0;
        if (_bc++ < 16) { fprintf(stderr, "[mq_guard] do_send DROP corrupt msgCount=%d mq=0x%08X\n", mq->msgCount, (uint32_t)mq_); fflush(stderr); }
        return false;
    }
    if (!block) {
        // If non-blocking, fail if the queue is full.
        if (MQ_IS_FULL(mq)) {
            // A silently rejected NOBLOCK send is the third loss mode (never-sent / eaten / DROPPED)
            // in a lost-reply hunt — without this line it is invisible to every other probe.
            if (_sw_hit) {
                fprintf(stderr, "[sendwatch] DROP-full mq=0x%08X msg=0x%08X valid=%d func=0x%08X\n",
                        (uint32_t)mq_, (uint32_t)(uintptr_t)msg, (int)mq->validCount, recomp_current_guest_func());
                fflush(stderr);
            }
            return false;
        }
    }
    else {
        // Otherwise, yield this thread until the queue has room.
        // [mqtrace] SEND-park twin of the recv trace below (env RECOMP_MQ_TRACE): a thread blocked
        // sending to a full queue is invisible to recv-only tracing — snowkids' main thread vanished
        // into exactly this blind spot. Inert unless the env is set.
        {
            static const bool _mt = getenv("RECOMP_MQ_TRACE") != nullptr;
            if (_mt && MQ_IS_FULL(mq)) {
                OSThread* _self = TO_PTR(OSThread, ultramodern::this_thread());
                fprintf(stderr, "[mqtrace] t=%d pri=%d SEND-PARK mq=0x%08X (full, msgCount=%d)\n",
                        (int)_self->id, (int)_self->priority, (uint32_t)mq_, mq->msgCount);
                fflush(stderr);
            }
        }
        while (MQ_IS_FULL(mq)) {
            debug_printf("[Message Queue] Thread %d is blocked on send\n", TO_PTR(OSThread, ultramodern::this_thread())->id);
            ultramodern::thread_queue_insert(PASS_RDRAM GET_MEMBER(OSMesgQueue, mq_, blocked_on_send), ultramodern::this_thread());
            ultramodern::run_next_thread_and_wait(PASS_RDRAM1);
        }
    }
    
    if (jam) {
        // Jams insert at the head of the message queue's buffer.
        mq->first = (mq->first + mq->msgCount - 1) % mq->msgCount;
        TO_PTR(OSMesg, mq->msg)[mq->first] = msg;
        mq->validCount++;
    }
    else {
        // Sends insert at the tail of the message queue's buffer.
        s32 last = (mq->first + mq->validCount) % mq->msgCount;
        TO_PTR(OSMesg, mq->msg)[last] = msg;
        mq->validCount++;
    }

    // If any threads were blocked on receiving from this message queue, pop the first one and schedule it.
    PTR(PTR(OSThread)) blocked_queue = GET_MEMBER(OSMesgQueue, mq_, blocked_on_recv);
    bool woke_receiver = false;
    if (!ultramodern::thread_queue_empty(PASS_RDRAM blocked_queue)) {
        PTR(OSThread) _tw_woken = ultramodern::thread_queue_pop(PASS_RDRAM blocked_queue);   // [tcbwatch] capture the popped receiver
        if (recomp_tcb_watch() && (uint32_t)_tw_woken == recomp_tcb_watch()) {
            fprintf(stderr, "[tcbwatch] (1) do_send WOKE watched thread 0x%08X off blocked_on_recv mq=0x%08X valid=%d\n",
                    (uint32_t)_tw_woken, (uint32_t)mq_, (int)mq->validCount); fflush(stderr);
        }
        ultramodern::schedule_running_thread(PASS_RDRAM _tw_woken);
        woke_receiver = true;
    }

    // (Wave-1 purge: removed the [mqsend] throwaway trace — a std::map lookup on EVERY send of
    // EVERY game for a concluded MKT investigation. The per-send hot path is now trace-free.)
    (void)woke_receiver;

    return true;
}

bool do_recv(RDRAM_ARG PTR(OSMesgQueue) mq_, PTR(OSMesg) msg_, bool block) {
    // Crash guard (RDRAM-pointer / msgCount invariant): same as do_send — reject a wild queue / corrupt
    // msgCount before the buffer index (mq->msg[first], % msgCount) so corruption can't crash the recv path.
    {
        const uint32_t _phys = (uint32_t)mq_ & 0x1FFFFFFFu;
        if (_phys < 0x80u || _phys >= 0x800000u) {
            static int _bq = 0;
            if (_bq++ < 16) { fprintf(stderr, "[mq_guard] do_recv DROP wild queue mq=0x%08X func=0x%08X\n", (uint32_t)mq_, recomp_current_guest_func()); fflush(stderr); }
            return false;
        }
    }
    OSMesgQueue* mq = TO_PTR(OSMesgQueue, mq_);
    if (mq->msgCount <= 0 || mq->msgCount > 4096) {
        static int _bc = 0;
        if (_bc++ < 16) { fprintf(stderr, "[mq_guard] do_recv DROP corrupt msgCount=%d mq=0x%08X\n", mq->msgCount, (uint32_t)mq_); fflush(stderr); }
        return false;
    }
    if (!block) {
        // If non-blocking, fail if the queue is empty
        if (MQ_IS_EMPTY(mq)) {
            return false;
        }
    } else {
        // Otherwise, yield this thread in a loop until the queue is no longer full.
        // (cont.19: stripped the per-recv [mq] blocking/unblocked logging — it was ~257k fflush'd
        //  lines/run (58% of the diag log), a major frame-rate drain that choked the boss fight;
        //  the scheduler deadlock it diagnosed is long fixed.)
        // (Wave-1 purge: removed the [recvblock] throwaway trace — per-empty-recv std::set work for
        // concluded Robotron/PD investigations. The wait-chain question is answerable via
        // RECOMP_TRACE_MQ below when it recurs.)
        if (MQ_IS_EMPTY(mq)) {
            // [trace] dump THIS thread's recompiled call stack when it parks on the queue named by
            // env RECOMP_TRACE_MQ — reveals the exact path into a stall. No-op unless the env is set
            // AND the game was recompiled with trace_mode. Capped at 4 dumps.
            {
                static const uint32_t _tmq = []{ const char* e = getenv("RECOMP_TRACE_MQ"); return e ? (uint32_t)strtoul(e, nullptr, 0) : 0u; }();
                static int _td = 0;
                if (_tmq && ((uint32_t)(uintptr_t)mq_ & 0xFFFFFFFFu) == _tmq && _td < 4) {
                    _td++;
                    recomp_trace_dump("thread parking on RECOMP_TRACE_MQ");
                }
            }
            // GENERAL: if this queue is a registered-but-UNMODELED hardware event (RDB/RAMROM/custom,
            // ev>=15) the engine has no producer for, deliver it — the real hardware would fire it, so a
            // thread waiting here would otherwise hang forever (Nightmare Creatures' OS_EVENT_18). The
            // async pump fills the queue and wakes us below. No-op for standard games (they never
            // register/wait on ev>=15) and for modeled events (SP/SI/AI/VI/PI/DP have real producers).
            recomp_deliver_unmodeled_event(PASS_RDRAM mq_);
        }
        // [mqtrace] env RECOMP_MQ_TRACE: one line per blocking park (thread id/pri + queue) — names
        // where each thread waits during a boot-order investigation. Inert unless the env is set.
        // func= names the guest function containing this recv (last per-thread EMIT_WATCH mark;
        // 0 on builds without marks) — the "which wait loop is this" question in one boot.
        {
            static const bool _mt = getenv("RECOMP_MQ_TRACE") != nullptr;
            if (_mt && MQ_IS_EMPTY(mq)) {
                OSThread* _self = TO_PTR(OSThread, ultramodern::this_thread());
                fprintf(stderr, "[mqtrace] t=%d pri=%d RECV-PARK mq=0x%08X func=0x%08X\n",
                        (int)_self->id, (int)_self->priority, (uint32_t)mq_, recomp_current_guest_func());
                fflush(stderr);
            }
        }
        while (MQ_IS_EMPTY(mq)) {
            ultramodern::thread_queue_insert(PASS_RDRAM GET_MEMBER(OSMesgQueue, mq_, blocked_on_recv), ultramodern::this_thread());
            ultramodern::run_next_thread_and_wait(PASS_RDRAM1);
        }
    }

    // [recvwatch] env RECOMP_RECV_WATCH=0xADDR: one line per CONSUME from that queue — the msg value
    // eaten + the guest function that ate it. sendwatch alone cannot distinguish "reply sent then
    // eaten by transition code" from "reply sent and still in the ring": the consume side is the
    // other half of the queue ledger. Honors RECOMP_WATCH_FULL like sendwatch.
    static const uint32_t _rwq = [] { const char* e = getenv("RECOMP_RECV_WATCH"); return e ? (uint32_t)strtoul(e, nullptr, 0) : 0u; }();
    bool _rw_hit;
    {
        static int _rwn = 0;
        _rw_hit = _rwq && ((uint32_t)mq_ == _rwq) && (watch_full() || _rwn++ < 40 || (_rwn & 63) == 0);
    }
    OSMesg _rw_msg = _rw_hit ? TO_PTR(OSMesg, mq->msg)[mq->first] : (OSMesg)0;

    if (msg_ != NULLPTR) {
        *TO_PTR(OSMesg, msg_) = TO_PTR(OSMesg, mq->msg)[mq->first];
    }

    mq->first = (mq->first + 1) % mq->msgCount;
    mq->validCount--;
    if (_rw_hit) {
        fprintf(stderr, "[recvwatch] recv mq=0x%08X msg=0x%08X valid=%d func=0x%08X\n",
                (uint32_t)mq_, (uint32_t)(uintptr_t)_rw_msg, (int)mq->validCount, recomp_current_guest_func());
        fflush(stderr);
    }
    // (Wave-1 purge: removed the [recvwake] throwaway trace — per-recv std::map work, concluded
    // MKT investigation.)

    // If any threads were blocked on sending to this message queue, pop the first one and schedule it.
    PTR(PTR(OSThread)) blocked_queue = GET_MEMBER(OSMesgQueue, mq_, blocked_on_send);
    if (!ultramodern::thread_queue_empty(PASS_RDRAM blocked_queue)) {
        ultramodern::schedule_running_thread(PASS_RDRAM ultramodern::thread_queue_pop(PASS_RDRAM blocked_queue));
    }

    return true;
}

extern "C" s32 osSendMesg(RDRAM_ARG PTR(OSMesgQueue) mq_, OSMesg msg, s32 flags) {
    OSMesgQueue *mq = TO_PTR(OSMesgQueue, mq_);
    bool jam = false;
    
    // Don't directly send to the message queue if this isn't a game thread to avoid contention.
    if (!ultramodern::is_game_thread()) {
        ultramodern::enqueue_external_message(mq_, msg, jam, false);
        return 0;
    }
    
    // Handle any messages that have been received from an external thread.
    dequeue_external_messages(PASS_RDRAM1);

    // Try to send the message.
    bool sent = do_send(PASS_RDRAM mq_, msg, jam, flags == OS_MESG_BLOCK);
    
    // Check the queue to see if this thread should swap execution to another.
    ultramodern::check_running_queue(PASS_RDRAM1);

    return sent ? 0 : -1;
}

extern "C" s32 osJamMesg(RDRAM_ARG PTR(OSMesgQueue) mq_, OSMesg msg, s32 flags) {
    OSMesgQueue *mq = TO_PTR(OSMesgQueue, mq_);
    bool jam = true;
    
    // Don't directly send to the message queue if this isn't a game thread to avoid contention.
    if (!ultramodern::is_game_thread()) {
        ultramodern::enqueue_external_message(mq_, msg, jam, false);
        return 0;
    }
    
    // Handle any messages that have been received from an external thread.
    dequeue_external_messages(PASS_RDRAM1);

    // Try to send the message.
    bool sent = do_send(PASS_RDRAM mq_, msg, jam, flags == OS_MESG_BLOCK);
    
    // Check the queue to see if this thread should swap execution to another.
    ultramodern::check_running_queue(PASS_RDRAM1);

    return sent ? 0 : -1;
}

extern "C" s32 osRecvMesg(RDRAM_ARG PTR(OSMesgQueue) mq_, PTR(OSMesg) msg_, s32 flags) {
    OSMesgQueue *mq = TO_PTR(OSMesgQueue, mq_);
    
    assert(ultramodern::is_game_thread() && "RecvMesg not allowed outside of game threads.");
    
    // Handle any messages that have been received from an external thread.
    dequeue_external_messages(PASS_RDRAM1);

    // Try to receive a message.
    bool received = do_recv(PASS_RDRAM mq_, msg_, flags == OS_MESG_BLOCK);
    
    // Check the queue to see if this thread should swap execution to another.
    ultramodern::check_running_queue(PASS_RDRAM1);

    return received ? 0 : -1;
}
