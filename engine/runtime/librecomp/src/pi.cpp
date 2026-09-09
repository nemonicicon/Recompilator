#include <memory>
#include <atomic>
#include <chrono>
#include <cstdlib>
#include <cstdlib>
#include <fstream>
#include <array>
#include <cstring>
#include <string>
#include <mutex>
#include "recomp.h"
#include "librecomp/addresses.hpp"
#include "librecomp/game.hpp"
#include "librecomp/files.hpp"
#include <ultramodern/ultra64.h>
#include <ultramodern/ultramodern.hpp>

static std::vector<uint8_t> rom;

#ifdef _WIN32
#include <windows.h>   // CaptureStackBackTrace for the [dmacover] probe
#endif

// Forward decls used by the [dmacover] probe inside do_rom_read below. The full set of these is
// declared further down (near the pi-pace block); do_rom_read sits ABOVE that point, so it needs
// its own view of the two guest-attribution helpers.
extern "C" uint32_t recomp_current_guest_func();
extern "C" uint32_t recomp_current_guest_caller();


bool recomp::is_rom_loaded() {
    return !rom.empty();
}

void recomp::set_rom_contents(std::vector<uint8_t>&& new_rom) {
    rom = std::move(new_rom);
}

std::span<const uint8_t> recomp::get_rom() {
    return rom;
}

constexpr uint32_t k1_to_phys(uint32_t addr) {
    return addr & 0x1FFFFFFF;
}

constexpr uint32_t phys_to_k1(uint32_t addr) {
    return addr | 0xA0000000;
}

// MI interrupt ack (mmio.cpp) — level-triggered MI model.
extern "C" void recomp_ack_mi_intr(uint32_t bits);
extern "C" void recomp_baremetal_ack_noted_mi(uint32_t bits);   // level-honest MI: noted bit clears on ack
extern "C" void recomp_present_mi_intr(uint32_t bits);

extern "C" void __osPiGetAccess_recomp(uint8_t* rdram, recomp_context* ctx) {
}

extern "C" void __osPiRelAccess_recomp(uint8_t* rdram, recomp_context* ctx) {
}

extern "C" void osCartRomInit_recomp(uint8_t* rdram, recomp_context* ctx) {
    OSPiHandle* handle = TO_PTR(OSPiHandle, recomp::cart_handle);
    handle->type = 0; // cart
    handle->baseAddress = phys_to_k1(recomp::rom_base);
    handle->domain = 0;

    ctx->r2 = (gpr)recomp::cart_handle;
}

extern "C" void osDriveRomInit_recomp(uint8_t * rdram, recomp_context * ctx) {
    OSPiHandle* handle = TO_PTR(OSPiHandle, recomp::drive_handle);
    handle->type = 1; // bulk
    handle->baseAddress = phys_to_k1(recomp::drive_base);
    handle->domain = 0;

    ctx->r2 = (gpr)recomp::drive_handle;
}

extern "C" void osCreatePiManager_recomp(uint8_t* rdram, recomp_context* ctx) {
    ;
}

void recomp::do_rom_read(uint8_t* rdram, gpr ram_address, uint32_t physical_addr, size_t num_bytes) {
    // TODO use word copies when possible
    const size_t _dmacover_req = num_bytes;   // [dmacover] length as REQUESTED, before any clamp

    // TODO handle misaligned DMA
    assert((physical_addr & 0x1) == 0 && "Only PI DMA from aligned ROM addresses is currently supported");
    assert((ram_address & 0x7) == 0 && "Only PI DMA to aligned RDRAM addresses is currently supported");
    // [pidma_all] every-path DMA map (RECOMP_PIDMA_LOG_ALL=1; SOTE audio-fetch dig 2026-07-19):
    // covers BOTH the raw-PI register path and HLE osPiStartDma — which cart regions feed which
    // RDRAM regions over a whole run.
    {
        static int _log_all = -1;
        if (_log_all < 0) { const char* e = getenv("RECOMP_PIDMA_LOG_ALL"); _log_all = (e && *e && *e != '0') ? 1 : 0; }
        if (_log_all) {
            fprintf(stderr, "[pidma_all] cart=0x%08X -> dram=0x%08X len=0x%zX\n",
                    physical_addr, (uint32_t)ram_address & 0x1FFFFFFFu, num_bytes);
            fflush(stderr);
        }
    }
    // GENERAL FIX (PI-DMA bounds clamp): the HLE do_dma path reaches here with NO bounds check, so an
    // uncovered/mis-recompiled overlay loader handing us a bogus huge size or out-of-range source makes
    // the raw byte loop below read PAST the rom vector (WILD READ) or write PAST RDRAM (WILD WRITE) ->
    // host access-violation. Root cause of the overlay CRASH cluster (stuntracer/wdc/...). Clamp the
    // transfer to the bytes that fit in BOTH the ROM source and the 8MB RDRAM dest; drop the overflow.
    // Crash-safe (asserts are no-ops in Release, so they don't catch this; this does).
    const size_t rom_size = rom.size();
    if (physical_addr < recomp::rom_base || (size_t)(physical_addr - recomp::rom_base) >= rom_size) {
        fprintf(stderr, "[piDMA] WARN out-of-range ROM source 0x%08X (base 0x%08X, size 0x%zX) -> dropped\n",
                physical_addr, recomp::rom_base, rom_size);
        return;
    }
    const size_t rom_off = physical_addr - recomp::rom_base;
    if (num_bytes > rom_size - rom_off) num_bytes = rom_size - rom_off;            // never read past ROM
    const uint32_t ram_phys = (uint32_t)ram_address & 0x1FFFFFFFu;
    // Bound against the HOST RDRAM buffer (recomp::mem_size = 512MB), NOT the 8MB GUEST N64 RAM. The engine
    // mirrors the cart into RDRAM at the cart-bus address 0xB0000000 (recomp.cpp init; raw-PI games like
    // Robotron read the cart through it) -> phys 0x10000000 (256MB), a LEGIT host write. Bounding at 0x800000
    // wrongly DROPPED that mirror -> raw-PI games read zeros and never reached a gfx task. Do NOT re-tighten.
    constexpr uint32_t RDRAM_SIZE = (uint32_t)recomp::mem_size;                     // 512MB host buffer
    if (ram_phys >= RDRAM_SIZE) {
        const uint8_t* _src = rom.data() + rom_off;
        uint32_t _w0 = (num_bytes >= 4) ? ((uint32_t)_src[0]<<24 | (uint32_t)_src[1]<<16 | (uint32_t)_src[2]<<8 | _src[3]) : 0;
        uint32_t _w1 = (num_bytes >= 8) ? ((uint32_t)_src[4]<<24 | (uint32_t)_src[5]<<16 | (uint32_t)_src[6]<<8 | _src[7]) : 0;
        fprintf(stderr, "[piDMA] WARN out-of-range dest 0x%08X src=0x%08X size=0x%X words=0x%08X,0x%08X -> dropped\n",
                (uint32_t)ram_address, physical_addr, (uint32_t)num_bytes, _w0, _w1);
        return;
    }
    if (num_bytes > RDRAM_SIZE - ram_phys) num_bytes = RDRAM_SIZE - ram_phys;      // never write past RDRAM
    // ------------------------------------------------------------------------------------------
    // [dmacover] TARGETED DMA-COVERAGE PROBE (KI Gold freeze, 2026-08-29).
    // THE QUESTION: the trapping watchpoint caught do_rom_read+0x14A (this copy loop) writing over
    //   the OSMesgQueue at phys 0x2D3FC8 that the game thread sleeps on -- and over the live display
    //   list at 0x290BF0. Is that a transfer the game LEGITIMATELY asked for (=> it recycled memory
    //   that still holds a live queue: a lifetime/allocator bug), or is do_rom_read writing OUTSIDE
    //   its requested range (=> OUR bug, in the clamp arithmetic above)?
    // WHY A NEW PROBE: [piDMA] is CAPPED (first 24 + len>=0x4000), so a small transfer landing here
    //   is INVISIBLE -- "no logged DMA covers it" would be the [[lying_instruments]] capped-counter
    //   trap, not evidence. [pidma_all] is uncapped but floods and throttles the run being measured.
    //   This one is uncapped yet narrow: it only speaks about addresses you name.
    // USE: RECOMP_DMA_COVER=0x2D3FC8[,0x290BF0,...]   (up to 4, physical, comma-separated)
    //      RECOMP_DMA_COVER_NEAR=0x2000               (default; also report near misses)
    // HOW TO READ THE RESULT:
    //   COVER line          -> the range really is requested. Bug is a LIFETIME OVERLAP, not ours.
    //   only near lines     -> requested ranges stop short; the write came from elsewhere or overran.
    //   neither, but the "alive" heartbeat prints -> a REAL negative (the probe was running and saw
    //                          N transfers), which is the thing a capped counter can never tell you.
    {
        static int      _cov_init = 0;
        static uint32_t _cov[4]   = {};
        static int      _ncov     = 0;
        static uint32_t _near     = 0x2000;
        static long     _seen     = 0;
        if (!_cov_init) {
            _cov_init = 1;
            if (const char* e = getenv("RECOMP_DMA_COVER")) {
                while (*e && _ncov < 4) {
                    char* end = nullptr;
                    unsigned long v = strtoul(e, &end, 0);
                    if (end == e) break;
                    _cov[_ncov++] = (uint32_t)(v & 0x1FFFFFFFu);
                    e = end;
                    while (*e == ',' || *e == ' ') e++;
                }
            }
            if (const char* n = getenv("RECOMP_DMA_COVER_NEAR")) _near = (uint32_t)strtoul(n, nullptr, 0);
        }
        if (_ncov) {
            _seen++;
            const uint32_t _lo = ram_phys;
            const uint32_t _hi = ram_phys + (uint32_t)num_bytes;
            for (int k = 0; k < _ncov; k++) {
                const uint32_t t = _cov[k];
                const bool covers = (t >= _lo && t < _hi);
                const bool nearby = !covers && ((t + _near) >= _lo && t < (_hi + _near));
                if (!covers && !nearby) continue;
                fprintf(stderr,
                        "[dmacover] %s target=0x%06X dram=0x%08X..0x%08X req_len=0x%zX clamped_len=0x%zX cart=0x%08X func=0x%08X caller=0x%08X xfer#%ld\n",
                        covers ? "COVER" : "near ", t, _lo, _hi, _dmacover_req, num_bytes,
                        physical_addr, recomp_current_guest_func(), recomp_current_guest_caller(), _seen);
#ifdef _WIN32
                if (covers) {
                    void* frames[16] = {};
                    unsigned short nf = CaptureStackBackTrace(0, 16, frames, nullptr);
                    fprintf(stderr, "[dmacover]   anchor do_rom_read=%p frames:", (void*)&recomp::do_rom_read);
                    for (unsigned short fi = 0; fi < nf; fi++) fprintf(stderr, " %p", frames[fi]);
                    fprintf(stderr, "\n");
                }
#endif
                fflush(stderr);
            }
            if ((_seen % 4096) == 0) {
                fprintf(stderr, "[dmacover] alive: %ld transfers inspected\n", _seen);
                fflush(stderr);
            }
        }
    }
    uint8_t* rom_addr = rom.data() + rom_off;
    for (size_t i = 0; i < num_bytes; i++) {
        MEM_B(i, ram_address) = *rom_addr;
        rom_addr++;
    }
}

