// recomp_live_gap.cpp — LiveRecompiler-backed dispatch-gap fallback.
//
// THE PROBLEM (same as recomp_interp.cpp): some executable code is reached at
// runtime that the static recompiler never turned into a C function — runtime-DMA'd
// overlays, code the decomp classified as `.data`, or any target reached only through
// an indirect pointer the recompiler couldn't see. `get_function(addr)` has nothing to
// return.
//
// THE OLD FIX (recomp_interp.cpp): a hand-written MIPS interpreter. It works but is a
// SEPARATE emulator that can mis-decode DATA as code and execute a wild store → the
// whole process crashes (1080's 0x28EE8790000 write, Army Men UNIMPL ops, Extreme-G
// 0xC0000005). It is also slow (one instruction at a time).
//
// THE NEW FIX (here): use N64Recomp's OWN LiveRecompiler (LiveRecomp/, sljit JIT). It
// recompiles the target function to native code at runtime with the SAME codegen as the
// static recompiler — so an interpreted-vs-static behavioural gap is impossible. Calls
// inside the JIT'd function resolve through the SAME get_function the static image uses,
// so it links seamlessly back into the recompiled game. And it FAILS SAFE: if the bytes
// don't form a valid function, recompilation fails and the trampoline no-ops instead of
// wild-writing.
//
// Dispatch follows the interpreter's proven trampoline shape: get_function() calls
// recomp_live_gap_set_target(vaddr) then returns recomp_live_gap_trampoline. The
// trampoline is later CALLED with (rdram, ctx) — only then is rdram available to fetch the
// instruction words — so it JITs (or hits the cache) and dispatches.
//
// General "fix the N64": this is the designed runtime-recompilation subsystem (the mod
// system already uses it, mods.cpp), routed at the dispatch gap. Helps every bare-metal /
// overlay / data-as-code port (1080, Army Men, Extreme-G, KI Gold, …) — no per-game code.

// ultramodern.hpp FIRST: it pulls <Windows.h>, which must be processed before the recompiler
// headers' macro fallout (rabbitizer redefines CONST; winnt.h breaks with C2733 after it).
#include <atomic>
#include "ultramodern/ultramodern.hpp"

#include "recomp.h"
#include "recompiler/context.h"
#include "recompiler/live_recompiler.h"

#include <csetjmp>
#include <cstdlib>
#include <filesystem>
#include <unordered_map>
#include <memory>
#include <mutex>
#include <vector>
#include <sstream>
#include <cstdio>
#include <cstdint>

// ── runtime callbacks the JIT'd code needs (recomp.cpp / mod_events.cpp) ──────────────
extern "C" void  cop0_status_write(recomp_context* ctx, gpr value);
extern "C" gpr   cop0_status_read(recomp_context* ctx);
extern "C" void  switch_error(const char* func, uint32_t vram, uint32_t jtbl);
extern "C" void  do_break(uint32_t vram);
extern "C" recomp_func_t* get_function(int32_t vram);
extern "C" void  recomp_trigger_event(uint8_t* rdram, recomp_context* ctx, uint32_t event_index);

// Interpreter's data guard (overlays.cpp/recomp_interp.cpp): true if the word at addr
// plausibly decodes as code rather than a pointer/constant.
extern "C" int recomp_interp_is_code(uint8_t* rdram, uint32_t addr);

