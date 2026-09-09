#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cctype>
#include <chrono>
#include <string>
#include <sstream>
#include <vector>
#include <thread>
#include <mutex>
#include <condition_variable>

#include "ultramodern/input.hpp"
#include "ultramodern/ultra64.h"
#include "ultramodern/ultramodern.hpp"

// SI COMPLETIONS TAKE JOYBUS TIME (NC RUN 26; the SI analog of the SP-task pacing fix,
// events.cpp RECOMP_SP_TASK_US). A real controller read is a serial PIF transaction
// (~136µs/pad, ~600µs for a 4-pad frame); the HLE completed it INSTANTLY, so a game's SI
// service loop (kick read -> blocking recv -> loop) free-runs at host speed and its thread
// starves everything below it in the cooperative scheduler (NC: the pri-15 SI thread spun
// ~100k cycles/s and the pri-10 main thread never ran again). Deliver SI-done after an
// emulated joybus-busy interval on a single deadline thread — while the game thread blocks
// in its recv, lower-priority threads run, exactly the hardware timeline.
// RECOMP_SI_BUSY_US overrides the interval (µs; 0 = legacy instant).
namespace {
    std::mutex si_pace_mutex;
    std::condition_variable si_pace_cv;
    int si_pace_pending = 0;
    bool si_pace_thread_started = false;

    long long si_busy_us() {
        static const long long v = [] {
            const char* e = std::getenv("RECOMP_SI_BUSY_US");
            return e ? atoll(e) : 500LL;
        }();
        return v;
    }

    void si_pace_thread_main() {
        std::unique_lock<std::mutex> lk(si_pace_mutex);
        for (;;) {
            si_pace_cv.wait(lk, [] { return si_pace_pending > 0; });
            // [si-pace-count 2026-09-04, Forsaken 64] ONE SI-done per kick. This used to zero the pending
            // count on wake, so two kicks issued inside one busy interval (a query and a read back to
            // back, or two threads' reads) collapsed into a single completion: the second kicker's
            // osRecvMesg then waited forever. Hardware runs every joybus transaction and interrupts for
            // each. Drain the count one message per interval, in order.
            si_pace_pending--;
            lk.unlock();
            std::this_thread::sleep_for(std::chrono::microseconds(si_busy_us()));
            ultramodern::send_si_message();
            lk.lock();
        }
    }

    void send_si_message_paced() {
        if (si_busy_us() <= 0) {
            ultramodern::send_si_message();
            return;
        }
        std::lock_guard<std::mutex> lk(si_pace_mutex);
        if (!si_pace_thread_started) {
            si_pace_thread_started = true;
            std::thread(si_pace_thread_main).detach();
        }
        si_pace_pending++;
        si_pace_cv.notify_one();
    }
}

#define PFS_ERR_NOPACK          1   // no device inserted
#define PFS_ERR_CONTRFAIL       4   // data transmission failure
#define PFS_ERR_INVALID         5   // invalid parameter or invalid file
#define PFS_ERR_DEVICE          11  // different type of device inserted

#define PFS_INITIALIZED         1
#define PFS_CORRUPTED           2
#define PFS_ID_BROKEN           4
#define PFS_MOTOR_INITIALIZED   8
#define PFS_GBPAK_INITIALIZED   16

static ultramodern::input::callbacks_t input_callbacks {};

void ultramodern::input::set_callbacks(const callbacks_t& callbacks) {
    input_callbacks = callbacks;
}

static std::chrono::high_resolution_clock::time_point input_poll_time;

static void update_poll_time() {
    input_poll_time = std::chrono::high_resolution_clock::now();
}

void ultramodern::measure_input_latency() {
#if 0
    printf("Delta: %ld micros\n", std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::high_resolution_clock::now() - input_poll_time));
#endif
}

#define MAXCONTROLLERS 4

#define CONT_NO_RESPONSE_ERROR 0x8

#define CONT_TYPE_NORMAL 0x0005
#define CONT_TYPE_MOUSE  0x0002
#define CONT_TYPE_VOICE  0x0100

// Default to all channels live. The HLE controller-read surface (osContGetReadData) gates its
// per-channel loop on this; per-channel get_input()/get_connected_device_info() already report
// which ports are actually present, so reading all 4 by default is faithful. It was 0, which
// assumed the engine's own osContInit() always runs first to raise it — but a cart whose
// osContInit is SDK-divergent runs RAW (e.g. Wave Race 64), never calls the engine native, leaves
// this 0, and osContGetReadData loops zero times -> get_input never called -> dead input despite a
// working bridge. osContSetCh() still narrows it for games that ask. (General engine fix.)
static int max_controllers = MAXCONTROLLERS;

