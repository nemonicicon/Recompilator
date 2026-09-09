/**
 * audio.cpp â€” SDL2 push-mode audio backend for SM64PC.
 *
 * SM64 uses Konami's custom audio sequencer running at 32 kHz.
 * We use SDL_QueueAudio (push mode, no callback) to keep latency low.
 */

#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <algorithm>
#include <chrono>
#include <vector>

#include "SDL.h"
#include "ultramodern/ultramodern.hpp"

// Audio device handle.
static SDL_AudioDeviceID audio_device = 0;
static uint32_t current_freq = 32000;

// Number of output channels (always stereo).
static constexpr int OUTPUT_CHANNELS = 2;

// Convert 16-bit N64 PCM to float32 and push to SDL.
//
// The runtime calls queue_samples(ptr, sample_count) where:
//   ptr          = pointer into RDRAM at the AI DMA source address
//   sample_count = total number of int16_t values (interleaved L+R)
//                  = 2 Ã— number of stereo pairs
//
// N64 AI DMA format (big-endian, interleaved):
//   [L_HI, L_LO, R_HI, R_LO, L_HI, L_LO, R_HI, R_LO, ...]
// Read as int16_t on little-endian x86, each element has its bytes swapped
// relative to the intended signed value, so we byte-swap each sample.
void sm64_queue_samples(int16_t* audio_data, size_t sample_count) {
    // Log first call and every 256th to trace bad pointers.
    static std::atomic<uint32_t> qs_count{0};
    uint32_t qn = qs_count.fetch_add(1, std::memory_order_relaxed);
    if (qn < 4 || (qn & 255) == 0) {
        fprintf(stderr, "[audio] queue_samples #%u: audio_data=%p sample_count=%zu device=%u\n",
                qn, (void*)audio_data, sample_count, audio_device);
        fflush(stderr);
    }

    if (!audio_device) return;

    // sample_count is the total int16_t count; stereo pairs = sample_count / 2.
    size_t pair_count = sample_count / 2;
    if (pair_count == 0) return;

    // SM64 (session 18, Reinhardt): cushion + production-rate measurement.
    // (1) Prime an ~80ms silence cushion on the FIRST real audio buffer (not at device-open,
    //     where it drains during boot before music starts). (2) Measure the effective production
    //     rate (frames pushed per real second) to compare against the device rate: if it reads
    //     ~43200 vs device 44100 it's a ~2% frame-timing deficit; if much lower it's a rate bug.
    {
        static bool primed = false;
        static std::chrono::steady_clock::time_point t0;
        static uint64_t total_frames = 0;
        static uint64_t last_log_frames = 0;
        if (!primed) {
            primed = true;
            t0 = std::chrono::steady_clock::now();
            // SM64 (session 18): cushion REMOVED â€” it sat in the SDL queue and inflated
            // get_frames_remaining(), telling the game more was buffered so it produced LESS,
            // worsening the deficit (940â†’1004/s). Production pacing is the real lever, not a cushion.
        }
        total_frames += pair_count;
        if (total_frames - last_log_frames >= (uint64_t)current_freq) { // ~once per second of audio
            last_log_frames = total_frames;
            double secs = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
            double prod_rate = secs > 0 ? (double)total_frames / secs : 0;
            fprintf(stderr, "[audio_rate] produced %llu frames in %.2fs = %.0f frames/s (device=%uHz, deficit=%.0f/s)\n",
                    (unsigned long long)total_frames, secs, prod_rate, current_freq, (double)current_freq - prod_rate);
            fflush(stderr);
        }
    }

    // Latency management: skip if we're absurdly far ahead. GPU-less target (2026-07-12): raised from
    // ~150ms-at-32k to 250ms at the CURRENT device rate — the look-ahead cushion
    // (RECOMP_AI_LOOKAHEAD_FRAMES) must never collide with this ceiling, or the drops it causes
    // ARE the popping. The ceiling only bounds runaway latency; the game's own controller is the
    // real regulator.
    const uint32_t MAX_QUEUED_BYTES = current_freq * OUTPUT_CHANNELS * sizeof(float) / 4; // 250ms
    // [audio_q] once/sec: min/max queued frames since last line + drops. THE number for the audio
    // hunt: min near 0 = underrun territory (the crackle); max near the ceiling = drop territory.
    {
        static uint32_t q_min = UINT32_MAX, q_max = 0, q_drops = 0;
        static std::chrono::steady_clock::time_point q_t0 = std::chrono::steady_clock::now();
        uint32_t q_frames = SDL_GetQueuedAudioSize(audio_device) / (OUTPUT_CHANNELS * sizeof(float));
        if (q_frames < q_min) q_min = q_frames;
        if (q_frames > q_max) q_max = q_frames;
        bool drop = SDL_GetQueuedAudioSize(audio_device) > MAX_QUEUED_BYTES;
        if (drop) q_drops++;
        double q_secs = std::chrono::duration<double>(std::chrono::steady_clock::now() - q_t0).count();
        if (q_secs >= 1.0) {
            fprintf(stderr, "[audio_q] depth min=%u max=%u frames (%.0f..%.0f ms) drops=%u\n",
                    q_min, q_max, q_min * 1000.0 / current_freq, q_max * 1000.0 / current_freq, q_drops);
            fflush(stderr);
            q_min = UINT32_MAX; q_max = 0; q_drops = 0;
            q_t0 = std::chrono::steady_clock::now();
        }
        if (drop) {
            return;
        }
    }

    // Grow the conversion buffer as needed.
    static float* float_buf = nullptr;
    static size_t float_buf_pairs = 0;
    if (pair_count > float_buf_pairs) {
        free(float_buf);
        float_buf = (float*)malloc(pair_count * OUTPUT_CHANNELS * sizeof(float));
        float_buf_pairs = pair_count;
    }

    // SM64 (session 18, Reinhardt): FIX for "loud static". `audio_data` points straight into the
    // recompiler's RDRAM, which stores every byte at host index (addr ^ 3) (N64 big-endian on a
    // little-endian host). Reading it as a flat int16_t array is WRONG twice over: the ^3 swizzle
    // SWAPS adjacent samples within each 4-byte word, and the old per-int16 byte-swap then
    // corrupted values that the ^3 read already returns correctly. Net result was scrambled
    // samples = loud static (the real waveform only faintly audible). The [pcm] probe in
    // librecomp/ai.cpp reads the SAME buffer per-byte with ^3 and sees a clean, smooth waveform.
    // Read each sample identically here: sample s[k] = byte[(2k)^3]<<8 | byte[(2k+1)^3].
    // (The AI buffer base is 4-aligned, so ^3 distributes correctly from this pointer.)
    const uint8_t* b = reinterpret_cast<const uint8_t*>(audio_data);
    auto read_sample = [&](size_t k) -> int16_t {
        size_t off = 2 * k;
        uint8_t hi = b[off ^ 3];
        uint8_t lo = b[(off + 1) ^ 3];
        return (int16_t)((uint16_t)hi << 8 | (uint16_t)lo);
    };
    for (size_t i = 0; i < pair_count; i++) {
        int16_t l = read_sample(2 * i + 0);
        int16_t r = read_sample(2 * i + 1);
        float_buf[i * 2 + 0] = l / 32768.0f;
        float_buf[i * 2 + 1] = r / 32768.0f;
    }

    // PCM tap (2026-07-12 Peach hunt): RECOMP_PCM_DUMP=<path> appends the exact int16 stereo
    // stream handed to SDL (post-RDRAM-read, pre-float). Splits the chain mechanically:
    // garbage HERE = aspMain synthesis; clean here = the device side. Capped at 120s.
    {
        static FILE* dump_f = nullptr;
        static bool dump_checked = false;
        static uint64_t dump_frames = 0;
        if (!dump_checked) {
            dump_checked = true;
            if (const char* p = getenv("RECOMP_PCM_DUMP")) {
                dump_f = fopen(p, "wb");
                fprintf(stderr, "[pcm_dump] %s -> %s\n", p, dump_f ? "open" : "FAILED");
            }
        }
        if (dump_f && dump_frames < (uint64_t)current_freq * 120) {
            static std::vector<int16_t> raw;
            raw.resize(pair_count * 2);
            for (size_t i = 0; i < pair_count; i++) {
                raw[i * 2 + 0] = read_sample(2 * i + 0);
                raw[i * 2 + 1] = read_sample(2 * i + 1);
            }
            fwrite(raw.data(), sizeof(int16_t), raw.size(), dump_f);
            fflush(dump_f);
            dump_frames += pair_count;
        }
    }

    SDL_QueueAudio(audio_device, float_buf, (uint32_t)(pair_count * OUTPUT_CHANNELS * sizeof(float)));
}

