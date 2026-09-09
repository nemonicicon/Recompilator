#include <thread>
#include <atomic>
#include <chrono>
#include <cinttypes>
#include <variant>
#include <unordered_map>
#include <utility>
#include <mutex>
#include <queue>
#include <cstring>
#include <cstdlib>   // cv64 S41: getenv for the authentic-timing gate
#include <cstdio>
#include <condition_variable>   // cv64 S41: the RDP timer thread
#include <deque>                // DP-completion pacer deadline queue (2026-07-19)
#include <optional>   // S45 de-flavor: per-game cutscene-gate phys addr (timing layer config)

#include "blockingconcurrentqueue.h"

#include "ultramodern/ultra64.h"
#include "ultramodern/ultramodern.hpp"
#include "ultramodern/extensions.h"

#include "ultramodern/rsp.hpp"
#include "ultramodern/renderer_context.hpp"

// cv64 cont.38: presented frames-per-second, published once/sec for the on-screen window-title FPS
// counter. Read by update_gfx() in main.cpp (on the main/window thread) → SDL_SetWindowTitle.
std::atomic<double> g_cv64_present_fps{ 0.0 };

// cv64 S41 timing layer: per-DL estimated real-RDP cycles, accumulated by rt64 (rt64_rsp.cpp / rt64_rdp.cpp)
// during interpretation; reset + consumed by the gfx task path below. Resolved at the final exe link.
extern "C" double g_rdp_estimated_cost_cycles;
// TIMING_FIDELITY_DESIGN P1 — v2 counting accumulators (defined in rt64_rsp.cpp; log-only).
extern "C" double g_rdptime2_pix[4];
extern "C" double g_rdptime2_lines;
extern "C" double g_rdptime2_setup;
extern "C" unsigned long long g_rdptime2_prims;
// cv64 S41 v5: rdram base (librecomp recomp.cpp) — read the game's cutscene state for the timing gate.
extern "C" uint8_t* g_rdram_base;

// S45 DE-FLAVOR: the cutscene-gate physical address is now a PER-GAME CONFIG FIELD, not a buried
// constant. The app (e.g. cv64pc/src/main.cpp) sets it to the address of its own cutscene-state word;
// if it is left unset (std::nullopt — every game but cv64), the hardware-timing layer is disabled for
// that game, so the gate can never read garbage out of another game's RAM (the SM64-boot-misfire class).
// The global CV64_AUTHENTIC_TIMING env var remains the master switch. Same extern-"C" bridge pattern as
// g_rdram_base (defined in the consumer, set by the producer); no shared header touched.
std::optional<uint32_t> g_cutscene_gate_phys_addr = std::nullopt;

// [rcp-floor 2026-08-27, MEASURED — see dossier_sote 08-27 ~14:00 and the FIX DESIGN note there]
// The RCP completion floors below exist because a kernel that latches a completion ONLY when its
// arm flag is already set will DISCARD an early one and then wait on it forever. SOTE's unattended
// boot is that case: at the shipped 1000/1500 it hangs 15s in (100% CPU, intro never starts);
// 3000/4500 is the minimum that boots; 4000/6000 boots with margin.
// DO NOT simply raise these defaults, and do not make them per-game (08-27: per-game
// fixes rot). MEASURED CLEAN (serial, 2 passes, nothing else on the bench): at 4000/6000 SPACE
// INVADERS drops 60fps -> 31fps, because 4ms SP + 6ms DP is 10ms of forced latency per task and a
// game that serialises on completions is capped by it. A fixed floor cannot serve both.
// THE FIX IS ADAPTIVE: the floor's only job is to not deliver BEFORE the guest arms, so deliver
// EARLY the moment the guest is demonstrably already waiting (its registered event queue has a
// blocked receiver / its arm flag is set), and fall back to the floor otherwise. Fast games then
// pay nothing and SOTE still gets its delay. Unbuilt — needs the gate.
static ultramodern::events::callbacks_t events_callbacks{};

void ultramodern::events::set_callbacks(const ultramodern::events::callbacks_t& callbacks) {
    events_callbacks = callbacks;
}

// ONE SERIAL RSP — completions in start order (NC RUN 28, hardware faithfulness).
// The engine completed gfx tasks INSTANTLY (gfx thread) but audio tasks ~1ms PACED (task thread):
// two completion clocks racing one piece of game state. Real hardware has ONE RSP; SP-done arrives
// only for the task the RSP is actually busy with, strictly in start order. Schedulers depend on
// that: libultra-style __scMain does a read-and-clear of sc->curRSPTask on every RSP-done with no
// null guard — an out-of-order or extra completion consumes the slot and orphans the real task's
// done-reply (Nightmare Creatures: its audio task's reply to the audio thread never sent -> audio
// dead -> the credits screen waited forever on the music). Rule restored here: every submission
// takes a ticket, in submission order; every completion waits its turn, emulates its RSP-busy
// window, fires sp_complete(), then releases the next.
void sp_complete();
// RDP-parallel console mode (RDPC_LLE_CONSOLE): the renderer completes DP itself when its
// render thread ACTUALLY finishes drawing (hardware-true DP-done; the inline dp_complete
// below would fire before the RDP work is done). Set by the console renderer at startup.
extern "C" int g_dp_deferred_by_renderer = 0;
static std::mutex rsp_order_mutex;
static std::condition_variable rsp_order_cv;
static uint64_t rsp_ticket_head = 0;   // next ticket to issue (at submission)
static uint64_t rsp_ticket_done = 0;   // completions delivered so far
// [rspwatch] host-side state for the 1 Hz truth line: how many gfx completions the RCP pacer is
// still holding, and whether the gfx action thread is inside RT64's send_dl right now. A guest that
// spins natively on SP_STATUS & HALT is waiting on exactly these (War Gods 2026-09-04).
static std::atomic<size_t> g_pacer_pending{0};
static std::atomic<int> g_gfx_in_send_dl{0};
extern "C" uint32_t recomp_sp_status_peek();
extern "C" void recomp_task_counts(uint32_t* submitted, uint32_t* completed);

static uint64_t rsp_issue_ticket() {
    std::lock_guard<std::mutex> lk(rsp_order_mutex);
    return rsp_ticket_head++;
}

extern std::atomic_bool exited;   // shutdown escape: an abandoned in-flight ticket must not hang the join
// RECOMP_SERIAL_RSP=0 disables the in-order completion wait (default ON = the NC fix). DK64
// boot-regression hunt (2026-07-12): the cross-thread ticket ordering (gfx thread vs task thread)
// may deadlock DK64's audio/gfx interleave -> game thread hangs after 2 frames. Test the bypass.
static bool serial_rsp_enabled() {
    static const bool on = [] {
        const char* e = std::getenv("RECOMP_SERIAL_RSP");
        bool v = (e == nullptr || e[0] != '0');
        fprintf(stderr, "[serialrsp] in-order RSP completions %s (RECOMP_SERIAL_RSP)\n", v ? "ON" : "OFF");
        fflush(stderr);
        return v;
    }();
    return on;
}
static void rsp_complete_in_order(uint64_t ticket, long long busy_us) {
    if (serial_rsp_enabled()) {
        std::unique_lock<std::mutex> lk(rsp_order_mutex);
        // Poll-wait (100µs) instead of a pure cv wait so process exit (which abandons any ticket a
        // joined thread never completed) always unblocks a waiter without needing a notify-at-exit.
        while (rsp_ticket_done != ticket) {
            if (exited) return;   // quitting: completions are moot
            rsp_order_cv.wait_for(lk, std::chrono::microseconds(100));
        }
    }
    // Emulate the RSP-busy interval (see the RECOMP_SP_TASK_US rationale in task_thread_func):
    // coarse sleep for a long bulk, yield-spin the tail — Win32 Sleep granularity can be >=15ms.
    if (busy_us > 0) {
        auto deadline = std::chrono::high_resolution_clock::now() + std::chrono::microseconds(busy_us);
        while (std::chrono::high_resolution_clock::now() < deadline) {
            if (deadline - std::chrono::high_resolution_clock::now() > std::chrono::milliseconds(3)) {
                ultramodern::sleep_milliseconds(1);
            } else {
                std::this_thread::yield();
            }
        }
    }
    sp_complete();
    {
        std::lock_guard<std::mutex> lk(rsp_order_mutex);
        rsp_ticket_done++;
    }
    rsp_order_cv.notify_all();
}

struct SpTaskAction {
    OSTask task;
    uint64_t rsp_ticket;
};

// Non-gfx (audio/general) RSP task queue entry — descriptor BY VALUE (see sp_task_queue note).
struct SpQueueEntry {
    OSTask task;
    uint64_t ticket;
    bool shutdown;
};

struct ScreenUpdateAction {
    ultramodern::renderer::ViRegs regs;
};

struct UpdateConfigAction {
};

using Action = std::variant<SpTaskAction, ScreenUpdateAction, UpdateConfigAction>;

struct ViState {
    const OSViMode* mode;
    PTR(void) framebuffer;
    PTR(OSMesg) mq;
    OSMesg msg;
    uint32_t state;
    uint32_t control;
    int retrace_count = 1;
};

#define VI_STATE_BLACK 0x20
#define VI_STATE_REPEATLINE 0x40

static struct {
    struct {
        std::thread thread;
        int cur_state;
        int field;
        // osViSetXScale/osViSetYScale factor (1.0 = use the mode's comRegs scale; <1.0 = the game asked
        // the VI to scan a sub-region of the framebuffer stretched to fill the active area, e.g. Lode
        // Runner 3D's osViSetXScale(0.5) = render 320-wide into a 640 fb, VI stretches the left 320 to 640).
        float xScaleFactor = 1.0f;
        float yScaleFactor = 1.0f;
        ViState states[2];
        ultramodern::renderer::ViRegs regs;
        ultramodern::renderer::ViRegs update_screen_regs;

        ViState* get_next_state() {
            return &states[cur_state ^ 1];
        }
        ViState* get_cur_state() {
            return &states[cur_state];
        }
        void update_vi() {
            ViState* next_state = get_next_state();
            const OSViMode* next_mode = next_state->mode;
            const OSViCommonRegs* common_regs = &next_mode->comRegs;
            const OSViFieldRegs* field_regs = &next_mode->fldRegs[field];
            PTR(void) framebuffer = osVirtualToPhysical(next_state->framebuffer);
            // Bare-metal raw VI class (SOTE 2026-07-18): a game that writes VI_ORIGIN directly
            // supplies the PHYSICAL scanout address (hardware semantics) — osVirtualToPhysical
            // is for the KSEG0/KSEG1 pointers libultra's osViSwapBuffer receives. The TLB probe
            // on an already-physical sub-8MB value MISSES and returns -1, poisoning the origin
            // (SOTE fb=0x00300000 -> ORIGIN=0x27F -> RT64 scans nothing -> black). If the probe
            // failed but the raw value is a plausible physical RDRAM address, take it as-is.
            if ((uint32_t)framebuffer >= 0x00800000u && (uint32_t)next_state->framebuffer < 0x00800000u) {
                framebuffer = next_state->framebuffer;
            }
            // [fb-content 2026-08-26] SOTE dig: is the presented fb actually DRAWN?
            // Every ~64th update dump the first 8 words at the resolved framebuffer address.
            // ALL-ZERO = the game never rendered here (RSP/RDP tasks are not writing pixels).
            // NON-ZERO = pixels exist and RT64 is not presenting them. The [vibuf] 'garbage'
            // warning is a false positive - it uses a naive KSEG0-only check, but the runtime
            // handles SOTE's raw-physical fb 15 lines below this via the '< 0x00800000' guard.
            {
                static long _fbn = 0;
                if ((++_fbn & 0x3F) == 0) {
                    uint32_t phys = (uint32_t)framebuffer;
                    if (phys < 0x00800000u) {
                        const uint32_t* px = (const uint32_t*)(events_context.rdram + phys);
                        uint32_t nz = 0;
                        for (int i = 0; i < 8; ++i) if (px[i]) ++nz;
                        fprintf(stderr, "[fb-content] #%ld phys=0x%06X nonzero=%u/8 first=[%08X %08X %08X %08X]\n",
                                _fbn, phys, nz, px[0], px[1], px[2], px[3]);
                        fflush(stderr);
                    }
                }
            }
            PTR(void) origin = framebuffer + field_regs->origin;

            // Process the VI state flags.
            uint32_t hStart = common_regs->hStart;
            if (next_state->state & VI_STATE_BLACK) {
                hStart = 0;
            }

            uint32_t yScale = field_regs->yScale;
            if (next_state->state & VI_STATE_REPEATLINE) {
                yScale = 0;
                origin = framebuffer;
            }

            // TODO implement osViFade

            // Update VI registers.
            regs.VI_ORIGIN_REG = origin;
            regs.VI_WIDTH_REG = common_regs->width;
            regs.VI_TIMING_REG = common_regs->burst;
            regs.VI_V_SYNC_REG = common_regs->vSync;
            regs.VI_H_SYNC_REG = common_regs->hSync;
            regs.VI_LEAP_REG = common_regs->leap;
            regs.VI_H_START_REG = hStart;
            regs.VI_V_START_REG = field_regs->vStart; // TODO implement osViExtendVStart
            regs.VI_V_BURST_REG = field_regs->vBurst;
            regs.VI_INTR_REG = field_regs->vIntr;
            // NOTE: osViSetXScale/YScale must NOT be folded into VI_X_SCALE_REG here — RT64's
            // deinterlacedWidth() infers the 480i doubled-stride from xScale, so a half-res scale value
            // makes it mis-size the framebuffer and fbAddress() scans a never-drawn buffer -> black screen
            // (verified on Lode Runner 3D). The half-res factor is carried separately (xScaleFactor /
            // yScaleFactor) and applied in RT64's PRESENT, not the VI register. Keep the mode value here.
            regs.VI_X_SCALE_REG = common_regs->xScale;
            regs.VI_Y_SCALE_REG = yScale;
            // Carry the osViSetXScale/YScale half-res factor on the separate channel (see note above).
            regs.xScaleFactor = xScaleFactor;
            regs.yScaleFactor = yScaleFactor;
            regs.VI_STATUS_REG = next_state->control;
            
            // Swap VI states.
            cur_state ^= 1;
            *get_next_state() = *get_cur_state();
        }
    } vi;
    struct {
        std::thread gfx_thread;
        std::thread task_thread;
        PTR(OSMesgQueue) mq = NULLPTR;
        OSMesg msg = (OSMesg)0;
    } sp;
    struct {
        PTR(OSMesgQueue) mq = NULLPTR;
        OSMesg msg = (OSMesg)0;
    } dp;
    struct {
        PTR(OSMesgQueue) mq = NULLPTR;
        OSMesg msg = (OSMesg)0;
    } ai;
    struct {
        PTR(OSMesgQueue) mq = NULLPTR;
        OSMesg msg = (OSMesg)0;
    } si;
    struct {
        PTR(OSMesgQueue) mq = NULLPTR;
        OSMesg msg = (OSMesg)0;
    } pi;
    // General registry of EVERY osSetEventMesg registration (event_id 0..23 -> queue+msg). Lets us
    // deliver UNMODELED hardware events (the RDB/RAMROM/custom range, event_id>=15) to a thread that
    // would otherwise hang forever on them — the real hardware fires these; the engine has no producer.
    // Surfaced by bare-metal/PSX ports (Nightmare Creatures' main thread waits on OS_EVENT_18).
    struct { PTR(OSMesgQueue) mq = NULLPTR; OSMesg msg = (OSMesg)0; } event_regs[24];
    // The same message queue may be used for multiple events, so share a mutex for all of them
    std::mutex message_mutex;
    uint8_t* rdram;
    moodycamel::BlockingConcurrentQueue<Action> action_queue{};
    // Non-gfx RSP tasks + their serial-RSP completion tickets. The OSTask is carried BY VALUE:
    // on hardware, osSpTaskLoad DMAs the 64-byte descriptor into DMEM at task start, so games
    // (SM64's alternating audio task slots) freely rebuild the struct right after StartGo. A
    // pointer dereferenced later on this thread reads a half-rewritten descriptor whenever the
    // task thread lags (the under-load "image as audio" Peach corruption, 2026-07-12) — the
    // gfx path (SpTaskAction) always snapshotted; audio now gets the same hardware semantics.
    moodycamel::BlockingConcurrentQueue<SpQueueEntry> sp_task_queue{};
    moodycamel::ConcurrentQueue<OSThread*> deleted_threads{};
} events_context{};

