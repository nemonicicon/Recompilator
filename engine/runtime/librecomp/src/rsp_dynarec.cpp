// rsp_dynarec.cpp — a LIVE RSP RECOMPILER (dynarec) built on the general-RSP interpreter.
//
// THE POINT: the interpreter (rsp_interp.cpp) reproduces the RSP and runs WHATEVER microcode a game
// loads into IMEM — game-agnostic across all 296 NTSC titles — but pays fetch/decode/dispatch/loop
// overhead on every instruction. This dynarec JITs each IMEM basic block to native code via sljit
// (which emits x86-64 on the desktop and aarch64 on ARM), keeping the interpreter as the base and
// the bit-exact ORACLE. It is a HYBRID JIT:
//   • the scalar/control hot path is emitted INLINE in sljit (lands in #10 — the speedup);
//   • the vector unit (rsp_cop2_dispatch/rsp_cop2_mem) and COP0/DMA (cop0_write) are reached by
//     sljit_emit_icall to the interpreter's PROVEN C++ handlers — no re-emitting the SIMD VU.
//
// MILESTONE #8 (this file, first cut): the SKELETON — block decoder (IMEM → block, boundary- and
// delay-slot-aware), the sljit scaffold (compiler → enter(rdram, state*) → [per-instr emit hook] →
// return), the block cache keyed by (entry PC, IMEM version) with overlay-swap invalidation, and the
// run loop with inter-block branch transfer. It COMPILES + LINKS and is ENGINE-INERT: nothing calls
// rsp_dynarec_run yet, and the per-instruction emit is a documented #9 hook, so no gfx path changes.
//
// #9 fills the emit hook with a call to scalar_step per instruction and VERIFIES bit-exact (cv64
// F3DEX2, RDP-stream CRC 7D078800) against the pure interpreter; #10 inlines the hot scalar ops.

#include <cstdint>
#include <cstdio>
#include <cstring>
#include <cstddef>   // offsetof
#include <vector>
#include <unordered_map>

#include "sljitLir.h"          // the JIT backend (x86-64 on desktop, aarch64 on ARM)
#include "rsp_interp.hpp"      // RspInterp, the decode helpers, imem_fetch, g_rsp_imem_version, the handlers