// ── termination bridge (the 0xE06D7363 class, 2026-07-18) ─────────────────────────────
// ultramodern kills a guest thread by THROWING ultramodern::thread_terminated from the HLE
// (osDestroyThread, the schedfix context-REPLACED branch, yield paths) and catching it at the
// host thread's root. sljit-generated frames carry NO Windows unwind info, so when the guest
// stack contains a JIT'd gap function the unwinder cannot walk it: the process dies with the
// exception code and no handler fires (drmario JIT=1, deterministic ~68s attract teardown;
// JIT=0 clean — this WAS the divergence). Bridge (the LuaJIT-class pattern):
//   1. every call OUT of JIT'd code to a looked-up native goes through live_jit_call_native,
//      which catches thread_terminated on the native side of the boundary;
//   2. the catch longjmps back to the nearest gap-trampoline anchor — with the jmp_buf's
//      Frame zeroed, MSVC longjmp does a pure register restore (NO RtlUnwindEx), so the
//      unwindable-frame requirement never arises. The skipped frames are the sljit frames
//      (no destructors) and this bridge (none either);
//   3. the anchor rethrows thread_terminated from the trampoline, below every JIT frame,
//      where normal C++ unwinding has full metadata again.
// Nested JIT entries compose: each bridge catch peels exactly one JIT layer, and the rethrow
// is caught by the NEXT bridge down (or the thread root).
namespace {
struct JitEntryAnchor {
    std::jmp_buf jb;
    JitEntryAnchor* prev;
};
thread_local JitEntryAnchor* t_jit_anchor = nullptr;
// [bm-bridge 2026-08-26] the ORIGINAL exception, preserved across the longjmp so the anchor can
// rethrow the exact type. The old bridge hardcoded thread_terminated; the bare-metal scheduler
// ALSO throws (BmFiberRedispatch / BmRootUnwind) through JIT boundaries — those sailed into the
// unwind-info-less sljit frames and killed the process with no handler (the JIT=1 silent death,
// SOTE 14:08: dead ~90s in, right after a rawirq vector invoke through JIT'd handler code).
thread_local std::exception_ptr t_jit_pending_exc = nullptr;

// Zero the captured frame pointer so longjmp restores registers instead of unwinding.
inline void make_longjmp_nonunwinding(std::jmp_buf& jb) {
#if defined(_WIN32) && defined(_M_X64)
    reinterpret_cast<_JUMP_BUFFER*>(&jb)->Frame = 0;
#else
    (void)jb; // POSIX longjmp does not unwind; nothing to disarm.
#endif
}

[[noreturn]] void jit_longjmp_to_anchor() {
    // Only reachable from code invoked BY a JIT'd function, so an anchor must exist; if it
    // somehow doesn't, rethrowing is strictly better than jumping through a null anchor.
    if (t_jit_anchor == nullptr) {
        if (t_jit_pending_exc) { std::exception_ptr e = t_jit_pending_exc; t_jit_pending_exc = nullptr; std::rethrow_exception(e); }
        throw ultramodern::thread_terminated{};
    }
    std::longjmp(t_jit_anchor->jb, 1);
}
} // namespace

extern "C" void live_jit_call_native(recomp_func_t* target, uint8_t* rdram, recomp_context* ctx) {
    try {
        target(rdram, ctx);
    } catch (...) {
        t_jit_pending_exc = std::current_exception();
        jit_longjmp_to_anchor();
    }
}

// cop0 STATUS writes and break/event paths can reach scheduling (yield-drain), so they get the
// same catch. switch_error only reports; the memory shims never park a thread (device-window
// handlers are non-blocking) — extend if a diag ever proves otherwise.
static void bridged_cop0_status_write(recomp_context* ctx, gpr value) {
    try { cop0_status_write(ctx, value); } catch (...) { t_jit_pending_exc = std::current_exception(); jit_longjmp_to_anchor(); }
}
static void bridged_do_break(uint32_t vram) {
    try { do_break(vram); } catch (...) { t_jit_pending_exc = std::current_exception(); jit_longjmp_to_anchor(); }
}
static void bridged_trigger_event(uint8_t* rdram, recomp_context* ctx, uint32_t event_index) {
    try { recomp_trigger_event(rdram, ctx, event_index); } catch (...) { t_jit_pending_exc = std::current_exception(); jit_longjmp_to_anchor(); }
}

namespace {
struct LiveJitCallNativeInstaller {
    LiveJitCallNativeInstaller() { recomp_live_jit_mem_ops.call_native = live_jit_call_native; }
};
LiveJitCallNativeInstaller s_live_jit_call_native_installer;
} // namespace

// One N64 instruction word at a KSEG0/overlay vaddr. MEM_W applies CV64_PHYS / the LLE
// TLB and yields the N64 word; it expands using the `rdram` in scope (the parameter).
static inline uint32_t gap_fetch(uint8_t* rdram, uint32_t pc) {
    return (uint32_t)MEM_W(0, pc);
}

