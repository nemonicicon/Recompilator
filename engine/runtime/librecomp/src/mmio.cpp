// The MMIO register trace is an instrument: silent unless RECOMP_MMIO_TRACE is set.
// Ungated it wrote 4,000 lines in a 20-second run of Turok 1 (2026-09-08).
// mmio.cpp — N64 memory-mapped hardware register emulation.
//
// Most N64 games touch the hardware only through libultra, which we replace with HLE natives.
// But several titles — especially PSX/arcade ports done by small teams (Space Invaders 64,
// Robotron 64, ...) — drive the N64 hardware registers DIRECTLY (raw PI DMA, raw VI video setup,
// raw SP task kicks, raw AI audio), barely using libultra. Our recompiler maps those KSEG1
// addresses (0xA4xxxxxx) straight into RDRAM, so without emulation the device semantics are lost
// (status polls spin forever, video never presents).
//
// STORE_W / LOAD_W (see recomp.h) route every access whose address lands in the device-register
// window (0xA4000000-0xA4FFFFFF) here. This file is the central device dispatcher: it decodes the
// register, emulates the side effects, and (importantly) LOGS every access so we can see exactly
// which registers a given game drives and in what order.
//
// Physical bases (after CV64_PHYS = vaddr & 0x1FFFFFFF):
//   0x04000000 SP DMEM/IMEM     0x04040000 SP registers   0x04080000 SP_PC
//   0x04100000 DPC (RDP cmd)    0x04300000 MI             0x04400000 VI
//   0x04500000 AI               0x04600000 PI             0x04800000 SI
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <deque>
#include <mutex>
#include <thread>
#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>   // CaptureStackBackTrace for the RECOMP_VI_TRACE diagnostic
#endif
#include "recomp.h"
#include <ultramodern/ultramodern.hpp>   // ultramodern::queue_audio_buffer (raw-AI audio submission)

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

// RAW-INTERRUPT-DELIVERY (bare-metal/PSX-port class): pending MI_INTR (RCP interrupt status) bits that
// recomp_mmio_load_w returns for MI_INTR (0x04300008). Set transiently by recomp_deliver_rcp_interrupt
// while the game's own exception handler runs, so the handler sees the right RCP source. 0 otherwise.
static std::atomic<uint32_t> g_pending_mi_intr{0};
// Lets the bare-metal game-thread idle (baremetal_sched.cpp) present an MI_INTR source before running NC's
// handler natively (the VI host thread no longer runs it in fiber mode).
extern "C" void recomp_set_pending_mi_intr(uint32_t v) { g_pending_mi_intr.store(v, std::memory_order_relaxed); }
// Level-triggered MI model (banjo wall 7): present ORs new sources in, device ACK writes clear
// them (the hardware protocol). The old present-then-wipe pattern destroyed any source the
// handler didn't service in that one invocation — fatal for one-shot completions (banjo's
// single SP-done arrived bundled with SI+VI, got wiped, audio waited forever).
extern "C" void recomp_present_mi_intr(uint32_t v) { g_pending_mi_intr.fetch_or(v, std::memory_order_relaxed); }
extern "C" void recomp_ack_mi_intr(uint32_t bits)  { g_pending_mi_intr.fetch_and(~bits, std::memory_order_relaxed); }
// bmsched's accumulated note bits (the VI host thread's 60Hz notes land THERE, not here) —
// exposed so the MI_INTR read is level-honest for poll-driven kernels, cleared by device acks.
extern "C" uint32_t recomp_baremetal_noted_mi(void);
extern "C" void recomp_baremetal_ack_noted_mi(uint32_t bits);
extern "C" void recomp_interp_ring_dump(const char* reason);   // [pc-ring] path dump (recomp_interp.cpp)

// MI_INTR_MASK, faithfully computed from the game's own set/clear bit-pair command writes (see
// recomp_mmio_store_w). Doubles as the RAW-title detector: matched-libultra games set their mask
// through the native HLE osSetIntMask and never write this register, so the mask stays 0 and the
// auto raw-interrupt delivery below stays inert for them; a game whose (unmatched) libultra runs
// as recompiled code writes it here and thereby self-identifies as needing hardware-style
// interrupt vectoring.
static std::atomic<uint32_t> g_mi_intr_mask{0};
extern "C" uint32_t recomp_mi_intr_mask() { return g_mi_intr_mask.load(std::memory_order_relaxed); }
extern "C" uint32_t recomp_mi_intr_pending() { return g_pending_mi_intr.load(std::memory_order_relaxed); }

// SP_STATUS register model (banjo wall 7). Read bits: 0=HALT 1=BROKE 2=DMA_BUSY 3=DMA_FULL
// 4=IO_FULL 5=SSTEP 6=INTR_ON_BREAK 7..14=SIG0..SIG7. The old hardcoded read (always 0x1)
// erased the SIGNAL protocol libultra's task machinery runs on: osSpTaskYield sets SIG0, the
// task ucode reports YIELDED via SIG1 / TASKDONE via SIG2, and osSpTaskYielded reads them back
// (banjo: func_80265D50 gates the NEXT GFX TASK on those bits — with a fake register the frame
// state machine never starts it). Init: HALT (idle RSP).
static std::atomic<uint32_t> g_sp_status{0x00000001u};
// [ai-len-bound] byte length of the most recent raw AI_LEN kick (0 until the first); the AI_LEN read
// bounds its report to this (hardware: the register holds the current DMA's remainder, never more).
static std::atomic<uint32_t> g_ai_last_kick_len{0u};
// [ai-fifo 2026-09-06, Robotron 64 / the raw-AI tempo regression] The AI holds a TWO-entry DMA FIFO. A read of
// AI_LEN returns the bytes left in the CURRENT transfer; the pending entry is invisible to it; AI_STATUS
// bit 31 (FULL) is set while both entries are outstanding. The 09-04 bound approximated this from the
// last kick alone (clamp to its length; subtract it only when the backlog held two whole kicks), which
// in the common state - one whole pending buffer plus a partly drained current one - reported the
// PENDING buffer's full length instead of the current remainder. A driver that derives its time base
// from how this register moves between reads then runs its sequencer fast (Robotron's music 2x by
// by ear, bisected to that commit). Model the FIFO from the kicks the game actually made: the
// cumulative bytes kicked minus the bytes still queued = the bytes consumed; the kick containing that
// point is the current transfer, its end minus the consumed point is the remainder, and everything
// after it is pending. Same backlog figure as before (get_remaining_audio_bytes) so HLE titles and the
// look-ahead/drain model are untouched.
static std::mutex g_ai_fifo_mutex;
static uint64_t g_ai_kicked_total = 0;               // cumulative bytes kicked through AI_LEN writes
static uint64_t g_ai_kick_ends[8];                   // cumulative end offsets of recent kicks, oldest first
static unsigned g_ai_kick_count = 0;
static void ai_fifo_note_kick(uint32_t len) {
    std::lock_guard<std::mutex> lk(g_ai_fifo_mutex);
    g_ai_kicked_total += len;
    if (g_ai_kick_count == 8u) { for (unsigned i = 1; i < 8u; i++) g_ai_kick_ends[i - 1] = g_ai_kick_ends[i]; g_ai_kick_count = 7u; }
    g_ai_kick_ends[g_ai_kick_count++] = g_ai_kicked_total;
}
// Resolve the FIFO against the live backlog: the current transfer's remainder and how many entries
// are outstanding (0, 1, or 2+ = FULL).
static void ai_fifo_state(uint32_t backlog_bytes, uint32_t* remainder, unsigned* outstanding) {
    std::lock_guard<std::mutex> lk(g_ai_fifo_mutex);
    const uint64_t queued = (backlog_bytes > g_ai_kicked_total) ? g_ai_kicked_total : backlog_bytes;
    const uint64_t consumed = g_ai_kicked_total - queued;
    unsigned first = 0;
    while (first < g_ai_kick_count && g_ai_kick_ends[first] <= consumed) first++;
    if (first == g_ai_kick_count) { *remainder = 0u; *outstanding = 0u; return; }
    *remainder = (uint32_t)(g_ai_kick_ends[first] - consumed);
    *outstanding = g_ai_kick_count - first;
}

// SP_SEMAPHORE (audit batch 1, final model after two falsified revisions): reads return 0,
// writes are the (stateless) release. On silicon this cell is test-and-set — a read returns the
// current value AND sets it held; the holder (usually the RSP UCODE side) writes to release. Our
// RSP is INSTANT: the agent that would hold the semaphore completes in zero time, so a CPU
// observer can never catch it held — read 0 is the faithful sync-observer value (the same model
// as SP_DMA_FULL/BUSY and PI/SI idle).
// Do NOT model literal test-and-set here (batch-1 banjo regression, 2026-07-16, found by
// engine bisect — 7de42fc/0570dd2/c052854 boot the 455KB title scene, batch builds froze at a
// 56KB early frame): with no ucode-side release, the CPU's own wait/acquire read sequences
// self-deadlock — a wait-until-free poll CONSUMES the free state, the real acquire then reads
// "held", the task kick never happens, and a release hooked to task completion (rev-2 attempt,
// eda69c2) can never fire because no task ever completes. Traffic sits past the 4000-line [mmio]
// log cap, so the diag shows nothing. Read-0 is also byte-identical to the pre-batch mirror-zero
// behavior proven across the 151-RENDERS corpus.

