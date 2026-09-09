// rsp_interp.cpp — a GENERAL RSP execution engine (interpreter).
//
// THE POINT: the N64's RSP is a programmable vector coprocessor — a scalar MIPS core plus an 8-lane
// 16-bit vector unit — that runs whatever *microcode* a game loads (F3DEX2, Fast3D, S2DEX, custom
// Rare/Factor5 ucodes...). The prior approach STATICALLY recompiled one specific microcode per game
// (RSPRecomp → f3dex2.cpp). That's a per-microcode treadmill. This is the hardware-faithful
// alternative: reproduce the RSP itself, and let it execute ANY microcode's instructions out of IMEM.
// One engine → the whole NTSC library.
//
// WHAT WE REUSE (not written here):
//   • The vector unit — every COP2 op — is the Ares RSP in rsp_vu.hpp (struct RSP / RSP::VU). DONE.
//   • DMEM + its ^3 byte-swizzle access, the SP DMA (dma_rdram_to_dmem/dmem_to_rdram), and the
//     DPC→softrdp command path (SET_DP_START/DO_DP_END → rsp_process_rdp_commands) — all in rsp.hpp.
// WHAT'S NEW HERE: IMEM, the fetch/decode/execute loop, the scalar MIPS core, and COP2 dispatch into
// the Ares VU methods (increment 2).
//
// Correctness oracle: run cv64's F3DEX2 microcode through this and diff the emitted RDP command stream
// against the existing F3DEX2 LLE's known-good CRC 7D078800. Bit-match ⇒ the general RSP is correct,
// and Fast3D (sm64) then "just runs".
//
// Encoding reference: rabbitizer (the RSP ISA), as used by RSPRecomp/src/rsp_recomp.cpp.
//
// STATUS: increment 1 — scalar core (ALU / load-store / branch / jump / COP0). COP2 (vector) dispatch,
// SP-status/semaphore, DMA-kick and BREAK/task wiring land in increments 2-3. Desktop-buildable +
// engine-inert until wired to a task (no caller yet).

#include <cstdint>
#include <cstdio>
#include <cstring>
#include <cstdlib>   // getenv — the optional profiler gate
#include <chrono>    // steady_clock — the optional profiler timing

#include "librecomp/rsp.hpp"          // dmem[], RSP_MEM_* (^3 swizzle), DMA, DPC macros, RspExitReason, AND
                                      // (transitively) rsp_vu.hpp → struct RSP, the Ares vector unit. NOTE:
                                      // rsp_vu.hpp has no include guard, so include it ONLY via rsp.hpp.
#include "librecomp/rsp_vu_impl.hpp"  // the Ares VU op DEFINITIONS (templates) — needed HERE because our
                                      // COP2 dispatch instantiates VMULF<0..15> etc.; without it those
                                      // instantiations are undefined externals at link. (Has no guard,
                                      // but rsp_vu.hpp only DECLARES — impl is a separate 1-time include.)
#include "recomp.h"                   // MEM_B — RDRAM access (to load IMEM from the ucode)
#include "rsp_interp.hpp"             // RspInterp, the MIPS-field decode helpers, imem_fetch, g_rsp_imem_version,
                                      // and the DE-STATIC'd handler declarations shared with rsp_dynarec.cpp

