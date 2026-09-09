// si.cpp — Serial Interface (SI) DMA + PIF/joybus emulation for raw-MMIO controller drivers.
//
// Most titles read controllers through libultra's osContStartReadData (HLE'd in input.cpp). But
// some — Killer Instinct Gold, and other small-team ports that hand-roll their controller code —
// drive the SI DMA registers directly:
//
//     SI_DRAM_ADDR (0x04800000) = RDRAM buffer holding the 64-byte PIF command block
//     SI_PIF_WR64  (0x04800010) = upload the block to PIF RAM   (RDRAM -> PIF)
//     SI_PIF_RD64  (0x04800004) = read the block back from PIF  (PIF  -> RDRAM, with responses)
//
// On hardware each kick runs the joybus protocol against the controllers and then raises the SI
// interrupt; libultra's __osSiCreateAccessQueue/handler posts a message to the queue the game
// registered with osSetEventMesg(OS_EVENT_SI, ...). Our MMIO layer previously ignored these writes,
// so the game's osRecvMesg on its SI queue blocked forever — KI Gold hung in init before ever
// building a graphics task (audio-only black screen).
//
// This file executes the joybus command block in place (the game keeps its command block in the
// SI_DRAM_ADDR buffer; WR64 then RD64 round-trip it), injects live controller state into each
// controller-read / status command's response slots, and fires the SI-done message.
//
// Joybus PIF-RAM command format (n64brew "PIF-NUS"): the 64-byte block is a stream of per-channel
// commands. Each command is  [tx_size] [rx_size] [cmd byte + tx data...] [rx response bytes...].
// Control bytes between/around commands:
//   0x00  channel skip — advance to the next controller port, no command
//   0xFD  channel reset
//   0xFE  end of command stream (stop parsing)
//   0xFF  padding / alignment filler (consumed, not a command)
// The high bit of tx_size (0x80) is a "skip" flag on some SDKs; we mask it off. After running a
// command, the SI writes the response bytes (and may set the high 2 bits of rx_size: 0x40 = device
// not present, 0x80 = data-CRC error) — we set 0x40 when a port has no controller.
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <deque>
#include <mutex>
#include <thread>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#ifdef _WIN32
// [eepwho] (2026-08-28, KI Gold): name the native guest function issuing raw EEPROM block reads.
// Same host-stack walk as overlays.cpp's [gapcaller] / tlb.cpp's [lowvawho]; env-gated, capped.
#include <windows.h>
#include <winternl.h>
#include <intrin.h>
#endif
#include "recomp.h"
#include "librecomp/cic.h"
#include "librecomp/game.hpp"

// Save-file backing (librecomp/src/files.cpp) — the same store the HLE osEeprom* path uses.
// (Signatures = the RDRAM_ARG/PTR(void) forms resolved: recomp mode, ultramodern/ultra64.h.)
void save_write(uint8_t* rdram, int32_t rdram_address, uint32_t offset, uint32_t count);
void save_read(uint8_t* rdram, int32_t rdram_address, uint32_t offset, uint32_t count);

// Input bridge (ultramodern/src/input.cpp).
extern "C" void recomp_si_poll_all();
extern "C" int  recomp_si_read_controller(int channel, uint8_t* out4);   // 4 bytes: btnHi,btnLo,sx,sy
extern "C" int  recomp_si_controller_status(int channel, uint8_t* out3); // 3 bytes: typeLo,typeHi,status (joybus wire order = type low byte first)
// Controller-pak bridge (librecomp/src/pak.cpp) — raw 32-byte block I/O + data CRC for joybus 0x02/0x03.
extern "C" void    recomp_pak_raw_read(int channel, uint16_t addr, uint8_t* out32);
extern "C" void    recomp_pak_raw_write(int channel, uint16_t addr, const uint8_t* in32);
extern "C" uint8_t recomp_pak_data_crc(const uint8_t* data);

// SI-done interrupt message (ultramodern/src/events.cpp).
namespace ultramodern { void send_si_message(); }