size_t sm64_get_frames_remaining() {
    if (!audio_device) return 0;
    uint32_t queued = SDL_GetQueuedAudioSize(audio_device);
    // Return remaining in samples (2 channels Ã— 4 bytes each).
    return queued / (OUTPUT_CHANNELS * sizeof(float));
}

void sm64_set_frequency(uint32_t freq) {
    fprintf(stderr, "[audio_freq] sm64_set_frequency(%u) (was %u)\n", freq, current_freq);
    fflush(stderr);
    if (freq == current_freq && audio_device != 0) return;
    current_freq = freq;

    if (audio_device != 0) {
        SDL_CloseAudioDevice(audio_device);
        audio_device = 0;
    }

    SDL_AudioSpec desired = {};
    desired.freq     = (int)freq;
    desired.format   = AUDIO_F32;
    desired.channels = (Uint8)OUTPUT_CHANNELS;
    // Device period. Default 0x100 (8ms @32k — snappy, trivially met on desktop). GPU-less target
    // (2026-07-12, run-2 verdict): with all 4 cores rendering, the device thread misses 8ms
    // pulls and consumption sags ~10% below nominal (queue pegged the ceiling, ~5 dropped
    // buffers/s = the pops). RECOMP_AUDIO_DEV_SAMPLES overrides (launcher uses 1024 = 32ms).
    desired.samples  = 0x100;
    if (const char* e = getenv("RECOMP_AUDIO_DEV_SAMPLES")) {
        long v = atol(e);
        if (v >= 64 && v <= 8192) desired.samples = (Uint16)v;
    }
    desired.callback = nullptr; // push mode
    desired.userdata = nullptr;

    SDL_AudioSpec obtained = {};
    audio_device = SDL_OpenAudioDevice(nullptr, 0, &desired, &obtained, 0);
    if (audio_device == 0) {
        fprintf(stderr, "[SM64PC] SDL_OpenAudioDevice failed: %s\n", SDL_GetError());
        return;
    }
    fprintf(stderr, "[audio_dev] driver=%s obtained: freq=%d samples=%u channels=%u format=0x%X (desired %d/%u)\n",
            SDL_GetCurrentAudioDriver() ? SDL_GetCurrentAudioDriver() : "?",
            obtained.freq, obtained.samples, obtained.channels, obtained.format,
            desired.freq, desired.samples);
    fflush(stderr);

    SDL_PauseAudioDevice(audio_device, 0); // unpause immediately
}

// Called once at startup.
void sm64_audio_init() {
    sm64_set_frequency(current_freq);
}

// Public callback struct to pass to recomp::start().
ultramodern::audio_callbacks_t get_audio_callbacks() {
    return {
        .queue_samples      = sm64_queue_samples,
        .get_frames_remaining = sm64_get_frames_remaining,
        .set_frequency      = sm64_set_frequency,
    };
}