namespace recomp {
namespace rsp {

// RspInterp, f_op/.../f_jtgt, and imem_fetch now live in rsp_interp.hpp (shared with the dynarec).

// IMEM version counter — bumped by imem_dma_in on every IMEM change so the dynarec can key its block
// cache on (entry PC, version) and drop stale blocks after an overlay swap. See rsp_interp.hpp.
uint64_t g_rsp_imem_version = 0;

// ── IMEM / fetch ────────────────────────────────────────────────────────────────────────────────
// The RSP fetches 32-bit big-endian instruction words from IMEM. RDRAM in this runtime is ^3-byte-
// swizzled (MEM_B(0, addr) with the ^3), so read the ucode byte-by-byte and assemble big-endian.
// Load big-endian instruction words from RDRAM into IMEM at a byte offset. Used for BOTH the initial
// resident-text load at task start AND runtime OVERLAY SWAPS: F3DEX2's text is >4KB, so it DMAs new
// text into IMEM mid-frame via an SP DMA (SP_MEM_ADDR bit12 set). RDRAM is ^3-byte-swizzled, so read
// byte-by-byte and assemble big-endian; wraps within the 4KB IMEM.
void imem_dma_in(RspInterp& st, uint8_t* rdram, uint32_t imem_off, uint32_t dram_paddr, uint32_t len_bytes) {
    ++g_rsp_imem_version;   // IMEM contents change here (resident load + overlay swaps) → invalidate dynarec blocks
    { const char* _t = getenv("RSPDMA_TRACE"); if (_t && _t[0]=='1') { static int _n=0; if (_n<24) { fprintf(stderr,"[imemdma] #%d imem_off=0x%03X src=0x%08X len=%u  (ucode-rel off if src near base)\n",_n,imem_off,(unsigned)dram_paddr,(unsigned)len_bytes); fflush(stderr); _n++; } } }
    if (len_bytes > 0x1000) len_bytes = 0x1000;
    for (uint32_t i = 0; i + 4 <= len_bytes; i += 4) {
        uint32_t d  = dram_paddr + i;
        uint32_t b0 = (uint8_t)MEM_B(0, (int64_t)(int32_t)(d + 0 + 0x80000000));
        uint32_t b1 = (uint8_t)MEM_B(0, (int64_t)(int32_t)(d + 1 + 0x80000000));
        uint32_t b2 = (uint8_t)MEM_B(0, (int64_t)(int32_t)(d + 2 + 0x80000000));
        uint32_t b3 = (uint8_t)MEM_B(0, (int64_t)(int32_t)(d + 3 + 0x80000000));
        st.imem[((imem_off + i) & 0xFFF) >> 2] = (b0 << 24) | (b1 << 16) | (b2 << 8) | b3;   // big-endian word
    }
}

// imem_fetch and the MIPS-field decode helpers (f_op/.../f_jtgt) are in rsp_interp.hpp (shared).
// rsp_cop2_dispatch / rsp_cop2_mem are declared there too (de-static'd for the dynarec); their
// definitions are below.

// ── COP0 (SP + DPC control registers) ───────────────────────────────────────────────────────────
// MFC0: most SP status/DMA regs read as 0 (we model DMAs as instant / no flags). The DPC (RDP FIFO)
// regs read back the captured pointers so a gfx ucode's "how far has the RDP consumed" polling sees an
// empty, ready FIFO. MTC0: DMA setup (SP_MEM_ADDR/DRAM_ADDR/RD_LEN/WR_LEN) and DP_START/DP_END kick the
// RDP FIFO into softrdp. Register numbers per rabbitizer's Rsp::Cop0 (SP 0-7, DPC 8-15).
uint32_t cop0_read(RspInterp& st, uint8_t* rdram, uint32_t rd) {
    (void)st; (void)rdram;
    switch (rd) {
        case 4:  return 0;                 // SP_STATUS — halt/broke/dma flags all clear
        case 5:  return 0;                 // SP_DMA_FULL
        case 6:  return 0;                 // SP_DMA_BUSY
        case 7:  return 0;                 // SP_SEMAPHORE — always acquirable
        case 8:  return g_rsp_dpc_start;   // DPC_START
        case 9:  return g_rsp_dpc_end;     // DPC_END
        case 10: return g_rsp_dpc_current; // DPC_CURRENT — model RDP as caught up
        case 11: return 0;                 // DPC_STATUS
        default: return 0;
    }
}

// DMA staging registers (SP_MEM_ADDR / SP_DRAM_ADDR); RD_LEN/WR_LEN kick the transfer.
static uint32_t s_dma_mem  = 0;
static uint32_t s_dma_dram = 0;

void cop0_write(RspInterp& st, uint8_t* rdram, uint32_t rd, uint32_t val) {
    switch (rd) {
        case 0: s_dma_mem  = val & 0x1FFF; break;                        // SP_MEM_ADDR (bit12=IMEM/DMEM, 11-0=off)
        case 1: s_dma_dram = val;          break;                        // SP_DRAM_ADDR
        case 2: {  // SP_RD_LEN — DMA RDRAM → SP memory. bit12 of SP_MEM_ADDR selects IMEM (overlay swap) vs DMEM.
            static int _nd = 0; static int _ni = 0;
            // IMEM DMAs (overlay swaps) get their own budget — the first 28-DMA cap hid swaps C/A
            // during the 2026-07-24 F3DEX2 hunt; they're rare and name the real slot geometry.
            if (_nd < 28 || ((s_dma_mem & 0x1000) && _ni < 64)) { _nd++; if (s_dma_mem & 0x1000) _ni++;
                fprintf(stderr, "[grsp-dma] #%d %s mem=%03X dram=%08X len=%X\n",
                _nd, (s_dma_mem & 0x1000) ? "IMEM" : "DMEM", s_dma_mem & 0xFFF, s_dma_dram, (val & 0xFFF) + 1); fflush(stderr); }
            /* 8-byte-unit law (see dma_rdram_to_dmem): the RSP DMA engine rounds the transfer
             * length UP to a multiple of 8. The DMEM path applies it inside the helper; the IMEM
             * path passes a length straight through, so round it here too — an overlay swap that
             * lost its tail words would fetch stale microcode. */
            if (s_dma_mem & 0x1000) imem_dma_in(st, rdram, s_dma_mem & 0xFFF, s_dma_dram, (((val & 0xFFF) + 1) + 7u) & ~7u);
            else                    dma_rdram_to_dmem(rdram, s_dma_mem & 0xFFF, s_dma_dram, val);
            break;
        }
        case 3: dma_dmem_to_rdram(rdram, s_dma_mem & 0xFFF, s_dma_dram, val); break;  // SP_WR_LEN — DMA out (DMEM)
        case 8: SET_DP_START(val); break;                               // DPC_START
        case 9: DO_DP_END(val);    break;                               // DPC_END → rsp_process_rdp_commands → softrdp
        default: break;
    }
}

// ── Indirect-jump census (RSP_JUMP_CENSUS=1) — the toml-completion instrument ──────────────────
// UCODE-CATALOG rung (2026-07-24): when cracking a family's layout for RSPRecomp, the config needs
// every indirect-branch target (extra_indirect_branch_targets). Tables in the ucode's data cover
// most, but COMPUTED targets (e.g. F3DLX's 0x1824, reached from the command-loop jr $21) appear
// nowhere as constants. This records every unique (origin PC, target) an actual run performs —
// run the interp over captured tasks, feed the census back into the toml. Instrument only; inert
// unless the env is set (one static-bool test per taken JR/JALR).
static void jump_census_note(uint32_t origin_pc, uint32_t target) {
    static const bool on = [] { const char* e = getenv("RSP_JUMP_CENSUS"); return e && e[0] == '1'; }();
    if (on) {
        static uint32_t seen[2048]; static int n = 0;
        const uint32_t key = ((origin_pc & 0xFFF) << 12) | (target & 0xFFF);
        bool dup = false;
        for (int i = 0; i < n; i++) if (seen[i] == key) { dup = true; break; }
        if (!dup) {
            if (n < 2048) seen[n++] = key;
            fprintf(stderr, "[jumpcensus] pc=0x%03X -> target=0x%03X (raw=0x%08X)\n",
                    origin_pc & 0xFFF, target & 0xFFF, target);
        }
    }
    // RSP_TRACE_JUMPS=<N>: ORDERED trace of the first N taken JR/JALRs (sequence, not census —
    // the divergence-window localizer for A/B path comparison).
    static const int trace_n = [] {
        const char* e = getenv("RSP_TRACE_JUMPS");
        return e ? atoi(e) : 0;
    }();
    if (trace_n > 0) {
        static int traced = 0;
        if (traced < trace_n) {
            traced++;
            fprintf(stderr, "[jumptrace] #%d pc=0x%03X -> 0x%03X\n",
                    traced, origin_pc & 0xFFF, target & 0xFFF);
        }
    }
}

// ── DMEM store-watch (RSP_DMEM_WATCH=<hex addr>) — path-divergence localizer ───────────────────
// Companion instrument to the jump census: logs the PC and value of every scalar store that
// covers the watched DMEM address. Use: when an A/B divergence traces to "cell X held the wrong
// value", the watch names the real ucode's store site(s) for X; the generated code's copy of that
// site is where the recomp path split. Inert unless the env names an address.
static void dmem_watch_note(uint32_t origin_pc, uint32_t addr, uint32_t size, uint32_t val) {
    static const int32_t watch = [] {
        const char* e = getenv("RSP_DMEM_WATCH");
        return e ? (int32_t)strtoul(e, nullptr, 16) : -1;
    }();
    if (watch < 0) return;
    const uint32_t a = addr & 0xFFF;
    if ((uint32_t)watch < a || (uint32_t)watch >= a + size) return;
    static int logs = 0;
    if (logs < 512) {
        logs++;
        fprintf(stderr, "[dmemwatch] pc=0x%03X store%u dmem=0x%03X val=0x%08X\n",
                origin_pc & 0xFFF, size, a, val);
    }
}

// ── Scalar step ─────────────────────────────────────────────────────────────────────────────────
// Executes ONE scalar instruction word. Returns false to keep running, true to BREAK (task done).
// Branches/jumps set the delay-slot machinery; the caller runs the next (delay) instruction, then
// applies the transfer.
bool scalar_step(RspInterp& st, uint8_t* rdram, uint32_t w) {
    auto& R = st.gpr;
    const uint32_t rs = f_rs(w), rt = f_rt(w), rd = f_rd(w), sa = f_sa(w);
    auto take_branch = [&](bool cond, int32_t off) { if (cond) { st.branch_pending = true; st.branch_target = st.pc + (off << 2); } };

    switch (f_op(w)) {
    case 0x00: // SPECIAL
        switch (f_funct(w)) {
        case 0x00: R[rd] = R[rt] << sa; break;                                   // SLL
        case 0x02: R[rd] = R[rt] >> sa; break;                                   // SRL
        case 0x03: R[rd] = (uint32_t)((int32_t)R[rt] >> sa); break;              // SRA
        case 0x04: R[rd] = R[rt] << (R[rs] & 31); break;                         // SLLV
        case 0x06: R[rd] = R[rt] >> (R[rs] & 31); break;                         // SRLV
        case 0x07: R[rd] = (uint32_t)((int32_t)R[rt] >> (R[rs] & 31)); break;    // SRAV
        case 0x08: jump_census_note(st.pc - 4, R[rs]); st.branch_pending = true; st.branch_target = R[rs]; break;    // JR
        case 0x09: jump_census_note(st.pc - 4, R[rs]); R[rd] = st.pc + 4; st.branch_pending = true; st.branch_target = R[rs]; break; // JALR
        case 0x0D: return true;                                                  // BREAK — task done
        case 0x20: case 0x21: R[rd] = R[rs] + R[rt]; break;                      // ADD/ADDU (no RSP scalar trap)
        case 0x22: case 0x23: R[rd] = R[rs] - R[rt]; break;                      // SUB/SUBU
        case 0x24: R[rd] = R[rs] & R[rt]; break;                                 // AND
        case 0x25: R[rd] = R[rs] | R[rt]; break;                                 // OR
        case 0x26: R[rd] = R[rs] ^ R[rt]; break;                                 // XOR
        case 0x27: R[rd] = ~(R[rs] | R[rt]); break;                             // NOR
        case 0x2A: R[rd] = (int32_t)R[rs] < (int32_t)R[rt]; break;               // SLT
        case 0x2B: R[rd] = R[rs] < R[rt]; break;                                 // SLTU
        default: break;
        }
        break;
    case 0x01: // REGIMM
        switch (rt) {
        case 0x00: take_branch((int32_t)R[rs] <  0, f_simm(w)); break;           // BLTZ
        case 0x01: take_branch((int32_t)R[rs] >= 0, f_simm(w)); break;           // BGEZ
        case 0x10: R[31] = st.pc + 4; take_branch((int32_t)R[rs] <  0, f_simm(w)); break; // BLTZAL
        case 0x11: R[31] = st.pc + 4; take_branch((int32_t)R[rs] >= 0, f_simm(w)); break; // BGEZAL
        default: break;
        }
        break;
    case 0x02: st.branch_pending = true; st.branch_target = f_jtgt(w); break;    // J
    case 0x03: R[31] = st.pc + 4; st.branch_pending = true; st.branch_target = f_jtgt(w); break; // JAL
    case 0x04: take_branch(R[rs] == R[rt], f_simm(w)); break;                    // BEQ
    case 0x05: take_branch(R[rs] != R[rt], f_simm(w)); break;                    // BNE
    case 0x06: take_branch((int32_t)R[rs] <= 0, f_simm(w)); break;               // BLEZ
    case 0x07: take_branch((int32_t)R[rs] >  0, f_simm(w)); break;               // BGTZ
    case 0x08: case 0x09: R[rt] = R[rs] + f_simm(w); break;                      // ADDI/ADDIU
    case 0x0A: R[rt] = (int32_t)R[rs] < f_simm(w); break;                        // SLTI
    case 0x0B: R[rt] = R[rs] < (uint32_t)f_simm(w); break;                       // SLTIU
    case 0x0C: R[rt] = R[rs] & f_uimm(w); break;                                 // ANDI
    case 0x0D: R[rt] = R[rs] | f_uimm(w); break;                                 // ORI
    case 0x0E: R[rt] = R[rs] ^ f_uimm(w); break;                                 // XORI
    case 0x0F: R[rt] = f_uimm(w) << 16; break;                                   // LUI
    case 0x10: // COP0
        if (rs == 0)      R[rt] = cop0_read(st, rdram, rd);                      // MFC0
        else if (rs == 4) cop0_write(st, rdram, rd, R[rt]);                      // MTC0
        break;
    case 0x12: rsp_cop2_dispatch(st, w); break;                                  // COP2 (vector) — increment 2
    // DMEM loads/stores (addr = base + simm, masked to DMEM by the ^3 macros)
    case 0x20: R[rt] = (int32_t)(int8_t) RSP_MEM_BU(0, R[rs] + f_simm(w)); break;         // LB
    case 0x21: R[rt] = (int32_t)(int16_t)RSP_MEM_H_LOAD(0, R[rs] + f_simm(w)); break;     // LH
    case 0x23: R[rt] = RSP_MEM_W_LOAD(0, R[rs] + f_simm(w)); break;                       // LW
    case 0x24: R[rt] = (uint8_t) RSP_MEM_BU(0, R[rs] + f_simm(w)); break;                 // LBU
    case 0x25: R[rt] = RSP_MEM_HU_LOAD(0, R[rs] + f_simm(w)); break;                      // LHU
    case 0x28: dmem_watch_note(st.pc - 4, R[rs] + f_simm(w), 1, R[rt]); RSP_MEM_BU(0, R[rs] + f_simm(w)) = (uint8_t)R[rt]; break;                  // SB
    case 0x29: dmem_watch_note(st.pc - 4, R[rs] + f_simm(w), 2, R[rt]); RSP_MEM_H_STORE(0, R[rs] + f_simm(w), R[rt]); break;                       // SH
    case 0x2B: dmem_watch_note(st.pc - 4, R[rs] + f_simm(w), 4, R[rt]); RSP_MEM_W_STORE(0, R[rs] + f_simm(w), R[rt]); break;                       // SW
    case 0x32: rsp_cop2_mem(st, w); break;   // LWC2 — vector loads  (LBV/LSV/LLV/LDV/LQV/LRV/LPV/LUV/LHV/LFV/LTV)
    case 0x3A: rsp_cop2_mem(st, w); break;   // SWC2 — vector stores (SBV/SSV/SLV/SDV/SQV/SRV/SPV/SUV/SHV/SFV/SWV/STV)
    default: break;   // unhandled scalar op — surface as coverage gaps appear
    }
    R[0] = 0;   // r0 stays hardwired to 0
    return false;
}

// ── COP2 (vector unit) dispatch ───────────────────────────────────────────────────────────────────
// opcode 0x12. bit25=1 ⇒ a vector COMPUTE / de-class op (e=bits24-21, vt=20-16, vs=15-11, vd=10-6,
// funct=5-0); bit25=0 ⇒ a register transfer selected by rs=bits25-21 (MFC2 0, CFC2 2, MTC2 4, CTC2 6).
// Call convention verbatim from the recompiled f3dex2 emit + rabbitizer's vector_operands table:
//   compute  Vd,Vs,Vt : rsp.OP<e>(vpu.r[vd], vpu.r[vs], vpu.r[vt])
//   de-class Vd,De,Vt : rsp.OP<e>(vpu.r[vd], de&7,      vpu.r[vt])   (funct 0x30-0x36)
//   mfc2/mtc2         : rsp.OP<el>(gpr[rt],  vpu.r[vs])              (el = elementlow = bits10-7)
//   cfc2/ctc2         : rsp.OP(gpr[rt], rd)                         (rd = control reg; no element)
// The <e>/<el> template arg is compile-time, so a 16-way switch materializes each lane (mechanical; the
// compiler keeps only the taken one). Element fields: elementhigh=bits24-21 (compute/de), elementlow=
// bits10-7 (mfc2/mtc2). Encoding pinned from rabbitizer rsp_cop2_vu.inc / rsp_cop2.inc + RabbitizerInstructionRsp.h.
#define VU_E3(OP)  switch(e){ \
    case 0x0:V.OP<0x0>(D,S,T);break; case 0x1:V.OP<0x1>(D,S,T);break; case 0x2:V.OP<0x2>(D,S,T);break; case 0x3:V.OP<0x3>(D,S,T);break; \
    case 0x4:V.OP<0x4>(D,S,T);break; case 0x5:V.OP<0x5>(D,S,T);break; case 0x6:V.OP<0x6>(D,S,T);break; case 0x7:V.OP<0x7>(D,S,T);break; \
    case 0x8:V.OP<0x8>(D,S,T);break; case 0x9:V.OP<0x9>(D,S,T);break; case 0xA:V.OP<0xA>(D,S,T);break; case 0xB:V.OP<0xB>(D,S,T);break; \
    case 0xC:V.OP<0xC>(D,S,T);break; case 0xD:V.OP<0xD>(D,S,T);break; case 0xE:V.OP<0xE>(D,S,T);break; case 0xF:V.OP<0xF>(D,S,T);break; }
#define VU_E2(OP)  switch(e){ \
    case 0x0:V.OP<0x0>(D,S);break; case 0x1:V.OP<0x1>(D,S);break; case 0x2:V.OP<0x2>(D,S);break; case 0x3:V.OP<0x3>(D,S);break; \
    case 0x4:V.OP<0x4>(D,S);break; case 0x5:V.OP<0x5>(D,S);break; case 0x6:V.OP<0x6>(D,S);break; case 0x7:V.OP<0x7>(D,S);break; \
    case 0x8:V.OP<0x8>(D,S);break; case 0x9:V.OP<0x9>(D,S);break; case 0xA:V.OP<0xA>(D,S);break; case 0xB:V.OP<0xB>(D,S);break; \
    case 0xC:V.OP<0xC>(D,S);break; case 0xD:V.OP<0xD>(D,S);break; case 0xE:V.OP<0xE>(D,S);break; case 0xF:V.OP<0xF>(D,S);break; }