/* Plain controller */

static u16 get_controller_type(ultramodern::input::Device device_type) {
    switch (device_type) {
    case ultramodern::input::Device::None:
        return 0;

    case ultramodern::input::Device::Controller:
        return CONT_TYPE_NORMAL;

#if 0
    case ultramodern::input::Device::Mouse:
        return CONT_TYPE_MOUSE;

    case ultramodern::input::Device::VRU:
        return CONT_TYPE_VOICE;
#endif
    }

    return 0;
}

// Engine-level accessory-slot virtualization.
//
// The N64 controller has a SINGLE accessory slot that can hold a Controller Pak (mempak),
// a Rumble Pak, or a Transfer Pak — never two at once. Every app frontend currently returns
// Pak::None for port 0 (the scaffold template never wired a pak), so without this default no
// game would ever see a Controller Pak and the entire osPfs/mempak-save class (Fox Sports
// College Hoops and friends) would fail with "Insert the Controller Pak".
//
// To make saves work everywhere WITHOUT editing the 80 app frontends, the engine treats an
// unspecified slot (Pak::None) as if a Controller Pak were inserted, for the purpose of the
// device-status / accessory-presence queries (osContGetQuery/osContInit status bit, raw-SI
// status). A frontend that explicitly reports RumblePak/ControllerPak/TransferPak overrides
// this default and is honored verbatim.
//
// [motorslot 2026-09-06] osMotorInit() routes through this helper TOO, so the port carries exactly
// one accessory. It used to answer the same unspecified slot as a working Rumble Pak while this
// helper answered it as a Controller Pak; a game that arbitrates by calling osMotorInit first then
// concluded there was no Controller Pak and refused to save with no pak traffic at all (Superman
// #106). Only an explicitly declared RumblePak takes a motor now; an unspecified slot is a
// Controller Pak everywhere, and a motor request against it gets PFS_ERR_DEVICE, exactly as a
// console with a Controller Pak fitted does.
static ultramodern::input::Pak effective_status_pak(const ultramodern::input::connected_device_info_t& info) {
    if (info.connected_device == ultramodern::input::Device::None) {
        return ultramodern::input::Pak::None;
    }
    if (info.connected_pak == ultramodern::input::Pak::None) {
        // Unspecified slot → default to a Controller Pak so mempak saves are detected.
        return ultramodern::input::Pak::ControllerPak;
    }
    return info.connected_pak;
}

static void __osContGetInitData(u8* pattern, OSContStatus *data) {
    *pattern = 0x00;

    for (int controller = 0; controller < max_controllers; controller++) {
        ultramodern::input::connected_device_info_t device_info{};

        if (input_callbacks.get_connected_device_info != nullptr) {
            device_info = input_callbacks.get_connected_device_info(controller);
        }

        if (device_info.connected_device != ultramodern::input::Device::None) {
            // Mark controller as present

            data[controller].type = get_controller_type(device_info.connected_device);
            data[controller].status = effective_status_pak(device_info) != ultramodern::input::Pak::None;
            data[controller].err_no = 0x00;

            *pattern |= 1 << controller;
        }
        else {
            // Mark controller as not connected

            // Libultra doesn't write status or type for absent controllers
            data[controller].err_no = CONT_NO_RESPONSE_ERROR; // CHNL_ERR_NORESP >> 4
        }
    }
}

extern "C" s32 osContInit(RDRAM_ARG PTR(OSMesgQueue) mq, u8* bitpattern, PTR(OSContStatus) data_) {
    OSContStatus *data = TO_PTR(OSContStatus, data_);

    max_controllers = MAXCONTROLLERS;

    __osContGetInitData(bitpattern, data);

    return 0;
}

extern "C" s32 osContReset(RDRAM_ARG PTR(OSMesgQueue) mq, PTR(OSContStatus) data) {
    assert(false);
    return 0;
}

extern "C" s32 osContStartQuery(RDRAM_ARG PTR(OSMesgQueue) mq) {
    send_si_message_paced();   // joybus-busy pacing (see top of file)

    return 0;
}