ultramodern::renderer::ViRegs* ultramodern::renderer::get_vi_regs() {
    return &events_context.vi.update_screen_regs;
}

extern "C" void osSetEventMesg(RDRAM_ARG OSEvent event_id, PTR(OSMesgQueue) mq_, OSMesg msg) {
    std::lock_guard lock{ events_context.message_mutex };

    // Record EVERY registration in the general table (for unmodeled-event delivery, see
    // recomp_deliver_unmodeled_event). The switch below additionally wires the modeled hardware events.
    if ((unsigned)event_id < 24) {
        events_context.event_regs[event_id].mq = mq_;
        events_context.event_regs[event_id].msg = msg;
    }

    switch (event_id) {
        case OS_EVENT_SP:
            fprintf(stderr, "[sp] osSetEventMesg: OS_EVENT_SP mq=0x%08X msg=%p\n",
                    (uint32_t)mq_, msg);
            fflush(stderr);
            events_context.sp.msg = msg;
            events_context.sp.mq = mq_;
            break;
        case OS_EVENT_DP:
            fprintf(stderr, "[evtreg] OS_EVENT_DP  mq=0x%08X\n", (uint32_t)mq_); fflush(stderr);
            events_context.dp.msg = msg;
            events_context.dp.mq = mq_;
            break;
        case OS_EVENT_AI:
            fprintf(stderr, "[evtreg] OS_EVENT_AI  mq=0x%08X\n", (uint32_t)mq_); fflush(stderr);
            events_context.ai.msg = msg;
            events_context.ai.mq = mq_;
            break;
        case OS_EVENT_SI:
            fprintf(stderr, "[evtreg] OS_EVENT_SI  mq=0x%08X\n", (uint32_t)mq_); fflush(stderr);
            events_context.si.msg = msg;
            events_context.si.mq = mq_;
            break;
        case OS_EVENT_PI:
            // PI (cartridge DMA) done interrupt. Bare-metal ports (and any libultra PI manager) wait
            // on this queue for a cart→RDRAM DMA to finish. Our PI device (librecomp/pi.cpp) does the
            // DMA synchronously then calls send_pi_message() to fire here. Without this the game's
            // asset-load wait never unblocks → it renders only its init frame → black. (General
            // "fix the N64": PI-done is standard hardware; requeue_pi is already false, a one-shot.)
            fprintf(stderr, "[evtreg] OS_EVENT_PI  mq=0x%08X\n", (uint32_t)mq_); fflush(stderr);
            events_context.pi.msg = msg;
            events_context.pi.mq = mq_;
            break;
        case OS_EVENT_VI: {
            // Bare-metal ports register the VI retrace event via the LOW-LEVEL osSetEventMesg
            // (no retrace-count arg) rather than osViSetEvent. Register the same VI-state queue
            // osViSetEvent uses so the retrace loop delivers messages here; leave retrace_count at
            // its default (1 = every retrace). (General bare-metal-port fix — without this the VI
            // queue stays NULL and the game's frame thread blocks forever.)
            fprintf(stderr, "[evtreg] OS_EVENT_VI  mq=0x%08X — registering VI retrace queue\n", (uint32_t)mq_); fflush(stderr);
            events_context.vi.get_next_state()->mq = mq_;
            events_context.vi.get_next_state()->msg = msg;
            break;
        }
        default:
            fprintf(stderr, "[evtreg] OS_EVENT_%d (unhandled by runtime) mq=0x%08X\n", (int)event_id, (uint32_t)mq_); fflush(stderr);
    }
}

// Deliver an UNMODELED registered hardware event whose queue a thread is about to block on forever.
// Only the high RDB/RAMROM/custom range (event_id>=15) — the modeled events (SP/SI/AI/VI/PI/DP) have
// real producers, and the low system events (SW/CART/COUNTER/PRENMI etc.) are left alone to avoid
// disturbing timer/scheduler timing in normal games. Bare-metal/PSX ports (Nightmare Creatures) drive
// these via their own __osException which we replaced with HLE, so a thread waiting on event 18/19
// hangs; the hardware would have fired it. Returns true if a message was queued for mq_. Capped to
// avoid runaway if a thread idles on one of these. General fix; standard games never wait on ev>=15.
extern "C" bool recomp_deliver_unmodeled_event(uint8_t* rdram, PTR(OSMesgQueue) mq_) {
    if (mq_ == NULLPTR) return false;
    // [SF64-ORACLE-20260824] DEFAULT FLIPPED TO OFF — the founding assumption ("standard games
    // never wait on ev>=15") is FALSIFIED: 2.0L+ libultra retail carts ship Nintendo's RDB
    // debugger thread (pri 149) parked on ev 18/19. Real hardware never fires those on retail;
    // this courtesy fed sf64 1.1's RDB thread 4000 wake-cycles at pri 149 through the boot
    // window and the game-side threads never started (desktop A/B, same exe: courtesy ON =
    // 0 flips / 0 PI ever; OFF = 30 fps, cart streaming). Nightmare Creatures — the motivating
    // case — carries its own delivery lane (nc_putenv NC_IRQ in its main.cpp). Set
    // RECOMP_UNMODELED_EVT=1 to re-enable for bring-up discovery of an NC-class port.
    {
        static const bool _on = [] { const char* e = std::getenv("RECOMP_UNMODELED_EVT"); return e && e[0] == '1'; }();
        if (!_on) return false;
    }
    static std::atomic<int> delivered_total{0};
    if (delivered_total.load() > 4000) return false; // safety cap
    for (int ev = 15; ev < 24; ev++) {
        if (events_context.event_regs[ev].mq == mq_) {
            int n = delivered_total.fetch_add(1);
            if (n < 30) { fprintf(stderr, "[evtunmodeled] deliver OS_EVENT_%d -> mq=0x%08X msg=0x%08X\n",
                                  ev, (uint32_t)mq_, (uint32_t)(uintptr_t)events_context.event_regs[ev].msg); fflush(stderr); }
            ultramodern::enqueue_external_message(mq_, events_context.event_regs[ev].msg, false, false);
            return true;
        }
    }
    return false;
}

extern "C" void osViSetEvent(RDRAM_ARG PTR(OSMesgQueue) mq_, OSMesg msg, u32 retrace_count) {
    static uint32_t viset_count = 0;
    uint32_t n = viset_count++;
    fprintf(stderr, "[vi] osViSetEvent #%u: mq=0x%08X msg=0x%08X retrace=%u\n",
            n, (uint32_t)mq_, (uint32_t)(uintptr_t)msg, retrace_count);
    fflush(stderr);
    std::lock_guard lock{ events_context.message_mutex };
    ViState* next_state = events_context.vi.get_next_state();
    next_state->mq = mq_;
    next_state->msg = msg;
    next_state->retrace_count = retrace_count;
}

uint64_t total_vis = 0;

extern std::atomic_bool exited;
extern moodycamel::LightweightSemaphore graphics_shutdown_ready;

void set_dummy_vi(bool odd);

// RAW-INTERRUPT-DELIVERY (librecomp/mmio.cpp): invoke the game's own exception handler on an RCP IRQ.
// No-op unless the NC_IRQ env (handler vram) is set — HLE titles untouched.
extern "C" void recomp_deliver_rcp_interrupt(uint8_t* rdram, uint32_t mi_bits, int hle_serving);
// Retrace-cached "is the HLE VI path serving this game" flag, consumed by the bare-metal auto-arm
// (baremetal_sched.cpp try_autoarm) — a matched title must never auto-arm the fiber scheduler.
static std::atomic<int> g_hle_vi_registered{0};
extern "C" int recomp_hle_vi_registered() { return g_hle_vi_registered.load(std::memory_order_relaxed); }
// Bare-metal (NC class) — declared here so vi_thread_func (below) can hand NC's VI queue to the game-thread
// idle for ring delivery + wait-list wake. (Re-declared near sp_complete; identical signatures.)
extern "C" int  recomp_baremetal_enabled();
extern "C" int  recomp_baremetal_nc_mode();
// [lane-1 gate 08-27, LANE_UNIFICATION_PLAN.md step 1] The HLE event-queue enqueues are one of
// SIX delivery lanes; for an ARMED non-NC bare-metal game they double-deliver alongside the MI
// level-bit lane (the guest's own handler posts its own messages) — every 08-27 freeze corpse
// was two lanes disagreeing. Armed non-NC games skip the HLE lane; HLE titles (never armed) and
// the NC legacy class (mixed lanes, proven) are byte-identical.
static inline bool hle_event_lane_on() { return !recomp_baremetal_enabled() || recomp_baremetal_nc_mode(); }
extern "C" void recomp_baremetal_note_vi_mq(uint32_t mq, uint32_t msg);
extern "C" uint32_t recomp_interp_pc_shared(void);   // [gt-pulse] cross-thread interp pc mirror
extern "C" void recomp_bm_peek_regs(uint32_t* out4);  // [gt-pulse] racy reg peek
extern "C" void recomp_bm_pump_state(uint64_t* idle_entries, int* pending);  // [pump-pulse]
extern "C" uint32_t recomp_baremetal_noted_mi(void);   // [spin-watch] accumulated MI level bits
extern "C" uint64_t recomp_ghost_stale_fetches(void);  // [ghoststale] executed fetches where ghost != live
extern "C" uint64_t recomp_ghost_total_fetches(void);  // [ghoststale] executed ghost-range fetches (denominator)
extern "C" uint64_t recomp_guest_instr(void);           // [guest-clock probe] interpreted instructions retired
extern "C" uint64_t recomp_guest_sessions(void);        // [guest-clock probe] interpreter session churn
extern "C" uint64_t recomp_bm_idle_census(int i);       // [idle-census] why interrupts do not reach the guest
extern "C" uint64_t recomp_bm_eret_census(int i);       // [eret-census] dispatch outcomes + split-brain count
extern "C" uint64_t recomp_gap_tail(int i);             // [gap-tail] interp vs no-op
extern "C" uint64_t recomp_bm_sample_rip(void);  // [rip-sample] frozen-cycle namer
extern "C" void recomp_bm_dump_wedge(void);      // [wedge-dump] park-ring + fiber states at FROZEN
// hog-sampler (NC RUN 24): 60Hz last-marked-guest-func print so a scheduler-starving hog thread names
// itself in one boot. Needs a RECOMP_EMIT_WATCH recomp + runtime RECOMP_HOG_SAMPLE; inert otherwise.
extern "C" int  recomp_hog_sampler_active();
extern "C" uint64_t recomp_hog_sample(uint64_t* marks);
extern "C" void recomp_hog_chain_dump();   // env RECOMP_HOG_CHAIN pointer-chain walk (inert unless set)
extern "C" uint64_t recomp_mark_watch_hits(uint32_t* vram);   // env RECOMP_MARK_WATCH single-func entry counter

extern "C" int  recomp_baremetal_enabled();
extern "C" void recomp_baremetal_note_interrupt(uint32_t mi_bits);

