#include "recomp.h"
#include <cstdio>
#include <string>
#include <ultramodern/ultra64.h>
#include <ultramodern/ultramodern.hpp>

#define VI_NTSC_CLOCK 48681812

extern "C" void osAiSetFrequency_recomp(uint8_t* rdram, recomp_context* ctx) {
    uint32_t freq = ctx->r4;
    // This makes actual audio frequency more accurate to console, but may not be desirable
    //uint32_t dacRate = (uint32_t)(((float)VI_NTSC_CLOCK / freq) + 0.5f);
    //freq = VI_NTSC_CLOCK / dacRate;
    ctx->r2 = freq;
    ultramodern::set_audio_frequency(freq);
}

extern "C" void osAiSetNextBuffer_recomp(uint8_t* rdram, recomp_context* ctx) {
    // r4 = N64 virtual address of audio buffer (KSEG0/KSEG1, sign-extended).
    // r5 = byte count of the DMA transfer.
    // TO_PTR strips segment bits: (uint32_t)(r4) & 0x1FFFFFFF → physical offset.
    uint32_t phys       = (uint32_t)(ctx->r4) & 0x1FFFFFFFu;
    uint32_t byte_count = (uint32_t)(ctx->r5);

    // Log every call so we can see exactly what r4/r5 look like at crash time.
    fprintf(stderr, "[ai] osAiSetNextBuffer: r4=0x%08X phys=0x%08X r5(bytes)=0x%08X\n",
            (uint32_t)(ctx->r4), phys, byte_count);
    fflush(stderr);

    // Guard 1: physical address must be inside 8 MB RDRAM.
    if (phys >= 0x800000u) {
        fprintf(stderr, "[ai]   → SKIP: phys 0x%08X out of RDRAM\n", phys);
        fflush(stderr);
        ctx->r2 = 0;
        return;
    }

    // Guard 2: byte_count must be non-zero and within the N64 AI DMA hardware
    // limit (32 KB).  A garbage r5 would otherwise make pair_count enormous and
    // walk the loop pointer far past the end of RDRAM.
    if (byte_count == 0 || byte_count > 0x8000u) {
        fprintf(stderr, "[ai]   → SKIP: byte_count 0x%08X invalid (0 or >32KB)\n", byte_count);
        fflush(stderr);
        ctx->r2 = 0;
        return;
    }

    // Guard 3: the buffer must fit entirely within RDRAM.
    if (phys + byte_count > 0x800000u) {
        fprintf(stderr, "[ai]   → SKIP: buffer [0x%08X, 0x%08X) overflows RDRAM\n",
                phys, phys + byte_count);
        fflush(stderr);
        ctx->r2 = 0;
        return;
    }

    // (Wave-1 purge: removed the CV64 session-16/18 PCM content probe — it scanned EVERY audio
    // buffer of EVERY game, forever, for a question answered sessions ago.)

    ultramodern::queue_audio_buffer(rdram, ctx->r4, ctx->r5);
    ctx->r2 = 0;
}

extern "C" void osAiGetLength_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = ultramodern::get_remaining_audio_bytes();
}

extern "C" void osAiGetStatus_recomp(uint8_t* rdram, recomp_context* ctx) {
    ctx->r2 = 0x00000000; // Pretend the audio DMAs finish instantly
}