// ── Raw-SI support (used by si.cpp for games that drive the SI DMA registers directly, bypassing
//    osContStartReadData — e.g. Killer Instinct Gold). Polls the host input ONCE for all channels,
//    then per-channel queries report live button/stick state in the joybus wire format. ───────────
extern "C" void recomp_si_poll_all() {
    if (input_callbacks.poll_input != nullptr) {
        input_callbacks.poll_input();
    }
    update_poll_time();
}

// Fills the standard N64 controller-read response (4 bytes: button_hi, button_lo, stick_x, stick_y).
// Returns 1 if the controller responded, 0 if absent (caller sets the no-response error bit).
// ── SCRIPTED INPUT (2026-08-29) ────────────────────────────────────────────────────────────────
// Every one of the 296 games needs a button press to get off its title/attract screen, and the
// bench runs unattended. Without this, an automated run can only ever observe the attract loop —
// which is exactly where KI Gold was freezing, with no way to test whether the freeze is even
// reachable once you skip past it.
//
//   RECOMP_INPUT_SCRIPT="START@20,A@25.5,START@31"   button@seconds (float ok), OR'd into ch 0
//   RECOMP_INPUT_SCRIPT_HOLD_MS=250                  how long each press is held (default 250)
//
// RELATIONSHIP TO THE EXISTING `RECOMP_AUTOPRESS` — READ BEFORE ADDING A THIRD ONE.
// SOTE already has an autopress, but it lives PER-GAME in `shadowspc/src/input.cpp` and takes a
// completely different contract: `RECOMP_AUTOPRESS=1` is a FLAG, with `RECOMP_AP_MASK`
// (a/s/b/p) and `RECOMP_AP_SECS` selecting a spam pattern (A every 30 ticks, START every ~4s,
// 'p' releases everything after N seconds so a screenshot lands in-level). Deliberately NOT
// reusing that name: same word, different semantics, and one of them silently doing nothing is
// exactly the class of trap this project keeps getting bitten by. This one is at the SI layer in
// the SHARED engine, so it serves every game rather than one; the shadowspc copy should
// eventually be retired in favour of it (its spam-pattern modes are the part worth porting).
//
// Held for a real span, not one frame: a game polling at 60Hz can miss a single-frame press, and a
// press that lands between polls is indistinguishable from a broken input path. Channel 0 only.
// Inert unless set, so baseline runs are byte-identical.
namespace {
    struct ScriptedPress { uint16_t mask; double at_s; bool logged;     int  reads = 0;    // [sticky-press] how many times the game has sampled this press
    bool done  = false; // [sticky-press] released (hold elapsed AND sampled >= MIN_READS)
};

    uint16_t autopress_mask_for(const std::string& name) {
        if (name == "A")     return 0x8000; if (name == "B")     return 0x4000;
        if (name == "Z")     return 0x2000; if (name == "START") return 0x1000;
        if (name == "DU")    return 0x0800; if (name == "DD")    return 0x0400;
        if (name == "DL")    return 0x0200; if (name == "DR")    return 0x0100;
        if (name == "L")     return 0x0020; if (name == "R")     return 0x0010;
        if (name == "CU")    return 0x0008; if (name == "CD")    return 0x0004;
        if (name == "CL")    return 0x0002; if (name == "CR")    return 0x0001;
        return 0;
    }

    std::vector<ScriptedPress>& autopress_script() {
        static std::vector<ScriptedPress> script = [] {
            std::vector<ScriptedPress> out;
            const char* e = std::getenv("RECOMP_INPUT_SCRIPT");
            if (e == nullptr) return out;
            std::string s(e), tok;
            std::stringstream ss(s);
            while (std::getline(ss, tok, ',')) {
                size_t at = tok.find('@');
                if (at == std::string::npos) continue;
                std::string name = tok.substr(0, at);
                for (char& c : name) c = (char)toupper((unsigned char)c);
                uint16_t m = autopress_mask_for(name);
                if (m == 0) { fprintf(stderr, "[inputscript] UNKNOWN button '%s' (ignored)\n", name.c_str()); continue; }
                out.push_back({ m, atof(tok.c_str() + at + 1), false });
            }
            if (!out.empty()) {
                fprintf(stderr, "[inputscript] armed: %zu press(es)\n", out.size());
                fflush(stderr);
            }
            return out;
        }();
        return script;
    }