// Task completion (events.cpp sp_complete, the same moment SP-done is raised): our RSP runs
// tasks to completion (a yield request always loses the race against an infinitely fast RSP,
// which is semantically consistent) -> halted again + TASKDONE(SIG2).
// [taskbal] SUBMITTED vs COMPLETED. Under rung 6 the completion path changed shape: the game's own
// osSpTaskStartGo writes SP_STATUS CLR_HALT, mmio submits, and the done-signal has to return through
// here + the SP interrupt instead of through the HLE shim. If the guest waits on a completion it
// never observes, gfx AND audio both go quiet while tasks keep submitting — which is exactly the
// cv64 rung-6 symptom (correct tasks, correct display lists, nothing rendered, no sound).
// A balance that grows without bound is the proof; equal counts exonerate the completion path.
std::atomic<uint32_t> g_task_submitted{0};
std::atomic<uint32_t> g_task_completed{0};
extern "C" void recomp_task_submitted_note() {
    uint32_t s = g_task_submitted.fetch_add(1, std::memory_order_relaxed) + 1;
    uint32_t c = g_task_completed.load(std::memory_order_relaxed);
    if ((s % 25u) == 0u) { if (rc_trace_on("RECOMP_TASKBAL")) fprintf(stderr, "[taskbal] submitted=%u completed=%u outstanding=%d\n",
                                   s, c, (int)(s - c)); fflush(stderr); }
}
extern "C" void recomp_sp_status_task_done() {
    g_sp_status.fetch_or(0x1u | 0x200u, std::memory_order_relaxed);
    uint32_t c = g_task_completed.fetch_add(1, std::memory_order_relaxed) + 1;
    uint32_t s = g_task_submitted.load(std::memory_order_relaxed);
    if ((c % 25u) == 0u) { if (rc_trace_on("RECOMP_TASKBAL")) fprintf(stderr, "[taskbal] submitted=%u completed=%u outstanding=%d\n",
                                   s, c, (int)(s - c)); fflush(stderr); }
}
// [rspwatch] read-only peeks for the 1 Hz truth line in events.cpp: the modeled SP_STATUS the guest
// is polling, and the exact submitted/completed task balance ([taskbal] only prints every 25th,
// which is silence for a game that wedges inside its first two dozen tasks — War Gods 2026-09-04).
extern "C" uint32_t recomp_sp_status_peek() { return g_sp_status.load(std::memory_order_relaxed); }
extern "C" void recomp_task_counts(uint32_t* submitted, uint32_t* completed) {
    if (submitted) *submitted = g_task_submitted.load(std::memory_order_relaxed);
    if (completed) *completed = g_task_completed.load(std::memory_order_relaxed);
}

// DPC_STATUS: NO readable status model — reads are hardcoded 0, writes mirror inertly (below).
// A pairs-only status cell (batch-1 attempt, decode CLR/SET xbus/freeze/flush into a readable
// register per mupen rdp_core.c update_dpc_status) is FALSIFIED for this engine (banjo row bisect
// 2026-07-16, second co-culprit after the SP_PC mask): the game latches its own mode bits during
// gfx init (past the [mmio] log cap) and its fb-rotation gate treats ANY nonzero DPC_STATUS as
// "RDP mid-frame" — with the model it froze after one frame (STATIC [57,57,57,57]); with
// hardcoded-0 reads it runs (bisect-B, 150KB moving scene). On silicon the device-side lifecycle
// (busy/valid/counter dynamics) contextualizes those bits; presenting the latched bits WITHOUT
// that lifecycle is less truthful to an instant-RDP observer than "always idle, nothing latched".
// Do not re-add a readable DPC model before the full DPC design (f916c7d) covers the device side.

// MI_MODE computed-mode state (audit batch 2): the write side is a command port (init-length +
// three clr/set pairs + the DP-int ack); reads return this computed mode word, per the reference
// (mupen mi_controller.c update_mi_init_mode). Poweron = 0 (mupen memsets; MI_VERSION is the only
// seeded MI register).
static std::atomic<uint32_t> g_mi_mode{0u};

// RI (RDRAM interface) warm-boot register file (audit batch 1). We never run the IPL, so present
// the post-IPL register values a booted game observes on hardware (mupen64plus zeroes these at
// poweron and lets the IPL program them; without an IPL, zero is the UN-booted state). The known
// hazard: a recompiled __osInitialize that probes RI_SELECT==0 concludes cold boot and enters the
// RDRAM init sequence — register timing loops we don't model = boot hang (BLACK). Writes store.
// 0x00 MODE, 0x04 CONFIG, 0x08 CURRENT_LOAD, 0x0C SELECT, 0x10 REFRESH, 0x14 LATENCY, 0x18/0x1C R/WERROR.
static std::atomic<uint32_t> g_ri_regs[8] = {0xEu, 0x40u, 0u, 0x14u, 0x63634u, 0u, 0u, 0u};

// PI device lives in pi.cpp (it owns the ROM + do_rom_read for cartridge DMA).
extern "C" void recomp_pi_register_write(uint8_t* rdram, uint32_t off, uint32_t value);
extern "C" uint32_t recomp_pi_register_read(uint8_t* rdram, uint32_t off);
// Mask-reenable delivery venue (baremetal_sched.cpp): called on MI_INTR_MASK writes that
// expose a pending level line — the hardware moment a masked interrupt gets taken.
extern "C" void recomp_baremetal_mask_poll(void);

// SI / PIF (controller serial bus). Raw-MMIO controller drivers (Killer Instinct Gold and other
// small-team ports that bypass libultra's osContStartReadData) drive the SI DMA registers directly.
// recomp_si_dma() lives in si.cpp: it executes the joybus command block, injects live controller
// state, and fires the SI-done interrupt message so the game's osRecvMesg(SI queue) unblocks.
extern "C" void recomp_si_dma(uint8_t* rdram, uint32_t is_read);

// SI_STATUS DMA-busy model for RAW-POLL controller drivers. recomp_si_dma completes the joybus DMA
// synchronously and signals it ONLY by firing the SI interrupt (the osRecvMesg path). A driver that
// instead BUSY-POLLS SI_STATUS (0x04800018) for the DMA-busy bit to assert-then-clear — bypassing
// libultra's osContStartReadData/osRecvMesg — never observed a transition, because SI_STATUS was
// hardwired to 0 (idle) forever, and spun its thread to death (DK64's controller read 0x8060D14C
// wedges before it ever builds a gfx task; KI Gold's raw controller driver is the same class). This
// latch makes the register faithful to a synchronous-DMA observer: a kick (SI_PIF_RD64/WR64) marks
// the SI momentarily busy, and the first SI_STATUS read after a kick returns DMA_BUSY(0x1) then clears
// it — so a "wait until busy clears" / "wait for the busy edge" poll terminates on the next read. The
// interrupt/osRecvMesg path is untouched (it never reads SI_STATUS), so libultra titles are unaffected.
static std::atomic<uint32_t> g_si_status_busy{0};
// [si-busy 2026-09-04, War Gods] The SI DMA now has a real completion window (si.cpp fires SI-done
// ~2 ms after the kick, the SDK's own figure for osContStartReadData). Busy is set at the kick and
// cleared HERE by si.cpp at the moment the completion fires, so SI_STATUS reads busy for exactly the
// window and idle the instant the message exists - the Space Invaders one-shot check after its recv
// still sees idle, and raw busy-edge pollers (KI Gold) finally see a true assert-then-clear.
extern "C" void recomp_si_busy_clear() { g_si_status_busy.store(0u, std::memory_order_relaxed); }

// VI present (video scanout) lives in ultramodern/events.cpp. The HLE VI retrace thread scans out
// whatever framebuffer osViSwapBuffer last pointed it at, every retrace, through the renderer
// (osViSwapBuffer -> next_state.framebuffer -> update_vi() bakes VI_ORIGIN_REG -> decodeVI() ->
// updateScreen()). libultra games drive that via osViSwapBuffer; raw-MMIO ports never do — they
// write the scanout address straight into the VI_ORIGIN hardware register instead, so without this
// hook the retrace thread keeps scanning out the dummy framebuffer and the game never presents.
// Recompiler-build signature: PTR(void) == int32_t, RDRAM_ARG == "uint8_t* rdram,". osViSwapBuffer
// takes events_context.message_mutex internally, so calling it from the game thread is race-safe
// against the VI thread. (General raw-MMIO-port fix: Robotron 64, Space Invaders 64, the PSX/arcade
// small-team class.)
extern "C" void osViSwapBuffer(uint8_t* rdram, int32_t frameBufPtr);

