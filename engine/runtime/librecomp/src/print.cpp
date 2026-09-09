#include <vector>
#include <string>
#include <string_view>
#include <cstring>
#include <cstdio>

#include <ultramodern/ultra64.h>
#include <ultramodern/ultramodern.hpp>
#include "recomp.h"
#include "euc-jp.hpp"

extern "C" void __checkHardware_msp_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = 0;
}

extern "C" void __checkHardware_kmc_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = 0;
}

extern "C" void __checkHardware_isv_recomp(uint8_t * rdram, recomp_context * ctx) {
    ctx->r2 = 0;
}

extern "C" void __osInitialize_msp_recomp(uint8_t * rdram, recomp_context * ctx) {
}

extern "C" void __osInitialize_kmc_recomp(uint8_t * rdram, recomp_context * ctx) {
}

extern "C" void __osInitialize_isv_recomp(uint8_t * rdram, recomp_context * ctx) {
}

extern "C" void isPrintfInit_recomp(uint8_t * rdram, recomp_context * ctx) {
}

extern "C" void __osRdbSend_recomp(uint8_t * rdram, recomp_context * ctx) {
    gpr buf = ctx->r4;
    size_t size = ctx->r5;
    u32 type = (u32)ctx->r6;
    std::unique_ptr<char[]> to_print = std::make_unique<char[]>(size + 1);

    for (size_t i = 0; i < size; i++) {
        to_print[i] = MEM_B(i, buf);
    }
    to_print[size] = '\x00';

    fwrite(to_print.get(), 1, size, stdout);

    ctx->r2 = size;
}

// SESSION 32+: faithful native osSyncPrintf.
//
// Retail N64 ships osSyncPrintf to a debug serial host (ISViewer/GIO) that is absent on a
// PC port, so the output is discarded and the call RETURNS. The recompiled libultra _Printf
// has a hang bug (osSyncPrintf("wait cont = %d", ...) in title_demo wedges every 2nd-map
// load -> blocks Level 2). This native impl formats the args host-side with HARD BOUNDS (so
// it can never loop/hang), routes the result to the diag log as [game] (preserving the
// game's own labeled debug output), then returns. It does NOT touch the buggy _Printf.
// Game-agnostic: osSyncPrintf is stock libultra, common to many N64 titles.
//
// ABI: fmt = a0 (r4); varargs = a1/a2/a3 (r5/r6/r7) then the caller stack at sp+0x10 (o32).
// MEM_*(x, y) addresses CV64_PHYS(x + y) (symmetric), so MEM_B(fmt, i) reads fmt[i] through
// the overlay TLB exactly as the game would.
extern "C" void cv64_osSyncPrintf_native(uint8_t * rdram, recomp_context * ctx) {
    gpr fmt = ctx->r4;
    if (fmt == 0) {
        return;
    }

    auto getarg = [&](int n) -> uint32_t {
        switch (n) {
            case 0:  return (uint32_t)ctx->r5;
            case 1:  return (uint32_t)ctx->r6;
            case 2:  return (uint32_t)ctx->r7;
            default: return (uint32_t)MEM_W(ctx->r29, 0x10 + (n - 3) * 4);
        }
    };

    constexpr int FMT_CAP = 1024;   // bounded format scan -> cannot hang
    constexpr int OUT_CAP = 1024;   // bounded output
    std::string out;
    out.reserve(128);
    int argi = 0;

    for (int i = 0; i < FMT_CAP && (int)out.size() < OUT_CAP; i++) {
        char c = (char)MEM_B(fmt, i);
        if (c == '\0') {
            break;
        }
        if (c != '%') {
            out.push_back(c);
            continue;
        }
        // Copy the conversion spec (% flags width precision length conv), bounded.
        char spec[32];
        int sl = 0;
        spec[sl++] = '%';
        int j = i + 1;
        char conv = '%';
        for (; j < i + 1 + 24; j++) {
            char d = (char)MEM_B(fmt, j);
            if (d == '\0') {
                break;
            }
            if (sl < (int)sizeof(spec) - 1) {
                spec[sl++] = d;
            }
            if (std::strchr("diouxXcspeEfgG%", d)) {
                conv = d;
                break;
            }
        }
        spec[sl] = '\0';

        char buf[80];
        switch (conv) {
            case '%': out.push_back('%'); break;
            case 'd': case 'i': std::snprintf(buf, sizeof buf, "%d",     (int32_t)getarg(argi++)); out += buf; break;
            case 'u':           std::snprintf(buf, sizeof buf, "%u",              getarg(argi++)); out += buf; break;
            case 'o':           std::snprintf(buf, sizeof buf, "%o",              getarg(argi++)); out += buf; break;
            case 'x':           std::snprintf(buf, sizeof buf, "%x",              getarg(argi++)); out += buf; break;
            case 'X':           std::snprintf(buf, sizeof buf, "%X",              getarg(argi++)); out += buf; break;
            case 'p':           std::snprintf(buf, sizeof buf, "0x%08x",          getarg(argi++)); out += buf; break;
            case 'c':           out.push_back((char)getarg(argi++)); break;
            case 'e': case 'E': case 'f': case 'g': case 'G':
                // f64 arg (occupies an 8-byte slot); discard the value best-effort, stay bounded.
                out += "<f>"; argi += 2; break;
            case 's': {
                gpr sp = getarg(argi++);
                if (sp != 0) {
                    for (int k = 0; k < 256 && (int)out.size() < OUT_CAP; k++) {
                        char sc = (char)MEM_B(sp, k);
                        if (sc == '\0') {
                            break;
                        }
                        out.push_back(sc);
                    }
                }
                break;
            }
            default: out += spec; break;   // unknown spec -> emit literally
        }
        i = j; // resume after the spec (the loop's i++ moves to the next char)
    }

    if (!out.empty()) {
        std::string utf8 = Encoding::decode_eucjp(std::string_view{ out.data(), out.size() });
        while (!utf8.empty() && (utf8.back() == '\n' || utf8.back() == '\r')) {
            utf8.pop_back();
        }
        if (!utf8.empty()) {
            fprintf(stderr, "[game] %s\n", utf8.c_str());
            fflush(stderr);
        }
    }
}

extern "C" void is_proutSyncPrintf_recomp(uint8_t * rdram, recomp_context * ctx) {
    // CV64 (KCEK engine) is heavily instrumented: osSyncPrintf -> _Printf -> this prout
    // callback, which receives the game's already-FORMATTED debug bytes (buf=a1, size=a2).
    // The Konami devs' line-buffered EUC-JP output below was left commented out; re-enabled
    // and routed to the diag log (stderr) so the game's OWN labeled diagnostics show up for
    // free (e.g. "Scroll: Destruct!!", "BG3D SYSTEM INITIALIZE", "DISPLAY ROOM %d"). This is
    // a runtime file, so it survives N64Recomp re-runs. Grep the diag log for "[game]".
    static std::vector<char> print_buffer;

    gpr buf = ctx->r5;
    size_t size = ctx->r6;

    for (size_t i = 0; i < size; i++) {
        // Add the new character to the buffer
        char cur_char = MEM_B(i, buf);

        // If the new character is a newline, flush the buffer as one decoded line.
        if (cur_char == '\n') {
            std::string utf8_str = Encoding::decode_eucjp(std::string_view{ print_buffer.data(), print_buffer.size() });
            if (!utf8_str.empty()) {
                fprintf(stderr, "[game] %s\n", utf8_str.c_str());
                fflush(stderr);
            }
            print_buffer.clear();
        } else if (cur_char != '\r') {
            print_buffer.push_back(cur_char);
        }
    }

    ctx->r2 = 1;
}