    uint16_t autopress_active_buttons() {
        auto& script = autopress_script();
        if (script.empty()) return 0;
        static const double hold_s = [] {
            const char* h = std::getenv("RECOMP_INPUT_SCRIPT_HOLD_MS");
            double ms = (h != nullptr) ? atof(h) : 250.0;
            return (ms > 0.0 ? ms : 250.0) / 1000.0;
        }();
        // [sticky-press 2026-09-01, Cruis'n USA] A press is only a press if the GAME SAMPLES it and then
        // sees it released. A title that polls its pad slowly (Cruis'n's notice screen: ~3 Hz, and
        // irregularly) missed every 250 ms tap; a START held from boot (measured: PIF block answered
        // 0x1000 from the first read) never made an edge, so the notice never advanced. Each press now
        // stays down until BOTH the hold time has elapsed AND the game has read it at least MIN_READS
        // times (default 3), then releases. Fast pollers (60 Hz) see exactly the old behaviour.
        static const int min_reads = [] {
            const char* m = std::getenv("RECOMP_INPUT_SCRIPT_MIN_READS");
            int v = (m != nullptr) ? atoi(m) : 3;
            return v > 0 ? v : 3;
        }();
        static const auto t0 = std::chrono::steady_clock::now();
        const double now = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
        uint16_t mask = 0;
        for (auto& p : script) {
            if (p.done || now < p.at_s) continue;
            mask |= p.mask;
            p.reads++;
            if (!p.logged) {
                p.logged = true;
                fprintf(stderr, "[inputscript] t=%.2fs pressing 0x%04X\n", now, (unsigned)p.mask);
                fflush(stderr);
            }
            if (now >= p.at_s + hold_s && p.reads >= min_reads) {
                p.done = true;
                fprintf(stderr, "[inputscript] t=%.2fs released 0x%04X after %d read(s)\n", now, (unsigned)p.mask, p.reads);
                fflush(stderr);
            }
        }
        return mask;
    }
}

extern "C" int recomp_si_read_controller(int channel, uint8_t* out4) {
    if (channel < 0 || channel >= MAXCONTROLLERS) { return 0; }
    uint16_t buttons = 0; float x = 0.0f, y = 0.0f;
    bool got = false;
    if (input_callbacks.get_input != nullptr) {
        got = input_callbacks.get_input(channel, &buttons, &x, &y);
    }
    // Scripted press: OR'd in on channel 0. Also synthesizes a response when no real controller
    // answered, so an unattended run with no pad attached can still drive the game.
    if (channel == 0) {
        const uint16_t scripted = autopress_active_buttons();
        if (scripted != 0) { buttons |= scripted; got = true; }
    }
    if (!got) { return 0; }
    float sx = 80.0f * x, sy = 80.0f * y;
    if (sx >  80.0f) sx =  80.0f; else if (sx < -80.0f) sx = -80.0f;
    if (sy >  80.0f) sy =  80.0f; else if (sy < -80.0f) sy = -80.0f;
    out4[0] = (uint8_t)(buttons >> 8);
    out4[1] = (uint8_t)(buttons & 0xFF);
    out4[2] = (uint8_t)(int8_t)sx;
    out4[3] = (uint8_t)(int8_t)sy;
    return 1;
}