// Bare-metal (NC class): NC drives the SI registers directly, so there is no osContStartReadData mq the
// engine can capture — NC registered its SI/controller queue in its OWN event table (D_8012D600+0x28).
// The HLE send_si_message would fire to events_context.si.mq (NULL for NC) and DROP. So when bare-metal,
// skip the HLE path and flag a raw-SI completion; the game-thread idle resolves NC's SI queue from the
// event table and delivers+wakes (same mechanism as PI/HLE-controller). Baseline games never enable
// bare-metal and keep the plain send_si_message path. Gated -> baseline-safe.
extern "C" int  recomp_baremetal_enabled();
extern "C" int  recomp_baremetal_eret_seen();
extern "C" void recomp_baremetal_note_rawsi();
extern "C" int  recomp_baremetal_nc_mode();
extern "C" void recomp_baremetal_note_interrupt(uint32_t mi_bits);

namespace {
// rdram stores each 32-bit word byte-swapped vs. the N64's big-endian view. A byte at N64 physical
// address `a` is therefore at host offset `a ^ 3`. These helpers read/write single PIF-block bytes
// in the game's true byte order.
inline uint8_t  rd8(uint8_t* rdram, uint32_t a)            { return *(rdram + (a ^ 3)); }
inline void     wr8(uint8_t* rdram, uint32_t a, uint8_t v) { *(rdram + (a ^ 3)) = v; }

inline uint32_t si_dram_addr(uint8_t* rdram) {
    // SI_DRAM_ADDR was mirrored into rdram at its phys offset by mmio.cpp before the kick.
    uint32_t w = *reinterpret_cast<uint32_t*>(rdram + 0x04800000u);
    return w & 0x007FFFFFu; // clamp to 8 MB RDRAM
}
} // namespace

// ── CIC-NUS-6105 challenge/response (anti-piracy LLE) ──────────────────────────────────────────────
// The 6105 club (DK64 / Conker / Banjo-Tooie / Jet Force / Majora's Mask...) can issue a CIC "challenge"
// through the PIF: the game writes challenge nibbles into PIF RAM and sets the control byte's challenge
// bit (0x02). On hardware the PIF forwards them to the CIC, which transforms them with a fixed algorithm
// and writes the response back, which the game verifies; a wrong/absent response trips anti-piracy. We
// HLE the joybus but never answered the challenge. This is the reverse-engineered 6105 transform applied
// per nibble (the n64brew "6105 Algorithm").
// Thin shim → the faithful CIC chip model (librecomp/cic.cpp). The challenge transform now lives in the
// LLE CIC module (recomp::cic::challenge_6105) so si.cpp only marshals the 30 nibbles to/from PIF RAM.
static void cic6105_challenge(uint8_t* mem, int n) {
    if (n == 30) recomp::cic::challenge_6105(mem);
}

// is_read: 1 = SI_PIF_RD64 (the read-back that returns controller responses), 0 = SI_PIF_WR64.
// We execute the joybus block on BOTH kicks (the response is harmless on the upload and present on
// the read-back) and always fire the SI-done message so the game's wait unblocks either way.
// ── [si-busy 2026-09-04, War Gods] THE SI IS NOT INSTANTANEOUS HARDWARE ─────────────────────────────
// The joybus transaction behind a controller read takes real time: the SDK's man page for
// osContStartReadData says "around 2 milliseconds to complete its data reading and for osRecvMesg to
// receive a final message". This function used to complete the DMA and fire SI-done synchronously
// INSIDE the kick, so the completion existed before the kicking thread had even reached its
// osRecvMesg. MEASURED on wargods (RECOMP_RECV_WATCH on its OS_EVENT_SI queue, marked emission):
// two threads share that queue - the pri-5 main thread loops osContStartReadData/osRecvMesg/
// osContGetReadData from its own body, and the pri-10 gfx thread also kicks a read and waits - and
// in every wedging run ALL 11 SI-dones were consumed by the main thread (func=0x8028C300) while the
// gfx thread parked on the same queue after its own kick and never woke. With a real window the
// kicker reaches osRecvMesg and parks BEFORE the completion lands, and the priority-ordered wake
// (proven correct with RECOMP_TCB_WATCH: t=3 woken and consuming when it was parked first) delivers
// it to the right thread. Same rule, same reason, same shape as the RSP-busy interval in
// events.cpp task_thread_func (sp_task_busy_us): restore the hardware timeline so the waiting thread
// stays blocked and the others run. HLE (baseline) path only; the bare-metal lanes deliver through
// MI bits with their own timing and are unchanged. No env gate: the window is hardware's, not ours.
namespace {
    constexpr long long kSiDmaUs = 2000;   // SDK: ~2 ms, osContStartReadData man page
    std::mutex g_si_m;
    std::condition_variable g_si_cv;
    std::deque<std::chrono::steady_clock::time_point> g_si_due;   // one entry per kick, in order
    bool g_si_thread_started = false;
}
extern "C" void recomp_si_busy_clear();   // mmio.cpp: SI_STATUS reads idle from this moment
static void si_fire_deferred() {
    std::lock_guard<std::mutex> g(g_si_m);
    g_si_due.push_back(std::chrono::steady_clock::now() + std::chrono::microseconds(kSiDmaUs));
    if (!g_si_thread_started) {
        g_si_thread_started = true;
        std::thread([] {
            std::unique_lock<std::mutex> l(g_si_m);
            for (;;) {
                if (g_si_due.empty()) { g_si_cv.wait(l); continue; }
                const auto due = g_si_due.front();
                if (std::chrono::steady_clock::now() < due) { g_si_cv.wait_until(l, due); continue; }
                g_si_due.pop_front();
                l.unlock();
                recomp_si_busy_clear();              // idle first, so a one-shot busy check after the
                ultramodern::send_si_message();      // recv sees the hardware truth: DMA finished
                l.lock();
            }
        }).detach();
    }
    g_si_cv.notify_one();
}