void vi_thread_func() {
    ultramodern::set_native_thread_name("VI Thread");
    // This thread should be prioritized over every other thread in the application, as it's what allows
    // the game to generate new audio and gfx lists.
    ultramodern::set_native_thread_priority(ultramodern::ThreadPriority::Critical);
    using namespace std::chrono_literals;

    int remaining_retraces = 1;

    while (!exited) {
        // Determine the next VI time (more accurate than adding 16ms each VI interrupt)
        auto next = ultramodern::get_start() + (total_vis * 1000000us) / (60 * ultramodern::get_speed_multiplier());
        //if (next > std::chrono::high_resolution_clock::now()) {
        //    printf("Sleeping for %" PRIu64 " us to get from %" PRIu64 " us to %" PRIu64 " us \n",
        //        (next - std::chrono::high_resolution_clock::now()) / 1us,
        //        (std::chrono::high_resolution_clock::now() - events_context.start) / 1us,
        //        (next - events_context.start) / 1us);
        //} else {
        //    printf("No need to sleep\n");
        //}
        // Detect if there's more than a second to wait and wait a fixed amount instead for the next VI if so, as that usually means the system clock went back in time.
        if (std::chrono::floor<std::chrono::seconds>(next - std::chrono::high_resolution_clock::now()) > 1s) {
            // printf("Skipping the next VI wait\n");
            next = std::chrono::high_resolution_clock::now();
        }
        ultramodern::sleep_until(next);
        auto time_now = ultramodern::time_since_start();
        // Calculate how many VIs have passed
        uint64_t new_total_vis = (time_now * (60 * ultramodern::get_speed_multiplier()) / 1000ms) + 1;
        if (new_total_vis > total_vis + 1) {
            //printf("Skipped % " PRId64 " frames in VI interupt thread!\n", new_total_vis - total_vis - 1);
        }
        total_vis = new_total_vis;

        // If the game hasn't started yet, set a dummy VI mode and origin.
        if (!ultramodern::is_game_started()) {
            static bool odd = false;
            set_dummy_vi(odd);
            odd = !odd;
        }

        // Queue a screen update for the graphics thread with the current VI register state.
        // Doing this before the VI update is equivalent to updating the screen after the previous frame's scanout finished.
        events_context.action_queue.enqueue(ScreenUpdateAction{ events_context.vi.regs });

        // Update VI registers and swap VI modes.
        events_context.vi.update_vi();

        // One-time full RDRAM snapshot (env RECOMP_RDRAM_DUMP=<path>, ~10s in) — captures the
        // guest's SELF-DECOMPRESSED code image for the compressed-title recomp pipeline
        // (2026-07-15: banjokazooie-class has only ~73 resident funcs recompiled; the game
        // lives in RAM). Baseline-safe: no-op when unset.
        {
            static int rdram_dump_vis = 0;
            static bool rdram_dumped = false;
            const char* dump_path = std::getenv("RECOMP_RDRAM_DUMP");
            // RECOMP_RDRAM_DUMP_VIS=N sets the retrace count to capture at (default 600 = ~10s at
            // 60Hz). KI Gold 2026-08-29: its fight overlay is not decompressed into RDRAM until
            // t~21.3s (~1280 retraces), so the hardcoded 600 captures the MENU image and the
            // overlay you are hunting is simply not there yet. Time the capture to the load.
            static const int dump_at = [] {
                const char *e = std::getenv("RECOMP_RDRAM_DUMP_VIS");
                int v = (e != nullptr) ? atoi(e) : 600;
                return (v > 0) ? v : 600;
            }();
            if (dump_path && !rdram_dumped && ++rdram_dump_vis >= dump_at) {
                rdram_dumped = true;
                extern uint8_t* g_rdram_base;
                if (g_rdram_base) {
                    if (FILE* f = fopen(dump_path, "wb")) {
                        // ^3 swizzle back to N64 byte order so the image splats like a ROM
                        for (uint32_t i = 0; i < 0x800000u; i++) fputc(g_rdram_base[i ^ 3], f);
                        fclose(f);
                        fprintf(stderr, "[rdram_dump] wrote 8MB (N64 byte order) -> %s\n", dump_path);
                        fflush(stderr);
                    }
                }
            }
        }

        // If the game has started, handle sending VI and AI events.
        if (ultramodern::is_game_started()) {
            // THE VIDEO INTERRUPT IS HARDWARE, AND A GAME THAT HOSTS ITS OWN KERNEL NEEDS IT.
            //
            // Everything below this line is the HLE lane: it posts a message to the queue a game
            // registered through osViSetEvent/osSetEventMesg. A cart that runs its OWN operating
            // system registers nothing with us - it programs the VI registers directly and waits on
            // the retrace INTERRUPT, in its own handler, on its own queue. For those games this
            // loop reached the `mq == NULL` branch, printed "no queue registered", and raised
            // nothing at all, so their render thread waited on a heartbeat that never arrived.
            //
            // MEASURED on Turok 2: Seeds of Evil, 2026-09-08, interrupts handed to the guest over
            // 20 s - cartridge DMA 194, RSP 41, audio 41, serial 4, display processor 0, and VIDEO
            // RETRACE 3. Every other source has a delivery site (mmio.cpp AI/generic, pi.cpp,
            // si.cpp, events.cpp SP/DP); video had none. Its audio thread ran at a full 60 tasks a
            // second while its graphics thread never submitted a single display list.
            //
            // On the console VI_INTR fires once per field regardless of what software is listening,
            // so this is raised every retrace and is NOT gated on remaining_retraces (that divider
            // is libultra's osViSetEvent retrace_count, a software concept, not the hardware's).
            // Inert for HLE titles: recomp_baremetal_enabled() is false unless the game is running
            // its own kernel on the fiber scheduler.
            if (recomp_baremetal_enabled()) recomp_baremetal_note_interrupt(0x08);
            remaining_retraces--;
            
            std::lock_guard lock{ events_context.message_mutex };
            ViState* cur_state = events_context.vi.get_cur_state();
            if (remaining_retraces == 0) {
                if (cur_state->mq != NULLPTR) {
                    // Send a message to the VI queue, and do not set it to be requeued if the queue was full.
                    // The worst case scenario is that the game misses a VI message and has to wait a little longer for the next.
                    static uint64_t vi_sent = 0;
                    if (vi_sent < 16 || vi_sent % 300 == 0) {
                        fprintf(stderr, "[vi] VI retrace #%llu: sending to mq=0x%08X total_vis=%llu\n",
                                (unsigned long long)vi_sent, (uint32_t)cur_state->mq, (unsigned long long)total_vis);
                        fflush(stderr);
                    }
                    vi_sent++;
                    if (hle_event_lane_on())   // [lane-1 gate]
                    ultramodern::enqueue_external_message_src(cur_state->mq, cur_state->msg, false, ultramodern::EventMessageSource::Vi);
                    // Bare-metal (NC class): NC's gfx scheduler blocks on osRecvMesg on this VI queue but it
                    // lives in NC's OWN ring (the HLE enqueue above doesn't land in it nor run NC's wait-list
                    // wake), so the scheduler never wakes per-frame to submit the gfx task. Hand the VI mq+msg
                    // to the game-thread idle, which posts into NC's ring + wakes the scheduler TCB. Baseline
                    // HLE titles never enable bare-metal -> only the plain enqueue above runs for them.
                    if (recomp_baremetal_enabled() && recomp_baremetal_nc_mode()) recomp_baremetal_note_vi_mq((uint32_t)cur_state->mq, (uint32_t)(uintptr_t)cur_state->msg);   // [lane-1] NC-only hint
                } else {
                    static uint64_t vi_null = 0;
                    if (vi_null < 4 || vi_null % 300 == 0) {
                        fprintf(stderr, "[vi] VI retrace: mq=NULL (no queue registered) total_vis=%llu null_count=%llu\n",
                                (unsigned long long)total_vis, (unsigned long long)vi_null);
                        fflush(stderr);
                    }
                    vi_null++;
                }
                remaining_retraces = cur_state->retrace_count;
            }
            if (events_context.ai.mq != NULLPTR && hle_event_lane_on()) {   // [lane-1 gate]
                // Send a message to the VI queue, and do not set it to be requeued if the queue was full for the same reason as the VI message above.
                ultramodern::enqueue_external_message_src(events_context.ai.mq, events_context.ai.msg, false, ultramodern::EventMessageSource::Ai);
            }
            // OS_EVENT_COUNTER (the VR4300 timer/counter interrupt). Bare-metal / custom-VI-manager ports
            // drive their per-frame schedule off the periodic timer event, not just VI retrace; the engine
            // never fires it (osSetTimer/__osSetCompare are HLE no-ops), so a VI/timer manager or RCP
            // frame-scheduler that waits on COUNTER stalls and never forwards frame messages to the game
            // thread. Fire it each retrace (a reasonable 60Hz timer tick) to the queue the game registered
            // for it. General fix for the bare-metal frame-scheduler class (Nightmare Creatures iteration-4
            // VI-mgr->scheduler->game forward). No-op for games that don't register OS_EVENT_COUNTER (the
            // HLE-timer path, e.g. sm64/cv64) — their event_regs[3].mq stays NULL.
            if (events_context.event_regs[3].mq != NULLPTR && hle_event_lane_on()) {   // [lane-1 gate: armed non-NC games get timer via the IP7 latch]
                static uint64_t ctr_sent = 0;
                if (ctr_sent < 8) { fprintf(stderr, "[counter] fire OS_EVENT_COUNTER -> mq=0x%08X msg=0x%08X\n",
                                            (uint32_t)events_context.event_regs[3].mq, (uint32_t)(uintptr_t)events_context.event_regs[3].msg); fflush(stderr); }
                ctr_sent++;
                ultramodern::enqueue_external_message(events_context.event_regs[3].mq, events_context.event_regs[3].msg, false, false);
            }
            // RAW-INTERRUPT-DELIVERY: run the game's own exception handler for the VI interrupt so it
            // sets its RCP-event flags + posts its events. AUTO for any game whose HLE VI queue is
            // unregistered AND whose own raw MI mask enables VI (the unmatched-libultra class — their
            // recompiled __osException dispatches exactly as on hardware); explicit via NC_IRQ env for
            // the bare-metal class; inert for HLE-served titles (VI queue registered = hle_serving).
            g_hle_vi_registered.store(cur_state->mq != NULLPTR ? 1 : 0, std::memory_order_relaxed);
            recomp_deliver_rcp_interrupt(events_context.rdram, 0x08u,
                                         cur_state->mq != NULLPTR ? 1 : 0); // 0x08 = MI_INTR VI

            // (Wave-1 purge: retired the [ncgate] NC render-gate probe/forcer — a concluded experiment
            // that read/clobbered an NC-specific RAM word from shared engine code. Its conclusion feeds
            // the general bare-metal frame-ready delivery; see the generalization worklist.)

            // hog-sampler: one line per retrace naming the last guest func any thread entered.
            // t = host-thread ordinal (1st marking thread = 1), dmarks = entries since last retrace
            // (0 ⇒ spinning a back-edge inside f without calling anything).
            if (recomp_hog_sampler_active()) {
                static uint64_t hog_last_marks = 0;
                uint64_t hog_marks = 0;
                uint64_t hog_mk = recomp_hog_sample(&hog_marks);
                fprintf(stderr, "[hogsample] vi=%llu t=%u f=0x%08X dmarks=%llu\n",
                        (unsigned long long)total_vis, (uint32_t)(hog_mk >> 32), (uint32_t)hog_mk,
                        (unsigned long long)(hog_marks - hog_last_marks));
                hog_last_marks = hog_marks;
                fflush(stderr);
            }
            { static uint32_t hog_chain_tick = 0; if ((++hog_chain_tick % 60) == 1) recomp_hog_chain_dump(); }
            // [gt-pulse] 1Hz game-thread pc sample (cross-thread mirror updated at interp poll
            // cadence). A FROZEN value while retraces keep ticking = the game thread is inside a
            // native path with no venue; the frozen pc names the last interpreted site before it.
            // [spin-watch 08-27] UNCAPPED 1Hz truth line. Every other view of the no-input hang
            // was a capped print lying by omission (gt-pulse 40, notes capped, mmio 4000, the
            // interp-only store watch). This one always prints: the guest pc mirror, the pending
            // interrupt count, the accumulated MI level bits, and the idle/pump counter. A hang
            // is then readable directly: pc parked + notes still arriving = nothing is delivering;
            // pc parked + no notes = the source side died.
            {
                static uint32_t sw_tick = 0;
                if ((++sw_tick % 60) == 0) {
                    uint64_t sw_idle = 0; int sw_pend = 0;
                    recomp_bm_pump_state(&sw_idle, &sw_pend);
                    static uint64_t sw_prev_ginstr = 0;
                    const uint64_t sw_ginstr = recomp_guest_instr();
                    fprintf(stderr, "[spin-watch] pc=0x%08X pending=%d mi_noted=0x%02X idle=%llu vis=%llu ginstr=%llu rate=%llu/s sess=%llu idle{off,gate,root,none,DRAIN}={%llu,%llu,%llu,%llu,%llu} eret{n,sw,self,resume,MM}={%llu,%llu,%llu,%llu,%llu} HANDLER=%llu gap{interp,noop}={%llu,%llu} ghost{stale,tot}={%llu,%llu}%c",
                            recomp_interp_pc_shared(), sw_pend, recomp_baremetal_noted_mi(),
                            (unsigned long long)sw_idle, (unsigned long long)total_vis,
                            (unsigned long long)sw_ginstr, (unsigned long long)(sw_ginstr - sw_prev_ginstr), (unsigned long long)recomp_guest_sessions(),
                            (unsigned long long)recomp_bm_idle_census(0), (unsigned long long)recomp_bm_idle_census(1),
                            (unsigned long long)recomp_bm_idle_census(2), (unsigned long long)recomp_bm_idle_census(3),
                            (unsigned long long)recomp_bm_idle_census(4),
                            (unsigned long long)recomp_bm_eret_census(0), (unsigned long long)recomp_bm_eret_census(1),
                            (unsigned long long)recomp_bm_eret_census(2), (unsigned long long)recomp_bm_eret_census(3),
                            (unsigned long long)recomp_bm_eret_census(4),
                            (unsigned long long)recomp_bm_eret_census(5),
                            (unsigned long long)recomp_gap_tail(0), (unsigned long long)recomp_gap_tail(1),
                            (unsigned long long)recomp_ghost_stale_fetches(), (unsigned long long)recomp_ghost_total_fetches(), 0x0A);
                    sw_prev_ginstr = sw_ginstr;
                    fflush(stderr);
                    // [rspwatch] the RSP side of the same 1 Hz truth: is a completion owed, and who
                    // owes it. head==done and HALT set = nothing outstanding; head>done with the
                    // pacer holding it = waiting on the debt/floor; head>done, pacer empty, gfx
                    // thread in send_dl = RT64 has not finished walking the task.
                    {
                        uint32_t tsub = 0, tdone = 0; recomp_task_counts(&tsub, &tdone);
                        unsigned long long th, td;
                        { std::lock_guard<std::mutex> lk(rsp_order_mutex); th = rsp_ticket_head; td = rsp_ticket_done; }
                        fprintf(stderr, "[rspwatch] tickets head=%llu done=%llu tasks sub=%u done=%u sp_status=0x%03X pacer_pending=%zu gfx_in_send_dl=%d%c",
                                th, td, tsub, tdone, recomp_sp_status_peek(),
                                g_pacer_pending.load(std::memory_order_relaxed), g_gfx_in_send_dl.load(std::memory_order_relaxed), 0x0A);
                        fflush(stderr);
                    }
                }
            }
            {
                static uint32_t gtp_tick = 0;
                static uint32_t gtp_last = 0;
                static uint32_t gtp_frozen = 0;
                if ((++gtp_tick % 60) == 0) {
                    const uint32_t pc = recomp_interp_pc_shared();
                    gtp_frozen = (pc == gtp_last) ? gtp_frozen + 1 : 0;
                    gtp_last = pc;
                    static int gtp_prints = 0;
                    if (gtp_prints < 40 || gtp_frozen == 5 || (gtp_tick % 1800) == 0) {
                        gtp_prints++;
                        uint32_t rg[4];
                        recomp_bm_peek_regs(rg);
                        uint64_t pe = 0; int pd = 0;
                        recomp_bm_pump_state(&pe, &pd);
                        fprintf(stderr, "[gt-pulse] interp_pc=0x%08X v0=0x%08X v1=0x%08X a1=0x%08X a2=0x%08X idle=%llu pend=%d %s\n",
                                pc, rg[0], rg[1], rg[2], rg[3],
                                (unsigned long long)pe, pd, (gtp_frozen >= 5) ? "FROZEN" : "");
                        if (gtp_frozen >= 5) {
                            const uint64_t rip = recomp_bm_sample_rip();
                            fprintf(stderr, "[rip-sample] game-thread RIP=0x%llX\n", (unsigned long long)rip);
                            fflush(stderr);
                            static uint32_t wd_n = 0;
                            if ((++wd_n % 10u) == 1u) recomp_bm_dump_wedge();   // every ~10th frozen pulse
                        }
                        fflush(stderr);
                    }
                }
            }
            // [unitctr 2026-08-26] SOTE reload progress: the cen64 oracle proved the transition is
            // a SELF-RELOAD whose descriptor chain counts units at [0x80199CC4] (truth: 0x012A units
            // processed; our wedge: 0x0006). 1Hz change-sampler names the unit timeline + the stall
            // boundary. Reads events_context.rdram; prints only on change; instrument-only.
            {
                static uint32_t uc_tick = 0;
                static uint32_t uc_last = 0xFFFFFFFFu;
                if ((++uc_tick % 30) == 0 && events_context.rdram != nullptr) {
                    const uint32_t w = *(uint32_t*)(events_context.rdram + 0x199CC4u);
                    if (w != uc_last) {
                        fprintf(stderr, "[unitctr] [0x80199CC4]=0x%08X (units=%u) desc0=0x%08X%c",
                                w, w >> 16, *(uint32_t*)(events_context.rdram + 0x199CB0u), 0x0A);
                        fflush(stderr);
                        uc_last = w;
                    }
                    // [ring-1hz 08-27] the park-ring only surfaced at FROZEN, but the dead-boot
                    // class never trips FROZEN — it churns. Surface the ring every 5s regardless
                    // so the steady-state schedule (which tcbs park at which pcs) is always on
                    // the record. Uncapped by design; ~3 lines / 5s.
                    static uint32_t ring_tick = 0;
                    if ((++ring_tick % 5) == 0) recomp_bm_dump_wedge();
                }
            }
            // mark-watch 1Hz report (env RECOMP_MARK_WATCH; inert otherwise)
            {
                static uint32_t mw_tick = 0;
                if ((++mw_tick % 60) == 1) {
                    uint32_t mw_vram = 0;
                    uint64_t mw_hits = recomp_mark_watch_hits(&mw_vram);
                    if (mw_vram != 0) {
                        fprintf(stderr, "[markwatch] func_%08X entries=%llu\n", mw_vram, (unsigned long long)mw_hits);
                        fflush(stderr);
                    }
                }
            }
        }

        if (events_callbacks.vi_callback != nullptr) {
            events_callbacks.vi_callback();
        }
    }
}