#define VU_ERND(OP) switch(e){ \
    case 0x0:V.OP<0x0>(D,vs,T);break; case 0x1:V.OP<0x1>(D,vs,T);break; case 0x2:V.OP<0x2>(D,vs,T);break; case 0x3:V.OP<0x3>(D,vs,T);break; \
    case 0x4:V.OP<0x4>(D,vs,T);break; case 0x5:V.OP<0x5>(D,vs,T);break; case 0x6:V.OP<0x6>(D,vs,T);break; case 0x7:V.OP<0x7>(D,vs,T);break; \
    case 0x8:V.OP<0x8>(D,vs,T);break; case 0x9:V.OP<0x9>(D,vs,T);break; case 0xA:V.OP<0xA>(D,vs,T);break; case 0xB:V.OP<0xB>(D,vs,T);break; \
    case 0xC:V.OP<0xC>(D,vs,T);break; case 0xD:V.OP<0xD>(D,vs,T);break; case 0xE:V.OP<0xE>(D,vs,T);break; case 0xF:V.OP<0xF>(D,vs,T);break; }
// de-class: rsp.OP<e>(vd, de, vt) — VMOV/VRCP/VRCPL/VRCPH/VRSQ/VRSQL/VRSQH.
#define VU_EDE(OP) switch(e){ \
    case 0x0:V.OP<0x0>(D,de,T);break; case 0x1:V.OP<0x1>(D,de,T);break; case 0x2:V.OP<0x2>(D,de,T);break; case 0x3:V.OP<0x3>(D,de,T);break; \
    case 0x4:V.OP<0x4>(D,de,T);break; case 0x5:V.OP<0x5>(D,de,T);break; case 0x6:V.OP<0x6>(D,de,T);break; case 0x7:V.OP<0x7>(D,de,T);break; \
    case 0x8:V.OP<0x8>(D,de,T);break; case 0x9:V.OP<0x9>(D,de,T);break; case 0xA:V.OP<0xA>(D,de,T);break; case 0xB:V.OP<0xB>(D,de,T);break; \
    case 0xC:V.OP<0xC>(D,de,T);break; case 0xD:V.OP<0xD>(D,de,T);break; case 0xE:V.OP<0xE>(D,de,T);break; case 0xF:V.OP<0xF>(D,de,T);break; }