// Raw-MMIO VI configuration (ultramodern/events.cpp). Raw ports set the VI status/width/region/scale
// via direct register writes the HLE VI state never sees; this feeds the game's actual VI registers
// into the HLE VI so the present is built visible + at the right resolution. Without it the VI stays
// BLANK (status=0) and RT64 skips the present. General raw-MMIO-port fix; HLE titles never reach here.
extern "C" void recomp_set_raw_vi(uint32_t control, uint32_t width, uint32_t hStart, uint32_t vStart,
                                  uint32_t xScale, uint32_t yScale);

// SP task submit (RSP gfx/audio kick) lives in ultramodern/events.cpp. The HLE osSpTaskStartGo
// native (sp.cpp) receives the OSTask* in a register and calls this to push the task onto the
// sp_task_queue, where the task thread runs it (gfx -> RT64, audio -> AI). Raw-MMIO ports never call
// osSpTaskStartGo — they drive the SP DMA + SP_STATUS registers directly — so we reconstruct the
// OSTask pointer from the raw SP access trace below and feed it through the SAME proven backend.
// Recompiler-build signature: PTR(OSTask) == int32_t, RDRAM_ARG == "uint8_t* rdram,".
namespace ultramodern { void submit_rsp_task(uint8_t* rdram, int32_t task); }
extern "C" int recomp_bm_wave_active();   // [wave-sp] swap wave live (baremetal_sched)

namespace {

// ---- access logging (the research tool): decode + log every device-register touch ----------
const char* reg_name(uint32_t phys) {
    switch (phys & 0x04FFFFFF) {
        // SP
        case 0x04040000: return "SP_MEM_ADDR";  case 0x04040004: return "SP_DRAM_ADDR";
        case 0x04040008: return "SP_RD_LEN";    case 0x0404000C: return "SP_WR_LEN";
        case 0x04040010: return "SP_STATUS";    case 0x04040014: return "SP_DMA_FULL";
        case 0x04040018: return "SP_DMA_BUSY";  case 0x0404001C: return "SP_SEMAPHORE";
        case 0x04080000: return "SP_PC";
        // DPC
        case 0x04100000: return "DPC_START";    case 0x04100004: return "DPC_END";
        case 0x04100008: return "DPC_CURRENT";  case 0x0410000C: return "DPC_STATUS";
        case 0x04100010: return "DPC_CLOCK";
        // MI
        case 0x04300000: return "MI_MODE";      case 0x04300004: return "MI_VERSION";
        case 0x04300008: return "MI_INTR";      case 0x0430000C: return "MI_INTR_MASK";
        // VI
        case 0x04400000: return "VI_CONTROL";   case 0x04400004: return "VI_ORIGIN";
        case 0x04400008: return "VI_WIDTH";     case 0x0440000C: return "VI_INTR";
        case 0x04400010: return "VI_CURRENT";   case 0x04400014: return "VI_BURST";
        case 0x04400018: return "VI_V_SYNC";    case 0x0440001C: return "VI_H_SYNC";
        case 0x04400020: return "VI_LEAP";      case 0x04400024: return "VI_H_START";
        case 0x04400028: return "VI_V_START";   case 0x0440002C: return "VI_V_BURST";
        case 0x04400030: return "VI_X_SCALE";   case 0x04400034: return "VI_Y_SCALE";
        // AI
        case 0x04500000: return "AI_DRAM_ADDR"; case 0x04500004: return "AI_LEN";
        case 0x04500008: return "AI_CONTROL";   case 0x0450000C: return "AI_STATUS";
        case 0x04500010: return "AI_DACRATE";   case 0x04500014: return "AI_BITRATE";
        // PI
        case 0x04600000: return "PI_DRAM_ADDR"; case 0x04600004: return "PI_CART_ADDR";
        case 0x04600008: return "PI_RD_LEN";    case 0x0460000C: return "PI_WR_LEN";
        case 0x04600010: return "PI_STATUS";
        // RI
        case 0x04700000: return "RI_MODE";      case 0x04700004: return "RI_CONFIG";
        case 0x04700008: return "RI_CURR_LOAD"; case 0x0470000C: return "RI_SELECT";
        case 0x04700010: return "RI_REFRESH";   case 0x04700014: return "RI_LATENCY";
        case 0x04700018: return "RI_RERROR";    case 0x0470001C: return "RI_WERROR";
        // SI
        case 0x04800000: return "SI_DRAM_ADDR"; case 0x04800004: return "SI_PIF_RD64";
        case 0x04800010: return "SI_PIF_WR64";  case 0x04800018: return "SI_STATUS";
        default: return nullptr;
    }
}

void log_mmio(char rw, uint32_t phys, uint32_t value) {
    static long _n = 0;
    // SI traffic is exempt from the cap: it is inherently low-rate (joybus polls), and the cap
    // blinded exactly the question that matters for PIF-wait stalls — "did the guest ever kick
    // SI again after boot?" (SOTE boot-sequence stall, 2026-07-19).
    // The SI exemption is an INSTRUMENT, not behaviour (discipline rule 16). It was added for
    // the SOTE boot-stall dig (2026-07-19) to answer "did the guest ever kick SI again after
    // boot?", and left unconditional -- so every joybus controller poll wrote an fprintf +
    // fflush to an _IONBF log, forever, in every game. Measured on SOTE 2026-07-29: ~30k
    // synchronous flushes in 137 s (15236 PIF reads + 14720 SI writes), which is why it ran
    // "wayyy too slow". Default is now the same 4000-line cap as every other source; set
    // RECOMP_MMIO_SI_TRACE=1 to restore the uncapped SI view when digging at SI again.
    static const bool si_uncapped = [] {
        const char* e = std::getenv("RECOMP_MMIO_SI_TRACE");
        return e != nullptr && *e != '\0' && *e != '0';
    }();
    bool si = si_uncapped && (phys & 0x04F00000u) == 0x04800000u;
    // [wave-sp 2026-08-26] the post-wave program's FIRST RSP task submission (SP/DPC writes) is
    // the current frontier and always lands past this cap — exempt SP + DPC traffic while the
    // swap wave is active (task submits are a handful of writes; no volume risk).
    bool wave_sp = recomp_bm_wave_active() &&
                   (((phys & 0x04F00000u) == 0x04000000u) || ((phys & 0x04F00000u) == 0x04100000u));
    if (!si && !wave_sp && _n >= 4000) return;          // cap (these are rare relative to RDRAM access)
    _n++;
    const char* nm = reg_name(phys);
    char blk[12];
    if (!nm) { snprintf(blk, sizeof blk, "?0x%08X", phys); nm = blk; }
    if (rw == 'W') { if (rc_trace_on("RECOMP_MMIO_TRACE")) fprintf(stderr, "[mmio] W %-14s = 0x%08X\n", nm, value); }
    else           { if (rc_trace_on("RECOMP_MMIO_TRACE")) fprintf(stderr, "[mmio] R %-14s -> 0x%08X\n", nm, value); }
    fflush(stderr);
}

// A VI_CURRENT line counter so the game's vsync polls (read VI_CURRENT until it hits a line)
// make progress instead of spinning on a static value.
std::atomic<uint32_t> g_vi_current{0};

inline uint32_t& mirror(uint8_t* rdram, uint32_t phys) {
    return *reinterpret_cast<uint32_t*>(rdram + phys);
}

} // namespace

// VI retrace counter (defined in ultramodern events.cpp; also extern'd in vi.cpp). Drives the VI_CURRENT
// field bit so interlaced games reading VI_CURRENT&1 for field parity aren't frozen on field 0.
extern uint64_t total_vis;

// COP0 register backing (tlb.cpp) — reg 13 is Cause; the GIO device ACK deasserts its RDB interrupt
// line by clearing the corresponding Cause IP bit, exactly as the real device would on hardware.
extern "C" uint32_t recomp_cop0_tlb_read(int reg);
extern "C" void recomp_cop0_tlb_write(int reg, uint32_t value);
// Bare-metal cooperative-scheduler bracket (baremetal_sched.cpp): suppress fiber switching on the VI host
// thread during interrupt delivery, so the guest handler only posts its event (the game thread reschedules).
extern "C" void recomp_baremetal_enter_interrupt();
extern "C" void recomp_baremetal_exit_interrupt();
extern "C" int  recomp_baremetal_enabled();
extern "C" void recomp_baremetal_note_interrupt(uint32_t mi_bits);
extern "C" int  recomp_baremetal_eret_seen();
extern "C" int  recomp_baremetal_autoarm(uint8_t* rdram);
extern "C" int  recomp_baremetal_armed();
extern "C" int  recomp_baremetal_armed();
extern "C" int  recomp_baremetal_nc_mode();

