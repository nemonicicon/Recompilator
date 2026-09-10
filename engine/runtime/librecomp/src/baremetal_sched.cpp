// baremetal_sched.cpp — bare-metal cooperative-scheduler support (the "NC class").
//
// Some N64 titles are NOT libultra-HLE'd: they ship a handwritten exception handler plus a cooperative
// task scheduler that context-switches via the CPU `eret` instruction (restore a task's registers from its
// TCB, then `eret` to its saved EPC). A static recompiler turns every guest function into a C function, so an
// `eret` that resumes a YIELDED task at a mid-function PC *with its C call-stack intact* cannot be a plain
// call (cooperative re-entry would nest forever and overflow the C stack) nor a longjmp (that unwinds the
// stack we must preserve). The correct fit is a FIBER per task: the eret becomes a fiber switch, which keeps
// each task's C stack alive across yields, while the guest's own (recompiled) dispatcher restores the MIPS
// registers via the TCB. The two halves are complementary — the dispatcher carries the register file (ctx),
// the fiber carries the C stack.
//
// GENERAL mechanism; the only per-game DATUM is the address of the scheduler's "current task" pointer
// (NC: 0x800A36B0), supplied via env RECOMP_BAREMETAL_TASKPTR=0xADDR. Baseline (libultra-HLE) games never
// execute a guest `eret`, so recomp_eret is never called and this file is completely inert for them.
//
// Threading (layer C): interrupt delivery runs the guest handler on the VI HOST thread (mmio.cpp), but fibers
// are thread-affine, so a context switch must NOT happen there — the handler only needs to POST its event and
// return; the game thread reschedules. recomp_baremetal_enter/exit_interrupt() bracket that delivery so
// recomp_eret no-ops on the host thread.

#include <cstdint>
#include <cstdlib>
#include <cstdio>
#include <atomic>
#include <chrono>
#include <thread>
#include <unordered_map>

#ifdef _WIN32
#include <Windows.h>

// ── INSTRUMENTS ARE OFF UNLESS ASKED FOR ────────────────────────────────────────────────────────
// THE RULE: an environment gate is a game-specific hack by another name. That applies to
// BEHAVIOUR; the same law says ENV VARS ARE INSTRUMENTS. These are instruments, and they were not
// gated at all: a 20-second run of Turok 1 on 2026-09-08 wrote 20,225 lines from eight of them, to
// a file, unasked. That slows every shipped game, fills a user's disk, and breaks the project's own
// rule that an eyes verdict needs a clean run with all instruments off. Cached is pointless here -
// the call only happens when a rate limiter has already decided to print.
static bool rc_trace_on(const char* var) {
    const char* v = std::getenv(var);
    return v != nullptr && v[0] != '\0' && v[0] != '0';
}
#endif

struct recomp_context;
typedef void (recomp_func_t)(uint8_t* rdram, recomp_context* ctx);

extern "C" uint32_t recomp_cop0_tlb_read(int reg);
extern "C" void recomp_baremetal_compare_write(uint32_t value);   // deadline waiter (defined below)
extern "C" void recomp_baremetal_ip7_latch_now(void);             // immediate latch+poke (defined below)
extern "C" recomp_func_t* recomp_lookup_native(uint32_t addr);
extern "C" void recomp_interpret(uint8_t* rdram, recomp_context* ctx, uint32_t start_vaddr);

extern "C" void recomp_cop0_tlb_write(int reg, uint32_t value);
extern "C" void recomp_set_pending_mi_intr(uint32_t v);
extern "C" void recomp_present_mi_intr(uint32_t v);
extern "C" void cop0_status_write(recomp_context* ctx, uint64_t value);
extern "C" uint64_t cop0_status_read(recomp_context* ctx);
// Per-fiber register files (recomp.cpp owns the type details incl. the f_odd fixup).
extern "C" recomp_context* bm_ctx_alloc(void);
extern "C" void bm_ctx_copy(recomp_context* dst, const recomp_context* src);

// ── per-game gating (read once from the environment) ──────────────────────────────────────────────
static bool     g_init       = false;
static bool     g_enabled    = false;
static uint32_t g_taskptr    = 0;       // guest address of the scheduler's "current task" pointer
// [dispatch-window 2026-08-28] The learn-2 scan below already IDENTIFIES the guest dispatcher (an
// eret preceded by >=6 `ld $reg,off($k0)` TCB restores) but threw its address range away. That
// range is the missing discriminator for the EPC-poison class: the dispatcher runs with
// interrupts off precisely so it cannot be interrupted, so a pc inside it is NEVER a legal
// interrupted pc on hardware. Learned, never hardcoded.
static uint32_t g_disp_lo    = 0;       // guest dispatcher context-restore window, low  (vaddr)
static uint32_t g_disp_hi    = 0;       // ... high (exclusive)
extern "C" int recomp_tlb_is_mapped(uint32_t vaddr, uint32_t* phys_out);   // tlb.cpp (also declared at the raise site)
// [dispatch-window SEGMENT FIX 2026-09-06, Shadow Man #118] The window above is ALWAYS recorded as a
// KSEG0 vaddr: learn-2 scans RDRAM PHYSICALLY and builds `0x80000000 + phys`, and the interpreted-eret
// learn accepts only `(va>>28)==8`. But an Acclaim/Iguana kernel is LINKED INTO A TLB-MAPPED KUSEG
// WINDOW and executes there: Shadow Man maps VA 0x00100000 -> phys 0 with one 1 MB entry and its
// dispatcher eret lives at VA 0x00118218 (phys 0x18218, learned as 0x80018218); Turok 2 / South Park /
// Armorines / Turok 3 / Rage Wars all map VA 0x00200000 -> phys 0 the same way. Comparing RAW vaddrs
// therefore returns false for every pc in exactly the class of kernel this guard was written for, so
// the EPC poison the guard exists to prevent happens anyway - measured on Shadow Man: the mask-poll
// venue latched EPC = the dispatcher's own eret, the guest canonized it into TCB 0x80110630, and every
// dispatch of that TCB eretted straight back (4.5 M self-redispatches, guest instructions retired
// FROZEN at 276,949, handler entries frozen at 3) - the 08-28 EPC-poison closed loop verbatim.
// Compare in the PHYSICAL domain, and only through a VALID mapping: recomp_tlb_translate flat-maps
// misses, so an unmapped KUSEG pc must keep the old answer rather than invent a match. KSEG0/KSEG1
// pcs are fully answered by the raw test, so every non-TLB title is bit-identical to before.
static inline bool bm_pc_in_dispatch(uint32_t pc) {
    if (g_disp_hi == 0u) return false;
    if (pc >= g_disp_lo && pc < g_disp_hi) return true;
    if ((pc & 0xC0000000u) == 0x80000000u) return false;   // KSEG0/1: the raw test above is the answer
    uint32_t _dphys = 0;
    if (!recomp_tlb_is_mapped(pc, &_dphys)) return false;  // no valid mapping -> make no claim
    return (_dphys >= (g_disp_lo & 0x1FFFFFFFu)) && (_dphys < (g_disp_hi & 0x1FFFFFFFu));
}
static uint32_t g_handler    = 0;       // guest exception-handler entry (NC_IRQ), run on the game-thread idle
static uint32_t g_cause      = 0x400;   // Cause IP bits the handler dispatches on (NC_IRQ_CAUSE)
// [hverify-direct 2026-08-26] The guest kernel's own ISR post routine, registered by the GAME
// (which links the emission and can name the symbol; the engine cannot — SOTE's poster
// static_6_800C3D08 is not in the overlay func table, and resolving its vaddr at runtime would
// interpret the STOMPED live bytes). Generalization of NC_EVENT_POSTER: when the handler's code
// region is gone but its service table survives, delivery = call the poster with a0 = code*8.
static recomp_func_t* g_svc_poster = nullptr;
static uint32_t       g_svc_table  = 0x80193690u;   // SOTE kernel service table (July decode)
extern "C" void recomp_ack_mi_intr(uint32_t bits);   // mmio.cpp: clear MI level bits on delivery
extern "C" void recomp_icache_ghost_arm(uint8_t* rdram, uint32_t lo, uint32_t hi);   // recomp_interp.cpp: [icache-ghost]
extern "C" void recomp_icache_ghost_sync_all(uint8_t* rdram);                  // recomp_interp.cpp: [wave-settle]
extern "C" int  recomp_icache_ghost_covers(uint32_t vaddr);                  // recomp_interp.cpp: [icache-ghost]
extern "C" int recomp_pi_complete_on_arm(void);   // pi.cpp: [pi-arm] completion-on-arm
extern "C" void recomp_interp_ring_dump(const char* reason);   // recomp_interp.cpp: dump the armed pc ring
extern "C" void recomp_baremetal_set_svc_poster(recomp_func_t* f, uint32_t table_vaddr) {
    g_svc_poster = f;
    if (table_vaddr != 0u) g_svc_table = table_vaddr;
}
static uint32_t g_direct_wakee = 0;
static std::atomic<int> g_wave_active{0};   // [pi-pace v2] first ghost-delivery = the swap wave is live
static void bm_world_reset(void);           // [world-reset 08-27] defined below the fiber globals
static bool g_wave_fresh = true;            // [world-reset] true at boot and after each wave-settle:
                                            // the next ghost-delivery is a NEW transition's first
extern "C" int recomp_bm_wave_active() { return g_wave_active.load(std::memory_order_relaxed); }   // [frame-tick] TCB the direct lane just woke; the resume path dispatches it first
void* g_game_thread_handle = nullptr;   // [rip-sample] duplicated real handle of the game thread
std::atomic<uint64_t> g_idle_entries{0};   // [pump-pulse] counts every idle/drain attempt
uint32_t g_park_ring[16][2] = {};   // [park-ring] (tcb, live_pc) at each yield-to-root (unconditional scope: the dump compiles on every platform)
uint32_t g_park_ring_n = 0;
static std::atomic<uint32_t> g_pending_mi_bits{0};  // accumulated MI_INTR source bits (VI=8 SP=1 DP=0x20 ...)
// [poll-lane MI level-honesty 2026-08-06] Hardware MI_INTR is a LEVEL register: every pending
// source line shows in a guest READ regardless of mask or delivery. Our notes accumulated here
// were invisible to mmio's MI_INTR read, so a POLL-DRIVEN kernel (EA keeps &MI regs in k0;
// turok's Iguana kernel shows the same shape) could never see a VI it hadn't been HANDED —
// same family as e8de01b's PI level-presentation. mmio.cpp ORs these into the read and the
// device ACK writes clear them (VI_CURRENT write clears bit 8, etc).
extern "C" uint32_t recomp_baremetal_noted_mi(void) { return g_pending_mi_bits.load(std::memory_order_relaxed); }
extern "C" void recomp_baremetal_ack_noted_mi(uint32_t bits) { g_pending_mi_bits.fetch_and(~bits, std::memory_order_relaxed); }
static std::atomic<int>      g_pending_intr{0};     // count of RCP interrupts the game-thread idle must drain
static uint8_t*        g_rdram = nullptr;   // captured on the first eret (same for every fiber)
static recomp_context* g_ctx   = nullptr;
static void*           g_idle_fiber = nullptr; // the fiber running the handler-drain; recomp_eret returns here on a dead-end pick

// ── DIRECT EVENT POST (NC class, baseline-safe) ───────────────────────────────────────────────────
// NC's RCP interrupts must post their event INTO the game's OWN OSMesgQueue ring AND run NC's OWN
// wait-list wake (dequeue the blocked TCB from the queue's wait-list and re-add it to the run queue).
// The HLE message system can deliver the message into the ring (validCount++) but it CANNOT run NC's
// bare-metal wake — so a boot thread blocked in NC's `osRecvMesg` (func_80081AC0) sees the message but
// is never re-scheduled to consume it, and re-blocks forever (the PI-DMA-completion hang).
//
// NC's exception handler already has the correct routine: func_80080D7C(arg) reads the event->queue
// table at D_8012D600 + arg, posts the event's message into that queue (msg[(first+validCount)%count],
// validCount++), THEN dequeues the queue's blocked TCB (func_80080FBC) and re-adds it to the run queue
// (func_80080F74). That is exactly the HW-faithful delivery. The un-named MI-dispatch chain that *would*
// call it (func_80080808 -> per-source func -> func_80080D7C) is not reliably reachable from the engine
// (it derails into the interpreter after the source-register clear), so we call func_80080D7C DIRECTLY
// from the game-thread idle with the per-source arg, bypassing the fragile dispatch.
//
// GENERAL mechanism; the per-game DATA (poster address + per-source args) come from env so this stays
// game-agnostic. Gated on the NC handler being configured (g_handler != 0) AND the poster being set ->
// baseline libultra-HLE games never set these, never run a guest eret, and are byte-for-byte unaffected.
static uint32_t g_event_poster = 0;     // guest addr of NC's func_80080D7C(arg) event poster
static uint32_t g_arg_pi  = 0x40;       // func_80080D7C arg for OS_EVENT_PI (NC: 0x40)
static uint32_t g_arg_sp  = 0x38;       // SP/gfx-done (NC: 0x38)
static uint32_t g_arg_dp  = 0x48;       // DP-done (NC: 0x48)

// Wait-list wake (the piece HLE delivery cannot do): NC's osRecvMesg (bare-metal) registers the blocking
// TCB on the queue's wait-list (queue+0x0) and removes it from the run queue. The completion delivery must
// dequeue that waiter and re-insert it into the run queue, or the boot thread that osRecvMesg-waits a PI
// (overlay-load) completion is never rescheduled to re-poll the message and hangs. NC's own primitives:
//   func_80080FBC(queue)  -> returns the wait-list's head TCB (*(*(queue+0)+0))    [NC: 0x80080FBC]
//   func_80080F74(runq, tcb) -> priority-insert tcb into the run queue at D_800A36A8 [NC: 0x80080F74]
// We call them natively from the game-thread idle on the queue osPiStartDma was told to signal.
static uint32_t g_wl_dequeue = 0;       // NC func_80080FBC
static uint32_t g_rq_insert  = 0;       // NC func_80080F74
static uint32_t g_runq_head  = 0x800A36A8u; // NC run-queue head pointer (D_800A36A8)
static std::atomic<uint32_t> g_pi_mq{0};    // the guest queue a bare-metal osPiStartDma is waiting on
static std::atomic<uint32_t> g_si_mq{0};    // the guest queue a bare-metal osContStartReadData is waiting on
extern "C" void recomp_baremetal_note_pi_mq(uint32_t mq) { if (mq) g_pi_mq.store(mq, std::memory_order_relaxed); }
extern "C" void recomp_baremetal_note_si_mq(uint32_t mq) { if (mq) g_si_mq.store(mq, std::memory_order_relaxed); }

// ── RCP-completion delivery for queues NC registered in its OWN event table (raw-SI / SP / DP) ─────
// Unlike PI (the game passes its mq to osPiStartDma) and HLE controller reads (the game passes its mq
// to osContStartReadData), three completion sources have NO mq the engine can capture from a guest call:
//   • RAW-SI: NC drives the SI registers directly (si.cpp), so there is no osContStartReadData mq — NC
//     instead registered its SI/controller queue in its OWN event-dispatch table at D_8012D600+0x28.
//   • SP-done / DP-done (gfx task completion): the renderer host thread fires these (events.cpp); NC's
//     SP/DP queues live at D_8012D600+0x38 / +0x48 (they materialize only AFTER osCreateScheduler runs).
// For all three, the host thread that observes the completion only RAISES a pending flag; the game-thread
// idle resolves the actual guest queue from NC's event table and runs nc_deliver_and_wake (delivery on the
// game thread keeps the run-queue mutation single-threaded, same invariant as the PI/SI HLE path). General
// mechanism; the per-source event-table args come from env, default to NC's. Inert unless bare-metal.
static const uint32_t NC_EVTAB_BASE = 0x8012D600u;        // NC event-dispatch table base (D_8012D600)
static std::atomic<int> g_rawsi_pending{0};               // raw-SI PIF read completed (si.cpp), deliver on idle
static std::atomic<int> g_sp_pending{0};                  // SP-done (gfx) completed (events.cpp), deliver on idle
static std::atomic<int> g_dp_pending{0};                  // DP-done (gfx) completed (events.cpp), deliver on idle
// Each note also bumps g_pending_intr so the game-thread idle is guaranteed to run its drain (raw-SI has no
// MI-bit trigger of its own; SP/DP already bump via note_interrupt, the extra bump is harmless/idempotent).
extern "C" void recomp_baremetal_note_rawsi() { g_rawsi_pending.store(1, std::memory_order_relaxed); g_pending_intr.fetch_add(1, std::memory_order_relaxed); }
extern "C" void recomp_baremetal_note_sp()    { g_sp_pending.store(1, std::memory_order_relaxed);    g_pending_intr.fetch_add(1, std::memory_order_relaxed); }
extern "C" void recomp_baremetal_note_dp()    { g_dp_pending.store(1, std::memory_order_relaxed);    g_pending_intr.fetch_add(1, std::memory_order_relaxed); }

// VI-retrace delivery for NC's gfx scheduler. The VI host thread "sends" each retrace to the scheduler's
// queue (e.g. 0x80104940) via the HLE enqueue, but that never lands in NC's ring nor runs NC's wait-list
// wake — so NC's scheduler TCB (blocked in osRecvMesg on its VI queue) never wakes per-frame and never
// submits the gfx task. Capture the VI queue the game registered (we DO have the mq here, unlike SP/DP)
// and deliver+wake on the game-thread idle, same as PI/SI. Idempotent ring-fill (only when empty) means a
// missed-frame just waits for the next retrace. NC-only (g_handler set); inert for HLE titles.
static std::atomic<uint32_t> g_vi_mq{0};
static std::atomic<uint32_t> g_vi_msg{0};   // the msg value the scheduler expects (OS_SC_RETRACE_MSG etc.)
extern "C" void recomp_baremetal_note_vi_mq(uint32_t mq, uint32_t msg) { if (mq) { g_vi_mq.store(mq, std::memory_order_relaxed); g_vi_msg.store(msg, std::memory_order_relaxed); g_pending_intr.fetch_add(1, std::memory_order_relaxed); } }

// ── HIGH-HALF TRUNCATION REPAIR (NC class, baseline-safe) ─────────────────────────────────────────
// Nightmare Creatures' cooperative scheduler suffers a deterministic engine-level HIGH-HALF TRUNCATION of
// a TCB pointer: a KSEG0 pointer like 0x800BF090 is observed as 0x0001F090 (low 16 bits 0xF090 intact,
// high 16 bits 0x800B clipped to 0x0001). The static trace proved no guest store truncates (every write of
// the run-queue / current-task / wait-list pointers is a full-word `sw`); the tear is in the shared
// recomp_context across the fiber/native-handler switch. The truncated pointer lands not only in the
// current-task word (0x800A36B0) but ALSO in the scheduler's run-queue node chain and the message-queue
// wait-lists the native handler walks — so repairing only the current-task word still lets the handler
// dereference a torn `next` pointer and wild-read. We track the last KSEG0-valid high half (always 0x800B
// for this game's TCB arena) and SCRUB the truncation signature out of the tight scheduler data region
// before the native handler runs, so the dispatcher walks clean pointers. ALL of this is gated on the NC
// handler being configured (g_handler != 0, i.e. NC_IRQ set) -> baseline libultra-HLE games never set
// NC_IRQ, never run a bare-metal handler, and are byte-for-byte unaffected.
static uint32_t g_tcb_hi = 0;   // last KSEG0-valid current-task-pointer high half (e.g. 0x800B0000)

// Repair one 32-bit word in place if it carries the truncation signature: top nibble 0, non-zero low half,
// and a known-good high half is available. Returns true if it repaired. Conservative: only fixes 0x0001xxxx
// style values back to (g_tcb_hi | low16); leaves everything else untouched.
static inline bool nc_repair_word(uint32_t* w) {
    uint32_t v = *w;
    if (g_tcb_hi == 0) return false;
    if ((v >> 28) == 0x8u) return false;                 // already a valid KSEG0 pointer
    if (v == 0u) return false;                           // clean null
    if ((v & 0xFFFF0000u) != 0x00010000u) return false;  // only the observed 0x0001xxxx truncation pattern
    uint32_t fixed = g_tcb_hi | (v & 0xFFFFu);
    if ((fixed >> 28) != 0x8u) return false;
    *w = fixed;
    return true;
}

// Walk an intrusive singly-linked TCB list from `head`, repairing torn `next` links (node+0x0). Bounded
// against cycles / wild pointers. The list `next` is at offset 0; a node==its-own-next is the tail sentinel.
static void nc_scrub_chain(uint8_t* rdram, uint32_t head) {
    uint32_t cur = head;
    for (int hops = 0; hops < 64; ++hops) {
        if ((cur >> 28) != 0x8u) break;                  // not a valid node pointer; stop
        uint32_t phys = cur & 0x1FFFFFFFu;
        if (phys + 8u > 0x00800000u) break;              // out of installed RDRAM; stop
        uint32_t* nextp = (uint32_t*)(rdram + phys + 0u);
        if (nc_repair_word(nextp)) {
            static int _sn = 0;
            if (++_sn <= 50) { fprintf(stderr, "[bmsched][SCRUB] repaired next @node 0x%08X -> 0x%08X\n", cur, *nextp); fflush(stderr); }
        }
        uint32_t next = *nextp;
        if (next == cur) break;                          // self-loop sentinel (list tail)
        cur = next;
    }
}

// Scrub the truncation signature out of the scheduler's run-queue + current-task pointer + the linked-list
// `next` chain the dispatcher walks. The run-queue is an intrusive singly-linked list of TCB nodes whose
// `next` pointer is at node+0x0 and priority at node+0x4 (matches func_80080F74's `lw next,0x0` / `lw pri,0x4`).
// A torn `next` (0x0001xxxx) anywhere in the chain wild-reads when walked, so we follow the chain from the
// head at 0x800A36A8 and repair each torn link, bounded against cycles. Also fixes the current-task word.
// The run-queue is headed by a sentinel node at guest 0x800A36A0 (the header struct that precedes the
// 0x36A8 head-pointer word). An EMPTY queue's head pointer (0x36A8) == the sentinel address 0x800A36A0.
// A corrupted dequeue can leave the head as 0xFFFFFFFF (-1) — reset it to the sentinel so the walk
// terminates cleanly instead of dereferencing -1.
static const uint32_t NC_RQ_SENTINEL = 0x800A36A0u;

// ── live-runnable-TCB census (orphan-recovery, NC-only) ───────────────────────────────────────────
// Root cause of the "audio plays but no gfx task" freeze: NC's exception/dispatch handler (func_80080808
// region) is NOT recompiled native, so the game-thread idle runs it in the INTERPRETER. When the
// interpreted dispatcher reaches its `eret`, recomp_eret performs the fiber switch and ENDS the interp
// session mid-flight — tearing the dispatcher's run-queue dequeue so the head is left as 0xFFFFFFFF.
// The old scrub then reset that wild head to the EMPTY sentinel, which silently ORPHANED the two TCBs
// that were enqueued at the tear (the game thread 0x800BFA40 and the gfx-scheduler thread 0x801049B0).
// After that, neither ever runs again → the frame pump dies → no type=1 gfx task is ever built.
//
// FIX: remember every TCB we have ever dispatched (its last-seen guest pointer). When the scrub is about
// to reset a torn run-queue head to empty, FIRST re-insert the runnable census members (KSEG0-valid, not
// the currently-running fiber, not the idle/boot thread) back into the run queue via NC's OWN priority
// insert (func_80080F74 = g_rq_insert) — the same call the wake path uses. This re-arms the scheduler so
// the render threads are rescheduled instead of lost. Gated on g_handler (NC_IRQ) → inert for HLE titles.
static std::unordered_map<uint32_t, int> g_seen_tcbs;   // dispatched TCB -> dummy; the live thread census
static uint32_t g_current_tcb = 0;                      // the TCB whose fiber is currently running
static const uint32_t NC_IDLE_TCB = 0x800BF090u;        // boot/idle thread — never re-insert this one
// Set by orphan recovery (a FATAL run-queue tear: head -> 0xFFFFFFFF, NOT the repairable 0x0001xxxx high-half
// pattern). After such a tear the SCRUB pins the current-task word back to the idle thread, and the idle loop
// keeps re-running the handler which sees current==idle and never switches — the scheduler FREEZES with the
// game/scheduler threads stranded on the rebuilt run queue (audio keeps playing on the last scheduler state,
// but no fiber ever advances). This flag tells the idle to FORCE a re-dispatch to the highest-priority
// re-inserted TCB once the handler returns without having switched. NC-only (g_handler gates it).
static std::atomic<bool> g_orphan_redispatch{false};

// Defined after the fiber machinery (below, _WIN32 only). Called from the idle drain when
// g_orphan_redispatch is set: pick the highest-priority TCB on the rebuilt run queue and switch to its
// fiber, mirroring recomp_eret's tail. Returns true if it switched (the scheduler resumed). NC-only.
#ifdef _WIN32
static bool nc_force_redispatch(uint8_t* rdram);
#else
static bool nc_force_redispatch(uint8_t*) { return false; }
#endif

// Is `tcb` currently blocked on some message-queue wait-list? Scan NC's event-dispatch table (0x80126600,
// same span the scrub walks) and each registered queue's wait-list chain (head at queue+0x0, next at
// node+0x0). A thread found there is cooperatively blocked in osRecvMesg and must be woken by its event,
// NOT re-inserted into the run queue. Bounded against cycles/wild pointers. Returns true if found blocked.
static bool nc_tcb_on_any_waitlist(uint8_t* rdram, uint32_t tcb) {
    if ((tcb >> 28) != 0x8u) return false;
    for (uint32_t i = 0; i < 0x100u; i += 4u) {
        uint32_t qptr = *(uint32_t*)(rdram + (0x00126600u + i));
        if ((qptr >> 28) != 0x8u) continue;
        uint32_t qphys = qptr & 0x1FFFFFFFu;
        if (qphys + 4u > 0x00800000u) continue;
        uint32_t node = *(uint32_t*)(rdram + qphys + 0u);    // wait-list head
        for (int hops = 0; hops < 64; ++hops) {
            if ((node >> 28) != 0x8u) break;
            if (node == tcb) return true;
            uint32_t nphys = node & 0x1FFFFFFFu;
            if (nphys + 4u > 0x00800000u) break;
            uint32_t next = *(uint32_t*)(rdram + nphys + 0u);
            if (next == node) break;
            node = next;
        }
    }
    return false;
}

// Re-insert one TCB into NC's run queue via func_80080F74(runq_head, tcb). Mirrors nc_deliver_and_wake's
// invocation exactly (saves/restores the shared GPR window, $ra=0 so the routine's `jr $ra` returns clean).
static bool nc_runq_insert_tcb(uint8_t* rdram, uint32_t tcb) {
    if (g_rq_insert == 0 || g_ctx == nullptr) return false;
    if ((tcb >> 28) != 0x8u) return false;
    recomp_func_t* fri = recomp_lookup_native(g_rq_insert);
    if (!fri) return false;
    // Skip if it's already linked into the run queue (its node+0x0 next is a KSEG0 ptr or the sentinel and
    // the head chain reaches it). Cheap guard: don't double-insert the node that is already the head.
    uint64_t* gpr = reinterpret_cast<uint64_t*>(g_ctx);
    uint64_t saved[32]; for (int i = 0; i < 32; ++i) saved[i] = gpr[i];
    gpr[4] = (uint64_t)(int64_t)(int32_t)g_runq_head;            // $a0 = run-queue head (sentinel)
    gpr[5] = (uint64_t)(int64_t)(int32_t)tcb;                    // $a1 = TCB to insert
    gpr[31] = 0;                                                 // jr $ra -> clean return via noop stub
    fri(rdram, g_ctx);
    for (int i = 0; i < 32; ++i) gpr[i] = saved[i];
    return true;
}