// ---------------------------------------------------------------------------------------------
// Raw PI (Peripheral Interface) register emulation.
//
// Games that hand-roll cartridge DMA by hitting the PI hardware registers directly (instead of
// going through osPiStartDma) land here via STORE_W (see recomp.h). The PI registers live at
// physical 0x04600000 (virtual 0xA4600000):
//     0x00 PI_DRAM_ADDR   0x04 PI_CART_ADDR   0x08 PI_RD_LEN   0x0C PI_WR_LEN
//     0x10 PI_STATUS      0x14..0x30 BSD DOM1/DOM2 bus-timing
// We map the registers onto their natural RDRAM offsets so the recompiled code's plain MEM_W
// *reads* see consistent values, and emulate the device behaviour on *writes*:
//   - writing PI_RD_LEN performs a synchronous cartridge->RDRAM DMA (so the data is present the
//     instant the game's status poll falls through — no race),
//   - PI_STATUS is a command register: writing it (RESET|CLR_INTR) must NOT leave the busy bits
//     set, so reads always return idle. This is what unblocks the boot poll loop.
// Faithful because the real PI is exactly a DMA engine the CPU pokes through these registers.
// Invoked by the central MMIO dispatcher (mmio.cpp) for writes to the PI register block.
// PI (cartridge DMA) done interrupt — fired after a synchronous cart->RDRAM DMA so a game waiting on
// osSetEventMesg(OS_EVENT_PI, ...) unblocks. Implemented in ultramodern/events.cpp (drops harmlessly
// if the game never registered OS_EVENT_PI). General hardware fix for raw-MMIO PI ports.
namespace ultramodern { void send_pi_message(); }

// Bare-metal (NC class) hook: a cooperative-scheduler port does NOT use HLE osRecvMesg — its boot thread
// blocks on its OWN guest scheduler queue. The HLE do_dma enqueues the completion into the HLE message
// system, which the bare-metal guest never observes, so the boot thread that osPiStartDma'd an overlay
// (then osRecvMesg-waits the PI done) hangs forever and never reaches osCreateScheduler. Notes the PI MI
// bit so NC's native exception handler runs and posts its own PI event to the guest queue. No-op (returns
// 0) for baseline HLE games, which observe the HLE message directly — so they are byte-for-byte unaffected.
extern "C" int  recomp_baremetal_enabled();
extern "C" void recomp_baremetal_note_interrupt(uint32_t mi_bits);
extern "C" void recomp_baremetal_note_pi_mq(uint32_t mq);
extern "C" void load_overlays(uint32_t rom, int32_t ram_addr, uint32_t size);   // overlays.cpp: bind the code sections inside a ROM range at the RAM they were DMA'd to   // bare-metal: record the guest queue osPiStartDma waits on
extern "C" int  recomp_baremetal_nc_mode();                 // NC legacy explicit class vs auto-armed stock-libultra
extern "C" int  recomp_baremetal_eret_seen();               // the fiber world has bootstrapped (g_ctx captured)
extern "C" int  recomp_bm_wave_active();                    // [pi-pace v2] swap wave live: bytes land at completion
extern "C" uint32_t recomp_current_guest_func();            // recomp.cpp: current guest func on this thread (EMIT_WATCH builds; 0 otherwise)
extern "C" uint32_t recomp_current_guest_caller();          // recomp.cpp: 1-deep caller of the above — the frame that keeps calling a spinning leaf