// Bare-metal (NC-class) RCP-interrupt delivery: titles with their own exception handler wait on SP/DP-done via
// their OWN RCP-interrupt handler + event queues, NOT the HLE sp.mq/dp.mq (which they never register). Mirror the
// VI delivery by feeding the SP/DP MI source bit into the game-thread handler drain so the handler posts the
// graphics-completion event the render task is blocked on. General (any raw-SP-task baremetal title); inert otherwise.
extern "C" int  recomp_baremetal_enabled();
extern "C" int  recomp_baremetal_nc_mode();
extern "C" void recomp_baremetal_note_interrupt(uint32_t mi_bits);
// Bare-metal (NC class): NC waits on SP/DP-done via its OWN event queues (D_8012D600+0x38/+0x48), NOT the
// HLE sp.mq/dp.mq (which are NULL — NC never calls osSetEventMesg(OS_EVENT_SP/DP)). The MI-bit note alone
// runs NC's handler but its own MI-dispatch chain derails before posting the gfx-completion event. So we
// ALSO flag SP/DP pending; the game-thread idle resolves NC's SP/DP queue from the event table and runs
// nc_deliver_and_wake (post the message into the ring + wake the render task), exactly like PI/SI.
extern "C" void recomp_baremetal_note_sp();
extern "C" void recomp_baremetal_note_dp();
extern "C" void recomp_baremetal_note_vi_mq(uint32_t mq, uint32_t msg);

// SP_STATUS register model (mmio.cpp): task-completion state, set before the SP interrupt is
// raised so the handler reads a coherent register.
extern "C" void recomp_sp_status_task_done();

void sp_complete() {
    uint8_t* rdram = events_context.rdram;
    std::lock_guard lock{ events_context.message_mutex };
    recomp_sp_status_task_done();
    { static int _n=0; if (_n++ < 20) { fprintf(stderr, "[evtfire] SP-done -> mq=0x%08X\n", (uint32_t)events_context.sp.mq); fflush(stderr); } }
    if (hle_event_lane_on())   // [lane-1 gate]
    ultramodern::enqueue_external_message_src(events_context.sp.mq, events_context.sp.msg, false, ultramodern::EventMessageSource::Sp);
    if (recomp_baremetal_enabled()) { recomp_baremetal_note_interrupt(0x01); if (recomp_baremetal_nc_mode()) recomp_baremetal_note_sp(); } // SP-done: MI bit (general) + NC ring delivery (legacy)
}

void dp_complete() {
    uint8_t* rdram = events_context.rdram;
    std::lock_guard lock{ events_context.message_mutex };
    { static int _n=0; if (_n++ < 20) { fprintf(stderr, "[evtfire] DP-done -> mq=0x%08X\n", (uint32_t)events_context.dp.mq); fflush(stderr); } }
    if (hle_event_lane_on())   // [lane-1 gate]
    ultramodern::enqueue_external_message_src(events_context.dp.mq, events_context.dp.msg, false, ultramodern::EventMessageSource::Dp);
    if (recomp_baremetal_enabled()) { recomp_baremetal_note_interrupt(0x20); if (recomp_baremetal_nc_mode()) recomp_baremetal_note_dp(); } // DP-done: MI bit (general) + NC ring delivery (legacy)
}

// GFX RCP-COMPLETION PACER (default tier; SOTE boot deadlock, 2026-07-19). Hardware contract:
// an RSP gfx task occupies the RSP for a real interval (~1-4ms) and the RDP finishes AFTER the
// task that fed it — neither SP-done nor DP-done is ever simultaneous with the submit or with
// each other. Our RSP completes in microseconds and RT64 accepts a DL near-instantly; both
// completions then race the guest to its own wait-arm point. SOTE's kernel drains its RSP-event
// queue non-blockingly from every wait loop and only latches a completion into a fire flag if
// the matching arm flag is set at consumption time — its frame-end signal is the LAST GFX
// SP-DONE (task-queue-empty query) with the frame-end arm set, and the arm is written AFTER the
// submit burst. An instant SP-done is consumed before the arm and discarded — the armed spin
// then waits forever (the boot-sequence world-stop; nondeterministic onset because it is a
// race). Both completions are therefore delivered off-thread at floor deadlines by ONE pacer
// thread over ONE monotonic deque (schedule-at-max(back, deadline), the ai_pacer_kick pattern):
// per-completion counting (none can be collapsed), and in-queue ordering makes DP(N) unable to
// fire before SP(N) structurally. SP deliveries still route through rsp_complete_in_order's
// ticket sequencer, so cross-stream order vs audio tasks holds. The gfx thread never sleeps
// (it services VI/screen updates — the v3 lesson). Floors are NOT a pacing model: cost-driven
// timing stays with the opt-in authentic-timing/governor layers (TIMING_FIDELITY_DESIGN).
// Knobs: RECOMP_SP_TASK_US (SP floor, shared with the audio path; default 1000),
// RECOMP_DP_MIN_DELAY_US (DP floor past SP; default 1500). 0 = legacy inline for that stage.
// RECOMP_DP_RENDER_TRUE (default ON; 0 = floor pacer): deliver DP-done at ACTUAL workload-render
// completion via rt64's rt64_workload_rendered_hook — see deliver_render_true_dp below.
// ── [guest-clock: RCP completion debt] (GUEST_CLOCK_PLAN.md, 2026-08-27) ────────────────────────
// Hardware does not hand the game a wall-clock delay while the RCP works; it hands it a GUARANTEED
// AMOUNT OF CPU PROGRESS. SOTE's cine frame costs 0.62ms of RDP time, so a console CPU retires
// ~58,000 cycles before the completion can be observed — thousands of times more than the few
// hundred instructions the game needs to arm its wait, which is why the console cannot lose that
// race and we can. Our floors are HOST microseconds, so what the guest actually gets depends on
// whether that code path happens to run interpreted or native: measured 18M interpreted instr/s
// during SOTE's boot, i.e. a 1ms floor buys ~18,000 instructions where hardware gives 58,000.
// (That arithmetic predicts the measured 3ms minimum floor to within a few percent.)
//
// So express the wait as a CYCLE DEBT and let real time fall out of it. Safety shape, deliberate:
//   * NEVER deliver earlier than the existing floor — the floor has other jobs (the snowkids
//     priority-starvation class, the torn-DL walk), and this must not regress them.
//   * After the floor, wait until the guest has retired the debt.
//   * If the guest clock is not moving at all (delta == 0), the game is running native and we have
//     no visibility: fall back to exactly today's behaviour. This is what keeps Space Invaders
//     (60fps, fully native) unchanged while SOTE gets its correct wait.
//   * A hard cap bounds the wait in every case.
// The native half of the clock (recompiler-emitted instruction counts) retires the delta==0 case.
extern "C" uint64_t recomp_guest_instr(void);
static constexpr double kCpuCyclesPerRdpCycle = 93.75 / 62.5;   // VR4300 vs RDP clock
static constexpr uint64_t kRcpHardCapUs = 8000;                 // bound the wait, always

static bool rcp_debt_paid(uint64_t start_ginstr, uint64_t debt_cycles,
                          std::chrono::high_resolution_clock::time_point floor_deadline,
                          std::chrono::high_resolution_clock::time_point hard_cap) {
    const auto now = std::chrono::high_resolution_clock::now();
    if (now < floor_deadline) return false;              // never earlier than today
    if (now >= hard_cap) return true;                    // bounded, always
    const uint64_t delta = recomp_guest_instr() - start_ginstr;
    if (delta == 0) return true;                         // guest clock blind (native): legacy floor
    return delta >= debt_cycles;                         // hardware's actual rule
}

static void schedule_gfx_completion(bool is_dp, uint64_t ticket,
                                    std::chrono::high_resolution_clock::time_point deadline,
                                    uint64_t debt_cycles = 0) {
    struct Pending {
        std::chrono::high_resolution_clock::time_point due;      // floor: never deliver before this
        std::chrono::high_resolution_clock::time_point cap;      // hard bound on the total wait
        uint64_t start_ginstr;                                   // guest clock at scheduling
        uint64_t debt;                                           // CPU cycles the guest is owed
        bool is_dp; uint64_t ticket;
    };
    static std::mutex m;
    static std::condition_variable cv;
    static std::deque<Pending> due;
    static bool thread_started = false;
    {
        std::lock_guard<std::mutex> g(m);
        auto start = (!due.empty() && due.back().due > deadline) ? due.back().due : deadline;
        due.push_back({ start, start + std::chrono::microseconds(kRcpHardCapUs),
                        recomp_guest_instr(), debt_cycles, is_dp, ticket });
        g_pacer_pending.store(due.size(), std::memory_order_relaxed);   // [rspwatch]
        if (!thread_started) {
            thread_started = true;
            std::thread([] {
                ultramodern::set_native_thread_name("RCP Pacer");
                std::unique_lock<std::mutex> l(m);
                for (;;) {
                    if (due.empty()) { cv.wait(l); continue; }
                    // Only ever examine the FRONT item: in-queue ordering is what makes DP(N)
                    // structurally unable to fire before SP(N), and the debt rule must not break it.
                    const Pending& front = due.front();
                    if (!rcp_debt_paid(front.start_ginstr, front.debt, front.due, front.cap)) {
                        // Not yet owed. Sleep to the floor if it is still ahead, else re-check on a
                        // short tick while the guest pays down the debt.
                        const auto now = std::chrono::high_resolution_clock::now();
                        cv.wait_until(l, (now < front.due) ? front.due
                                                           : now + std::chrono::microseconds(250));
                        continue;
                    }
                    Pending p = due.front();
                    due.pop_front();
                    g_pacer_pending.store(due.size(), std::memory_order_relaxed);   // [rspwatch]
                    l.unlock();
                    if (p.is_dp) dp_complete();
                    else rsp_complete_in_order(p.ticket, 0);
                    l.lock();
                }
            }).detach();
        }
    }
    cv.notify_one();
}

// ── RDP-DIRECT COMPLETION (KI Gold, 2026-08-28) ────────────────────────────────────────────────
// osDpSetNextBuffer hands a command list STRAIGHT to the RDP (DPC_START/DPC_END) with no RSP task
// in front of it, so NONE of the gfx-task completion paths below ever run for it and OS_EVENT_DP
// never fires. A scheduler that waits on DP-done before re-opening its swap gate then stops dead.
// MEASURED on KI Gold: exactly ONE [evtfire] DP-done in a 120 s run — and that counter caps at 20,
// so a value below the cap is the exact total, not a truncation. Its scheduler leaves D_8000D196
// latched at 1 (set right after the osDpSetNextBuffer that "succeeded"), which is the one value
// that stops it reaching the only site that re-opens D_8000D198 => osViSwapBuffer is never called.
// Route through the SAME pacer the task path uses so ordering against pending SP completions holds.
extern "C" void recomp_dp_direct_complete(uint32_t delay_us) {
    schedule_gfx_completion(true, 0,
        std::chrono::high_resolution_clock::now() + std::chrono::microseconds(delay_us));
}

