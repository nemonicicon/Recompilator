#include <optional>
#include <string>
#include <string_view>
#include <fstream>
#include <array>
#include <vector>
#include <map>
#include <algorithm>
#include <unordered_set>
#include <unordered_map>
#include <cassert>
#include <iostream>
#include <filesystem>
#include "rabbitizer.hpp"
#include "fmt/format.h"
#include "fmt/ostream.h"
#include <toml++/toml.hpp>

using InstrId = rabbitizer::InstrId::UniqueId;
using Cop0Reg = rabbitizer::Registers::Rsp::Cop0;
constexpr size_t instr_size = sizeof(uint32_t);
constexpr uint32_t rsp_mem_mask = 0x1FFF;

// Can't use rabbitizer's operand types because we need to be able to provide a register reference or a register index
enum class RspOperand {
    None,
    Vt,
    VtIndex,
    Vd,
    Vs,
    VsIndex,
    De,
    Rt,
    Rs,
    Imm7,
};

std::unordered_map<InstrId, std::array<RspOperand, 3>> vector_operands{
    // Vt, Rs, Imm
    { InstrId::rsp_lbv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_ldv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_lfv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_lhv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_llv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_lpv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_lqv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_lrv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_lsv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_luv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    // { InstrId::rsp_lwv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}}, // Not in rabbitizer
    { InstrId::rsp_sbv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_sdv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_sfv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_shv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_slv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_spv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_sqv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_srv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_ssv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_suv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_swv, {RspOperand::Vt, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_stv, {RspOperand::VtIndex, RspOperand::Rs, RspOperand::Imm7}},
    { InstrId::rsp_ltv, {RspOperand::VtIndex, RspOperand::Rs, RspOperand::Imm7}},

    // Vd, Vs, Vt
    { InstrId::rsp_vabs,    {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vadd,    {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vaddc,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vand,    {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vch,     {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vcl,     {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vcr,     {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_veq,     {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vge,     {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vlt,     {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmacf,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmacu,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmadh,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmadl,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmadm,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmadn,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmrg,    {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmudh,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmudl,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmudm,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmudn,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vne,     {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vnor,    {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vnxor,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vor,     {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vsub,    {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vsubc,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmulf,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmulu,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vmulq,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vnand,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vxor,    {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}},
    { InstrId::rsp_vsar,    {RspOperand::Vd, RspOperand::Vs, RspOperand::None}},
    { InstrId::rsp_vmacq,   {RspOperand::Vd, RspOperand::None, RspOperand::None}},
    // { InstrId::rsp_vzero,   {RspOperand::Vd, RspOperand::Vs, RspOperand::Vt}}, unused pseudo
    { InstrId::rsp_vrndn,   {RspOperand::Vd, RspOperand::VsIndex, RspOperand::Vt}},
    { InstrId::rsp_vrndp,   {RspOperand::Vd, RspOperand::VsIndex, RspOperand::Vt}},

    // Vd, De, Vt
    { InstrId::rsp_vmov,    {RspOperand::Vd, RspOperand::De, RspOperand::Vt}},
    { InstrId::rsp_vrcp,    {RspOperand::Vd, RspOperand::De, RspOperand::Vt}},
    { InstrId::rsp_vrcpl,   {RspOperand::Vd, RspOperand::De, RspOperand::Vt}},
    { InstrId::rsp_vrcph,   {RspOperand::Vd, RspOperand::De, RspOperand::Vt}},
    { InstrId::rsp_vrsq,    {RspOperand::Vd, RspOperand::De, RspOperand::Vt}},
    { InstrId::rsp_vrsql,   {RspOperand::Vd, RspOperand::De, RspOperand::Vt}},
    { InstrId::rsp_vrsqh,   {RspOperand::Vd, RspOperand::De, RspOperand::Vt}},

    // Rt, Vs
    { InstrId::rsp_mfc2,    {RspOperand::Rt, RspOperand::Vs, RspOperand::None}},
    { InstrId::rsp_mtc2,    {RspOperand::Rt, RspOperand::Vs, RspOperand::None}},

    // Nop
    { InstrId::rsp_vnop,    {RspOperand::None, RspOperand::None, RspOperand::None}}
};

std::string_view ctx_gpr_prefix(int reg) {
    if (reg != 0) {
        return "r";
    }
    return "";
}

// CV64 Brick 3 (graphics-ucode LLE): returns the C++ expression a `mfc0 $rt, $cop0_reg` reads.
// Most RSP status regs read as 0 (we pretend DMAs finish instantly / no status flags set). The DPC
// (RDP command FIFO) registers read back the captured FIFO pointers from the runtime: we model the
// RDP as consuming instantly so a graphics ucode's "how full is the FIFO / where has the RDP read
// to" polling always sees an empty, ready FIFO and proceeds. (Was `expected_c0_reg_value` returning
// a uint32_t constant; widened to std::string so DPC reads can be runtime expressions, not
// compile-time constants. General: enables LLE of any graphics RSP microcode, not just non-gfx ones.)
std::string c0_reg_read_string(int cop0_reg) {
    switch (static_cast<Cop0Reg>(cop0_reg)) {
    case Cop0Reg::RSP_COP0_SP_STATUS:    return "0"; // None of the flags in RSP status are set
    case Cop0Reg::RSP_COP0_SP_DMA_FULL:  return "0"; // Pretend DMAs complete instantly
    case Cop0Reg::RSP_COP0_SP_DMA_BUSY:  return "0"; // Pretend DMAs complete instantly
    case Cop0Reg::RSP_COP0_SP_SEMAPHORE: return "0"; // Always acquire the semaphore
    case Cop0Reg::RSP_COP0_DPC_START:    return "g_rsp_dpc_start";
    case Cop0Reg::RSP_COP0_DPC_END:      return "g_rsp_dpc_end";
    case Cop0Reg::RSP_COP0_DPC_CURRENT:  return "g_rsp_dpc_current"; // == end after a kick (instant RDP)
    case Cop0Reg::RSP_COP0_DPC_STATUS:   return "0"; // not busy / not full / not frozen
    case Cop0Reg::RSP_COP0_DPC_CLOCK:    return "0";
    case Cop0Reg::RSP_COP0_DPC_BUFBUSY:  return "0";
    case Cop0Reg::RSP_COP0_DPC_PIPEBUSY: return "0";
    case Cop0Reg::RSP_COP0_DPC_TMEM:     return "0";
    default:
        fmt::print(stderr, "Unhandled mfc0: {}\n", cop0_reg);
        throw std::runtime_error("Unhandled mfc0");
    }
}

std::string_view c0_reg_write_action(int cop0_reg) {
    switch (static_cast<Cop0Reg>(cop0_reg)) {
    case Cop0Reg::RSP_COP0_SP_SEMAPHORE:
        return ""; // Ignore semaphore functionality
    case Cop0Reg::RSP_COP0_SP_STATUS:
        return ""; // Ignore writes to the status flags since yielding is ignored
    case Cop0Reg::RSP_COP0_SP_DRAM_ADDR:
        return "SET_DMA_DRAM";
    case Cop0Reg::RSP_COP0_SP_MEM_ADDR:
        return "SET_DMA_MEM";
    case Cop0Reg::RSP_COP0_SP_RD_LEN:
        return "DO_DMA_READ";
    case Cop0Reg::RSP_COP0_SP_WR_LEN:
        return "DO_DMA_WRITE";
    // CV64 Brick 3 (graphics-ucode LLE): the DP command FIFO. START sets the FIFO base and resets
    // the modeled RDP read pointer; END kicks/extends the FIFO -> capture the [current, end] RDRAM
    // range as RDP commands (and advance current=end, the instant-RDP model). STATUS/CLOCK writes
    // (xbus/freeze/flush flags, counter resets) have no effect when the RDP consumes instantly.
    case Cop0Reg::RSP_COP0_DPC_START:
        return "SET_DP_START";
    case Cop0Reg::RSP_COP0_DPC_END:
        return "DO_DP_END";
    case Cop0Reg::RSP_COP0_DPC_STATUS:
        return "";
    case Cop0Reg::RSP_COP0_DPC_CLOCK:
        return "";
    default:
        fmt::print(stderr, "Unhandled mtc0: {}\n", cop0_reg);
        throw std::runtime_error("Unhandled mtc0");
    }

}

bool is_c0_reg_write_dma_read(int cop0_reg) {
    return static_cast<Cop0Reg>(cop0_reg) == Cop0Reg::RSP_COP0_SP_RD_LEN;
}

std::optional<int> get_rsp_element(const rabbitizer::InstructionRsp& instr) {
    if (instr.hasOperand(rabbitizer::OperandType::rsp_vt_elementhigh)) {
        return instr.GetRsp_elementhigh();
    } else if (instr.hasOperand(rabbitizer::OperandType::rsp_vt_elementlow) || instr.hasOperand(rabbitizer::OperandType::rsp_vs_index)) {
        return instr.GetRsp_elementlow();
    }

    return std::nullopt;
}

bool rsp_ignores_element(InstrId id) {
    return id == InstrId::rsp_vmacq || id == InstrId::rsp_vnop;
}

// LABEL/TRANSFER TRACE emission (tool env RSPRECOMP_EMIT_LABELTRACE=1, F3DEX2 divergence hunt
// 2026-07-24): debug artifacts get an RSP_LT(target) call before every goto — the taken-transfer
// signal matching the interp's rsp_labeltrace at transfer application. Production artifacts
// (env unset) are byte-identical to before; keep debug regens in separate output files.
static bool lt_emit_on() {
    static const bool on = getenv("RSPRECOMP_EMIT_LABELTRACE") != nullptr;
    return on;
}
static std::string lt_prefix(uint32_t target) {
    return lt_emit_on() ? fmt::format("rsp_labeltrace(0x{:04X}); ", target) : std::string{};
}

struct BranchTargets {
    std::unordered_set<uint32_t> direct_targets;
    std::unordered_set<uint32_t> indirect_targets;
};

BranchTargets get_branch_targets(const std::vector<rabbitizer::InstructionRsp>& instrs) {
    BranchTargets ret;
    for (const auto& instr : instrs) {
        if (instr.isJumpWithAddress() || instr.isBranch()) {
            // CV64 Brick 3 (graphics-ucode LLE): the RSP PC is 12-bit and execution wraps WITHIN
            // IMEM (0x1000-0x1FFF). A forward branch/jump running past the top of IMEM wraps back into
            // IMEM, not into DMEM. Masking with rsp_mem_mask (0x1FFF) yields a bogus 0x0xxx (DMEM)
            // target for such a wrap; keep it in IMEM via (x & 0xFFF) | 0x1000. No-op for all
            // non-wrapping targets (e.g. the entire audio ucode); required for F3DEX2's high-IMEM
            // DMA/flush loops that branch forward across the 0x2000 boundary.
            ret.direct_targets.insert((instr.getBranchVramGeneric() & 0xFFF) | 0x1000);
        }
        if (instr.doesLink()) {
            ret.indirect_targets.insert(((instr.getVram() + 2 * instr_size) & 0xFFF) | 0x1000);
        }
    }
    return ret;
}

struct ResumeTargets {
    std::unordered_set<uint32_t> non_delay_targets;
    std::unordered_set<uint32_t> delay_targets;
};

void get_overlay_swap_resume_targets(const std::vector<rabbitizer::InstructionRsp>& instrs, ResumeTargets& targets) {
    bool is_delay_slot = false;
    for (const auto& instr : instrs) {
        InstrId instr_id = instr.getUniqueId();
        int rd = (int)instr.GetO32_rd();

        if (instr_id == InstrId::rsp_mtc0 && is_c0_reg_write_dma_read(rd)) {
            uint32_t vram = instr.getVram();

            targets.non_delay_targets.insert(vram);

            if (is_delay_slot) {
                targets.delay_targets.insert(vram);
            }
        }

        is_delay_slot = instr.hasDelaySlot();
    }
}

bool process_instruction(size_t instr_index, const std::vector<rabbitizer::InstructionRsp>& instructions, std::ofstream& output_file, const BranchTargets& branch_targets, const std::unordered_set<uint32_t>& unsupported_instructions, const ResumeTargets& resume_targets, bool has_overlays, bool indent, bool in_delay_slot) {
    const auto& instr = instructions[instr_index];

    uint32_t instr_vram = instr.getVram();
    InstrId instr_id = instr.getUniqueId();

    // Skip labels if we're duplicating an instruction into a delay slot
    if (!in_delay_slot) {
        // Print a label if one exists here
        if (branch_targets.direct_targets.contains(instr_vram) || branch_targets.indirect_targets.contains(instr_vram)) {
            fmt::print(output_file, "L_{:04X}:\n", instr_vram);
            // cv64 (session 12): basic-block watchdog. Record this label as the most-recent
            // block executed, and bail if the total exceeds the limit (infinite-loop guard).
            fmt::print(output_file,
                "    cv64_label_ring[cv64_label_ring_idx % CV64_LABEL_RING_SIZE] = 0x{:04X};\n"
                "    cv64_label_ring_idx++;\n"
                "    if (++cv64_block_count > CV64_BLOCK_LIMIT) {{\n"
                "        fprintf(stderr, \"[rsp_watchdog] BAIL: exceeded %llu basic blocks. Last 32 labels (newest last):\\n\",\n"
                "                (unsigned long long)CV64_BLOCK_LIMIT);\n"
                "        for (int _i = 0; _i < CV64_LABEL_RING_SIZE; _i++) {{\n"
                "            int _idx = (cv64_label_ring_idx + _i) % CV64_LABEL_RING_SIZE;\n"
                "            if (cv64_label_ring[_idx]) fprintf(stderr, \"  L_%04X\\n\", cv64_label_ring[_idx]);\n"
                "        }}\n"
                "        fflush(stderr);\n"
                "        return RspExitReason::Unsupported;\n"
                "    }}\n", instr_vram);
        }
    }

    uint16_t branch_target = (instr.getBranchVramGeneric() & 0xFFF) | 0x1000; // CV64 Brick 3: IMEM-wrap (see get_branch_targets)

    // Output a comment with the original instruction
    if (instr.isBranch() || instr_id == InstrId::rsp_j) {
        fmt::print(output_file, "    // {}\n", instr.disassemble(0, fmt::format("L_{:04X}", branch_target)));
    } else if (instr_id == InstrId::rsp_jal) {
        fmt::print(output_file, "    // {}\n", instr.disassemble(0, fmt::format("0x{:04X}", branch_target)));
    } else {
        fmt::print(output_file, "    // {}\n", instr.disassemble(0));
    }

    auto print_indent = [&]() {
        fmt::print(output_file, "    ");
    };

    auto print_line = [&]<typename... Ts>(fmt::format_string<Ts...> fmt_str, Ts&& ...args) {
        std::string line = fmt::format(fmt_str, std::forward<Ts>(args)...);
        print_indent();
        // A WRITE TO $zero IS AN ARCHITECTURAL NO-OP, AND `0 = x;` IS NOT VALID C.
        //
        // ctx_gpr_prefix(0) is "" by design, because every READ of $zero must emit the literal
        // 0. At a DESTINATION the same rule produces `0 = <rhs>;`, which is not an lvalue, and
        // the whole microcode fails to compile. Real microcode contains these: Tetrisphere's
        // audio microcode has `xori $zero, $27, 0x39F8` and `sll $zero, $21, 0` - an assembler
        // emits writes to $zero freely, precisely because the hardware discards them.
        //
        // Discard the value instead of assigning it. The right-hand side is still evaluated, so
        // nothing with an effect loses it, and $zero keeps reading as 0 everywhere because no
        // storage is ever created for it. Found 2026-09-08 on a playtest of the release:
        // Tetrisphere was the only cart of 44 that failed to compile, on three such lines.
        if (line.starts_with("0 = ")) {
            fmt::print(output_file, "(void)({})", std::string_view{line}.substr(4));
        } else {
            fmt::print(output_file, "{}", line);
        }
        fmt::print(output_file, ";\n");
    };

    auto print_branch_condition = [&]<typename... Ts>(fmt::format_string<Ts...> fmt_str, Ts&& ...args) {
        fmt::print(output_file, fmt_str, std::forward<Ts>(args)...);
        fmt::print(output_file, " ");
    };

    auto print_unconditional_branch = [&]<typename... Ts>(fmt::format_string<Ts...> fmt_str, Ts&& ...args) {
        if (instr_index < instructions.size() - 1) {
            uint32_t next_vram = instr_vram + 4;
            process_instruction(instr_index + 1, instructions, output_file, branch_targets, unsupported_instructions, resume_targets, has_overlays, false, true);
        }
        print_indent();
        fmt::print(output_file, fmt_str, std::forward<Ts>(args)...);
        fmt::print(output_file, ";\n");
    };

    auto print_branch = [&]<typename... Ts>(fmt::format_string<Ts...> fmt_str, Ts&& ...args) {
        fmt::print(output_file, "{{\n    ");
        if (instr_index < instructions.size() - 1) {
            uint32_t next_vram = instr_vram + 4;
            process_instruction(instr_index + 1, instructions, output_file, branch_targets, unsupported_instructions, resume_targets, has_overlays, true, true);
        }
        fmt::print(output_file, "        ");
        fmt::print(output_file, fmt_str, std::forward<Ts>(args)...);
        fmt::print(output_file, ";\n    }}\n");
    };

    if (indent) {
        print_indent();
    }

    // Replace unsupported instructions with early returns
    if (unsupported_instructions.contains(instr_vram)) {
        print_line("return RspExitReason::Unsupported", instr_vram);
        if (indent) {
            print_indent();
        }
    }

    int rd = (int)instr.GetO32_rd();
    int rs = (int)instr.GetO32_rs();
    int base = rs;
    int rt = (int)instr.GetO32_rt();
    int sa = (int)instr.Get_sa();

    int fd = (int)instr.GetO32_fd();
    int fs = (int)instr.GetO32_fs();
    int ft = (int)instr.GetO32_ft();

    uint16_t imm = instr.Get_immediate();

    std::string unsigned_imm_string = fmt::format("{:#X}", imm);
    std::string signed_imm_string = fmt::format("{:#X}", (int16_t)imm);

    auto rsp_element = get_rsp_element(instr);

    // If this instruction is in the vector operand table then emit the appropriate function call for its implementation
    auto operand_find_it = vector_operands.find(instr_id);
    if (operand_find_it != vector_operands.end()) {
        const auto& operands = operand_find_it->second;
        int vd = (int)instr.GetRsp_vd();
        int vs = (int)instr.GetRsp_vs();
        int vt = (int)instr.GetRsp_vt();
        std::string operand_string = "";
        for (RspOperand operand : operands) {
            switch (operand) {
                case RspOperand::Vt:
                    operand_string += fmt::format("rsp.vpu.r[{}], ", vt);
                    break;
                case RspOperand::VtIndex:
                    operand_string += fmt::format("{}, ", vt);
                    break;
                case RspOperand::Vd:
                    operand_string += fmt::format("rsp.vpu.r[{}], ", vd);
                    break;
                case RspOperand::Vs:
                    operand_string += fmt::format("rsp.vpu.r[{}], ", vs);
                    break;
                case RspOperand::VsIndex:
                    operand_string += fmt::format("{}, ", vs);
                    break;
                case RspOperand::De:
                    operand_string += fmt::format("{}, ", instr.GetRsp_de() & 7);
                    break;
                case RspOperand::Rt:
                    operand_string += fmt::format("{}{}, ", ctx_gpr_prefix(rt), rt);
                    break;
                case RspOperand::Rs:
                    operand_string += fmt::format("{}{}, ", ctx_gpr_prefix(rs), rs);
                    break;
                case RspOperand::Imm7:
                    // Sign extend the 7-bit immediate
                    operand_string += fmt::format("{:#X}, ", ((int8_t)(imm << 1)) >> 1);
                    break;
                case RspOperand::None:
                    break;
            }
        }
        // Trim the trailing comma off the operands
        if (operand_string.size() > 0) {
            operand_string = operand_string.substr(0, operand_string.size() - 2);
        }
        std::string uppercase_name = "";
        std::string lowercase_name = instr.getOpcodeName();
        uppercase_name.reserve(lowercase_name.size() + 1);
        for (char c : lowercase_name) {
            uppercase_name += std::toupper(c);
        }
        if (rsp_ignores_element(instr_id)) {
            print_line("rsp.{}({})", uppercase_name, operand_string);
        } else {
            print_line("rsp.{}<{}>({})", uppercase_name, rsp_element.value(), operand_string);
        }
    }
    // Otherwise, implement the instruction directly
    else {
        switch (instr_id) {
        case InstrId::rsp_nop:
            fmt::print(output_file, "\n");
            break;
            // Arithmetic
        case InstrId::rsp_lui:
            print_line("{}{} = S32({} << 16)", ctx_gpr_prefix(rt), rt, unsigned_imm_string);
            break;
        case InstrId::rsp_add:
        case InstrId::rsp_addu:
            if (rd == 0) {
                fmt::print(output_file, "\n");
                break;
            }
            print_line("{}{} = RSP_ADD32({}{}, {}{})", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_negu: // pseudo instruction for subu x, 0, y
        case InstrId::rsp_sub:
        case InstrId::rsp_subu:
            print_line("{}{} = RSP_SUB32({}{}, {}{})", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_addi:
        case InstrId::rsp_addiu:
            // $zero-dest guard (durable fix of the 07-12 pilotwings hand-patch): overlay-tail data
            // words decode as `addiu $zero, ...`; `0 = RSP_ADD32(...)` is invalid C. Discard the
            // write, exactly like the rd==0 guard on add/addu/and. General catalog hardening.
            if (rt == 0) {
                fmt::print(output_file, "\n");
                break;
            }
            print_line("{}{} = RSP_ADD32({}{}, {})", ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs, signed_imm_string);
            break;
        case InstrId::rsp_and:
            if (rd == 0) {
                fmt::print(output_file, "\n");
                break;
            }
            print_line("{}{} = {}{} & {}{}", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_andi:
            print_line("{}{} = {}{} & {}", ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs, unsigned_imm_string);
            break;
        case InstrId::rsp_or:
            print_line("{}{} = {}{} | {}{}", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_ori:
            print_line("{}{} = {}{} | {}", ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs, unsigned_imm_string);
            break;
        case InstrId::rsp_nor:
            print_line("{}{} = ~({}{} | {}{})", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_xor:
            print_line("{}{} = {}{} ^ {}{}", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_xori:
            print_line("{}{} = {}{} ^ {}", ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs, unsigned_imm_string);
            break;
        // sll/sllv shift UNSIGNED then reinterpret: `S32(rt) << sa` left-shifts a signed value into
        // the sign bit — UB (C++17) that MSVC /O2 compiled inconsistently across TUs (2026-07-24:
        // F3DEX2-2.07's lighting test `sll $11,$6,10; bgez` — the whole 97-capture divergence class;
        // gcc console builds were shielded only by -fwrapv).
        case InstrId::rsp_sll:
            print_line("{}{} = S32(U32({}{}) << {})", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rt), rt, sa);
            break;
        case InstrId::rsp_sllv:
            print_line("{}{} = S32(U32({}{}) << ({}{} & 31))", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs);
            break;
        case InstrId::rsp_sra:
            print_line("{}{} = S32(RSP_SIGNED({}{}) >> {})", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rt), rt, sa);
            break;
        case InstrId::rsp_srav:
            print_line("{}{} = S32(RSP_SIGNED({}{}) >> ({}{} & 31))", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs);
            break;
        case InstrId::rsp_srl:
            print_line("{}{} = S32(U32({}{}) >> {})", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rt), rt, sa);
            break;
        case InstrId::rsp_srlv:
            print_line("{}{} = S32(U32({}{}) >> ({}{} & 31))", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs);
            break;
        case InstrId::rsp_slt:
            print_line("{}{} = RSP_SIGNED({}{}) < RSP_SIGNED({}{}) ? 1 : 0", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_slti:
            print_line("{}{} = RSP_SIGNED({}{}) < {} ? 1 : 0", ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs, signed_imm_string);
            break;
        case InstrId::rsp_sltu:
            print_line("{}{} = {}{} < {}{} ? 1 : 0", ctx_gpr_prefix(rd), rd, ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_sltiu:
            print_line("{}{} = {}{} < {} ? 1 : 0", ctx_gpr_prefix(rt), rt, ctx_gpr_prefix(rs), rs, signed_imm_string);
            break;
            // Loads
            // TODO ld
        case InstrId::rsp_lw:
            print_line("{}{} = RSP_MEM_W_LOAD({}, {}{})", ctx_gpr_prefix(rt), rt, signed_imm_string, ctx_gpr_prefix(base), base);
            break;
        case InstrId::rsp_lh:
            print_line("{}{} = RSP_MEM_H_LOAD({}, {}{})", ctx_gpr_prefix(rt), rt, signed_imm_string, ctx_gpr_prefix(base), base);
            break;
        case InstrId::rsp_lb:
            print_line("{}{} = RSP_MEM_B({}, {}{})", ctx_gpr_prefix(rt), rt, signed_imm_string, ctx_gpr_prefix(base), base);
            break;
        case InstrId::rsp_lhu:
            print_line("{}{} = RSP_MEM_HU_LOAD({}, {}{})", ctx_gpr_prefix(rt), rt, signed_imm_string, ctx_gpr_prefix(base), base);
            break;
        case InstrId::rsp_lbu:
            print_line("{}{} = RSP_MEM_BU({}, {}{})", ctx_gpr_prefix(rt), rt, signed_imm_string, ctx_gpr_prefix(base), base);
            break;
            // Stores
        case InstrId::rsp_sw:
            print_line("RSP_MEM_W_STORE({}, {}{}, {}{})", signed_imm_string, ctx_gpr_prefix(base), base, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_sh:
            print_line("RSP_MEM_H_STORE({}, {}{}, {}{})", signed_imm_string, ctx_gpr_prefix(base), base, ctx_gpr_prefix(rt), rt);
            break;
        case InstrId::rsp_sb:
            print_line("RSP_MEM_B({}, {}{}) = {}{}", signed_imm_string, ctx_gpr_prefix(base), base, ctx_gpr_prefix(rt), rt);
            break;
            // Branches
        case InstrId::rsp_j:
        case InstrId::rsp_b:
            print_unconditional_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        case InstrId::rsp_jal:
            print_line("{}{} = 0x{:04X}", ctx_gpr_prefix(31), 31, instr_vram + 2 * instr_size);
            print_unconditional_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        case InstrId::rsp_jr:
            print_line("jump_target = {}{}", ctx_gpr_prefix(rs), rs);
            print_line("debug_file = __FILE__; debug_line = __LINE__");
            print_unconditional_branch("goto do_indirect_jump");
            break;
        case InstrId::rsp_jalr:
            // return address (rd, usually r31) = addr after the delay slot. Format MUST be {:04X}:
            // {:8X} SPACE-pads to width 8, emitting `0x    196C` (invalid C). Latent until F3DLX-1.x,
            // the first catalog ucode to use jalr as a call (F3DEX2 uses jr/bgezal, never hit it).
            print_line("jump_target = {}{}; {}{} = 0x{:04X}", ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rd), rd, instr_vram + 2 * instr_size);
            print_line("debug_file = __FILE__; debug_line = __LINE__");
            print_unconditional_branch("goto do_indirect_jump");
            break;
        case InstrId::rsp_bne:
            print_indent();
            print_branch_condition("if ({}{} != {}{})", ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            print_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        case InstrId::rsp_beq:
            print_indent();
            print_branch_condition("if ({}{} == {}{})", ctx_gpr_prefix(rs), rs, ctx_gpr_prefix(rt), rt);
            print_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        case InstrId::rsp_bgez:
            print_indent();
            print_branch_condition("if (RSP_SIGNED({}{}) >= 0)", ctx_gpr_prefix(rs), rs);
            print_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        // CV64 Brick 3 (graphics-ucode LLE): branch-and-link if >= 0. MIPS links UNCONDITIONALLY
        // (r31 = address after the delay slot) and branches when rs >= 0. F3DEX2 uses it as a call;
        // the return address is auto-added to the indirect-jump table by get_branch_targets (doesLink).
        case InstrId::rsp_bgezal:
            print_line("{}{} = 0x{:04X}", ctx_gpr_prefix(31), 31, instr_vram + 2 * instr_size);
            print_indent();
            print_branch_condition("if (RSP_SIGNED({}{}) >= 0)", ctx_gpr_prefix(rs), rs);
            print_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        case InstrId::rsp_bgtz:
            print_indent();
            print_branch_condition("if (RSP_SIGNED({}{}) > 0)", ctx_gpr_prefix(rs), rs);
            print_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        case InstrId::rsp_blez:
            print_indent();
            print_branch_condition("if (RSP_SIGNED({}{}) <= 0)", ctx_gpr_prefix(rs), rs);
            print_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        case InstrId::rsp_bltz:
            print_indent();
            print_branch_condition("if (RSP_SIGNED({}{}) < 0)", ctx_gpr_prefix(rs), rs);
            print_branch("{}goto L_{:04X}", lt_prefix(branch_target), branch_target);
            break;
        case InstrId::rsp_break:
            print_line("return RspExitReason::Broke", instr_vram);
            break;
        case InstrId::rsp_mfc0:
            print_line("{}{} = {}", ctx_gpr_prefix(rt), rt, c0_reg_read_string(rd));
            break;
        case InstrId::rsp_mtc0:
            {
                std::string_view write_action = c0_reg_write_action(rd);
                if (has_overlays && is_c0_reg_write_dma_read(rd)) {
                    // DMA read, do overlay swap if reading into IMEM
                    fmt::print(output_file, 
                        "    if (dma_mem_address & 0x1000) {{\n"
                        "        ctx->resume_address = 0x{:04X};\n"
                        "        ctx->resume_delay = {};\n"
                        "        goto do_overlay_swap;\n"
                        "    }}\n",
                        instr_vram, in_delay_slot ? "true" : "false");
                }
                if (!write_action.empty()) {
                    print_line("{}({}{})", write_action, ctx_gpr_prefix(rt), rt);
                }
                break;
            }
        // CV64 Brick 3 (graphics-ucode LLE): COP2 control-register moves. The VU already implements
        // RSP::CFC2/CTC2 (pack/unpack VCO/VCC/VCE <-> a GPR), just like the mfc2/mtc2 in the vector
        // table above. F3DEX2 reads these vector flag registers after vge/vlt/vch compares (clipping,
        // backface cull, lighting); the audio ucode never did, which is why they were "unhandled"
        // until now. rd & 3 selects the control register (0 = VCO, 1 = VCC, 2 = VCE).
        case InstrId::rsp_cfc2:
            if (rt != 0) { // cfc2 into $zero is a discard
                print_line("rsp.CFC2({}{}, {})", ctx_gpr_prefix(rt), rt, rd);
            }
            break;
        case InstrId::rsp_ctc2:
            print_line("rsp.CTC2({}{}, {})", ctx_gpr_prefix(rt), rt, rd);
            break;
        default:
            fmt::print(stderr, "Unhandled instruction: {}\n", instr.getOpcodeName());
            assert(false);
            return false;
        }
    }

    // Write overlay swap resume labels
    if (in_delay_slot) {
        if (resume_targets.delay_targets.contains(instr_vram)) {
            fmt::print(output_file, "R_{:04X}_delay:\n", instr_vram);
        }
    } else {
        if (resume_targets.non_delay_targets.contains(instr_vram)) {
            fmt::print(output_file, "R_{:04X}:\n", instr_vram);
        }
    }

    return true;
}

void write_indirect_jumps(std::ofstream& output_file, const BranchTargets& branch_targets, const std::string& output_function_name) {
    fmt::print(output_file, "do_indirect_jump:\n");
    if (lt_emit_on()) {
        // JR/VALUE TRACE (F3DEX2 +16-DL hunt): every indirect transfer's target + the DL-state
        // registers ($25=cmd w0, $26=DL dram ptr, $27=input cursor). Debug artifacts only.
        fmt::print(output_file, "    rsp_jrtrace(jump_target | 0x1000, r25, r26, r27);\n");
    }
    fmt::print(output_file,
        "    switch ((jump_target | 0x1000) & {:#X}) {{ \n", rsp_mem_mask);
    for (uint32_t branch_target: branch_targets.indirect_targets) {
        fmt::print(output_file, "        case 0x{0:04X}: goto L_{0:04X};\n", branch_target);
    }
    fmt::print(output_file,
        "    }}\n"
        "    printf(\"Unhandled jump target 0x%04X in microcode {}, coming from [%s:%d]\\n\", jump_target, debug_file, debug_line);\n"
        "    printf(\"Register dump: r0  = %08X r1  = %08X r2  = %08X r3  = %08X r4  = %08X r5  = %08X r6  = %08X r7  = %08X\\n\"\n"
        "           \"               r8  = %08X r9  = %08X r10 = %08X r11 = %08X r12 = %08X r13 = %08X r14 = %08X r15 = %08X\\n\"\n"
        "           \"               r16 = %08X r17 = %08X r18 = %08X r19 = %08X r20 = %08X r21 = %08X r22 = %08X r23 = %08X\\n\"\n"
        "           \"               r24 = %08X r25 = %08X r26 = %08X r27 = %08X r28 = %08X r29 = %08X r30 = %08X r31 = %08X\\n\",\n"
        "           0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16,\n"
        "           r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31);\n"
        "    return RspExitReason::UnhandledJumpTarget;\n", output_function_name);
}

void write_overlay_swap_return(std::ofstream& output_file) {
    fmt::print(output_file,
        "do_overlay_swap:\n"
        "                    ctx->r1 = r1;   ctx->r2 = r2;   ctx->r3 = r3;   ctx->r4 = r4;   ctx->r5 = r5;   ctx->r6 = r6;   ctx->r7 = r7;\n"
        "    ctx->r8 = r8;   ctx->r9 = r9;   ctx->r10 = r10; ctx->r11 = r11; ctx->r12 = r12; ctx->r13 = r13; ctx->r14 = r14; ctx->r15 = r15;\n"
        "    ctx->r16 = r16; ctx->r17 = r17; ctx->r18 = r18; ctx->r19 = r19; ctx->r20 = r20; ctx->r21 = r21; ctx->r22 = r22; ctx->r23 = r23;\n"
        "    ctx->r24 = r24; ctx->r25 = r25; ctx->r26 = r26; ctx->r27 = r27; ctx->r28 = r28; ctx->r29 = r29; ctx->r30 = r30; ctx->r31 = r31;\n"
        "    ctx->dma_mem_address = dma_mem_address;\n"
        "    ctx->dma_dram_address = dma_dram_address;\n"
        "    ctx->jump_target = jump_target;\n"
        "    ctx->rsp = rsp;\n"
        "    return RspExitReason::SwapOverlay;\n");
}

#ifdef _MSC_VER
inline uint32_t byteswap(uint32_t val) {
    return _byteswap_ulong(val);
}
#else
constexpr uint32_t byteswap(uint32_t val) {
    return __builtin_bswap32(val);
}
#endif

struct RSPRecompilerOverlayConfig {
    size_t offset;
    size_t size;
};

struct RSPRecompilerOverlaySlotConfig {
    size_t text_address;
    std::vector<RSPRecompilerOverlayConfig> overlays;
};

struct RSPRecompilerConfig {
    size_t text_offset;
    size_t text_size;
    size_t text_address;
    // CV64 Brick 3 (graphics-ucode LLE): byte offset, within the recompiled IMEM image, at which the
    // ROM text is loaded. Default 0 (ROM bytes fill the whole image, as for the audio ucode). For
    // F3DEX2, rspboot DMAs the resident to IMEM 0x080, so the base is a full 0x1000-byte IMEM image
    // with text_load_offset=0x80: bytes [0..0x80) are zero (nop lead-in to the entry at IMEM 0x080)
    // and the ROM text fills [0x80..]. This lets the overlay slot at IMEM 0x000 sit inside the base
    // and keeps overlay offsets ucode-relative (so they match both the ROM read and the swap key).
    size_t text_load_offset;
    std::filesystem::path rom_file_path;
    std::filesystem::path output_file_path;
    std::string output_function_name;
    std::vector<uint32_t> extra_indirect_branch_targets;
    std::unordered_set<uint32_t> unsupported_instructions;
    std::vector<RSPRecompilerOverlaySlotConfig> overlay_slots;
};

std::filesystem::path concat_if_not_empty(const std::filesystem::path& parent, const std::filesystem::path& child) {
    if (!child.empty()) {
        return parent / child;
    }
    return child;
}

template <typename T>
std::vector<T> toml_to_vec(const toml::array* array) {
    std::vector<T> ret;

    // Reserve room for all the funcs in the map.
    ret.reserve(array->size());
    array->for_each([&ret](auto&& el) {
        if constexpr (toml::is_integer<decltype(el)>) {
            ret.push_back(*el);
        }
    });

    return ret;
}

template <typename T>
std::unordered_set<T> toml_to_set(const toml::array* array) {
    std::unordered_set<T> ret;

    array->for_each([&ret](auto&& el) {
        if constexpr (toml::is_integer<decltype(el)>) {
            ret.insert(*el);
        }
    });

    return ret;
}

bool read_config(const std::filesystem::path& config_path, RSPRecompilerConfig& out) {
    RSPRecompilerConfig ret{};

    try {
        const toml::table config_data = toml::parse_file(config_path.u8string());
        std::filesystem::path basedir = std::filesystem::path{ config_path }.parent_path();

        std::optional<uint32_t> text_offset = config_data["text_offset"].value<uint32_t>();
        if (text_offset.has_value()) {
            ret.text_offset = text_offset.value();
        }
        else {
            throw toml::parse_error("Missing text_offset in config file", config_data.source());
        }

        std::optional<uint32_t> text_size = config_data["text_size"].value<uint32_t>();
        if (text_size.has_value()) {
            ret.text_size = text_size.value();
        }
        else {
            throw toml::parse_error("Missing text_size in config file", config_data.source());
        }

        std::optional<uint32_t> text_address = config_data["text_address"].value<uint32_t>();
        if (text_address.has_value()) {
            ret.text_address = text_address.value();
        }
        else {
            throw toml::parse_error("Missing text_address in config file", config_data.source());
        }

        // CV64 Brick 3 (optional, default 0): see RSPRecompilerConfig::text_load_offset.
        ret.text_load_offset = config_data["text_load_offset"].value<uint32_t>().value_or(0);

        std::optional<std::string> rom_file_path = config_data["rom_file_path"].value<std::string>();
        if (rom_file_path.has_value()) {
            ret.rom_file_path = concat_if_not_empty(basedir, rom_file_path.value());
        }
        else {
            throw toml::parse_error("Missing rom_file_path in config file", config_data.source());
        }

        std::optional<std::string> output_file_path = config_data["output_file_path"].value<std::string>();
        if (output_file_path.has_value()) {
            ret.output_file_path = concat_if_not_empty(basedir, output_file_path.value());
        }
        else {
            throw toml::parse_error("Missing output_file_path in config file", config_data.source());
        }

        std::optional<std::string> output_function_name = config_data["output_function_name"].value<std::string>();
        if (output_function_name.has_value()) {
            ret.output_function_name = output_function_name.value();
        }
        else {
            throw toml::parse_error("Missing output_function_name in config file", config_data.source());
        }

        // Extra indirect branch targets (optional)
        const toml::node_view branch_targets_data = config_data["extra_indirect_branch_targets"];
        if (branch_targets_data.is_array()) {
            const toml::array* branch_targets_array = branch_targets_data.as_array();
            ret.extra_indirect_branch_targets = toml_to_vec<uint32_t>(branch_targets_array);
        }

        // Unsupported_instructions (optional)
        const toml::node_view unsupported_instructions_data = config_data["unsupported_instructions"];
        if (unsupported_instructions_data.is_array()) {
            const toml::array* unsupported_instructions_array = unsupported_instructions_data.as_array();
            ret.unsupported_instructions = toml_to_set<uint32_t>(unsupported_instructions_array);
        }

        // Overlay slots (optional)
        const toml::node_view overlay_slots = config_data["overlay_slots"];
        if (overlay_slots.is_array()) {
            const toml::array* overlay_slots_array = overlay_slots.as_array();

            int slot_idx = 0;
            overlay_slots_array->for_each([&](toml::table slot){
                RSPRecompilerOverlaySlotConfig slot_config;

                std::optional<uint32_t> text_address = slot["text_address"].value<uint32_t>();
                if (text_address.has_value()) {
                    slot_config.text_address = text_address.value();
                }
                else {
                    throw toml::parse_error(
                        fmt::format("Missing text_address in config file at overlay slot {}", slot_idx).c_str(), 
                        config_data.source());
                }

                // Overlays per slot
                const toml::node_view overlays = slot["overlays"];
                if (overlays.is_array()) {
                    const toml::array* overlay_array = overlays.as_array();

                    int overlay_idx = 0;
                    overlay_array->for_each([&](toml::table overlay){
                        RSPRecompilerOverlayConfig overlay_config;
                        
                        std::optional<uint32_t> offset = overlay["offset"].value<uint32_t>();
                        if (offset.has_value()) {
                            overlay_config.offset = offset.value();
                        }
                        else {
                            throw toml::parse_error(
                                fmt::format("Missing offset in config file at overlay slot {} overlay {}", slot_idx, overlay_idx).c_str(), 
                                config_data.source());
                        }

                        std::optional<uint32_t> size = overlay["size"].value<uint32_t>();
                        if (size.has_value()) {
                            overlay_config.size = size.value();

                            if ((size.value() % sizeof(uint32_t)) != 0) {
                                throw toml::parse_error(
                                    fmt::format("Overlay size must be a multiple of {} in config file at overlay slot {} overlay {}", sizeof(uint32_t), slot_idx, overlay_idx).c_str(), 
                                    config_data.source());
                            }
                        }
                        else {
                            throw toml::parse_error(
                                fmt::format("Missing size in config file at overlay slot {} overlay {}", slot_idx, overlay_idx).c_str(), 
                                config_data.source());
                        }

                        slot_config.overlays.push_back(overlay_config);
                        overlay_idx++;
                    });
                }
                else {
                    throw toml::parse_error(
                        fmt::format("Missing overlays in config file at overlay slot {}", slot_idx).c_str(), 
                        config_data.source());
                }

                ret.overlay_slots.push_back(slot_config);
                slot_idx++;
            });
        }

    }
    catch (const toml::parse_error& err) {
        std::cerr << "Syntax error parsing toml: " << *err.source().path << " (" << err.source().begin <<  "):\n" << err.description() << std::endl;
        return false;
    }

    out = ret;
    return true;
}

struct FunctionPermutation {
    std::vector<rabbitizer::InstructionRsp> instrs;
    std::vector<uint32_t> permutation;
};

struct Permutation {
    std::vector<uint32_t> instr_words;
    std::vector<uint32_t> permutation;
};

struct Overlay {
    std::vector<uint32_t> instr_words;
};

struct OverlaySlot {
    uint32_t offset;
    std::vector<Overlay> overlays;
};

// LAYERED SLOTS (2026-07-24, F3DLX.Rej fifo 2.08 = the named witness): hardware IMEM slots are
// PALIMPSESTS. A smaller overlay DMA'd over a larger one leaves the larger one's TAIL bytes live,
// and ucodes EXECUTE from that tail (the 2.08 frame epilogue runs from ovlA-head + ovlB-tail).
// One-index-per-slot cannot express that, so a slot is modeled as a state machine over byte
// COMPOSITES: state = the actual span content, transitions = the paint events the dispatcher can
// observe (overlay-load DMAs paint the span prefix [0, size_i); the resident self-reload paints
// [text_load_offset, span_end) with base bytes — a REAL layer event now, not a no-op). States are
// canonicalized by content, so histories that produce identical bytes collapse (e.g. the F3DEX-1.x
// resident-under-slot overlay 0 == the base image under the slot). The initial state (id 0) is the
// base image content, matching both the pre-swap hardware slot and the interp reference's IMEM.
struct SlotMachine {
    uint32_t word_offset;                            // slot span start, in image words
    uint32_t span_words;                             // span length = max overlay size, in words
    std::vector<std::vector<uint32_t>> composites;   // state id -> span content
    std::vector<std::vector<uint32_t>> ovl_next;     // state id -> overlay ordinal -> state id
    std::vector<uint32_t> reload_next;               // state id -> state id (resident reload)
};

SlotMachine build_slot_machine(const std::vector<uint32_t>& base_words, const OverlaySlot& slot, uint32_t text_load_offset) {
    SlotMachine machine{};
    machine.word_offset = slot.offset / sizeof(uint32_t);

    size_t span_words = 0;
    for (const Overlay& overlay : slot.overlays) {
        span_words = std::max(span_words, overlay.instr_words.size());
    }
    machine.span_words = (uint32_t)span_words;

    if (machine.word_offset + span_words > base_words.size()) {
        fmt::print(stderr, "Overlay slot at word offset 0x{:X} (span 0x{:X} words) exceeds the text image\n",
            machine.word_offset, span_words);
        throw std::runtime_error("Overlay slot exceeds text image");
    }

    // The resident reload repaints [text_load_offset, text end) with base bytes; only the part
    // intersecting this slot's span matters here (outside the span, base bytes repaint themselves).
    uint32_t reload_abs_lo = std::max<uint32_t>(slot.offset, text_load_offset);
    uint32_t reload_abs_hi = slot.offset + (uint32_t)span_words * sizeof(uint32_t);
    bool has_reload_event = reload_abs_lo < reload_abs_hi;
    uint32_t reload_rel_word = (reload_abs_lo - slot.offset) / sizeof(uint32_t);

    std::map<std::vector<uint32_t>, uint32_t> composite_ids;
    std::vector<uint32_t> initial(base_words.begin() + machine.word_offset,
                                  base_words.begin() + machine.word_offset + span_words);
    composite_ids[initial] = 0;
    machine.composites.push_back(initial);

    for (uint32_t state = 0; state < machine.composites.size(); state++) {
        std::vector<uint32_t> ovl_transitions(slot.overlays.size());
        for (size_t i = 0; i < slot.overlays.size(); i++) {
            std::vector<uint32_t> content = machine.composites[state];
            std::copy(slot.overlays[i].instr_words.begin(), slot.overlays[i].instr_words.end(), content.begin());
            auto [it, inserted] = composite_ids.try_emplace(content, (uint32_t)machine.composites.size());
            if (inserted) {
                machine.composites.push_back(content);
            }
            ovl_transitions[i] = it->second;
        }
        machine.ovl_next.push_back(ovl_transitions);

        uint32_t reload_target = state;
        if (has_reload_event) {
            std::vector<uint32_t> content = machine.composites[state];
            for (uint32_t w = reload_rel_word; w < span_words; w++) {
                content[w] = base_words[machine.word_offset + w];
            }
            auto [it, inserted] = composite_ids.try_emplace(content, (uint32_t)machine.composites.size());
            if (inserted) {
                machine.composites.push_back(content);
            }
            reload_target = it->second;
        }
        machine.reload_next.push_back(reload_target);

        // Reachable composites are staircase stacks bounded by the overlay size boundaries; real
        // families stay tiny (2.08: 6, F3DLX 1.23: 8). A blowup means a layout error — fail loudly.
        if (machine.composites.size() > 64) {
            fmt::print(stderr, "Overlay slot at word offset 0x{:X}: composite state explosion (>64); check the slot layout\n",
                machine.word_offset);
            throw std::runtime_error("Slot composite explosion");
        }
    }

    return machine;
}

bool next_permutation(const std::vector<uint32_t>& option_lengths, std::vector<uint32_t>& current) {
    current[current.size() - 1] += 1;

    size_t i = current.size() - 1;
    while (current[i] == option_lengths[i]) {
        current[i] = 0;
        if (i == 0) {
            return false;
        }

        current[i - 1] += 1;
        i--;
    }

    return true;
}

// One permutation per Cartesian combination of slot COMPOSITE states (layered slots: composites,
// not raw overlay indices — see SlotMachine above).
void permute(const std::vector<uint32_t>& base_words, const std::vector<SlotMachine>& slot_machines, std::vector<Permutation>& permutations) {
    auto current = std::vector<uint32_t>(slot_machines.size(), 0);
    auto slot_options = std::vector<uint32_t>(slot_machines.size(), 0);

    for (size_t i = 0; i < slot_machines.size(); i++) {
        slot_options[i] = slot_machines[i].composites.size();
    }

    do {
        Permutation permutation = {
            .instr_words = std::vector<uint32_t>(base_words),
            .permutation = std::vector<uint32_t>(current)
        };

        for (size_t i = 0; i < slot_machines.size(); i++) {
            const SlotMachine& machine = slot_machines[i];
            const std::vector<uint32_t>& content = machine.composites[current[i]];

            std::copy(content.begin(), content.end(), permutation.instr_words.begin() + machine.word_offset);
        }

        permutations.push_back(permutation);
    } while (next_permutation(slot_options, current));
}

std::string make_permutation_string(const std::vector<uint32_t> permutation) {
    std::string str = "";

    for (uint32_t opt : permutation) {
        // '_'-separated: composite ids can exceed one digit, and concatenation would be ambiguous.
        str += "_" + std::to_string(opt);
    }

    return str;
}

void create_overlay_swap_function(const std::string& function_name, std::ofstream& output_file, const std::vector<FunctionPermutation>& permutations, const RSPRecompilerConfig& config, const std::vector<SlotMachine>& slot_machines) {
    // Includes and permutation protos
    fmt::print(output_file, 
        "#include <map>\n"
        "#include <vector>\n\n"
        "using RspUcodePermutationFunc = RspExitReason(uint8_t* rdram, RspContext* ctx);\n\n"
        "RspExitReason {}(uint8_t* rdram, RspContext* ctx);\n",
        config.output_function_name + "_initial");

    for (const auto& permutation : permutations) {
        fmt::print(output_file, "RspExitReason {}(uint8_t* rdram, RspContext* ctx);\n",
            config.output_function_name + make_permutation_string(permutation.permutation));
    }
    fmt::print(output_file, "\n");

    // IMEM -> slot index mapping
    fmt::print(output_file, 
        "static const std::map<uint32_t, uint32_t> imemToSlot = {{\n");
    for (size_t i = 0; i < config.overlay_slots.size(); i++) {
        const RSPRecompilerOverlaySlotConfig& slot = config.overlay_slots[i];

        uint32_t imemAddress = slot.text_address & rsp_mem_mask;
        fmt::print(output_file, "    {{ 0x{:04X}, {} }},\n",
            imemAddress, i);
    }
    fmt::print(output_file, "}};\n\n");

    // ucode offset -> overlay index mapping (per slot)
    fmt::print(output_file, 
        "static const std::vector<std::map<uint32_t, uint32_t>> offsetToOverlay = {{\n");
    for (const auto& slot : config.overlay_slots) {
        fmt::print(output_file, "    {{\n");
        for (size_t i = 0; i < slot.overlays.size(); i++) {
            const RSPRecompilerOverlayConfig& overlay = slot.overlays[i];

            fmt::print(output_file, "        {{ 0x{:04X}, {} }},\n",
                overlay.offset, i);
        }
        fmt::print(output_file, "    }},\n");
    }
    fmt::print(output_file, "}};\n\n");

    // LAYERED SLOTS: per-slot composite transition tables (see SlotMachine in the tool).
    // ovlNext[slot][state][overlay ordinal] = next state after that overlay's DMA paints the span
    // prefix over the CURRENT composite (palimpsest semantics, not overlay-index replacement).
    fmt::print(output_file,
        "static const std::vector<std::vector<std::vector<uint32_t>>> ovlNext = {{\n");
    for (const SlotMachine& machine : slot_machines) {
        fmt::print(output_file, "    {{\n");
        for (const auto& transitions : machine.ovl_next) {
            fmt::print(output_file, "        {{ ");
            for (uint32_t next_state : transitions) {
                fmt::print(output_file, "{}, ", next_state);
            }
            fmt::print(output_file, "}},\n");
        }
        fmt::print(output_file, "    }},\n");
    }
    fmt::print(output_file, "}};\n\n");

    // reloadNext[slot][state] = next state after the resident self-reload repaints
    // [text_load_offset, span end) with base bytes (identity for slots the reload window misses).
    fmt::print(output_file,
        "static const std::vector<std::vector<uint32_t>> reloadNext = {{\n");
    for (const SlotMachine& machine : slot_machines) {
        fmt::print(output_file, "    {{ ");
        for (uint32_t next_state : machine.reload_next) {
            fmt::print(output_file, "{}, ", next_state);
        }
        fmt::print(output_file, "}},\n");
    }
    fmt::print(output_file, "}};\n\n");

    // Permutation function pointers
    fmt::print(output_file, 
        "static RspUcodePermutationFunc* permutations[] = {{\n");
    for (const auto& permutation : permutations) {
        fmt::print(output_file, "    {},\n",
            config.output_function_name + make_permutation_string(permutation.permutation));
    }
    fmt::print(output_file, "}};\n\n");

    // Main function
    fmt::print(output_file,
        "RspExitReason {}(uint8_t* rdram, uint32_t ucode_addr) {{\n"
        "    RspContext ctx{{}};\n",
        config.output_function_name);
    
    std::string slots_init_str = "";
    for (size_t i = 0; i < config.overlay_slots.size(); i++) {
        if (i > 0) {
            slots_init_str += ", ";
        }

        slots_init_str += "0";
    }

    fmt::print(output_file, "    uint32_t slots[] = {{{}}};\n\n",
        slots_init_str);

    fmt::print(output_file, "    RspExitReason exitReason = {}(rdram, &ctx);\n\n",
        config.output_function_name + "_initial");
    
    fmt::print(output_file, "");

    std::string perm_index_str = "";
    for (size_t i = 0; i < slot_machines.size(); i++) {
        if (i > 0) {
            perm_index_str += " + ";
        }

        uint32_t multiplier = 1;
        for (size_t k = i + 1; k < slot_machines.size(); k++) {
            multiplier *= slot_machines[k].composites.size();
        }

        perm_index_str += fmt::format("slots[{}] * {}", i, multiplier);
    }
    
    fmt::print(output_file,
        "    while (exitReason == RspExitReason::SwapOverlay) {{\n"
        // RESIDENT SELF-RELOAD (F3DEX-2.x fifo law, 2026-07-24, Space Invaders F3DLX.Rej 2.08 =
        // the named witness): some gfx ucodes re-DMA their own main text (ucode+0 -> the resident
        // IMEM base) mid-task. Modeling it as an overlay slot is WRONG: the slot then spans the
        // BOOT/relocation code, the post-swap resume misses the permutation's resume switch, boot
        // re-runs, and overlay descriptors get relocated TWICE (measured: second swap dram =
        // ovl_paddr + ucode_paddr). With LAYERED SLOTS it is a real state transition instead: the
        // reload repaints [text_load_offset, text end) with resident bytes, restoring base content
        // over any stale overlay tails inside slot spans (reloadNext; identity outside them).
        // (24-bit physical mask: the ucode may write SP_DRAM_ADDR in PHYSICAL form while
        //  ucode_addr is the KSEG0 vaddr — measured on the 2.08 witness: dram=0x0006ABD0 vs
        //  ucode=0x8006ABD0. SP_DRAM_ADDR is a physical register; mask both sides.)
        "        if (ctx.dma_mem_address == 0x{2:X} && ((ctx.dma_dram_address - ucode_addr) & 0xFFFFFF) == 0) {{\n"
        "            for (size_t _i = 0; _i < reloadNext.size(); _i++) {{\n"
        "                slots[_i] = reloadNext[_i][slots[_i]];\n"
        "            }}\n"
        "            if (getenv(\"RSP_SWAP_TRACE\")) fprintf(stderr, \"[rc-swap] RELOAD -> state0=%u\\n\", slots[0]);\n"
        "            RspUcodePermutationFunc* residentResume = permutations[{1}];\n"
        "            exitReason = residentResume(rdram, &ctx);\n"
        "            continue;\n"
        "        }}\n"
        // CV64 Brick 3: graceful handling of an overlay swap whose target slot/overlay isn't configured
        // (e.g., a second overlay slot or an overlay offset not listed in the toml). The stock code used
        // std::map::at() which THROWS std::out_of_range -> uncaught -> std::terminate -> hard crash. Use
        // checked lookups that log + exit (Unsupported) instead, so an unconfigured overlay is a clean
        // bail (and the log tells us exactly which slot/offset to add).
        "        auto _slotIt = imemToSlot.find(ctx.dma_mem_address);\n"
        "        if (_slotIt == imemToSlot.end()) {{\n"
        "            printf(\"[rsp] {0}: overlay DMA to unconfigured IMEM 0x%04X (add an overlay_slot)\\n\", ctx.dma_mem_address);\n"
        "            return RspExitReason::Unsupported;\n"
        "        }}\n"
        "        uint32_t slot = _slotIt->second;\n"
        "        const auto& _o2o = offsetToOverlay[slot];\n"
        // 24-bit physical mask, same law as the resident-reload check above: SP_DRAM_ADDR is a
        // physical register — post-reload overlay DMAs arrive in PHYSICAL form (measured on the
        // 2.08 witness: dram=0x0006BBE8 vs KSEG0 ucode=0x8006ABD0 -> raw diff 0x80001018 missed
        // the map and bailed Unsupported mid-task). Mask both sides; ucode text offsets are tiny.
        "        uint32_t _ovlOffset = (ctx.dma_dram_address - ucode_addr) & 0xFFFFFF;\n"
        "        auto _ovlIt = _o2o.find(_ovlOffset);\n"
        "        if (_ovlIt == _o2o.end()) {{\n"
        "            printf(\"[rsp] {0}: unconfigured overlay offset 0x%08X in slot %u (add an overlay)\\n\", _ovlOffset, slot);\n"
        "            return RspExitReason::Unsupported;\n"
        "        }}\n"
        // LAYERED SLOTS: the DMA'd overlay paints the span prefix over the CURRENT composite —
        // the next state depends on what was there (palimpsest), not on the overlay alone.
        "        slots[slot] = ovlNext[slot][slots[slot]][_ovlIt->second];\n"
        "        if (getenv(\"RSP_SWAP_TRACE\")) fprintf(stderr, \"[rc-swap] slot=%u ovl=%u -> state=%u\\n\", slot, _ovlIt->second, slots[slot]);\n"
        "\n"
        "        RspUcodePermutationFunc* permutationFunc = permutations[{1}];\n"
        "        exitReason = permutationFunc(rdram, &ctx);\n"
        "    }}\n\n"
        "    return exitReason;\n"
        "}}\n\n",
        config.output_function_name, perm_index_str, 0x1000 | (uint32_t)config.text_load_offset);
}

void create_function(const std::string& function_name, std::ofstream& output_file, const std::vector<rabbitizer::InstructionRsp>& instrs, const RSPRecompilerConfig& config, const ResumeTargets& resume_targets, bool is_permutation, bool is_initial) {
    // Collect indirect jump targets (return addresses for linked jumps)
    BranchTargets branch_targets = get_branch_targets(instrs);

    // Add any additional indirect branch targets that may not be found directly in the code (e.g. from a jump table)
    for (uint32_t target : config.extra_indirect_branch_targets) {
        branch_targets.indirect_targets.insert(target);
    }
    
    // Write function
    if (is_permutation) {
        fmt::print(output_file,
            "RspExitReason {}(uint8_t* rdram, RspContext* ctx) {{\n"
            "    uint32_t                 r1 = ctx->r1,   r2 = ctx->r2,   r3 = ctx->r3,   r4 = ctx->r4,   r5 = ctx->r5,   r6 = ctx->r6,   r7 = ctx->r7;\n"
            "    uint32_t  r8 = ctx->r8,  r9 = ctx->r9,   r10 = ctx->r10, r11 = ctx->r11, r12 = ctx->r12, r13 = ctx->r13, r14 = ctx->r14, r15 = ctx->r15;\n"
            "    uint32_t r16 = ctx->r16, r17 = ctx->r17, r18 = ctx->r18, r19 = ctx->r19, r20 = ctx->r20, r21 = ctx->r21, r22 = ctx->r22, r23 = ctx->r23;\n"
            "    uint32_t r24 = ctx->r24, r25 = ctx->r25, r26 = ctx->r26, r27 = ctx->r27, r28 = ctx->r28, r29 = ctx->r29, r30 = ctx->r30, r31 = ctx->r31;\n"
            "    uint32_t dma_mem_address = ctx->dma_mem_address, dma_dram_address = ctx->dma_dram_address, jump_target = ctx->jump_target;\n"
            "    const char * debug_file = NULL; int debug_line = 0;\n"
            "    RSP rsp = ctx->rsp;\n"
            // CV64 Brick 3: the per-label watchdog code (emitted by process_instruction for every
            // function) references these locals, so the OVERLAY PERMUTATION functions must declare them
            // too (they're only in the non-permutation prologue otherwise). Per-permutation state is
            // fine — the block count just resets across an overlay swap.
            "    uint64_t cv64_block_count = 0;\n"
            "    static const uint64_t CV64_BLOCK_LIMIT = 1000000ULL;\n"
            "    static const int CV64_LABEL_RING_SIZE = 32;\n"
            "    uint32_t cv64_label_ring[CV64_LABEL_RING_SIZE] = {{0}};\n"
            "    int cv64_label_ring_idx = 0;\n", function_name);

        // Write jumps to resume targets
        if (!is_initial) {
            fmt::print(output_file,
                "    if (ctx->resume_delay) {{\n"
                "        switch (ctx->resume_address) {{\n");
            
            for (uint32_t address : resume_targets.delay_targets) {
                fmt::print(output_file, "            case 0x{0:04X}: goto R_{0:04X}_delay;\n", 
                    address);
            }
            
            fmt::print(output_file,
                "        }}\n"
                "    }} else {{\n"
                "        switch (ctx->resume_address) {{\n");
            
            for (uint32_t address : resume_targets.non_delay_targets) {
                fmt::print(output_file, "            case 0x{0:04X}: goto R_{0:04X};\n", 
                    address);
            }

            fmt::print(output_file,
                "        }}\n"
                "    }}\n"
                "    printf(\"Unhandled resume target 0x%04X (delay slot: %d) in microcode {}\\n\", ctx->resume_address, ctx->resume_delay);\n"
                "    return RspExitReason::UnhandledResumeTarget;\n",
                config.output_function_name);
        }

        fmt::print(output_file, "    r1 = 0xFC0;\n");
    } else {
        fmt::print(output_file,
            "RspExitReason {}(uint8_t* rdram, [[maybe_unused]] uint32_t ucode_addr) {{\n"
            "    uint32_t           r1 = 0,  r2 = 0,  r3 = 0,  r4 = 0,  r5 = 0,  r6 = 0,  r7 = 0;\n"
            "    uint32_t  r8 = 0,  r9 = 0, r10 = 0, r11 = 0, r12 = 0, r13 = 0, r14 = 0, r15 = 0;\n"
            "    uint32_t r16 = 0, r17 = 0, r18 = 0, r19 = 0, r20 = 0, r21 = 0, r22 = 0, r23 = 0;\n"
            "    uint32_t r24 = 0, r25 = 0, r26 = 0, r27 = 0, r28 = 0, r29 = 0, r30 = 0, r31 = 0;\n"
            "    uint32_t dma_mem_address = 0, dma_dram_address = 0, jump_target = 0;\n"
            "    const char * debug_file = NULL; int debug_line = 0;\n"
            "    RSP rsp{{}};\n"
            "    // cv64 (session 12): basic-block watchdog. Real audio tasks should complete\n"
            "    // in a few 100k basic blocks; if we hit 1M we are infinite-looping (likely\n"
            "    // an mfc0 stub returning 0 sending the dispatcher down the wrong path).\n"
            "    // Lower than 1M would risk premature bail for genuinely long tasks;\n"
            "    // higher would tank framerate when the loop fires every audio frame.\n"
            "    uint64_t cv64_block_count = 0;\n"
            "    static const uint64_t CV64_BLOCK_LIMIT = 1000000ULL;\n"
            "    static const int CV64_LABEL_RING_SIZE = 32;\n"
            "    uint32_t cv64_label_ring[CV64_LABEL_RING_SIZE] = {{0}};\n"
            "    int cv64_label_ring_idx = 0;\n"
            "    r1 = 0xFC0;\n", function_name);
    }
    // Write each instruction
    for (size_t instr_index = 0; instr_index < instrs.size(); instr_index++) {
        process_instruction(instr_index, instrs, output_file, branch_targets, config.unsupported_instructions, resume_targets, is_permutation, false, false);
    }

    // Terminate instruction code with a return to indicate that the microcode has run past its end
    fmt::print(output_file, "    return RspExitReason::ImemOverrun;\n");

    // CV64 Brick 3 (graphics-ucode LLE): emit graceful-exit stubs for any branch/jump target that
    // lands OUTSIDE the recompiled text. F3DEX2 jumps into the rspboot/header region (IMEM 0x000-0x080:
    // task control / ucode reload / DMA-wait) and high-IMEM branches can wrap past the text end; those
    // targets have no instruction label, so `goto L_XXXX` would fail to compile. Exiting here (Unsupported)
    // means the LLE runs up to that boundary — for a gfx capture that's a clean cut (all RDP commands
    // emitted so far are captured). The audio ucode never left its text, so this is inert for it.
    {
        const uint32_t imem_lo = config.text_address & rsp_mem_mask;
        const uint32_t imem_hi = imem_lo + (uint32_t)config.text_size;
        std::unordered_set<uint32_t> oob_targets;
        for (uint32_t t : branch_targets.direct_targets) {
            if (t < imem_lo || t >= imem_hi) oob_targets.insert(t);
        }
        for (uint32_t t : branch_targets.indirect_targets) {
            if (t < imem_lo || t >= imem_hi) oob_targets.insert(t);
        }
        for (uint32_t t : oob_targets) {
            fmt::print(output_file,
                "L_{0:04X}:\n"
                "    printf(\"[rsp] {1}: exited text to 0x{0:04X} (rspboot/header or wrap)\\n\");\n"
                "    return RspExitReason::Unsupported;\n",
                t, config.output_function_name);
        }
    }

    // Write the section containing the indirect jump table
    write_indirect_jumps(output_file, branch_targets, config.output_function_name);

    // Write routine for returning for an overlay swap
    if (is_permutation) {
        write_overlay_swap_return(output_file);
    }

    // End the file
    fmt::print(output_file, "}}\n");
}

int main(int argc, const char** argv) {
    if (argc != 2) {
        fmt::print("Usage: {} [config file]\n", argv[0]);
        std::exit(EXIT_SUCCESS);
    }

    RSPRecompilerConfig config;
    if (!read_config(std::filesystem::path{argv[1]}, config)) {
        fmt::print("Failed to parse config file {}\n", argv[0]);
        std::exit(EXIT_FAILURE);
    }

    std::vector<uint32_t> instr_words{};
    std::vector<OverlaySlot> overlay_slots{};
    // CV64 Brick 3: zero-initialize so any text_load_offset gap (IMEM below where the ROM text loads)
    // decodes as nops — a harmless lead-in into the real entry. Default (text_load_offset=0) is unchanged.
    instr_words.resize(config.text_size / sizeof(uint32_t), 0);
    {
        std::ifstream rom_file{ config.rom_file_path, std::ios_base::binary };

        if (!rom_file.good()) {
            fmt::print(stderr, "Failed to open rom file\n");
            return EXIT_FAILURE;
        }

        rom_file.seekg(config.text_offset);
        rom_file.read(reinterpret_cast<char*>(instr_words.data()) + config.text_load_offset, config.text_size - config.text_load_offset);

        for (const RSPRecompilerOverlaySlotConfig &slot_config : config.overlay_slots) {
            OverlaySlot slot{};
            slot.offset = (slot_config.text_address - config.text_address) & rsp_mem_mask;

            for (const RSPRecompilerOverlayConfig &overlay_config : slot_config.overlays) {
                Overlay overlay{};
                overlay.instr_words.resize(overlay_config.size / sizeof(uint32_t));

                rom_file.seekg(config.text_offset + overlay_config.offset);
                rom_file.read(reinterpret_cast<char*>(overlay.instr_words.data()), overlay_config.size);

                slot.overlays.push_back(overlay);
            }

            overlay_slots.push_back(slot);
        }
    }

    // Build the per-slot composite state machines (layered slots), then one permutation per
    // Cartesian combination of composite states.
    std::vector<SlotMachine> slot_machines{};
    std::vector<Permutation> permutations{};
    if (!overlay_slots.empty()) {
        for (size_t i = 0; i < overlay_slots.size(); i++) {
            slot_machines.push_back(build_slot_machine(instr_words, overlay_slots[i], (uint32_t)config.text_load_offset));
            fmt::print("Slot {} @ IMEM 0x{:04X}: {} overlays -> {} composite states\n",
                i, (config.overlay_slots[i].text_address & rsp_mem_mask),
                overlay_slots[i].overlays.size(), slot_machines.back().composites.size());
        }
        permute(instr_words, slot_machines, permutations);
        fmt::print("{} permutations total\n", permutations.size());
    }

    // Disable appropriate pseudo instructions
    RabbitizerConfig_Cfg.pseudos.pseudoMove = false;
    RabbitizerConfig_Cfg.pseudos.pseudoBeqz = false;
    RabbitizerConfig_Cfg.pseudos.pseudoBnez = false;
    RabbitizerConfig_Cfg.pseudos.pseudoNot = false;

    // Decode the instruction words into instructions
    std::vector<rabbitizer::InstructionRsp> instrs{};
    instrs.reserve(instr_words.size());
    uint32_t vram = config.text_address & rsp_mem_mask;
    for (uint32_t instr_word : instr_words) {
        const rabbitizer::InstructionRsp& instr = instrs.emplace_back(byteswap(instr_word), vram);
        vram += instr_size;
    }

    std::vector<FunctionPermutation> func_permutations{};
    func_permutations.reserve(permutations.size());
    for (const Permutation& permutation : permutations) {
        FunctionPermutation func = {
            .permutation = std::vector<uint32_t>(permutation.permutation)
        };

        func.instrs.reserve(permutation.instr_words.size());
        uint32_t vram = config.text_address & rsp_mem_mask;
        for (uint32_t instr_word : permutation.instr_words) {
            const rabbitizer::InstructionRsp& instr = func.instrs.emplace_back(byteswap(instr_word), vram);
            vram += instr_size;
        }

        func_permutations.emplace_back(func);
    }

    // Determine all possible overlay swap resume targets
    ResumeTargets resume_targets{};
    for (const FunctionPermutation& permutation : func_permutations) {
        get_overlay_swap_resume_targets(permutation.instrs, resume_targets);
    }

    // Open output file and write beginning
    std::filesystem::create_directories(std::filesystem::path{ config.output_file_path }.parent_path());
    std::ofstream output_file(config.output_file_path);
    fmt::print(output_file,
        "#include \"librecomp/rsp.hpp\"\n"
        "#include \"librecomp/rsp_vu_impl.hpp\"\n");
    
    // Write function(s)
    if (overlay_slots.empty()) {
        create_function(config.output_function_name, output_file, instrs, config, resume_targets, false, false);
    } else {
        create_overlay_swap_function(config.output_function_name, output_file, func_permutations, config, slot_machines);
        create_function(config.output_function_name + "_initial", output_file, instrs, config, ResumeTargets{}, true, true);

        for (const auto& permutation : func_permutations) {
            create_function(config.output_function_name + make_permutation_string(permutation.permutation), 
                output_file, permutation.instrs, config, resume_targets, true, false);
        }
    }

    return 0;
}
