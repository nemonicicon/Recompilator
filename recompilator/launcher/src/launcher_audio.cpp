/**
 * launcher_audio.cpp — THE HOST'S audio backend (Recompilator UI step 3, 2026-09-06).
 *
 * SDL2 push-mode output, one device, shared by every game the host loads as a module. This is a
 * HOST SERVICE, not per-game code: the N64's AI delivers big-endian interleaved 16-bit stereo out
 * of RDRAM at whatever rate osAiSetFrequency picked, and converting that to the sound card is the
 * same job for all 296 carts. The port trees' own src/audio.cpp (which this is derived from,
 * minus their per-session diagnostics) stays where it is for the <game>pc.exe path.
 *
 * THE ONE SUBTLETY, and it is load-bearing: `audio_data` points straight into RDRAM, where every
 * byte lives at host index (addr ^ 3) because the guest is big-endian on a little-endian host.
 * Reading it as a flat int16_t array is wrong twice over — the ^3 read swaps adjacent samples
 * within each 4-byte word, and a per-int16 byte swap on top of that corrupts values the ^3 read
 * already returns correctly. Sample k is byte[(2k)^3] << 8 | byte[(2k+1)^3]. Getting this wrong
 * sounds like loud static with the real waveform faintly behind it.
 */

#include <cstdint>
#include <cstdio>
#include <cstdlib>

#include "SDL.h"
#include "ultramodern/ultramodern.hpp"

namespace {

SDL_AudioDeviceID g_device = 0;
uint32_t          g_freq = 32000;

constexpr int OUTPUT_CHANNELS = 2;

void set_frequency(uint32_t freq) {
    if (freq == g_freq && g_device != 0) return;
    g_freq = freq;

    if (g_device != 0) {
        SDL_CloseAudioDevice(g_device);
        g_device = 0;
    }

    SDL_AudioSpec desired = {};
    desired.freq     = (int)freq;
    desired.format   = AUDIO_F32;
    desired.channels = (Uint8)OUTPUT_CHANNELS;
    desired.samples  = 0x100;    // small buffer: latency, not throughput, is the constraint here
    desired.callback = nullptr;  // push mode (SDL_QueueAudio)
    desired.userdata = nullptr;

    g_device = SDL_OpenAudioDevice(nullptr, 0, &desired, nullptr, 0);
    if (g_device == 0) {
        fprintf(stderr, "[launcher-audio] SDL_OpenAudioDevice(%u Hz) failed: %s\n", freq, SDL_GetError());
        fflush(stderr);
        return;
    }
    fprintf(stderr, "[launcher-audio] device %u open at %u Hz\n", (unsigned)g_device, freq);
    fflush(stderr);
    SDL_PauseAudioDevice(g_device, 0);
}

void queue_samples(int16_t* audio_data, size_t sample_count) {
    if (g_device == 0) return;

    const size_t pair_count = sample_count / 2;   // sample_count counts int16s, L and R interleaved
    if (pair_count == 0) return;

    // Latency ceiling: ~100 ms of stereo float at 48 kHz. Past that the game is producing faster
    // than the card consumes and the newest buffer is the one to drop.
    constexpr uint32_t MAX_QUEUED_BYTES = 48000 * 2 * sizeof(float) / 10;
    if (SDL_GetQueuedAudioSize(g_device) > MAX_QUEUED_BYTES) return;

    static float* buf = nullptr;
    static size_t buf_pairs = 0;
    if (pair_count > buf_pairs) {
        free(buf);
        buf = (float*)malloc(pair_count * OUTPUT_CHANNELS * sizeof(float));
        buf_pairs = buf ? pair_count : 0;
        if (!buf) return;
    }

    const uint8_t* b = reinterpret_cast<const uint8_t*>(audio_data);
    for (size_t i = 0; i < pair_count; i++) {
        for (int c = 0; c < 2; c++) {
            const size_t off = 2 * (2 * i + c);
            const uint8_t hi = b[off ^ 3];
            const uint8_t lo = b[(off + 1) ^ 3];
            const int16_t s = (int16_t)((uint16_t)hi << 8 | (uint16_t)lo);
            buf[i * 2 + c] = s / 32768.0f;
        }
    }

    SDL_QueueAudio(g_device, buf, (uint32_t)(pair_count * OUTPUT_CHANNELS * sizeof(float)));
}

size_t get_frames_remaining() {
    if (g_device == 0) return 0;
    return SDL_GetQueuedAudioSize(g_device) / (OUTPUT_CHANNELS * sizeof(float));
}

} // namespace

namespace launcher {

// The rate the device is open at. The GAME chooses it, not the user - each cartridge asks
// for its own - so the AUDIO screen reports it rather than offering to change it.
uint32_t audio_frequency() { return g_freq; }

void audio_init() {
    SDL_InitSubSystem(SDL_INIT_AUDIO);
    set_frequency(g_freq);
}

ultramodern::audio_callbacks_t audio_callbacks() {
    return ultramodern::audio_callbacks_t{
        .queue_samples        = queue_samples,
        .get_frames_remaining = get_frames_remaining,
        .set_frequency        = set_frequency,
    };
}

} // namespace launcher