// ── RENDER-TRUE DP-DONE (SOTE dark-shimmer root fix, 2026-07-19) ────────────────────────────────
// The floor pacer above still LIES about when the RDP finished: the guest receives DP-done at
// submit+floor, flips its framebuffer, and the VI presents a target whose workload the render
// thread hasn't finished — the fill lands but the frame's draws haven't, so presents interleave
// mid-frame black with finished frames (SOTE's constant shimmer; burst-measured 30-60% black).
// Hardware truth: DP-done fires when the RDP finished writing the framebuffer. rt64's workload
// thread knows that exact moment (rt64_workload_rendered_hook fires alongside the "present may
// show this workload" advance). Delivery routes through the SAME monotonic deque, so DP(N) still
// cannot precede SP(N) and drain-separation from the last SP is kept by a small epsilon.
// Accounting: the render can complete BEFORE the submitting thread reaches its schedule point
// (send_dl enqueues, the workload thread races ahead), so an early hook banks a credit the
// submit path consumes immediately — order restored in the deque either way. Credits are capped:
// the opt-in authentic-timing/governor layers deliver DP themselves and never register pendings,
// so their workloads' hooks must not accumulate unbounded credits.
extern "C" void (*rt64_workload_rendered_hook)(void);
static std::mutex dp_render_mutex;
static int dp_render_pending = 0;    // DP deliveries awaiting their workload's render completion
static int dp_render_credits = 0;    // render completions that beat their submit path (capped)
static bool dp_render_true_enabled() {
    // DEFAULT OFF (2026-07-19): built during the SOTE shimmer dig on the theory that presents
    // raced unfinished workloads — the real cause was the early-present heuristic presenting
    // clear-only pairs (rt64_framebuffer_pair.cpp earlyPresentCandidate), and the verified
    // completion mechanism is the floor pacer above. Render-true delivery is hardware-truer on
    // paper but unverified in the fleet; opt in with RECOMP_DP_RENDER_TRUE=1 when the
    // timing-fidelity work picks it up.
    static const bool on = [] {
        const char* e = std::getenv("RECOMP_DP_RENDER_TRUE");
        return (e && e[0] == '1');
    }();
    return on;
}
static void deliver_render_true_dp() {
    schedule_gfx_completion(true, 0,
        std::chrono::high_resolution_clock::now() + std::chrono::microseconds(500));
}
static void ultramodern_workload_rendered() {
    std::lock_guard<std::mutex> l(dp_render_mutex);
    if (dp_render_pending > 0) {
        dp_render_pending--;
        deliver_render_true_dp();
    }
    else if (dp_render_credits < 4) {
        dp_render_credits++;
    }
}

void task_thread_func(uint8_t* rdram, moodycamel::LightweightSemaphore* thread_ready) {
    ultramodern::set_native_thread_name("SP Task Thread");
    ultramodern::set_native_thread_priority(ultramodern::ThreadPriority::Normal);

    // Notify the caller thread that this thread is ready.
    thread_ready->signal();

    while (true) {
        // Wait until an RSP task has been sent
        SpQueueEntry entry;
        events_context.sp_task_queue.wait_dequeue(entry);

        if (entry.shutdown) {
            return;
        }
        // The descriptor snapshot taken at submission (hardware: osSpTaskLoad's DMA).
        OSTask* task = &entry.task;

        // (cont.19: stripped the per-task [sp] task_thread trace.)
        // A failed ucode (VARIANT microcode hitting an unhandled jump target — NFL Blitz ships a
        // Midway aspMain whose first audio task jumps to 0x1348) used to ULTRAMODERN_QUICK_EXIT()
        // here, killing an otherwise-healthy boot. The hardware doesn't halt the console when the
        // RSP runs off the rails — the task still raises SP-done and the show goes on. Degrade:
        // log capped, then fall through to the SAME completion path as success, because the done-
        // message is what the game's audio thread blocks on AND rsp_complete_in_order's ticket
        // chain is what every LATER task (gfx included) queues behind — skip it and video wedges.
        // Audio stays parked (no samples synthesized); the process and the render loop live.
        if (!ultramodern::rsp::run_task(PASS_RDRAM task)) {
            static std::atomic_uint32_t rsp_task_fail_count{ 0 };
            uint32_t fail_n = rsp_task_fail_count.fetch_add(1, std::memory_order_relaxed) + 1;
            if (fail_n <= 3 || (fail_n % 1024) == 0) {
                fprintf(stderr, "[rsp] task type %" PRIu32 " FAILED (occurrence %" PRIu32 "); completing as a no-op to keep the game alive\n",
                        task->t.type, fail_n);
                fflush(stderr);
            }
        }

        // The RSP is not instantaneous hardware: an audio-frame task occupies it on the order of a
        // millisecond while the CPU is free to run LOWER-priority threads. HLE run_task completes in
        // ~zero time, so a high-priority audio thread pacing on SP-done gets re-woken back-to-back
        // and can monopolize the cooperative scheduler forever — the snowkids/waverace class: 16
        // BLACK games whose pri-110 audio loop starved the pri-10 main loop. Restore the hardware
        // timeline: deliver SP-done after an emulated RSP-busy interval so the waiting thread stays
        // blocked and starved threads run. RECOMP_SP_TASK_US overrides (µs; 0 = legacy instant).
        // The wait itself + the in-start-order delivery live in rsp_complete_in_order (serial RSP).
        static const long long sp_task_busy_us = [] {
            const char* v = getenv("RECOMP_SP_TASK_US");
            return v ? atoll(v) : 1000LL;
        }();
        rsp_complete_in_order(entry.ticket, sp_task_busy_us);
    }
}

std::atomic_uint32_t display_refresh_rate = 60;
std::atomic<float> resolution_scale = 1.0f;

uint32_t ultramodern::get_target_framerate(uint32_t original) {
    auto& config = ultramodern::renderer::get_graphics_config();

    switch (config.rr_option) {
        case ultramodern::renderer::RefreshRate::Original:
        default:
            return original;
        case ultramodern::renderer::RefreshRate::Manual:
            return config.rr_manual_value;
        case ultramodern::renderer::RefreshRate::Display:
            return display_refresh_rate.load();
    }
}

uint32_t ultramodern::get_display_refresh_rate() {
    return display_refresh_rate.load();
}

float ultramodern::get_resolution_scale() {
    return resolution_scale.load();
}

void ultramodern::trigger_config_action() {
    events_context.action_queue.enqueue(UpdateConfigAction{});
}

std::atomic<ultramodern::renderer::SetupResult> renderer_setup_result = ultramodern::renderer::SetupResult::Success;
std::atomic<ultramodern::renderer::GraphicsApi> renderer_chosen_api = ultramodern::renderer::GraphicsApi::Auto;