static void nc_scrub_scheduler_region(uint8_t* rdram) {
    if (g_tcb_hi == 0) return;
    // (pre) repair a wild run-queue head (0xFFFFFFFF / non-KSEG0) back to the empty-queue sentinel.
    {
        uint32_t* headw = (uint32_t*)(rdram + 0x000A36A8u);
        if ((*headw >> 28) != 0x8u) {
            if (!nc_repair_word(headw)) {                // not the 0x0001xxxx pattern -> reset to sentinel
                static int _hr = 0;
                if (++_hr <= 50) { fprintf(stderr, "[bmsched][SCRUB] wild run-queue head 0x%08X -> sentinel 0x%08X\n", *headw, NC_RQ_SENTINEL); fflush(stderr); }
                *headw = NC_RQ_SENTINEL;
                // ── ORPHAN RECOVERY ───────────────────────────────────────────────────────────────────
                // The torn dequeue just lost whatever runnable TCBs were enqueued. Re-insert the live
                // census members so the scheduler reschedules them (NC-only; g_handler gates the whole
                // mechanism). Re-insert in census order; func_80080F74 priority-sorts them into place.
                if (g_handler != 0 && g_rq_insert != 0) {
                    // Re-insert ONLY a TCB that is NOT currently blocked on some queue's wait-list. A
                    // cooperatively-blocked thread (osRecvMesg) lives on its queue's wait-list and must be
                    // woken by its event — putting it on the run queue would make the dispatcher run it with
                    // a stale "waiting" state. The thread(s) torn out of the run queue at the dequeue are the
                    // ones that were RUNNABLE (not on any wait-list); re-insert exactly those.
                    uint32_t reinserted = 0;
                    for (auto& kv : g_seen_tcbs) {
                        uint32_t tcb = kv.first;
                        if ((tcb >> 28) != 0x8u) continue;       // not a valid pointer
                        if (tcb == NC_IDLE_TCB) continue;        // never re-arm the idle/boot thread
                        if (tcb == g_current_tcb) continue;      // the running fiber is not on the run queue
                        if (nc_tcb_on_any_waitlist(rdram, tcb)) continue;  // legitimately blocked -> leave it
                        if (nc_runq_insert_tcb(rdram, tcb)) reinserted++;
                    }
                    static int _or = 0;
                    if (++_or <= 50) {
                        fprintf(stderr, "[bmsched][ORPHAN] re-inserted %u runnable (non-blocked) TCB(s) after torn run-queue head (current=0x%08X)\n", reinserted, g_current_tcb);
                        fflush(stderr);
                    }
                    // FATAL-tear recovery: a torn dequeue stranded the runnable threads. The handler that
                    // resumes from here will see the current-task word pinned to the idle thread (the SCRUB
                    // below repairs it to whatever was last valid, which after this tear is the idle) and will
                    // NOT switch — so flag the idle to force a re-dispatch to the rebuilt run-queue head once
                    // the handler returns. Without this the cooperative scheduler freezes permanently.
                    if (reinserted > 0) g_orphan_redispatch.store(true, std::memory_order_relaxed);
                }
            }
        }
    }
    // ── one-shot DUMP of the run-queue chain (raw, BEFORE any repair) so we can see the exact torn node.
    {
        static int _dumped = 0;
        if (_dumped < 4) {
            _dumped++;
            uint32_t head = *(uint32_t*)(rdram + 0x000A36A8u);
            fprintf(stderr, "[bmsched][RQDUMP] head(0x36A8)=0x%08X tail(0x36AC)=0x%08X cur(0x36B0)=0x%08X\n",
                    head, *(uint32_t*)(rdram + 0x000A36ACu), *(uint32_t*)(rdram + 0x000A36B0u));
            uint32_t cur = head;
            for (int i = 0; i < 16; ++i) {
                if ((cur >> 28) != 0x8u) { fprintf(stderr, "[bmsched][RQDUMP]   node[%d]=0x%08X (NON-KSEG0, stop)\n", i, cur); break; }
                uint32_t phys = cur & 0x1FFFFFFFu;
                if (phys + 8u > 0x00800000u) { fprintf(stderr, "[bmsched][RQDUMP]   node[%d]=0x%08X (OOB, stop)\n", i, cur); break; }
                uint32_t nxt = *(uint32_t*)(rdram + phys + 0u);
                uint32_t pri = *(uint32_t*)(rdram + phys + 4u);
                fprintf(stderr, "[bmsched][RQDUMP]   node[%d]=0x%08X next=0x%08X pri=0x%08X\n", i, cur, nxt, pri);
                if (nxt == cur) break;
                cur = nxt;
            }
            fflush(stderr);
        }
    }
    // (a) current-task word + the run-queue head/tail node pointers.
    static const uint32_t kSlots[] = { 0x000A36A8u, 0x000A36ACu, 0x000A36B0u, 0x000A36B4u };
    for (uint32_t off : kSlots) {
        uint32_t* w = (uint32_t*)(rdram + off);
        if (nc_repair_word(w)) {
            static int _sc = 0;
            if (++_sc <= 50) { fprintf(stderr, "[bmsched][SCRUB] repaired sched word @0x%08X -> 0x%08X\n", 0x80000000u | off, *w); fflush(stderr); }
        }
    }
    // (b) walk the run-queue `next` chain from the head node, repairing torn links. Bounded to 64 hops.
    nc_scrub_chain(rdram, *(uint32_t*)(rdram + 0x000A36A8u));
    // (c) the wake path (func_80080D7C) dequeues a woken thread from a MESSAGE-QUEUE wait-list and enqueues it
    // into the run-queue; if THAT TCB was stored torn while the main thread blocked, the enqueue walk wild-reads.
    // The event->queue pointer table lives at guest 0x80126600 (0x80130000-0x2A00), indexed by event slot. Walk
    // a generous span of it, and for each queue scrub its wait-list head (queue+0x0) + that list's `next` chain.
    for (uint32_t i = 0; i < 0x100u; i += 4u) {          // up to 64 event slots
        uint32_t qptr = *(uint32_t*)(rdram + (0x00126600u + i));
        if ((qptr >> 28) != 0x8u) continue;
        uint32_t qphys = qptr & 0x1FFFFFFFu;
        if (qphys + 4u > 0x00800000u) continue;
        uint32_t* headp = (uint32_t*)(rdram + qphys + 0u); // wait-list head
        if (nc_repair_word(headp)) {
            static int _sq = 0;
            if (++_sq <= 50) { fprintf(stderr, "[bmsched][SCRUB] repaired waitlist head @queue 0x%08X -> 0x%08X\n", qptr, *headp); fflush(stderr); }
        }
        nc_scrub_chain(rdram, *headp);                   // and the wait-list chain
    }
}

// AUTO-BAREMETAL (worklist #8, 2026-07-01): distinguish the LEGACY EXPLICIT path (NC_IRQ env = the
// hand-configured Nightmare Creatures class, with all its game-specific compensation machinery)
// from the AUTO path (stock-libultra unmatched games, armed at their first guest eret when the
// rawirq-auto conditions hold). Every NC-specific compensation (scrub, high-half repair, orphan
// redispatch, direct-delivery, EVTAB dump) is gated on g_nc_mode so auto-armed games never get
// NC addresses poked into their RDRAM.
static bool g_nc_mode = false;                 // NC_IRQ env present = legacy explicit configuration
static bool g_autobm  = false;                 // armed automatically (stock-libultra unmatched class)
static std::atomic<bool> g_eret_seen{false};   // any guest eret observed (raw-MMIO ports never eret)

static void lazy_init() {
    if (g_init) return;
    g_init = true;
    const char* e = std::getenv("RECOMP_BAREMETAL_TASKPTR");
    if (e && *e) {
        g_taskptr = (uint32_t)strtoul(e, nullptr, 0);
#ifdef _WIN32
        g_enabled = (g_taskptr != 0);
#else
        // Do NOT arm off-Windows. try_autoarm already refuses here for the stated reason
        // ("fibers are Win32-only; arming would blackhole interrupts") — but this ENV path had no
        // such guard, so RECOMP_BAREMETAL_TASKPTR could arm a scheduler whose entire dispatch body
        // is #ifdef'd out. The consequence is worse than not arming: recomp_deliver_rcp_interrupt
        // short-circuits into note_interrupt and returns (mmio.cpp), disabling host-thread raw
        // delivery, while every guest eret becomes a no-op — so interrupts are noted and NEVER
        // drained and nothing ever context-switches. Keep g_taskptr for diagnostics; stay disabled.
        fprintf(stderr, "[bmsched] RECOMP_BAREMETAL_TASKPTR ignored: fibers are Win32-only\n");
        fflush(stderr);
#endif
    }
    const char* h = std::getenv("NC_IRQ");       if (h && *h) { g_handler = (uint32_t)strtoul(h, nullptr, 0); g_nc_mode = true; }
    const char* c = std::getenv("NC_IRQ_CAUSE"); if (c && *c) g_cause   = (uint32_t)strtoul(c, nullptr, 0);
    // Direct event-poster (NC func_80080D7C) + per-source args. NC_EVENT_POSTER set => the idle posts
    // RCP events into the guest ring via NC's own routine (message + wait-list wake), instead of relying
    // on the un-named MI-dispatch chain that derails. Default poster for NC is 0x80080D7C.
    const char* ep = std::getenv("NC_EVENT_POSTER"); if (ep && *ep) g_event_poster = (uint32_t)strtoul(ep, nullptr, 0);
    else if (g_handler != 0) g_event_poster = 0x80080D7Cu;   // NC default when the bare-metal handler is configured
    const char* ap = std::getenv("NC_ARG_PI"); if (ap && *ap) g_arg_pi = (uint32_t)strtoul(ap, nullptr, 0);
    const char* as = std::getenv("NC_ARG_SP"); if (as && *as) g_arg_sp = (uint32_t)strtoul(as, nullptr, 0);
    const char* ad = std::getenv("NC_ARG_DP"); if (ad && *ad) g_arg_dp = (uint32_t)strtoul(ad, nullptr, 0);
    // Wait-list wake primitives (NC defaults when the bare-metal handler is configured).
    const char* wd = std::getenv("NC_WL_DEQUEUE"); if (wd && *wd) g_wl_dequeue = (uint32_t)strtoul(wd, nullptr, 0);
    else if (g_handler != 0) g_wl_dequeue = 0x80080FBCu;
    const char* ri = std::getenv("NC_RQ_INSERT"); if (ri && *ri) g_rq_insert = (uint32_t)strtoul(ri, nullptr, 0);
    else if (g_handler != 0) g_rq_insert = 0x80080F74u;
    const char* rh = std::getenv("NC_RUNQ_HEAD"); if (rh && *rh) g_runq_head = (uint32_t)strtoul(rh, nullptr, 0);
}

// ── AUTO-ARM (worklist #8): stock-libultra unmatched games ─────────────────────────────────────
// Arm the fiber/eret scheduler WITHOUT env config when the game proves, through hardware-shaped
// behavior, that it is running its own OS: it wrote its own raw MI_INTR_MASK (matched titles use
// native HLE osSetIntMask and never touch the register), no HLE VI queue is serving it, real code
// is installed at the exception vector, and it executes guest `eret`s (raw-MMIO ports never do —
// they keep today's host-thread delivery byte-identical). The only per-game datum the legacy path
// needed (the current-task pointer) is replaced by the stock-libultra ABI invariant: the
// dispatcher enters eret with $k0 = the dispatched TCB (taskptr==0 sentinel → r26 mode in
// recomp_eret). RECOMP_AUTOBM=0 is the kill-switch; env paths always win.
extern "C" uint32_t recomp_mi_intr_mask();
extern "C" uint32_t recomp_mi_intr_pending();
extern "C" int recomp_interp_is_code(uint8_t* rdram, uint32_t vaddr);
extern "C" int recomp_hle_vi_registered();
extern "C" void recomp_set_pending_mi_intr(uint32_t v);
extern "C" recomp_func_t* get_function(int32_t vram);
// [autoarm TASK PROOF 2026-09-05] A dispatched TCB is a KSEG0 pointer with a whole OSThread
// (0x1B0) inside RDRAM. 0 (nothing running yet) and 0xA430000C (MI_INTR_MASK, what the fifa/Quake
// dispatcher vintage leaves in $k0) both fail it.
static inline bool bm_tcb_plausible(uint32_t tcb) {
    return ((tcb >> 28) == 0x8u) && (((tcb & 0x1FFFFFFFu) + 0x1B0u) <= 0x00800000u);
}
static uint32_t g_arm_taskptr_cache = 0;   // learn-2's __osRunningThread, kept across declined arms
// k0 = the guest's $k0 at an arming eret, when the caller has it (0 = not supplied). The stock
// dispatcher enters eret with $k0 = the dispatched TCB, so it is the second source for the
// task-proof below.
static bool try_autoarm(uint8_t* rdram, bool from_eret = false, uint32_t k0 = 0) {
#ifdef _WIN32
    if (g_enabled || g_nc_mode || rdram == nullptr) return false;
    static int kill = -1;
    if (kill < 0) { const char* k = std::getenv("RECOMP_AUTOBM"); kill = (k && k[0] == '0') ? 1 : 0; }
    if (kill) return false;
    if (recomp_hle_vi_registered()) return false;        // HLE is serving — never double-schedule
    // [autoarm TASK PROOF 2026-09-05, Quake #267 — cheap retry] Arming used to be a one-way door,
    // so the learn-2 scan below (8 MB of guest RAM, once) could sit on the arming path. The proof
    // at the end of this function can now DECLINE an arm, and the next eret retries — Quake runs
    // ~150k erets/s, so re-scanning would be ruinous. Once the dispatcher pointer is known, the
    // retry is one RDRAM word: still no dispatched task ⇒ stay native, cheaply.
    if (from_eret && g_arm_taskptr_cache != 0) {
        const uint32_t tp = g_arm_taskptr_cache & 0x1FFFFFFFu;
        uint32_t tcb = (tp + 4u <= 0x00800000u) ? *(uint32_t*)(rdram + tp) : 0u;
        if (tcb == 0u) { tcb = k0; }
        if (!bm_tcb_plausible(tcb)) return false;
    }
    // FIRST-ERET ARMING (2026-07-18, SOTE): a game's very first eret is its boot context switch,
    // and it can come BEFORE the switched-to thread enables the MI mask or installs the vector
    // (SOTE: mask setup lives INSIDE the first-dispatched thread — requiring the mask here
    // deadlocked the native boot; the interpreter escaped only because it follows erets inline).
    // Executing a guest eret IS the hardware-shaped proof of a self-hosted OS — HLE titles never
    // compile one. The mask/vector conditions are DELIVERY-time concerns and stay for the
    // interrupt-site arm (from_eret=false); the drain late-binds the vector via get_function.
    if (!from_eret) {
        if (recomp_mi_intr_mask() == 0u) return false;  // the game never asked hardware for interrupts
        if (!recomp_interp_is_code(rdram, 0x80000180u)) return false;
    }
    // Decode the stock __osExceptionPreamble at the vector (lui $k0,hi; addiu $k0,lo; jr $k0) so the
    // idle drain runs the real handler (usually statically recompiled = native); unmatched pattern →
    // run the vector itself through get_function/JIT.
    uint32_t w0 = *(uint32_t*)(rdram + 0x180u);
    uint32_t w1 = *(uint32_t*)(rdram + 0x184u);
    uint32_t w2 = *(uint32_t*)(rdram + 0x188u);
    uint32_t target = 0x80000180u;
    if ((w0 >> 16) == 0x3C1Au && (w1 >> 16) == 0x275Au && w2 == 0x03400008u) {
        target = ((w0 & 0xFFFFu) << 16) + (uint32_t)(int32_t)(int16_t)(w1 & 0xFFFFu);
    }
    g_handler = target;
    g_cause   = 0x00000400u;   // IP2 = RCP, the stock-libultra dispatch bit
    // Learn __osRunningThread from the game's OWN handler prologue: stock __osException opens with
    // `lui $k0,hi(__osRunningThread); lw $k0,lo($k0)` — that load target IS the current-task
    // pointer, giving the proven memory-read dispatch mode with the game's own code as ground
    // truth. ($k0-at-eret proved vintage-fragile: fifa's dispatcher erets with k0 = the MI mask
    // register address it last scratched.) Scan the first 16 words for the lui/lw pair; on a miss
    // g_taskptr stays 0 and recomp_eret falls back to $k0 (KSEG0-checked, dead-ends benignly).
    g_taskptr = 0;
    {
        uint32_t hphys = target & 0x1FFFFFFFu;
        if (target != 0x80000180u && hphys + 64u <= 0x00800000u) {
            uint32_t hi_imm = 0;
            for (int i = 0; i < 16; i++) {
                uint32_t w  = *(uint32_t*)(rdram + hphys + (uint32_t)i * 4u);
                uint32_t op = w >> 26, rt = (w >> 16) & 31u, rs = (w >> 21) & 31u;
                if (op == 0x0Fu && (rt == 26u || rt == 27u)) { hi_imm = (w & 0xFFFFu) << 16; continue; }   // lui k0/k1
                if (hi_imm != 0u && op == 0x23u && (rt == 26u || rt == 27u) && rs == rt) {                  // lw kN, off(kN)
                    uint32_t addr = hi_imm + (uint32_t)(int32_t)(int16_t)(w & 0xFFFFu);
                    if ((addr >> 28) == 0x8u && ((addr & 0x1FFFFFFFu) + 4u) <= 0x00800000u) { g_taskptr = addr; }
                    break;
                }
            }
        }
    }
    // Learn source 2 (banjotooie class): some vintages' handler prologue saves into a FIXED
    // context buffer (lui/addiu $k0 — no lw), so the source-1 scan misses and the $k0-at-eret
    // fallback reads the MI-mask register address the dispatcher scratched last (observed:
    // tooie k0=0xA430000C at every eret -> CORRUPT dead-end forever). Every libultra vintage's
    // dispatcher DOES store the popped TCB to __osRunningThread right before making it current:
    //     lui $rA, hi(RT) ; sw $rX, lo($rA) ; ... ; or $k0, $rX, $zero ; <context restore> ; eret
    // (tooie func_800327C8: sw $v0,0x1490($at) / lui 0x8004 -> RT=0x80041490.) Scan guest RAM
    // for eret; walk back for `or $k0,$rX,$zero`, then the paired sw/lui — the sw target is RT.
    if (g_taskptr == 0) {
        // LAST qualifying eret wins: a relocating OS (tooie) carries a BOOT-stage copy of the
        // dispatcher in the resident region and the live one in the payload; the payload copy
        // (higher address) supersedes. Validated offline on tooie's dump: exactly two qualify
        // (0x80002654 -> 0x800042D0 boot copy, 0x800329A4 -> 0x80041490 live) — last is correct.
        for (uint32_t phys = 0x400; phys + 4 <= 0x00800000u; phys += 4) {
            if (*(uint32_t*)(rdram + phys) != 0x42000018u) continue;              // eret
            // Require the dispatcher's CONTEXT-RESTORE signature before this eret: a run of
            // `ld $reg, off($k0)` (op 0x37, base $k0) — the TCB register-file reload. Filters
            // out boot-stub/fast-path erets (tooie learn-2 v1 latched one and learned garbage).
            {
                int ld_k0 = 0;
                for (uint32_t back = 4; back <= 0x240u && back <= phys; back += 4) {
                    uint32_t w = *(uint32_t*)(rdram + phys - back);
                    if ((w >> 26) == 0x37u && ((w >> 21) & 31u) == 26u) ld_k0++;
                }
                if (ld_k0 < 6) continue;
            }
            uint32_t found = 0;
            for (uint32_t back = 4; back <= 0x240u && back <= phys && found == 0; back += 4) {
                uint32_t w = *(uint32_t*)(rdram + phys - back);
                // `move $k0, $rX` — MIPS has TWO canonical expansions and libultra ships BOTH:
                // `or $k0,$rX,$zero` (funct 0x25) and `addu $k0,$rX,$zero` (funct 0x21). The
                // SDK dispatcher in engine/references/sdk/libg/x/exceptasm.o uses ADDU at
                // .text+0x0C98 (word 0x0040D021), so accepting only `or` left g_taskptr = 0 for
                // that whole vintage (turok1/fifa class). Identity then fell back to $k0-at-eret
                // — and that dispatcher loads k0 with 0xA430000C (MI_INTR_MASK) two instructions
                // before its eret, which is the [bmsched][CORRUPT] tcb=0xA430000C wall verbatim.
                // The mask already pins rt=$zero, rd=$k0, sa=0 and leaves rs free.
                // (spec audit 2026-08-06, verified against the .o bytes)
                {
                    uint32_t moved = w & 0xFC1FFFFFu;
                    if (moved != 0x0000D025u && moved != 0x0000D021u) continue;
                }
                uint32_t rX = (w >> 21) & 31u;
                for (uint32_t b2 = back + 4; b2 <= back + 0x40u && b2 <= phys; b2 += 4) {
                    uint32_t sw_w = *(uint32_t*)(rdram + phys - b2);
                    if ((sw_w >> 26) != 0x2Bu || ((sw_w >> 16) & 31u) != rX) continue;  // sw $rX, imm($rA)
                    uint32_t rA = (sw_w >> 21) & 31u;
                    for (uint32_t b3 = b2 + 4; b3 <= b2 + 0x20u && b3 <= phys; b3 += 4) {
                        uint32_t lui_w = *(uint32_t*)(rdram + phys - b3);
                        if ((lui_w >> 26) == 0x0Fu && ((lui_w >> 16) & 31u) == rA) {
                            uint32_t addr = ((lui_w & 0xFFFFu) << 16) + (uint32_t)(int32_t)(int16_t)(sw_w & 0xFFFFu);
                            if ((addr >> 28) == 0x8u && ((addr & 0x1FFFFFFFu) + 4u) <= 0x00800000u) found = addr;
                            break;
                        }
                    }
                    break;
                }
            }
            if (found != 0) {
                g_taskptr = found;   // later (higher-address) dispatcher overwrites
                // [dispatch-window] same "later wins" rule: remember THIS dispatcher's extent.
                // The window is exactly the back-scan the match already trusts (eret - 0x240 ..
                // eret + 8): the context-restore run plus the prologue that selects the task.
                const uint32_t _eret_va = 0x80000000u + phys;
                g_disp_hi = _eret_va + 8u;
                g_disp_lo = (_eret_va > (0x80000400u + 0x240u)) ? (_eret_va - 0x240u) : 0x80000400u;
            }
        }
        if (g_taskptr != 0) {
            fprintf(stderr, "[bmsched] AUTOBM taskptr via learn-2 (dispatcher RT store): 0x%08X (dispatch window 0x%08X..0x%08X)\n", g_taskptr, g_disp_lo, g_disp_hi);
            fflush(stderr);
        }
    }
    // [autoarm TASK PROOF 2026-09-05, Quake #267] Arming on an eret is only faithful if THIS eret
    // is a dispatcher eret — one that names the task it is resuming. Once learn-2 has found the
    // game's own __osRunningThread, the guest itself answers that question: the word at g_taskptr
    // is the TCB the dispatcher just made current. A boot-stage eret (Quake's first one) reaches
    // here with __osRunningThread still 0 and $k0 = 0xA430000C (the MI_INTR_MASK address the
    // dispatcher scratched last) — no task exists yet, so the takeover cannot restore one. Arming
    // anyway is what broke Quake: every eret then read tcb=0 ([bmsched][CORRUPT]), fell to
    // "faithful-eret: tcb unusable → anonymous continuation", dropped the game into the
    // interpreter at a mid-function resume pc (0x80058500) and spun on an MI mask of 0 forever
    // (14.7M [edge-census] declines, 1 frame in 40 s). Measured: the same exe with the takeover
    // declined reaches Quake's MAIN menu at 30.5 fps.
    // So: decline THIS eret, drop the half-learned state, and leave the eret to the native path —
    // exactly what the engine did before it armed. try_autoarm is retried at every later eret, so
    // the moment the guest does have a running task (SOTE/1080/tooie store it right before their
    // dispatcher's eret) arming proceeds as before. When learn-2 found nothing (g_taskptr == 0,
    // the $k0-sentinel mode the interpreted-eret class uses) there is no guest answer to consult
    // and the behaviour is unchanged.
    if (from_eret && g_taskptr != 0) {
        uint32_t tcb = 0;
        const uint32_t tp_phys = g_taskptr & 0x1FFFFFFFu;
        if ((g_taskptr >> 28) == 0x8u && tp_phys + 4u <= 0x00800000u) {
            tcb = *(uint32_t*)(rdram + tp_phys);
        }
        if (tcb == 0u) { tcb = k0; }   // ABI fallback: the dispatcher enters eret with $k0 = the TCB
        if (!bm_tcb_plausible(tcb)) {
            static int _decl = 0;
            if (_decl++ < 8) {
                fprintf(stderr, "[bmsched] AUTOBM DECLINED at this eret: no dispatched task (taskptr=0x%08X -> tcb=0x%08X, k0=0x%08X) - leaving the eret native\n",
                        g_taskptr, tcb, k0);
                fflush(stderr);
            }
            g_arm_taskptr_cache = g_taskptr;   // keep the scan's answer; the retry above is one word
            g_handler = 0; g_taskptr = 0; g_disp_lo = 0; g_disp_hi = 0;
            return false;
        }
    }
    g_autobm  = true;
    g_enabled = true;          // LAST — every enabled() consumer sees a fully-configured state
    fprintf(stderr, "[bmsched] AUTOBM ARMED handler=0x%08X taskptr=0x%08X mask=0x%02X (vector %s)\n",
            g_handler, g_taskptr, recomp_mi_intr_mask(), target == 0x80000180u ? "raw" : "preamble-decoded");
    fflush(stderr);
    // [icache-ghost] arm HERE, not at wave detection (2026-08-26, third arm site and the correct
    // one): on the VR4300 there is no detection — the I-cache is simply always on. Every "detect
    // the wave, then arm" scheme loses a race (measured twice today: the hold-#1 site missed the
    // pre-stomp osRecvMesg overwrite; the loader-fetch site missed the PI-DMA wave writes that
    // precede the loader's first interpreted fetch). At AUTOBM-ARM the kernel is pristine and no
    // transition activity has begun — snapshot now. Code the game legitimately loads later is
    // CACHE-invalidated by the game itself (mandatory on hardware), which syncs the ghost line by
    // line; only stealth overwrites (the packed-title swap wave) execute stale — hardware-exact.
    {
        static const bool ig_on = [] { const char* e = std::getenv("RECOMP_ICACHE_GHOST"); return (e == nullptr) || (e[0] != '0'); }();   // DEFAULT ON (the VR4300 I-cache has no enable bit); env=0 = off-instrument
        if (ig_on) recomp_icache_ghost_arm(rdram, 0x80000400u, 0x801A0000u);
    }
    // A COMPARE armed BEFORE this point never reached the deadline waiter (compare_write gates on
    // g_enabled/g_autobm) — retro-arm it now so a pre-arm timer wait cannot strand (the level-eval
    // this latch model replaced would have caught it at the next drain). If the deadline already
    // passed during boot, hardware would have latched — latch immediately.
    {
        uint32_t c = recomp_cop0_tlb_read(11);
        if (c != 0u) {
            if ((int32_t)(c - recomp_cop0_tlb_read(9)) > 0) recomp_baremetal_compare_write(c);
            else recomp_baremetal_ip7_latch_now();
        }
    }
    return true;
#else
    (void)rdram; return false;   // fibers are Win32-only; arming would blackhole interrupts
#endif
}
extern "C" int recomp_baremetal_eret_seen() { return g_eret_seen.load(std::memory_order_relaxed) ? 1 : 0; }
extern "C" int recomp_baremetal_autoarm(uint8_t* rdram) { lazy_init(); return try_autoarm(rdram) ? 1 : 0; }
// armed = the fiber scheduler owns interrupt delivery (both flags: g_enabled without g_autobm is the NC-legacy state and must NOT divert here - note_interrupt would drop it).
extern "C" int recomp_baremetal_armed() { return (g_enabled && g_autobm) ? 1 : 0; }

extern "C" int recomp_baremetal_nc_mode() { lazy_init(); return g_nc_mode ? 1 : 0; }
// Interpreted eret = proof the game runs its own OS (the fifa class dispatches threads entirely
// inside the interpreter). Latch eret-seen + attempt the auto-arm; on success the SAME eret takes
// the fiber branch in the interpreter (mid-flight arm, once) and later handler runs go native.
extern "C" uint32_t recomp_interp_peek_pc(void);
extern "C" void recomp_baremetal_note_interp_eret(uint8_t* rdram) {
    lazy_init();
    g_eret_seen.store(true, std::memory_order_relaxed);
    if (!g_enabled) try_autoarm(rdram, /*from_eret=*/true);
    // [dispatch-window learn 2026-09-03] The window was set ONLY on the learn-2 (dispatcher RT-store)
    // path; a preamble-decoded arm left it EMPTY, so no venue was protected from latching a pc inside
    // the guest dispatcher (1080: the PI manager TCB canonized the dispatcher eret 0x801153AC as its
    // resume pc -> every dispatch of it erets straight back, the main thread waits for PI forever).
    // Every libultra eret lives in __osDispatchThread, so the first INTERPRETED eret names the
    // dispatcher: seed the same window learn-2 would have (eret-0x240 .. eret+8).
    static const bool _wl = [] { const char* e = std::getenv("RECOMP_BM_WINLEARN"); return !(e && e[0] == '0'); }();   // off-instrument for bisects
    if (_wl && g_disp_hi == 0u) {
        const uint32_t va = recomp_interp_peek_pc();
        if ((va >> 28) == 0x8u) {
            g_disp_hi = va + 8u;
            g_disp_lo = (va > (0x80000400u + 0x240u)) ? (va - 0x240u) : 0x80000400u;
            fprintf(stderr, "[bmsched] dispatch window learned from the first interpreted eret at 0x%08X: 0x%08X..0x%08X\n", va, g_disp_lo, g_disp_hi);
            fflush(stderr);
        }
    }
}

// Run NC's wait-list wake on a specific guest queue: if the queue (guest addr) has a TCB blocked on its
// wait-list (queue+0x0 chain), dequeue it (func_80080FBC) and priority-insert it into the run queue
// (func_80080F74), exactly as NC's own event poster does. This is the piece the HLE message delivery
// cannot perform (it increments the ring's validCount but has no knowledge of NC's run queue). Runs on
// the game thread (from the idle), so the run-queue mutation is safe. Returns true if it woke a waiter.
static inline uint32_t nc_rdw(uint32_t va) { uint32_t p = va & 0x1FFFFFFFu; return *(uint32_t*)(g_rdram + p); }
static inline void     nc_wdw(uint32_t va, uint32_t v) { uint32_t p = va & 0x1FFFFFFFu; *(uint32_t*)(g_rdram + p) = v; }

// Deliver a completion message into a bare-metal OSMesgQueue's ring (NC layout) AND run NC's wait-list
// wake. NC OSMesgQueue layout (from func_80080280 / func_80081AC0): 0x0 waitlist-head, 0x4 waitlist-tail,
// 0x8 validCount, 0xC first, 0x10 msgCount, 0x14 msg-buffer. We:
//   (1) if there is room (validCount < msgCount), append `msg` at msg[(first+validCount)%msgCount] and
//       validCount++  — exactly what NC's own osSendMesg/func_80080D7C poster does;
//   (2) if a TCB is blocked on the wait-list (head chain non-empty), dequeue it (func_80080FBC) and
//       priority-insert it into the run queue (func_80080F74) so the scheduler reschedules it to re-poll.
// Returns true once the queue has a delivered message AND no remaining waiter (delivery complete).
static bool nc_deliver_and_wake(uint32_t queue, uint32_t msg) {
    if (g_wl_dequeue == 0 || g_rq_insert == 0 || g_ctx == nullptr || g_rdram == nullptr) return false;
    if ((queue >> 28) != 0x8u) return false;
    uint32_t qphys = queue & 0x1FFFFFFFu;
    if (qphys + 0x18u > 0x00800000u) return false;
    uint32_t validCount = nc_rdw(queue + 0x8u);
    uint32_t first      = nc_rdw(queue + 0xCu);
    uint32_t msgCount   = nc_rdw(queue + 0x10u);
    uint32_t msgbuf     = nc_rdw(queue + 0x14u);
    // (1) deliver into the ring if there is room and we have not already delivered (idempotent: only add
    // when empty, since a single PI completion = one message; re-entry must not stack duplicates).
    bool delivered_now = false;
    if (msgCount > 0 && msgCount <= 4096 && validCount < msgCount && (msgbuf >> 28) == 0x8u) {
        // Only inject when the ring is currently EMPTY (validCount==0): the boot waits for exactly one
        // completion; injecting once and letting NC consume it is faithful and avoids duplicate fills.
        if (validCount == 0) {
            uint32_t slot = (first + validCount) % msgCount;
            nc_wdw(msgbuf + slot * 4u, msg);
            nc_wdw(queue + 0x8u, validCount + 1u);
            delivered_now = true;
        }
    }
    // (2) wake any waiter on the queue's wait-list. NC's check: t2=*(queue+0); t3=*(t2+0); wake if t3!=0.
    bool woke = false;
    uint32_t wl_head = nc_rdw(queue + 0x0u);
    if ((wl_head >> 28) == 0x8u && (wl_head & 0x1FFFFFFFu) + 4u <= 0x00800000u && nc_rdw(wl_head + 0x0u) != 0u) {
        recomp_func_t* fdq = recomp_lookup_native(g_wl_dequeue);
        recomp_func_t* fri = recomp_lookup_native(g_rq_insert);
        if (fdq && fri) {
            uint64_t* gpr = reinterpret_cast<uint64_t*>(g_ctx);
            uint64_t saved[32]; for (int i = 0; i < 32; ++i) saved[i] = gpr[i];
            gpr[4] = (uint64_t)(int64_t)(int32_t)queue; gpr[31] = 0;     // v0 = func_80080FBC(queue)
            fdq(g_rdram, g_ctx);
            uint32_t tcb = (uint32_t)gpr[2];
            gpr[4] = (uint64_t)(int64_t)(int32_t)g_runq_head;           // func_80080F74(runq, tcb)
            gpr[5] = (uint64_t)(int64_t)(int32_t)tcb; gpr[31] = 0;
            fri(g_rdram, g_ctx);
            for (int i = 0; i < 32; ++i) gpr[i] = saved[i];
            woke = (tcb >> 28) == 0x8u;
            static int _wq=0; if (++_wq<=16) { fprintf(stderr, "[bmsched][WAKE] queue=0x%08X delivered=%d TCB=0x%08X vc=%u->%u -> run-queue\n", queue, (int)delivered_now, tcb, validCount, nc_rdw(queue+0x8u)); fflush(stderr); }
        }
    }
    (void)woke;
    // Delivery is COMPLETE (clear the pending mq) once the message has been consumed by NC: validCount back
    // to 0 AND no waiter left on the wait-list. Until then keep delivering/waking each idle.
    uint32_t vc_now = nc_rdw(queue + 0x8u);
    uint32_t wlh_now = nc_rdw(queue + 0x0u);
    uint32_t wl0_now = ((wlh_now >> 28) == 0x8u && (wlh_now & 0x1FFFFFFFu) + 4u <= 0x00800000u) ? nc_rdw(wlh_now + 0x0u) : 0u;
    return (vc_now == 0u && wl0_now == 0u && !delivered_now);
}