// ── [pi-pace] REAL PI DMA DURATION (SOTE 2026-08-26, env RECOMP_PI_PACE=1) ─────────────────────
// Hardware cart DMAs take real time (~5-10 MB/s): a 71KB load is MILLISECONDS, so a guest that
// starts a DMA and then arms its completion wait ALWAYS wins the race. Our synchronous copy
// completed in nanoseconds and the completion beat the arm — the lost-PI-wake at SOTE's phase
// transition (the W5 completion-vs-arm family). Model the duration: the COPY still lands
// immediately (end-state identical), but PI_STATUS stays busy and the completion side effects
// (intr flag, MI level, HLE message, bare-metal note) fire at a length-proportional due time from
// the engine main loop's pacer tick. Unset env = byte-identical behavior.
static std::atomic<long long> g_pi_due_us{0};     // 0 = no deferred completion pending
static uint8_t* g_pi_tick_rdram = nullptr;
static bool pi_pace_on() {
    static const bool on = [] { const char* e = std::getenv("RECOMP_PI_PACE"); return (e == nullptr) || (e[0] != '0'); }();   // DEFAULT ON (cart DMA always took real time on hardware); env=0 = off-instrument
    return on;
}
static long long pi_now_us() {
    return std::chrono::duration_cast<std::chrono::microseconds>(
        std::chrono::steady_clock::now().time_since_epoch()).count();
}
static uint32_t g_pi_pend_dram = 0, g_pi_pend_cart = 0, g_pi_pend_len = 0;
static bool g_pi_pend_copy = false;   // [pi-pace v2] bytes land at completion, not arm
static void pi_complete_now(uint8_t* rdram) {
    // [pi-pace v2 2026-08-26] the BYTES are the payload of the duration: hardware delivers them
    // across the transfer window, completing WITH the interrupt. Landing them at arm hands the
    // guest the future early — measured at SOTE's transition: staged wave bytes clobbered live
    // kernel data (curtask word, run-queue links) the old world still walks mid-wave, so the
    // dispatcher lost the RUNNABLE worker and idled forever. Copy here, then signal.
    if (g_pi_pend_copy) {
        g_pi_pend_copy = false;
        recomp::do_rom_read(rdram, (gpr)(int32_t)(0x80000000u | g_pi_pend_dram), g_pi_pend_cart, g_pi_pend_len);
        static int _bc = 0;
        if (_bc++ < 12) { fprintf(stderr, "[pi-pace] BYTES landed at completion: cart=0x%08X -> dram=0x%08X len=0x%X%c", g_pi_pend_cart, g_pi_pend_dram, g_pi_pend_len, 0x0A); fflush(stderr); }
    }
    uint32_t* reg = reinterpret_cast<uint32_t*>(rdram + 0x04600000u);
    reg[4] = 0x08u;
    recomp_present_mi_intr(0x10u);
    ultramodern::send_pi_message();
    if (recomp_baremetal_enabled() && recomp_baremetal_eret_seen()) {
        recomp_baremetal_note_interrupt(0x10);
    }
}
// [pi-arm] completion-on-arm: the race-ending half of the pacer. The guest arming its interrupt
// wait WHILE a paced DMA is in flight is the exact hardware moment "waiting for the DMA" begins —
// completing right then is faithful (the DMA finishes during the wait) and can never be early.
// Called from the mask-poll decline path when the guest's mask includes PI. Returns 1 if an
// in-flight DMA was completed (its note fires; the next venue pass delivers legitimately).
extern "C" int recomp_pi_complete_on_arm(void) {
    const long long due = g_pi_due_us.exchange(0, std::memory_order_relaxed);
    if (due == 0 || g_pi_tick_rdram == nullptr) return 0;
    static int _pa = 0;
    if (_pa++ < 12) { fprintf(stderr, "[pi-arm] completing in-flight DMA at the guest's arm point%c", 0x0A); fflush(stderr); }
    pi_complete_now(g_pi_tick_rdram);
    return 1;
}
extern "C" void recomp_pi_pacer_tick(void) {
    const long long due = g_pi_due_us.load(std::memory_order_relaxed);
    if (due == 0 || g_pi_tick_rdram == nullptr) return;
    if (pi_now_us() < due) return;
    if (g_pi_due_us.exchange(0, std::memory_order_relaxed) == 0) return;   // [pi-status-busy] single-fire vs the poll-side completion
    static int _pc = 0;
    if (_pc++ < 12) { fprintf(stderr, "[pi-pace] deferred PI completion fired%c", 0x0A); fflush(stderr); }
    pi_complete_now(g_pi_tick_rdram);
}