// ── function-extent detection ─────────────────────────────────────────────────────────
// Linear sweep from `start`: a MIPS function ends at an unconditional transfer
// (jr $ra / jr $reg / j) whose position is past every forward branch target seen so far
// (so we don't cut a multi-return function short). Returns instruction COUNT incl. the
// terminator's delay slot, or 0 if the region doesn't look like a function.
static constexpr uint32_t kMaxFuncInstrs = 0x4000; // 16K instrs (64 KiB) hard cap

static uint32_t gap_function_length(uint8_t* rdram, uint32_t start) {
    if (!recomp_interp_is_code(rdram, start)) {
        return 0; // first word isn't plausibly code
    }
    uint32_t furthest = start; // furthest forward branch/jump target reached so far
    for (uint32_t i = 0; i < kMaxFuncInstrs; i++) {
        uint32_t pc = start + i * 4;
        uint32_t w = gap_fetch(rdram, pc);
        uint32_t op = w >> 26;

        if (op == 0) { // SPECIAL
            uint32_t funct = w & 0x3F;
            if (funct == 0x08) { // jr — return / indirect tail. Terminator if past all fwd targets.
                if (pc >= furthest) {
                    return i + 2; // include the delay slot
                }
            }
            // jalr (0x09) is a call — keeps going.
        } else if (op == 2) { // j (unconditional)
            uint32_t tgt = (pc & 0xF0000000u) | ((w & 0x03FFFFFFu) << 2);
            if (tgt > furthest) furthest = tgt; // may be a forward local jump
            if (pc >= furthest) {
                return i + 2;
            }
        } else if (op == 4 || op == 5 || op == 6 || op == 7 ||      // beq bne blez bgtz
                   op == 20 || op == 21 || op == 22 || op == 23) {  // beql bnel blezl bgtzl
            int32_t off = (int16_t)(w & 0xFFFF);
            uint32_t tgt = pc + 4 + off * 4;
            if (tgt > furthest) furthest = tgt;
        } else if (op == 1) { // REGIMM (bltz/bgez/...l)
            int32_t off = (int16_t)(w & 0xFFFF);
            uint32_t tgt = pc + 4 + off * 4;
            if (tgt > furthest) furthest = tgt;
        }
        // op 3 (jal) is a call — keeps going. Other ops fall through.
    }
    return 0; // ran off the cap without a clean terminator — refuse (fail safe)
}

// ── cache ─────────────────────────────────────────────────────────────────────────────
// Keyed on (vaddr, first instruction word). The first-word check is a cheap content guard
// so a SHARED-vaddr overlay window (e.g. the 0x0F NI slot, where the bytes change when a
// different overlay is loaded) re-JITs instead of dispatching a stale function. Keeps the
// LiveGeneratorOutput alive (it owns the executable code). A cached null = "not code".
struct GapEntry {
    recomp_func_t* func = nullptr;
    bool resolved = false; // attempted (success or proven-not-code)
    std::unique_ptr<N64Recomp::LiveGeneratorOutput> output;
    // MUST outlive the generated code: the generator bakes this array's ADDRESS into the emitted
    // code as an absolute load (live_generator.cpp:884, SLJIT_MEM0) dereferenced on EVERY call of
    // the JIT'd function — it is not read at codegen time. See the note in gap_jit.
    std::unique_ptr<int32_t[]> section_addresses;
};
static std::unordered_map<uint64_t, GapEntry> g_gap_cache;
static std::mutex g_gap_mtx;

static inline uint64_t gap_key(uint32_t vaddr, uint32_t first_word) {
    return ((uint64_t)vaddr << 32) | first_word;
}