void gfx_thread_func(uint8_t* rdram, moodycamel::LightweightSemaphore* thread_ready, ultramodern::renderer::WindowHandle window_handle) {
    bool enabled_instant_present = false;
    using namespace std::chrono_literals;

    ultramodern::set_native_thread_name("Gfx Thread");
    ultramodern::set_native_thread_priority(ultramodern::ThreadPriority::Normal);

    auto old_config = ultramodern::renderer::get_graphics_config();

    auto renderer_context = ultramodern::renderer::create_render_context(rdram, window_handle, ultramodern::renderer::get_graphics_config().developer_mode);

    renderer_chosen_api.store(renderer_context->get_chosen_api());
    if (!renderer_context->valid()) {
        renderer_setup_result.store(renderer_context->get_setup_result());
        // Notify the caller thread that this thread is ready.
        thread_ready->signal();
        return;
    }

    if (events_callbacks.gfx_init_callback != nullptr) {
        events_callbacks.gfx_init_callback();
    }

    ultramodern::rsp::init();

    // Notify the caller thread that this thread is ready.
    thread_ready->signal();

    while (!exited) {
        // Try to pull an action from the queue
        Action action;
        if (events_context.action_queue.wait_dequeue_timed(action, 1ms)) {
            // Determine the action type and act on it
            if (const auto* task_action = std::get_if<SpTaskAction>(&action)) {
                // Turn on instant present if the game has been started and it hasn't been turned on yet.
                if (ultramodern::is_game_started() && !enabled_instant_present) {
                    // [instantpresent] RECOMP_NO_INSTANT_PRESENT=1 leaves RT64 in its default
                    // SkipBuffering mode instead of PresentEarly. PresentEarly publishes a
                    // framebuffer pair as soon as its colour image matches a VI history entry --
                    // i.e. BEFORE the full sync. A game that CLEARS every frame is unaffected, but
                    // KI Gold never clears (measured: exactly ONE fillRect in 60s) and repaints
                    // only partial regions, so a mid-frame present shows last frame's pixels
                    // wherever this frame has not drawn yet -- persistence AND flashing, from the
                    // presentation side rather than the drawing side. Default unchanged (ON).
                    static const bool suppress = [] {
                        const char *e = std::getenv("RECOMP_NO_INSTANT_PRESENT");
                        return (e != nullptr) && (e[0] == '1');
                    }();
                    if (!suppress) {
                        renderer_context->enable_instant_present();
                    } else {
                        fprintf(stderr, "[instantpresent] SUPPRESSED (RECOMP_NO_INSTANT_PRESENT) - "
                                        "RT64 stays in SkipBuffering\n");
                        fflush(stderr);
                    }
                    enabled_instant_present = true;
                }
                // SP-done for gfx tasks is scheduled AFTER send_dl below — hardware contract:
                // SP-done means the RSP has fully consumed the task's data, and our DL walk
                // (send_dl) IS that consumption. Firing it before/during the walk let the guest
                // rewrite its display-list buffer mid-walk (single-DL-buffer games: SOTE 0x115068
                // every frame, the snowkids flashing class) — RT64 then snapshotted TORN commands
                // = one-frame full-screen garbage (the strobe, caught in the inspector as the
                // background FILL rect wearing combine-mode state). See the pacer comment at
                // schedule_gfx_completion. RECOMP_SP_TASK_US floor still applies from task
                // arrival, never landing before walk end.
                static const long long gfx_task_busy_us = [] {
                    const char* v = getenv("RECOMP_SP_TASK_US");
                    return v ? atoll(v) : 1000LL;
                }();
                const auto gfx_task_arrival = std::chrono::high_resolution_clock::now();
                ultramodern::measure_input_latency();

                PTR(u64) displaylist = task_action->task.t.data_ptr;
                ultramodern::extensions::on_displaylist_submitted(displaylist);

                // CV64 Brick 3 (Option D): run the LLE graphics microcode (F3DEX2) over this gfx task
                // to capture the faithful RDP command stream, ALONGSIDE the HLE renderer below. No-op
                // unless a capture hook is registered. (Capture-only; Brick 4 consumes the commands.)
                ultramodern::rsp::capture_gfx_task(PASS_RDRAM &task_action->task);

                [[maybe_unused]] auto renderer_start = std::chrono::high_resolution_clock::now();
                // cv64 S41 — HARDWARE-TIMING FIDELITY LAYER (the narrator-skip / DK64-vine-class cure).
                // rt64 accumulates this DL's estimated real-RDP cost (hardware constants: 62.5MHz, cycles
                // per pixel by cycle type, tri setup, RDRAM contention — see rt64_rsp.cpp). We hold
                // dp_complete until the REAL RDP would have finished, so the game's own pacing logic
                // overruns its VI budget on heavy frames exactly like hardware (intro ≈21fps vs the
                // authored 30) → lag-tuned content (the t=940 voice trigger) lands correctly. The CPU
                // keeps simulating in parallel, audio is real-time — both as on hardware. Faithful and
                // game-agnostic; the script/data is never touched. Disable: CV64_AUTHENTIC_TIMING=0.
                g_rdp_estimated_cost_cycles = 0.0;
                // P1 (TIMING_FIDELITY_DESIGN): reset the v2 counting accumulators alongside v1.
                for (int _t2i = 0; _t2i < 4; _t2i++) g_rdptime2_pix[_t2i] = 0.0;
                g_rdptime2_lines = 0.0; g_rdptime2_setup = 0.0; g_rdptime2_prims = 0;
                g_gfx_in_send_dl.store(1, std::memory_order_relaxed);   // [rspwatch]
                renderer_context->send_dl(&task_action->task);
                g_gfx_in_send_dl.store(0, std::memory_order_relaxed);   // [rspwatch]
                [[maybe_unused]] auto renderer_end = std::chrono::high_resolution_clock::now();
                // [guest-clock] This task's REAL RDP cost, converted to the CPU cycles hardware
                // would have retired while the RCP worked. Already computed for every game above
                // and, until now, discarded. SOTE's cine frame: 0.62ms of RDP => ~58,000 cycles.
                const uint64_t rcp_debt_cycles =
                    (uint64_t)(g_rdp_estimated_cost_cycles * kCpuCyclesPerRdpCycle);
                // SP-done: the DL walk above has fully consumed the task's data — the earliest
                // hardware-honest completion point (see the comment at the top of this branch).
                // Deadline = arrival + busy floor, but never before walk end.
                if (gfx_task_busy_us > 0) {
                    auto sp_deadline = gfx_task_arrival + std::chrono::microseconds(gfx_task_busy_us);
                    if (sp_deadline < renderer_end) sp_deadline = renderer_end;
                    schedule_gfx_completion(false, task_action->rsp_ticket, sp_deadline, rcp_debt_cycles);
                } else {
                    rsp_complete_in_order(task_action->rsp_ticket, 0);
                }
                // P1 (TIMING_FIDELITY_DESIGN): v2 counting-mode report. LOG-ONLY + env-gated
                // (RECOMP_TIMING_LOG=1): the default build emits nothing and acts on nothing.
                // v2 preview cost = setup + SPAN_SETUP×lines + Σ pix×rate; rates are the DOCUMENTED
                // peaks (fill/copy 4 px/clk = 0.25, 1-cycle 1.0, 2-cycle 2.0 cycles/px) and
                // SPAN_SETUP=8.0 is a placeholder — both [CALIBRATE] against oracle traces in P2.
                {
                    static const bool timing_log = (std::getenv("RECOMP_TIMING_LOG") != nullptr);
                    if (timing_log) {
                        static uint32_t _t2n = 0;
                        if ((_t2n++ % 256u) == 0u) {
                            const double _rate[4] = {0.25, 0.25, 1.0, 2.0};
                            double _c2 = g_rdptime2_setup + 8.0 * g_rdptime2_lines;
                            for (int i = 0; i < 4; i++) _c2 += g_rdptime2_pix[i] * _rate[i];
                            fprintf(stderr, "[rdptime2] task#%u v1=%.2fms v2=%.2fms prims=%llu lines=%.0f pix{f,c,1,2}={%.0f,%.0f,%.0f,%.0f}\n",
                                    _t2n, g_rdp_estimated_cost_cycles / 62.5 / 1000.0, _c2 / 62.5 / 1000.0,
                                    g_rdptime2_prims, g_rdptime2_lines,
                                    g_rdptime2_pix[0], g_rdptime2_pix[1], g_rdptime2_pix[2], g_rdptime2_pix[3]);
                            fflush(stderr);
                        }
                    }
                }

                {
                    static const bool authentic_timing = [] {
                        const char* e = std::getenv("CV64_AUTHENTIC_TIMING");
                        // SM64PC SESSION 45 (this branch): DEFAULT OFF. The layer is a
                        // CV64-profile feature — its gate reads CV64's sys.cutscene_ID at
                        // phys 0x389EF8, which in any OTHER game's RAM is arbitrary data
                        // (SM64 boot #3: gate ENABLED + garbage read = the cutscene pacing
                        // could engage on boot frames). Opt in with CV64_AUTHENTIC_TIMING=1.
                        bool on = (e && e[0] == '1');
                        fprintf(stderr, "[rdptime] authentic timing %s (CV64_AUTHENTIC_TIMING=%s; default OFF on the sm64 branch)\n",
                                on ? "ENABLED" : "DISABLED", e ? e : "(unset)");
                        return on;
                    }();
                    // v5 (the rule): GAMEPLAY runs UNSLOWED (the enhancement); CUTSCENES pace at
                    // the MEASURED hardware tempo (where the time-tuned triggers live). Gate = the game's
                    // own cutscene state (a nonzero word while a cutscene plays). The physical address of
                    // that word is now a PER-GAME CONFIG FIELD (g_cutscene_gate_phys_addr) instead of a
                    // buried 0x389EF8 constant: cv64pc sets it to 0x389EF8 (sys.cutscene_ID); any game that
                    // leaves it unset disables the layer entirely → the gate never reads garbage out of a
                    // different game's RAM. (S45 de-flavor; per-span RDP timing model will retire both.)
                    bool in_cutscene = false;
                    if (g_cutscene_gate_phys_addr.has_value() && g_rdram_base != nullptr) {
                        in_cutscene = (*reinterpret_cast<uint32_t*>(g_rdram_base + *g_cutscene_gate_phys_addr) != 0u);
                    }
                    // DK64 test path: CV64_AUTHENTIC_ALWAYS forces the layer on every frame and drives it from
                    // the now-fixed RAW RDP-cost estimate (no CV64 measured-cadence calibration), with a 60Hz
                    // VI-deadline FLOOR (light frames don't free-run past hardware) and a safety cap
                    // (CV64_AUTHENTIC_CAP_MS, default 50 = 20fps). (Experimental; verify then wire a DK64 gate.)
                    static const bool authentic_always = (std::getenv("CV64_AUTHENTIC_ALWAYS") != nullptr);
                    if (authentic_always) in_cutscene = true;
                    if (authentic_timing && in_cutscene) {
                        // cycles -> microseconds at the RDP's 62.5 MHz.
                        double cost_us = g_rdp_estimated_cost_cycles / 62.5;
                        // Reproduce the MEASURED hardware cadence (hardware footage: 910 ticks in 43s =
                        // 17% two-VI + 83% three-VI frames). CV64-specific; skipped in raw/always mode.
                        if (!authentic_always && cost_us > 33000.0) {
                            static uint32_t _cad = 0;
                            cost_us = ((_cad++ % 6u) == 0u) ? 33000.0 : 47000.0;
                        }
                        std::chrono::high_resolution_clock::time_point rdp_done;
                        if (authentic_always) {
                            static const double cap_us = [] {
                                const char* e = std::getenv("CV64_AUTHENTIC_CAP_MS");
                                return ((e && e[0]) ? atof(e) : 50.0) * 1000.0;
                            }();
                            if (cost_us > cap_us) cost_us = cap_us;
                            const std::chrono::high_resolution_clock::time_point next_vi = ultramodern::get_start()
                                + ((total_vis + 1) * 1000000us) / (60 * ultramodern::get_speed_multiplier());
                            const std::chrono::high_resolution_clock::time_point capped =
                                renderer_start + std::chrono::microseconds((int64_t)cost_us);
                            rdp_done = (capped > next_vi) ? capped : next_vi;
                        } else {
                            rdp_done = renderer_start + std::chrono::microseconds((int64_t)cost_us);
                        }
                        static int _rl = 0; static uint32_t _rn = 0;
                        if ((++_rn & 0x3F) == 0 && _rl < 40) {
                            _rl++;
                            fprintf(stderr, "[rdptime] task #%u estimated %.2f ms (interp took %.2f ms)\n",
                                    _rn, cost_us / 1000.0,
                                    std::chrono::duration<double, std::milli>(renderer_end - renderer_start).count());
                            fflush(stderr);
                        }
                        // v3: do NOT sleep THIS thread — it also services the VI/screen updates, so an
                        // inline sleep stalls the VI and the game's retrace waits stack ON TOP of the RDP
                        // wait (measured: intro at 10.7 logic-ticks/s vs the 21.2 hardware target = the
                        // double-count). Hardware truth: the RDP is busy while the VI ticks independently.
                        // A dedicated timer thread delivers dp_complete at the deadline; the game (which
                        // is the only thing waiting on DP-done) paces itself; the VI flows freely.
                        static std::mutex rdp_mtx;
                        static std::condition_variable rdp_cv;
                        static std::chrono::high_resolution_clock::time_point rdp_deadline;
                        static bool rdp_pending = false;
                        static const bool rdp_timer_started = [] {
                            std::thread([] {
                                for (;;) {
                                    std::unique_lock<std::mutex> l(rdp_mtx);
                                    rdp_cv.wait(l, [] { return rdp_pending; });
                                    auto dl = rdp_deadline;
                                    l.unlock();
                                    std::this_thread::sleep_until(dl);
                                    l.lock();
                                    rdp_pending = false;
                                    l.unlock();
                                    dp_complete();
                                }
                            }).detach();
                            return true;
                        }();
                        (void)rdp_timer_started;
                        {
                            std::lock_guard<std::mutex> l(rdp_mtx);
                            rdp_deadline = rdp_done;
                            rdp_pending = true;
                        }
                        rdp_cv.notify_one();
                        // dp_complete will be sent by the timer thread; skip the inline one below.
                        ultramodern::extensions::on_displaylist_parsed(displaylist);
                        ultramodern::extensions::on_displaylist_completed(displaylist);
                        continue;
                    }
                }

                // VI-DEADLINE FRAME GOVERNOR (gated on RECOMP_FRAME_GOVERNOR; DEFAULT OFF).
                // Problem: the ONLY 60Hz pacer is the VI thread (vi_thread_func above), which sleeps to
                // the VI deadline then posts the retrace msg. A game's per-frame logic, however, is NOT
                // gated to it: the gfx-task ack below (sp_complete + dp_complete) currently reports the
                // GPU finished INSTANTLY, so a game that waits only on RDP/SP-done (e.g. DK64's
                // interpreted intro) free-runs its logic many times faster than 60Hz. Fix: hold the
                // frame-done (dp_complete) until time >= the next VI deadline — the SAME deadline the VI
                // thread computes (get_start() + total_vis*1e6us/60) — so logic is paced to one frame per
                // 60Hz tick. We mirror the CV64_AUTHENTIC_TIMING block above exactly: do NOT sleep this
                // thread (it also services the VI/screen updates), but hand the deadline to a dedicated
                // timer thread that delivers dp_complete() at the deadline; the game (the only thing
                // waiting on DP-done) then paces itself while the VI flows freely. Baseline-safe: when the
                // env is unset this whole block is skipped (the static gate evaluates false ONCE), so
                // sm64/cv64/robotron hit the plain dp_complete() below and are byte-identical to now.
                {
                    static const bool frame_governor = [] {
                        const char* e = std::getenv("RECOMP_FRAME_GOVERNOR");
                        bool on = (e != nullptr && e[0] != '\0' && e[0] != '0');
                        fprintf(stderr, "[govenor] VI-deadline frame governor %s (RECOMP_FRAME_GOVERNOR=%s; default OFF)\n",
                                on ? "ENABLED" : "DISABLED", e ? e : "(unset)");
                        fflush(stderr);
                        return on;
                    }();
                    if (frame_governor) {
                        // FLAT-CAP MODE (NC class, 2026-07-02): RECOMP_FRAME_GOVERNOR=<fps> (10..120) paces
                        // EVERY frame to a steady <fps> grid with NO game-mode read and NO cost dip. For titles
                        // whose logic rate is EMERGENT from task-completion latency (Kalisto NC: on hardware the
                        // RDP takes most of a frame, so the fb-swap gate paces the game to 30fps; our instant
                        // RT64 completion let it free-run at 60 = 2x speed + game-side audio churn).
                        // RECOMP_FRAME_GOVERNOR=1 keeps the original DK64 mode-gated behavior below.
                        static const int flat_cap_fps = [] {
                            const char* e = std::getenv("RECOMP_FRAME_GOVERNOR");
                            int v = e ? atoi(e) : 0;
                            return (v >= 10 && v <= 120) ? v : 0;
                        }();
                        // FRAMERATE CAP, game-mode-gated: DK64 GAMEPLAY (GAME_MODE_ADVENTURE) targets 30fps
                        // (US/NTSC); its CUTSCENES/intro/menus (rap, logos, file select) run at 60fps. The cost
                        // can't tell them apart (both are light), so we read game_mode (0x80755318 -> phys
                        // 0x755318; word, native order). 30fps cap = total_vis+1 (the next 30fps tick — total_vis
                        // is already elapsed+1 in vi_thread_func, so +1 again = 2 VIs ahead); 60fps cap = total_vis
                        // (1 VI ahead). DK64 game_mode default is a per-game knob; 0x80755318 is DK64's.
                        // game_mode is a byte stored with the N64Recomp big-endian XOR-3 swizzle, so read the
                        // byte at (phys ^ 3), not the word (a word read gives it byte-reversed, e.g. 0x02000000).
                        const int32_t dk_game_mode = flat_cap_fps ? -1 : (events_context.rdram
                            ? (int32_t)*(uint8_t*)(events_context.rdram + (0x755318u ^ 3u)) : 6);
                        // Gameplay-rate modes (30fps + cost dip): ADVENTURE(6) = normal play, and the attract
                        // DEMO, which is recorded gameplay running under DK-TV mode — DK_TV(3) / UNKNOWN_4(4)
                        // (DK64 groups these in gameIsInDKTVMode). The demo MUST be gameplay-rate or its recorded
                        // inputs replay too fast. Everything else (logos/rap/menus) is a 60fps cutscene.
                        // (flat-cap mode: never "gameplay" => steady grid, no cost dip.)
                        const bool is_gameplay = flat_cap_fps ? false
                            : (dk_game_mode == 6 || dk_game_mode == 3 || dk_game_mode == 4);
                        // PHASE-LOCKED PACE: deliver dp_complete on a steady grid at the target rate so the
                        // game's LOGIC hits exactly that framerate. The old VI-aligned `total_vis` deadline
                        // drifted to ~53fps in the rap — each frame's post-dp work re-anchored total_vis ~1.13
                        // VIs out, so the cuts lagged the 57s song by ~9s. Advance a persistent deadline by one
                        // frame-period each frame; only clamp forward after a real hitch / mode change.
                        // GAMEPLAY=30fps, cutscenes/intro/menus=60fps.
                        const double target_fps = flat_cap_fps ? (double)flat_cap_fps
                                                               : (is_gameplay ? 30.0 : 60.0);
                        const auto pace_period = std::chrono::microseconds(
                            (int64_t)(1000000.0 / (target_fps * ultramodern::get_speed_multiplier())));
                        static std::chrono::high_resolution_clock::time_point paced_deadline =
                            std::chrono::high_resolution_clock::now();
                        paced_deadline += pace_period;
                        const std::chrono::high_resolution_clock::time_point _now_tp =
                            std::chrono::high_resolution_clock::now();
                        if (paced_deadline < _now_tp) paced_deadline = _now_tp; // resync after a hitch / mode flip
                        // COST-DRIVEN DIP (gameplay only): heavy frames hold past the 30fps grid by their
                        // estimated RDP cost so the rate dips like hardware (15-25fps) and the attract demo
                        // stays in sync. Cutscenes stay STEADY on the grid (their "heavy" frames are cost
                        // over-count, not real load — dipping them just drifts the cuts off the music).
                        static const double cost_scale = [] {
                            const char* e = std::getenv("RECOMP_COST_SCALE");
                            return (e && e[0]) ? atof(e) : 0.28;
                        }();
                        const double cost_us = (g_rdp_estimated_cost_cycles / 62.5) * cost_scale;
                        const std::chrono::high_resolution_clock::time_point cost_deadline =
                            renderer_start + std::chrono::microseconds((int64_t)cost_us);
                        const bool dipping = (is_gameplay && cost_deadline > paced_deadline);
                        if (dipping) paced_deadline = cost_deadline; // a dip resyncs the pace (don't catch up lost time)
                        const std::chrono::high_resolution_clock::time_point next_vi = paced_deadline;
                        static int _gl = 0; static uint32_t _gn = 0;
                        if ((++_gn & 0x3F) == 0 && _gl < 800) {
                            _gl++;
                            auto _us = std::chrono::duration_cast<std::chrono::microseconds>(
                                next_vi - renderer_start).count();
                            fprintf(stderr, "[govenor] frame #%u %lldus (%.1ffps) mode=%d cap=%dfps cost=%.1fms scaled=%.1fms %s\n",
                                    _gn, (long long)_us, 1000000.0 / (double)(_us > 0 ? _us : 1),
                                    dk_game_mode, (int)target_fps,
                                    g_rdp_estimated_cost_cycles / 62.5 / 1000.0, cost_us / 1000.0,
                                    dipping ? "DIP" : "cap");
                            fflush(stderr);
                        }
                        // Dedicated timer thread delivers dp_complete() at the deadline (do not stall this
                        // thread — it services VI/screen updates). Same structure as the CV64 rdp timer.
                        static std::mutex gov_mtx;
                        static std::condition_variable gov_cv;
                        static std::chrono::high_resolution_clock::time_point gov_deadline;
                        static bool gov_pending = false;
                        static const bool gov_timer_started = [] {
                            std::thread([] {
                                for (;;) {
                                    std::unique_lock<std::mutex> l(gov_mtx);
                                    gov_cv.wait(l, [] { return gov_pending; });
                                    auto dl = gov_deadline;
                                    l.unlock();
                                    std::this_thread::sleep_until(dl);
                                    l.lock();
                                    gov_pending = false;
                                    l.unlock();
                                    dp_complete();
                                }
                            }).detach();
                            return true;
                        }();
                        (void)gov_timer_started;
                        {
                            std::lock_guard<std::mutex> l(gov_mtx);
                            gov_deadline = next_vi;
                            gov_pending = true;
                        }
                        gov_cv.notify_one();
                        // dp_complete will be sent by the timer thread at the VI deadline; skip the inline one.
                        ultramodern::extensions::on_displaylist_parsed(displaylist);
                        ultramodern::extensions::on_displaylist_completed(displaylist);
                        continue;
                    }
                }

                // Console mode: the renderer's RDP thread delivers dp_complete when the render
                // actually finishes (hardware-true timing); skip the early inline one.
                if (!g_dp_deferred_by_renderer) {
                    // Default tier: hold DP-done a floor interval past the SP task so the two never
                    // land in one interrupt drain (see schedule_dp_complete_at above — the SOTE
                    // consume-while-unarmed deadlock). Floor, not pacing: 1.5ms << one VI.
                    static const int64_t dp_floor_us = [] {
                        const char* e = std::getenv("RECOMP_DP_MIN_DELAY_US");
                        return (int64_t)((e && e[0]) ? atoll(e) : 1500);
                    }();
                    // Render-true DP-done (default): register/consume against the workload
                    // thread's actual render completion — see ultramodern_workload_rendered
                    // above. The hook is installed lazily here so console mode (which delivers
                    // DP from its own renderer) never double-delivers.
                    if (dp_render_true_enabled()) {
                        {
                            static const bool hook_installed = [] {
                                rt64_workload_rendered_hook = ultramodern_workload_rendered;
                                return true;
                            }();
                            (void)hook_installed;
                        }
                        std::lock_guard<std::mutex> l(dp_render_mutex);
                        if (dp_render_credits > 0) {
                            dp_render_credits--;
                            deliver_render_true_dp();
                        }
                        else {
                            dp_render_pending++;
                        }
                    }
                    // Floor fallback (RECOMP_DP_RENDER_TRUE=0). Anchor to NOW, not
                    // renderer_start: when the DL processing itself exceeds the floor, a
                    // renderer_start-anchored deadline is already in the past at schedule time
                    // and fires in the same drain as SP-done — the exact race the floor exists
                    // to prevent. Enqueued AFTER this task's SP completion in the same monotonic
                    // deque, so DP(N) structurally cannot fire before SP(N) — including the
                    // dp_floor==0 case, which must still ride the deque whenever the SP side is
                    // deferred.
                    else if (dp_floor_us > 0) {
                        schedule_gfx_completion(true, 0,
                            std::chrono::high_resolution_clock::now() + std::chrono::microseconds(dp_floor_us),
                            rcp_debt_cycles);
                    } else if (gfx_task_busy_us > 0) {
                        schedule_gfx_completion(true, 0, std::chrono::high_resolution_clock::now(), rcp_debt_cycles);
                    } else {
                        dp_complete();
                    }
                }
                // TODO hook the parsed event up to the actual parsing point when a callback is added to RT64.
                ultramodern::extensions::on_displaylist_parsed(displaylist);
                ultramodern::extensions::on_displaylist_completed(displaylist);
                // printf("Renderer ProcessDList time: %d us\n", static_cast<u32>(std::chrono::duration_cast<std::chrono::microseconds>(renderer_end - renderer_start).count()));
            }
            else if (const auto* screen_update_action = std::get_if<ScreenUpdateAction>(&action)) {
                events_context.vi.update_screen_regs = screen_update_action->regs;
                renderer_context->update_screen();
                display_refresh_rate = renderer_context->get_display_framerate();
                resolution_scale = renderer_context->get_resolution_scale();
                // cv64 cont.36: per-second FPS counter (presented frames) to measure perf. Logged as [fps].
                {
                    static uint64_t _fps_frames = 0;
                    static std::chrono::steady_clock::time_point _fps_t0 = std::chrono::steady_clock::now();
                    _fps_frames++;
                    // TRUE FPS (2026-07-19, corpus-wide): _fps_frames counts update_screen
                    // calls = VI re-arms = always the 60Hz retrace rate, NOT the game's frame
                    // rate (SOTE's crawling intro reported a rock-steady "60.0 FPS"). The real
                    // rate is the VI ORIGIN FLIP rate — how often the game points the VI at a
                    // DIFFERENT framebuffer. Mask the low bits so interlaced field offsets
                    // (±0x280 within one frame) don't double-count. Games that never flip
                    // (single-buffered scanout) fall back to the re-arm rate — the old value —
                    // rather than showing a misleading 0.
                    {
                        static uint32_t _last_origin_fb = 0xFFFFFFFFu;
                        static uint64_t _fps_flips = 0;
                        const uint32_t _origin_fb = screen_update_action->regs.VI_ORIGIN_REG & ~0x7FFu;
                        if (_origin_fb != _last_origin_fb) {
                            if (_last_origin_fb != 0xFFFFFFFFu) _fps_flips++;
                            _last_origin_fb = _origin_fb;
                        }
                        auto _fps_now = std::chrono::steady_clock::now();
                        auto _fps_ms = std::chrono::duration_cast<std::chrono::milliseconds>(_fps_now - _fps_t0).count();
                        if (_fps_ms >= 1000) {
                            double _vi_rate = (double)_fps_frames * 1000.0 / (double)_fps_ms;
                            double _flip_rate = (double)_fps_flips * 1000.0 / (double)_fps_ms;
                            // NO FALLBACK (2026-07-29). This used to read
                            //     _fps = (_fps_flips > 0) ? _flip_rate : _vi_rate;
                            // and that fallback fires exactly when a game is NOT flipping --
                            // boot, intro, a stalled scene -- which is precisely when someone
                            // reads this counter to find out why. It then answers with the 60Hz
                            // re-arm rate, i.e. the original bug this block was written to fix.
                            // The number has been reported as untrue repeatedly; this is why.
                            // An honest 0.0 ("no new frames were produced") is a VISIBLE failure;
                            // a confident 60.0 is an invisible one. Same principle the RDP path
                            // already follows: missing output is honest, wrong output is not.
                            // A genuinely single-buffered title would now read 0.0 -- that is a
                            // real signal to investigate, not a number to paper over.
                            double _fps = _flip_rate;
                            g_cv64_present_fps.store(_fps, std::memory_order_relaxed); // → window-title FPS
                            fprintf(stderr, "[fps] %.1f new / %.1f vi  (%llu flips, %llu presents / %lldms)\n",
                                    _fps, _vi_rate, (unsigned long long)_fps_flips,
                                    (unsigned long long)_fps_frames, (long long)_fps_ms);
                            fflush(stderr);
                            _fps_frames = 0; _fps_flips = 0; _fps_t0 = _fps_now;
                        }
                    }
                }
            }
            else if (const auto* config_action = std::get_if<UpdateConfigAction>(&action)) {
                (void)config_action;
                auto new_config = ultramodern::renderer::get_graphics_config();
                if (renderer_context->update_config(old_config, new_config)) {
                    old_config = new_config;
                }
            }
        }
    }

    graphics_shutdown_ready.wait();
    renderer_context->shutdown();
}