// Call NC's own event poster func_80080D7C(arg) natively on the game thread. It posts the event's
// stored message into the game's OSMesgQueue ring (D_8012D600+arg -> queue) AND runs NC's wait-list
// wake (dequeue blocked TCB -> re-add to run queue), exactly as NC's interrupt handler would. We
// save/restore the shared ctx registers the call clobbers (a0/r4 arg, ra/r31 return, and the s2/v-
// temporaries the routine uses) so the surrounding fiber/handler state is undisturbed.
// recomp_context layout (recomp.h): 32 GPRs (r0..r31) as uint64_t first, then fpr[32], then hi, lo.
// We access them by index without pulling in recomp.h (avoids a typedef/forward-decl conflict with the
// lean forward declarations at the top of this file). r4=4 (a0), r31=31 (ra). We snapshot/restore the
// full GPR window the poster could touch so the in-flight fiber/handler ctx is byte-for-byte preserved.
static void nc_post_event(uint32_t arg) {
    if (g_event_poster == 0 || g_ctx == nullptr || g_rdram == nullptr) {
        static int _pn=0; if (++_pn<=8) { fprintf(stderr, "[bmsched][POST?] skip arg=0x%X poster=0x%08X ctx=%p rdram=%p\n", arg, g_event_poster, (void*)g_ctx, (void*)g_rdram); fflush(stderr); }
        return;
    }
    recomp_func_t* f = recomp_lookup_native(g_event_poster);
    if (!f) {                                        // poster not pinned native -> skip (no interp fallback: avoid the derail)
        static int _pl=0; if (++_pl<=8) { fprintf(stderr, "[bmsched][POST?] lookup FAILED poster=0x%08X (not pinned native)\n", g_event_poster); fflush(stderr); }
        return;
    }
    uint64_t* gpr = reinterpret_cast<uint64_t*>(g_ctx);   // &ctx->r0; GPRs are the first 32 uint64_t
    uint64_t saved[32];
    for (int i = 0; i < 32; ++i) saved[i] = gpr[i];
    // [POSTQ] read NC's event table (D_8012D600+arg) -> the target queue, and dump its ring state
    // before/after so we can see whether the message lands and whether a TCB is waiting to be woken.
    auto rdw = [&](uint32_t va)->uint32_t { uint32_t p=va&0x1FFFFFFFu; if (p+4>0x800000u) return 0xBADBAD; return *(uint32_t*)(g_rdram+p); };
    uint32_t qptr = rdw(0x8012D600u + arg);
    uint32_t vc_before=0, mc=0, wl=0;
    if ((qptr>>28)==0x8u) { vc_before=rdw(qptr+0x8); mc=rdw(qptr+0x10); wl=rdw(qptr+0x0); }
    gpr[4]  = (uint64_t)(int64_t)(int32_t)arg;       // $a0 = the byte arg (event slot offset)
    // func_80080D7C saves $ra into $s2 at entry, then its final `jr $s2` is recompiled as
    // LOOKUP_FUNC(s2)(rdram,ctx) (a register tail-return). Set $ra=0 so that tail-call resolves to
    // get_function(0)=ni_stub_noop (a clean no-op return) instead of recursing on the poster address
    // — otherwise func_80080D7C tail-calls itself forever (the boot fiber spins, never returns here).
    gpr[31] = 0;                                     // -> jr $s2 returns via the noop stub, back to this C frame
    f(g_rdram, g_ctx);
    for (int i = 0; i < 32; ++i) gpr[i] = saved[i];  // restore the GPR window (incl hi/lo are past r31, untouched here)
    uint32_t vc_after=0; if ((qptr>>28)==0x8u) vc_after=rdw(qptr+0x8);
    static int _pe=0; if (++_pe<=16) { fprintf(stderr, "[bmsched][POST] func_80080D7C(arg=0x%X) queue=0x%08X validCount %u->%u msgCount=%u waitlist=0x%08X | EC480: vc=%u first=%u mc=%u wl=0x%08X\n", arg, qptr, vc_before, vc_after, mc, wl, rdw(0x800EC480u+0x8), rdw(0x800EC480u+0xC), rdw(0x800EC480u+0x10), rdw(0x800EC480u+0x0)); fflush(stderr); }
}

// On the VI host thread during interrupt delivery we must not switch fibers (post-only).
static thread_local bool tl_in_interrupt = false;
// Drain-at-eret recursion guard (auto-bm): set while the eret-path pump runs the handler, so the
// handler's own eret dispatches instead of re-draining.
static thread_local bool tl_eret_drain = false;
extern "C" void recomp_baremetal_enter_interrupt() { tl_in_interrupt = true; }
extern "C" void recomp_baremetal_exit_interrupt()  { tl_in_interrupt = false; }

// Is the fiber scheduler active for this game? (mmio.cpp uses this to defer interrupt handling to the
// game thread instead of running NC's scheduler as throwaway-ctx interp on the VI host thread.)
extern "C" int recomp_baremetal_enabled() { lazy_init(); return g_enabled ? 1 : 0; }

// The VI host thread records each RCP interrupt here; the game thread drains it (runs NC's handler natively
// at a safe point) so the scheduler/eret/fibers all execute on one thread. (g_pending_intr defined above.)
extern "C" void recomp_baremetal_note_interrupt(uint32_t mi_bits) { uint32_t _prev = 0; if (mi_bits) _prev = g_pending_mi_bits.fetch_or(mi_bits, std::memory_order_relaxed); g_pending_intr.fetch_add(1, std::memory_order_relaxed); static int _ni=0; if(++_ni<=3||_ni%1000==0||(mi_bits&~0x8u)){if(rc_trace_on("RECOMP_BM_RUNLOG")){fprintf(stderr,"[bmsched] note_interrupt total=%d mi=0x%X\n",_ni,mi_bits);fflush(stderr);}} if (_prev & mi_bits & ~0x8u) {if(rc_trace_on("RECOMP_BM_RUNLOG")){fprintf(stderr,"[bmsched] note MERGE mi=0x%X prev=0x%X (same-bit note before drain)\n",mi_bits,_prev);fflush(stderr);} } }
extern "C" int  recomp_baremetal_take_pending() { return g_pending_intr.exchange(0, std::memory_order_relaxed); }
extern "C" uint64_t recomp_bm_sample_rip(void) {
#ifdef _WIN32
    if (g_game_thread_handle == nullptr) return 0;
    HANDLE h = (HANDLE)g_game_thread_handle;
    if (SuspendThread(h) == (DWORD)-1) return 0;
    CONTEXT cx; memset(&cx, 0, sizeof cx); cx.ContextFlags = CONTEXT_CONTROL;
    uint64_t rip = 0;
    uint64_t rsp = 0;
    cx.ContextFlags = CONTEXT_CONTROL | CONTEXT_INTEGER;
    if (GetThreadContext(h, &cx)) { rip = (uint64_t)cx.Rip; rsp = (uint64_t)cx.Rsp; }
    // [stack-walk] the RIP landed in a system DLL (a host-side WAIT). The return addresses on the
    // stack that fall inside the EXE image name the engine frames that entered the wait — resolve
    // against shadowspc.map. Read a window of the suspended thread's stack (same process: plain reads).
    // [rip-sample 2026-09-03] NEVER print while the sampled thread is suspended: the game thread prints
    // through the same stderr stream, so suspending it inside an fprintf and then printing here deadlocks
    // both threads on the stream lock (measured on 1080: every driver run "died" 9-13 s in — window alive,
    // logs frozen; a direct run without the coincidence lived on). Walk the stack into locals, resume, print.
    uint64_t cand[10]; int printed = 0;
    const uint64_t base = (uint64_t)GetModuleHandleA(nullptr);
    if (rsp != 0) {
        const uint64_t* sp = (const uint64_t*)rsp;
        for (int i = 0; i < 256 && printed < 10; i++) {
            uint64_t v = 0;
            __try { v = sp[i]; } __except (1) { break; }
            if (v >= base && v < base + 0x1800000ull) cand[printed++] = v - base;
        }
    }
    ResumeThread(h);
    if (rsp != 0) {
        static int _sw = 0;
        if (_sw++ < 6) {
            fprintf(stderr, "[stack-walk] rip=0x%llX rsp=0x%llX exebase=0x%llX ret-candidates:",
                    (unsigned long long)rip, (unsigned long long)rsp, (unsigned long long)base);
            for (int i = 0; i < printed; i++) fprintf(stderr, " +0x%llX", (unsigned long long)cand[i]);
            fprintf(stderr, "%c", 0x0A);
            fflush(stderr);
        }
    }
    return rip;
#else
    return 0;
#endif
}
extern "C" void recomp_bm_pump_state(uint64_t* idle_entries, int* pending) { *idle_entries = g_idle_entries.load(std::memory_order_relaxed); *pending = g_pending_intr.load(std::memory_order_relaxed); }
// [pollguard 2026-08-26] PEEK (never clears - take_pending() is the consumer). The codegen poll
// guard consults this so a guest spin-loop yields when an interrupt has ACTUALLY ARRIVED
// (hardware semantics), instead of after a hardcoded 100k-iteration debt. MEASURED on SOTE
// (sustained median, visible window): stock guard 2.0 fps -> this 45.0 fps.
extern "C" int  recomp_baremetal_peek_pending() { return g_pending_intr.load(std::memory_order_relaxed); }

// ── CP0 COMPARE deadline waiter (SOTE sequencer dig, 2026-07-19) ──────────────────────────────────
// The timer line (Cause IP7) is level-evaluated inside the drain, but drains only run when some RCP
// note bumps g_pending_intr — so an armed COMPARE deadline waited for the NEXT VI note (~16.7ms
// granularity). Measured on SOTE: the kernel's 11.68ms one-shot sequencer sleeps delivered 20-50ms
// late → the 4-5x-slow intro. Hardware preempts at the deadline; this waiter is that preemption:
// every COMPARE write re-arms it, and when the deadline passes it pokes the pump ONCE (per arm-edge)
// so the very next drain presents IP7 on time. g_timer_poke suppresses the drain's 0x8 MI fallback —
// a pure timer wake must present IP7 with NO MI bits (a phantom VI bit would double-post the VI
// service). Agnostic: any bm-class game that arms COMPARE gets real-time timer delivery; games that
// never write COMPARE never spawn the thread.
// VR4300-faithful semantics: the timer interrupt is a LATCH — set when COUNT reaches COMPARE,
// cleared by ANY mtc0 COMPARE (that is why the guest ack idiom `mfc0 t,Compare; mtc0 t,Compare`
// works on silicon even though the value is unchanged). The drain's old level-evaluation
// (count >= compare re-derived every pass) re-asserted IP7 after the ack until the guest
// disarmed — harmless at VI-note drain cadence, a tick storm at deadline-waiter cadence.
static std::atomic<uint32_t> g_compare_gen{0};       // bumped on every COMPARE write
static std::atomic<uint32_t> g_compare_deadline{0};  // latest armed value (0 = disarmed)
static std::atomic<int>      g_ip7_latch{0};         // the pending timer line; drain presents it
static std::atomic<int>      g_timer_poke{0};        // set by the waiter; drain consumes it
static std::atomic<bool>     g_timer_waiter_live{false};

extern "C" void recomp_baremetal_compare_write(uint32_t value) {
    if (!g_enabled || !g_autobm) return;
    g_ip7_latch.store(0, std::memory_order_relaxed);  // hardware: any COMPARE write clears the line
    // Arm only FUTURE deadlines. A write whose value COUNT has already passed is the ack idiom
    // (silicon would not re-fire until COUNT wraps ~91s later); treat it as clear-only.
    int32_t remain = (int32_t)(value - recomp_cop0_tlb_read(9));
    uint32_t armed = (value != 0u && remain > 0) ? value : 0u;
    g_compare_deadline.store(armed, std::memory_order_relaxed);
    g_compare_gen.fetch_add(1, std::memory_order_release);
    if (armed == 0u) return;
    bool expected = false;
    if (g_timer_waiter_live.compare_exchange_strong(expected, true)) {
        std::thread([]() {
            uint32_t fired_gen = 0xFFFFFFFFu;
            while (g_enabled) {
                uint32_t gen = g_compare_gen.load(std::memory_order_acquire);
                uint32_t dl  = g_compare_deadline.load(std::memory_order_relaxed);
                if (dl == 0u || gen == fired_gen) {           // disarmed, or this arm already fired
                    std::this_thread::sleep_for(std::chrono::microseconds(500));
                    continue;
                }
                int32_t remain = (int32_t)(dl - recomp_cop0_tlb_read(9));
                if (remain > 0) {                             // not due: sleep toward it, re-check
                    int64_t us = (int64_t)remain * 1000 / 46875;
                    if (us > 1000) us = 1000;
                    if (us < 100)  us = 100;
                    std::this_thread::sleep_for(std::chrono::microseconds(us));
                    continue;
                }
                fired_gen = gen;                              // due: latch the line, poke the pump
                g_ip7_latch.store(1, std::memory_order_relaxed);
                g_timer_poke.store(1, std::memory_order_relaxed);
                g_pending_intr.fetch_add(1, std::memory_order_relaxed);
            }
            g_timer_waiter_live.store(false, std::memory_order_relaxed);
        }).detach();
    }
}
extern "C" int recomp_baremetal_ip7_latched() { return g_ip7_latch.load(std::memory_order_relaxed); }
extern "C" void recomp_baremetal_ip7_latch_now(void) {
    g_ip7_latch.store(1, std::memory_order_relaxed);
    g_timer_poke.store(1, std::memory_order_relaxed);
    g_pending_intr.fetch_add(1, std::memory_order_relaxed);
}

// Game-thread idle drain (Piece 2): NC's exception handler runs HERE (on the game thread), not on the VI host
// thread. It sets up the interrupt state the handler reads (Cause IP bits + MI_INTR source), then interprets
// NC's handler from g_handler; the handler posts its event and reschedules, and its eret routes to recomp_eret
// (Piece 3) which switches to the woken task's fiber. Called in a loop from the bare-metal pause_self idle.
extern "C" void recomp_interpret(uint8_t* rdram, recomp_context* ctx, uint32_t start_vaddr);
extern "C" void recomp_interpret_mark_eret_entry(void);
extern "C" void recomp_live_gap_trampoline(uint8_t* rdram, recomp_context* ctx);
extern "C" void recomp_interp_trampoline(uint8_t* rdram, recomp_context* ctx);
// [venue-census 2026-08-06] which drain venue is delivering (set around recomp_baremetal_idle
// by the venues that know; "direct" = a caller that did not tag, e.g. the ultramodern poll
// guards or the root pump). Declared HERE, outside the _WIN32 fiber block, because the venues
// that write it (mask_poll / interp_poll) compile on every platform. Instrument only.
static thread_local const char* tl_drain_venue = "direct";
// [edge-retake 2026-09-03] an IE-rising / mask edge that fired INSIDE a native callee beneath an interp frame
// was deferred (no representable EPC there). The interpreter re-takes it at the first instruction after the
// callee returns (recomp_interp.cpp) -- the moment hardware would already have taken it, with a coherent file.
extern "C" volatile int recomp_bm_edge_deferred = 0;
extern "C" uint32_t recomp_interp_peek_pc(void);
extern "C" int recomp_interp_in_native_callee(void);   // round 6: live_pc staleness gate
// Defined below, beside the fiber machinery it needs (TaskFiber / g_root_fiber / g_running are
// declared further down). Returns true if it parked this task fiber and switched to the root.
// Defined ONLY under _WIN32 (the fiber block at the #ifdef below), but DECLARED and CALLED from
// unconditionally-compiled code — so without this #else the non-Windows build gets a declared,
// called, never-defined static: a link error on every aarch64 Linux target (reva / repc). Mirrors
// the sibling nc_force_redispatch above, which already had this shape. (2026-08-05)
#ifdef _WIN32
static bool bm_yield_to_root_if_task_fiber();
static void bm_seed_handler_ctx();          // per-fiber files: handler sees the interrupted task's state
static recomp_context* bm_exec_sr_ctx();    // the RUNNING execution's register file (SR split-brain fix, 08-06)
static bool bm_resume_interrupted_task();   // [hverify] hold ≠ halt: resume the suspended guest undelivered
#else
static bool bm_yield_to_root_if_task_fiber() { return false; }   // no fibers: nothing to yield to
static void bm_seed_handler_ctx() {}                             // no fibers: shared-ctx legacy
static recomp_context* bm_exec_sr_ctx() { return g_ctx; }        // no fibers: one shared file
static bool bm_resume_interrupted_task() { return false; }       // no fibers: nothing to resume
extern "C" void recomp_bm_budget_break(uint32_t pc) { (void)pc; }  // no fibers: no redispatch
extern "C" void recomp_bm_peek_regs(uint32_t* out4) { out4[0]=out4[1]=out4[2]=out4[3]=0; }   // no fibers: nothing to peek
#endif

// [eret-census 2026-08-27] The eret print is capped at 500 (RECOMP_BM_RUNLOG), so counting eret
// lines in a log understates dispatch by an unknown factor - that misread cost real time today.
// Uncapped counters instead, reported by the 1Hz spin-watch:
//   0 eret entries  1 SWITCH to another fiber  2 self-redispatch  3 resume-interrupted
//   4 curtask(guest) != g_current(engine) AT ERET ENTRY = the split-brain, counted
std::atomic<uint64_t> g_eret_census[6] = {};   // [5] = guest-handler entries
extern "C" uint64_t recomp_bm_eret_census(int i) { return (i>=0 && i<6) ? g_eret_census[i].load(std::memory_order_relaxed) : 0; }

// [eret-EPC guard 2026-08-27] Is this pc an eret instruction? Latching an eret as the interrupted
// pc creates a closed loop: eret -> "already running, self-redispatch" -> re-enter at that pc ->
// interpret -> it is an eret -> repeat. MEASURED at 180,000 iterations/sec retiring zero guest
// instructions (census: eret n and self both +180k/s, gap interp +180k/s, handler entries frozen).
// Hardware cannot reach this: the dispatcher runs with EXL set/IE clear so it cannot be
// interrupted at its own eret; our parked-artifact bypass opens the door. Same law as the rest of
// this file - a venue that cannot name an honest resume pc DEFERS, it does not lie.
// TRIED AT BOTH LATCH VENUES (mask-poll and interp-poll) 08-27 and REVERTED: the guard
// NEVER FIRED in 6 unattended boots, so the measured loop is entered by another path and
// this is not where it starts. Helper kept unused as the record; find the real re-entry
// (fiber_proc chase / tf->epc) before re-arming it.
[[maybe_unused]] static inline bool bm_pc_is_eret(uint32_t pc) {
    if (g_rdram == nullptr) return false;
    const uint32_t off = pc & 0x1FFFFFFFu;
    if (off + 4u >= 0x00800000u) return false;
    return *(const uint32_t*)(g_rdram + off) == 0x42000018u;   // ERET
}

// [idle-census 2026-08-27] Why does an interrupt not reach the guest? Every existing print in
// this function is CAPPED, so a refusal happening thousands of times per second is invisible after
// the first eight. Counters cannot lie by omission: one per exit path, reported by the 1Hz
// spin-watch. Measured motivation: 9,351 VI retraces produced 61 drains.
//   0 disabled  1 gate-held (SR blocked, thread not parked)  2 yielded to root
//   3 nothing pending  4 DRAINED
std::atomic<uint64_t> g_idle_census[5] = {};
extern "C" uint64_t recomp_bm_idle_census(int i) { return (i>=0 && i<5) ? g_idle_census[i].load(std::memory_order_relaxed) : 0; }