extern "C" void recomp_pi_register_write(uint8_t* rdram, uint32_t off, uint32_t value) {
    // PI register block base (physical 0x04600000) as a word array, native endianness — the same
    // view the recompiler's MEM_W store produced, so read-backs are consistent.
    uint32_t* reg = reinterpret_cast<uint32_t*>(rdram + 0x04600000u);
    switch (off) {
        case 0x00: reg[0] = value; break; // PI_DRAM_ADDR
        case 0x04: reg[1] = value; break; // PI_CART_ADDR
        // HARDWARE: PI_WR_LEN (0x0C) starts the cart->RDRAM read (libultra osPiStartDma OS_READ -> the
        // COMMON load); PI_RD_LEN (0x08) is the RDRAM->cart write. The engine previously did the read
        // ONLY on 0x08 and IDLED 0x0C, so standard raw-PI games that load the cart via WR_LEN (e.g. 1080's
        // boot cart-scan in func_80000B34) loaded nothing and span forever. Do the synchronous cart->RDRAM
        // read for EITHER length register: hardware-faithful for loads, and regression-safe (ROM is
        // read-only, so treating the 0x08 write-direction as a load too is a harmless no-op for our carts).
        case 0x08:                        // PI_RD_LEN
        case 0x0C: {                      // PI_WR_LEN -> cart->RDRAM read DMA (the real load path)
            reg[off >> 2] = value;
            uint32_t dram = reg[0] & 0x00FFFFFFu;        // RDRAM physical destination
            // [pi-cart28 2026-08-26, THE SOTE RELOAD WALL] cen64-conformant cart decode: the PI
            // cart address is a 28-BIT bus offset (cen64 pi_dma_write: source = reg & 0xFFFFFFE;
            // pi_rom_fetch reads rom[source] directly). Bit 28 (the libultra 0x10000000 idiom) is
            // DON'T-CARE: 0x104E8900 and 0x004E8900 are the SAME ROM byte. SOTE's pre-dev-kit
            // kernel programs BARE OFFSETS for its reload's 0x400-byte index reads (measured:
            // hundreds of cart=0x000Bxxxx/0x003Bxxxx DMAs, every one piREJECT'd "cart<rom_base"
            // with completion-still-reported = the game read garbage and the reload died — THE
            // month-old wall). The cen64 oracle services them all (oracle_pidma.txt, 27 bare-offset
            // reads on the truth path). Standard-idiom addresses decode IDENTICALLY to the old
            // (cart - rom_base) math — behavior changes ONLY for the formerly-rejected class.
            uint32_t cart = reg[1] & 0x0FFFFFFEu;        // 28-bit cart bus -> ROM byte offset
            uint32_t len  = (value & 0x00FFFFFFu) + 1;   // PI length is (bytes - 1)
            size_t rom_size = recomp::get_rom().size();
            // [pi-cart28b] cen64 pi_rom_fetch semantics for the tail: a read STARTING past the ROM
            // serves pure 0xFF; a read RUNNING past it clamps and pads the remainder 0xFF (0xFF is
            // byte-swizzle-invariant, so the raw memset matches the swizzled layout).
            if ((dram & 0x7u) == 0 && (size_t)cart >= rom_size && (size_t)dram + len <= 0x00800000u) {
                memset(rdram + dram, 0xFF, len);
            } else
            if ((dram & 0x7u) == 0 && (size_t)cart < rom_size) {
                size_t fill = 0;
                if ((size_t)cart + len > rom_size) {
                    fill = (size_t)cart + len - rom_size;
                    len = (uint32_t)(rom_size - cart);
                }
                if (fill > 0 && (size_t)dram + len + fill <= 0x00800000u)
                    memset(rdram + dram + len, 0xFF, fill);
                cart = recomp::rom_base + cart;          // do_rom_read subtracts rom_base internally
                if (!(pi_pace_on() && recomp_baremetal_enabled() && recomp_bm_wave_active())) {
                    recomp::do_rom_read(rdram, (gpr)(int32_t)(0x80000000u | dram), cart, len);
                    // [ovl-raw 2026-09-01, Cruis'n USA] A game that programs the PI registers itself
                    // (Williams/Midway arcade ports, SOTE, Robotron) never passes through do_dma, so its
                    // DMA'd code overlays were never bound to their recompiled sections and ran
                    // interpreted. Bind them here by ROM range at the RAM the bytes LANDED at (the
                    // original N64Recomp model, load_overlays), so a section declared at a placeholder vram
                    // still binds where the game runs it. General: no-op for a game with no overlay sections.
                    load_overlays(cart - recomp::rom_base, (int32_t)(0x80000000u | dram), len);
                }   // wave era only: the copy is deferred to pi_complete_now (see [pi-pace v2] there).
                    // Boot keeps arm-time bytes — the deferred variant broke the boot PI wake chain
                    // (measured 15:52: 3 completions total, worker re-parking at 0x800C3EAC forever).
                static long _ndma = 0;
                static int _log_all = -1;   // RECOMP_PIDMA_LOG_ALL=1: uncap (SOTE audio-fetch dig)
                if (_log_all < 0) { const char* e = getenv("RECOMP_PIDMA_LOG_ALL"); _log_all = (e && *e && *e != '0') ? 1 : 0; }
                if (_log_all || _ndma++ < 24 || len >= 0x4000) { // [piDMA] first 24 + big (overlay) loads
                    fprintf(stderr, "[piDMA] cart=0x%08X -> dram=0x%08X len=0x%X (off=0x%X)\n", cart, dram, len, off);
                    fflush(stderr);
                } else if ((_ndma & 0xFFFu) == 0) {
                    // HEARTBEAT (KI Gold, 2026-08-28). The cap above makes "the [piDMA] lines stopped"
                    // unreadable — it is silence-by-cap, not silence-by-stall, and that is exactly the
                    // [[lying_instruments]] trap. One line per 4096 transfers carries the RUNNING TOTAL
                    // (so a rate is computable between any two runs) and the CURRENT cart address (so a
                    // retry loop hammering ONE address is visible as a constant). Uncapping instead is
                    // not an option here: the guest is issuing these from a hot loop and the flood would
                    // throttle the very run being measured.
                    // NAME THE CALLER. On an EMIT_WATCH build recomp_current_guest_func() is the
                    // guest function currently executing on this thread — without it a runaway
                    // transfer count says WHAT but never WHO, which is the difference between a
                    // finding and another day of guessing (KI Gold: 25.5M reads of ONE address).
                    fprintf(stderr, "[piDMA] running total=%ld cart=0x%08X dram=0x%08X len=0x%X func=0x%08X caller=0x%08X\n",
                            _ndma, cart, dram, len, recomp_current_guest_func(), recomp_current_guest_caller());
                    fflush(stderr);
                }
            } else {
                // SILENT-REJECT PROBE (SOTE audio-fetch dig 2026-07-19): the guard above skips the
                // transfer, but PI_STATUS/INTERRUPT below still report completion — so a guest whose
                // DMA is rejected believes its data arrived and reads a stale/empty buffer forever.
                // Name every rejection and WHICH predicate failed.
                static long _nrej = 0;
                if (_nrej++ < 40 || (_nrej % 500) == 0) {
                    const char* why =
                        (dram & 0x7u)                                               ? "dram-unaligned" :
                                                                                      "past-rom-end";   // [pi-cart28] 28-bit decode: no base/odd rejects remain
                    // RAW register values too: masking hides whether the guest wrote a proper
                    // cart-domain address (0x10xxxxxx / 0xB0xxxxxx, top bits lost downstream) or a
                    // bare ROM offset (guest-side base never initialized). That distinction decides
                    // whether the fix belongs in pi.cpp or upstream in the guest.
                    fprintf(stderr, "[piREJECT] #%ld cart=0x%08X -> dram=0x%08X len=0x%X (off=0x%X) WHY=%s "
                                    "(rom_base=0x%08X rom_size=0x%zX) RAW dram_reg=0x%08X cart_reg=0x%08X"
                                    " -- completion still reported\n",
                            _nrej, cart, dram, len, off, why, recomp::rom_base, rom_size,
                            reg[0], reg[1]);
                    fflush(stderr);
                }
            }
            // PI_STATUS after a completed DMA (audit batch 3, per the reference — mupen
            // pi_controller.c end_of_dma_transfer): busy bits clear, INTERRUPT (0x08) SET until the
            // game acks with the CLR_INTR write. The old hardcoded-idle-0 read starved raw-PI
            // drivers that poll PI_STATUS bit3 for completion instead of using the MI/osRecvMesg
            // path (the SI/EEPROM silence class). Busy bits stay 0 = the sync-DMA observer model.
            // [pi-pace] defer completion by the DMA's real duration (?10 MB/s + fixed cost);
            // the copy above already landed. While deferred, PI_STATUS reads busy (0x3).
            if (pi_pace_on() && recomp_baremetal_enabled()) {
                uint32_t* r2 = reinterpret_cast<uint32_t*>(rdram + 0x04600000u);
                const long long prev = g_pi_due_us.exchange(0, std::memory_order_relaxed);
                if (prev != 0) pi_complete_now(rdram);   // single-slot: flush an unfired predecessor (lands ITS bytes first)
                if (recomp_bm_wave_active() &&
                    cart >= recomp::rom_base && (cart & 0x1u) == 0 && (dram & 0x7u) == 0 &&
                    (size_t)(cart - recomp::rom_base) + len <= rom_size) {
                    g_pi_pend_dram = dram; g_pi_pend_cart = cart; g_pi_pend_len = len; g_pi_pend_copy = true;
                }
                g_pi_tick_rdram = rdram;
                r2[4] = 0x03u;                            // IO+DMA busy
                // [pi-pace v3 2026-08-26] durations are GUEST time: under RECOMP_FF the guest's
                // timing loops run FF x faster in wall-clock, so a wall-clock deferral overshoots
                // by FF and the guest's own DMA-wait expires before the bytes land — measured at
                // SOTE's reload: the self-describing 0x400-read stream read a STALE buffer header
                // and the next-block pointer chain went garbage (cart=0x17CAFFF8-class rejects;
                // the cen64 truth stream is 7701 clean sequential reads). Scale by FF.
                static const long long ff = [] {
                    const char* e = std::getenv("RECOMP_FF");
                    long v = (e != nullptr) ? strtol(e, nullptr, 10) : 1;
                    return (long long)((v >= 1 && v <= 32) ? v : 1);
                }();
                const long long dur = (100 + (long long)len / 10) / ff;   // us: 10 MB/s cart rate, guest-time
                g_pi_due_us.store(pi_now_us() + dur, std::memory_order_relaxed);
                static int _pd = 0;
                if (_pd++ < 12) { fprintf(stderr, "[pi-pace] DMA len=0x%X deferred %lldus%c", len, dur, 0x0A); fflush(stderr); }
                break;
            }
            reg[4] = 0x08u;
            // LEVEL-TRIGGERED MI PRESENTATION (fifa wall, 2026-08-05): hardware holds MI_INTR bit 4
            // (PI) high from DMA completion until the game's CLR_INTR ack — regardless of when the
            // game arms its interrupt system. A boot's first DMAs can complete BEFORE the kernel
            // exists (fifa: header + overlay blob DMA'd, THEN the MI mask written, THEN sleep on a
            // PI interrupt that had already come and gone — the eret_seen-gated note below was the
            // only raw delivery, and it is a one-shot). Present the level source unconditionally:
            // the mask gates delivery, and post-arm note traffic (VI every frame) drains it.
            // Pollers (robotron/spaceinv) read PI_STATUS and never see this. Ack clears it above.
            recomp_present_mi_intr(0x10u);
            // Hardware raises the PI interrupt when the DMA finishes; a raw-MMIO PI driver waits for it
            // via osSetEventMesg(OS_EVENT_PI). We complete synchronously, so fire it now. (No-op if the
            // game never registered the event — the queue is NULL and do_send drops it.)
            ultramodern::send_pi_message();
            // Bare-metal fiber world: the game's kernel serves PI through its OWN interrupt handler
            // (MI source 0x10), not the HLE message system — same delivery the HLE osPiStartDma path
            // does at its completion (see the eret_seen note there). Without this a custom kernel's
            // PI service never runs and its DMA-completion waiter spins forever on a flag the ISR
            // was supposed to set (SOTE task 0x800C0114 polling PI_STATUS after the B1 asset loads).
            if (recomp_baremetal_enabled() && recomp_baremetal_eret_seen()) {
                recomp_baremetal_note_interrupt(0x10);
            }
            break;
        }
        case 0x10:                                    // PI_STATUS: command write (reference: pi_controller.c)
            // bit1 = CLR_INTR: clear the interrupt flag + the MI line (level-triggered model, mmio.cpp)
            if (value & 0x2u) { recomp_ack_mi_intr(0x10u); recomp_baremetal_ack_noted_mi(0x10u); reg[4] &= ~0x08u; }
            // bit0 = RESET: zero the status register
            if (value & 0x1u) reg[4] = 0;
            break;
        default:                                       // 0x14..0x30 BSD bus-timing: just store (harmless)
            if ((off >> 2) < 16) reg[off >> 2] = value;
            break;
    }
}