// ------------------------------------------------------------------------------------------------
// Cartridge GIO / RDB device window (0xC0000000-0xC000FFFF, KSEG2). A few bare-metal ports drive a
// custom command-processor device mapped here (Nightmare Creatures): the game streams command words to
// 0xC0000000, and the device signals completion with an RDB read/write CPU interrupt (CAUSE_IP6 0x2000 /
// CAUSE_IP7 0x4000), whose handler ACKs the device by writing 0 to 0xC000000C / 0xC0000008. We can't
// emulate the device's render semantics yet, but we MUST honor the ACK -> deassert handshake so the
// game's exception handler (invoked via recomp_deliver_rcp_interrupt) doesn't spin forever polling the
// Cause bit it just ACKed. Every access write-throughs via the real TLB so games that merely TLB-map
// this window as plain memory are untouched. Gated on the GIO device being enabled (NC_IRQ present).
static int g_gio_enabled = -1;   // -1 = unchecked
static void recomp_gio_device_store(uint8_t* rdram, uint32_t vaddr, uint32_t value) {
    if (g_gio_enabled < 0) g_gio_enabled = getenv("NC_IRQ") ? 1 : 0;
    // Write-through via the real TLB (preserves TLB-mapped users; unmapped falls back flat, matching the
    // pre-routing behavior of a plain MEM_W to this address).
    *reinterpret_cast<int32_t*>(rdram + recomp_tlb_translate(vaddr)) = (int32_t)value;
    if (!g_gio_enabled) return;
    switch (vaddr) {
        case 0xC000000Cu: recomp_cop0_tlb_write(13, recomp_cop0_tlb_read(13) & ~0x2000u); break; // ACK RDB-read  (IP6) -> deassert
        case 0xC0000008u: recomp_cop0_tlb_write(13, recomp_cop0_tlb_read(13) & ~0x4000u); break; // ACK RDB-write (IP7) -> deassert
        default: break; // 0xC0000000 command kick / 0xC0009840 device regs: write-through only (gfx routing TBD)
    }
    static long _g = 0; if (_g < 64) { _g++; fprintf(stderr, "[gio] W 0x%08X = 0x%08X\n", vaddr, value); fflush(stderr); }
}

// ------------------------------------------------------------------------------------------------
// AI completion pacer (bare-metal class): one MI 0x04 note per queued AI buffer, fired when that
// buffer FINISHES at the DAC clock — the hardware protocol. Two properties the old at-submit note
// lacked, both load-bearing (SOTE): (1) the cadence is the DAC's (~69/s at 22 kHz × 320-sample
// buffers), so an interrupt-refilled driver actually keeps up; (2) the FINAL buffer after the last
// kick still completes, so an audio-synced sequencer sees its stream end instead of parking
// forever. Buffers queue back-to-back (a kick while one is playing starts after it), matching the
// AI's 2-deep DMA FIFO timeline. The pacer thread sleeps until the next completion; process-
// lifetime, started on the first kick (same style as the runtime's other device threads).
static void ai_pacer_kick(uint32_t len_bytes) {
    static std::mutex m;
    static std::condition_variable cv;
    static std::deque<std::chrono::steady_clock::time_point> due;
    static bool thread_started = false;
    auto now = std::chrono::steady_clock::now();
    uint32_t rate = ultramodern::get_audio_sample_rate();
    if (rate == 0) rate = 22050;
    // 4 bytes per stereo 16-bit frame at the DAC rate.
    auto dur = std::chrono::nanoseconds((uint64_t)len_bytes * 1000000000ull / ((uint64_t)rate * 4ull));
    {
        std::lock_guard<std::mutex> g(m);
        auto start = (!due.empty() && due.back() > now) ? due.back() : now;
        due.push_back(start + dur);
        if (!thread_started) {
            thread_started = true;
            std::thread([] {
                std::unique_lock<std::mutex> l(m);
                for (;;) {
                    if (due.empty()) { cv.wait(l); continue; }
                    auto next = due.front();
                    if (cv.wait_until(l, next) == std::cv_status::timeout && !due.empty() && due.front() == next) {
                        due.pop_front();
                        l.unlock();
                        recomp_baremetal_note_interrupt(0x04);
                        l.lock();
                    }
                }
            }).detach();
        }
    }
    cv.notify_all();
}