extern "C" void recomp_baremetal_idle() {
    g_idle_entries.fetch_add(1, std::memory_order_relaxed);
    if (!g_enabled || g_handler == 0 || g_ctx == nullptr) { g_idle_census[0].fetch_add(1, std::memory_order_relaxed); return; }
    // Hardware interrupt gate (auto-bm): the line is HELD while the guest runs with interrupts
    // disabled (Status.IE=0) or inside an exception (EXL/ERL set) — the kernel's scheduler
    // mutations (current-task word, run queue) rely on exactly that. Draining inside such a
    // critical section runs the handler mid-mutation and tears the pointers it walks (observed:
    // current-task word 0x800E7CA0 → 0x00047CA0, high half replaced). Pending interrupts stay
    // noted; the next legal venue (IE restored) drains them. NC keeps its proven behavior.
    if (g_autobm) {
        // SR SPLIT-BRAIN (2026-08-06): since the per-fiber register files (cf36d17), each fiber's
        // own file carries its own status_reg — the kernel's per-thread SR virtualization, kept
        // coherent by the dispatcher's mtc0 + bm_ctx_copy at every dispatch. The PHYSICAL SR at
        // any instant is the RUNNING execution's file, not g_ctx (measured on turok: the fiber's
        // osRestoreInt set IE on its own file while this gate read g_ctx's stale 0x00000000 and
        // refused every drain forever). Read the running file.
        uint32_t _sr = (uint32_t)cop0_status_read(bm_exec_sr_ctx());
        // [parked-artifact 2026-08-26] the gatewhy instrument's prediction, now measured: 24M
        // refused drains with the worker tcb state=WAITING(8) and SR=0xFF00 — stock libultra
        // yields INSIDE the __osDisableInt bracket (osRecvMesg -> __osEnqueueAndYield), so a
        // PARKED thread's file always shows IE-clear. On hardware the dispatcher restores the
        // NEXT thread's SR, so IE-clear never describes the running CPU across a park. Gate only
        // when the current thread is NOT parked: state=WAITING means the IE-clear is an artifact
        // and the line must stay open (holding it deadlocks the completion the parker waits for).
        uint32_t _pkstate = 0;
        if ((g_rdram != nullptr) && (g_current_tcb != 0u)) {
            const uint32_t _tp = g_current_tcb & 0x00FFFFFFu;
            if ((_tp + 0x14u) < 0x00800000u) _pkstate = (*(const uint32_t*)(g_rdram + _tp + 0x10u)) >> 16;
        }
        // [bypass narrowed 2026-08-27] The parked-artifact rationale is about IE-CLEAR only:
        // stock libultra yields INSIDE __osDisableInt (osRecvMesg -> __osEnqueueAndYield), so a
        // parked thread's file always shows IE clear and holding the line there deadlocks the
        // completion it waits for. EXL/ERL set is a DIFFERENT statement — the guest is genuinely
        // inside an exception, running its own handler/dispatcher — and delivering there is how a
        // dispatcher address gets latched as the interrupted pc and canonized into a TCB. That
        // poisoning was measured: worker TCB saved pc = 0x800C3EC0 (inside the dispatcher), then
        // 10.5M self-redispatches in one boot at ~580k/sec retiring zero guest instructions.
        // So bypass ONLY for the parked IE-clear artifact, never while EXL/ERL is set.
        if ((_sr & 0x6u) == 0u && (_sr & 0x1u) == 0u && (_pkstate == 8u)) {
            static int _pb = 0;
            ++_pb;
            if (_pb <= 8 || (_pb % 100000) == 0) {
                fprintf(stderr, "[bmsched] gate BYPASS #%d: SR=0x%08X blocked but tcb 0x%08X state=WAITING - parked artifact, draining%c", _pb, _sr, g_current_tcb, 0x0A);
                fflush(stderr);
            }
        }
        // FULL HARDWARE TAKE-CONDITION (2026-08-06): IE=1 AND EXL=0 AND ERL=0 — the VR4300 takes
        // an interrupt only then. The IE half was previously dropped ("over-blocked" — the fifa
        // EA-kernel dig, whose bracket is EXL-based), but stock-libultra kernels bracket their
        // scheduler mutations with IE alone (__osDisableInt = clear SR.IE), and delivering
        // through that bracket tears the dispatch mid-mutation: measured on turok 08-06 — VI
        // drain at an interp'd mask write with SR=0x0000FF00 (IE=0) inside osStartThread's
        // critical section; the guest then canonized the interrupted pc into the WRONG thread's
        // TCB (boot thread's continuation written to the just-started thread) and the boot died
        // at piDMA=0. Delivery moments are covered by the edge venues: EXL-falling AND
        // IE-rising both route through cop0_status_write -> recomp_baremetal_mask_poll.
        // Bootstrap is safe: libultra's first dispatch restores the boot thread's SR (IE=1)
        // through cop0_status_write before any delivery is needed.
        // [bypass narrowed 2026-08-27 — this is the condition that actually HOLDS; the block above
        // only prints. Adding "|| EXL/ERL set" means a PARKED thread no longer bypasses the gate
        // while the guest is inside an exception, which is where a dispatcher address gets latched
        // as the interrupted pc and canonized into a TCB (measured: worker saved pc = 0x800C3EC0,
        // then 10.5M self-redispatches/boot at ~580k/sec retiring zero guest instructions).]
        if (((_sr & 0x6u) != 0u || (_sr & 0x1u) == 0u) && ((_pkstate != 8u) || ((_sr & 0x6u) != 0u))) {
            static int _gb = 0;
            ++_gb;
            if (_gb <= 8 || (_gb % 2000) == 0) {
                // [gatewhy] (SOTE 2026-08-26) — instrument only. The gate cannot tell "the CPU is
                // genuinely inside a critical section" from "the last-running thread is PARKED at a
                // blocking yield, which stock libultra always leaves with IE clear". osRecvMesg
                // brackets its whole body in __osDisableInt/__osRestoreInt and yields in the middle
                // (SOTE: __osEnqueueAndYield at 0x800C3DF0, resume point 0x800BD338); on hardware
                // the dispatcher restores the NEXT thread's SR, so IE-clear never describes the
                // running CPU — but our fiber model leaves the blocked thread's file as "running".
                // OSThread.state lives at +0x10 (u16, high half of this word) and reads
                // OS_STATE_WAITING(8) for a thread blocked on a queue. If that is what we see here,
                // the IE-clear is a parked-thread artifact and holding the line deadlocks the game.
                uint32_t _tstate = 0xFFFFFFFFu, _tpri = 0xFFFFFFFFu;
                if ((g_rdram != nullptr) && (g_current_tcb != 0u)) {
                    const uint32_t _tphys = g_current_tcb & 0x00FFFFFFu;
                    if ((_tphys + 0x18u) < 0x00800000u) {
                        _tstate = *(const uint32_t*)(g_rdram + _tphys + 0x10u);
                        _tpri   = *(const uint32_t*)(g_rdram + _tphys + 0x04u);
                    }
                }
                fprintf(stderr, "[bmsched] drain gated #%d: SR=0x%08X (%s) tcb=0x%08X epc=0x%08X | [gatewhy] stateWord=0x%08X (state=%u%s) pri=%d\n",
                        _gb, _sr, (_sr & 0x6u) ? "EXL/ERL set" : "IE clear", g_current_tcb, recomp_cop0_tlb_read(14),
                        _tstate, (unsigned)(_tstate >> 16),
                        ((_tstate >> 16) == 8u) ? "=WAITING — PARKED, NOT A CRITICAL SECTION" : "", (int)_tpri,
                        (uint32_t)cop0_status_read(bm_exec_sr_ctx()),
                        (g_ctx != nullptr) ? (uint32_t)cop0_status_read(g_ctx) : 0xDEADu,
                        recomp_interp_peek_pc());
                fflush(stderr);
            }
            // [walk-dump 2026-08-06] one-shot: the __osEnqueueThread wedge's walk registers —
            // a0 = the queue being inserted into, a1 = the thread, t8/t9 = cur/prev of the
            // stuck priority walk (turok, 0x800A5E68). Names the corrupt queue for the
            // offline walk of the wedge-time RDRAM capture. Instrument only.
            if (recomp_cop0_tlb_read(14) == 0x800A5E68u) {
                static bool _wd = false;
                if (!_wd) {
                    _wd = true;
                    const uint64_t* r = (const uint64_t*)bm_exec_sr_ctx();
                    fprintf(stderr, "[walk-dump] a0(queue)=0x%08X a1(thread)=0x%08X t7(pri)=0x%08X t8(cur)=0x%08X t9(prev)=0x%08X ra=0x%08X sp=0x%08X\n",
                            (uint32_t)r[4], (uint32_t)r[5], (uint32_t)r[15], (uint32_t)r[24], (uint32_t)r[25], (uint32_t)r[31], (uint32_t)r[29]);
                    fflush(stderr);
                }
            }
            // [stuck-gate watchdog 2026-08-27] TRIED AND REVERTED SAME-DAY. Reasoning was sound —
            // a refusal streak outlasting a video frame cannot be a real libultra critical section
            // (those are microseconds), and this gate was measured refusing 208,051 times in a row
            // on a thread the guest reported RUNNING. Forcing delivery after 20ms DID restore the
            // drains (census DRAIN resumed climbing at the VI rate, watchdog fired 13x), and the
            // game still hung: the erets stayed frozen, so the handler runs and returns without
            // ever dispatching a thread. The gate was never the blocker. Do not re-try this without
            // first explaining why no eret follows a healthy drain.
            g_idle_census[1].fetch_add(1, std::memory_order_relaxed);   // [idle-census] gate held
            return;
        }
        // ── YIELD TO ROOT: never run the handler nested on a task's own fiber ────────────────────
        // The handler must not borrow the stack of the task it interrupts. When it does, an eret
        // back to that same task is the "self-redispatch" case: the dispatcher C-frames underneath
        // are abandoned and the register file has been overwritten, so control cannot simply
        // return — it has to unwind to the fiber's top and RE-ENTER AT THE SAVED EPC. An EPC is a
        // mid-function address (measured: osRecvMesg+0x68, osStartThread+0x134, osSetThreadPri+0xC4),
        // and get_function only ever resolves function ENTRIES, so that re-entry has no native
        // target and falls to recomp_interpret. That is the sole source of interpretation in the
        // self-hosted path.
        //
        // The fiber model already has a stack that belongs to nobody: the scheduler ROOT. Draining
        // there leaves the interrupted task's fiber SUSPENDED AND INTACT, so resuming it is a plain
        // SwitchToFiber — native, mid-function, no lookup. The self-redispatch guard below already
        // exempts the root for exactly this reason (GetCurrentFiber() != g_root_fiber).
        //
        // So a blocked task yields to the root instead of draining in place; the root pump services
        // the interrupt and dispatches whichever task is runnable — which is what a scheduler is.
        // NC mode keeps its proven in-place behaviour.
        if (bm_yield_to_root_if_task_fiber()) { g_idle_census[2].fetch_add(1, std::memory_order_relaxed); return; }   // resumed later by the root's dispatch
    }
    // FATAL-tear recovery (NC-only): a prior scrub (from the idle OR from recomp_eret) rebuilt a torn run
    // queue but left the current-task word pinned to the idle thread, so no eret fired and the cooperative
    // scheduler is frozen. Force a re-dispatch to the rebuilt run-queue head BEFORE the pending gate (the
    // freeze persists even with no new interrupt pending, so we must act regardless of _p). nc_force_redispatch
    // SwitchToFibers the stranded task; it returns here only when that task yields back. Bounded retries via
    // the flag (cleared on consume) so we don't spin if no fiber is eligible.
    if (g_nc_mode && g_orphan_redispatch.exchange(false, std::memory_order_relaxed)) {
        nc_force_redispatch(g_rdram);
    }
    int _p = recomp_baremetal_take_pending();
    if (_p <= 0) { g_idle_census[3].fetch_add(1, std::memory_order_relaxed); return; }   // nothing pending
    g_idle_census[4].fetch_add(1, std::memory_order_relaxed);                            // DRAINED
    { static int _d=0; if(++_d<=8||_d%200==0){fprintf(stderr,"[bmsched] idle DRAIN #%d (pending=%d)\n",_d,_p);fflush(stderr);} }
#ifdef _WIN32
    if (IsThreadAFiber()) g_idle_fiber = GetCurrentFiber();   // [fiber-guard] never record the 0x1E00 non-fiber sentinel as a fiber
#endif
    // ── [EVTAB] one-shot-ish DUMP of NC's event-dispatch table (D_8012D600) SI/SP/DP slots ──────────
    // Each slot at base+arg holds a guest OSMesgQueue pointer (the same word nc_post_event reads as the
    // target queue). We dump SI(+0x28)/SP(+0x38)/DP(+0x48) once they populate so we can capture the exact
    // guest queue addresses NC registered — esp. SP/DP, which only appear AFTER osCreateScheduler runs.
    if (g_nc_mode) {
        static uint32_t _last_si = 0xDEADBEEF, _last_sp = 0xDEADBEEF, _last_dp = 0xDEADBEEF;
        auto rdw = [&](uint32_t va)->uint32_t { uint32_t p = va & 0x1FFFFFFFu; if (p + 4u > 0x800000u) return 0xBADBAD; return *(uint32_t*)(g_rdram + p); };
        uint32_t base = 0x8012D600u;
        uint32_t si = rdw(base + 0x28u);
        uint32_t sp = rdw(base + 0x38u);
        uint32_t dp = rdw(base + 0x48u);
        if (si != _last_si || sp != _last_sp || dp != _last_dp) {
            _last_si = si; _last_sp = sp; _last_dp = dp;
            fprintf(stderr, "[bmsched][EVTAB] D_8012D600 slots: SI(+0x28)=0x%08X SP(+0x38)=0x%08X DP(+0x48)=0x%08X\n", si, sp, dp);
            // also dump the full +0x00..+0x60 span so we can see PI(+0x40) and any others
            for (uint32_t off = 0x00u; off <= 0x60u; off += 0x8u) {
                uint32_t q = rdw(base + off);
                if ((q >> 28) == 0x8u) {
                    uint32_t vc = rdw(q + 0x8u), mc = rdw(q + 0x10u), wl = rdw(q + 0x0u);
                    fprintf(stderr, "[bmsched][EVTAB]   +0x%02X = queue 0x%08X (validCount=%u msgCount=%u waitlist=0x%08X)\n", off, q, vc, mc, wl);
                }
            }
            fflush(stderr);
        }
    }
    uint32_t _cause = g_cause;
    if (g_autobm) {
        // Design R8 (round 7), reworked for the SOTE sequencer dig: the COUNT/COMPARE timer line
        // (Cause IP7, 0x8000) is a LATCH set by the deadline waiter when COUNT reaches the armed
        // COMPARE, and cleared by ANY guest COMPARE write (the silicon ack protocol — see
        // recomp_baremetal_compare_write). The old level-evaluation (count >= compare re-derived
        // per drain) re-asserted IP7 after the guest's same-value ack rewrite until disarm.
        // Stock-libultra boots block in osSetTimer waits (the fifa-class 90s stall: threads
        // pumping, all parked, swapping only the boot-clear buffer) — the latch covers them at
        // deadline precision instead of VI-note granularity.
        if (recomp_baremetal_ip7_latched()) {
            _cause |= 0x8000u;
            // ── [timertrace] IP7-delivery probe (SOTE sequencer dig; RECOMP_TIMER_TRACE=1) ──────
            // Counts every drain that presents IP7. Compared against the guest's COMPARE-write
            // cadence (tlb.cpp side) this yields delivered-vs-programmed tick rate directly.
            static int _tt_on = -1;
            if (_tt_on < 0) { const char* e = getenv("RECOMP_TIMER_TRACE"); _tt_on = (e && *e && *e != '0') ? 1 : 0; }
            if (_tt_on) {
                static int _n = 0;
                _n++;
                if (_n <= 20 || (_n % 1000) == 0) {
                    uint32_t _compare = recomp_cop0_tlb_read(11);
                    fprintf(stderr, "[timertrace] IP7 assert #%d count=0x%08X compare=0x%08X over=%d\n",
                            _n, recomp_cop0_tlb_read(9), _compare,
                            (int32_t)(recomp_cop0_tlb_read(9) - _compare));
                    fflush(stderr);
                }
            }
        }
    }
    recomp_cop0_tlb_write(13, _cause);                      // present Cause IP bits
    uint32_t _mi = g_pending_mi_bits.exchange(0, std::memory_order_relaxed);
    int _timer_poked = g_timer_poke.exchange(0, std::memory_order_relaxed);
    // ── SPURIOUS-ENTRY GUARD (fifa crawl-basin derail, 2026-08-05) ──────────────────────────────
    // EA-class kernels treat a SOURCELESS handler entry as fatal: scan sources → all zeros →
    // defensively mask everything (cmd 0x555) → eret with no dispatch (k0 still their &MI_INTR
    // scan base, EPC null) = the measured terminal derail. In auto-bm every note carries its MI
    // bits (note_interrupt fetch_or's them), so _mi==0 with no timer latch and no still-pending
    // level bits means NOTHING IS DELIVERABLE — hardware raises no exception here; neither do we.
    // NC keeps its proven behavior below (its drains historically ran on bitless VI notes).
    if (g_autobm && _mi == 0u && !_timer_poked && !recomp_baremetal_ip7_latched()
        && recomp_mi_intr_pending() == 0u) {
        static int _sg = 0;
        if (_sg <= 8 || (_sg % 2000) == 0) { fprintf(stderr, "[bmsched] spurious drain skipped #%d (no source)\n", _sg); fflush(stderr); }
        _sg++;
        return;
    }
    // LEVEL-TRIGGERED presentation (banjo wall 7): OR the new sources into MI_INTR — never
    // overwrite. Bits stay asserted until the game's own device ACK write clears them (VI_CURRENT,
    // SP_STATUS CLR_INTR, SI/AI_STATUS, PI_STATUS bit1, MI_MODE bit11 — all modeled in mmio/pi).
    // The old store() dropped any still-unserviced source on every drain.
    // COMPARE-waiter pokes present NO MI bits (the wake is the IP7 line alone — a fabricated 0x8
    // here would post a phantom VI service message per timer tick).
    // Auto-bm never fabricates: a real source is either in _mi or already level-pending in MI_INTR.
    recomp_present_mi_intr(_mi ? _mi : ((_timer_poked || g_autobm) ? 0u : 0x8u)); // present accumulated MI sources
    // ── [SVCQ] service-queue overflow probe (SOTE stall dig, 2026-07-19; RECOMP_BM_SVCQ=1) ─────────
    // The SOTE-class kernel's post-from-interrupt (0x800C3D08) DROPS the event silently when the
    // registered queue is full — a lost one-shot completion deadlocks its waiter forever. Before the
    // guest handler runs, shadow the service table (0x80193690, {queue,msg} per code; MI bit b maps
    // to code b+4) and log any pending bit whose queue is already at capacity — the exact moment a
    // drop is about to happen. Table base via env RECOMP_BM_SVCTAB (hex) for other kernels.
    {
        static int _svcq_on = -1;
        static uint32_t _svctab = 0x80193690u;
        if (_svcq_on < 0) {
            const char* e = getenv("RECOMP_BM_SVCQ"); _svcq_on = (e && *e && *e != '0') ? 1 : 0;
            const char* t = getenv("RECOMP_BM_SVCTAB"); if (t && *t) _svctab = (uint32_t)strtoul(t, nullptr, 16);
        }
        if (_svcq_on && _mi) {
            auto rdw = [&](uint32_t va)->uint32_t { uint32_t p = va & 0x1FFFFFFFu; if (p + 4u > 0x800000u) return 0u; return *(uint32_t*)(g_rdram + p); };
            for (int b = 0; b < 6; b++) {
                if (!(_mi & (1u << b))) continue;
                uint32_t q = rdw(_svctab + (uint32_t)(b + 4) * 8u);
                if ((q >> 28) != 0x8u) continue;            // handler-pair or unregistered: not a queue
                uint32_t cnt = rdw(q + 8u), cap = rdw(q + 0x10u);
                if (cap != 0u && cnt >= cap) {
                    fprintf(stderr, "[bmsched][SVCQ] DROP-IMMINENT mi_bit=%d code=%d q=0x%08X count=%u cap=%u\n",
                            b, b + 4, q, cnt, cap);
                    fflush(stderr);
                }
            }
        }
    }
    // Status presentation: NC mode overwrites SR with the cause bits (its handler only tests the IP
    // line). A stock-libultra handler tests (Status & Cause & IM) AND depends on its own SR state
    // (FR/KX/IE) — OR the pending line + IE in, never clobber. The merge source must be the GUEST-
    // VISIBLE Status (ctx->status_reg, what mfc0 reads and mtc0/thread-SR-restores write), NOT the
    // generic cop0 array's reg 12 — that backing never carries the IM bits, so sourcing from it
    // rewrote SR to 0x401 every drain, wiping IM4 (0x1000, pre-NMI mask; set on every real libultra
    // boot). Rare titles tamper-check exactly that bit ((SR & 0x1000)==0 -> show piracy screen, hang
    // an osDpSetStatus(DPC_CLR_FREEZE) loop forever = banjokazooie's empty-frame-loop wall).
    // Auto-bm: also SET Status.EXL (bit1) — hardware raises it on exception entry; the handler's
    // eret clears it (recomp_eret). Completes the EXL lifecycle the drain gate keys on.
    // PER-FIBER FILES (auto-bm): seed the handler's register file (g_ctx) from the interrupted
    // task's own file BEFORE presenting the exception state onto it — hardware exception entry
    // presents exactly the interrupted thread's registers, and the guest handler's save protocol
    // depends on it (the shared-ctx model handed it a mongrel of whoever ran last — the k0-leak
    // class: fifa's current-task word overwritten with EA's &MI_INTR dispatch base).
    // ── [hverify] HANDLER LIVENESS GATE (SOTE, 2026-08-26) — env RECOMP_HANDLER_VERIFY=1 ────────
    // A packed title rebuilds its code image at a phase change and may stomp the very region its
    // exception vector points at, mid-rewrite. On hardware that window is sub-frame — no interrupt
    // can observe it. In this engine the same window is dilated ~100x (SOTE: new code lands at
    // t=188379ms, the old handler region is stomped 121ms — seven VI periods — later, and the next
    // diag lines are a drain-derail INTO the half-stomped handler that kills the unpacker's world:
    // the frozen phase-2 capture is self-inconsistent, new code jal'ing a region that is still
    // fill). Contract restored here: never deliver through a handler whose live bytes are no
    // longer plausible code. Two parts, both read-only until they act:
    //   (a) vector follow — if the guest re-pointed 0x80000180's lui/addiu/jr stub at a NEW
    //       handler, follow it (re-latch, deliver there);
    //   (b) liveness — if the latched handler's bytes changed and are NOT plausible code, HOLD
    //       this delivery: restore the consumed MI bits and return with no state touched. That is
    //       the hardware analog (masked during the rewrite), not a dropped interrupt.
    if (g_autobm && g_handler != 0 && g_rdram != nullptr) {
        static const bool hv_on = [] { const char* e = std::getenv("RECOMP_HANDLER_VERIFY"); return (e == nullptr) || (e[0] != '0'); }();   // DEFAULT ON (hardware executes the handler BYTES, never a stale twin); env=0 = off-instrument
        if (hv_on) {
            // (a) vector follow: lui $k0,hi / addiu $k0,$k0,lo / jr $k0
            const uint32_t v0 = *(uint32_t*)(g_rdram + 0x180u);
            const uint32_t v1 = *(uint32_t*)(g_rdram + 0x184u);
            const uint32_t v2 = *(uint32_t*)(g_rdram + 0x188u);
            if (((v0 >> 16) == 0x3C1Au) && ((v1 >> 16) == 0x275Au) && (v2 == 0x03400008u)) {
                const uint32_t vt = (v0 << 16) + (uint32_t)(int32_t)(int16_t)(v1 & 0xFFFFu);
                if ((vt >> 28) == 0x8u && vt != g_handler) {
                    fprintf(stderr, "[hverify] VECTOR RE-POINTED 0x%08X -> 0x%08X — following\n", g_handler, vt);
                    fflush(stderr);
                    g_handler = vt;
                }
            }
            // (b) liveness of the (possibly just re-latched) handler bytes
            const uint32_t hp = g_handler & 0x00FFFFFFu;
            uint64_t hh = 1469598103934665603ull;
            for (uint32_t i = 0; i < 0x20u && (hp + i) < 0x00800000u; i++) { hh ^= g_rdram[hp + i]; hh *= 1099511628211ull; }
            static uint64_t hv_latched = 0;      // captured on the first drain (boot handler, known good)
            static uint32_t hv_latched_for = 0;  // ...and re-captured whenever g_handler moves
            if (hv_latched == 0 || hv_latched_for != g_handler) { hv_latched = hh; hv_latched_for = g_handler; }
            else if (hh != hv_latched) {
                // [ghost-delivery 2026-08-26 — THE STEP-BACK FIX] With the I-cache ghost armed and
                // covering the handler, a mid-wave delivery is NOT dangerous: the drain resolves the
                // handler through get_function -> live-gap interpreter, whose fetches serve the
                // PRE-WAVE ghost bytes — the OLD handler, valid code, intact data. And it is NOT
                // optional either: the B1 wave is STAGED — the loader parks in osRecvMesg between
                // segments waiting for PI completions that only the OLD kernel's handler chain can
                // post (the banked flagpoke diagnosis: "the payload arrives; only the SIGNAL is
                // missing — the completer's kernel was eaten by the load"). Holding delivery here
                // IS the month-old wall: the wave freezes mid-flight, and the frozen bytes are what
                // the settle heuristic then mistook for completion. So: ghost armed ⇒ deliver
                // normally, exactly as pre-wave (the transition isn't special; the I-cache makes it
                // invisible). The wave then truly completes; the loader tail creates + starts the
                // new program's boot thread (osCreateThread tcb=0x80112A80 entry=0x8001750C — read
                // from the July intro snapshot); the new kernel's own init installs its world and
                // its CACHE invalidates dissolve the ghost line by line.
                if (recomp_icache_ghost_covers(g_handler)) {
                    g_wave_active.store(1, std::memory_order_relaxed);   // [pi-pace v2] bytes now land at completion
                    // [world-reset 08-27] first delivery of a NEW transition (fresh since boot or
                    // since the last wave-settle): the kernel is being replaced in place — purge
                    // the engine's view of the OLD world before serving the new one.
                    if (g_wave_fresh) { g_wave_fresh = false; bm_world_reset(); }
                    static int _gd = 0;
                    ++_gd;
                    if (_gd <= 6 || (_gd % 2000) == 0) {
                        fprintf(stderr, "[ghost-delivery] #%d handler bytes differ from latch but ghost covers 0x%08X — delivering via pre-wave ghost code%c", _gd, g_handler, 0x0A);
                        fflush(stderr);
                    }
                } else {
                // [wave-settle 2026-08-26] STABILITY RELEASE — the half STRICT was missing. STRICT
                // is right to refuse content classification (two heuristics accepted the 0x73 fill
                // and died at 184s). But a hold that can never end deadlocks a SUCCESSFUL swap: the
                // ghostboot run measured the NEW handler (first=3C1A8019) byte-stable across 2000
                // consecutive held deliveries while the guest idled forever. Release needs BOTH:
                //   (a) stability — the same non-latch hash across >=50 consecutive holds (~280ms
                //       at the VI rate; a wave mid-rewrite keeps changing the hash), AND
                //   (b) the vector-handler preamble contract — first insn `lui k0,%hi(...)`
                //       (0x3C1Axxxx), the same contract try_autoarm decodes. The 0x73/garbage
                //       fills of the two burned heuristics fail (b); a half-written wave fails (a).
                // On release: the settled bytes become the latch (the new handler IS the handler),
                // the ghost full-syncs (the loader's cache invalidate, dropped from native twins),
                // and the old program's DIRECT poster is retired. Delivery then proceeds normally
                // into the NEW kernel's handler.
                bool ws_release = false;
                {
                    static uint64_t ws_seen = 0; static int ws_stable = 0;
                    if (hh == ws_seen) { ++ws_stable; } else { ws_seen = hh; ws_stable = 1; }
                    const uint32_t ws_w0 = *(uint32_t*)(g_rdram + hp);
                    if (ws_stable >= 50 && (ws_w0 & 0xFFFF0000u) == 0x3C1A0000u) {
                        hv_latched = hh; hv_latched_for = g_handler;
                        recomp_icache_ghost_sync_all(g_rdram);
                        g_svc_poster = nullptr;
                        fprintf(stderr, "[wave-settle] handler 0x%08X STABLE across %d held deliveries (first=%08X %08X) — re-latched, ghost synced, poster retired; delivering into the NEW kernel%c",
                                g_handler, ws_stable, ws_w0, *(uint32_t*)(g_rdram + hp + 4u), 0x0A);
                        fflush(stderr);
                        ws_release = true;
                        ws_stable = 0; ws_seen = 0;
                        g_wave_fresh = true;   // [world-reset] transition complete: the NEXT
                                               // ghost-delivery marks a new one and resets again
                    }
                }
                if (!ws_release) {
                // STRICT (10:44, third cut): NO acceptance heuristic. Round 1 delegated to
                // recomp_interp_is_code (accepted 0x73737373 fill); round 2 added uniformity
                // rejection (the real fill carries embedded compressed bytes — 7373B5AE A3EAD27D —
                // so 8 words are NOT uniform and it still re-latched garbage and died at 184s,
                // twice, identically). Ground truth is simpler than classification: the native
                // handler `h` was compiled from the LATCHED bytes, so it is valid ONLY while the
                // live bytes match them. Any change ⇒ HOLD (the hardware analog: the guest masks
                // interrupts across a handler rewrite). If a future title legitimately installs a
                // new same-address handler, acceptance needs a real validator — not is_code.
                // ── [hverify-direct] deliver WITHOUT the handler (env RECOMP_HVERIFY_DIRECT=1) ──
                // The handler's CODE is gone but its DATA lives: the service table still holds
                // (queue,msg) pairs (probed at hold time: SP/SI/VI/PI/DP all valid, AI=0 as the
                // July decode says). The game-registered poster IS the handler's post half — run it
                // for each held source (a0 = code*8), exactly the call the stomped dispatch case
                // would have made. The poster posts into the guest ring and wakes the waitlist via
                // the kernel's own routines (all compiled July code, all data-driven from intact
                // structures). Bits with no registered queue are dropped like hardware acks them.
                {
                    static const bool hv_direct = [] { const char* e = std::getenv("RECOMP_HVERIFY_DIRECT"); return (e != nullptr) && (e[0] == '1'); }();
                    if (hv_direct && (g_svc_poster != nullptr)) {
                        uint32_t delivered = 0;
                        for (int b = 0; b < 6; b++) {
                            if ((_mi & (1u << b)) == 0u) continue;
                            const uint32_t toff = (g_svc_table & 0x00FFFFFFu) + (uint32_t)(b + 4) * 8u;
                            const uint32_t q = (toff + 8u <= 0x00800000u) ? *(uint32_t*)(g_rdram + toff) : 0u;
                            if ((q >> 28) != 0x8u) { delivered |= (1u << b); continue; }   // unregistered: ack+drop
                            // [frame-tick] the thread first on this queue's waitlist is the one
                            // the poster is about to wake - remember it so the resume path can
                            // DISPATCH it (the engine half the dead handler's eret used to do).
                            // 0x800E7CA0 = the kernel's empty-list sentinel, never a real TCB.
                            {
                                const uint32_t wl = *(uint32_t*)(g_rdram + (q & 0x00FFFFFFu));
                                if (((wl >> 28) == 0x8u) && (wl != 0x800E7CA0u)) g_direct_wakee = wl;
                            }
                            uint64_t* rf = (uint64_t*)g_ctx;
                            const uint64_t saved_a0 = rf[4];
                            const uint64_t saved_ra = rf[31];
                            rf[4] = (uint64_t)(int64_t)(int32_t)((uint32_t)(b + 4) * 8u);
                            g_svc_poster(g_rdram, g_ctx);
                            rf[4] = saved_a0;
                            rf[31] = saved_ra;
                            recomp_ack_mi_intr(1u << b);
                            delivered |= (1u << b);
                            static int _dd = 0;
                            ++_dd;
                            if (_dd <= 12 || (_dd % 2000) == 0) {
                                fprintf(stderr, "[hverify] DIRECT #%d: posted mi bit%d via guest poster (q=0x%08X msg=0x%08X)\n",
                                        _dd, b, q, *(uint32_t*)(g_rdram + toff + 4u));
                                fflush(stderr);
                            }
                        }
                        _mi &= ~delivered;
                    }
                }
                if (_mi != 0u) g_pending_mi_bits.fetch_or(_mi, std::memory_order_relaxed);
                static int hv_holds = 0;
                ++hv_holds;
                if (hv_holds <= 8 || (hv_holds % 2000) == 0) {
                    fprintf(stderr, "[hverify] HOLD #%d: handler 0x%08X bytes changed since latch (first=%08X %08X) — delivery held, mi=0x%X restored\n",
                            hv_holds, g_handler, *(uint32_t*)(g_rdram + hp), *(uint32_t*)(g_rdram + hp + 4), _mi);
                    fflush(stderr);
                }
                // [icache-ghost] arm at wave detection (env RECOMP_ICACHE_GHOST=1): the first hold
                // IS the moment the wave is caught mid-rewrite — snapshot the kernel range so
                // interpreted continuations keep executing the PRE-WAVE code, exactly as the
                // VR4300's un-invalidated I-cache does on hardware. The new program's own code
                // (0x8030xxxx+) is outside the range and executes live.
                {
                    static const bool ig_on = [] { const char* e = std::getenv("RECOMP_ICACHE_GHOST"); return (e == nullptr) || (e[0] != '0'); }();   // DEFAULT ON (the VR4300 I-cache has no enable bit); env=0 = off-instrument
                    if (ig_on && hv_holds == 1) {
                        recomp_icache_ghost_arm(g_rdram, 0x80000400u, 0x801A0000u);
                    }
                }
                // [sleepers] one-shot kernel-state dump: WHO waits on WHAT. For every service-table
                // queue (plus the shared event-pump queue), dump validCount/msgCount and WALK THE
                // WAITLIST — each parked TCB names itself (addr, pri@+4, state@+0x10). This replaces
                // a week of inference about what the worker is blocked on with one printed fact.
                if (hv_holds == 1 || hv_holds == 100) {
                    auto rdw = [&](uint32_t va) -> uint32_t {
                        const uint32_t p = va & 0x00FFFFFFu;
                        return (p + 4u <= 0x00800000u) ? *(uint32_t*)(g_rdram + p) : 0u;
                    };
                    fprintf(stderr, "[hverify][sleepers] kernel state at hold #%d: curtask[0x800E7CB0]=0x%08X\n",
                            hv_holds, rdw(0x800E7CB0u));
                    {
                        extern uint32_t g_park_ring[16][2];
                        extern uint32_t g_park_ring_n;
                        fprintf(stderr, "[hverify][park-ring] last yields (oldest->newest):");
                        for (uint32_t k = 0; k < 16u; k++) {
                            const uint32_t i = (g_park_ring_n + k) & 15u;
                            if (g_park_ring[i][0] != 0u)
                                fprintf(stderr, " %08X@%08X", g_park_ring[i][0], g_park_ring[i][1]);
                        }
                        fputc(0x0A, stderr);
                    }
                    uint32_t qs[8]; int nq = 0;
                    for (int b = 0; b < 6; b++) {
                        const uint32_t q = rdw(g_svc_table + (uint32_t)(b + 4) * 8u);
                        bool dup = false;
                        for (int k = 0; k < nq; k++) if (qs[k] == q) dup = true;
                        if (!dup && ((q >> 28) == 0x8u) && nq < 8) qs[nq++] = q;
                    }
                    for (int k = 0; k < nq; k++) {
                        const uint32_t q = qs[k];
                        fprintf(stderr, "[hverify][sleepers]   q=0x%08X valid=%u cap=%u first=%u | waitlist:",
                                q, rdw(q + 8u), rdw(q + 0x10u), rdw(q + 0xCu));
                        uint32_t t = rdw(q + 0u);
                        for (int hop = 0; hop < 6 && ((t >> 28) == 0x8u); hop++) {
                            fprintf(stderr, " tcb=0x%08X(pri=%d,state=%u)", t,
                                    (int)rdw(t + 4u), (unsigned)(rdw(t + 0x10u) >> 16));
                            t = rdw(t + 0u);
                        }
                        fprintf(stderr, "%s\n", (rdw(q + 0u) >> 28) == 0x8u ? "" : " (empty)");
                    }
                    fflush(stderr);
                }
                // [svcq-at-hold] Is the guest kernel's service table still LIVE while its handler
                // is stomped? If table[src] holds a valid queue, the held delivery can be done
                // DIRECTLY (post the message the handler would have posted) — the NC-class direct
                // lane, generalized. One-shot dump on the first holds; read-only.
                if (hv_holds <= 3) {
                    const uint32_t svctab = 0x80193690u;   // SOTE kernel service table (July decode; SVCQ default)
                    fprintf(stderr, "[hverify][svcq] service table @0x%08X:", svctab);
                    for (int b = 0; b < 6; b++) {
                        const uint32_t off = (svctab & 0x00FFFFFFu) + (uint32_t)(b + 4) * 8u;
                        const uint32_t q = (off + 4u <= 0x00800000u) ? *(uint32_t*)(g_rdram + off) : 0u;
                        fprintf(stderr, " bit%d(code%d)=0x%08X", b, b + 4, q);
                    }
                    fprintf(stderr, "\n");
                    fflush(stderr);
                }
                // HOLD ≠ HALT (10:55 — the mine in the first cut of this gate): the drain runs on
                // the ROOT with the interrupted task's fiber suspended; the normal path resumes it
                // through the handler's eret. Returning without resuming ANYONE parked the whole
                // guest world forever (measured: post-transition, ZERO bmsched RESUMED lines,
                // zero erets, zero MMIO reads — the unpacker's fiber sat suspended while ~12,000
                // holds ticked at 60Hz). Masked-interrupt hardware semantics are "delivery waits,
                // EXECUTION CONTINUES" — so resume the interrupted task undelivered, register file
                // untouched.
                // [loop-ring] at hold #200 the post-wave world has settled into its poll loop;
                // the armed interp ring (INTERP_TRACE_RING) holds the last 64 pcs the interpreter
                // executed - the worker's ACTUAL loop body, no inference. One dump.
                if (hv_holds == 200) { recomp_interp_ring_dump("post-wave poll loop"); }
                bm_resume_interrupted_task();
                return;
                }   // if (!ws_release) — settle falls through to normal delivery below
                }   // else (no ghost cover) — ghost-delivery falls through to normal delivery
            }
        }
    }
    if (g_autobm) bm_seed_handler_ctx();
    cop0_status_write(g_ctx, g_autobm ? ((uint32_t)cop0_status_read(g_ctx) | g_cause | 3u) : g_cause);
    if (g_nc_mode) nc_scrub_scheduler_region(g_rdram);      // repair any high-half-truncated scheduler pointers
                                                            // BEFORE the handler walks the run-queue (NC-only)
    // ── DIRECT EVENT DELIVERY (NC class) ──────────────────────────────────────────────────────────
    // For the RCP sources whose event the engine cannot deliver through the HLE message system (PI/SP/DP:
    // their queues are NC's OWN OSMesgQueues registered via NC's un-named osSetEventMesg, so the HLE
    // producer/wake path can't reach them), post directly through NC's own event poster func_80080D7C.
    // This writes the event message into the guest ring AND runs NC's wait-list wake (re-adds the blocked
    // TCB to the run queue) — the exact, HW-faithful delivery the un-named MI-dispatch chain fails to do.
    // VI stays HLE (osViSetEvent is named, the engine sees NC's VI queue), so we do NOT post VI here.
    // ── WAKE the NC TCB blocked on a bare-metal osPiStartDma completion queue ──────────────────────
    // The HLE message system already delivers the PI completion into the queue osPiStartDma named (its
    // validCount is incremented by the external-message drain in pause_self), but it cannot re-queue the
    // NC TCB that blocked in NC's osRecvMesg on that queue. Run NC's own wait-list wake here so the boot
    // thread is rescheduled to re-poll the (now-present) message and continue its overlay load. We keep
    // trying on each drain until the wait-list is empty (the waiter has been moved to the run queue).
    {
        // Deliver the PI/SI completion into the waiting NC queue ring and wake the blocked NC TCB, in NC's
        // own layout, on the game thread. nc_deliver_and_wake returns true once NC has consumed the message
        // (ring empty + no waiter) — only then do we clear the pending mq. Same pattern for every bare-metal
        // RCP completion whose event NC registered in its OWN table (so the HLE producer has a NULL queue).
        uint32_t pimq = g_pi_mq.load(std::memory_order_relaxed);
        if (pimq != 0 && nc_deliver_and_wake(pimq, 0u)) g_pi_mq.compare_exchange_strong(pimq, 0, std::memory_order_relaxed);
        uint32_t simq = g_si_mq.load(std::memory_order_relaxed);
        if (simq != 0 && nc_deliver_and_wake(simq, 0u)) g_si_mq.compare_exchange_strong(simq, 0, std::memory_order_relaxed);

        // Raw-SI / SP-done / DP-done: NC registered these queues in its OWN event table (D_8012D600+arg),
        // not via a guest mq we could capture. The host thread only flagged the completion; resolve the
        // queue from the event table here and deliver+wake on the game thread (same nc_deliver_and_wake).
        auto evtab_q = [&](uint32_t arg)->uint32_t {
            uint32_t p = (NC_EVTAB_BASE + arg) & 0x1FFFFFFFu;
            if (p + 4u > 0x800000u) return 0;
            uint32_t q = *(uint32_t*)(g_rdram + p);
            return ((q >> 28) == 0x8u) ? q : 0u;
        };
        if (g_rawsi_pending.load(std::memory_order_relaxed)) {
            uint32_t q = evtab_q(0x28u);                       // NC SI/controller queue (e.g. 0x8012D248)
            if (q == 0 || nc_deliver_and_wake(q, 0u)) g_rawsi_pending.store(0, std::memory_order_relaxed);
        }
        if (g_sp_pending.load(std::memory_order_relaxed)) {
            uint32_t q = evtab_q(g_arg_sp);                    // NC SP/gfx-done queue (+0x38, e.g. 0x8012E930)
            if (q == 0 || nc_deliver_and_wake(q, 0u)) g_sp_pending.store(0, std::memory_order_relaxed);
        }
        if (g_dp_pending.load(std::memory_order_relaxed)) {
            uint32_t q = evtab_q(g_arg_dp);                    // NC DP-done queue (+0x48, e.g. 0x80104940)
            if (q == 0 || nc_deliver_and_wake(q, 0u)) g_dp_pending.store(0, std::memory_order_relaxed);
        }
        // VI retrace -> NC gfx scheduler queue (e.g. 0x80104940). Deliver the scheduler's retrace message
        // into its ring + wake the scheduler TCB so it advances one frame (and submits the gfx task). We
        // have the actual mq+msg the game registered (captured in events.cpp), so deliver directly. Cleared
        // each idle (re-armed every retrace); the empty-ring guard avoids stacking duplicate retrace msgs.
        {
            uint32_t vimq = g_vi_mq.exchange(0, std::memory_order_relaxed);
            if (vimq != 0) nc_deliver_and_wake(vimq, g_vi_msg.load(std::memory_order_relaxed));
        }
    }
    // Prefer the NATIVE (pinned) handler: running it as a recompiled C function means its eret fires from native
    // code, so the fiber switch can't tear an interpreter session mid-flight (the run-queue-corruption root cause).
    // Fall back to the interpreter only if the handler isn't pinned native.
    // AUTO mode resolves through get_function (the handler may live only as LiveRecomp gap code —
    // the proven rawirq path); NC mode keeps the pinned-native-else-interp preference.
    recomp_func_t* h = g_autobm ? get_function((int32_t)g_handler) : recomp_lookup_native(g_handler);
    // [drainsvc] service diagnosis (wall 7): what the handler SAW vs what it ACKED. presented =
    // MI_INTR at entry; mask = the game's computed MI mask; left = MI_INTR after the handler
    // (acks clear bits, so left==presented means the handler serviced NOTHING this drain).
    uint32_t _pre = recomp_mi_intr_pending();
    uint32_t _msk = recomp_mi_intr_mask();
    // [drainpre] — the post-handler drainsvc print almost never fires (handlers eret away),
    // so the first drains' presented sources were invisible. Capped entry-side print: which
    // source entered the guest handler, in order (the fifa first-waker question).
    { static int _dp = 0; if (_dp++ < 12) {
        // [vecdump] the decisive question for raw vectoring: are the game's handler BYTES
        // actually at the vector? A resolved h can be a live-gap trampoline over zeros.
        uint32_t w0 = 0, w1 = 0;
        if (g_rdram != nullptr) {
            // RDRAM is stored in guest byte order; the host word is already swizzled, so read
            // it directly (same convention as every other engine RDRAM word read).
            w0 = *(uint32_t*)(g_rdram + (g_handler & 0x1FFFFFFFu));
            w1 = *(uint32_t*)(g_rdram + ((g_handler + 4) & 0x1FFFFFFFu));
        }
        fprintf(stderr, "[drainpre] #%d presented=0x%02X mask=0x%02X cause=0x%04X native=%d vec[0x%08X]=%08X %08X\n",
                _dp, _pre, _msk, g_cause, h != nullptr, g_handler, w0, w1); fflush(stderr); } }
    // [handler-census 2026-08-27] UNCAPPED pair with the eret census: how many times is the guest
    // exception handler actually entered, versus how many erets come back out of it? [drainsvc]
    // answers the first only up to its cap of 60. If entries climb while erets stay frozen, the
    // handler is returning without dispatching — the whole remaining question on the SOTE hang.
    // [handler-identity] `native=%d` in [drainpre] is only (h != nullptr), and get_function NEVER
    // returns null — overlays.cpp hands back a trampoline. So that field never proved we were
    // calling real recompiled code. Say what h actually IS, once.
    { static bool _hid = false; if (!_hid) { _hid = true;
        fprintf(stderr, "[handler-identity] g_handler=0x%08X h=%p %s (interp_tramp=%p livegap_tramp=%p)%c",
                g_handler, (void*)h,
                (h == recomp_interp_trampoline) ? "= INTERP TRAMPOLINE" :
                (h == recomp_live_gap_trampoline) ? "= LIVE-GAP TRAMPOLINE" : "= real native function",
                (void*)recomp_interp_trampoline, (void*)recomp_live_gap_trampoline, 0x0A);
        fflush(stderr); } }
    g_eret_census[5].fetch_add(1, std::memory_order_relaxed);
    if (h) h(g_rdram, g_ctx);
    else {
        // [interpsrc] the drain venue: the handler itself failed to pin native.
        static int _ih = 0;
        if (_ih++ < 8) { fprintf(stderr, "[interpsrc] drain handler=0x%08X not pinned native\n", g_handler); fflush(stderr); }
        recomp_interpret(g_rdram, g_ctx, g_handler);
    }
    {
        static int _ds = 0;
        if (_ds < 60 || (_ds % 2000) == 0) {
            fprintf(stderr, "[drainsvc] #%d presented=0x%02X mask=0x%02X left=0x%02X native=%d\n",
                    _ds, _pre, _msk, recomp_mi_intr_pending(), h != nullptr);
            fflush(stderr);
        }
        _ds++;
    }
    // NO post-handler wipe (banjo wall 7): the old recomp_set_pending_mi_intr(0) here destroyed
    // every source the handler didn't service in this one invocation — banjo's single SP-done
    // (bundled with SI+VI in one drain) was wiped and its audio thread waited forever. Sources now
    // clear ONLY via the game's own device ACK writes (hardware level-triggered protocol); an
    // unserviced bit persists to the next drain exactly as MI_INTR does on silicon.

    // FATAL-tear recovery (NC-only): if the handler's own scrub just rebuilt a torn run queue without
    // switching, force a re-dispatch immediately (also handled at the top of the next idle cycle, but doing
    // it here resumes the stranded task one drain sooner).
    if (g_nc_mode && g_orphan_redispatch.exchange(false, std::memory_order_relaxed)) {
        nc_force_redispatch(g_rdram);
    }
}