// mfc2/mtc2: rsp.OP<el>(gpr[rt], vpu.r[vs]) — 16-way over the byte-element `el`.
#define VU_XFER(OP) switch(el){ \
    case 0x0:V.OP<0x0>(R[rt],V.vpu.r[vs]);break; case 0x1:V.OP<0x1>(R[rt],V.vpu.r[vs]);break; case 0x2:V.OP<0x2>(R[rt],V.vpu.r[vs]);break; case 0x3:V.OP<0x3>(R[rt],V.vpu.r[vs]);break; \
    case 0x4:V.OP<0x4>(R[rt],V.vpu.r[vs]);break; case 0x5:V.OP<0x5>(R[rt],V.vpu.r[vs]);break; case 0x6:V.OP<0x6>(R[rt],V.vpu.r[vs]);break; case 0x7:V.OP<0x7>(R[rt],V.vpu.r[vs]);break; \
    case 0x8:V.OP<0x8>(R[rt],V.vpu.r[vs]);break; case 0x9:V.OP<0x9>(R[rt],V.vpu.r[vs]);break; case 0xA:V.OP<0xA>(R[rt],V.vpu.r[vs]);break; case 0xB:V.OP<0xB>(R[rt],V.vpu.r[vs]);break; \
    case 0xC:V.OP<0xC>(R[rt],V.vpu.r[vs]);break; case 0xD:V.OP<0xD>(R[rt],V.vpu.r[vs]);break; case 0xE:V.OP<0xE>(R[rt],V.vpu.r[vs]);break; case 0xF:V.OP<0xF>(R[rt],V.vpu.r[vs]);break; }