// Diagnostics sink export (roadmap tool #1): serialize the live-gap cache as a JSON array. Each entry is
// a function the STATIC recompile missed but the runtime discovered (and JIT'd, if it was real code) —
// exactly the runtime->static feedback the gap-journal/reingest tool (#3) reads back into symbol_addrs/toml.
// Thread-safe (takes g_gap_mtx). Returns "[]" when empty. Called from recomp_diag_flush.cpp at process exit.
std::string recomp_diag_gap_cache_json() {
    std::lock_guard<std::mutex> lk(g_gap_mtx);
    std::string out = "[";
    bool first = true;
    for (const auto& [key, entry] : g_gap_cache) {
        char buf[256];
        snprintf(buf, sizeof(buf),
                 "%s\n    { \"vaddr\": \"0x%08X\", \"first_word\": \"0x%08X\", \"resolved\": %s, \"is_code\": %s, \"code_size\": %zu }",
                 first ? "" : ",",
                 (uint32_t)(key >> 32), (uint32_t)(key & 0xFFFFFFFFu),
                 entry.resolved ? "true" : "false",
                 entry.func != nullptr ? "true" : "false",
                 entry.output ? entry.output->code_size : (size_t)0);
        out += buf;
        first = false;
    }
    out += first ? "]" : "\n  ]";
    return out;
}