#ifdef _WIN32
struct TaskFiber {
    void*  handle = nullptr;
    uint32_t epc  = 0;        // entry PC, used only to seed the fiber's first run
    uint8_t* rdram = nullptr;
    recomp_context* ctx = nullptr;
    // PER-FIBER REGISTER FILE (auto-bm only, 2026-08-05): this thread's own recomp_context.
    // The shared-ctx model let the handler / other fibers mutate a suspended task's guest
    // registers between its suspension and the dispatcher's restore — the "engine-level
    // register tear across the fiber/native context switch on the SHARED recomp_context"
    // the NC high-half repair names (and fifa's taskptr<-0xA430000C k0 leak). With write-
    // through codegen, copy-on-switch is observably hardware's one-register-file semantics.
    // NC mode keeps the proven shared-ctx behaviour: own stays null there.
    recomp_context* own = nullptr;
    bool started = false;
    int interp_depth = 0;     // this fiber's interp nesting, swapped in/out at fiber switches
                              // (g_interp_depth is a THREAD local shared by all fibers — see
                              // recomp_interp_swap_depth)
    int native_depth = 0;     // companion: this fiber's interp->native-callee nesting (round 6)
    uint32_t live_pc = 0;     // companion: this fiber's parked interp live pc (round 6)
    // [epc-wins 2026-09-05, Rage Wars #152] set by recomp_eret when a dispatch of this PARKED
    // (mid-interp) fiber names a guest EPC that differs from live_pc; consumed at the fiber's
    // yield-to-root resume point, where it unwinds the parked frame so fiber_proc re-enters at epc.
    bool abandon_parked = false;
};
// Thrown on a task fiber to abandon its suspended frames; fiber_proc catches it and re-enters at
// tf->epc (defined here, ahead of bm_yield_to_root_if_task_fiber, which also throws it).
struct BmFiberRedispatch {};
extern "C" int recomp_interp_swap_native(int new_depth);
extern "C" uint32_t recomp_interp_swap_live_pc(uint32_t new_pc);
extern "C" void recomp_interp_native_enter(void);
extern "C" void recomp_interp_native_exit(void);
static int g_root_native_depth = 0;      // the root's slots for the same swaps
static uint32_t g_root_live_pc = 0;

// ── EPC-restore latch (2026-08-06): k0 snapshotted at the guest's `mtc0 ->EPC` ──────────────
// The dispatcher has the TCB in k0 at its EPC restore and clobbers it with the MI address
// before eret (the fake-TCB wall's true mechanism). tlb.cpp calls the hook on every guest EPC
// write; the eret venue consumes the latch when eret-time k0 is unusable.
static uint32_t g_epc_restore_k0 = 0;
extern "C" uint32_t recomp_tlb_translate(uint32_t vaddr);   // tlb.cpp (EPC-honesty range test)
extern "C" int recomp_interp_swap_depth(int new_depth);
extern "C" int recomp_interp_peek_depth(void);
static int g_root_interp_depth = 0;   // the root fiber's slot for the same swap

static void*  g_root_fiber = nullptr;                       // the game thread converted to a fiber (scheduler root)
static std::unordered_map<uint32_t, TaskFiber*> g_fibers;   // key = guest TCB pointer
static TaskFiber* g_running = nullptr;                      // the task fiber currently executing
// The task whose execution the pending interrupt INTERRUPTED (stamped at yield-to-root).
// Hardware exception entry presents the interrupted thread's exact register file to the
// handler; the drain seeds the handler's file (g_ctx) from this fiber's own file.
static TaskFiber* g_interrupted = nullptr;

// The register file holding the machine's LIVE SR: the current guest thread's own file
// (g_running), regardless of which host fiber is executing. The root pump is engine plumbing
// the guest cannot see — from the guest's viewpoint g_running's thread is still "running",
// and hardware evaluates the interrupt take-condition against ITS Status. Measured 08-06:
// a fiber parked via mask-poll at sr=0xFF01 (legal) and the ROOT pump then refused the very
// drain that park requested, because on the root this returned g_ctx whose SR was a stale
// 0xFF00 from the previous handler episode. Fallback g_ctx = pre-fiber boot / dead-end pump.
static recomp_context* bm_exec_sr_ctx() {
    if (g_running != nullptr && g_running->own != nullptr)
        return g_running->own;
    return g_ctx;
}

static void bm_seed_handler_ctx() {
    if (!g_autobm || g_ctx == nullptr) return;
    if (g_interrupted != nullptr && g_interrupted->own != nullptr)
        bm_ctx_copy(g_ctx, g_interrupted->own);
    // [seed-census] the state the guest handler is about to canonize: EPC it will read from
    // COP0, whose register file it got, and whether that task was parked mid-interp. A stale
    // EPC here is the defect-B poison at its injection point.
    if (g_interrupted != nullptr) {
        static std::atomic<long> _sc{0}; long n = ++_sc;
        if (n <= 60 || (n % 500) == 0) {
            // guest_cur = the GUEST's own current-thread variable (*taskptr). If it disagrees
            // with our g_current_tcb at a drain, the handler saves the presented state into
            // the WRONG TCB — the manufactured cross-thread corruption (95E0<-91D0, 08-06).
            uint32_t guest_cur = (g_taskptr != 0 && g_rdram != nullptr)
                               ? *(uint32_t*)(g_rdram + (g_taskptr & 0x1FFFFFFFu)) : 0u;
            if (rc_trace_on("RECOMP_SEED_CENSUS")) fprintf(stderr, "[seed-census] #%ld venue=%s our_tcb=0x%08X guest_cur=0x%08X %s guest_epc=0x%08X parked_depth=%d k0=0x%08X\n",
                    n, tl_drain_venue, g_current_tcb, guest_cur,
                    (guest_cur == g_current_tcb) ? "AGREE" : "**DISAGREE**",
                    recomp_cop0_tlb_read(14), g_interrupted->interp_depth,
                    (g_interrupted->own != nullptr) ? (uint32_t)((const uint64_t*)g_interrupted->own)[26] : 0u);
            fflush(stderr);
        }
    }
}

// ── YIELD TO ROOT (declared above recomp_baremetal_idle) ────────────────────────────────────────
// Never run the interrupt handler nested on the stack of the task it interrupts. When it is, an
// eret back to that same task is the "self-redispatch" case below: the dispatcher C-frames beneath
// are abandoned and the register file has been overwritten, so control cannot simply return — it
// must unwind to the fiber's top and RE-ENTER AT THE SAVED EPC. An EPC is a mid-function address
// (measured on sm64: osRecvMesg+0x68, osStartThread+0x134, osSetThreadPri+0xC4), and get_function
// resolves only function ENTRIES, so that re-entry has no native target and falls to
// recomp_interpret. That is the ONE source of interpretation in the self-hosted path.
//
// The fiber model already owns a stack belonging to no task: the scheduler ROOT. Draining there
// leaves the interrupted task's fiber suspended and intact, so resuming it is a plain
// SwitchToFiber — native, mid-function, no lookup. The self-redispatch guard already exempts the
// root for exactly this reason (GetCurrentFiber() != g_root_fiber).
//
// So a blocked task yields to the root rather than draining in place, and the root pump services
// the interrupt and dispatches whatever is runnable. That is what a scheduler is.
static bool bm_yield_to_root_if_task_fiber() {
    if (g_root_fiber == nullptr) return false;                 // pre-first-eret: no fiber world yet
    // [fiber-guard 2026-09-02, GoldenEye] ultramodern runs every guest thread on its own host std::thread
    // (threads.cpp:455) while g_root_fiber is process-global (set by ConvertThreadToFiber on whichever
    // thread took the first eret). On a host thread that was never converted, GetCurrentFiber() returns
    // the 0x1E00 non-fiber sentinel, the two checks below pass, and SwitchToFiber's context save writes
    // [0x1E00+0x18] = the corpus-wide "WRITE 0x1E18" crash (KERNELBASE, resolved as a bogus exe RVA).
    // Hardware has nothing to yield to here either: drain on this thread. coswitch.cpp:143 already guards
    // its own switch the same way.
    if (!IsThreadAFiber()) return false;
    if (GetCurrentFiber() == g_root_fiber) return false;       // already on the root: drain here
    static int _y = 0;
    if (_y++ < 8) { fprintf(stderr, "[bmsched] idle on task fiber -> yield to root (drain there)\n"); fflush(stderr); }
    // Per-fiber interp-depth swap, outgoing side: restore the ROOT's nesting and park THIS fiber's
    // in its own slot. Storing it elsewhere corrupts the task's count and leaves the root's stale
    // (the documented failure in the cross-task switch below).
    int parked = recomp_interp_swap_depth(g_root_interp_depth);
    int parked_native = recomp_interp_swap_native(g_root_native_depth);
    uint32_t parked_pc = recomp_interp_swap_live_pc(g_root_live_pc);
    if (g_running != nullptr) {
        g_running->interp_depth = parked;
        g_running->native_depth = parked_native;
        g_running->live_pc      = parked_pc;
    }
    // [park-ring] last 16 (tcb, parked_pc) pairs at yield-to-root — the task's true resting pc,
    // captured at the ONE moment it is knowable. Dumped by the [sleepers] probe. Lock-free-ish:
    // single game thread writes; readers tolerate tearing (diagnostic only).
    {
        extern uint32_t g_park_ring[16][2];
        extern uint32_t g_park_ring_n;
        const uint32_t i = (g_park_ring_n++) & 15u;
        g_park_ring[i][0] = g_current_tcb;
        g_park_ring[i][1] = (g_running != nullptr) ? g_running->live_pc : 0u;
    }
    // Stamp the interrupted task: the root's drain seeds the handler's register file from it
    // (hardware: exception entry presents the interrupted thread's exact state).
    if (g_running != nullptr) g_interrupted = g_running;
    // [venue-census] EPC honesty check at the choke point every task-fiber drain passes through:
    // what COP0 EPC will the guest handler read, vs the interpreter's live pc if this fiber is
    // parked mid-interp (parked = the depth just swapped out above). A mismatch with depth>0 is
    // a stale EPC about to be canonized by the guest — defect B's injection (roster 08-06).
    {
        uint32_t cop0_epc = recomp_cop0_tlb_read(14);
        uint32_t live_pc  = recomp_interp_peek_pc();
        int      pdepth   = (g_running != nullptr) ? g_running->interp_depth : 0;
        const char* verdict = (pdepth <= 0) ? "native-park"
                            : (cop0_epc == live_pc) ? "LIVE" : "STALE";
        static std::atomic<long> _vc{0}; long n = ++_vc;

        // [wedge-derail 2026-08-26] first venue-census whose (tcb,live_pc) matches the SOTE
        // wedge fingerprint (08-26 dossier: tcb=0x80112A80 live_pc=0x800C3EC0 or 0x800C4014)
        // — the FIRST hit is the crime scene. Dump this frame + the PREVIOUS frame's fields (the
        // eret/jr that handed the interpreter its first bad PC). One-shot per fingerprint, no rate
        // limit; the derail hits once and cascades.
        {
            static uint32_t _prev_tcb = 0, _prev_epc = 0, _prev_lpc = 0, _prev_sr = 0;
            static const char* _prev_venue = nullptr;
            static int _prev_pdepth = 0;
            static bool _armed_ec0 = true, _armed_014 = true;
            bool hit = false;
            if (_armed_ec0 && live_pc == 0x800C3EC0u) { hit = true; _armed_ec0 = false; }
            if (_armed_014 && live_pc == 0x800C4014u) { hit = true; _armed_014 = false; }
            if (hit) {
                fprintf(stderr, "[wedge-derail] FIRST hit tcb=0x%08X live_pc=0x%08X epc=0x%08X sr=0x%08X venue=%s pdepth=%d\n",
                        g_current_tcb, live_pc, cop0_epc,
                        (g_ctx != nullptr) ? (uint32_t)cop0_status_read(bm_exec_sr_ctx()) : 0u,
                        tl_drain_venue, pdepth);
                fprintf(stderr, "[wedge-derail] PREV       tcb=0x%08X live_pc=0x%08X epc=0x%08X sr=0x%08X venue=%s pdepth=%d\n",
                        _prev_tcb, _prev_lpc, _prev_epc, _prev_sr,
                        _prev_venue ? _prev_venue : "(null)", _prev_pdepth);
                fflush(stderr);
            }
            _prev_tcb    = g_current_tcb;
            _prev_epc    = cop0_epc;
            _prev_lpc    = live_pc;
            _prev_sr     = (g_ctx != nullptr) ? (uint32_t)cop0_status_read(bm_exec_sr_ctx()) : 0u;
            _prev_venue  = tl_drain_venue;
            _prev_pdepth = pdepth;
        }
                if (n <= 60 || (n % 500) == 0 || (pdepth > 0 && cop0_epc != live_pc)) {
            if (rc_trace_on("RECOMP_VENUE_CENSUS")) fprintf(stderr, "[venue-census] #%ld venue=%s tcb=0x%08X cop0_epc=0x%08X live_pc=0x%08X depth=%d sr=0x%08X -> %s\n",
                    n, tl_drain_venue, g_current_tcb, cop0_epc, live_pc, pdepth,
                    (g_ctx != nullptr) ? (uint32_t)cop0_status_read(bm_exec_sr_ctx()) : 0u, verdict);
            fflush(stderr);
        }
    }
    // Clear the drain gate BEFORE handing the thread to the root. tl_eret_drain is HOST-THREAD-
    // local, shared by every fiber on this thread — the interp-poll venue sets it around its
    // idle call, so carrying it across this switch hands the root a permanently-set gate: the
    // canonical pump spins on `!tl_eret_drain` forever while the suspended yielder (the only
    // code that would clear it) waits on a dispatch only a drain can cause. Measured on fifa
    // (2026-08-05): pump engaged, idle DRAIN #1..#2, then thousands of notes and no drain ever
    // again. Same law as the committed-dispatch clear in recomp_eret's switch path.
    tl_eret_drain = false;
    TaskFiber* self = g_running;   // [epc-wins] the fiber parking here
    SwitchToFiber(g_root_fiber);
    // [epc-wins 2026-09-05] Resumed by a dispatch whose guest EPC differed from this fiber's parked
    // interp pc (decided in recomp_eret, see abandon_parked). Hardware jumps to EPC; the parked
    // frame beneath us is fiction. Unwind to fiber_proc, which re-enters at tf->epc with the guest
    // file the dispatch copied in (InterpScope RAII rebalances the depth during the unwind).
    if (self != nullptr && self->abandon_parked) {
        self->abandon_parked = false;
        static int _ab = 0;
        if (_ab++ < 40) { fprintf(stderr, "[epc-wins] resume: abandoning the parked frame of tcb=0x%08X -> fiber_proc re-enters at epc=0x%08X\n", g_current_tcb, self->epc); fflush(stderr); }
        throw BmFiberRedispatch{};
    }
    return true;
}

// [hverify] HOLD ≠ HALT (2026-08-26): resume the interrupted task WITHOUT delivering. The gate's
// first cut returned from the drain with the yielded task still suspended — and since dispatch
// only ever happens through the handler's eret, holding every delivery parked the entire guest
// world (post-transition: zero RESUMED, zero erets, zero MMIO reads while ~12k holds ticked).
// Masked hardware doesn't stop the CPU; it keeps executing and delivers later. Mirror of the
// root-eret resume path below, minus the ctx copy — nothing was delivered, the task's own file
// is already correct. Returns control here when the task next yields; route to the canonical
// pump exactly like every other root resume.
static void bm_root_canonical_pump();   // defined below; throws BmRootUnwind if one is already live
extern "C" void recomp_bm_peek_regs(uint32_t* out4) {
    out4[0] = out4[1] = out4[2] = out4[3] = 0;
    TaskFiber* r = g_running;
    if (r == nullptr || r->own == nullptr) return;
    const uint64_t* f = (const uint64_t*)r->own;
    out4[0] = (uint32_t)f[2]; out4[1] = (uint32_t)f[3]; out4[2] = (uint32_t)f[5]; out4[3] = (uint32_t)f[6];
}

static TaskFiber* g_budget_broken = nullptr;   // [budget-redispatch] wave-era break to continue
// [torn-state 08-27] A fiber with an unconsumed break note is marked RUNNING guest-side but
// suspended engine-side: if the note is lost, NOTHING ever dispatches it again (the guest
// scheduler won't — it believes the thread is on the CPU). Measured corpse: worker st=4/sus,
// idle spinning at 0x800175AC forever, ~1/3 of boots. Three loss paths closed below:
//  (a) consume was gated on wave_active() — a wave ending between break and pump stranded it;
//  (b) handle==nullptr/!started dropped the note silently;
//  (c) single slot: a second break overwrote a live note when the eret path dispatched other
//      fibers in between. (c) is now loud; any non-pump dispatch of the noted fiber clears
//      its note (bm_clear_budget_note) so a stale continuation can never re-enter at an old pc.
static inline void bm_clear_budget_note(TaskFiber* tf) {
    (void)tf;   // [torn-state REVERTED] no-op; call sites kept for the re-attempt
}
extern "C" void recomp_bm_budget_break(uint32_t pc) {
    if (g_running != nullptr && g_root_fiber != nullptr && GetCurrentFiber() != g_root_fiber) {
        g_running->epc = pc;            // continuation = the exact break pc (regs live in its own file)
        g_budget_broken = g_running;
    }
}

// [world-reset 08-27] The reload rebuilds the kernel AT THE SAME ADDRESSES; every engine-side
// cache of the old world (suspended fibers' resume points, parked continuations, wakee hints)
// then describes a DEAD world. Three measured corpse shapes from that staleness in one morning:
// the 0x80011E04 return-ouroboros, the 0x8x..C9C4 pointer derail, and the sentinel-blocked pair
// (worker+pri254 both on 0x800E7CA8). On wave-start — the engine's own "kernel is being
// replaced" signal — drop them: fibers are recreated on demand at the next eret to the rebuilt
// TCBs. The currently-executing fiber (the reload copier itself) survives, as does g_running.
// Dropped handles are deliberately leaked: DeleteFiber frees a suspended stack without
// unwinding it; a few KB once per reload is the safe price.
static void bm_world_reset(void) {
    void* cur = GetCurrentFiber();
    int dropped = 0;
    for (auto it = g_fibers.begin(); it != g_fibers.end(); ) {
        TaskFiber* tf = it->second;
        if (tf != nullptr && tf != g_running && tf->handle != cur) { it = g_fibers.erase(it); ++dropped; }
        else ++it;
    }
    g_budget_broken = nullptr;
    g_direct_wakee = 0u;
    g_interrupted = nullptr;
    fprintf(stderr, "[bmsched] WORLD-RESET at wave-start: dropped %d stale fibers (executing kept)\n", dropped);
    fflush(stderr);
}

static bool bm_resume_interrupted_task() {
    if (g_root_fiber == nullptr || GetCurrentFiber() != g_root_fiber) return false;
    TaskFiber* tf = g_interrupted;
    // [frame-tick] a thread the direct lane just woke outranks the interrupted spinner: on
    // hardware the handler's eret dispatches the HIGHEST-PRIORITY runnable thread, and the
    // freshly-woken waiter is exactly that (the VI manager at pri 254, the frame-waiting worker).
    // Resuming only the interrupted idle forever starves the wakee - the noon zombie.
    if (g_direct_wakee != 0u) {
        const uint32_t wk = g_direct_wakee;
        g_direct_wakee = 0u;
        auto it = g_fibers.find(wk);
        if (it != g_fibers.end() && it->second != nullptr && it->second->handle != nullptr && it->second->started) {
            static int _fw = 0;
            if (_fw++ < 12) { fprintf(stderr, "[hverify] FRAME-TICK dispatch woken tcb=0x%08X\n", wk); fflush(stderr); }
            tf = it->second;
        }
    }
    if (tf == nullptr || tf->handle == nullptr || tf->handle == g_root_fiber || !tf->started) return false;
    static int _hr = 0;
    if (_hr <= 8 || (_hr % 2000) == 0) {
        fprintf(stderr, "[hverify] HOLD-resume #%d -> suspended task (undelivered continue)\n", _hr);
        fflush(stderr);
    }
    _hr++;
    tl_eret_drain = false;   // a committed resume ends the drain episode (same law as eret's switch)
    bm_clear_budget_note(tf);   // [torn-state 08-27] this dispatch supersedes any parked continuation
    g_root_interp_depth = recomp_interp_swap_depth(tf->interp_depth);
    g_root_native_depth = recomp_interp_swap_native(tf->native_depth);
    g_root_live_pc      = recomp_interp_swap_live_pc(tf->live_pc);
    SwitchToFiber(tf->handle);
    bm_root_canonical_pump();
    return true;
}

// [wedge-dump 2026-08-26] one call = the whole scheduler picture at a frozen moment: last 16
// yields (tcb@pc), the guest curtask word, and every known fiber's guest TCB state. Called from
// the gt-pulse FROZEN detector so any future wedge names its own park sites without a debugger.
extern "C" void recomp_bm_dump_wedge(void) {
#ifdef _WIN32
    fprintf(stderr, "[wedge-dump] park-ring (oldest->newest):");
    for (uint32_t k = 0; k < 16u; k++) {
        const uint32_t i = (g_park_ring_n + k) & 15u;
        if (g_park_ring[i][0] != 0u) fprintf(stderr, " %08X@%08X", g_park_ring[i][0], g_park_ring[i][1]);
    }
    fputc(0x0A, stderr);
    if (g_rdram != nullptr) {
        const uint32_t cur = (g_taskptr != 0u && (g_taskptr & 0x00FFFFFFu) + 4u < 0x00800000u)
                           ? *(uint32_t*)(g_rdram + (g_taskptr & 0x00FFFFFFu)) : 0u;
        fprintf(stderr, "[wedge-dump] curtask[0x%08X]=0x%08X g_current=0x%08X fibers:", g_taskptr, cur, g_current_tcb);
        for (auto& kv : g_fibers) {
            const uint32_t t = kv.first;
            uint32_t st = 0xFFFFu, pri = 0xFFFFu;
            if ((t >> 28) == 0x8u && (t & 0x00FFFFFFu) + 0x14u < 0x00800000u) {
                st  = *(uint32_t*)(g_rdram + (t & 0x00FFFFFFu) + 0x10u) >> 16;
                pri = *(uint32_t*)(g_rdram + (t & 0x00FFFFFFu) + 0x04u);
            }
            fprintf(stderr, " %08X(st=%u,pri=%u,%s)", t, st, pri,
                    (kv.second == g_running) ? "RUN" : (kv.second && kv.second->started ? "sus" : "new"));
            // [wait-decode 08-27] a WAITING thread's [tcb+8] points into the mq it blocks on
            // (libultra OSThread.queue = &mq->mqueue for recv). Print the queue and its counts —
            // the Production-card freeze is a worker waiting on a queue whose wake was erased.
            if (st == 8u) {
                const uint32_t qp = *(uint32_t*)(g_rdram + (t & 0x00FFFFFFu) + 0x08u);
                if ((qp >> 28) == 0x8u && (qp & 0x00FFFFFFu) + 0x18u < 0x00800000u) {
                    const uint32_t qb = qp & 0x00FFFFFFu;
                    fprintf(stderr, "[q=%08X valid=%d first=%d cap=%d]", qp,
                            *(int32_t*)(g_rdram + qb + 0x08u), *(int32_t*)(g_rdram + qb + 0x0Cu),
                            *(int32_t*)(g_rdram + qb + 0x10u));
                }
            }
        }
        fputc(0x0A, stderr);
    }
    fflush(stderr);
#endif
}