// Store dispatch: emulate the device write side effects.
extern "C" void recomp_mmio_store_w(uint8_t* rdram, uint32_t vaddr, uint32_t value) {
    // Cartridge GIO / RDB device window (KSEG2) — handled separately (TLB write-through + ACK handshake).
    if ((vaddr & 0xFFFF0000u) == 0xC0000000u) { recomp_gio_device_store(rdram, vaddr, value); return; }

    uint32_t phys = vaddr & 0x1FFFFFFF;
    log_mmio('W', phys, value);

    // PI (cartridge DMA + bus timing) — real emulation in pi.cpp.
    if (phys >= 0x04600000u && phys < 0x04600040u) {
        recomp_pi_register_write(rdram, phys - 0x04600000u, value);
        return;
    }

    // MI_INTR_MASK (0x0430000C): the hardware register is a COMMAND port — each write carries
    // set/clear BIT PAIRS per source (bit 2s = clear source s, bit 2s+1 = set source s; sources
    // SP=0 SI=1 AI=2 VI=3 PI=4 DP=5), NOT a plain value. Compute the real mask (the old raw-mirror
    // readback returned the command word — garbage as a mask — the exact register the
    // __osDispatchThread spin class polled). The computed mask also drives the auto raw-interrupt
    // delivery gate (see recomp_deliver_rcp_interrupt).
    if ((phys & 0x04FFFFFFu) == 0x0430000Cu) {
        // [mi-poison] (2026-08-06, general guest-sanity report): a KSEG0-POINTER-shaped value
        // written to the MI mask command port is never a real command — it is the signature of
        // a guest queue primitive operating on a garbage queue pointer that aliases the MI
        // mirror (measured on fifa: "MI mask written with pointer 0x800F3AE0"; on turok the
        // same disease imports mirror garbage into thread links — the k0-poison web). Name the
        // native caller chain so the mis-registered object is identifiable. Capped, always on:
        // this is corruption-by-definition, not noise.
        if ((value & 0xF0000000u) == 0x80000000u) {
            static int _mp = 0;
            if (_mp++ < 8) {
                recomp_interp_ring_dump("mi-poison");
#ifdef _WIN32
                void* frames[6] = {};
                USHORT n = CaptureStackBackTrace(1, 6, frames, nullptr);
                HMODULE mod = GetModuleHandleA(nullptr);
                fprintf(stderr, "[mi-poison] #%d POINTER 0x%08X written to MI_INTR_MASK; caller RVAs:", _mp, value);
                for (USHORT fi = 0; fi < n; fi++)
                    fprintf(stderr, " 0x%08llX", (unsigned long long)((uintptr_t)frames[fi] - (uintptr_t)mod));
                fprintf(stderr, " (resolve vs the exe .map)\n");
#else
                fprintf(stderr, "[mi-poison] #%d POINTER 0x%08X written to MI_INTR_MASK\n", _mp, value);
#endif
                fflush(stderr);
            }
        }
        uint32_t m = g_mi_intr_mask.load(std::memory_order_relaxed);
        for (int s = 0; s < 6; s++) {
            if (value & (1u << (2 * s)))     m &= ~(1u << s);
            if (value & (1u << (2 * s + 1))) m |=  (1u << s);
        }
        g_mi_intr_mask.store(m, std::memory_order_relaxed);
        mirror(rdram, phys) = m;   // mirror the COMPUTED mask, coherent with the read path
        static int _mm = 0; if (_mm++ < 12) { fprintf(stderr, "[mi] INTR_MASK cmd=0x%03X -> mask=0x%02X\n", value, m); fflush(stderr); }
        // HARDWARE: re-enabling a source whose MI line is pending delivers the interrupt at THIS
        // instant — the level model's other half. A native disable/check/restore idle (fifa's
        // kernel) is invisible to every other pump venue; its restore write lands exactly here.
        // Unconditional: the venue gates itself on the union of bmsched's noted bits and the
        // register-level bits vs the new mask (mmio's g_pending_mi_intr alone is TRANSIENT —
        // set only while a handler runs — so gating here on it missed every steady-state note).
        recomp_baremetal_mask_poll();
        return;
    }

    // VI_CURRENT write = VI interrupt ACK (hardware: any write to VI_CURRENT clears the VI line).
    // Without this, a raw-dispatch handler that re-checks MI_INTR after acking (banjokazooie-class
    // __osException: process VI -> ack -> poll for more sources) sees VI still pending and spins
    // inside one invocation forever (measured 2026-07-15: 14 erets vs 1200 drains, boot never
    // proceeds past the first VI). Clears only the presented bit; the next real retrace re-raises.
    if ((phys & 0x04FFFFFFu) == 0x04400010u) {
        g_pending_mi_intr.fetch_and(~0x8u, std::memory_order_relaxed);
        recomp_baremetal_ack_noted_mi(0x8u);   // poll-lane: the noted VI bit clears on ack too
        mirror(rdram, phys) = value;
        return;
    }

    // The remaining device ACKs, same hardware protocol as the VI ack above (banjo wall 7 — the
    // level-triggered MI model needs every source clearable by its device write, or a presented
    // bit persists forever / gets nowhere):
    //   MI_MODE   bit11 (0x800) = CLR_DP_INTERRUPT -> DP  (0x20)
    //   SI_STATUS any write     = clear SI line    -> SI  (0x02)
    //   AI_STATUS any write     = clear AI line    -> AI  (0x04)
    //   SP_STATUS bit3/bit4     = CLR/SET_INTR     -> SP  (0x01)   [in the SP kick switch below]
    //   PI_STATUS bit1          = clear PI intr    -> PI  (0x10)   [pi.cpp register write path]
    if ((phys & 0x04FFFFFFu) == 0x04300000u) {              // MI_MODE (audit batch 2)
        // COMMAND port, same shape as MI_INTR_MASK: the readback must be the COMPUTED mode, not
        // the raw command word (the old mirror echoed the command — the exact MI_INTR_MASK bug
        // class). Decode per the reference (mupen mi_controller.c update_mi_init_mode):
        // bits 0-6 = init_length (stored), 0x80/0x100 = clr/set init_mode (mode bit7),
        // 0x200/0x400 = clr/set ebus test_mode (mode bit8), 0x800 = clear DP interrupt (our
        // level-triggered MI ack), 0x1000/0x2000 = clr/set RDRAM reg_mode (mode bit9).
        uint32_t m = g_mi_mode.load(std::memory_order_relaxed);
        m = (m & ~0x7Fu) | (value & 0x7Fu);
        if (value & 0x0080u) m &= ~0x80u;
        if (value & 0x0100u) m |=  0x80u;
        if (value & 0x0200u) m &= ~0x100u;
        if (value & 0x0400u) m |=  0x100u;
        if (value & 0x0800u) { recomp_ack_mi_intr(0x20u); recomp_baremetal_ack_noted_mi(0x20u); }
        if (value & 0x1000u) m &= ~0x200u;
        if (value & 0x2000u) m |=  0x200u;
        g_mi_mode.store(m, std::memory_order_relaxed);
        mirror(rdram, phys) = m;   // keep the raw cell coherent with the computed mode (sub-word readers)
        return;
    }
    if ((phys & 0x04FFFFFFu) == 0x04800018u) {              // SI_STATUS
        recomp_ack_mi_intr(0x02u);
        recomp_baremetal_ack_noted_mi(0x02u);   // level-honest MI read: noted bit clears on ack too
        mirror(rdram, phys) = value;
        return;
    }
    if ((phys & 0x04FFFFFFu) == 0x0450000Cu) {              // AI_STATUS
        recomp_ack_mi_intr(0x04u);
        recomp_baremetal_ack_noted_mi(0x04u);
        mirror(rdram, phys) = value;
        return;
    }

    // RI registers (0x04700000-0x0470001C): store into the warm-boot register file.
    if ((phys & 0x04FFFFFFu) >= 0x04700000u && (phys & 0x04FFFFFFu) < 0x04700020u) {
        g_ri_regs[((phys & 0x1Fu) >> 2)].store(value, std::memory_order_relaxed);
        return;
    }

    // All other device writes: mirror into RDRAM so subsequent reads of config registers return
    // what was written. Device-specific side effects (VI present, SP task kick, AI/SI DMA) will be
    // layered on here as the per-game access trace shows exactly what each title drives.
    mirror(rdram, phys) = value;

    // SP raw task kick (raw-MMIO RSP ports: Space Invaders 64, the PSX/arcade small-team class).
    // libultra's osSpTaskStartGo is HLE'd (sp.cpp) and never touches these registers, so this whole
    // block is unreachable for libultra titles — it only fires for games that drive the SP hardware
    // directly. Those games do exactly what the SP hardware requires: DMA the OSTask (0x40 bytes)
    // into DMEM at OS_TASK_OFFSET (0x04000FC0), DMA the boot ucode into IMEM, set SP_PC, then write
    // SP_STATUS with bit0 (CLR_HALT) to release the RSP. The OSTask* the HLE path would receive in a
    // register isn't visible to us, but the OSTask's RDRAM source address IS — it's the SP_DRAM_ADDR
    // of the DMA whose destination is the DMEM task offset. We capture that, then on the CLR_HALT
    // "go" we submit it through the SAME backend the HLE uses (submit_rsp_task -> sp_task_queue ->
    // run_task -> RT64 gfx / AI audio). General "fix the N64": this is the SP task hardware semantics,
    // not a per-game patch — any raw-SP-task title presents through this path.
    {
        static uint32_t sp_mem_addr = 0;   // last SP_MEM_ADDR (DMA destination in SP DMEM/IMEM)
        static uint32_t sp_dram_addr = 0;   // last SP_DRAM_ADDR (DMA source in RDRAM)
        static uint32_t sp_task_dram = 0;   // RDRAM address of the OSTask (DMA'd to DMEM 0xFC0)
        switch (phys) {
            case 0x04040000: sp_mem_addr = value; break;                     // SP_MEM_ADDR
            case 0x04040004: sp_dram_addr = value & 0x1FFFFFFFu; break;      // SP_DRAM_ADDR
            case 0x04040008:                                                  // SP_RD_LEN -> DMA executes
                if ((sp_mem_addr & 0xFFFu) == 0xFC0u) sp_task_dram = sp_dram_addr; // dest == OS_TASK_OFFSET
                break;
            case 0x04040010: {                                                // SP_STATUS (command port)
                if (value & 0x08u) { recomp_ack_mi_intr(0x01u); recomp_baremetal_ack_noted_mi(0x01u); }   // CLR_INTR: SP interrupt ack
                if (value & 0x10u) recomp_present_mi_intr(0x01u);             // SET_INTR (rare, but hardware)
                // Decode the CLR/SET bit pairs into the modeled read state (see g_sp_status above).
                // [sp-status atomic 2026-09-02, War Gods] The old load / modify / store raced the pacer thread's
                // recomp_sp_status_task_done() (fetch_or HALT|TASKDONE): a task completing between the guest's load
                // and its store had its HALT erased by the stale store, and libultra's `while (__osSpSetPc() == -1)`
                // (which waits for SP_STATUS & HALT) then spun forever with no further task to re-halt it — War Gods
                // parked after ~1 s with 3,901 HALT-clear status reads (research_wargods.md). Hardware semantics: each
                // write to the command port applies its CLR/SET pairs to the live register; nothing it does not name
                // changes. So apply the decoded masks with atomic RMW ops and never write back a stale snapshot.
                uint32_t clr = 0u, set = 0u;
                if (value & (1u << 1)) set |= 0x1u;                           // SET_HALT
                if (value & (1u << 2)) clr |= 0x2u;                           // CLR_BROKE
                if (value & (1u << 5)) clr |= 0x20u;                          // CLR_SSTEP
                if (value & (1u << 6)) set |= 0x20u;                          // SET_SSTEP
                if (value & (1u << 7)) clr |= 0x40u;                          // CLR_INTR_ON_BREAK
                if (value & (1u << 8)) set |= 0x40u;                          // SET_INTR_ON_BREAK
                for (int sig = 0; sig < 8; sig++) {                           // SIG0..7: write pairs 9..24 -> read 7..14
                    if (value & (1u << (9  + 2 * sig))) clr |= (1u << (7 + sig));
                    if (value & (1u << (10 + 2 * sig))) set |= (1u << (7 + sig));
                }
                const bool go = ((value & 0x1u) != 0u) && (sp_task_dram != 0u);   // CLR_HALT == "go"
                if (go) clr |= 0x1u;                                          // RSP running (task_done re-halts)
                if (clr) g_sp_status.fetch_and(~clr, std::memory_order_relaxed);
                if (set) g_sp_status.fetch_or(set, std::memory_order_relaxed);
                if (go) {                                                     // HALT already cleared ABOVE: a task that
                    ultramodern::submit_rsp_task(rdram, (int32_t)(0x80000000u | sp_task_dram));   // completes at once
                    sp_task_dram = 0u;                                        // re-halts via fetch_or and stays halted
                }
                break;
            }
            default: break;
        }
    }

    // Raw AI audio DMA (raw-MMIO audio ports: Space Invaders 64, the PSX/arcade small-team class).
    // See ai_pacer_kick below the store handler for the MI 0x04 completion model.
    // libultra's osAiSetNextBuffer is HLE'd (ai.cpp) and never touches these registers, so this block is
    // unreachable for libultra titles. Raw-MMIO games instead write AI_DRAM_ADDR (the RSP-produced sample
    // buffer) then AI_LEN (the DMA kick) directly. Submit that buffer through the SAME sink the HLE path
    // uses (queue_audio_buffer -> the app's queue_samples), so raw-AI titles actually play sound. Without
    // this the samples are produced but never reach the DAC = silence. General "fix the N64", not per-game.
    {
        static uint32_t ai_dram = 0;
        if (phys == 0x04500000u) {                                       // AI_DRAM_ADDR: latch the source
            ai_dram = value & 0x00FFFFFFu;                               // physical RDRAM address (strip KSEG)
        } else if (phys == 0x04500004u) {                               // AI_LEN write == DMA kick
            uint32_t len = value & 0x0003FFF8u;                          // 8-byte-aligned byte count
            if (len != 0u && len <= 0x8000u && (ai_dram + len) <= 0x800000u) {
                g_ai_last_kick_len.store(len, std::memory_order_relaxed);   // [ai-len-bound] see the AI_LEN read
                ai_fifo_note_kick(len);                                         // [ai-fifo]
                ultramodern::queue_audio_buffer(rdram, (int32_t)(0x80000000u | ai_dram), len);
                // AI COMPLETION PACER (SOTE boot-sequence stall, supersedes the round-7 at-submit
                // note): hardware raises MI 0x04 when each queued DMA buffer FINISHES at the DAC
                // rate — including the final buffer(s) after the last kick. Noting at submit gave
                // ~8 completions/s instead of ~69/s (the driver only refills per note), and left
                // the LAST completion unfired forever: SOTE's audio-synced intro sequencer waits
                // on exactly that end-of-stream completion, so the whole game parked at jingle
                // end (~9.3s: gfx/audio/input all stop, the world idles). The pacer schedules one
                // MI 0x04 per buffer at its true DAC-clock finish time.
                if (recomp_baremetal_enabled() && !recomp_baremetal_nc_mode()) {
                    ai_pacer_kick(len);
                }
            }
        } else if (phys == 0x04500010u) {                               // AI_DACRATE -> set the OUTPUT device
            // to the game's TRUE sample rate. libultra/raw drivers set freq = AI_clock / (DACRATE+1); the
            // register holds rate-1. Without this the device stays at ultramodern::init_audio's 48 kHz
            // default while a raw-AI game (Space Invaders DACRATE=0x089F = ~22 kHz) plays at the wrong
            // pitch and under-runs. HLE titles set this via osAiSetFrequency (ai.cpp) and never reach here.
            uint32_t dacrate = value & 0x3FFFu;
            if (dacrate != 0u) {
                ultramodern::set_audio_frequency(48681812u / (dacrate + 1u));
            }
        }
    }

    // SI DMA kick: SI_PIF_RD64 (0x04800004, PIF→RDRAM, controller read-back) or
    // SI_PIF_WR64 (0x04800010, RDRAM→PIF, command-block upload). Both complete by raising the
    // SI interrupt; the game's osRecvMesg on the registered SI queue waits for that. Without this,
    // raw-MMIO controller drivers (KI Gold) block their main thread forever before rendering.
    if (phys == 0x04800004u) { g_si_status_busy.store(1u, std::memory_order_relaxed); recomp_si_dma(rdram, 1u); return; } // read-back: fill response + fire
    if (phys == 0x04800010u) { g_si_status_busy.store(1u, std::memory_order_relaxed); recomp_si_dma(rdram, 0u); return; } // write: upload block + fire

    // VI_ORIGIN (0x04400004): the raw scanout framebuffer address. This is the one input the HLE VI
    // present pipeline lacks for raw-MMIO ports — libultra games feed it via osViSwapBuffer, raw
    // ports write it straight to this register. Hand it to osViSwapBuffer so the existing VI retrace
    // thread scans the game's framebuffer out through the renderer, exactly like the libultra path
    // (no new present path — we reuse the proven one). osVirtualToPhysical inside update_vi() masks
    // KSEG0/KSEG1 and passes a bare physical RDRAM address (the common VI_ORIGIN form) through flat,
    // so a raw 0x00xxxxxx or 0x80xxxxxx/0xA0xxxxxx origin all resolve correctly. The mirror() above
    // already recorded the value for read-back; this adds the device side effect (present).
    //
    // cv64 / libultra safety: this fires ONLY on a raw store to the VI_ORIGIN device register
    // (0xA4400004 -> phys 0x04400004). libultra titles (Castlevania 64 included) NEVER write the VI
    // registers directly — they go through osViSwapBuffer/osViSetMode, which already drive
    // next_state.framebuffer — so this branch is unreachable for them and the HLE-VI path is byte-for-
    // byte untouched.
    // Raw-MMIO ports program the VI in the order CONTROL=0 (blank) -> ORIGIN -> CONTROL=enable. The ORIGIN
    // write below latches whatever VI_CONTROL is mirrored AT THAT MOMENT (=0, blank) into the HLE VI, and the
    // later CONTROL=enable write had no side effect -> STATUS stayed BLANK -> RT64 skipped the present -> black.
    // g_raw_vi_active records that a raw scanout is live so a subsequent VI_CONTROL write re-feeds the VI.
    static bool g_raw_vi_active = false;

    if (phys == 0x04400004u) {
#ifdef _WIN32
        // RECOMP_VI_TRACE=1: dump the host callstack of every raw VI_ORIGIN write, with a known
        // symbol as the ASLR anchor so the frames resolve offline against the linker map
        // (slide = live anchor - map anchor). Recompiled frames are func_<guest vaddr>, so this
        // names the exact guest call chain that computed the framebuffer value (the SOTE
        // fb=0x27F hunt). Env-gated diagnostic; zero cost when unset.
        {
            static int vi_trace = -1;
            if (vi_trace < 0) vi_trace = std::getenv("RECOMP_VI_TRACE") ? 1 : 0;
            if (vi_trace) {
                void* frames[24] = {};
                unsigned short nf = CaptureStackBackTrace(0, 24, frames, nullptr);
                fprintf(stderr, "[vitrace] W VI_ORIGIN=0x%08X anchor recomp_mmio_store_w=%p frames:", value, (void*)&recomp_mmio_store_w);
                for (unsigned short fi = 0; fi < nf; fi++) fprintf(stderr, " %p", frames[fi]);
                fprintf(stderr, "\n");
                fflush(stderr);
            }
        }
#endif
        // Feed the game's actual VI registers (mirrored above on their own writes) into the HLE VI so
        // the present is built from a VISIBLE status + the real width/region/scale, then swap to the new
        // scanout framebuffer. Without the registers the HLE VI keeps the dummy mode (status BLANK, width
        // 320) and RT64's VI::visible() is false -> no present -> black.
        g_raw_vi_active = true;
        recomp_set_raw_vi(mirror(rdram, 0x04400000u),  // VI_CONTROL
                          mirror(rdram, 0x04400008u),  // VI_WIDTH
                          mirror(rdram, 0x04400024u),  // VI_H_START
                          mirror(rdram, 0x04400028u),  // VI_V_START
                          mirror(rdram, 0x04400030u),  // VI_X_SCALE
                          mirror(rdram, 0x04400034u)); // VI_Y_SCALE
        osViSwapBuffer(rdram, (int32_t)value);
        return;
    }

    // VI_CONTROL (0x04400000) re-latch: raw-MMIO ports set CONTROL=enable (e.g. Nightmare Creatures' 0x311E)
    // AFTER the ORIGIN write, which had latched CONTROL=0 (blank). Re-feed the VI here so the display-enable
    // takes effect. Gated on g_raw_vi_active (a raw scanout is live) so libultra titles — which never raw-write
    // the VI registers — are byte-for-byte untouched. General raw-MMIO VI fix (the bare-metal/raw-port class).
    if (phys == 0x04400000u && g_raw_vi_active) {
        recomp_set_raw_vi(value,                        // the new VI_CONTROL just written
                          mirror(rdram, 0x04400008u),   // VI_WIDTH
                          mirror(rdram, 0x04400024u),   // VI_H_START
                          mirror(rdram, 0x04400028u),   // VI_V_START
                          mirror(rdram, 0x04400030u),   // VI_X_SCALE
                          mirror(rdram, 0x04400034u));  // VI_Y_SCALE
        return;
    }

    // VI_WIDTH/etc.: already mirrored above so read-back returns what was written. The retrace
    // thread owns the actual scanout; no further side effect is needed here.
}