// Invoked by the central MMIO dispatcher (mmio.cpp) for reads of the PI register block.
extern "C" uint32_t recomp_pi_register_read(uint8_t* rdram, uint32_t off) {
    if (off == 0x10) { // PI_STATUS
        // ── [pi-status-busy 2026-09-05, Rage Wars #152 / the Acclaim raw-PI class] ────────────────
        // SDK (engine/references/sdk/.../usr/include/PR/rcp.h:741-743): PI_STATUS_DMA_BUSY 0x01,
        // PI_STATUS_IO_BUSY 0x02, PI_STATUS_ERROR 0x04; bit 3 = interrupt. libultra's own raw driver
        // (engine/references/libreultra/lib/src/osPiRawStartDma.c) spins on
        // `while (status & (PI_STATUS_BUSY | PI_STATUS_IOBUSY | PI_STATUS_ERROR))` (osPiRawStartDma.c:10) before touching the
        // registers - a hardware PI reports BUSY for the whole transfer. This read masked the busy bits
        // to 0 ("synchronous DMA observer") while the write path above sets 0x03 for a paced
        // transfer whose BYTES are deferred to completion ([pi-pace v2]): a guest that polls STATUS
        // instead of waiting for the PI interrupt saw "idle" instantly and read the destination
        // before the bytes landed. MEASURED on Rage Wars: PI_DRAM_ADDR=0x0014C000 CART=0x1028B264
        // WR_LEN=0xFFF (a heap page the guest's pager had just mapped at virtual 0x00800000), then
        // `lw` from that page at 0x00257420 read zeros -> pointer chain -> TLB miss on 0x275ABBBC
        // -> the game's fatal handler (0x0023C1D0: unmapped page not in its table) -> 2 s -> reboot
        // through the boot stub at 0x80000400, forever (the "2 fps" reboot loop). Report the busy
        // bits the write path already keeps, and complete an overdue paced transfer right here so a
        // tight poll loop on the game thread terminates even between main-loop pacer ticks.
        {
            const long long due = g_pi_due_us.load(std::memory_order_relaxed);
            if (due != 0 && g_pi_tick_rdram != nullptr && pi_now_us() >= due) {
                if (g_pi_due_us.exchange(0, std::memory_order_relaxed) != 0) {
                    static int _sc = 0;
                    if (_sc++ < 12) { fprintf(stderr, "[pi-pace] overdue completion fired from a PI_STATUS poll%c", 0x0A); fflush(stderr); }
                    pi_complete_now(g_pi_tick_rdram);
                }
            }
        }
        return *reinterpret_cast<uint32_t*>(rdram + 0x04600000u + 0x10u) & 0x0Bu;   // DMA busy | IO busy | interrupt
    }
    return *reinterpret_cast<uint32_t*>(rdram + 0x04600000u + (off & 0x3Cu));
}

void recomp::do_rom_pio(uint8_t* rdram, gpr ram_address, uint32_t physical_addr) {
    assert((physical_addr & 0x3) == 0 && "PIO not 4-byte aligned in device, currently unsupported");
    assert((ram_address & 0x3) == 0 && "PIO not 4-byte aligned in RDRAM, currently unsupported");
    uint8_t* rom_addr = rom.data() + physical_addr - recomp::rom_base;
    MEM_B(0, ram_address) = *rom_addr++;
    MEM_B(1, ram_address) = *rom_addr++;
    MEM_B(2, ram_address) = *rom_addr++;
    MEM_B(3, ram_address) = *rom_addr++;
}

struct {
    std::vector<char> save_buffer;
    std::thread saving_thread;
    std::filesystem::path save_file_path;
    moodycamel::LightweightSemaphore write_sempahore;
    // Used to tell the saving thread that a file swap is pending.
    moodycamel::LightweightSemaphore swap_file_pending_sempahore;
    // Used to tell the consumer thread that the saving thread is ready for a file swap.
    moodycamel::LightweightSemaphore swap_file_ready_sempahore;
    std::mutex save_buffer_mutex;
} save_context;

const std::u8string save_folder = u8"saves";

extern std::filesystem::path config_path;

std::filesystem::path ultramodern::get_save_file_path() {
    return save_context.save_file_path;
}

void set_save_file_path(const std::u8string& subfolder, const std::u8string& name) {
    std::filesystem::path save_folder_path = config_path / save_folder;
    if (!subfolder.empty()) {
        save_folder_path = save_folder_path / subfolder;
    }
    save_context.save_file_path = save_folder_path / (name + u8".bin");
}

void update_save_file() {
    bool saving_failed = false;
    {
        std::ofstream save_file = recomp::open_output_file_with_backup(ultramodern::get_save_file_path(), std::ios_base::binary);

        if (save_file.good()) {
            std::lock_guard lock{ save_context.save_buffer_mutex };
            save_file.write(save_context.save_buffer.data(), save_context.save_buffer.size());
        }
        else {
            saving_failed = true;
        }
    }
    if (!saving_failed) {
        saving_failed = !recomp::finalize_output_file_with_backup(ultramodern::get_save_file_path());
    }
    if (saving_failed) {
        ultramodern::error_handling::message_box("Failed to write to the save file. Check your file permissions and whether the save folder has been moved to Dropbox or similar, as this can cause issues.");
    }
}