// Reports controller presence + type (joybus status: 3 bytes type_hi, type_lo, status). Returns 1
// if a device is connected on this channel.
extern "C" int recomp_si_controller_status(int channel, uint8_t* out3) {
    if (channel < 0 || channel >= MAXCONTROLLERS) { return 0; }
    ultramodern::input::connected_device_info_t info{};
    if (input_callbacks.get_connected_device_info != nullptr) {
        info = input_callbacks.get_connected_device_info(channel);
    }
    if (info.connected_device == ultramodern::input::Device::None) { return 0; }
    uint16_t type = get_controller_type(info.connected_device);
    // Joybus controller-info response transmits the 16-bit type LOW byte first: libultra (and SI's
    // inlined decode at func_8005CE4C) reads `type = unk05<<8 | unk04`, so byte0 = type_lo, byte1 = type_hi.
    // Emitting it hi-first made a standard controller decode as 0x0500 instead of 0x0005, so raw-SI titles
    // (Space Invaders) rejected it with "controller not fully inserted". (Baseline games use the libultra
    // osCont HLE and never serialize joybus bytes, so they never reach this path.)
    out3[0] = (uint8_t)(type & 0xFF);   // unk04 = type low  (0x05 for a standard controller)
    out3[1] = (uint8_t)(type >> 8);     // unk05 = type high (0x00)
    /* [sitype] PROBE (RECOMP_SI_TYPE_SWAP=1, default inert): the low-first order above was tuned to
     * satisfy Space Invaders; whether every raw-SI title agrees is untested. Instrument only. */
    {
        static const bool swap_type = [] {
            const char* e = std::getenv("RECOMP_SI_TYPE_SWAP");
            return e != nullptr && *e != '\0' && *e != '0';
        }();
        if (swap_type) { uint8_t t = out3[0]; out3[0] = out3[1]; out3[1] = t; }
    }
    out3[2] = (uint8_t)(effective_status_pak(info) != ultramodern::input::Pak::None ? 1 : 0);
    /* [sistatus] PROBE (RECOMP_SI_STATUS_BITS=<hex>, default inert): OR extra bits into the joybus
     * controller status byte. Robotron's own osPfsIsPlug tests `status & 0x04`, not the 0x01
     * pak-present bit we set, so which bit a real pad asserts here is an empirical question -- and
     * the game answers it for us: accept the pak and it starts issuing 0x02 reads ([pakcmd]).
     * Instrument only; the finding becomes a default, never an env-gated behaviour. */
    {
        static const int extra = [] {
            const char* e = std::getenv("RECOMP_SI_STATUS_BITS");
            return (e != nullptr && *e != '\0') ? (int)strtol(e, nullptr, 16) : 0;
        }();
        if (extra) out3[2] = (uint8_t)(out3[2] | (uint8_t)extra);
    }
    return 1;
}

extern "C" int  recomp_baremetal_enabled();
extern "C" int  recomp_baremetal_eret_seen();
extern "C" void recomp_baremetal_note_si_mq(uint32_t mq);

extern "C" s32 osContStartReadData(RDRAM_ARG PTR(OSMesgQueue) mq) {
    { static int _n=0; if (_n++ < 10) { fprintf(stderr, "[cont] osContStartReadData mq=0x%08X\n", (uint32_t)mq); fflush(stderr); } }
    if (input_callbacks.poll_input != nullptr) {
        input_callbacks.poll_input();
    }
    update_poll_time();

    // PRE-ERET GATE (same invariant as pi.cpp/si.cpp/scheduling.cpp, NC RUN 26): the bare-metal
    // ring delivery below is consumed by the fiber idle, which is a NO-OP until the first eret.
    // A hybrid title (baremetal envs set, HLE threads serving) that reads the controller pre-eret
    // would have its SI completion black-holed — NC's t=8 SI thread parked forever on 0x8012D248
    // and the boot wedged in its loading poll. Divert only once erets are live.
    if (recomp_baremetal_enabled() && recomp_baremetal_eret_seen()) {
        // Bare-metal (NC class): NC registered the SI/controller-done event in its OWN event table (not via
        // the HLE osSetEventMesg), so events_context.si.mq is NULL and send_si_message can't deliver. Record
        // the queue NC passed to osContStartReadData; the bare-metal idle delivers the SI completion into
        // its ring AND runs NC's wait-list wake (same mechanism as the PI overlay-load completion). Baseline
        // HLE games never enable bare-metal and keep the plain send_si_message path below.
        recomp_baremetal_note_si_mq((uint32_t)mq);
    } else {
        send_si_message_paced();   // joybus-busy pacing (see top of file)
    }

    return 0;
}

extern "C" s32 osContSetCh(RDRAM_ARG u8 ch) {
    max_controllers = std::min(ch, u8(MAXCONTROLLERS));

    return 0;
}

extern "C" void osContGetQuery(RDRAM_ARG PTR(OSContStatus) data_) {
    OSContStatus *data = TO_PTR(OSContStatus, data_);
    u8 pattern;

    __osContGetInitData(&pattern, data);
}