// ------------------------------------------------------------------------------------------------
// Load dispatch: return live device-register values for the status/current registers the games
// poll (a stale RDRAM read would spin the poll forever, like the PI_STATUS bug).
extern "C" uint32_t recomp_mmio_load_w(uint8_t* rdram, uint32_t vaddr) {
    uint32_t phys = vaddr & 0x1FFFFFFF;
    uint32_t v;
    switch (phys & 0x04FFFFFF) {
        case 0x04040010: v = g_sp_status.load(std::memory_order_relaxed); break; // SP_STATUS: modeled register (halt/broke/sstep/signals)
        case 0x04040014: v = 0x00000000; break; // SP_DMA_FULL: not full (DMA completes synchronously)
        case 0x04040018: v = 0x00000000; break; // SP_DMA_BUSY: not busy (DMA completes synchronously)
        case 0x0404001C: v = 0x00000000; break; // SP_SEMAPHORE: never observably held (instant RSP; see model note above)
        case 0x04080000: v = mirror(rdram, phys); break; // SP_PC: RAW ECHO of the last write, per the
            // reference — mupen64plus read_rsp_regs2 returns the stored word unmasked, and do_SP_Task
            // deliberately PRESERVES the upper bits across a task (save_pc = pc & ~0xfff). Games
            // round-trip full mem-map-form values through this register (banjokazooie recomputes its
            // next ucode entry from the echo: the batch-1 &0xFFC read mask froze it after one frame —
            // 56KB STATIC, isolated by row bisect 2026-07-16). Masking to the 12-bit pc happens at task
            // time on the reference, never on readback.
        case 0x0410000C: v = 0x00000000; break; // DPC_STATUS: always idle, nothing latched (see the falsified-model note above before changing)
        case 0x04300000: v = g_mi_mode.load(std::memory_order_relaxed); break; // MI_MODE: computed mode word (batch 2)
        case 0x04300004: v = 0x02020102u; break; // MI_VERSION: hardware constant (mupen64plus poweron_mi)
        case 0x04300008: // MI_INTR: pending RCP bits — LEVEL register: delivered transients OR
                         // bmsched's undrained notes (poll-driven kernels read this directly)
            v = g_pending_mi_intr.load(std::memory_order_relaxed) | recomp_baremetal_noted_mi();
            { // [mi-read] bounded census (rung-157 PI-stuck dig): what the guest handler SEES
                static int _mr = 0;
                if (_mr < 24 && (v & ~0x8u)) { _mr++;
                    fprintf(stderr, "[mi-read] #%d guest reads MI_INTR = 0x%02X (mmio mask readback = 0x%02X)\n",
                            _mr, v, g_mi_intr_mask.load(std::memory_order_relaxed)); fflush(stderr); }
            }
            break;
        case 0x0430000C: // MI_INTR_MASK: report the COMPUTED mask (tracked from the game's own
            // set/clear command writes — faithful readback for the __osDispatchThread spin class).
            // (banjo wall 7: the old "report 0x3F while anything is pending" hack is GONE — with the
            // level-triggered MI model, pending is nonzero almost always, which pinned the game's
            // mask readback at 0x3F and made the handler service sources the game had masked off in
            // critical sections. A masked pending source now simply persists until the game restores
            // its mask and the next drain services it — the silicon behavior.)
            v = g_mi_intr_mask.load(std::memory_order_relaxed); break;
        case 0x04400010: {                      // VI_CURRENT (VI_V_CURRENT_LINE): advancing scanline + field
            // Hardware returns the current half-line whose bit0 encodes the current FIELD in interlaced
            // mode -- value = (line & ~1) | field, with field toggling once per retrace ONLY when serrate
            // (VI_CTRL bit6) is set (confirmed against the in-tree mupen64plus vi_controller.c:105/169 and
            // rt64_vi.cpp:83, which gates `vCurrentLine & 1` behind status.serrate). The old read returned
            // only EVEN values, so bit0 was stuck at 0 and any 480i game reading VI_CURRENT&1 for the
            // field/double-buffer parity (the libultra OSSched pattern, e.g. Army Men's fp_8008DB00) froze
            // on field 0. Keep the advancing counter so vsync progress-polls still terminate; OR in the
            // real field (total_vis&1) ONLY when interlaced, so progressive games (all 9 displayers,
            // serrate=0) read byte-identically to before (bit0 stays 0 = no regression).
            uint32_t line    = g_vi_current.fetch_add(2, std::memory_order_relaxed) % 525; // even, advancing
            uint32_t serrate = mirror(rdram, 0x04400000u) & 0x40u;                         // VI_CTRL bit6=480i
            uint32_t field   = serrate ? (uint32_t)(total_vis & 1ull) : 0u;
            v = (line & ~1u) | field;
            break;
        }
        case 0x0450000C: // AI_STATUS: model the real 2-deep AI DMA FIFO. FIFO_FULL (bit31) asserts
            // while >= 2 buffers remain un-drained. Raw-MMIO-AI games (Army Men: Sarge's Heroes) spin
            // on this bit to pace synthesis to the DAC drain rate; hard-wiring it to 0 ("never full")
            // defeated that, so the game queued one buffer per 60Hz retrace (~33k frames/s) vs the ~22k
            // device rate -> music ~1.5x too fast. HLE titles use osAiSetNextBuffer and never read this
            // register, so they are byte-for-byte unaffected. See ultramodern::audio_fifo_full().
            // [ai-fifo] with raw kicks on record, FULL = two entries outstanding (the hardware rule);
            // before any raw kick (HLE-only titles never read this) keep the backlog rule.
            if (g_ai_last_kick_len.load(std::memory_order_relaxed) != 0u) {
                uint32_t rem_ = 0; unsigned out_ = 0;
                ai_fifo_state(ultramodern::get_remaining_audio_bytes(), &rem_, &out_);
                v = (out_ >= 2u) ? 0x80000000u : 0x00000000u; break;
            }
            v = ultramodern::audio_fifo_full() ? 0x80000000u : 0x00000000u; break;
        case 0x04500004: { // AI_LEN read: remaining buffered audio (NOT 0). Raw-AI games poll this to pace
            // production — reporting 0 ("always drained") made the game over-produce (460 samples/frame at
            // 60fps = ~27.6k/s) past the ~22k device rate, overfilling + dropping samples. The real buffered
            // amount (same signal osAiGetLength gives HLE titles) lets the game throttle to the device rate.
            // [ai-len-bound 2026-09-04, Forsaken 64] Hardware AI_LEN is the byte count left in the CURRENT
            // DMA: at most one kick's length, and while the 2-deep FIFO holds a pending entry that entry is
            // NOT counted. The host backlog can hold nearly three buffers, so the raw read handed the game
            // 0x8C8 right after a 0x740 kick with FIFO_FULL set (MEASURED forsaken run1). Forsaken sizes
            // each frame as target - (AI_LEN >> 2) + 0x50 (func_800070D0); past 0x700 that count goes
            // <= 0, its list builder returns no commands and the scheduler hits its own
            // 'No Task list!!!!!' abort (a NULL write = a crash on hardware, a silent limp here). Bound the
            // register to what the silicon can report. HLE osAiGetLength is untouched.
            uint32_t t = ultramodern::get_remaining_audio_bytes();
            const uint32_t last = g_ai_last_kick_len.load(std::memory_order_relaxed);
            if (last != 0u) {
                // [ai-fifo 2026-09-06] the CURRENT transfer's remainder from the two-entry FIFO model
                // (replaces the 09-04 last-kick clamp; see ai_fifo_state). Never more than one kick.
                uint32_t rem_ = 0; unsigned out_ = 0;
                ai_fifo_state(t, &rem_, &out_);
                t = rem_;
            }
            v = t; break;
        }
        case 0x04600010: v = recomp_pi_register_read(rdram, 0x10); break; // PI_STATUS: idle
        case 0x04800018: // SI_STATUS: always IDLE (DMA_BUSY=0). recomp_si_dma completes the joybus DMA
            // SYNCHRONOUSLY on the kick, so the SI is never observably busy from game code. The old
            // "busy once after a kick" latch broke libultra's __osSiRawStartDma, which does
            // `if (__osSiDeviceBusy()) return -1;` — a ONE-SHOT check, not a spin. Space Invaders'
            // osContInit kicks the WRITE DMA, recv's its SI-done, then calls __osSiRawStartDma(READ);
            // that busy-check read SI_STATUS=1 (stale latch) -> returned -1 -> the read-back RD64 never
            // kicked -> osContInit hung forever on its final osRecvMesg. Reporting idle (the truth for a
            // synchronous DMA) lets the READ DMA fire. (Baseline games use the osCont HLE and never read
            // SI_STATUS; KI Gold's raw busy-EDGE poll is the only thing that wanted the fake assert, and
            // it is parked — revisit with a per-driver model if it ever needs the edge.)
            // [si-busy 2026-09-04] No longer hardwired idle: busy (DMA_BUSY, bit 0) from the kick until
            // si.cpp's deferred completion clears it (recomp_si_busy_clear) as it fires SI-done. The
            // one-shot check above still reads idle after its recv, because the clear precedes the
            // message. Nothing self-clears on read any more - the window is the hardware's, not a latch.
            v = g_si_status_busy.load(std::memory_order_relaxed) ? 0x1u : 0u; break;
        default:
            if ((phys & 0x04FFFFFFu) >= 0x04700000u && (phys & 0x04FFFFFFu) < 0x04700020u) {
                v = g_ri_regs[((phys & 0x1Fu) >> 2)].load(std::memory_order_relaxed); // RI: warm-boot register file
            } else {
                v = mirror(rdram, phys); // config registers: return last written
            }
            break;
    }
    log_mmio('R', phys, v);
    return v;
}