#define VI_CTRL_TYPE_16             0x00002
#define VI_CTRL_TYPE_32             0x00003
#define VI_CTRL_GAMMA_DITHER_ON     0x00004
#define VI_CTRL_GAMMA_ON            0x00008
#define VI_CTRL_DIVOT_ON            0x00010
#define VI_CTRL_SERRATE_ON          0x00040
#define VI_CTRL_ANTIALIAS_MASK      0x00300
#define VI_CTRL_ANTIALIAS_MODE_1    0x00100
#define VI_CTRL_ANTIALIAS_MODE_2    0x00200
#define VI_CTRL_ANTIALIAS_MODE_3    0x00300
#define VI_CTRL_PIXEL_ADV_MASK      0x01000
#define VI_CTRL_PIXEL_ADV_1         0x01000
#define VI_CTRL_PIXEL_ADV_2         0x02000
#define VI_CTRL_PIXEL_ADV_3         0x03000
#define VI_CTRL_DITHER_FILTER_ON    0x10000

static const OSViMode dummy_mode = []() {
    OSViMode ret{};

    ret.type = 2;
    ret.comRegs.ctrl = VI_CTRL_TYPE_16 | VI_CTRL_GAMMA_DITHER_ON | VI_CTRL_GAMMA_ON | VI_CTRL_DIVOT_ON | VI_CTRL_ANTIALIAS_MODE_1 | VI_CTRL_PIXEL_ADV_3;
    ret.comRegs.width = 0x140;
    ret.comRegs.burst = 0x03E52239;
    ret.comRegs.vSync = 0x20D;
    ret.comRegs.hSync = 0xC15;
    ret.comRegs.leap = 0x0C150C15;
    ret.comRegs.hStart = 0x006C02EC;
    ret.comRegs.xScale = 0x200;
    ret.comRegs.vCurrent = 0x0;

    for (int field = 0; field < 2; field++) {
        ret.fldRegs[field].origin = 0x280;
        ret.fldRegs[field].yScale = 0x400;
        ret.fldRegs[field].vStart = 0x2501FF;
        ret.fldRegs[field].vBurst = 0xE0204;
        ret.fldRegs[field].vIntr = 0x2;
    }

    return ret;
}();

void set_dummy_vi(bool odd) {
    ViState* next_state = events_context.vi.get_next_state();
    next_state->mode = &dummy_mode;
    // Set up a dummy framebuffer.
    next_state->framebuffer = 0x80700000;
    if (odd) {
        next_state->framebuffer += 0x25800;
    }
}

extern "C" void osViSwapBuffer(RDRAM_ARG PTR(void) frameBufPtr) {
    std::lock_guard lock{ events_context.message_mutex };
    events_context.vi.get_next_state()->framebuffer = frameBufPtr;
    // [vibuf] tracer: catch the FIRST few swaps + ANY framebuffer that is not a valid KSEG0/KSEG1
    // virtual address (0x80000000/0xA0000000 high bits). A garbage fb here = the game computed a bad
    // framebuffer pointer (recomp correctness bug upstream); NO [vibuf] line at all = the game never
    // swaps and the garbage VI_ORIGIN comes from the mode/raw path instead.
    static long _vibuf_n = 0;
    uint32_t fb = (uint32_t)frameBufPtr;
    // 2026-08-26 FALSE-POSITIVE FIX. The old test was `(fb & 0x80000000) == 0` — "not KSEG0/KSEG1
    // therefore garbage". But a BARE-METAL title hands this a RAW PHYSICAL address: SOTE swaps
    // 0x003DAA80 / 0x0038FA80 / 0x003B5280, all bit-31-clear, all perfectly valid, and the VI path
    // below resolves them correctly — the game renders its cutscenes at 40+ fps while this flag
    // screams on every swap. The result was a permanent lie: ~14,000 "NOT A VALID FB (garbage)"
    // lines per run, which sent two sessions chasing framebuffer plumbing that was never broken.
    // Accept EITHER a KSEG0/KSEG1 virtual address OR a plausible physical RDRAM offset (word
    // aligned, nonzero, inside 8MB); flag only an address that is neither. Log-only — no behaviour
    // change beyond what gets printed. See [[verify-before-narrate]].
    const bool fb_kseg    = (fb & 0x80000000u) != 0;
    const bool fb_physok  = (fb != 0u) && ((fb & 3u) == 0u) && (fb < 0x00800000u);
    bool bad = !fb_kseg && !fb_physok;
    if (_vibuf_n < 8 || bad) {
        fprintf(stderr, "[vibuf] osViSwapBuffer #%ld fb=0x%08X%s\n", _vibuf_n, fb,
                bad ? "  <-- NOT A VALID FB (garbage)" : "");
        fflush(stderr);
    }
    _vibuf_n++;
}

// Raw-MMIO VI configuration (Space Invaders 64 and the PSX/arcade small-team class). These titles
// drive the VI hardware registers DIRECTLY and never call osViSetMode, so the HLE VI state keeps the
// dummy mode (control = 0 -> VI_STATUS_TYPE_BLANK -> RT64 VI::visible() == false -> the present is
// skipped and the screen stays black; the dummy width is also 320 while these games run 640). The raw
// MMIO dispatcher (librecomp/mmio.cpp) hands us the game's actual VI registers here so the HLE VI path
// (update_vi -> update_screen) builds a faithful, VISIBLE VI from them. Timing fields the present does
// not need (burst/sync/leap/vBurst/vIntr) are taken from the known-good dummy mode. General "fix the
// N64": the VI register semantics, not a per-game patch. HLE titles never reach this (they go through
// osViSetMode), so their VI path is untouched.
extern "C" void recomp_set_raw_vi(uint32_t control, uint32_t width, uint32_t hStart, uint32_t vStart,
                                  uint32_t xScale, uint32_t yScale) {
    std::lock_guard lock{ events_context.message_mutex };
    static OSViMode raw_mode{};
    {
        // [rawvi 2026-09-05, Rage Wars #152] change-detected snapshot of the six registers this path hands
        // to RT64 (uncapped, but bounded by distinct register combinations). [mmio] W prints are capped
        // per register, so a mode switch late in a boot leaves no record of what H_START the present got.
        static uint32_t _p[6] = { 0xFFFFFFFFu, 0xFFFFFFFFu, 0xFFFFFFFFu, 0xFFFFFFFFu, 0xFFFFFFFFu, 0xFFFFFFFFu };
        static unsigned _n = 0;
        if (_p[0] != control || _p[1] != width || _p[2] != hStart || _p[3] != vStart || _p[4] != xScale || _p[5] != yScale) {
            _p[0] = control; _p[1] = width; _p[2] = hStart; _p[3] = vStart; _p[4] = xScale; _p[5] = yScale;
            fprintf(stderr, "[rawvi] #%u control=0x%08X width=%u hStart=0x%08X vStart=0x%08X xScale=0x%08X yScale=0x%08X%c",
                    _n++, control, width, hStart, vStart, xScale, yScale, 0x0A);
            fflush(stderr);
        }
    }
    raw_mode.type = 2;
    raw_mode.comRegs.ctrl   = control;
    raw_mode.comRegs.width  = width;
    raw_mode.comRegs.hStart = hStart;
    raw_mode.comRegs.xScale = xScale;
    raw_mode.comRegs.burst  = dummy_mode.comRegs.burst;
    raw_mode.comRegs.vSync  = dummy_mode.comRegs.vSync;
    raw_mode.comRegs.hSync  = dummy_mode.comRegs.hSync;
    raw_mode.comRegs.leap   = dummy_mode.comRegs.leap;
    for (int field = 0; field < 2; field++) {
        raw_mode.fldRegs[field].origin = 0; // raw VI_ORIGIN is the full scanout address (set via osViSwapBuffer)
        raw_mode.fldRegs[field].yScale = yScale;
        raw_mode.fldRegs[field].vStart = vStart;
        raw_mode.fldRegs[field].vBurst = dummy_mode.fldRegs[field].vBurst;
        raw_mode.fldRegs[field].vIntr  = dummy_mode.fldRegs[field].vIntr;
    }
    ViState* next_state = events_context.vi.get_next_state();
    next_state->mode = &raw_mode;
    next_state->control = control;
}