// Thrown at a fiber's resume point when it gets RE-DISPATCHED (guest eret targeting this task):
// on hardware an eret JUMPS to EPC — it never falls back through the dispatcher's caller frames.
// Our fiber model used to unwind those abandoned kernel C-frames on resume, executing their tails
// with the register file the dispatcher restored for the APP-LEVEL resume point (SOTE wall-3: a
// frame tail read through k0=0xA430000C and scanned MI device space). The throw abandons the old
// frames (unwound through interp/trampoline/recompiled C, same path thread_terminated proves out)
// and fiber_proc re-enters cleanly at the freshly-set tf->epc with the freshly-restored ctx.
// JIT-on caveat: sljit frames can't be unwound through; the live-gap thread_terminated bridge
// (recomp_live_gap.cpp) would need the same treatment for this type before JIT=1 runs bare-metal.
// struct BmFiberRedispatch {} is defined above, next to TaskFiber (moved 2026-09-05 for the [epc-wins] resume throw).

// ROOT-fiber companion (SOTE wall 4 round 2): every root resume used to START A NEW wait-for-
// interrupt pump on top of the frozen handler/dispatch frames of the previous one — the root's
// stack and its InterpScope nesting grew monotonically (one drained-handler interp session per
// root dispatch, never unwound). ~64 root-pump cycles later the shared interp depth counter
// pinned at the cap and EVERY interp call bailed; whichever guest subsystem next needed the
// interpreter broke (observed: the 0x800C6xxx stream backend no-op'd -> ring overflow -> guest
// assert; next boot the 0x800C3Dxx dispatcher tore its k0 -> CORRUPT eret). The root's resume is
// an eret like any other: a JUMP, never a return — unwind to the ONE canonical pump frame below
// (InterpScope RAII re-balances the depth counter during the unwind, same as BmFiberRedispatch).
struct BmRootUnwind {};
static bool g_root_pump_live = false;   // the canonical root pump frame exists on the root stack

static void CALLBACK fiber_proc(void* arg) {
    TaskFiber* tf = (TaskFiber*)arg;
    for (;;) {
        tf->started = true;
        try {
        if (g_autobm) {
            // CONTINUATION LOOP (auto-bm round 4-5): a thread dispatched at a MID-FUNCTION EPC whose
            // outermost function returns has NOT finished — follow ctx->r31 onward, executing via the
            // GENERAL dispatcher (get_function/LiveRecomp JIT for mid-function pcs). A yield (eret)
            // switches fibers from inside a call, so reaching the loop tail means it genuinely
            // returned. GATED on g_autobm: NC's legacy fibers share ONE recomp_context, so a foreign
            // thread's r31 chased here would native-double-run a tail = the documented tear class.
            // [eret-take 2026-09-03, REMOVED the same night] A loop-head venue that took a pending interrupt at
            // the first instruction after eret was tried here. On libultra's yield path the resumed thread
            // arrives with IE clear (osYieldThread yields inside __osDisableInt; the hardware take moment is
            // the mtc0 in __osRestoreInt, covered by the mask/SR venue + the interpreter's edge retake), so it
            // fired ~5x per run on 1080 and bought nothing -- and on Turok it fired ~130x during boot in the two
            // boots that never rendered (a mode the 09-02 engine never showed in 4 boots). Removed.
            uint32_t pc = tf->epc;
            for (;;) {
                recomp_func_t* f = get_function((int32_t)pc);
                { static int _fr = 0; static int _frcap = -2; if (_frcap == -2) { const char* e = getenv("RECOMP_BM_RUNLOG"); _frcap = (e && *e) ? atoi(e) : 0; } if (_frcap < 0 || _fr++ < _frcap) { fprintf(stderr, "[bmsched] fiber RUN pc=0x%08X fn=%p\n", pc, (void*)f); fflush(stderr); } }
                // Eret-style entry (jump to an EPC / ra-chase continuation), NOT a call: when this
                // dispatch reaches the interpreter (directly, or through a gap trampoline that
                // get_function returned for a between-FUNCs vaddr), disable the interp's
                // pc==entry_ra session-end check. A loop-style task with saved ra == entry pc
                // (SOTE 0x800C0744) otherwise ends before executing a single instruction.
                if (f == nullptr || f == recomp_live_gap_trampoline || f == recomp_interp_trampoline) {
                    /* [interpsrc] THE address failed to resolve to native code. get_function never
                     * returns null — overlays.cpp hands back recomp_interp_trampoline instead — so a
                     * non-null f is NOT proof of a native target, and testing for null misses every
                     * one of these. Toward "no interpretation at all": each line below is an address
                     * that should have had a native entry, and the venue says which shape it is
                     * (a thread STARTING resolves; a mid-function continuation does not). */
                    static int _is = 0;
                    if (_is++ < 24) {
                        fprintf(stderr, "[interpsrc] unresolved pc=0x%08X tcb=0x%08X via=%s fiber=%s\n",
                                pc, g_current_tcb,
                                f == nullptr ? "null" : (f == recomp_interp_trampoline ? "interp-tramp" : "livegap-tramp"),
                                GetCurrentFiber() == g_root_fiber ? "ROOT" :
                                (GetCurrentFiber() == g_idle_fiber ? "IDLE" : "TASK"));
                        fflush(stderr);
                    }
                    recomp_interpret_mark_eret_entry();
                }
                if (f) {
                    // round 6: a native run in the chase has no representable live pc either —
                    // count it so venues defer (throw-imbalance is covered by the catch's rebase).
                    // [edge-retake 2026-09-03] ...but ONLY a real native function. get_function never
                    // returns null: a gap/interp TRAMPOLINE is the interpreter, whose live pc IS
                    // representable. Bracketing it made every interpreted session dispatched from
                    // here look like a native callee, so the mask/SR venue deferred every edge of
                    // every such thread forever (1080: 25M deferrals/min, 0 deliveries -- an
                    // osYieldThread spin whose IE rises inside an interpreted __osRestoreInt).
                    static const bool _brk = [] { const char* e = std::getenv("RECOMP_BM_TRAMPBRACKET"); return (e && e[0] == '1'); }();   // =1: old behaviour (bisect instrument)
                    const bool _tramp = !_brk && (f == recomp_live_gap_trampoline || f == recomp_interp_trampoline);
                    if (!_tramp) recomp_interp_native_enter();
                    f(tf->rdram, tf->ctx);
                    if (!_tramp) recomp_interp_native_exit();
                }
                else {
                    /* [interpsrc] WHY did this fall to the interpreter? Name the venue, not just the
                     * address: a cold entry at a true function entry is expected (a thread STARTING),
                     * while a mid-function pc means a continuation we failed to keep as a live fiber.
                     * Toward "no interpretation at all" — every line here is an address that should
                     * have resolved. */
                    static int _is = 0;
                    if (_is++ < 24) {
                        fprintf(stderr, "[interpsrc] fiber_proc cold-entry pc=0x%08X tcb=0x%08X fiber=%s\n",
                                pc, g_current_tcb,
                                GetCurrentFiber() == g_root_fiber ? "ROOT" :
                                (GetCurrentFiber() == g_idle_fiber ? "IDLE" : "TASK"));
                        fflush(stderr);
                    }
                    recomp_interpret(tf->rdram, tf->ctx, pc);
                }
                uint32_t ra = (uint32_t)((const uint64_t*)tf->ctx)[31];
                if (ra == 0u || (ra & 3u) != 0u || ra == pc || !recomp_interp_is_code(tf->rdram, ra)) {
                    // [chase-break 08-27] name the clause: the 0x80011E04 return-loop corpse spams
                    // RETURNED at one pc — ra==pc there means the saved file's ra was clobbered
                    // to the resume pc (jr ra = jump-to-self, budget burn, break, re-enter, ∞).
                    static int _cb = 0;
                    if (_cb++ < 24) {
                        fprintf(stderr, "[bmsched] chase-break pc=0x%08X ra=0x%08X sp=0x%08X (%s)\n",
                                pc, ra, (uint32_t)((const uint64_t*)tf->ctx)[29],
                                (ra == pc) ? "ra==pc" : (ra == 0u) ? "ra=0" : ((ra & 3u) != 0u) ? "unaligned" : "not-code");
                        fflush(stderr);
                    }
                    break;
                }
                pc = ra;
            }
        } else {
            // NC LEGACY (g_nc_mode): the RUN-23-proven behavior — lookup_native-else-interp, single
            // pass, park at root on return. No $ra-chase (NC's jr-$s2/$ra=0 convention + shared ctx).
            recomp_func_t* f = recomp_lookup_native(tf->epc);
            fprintf(stderr, "[bmsched] fiber RUN epc=0x%08X native=%p\n", tf->epc, (void*)f); fflush(stderr);
            if (f) f(tf->rdram, tf->ctx);
            else   recomp_interpret(tf->rdram, tf->ctx, tf->epc);
        }
        } catch (BmFiberRedispatch&) {
            // Re-dispatched: abandoned the suspended frames; loop re-enters at the new tf->epc.
            // If the abandoned frames included an in-flight drain (handler eret'd away mid-drain),
            // its tl_eret_drain=true guard was never cleared — reset it or draining stops forever.
            tl_eret_drain = false;
            // RE-BASE (the depth ratchet, wall 4): this catch is the fiber's bottom — nothing is
            // live above it, so the TRUE interp nesting here is 0 BY CONSTRUCTION. The unwind we
            // just did only subtracted the fiber's real scopes from whatever the resume seeded
            // (the saved slot), so any historical mis-count would survive forever and every small
            // leak would accumulate ("restore deep interp slot" climbing to the cap = the wedge).
            // Enforcing the invariant here makes the counter self-healing every cycle.
            recomp_interp_swap_depth(0);
            recomp_interp_swap_native(0);      // companions rebase with it (round 6)
            recomp_interp_swap_live_pc(0);
            static int _rd = 0;
            if (_rd++ < 40) { fprintf(stderr, "[bmsched] fiber REDISPATCH -> epc=0x%08X\n", tf->epc); fflush(stderr); }
            continue;
        }
        // [depth-probe A] a returning fiber's stack is empty — every InterpScope on it has been
        // destroyed — so a nonzero live counter here is GHOST residue created during this fiber's
        // own run (increments whose decrements landed in another counter view).
        {
            int live = recomp_interp_peek_depth();
            static int _gh = 0;
            if (live != 0 && _gh++ < 40)
                fprintf(stderr, "[bmsched] fiber RETURNED with GHOST depth=%d (epc=0x%08X)\n", live, tf->epc);
        }
        fprintf(stderr, "[bmsched] fiber RETURNED epc=0x%08X\n", tf->epc); fflush(stderr);
        // Task body returned. Hand control back to the scheduler root. Clear g_running: nothing is
        // dispatched now — leaving it pointed at this returned fiber made a later root-context eret
        // (a) mis-attribute the root's interp depth into this fiber's slot and (b) refuse to ever
        // re-dispatch this tcb through the 'already running' early-out.
        if (g_running == tf) g_running = nullptr;
        // Per-fiber interp-depth swap (outgoing side of this switch; see recomp_interp_swap_depth).
        // RE-BASE: a returned fiber's stack is EMPTY — its true nesting is 0 by construction, so
        // store that, not the counter (which carries any historical mis-count; probe A above
        // reports the discrepancy). Restoring the root's view is unchanged.
        recomp_interp_swap_depth(g_root_interp_depth);
        recomp_interp_swap_native(g_root_native_depth);
        recomp_interp_swap_live_pc(g_root_live_pc);
        tf->interp_depth = 0;
        tf->native_depth = 0;                  // returned fiber: empty by construction (round 6)
        tf->live_pc      = 0;
        SwitchToFiber(g_root_fiber);
    }
}

// FATAL-tear recovery dispatcher (NC-only). The run queue was rebuilt by orphan recovery but the handler
// left the current-task word pinned to the idle thread, so no eret fired. Pick the highest-priority TCB on
// the rebuilt run queue (its HEAD after func_80080F74's priority-sorted re-insert), make it current, and
// switch to its fiber — exactly what recomp_eret's tail does for a normal dispatch. Only switches to a TCB
// that ALREADY has a created fiber (a thread we have dispatched before, i.e. a census member); a never-run
// TCB has no resume point here (its first dispatch must come from a real guest eret with a valid entry PC).
static bool nc_force_redispatch(uint8_t* rdram) {
    static int _dbg = 0; bool dbg = (_dbg < 60);
    if (g_root_fiber == nullptr) return false;             // no fiber context yet (pre-first-eret)
    // Read the rebuilt run-queue head node = the highest-priority runnable TCB.
    uint32_t head = *(uint32_t*)(rdram + 0x000A36A8u);
    if (dbg) { _dbg++; fprintf(stderr, "[bmsched][REDISPATCH?] head=0x%08X cur=0x%08X\n", head, g_current_tcb); fflush(stderr); }
    if ((head >> 28) != 0x8u) return false;               // empty (sentinel) or still wild
    if (head == NC_RQ_SENTINEL) return false;
    uint32_t tcb = head;
    if (tcb == g_current_tcb) return false;               // already the running fiber
    if (tcb == NC_IDLE_TCB) return false;                 // never force the idle/boot thread
    // CRITICAL: do NOT force-dispatch a thread that is blocked on a queue's wait-list. A fatal tear can leave
    // a blocked thread stranded as the run-queue head; switching to it would make it re-block immediately and,
    // because the guest keeps selecting it as the (still-corrupt) head, recomp_eret loops forever on "already
    // running". Only redispatch a genuinely runnable thread; otherwise leave the scheduler to its other paths.
    if (nc_tcb_on_any_waitlist(rdram, tcb)) {
        if (dbg) { fprintf(stderr, "[bmsched][REDISPATCH?] head tcb=0x%08X is wait-list-blocked -> skip\n", tcb); fflush(stderr); }
        return false;
    }
    auto it = g_fibers.find(tcb);
    if (it == g_fibers.end() || it->second == nullptr || it->second->handle == nullptr) {
        if (dbg) { fprintf(stderr, "[bmsched][REDISPATCH?] head tcb=0x%08X has no fiber -> skip\n", tcb); fflush(stderr); }
        return false;
    }
    TaskFiber* tf = it->second;
    // Make this TCB current (so guest reads of 0x800A36B0 + our own bookkeeping agree) and switch to it.
    *(uint32_t*)(rdram + (g_taskptr & 0x1FFFFFFFu)) = tcb;
    g_running = tf;
    g_current_tcb = tcb;
    bm_clear_budget_note(tf);   // [torn-state 08-27] this dispatch supersedes any parked continuation
    static int _fr = 0;
    if (++_fr <= 50) { fprintf(stderr, "[bmsched][REDISPATCH] forced switch to rebuilt run-queue head tcb=0x%08X\n", tcb); fflush(stderr); }
    SwitchToFiber(tf->handle);                            // resumes that task; returns here when it yields back
    // The task yielded back to us (it re-blocked in osRecvMesg). It is NO LONGER running — clear g_running so
    // the next eret/dispatch is free to switch to it again (or to another thread). Leaving g_running set to a
    // re-blocked task makes recomp_eret hit "already running" and refuse every subsequent switch -> deadlock.
    g_running = nullptr;
    g_current_tcb = 0;
    return true;
}

// THE CANONICAL ROOT PUMP (wall 4 round 2), factored so BOTH root-resume sites enter it.
// Once the fiber world is live, the root's only correct role is the idle: pump pending
// interrupts forever — each drain's handler-eret dispatches the woken task from inside,
// exactly like dead_end. The pump frame is established ONCE; every later root resume
// unwinds back to it via BmRootUnwind instead of stacking a new pump on the previous
// drain's frozen frames (that stacking grew the root stack + interp nesting to the cap).
// Callers: (1) recomp_eret's RESUMED tail — the original site; (2) the ROOT self-redispatch
// launch site — which previously plain-`return`ed when the fiber world handed back, parking
// the root pump-less in the abandoned boot chain (fifa boot 2026-08-05: all threads waiting
// on handler service, 2000+ VI notes, ZERO drains — the GoldenEye dead stop's twin).
static void bm_root_canonical_pump() {
    if (g_root_pump_live) throw BmRootUnwind{};
    g_root_pump_live = true;
    // RE-BASE anchor: the root's true nesting below the pump frame is whatever is live right
    // now (the boot chain + the session this resume was reached through); every unwind back to
    // the pump returns the stack to exactly this shape.
    const int pump_base_depth = recomp_interp_peek_depth();
    const int pump_base_native = recomp_interp_in_native_callee();   // companions re-base with
    const uint32_t pump_base_pc = recomp_interp_peek_pc();           // the depth (round 6)
    static int _rp = 0;
    if (_rp++ < 8) { fprintf(stderr, "[bmsched] root resumed -> wait-for-interrupt pump (canonical, base depth %d)\n", pump_base_depth); fflush(stderr); }
    while (g_enabled) {
        try {
            if (!tl_eret_drain && g_pending_intr.load(std::memory_order_relaxed) > 0) {
                tl_eret_drain = true;
                recomp_baremetal_idle();
                tl_eret_drain = false;
            }
            // [budget-redispatch 2026-08-26] a wave-era fiber that hit the budget wall returned
            // here so drains could run; continue it at its break pc (regs preserved in its file;
            // mid-function pc resolves through the live-gap interpreter).
            // [torn-state 08-27 REVERTED same-day] the unconditional consume regressed boot to a
            // zero-frame spin (894M calls to 0x800C20B0, every delivery deferred "inside native
            // callee (stale live_pc)") — the out-of-wave redispatch interacts with the per-fiber
            // depth swaps in a way the wave-era path does not. Reverted to the wave-gated consume
            // pending a proper A/B; the strand-loss diagnosis stands (see dossier 08-27).
            // [strand-detect 08-27] print-only: catch a note the wave gate will never consume,
            // with the context the fix needs (guest TCB, its OS state word, drain flag, depths).
            {
                static uint64_t sd_iters = 0;
                static TaskFiber* sd_last = nullptr;
                TaskFiber* sd = g_budget_broken;
                if (sd != nullptr && !recomp_bm_wave_active()) {
                    if (sd != sd_last) { sd_last = sd; sd_iters = 0; }
                    if (++sd_iters == 20000) {
                        uint32_t sd_tcb = 0;
                        for (auto& kv : g_fibers) if (kv.second == sd) { sd_tcb = kv.first; break; }
                        uint32_t sd_st = 0xFFFFu;
                        if (sd_tcb != 0 && g_rdram != nullptr
                            && (sd_tcb >> 28) == 0x8u && (sd_tcb & 0x00FFFFFFu) + 0x14u < 0x00800000u)
                            sd_st = *(uint32_t*)(g_rdram + (sd_tcb & 0x00FFFFFFu) + 0x10u) >> 16;
                        fprintf(stderr, "[bmsched] STRANDED note: tcb=0x%08X epc=0x%08X guest_st=%u drain=%d depths(i/n)=%d/%d live_pc=0x%08X\n",
                                sd_tcb, sd->epc, (unsigned)sd_st, (int)tl_eret_drain,
                                sd->interp_depth, sd->native_depth, sd->live_pc);
                        fflush(stderr);
                    }
                } else {
                    sd_last = nullptr; sd_iters = 0;
                }
            }
            if (g_budget_broken != nullptr && recomp_bm_wave_active()) {
                TaskFiber* bb = g_budget_broken;
                g_budget_broken = nullptr;
                if (bb->handle != nullptr && bb->started) {
                    static int _brd = 0;
                    ++_brd;
                    if (_brd <= 8 || (_brd % 2000) == 0) { fprintf(stderr, "[bmsched] budget-redispatch #%d -> epc=0x%08X%c", _brd, bb->epc, 0x0A); fflush(stderr); }
                    g_root_interp_depth = recomp_interp_swap_depth(bb->interp_depth);
                    g_root_native_depth = recomp_interp_swap_native(bb->native_depth);
                    g_root_live_pc      = recomp_interp_swap_live_pc(bb->live_pc);
                    SwitchToFiber(bb->handle);
                }
            }
        } catch (BmRootUnwind&) {
            // A drain's handler eret'd away and the root was later resumed: the throw above
            // unwound the abandoned handler/dispatch frames (InterpScope RAII re-balanced the
            // interp depth). An in-flight drain was abandoned mid-episode — clear its gate,
            // and re-base the counter to the pump's known stack shape (see the ratchet note
            // in fiber_proc's catch).
            tl_eret_drain = false;
            recomp_interp_swap_depth(pump_base_depth);
            recomp_interp_swap_native(pump_base_native);
            recomp_interp_swap_live_pc(pump_base_pc);
        }
        Sleep(1);
    }
    g_root_pump_live = false;
}
#endif

// Interp-loop pump venue (completes the drain-at-eret design's R3 contingency): interpreted
// guest spin/wait loops have no poll guards (native loops get emit_poll_yield_guard), so a game
// parked in an interpreted wait starves the drain — interrupts pile up noted-but-undrained and
// the kernel never advances (SOTE post-stream stall: 14000 noted, 8 drained). Called from the
// interpreter's exec loop every N instructions. Behaves like the hardware exception at THIS
// instruction: latch EPC to the interrupted pc, then drain. The handler's eret redispatches;
// BmFiberRedispatch unwinds the interp session itself and fiber_proc re-enters at the new epc.
// Mask-reenable pump venue (fifa 2026-08-05): a native disable/check/restore idle loop writes
// the MI mask every iteration; its body contains that store, so the recompiler's load-only
// poll detector cannot guard it, and the interp venue never sees native code — the spinner
// held its fiber forever while notes piled (2 drains / 50s, thousands pending). But the
// restore write itself IS the hardware delivery moment: MI sources are level lines gated by
// the mask, so a write that exposes a pending line takes the interrupt immediately. mmio.cpp
// calls this from the MI_INTR_MASK write when (pending & new_mask) != 0. Same gates as the
// interp venue; on a task fiber the idle yields to the root pump, whose drain runs the
// handler; the suspended writer resumes at its fiber's suspension point (no EPC needed).
// [latch-gate 2026-09-03] Hardware latches EPC only at exception ENTRY, and entry cannot happen while
// EXL/ERL are set or IE is clear. Both pc-bearing venues below latched EPC = live pc FIRST and only then
// called recomp_baremetal_idle(), whose drain gate refused - leaving the guest's freshly restored EPC
// clobbered. Measured on Turok (turok_B1_ghostvalid 09-03): __osException's tail restores EPC (mtc0 at
// 0x800A5F6C), writes MI_INTR_MASK at 0x800A5FF8 (= the mask-poll venue) and erets; with a VI note pending
// at that instant the eret returned to 0x800A5FF8 itself and the boot spun in 30M self-erets without ever
// rendering (yesterday's 0/61 'never rendered' boots were the same shape). The predicate below is the
// idle() gate's, including its parked-artifact bypass (state 8, IE clear, EXL/ERL clear): keep them in step.
static bool bm_latch_gate_closed(uint32_t* sr_out) {
    const uint32_t sr = (uint32_t)cop0_status_read(bm_exec_sr_ctx());
    uint32_t pk = 0;
    if ((g_rdram != nullptr) && (g_current_tcb != 0u)) {
        const uint32_t tp = g_current_tcb & 0x00FFFFFFu;
        if ((tp + 0x14u) < 0x00800000u) pk = (*(const uint32_t*)(g_rdram + tp + 0x10u)) >> 16;
    }
    if (sr_out != nullptr) *sr_out = sr;
    return ((sr & 0x6u) != 0u || (sr & 0x1u) == 0u) && ((pk != 8u) || ((sr & 0x6u) != 0u));
}
static void bm_latch_gate_note(const char* venue, uint32_t sr, uint32_t pc) {
    static std::atomic<long> _lg{0}; long n = ++_lg;
    if (n <= 16 || (n % 4096) == 0) {
        fprintf(stderr, "[latch-gate] #%ld %s declined: SR=0x%08X (%s) at pc=0x%08X - EPC left alone, note stays pending%c",
                n, venue, sr, (sr & 0x6u) ? "EXL/ERL set" : "IE clear", pc, 0x0A);
        fflush(stderr);
    }
}
extern "C" void recomp_baremetal_mask_poll(void) {
    // [edge-census 2026-08-06] name why an edge-venue call declines — the starvation
    // discriminator (turok: 1 drain / 25s while 1000+ notes piled; WHICH guard turned
    // the IE-rising edges away names the choreography bug). Instrument only.
    static std::atomic<long> _edge_declines[3] = {{0}, {0}, {0}};
    auto edge_decline = [](int why, const char* label) {
        long n = ++_edge_declines[why];
        if (n <= 24 || (n % 2000) == 0) {
            if (rc_trace_on("RECOMP_EDGE_CENSUS")) fprintf(stderr, "[edge-census] decline #%ld: %s\n", n, label);
            fflush(stderr);
        }
    };
    if (!g_enabled || !g_autobm || g_ctx == nullptr) return;
    if (tl_in_interrupt || tl_eret_drain) { edge_decline(0, tl_in_interrupt ? "tl_in_interrupt" : "tl_eret_drain"); return; }
    // (Boot-grace pacing experiment 2026-08-05: FALSIFIED and removed. A 50ms delivery hold
    // after first engage changed nothing — tick stayed 0, surface stayed NULL, loop ran 60Hz.
    // [drainpre] showed orderly delivery: first drain = accumulated SI+VI+PI, then steady VI.
    // The init failure is upstream of delivery pacing; see COMPRESSED_CLASS_ROSTER.md.)
    // Gate on the sources the DRAIN would actually present: bmsched's noted bits (the VI host
    // thread's notes accumulate here, NOT in mmio's transient MI_INTR register) plus mmio's
    // level bits (pi.cpp's pre-arm presentation lands there). Deliver only when the new mask
    // exposes one of them — the hardware take-on-unmask moment.
    uint32_t lvl = g_pending_mi_bits.load(std::memory_order_relaxed)
                 | recomp_mi_intr_pending();
    if ((lvl & recomp_mi_intr_mask()) == 0) { edge_decline(1, "no pending∩mask"); return; }
    // [pi-level] (SOTE 2026-08-26, the lost PI wake): hardware PI completion is LEVEL-triggered —
    // the line stays high until the game acks PI_STATUS. Our note counter consumed the last
    // pre-transition PI-done while the handler was dying, and the guest then ARMED its wait after
    // the fact (the W5 completion-vs-arm family, PI edition): it now spins its mask-toggle loop
    // with a PI-inclusive mask, pending forever empty (81M "no pending∩mask" declines, stacks
    // parked in the mask/cop0 write path, idle counter frozen). Re-present the level: while the
    // guest's own mask includes PI and nothing is pending, re-note PI at a slow beat so the drain
    // can run and the direct lane can post PI through the guest's own poster. Self-limiting: goes
    // quiet the moment the guest acks/unmasks or real pendings flow again.
    {
        static const bool pl_on = [] { const char* e = std::getenv("RECOMP_HVERIFY_DIRECT"); return (e != nullptr) && (e[0] == '1'); }();

        static long pl_declines = 0;
        if (pl_on && (recomp_mi_intr_mask() & 0x10u) != 0u && (++pl_declines % 500) == 0) {
            // [pi-arm v2] streak-gated: a genuine stuck-wait exists. First choice = complete a real
            // in-flight paced DMA (its note fires; the normal path delivers). Only when nothing is
            // in flight does the poster fallback below re-present the lost level.
            if (recomp_pi_complete_on_arm() != 0) return;
            static int _pl = 0;
            ++_pl;
            if (_pl <= 6 || (_pl % 200) == 0) {
                fprintf(stderr, "[pi-level] re-presenting PI-done (decline streak %ld, guest mask=0x%X)%c",
                        pl_declines, recomp_mi_intr_mask(), 0x0A);
                fflush(stderr);
            }
            // v2 (13:30): the note alone dies at the EPC-honesty deferral — the guest spins in
            // NATIVE kernel code, so no pc-bearing venue ever arrives to deliver an exception.
            // But the spin is an osRecvMesg-style loop that re-checks its queue natively every
            // iteration: it does not need an exception, it needs THE MESSAGE.
            // [lane-3 dead-man 08-27, LANE_UNIFICATION_PLAN.md step 3] The direct-poster post
            // was written for the pre-divert world (guest spinning in NATIVE kernel code, no
            // pc-bearing venue). Under always-divert the interp venue delivers PI honestly, and
            // the poster is a second lane racing the first — the 08-27 disease. Dead-man now:
            // print instead of posting. If a run hangs at a PI wait WITH this printing, the
            // poster was load-bearing after all — restore it consciously, not by default.
            if (g_svc_poster != nullptr && g_ctx != nullptr && g_rdram != nullptr) {
                const uint32_t toff = (g_svc_table & 0x00FFFFFFu) + 0x40u;   // code8*8 = PI
                const uint32_t q = *(uint32_t*)(g_rdram + toff);
                if ((q >> 28) == 0x8u) {
                    // [lane3 A/B 08-27] off-instrument RECOMP_LANE3_POSTER=1 restores the post so
                    // the dead-man can be A/B'd against it on the same binary. Default = suppressed.
                    static const bool l3 = [] { const char* e = std::getenv("RECOMP_LANE3_POSTER"); return (e != nullptr) && (e[0] == '1'); }();
                    static long _dm = 0;
                    ++_dm;
                    if (_dm <= 12 || (_dm % 500) == 0) {
                        fprintf(stderr, "[lane3-%s] poster fallback PI (q=0x%08X, streak %ld)\n",
                                l3 ? "post" : "deadman", q, pl_declines);
                        fflush(stderr);
                    }
                    if (l3) {
                        uint64_t* rf = (uint64_t*)g_ctx;
                        const uint64_t sa0 = rf[4];
                        const uint64_t sra = rf[31];
                        rf[4] = 0x40u;
                        g_svc_poster(g_rdram, g_ctx);
                        rf[4] = sa0;
                        rf[31] = sra;
                    }
                }
            }
            return;
        }
    }
    // A level source can be pending with the NOTE counter at 0 (presented before the kernel
    // armed, e.g. boot-time PI DMAs) — synthesize the note so the drain's take_pending passes.
    if (g_pending_intr.load(std::memory_order_relaxed) <= 0)
        g_pending_intr.fetch_add(1, std::memory_order_relaxed);
    { static std::atomic<long> _mp{0}; long n = ++_mp;
      if (n <= 8 || (n % 2000) == 0) { fprintf(stderr, "[mask-poll] #%ld pending-line delivery\n", n); fflush(stderr); } }
    // [defect-B fix 2026-08-06] Hardware latches EPC = the interrupted instruction at exception
    // entry. This venue fires from an MI-mask store the guest just executed; when that store ran
    // INTERPRETED (current fiber's depth > 0), the interpreter's live pc IS that instruction —
    // latch it, exactly as the interp-poll and guard venues already do. Without this the drain
    // presented whatever EPC some EARLIER venue latched, and the guest handler canonized that
    // STALE resume pc into the interrupted thread's TCB (measured: turok 08-06 [venue-census],
    // every depth>0 mask-poll drain STALE; fifa's lost-registration kill chain, roster 08-06).
    // NATIVE mask writes (depth == 0) carry NO representable guest pc — and canonizing a stale
    // EPC with live registers is the corrupt pair that resumes into the wrong frame and poisons
    // TCBs downstream (measured: seed-census #2 depth=0 stale 0x8009E1D4 → thread 0x800F95E0
    // later installed at another thread's pc → interp walked data → host crash). A venue that
    // cannot name the interrupted pc must NOT run the guest handler: DEFER — the note stays
    // pending and the next pc-bearing venue (guard latch / interp latch / voluntary eret save)
    // delivers honestly. Delay, never dishonesty. (fifa's guardless native idle loop relied on
    // this venue; its honest fix is the store-tolerant poll detector, cgenerator-side — the
    // mask venue stays for interp'd stores, which turok exercises constantly.)
    if (recomp_interp_peek_depth() > 0 && recomp_interp_in_native_callee() == 0) {
        uint32_t live = recomp_interp_peek_pc();
        // [dispatch-window 2026-08-28] THE LIKELIER PRODUCER OF THE EPC POISON, and why the
        // interp-poll guard alone fired zero times in 5 boots: THIS venue is entered from the
        // guest's own MI-mask / SR store, and restoring SR is exactly what a dispatcher does
        // while it swaps context. So the live pc here is routinely INSIDE the dispatcher, and
        // latching it hands the guest "dispatch a thread" as a resume address. Same rule, same
        // reason as the interp-poll site: a pc inside the dispatcher is never a legal interrupted
        // pc on hardware (it runs with interrupts off precisely so it cannot be interrupted), so
        // DEFER rather than latch a lie. Delay, never dishonesty.
        if (live != 0u && bm_pc_in_dispatch(live)) {
            static std::atomic<long> _dm{0}; long n = ++_dm;
            if (n <= 16 || (n % 4096) == 0) {
                fprintf(stderr, "[dispatch-window] #%ld mask-poll declined: live pc=0x%08X inside guest dispatcher 0x%08X..0x%08X%c",
                        n, live, g_disp_lo, g_disp_hi, 0x0A);
                fflush(stderr);
            }
            return;
        }
        {
            uint32_t _gsr = 0;
            if (live != 0u && bm_latch_gate_closed(&_gsr)) { bm_latch_gate_note("mask-poll", _gsr, live); return; }   // [latch-gate]
        }
        if (live != 0u) recomp_cop0_tlb_write(14, live);
    } else {
        // depth==0 (native store) OR inside a native callee beneath an interp frame (round 6:
        // live_pc is frozen at the caller's jal — latching it makes the guest RE-EXECUTE the
        // call on resume, re-running non-idempotent kernel primitives; turok's cyclic-queue
        // + fused-register poison). No representable EPC either way: DEFER.
        if (recomp_interp_peek_depth() > 0) recomp_bm_edge_deferred = 1;   // [edge-retake] the interpreter re-takes it on return
        edge_decline(2, recomp_interp_peek_depth() > 0
                        ? "inside native callee (stale live_pc) - deferred"
                        : "native store, no representable EPC - deferred to next pc-bearing venue");
        return;
    }
    tl_eret_drain = true;
    tl_drain_venue = "mask-poll";        // venue-census tag
    recomp_baremetal_idle();
    tl_drain_venue = "direct";
    tl_eret_drain = false;
}