// RAW-INTERRUPT-DELIVERY: invoke the game's OWN recompiled exception handler on an RCP interrupt, so its
// handler dispatches the interrupt the way the hardware would (set its RCP-event-pending flags + post its
// events) — the keystone for bare-metal/PSX ports whose libultra interrupt path we don't otherwise run
// (Nightmare Creatures: scheduler gated on a flag only __osException sets; 1080's loader flag). The
// handler (e.g. Nightmare's func_80080454=__osException) self-sets its k0 scratch and its ERET compiles
// to a clean return, so we just set Cause IP2 (RCP interrupt) + MI_INTR pending bits and call it with a
// zeroed ctx. mi_bits = MI_INTR source(s): SP=1 SI=2 AI=4 VI=8 PI=0x10 DP=0x20.
//
// AUTO MODE (2026-07-01, worklist #1 — the promotion this comment always promised): when NC_IRQ is
// UNSET, deliver through the hardware truth instead of an env: on real silicon every enabled MI
// interrupt vectors to the general exception vector at 0x80000180 — whatever handler stub the ROM's
// boot installed there (libultra's or handwritten). Deliver ONLY when the game asked for it the
// hardware way: hle_serving==0 (no HLE event queue registered for this source — matched titles are
// served by the HLE path and must never get double delivery) AND the game enabled the source in its
// OWN MI_INTR_MASK (raw command writes, tracked above — matched titles use native osSetIntMask and
// never touch the raw register, so this gate is naturally closed for them) AND real code is
// installed at the vector. The vector executes through get_function/JIT like any code.
// ENV MODE (NC_IRQ set = handler vram): legacy explicit configuration, unchanged.
extern "C" int recomp_interp_is_code(uint8_t* rdram, uint32_t vaddr);
extern "C" void recomp_deliver_rcp_interrupt(uint8_t* rdram, uint32_t mi_bits, int hle_serving) {
    // Fiber-scheduler (bare-metal) mode: do NOT run NC's handler here on the VI host thread — that would drive
    // the cooperative scheduler as throwaway-ctx interpretation on the wrong thread, so recomp_eret/fibers
    // (which live on the game thread) never engage. Just record the interrupt; the game thread drains it and
    // runs the handler+dispatcher natively, keeping the whole scheduler on one thread.
    if (recomp_baremetal_enabled()) { recomp_baremetal_note_interrupt(mi_bits); return; }
    static int checked = 0;
    static uint32_t handler = 0;
    static uint32_t cause_bits = 0x00000400u;   // Cause IP bits to present. Default IP2 (RCP). Nightmare's
                                                 // handler dispatches on IP6 (RDB-read 0x2000), not IP2 — set
                                                 // NC_IRQ_CAUSE=0x2000 for it. (The old code always set 0x400,
                                                 // which Nightmare's handler ignored -> it set no event/flag.)
    static uint32_t pump_ready_vaddr = 0u;       // NC_PUMP: GIO device-ready flag vaddr. When set, keep invoking
                                                 // the handler (draining one queued command per call) until the
                                                 // handler raises this flag (device queue empty) — so a whole
                                                 // frame of commands drains per retrace instead of one.
    if (!checked) { checked = 1;
        const char* e = getenv("NC_IRQ");       if (e) handler          = (uint32_t)strtoul(e, nullptr, 0);
        const char* c = getenv("NC_IRQ_CAUSE"); if (c) cause_bits       = (uint32_t)strtoul(c, nullptr, 0);
        const char* p = getenv("NC_PUMP");      if (p) pump_ready_vaddr = (uint32_t)strtoul(p, nullptr, 0);
        fprintf(stderr, "[ncirq] init: handler=0x%08X cause=0x%X pump=0x%08X\n", handler, cause_bits, pump_ready_vaddr); fflush(stderr); }
    if (handler == 0) {
        // AUTO MODE: no env. Deliver to the ROM's own vector iff the game (a) has no HLE service
        // for this source, (b) enabled the source in its own raw MI mask, (c) installed real code
        // at 0x80000180. The is_code probe re-checks until it first passes (boot installs the
        // vector after a few frames), then latches.
        if (hle_serving) return;
        if ((recomp_mi_intr_mask() & mi_bits) == 0u) return;
        static int vector_live = 0;
        if (!vector_live) {
            if (!recomp_interp_is_code(rdram, 0x80000180u)) return;
            vector_live = 1;
            fprintf(stderr, "[rawirq] AUTO: MI mask=0x%02X, vector code present at 0x80000180 — delivering raw RCP interrupts\n",
                    recomp_mi_intr_mask());
            fflush(stderr);
        }
        // AUTO-ARM latch site 2 (worklist #8): if this game executes guest erets (its own libultra
        // dispatcher is live as recompiled code), promote it to the fiber scheduler — the host-thread
        // throwaway-ctx invocation below fires the handler but can never context-switch, and mutating
        // the guest scheduler state from the host thread is the proven fire-but-no-render corruption.
        // Once armed, the enabled() short-circuit at the top of this function diverts all future
        // deliveries to note_interrupt + game-thread drain. Eret-less raw-MMIO ports (spaceinvaders/
        // robotron class) keep the host invocation below byte-identical.
        if (recomp_baremetal_eret_seen() && recomp_baremetal_autoarm(rdram)) {
            recomp_baremetal_note_interrupt(mi_bits);
            return;
        }
        recomp_func_t* vfn = get_function((int32_t)0x80000180u);
        if (vfn == nullptr) return;
        // [arm-race 2026-08-26] the game thread can ARM the fiber scheduler while this VI-thread
        // delivery is already past the enabled() gate — the is_code probe and get_function above
        // take real time (kseg0 code scan). A raw host-thread invoke after arming mutates guest
        // scheduler state from the wrong thread (the proven fire-but-no-render corruption) — the
        // merged-build boot lost exactly this race. Re-check at the last moment; the model owns
        // every delivery from arm onward.
        if (recomp_baremetal_armed()) {
            static int _r = 0; if (_r++ < 4) { fprintf(stderr, "[rawirq] armed mid-delivery — diverting mi=0x%X to note_interrupt\n", mi_bits); fflush(stderr); }
            recomp_baremetal_note_interrupt(mi_bits);
            return;
        }
        g_pending_mi_intr.store(mi_bits, std::memory_order_relaxed);
        // Present Cause (IP2 = RCP) AND Status (IE | IM2) so the handler's enabled-and-pending
        // test passes; invoke the vector with a fresh ctx exactly like env-mode below.
        recomp_cop0_tlb_write(13, 0x00000400u);
        recomp_cop0_tlb_write(12, recomp_cop0_tlb_read(12) | 0x00000401u);
        recomp_context vctx{};
        vctx.status_reg = 0x00000400u;
        static uint64_t _a = 0; if (_a++ < 6) { fprintf(stderr, "[rawirq] invoke vector 0x80000180 mi=0x%X\n", mi_bits); fflush(stderr); }
        recomp_baremetal_enter_interrupt();
        vfn(rdram, &vctx);
        recomp_baremetal_exit_interrupt();
        g_pending_mi_intr.store(0u, std::memory_order_relaxed);
        return;
    }
    recomp_func_t* fn = get_function((int32_t)handler);
    { static int _d=0; if (_d++ < 3) { fprintf(stderr, "[ncirq] get_function(0x%08X)=%p\n", handler, (void*)fn); fflush(stderr); } }
    if (fn == nullptr) return;
    g_pending_mi_intr.store(mi_bits, std::memory_order_relaxed);

    // Present the interrupt + invoke. Each invocation uses a fresh zeroed ctx (the handler self-sets its
    // k0 scratch; its ERET compiles to a clean return). Cause carries the IP bits; Status carries matching
    // IM bits so the handler's `Status & Cause` enabled-and-pending test passes. The device ACK store
    // (recomp_gio_device_store) clears the Cause bit, so the handler's in-loop "wait for line deassert"
    // poll exits, and (queue empty) it raises pump_ready_vaddr to stop the drain.
    // Per-retrace drain bound. The producer (game thread) runs concurrently and re-clears the ready flag
    // to kick the next command, so the pump can't perfectly observe "queue empty" — bound the drain so one
    // retrace never spins unboundedly; any remaining commands drain on the following retrace(s). A few
    // hundred per retrace (x60Hz) far exceeds a real frame's command count.
    const uint32_t cap = 2048u;
    uint32_t iters = 0;
    // Interrupt delivery runs on the VI HOST thread. For bare-metal cooperative schedulers (the NC class)
    // the handler may reach a guest `eret`; bracket the invocation so recomp_eret treats it as POST-ONLY and
    // does NOT switch fibers here (fibers are thread-affine; the game thread reschedules). Inert otherwise.
    recomp_baremetal_enter_interrupt();
    for (;;) {
        recomp_cop0_tlb_write(13, cause_bits);
        recomp_context ctx{};
        ctx.status_reg = cause_bits;
        static uint64_t _n = 0; if (_n++ < 6) { fprintf(stderr, "[ncirq] invoke handler 0x%08X cause=0x%X mi=0x%X\n", handler, cause_bits, mi_bits); fflush(stderr); }
        fn(rdram, &ctx);
        if (pump_ready_vaddr == 0u) break;                                  // no pump: single delivery
        uint32_t ready = *reinterpret_cast<uint32_t*>(rdram + recomp_tlb_translate(pump_ready_vaddr));
        if (ready != 0u) break;                                             // device queue drained
        if (++iters >= cap) break;                                          // per-retrace bound; rest drains next retrace
    }
    recomp_baremetal_exit_interrupt();
    g_pending_mi_intr.store(0u, std::memory_order_relaxed);
}