void rsp_cop2_dispatch(RspInterp& st, uint32_t w) {
    RSP& V = st.vu;
    auto& R = st.gpr;
    if (((w >> 25) & 1) == 0) {
        // COP2 register transfer — sub-op in rs (bits25-21); GPR rt=bits20-16, vs=bits15-11, el=bits10-7,
        // control-reg rd=bits15-11 (cfc2/ctc2). MFC2 writes gpr, MTC2 writes vreg; CFC2 reads VCO/VCC/VCE
        // into a gpr, CTC2 the reverse (rd&3 selects the control reg — Ares masks internally).
        const uint32_t rsf = (w >> 21) & 0x1F, rt = (w >> 16) & 0x1F, vs = (w >> 11) & 0x1F, el = (w >> 7) & 0xF;
        switch (rsf) {
        case 0x00: VU_XFER(MFC2); break;                 // MFC2  gpr[rt] <- vreg[vs] byte el
        case 0x04: VU_XFER(MTC2); break;                 // MTC2  vreg[vs] byte el <- gpr[rt]
        case 0x02: V.CFC2(R[rt], (u8)vs); break;         // CFC2  gpr[rt] <- ctrl[vs&3]
        case 0x06: V.CTC2(R[rt], (u8)vs); break;         // CTC2  ctrl[vs&3] <- gpr[rt]
        default: break;
        }
        R[0] = 0;
        return;
    }
    const uint32_t e = (w >> 21) & 0xF, vs = (w >> 11) & 0x1F, vd = (w >> 6) & 0x1F, funct = w & 0x3F;
    const uint32_t de = (w >> 11) & 7;   // de-class: destination element (vs slot repurposed)
    auto& D = V.vpu.r[vd]; auto& S = V.vpu.r[vs]; auto& T = V.vpu.r[(w >> 16) & 0x1F];   // vt = bits 20-16
    (void)S; (void)T;   // some ops (VSAR/VRND/VMACQ/de-class) don't use all three — the switch selects which
    switch (funct) {
    case 0x00: VU_E3(VMULF); break;  case 0x01: VU_E3(VMULU); break;  case 0x02: VU_ERND(VRNDP); break; case 0x03: VU_E3(VMULQ); break;
    case 0x04: VU_E3(VMUDL); break;  case 0x05: VU_E3(VMUDM); break;  case 0x06: VU_E3(VMUDN); break;   case 0x07: VU_E3(VMUDH); break;
    case 0x08: VU_E3(VMACF); break;  case 0x09: VU_E3(VMACU); break;  case 0x0A: VU_ERND(VRNDN); break; case 0x0B: V.VMACQ(D); break;
    case 0x0C: VU_E3(VMADL); break;  case 0x0D: VU_E3(VMADM); break;  case 0x0E: VU_E3(VMADN); break;   case 0x0F: VU_E3(VMADH); break;
    case 0x10: VU_E3(VADD); break;   case 0x11: VU_E3(VSUB); break;   case 0x13: VU_E3(VABS); break;    case 0x14: VU_E3(VADDC); break;
    case 0x15: VU_E3(VSUBC); break;  case 0x1D: VU_E2(VSAR); break;
    case 0x20: VU_E3(VLT); break;    case 0x21: VU_E3(VEQ); break;    case 0x22: VU_E3(VNE); break;     case 0x23: VU_E3(VGE); break;
    case 0x24: VU_E3(VCL); break;    case 0x25: VU_E3(VCH); break;    case 0x26: VU_E3(VCR); break;     case 0x27: VU_E3(VMRG); break;
    case 0x28: VU_E3(VAND); break;   case 0x29: VU_E3(VNAND); break;  case 0x2A: VU_E3(VOR); break;     case 0x2B: VU_E3(VNOR); break;
    case 0x2C: VU_E3(VXOR); break;   case 0x2D: VU_E3(VNXOR); break;
    case 0x30: VU_EDE(VRCP); break;  case 0x31: VU_EDE(VRCPL); break; case 0x32: VU_EDE(VRCPH); break;  case 0x33: VU_EDE(VMOV); break;
    case 0x34: VU_EDE(VRSQ); break;  case 0x35: VU_EDE(VRSQL); break; case 0x36: VU_EDE(VRSQH); break;
    case 0x37: V.VNOP(); break;
    default: break;
    }
}
#undef VU_E3
#undef VU_E2
#undef VU_ERND
#undef VU_EDE
#undef VU_XFER