// JIT the function at `vaddr` (or return the cached pointer). nullptr = not recompilable
// (caller should no-op). Thread-safe.
static recomp_func_t* gap_jit(uint8_t* rdram, uint32_t vaddr) {
    if ((vaddr & 3u) != 0u) return nullptr; // unaligned = not a function entry

    uint32_t first_word = gap_fetch(rdram, vaddr);
    uint64_t key = gap_key(vaddr, first_word);

    std::lock_guard<std::mutex> lk(g_gap_mtx);
    auto it = g_gap_cache.find(key);
    if (it != g_gap_cache.end() && it->second.resolved) {
        return it->second.func; // may be nullptr (cached "not code")
    }

    GapEntry& slot = g_gap_cache[key];
    slot.resolved = true;
    slot.func = nullptr;

    uint32_t len = gap_function_length(rdram, vaddr);
    if (len == 0) {
        static int _n = 0;
        if (_n++ < 64) {
            fprintf(stderr, "[live-gap] 0x%08X not a recompilable function (word=0x%08X) -> no-op\n",
                    vaddr, first_word);
            fflush(stderr);
        }
        return nullptr;
    }

    // BYTE-ORDER FIX (NC RUN 27 — the wild-store class): Function::words are consumed by the
    // recompiler in ROM/ELF BYTE ORDER — recompilation.cpp:1121 does `byteswap(word)` before
    // decode, because the static pipeline stores raw big-endian file words. gap_fetch (MEM_W)
    // yields HOST-ORDER words, so feeding them directly got every instruction BYTE-REVERSED at
    // decode: `lui $a0,0x8009` (0x3C048009) decoded as its mirror `j 0x860010F0` (0x0980043C).
    // Every gap JIT compiled garbage — the spurious wild branches were then "delay-slot +
    // early-return" downgraded, so gap functions silently became near-no-ops (the LiveRecomp
    // fail-safe-BLACK class: JIT "engages", game stays black) or wild-stored (NC's crash at
    // func_80054150). Pre-swap so the decoder's swap restores the true word.
    std::vector<uint32_t> words(len);
    for (uint32_t i = 0; i < len; i++) {
        words[i] = byteswap(gap_fetch(rdram, vaddr + i * 4));
    }

    // Minimal single-function Context (mirrors live_recompiler_test.cpp).
    N64Recomp::Context context{};

    // STAGE 2 (P1 finding #2 REMAINING, 2026-07-18): back the analysis with RDRAM so
    // jr-jump-table reads succeed. The analysis reads table entries from context.rom via each
    // section's rom/ram mapping (analysis.cpp "Determine jump table sizes"); with an empty rom
    // every switch-carrying function died at the out-of-ROM guard -> analyze-fail ->
    // interpreter. For a KSEG0 function, snapshot the installed 8MB of physical RDRAM as
    // ROM-order (big-endian) bytes and map BOTH sections phys-consistently, so any KSEG0 table
    // vram resolves to its live bytes. Non-KSEG0 (TLB-mapped) functions keep the empty-rom
    // behavior: their tables aren't phys-addressable this way and the guard fail-safes to the
    // interpreter exactly as before. Snapshot cost is per UNIQUE JIT'd function (cache-gated),
    // ~8MB byteswap ≈ milliseconds.
    const bool kseg0 = (vaddr & 0xE0000000u) == 0x80000000u;
    const uint32_t phys_base = vaddr & 0x1FFFFFFFu;
    constexpr uint32_t kRdramPhysBytes = 0x800000u; // installed 8MB (RDRAM_OPEN_BUS above that)
    if (kseg0) {
        context.rom.resize(kRdramPhysBytes);
        const uint32_t* src = reinterpret_cast<const uint32_t*>(rdram);
        uint32_t* dst = reinterpret_cast<uint32_t*>(context.rom.data());
        for (uint32_t i = 0; i < kRdramPhysBytes / 4u; i++) {
            dst[i] = byteswap(src[i]); // rdram words are host-order; rom bytes are BE
        }
    }

    context.sections.resize(kseg0 ? 2 : 1);
    context.sections[0].ram_addr = vaddr;
    context.sections[0].rom_addr = kseg0 ? phys_base : 0; // phys-consistent with the snapshot
    context.sections[0].size = len * 4;
    context.sections[0].name = ".live_gap";
    context.sections[0].executable = true;
    context.sections[0].relocatable = false;
    if (kseg0) {
        // Covers all of KSEG0 RDRAM so the analysis' cross-section table resolution finds any
        // table outside the function's own span (rodata after the function, another overlay...).
        context.sections[1].ram_addr = 0x80000000u;
        context.sections[1].rom_addr = 0;
        context.sections[1].size = kRdramPhysBytes;
        context.sections[1].name = ".live_gap_rdram";
        context.sections[1].executable = false;
        context.sections[1].relocatable = false;
    }
    context.section_functions.resize(context.sections.size());
    context.functions_by_vram[vaddr].emplace_back(context.functions.size());
    context.section_functions[0].emplace_back(context.functions.size());
    context.sections[0].function_addrs.emplace_back(vaddr);
    context.functions.emplace_back(vaddr, /*rom*/kseg0 ? phys_base : 0u, std::move(words), "live_gap_func", /*section*/(uint16_t)0);

    // KSEG0 code is absolutely addressed; the section's runtime base == its vram.
    // LIFETIME (the wild-pointer crash class, 2026-07-18): the generator does NOT read this
    // array at codegen time — it bakes its ADDRESS into the emitted code as an absolute load
    // (live_generator.cpp:884, SLJIT_MEM0(), sljit_sw(section_addr_ptr)) that runs on every call.
    // This used to be a stack-local vector, so the moment gap_jit returned, every reloc'd address
    // the JIT'd function computed read a FREED heap block and used the garbage as an N64 address.
    // mods.cpp never hit this: it keeps section_addresses as a persistent member (mods.cpp:484).
    // Owned by the cache entry now, which lives as long as the code it belongs to.
    slot.section_addresses = std::make_unique<int32_t[]>(1);
    slot.section_addresses[0] = (int32_t)vaddr;

    N64Recomp::LiveGeneratorInputs inputs{};
    inputs.base_event_index            = 0;
    inputs.cop0_status_write           = bridged_cop0_status_write;  // termination bridge (see above)
    inputs.cop0_status_read            = cop0_status_read;
    inputs.switch_error                = switch_error;
    inputs.do_break                    = bridged_do_break;
    inputs.get_function                = get_function;
    inputs.syscall_handler             = nullptr;
    inputs.pause_self                  = nullptr;
    inputs.trigger_event               = bridged_trigger_event;
    inputs.reference_section_addresses = nullptr;
    inputs.local_section_addresses     = slot.section_addresses.get();
    inputs.run_hook                    = nullptr;

    N64Recomp::LiveGenerator generator{ context.functions.size(), inputs };
    std::vector<std::vector<uint32_t>> dummy_static_funcs{};
    std::ostringstream dummy_ostream{};

    bool ok = N64Recomp::recompile_function_live(generator, context, 0, dummy_ostream, dummy_static_funcs, true);
    auto output = std::make_unique<N64Recomp::LiveGeneratorOutput>(generator.finish());

    if (!ok || !output->good || output->functions.empty() || output->functions[0] == nullptr) {
        static int _n = 0;
        if (_n++ < 64) {
            // Not "no-op": the dispatcher re-checks is_code on a null return and runs REAL code
            // through the interpreter (recomp_live_gap_trampoline tail). Say so, or this line
            // reads as a silent-wrongness path during crash forensics.
            fprintf(stderr, "[live-gap] 0x%08X JIT refused (len=%u ok=%d good=%d) -> interpreter fallback (no-op only if not code)\n",
                    vaddr, len, (int)ok, output ? (int)output->good : -1);
            fflush(stderr);
        }
        return nullptr;
    }

    recomp_func_t* fn = output->functions[0];
    slot.func = fn;
    slot.output = std::move(output);

    static int _n = 0;
    if (_n++ < 64) {
        fprintf(stderr, "[live-gap] 0x%08X JIT ok (%u instrs, %zu bytes)\n",
                vaddr, len, slot.output->code_size);
        fflush(stderr);
    }

    // GAP CAPTURE (2026-07-18, materialization route): RECOMP_GAP_DUMP=1 appends every JIT-PROVEN
    // function's exact runtime bytes (ROM byte order) to saves/gap_code_dump.bin with a tsv index.
    // These vaddrs' code is loaded at runtime from elsewhere in ROM (drmario: the static rom
    // offsets under the same vaddrs disassemble as garbage — the veto proved it), so the ONLY
    // faithful static source is the bytes the JIT just verified. An offline tool matches the
    // captures back to raw ROM (or, failing that, assembles them as capture-backed overlay
    // sections — the banjo RAM-capture class, generalized).
    static const bool gap_dump_enabled = [] {
        const char* e = std::getenv("RECOMP_GAP_DUMP");
        return e != nullptr && e[0] == '1';
    }();
    if (gap_dump_enabled) {
        std::filesystem::path save_path = ultramodern::get_save_file_path();
        if (!save_path.empty()) {
            std::filesystem::path dir = save_path.parent_path();
            // context.functions[0].words were pre-swapped to ROM byte order above — but they were
            // MOVED into the context; re-read from RDRAM instead (same source, still resident).
            if (FILE* fbin = fopen((dir / "gap_code_dump.bin").string().c_str(), "ab")) {
                // "ab" position is undefined until the first write on Windows: seek explicitly
                // or every index offset records as 0 (2026-07-18, first capture run).
                fseek(fbin, 0, SEEK_END);
                long at = ftell(fbin);
                for (uint32_t i = 0; i < len; i++) {
                    uint32_t be = byteswap(gap_fetch(rdram, vaddr + i * 4));
                    fwrite(&be, 4, 1, fbin);
                }
                fclose(fbin);
                if (FILE* fidx = fopen((dir / "gap_code_dump.tsv").string().c_str(), "a")) {
                    fprintf(fidx, "0x%08X\t%u\t%ld\n", vaddr, len, at);
                    fclose(fidx);
                }
            }
        }
    }
    return fn;
}