extern std::atomic_bool exited;

void saving_thread_func(RDRAM_ARG1) {
    while (!exited) {
        bool save_buffer_updated = false;
        // Repeatedly wait for a new action to be sent.
        constexpr int64_t wait_time_microseconds = 10000;
        constexpr int max_actions = 128;
        int num_actions = 0;

        // Wait up to the given timeout for a write to come in. Allow multiple writes to coalesce together into a single save.
        // Cap the number of coalesced writes to guarantee that the save buffer eventually gets written out to the file even if the game
        // is constantly sending writes.
        while (save_context.write_sempahore.wait(wait_time_microseconds) && num_actions < max_actions) {
            save_buffer_updated = true;
            num_actions++;
        }

        // If an action came through that affected the save file, save the updated contents.
        if (save_buffer_updated) {
            update_save_file();
        }

        if (save_context.swap_file_pending_sempahore.tryWait()) {
            save_context.swap_file_ready_sempahore.signal();
        }
    }
}

void save_write_ptr(const void* in, uint32_t offset, uint32_t count) {
    assert(offset + count <= save_context.save_buffer.size());

    {
        std::lock_guard lock { save_context.save_buffer_mutex };
        memcpy(&save_context.save_buffer[offset], in, count);
    }
    
    save_context.write_sempahore.signal();
}

void save_write(RDRAM_ARG PTR(void) rdram_address, uint32_t offset, uint32_t count) {
    assert(offset + count <= save_context.save_buffer.size());

    {
        std::lock_guard lock { save_context.save_buffer_mutex };
        for (gpr i = 0; i < count; i++) {
            save_context.save_buffer[offset + i] = MEM_B(i, rdram_address);
        }
    }

    save_context.write_sempahore.signal();
}

void save_read(RDRAM_ARG PTR(void) rdram_address, uint32_t offset, uint32_t count) {
    assert(offset + count <= save_context.save_buffer.size());

    std::lock_guard lock { save_context.save_buffer_mutex };
    for (gpr i = 0; i < count; i++) {
        MEM_B(i, rdram_address) = save_context.save_buffer[offset + i];
    }
}

void save_clear(uint32_t start, uint32_t size, char value) {
    assert(start + size < save_context.save_buffer.size());

    {
        std::lock_guard lock { save_context.save_buffer_mutex };
        std::fill_n(save_context.save_buffer.begin() + start, size, value);
    }

    save_context.write_sempahore.signal();
}

size_t get_save_size(recomp::SaveType save_type) {
    switch (save_type) {
        case recomp::SaveType::AllowAll:
        case recomp::SaveType::Flashram:
            return 0x20000;
        case recomp::SaveType::Sram:
            return 0x8000;
        case recomp::SaveType::Eep16k:
            return 0x800;
        case recomp::SaveType::Eep4k:
            return 0x200;
        case recomp::SaveType::None:
            return 0;
    }
    return 0;
}

void read_save_file() {
    std::filesystem::path save_file_path = ultramodern::get_save_file_path();

    // Ensure the save file directory exists.
    std::filesystem::create_directories(save_file_path.parent_path());

    // Read the save file if it exists.
    std::ifstream save_file = recomp::open_input_file_with_backup(save_file_path, std::ios_base::binary);
    if (save_file.good()) {
        save_file.read(save_context.save_buffer.data(), save_context.save_buffer.size());
    }
    else {
        // Otherwise clear the save file to all zeroes.
        std::fill(save_context.save_buffer.begin(), save_context.save_buffer.end(), 0);
    }
}

void ultramodern::init_saving(RDRAM_ARG1) {
    set_save_file_path(u8"", recomp::current_game_id());

    save_context.save_buffer.resize(get_save_size(recomp::get_save_type()));

    read_save_file();

    save_context.saving_thread = std::thread{saving_thread_func, PASS_RDRAM};
}

void ultramodern::change_save_file(const std::u8string& subfolder, const std::u8string& name) {
    // Tell the saving thread that a file swap is pending.
    save_context.swap_file_pending_sempahore.signal();
    // Wait until the saving thread indicates it's ready to swap files.
    save_context.swap_file_ready_sempahore.wait();
    // Perform the save file swap.
    set_save_file_path(subfolder, name);
    read_save_file();
}

void ultramodern::join_saving_thread() {
    if (save_context.saving_thread.joinable()) {
        save_context.saving_thread.join();
    }
}

// Declared in overlays.cpp — registers sections found in [rom, rom+size)
// at their default virtual RAM addresses (section_table.ram_addr).
// Called after every ROM→RDRAM DMA so overlay function maps stay current.
extern "C" void load_overlays_from_dma(uint32_t rom, uint32_t size);