// ── COP2 vector loads/stores (LWC2 0x32 / SWC2 0x3A) ──────────────────────────────────────────────
// Encoding (rabbitizer rsp_normal_lwc2.inc / rsp_normal_swc2.inc + RabbitizerInstructionRsp.h): sub-op
// = bits15-11, vt = bits20-16, base rs = bits25-21, element = elementlow = bits10-7, offset = 7-bit
// signed = bits6-0 (RSPRecomp passes it raw sign-extended; the Ares VU method scales by element width).
// Call: rsp.OP<element>(vpu.r[vt], gpr[rs], off7) — LTV/STV take the vt INDEX (u8) not the reg, since
// they spread across a register group. Element must be compile-time ⇒ 16-way switch over `element`,
// with the sub-op switch inside each lane. (LWV 0x0A is absent — the VU has no LWV; SWV is 0x0A.)
#define RSP_VLOAD(E) \
    case 0x00: V.LBV<E>(Vt,base,off7); break; case 0x01: V.LSV<E>(Vt,base,off7); break; case 0x02: V.LLV<E>(Vt,base,off7); break; \
    case 0x03: V.LDV<E>(Vt,base,off7); break; case 0x04: V.LQV<E>(Vt,base,off7); break; case 0x05: V.LRV<E>(Vt,base,off7); break; \
    case 0x06: V.LPV<E>(Vt,base,off7); break; case 0x07: V.LUV<E>(Vt,base,off7); break; case 0x08: V.LHV<E>(Vt,base,off7); break; \
    case 0x09: V.LFV<E>(Vt,base,off7); break; case 0x0B: V.LTV<E>(vt,base,off7); break;