extern "C" void osContGetReadData(OSContPad *data) {
    for (int controller = 0; controller < max_controllers; controller++) {
        uint16_t buttons = 0;
        float x = 0.0f;
        float y = 0.0f;
        bool got_response = false;

        if (input_callbacks.get_input != nullptr) {
            got_response = input_callbacks.get_input(controller, &buttons, &x, &y);
        }

        if (got_response) {
            data[controller].button = buttons;
            // N64 analog stick range is -80..+80 (see OSContPad, ultra64.h:250). CV64's
            // player locomotion is calibrated for that range and treats out-of-range
            // values as invalid → was scaling by 127, so a full deflection (127) read as
            // "no input" → the player couldn't walk (buttons/camera still worked because
            // they go through a separate path). Scale to 80 and clamp.
            float sx = 80.0f * x, sy = 80.0f * y;
            if (sx >  80.0f) sx =  80.0f; else if (sx < -80.0f) sx = -80.0f;
            if (sy >  80.0f) sy =  80.0f; else if (sy < -80.0f) sy = -80.0f;
            data[controller].stick_x = (int8_t)sx;
            data[controller].stick_y = (int8_t)sy;
            data[controller].err_no = 0;
            // Capped diagnostic: SDL LEFT stick on FIRM pushes only (|axis|>20), so we capture real
            // left/right + up/down deflections instead of the resting drift filling the budget.
            if (controller == 0 && (data[controller].stick_x > 20 || data[controller].stick_x < -20 ||
                                    data[controller].stick_y > 20 || data[controller].stick_y < -20)) {
                static int _stk = 0;
                if (_stk++ < 60) fprintf(stderr, "[stick] x=%.2f y=%.2f -> sx=%d sy=%d\n",
                    x, y, data[controller].stick_x, data[controller].stick_y);
            }
        } else {
            data[controller].err_no =  CONT_NO_RESPONSE_ERROR; // CHNL_ERR_NORESP >> 4
        }
    }
}

/* Rumble */

s32 osMotorInit(RDRAM_ARG PTR(OSMesgQueue) mq, PTR(OSPfs) pfs_, int channel) {
    OSPfs *pfs = TO_PTR(OSPfs, pfs_);

    // basic initialization performed regardless of connected/disconnected status
    pfs->queue = mq;
    pfs->channel = channel;
    pfs->activebank = 0xFF;
    pfs->status = 0;

    ultramodern::input::connected_device_info_t device_info{};
    if (input_callbacks.get_connected_device_info != nullptr) {
        device_info = input_callbacks.get_connected_device_info(channel);
    }

    if (device_info.connected_device != ultramodern::input::Device::Controller) {
        return PFS_ERR_CONTRFAIL;
    }
    // [motorslot 2026-09-06, Superman #106] ONE ACCESSORY PER PORT. A controller port holds exactly
    // one accessory; hardware cannot answer "Controller Pak" to a save query and "Rumble Pak" to a
    // motor query at the same instant. This function used to answer an unspecified slot (Pak::None —
    // what every current app frontend reports) as a working Rumble Pak while effective_status_pak()
    // answered the same slot as a Controller Pak, so the port held two devices at once. Games that
    // arbitrate with osMotorInit FIRST read that as "a Rumble Pak is in the port", conclude there is
    // no Controller Pak, and refuse to save without ever issuing one pak command — Superman's save
    // init (0x80002E80) does exactly this: osPfsIsPlug reports the pak present, osMotorInit returning
    // 0 then makes it substitute PFS_ERR_NOPACK (1) for the osPfsInitPak call it never makes, and its
    // 12-entry PFS-error jump table sends every code but 0 to the "NO CONTROLLER PAK" arm.
    // Resolve the slot through the SAME helper every other accessory query uses, so the port carries
    // one device: only an explicitly declared Rumble Pak takes a motor; an unspecified slot is the
    // Controller Pak that osPfs/save queries already see, and a motor request against it gets the
    // real-hardware "different type of device inserted" result. Rumble is optional hardware — a game
    // whose osMotorInit fails behaves exactly as it does on a console with a Controller Pak fitted.
    if (effective_status_pak(device_info) != ultramodern::input::Pak::RumblePak) {
        return PFS_ERR_DEVICE;
    }

    pfs->status = PFS_MOTOR_INITIALIZED;
    return 0;
}

s32 osMotorStop(RDRAM_ARG PTR(OSPfs) pfs) {
    return __osMotorAccess(PASS_RDRAM pfs, false);
}

s32 osMotorStart(RDRAM_ARG PTR(OSPfs) pfs) {
    return __osMotorAccess(PASS_RDRAM pfs, true);
}

s32 __osMotorAccess(RDRAM_ARG PTR(OSPfs) pfs_, s32 flag) {
    OSPfs *pfs = TO_PTR(OSPfs, pfs_);

    if (!(pfs->status & PFS_MOTOR_INITIALIZED)) {
        return PFS_ERR_INVALID;
    }

    if (input_callbacks.set_rumble != nullptr) {
        input_callbacks.set_rumble(pfs->channel, flag);
    }

    return 0;
}