void do_dma(RDRAM_ARG PTR(OSMesgQueue) mq, gpr rdram_address, uint32_t physical_addr, uint32_t size, uint32_t direction) {
    // ── [pitrace] (SOTE 2026-08-26) — env RECOMP_PI_TRACE=1, every PI DMA with its geometry ─────
    // The phase transition is a DMA WAVE that rebuilds the code image and eats the old kernel
    // (code AND data); understanding the handoff needs the wave's exact anatomy: order, targets,
    // sizes, and which DMA the worker's last wait corresponds to. Read-only; unset = zero cost.
    {
        static const bool pt_on = [] { const char* e = std::getenv("RECOMP_PI_TRACE"); return (e != nullptr) && (e[0] == '1'); }();
        if (pt_on) {
            static std::atomic<uint32_t> pt_n{0};
            const uint32_t n = ++pt_n;
            fprintf(stderr, "[pitrace] #%u dir=%u dram=0x%08X cart=0x%08X len=0x%X mq=0x%08X\n",
                    n, direction, (uint32_t)rdram_address, physical_addr, size, (uint32_t)mq);
            fflush(stderr);
        }
    }

    // TODO asynchronous transfer
    // TODO implement unaligned DMA correctly
    if (direction == 0) {
        if (physical_addr >= recomp::rom_base) {
            // read cart rom
            recomp::do_rom_read(rdram, rdram_address, physical_addr, size);

            // [ovldisc] OVERLAY-DISCOVERY PROBE (reusable tool for the overlay second-pass):
            // dump every cart->RDRAM DMA as rom->vram->size. These triples ARE the overlay table,
            // captured from what the game actually DMAs (no static guessing). Filter + convert to
            // yaml/ld code segments with tools/overlays_from_log.py. General + harmless (log only);
            // gate behind RECOMP_OVLDISC env so it's silent unless a port is being discovered.
            if (std::getenv("RECOMP_OVLDISC")) {
                static long _n = 0;
                if (_n++ < 4000) {
                    fprintf(stderr, "[ovldisc] DMA rom=0x%08X vram=0x%08X size=0x%X\n",
                            physical_addr - recomp::rom_base, (uint32_t)rdram_address, size);
                    fflush(stderr);
                }
            }

            // Register any overlay code sections that were just DMA'd from ROM.
            // load_overlays_from_dma uses the section's canonical MIPS vaddr
            // (section_table.ram_addr) as the func_map key, not the RDRAM
            // destination — this is essential for NisitenmaIchigo overlays
            // whose kuseg vaddr (0x0F000000) differs from the KSEG0 DMA target.
            load_overlays_from_dma(physical_addr - recomp::rom_base, size);

            if (recomp_baremetal_enabled() && recomp_baremetal_eret_seen()) {
                // Bare-metal, fiber world LIVE (eret seen): do NOT deliver through the HLE message
                // system (HLE do_send's wake step would scribble a guest queue's TCB wait-list at
                // offset 0x0). Raise the PI MI bit —
                // (Pre-eret gate, worklist NC: before the first eret, g_ctx is null so
                // nc_deliver_and_wake / the idle drain have NO deliverer — the completion would be
                // blackholed. NC's boot does a SYNCHRONOUS blocking osPiStartDma+osRecvMesg before
                // its scheduler ever arms, so pre-eret the waiter is still an HLE ultramodern thread
                // and the else-branch's HLE delivery is both safe AND the only path. General: any
                // hybrid game doing libultra sync loads before its custom scheduler starts.)
                // the game-thread drain runs the game's OWN handler, which serves PI exactly as on
                // hardware. NC (legacy explicit class) additionally gets its direct ring delivery
                // (note_pi_mq -> nc_deliver_and_wake); auto-armed stock-libultra games need only the
                // MI bit (their recompiled __osException posts to their own queues itself).
                recomp_baremetal_note_interrupt(0x10);
                if (recomp_baremetal_nc_mode()) recomp_baremetal_note_pi_mq((uint32_t)mq);
            } else {
                // Send a message to the mq to indicate that the transfer completed (HLE path).
                ultramodern::enqueue_external_message_src(mq, 0, false, ultramodern::EventMessageSource::Pi);
            }
        } else if (physical_addr >= recomp::sram_base) {
            // Flashram's DATA WINDOW is read with raw PI DMAs from this same range — both by
            // libultra osFlashReadArray AND by custom drivers (Westwood candc, Blizzard sc64)
            // that never call the HLE-patched osFlash* entry points. Serve those reads from the
            // save buffer exactly like hardware serves the flash array.
            uint32_t save_offset = physical_addr - recomp::sram_base;
            bool serve_read = recomp::sram_allowed() ||
                              recomp::get_save_type() == recomp::SaveType::Flashram;
            if (serve_read && (size_t)save_offset + size <= get_save_size(recomp::get_save_type())) {
                save_read(rdram, rdram_address, save_offset, size);
            } else {
                // Hardware-faithful fail-soft (was: fatal message box + QUICK_EXIT). A real N64
                // with no save chip in the cart returns open-bus garbage on this DMA and keeps
                // running — games PROBE this range at boot to detect save hardware. Read back
                // as erased/absent (0xFF) and complete the DMA.
                static bool sram_probe_logged = false;
                if (!sram_probe_logged) {
                    sram_probe_logged = true;
                    fprintf(stderr, "[save] PI read in save range unserviceable (type/bounds) -> open-bus fail-soft (0xFF fill)\n");
                }
                for (gpr i = 0; i < size; i++) {
                    MEM_B(i, rdram_address) = 0xFF;
                }
            }
            // Either way the DMA completes, exactly like hardware.
            ultramodern::enqueue_external_message_src(mq, 0, false, ultramodern::EventMessageSource::Pi);
        } else {
            fprintf(stderr, "[WARN] PI DMA read from unknown region, phys address 0x%08X\n", physical_addr);
        }
    } else {
        if (physical_addr >= recomp::rom_base) {
            // write cart rom
            throw std::runtime_error("ROM DMA write unimplemented");
        } else if (physical_addr >= recomp::sram_base) {
            if (!recomp::sram_allowed()) {
                // Hardware-faithful fail-soft: writes to absent save hardware vanish on the bus;
                // the console never halts. Complete the DMA and move on (see read-path note).
                static bool sram_probe_logged_w = false;
                if (!sram_probe_logged_w) {
                    sram_probe_logged_w = true;
                    fprintf(stderr, "[save] PI write in SRAM range with non-SRAM save type -> open-bus fail-soft (dropped)\n");
                }
                ultramodern::enqueue_external_message_src(mq, 0, false, ultramodern::EventMessageSource::Pi);
            } else {
                // write sram
                save_write(rdram, rdram_address, physical_addr - recomp::sram_base, size);

                // Send a message to the mq to indicate that the transfer completed
                ultramodern::enqueue_external_message_src(mq, 0, false, ultramodern::EventMessageSource::Pi);
            }
        } else {
            fprintf(stderr, "[WARN] PI DMA write to unknown region, phys address 0x%08X\n", physical_addr);
        }
    }
}

extern "C" void osPiStartDma_recomp(RDRAM_ARG recomp_context* ctx) {
    uint32_t mb = ctx->r4;
    uint32_t pri = ctx->r5;
    uint32_t direction = ctx->r6;
    uint32_t devAddr = ctx->r7 | recomp::rom_base;
    gpr dramAddr = MEM_W(0x10, ctx->r29);
    uint32_t size = MEM_W(0x14, ctx->r29);
    PTR(OSMesgQueue) mq = MEM_W(0x18, ctx->r29);
    uint32_t physical_addr = k1_to_phys(devAddr);

    // CAP IT. This was an unconditional fprintf+fflush on every call. That was survivable while
    // this path was dead (the PI manager has been LLE since [RUNG2-LLE-PI]), but a game that
    // streams from cart calls this thousands of times a second, and an fflush per call becomes the
    // dominant load in the process — the exact failure the [tlb_lowva] flood caused on KI Gold
    // (231k lines, VI decayed 60/s -> 7/s). First 24 + every 4096th, with a running total so the
    // rate stays countable after the print stops.
    // caller= NAMES THE GUEST FUNCTION that made this request. Unlike the [piDMA] heartbeat's
    // 1-deep caller (useless for a spinning leaf — emit_func_remark overwrites it), this stub is
    // NATIVE and emits no mark, so the last mark on this thread is genuinely the CALLING guest
    // function. Answers "who is issuing the garbage devAddr" in one run.
    { static long _n = 0; if (_n++ < 24 || (_n & 0xFFFu) == 0) {
        fprintf(stderr, "[pi] osPiStartDma #%ld: dev=0x%08X dram=0x%08X size=0x%X dir=%u caller=0x%08X%c",
                _n, devAddr, (uint32_t)dramAddr, size, direction, recomp_current_guest_func(), 0x0A);
        fflush(stderr); } }

    do_dma(PASS_RDRAM mq, dramAddr, physical_addr, size, direction);

    ctx->r2 = 0;
}

extern "C" void osEPiStartDma_recomp(RDRAM_ARG recomp_context* ctx) {
    OSPiHandle* handle = TO_PTR(OSPiHandle, ctx->r4);
    OSIoMesg* mb = TO_PTR(OSIoMesg, ctx->r5);
    uint32_t direction = ctx->r6;
    uint32_t devAddr = handle->baseAddress | mb->devAddr;
    gpr dramAddr = mb->dramAddr;
    uint32_t size = mb->size;
    PTR(OSMesgQueue) mq = mb->hdr.retQueue;
    uint32_t physical_addr = k1_to_phys(devAddr);

    fprintf(stderr, "[pi] osEPiStartDma: handle=0x%08X base=0x%08X devOff=0x%08X dev=0x%08X phys=0x%08X dram=0x%08X size=0x%X dir=%u mq=0x%08X\n",
            (uint32_t)ctx->r4, handle->baseAddress, mb->devAddr, devAddr, physical_addr,
            (uint32_t)dramAddr, size, direction, (uint32_t)mq);
    fflush(stderr);

    do_dma(PASS_RDRAM mq, dramAddr, physical_addr, size, direction);

    ctx->r2 = 0;
}

