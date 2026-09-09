// rsp_interp.hpp — shared surface of the general-RSP interpreter (rsp_interp.cpp).
//
// THE POINT: the interpreter is the BASE + the bit-exact ORACLE. The live RSP recompiler
// (rsp_dynarec.cpp) is a HYBRID JIT built ON these exact pieces — it inlines the scalar/control
// hot path in sljit and CALLS OUT to the interpreter's proven C++ handlers for the vector unit and
// COP0/DMA. So the state struct, the MIPS-field decode helpers, and the four handlers are declared
// here and DE-STATIC'd in rsp_interp.cpp; both TUs share one definition of correctness.
//
// rsp.hpp (transitively rsp_vu.hpp — the Ares vector unit) has NO include guard and must be included
// ONLY via rsp.hpp; this header does that, so include THIS header (never rsp_vu.hpp directly).

#ifndef __RSP_INTERP_HPP__
#define __RSP_INTERP_HPP__

#include <cstdint>

#include "librecomp/rsp.hpp"   // struct RSP (Ares VU), DMEM ^3 macros, DMA, DPC→softrdp, RspExitReason

namespace recomp {
namespace rsp {

// ── RSP execution state ─────────────────────────────────────────────────────────────────────────
// Scalar GPRs + PC + the private IMEM copy live here; the vector unit is the Ares `RSP`. DMEM is the
// shared global dmem[] (rsp.hpp), so the ^3-swizzle access macros and the DMA plumbing apply unchanged.
struct RspInterp {
    uint32_t gpr[32];        // r0 hardwired to 0
    uint32_t pc;             // IMEM byte offset of the NEXT instruction (0x000..0xFFC), 12-bit
    uint32_t imem[1024];     // 4KB instruction memory, one decoded-endian 32-bit word per slot
    RSP      vu;             // the Ares vector unit (COP2)

    // Delay-slot machinery: a taken branch/jump sets branch_pending with the target; the instruction in
    // the delay slot executes first, then control transfers. Matches MIPS/RSP semantics exactly.
    bool     branch_pending = false;
    uint32_t branch_target  = 0;
};

// ── IMEM version — the dynarec's block-cache invalidation key ─────────────────────────────────────
// Bumped every time IMEM contents change (resident-text load at task start AND runtime overlay swaps —
// both go through imem_dma_in). A block is cached by (entry PC, imem_version); when a game DMAs new
// text into IMEM the version moves and stale blocks are never reused. Lives in rsp_interp.cpp.
extern uint64_t g_rsp_imem_version;

// ── Instruction field decode (MIPS layout) ──────────────────────────────────────────────────────
// `inline` (external linkage) so both the interpreter and the dynarec's block decoder share them.
inline uint32_t f_op   (uint32_t w) { return (w >> 26) & 0x3F; }
inline uint32_t f_rs   (uint32_t w) { return (w >> 21) & 0x1F; }
inline uint32_t f_rt   (uint32_t w) { return (w >> 16) & 0x1F; }
inline uint32_t f_rd   (uint32_t w) { return (w >> 11) & 0x1F; }
inline uint32_t f_sa   (uint32_t w) { return (w >>  6) & 0x1F; }
inline uint32_t f_funct(uint32_t w) { return  w        & 0x3F; }
inline int32_t  f_simm (uint32_t w) { return (int32_t)(int16_t)(w & 0xFFFF); }
inline uint32_t f_uimm (uint32_t w) { return  w & 0xFFFF; }
inline uint32_t f_jtgt (uint32_t w) { return (w & 0x03FFFFFF) << 2; }   // stays inside IMEM after &0xFFF

inline uint32_t imem_fetch(const RspInterp& st, uint32_t pc) {
    return st.imem[(pc & 0xFFF) >> 2];
}

// ── The interpreter's handlers (DE-STATIC'd; defined in rsp_interp.cpp) ───────────────────────────
// Load big-endian instruction words from ^3-swizzled RDRAM into IMEM at a byte offset; used for BOTH
// the initial resident-text load AND runtime overlay swaps. Bumps g_rsp_imem_version.
void imem_dma_in(RspInterp& st, uint8_t* rdram, uint32_t imem_off, uint32_t dram_paddr, uint32_t len_bytes);

// Execute ONE scalar instruction word. Returns true on BREAK (task done). A taken branch/jump sets
// st.branch_pending/branch_target; the CALLER runs the delay-slot instr, then applies the transfer.
bool scalar_step(RspInterp& st, uint8_t* rdram, uint32_t w);

// COP2 vector unit: compute/de-class/register-transfer (opcode 0x12) and vector loads/stores
// (LWC2 0x32 / SWC2 0x3A). The dynarec calls these directly — it does NOT re-emit the SIMD VU.
void rsp_cop2_dispatch(RspInterp& st, uint32_t w);
void rsp_cop2_mem(RspInterp& st, uint32_t w);

// COP0 (SP + DPC control registers): MTC0 does DMA setup/kick (incl. IMEM overlay swap) and
// DP_START/DP_END → softrdp; MFC0 reads back the modeled SP/DPC state.
void     cop0_write(RspInterp& st, uint8_t* rdram, uint32_t rd, uint32_t val);
uint32_t cop0_read (RspInterp& st, uint8_t* rdram, uint32_t rd);

} // namespace rsp
} // namespace recomp

#endif // __RSP_INTERP_HPP__