extern "C" void osViSetMode(RDRAM_ARG PTR(OSViMode) mode_) {
    std::lock_guard lock{ events_context.message_mutex };
    OSViMode* mode = TO_PTR(OSViMode, mode_);
    ViState* next_state = events_context.vi.get_next_state();
    next_state->mode = mode;
    next_state->control = next_state->mode->comRegs.ctrl;
    // [vistate 2026-08-25] HARDWARE CONTRACT: libultra's osViSetMode does `unk00 = 1` - a mode
    // set RESETS the whole VI state word, clearing black (0x20), repeat-line (0x40) and the
    // scale-special bits (0x2/0x4). We latched them forever, so a game that blanks during a
    // load (osViBlack(1)) and unblanks by SETTING A MODE - legal, and how libultra's own API
    // behaves - stayed black permanently. Verified against engine/references/libreultra
    // lib/src/osViSetMode.c (+ __osViSwapContext.c, where 0x20 zeroes hStart). Bit 0 is
    // libultra's mode-valid flag.
    next_state->state = 1;
    // [vimode] catch EVERY VI mode switch (uncapped, in the real handler). serrate (VI_CTRL bit 6
    // = 0x40) = interlaced/480i vs progressive/240p. If opening the Start menu flips this, the
    // 240p->480i theory for the see-through-walls glitch is confirmed.
    fprintf(stderr, "[vimode] osViSetMode ctrl=0x%08X width=%u serrate(480i)=%u\n",
        (unsigned)mode->comRegs.ctrl, (unsigned)mode->comRegs.width,
        (unsigned)((mode->comRegs.ctrl >> 6) & 1u));
    fflush(stderr);
}

#define OS_VI_GAMMA_ON          0x0001
#define OS_VI_GAMMA_OFF         0x0002
#define OS_VI_GAMMA_DITHER_ON   0x0004
#define OS_VI_GAMMA_DITHER_OFF  0x0008
#define OS_VI_DIVOT_ON          0x0010
#define OS_VI_DIVOT_OFF         0x0020
#define OS_VI_DITHER_FILTER_ON  0x0040
#define OS_VI_DITHER_FILTER_OFF 0x0080

extern "C" void osViSetSpecialFeatures(uint32_t func) {
    std::lock_guard lock{ events_context.message_mutex };
    ViState* next_state = events_context.vi.get_next_state();
    uint32_t* control_out = &next_state->control;
    if ((func & OS_VI_GAMMA_ON) != 0) {
        *control_out |= VI_CTRL_GAMMA_ON;
    }

    if ((func & OS_VI_GAMMA_OFF) != 0) {
        *control_out &= ~VI_CTRL_GAMMA_ON;
    }

    if ((func & OS_VI_GAMMA_DITHER_ON) != 0) {
        *control_out |= VI_CTRL_GAMMA_DITHER_ON;
    }

    if ((func & OS_VI_GAMMA_DITHER_OFF) != 0) {
        *control_out &= ~VI_CTRL_GAMMA_DITHER_ON;
    }

    if ((func & OS_VI_DIVOT_ON) != 0) {
        *control_out |= VI_CTRL_DIVOT_ON;
    }

    if ((func & OS_VI_DIVOT_OFF) != 0) {
        *control_out &= ~VI_CTRL_DIVOT_ON;
    }

    if ((func & OS_VI_DITHER_FILTER_ON) != 0) {
        *control_out |= VI_CTRL_DITHER_FILTER_ON;
        *control_out &= ~VI_CTRL_ANTIALIAS_MASK;
    }

    if ((func & OS_VI_DITHER_FILTER_OFF) != 0) {
        *control_out &= ~VI_CTRL_DITHER_FILTER_ON;
        *control_out |= next_state->mode->comRegs.ctrl & VI_CTRL_ANTIALIAS_MASK;
    }
}

extern "C" void osViBlack(uint8_t active) {
    std::lock_guard lock{ events_context.message_mutex };
    ViState* next_state = events_context.vi.get_next_state();
    uint32_t* state_out = &next_state->state;
    if (active) {
        *state_out |= VI_STATE_BLACK;
    } else {
        *state_out &= ~VI_STATE_BLACK;
    }
}

extern "C" void osViRepeatLine(uint8_t active) {
    std::lock_guard lock{ events_context.message_mutex };
    ViState* next_state = events_context.vi.get_next_state();
    uint32_t* state_out = &next_state->state;
    if (active) {
        *state_out |= VI_STATE_REPEATLINE;
    } else {
        *state_out &= ~VI_STATE_REPEATLINE;
    }
}

extern "C" void osViSetXScale(float scale) {
    // The game asks the VI to scan out the framebuffer horizontally scaled by `scale` (e.g. 0.5 = render
    // half-width, stretch to full). update_vi() turns this into VI_X_SCALE_REG and RT64's present honors it.
    events_context.vi.xScaleFactor = scale;
}

extern "C" void osViSetYScale(float scale) {
    events_context.vi.yScaleFactor = scale;
}

extern "C" PTR(void) osViGetNextFramebuffer() {
    return events_context.vi.get_next_state()->framebuffer;
}

extern "C" PTR(void) osViGetCurrentFramebuffer() {
    return events_context.vi.get_cur_state()->framebuffer;
}

// [taskbal] submission counter, paired with recomp_sp_status_task_done in mmio.cpp.
extern "C" void recomp_task_submitted_note();

void ultramodern::submit_rsp_task(RDRAM_ARG PTR(OSTask) task_) {
    OSTask* task = TO_PTR(OSTask, task_);

    { static int _t=0, _g=0; bool gfx=(task->t.type==M_GFXTASK);
      // [submit_task]/[dlpeek] cap. Default 8 shows only BOOT tasks -- useless for a wall that
      // appears minutes in, and a count sitting at 8 says nothing about what is submitted LATER
      // (KI Gold 2026-08-29: the boot DL is well-formed, which proves nothing about the freeze).
      // RECOMP_TASK_LOG_N raises it so the task stream can be read ACROSS the wall; 0 = unlimited.
      static const int _cap = []{ const char* e = getenv("RECOMP_TASK_LOG_N");
                                  return e ? atoi(e) : 8; }();
      bool _show = (_cap == 0) || (gfx ? (_g < _cap) : (_t < _cap));
      if (gfx) _g++; else _t++;
      if (_show) { fprintf(stderr,
        "[submit_task] #%d task=0x%08X type=%u ucode=0x%08X ucode_data=0x%08X data_ptr=0x%08X data_size=0x%X -> %s\n",
        (_t+_g), (uint32_t)task_, (unsigned)task->t.type, (unsigned)task->t.ucode, (unsigned)task->t.ucode_data,
        (unsigned)task->t.data_ptr, (unsigned)task->t.data_size,
        (gfx?"*** GFX/RT64 ***":"audio/run_task")); fflush(stderr);
        /* [dlpeek] The task fields can be perfectly correct while the DISPLAY LIST they point at is
         * not — and the list is what RT64 actually walks. Dump the first words at data_ptr so the
         * content is judged directly instead of inferred from the pointer. Both address forms index
         * the same RDRAM offset (low 24 bits), so this reads what RT64 reads either way. */
        if (gfx) {
            const uint32_t off = (uint32_t)task->t.data_ptr & 0x00FFFFFFu;
            fprintf(stderr, "[dlpeek] data_ptr=0x%08X (off 0x%06X) size=0x%X words:",
                    (unsigned)task->t.data_ptr, off, (unsigned)task->t.data_size);
            for (int w = 0; w < 8; w++) {
                const uint32_t a = off + (uint32_t)(w * 4);
                uint32_t v = (a + 4u <= 0x00800000u) ? *(uint32_t*)(rdram + a) : 0xDEADDEADu;
                fprintf(stderr, " %08X", v);
            }
            fprintf(stderr, "\n"); fflush(stderr);
        } } }

    // [taskbal] count every submission at the single ordered submission point (see mmio.cpp).
    recomp_task_submitted_note();
    // Serial-RSP: every submission takes a completion ticket here, in submission order (this is
    // the single ordered submission point — osSpTaskStartGo/raw-SP both funnel through it).
    uint64_t ticket = rsp_issue_ticket();

    // Send gfx tasks to the graphics action queue
    if (task->t.type == M_GFXTASK) {
        events_context.action_queue.enqueue(SpTaskAction{ *task, ticket });
    }
    // Set all other tasks as the RSP task. Snapshot the descriptor NOW — hardware semantics
    // (osSpTaskLoad DMAs it at task start; the game may rebuild the struct immediately after).
    else {
        events_context.sp_task_queue.enqueue({ *task, ticket, false });
    }
}

void ultramodern::send_si_message() {
    { static int _n=0; if (_n++ < 20) { fprintf(stderr, "[evtfire] SI-done -> mq=0x%08X\n", (uint32_t)events_context.si.mq); fflush(stderr); } }
    if (hle_event_lane_on())   // [lane-1 gate]
    ultramodern::enqueue_external_message_src(events_context.si.mq, events_context.si.msg, false, ultramodern::EventMessageSource::Si);
}

void ultramodern::send_pi_message() {
    // Fire the PI (cartridge DMA) done interrupt to the queue the game registered via
    // osSetEventMesg(OS_EVENT_PI, ...). Called by librecomp/pi.cpp after each cart→RDRAM DMA. If the
    // game never registered OS_EVENT_PI the queue is NULL and do_send drops it harmlessly.
    { static int _n=0; if (_n++ < 20) { fprintf(stderr, "[evtfire] PI-done -> mq=0x%08X\n", (uint32_t)events_context.pi.mq); fflush(stderr); } }
    if (hle_event_lane_on())   // [lane-1 gate]
    ultramodern::enqueue_external_message_src(events_context.pi.mq, events_context.pi.msg, false, ultramodern::EventMessageSource::Pi);
    if (recomp_baremetal_enabled()) recomp_baremetal_note_interrupt(0x10); // PI-done MI bit -> NC handler posts its PI event
}

void ultramodern::init_events(RDRAM_ARG ultramodern::renderer::WindowHandle window_handle) {
    moodycamel::LightweightSemaphore gfx_thread_ready;
    moodycamel::LightweightSemaphore task_thread_ready;
    events_context.rdram = rdram;
    events_context.sp.gfx_thread = std::thread{ gfx_thread_func, rdram, &gfx_thread_ready, window_handle };
    events_context.sp.task_thread = std::thread{ task_thread_func, rdram, &task_thread_ready };

    // Wait for the two sp threads to be ready before continuing to prevent the game from
    // running before we're able to handle RSP tasks.
    gfx_thread_ready.wait();
    task_thread_ready.wait();

    ultramodern::renderer::SetupResult setup_result = renderer_setup_result.load();
    if (setup_result != ultramodern::renderer::SetupResult::Success) {
        auto show_renderer_error = [](const std::string& msg) {
            std::string error_msg = "An error has been encountered on startup: " + msg;

            ultramodern::error_handling::message_box(error_msg.c_str());
        };

        const std::string driver_os_suffix = "\nPlease make sure your GPU drivers and your OS are up to date.";
        switch (setup_result) {
            case ultramodern::renderer::SetupResult::Success:
                break;
            case ultramodern::renderer::SetupResult::DynamicLibrariesNotFound:
                show_renderer_error("Failed to load dynamic libraries. Make sure the DLLs are next to the recomp executable.");
                break;
            case ultramodern::renderer::SetupResult::InvalidGraphicsAPI:
                show_renderer_error(ultramodern::renderer::get_graphics_api_name(renderer_chosen_api.load()) + " is not supported on this platform. Please select a different graphics API.");
                break;
            case ultramodern::renderer::SetupResult::GraphicsAPINotFound:
                show_renderer_error("Unable to initialize " + ultramodern::renderer::get_graphics_api_name(renderer_chosen_api.load()) + "." + driver_os_suffix);
                break;
            case ultramodern::renderer::SetupResult::GraphicsDeviceNotFound:
                show_renderer_error("Unable to find compatible graphics device." + driver_os_suffix);
                break;
        }
        throw std::runtime_error("Failed to initialize the renderer");
    }

    // Pre-initialize both VI states with the dummy mode so that update_vi() never
    // sees a null mode pointer.  When start_game() is called before start() (as in
    // cv64pc's main.cpp), is_game_started() is already true when the VI thread
    // launches, which prevents set_dummy_vi() from running in vi_thread_func.
    // Without this, update_vi() dereferences a null OSViMode* on its first call
    // and crashes at fldRegs[0] (offset 0x28 from a null OSViMode*).
    events_context.vi.states[0].mode = &dummy_mode;
    events_context.vi.states[1].mode = &dummy_mode;

    events_context.vi.thread = std::thread{ vi_thread_func };
}

void ultramodern::join_event_threads() {
    events_context.sp.gfx_thread.join();
    events_context.vi.thread.join();

    // Send a shutdown entry to indicate that the RSP task thread should exit.
    events_context.sp_task_queue.enqueue({ OSTask{}, 0, true });
    events_context.sp.task_thread.join();
}
