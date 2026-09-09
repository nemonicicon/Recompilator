#include "ultramodern/ultra64.h"
#include "ultramodern/ultramodern.hpp"
#include <cassert>
#include <atomic>
#include <chrono>
#include <cstdio>
#include <cstdlib>

static uint32_t sample_rate = 48000;
// cv64 (session 18, Reinhardt): last audio buffer size in stereo frames, used to drive the AI
// interrupt at the true DAC consumption rate (sample_rate / buffer_frames) instead of the 60Hz
// video rate. Updated on every queued buffer.
static std::atomic<uint32_t> last_buffer_frames{ 0 };

static ultramodern::audio_callbacks_t audio_callbacks;

uint32_t ultramodern::get_audio_sample_rate() { return sample_rate; }
uint32_t ultramodern::get_audio_buffer_frames() { return last_buffer_frames.load(); }

void ultramodern::set_audio_callbacks(const ultramodern::audio_callbacks_t& callbacks) {
    audio_callbacks = callbacks;
}

void ultramodern::init_audio() {
    // Pick an initial dummy sample rate; this will be set by the game later to the true sample rate.
    set_audio_frequency(48000);
}

void ultramodern::set_audio_frequency(uint32_t freq) {
    if (audio_callbacks.set_frequency) {
        audio_callbacks.set_frequency(freq);
    }
    sample_rate = freq;
}

void ultramodern::queue_audio_buffer(RDRAM_ARG PTR(int16_t) audio_data_, uint32_t byte_count) {
    // Ensure that the byte count is an integer multiple of samples.
    assert((byte_count & 1) == 0);

    // Calculate the number of samples from the number of bytes.
    uint32_t sample_count = byte_count / sizeof(int16_t);

    // Queue the swapped audio data.
    if (sample_count > 0 && audio_callbacks.queue_samples) {
        last_buffer_frames.store(sample_count / 2); // stereo frames in this buffer
        audio_callbacks.queue_samples(TO_PTR(int16_t, audio_data_), sample_count);
    }
}

// cv64 (session 18, Reinhardt): audio production look-ahead, in VI-frames worth of samples.
// CV64's audio manager is self-regulating: it synthesizes (target - osAiGetLength) each frame, so
// at steady state production == consumption regardless of this value; the offset just sets how
// large a lead (cushion) the game keeps. The upstream default 0.5 ("For Godot") was too small for
// our SDL2 push path → the reported remaining stayed too high on average → the game under-produced
// by ~2% (43200 vs 44100/s) → the SDL queue drained to empty → underrun popping + "slightly slow".
// Confirmed empirically: reporting remaining=0 made it over-produce ("sped up"), proving it adapts.
// A larger look-ahead makes the game keep ~40-50ms of self-produced buffer, eliminating the
// underrun at the source (no silence injection, correct pitch). Tune via [audio_q] queue depth.
float buffer_offset_frames = 4.0f;