// EPC-restore latch hook (see g_epc_restore_k0): called by tlb.cpp on every guest EPC write.
// Snapshot the executing fiber's k0 — at the dispatcher's `mtc0 ->EPC` it is the TCB, the one
// moment this libultra vintage exposes the dispatched thread before clobbering k0.
extern "C" void recomp_bm_epc_restore_hook(void) {
    // Sample the file the mtc0 is EXECUTING on, not the one scheduler bookkeeping points at.
    // During a root-venue drain the guest handler (and its __osDispatchThreadSave) runs on
    // g_ctx, while g_running still names the task the interrupt interrupted — so the old
    // g_running-first pick read the PARKED thread's r26, which almost always holds the
    // 0xA430000C copied in at its own dispatch, and the latch never fired. On the root the
    // executing file is g_ctx; on a task fiber it is that fiber's own.
    // (spec audit 2026-08-06)
    recomp_context* c = (GetCurrentFiber() == g_root_fiber || g_running == nullptr ||
                         g_running->ctx == nullptr)
                            ? g_ctx
                            : g_running->ctx;
    if (c != nullptr) g_epc_restore_k0 = (uint32_t)((const uint64_t*)c)[26];
}

// [fn-trace 2026-09-04] the EXECUTING register file and the current TCB, for the guest function-entry
// tracer in recomp.cpp: recomp_func_mark receives only a vram, and the arguments live in whichever
// file this fiber runs on (same pick as the EPC-restore hook above: root -> g_ctx, task fiber -> its
// own). nullptr / 0 for a game that never armed the bare-metal scheduler.
extern "C" recomp_context* recomp_baremetal_exec_ctx(void) {
#ifdef _WIN32
    return (GetCurrentFiber() == g_root_fiber || g_running == nullptr || g_running->ctx == nullptr) ? g_ctx : g_running->ctx;
#else
    return g_ctx;
#endif
}
extern "C" uint32_t recomp_baremetal_current_tcb(void) { return g_current_tcb; }

// [tlb-refill] synchronous TLB-refill / TLB-invalid exception for an unmapped KUSEG DATA access
// (2026-09-04, Turok 2 #76 attempt 5; the Acclaim-window class 2nd wall). A self-hosted kernel maps
// only its boot window (Turok 2: one 2MB TLB entry, idx 31, 0x00200000-0x003FFFFF) up front and
// installs a TLB-refill handler at 0x80000080, then relies on DEMAND refill for the rest of its
// address space -- its allocator (measured with the fn-trace tracer) hands the boot thread heap
// pointers at 0x0048_0000 / 0x004B_0000, above the boot window. tlb.cpp flat-maps every unmapped
// KUSEG address SILENTLY, so the guest's refill handler never runs and the dereference reads zero,
// and the frame pipeline stalls with the worker threads spinning (the "black screen" wall).
//
// Raise what hardware raises: set BadVAddr/Context/EntryHi (the miss handoff), Cause.ExcCode
// (TLBL/TLBS), EPC and Status.EXL, and hand the interpreter the exception vector to jump to. The
// guest handler installs the mapping (tlbwi) and erets; recomp_eret resumes this fiber at EPC (the
// faulting instruction), which now finds the entry. Returns the vector, or 0 to decline (caller
// keeps the flat-fallback behaviour). INERT unless the bare-metal scheduler is armed, so the HLE
// trio (sm64/cv64/robotron) never reaches it -- gate-safe by construction.
extern "C" int recomp_tlb_is_mapped(uint32_t vaddr, uint32_t* phys_out);   // tlb.cpp
extern "C" int recomp_tlb_match_state(uint32_t vaddr);                    // tlb.cpp: 0 none / 1 valid / 2 V-clear
extern "C" uint32_t recomp_bm_raise_tlb_refill(uint8_t* rdram, recomp_context* ctx,
                                               uint32_t vaddr, int is_store, uint32_t epc) {
    if (!(g_enabled && g_autobm)) return 0;              // only the armed bare-metal path
    if ((vaddr & 0x80000000u) != 0u) return 0;          // KSEG never TLB-faults through this path
    if (vaddr < 0x00010000u) return 0;                  // low/null page: keep the flat-fallback the
                                                        // engine has always given null-tolerant code
                                                        // (a real refill of page 0 would derail)
    if (rdram == nullptr) return 0;
    uint32_t phys = 0;
    if (recomp_tlb_is_mapped(vaddr, &phys)) return 0;   // already mapped -> normal access
    // The guest must have installed a refill handler; otherwise keep the silent flat fallback (the
    // pre-existing behaviour) rather than jump into a zero-filled vector. Instr word at KSEG0
    // 0x80000080 -> phys 0x80 (word-aligned, host order == guest word, like MEM_W).
    if (*(const uint32_t*)(rdram + 0x0u) == 0u && *(const uint32_t*)(rdram + 0x80u) == 0u) return 0;
    // ── [refill-vector 2026-09-06, Banjo-Tooie #228] "non-zero at 0x80000080" IS NOT "has a pager" ──
    // The VR4300 has FOUR exception vectors (TLB-refill 0x80000000, XTLB-refill 0x80000080, cache
    // error 0x80000100, general 0x80000180). libultra's osInitialize copies the SAME
    // __osExceptionPreamble stub -- lui/addiu/jr $k0 onto the game's __osException -- into ALL FOUR.
    // So the word test above passes for every libultra title on earth, and we then vector a TLB miss
    // into __osException, which has NO demand-paging service: an unhandled TLBL/TLBS takes libultra's
    // FAULT path, which sets the running thread to OS_STATE_STOPPED and dispatches away. The refill
    // therefore installs no mapping and KILLS A THREAD, turning an access the flat fallback served
    // correctly into a dead kernel.
    // MEASURED (2026-09-06): in every run on disk where [tlb-refill] fires, the tcb named on that
    // line is OS_STATE_STOPPED in every later [wedge-dump] and the game submits ZERO gfx tasks --
    // banjotooie (tcb 0x80076A20 pri 35, its loader worker; the main thread then spins 4.13M times
    // in osYieldThread waiting on a counter that worker was to drain), banjokazooie bk_a1/bk_d3
    // (tcb 0x80283450 pri 150, the graphics thread) and armorines (tcb 0x800F8330). The ONE
    // banjokazooie run that PASSES at 20 fps raises no refill at all and stops no thread -- which is
    // also the explanation for that title's run-to-run boot flip. Exactly one [tlb] write happens in
    // a 60 s banjotooie run (the boot one; that print's cap is 96, so the count is exact): the
    // handler never maps anything.
    // A kernel with REAL demand paging necessarily puts a DIFFERENT routine on the refill vector --
    // that is what the separate vector is for. So: if the refill vector holds the same code as the
    // general vector, it is the stock preamble, not a pager. Decline and keep the flat fallback (the
    // pre-2026-09-04 behaviour). Games that do install a dedicated refill handler keep the capability.
    // [refill-vector-32 2026-09-06, GoldenEye 007 #19] PICK THE VECTOR THE HARDWARE WOULD PICK.
    // libultra's own osInitialize (engine/references/libreultra/lib/src/osInitialize.c) names the
    // four VR4300 vectors -- EXCEPTION_TLB_MISS 0x80000000, EXCEPTION_XTLB_MISS 0x80000080,
    // EXCEPTION_CACHE_ERROR 0x80000100, EXCEPTION_GENERAL 0x80000180 -- and copies the SAME
    // __osExceptionPreamble into all four. A 32-bit KUSEG TLB miss taken with Status.EXL clear
    // vectors to 0x80000000; 0x80000080 is the 64-bit-addressing (UX/SX/KX) refill, which no N64
    // title enters. So a kernel with a REAL demand pager overwrites 0x80000000 and leaves the other
    // three stock, and testing 0x80000080 alone can never see it. MEASURED on GoldenEye 007: its
    // boot at 0x80000614 copies 128 bytes from 0x70001B60 over 0x80000000..0x8000007F -- a
    // Context/tlbwr fast refill reading a page table at 0x8005DBF0 -- immediately after calling
    // osInitialize, and leaves 0x80000080/0x100/0x180 as the preamble.
    // Take whichever refill vector DIFFERS from the general vector: 0x80000000 first (the
    // architectural one), then 0x80000080 (kept for any kernel that installs there). Both stock =
    // no pager -> decline and keep the flat fallback, which is the 2026-09-06 Banjo-Tooie guard.
    uint32_t pager_vec = 0u;
    {
        const uint32_t* v_tlb     = (const uint32_t*)(rdram + 0x0u);     // 32-bit TLB-refill vector
        const uint32_t* v_xtlb    = (const uint32_t*)(rdram + 0x80u);    // XTLB-refill vector
        const uint32_t* v_general = (const uint32_t*)(rdram + 0x180u);   // general exception vector
        auto stock = [v_general](const uint32_t* v) {
            return v[0] == v_general[0] && v[1] == v_general[1] &&
                   v[2] == v_general[2] && v[3] == v_general[3];
        };
        // [refill32-guard 2026-09-06] A pager can only exist once the kernel has installed its
        // GENERAL handler (osInitialize writes all four vectors together; a real pager is copied over
        // 0x80000000 afterwards, as GoldenEye does). While 0x80000180 is still zero, whatever sits at
        // 0x80000000 is boot residue or snapshot data, not a handler: on Banjo-Kazooie the first draft
        // of this test delivered one refill into such residue (1 launch in 6 went black, a refill
        // killing the thread the 03:43 guard had saved). Also require the OTHER refill vector to be the
        // stock preamble: a kernel installs one pager, not two.
        const bool kernel_up = (v_general[0] != 0u);
        // A refill handler's FIRST instruction is a COP0 op (GoldenEye: mtc0 $zero,PageMask then mfc0
        // $k0,Context; the MIPS convention reads Context/BadVAddr into k0/k1 first). The stock preamble
        // starts with lui, and the residue Banjo-Kazooie leaves at 0x80000000 (a [hi,mask,lo0,lo1] TLB
        // entry record, first word 0xC0000000) starts with neither: run r32g3 delivered a refill into it
        // and killed the graphics thread. A non-COP0 first word is data, not a pager.
        auto refill_like = [](const uint32_t* v) { return ((v[0] >> 26) & 0x3Fu) == 0x10u; };
        if      (kernel_up && v_tlb[0]  != 0u && !stock(v_tlb)  && stock(v_xtlb) && refill_like(v_tlb))  pager_vec = 0x80000000u;
        else if (kernel_up && v_xtlb[0] != 0u && !stock(v_xtlb) && stock(v_tlb)  && refill_like(v_xtlb)) pager_vec = 0x80000080u;
        if (pager_vec == 0u) {
            static int _nv = 0;
            if (_nv++ < 4) {
                fprintf(stderr, "[refill-vector] 0x80000000 and 0x80000080 both hold the stock libultra "
                                "preamble (no demand pager) -> declining TLB refill for vaddr=0x%08X, "
                                "keeping the flat fallback\n", vaddr);
                fflush(stderr);
            }
            return 0;
        }
    }
    // Anti-hang guard: if we already raised for this exact (epc,vaddr) and it is STILL unmapped, the
    // handler did not resolve it -- fall back to flat after a few tries instead of looping forever.
    static thread_local uint32_t last_pc = 0, last_va = 0;
    static thread_local int repeat = 0;
    if (epc == last_pc && vaddr == last_va) { if (++repeat > 3) return 0; }
    else { last_pc = epc; last_va = vaddr; repeat = 0; }

    const uint32_t status  = (uint32_t)cop0_status_read(ctx);
    const uint32_t entryhi = recomp_cop0_tlb_read(10);
    recomp_cop0_tlb_write(8, vaddr);                                             // BadVAddr (reg 8)
    const uint32_t context = (recomp_cop0_tlb_read(4) & 0xFF800000u)
                           | (((vaddr >> 13) << 4) & 0x007FFFF0u);
    recomp_cop0_tlb_write(4, context);                                          // Context (BadVPN2)
    recomp_cop0_tlb_write(10, (vaddr & 0xFFFFE000u) | (entryhi & 0xFFu));        // EntryHi (VPN2|ASID)
    uint32_t cause = recomp_cop0_tlb_read(13) & ~0x8000007Cu;                    // clear BD + ExcCode
    cause |= (uint32_t)((is_store ? 3u : 2u) << 2);                             // TLBS=3 / TLBL=2
    recomp_cop0_tlb_write(13, cause);
    // A MATCHING entry with V clear is a TLB *Invalid*, not a refill: hardware sends it to the
    // GENERAL vector with the same TLBL/TLBS code, which is where a kernel's fault path lives.
    // GoldenEye's pager needs both halves -- the fast refill installs whatever the page table holds
    // (zero, i.e. V = 0, for a page not resident yet) and the retried access then takes the Invalid,
    // which its libultra turns into OS_EVENT_FAULT for the fault thread that DMAs the page in.
    const int _match = recomp_tlb_match_state(vaddr);       // 0 = no entry, 2 = entry with V clear
    uint32_t vector;
    if (status & 0x2u) {                                                         // EXL already set:
        vector = 0x80000180u;                                                   // nested -> general vector
    } else {
        recomp_cop0_tlb_write(14, epc);                                         // EPC = faulting instr
        cop0_status_write(ctx, (uint64_t)(status | 0x2u));                      // set EXL (Status is in ctx)
        vector = (_match == 2) ? 0x80000180u                                    // TLB Invalid -> general
                               : pager_vec;                                     // TLB refill  -> the pager
    }
    static int _n = 0;
    if (_n++ < 40 || (_n % 2000) == 0) {
        fprintf(stderr, "[tlb-refill] #%d %s vaddr=0x%08X epc=0x%08X -> vector 0x%08X (EntryHi=0x%08X) tcb=0x%08X\n",
                _n, is_store ? "store" : "load", vaddr, epc, vector,
                (vaddr & 0xFFFFE000u) | (entryhi & 0xFFu), g_current_tcb);
        fflush(stderr);
    }
    return vector;
}

extern "C" void recomp_baremetal_interp_poll(uint32_t pc) {
    // Venue census (fifa drain-starvation dig 2026-08-05): every 4096th call prints the gate
    // states, so a starved drain names its blocker — or, if this never prints at all, the
    // spinner is NATIVE code with no poll guard and this venue never sees it.
    {
        static std::atomic<long> _n{0};
        long n = ++_n;
        if ((n & 0xFFFu) == 1u)
            fprintf(stderr, "[interp-poll] #%ld pc=0x%08X in_intr=%d eret_drain=%d pending=%d enabled=%d autobm=%d\n",
                    n, pc, (int)tl_in_interrupt, (int)tl_eret_drain,
                    g_pending_intr.load(std::memory_order_relaxed), (int)g_enabled, (int)g_autobm);
    }
    if (!g_enabled || !g_autobm || g_ctx == nullptr) return;
    if (tl_in_interrupt || tl_eret_drain) {
        // [drain-spin 08-27] THE NO-INPUT HANG: a drain runs the guest handler, the handler ends
        // up in an INTERPRETED loop waiting for something only the next interrupt can provide,
        // and this very guard refuses to deliver it — 100% CPU forever (measured: game thread
        // Running, 97s CPU, RIP inside exec_one/fetch_instr). Name the spinning pcs so the loop
        // can be identified; instrument only, the guard still holds.
        if (tl_eret_drain) {
            static std::atomic<long> _ds{0};
            long n = ++_ds;
            if ((n & 0xFFFu) == 1u) {
                fprintf(stderr, "[drain-spin] #%ld interp still running INSIDE a drain: pc=0x%08X venue=%s pending=%d\n",
                        n, pc, tl_drain_venue ? tl_drain_venue : "?",
                        g_pending_intr.load(std::memory_order_relaxed));
                fflush(stderr);
            }
        }
        return;    // never on the VI host thread / nested drain
    }
    if (g_pending_intr.load(std::memory_order_relaxed) <= 0) return;
    // ── EPC HONESTY: an EPC must name EXECUTABLE MEMORY (2026-08-06) ─────────────────────────
    // Hardware's EPC is the address of the interrupted instruction, so it always lies inside
    // real memory. An interpreter session that derails (mis-dispatch, data-as-code) walks its
    // pc past the end of RDRAM — measured on turok2: pc sliding ~48K instructions per poll
    // through zeroed RAM to 0x80A30588, physical 10.7MB on an 8MB machine. Latching that as
    // EPC hands the guest a resume address it will save into a TCB and eret to later: one
    // derailed session permanently poisons a thread. A venue that cannot name a REAL
    // interrupted pc must defer (the same law as the pc-less venues) — the note stays pending
    // and the next honest venue delivers. Delay, never dishonesty.
    {
        uint32_t phys = recomp_tlb_translate(pc) & 0x1FFFFFFFu;
        if (phys >= 0x800000u || (pc & 3u) != 0u) {
            static std::atomic<long> _wp{0}; long n = ++_wp;
            if (n <= 16 || (n % 4096) == 0)
                fprintf(stderr, "[epc-honesty] #%ld declined: pc=0x%08X (phys 0x%08X) is outside RDRAM — derailed session, not latching\n",
                        n, pc, phys);
            return;
        }
    }
    // ── [EPC poison: MECHANISM PROVEN, blunt fix REVERTED 2026-08-27] ───────────────────────────
    // MEASURED: the worker TCB acquires saved pc = 0x800C3EC0, an address INSIDE the guest's own
    // dispatcher (instruction there is `jr ra`). Every dispatch then re-enters the dispatcher,
    // erets, and dispatches again: 10.5 MILLION self-redispatches in one 18s boot (~580k/sec)
    // retiring zero guest instructions. Cause: this venue latches EPC BEFORE the gate decides, so
    // while the guest runs its dispatcher we record a dispatcher address as the interrupted pc,
    // and the parked-artifact bypass then delivers anyway so the guest saves the poison into a TCB.
    // PROVEN by experiment: skipping the latch whenever SR says uninterruptible drops the loop from
    // 10,500,000 to 6. But it REGRESSED BOOT (0/4 runs past 24s vs 4/6 past 50s before), because a
    // skipped latch leaves a STALE EPC for the bypass to deliver against — a different lie.
    // So the fix is NOT "never latch": it is to stop DELIVERING while uninterruptible, i.e. narrow
    // the parked-artifact bypass so it cannot fire when the live pc is inside the guest's exception
    // /dispatch code. Do that next; do not re-try the blunt skip.
    // ── [dispatch-window 2026-08-28] DO NOT DELIVER WHILE THE GUEST IS INSIDE ITS DISPATCHER ────
    // The EPC-poison mechanism, now measured end-to-end on SOTE and traced to guest code:
    //   * learn-2 finds the dispatcher; SOTE's is at 0x800C3ED8 and does exactly what libultra's
    //     __osDispatchThread does — pop the run-queue head, store it to the current-task word,
    //     mark it RUNNING(4), reload the register file from the TCB, eret.
    //   * This venue latched pc=0x800C3EDC (its SECOND instruction) as the interrupted pc while
    //     the guest was mid-dispatch, and the parked-artifact bypass then delivered, so the
    //     guest's own save path canonized "dispatch a thread" into that thread's TCB.
    //   * Dispatching it then re-enters the dispatcher, which dispatches it again: a closed loop
    //     ENTIRELY INSIDE GUEST CODE. Measured: self-redispatch 172 -> 162,716 in one second,
    //     climbing ~186k/sec, handler entries FROZEN, ZERO guest instructions retired.
    // Hardware cannot do this: the dispatcher runs with interrupts off precisely so it cannot be
    // interrupted, so a pc inside it is never a legal interrupted pc. Decline here — do not latch
    // AND do not drain — so the note stays pending and the next honest venue delivers it.
    // This is NOT the blunt "never latch while uninterruptible" that was tried and REVERTED on
    // 08-27 (0/4 boots past 24s): that one skipped the latch but STILL DELIVERED, against a stale
    // EPC. Declining the whole delivery leaves nothing stale to deliver against. Same law as the
    // [epc-honesty] guard directly above: delay, never dishonesty.
    if (bm_pc_in_dispatch(pc)) {
        static std::atomic<long> _dw{0}; long n = ++_dw;
        if (n <= 16 || (n % 4096) == 0) {
            fprintf(stderr, "[dispatch-window] #%ld declined: pc=0x%08X is inside the guest dispatcher 0x%08X..0x%08X — not latching, not draining%c",
                    n, pc, g_disp_lo, g_disp_hi, 0x0A);
            fflush(stderr);
        }
        return;
    }
    {
        uint32_t _gsr = 0;
        if (bm_latch_gate_closed(&_gsr)) { bm_latch_gate_note("interp-poll", _gsr, pc); return; }   // [latch-gate]
    }
    recomp_cop0_tlb_write(14, pc);   // hardware: exception entry latches EPC = interrupted pc
    tl_eret_drain = true;
    tl_drain_venue = "interp-poll";      // venue-census tag (EPC latched = live pc)
    recomp_baremetal_idle();
    tl_drain_venue = "direct";
    tl_eret_drain = false;
}

// recomp_eret — emitted by the recompiler in place of a guest `eret`. The recompiled dispatcher has, just
// before this, restored the target task's registers into ctx and written its resume PC to COP0 EPC (reg 14)
// and the scheduler's current-task pointer. We switch to that task's fiber (creating it on first dispatch).
static int g_dbg = 0;