// ── dispatch trampoline (interp-style) ────────────────────────────────────────────────
// get_function sets the target then returns recomp_live_gap_trampoline; the trampoline is
// CALLED with (rdram, ctx), so rdram is available here to fetch + JIT.
std::atomic<uint64_t> g_gap_tail_interp{0};
std::atomic<uint64_t> g_gap_tail_noop{0};
extern "C" uint64_t recomp_gap_tail(int i) { return i ? g_gap_tail_noop.load(std::memory_order_relaxed) : g_gap_tail_interp.load(std::memory_order_relaxed); }
static thread_local uint32_t g_live_gap_target = 0;

// Interpreter fallback (recomp_interp.cpp): the robust path that executes EVERY MIPS instruction. The JIT
// (gap_jit) is faster but the LiveGenerator silently no-ops on constructs it can't codegen (output good=0) —
// large/complex runtime-loaded functions like Blast Corps' main thread (2858 instrs) hit those. When the JIT
// bails on what gap_jit already proved is real code, interpret it instead of no-opping into a dead game.
extern "C" void recomp_interp_set_target(uint32_t vaddr);
extern "C" void recomp_interp_trampoline(uint8_t* rdram, recomp_context* ctx);

extern "C" void recomp_live_gap_set_target(uint32_t vaddr) {
    g_live_gap_target = vaddr;
}