// If there's ever any audio popping, check here first. Some games are very sensitive to
// the remaining sample count and reporting a number that's too high here can lead to issues.
// Reporting a number that's too low can lead to audio lag in some games.
uint32_t ultramodern::get_remaining_audio_bytes() {
    // DIAGNOSTIC (2026-07-12, the sustain hunt): RECOMP_AI_REPORT_FULL=1 pins the report
    // high so the game's audio driver always picks its LOW samples-per-frame — reproducing
    // the pinned-core corner ON THE DESKTOP. If the (otherwise clean) desktop develops the
    // sustain artifact under this pin, the osAiGetLength feedback law is convicted (the
    // boot-chain diff caught the command lists diverging exactly with it).
    static const bool report_full = [] {
        const char* e = getenv("RECOMP_AI_REPORT_FULL");
        return e != nullptr && e[0] == '1';
    }();
    if (report_full) {
        return 8000;   // ~2000 samples reported buffered — always above the driver's threshold
    }
    // GPU-less target (2026-07-12): env override for the look-ahead. A small ARM target's audio stack drains
    // SDL's queue in coarse periods, so a VI-phase-locked producer (SM64's 528/HIGH controller)
    // keeps sampling a freshly-filled queue, pins at LOW, and under-produces (~414/s measured
    // deficit -> underruns). A larger look-ahead makes the game hold a bigger self-cushion.
    // Unset = 4.0 exactly as before (desktop behavior unchanged).
    static bool offset_env_read = false;
    if (!offset_env_read) {
        offset_env_read = true;
        if (const char* e = getenv("RECOMP_AI_LOOKAHEAD_FRAMES")) {
            float v = (float)atof(e);
            if (v >= 0.0f && v <= 30.0f) {
                buffer_offset_frames = v;
                fprintf(stderr, "[audio_q] look-ahead override: %.1f VI-frames (RECOMP_AI_LOOKAHEAD_FRAMES)\n", v);
            }
        }
    }
    // Get the number of remaining buffered audio bytes.
    uint32_t buffered_byte_count;
    if (audio_callbacks.get_frames_remaining != nullptr) {
        buffered_byte_count = audio_callbacks.get_frames_remaining() * 2 * sizeof(int16_t);
    }
    else {
        buffered_byte_count = 100;
    }

    // THE AI DRAIN MODEL (established 2026-07-12, by ear on both machines): the real AI
    // register drains on the steady DAC clock; our SDL-queue snapshot moves in coarse
    // device-period steps. SM64's driver reads this value to choose samples-per-frame —
    // the staircase pinned it into a LOW-only corner it never occupies on hardware, and
    // that corner IS the sustain artifact (boot-chain diff caught the command lists
    // diverging; pinning the clean desktop reproduced the artifact). Interpolate the real
    // reading forward at the DAC rate between changes: hardware-shaped feedback, anchored
    // to the true queue so it cannot drift. RECOMP_AI_DRAIN_MODEL=0 disables (A/B).
    static const bool drain_model = [] {
        const char* e = getenv("RECOMP_AI_DRAIN_MODEL");
        return e == nullptr || e[0] != '0';
    }();
    if (drain_model && audio_callbacks.get_frames_remaining != nullptr) {
        static uint32_t anchor_bytes = 0;
        static uint32_t last_raw = 0xFFFFFFFFu;
        static std::chrono::steady_clock::time_point anchor_t;
        auto now = std::chrono::steady_clock::now();
        if (buffered_byte_count != last_raw) {
            last_raw = buffered_byte_count;
            anchor_bytes = buffered_byte_count;
            anchor_t = now;
        }
        double secs = std::chrono::duration<double>(now - anchor_t).count();
        double drained = secs * (double)sample_rate * 2.0 * (double)sizeof(int16_t);
        buffered_byte_count = (drained >= (double)anchor_bytes)
                            ? 0u : anchor_bytes - (uint32_t)drained;
    }
    // Adjust the reported count to be some number of refreshes in the future, which helps ensure that
    // there are enough samples even if the audio thread experiences a small amount of lag. This prevents
    // audio popping on games that use the buffered audio byte count to determine how many samples
    // to generate.
    uint32_t samples_per_vi = (sample_rate / 60);
    if (buffered_byte_count > static_cast<uint32_t>(buffer_offset_frames * sizeof(int16_t) * samples_per_vi)) {
        buffered_byte_count -= static_cast<uint32_t>(buffer_offset_frames * sizeof(int16_t) * samples_per_vi);
    }
    else {
        buffered_byte_count = 0;
    }
    return buffered_byte_count;
}

// The real N64 AI holds a 2-entry DMA FIFO; AI_STATUS_FIFO_FULL (bit 31) asserts while both entries
// are occupied and clears as each buffer drains at the DAC rate. Raw-MMIO-AI games read AI_STATUS
// directly and SPIN on this bit, only synthesizing+queuing the next buffer once a slot frees — that
// spin is the game's own hardware-accurate pacing to the DAC consumption rate. Army Men: Sarge's
// Heroes paces this way (it never calls osAiGetLength/osAiGetStatus). Our MMIO layer had AI_STATUS
// hard-wired to 0 ("never full"), so the spin never blocked and the game queued one buffer per 60Hz
// video retrace (~33k frames/s) instead of the ~22k DAC rate -> music ran ~1.5x too fast while
// gameplay stayed correct. Model the FIFO from the live device backlog: full when >= 2 buffers of
// audio remain un-drained. The exact threshold only sets steady-state latency, not the rate — once
// the bit engages at any sane backlog, the game's spin self-paces production to the drain rate.
bool ultramodern::audio_fifo_full() {
    uint32_t buf = last_buffer_frames.load();
    if (buf == 0) {
        return false; // nothing queued yet -> the FIFO has room
    }
    uint32_t remaining_frames = (audio_callbacks.get_frames_remaining != nullptr)
        ? static_cast<uint32_t>(audio_callbacks.get_frames_remaining())
        : 0u;
    return remaining_frames >= 2u * buf;
}