namespace recomp {
namespace rsp {

// ── The compiled-block calling convention ─────────────────────────────────────────────────────────
// Each block is `sljit_sw fn(uint8_t* rdram, RspInterp* state)`:
//   • rdram lands in SLJIT_S0, state* in SLJIT_S1 (sljit places args into the saved registers in order).
//     GPR i is then SLJIT_MEM1(SLJIT_S1), offsetof(RspInterp, gpr) + i*4.
//   • Returns 0 to keep running, 1 if the block hit a BREAK (task done) — mirrors scalar_step's bool.
// A taken branch/jump inside the block sets state->branch_pending / branch_target (the interpreter's
// handlers already do this); the RUN LOOP applies the transfer after the block returns.
using RspBlockFn = sljit_sw (*)(uint8_t* rdram, RspInterp* state);

[[maybe_unused]] static constexpr sljit_s32 REG_RDRAM = SLJIT_S0;   // arg0 (used by the #9/#10 inline emit)
[[maybe_unused]] static constexpr sljit_s32 REG_STATE = SLJIT_S1;   // arg1

// GPR i as an sljit memory operand base offset (state->gpr[i]). Used by the #10 inline emit.
[[maybe_unused]] static inline sljit_sw gpr_off(uint32_t i) { return (sljit_sw)(offsetof(RspInterp, gpr) + i * sizeof(uint32_t)); }

static constexpr sljit_sw PC_OFF = (sljit_sw)offsetof(RspInterp, pc);

// ── The call-threaded step wrapper (#9) ───────────────────────────────────────────────────────────
// sljit calls THIS per instruction. It forwards to the interpreter's proven scalar_step (the oracle's
// exact semantics) and returns 1 on BREAK / 0 otherwise (a clean int return — no bool-in-AL ABI
// ambiguity, and it turns scalar_step's RspInterp& into a pointer arg the JIT can pass in a register).
static int dyn_scalar_step(RspInterp* st, uint8_t* rdram, uint32_t w) {
    return scalar_step(*st, rdram, w) ? 1 : 0;
}

// ── Block boundary classification ─────────────────────────────────────────────────────────────────
enum class EndKind { None, Branch, Break };

// An instruction ends a basic block if it is a branch/jump (→ one delay slot follows, still in-block)
// or a BREAK (→ block ends immediately, task done). Mirrors scalar_step's control-flow set exactly.
static EndKind classify(uint32_t w) {
    switch (f_op(w)) {
    case 0x00: // SPECIAL
        switch (f_funct(w)) {
        case 0x08: case 0x09: return EndKind::Branch;  // JR / JALR
        case 0x0D:            return EndKind::Break;    // BREAK
        default:              return EndKind::None;
        }
    case 0x01:               return EndKind::Branch;    // REGIMM (BLTZ/BGEZ/BLTZAL/BGEZAL)
    case 0x02: case 0x03:    return EndKind::Branch;    // J / JAL
    case 0x04: case 0x05: case 0x06: case 0x07:
                             return EndKind::Branch;    // BEQ / BNE / BLEZ / BGTZ
    default:                 return EndKind::None;
    }
}

// ── A decoded, compiled block ─────────────────────────────────────────────────────────────────────
struct DynBlock {
    RspBlockFn fn       = nullptr;   // native entry (== the sljit code base)
    void*      code     = nullptr;   // sljit-owned executable memory (freed on cache invalidation)
    uint32_t   entry_pc = 0;
    uint32_t   end_pc   = 0;         // sequential PC after the last in-block instruction (fall-through default)
    EndKind    end_kind = EndKind::None;
};

// ── Decode one basic block out of IMEM ────────────────────────────────────────────────────────────
// Walk instruction words from entry_pc until a boundary; a branch/jump pulls its delay slot in, then
// the block ends. `out` receives (pc, word) pairs in program order; returns the block's end_kind and
// writes the fall-through end_pc. A safety cap bounds a runaway (missing boundary) to one IMEM's worth.
static EndKind decode_block(const RspInterp& st, uint32_t entry_pc,
                            std::vector<std::pair<uint32_t, uint32_t>>& out, uint32_t& end_pc) {
    out.clear();
    uint32_t pc = entry_pc & 0xFFF;
    const uint32_t cap = 1024;   // 4KB IMEM / 4 bytes — cannot legitimately exceed this in one block
    for (uint32_t n = 0; n < cap; ++n) {
        uint32_t w = imem_fetch(st, pc);
        out.emplace_back(pc, w);
        EndKind k = classify(w);
        pc = (pc + 4) & 0xFFF;
        if (k == EndKind::Break) { end_pc = pc; return EndKind::Break; }
        if (k == EndKind::Branch) {
            // Pull in the delay-slot instruction; then the block ends.
            uint32_t dw = imem_fetch(st, pc);
            out.emplace_back(pc, dw);
            pc = (pc + 4) & 0xFFF;
            end_pc = pc;
            return EndKind::Branch;
        }
    }
    end_pc = pc;
    return EndKind::None;   // cap hit: treat as a fall-through block (rare; the run loop continues sequentially)
}

// ── #10: inline the hot scalar ops directly in sljit (no per-instruction call-out) ─────────────────
// Returns true if the instruction was fully emitted inline. These ops touch ONLY the GPRs — never
// pc/branch_pending, DMEM (the ^3 swizzle), or the VU — so they need no st.pc store and no BREAK check.
// r0 is hardwired: a write targeting reg 0 is dropped (the op becomes a no-op), matching the
// interpreter's trailing R[0]=0. Everything pc-sensitive or memory/VU/COP0 (branches, jumps, JR/JALR,
// BREAK, loads/stores, LWC2/SWC2, COP0, COP2) — plus SLT/SLTU/SLTI/SLTIU (need flag materialization) —
// returns false and stays call-threaded (bit-exact, just not yet inlined). R0/R1 are scratch temps.
static bool emit_inline_scalar(sljit_compiler* c, uint32_t w) {
    const sljit_s32 S = REG_STATE;
    const uint32_t op = f_op(w);
    const uint32_t rs = f_rs(w), rt = f_rt(w), rd = f_rd(w), sa = f_sa(w);

    // rd = [rs] OP [rt]   (load rs→R0, R0 OP= [rt], store R0→rd; ≤1 memory operand per sljit op)
    auto rrr = [&](sljit_s32 sop) {
        if (rd == 0) return;
        sljit_emit_op1(c, SLJIT_MOV32, SLJIT_R0, 0, SLJIT_MEM1(S), gpr_off(rs));
        sljit_emit_op2(c, sop, SLJIT_R0, 0, SLJIT_R0, 0, SLJIT_MEM1(S), gpr_off(rt));
        sljit_emit_op1(c, SLJIT_MOV32, SLJIT_MEM1(S), gpr_off(rd), SLJIT_R0, 0);
    };
    // rd = [rt] SHIFT sa   (immediate shift amount)
    auto shimm = [&](sljit_s32 sop) {
        if (rd == 0) return;
        sljit_emit_op2(c, sop, SLJIT_R0, 0, SLJIT_MEM1(S), gpr_off(rt), SLJIT_IMM, (sljit_sw)sa);
        sljit_emit_op1(c, SLJIT_MOV32, SLJIT_MEM1(S), gpr_off(rd), SLJIT_R0, 0);
    };
    // rd = [rt] SHIFT ([rs] & 31)   (variable shift; mask to match the interpreter)
    auto shvar = [&](sljit_s32 sop) {
        if (rd == 0) return;
        sljit_emit_op2(c, SLJIT_AND32, SLJIT_R1, 0, SLJIT_MEM1(S), gpr_off(rs), SLJIT_IMM, 31);
        sljit_emit_op2(c, sop, SLJIT_R0, 0, SLJIT_MEM1(S), gpr_off(rt), SLJIT_R1, 0);
        sljit_emit_op1(c, SLJIT_MOV32, SLJIT_MEM1(S), gpr_off(rd), SLJIT_R0, 0);
    };
    // rt = [rs] OP imm
    auto rri = [&](sljit_s32 sop, sljit_sw imm) {
        if (rt == 0) return;
        sljit_emit_op2(c, sop, SLJIT_R0, 0, SLJIT_MEM1(S), gpr_off(rs), SLJIT_IMM, imm);
        sljit_emit_op1(c, SLJIT_MOV32, SLJIT_MEM1(S), gpr_off(rt), SLJIT_R0, 0);
    };

    switch (op) {
    case 0x00: // SPECIAL
        switch (f_funct(w)) {
        case 0x00: shimm(SLJIT_SHL32);  return true;         // SLL
        case 0x02: shimm(SLJIT_LSHR32); return true;         // SRL
        case 0x03: shimm(SLJIT_ASHR32); return true;         // SRA
        case 0x04: shvar(SLJIT_SHL32);  return true;         // SLLV
        case 0x06: shvar(SLJIT_LSHR32); return true;         // SRLV
        case 0x07: shvar(SLJIT_ASHR32); return true;         // SRAV
        case 0x20: case 0x21: rrr(SLJIT_ADD32); return true; // ADD / ADDU
        case 0x22: case 0x23: rrr(SLJIT_SUB32); return true; // SUB / SUBU
        case 0x24: rrr(SLJIT_AND32); return true;            // AND
        case 0x25: rrr(SLJIT_OR32);  return true;            // OR
        case 0x26: rrr(SLJIT_XOR32); return true;            // XOR
        case 0x27:                                           // NOR = ~([rs] | [rt])
            if (rd != 0) {
                sljit_emit_op1(c, SLJIT_MOV32, SLJIT_R0, 0, SLJIT_MEM1(S), gpr_off(rs));
                sljit_emit_op2(c, SLJIT_OR32,  SLJIT_R0, 0, SLJIT_R0, 0, SLJIT_MEM1(S), gpr_off(rt));
                sljit_emit_op2(c, SLJIT_XOR32, SLJIT_R0, 0, SLJIT_R0, 0, SLJIT_IMM, (sljit_sw)-1);
                sljit_emit_op1(c, SLJIT_MOV32, SLJIT_MEM1(S), gpr_off(rd), SLJIT_R0, 0);
            }
            return true;
        default: return false;   // SLT/SLTU/JR/JALR/BREAK/... → call-threaded
        }
    case 0x08: case 0x09: rri(SLJIT_ADD32, (sljit_sw)f_simm(w)); return true;              // ADDI / ADDIU
    case 0x0C: rri(SLJIT_AND32, (sljit_sw)f_uimm(w)); return true;                          // ANDI
    case 0x0D: rri(SLJIT_OR32,  (sljit_sw)f_uimm(w)); return true;                          // ORI
    case 0x0E: rri(SLJIT_XOR32, (sljit_sw)f_uimm(w)); return true;                          // XORI
    case 0x0F:                                                                              // LUI
        if (rt != 0)
            sljit_emit_op1(c, SLJIT_MOV32, SLJIT_MEM1(S), gpr_off(rt), SLJIT_IMM, (sljit_sw)(f_uimm(w) << 16));
        return true;
    default: return false;   // SLTI/SLTIU/branches/loads/stores/COP0/COP2 → call-threaded
    }
}

// ── sljit emit of one instruction (#9 call-threaded fallback for ops not inlined by #10) ───────────
// Emits, per instruction:
//   state->pc = (pc+4) & 0xFFF        (scalar_step reads pc as the delay-slot address for branch/link
//                                       targets — R[31]=pc+4, branch_target=pc+(off<<2); EXACTLY the
//                                       interpreter's fetch order, which advances pc before scalar_step)
//   R0=state, R1=rdram, R2=word ; call dyn_scalar_step ; if (ret != 0) goto break  (BREAK → return 1)
// A taken branch/jump sets state->branch_pending/branch_target inside scalar_step; the run loop applies
// the transfer after the block returns. #10 replaces the icall with inline sljit for the hot scalar ops.
static void emit_instruction(sljit_compiler* c, uint32_t pc, uint32_t word,
                             std::vector<sljit_jump*>& break_jumps) {
    // state->pc = (pc + 4) & 0xFFF
    sljit_emit_op1(c, SLJIT_MOV32, SLJIT_MEM1(REG_STATE), PC_OFF, SLJIT_IMM, (sljit_sw)((pc + 4) & 0xFFF));
    // args: R0 = state* (S1), R1 = rdram* (S0), R2 = instruction word (constant)
    sljit_emit_op1(c, SLJIT_MOV,   SLJIT_R0, 0, REG_STATE, 0);
    sljit_emit_op1(c, SLJIT_MOV,   SLJIT_R1, 0, REG_RDRAM, 0);
    sljit_emit_op1(c, SLJIT_MOV32, SLJIT_R2, 0, SLJIT_IMM, (sljit_sw)word);
    sljit_emit_icall(c, SLJIT_CALL, SLJIT_ARGS3(32, P, P, 32), SLJIT_IMM, sljit_sw(&dyn_scalar_step));
    // if scalar_step returned non-zero (BREAK), jump to the block's break-return.
    break_jumps.push_back(sljit_emit_cmp(c, SLJIT_NOT_EQUAL, SLJIT_R0, 0, SLJIT_IMM, 0));
}

// ── Compile a block to native code ────────────────────────────────────────────────────────────────
// Builds `sljit_sw fn(uint8_t* rdram, RspInterp* state)`: enter → per-instruction emit → return 0.
// Returns a populated DynBlock (fn/code null on failure).
static DynBlock compile_block(const RspInterp& st, uint32_t entry_pc) {
    DynBlock blk{};
    blk.entry_pc = entry_pc & 0xFFF;

    std::vector<std::pair<uint32_t, uint32_t>> instrs;
    blk.end_kind = decode_block(st, blk.entry_pc, instrs, blk.end_pc);

    sljit_compiler* c = sljit_create_compiler(nullptr);
    if (c == nullptr) {
        return blk;   // fn/code stay null → caller falls back (run loop treats as unsupported)
    }

    // Prologue: two pointer args (rdram→S0, state→S1), returns a word. Scratch R0..R2 for icall args,
    // saved S0..S1 for the two args (extra headroom leaves room for #10's inline temporaries).
    sljit_emit_enter(c, 0, SLJIT_ARGS2(W, P, P), /*scratch*/ 4, /*saved*/ 3, /*local*/ 0);

    std::vector<sljit_jump*> break_jumps;
    for (const auto& [pc, word] : instrs) {
        if (emit_inline_scalar(c, word)) continue;   // #10 fast path (GPR-only ops, no call-out)
        emit_instruction(c, pc, word, break_jumps);  // call-threaded: pc-sensitive / memory / VU / COP0
    }

    // Epilogue: no BREAK hit → return 0 (keep-running). A BREAK jumps past this to `return 1`.
    sljit_emit_return(c, SLJIT_MOV, SLJIT_IMM, 0);
    if (!break_jumps.empty()) {
        sljit_label* brk = sljit_emit_label(c);
        sljit_emit_return(c, SLJIT_MOV, SLJIT_IMM, 1);
        for (sljit_jump* j : break_jumps) sljit_set_label(j, brk);
    }

    blk.code = sljit_generate_code(c, 0, nullptr);
    sljit_free_compiler(c);   // the generated code outlives the compiler; freed via sljit_free_code on eviction
    blk.fn = reinterpret_cast<RspBlockFn>(blk.code);
    return blk;
}

// ── Block cache — keyed by (entry PC, IMEM version) ───────────────────────────────────────────────
// IMEM is only 4KB and games overlay-swap text into it mid-frame; g_rsp_imem_version (bumped by
// imem_dma_in) folds "which IMEM contents" into the key, so a block compiled against old text is never
// reused after a swap. On a version change we drop the whole cache (freeing each block's code).
// NOTE (#10 perf): the whole cache is flushed on a version change, so the key is just entry_pc within
// a version. F3DEX2 reloads overlay text frequently, so this recompiles blocks after each swap — fine
// for #8/#9 correctness; #10 can switch to keying on an IMEM content hash to avoid the re-thrash.
static std::unordered_map<uint32_t, DynBlock> s_block_cache;
static uint64_t s_cache_version = ~0ull;   // force a first-use sync with g_rsp_imem_version

static inline uint32_t block_key(uint32_t entry_pc) { return entry_pc & 0xFFF; }

static void flush_block_cache() {
    for (auto& [k, blk] : s_block_cache) {
        if (blk.code) sljit_free_code(blk.code, nullptr);
    }
    s_block_cache.clear();
}

static DynBlock& get_block(const RspInterp& st, uint32_t entry_pc) {
    if (s_cache_version != g_rsp_imem_version) {
        flush_block_cache();                 // IMEM changed → all cached blocks are stale
        s_cache_version = g_rsp_imem_version;
    }
    uint32_t key = block_key(entry_pc);
    auto it = s_block_cache.find(key);
    if (it != s_block_cache.end()) {
        return it->second;
    }
    auto [ins, _] = s_block_cache.emplace(key, compile_block(st, entry_pc));
    return ins->second;
}

// ── Run one RSP task to BREAK via the dynarec ─────────────────────────────────────────────────────
// Mirrors rsp_interp_run's setup (IMEM load + rspboot register handoff), then drives blocks instead of
// single-stepping: fetch/compile the block at st.pc, run it, apply the inter-block branch transfer.
// ENGINE-INERT for #8 (no caller); once #9 fills the emit hook this returns the real task result.
RspExitReason rsp_dynarec_run(uint8_t* rdram, uint32_t ucode_paddr, uint32_t ucode_size,
                              uint32_t imem_load_off, uint32_t entry_pc) {
    static RspInterp st;   // one RSP unit; DMEM (dmem[]) already persists across tasks
    std::memset(st.gpr, 0, sizeof(st.gpr));
    imem_dma_in(st, rdram, imem_load_off, ucode_paddr, ucode_size);   // resident text → IMEM (bumps version)
    st.pc = entry_pc & 0xFFF;
    st.branch_pending = false;

    // rspboot register handoff (verbatim from rsp_interp_run): r1 = OSTask base in DMEM, r2 = ucode base
    // (Fast3D adds overlay/DL offsets to it), r3 = text RD_LEN, r7 = entry (SP_MEM_ADDR form).
    st.gpr[1] = 0xFC0;
    st.gpr[2] = RSP_MEM_W_LOAD(0, 0xFD0);
    st.gpr[3] = (ucode_size - 1) & 0xFFF;
    st.gpr[7] = 0x1000 | (imem_load_off & 0xFFF);

    // Guard against a runaway (a decode/semantics gap or an empty #8 block that never advances PC):
    // bound the number of block dispatches, mirroring the interpreter's watchdog.
    for (uint64_t guard = 0; guard < 20'000'000ull; ++guard) {
        DynBlock& blk = get_block(st, st.pc);
        if (blk.fn == nullptr) {
            return RspExitReason::Unsupported;   // compile failed
        }
        sljit_sw broke = blk.fn(rdram, &st);
        // Authoritatively set the next pc AFTER the block. The block's per-instruction st.pc writes are
        // only transient (a call-out branch stores pc+4 so scalar_step can compute its target), and #10's
        // inlined ops don't touch st.pc at all — so the block's final st.pc is NOT reliable. Control flow
        // is decided solely by branch_pending: a taken branch/jump → branch_target; otherwise the block
        // fell through → blk.end_pc (the sequential pc past the last instruction).
        if (st.branch_pending) {
            st.pc = st.branch_target & 0xFFF;
            st.branch_pending = false;
        } else {
            st.pc = blk.end_pc & 0xFFF;
        }
        if (broke) {
            return RspExitReason::Broke;
        }
    }
    fprintf(stderr, "[rsp_dynarec] guard tripped — runaway (decode/semantics gap)\n");
    fflush(stderr);
    return RspExitReason::Unsupported;
}

} // namespace rsp
} // namespace recomp