extern "C" void recomp_live_gap_trampoline(uint8_t* rdram, recomp_context* ctx) {
    uint32_t vaddr = g_live_gap_target;
    // Live-gap JIT is OPT-IN (RECOMP_LIVE_GAP_JIT=1). Default = the faithful interpreter.
    // 2026-07-15 corpus sweep measured the JIT-on default regressing 41 games RENDERS->BLACK and
    // 10 RENDERS->CRASH vs the 07-02 baseline; A/B confirmed on drmario (BLACK->RENDERS), gex64
    // (BLACK->RENDERS), thps (CRASH->RENDERS) with the JIT off. The wild-store class below was
    // already documented by the 07-12 DK64 hunt; correct-by-construction says the JIT re-earns
    // its default via the oracle before it ships on. Repro cases for fixing it: drmario, thps.
    static const bool gap_jit_enabled = [] {
        const char* e = std::getenv("RECOMP_LIVE_GAP_JIT");
        bool v = (e != nullptr && e[0] == '1');
        fprintf(stderr, "[livegap] JIT %s (RECOMP_LIVE_GAP_JIT); interpreter fallback always available\n", v ? "ON" : "OFF");
        fflush(stderr);
        return v;
    }();
    recomp_func_t* fn = gap_jit_enabled ? gap_jit(rdram, vaddr) : nullptr;
    if (fn != nullptr) {
        // Run the JIT'd function (its calls resolve via get_function) under a termination
        // anchor: if a callee throws thread_terminated, the bridge longjmps HERE (skipping
        // the unwind-info-less sljit frames) and we rethrow from a normally-unwindable frame.
        // POD locals only between setjmp and the call (setjmp + destructors don't mix).
        JitEntryAnchor anchor;
        anchor.prev = t_jit_anchor;
        t_jit_anchor = &anchor;
        bool terminated = false;
        if (setjmp(anchor.jb) == 0) {
            make_longjmp_nonunwinding(anchor.jb);
            fn(rdram, ctx);
        } else {
            terminated = true;
        }
        t_jit_anchor = anchor.prev;
        if (terminated) {
            // rethrow the EXACT exception the bridge stashed (BmFiberRedispatch / BmRootUnwind /
            // thread_terminated / anything) from this normally-unwindable frame.
            if (t_jit_pending_exc) { std::exception_ptr e = t_jit_pending_exc; t_jit_pending_exc = nullptr; std::rethrow_exception(e); }
            throw ultramodern::thread_terminated{};
        }
        return;
    }
    // gap_jit returned null. Two cases: (a) the bytes aren't a function (gap_function_length == 0), or (b) the
    // bytes ARE a real function but the LiveGenerator couldn't codegen it (good=0). gap_jit already verified
    // is_code, so distinguish here: if it's still code, fall back to the robust MIPS interpreter (handles every
    // instruction, just slower than the JIT); otherwise no-op (fail safe — no wild store on genuine data).
    // [gap-tail census 2026-08-27] Which tail does a gap call actually take? Measured need: the
    // SOTE drain invokes the guest exception vector through this trampoline 60x/sec and ZERO erets
    // come back out, so we must know whether the handler is being INTERPRETED or silently NO-OPed
    // by the is_code fail-safe. Uncapped counters; every print in this engine is capped and six of
    // them misled the 08-27 hunt.
    if (recomp_interp_is_code(rdram, vaddr)) {
        g_gap_tail_interp.fetch_add(1, std::memory_order_relaxed);
        recomp_interp_set_target(vaddr);
        recomp_interp_trampoline(rdram, ctx);
    } else {
        g_gap_tail_noop.fetch_add(1, std::memory_order_relaxed);
        static bool _once = false;
        if (!_once) { _once = true;
            fprintf(stderr, "[gap-tail] NO-OP: vaddr=0x%08X is not is_code — a gap call did nothing%c", vaddr, 0x0A);
            fflush(stderr); }
    }
}