// Shared-ctx seam fingerprint (SOTE wall-3): every fiber, the interpreted dispatcher, and the
// handler-drain all flow through ONE recomp_context, so a resumed task can wake with registers
// some other execution left behind. Print the registers that matter for identifying WHOSE set
// this is (ra/sp/s0/s1 = callee state, k0 = dispatched TCB, v0/a0 = call results/args) at each
// handoff so a diff of PRE-SWITCH vs RESUMED names the torn register and the clobberer.
static void bm_ctx_fp(const char* tag, uint32_t tcb, recomp_context* ctx) {
    const uint64_t* r = (const uint64_t*)ctx;
    fprintf(stderr, "[bmsched] %s tcb=0x%08X ctx=%p sr=0x%08X ra=0x%08X sp=0x%08X s0=0x%08X s1=0x%08X k0=0x%08X v0=0x%08X a0=0x%08X\n",
            tag, tcb, (void*)ctx, (uint32_t)cop0_status_read(ctx), (uint32_t)r[31], (uint32_t)r[29], (uint32_t)r[16], (uint32_t)r[17],
            (uint32_t)r[26], (uint32_t)r[2], (uint32_t)r[4]);
    fflush(stderr);
}
extern "C" void recomp_eret(uint8_t* rdram, recomp_context* ctx) {
    lazy_init();
    g_eret_census[0].fetch_add(1, std::memory_order_relaxed);
    // [eret-census] Does the GUEST's own current-task word agree with what the engine believes is
    // running? A persistent disagreement means we execute a thread the game thinks is blocked while
    // starving the one it selected - the split-brain measured on the SOTE hang.
    if (g_rdram != nullptr && g_taskptr != 0u) {
        const uint32_t _cw = g_taskptr & 0x00FFFFFFu;
        if (_cw + 4u < 0x00800000u) {
            const uint32_t _gcur = *(const uint32_t*)(g_rdram + _cw);
            if (_gcur != 0u && _gcur != g_current_tcb) g_eret_census[4].fetch_add(1, std::memory_order_relaxed);
        }
    }
    g_eret_seen.store(true, std::memory_order_relaxed);   // raw-MMIO ports never get here (site-2 gate)
    { static int _c = 0; if (_c < 500) { _c++; fprintf(stderr, "[bmsched] CALLED enabled=%d taskptr=0x%08X\n", g_enabled, g_taskptr); fflush(stderr); } }
    // AUTO-ARM latch site 1 (primary): reaching a compiled guest eret IS the self-hosted-OS proof,
    // so arm even before the game's MI-mask/vector setup (SOTE: the mask is set INSIDE the thread
    // this very eret dispatches — the old mask gate deadlocked the native boot).
    if (!g_enabled) {
        // (recomp_context is opaque here; the GPRs are the leading u64 array of the ABI — slot 26 = $k0.)
        if (!try_autoarm(rdram, /*from_eret=*/true, (uint32_t)((const uint64_t*)ctx)[26])) return;   // baseline games never reach here anyway
    }
    g_ctx = ctx; g_rdram = rdram;      // capture the shared ctx/rdram for the idle handler-drain (Piece 2)
#ifdef _WIN32
    // [rip-sample] duplicate the GAME thread's real handle so the VI thread's frozen-detector can
    // Suspend/GetThreadContext/Resume it and name the unguarded native cycle by RIP (.map lookup).
    {
        extern void* g_game_thread_handle;
        if (g_game_thread_handle == nullptr) {
            DuplicateHandle(GetCurrentProcess(), GetCurrentThread(), GetCurrentProcess(),
                            (HANDLE*)&g_game_thread_handle, THREAD_SUSPEND_RESUME | THREAD_GET_CONTEXT,
                            FALSE, 0);
        }
    }
#endif
    if (tl_in_interrupt) { if (g_dbg < 500) { g_dbg++; fprintf(stderr, "[bmsched] eret on INTERRUPT thread -> skip\n"); fflush(stderr); } return; }
    // VR4300 eret semantics: clear Status.ERL if set, else Status.EXL — the exception-level bit
    // the kernel set at handler entry. Without this the first exception left EXL stuck in the
    // guest-visible SR forever (observed SR=0xFF03 steady-state), which starves the EXL/ERL
    // drain gate and misrepresents the guest's critical-section state.
    {
        uint32_t _sr = (uint32_t)cop0_status_read(ctx);
        if (_sr & 0x4u) cop0_status_write(ctx, _sr & ~0x4u);
        else if (_sr & 0x2u) cop0_status_write(ctx, _sr & ~0x2u);
    }
    // Bracket the native handler: it ran just before this eret and may have left high-half-truncated /
    // wild pointers in the scheduler run-queue + wait-lists (the deterministic NC tear). Scrub them now so
    // the NEXT dispatch walks clean pointers — combined with the pre-handler scrub in recomp_baremetal_idle,
    // this brackets every handler invocation. NC-only; inert for baseline + auto games.
    if (g_nc_mode) nc_scrub_scheduler_region(rdram);

#ifdef _WIN32
    uint32_t epc = recomp_cop0_tlb_read(14);
    static int _dbgcap = -2; if (_dbgcap == -2) { const char* e = getenv("RECOMP_BM_RUNLOG"); _dbgcap = (e && *e) ? atoi(e) : 0; }
    bool dbg = (_dbgcap < 0) || (g_dbg < _dbgcap); if (dbg) { g_dbg++; fprintf(stderr, "[bmsched] eret GAME-thread epc=0x%08X sr=0x%08X root=%p\n", epc, (uint32_t)cop0_status_read(ctx), g_root_fiber); fflush(stderr); }
    // NOTE: EPC matters only for CREATING a task's fiber (its entry PC). For an EXISTING fiber the EPC is
    // irrelevant — the fiber resumes its own suspend point — so do NOT early-out on epc==0 here (the idle's
    // saved EPC is 0 since we don't seed it before the handler, yet we must still be able to switch to it).

    if (g_root_fiber == nullptr) {
        // First eret on the game thread: become a fiber so we can switch among task fibers.
        g_root_fiber = ConvertThreadToFiber(nullptr);
        if (g_root_fiber == nullptr) { if (dbg) { fprintf(stderr, "[bmsched]   ConvertThreadToFiber FAILED\n"); fflush(stderr); } return; }
        // ── THE BOOT THREAD IS A TASK TOO: register the root under the TCB that was running ──────
        // The thread executing this first eret is a real guest thread with a real TCB — sm64's boot
        // thread, mid-osStartThread, having just preempted itself to launch the VI manager. Its
        // continuation lives on THIS host stack, which is exactly what g_root_fiber now wraps.
        //
        // Without an entry in g_fibers for it, the game's own scheduler dispatching BACK to it (the
        // normal shape: viMgrMain blocks on its retrace queue, __osDispatchThread picks the next
        // runnable thread = boot) finds no fiber and cold-enters at its saved EPC instead. That EPC
        // is mid-function, get_function resolves only entries, and it falls to the LiveRecomp gap
        // trampoline -> interpreter -> derail. Measured on sm64: the unresolved addresses were
        // osStartThread+0x134 (this very continuation), osRecvMesg+0x68 and osSetThreadPri+0xC4 —
        // all continuations of threads whose fibers we never recorded. Boot never resumed, so it
        // never reached osViSetEvent, so the VI queue stayed NULL and the VI manager never woke:
        // the whole stall, from one missing map entry.
        //
        // Seed it with a started fiber whose handle IS the root, so recomp_eret's dispatch treats it
        // like any other task: a plain SwitchToFiber back to a live, intact stack. Native resume,
        // mid-function, no lookup, no interpreter.
        // Same read the dispatch below uses: the scheduler's current-task word, swizzled (host LE
        // word == guest BE word at this offset). 0 if the taskptr has not been learned yet.
        uint32_t boot_tcb = g_taskptr ? *(uint32_t*)(rdram + (g_taskptr & 0x1FFFFFFFu)) : 0u;
        if (boot_tcb != 0 && g_fibers.find(boot_tcb) == g_fibers.end()) {
            TaskFiber* rf = new TaskFiber();
            rf->handle  = g_root_fiber;
            rf->epc     = 0;              // never cold-entered: its continuation is the live stack
            rf->rdram   = rdram;
            rf->ctx     = ctx;
            rf->started = true;
            g_fibers[boot_tcb] = rf;
            g_running       = rf;
            g_current_tcb   = boot_tcb;
            if (dbg) { fprintf(stderr, "[bmsched]   ROOT registered as boot task tcb=0x%08X\n", boot_tcb); fflush(stderr); }
        }
    }

    // DRAIN-AT-ERET (auto-bm round 6; the design's R3 contingency): every dispatcher pass pumps
    // pending interrupts FIRST — the moral equivalent of hardware preemption. The guest idle can
    // never be relied on to reach a yield venue (JIT'd busy-loops have no poll guards yet), so the
    // scheduler itself is the pump. Recursion-guarded: the drain runs the handler, whose own eret
    // re-enters here to DISPATCH (pending already taken, guard set → no re-drain).
    // (drain-at-eret REMOVED, SOTE wall 3: running the handler mid-dispatch — after the guest
    // dispatcher already restored the NEXT task's registers — saved that half-way state with a
    // STALE EPC into the current TCB, poisoning its resume pc (observed epc=0x00000FA0 + torn
    // current-task word). Hardware cannot take an interrupt there: EXL is set for the whole
    // dispatcher. The interp-poll venue (EPC-latching), the root wait-for-interrupt pump, and
    // dead_end now cover every starvation case with correct exception semantics.)

    // Dead-end pick: the dispatcher selected an invalid task (no current-task ptr, or a never-run task with no
    // resume PC). Don't strand the cascade in a dead C frame. NC mode: switch back to the idle's handler-drain
    // fiber (pause_self loops there). AUTO mode: become the WAIT-FOR-INTERRUPT loop right here — nothing is
    // runnable, so park this fiber pumping interrupts; each drain's handler-eret dispatches the woken thread
    // from inside (control switches away and returns here only when nothing is runnable again). This is what
    // the silicon does on an empty run queue, and it makes the pump independent of any guest idle loop.
    auto dead_end = [&]() {
        if (g_autobm) {
            static int _we = 0; if (_we++ < 8) { fprintf(stderr, "[bmsched] dead-end -> wait-for-interrupt pump\n"); fflush(stderr); }
            while (g_enabled) {
                if (!tl_eret_drain && g_pending_intr.load(std::memory_order_relaxed) > 0) {
                    tl_eret_drain = true;
                    recomp_baremetal_idle();
                    tl_eret_drain = false;
                }
                Sleep(1);   // ~1ms tick; the VI host thread notes at 60Hz so pending always arrives
            }
            return;
        }
        if (g_idle_fiber && GetCurrentFiber() != g_idle_fiber) SwitchToFiber(g_idle_fiber);
    };

    // Task select. Legacy (taskptr from env): read the guest current-task word. AUTO (taskptr==0):
    // the stock-libultra ABI invariant — the dispatcher (__osDispatchThread) enters eret with
    // $k0 (r26) = the dispatched TCB and never restores k0 (kernel scratch), all libultra vintages.
    // (recomp_context is opaque here; the GPRs are the leading u64 array of the ABI — slot 26 = $k0.)
    uint32_t tcb = g_taskptr ? *(uint32_t*)(rdram + (g_taskptr & 0x1FFFFFFFu))   // swizzled: host LE == guest BE word
                             : (uint32_t)((const uint64_t*)ctx)[26];
    if (dbg) { fprintf(stderr, "[bmsched]   tcb=0x%08X (taskptr 0x%08X%s)\n", tcb, g_taskptr, g_autobm ? " AUTO/k0" : ""); fflush(stderr); }

    // ── EPC-RESTORE LATCH (2026-08-06, the k0-clobber decode) ────────────────────────────────
    // This libultra vintage clobbers k0 with the MI address (0xA430000C) in the dispatcher's
    // mask-write epilogue — AFTER the register restore, BEFORE the eret — so eret-time k0 is
    // NEVER the TCB (fifa + all three turoks). But the dispatcher names its thread earlier:
    // `lw kX, savedPC(TCB); mtc0 kX, $14` runs with k0 = the TCB still live, and
    // recomp_bm_epc_restore_hook latched it there. Prefer the latch when eret-time k0 is
    // unusable — this dispatches the thread the GUEST's scheduler actually chose (the popped
    // run-queue head), where the anonymous continuation could only resume the interrupted one.
    if (g_autobm) {
        auto plausible = [](uint32_t p) {
            return ((p >> 28) == 0x8u && (p & 0x1FFFFFFFu) < 0x800000u) ||
                   (p >= 0x1000u && p < 0x80000000u && (p & 0xFF000000u) != 0xA4000000u);
        };
        uint32_t latch = g_epc_restore_k0;
        if (!plausible(tcb) && latch != 0u && plausible(latch)) {
            static int _lt = 0;
            if (++_lt <= 64) {
                fprintf(stderr, "[bmsched]   tcb 0x%08X unusable -> EPC-restore latch 0x%08X (the dispatcher's own thread)\n", tcb, latch);
                fflush(stderr);
            }
            tcb = latch;
        }
    }

    // ── HIGH-HALF REPAIR (NC-only, baseline-safe) ─────────────────────────────────────────────────
    // Track the last KSEG0-valid current-task pointer we saw. The corruption observed in Nightmare
    // Creatures is a deterministic HIGH-HALF TRUNCATION of this word: 0x800BF090 -> 0x0001F090 (low
    // 16 bits 0xF090 intact, high 16 bits 0x800B clipped to 0x0001). It is NOT produced by any guest
    // store (the static trace proved the only writer of 0x800A36B0 is a full-word `sw`, and every
    // scheduler enqueue/dequeue is full-word); it is an engine-level register tear across the
    // fiber/native context switch on the SHARED recomp_context. We cannot cheaply fix the tear at its
    // physical source without reworking the per-fiber register file, so we REPAIR the symptom here:
    // if the read tcb is non-KSEG0 but its low half equals the low half of the last good tcb, restore
    // the high half from that last-good value. This un-skips the INTENDED task so the scheduler
    // advances (and we verify it reaches osCreateScheduler). Gated entirely on NC_IRQ -> baseline
    // (libultra-HLE) games never execute a guest eret, never reach here, and are byte-for-byte unchanged.
    if (((tcb >> 28) == 0x8u)) {
        g_tcb_hi = tcb & 0xFFFF0000u;                            // remember the known-good high half (0x800B0000)
    } else if (tcb != 0u && g_nc_mode &&                         // NC-only (never repair an auto game's pointers)
               g_tcb_hi != 0 &&
               (tcb & 0xFFFF0000u) == 0x00010000u) {             // the observed 0x0001xxxx truncation signature
        uint32_t repaired = g_tcb_hi | (tcb & 0xFFFFu);
        static int _re = 0;
        if (++_re <= 200) {
            fprintf(stderr,
                "[bmsched][REPAIR] eret tcb 0x%08X (truncated) -> 0x%08X (high half 0x%08X)\n",
                tcb, repaired, g_tcb_hi);
            fflush(stderr);
        }
        // Write the repaired pointer BACK to the guest current-task word so any subsequent guest reads
        // of 0x800A36B0 (the scheduler re-reads it) also see the corrected value, not the truncated one.
        *(uint32_t*)(rdram + (g_taskptr & 0x1FFFFFFFu)) = repaired;
        tcb = repaired;
        // fall through with the repaired tcb (do NOT dead-end) so we switch to the intended task
    } else if (g_autobm && tcb >= 0x1000u && tcb < 0x80000000u && (tcb & 0xFF000000u) != 0xA4000000u) {
        // TLB-WINDOW KERNEL (Acclaim class, turok2/3 2026-08-06): a bit-31-clear TCB is a
        // mapped low vaddr under the game's own memory model (kernel linked at virtual
        // 0x200000+phys), not corruption. Its data reads translate through the live TLB;
        // the fiber map only needs a stable key. Accept as-is. (0xA4xxxxxx = RCP register
        // space can never be a TCB — that is the boot-residue class below.)
    } else {
        // Implausible thread identity (boot-residue k0 = the MI mirror 0xA430000C — the wall
        // fifa and all three turoks converged on). Keep the diagnostic:
        static int _ce = 0;
        if (++_ce <= 200) {
            uint32_t node0 = *(uint32_t*)(rdram + 0x000A36A8u);
            uint32_t node4 = *(uint32_t*)(rdram + 0x000A36ACu);
            fprintf(stderr,
                "[bmsched][CORRUPT] eret read non-KSEG0 tcb=0x%08X (taskptr 0x%08X) | rq[0x36A8]=0x%08X rq[0x36AC]=0x%08X | hi=0x%04X lo=0x%04X (0x800B%04X?)\n",
                tcb, g_taskptr, node0, node4, (tcb >> 16) & 0xFFFF, tcb & 0xFFFF, tcb & 0xFFFF);
            fflush(stderr);
        }
        // HARDWARE-FAITHFUL FALLBACK (2026-08-06): silicon's eret has no TCB concept — it
        // returns to EPC with the live register file. The k0 heuristic failing means the
        // thread cannot be NAMED, not that it cannot be RUN; the stock-libultra k0 invariant
        // simply does not hold at a non-libultra kernel's first eret (k0 is scratch there).
        // Key the continuation fiber by EPC and proceed; identity refines once the kernel
        // establishes its own convention. Dead-end only when EPC itself is implausible.
        if (g_autobm && epc != 0 && (epc & 3u) == 0) {
            // [running-tcb rescue 2026-08-26] The B1 wave EATS the curtask word (measured in the
            // wedge snapshot: [0x800E7CB0]=0xD2CFCFCF) but the thread RECORDS survive — the
            // worker's TCB still said state=RUNNING(4) while the anonymous continuation re-parked
            // the idle spin forever and the transition thread never ran again. Hardware's "current
            // task" at this moment IS that running thread (one CPU, one continuation). If exactly
            // ONE known fiber's guest TCB reads RUNNING, resume its suspension (regs+pc preserved
            // by the fiber, same no-clobber semantics as the hold-resume path).
            if (GetCurrentFiber() == g_root_fiber) {
                uint32_t rt = 0; int rn = 0;
                for (auto& kv : g_fibers) {
                    const uint32_t t = kv.first;
                    if ((t >> 28) != 0x8u || kv.second == nullptr || !kv.second->started) continue;
                    const uint32_t p2 = t & 0x00FFFFFFu;
                    if (p2 + 0x14u > 0x00800000u) continue;
                    if ((*(uint32_t*)(rdram + p2 + 0x10u) >> 16) == 4u && kv.second != g_running) { rt = t; ++rn; }
                }
                if (rn == 1) {
                    static int _rr = 0;
                    ++_rr;
                    if (_rr <= 24 || (_rr % 2000) == 0) {
                        fprintf(stderr, "[bmsched] running-tcb rescue #%d: curtask word eaten, kernel TCB 0x%08X reads RUNNING - resuming its suspension%c", _rr, rt, 0x0A);
                        fflush(stderr);
                    }
                    g_direct_wakee = rt;
                    if (bm_resume_interrupted_task()) return;
                    g_direct_wakee = 0u;
                }
            }
            static int _ff = 0;
            if (++_ff <= 64) {
                fprintf(stderr, "[bmsched] faithful-eret: tcb unusable, continuing at epc=0x%08X (anonymous continuation)\n", epc);
                fflush(stderr);
            }
            // ONE anonymous continuation, not one per epc: hardware has one CPU. Keying by
            // epc spawned a fresh fiber + guest stack on EVERY interrupt return (epc advances
            // each time) — turok2 leaked fibers at 60Hz and turok3 rode the leak into a host
            // WRITE AV in the yield venue. A fixed sentinel reuses the single boot fiber: the
            // redispatch path updates its epc, and resuming its suspension IS the interrupted
            // point the eret names. Identity refines once the kernel establishes k0.
            tcb = 0xFFFFFFF0u;
        } else {
            dead_end(); return;
        }
    }
    if (tcb == 0) { dead_end(); return; }

    TaskFiber*& tf = g_fibers[tcb];
    if (tf == nullptr) {
        if (epc == 0) { g_fibers.erase(tcb); dead_end(); return; }   // can't create a fiber without a valid entry PC
        tf = new TaskFiber();
        tf->epc = epc; tf->rdram = rdram;
        // PER-FIBER FILE (auto-bm): the thread owns its register file; seed it with the
        // dispatcher-restored state the erettor's file holds RIGHT NOW (hardware: the one
        // physical file at eret = the new thread's registers). NC keeps the shared ctx.
        if (g_autobm) { tf->own = bm_ctx_alloc(); bm_ctx_copy(tf->own, ctx); tf->ctx = tf->own; }
        else         { tf->ctx = ctx; }
        tf->handle = CreateFiber(0, &fiber_proc, tf);
        if (tf->handle == nullptr) { if (dbg) { fprintf(stderr, "[bmsched]   CreateFiber FAILED\n"); fflush(stderr); } g_fibers.erase(tcb); return; }
        if (dbg) { fprintf(stderr, "[bmsched]   NEW fiber for tcb=0x%08X epc=0x%08X\n", tcb, epc); fflush(stderr); }
    } else {
        // [eret-census] redispatch of an EXISTING fiber: the guest's canonized state is about to
        // overwrite the parked fiber's own file. If the fiber parked mid-interp (interp_depth>0),
        // its resume continues at the interp's live pc — registers from the guest's save, pc from
        // the suspension: any divergence between them is the defect-B tear at its landing point.
        if (g_autobm && tf->started && tf->interp_depth > 0) {
            static std::atomic<long> _ec{0}; long n = ++_ec;
            if (n <= 60 || (n % 500) == 0) {
                if (rc_trace_on("RECOMP_ERET_CENSUS")) fprintf(stderr, "[eret-census] #%ld resume PARKED-MID-INTERP tcb=0x%08X guest_epc=0x%08X parked_depth=%d (fiber suspension wins pc; guest file wins regs)\n",
                        n, tcb, epc, tf->interp_depth);
                fflush(stderr);
            }
        }
        // ── [epc-wins 2026-09-05, Rage Wars #152: the two-stage boot] ──────────────────────────────
        // Hardware resumes a thread at the pc its TCB holds. Our fiber model resumed a fiber parked
        // mid-interp at its SUSPENSION point ("fiber suspension wins pc"), which is only right while
        // the guest never changes that thread's saved pc. Rage Wars' loader stage wipes its thread
        // table (32 KB block clear at ~3.8 s), re-creates the BOOT thread over the same TCB with a
        // new entry (create 0x002BABC0(tcb=0x80119590, pri 0, entry 0x002933F8) + start), and the
        // dispatch of that thread named EPC 0x002933F8 while the fiber sat parked in the old idle trap
        // `j .` at 0x00292F38: the resume replayed the idle loop forever, the VI handler re-saved the
        // idle pc into the fresh TCB 60x/s, the interpreter budget ran out and the engine bailed into
        // a KSEG0 alias with a garbage file (curtask=0x00043F10). Rule: when a parked fiber is
        // dispatched at a guest EPC that differs from its parked live pc, the GUEST EPC WINS - the
        // parked frame is abandoned on resume (below, at the yield-to-root return) and fiber_proc
        // re-enters at epc with the file this dispatch just copied in. Honesty guards keep a poisoned
        // EPC from being honored: it must be aligned, inside RDRAM, real code, and not inside the
        // guest's own dispatcher (never a legal interrupted pc). Equal pcs = the ordinary
        // resume-after-interrupt: unchanged.
        tf->abandon_parked = false;
        if (g_autobm && tf->started && tf->interp_depth > 0 && tf->live_pc != 0u && epc != 0u && epc != tf->live_pc
            && (epc & 3u) == 0u && ((recomp_tlb_translate(epc) & 0x1FFFFFFFu) < 0x00800000u)
            && !bm_pc_in_dispatch(epc) && recomp_interp_is_code(rdram, epc)) {
            tf->abandon_parked = true;
            static std::atomic<long> _ew{0}; long n = ++_ew;
            if (n <= 40 || (n % 1000) == 0) {
                fprintf(stderr, "[epc-wins] #%ld tcb=0x%08X parked_pc=0x%08X guest_epc=0x%08X -> abandon the parked interp frame on resume, re-enter at the guest EPC\n",
                        n, tcb, tf->live_pc, epc);
                fflush(stderr);
            }
        }
        tf->epc = epc; tf->rdram = rdram;
        // Redispatch of an existing thread: move the dispatcher-restored register state into
        // the thread's OWN file (hardware restore). Never re-alias tf->ctx to the shared file.
        if (g_autobm && tf->own != nullptr) { bm_ctx_copy(tf->own, ctx); tf->ctx = tf->own; }
        else if (g_autobm && tf->own == nullptr) { tf->own = bm_ctx_alloc(); bm_ctx_copy(tf->own, ctx); tf->ctx = tf->own; }
        else { tf->ctx = ctx; }
    }
    if (tf == g_running) {
        g_eret_census[2].fetch_add(1, std::memory_order_relaxed);   // [eret-census] self-redispatch
        // [selfredis-probe 2026-08-27] The 180k/sec closed loop runs through HERE. Name the pc we
        // are about to re-enter at, and the instruction living there, so the bad resume point can
        // be traced to its producer. Sampled, not capped-to-death.
        {
            static std::atomic<long> _sr2{0}; long n = ++_sr2;
            if (n <= 6 || (n % 100000) == 0) {
                uint32_t insn = 0;
                if (g_rdram != nullptr && (tf->epc & 0x1FFFFFFFu) + 4u < 0x00800000u)
                    insn = *(const uint32_t*)(g_rdram + (tf->epc & 0x1FFFFFFFu));
                fprintf(stderr, "[selfredis] #%ld tcb=0x%08X epc=0x%08X insn=0x%08X%s cop0epc=0x%08X%c",
                        n, tcb, tf->epc, insn, (insn == 0x42000018u) ? " (ERET!)" : "",
                        recomp_cop0_tlb_read(14), 0x0A);
                fflush(stderr);
            }
        }
        if (dbg) { fprintf(stderr, "[bmsched]   already running tcb=0x%08X -> self-redispatch at epc\n", tcb); fflush(stderr); }
        // Self-redispatch: the guest eret resumed the task that is already current (the normal
        // resume-after-interrupt shape). Hardware still JUMPS to EPC — returning here would unwind
        // the abandoned dispatcher frames with the EPC-restored register file (same wall-3 tail
        // replay as the cross-task case, just through this early-out). Re-enter at tf->epc.
        if (g_autobm && GetCurrentFiber() != g_root_fiber) {
            throw BmFiberRedispatch{};
        }
        // ── ERET-TO-INTERRUPTED-TASK ON THE ROOT (2026-08-05, fifa's crawl-basin derail) ─────────
        // A drain's handler (running on the ROOT) erets back to the task it interrupted — the
        // single most common exception exit on hardware. The old plain `return` fell back into
        // the handler's own post-eret frames: benign by luck when the handler ran native (the
        // frames just unwound to the drain), FATAL when it ran interpreted — the session kept
        // executing past the eret into adjacent code, the derail-containment aborted it
        // MID-DISPATCHER, and the torn state killed the kernel (measured: MI_INTR_MASK written
        // with pointer 0x800F3AE0, then the sourceless-scan shutdown — the basin coin-flip was
        // literally whether the handler resolved native or interp that run). Hardware semantics,
        // per the approved design: eret to thread T is a plain SwitchToFiber(T). The interrupted
        // fiber is SUSPENDED AND INTACT; hand it the dispatcher-restored file and resume it.
        // When it next yields, the root resumes here and unwinds to the canonical pump.
        if (g_autobm && tf->handle != nullptr && tf->handle != g_root_fiber && tf->started) {
            static int _sr = 0;
            g_eret_census[3].fetch_add(1, std::memory_order_relaxed);   // [eret-census] resumed interrupted
            if (_sr++ < 12) { fprintf(stderr, "[bmsched]   root eret -> resume interrupted task tcb=0x%08X (SwitchToFiber)\n", tcb); fflush(stderr); }
            // HARDWARE RESTORE (2026-08-06): the one physical file at eret = what the guest's
            // dispatcher just restored (ctx). Every other dispatch path copies it into the
            // thread's own file; this path skipped it — so guest-side state injected into the
            // interrupted thread's saved image during the handler (osRecvMesg's delivered
            // message in $v0, priority changes, any TCB edit) was silently DROPPED on resume:
            // the fiber woke with its pre-interrupt file. Measured consequence on turok: a
            // kernel queue-walk primitive (0x800A5E68) spinning 100k+ iterations on links a
            // stale-registered thread corrupted — 2.4M drain-gate refusals, boot dead.
            if (tf->own != nullptr) { bm_ctx_copy(tf->own, ctx); tf->ctx = tf->own; }
            tl_eret_drain = false;                       // a committed dispatch ends the drain episode
            bm_clear_budget_note(tf);   // [torn-state 08-27] this dispatch supersedes any parked continuation
            int* out_slot = &g_root_interp_depth;
            *out_slot = recomp_interp_swap_depth(tf->interp_depth);
            g_root_native_depth = recomp_interp_swap_native(tf->native_depth);
            g_root_live_pc      = recomp_interp_swap_live_pc(tf->live_pc);
            SwitchToFiber(tf->handle);
            // The task yielded/returned to the root again: route to the canonical pump like
            // every other root resume (BmRootUnwind unwinds to it if it already exists).
            bm_root_canonical_pump();
            return;
        }
        // ── SELF-REDISPATCH ON THE ROOT (2026-08-05, GoldenEye's dead stop) ──────────────────────
        // The throw above is exempted for the root because nothing catches it there — fiber_proc's
        // handler lives on TASK fibers only. That left a plain `return`, which continues the
        // abandoned dispatcher frames instead of jumping to EPC. Measured consequence on GoldenEye:
        // the boot task (registered as the root just above) erets, lands here, returns, and the
        // guest never resumes — ZERO fibers ever created, ZERO drains, 2000+ VI notes piled up.
        //
        // Hardware JUMPS to EPC. fiber_proc is exactly that jump (resolve pc, run, chase r31), so
        // promote this continuation to a real fiber and enter it there. The root's stack is
        // abandoned — which is what the arming design already prescribes for a mid-flight arm
        // ("the tangled root stack is abandoned exactly like the real boot stack").
        //
        // Only when the fiber we are on IS the root-backed one; a genuine root with no task
        // identity still returns, as before.
        if (g_autobm && epc != 0 && tf->handle == g_root_fiber) {
            TaskFiber* nf = new TaskFiber();
            nf->epc = epc; nf->rdram = rdram;
            // Per-fiber file for the promoted boot continuation, seeded from the boot state.
            nf->own = bm_ctx_alloc(); bm_ctx_copy(nf->own, ctx); nf->ctx = nf->own;
            nf->handle = CreateFiber(0, &fiber_proc, nf);
            if (nf->handle != nullptr) {
                if (dbg) { fprintf(stderr, "[bmsched]   ROOT self-redispatch -> NEW fiber tcb=0x%08X epc=0x%08X\n", tcb, epc); fflush(stderr); }
                tf = nf;                 // rebind g_fibers[tcb] (tf is a reference into the map)
                g_running = nf;
                bm_clear_budget_note(nf);   // [torn-state 08-27] this dispatch supersedes any parked continuation
                SwitchToFiber(nf->handle);
                // The fiber world handed BACK to the root (a task chain returned). The root's
                // pending frames are the abandoned boot chain — a plain `return` here parked the
                // root pump-less while interrupts piled up (fifa 2026-08-05: every thread waiting
                // on handler service, 2000+ notes, ZERO drains). Same law as the RESUMED tail:
                // once the fiber world is live, the root's only role is the canonical pump.
                bm_root_canonical_pump();
                return;                  // pump exited (disarmed) — legacy fall-through
            }
            delete nf;
            if (dbg) { fprintf(stderr, "[bmsched]   ROOT self-redispatch CreateFiber FAILED\n"); fflush(stderr); }
        }
        return;
    }
    TaskFiber* prev_tf = g_running;   // the OUTGOING fiber (nullptr = root), before reassignment
    g_running = tf;
    // Census this TCB as a live/runnable thread (orphan-recovery uses it to rebuild a torn run queue) and
    // record it as the currently-running fiber (the running fiber is NOT on the run queue, so the scrub
    // must not re-insert it). NC-only; baseline games never reach recomp_eret.
    if (g_nc_mode && (tcb >> 28) == 0x8u && tcb != NC_IDLE_TCB) g_seen_tcbs[tcb] = 1;
    uint32_t prev_tcb = g_current_tcb;
    g_current_tcb = tcb;
    g_eret_census[1].fetch_add(1, std::memory_order_relaxed);   // [eret-census] switched fibers
    if (dbg) { fprintf(stderr, "[bmsched]   SWITCH to tcb=0x%08X\n", tcb); fflush(stderr); }
    if (dbg) bm_ctx_fp("PRE-SWITCH", tcb, ctx);
    // A committed dispatch ends any in-flight drain episode: tl_eret_drain is a HOST-THREAD
    // local shared by every fiber on it, so leaving it set across the switch (handler eret'd
    // away mid-drain, drained fiber never redispatched) gates every pump venue forever — the
    // observed freeze at drain #8 with 14000 interrupts noted. Hardware allows new interrupts
    // the moment the handler erets; mirror that.
    tl_eret_drain = false;
    // Per-fiber interp-depth swap: save the outgoing fiber's nesting, restore the incoming's
    // (thread-local counter shared by all fibers — see recomp_interp_swap_depth). The outgoing
    // slot is chosen by the fiber ACTUALLY executing this eret: a root-pump drain runs the
    // handler (and this eret) on the ROOT fiber even while g_running still names the last
    // dispatched task, and saving the root's nesting into that task's slot both corrupted the
    // task's count and left the root's slot stale.
    {
        int* out_slot = (GetCurrentFiber() == g_root_fiber || prev_tf == nullptr)
                            ? &g_root_interp_depth : &prev_tf->interp_depth;
        // Poison tracker: a slot that RESTORES high says this fiber is parked deep (legitimate if
        // it unwinds later; a leak if it only ever climbs — pairs with [interp] high-water).
        static int _pz = 0;
        if ((tf->interp_depth >= 64 || tf->interp_depth < 0) && (_pz++ % 100) == 0)
            fprintf(stderr, "[bmsched] restore deep interp slot: tcb=0x%08X depth=%d\n", tcb, tf->interp_depth);
        *out_slot = recomp_interp_swap_depth(tf->interp_depth);
        // companions swap with the depth, into the SAME outgoing owner (round 6)
        if (out_slot == &g_root_interp_depth) {
            g_root_native_depth = recomp_interp_swap_native(tf->native_depth);
            g_root_live_pc      = recomp_interp_swap_live_pc(tf->live_pc);
        } else {
            prev_tf->native_depth = recomp_interp_swap_native(tf->native_depth);
            prev_tf->live_pc      = recomp_interp_swap_live_pc(tf->live_pc);
        }
    }
    bm_clear_budget_note(tf);   // [torn-state 08-27] this dispatch supersedes any parked continuation
    SwitchToFiber(tf->handle);
    // Resumed: some later guest eret re-dispatched THIS task. Hardware semantics are a JUMP to the
    // EPC that eret set — never a return through the abandoned dispatcher frames below us (their
    // tails would run with the register file restored for the app-level resume point; SOTE wall-3).
    // Throw to fiber_proc, which re-enters at tf->epc. The root fiber has no fiber_proc catch (it
    // carries the boot thread's original call chain), so it keeps the legacy fall-through.
    if (g_dbg < 500) { g_dbg++; bm_ctx_fp("RESUMED   ", prev_tcb, ctx); }
    if (g_autobm && GetCurrentFiber() != g_root_fiber) {
        throw BmFiberRedispatch{};
    }
    if (g_autobm) {
        // ROOT fiber resumed (a task returned or dispatched to it): its abandoned frames are the
        // boot thread's ORIGINAL call chain — unwinding them replays stale code with foreign
        // registers and then parks somewhere pump-less (the observed freeze after the last
        // 'fiber RETURNED': drains stop while interrupts pile up). The root's only correct role
        // once the fiber world is live is the idle: pump pending interrupts forever — each
        // drain's handler-eret dispatches the woken task from inside, exactly like dead_end.
        // CANONICAL PUMP (wall 4 round 2): the pump frame is established ONCE; every later root
        // resume unwinds back to it (see BmRootUnwind) instead of stacking a new pump on top of
        // the previous drain's frozen handler frames — that stacking grew the root's stack and
        // its interp nesting without bound until the depth cap starved every interp call.
        bm_root_canonical_pump();
        return;
    }
#endif
}