#define RSP_VSTORE(E) \
    case 0x00: V.SBV<E>(Vt,base,off7); break; case 0x01: V.SSV<E>(Vt,base,off7); break; case 0x02: V.SLV<E>(Vt,base,off7); break; \
    case 0x03: V.SDV<E>(Vt,base,off7); break; case 0x04: V.SQV<E>(Vt,base,off7); break; case 0x05: V.SRV<E>(Vt,base,off7); break; \
    case 0x06: V.SPV<E>(Vt,base,off7); break; case 0x07: V.SUV<E>(Vt,base,off7); break; case 0x08: V.SHV<E>(Vt,base,off7); break; \
    case 0x09: V.SFV<E>(Vt,base,off7); break; case 0x0A: V.SWV<E>(Vt,base,off7); break; case 0x0B: V.STV<E>(vt,base,off7); break;
#define RSP_MEM_ELEM16(BODY) switch (element) { \
    case 0x0:{switch(subop){BODY(0x0)}}break; case 0x1:{switch(subop){BODY(0x1)}}break; case 0x2:{switch(subop){BODY(0x2)}}break; case 0x3:{switch(subop){BODY(0x3)}}break; \
    case 0x4:{switch(subop){BODY(0x4)}}break; case 0x5:{switch(subop){BODY(0x5)}}break; case 0x6:{switch(subop){BODY(0x6)}}break; case 0x7:{switch(subop){BODY(0x7)}}break; \
    case 0x8:{switch(subop){BODY(0x8)}}break; case 0x9:{switch(subop){BODY(0x9)}}break; case 0xA:{switch(subop){BODY(0xA)}}break; case 0xB:{switch(subop){BODY(0xB)}}break; \
    case 0xC:{switch(subop){BODY(0xC)}}break; case 0xD:{switch(subop){BODY(0xD)}}break; case 0xE:{switch(subop){BODY(0xE)}}break; case 0xF:{switch(subop){BODY(0xF)}}break; }

void rsp_cop2_mem(RspInterp& st, uint32_t w) {
    RSP& V = st.vu;
    auto& R = st.gpr;
    const uint32_t subop   = (w >> 11) & 0x1F;
    const uint32_t element = (w >>  7) & 0xF;
    const uint32_t vt      = (w >> 16) & 0x1F;
    const uint32_t rs      = (w >> 21) & 0x1F;
    int32_t off7 = (int32_t)(w & 0x7F); if (off7 & 0x40) off7 -= 0x80;   // sign-extend the 7-bit offset
    auto& base = R[rs];   // uint32_t& — the base register VALUE (binds to the methods' cr32&)
    auto& Vt   = V.vpu.r[vt];   // RSP::r128& — loads write it; stores read it (binds to cr128&)
    if (f_op(w) == 0x3A) { RSP_MEM_ELEM16(RSP_VSTORE); }   // SWC2
    else                 { RSP_MEM_ELEM16(RSP_VLOAD);  }   // LWC2
}
#undef RSP_VLOAD
#undef RSP_VSTORE
#undef RSP_MEM_ELEM16

// ── Optional profiler (RECOMP_GENERAL_RSP_PROF=1) — sizes the interp cost / the dynarec win. ────────
// Counts loop iterations (≈ instructions executed; a taken branch's delay slot adds one uncounted step)
// + wall time across gfx tasks, prints every 200 tasks. Fully inert unless the env is set.
static void genrsp_prof_note(uint64_t iters, std::chrono::steady_clock::time_point call_start) {
    static const bool on = [] { const char* e = std::getenv("RECOMP_GENERAL_RSP_PROF"); return e && e[0] == '1'; }();
    if (!on) return;
    static uint64_t total = 0, tasks = 0;
    static double interp_sec = 0;
    static auto t0 = std::chrono::steady_clock::now();
    auto now = std::chrono::steady_clock::now();
    total += iters;
    interp_sec += std::chrono::duration<double>(now - call_start).count();   // time INSIDE the interp only
    if (++tasks % 200 == 0) {
        double wall = std::chrono::duration<double>(now - t0).count();        // wall since first task (incl. softrdp)
        fprintf(stderr, "[genrsp-prof] tasks=%llu instr/task=%llu total=%.1fM | interp=%.1fs=%.0f%%-of-frame  wall=%.1fs | interp-MIPS=%.1f  eff-MIPS=%.1f\n",
                (unsigned long long)tasks, (unsigned long long)(total / tasks), total / 1e6,
                interp_sec, wall > 0 ? 100.0 * interp_sec / wall : 0.0, wall,
                interp_sec > 0 ? (total / 1e6) / interp_sec : 0.0,
                wall > 0 ? (total / 1e6) / wall : 0.0);
        fflush(stderr);
    }
}