extern "C" void osEPiReadIo_recomp(RDRAM_ARG recomp_context * ctx) {
    OSPiHandle* handle = TO_PTR(OSPiHandle, ctx->r4);
    uint32_t devAddr = handle->baseAddress | ctx->r5;
    gpr dramAddr = ctx->r6;
    uint32_t physical_addr = k1_to_phys(devAddr);

    if (physical_addr > recomp::rom_base) {
        // cart rom
        recomp::do_rom_pio(PASS_RDRAM dramAddr, physical_addr);
    } else {
        // sram
        assert(false && "SRAM ReadIo unimplemented");
    }

    ctx->r2 = 0;
}

// Write a single IO word to an EPI device (osEPiWriteIo / osEPiRawWriteIo). The retail callers are
// the 64DD ASIC (absent on a retail console — OoT's leoChk_asic_ready) and, rarely, save-device
// word IO. Cart ROM is read-only and the 64DD drive is absent, so a drop is the hardware-correct
// result there; SRAM/flash saves go through osPiStartDma to the save domain, not this path. Stub to
// a no-op (return 0) until a game is shown to need writable EPI word-IO. General (libultra surface).
extern "C" void osEPiWriteIo_recomp(RDRAM_ARG recomp_context * ctx) {
    ctx->r2 = 0;
}

// ── PI WORD IO: osPiReadIo / osPiRawReadIo / osPiWriteIo / osPiRawWriteIo (ENGINE CAPABILITY, 2026-09-02) ──
// SDK reference (engine/references/libreultra/lib/src/osPiRawReadIo.c):
//     while (PI_STATUS & (BUSY|IOBUSY|ERROR)) {}   *data = HW_REG(osRomBase | devAddr, u32);   return 0;
// and the Online Manual (n64man/os/osPiStartDma.htm): osPiReadIo "reads a 32-bit word from the PI device
// address space" at devAddr into *data; osPiReadIo = __osPiGetAccess + osPiRawReadIo + __osPiRelAccess.
// osRomBase is the KSEG1 cart base (0xB0000000), so `osRomBase | devAddr` serves both a physical cart
// address (0x10000000|off) and a bare ROM offset; KSEG1 -> phys is `& 0x1FFFFFFF`.
// Until today NO native existed: every game tree carried a per-game stub that returned 0xFFFFFFFF and never
// wrote *data. Forsaken's boot reads one cart word twice through osPiReadIo and loops until the two copies
// agree, which two unwritten stack words can never satisfy. The 313 stubs were removed with this native.
static void pi_word_read(RDRAM_ARG uint32_t devAddr, gpr dataAddr, const char* who) {
    const uint32_t phys = (0xB0000000u | devAddr) & 0x1FFFFFFFu;
    const size_t rom_size = recomp::get_rom().size();
    if (phys >= recomp::rom_base && (size_t)(phys - recomp::rom_base) < rom_size) {
        recomp::do_rom_pio(PASS_RDRAM dataAddr, phys);          // one big-endian ROM word -> *data
    } else {
        // Not cart ROM (SRAM / flash / 64DD / other PI domains): no word device is modelled -> open bus.
        static int _n = 0;
        if (_n++ < 8) { fprintf(stderr, "[pi] %s: non-ROM device word dev=0x%08X phys=0x%08X -> open bus 0xFFFFFFFF%c", who, devAddr, phys, 0x0A); fflush(stderr); }
        MEM_W(0, dataAddr) = 0xFFFFFFFFu;
    }
    { static int _m = 0; if (_m++ < 4) { fprintf(stderr, "[pi] %s dev=0x%08X -> *0x%08X = 0x%08X%c", who, devAddr, (uint32_t)dataAddr, (uint32_t)MEM_W(0, dataAddr), 0x0A); fflush(stderr); } }
}
extern "C" void osPiRawReadIo_recomp(RDRAM_ARG recomp_context* ctx) {
    pi_word_read(PASS_RDRAM (uint32_t)ctx->r4, ctx->r5, "osPiRawReadIo");
    ctx->r2 = 0;
}
extern "C" void osPiReadIo_recomp(RDRAM_ARG recomp_context* ctx) {
    pi_word_read(PASS_RDRAM (uint32_t)ctx->r4, ctx->r5, "osPiReadIo");
    ctx->r2 = 0;
}
// Word WRITES: cart ROM is read-only and no writable PI word device is modelled (see osEPiWriteIo above), so the
// hardware-correct result for a retail cart is a dropped write; return 0 as libultra does.
static void pi_word_write_dropped(uint32_t devAddr, uint32_t data, const char* who) {
    static int _n = 0;
    if (_n++ < 8) { fprintf(stderr, "[pi] %s dev=0x%08X data=0x%08X -> dropped (no writable PI word device)%c", who, devAddr, data, 0x0A); fflush(stderr); }
}
extern "C" void osPiRawWriteIo_recomp(RDRAM_ARG recomp_context* ctx) {
    pi_word_write_dropped((uint32_t)ctx->r4, (uint32_t)ctx->r5, "osPiRawWriteIo");
    ctx->r2 = 0;
}
extern "C" void osPiWriteIo_recomp(RDRAM_ARG recomp_context* ctx) {
    pi_word_write_dropped((uint32_t)ctx->r4, (uint32_t)ctx->r5, "osPiWriteIo");
    ctx->r2 = 0;
}

// 64DD Disk Drive init (osLeoDiskInit). The Disk Drive peripheral is absent on a retail console and
// in our HLE, so return NULL (no handle) — exactly what hardware reports with no 64DD attached. Games
// that ship leftover 64DD code (OoT's leomain) check the NULL handle and skip the disk path. General.
extern "C" void osLeoDiskInit_recomp(RDRAM_ARG recomp_context * ctx) {
    ctx->r2 = 0;
}

extern "C" void osPiGetStatus_recomp(RDRAM_ARG recomp_context * ctx) {
    ctx->r2 = 0;
}

extern "C" void osPiRawStartDma_recomp(RDRAM_ARG recomp_context * ctx) {
    ultramodern::error_handling::message_box(
        "Stub `osPiRawStartDma_recomp` function called!\n"
        "Most games do not call this function directly, which means the libultra function\n"
        "that uses this function was not properly named.\n"
        "\n"
        "If you triggered this message, please make sure you have properly identified\n"
        "every libultra function on your recompiled game. If you are sure every libultra\n"
        "function has been identified and you still get this problem then open an issue on\n"
        "the N64ModernRuntime Github repository mentioning the game you are trying to\n"
        "recompile and steps to reproduce the issue.\n"
        "\n"
        "The application will close now, bye and good luck!"
    );
    ULTRAMODERN_QUICK_EXIT();
}

extern "C" void osEPiRawStartDma_recomp(RDRAM_ARG recomp_context * ctx) {
    ultramodern::error_handling::message_box(
        "Stub `osEPiRawStartDma_recomp` function called!\n"
        "Most games do not call this function directly, which means the libultra function\n"
        "that uses this function was not properly named.\n"
        "\n"
        "If you triggered this message, please make sure you have properly identified\n"
        "every libultra function on your recompiled game. If you are sure every libultra\n"
        "function has been identified and you still get this problem then open an issue on\n"
        "the N64ModernRuntime Github repository mentioning the game you are trying to\n"
        "recompile and steps to reproduce the issue.\n"
        "\n"
        "The application will close now, bye and good luck!"
    );
    ULTRAMODERN_QUICK_EXIT();
}