extern "C" void recomp_si_dma(uint8_t* rdram, uint32_t is_read) {
    uint32_t base = si_dram_addr(rdram);

    // Poll the host input once for this SI transaction.
    recomp_si_poll_all();

    /* ── PIF RAM IS A SEPARATE 64-BYTE MEMORY (hardware contract; measured 2026-08-03) ────────────
     * SI_PIF_WR64 uploads RDRAM -> PIF RAM; SI_PIF_RD64 downloads PIF RAM -> RDRAM. The two kicks
     * may name DIFFERENT RDRAM addresses: a driver can build its command block in one buffer and
     * receive responses into another. We execute the joybus block in place in RDRAM, so without a
     * PIF-side copy the read-back walks whatever happens to sit at the destination.
     * Robotron (LLE controller driver): WR64 at its command buffer answered correctly
     * (channel 0 -> 05 00 01, pak present), then RD64 pointed at a different buffer holding
     * 000000FF... -> no buttons, no pak, forever. sm64 hid this because its libultra reuses one
     * __osContPifRam buffer for both directions.
     * The model: keep a persistent 64-byte PIF image. On a read kick, restore it into the caller's
     * buffer BEFORE the walk (so the commands are there, and the walk refreshes the responses with
     * current input); after either kick, save the block back as the new PIF image. */
    static uint8_t g_pifram[64];
    static bool    g_pifram_valid = false;
    if (is_read && g_pifram_valid) {
        for (uint32_t k = 0; k < 64u; k++) wr8(rdram, base + k, g_pifram[k]);
    }

    /* [siblock] INSTRUMENT (RECOMP_SI_BLOCK_DUMP=1, default inert): the 64-byte PIF command block
     * before and after this kick. Answers, without guessing: does the game's block still describe a
     * controller request on later kicks, and do our responses land where it reads them? Needed
     * because a title that uploads its block ONCE (WR64 x2) and re-reads it thousands of times
     * (RD64) inherits any byte we perturb -- notably the sticky not-present flag (0x40) below. */
    static const int si_blockdump = [] {
        const char* e = std::getenv("RECOMP_SI_BLOCK_DUMP");
        return (e != nullptr && *e != '\0' && *e != '0') ? 1 : 0;
    }();
    static long si_dumped = 0;
    // [siblock] cadence: RECOMP_SI_BLOCK_DUMP_EVERY=N (default 500). Cruis'n 2026-09-01: a 30 s run has
    // ~270 kicks, so the default never shows a post-boot kick; N=50 gives ~5 across the notice screen.
    static const long si_every = [] {
        const char* e = std::getenv("RECOMP_SI_BLOCK_DUMP_EVERY");
        long v = (e != nullptr) ? atol(e) : 500;
        return v > 0 ? v : 500;
    }();
    const bool dump_this = si_blockdump && (si_dumped < 6 || (si_dumped % si_every) == 0);
    if (dump_this) {
        char line[200]; int p = 0;
        for (int k = 0; k < 64; k++) p += snprintf(line + p, sizeof line - (size_t)p, "%02X", rd8(rdram, base + (uint32_t)k));
        fprintf(stderr, "[siblock] #%ld %s PRE  %s\n", si_dumped, is_read ? "RD64" : "WR64", line);
        fflush(stderr);
    }

    // Walk the 64-byte PIF command block in the SI_DRAM_ADDR buffer.
    int channel = 0;
    uint32_t i = 0;
    int guard = 0;
    while (i < 64 && guard++ < 128) {
        uint8_t b = rd8(rdram, base + i);

        if (b == 0xFE) break;             // end of commands
        if (b == 0xFF) { i++; continue; } // padding / alignment filler
        if (b == 0x00) { i++; channel++; continue; } // channel skip
        if (b == 0xFD) { i++; channel++; continue; } // channel reset

        uint8_t tx = b & 0x3Fu;           // mask skip/cmd flag bits
        if (i + 1 >= 64) break;
        uint8_t rx = rd8(rdram, base + i + 1) & 0x3Fu;
        uint32_t cmd_off = i + 2;         // first tx byte (the command id)
        if (cmd_off >= 64) break;
        uint8_t cmd = rd8(rdram, base + cmd_off);
        uint32_t rx_off = cmd_off + tx;   // response bytes follow the tx bytes

        if (channel < 4) {
            if (cmd == 0x00 || cmd == 0xFF) {
                // Controller status / reset query → 3-byte response (type hi/lo, status).
                uint8_t st[3];
                if (recomp_si_controller_status(channel, st)) {
                    for (int k = 0; k < 3 && k < rx && (rx_off + k) < 64; k++) wr8(rdram, base + rx_off + k, st[k]);
                } else {
                    // No controller: set the not-present flag in rx_size (high bit 0x40).
                    wr8(rdram, base + i + 1, (uint8_t)(rd8(rdram, base + i + 1) | 0x40u));
                }
            } else if (cmd == 0x01) {
                // Controller read → 4-byte response (button hi/lo, stick x, stick y).
                uint8_t pad[4];
                if (recomp_si_read_controller(channel, pad)) {
                    for (int k = 0; k < 4 && k < rx && (rx_off + k) < 64; k++) wr8(rdram, base + rx_off + k, pad[k]);
                } else {
                    wr8(rdram, base + i + 1, (uint8_t)(rd8(rdram, base + i + 1) | 0x40u));
                }
            } else if (cmd == 0x02) {
                // Controller-pak READ (READ_MEMPACK): tx = cmd + 2 addr bytes; rx = 32 data + 1 data-CRC.
                // addr packs block<<5 | crc5; the pak serves block addr&0xFFE0 and returns the data CRC.
                uint16_t addr = (uint16_t)(((uint32_t)rd8(rdram, base + cmd_off + 1) << 8) | rd8(rdram, base + cmd_off + 2));
                uint8_t data[32];
                recomp_pak_raw_read(channel, addr, data);
                /* [pakcmd] robotron-class titles do their pak I/O by hand over raw joybus (they link
                 * only osPfsIsPlug), so the osPfs HLE never sees it and [pak] logging stays silent.
                 * Name every raw pak access: which block, and what we served. */
                { static long _n = 0;
                  if (_n++ < 24) { fprintf(stderr, "[pakcmd] READ  ch=%d addr=0x%04X blk=0x%04X tx=%u rx=%u -> %02X%02X%02X%02X crc=%02X\n",
                        channel, addr, (unsigned)(addr & 0xFFE0u), tx, rx, data[0], data[1], data[2], data[3],
                        recomp_pak_data_crc(data)); fflush(stderr); } }
                for (int k = 0; k < 32 && (rx_off + (uint32_t)k) < 64; k++) wr8(rdram, base + rx_off + k, data[k]);
                if (rx_off + 32u < 64u) wr8(rdram, base + rx_off + 32, recomp_pak_data_crc(data));
            } else if (cmd == 0x03) {
                // Controller-pak WRITE (WRITE_MEMPACK): tx = cmd + 2 addr + 32 data; rx = 1 data-CRC echo.
                uint16_t addr = (uint16_t)(((uint32_t)rd8(rdram, base + cmd_off + 1) << 8) | rd8(rdram, base + cmd_off + 2));
                uint8_t data[32];
                for (int k = 0; k < 32; k++) data[k] = (cmd_off + 3u + (uint32_t)k < 64u) ? rd8(rdram, base + cmd_off + 3 + k) : (uint8_t)0;
                recomp_pak_raw_write(channel, addr, data);
                { static long _n = 0;
                  if (_n++ < 24) { fprintf(stderr, "[pakcmd] WRITE ch=%d addr=0x%04X blk=0x%04X tx=%u rx=%u <- %02X%02X%02X%02X crc=%02X\n",
                        channel, addr, (unsigned)(addr & 0xFFE0u), tx, rx, data[0], data[1], data[2], data[3],
                        recomp_pak_data_crc(data)); fflush(stderr); } }
                if (rx_off < 64u) wr8(rdram, base + rx_off, recomp_pak_data_crc(data));
            }
        } else if (channel == 4 && (cmd == 0x00 || cmd == 0xFF || cmd == 0x04 || cmd == 0x05)) {
            // Cartridge joybus channel: the EEPROM save chip. The controller block above answers
            // pads 0-3; without THIS, a raw-PIF title probing its save chip got SILENCE — no
            // response bytes, no not-present flag — and busy-retried forever (banjokazooie boot:
            // ~1kHz PIF storm, 149k SI notes, gfx never starts). Protocol (wire order):
            //   status 0x00/0xFF -> 3 bytes: 0x00, 0x80 (4k) / 0xC0 (16k), 0x00
            //     (libultra __osContGetInitData reads the type low-byte-first -> CONT_EEPROM 0x8000)
            //   0x04 block read  (tx: cmd+block)        -> rx: 8 data bytes
            //   0x05 block write (tx: cmd+block+8 data) -> rx: 1 status byte
            // Policy mirrors eep.cpp's HLE probe: recomp::get_save_type() decides present/size; a
            // non-EEPROM save type answers the not-present flag (0x40 on rx_size) — a definitive
            // "no chip on this cart". Backed by the same save file as the HLE osEeprom* path
            // (save_read/save_write), so raw and HLE access see one EEPROM.
            recomp::SaveType st = recomp::get_save_type();
            bool eep16 = (st == recomp::SaveType::Eep16k || st == recomp::SaveType::AllowAll);
            bool eep4  = (st == recomp::SaveType::Eep4k);
            if (!eep16 && !eep4) {
                wr8(rdram, base + i + 1, (uint8_t)(rd8(rdram, base + i + 1) | 0x40u));
            } else if (cmd == 0x00 || cmd == 0xFF) {
                if (rx >= 1 && rx_off < 64u)      wr8(rdram, base + rx_off + 0, 0x00);
                if (rx >= 2 && rx_off + 1u < 64u) wr8(rdram, base + rx_off + 1, eep16 ? 0xC0 : 0x80);
                if (rx >= 3 && rx_off + 2u < 64u) wr8(rdram, base + rx_off + 2, 0x00);
            } else if (cmd == 0x04) {
                uint8_t block = rd8(rdram, base + cmd_off + 1);
                if (rx_off + 8u <= 64u)
                    save_read(rdram, (int32_t)(0x80000000u | (base + rx_off)), (uint32_t)block * 8u, 8u);
#ifdef _WIN32
                // [eepwho] RECOMP_EEP_WHO=1: which BLOCK is being read, and which native guest
                // function is asking. A game that reads the same block forever is looping on its
                // save-validation path; the RVAs resolve with recompilator/bench/resolve_rva.py.
                {
                    static const bool who = [] { const char* e = std::getenv("RECOMP_EEP_WHO");
                                                 return e != nullptr && e[0] != '0'; }();
                    static std::atomic<uint32_t> _n{0};
                    uint32_t n = _n.fetch_add(1, std::memory_order_relaxed);
                    if (who && n < 12u) {
                        fprintf(stderr, "[eepwho] #%u EEPROM read block=%u -> %02X%02X%02X%02X%02X%02X%02X%02X\n",
                                n, block,
                                rd8(rdram, base + rx_off + 0), rd8(rdram, base + rx_off + 1),
                                rd8(rdram, base + rx_off + 2), rd8(rdram, base + rx_off + 3),
                                rd8(rdram, base + rx_off + 4), rd8(rdram, base + rx_off + 5),
                                rd8(rdram, base + rx_off + 6), rd8(rdram, base + rx_off + 7));
                        HMODULE exe = GetModuleHandleA(nullptr);
                        if (exe != nullptr) {
                            const uintptr_t* sp = (const uintptr_t*)_AddressOfReturnAddress();
                            const uintptr_t* top = (const uintptr_t*)((NT_TIB*)NtCurrentTeb())->StackBase;
                            int found = 0;
                            for (int k = 0; k < 256 && found < 8 && &sp[k] < top; k++) {
                                uintptr_t ret = sp[k];
                                HMODULE m = nullptr;
                                if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                                                       GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                                       (LPCSTR)ret, &m) && m == exe) {
                                    fprintf(stderr, "[eepwho]   #%d RVA=0x%08llX\n", found,
                                            (unsigned long long)(ret - (uintptr_t)exe));
                                    found++;
                                }
                            }
                        }
                        fflush(stderr);
                    }
                }
#endif
            } else if (cmd == 0x05) {
                uint8_t block = rd8(rdram, base + cmd_off + 1);
                // [eeplog 2026-08-27] the SOTE save-validation wall: block writes were landing with
                // byte 7 = 0xFF in the save file. Log every raw block write's actual payload.
                {
                    static int _el = 0;
                    if (_el++ < 40) {
                        fprintf(stderr, "[eeplog] WR block=%u tx=%u rx=%u cmd_off=%u data=", block, tx, rx, cmd_off);
                        for (int eb = 0; eb < 8; eb++) fprintf(stderr, "%02X", rd8(rdram, base + cmd_off + 2u + (uint32_t)eb));
                        fputc(0x0A, stderr);
                        fflush(stderr);
                    }
                }
                if (cmd_off + 10u <= 64u)
                    save_write(rdram, (int32_t)(0x80000000u | (base + cmd_off + 2u)), (uint32_t)block * 8u, 8u);
                if (rx >= 1 && rx_off < 64u) wr8(rdram, base + rx_off, 0x00);
            }
        } else if (channel == 4) {
            // Cartridge joybus channel, any OTHER command — RTC status/read/write (0x06/0x07/0x08)
            // and anything else that could address a cart-bus device we don't carry. No NTSC-U cart
            // shipped a joybus RTC, and SILENCE is never hardware behavior: an unanswered probe is
            // the wall-6 class (banjo EEPROM: no bytes, no flag -> 1kHz PIF retry storm). Answer the
            // NoResponse flag exactly as the PIF does for an absent device — rx byte |= 0x80
            // (reference: mupen64plus pif.c:76 "set NoResponse if no device is connected"; libultra
            // __osContGetInitData reads it back as CONT_NO_RESPONSE_ERROR). Audit batch 2.
            wr8(rdram, base + i + 1, (uint8_t)(rd8(rdram, base + i + 1) | 0x80u));
        }

        channel++;
        i = rx_off + rx;                  // advance past this command's response
    }

    // Save the executed block back as the PIF image (see the PIF-RAM note above). Placed before the
    // CIC-challenge fixup deliberately: the challenge transform is answered per kick from the live
    // block, not replayed from a stale image.
    for (uint32_t k = 0; k < 64u; k++) g_pifram[k] = rd8(rdram, base + k);
    g_pifram_valid = true;

    if (dump_this) {
        char line[200]; int p = 0;
        for (int k = 0; k < 64; k++) p += snprintf(line + p, sizeof line - (size_t)p, "%02X", rd8(rdram, base + (uint32_t)k));
        fprintf(stderr, "[siblock] #%ld %s POST %s\n", si_dumped, is_read ? "RD64" : "WR64", line);
        fflush(stderr);
    }
    si_dumped++;

    // ── CIC-6105 challenge: PIF control byte (RAM 0x3F); bit 0x02 = challenge request. ────────────────
    {
        uint8_t pif_ctrl = rd8(rdram, base + 0x3Fu);
        if (std::getenv("RECOMP_PIF_PROBE")) {
            static FILE* pf = nullptr;
            if (!pf) { const char* p = std::getenv("RECOMP_PIF_PROBE"); pf = fopen((p && *p) ? p : "pif_probe.log", "w"); }
            if (pf) {
                fprintf(pf, "[pif] is_read=%u ctrl=0x%02X", is_read, pif_ctrl);
                if (pif_ctrl & 0x02u) {
                    fprintf(pf, "  *** CIC CHALLENGE (bit 0x02) *** PIF[0x30..0x3E]:");
                    for (int k = 0; k < 15; k++) fprintf(pf, " %02X", rd8(rdram, base + 0x30u + k));
                }
                // [pifcmd 2026-08-28] The probe logged only the CIC challenge byte, so it could not
                // say WHAT a game asks the controller -- and that is the whole question for the
                // Controller-Pak class. Wayne Gretzky shows NO CONTROLLER PAK while osContGetQuery
                // already answers status=0x01 (CONT_CARD_ON) and the game never calls a single
                // osPfs* function, so it must probe the pak through RAW PIF. Decode the command
                // chain: PIF RAM is [tx][rx][cmd][data...] per channel; cmd 0x02 = READ Controller
                // Pak, 0x03 = WRITE, 0x00 = STATUS, 0x01 = read controller. If 0x02 appears and we
                // never answer it with pak data, that is the general defect for raw-SI pak games.
                {
                    fprintf(pf, "  PIF:");
                    for (int k2 = 0; k2 < 64; k2++) fprintf(pf, "%02X", rd8(rdram, base + (uint32_t)k2));
                    int k2 = 0, ch = 0;
                    while (k2 < 62 && ch <= 6) {
                        uint8_t tx = rd8(rdram, base + (uint32_t)k2);
                        if (tx == 0xFEu) break;
                        if (tx == 0xFFu || tx == 0x00u) { k2++; continue; }
                        uint8_t rx  = rd8(rdram, base + (uint32_t)(k2 + 1));
                        uint8_t cmd = rd8(rdram, base + (uint32_t)(k2 + 2));
                        const char* nm = (cmd == 0x00u) ? "STATUS" : (cmd == 0x01u) ? "READCONT"
                                       : (cmd == 0x02u) ? "PAK-READ" : (cmd == 0x03u) ? "PAK-WRITE" : "?";
                        fprintf(pf, "  [ch%d tx=%u rx=%u cmd=0x%02X %s]", ch, (unsigned)(tx & 0x3Fu), (unsigned)(rx & 0x3Fu), (unsigned)cmd, nm);
                        k2 += 2 + (int)(tx & 0x3Fu) + (int)(rx & 0x3Fu);
                        ch++;
                    }
                }
                fprintf(pf, "\n"); fflush(pf);
            }
        }
        if (pif_ctrl & 0x02u) {
            // 30 challenge nibbles live in PIF RAM bytes 0x30..0x3E (hi nibble first); transform + write back.
            uint8_t nib[30];
            for (int k = 0; k < 15; k++) {
                uint8_t byte = rd8(rdram, base + 0x30u + k);
                nib[k * 2]     = (byte >> 4) & 0xf;
                nib[k * 2 + 1] = byte & 0xf;
            }
            cic6105_challenge(nib, 30);
            for (int k = 0; k < 15; k++)
                wr8(rdram, base + 0x30u + k, (uint8_t)((nib[k * 2] << 4) | (nib[k * 2 + 1] & 0xf)));
            wr8(rdram, base + 0x3Fu, (uint8_t)(pif_ctrl & ~0x02u)); // ack: clear the challenge bit
        }
    }

    (void)is_read;
    // Pre-eret gate (mirror pi.cpp): before the fiber world bootstraps there is no bare-metal
    // deliverer (g_ctx null), so fall through to the HLE SI message — the boot waiter is still an
    // HLE thread. Only divert once erets are live.
    if (recomp_baremetal_enabled() && recomp_baremetal_eret_seen()) {
        if (recomp_baremetal_nc_mode()) {
            recomp_si_busy_clear();          // bare-metal lanes stay instantaneous (their own timing)
            recomp_baremetal_note_rawsi();   // NC: idle delivers to NC's SI queue (D_8012D600+0x28) + wakes
        } else {
            // Auto-armed stock-libultra: SI-done = the MI SI bit through the game's own handler
            // (closes the SI-MI-bit generalization gap — note_rawsi never raised it).
            recomp_si_busy_clear();          // bare-metal lanes stay instantaneous (their own timing)
            recomp_baremetal_note_interrupt(0x02);
        }
    } else {
        si_fire_deferred();              // baseline HLE: SI-done ~2 ms after the kick (see [si-busy] above)
    }
}