// ── Run one RSP task to BREAK ────────────────────────────────────────────────────────────────────
// Loads the microcode into IMEM and executes from the entry point until BREAK (or a guard trips).
// This is the rspboot handoff, reproduced: the OS's rspboot DMAs the resident text into IMEM (F3DEX2
// loads at 0x080 — imem_load_off) and jumps to the entry (also 0x080). The CALLER stages the rest that
// rspboot's caller already did before us (OSTask into DMEM 0xFC0, ucode_data → DMEM) — see the gfx-LLE
// hook. GPRs start zeroed, matching the recompiled-f3dex2 oracle's entry (the resident re-reads the
// OSTask from DMEM, so no register handoff is relied upon). ucode_size is the resident text size (the
// >4KB overflow rides in as runtime overlay DMAs, handled in cop0_write). Engine-inert (no caller yet).
RspExitReason rsp_interp_run(uint8_t* rdram, uint32_t ucode_paddr, uint32_t ucode_size,
                             uint32_t imem_load_off, uint32_t entry_pc) {
    auto _prof_t0 = std::chrono::steady_clock::now();   // profiler: interp start (cheap; only used when gated on)
    static RspInterp st;   // static: the RSP is one unit; DMEM (dmem[]) already persists across tasks
    std::memset(st.gpr, 0, sizeof(st.gpr));
    // AB STATE CONTRACT (2026-07-24, F3DEX2 2.07 residual): the VU state (vregs, accumulators,
    // VCC/VCO/VCE, div latches) must ALSO reset per task — the recompiled artifacts start from a
    // zeroed RspContext every task, and with only gpr reset the interp carried the PREVIOUS
    // capture's VU leftovers into the next one (batch runs: capture N judged against capture N-1's
    // residue — the 97 amsh gameplay "failures" after the build-mismatch was fixed). Lighting reads
    // vreg lanes before writing them (legal on hardware, where residue is real task history), so
    // the oracle pins BOTH sides to the same zeroed entry state. If console-era work ever wants
    // cross-task VU persistence, make it an explicit handoff, not static-object residue.
    st.vu = RSP{};
    imem_dma_in(st, rdram, imem_load_off, ucode_paddr, ucode_size);   // resident text → IMEM (F3DEX2: 0x080)
    st.pc = entry_pc & 0xFFF;
    st.branch_pending = false;
    // rspboot register HANDOFF (reproduced from the decoded rspboot): the OS's rspboot enters the resident
    // with r1 = OSTask base in DMEM, r2 = OSTask.t.ucode (the UCODE BASE — Fast3D adds overlay/DL offsets to
    // it to form DMA source addresses), r3 = the text RD_LEN, r7 = the entry (SP_MEM_ADDR form). F3DEX2
    // re-derives these from DMEM (so zeroed GPRs worked), but Fast3D uses r2 directly — without it, its DMA
    // sources come out as bare offsets (0x1F48, 0x1, 0x0 → garbage → runaway).
    st.gpr[1] = 0xFC0;
    st.gpr[2] = RSP_MEM_W_LOAD(0, 0xFD0);            // = rspboot's `lw r2, 0x10(r1)` with r1=0xFC0
    st.gpr[3] = (ucode_size - 1) & 0xFFF;
    st.gpr[7] = 0x1000 | (imem_load_off & 0xFFF);

    // Basic-block/instruction guard: real microcode frames are bounded; a runaway = a decode/semantics
    // bug. Bail rather than spin (mirrors the RSPRecomp watchdog).
    uint32_t pc_ring[32] = {0}; uint32_t pc_rn = 0;   // runaway diagnostic: recent instruction PCs
    for (uint64_t guard = 0; guard < 20'000'000ull; ++guard) {
        pc_ring[pc_rn++ & 31] = st.pc;
        uint32_t w = imem_fetch(st, st.pc);
        st.pc = (st.pc + 4) & 0xFFF;
        // [gm] probe (RSP_GM_PROBE=1, 2.07 residual hunt): r6/r11-equivalent at the lighting bgez
        // (pc 0x8D8 = IMEM 0x18D8). Matches the hand probe in the f3dex207_lt debug artifact.
        {
            static const bool _gmp = [] { const char* e = getenv("RSP_GM_PROBE"); return e && e[0] == '1'; }();
            if (_gmp && st.pc == 0x8DC) {
                fprintf(stderr, "[gm-%c] r6=%08X r11=%08X\n", (char)g_rsp_vutrace_phase,
                        st.gpr[6], st.gpr[11]);
            }
        }
        bool brk = scalar_step(st, rdram, w);
        if (st.branch_pending) {
            // Execute the delay-slot instruction, THEN transfer.
            uint32_t dw = imem_fetch(st, st.pc);
            st.pc = (st.pc + 4) & 0xFFF;
            bool dbrk = scalar_step(st, rdram, dw);
            st.pc = st.branch_target & 0xFFF;
            st.branch_pending = false;
            // LABEL TRACE (RSP_LABEL_TRACE=1, F3DEX2 divergence hunt): log every TAKEN transfer
            // target — the recomp side emits the same signal before each goto (RSP_LT). The first
            // A/B stream difference names the exact diverging branch. Shared helper: rsp_labeltrace.
            rsp_labeltrace(st.pc | 0x1000);
            rsp_jrtrace(st.pc | 0x1000, st.gpr[25], st.gpr[26], st.gpr[27]);
            if (brk || dbrk) { genrsp_prof_note(guard, _prof_t0); return RspExitReason::Broke; }
        } else if (brk) {
            genrsp_prof_note(guard, _prof_t0); return RspExitReason::Broke;
        }
    }
    {
        static int trip_dumps = 0;
        if (trip_dumps++ < 2) {
            fprintf(stderr, "[rsp_interp] guard tripped — runaway; last 32 PCs (newest last) pc:word\n");
            for (int i = 0; i < 32; i++) {
                uint32_t p = pc_ring[(pc_rn + i) & 31];
                fprintf(stderr, "  %03X:%08X", p, st.imem[(p & 0xFFF) >> 2]);
                if ((i & 3) == 3) fprintf(stderr, "\n");
            }
            fflush(stderr);
        } else {
            fprintf(stderr, "[rsp_interp] guard tripped — runaway ucode (decode/semantics gap)\n");
        }
    }
    return RspExitReason::Unsupported;
}

} // namespace rsp
} // namespace recomp
