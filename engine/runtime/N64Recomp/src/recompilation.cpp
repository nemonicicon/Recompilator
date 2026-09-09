#include <vector>
#include <set>
#include <sstream>
#include <unordered_set>
#include <unordered_map>
#include <cassert>
#include <cstdlib>

#include "rabbitizer.hpp"
#include "fmt/format.h"
#include "fmt/ostream.h"

#include "recompiler/context.h"
#include "recompiler/diag_sink.h"
#include "analysis.h"
#include "recompiler/operations.h"
#include "recompiler/generator.h"

enum class JalResolutionResult {
    NoMatch,
    Match,
    CreateStatic,
    Ambiguous,
    Error
};

JalResolutionResult resolve_jal(const N64Recomp::Context& context, size_t cur_section_index, uint32_t target_func_vram, size_t& matched_function_index) {
    // Skip resolution if all function calls should use lookup and just return Ambiguous.
    if (context.use_lookup_for_all_function_calls) {
        return JalResolutionResult::Ambiguous;
    }

    // Look for symbols with the target vram address
    const N64Recomp::Section& cur_section = context.sections[cur_section_index];
    const auto matching_funcs_find = context.functions_by_vram.find(target_func_vram);
    uint32_t section_vram_start = cur_section.ram_addr;
    uint32_t section_vram_end = cur_section.ram_addr + cur_section.size;
    bool in_current_section = target_func_vram >= section_vram_start && target_func_vram < section_vram_end;
    bool exact_match_found = false;

    // Use a thread local to prevent reallocation across runs and to allow multi-threading in the future.
    thread_local std::vector<size_t> matched_funcs{};
    matched_funcs.clear();

    // Evaluate any functions with the target address to see if they're potential candidates for JAL resolution.
    if (matching_funcs_find != context.functions_by_vram.end()) {
        for (size_t target_func_index : matching_funcs_find->second) {
            const auto& target_func = context.functions[target_func_index];

            // Zero-sized symbol handling. unless there's only one matching target.
            if (target_func.words.empty()) {
                if (!N64Recomp::is_manual_patch_symbol(target_func.vram)) {
                    continue;
                }
            }

            // Immediately accept a function in the same section as this one, since it must also be loaded if the current function is.
            if (target_func.section_index == cur_section_index) {
                exact_match_found = true;
                matched_funcs.clear();
                matched_funcs.push_back(target_func_index);
                break;
            }

            // If the function's section isn't relocatable, add the function as a candidate.
            const auto& target_func_section = context.sections[target_func.section_index];
            if (!target_func_section.relocatable) {
                matched_funcs.push_back(target_func_index);
            }
        }
    }

    // If the target vram is in the current section, only allow exact matches.
    if (in_current_section) {
        // If an exact match was found, use it.
        if (exact_match_found) {
            matched_function_index = matched_funcs[0];
            return JalResolutionResult::Match;
        }
        // Otherwise, create a static function at the target address.
        else {
            return JalResolutionResult::CreateStatic;
        }
    }
    // Otherwise, disambiguate based on the matches found.
    else {
        // If there were no matches then JAL resolution has failed.
        // A static can't be created as the target section is unknown.
        if (matched_funcs.size() == 0) {
            return JalResolutionResult::NoMatch;
        }
        // If there was an exact match, use it.
        else if (matched_funcs.size() == 1) {
            matched_function_index = matched_funcs[0];
            return JalResolutionResult::Match;
        }
        // If there's more than one match, use an indirect jump to resolve the function at runtime.
        else {
            return JalResolutionResult::Ambiguous;
        }
    }

    // This should never be hit, so return an error.
    return JalResolutionResult::Error;
}

using InstrId = rabbitizer::InstrId::UniqueId;
using Cop0Reg = rabbitizer::Registers::Cpu::Cop0;

std::string_view ctx_gpr_prefix(int reg) {
    if (reg != 0) {
        return "ctx->r";
    }
    return "";
}

// [coswitch 2026-09-01] Guest coroutine ("swap-context") switch, set per function by the scan in
// recompile_function_impl: a function that LOADS $sp from memory is a context switch (compiled
// code never does that; only context switches, longjmp and exception returns do), and its `jr`
// must hand the host stack to the entering context's fiber instead of returning (see
// librecomp/src/coswitch.cpp — Mortal Kombat Trilogy's process kernel, the Williams/Midway
// arcade-port class). saves = the function also STORES $sp (the leaving context is preserved);
// a load-only switch abandons the leaving context (the kill path).
static thread_local bool     tl_coswitch_func  = false;   // switch: loads $sp off a non-frame base AND jr's through a register loaded the same way
static thread_local bool     tl_coswitch_saver = false;   // save: stores $sp off a non-frame base (setjmp, or the save half of a swap routine)
static thread_local bool     tl_coswitch_caller = false;  // this function directly calls a PURE saver (its frame hosts the savepoint)
static thread_local uint32_t tl_coswitch_regs  = 0;       // bitmask of GPRs loaded off a non-frame base in this function
static thread_local bool     tl_coswitch_starter = false; // start: writes $sp from an ARGUMENT register, then jr's through another (run the callee on a fresh guest stack = fresh fiber)
static thread_local bool     tl_coswitch_self_save = false; // pure saver that CALLS after its `sw $sp`: hosts its own savepoint at the save point (see CoswitchClass::save_then_calls)

// [coswitch] Whole-program classification, built once per Context: a PURE saver (setjmp: stores $sp off
// a non-frame base, returns normally) cannot host its own savepoint — its frame is gone the moment it
// returns, and a later resume would longjmp into a dead frame (NBA Hangtime, STATUS_BAD_STACK). The
// savepoint belongs at the CALL SITE, in the caller's frame, which stays live exactly as long as the
// guest's saved registers are meaningful. A routine that saves AND switches (MKT's func_800808B8)
// suspends inside its own frame and keeps its in-function savepoint.
// save_then_calls: the saver CALLS after storing $sp, so it does not return to its caller at the
// save point -- the callee switches away from inside it. Its savepoint must live in its OWN frame
// (see tl_coswitch_self_save), not at its call sites the way a true setjmp's does.
struct CoswitchClass { bool saver = false; bool switcher = false; int save_base = -1; bool save_base_is_const = false; uint32_t save_base_const = 0; bool save_then_calls = false; int save_off = 0; };
static thread_local const N64Recomp::Context* g_coswitch_ctx = nullptr;
static thread_local std::unordered_map<uint32_t, CoswitchClass> g_coswitch_classes;
static thread_local std::unordered_set<int> g_coswitch_switch_offs;   // offsets some switcher reads $sp back from
static void coswitch_classify(const N64Recomp::Context& context) {
    if (g_coswitch_ctx == &context) return;
    g_coswitch_ctx = &context;
    g_coswitch_classes.clear();
    using InstrIdCs = rabbitizer::InstrId::UniqueId;
    const int sp_reg = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_sp;
    const int fp_reg = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_fp;
    g_coswitch_switch_offs.clear();
    std::unordered_set<int>& switch_offs = g_coswitch_switch_offs;
    for (const auto& f : context.functions) {
        if (f.words.empty() || f.ignored || f.stubbed) continue;
        CoswitchClass c;
        uint32_t loaded = 0; bool loads_sp = false; bool jr_on_loaded = false;
        uint32_t vram = f.vram;
        // [coswitch 2026-09-03, MK4] Track registers this function materializes from IMMEDIATES
        // (the standard `lui`/`addiu`|`ori` address idiom). A pure saver that computes its context
        // block from a fixed address holds nothing useful in that register at its CALL SITE, where
        // the savepoint is emitted -- the caller would capture a stale value and register the
        // savepoint under the wrong block, so the matching switch finds no owner and declines.
        // Recording the constant lets the call site name the real block. A saver whose base comes
        // from an incoming argument (NBA Hangtime: `jal setjmp; addiu $a0,$a0,0x20`) has no constant
        // and keeps the register capture unchanged.
        uint32_t const_known = 0; uint32_t const_val[32] = {};
        std::vector<int> sp_load_offs;
        for (uint32_t word : f.words) {
            rabbitizer::InstructionCpu ins(byteswap(word), vram);
            vram += 4;
            const InstrIdCs id = ins.getUniqueId();
            if (id == InstrIdCs::cpu_jr) {
                if (loaded & (1u << (int)ins.GetO32_rs())) jr_on_loaded = true;
                continue;
            }
            const int base = (int)ins.GetO32_rs();
            const bool base_is_frame = (base == sp_reg || base == fp_reg);
            if (!base_is_frame) {
                if (id == InstrIdCs::cpu_lw || id == InstrIdCs::cpu_ld) {
                    const int rt = (int)ins.GetO32_rt();
                    if (rt == sp_reg) loads_sp = true;
                    loaded |= (1u << rt);
                }
                if (id == InstrIdCs::cpu_lw || id == InstrIdCs::cpu_ld) {
                    if ((int)ins.GetO32_rt() == sp_reg) sp_load_offs.push_back((int)ins.getProcessedImmediate());
                }
                if ((id == InstrIdCs::cpu_sw || id == InstrIdCs::cpu_sd) && (int)ins.GetO32_rt() == sp_reg) {
                    c.saver = true;
                    if (c.save_base < 0) {
                        c.save_base = base;
                        c.save_off = (int)ins.getProcessedImmediate();
                        if (base > 0 && (const_known & (1u << base)) != 0) {
                            c.save_base_is_const = true;
                            c.save_base_const = const_val[base];
                        }
                    }
                }
            }
            // Constant tracking runs for every instruction, frame-based ones included, so that a
            // register clobbered by an unmodelled op stops being treated as a known constant.
            if (id == InstrIdCs::cpu_jal || id == InstrIdCs::cpu_jalr) {
                // A call clobbers every caller-saved register: drop all constants (conservative --
                // this only makes the constant-block capture less likely to fire, never wrong).
                const_known = 0;
                if (c.saver) c.save_then_calls = true;
            }
            else if (id == InstrIdCs::cpu_lui) {
                const int rt = (int)ins.GetO32_rt();
                if (rt > 0) { const_known |= (1u << rt); const_val[rt] = ((uint32_t)ins.getProcessedImmediate()) << 16; }
            }
            else if (id == InstrIdCs::cpu_addiu || id == InstrIdCs::cpu_ori) {
                const int rt = (int)ins.GetO32_rt();
                const int rs = (int)ins.GetO32_rs();
                const bool rs_const = (rs == 0) || ((const_known & (1u << rs)) != 0);
                const uint32_t rs_val = (rs == 0) ? 0u : const_val[rs];
                if (rt > 0 && rs_const) {
                    const_known |= (1u << rt);
                    const_val[rt] = (id == InstrIdCs::cpu_ori)
                        ? (rs_val | (uint32_t)(ins.getProcessedImmediate() & 0xFFFF))
                        : (uint32_t)(rs_val + (uint32_t)(int32_t)ins.getProcessedImmediate());
                }
                else if (rt > 0) {
                    const_known &= ~(1u << rt);
                }
            }
            else {
                // Any other instruction that writes a GPR invalidates that register's constant.
                const int rd = (int)ins.GetO32_rd();
                const int rt = (int)ins.GetO32_rt();
                if (ins.modifiesRd() && rd > 0) const_known &= ~(1u << rd);
                if (ins.modifiesRt() && rt > 0) const_known &= ~(1u << rt);
            }
        }
        c.switcher = loads_sp && jr_on_loaded;
        if (c.switcher) switch_offs.insert(sp_load_offs.begin(), sp_load_offs.end());
        if (c.saver || c.switcher) g_coswitch_classes[f.vram] = c;
    }
    // A `sw $sp, off(base)` is only a CONTEXT save if some switch routine in this program reads a
    // stack pointer back from the same slot: `lw $sp, off(base); jr <loaded>`. Without that pairing
    // it is ordinary code that happens to store the stack pointer (SOTE has hundreds), and hosting
    // a savepoint in it would be wrong. Require the pairing before treating a saver as self-saving.
    for (auto& kv : g_coswitch_classes) {
        if (kv.second.save_then_calls && switch_offs.find(kv.second.save_off) == switch_offs.end()) {
            kv.second.save_then_calls = false;
        }
    }
}
static const CoswitchClass* coswitch_class_of(uint32_t vram) {
    auto it = g_coswitch_classes.find(vram);
    return (it == g_coswitch_classes.end()) ? nullptr : &it->second;
}
// Does SOME switch routine in this program read a stack pointer back from this slot? The pre-pass
// is the right place for a program-wide fact even though its per-function extents can differ from
// the emission's (chopper: the emitter's severed/static copies are absent from the class map).
static bool coswitch_is_switch_slot(int off) {
    return g_coswitch_switch_offs.find(off) != g_coswitch_switch_offs.end();
}
static bool coswitch_is_switcher(uint32_t vram) {
    const CoswitchClass* c = coswitch_class_of(vram);
    return c != nullptr && c->switcher;
}
static bool coswitch_is_pure_saver(uint32_t vram) {
    const CoswitchClass* c = coswitch_class_of(vram);
    // save_then_calls savers host their own savepoint (tl_coswitch_self_save); only a saver that
    // RETURNS to its caller at the save point (a true setjmp) wants one in the caller's frame.
    return c != nullptr && c->saver && !c->switcher && !c->save_then_calls;
}
// [coswitch] The STARTER idiom (Williams/Midway process kernel, NBA Hangtime func_80068D0C):
//   or $sp, $a0, $zero      ; the new process's stack top, passed in as an argument
//   jr $a1                  ; its entry thunk, passed in as an argument (never returns here)
//   or $a0, $a2, $zero      ; delay slot: the process record for the thunk
// A function that writes $sp by an ALU op from a register that is NOT the frame ($sp/$fp) and was
// NOT loaded from memory, then jumps through an argument register, is moving the CALLER onto a
// brand-new guest stack. Emitted as a coswitch on the block = the new $sp: the runtime runs the
// entry on a fresh fiber and the starter's own frame resumes (and unwinds to the scheduler's
// savepoint) when that process first yields. Measured 2026-09-01: exactly ONE such function across
// mkt/nba/sm64/robotron/cruisn/shadows/cv64, so this cannot misfire on the regression trio.
static bool coswitch_alu_writes_sp(const rabbitizer::InstructionCpu& ins) {
    using InstrIdCs = rabbitizer::InstrId::UniqueId;
    const int sp_reg = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_sp;
    const int fp_reg = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_fp;
    const InstrIdCs id = ins.getUniqueId();
    const int rs = (int)ins.GetO32_rs();
    if (rs == sp_reg || rs == fp_reg) return false;
    if (id == InstrIdCs::cpu_or || id == InstrIdCs::cpu_addu || id == InstrIdCs::cpu_daddu) {
        return (int)ins.GetO32_rd() == sp_reg;
    }
    if (id == InstrIdCs::cpu_addiu || id == InstrIdCs::cpu_daddiu) {
        return (int)ins.GetO32_rt() == sp_reg;
    }
    return false;
}
static bool coswitch_is_arg_reg(int r) {
    return r >= (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_a0 && r <= (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_a3;
}

// The instruction classes a poll SPIN PATH may contain: integer loads (the polled value) and
// pure register/immediate ALU ops. Split out of is_load_only_poll_loop so the early-out
// detector below judges a path by exactly the same rule rather than a second opinion.
static bool is_poll_path_op(const rabbitizer::InstructionCpu& instr, bool& has_load) {
    using InstrId = rabbitizer::InstrId::UniqueId;
    switch (instr.getUniqueId()) {
        // Integer loads (the polled value).
        case InstrId::cpu_lb:
        case InstrId::cpu_lbu:
        case InstrId::cpu_lh:
        case InstrId::cpu_lhu:
        case InstrId::cpu_lw:
        case InstrId::cpu_lwu:
        case InstrId::cpu_ld:
        case InstrId::cpu_lwl:
        case InstrId::cpu_lwr:
        case InstrId::cpu_ldl:
        case InstrId::cpu_ldr:
            has_load = true;
            return true;
        // Pure register/immediate ALU ops (no side effects beyond GPRs).
        case InstrId::cpu_nop:
        case InstrId::cpu_sll:
        case InstrId::cpu_srl:
        case InstrId::cpu_sra:
        case InstrId::cpu_sllv:
        case InstrId::cpu_srlv:
        case InstrId::cpu_srav:
        case InstrId::cpu_addi:
        case InstrId::cpu_addiu:
        case InstrId::cpu_add:
        case InstrId::cpu_addu:
        case InstrId::cpu_sub:
        case InstrId::cpu_subu:
        case InstrId::cpu_and:
        case InstrId::cpu_andi:
        case InstrId::cpu_or:
        case InstrId::cpu_ori:
        case InstrId::cpu_xor:
        case InstrId::cpu_xori:
        case InstrId::cpu_nor:
        case InstrId::cpu_slt:
        case InstrId::cpu_slti:
        case InstrId::cpu_sltiu:
        case InstrId::cpu_sltu:
        case InstrId::cpu_lui:
        case InstrId::cpu_daddi:
        case InstrId::cpu_daddiu:
        case InstrId::cpu_dadd:
        case InstrId::cpu_daddu:
        case InstrId::cpu_dsub:
        case InstrId::cpu_dsubu:
        case InstrId::cpu_dsll:
        case InstrId::cpu_dsrl:
        case InstrId::cpu_dsra:
        case InstrId::cpu_dsll32:
        case InstrId::cpu_dsrl32:
        case InstrId::cpu_dsra32:
        case InstrId::cpu_dsllv:
        case InstrId::cpu_dsrlv:
        case InstrId::cpu_dsrav:
            return true;
        // Anything else (stores, calls, branches, jumps, cop ops, mult/div) disqualifies.
        default:
            return false;
    }
}
// SM64PC S45 (engine, game-agnostic): detect a load-only memory-poll loop ending at the
// conditional branch `instructions[branch_index]` targeting `branch_target` (a backward,
// in-function address). The loop body = [target .. branch + delay slot]. Criteria: small
// (<= 16 instructions), contains at least one integer load (the polled value), and nothing
// but pure register/immediate ALU ops otherwise -- no stores, no calls, no other control
// flow, no cop/hi-lo ops. Such a loop's exit depends solely on ANOTHER agent (on hardware,
// an interrupt-driven higher-priority thread) changing the polled memory; in the cooperative
// runtime the spinner holds the scheduler token forever, so the generator inserts a yield
// guard on the back edge (emit_poll_yield_guard). Semantically free: memory may change under
// the loop on hardware anyway, and the iteration threshold keeps finite load-only scans
// (strlen, checksum loops) at full speed. Canonical case: SM64's turn_off_audio
// `while (sCurrentAudioSPTask != NULL) {}` -- only thread 3's SP-complete handler clears it.
static bool is_load_only_poll_loop(const N64Recomp::Function& func, const std::vector<rabbitizer::InstructionCpu>& instructions, size_t branch_index, uint32_t branch_target) {
    using InstrId = rabbitizer::InstrId::UniqueId;
    uint32_t branch_vram = (uint32_t)(func.vram + branch_index * 4);
    // Backward edge within this function only.
    if (branch_target > branch_vram || branch_target < func.vram) {
        return false;
    }
    size_t target_index = (branch_target - func.vram) / 4;
    size_t end_index = branch_index + 1; // include the delay slot
    if (end_index >= instructions.size()) {
        return false;
    }
    if (end_index - target_index > 16) {
        return false; // poll loops are tiny
    }
    bool has_load = false;
    for (size_t i = target_index; i <= end_index; i++) {
        if (i == branch_index) {
            continue; // the back-edge branch itself
        }
        if (!is_poll_path_op(instructions[i], has_load)) {
            return false;
        }
    }
    return has_load;
}

// EARLY-OUT POLL LOOP (Saikyou Habu Shougi, 2026-09-07). is_load_only_poll_loop measures the WHOLE
// loop body, so it rejects the far commoner shape where the poll sits at the TOP of a large loop and
// branches over the work while the flag is clear:
//
//     L_head: lw t6,0(s5); lw t7,0(s0); and t8,t6,t7
//             beql t8,zero,L_tail          <- the path actually executed while waiting
//             ... work, including calls ...
//     L_tail: addiu t7,t6,1
//             b L_head
//             sw t7,0(s4)                  <- iteration counter
//
// While the flag is clear the executed path is seven instructions with NO CALL, so the runtime never
// reaches an OS entry, never pumps external messages and never reschedules. The spinner keeps the
// scheduler token and every other thread starves - the livelock described at the top of
// ultramodern/src/scheduling.cpp. Measured on that cart: FOUR thread resumes in fifteen seconds and
// then nothing, its main thread blocked and its screen never unblanked.
//
// Judge the SPIN PATH, not the body: from the loop head, loads and pure ALU only (at least one load,
// the polled value), then a conditional branch landing within a few instructions of the back edge. A
// call, a store, or any other control flow before that branch rejects it. The work path is never
// examined - it is not the path that starves anyone, and it ends at the same back edge either way.
static bool is_early_out_poll_loop(const N64Recomp::Function& func,
                                   const std::vector<rabbitizer::InstructionCpu>& instructions,
                                   size_t branch_index, uint32_t branch_target) {
    using InstrId = rabbitizer::InstrId::UniqueId;
    uint32_t branch_vram = (uint32_t)(func.vram + branch_index * 4);

    // Backward edge within this function only.
    if (branch_target > branch_vram || branch_target < func.vram) {
        return false;
    }
    size_t target_index = (branch_target - func.vram) / 4;
    if (branch_index <= target_index || branch_index + 1 >= instructions.size()) {
        return false;
    }
    // The poll must be AT the head. A longer prefix is a loop doing work, not one waiting.
    const size_t max_prefix = 8;
    // The early out must land on the tail, i.e. within a couple of instructions of the back edge;
    // anything earlier re-enters the work and is not a spin.
    const size_t tail_slack = 3;
    bool has_load = false;
    for (size_t i = target_index; (i < target_index + max_prefix) && (i < branch_index); i++) {
        switch (instructions[i].getUniqueId()) {
            case InstrId::cpu_beq:
            case InstrId::cpu_bne:
            case InstrId::cpu_beql:
            case InstrId::cpu_bnel:
            case InstrId::cpu_beqz:
            case InstrId::cpu_bnez:
            case InstrId::cpu_bgez:
            case InstrId::cpu_bgezl:
            case InstrId::cpu_bgtz:
            case InstrId::cpu_bgtzl:
            case InstrId::cpu_blez:
            case InstrId::cpu_blezl:
            case InstrId::cpu_bltz:
            case InstrId::cpu_bltzl: {
                uint32_t tgt = (uint32_t)instructions[i].getBranchVramGeneric();
                if (tgt <= branch_vram && tgt >= func.vram) {
                    size_t tgt_index = (tgt - func.vram) / 4;
                    if ((tgt_index + tail_slack >= branch_index) && (tgt_index > i)) {
                        return has_load;   // a call-free path from the head to the back edge
                    }
                }
                return false;   // branches somewhere else: not the early-out shape
            }
            default:
                if (!is_poll_path_op(instructions[i], has_load)) {
                    return false;
                }
                break;
        }
    }
    return false;
}

// Companion to is_load_only_poll_loop for a CALLING poll-loop: a backward loop whose body makes
// a function call. Such a loop is COARSE (call overhead dominates each iteration), so guarding
// its back edge with the cheap NON-BLOCKING yield costs nothing measurable -- and it is the shape
// a cooperative busy-spin takes when it is NOT a tight load-only poll: an arcade / custom-runtime
// main/init loop that calls worker/drain functions while spinning on a flag the blocked worker
// threads cannot set until the spinner yields the scheduler token (MKT's t2 main loop). Tight
// no-call inner loops (memcpy, audio mixing, rasterizers) are deliberately NOT matched, so their
// hot path is untouched. The 100k-iteration threshold means a finite calling loop never yields;
// only a genuine >100k-iteration spin does, and the yield is then semantically free (it just
// delivers the interrupts / runs the higher-priority thread that hardware would have anyway).
static bool is_calling_poll_loop(const N64Recomp::Function& func, const std::vector<rabbitizer::InstructionCpu>& instructions, size_t branch_index, uint32_t branch_target) {
    using InstrId = rabbitizer::InstrId::UniqueId;
    uint32_t branch_vram = (uint32_t)(func.vram + branch_index * 4);
    if (branch_target > branch_vram || branch_target < func.vram) {
        return false; // backward edge within this function only
    }
    size_t target_index = (branch_target - func.vram) / 4;
    size_t end_index = branch_index + 1; // include the delay slot
    if (end_index >= instructions.size()) {
        return false;
    }
    if (end_index - target_index > 16384) {
        return false; // sanity bound on the compile-time body scan
    }
    // DIAGNOSTIC OPT-IN (2026-08-29, MKT bring-up): reproduce June's guard-EVERY-backward-loop mode.
    // MKT's t2 main loop and t3 I/O manager spin in STORE-BEARING, NON-calling loops. Those are
    // rejected by is_load_only_poll_loop (needs a load-only body) AND by the store-disqualifier
    // below, so neither detector guards them -> t2 never yields -> it holds the cooperative token
    // forever -> the pri-90 VI consumer never drains its queue -> 1 frame, then black.
    // June's diagnostic build emitted 1051 guards for MKT and got past this; today's narrowed
    // detector emits 292. This gate exists to TEST that difference, not to ship: guarding every
    // loop wrongly preempts Blast Corps' boot inflater (see the store rule below).
    // Unset => byte-identical output for every game. Set only for a deliberate experiment.
    static const bool guard_all_loops = [] {
        const char* e = std::getenv("RECOMP_GUARD_ALL_LOOPS");
        return e != nullptr && e[0] == '1';
    }();
    if (guard_all_loops) {
        return true;
    }
    // CALL/STORE DISCRIMINATOR (Blast Corps boot-decompress fix, 2026-06-20): a CALLING poll loop spins on a
    // flag while calling worker/drain functions (Doom 64's idle thread, MKT's t2 main loop) and needs the
    // non-blocking yield so the blocked worker threads can run and set the flag. But a loop that STORES to
    // memory is making PROGRESS toward its OWN exit (a decompressor / memcpy / rasterizer writing output to an
    // advancing pointer), NOT spinning on an external flag -- yielding it past the 100k threshold WRONGLY
    // preempts it. Blast Corps' boot gzip-inflater LZ77 body @func_80220A4C writes 132 KB+ of output via `sb`,
    // exceeds 100k iterations, gets preempted, and a freshly-created game thread then deadlocks the cooperative
    // scheduler so the decompress never resumes -> the game never finishes boot -> black. So: ANY store in the
    // body DISQUALIFIES (it is progress, never an external-flag spin); only a store-FREE body that makes a call
    // is a genuine calling poll. (Tight no-call load-only polls are handled by is_load_only_poll_loop above.)
    bool has_call = false;
    for (size_t i = target_index; i <= end_index; i++) {
        if (i == branch_index) {
            continue; // the back-edge branch itself
        }
        switch (instructions[i].getUniqueId()) {
            // Stores = progress toward the loop's own exit, not a poll on a flag a blocked worker must set.
            case InstrId::cpu_sb:
            case InstrId::cpu_sh:
            case InstrId::cpu_sw:
            case InstrId::cpu_swl:
            case InstrId::cpu_swr:
            case InstrId::cpu_sd:
            case InstrId::cpu_sdl:
            case InstrId::cpu_sdr:
            case InstrId::cpu_swc1:
            case InstrId::cpu_sdc1:
                return false;
            // A function call each iteration is the calling-poll shape (the spinner drains workers).
            case InstrId::cpu_jal:
            case InstrId::cpu_jalr:
                has_call = true;
                break;
            default:
                break;
        }
    }
    return has_call;
}

// 2026-09-01 (Mortal Kombat Trilogy boot wedge; general): a load-only poll loop whose body
// contains BRANCHES. is_load_only_poll_loop rejects any branch in the body and caps it at 16
// instructions, so a multi-condition poll such as MKT's func_800812C8 --
//     L: lw t1,slotA; bgez t1,L; lw t2,slotB; bgezl t2,L; lw t3,slotC; bgezl t3,L; ...
// (the main thread waits for five frame-buffer slots to be released by its VI-driven
// scheduler thread) -- gets a guard on the ONE back-edge whose body is branch-free and
// spins unguarded on the others. The spinner then never pumps the external message queue,
// the higher-priority consumer never runs, and the polled slots never change. MEASURED
// 2026-09-01: sampler RIP inside func_800812C8 across four snapshots, 26 s of CPU on that
// thread, every other guest thread parked in osRecvMesg, 40 VI ticks coalesced undelivered;
// the guard-every-loop diagnostic build guards all five edges and boots past it.
// Same class as the load-only poll: no store, no call => the loop cannot make progress toward
// its own exit; only another agent can. Criteria: backward in-function edge, body <= 64
// instructions, at least one integer load, and nothing but loads, GPR ALU ops, and
// NON-LINKING branches/jumps whose targets stay inside the function (inner control flow or
// loop exits). Stores, calls (jal/jalr/bal/b*al), jr, cop ops, mult/div and everything else
// disqualify exactly as in the two detectors above. Checked AFTER them, so every loop they
// already matched is emitted exactly as before; the guard used here is the NON-blocking
// calling-poll yield (yield_self_poll): a finite loop that happens to match pays a
// non-blocking pump every 64 iterations past the 100k threshold and never sleeps.
static bool is_branching_load_only_poll_loop(const N64Recomp::Function& func, const std::vector<rabbitizer::InstructionCpu>& instructions, size_t branch_index, uint32_t branch_target) {
    using InstrId = rabbitizer::InstrId::UniqueId;
    uint32_t branch_vram = (uint32_t)(func.vram + branch_index * 4);
    if (branch_target > branch_vram || branch_target < func.vram) {
        return false; // backward edge within this function only
    }
    const uint32_t func_vram_end = func.vram + (uint32_t)(func.words.size() * sizeof(func.words[0]));
    size_t target_index = (branch_target - func.vram) / 4;
    size_t end_index = branch_index + 1; // include the delay slot
    if (end_index >= instructions.size()) {
        return false;
    }
    if (end_index - target_index > 64) {
        return false; // still a small poll, just not a branch-free one
    }
    bool has_load = false;
    for (size_t i = target_index; i <= end_index; i++) {
        if (i == branch_index) {
            continue; // the back-edge branch itself
        }
        switch (instructions[i].getUniqueId()) {
            // Integer loads (the polled values).
            case InstrId::cpu_lb:
            case InstrId::cpu_lbu:
            case InstrId::cpu_lh:
            case InstrId::cpu_lhu:
            case InstrId::cpu_lw:
            case InstrId::cpu_lwu:
            case InstrId::cpu_ld:
            case InstrId::cpu_lwl:
            case InstrId::cpu_lwr:
            case InstrId::cpu_ldl:
            case InstrId::cpu_ldr:
                has_load = true;
                break;
            // Pure register/immediate ALU ops (no side effects beyond GPRs).
            case InstrId::cpu_nop:
            case InstrId::cpu_sll:
            case InstrId::cpu_srl:
            case InstrId::cpu_sra:
            case InstrId::cpu_sllv:
            case InstrId::cpu_srlv:
            case InstrId::cpu_srav:
            case InstrId::cpu_addi:
            case InstrId::cpu_addiu:
            case InstrId::cpu_add:
            case InstrId::cpu_addu:
            case InstrId::cpu_sub:
            case InstrId::cpu_subu:
            case InstrId::cpu_and:
            case InstrId::cpu_andi:
            case InstrId::cpu_or:
            case InstrId::cpu_ori:
            case InstrId::cpu_xor:
            case InstrId::cpu_xori:
            case InstrId::cpu_nor:
            case InstrId::cpu_slt:
            case InstrId::cpu_slti:
            case InstrId::cpu_sltiu:
            case InstrId::cpu_sltu:
            case InstrId::cpu_lui:
            case InstrId::cpu_daddi:
            case InstrId::cpu_daddiu:
            case InstrId::cpu_dadd:
            case InstrId::cpu_daddu:
            case InstrId::cpu_dsub:
            case InstrId::cpu_dsubu:
            case InstrId::cpu_dsll:
            case InstrId::cpu_dsrl:
            case InstrId::cpu_dsra:
            case InstrId::cpu_dsll32:
            case InstrId::cpu_dsrl32:
            case InstrId::cpu_dsra32:
            case InstrId::cpu_dsllv:
            case InstrId::cpu_dsrlv:
            case InstrId::cpu_dsrav:
                break;
            // Non-linking branches and in-function jumps: control flow only, never progress.
            case InstrId::cpu_b:
            case InstrId::cpu_j:
            case InstrId::cpu_beq:
            case InstrId::cpu_bne:
            case InstrId::cpu_beql:
            case InstrId::cpu_bnel:
            case InstrId::cpu_beqz:
            case InstrId::cpu_bnez:
            case InstrId::cpu_bgez:
            case InstrId::cpu_bgezl:
            case InstrId::cpu_bgtz:
            case InstrId::cpu_bgtzl:
            case InstrId::cpu_blez:
            case InstrId::cpu_blezl:
            case InstrId::cpu_bltz:
            case InstrId::cpu_bltzl: {
                uint32_t tgt = (uint32_t)instructions[i].getBranchVramGeneric();
                if (tgt < func.vram || tgt >= func_vram_end) {
                    return false; // leaves the function: not a poll shape we understand
                }
                break;
            }
            // Anything else (stores, calls, jr, cop ops, mult/div) disqualifies.
            default:
                return false;
        }
    }
    return has_load;
}

// F1 Pole Position 64 #254 (2026-09-05, engine, game-agnostic): the idle/busy-wait spin that
// WRITES. is_load_only_poll_loop and its branching sibling reject any store, on the premise that a
// store is "progress toward the loop's own exit." That premise fails for an UNCONDITIONAL backward
// branch: such a loop has NO compiler-visible exit at all, so a store in its body is not progress —
// it is a counter/heartbeat an idle thread bumps forever (F1 Pole's thread-1 idle loop at 0x80000610
// demotes itself to priority 0 and spins `D_800B0150:D_800B0154 += 1; b .`, hog-sampled dmarks=0).
// Called ONLY for a backward, in-function unconditional b/j (the cpu_j/cpu_b block), where the branch
// is always taken, so if the body is STRAIGHT-LINE — no call, no jr/jalr, no other branch/jump, no
// trap/cop2/mult-div — the only exit is preemption and the back edge MUST be a yield point. Stores +
// loads + register ALU are allowed; anything that could transfer control or trap disqualifies (kept
// tight so a loop whose real exit lives in its body is not mistaken for an infinite spin). Emits the
// NON-BLOCKING guard, so a finite straight-line loop stays byte-identical until the 100k threshold.
static bool is_unconditional_straightline_spin(const N64Recomp::Function& func, const std::vector<rabbitizer::InstructionCpu>& instructions, size_t branch_index, uint32_t branch_target) {
    using InstrId = rabbitizer::InstrId::UniqueId;
    uint32_t branch_vram = (uint32_t)(func.vram + branch_index * 4);
    if (branch_target > branch_vram || branch_target < func.vram) {
        return false; // backward edge within this function only
    }
    size_t target_index = (branch_target - func.vram) / 4;
    size_t end_index = branch_index + 1; // include the delay slot
    if (end_index >= instructions.size()) {
        return false;
    }
    if (end_index - target_index > 64) {
        return false; // an idle spin body is small; do not scan large spans
    }
    for (size_t i = target_index; i <= end_index; i++) {
        if (i == branch_index) {
            continue; // the terminal unconditional branch itself
        }
        switch (instructions[i].getUniqueId()) {
            // Integer loads.
            case InstrId::cpu_lb: case InstrId::cpu_lbu: case InstrId::cpu_lh: case InstrId::cpu_lhu:
            case InstrId::cpu_lw: case InstrId::cpu_lwu: case InstrId::cpu_ld:
            case InstrId::cpu_lwl: case InstrId::cpu_lwr: case InstrId::cpu_ldl: case InstrId::cpu_ldr:
            // Integer stores — the distinguishing allowance vs is_load_only_poll_loop.
            case InstrId::cpu_sb: case InstrId::cpu_sh: case InstrId::cpu_sw: case InstrId::cpu_sd:
            case InstrId::cpu_swl: case InstrId::cpu_swr: case InstrId::cpu_sdl: case InstrId::cpu_sdr:
            // Pure register/immediate ALU.
            case InstrId::cpu_nop: case InstrId::cpu_sll: case InstrId::cpu_srl: case InstrId::cpu_sra:
            case InstrId::cpu_sllv: case InstrId::cpu_srlv: case InstrId::cpu_srav:
            case InstrId::cpu_addi: case InstrId::cpu_addiu: case InstrId::cpu_add: case InstrId::cpu_addu:
            case InstrId::cpu_sub: case InstrId::cpu_subu: case InstrId::cpu_and: case InstrId::cpu_andi:
            case InstrId::cpu_or: case InstrId::cpu_ori: case InstrId::cpu_xor: case InstrId::cpu_xori:
            case InstrId::cpu_nor: case InstrId::cpu_slt: case InstrId::cpu_slti: case InstrId::cpu_sltiu:
            case InstrId::cpu_sltu: case InstrId::cpu_lui:
            case InstrId::cpu_daddi: case InstrId::cpu_daddiu: case InstrId::cpu_dadd: case InstrId::cpu_daddu:
            case InstrId::cpu_dsub: case InstrId::cpu_dsubu:
            case InstrId::cpu_dsll: case InstrId::cpu_dsrl: case InstrId::cpu_dsra:
            case InstrId::cpu_dsll32: case InstrId::cpu_dsrl32: case InstrId::cpu_dsra32:
            case InstrId::cpu_dsllv: case InstrId::cpu_dsrlv: case InstrId::cpu_dsrav:
                break;
            // Anything else (calls, jr/jalr, any branch/jump, mult/div, cop, trap, syscall)
            // could transfer control out of the loop — then it is not a guaranteed infinite spin.
            default:
                return false;
        }
    }
    return true;
}

// GENERAL FIX (sweep, Wipeout 64 #284): jump-table addend temps, one definition each.
// A jump table's `addu` emits `gpr jr_addend_<jr_vram> = <reg>;` and the `jr`'s switch reads it. Every
// delay-slot instruction is emitted TWICE by design (once on the branch-taken path before `goto after_N`,
// once at its in-order position so anything that branches to the delay slot still runs it), so an `addu`
// that sits in a delay slot defined the same temp twice. When both copies land at function scope (the
// `jal` form) that is a redefinition and the emission cannot compile at all (MSVC C2374).
// Per function: remember the scope depth at which each temp was defined; a later emission whose definition
// is at function scope (depth 0, in scope everywhere below it) becomes an assignment instead. A definition
// made inside a branch body (depth > 0) is NOT reused, so the pre-existing shape of that case is untouched.
struct JtblAddendScopes {
    std::unordered_map<uint32_t, int> defined_depth; // jr_vram -> scope depth of the definition
    int depth = 0;                                   // conditional-branch bodies currently open
};

template <typename GeneratorType>
bool process_instruction(GeneratorType& generator, const N64Recomp::Context& context, const N64Recomp::Function& func, size_t func_index, const N64Recomp::FunctionStats& stats, const std::unordered_set<uint32_t>& jtbl_lw_instructions, JtblAddendScopes& jtbl_addends, size_t instr_index, const std::vector<rabbitizer::InstructionCpu>& instructions, std::ostream& output_file, bool indent, bool emit_link_branch, int link_branch_index, size_t reloc_index, bool& needs_link_branch, bool& is_branch_likely, bool tag_reference_relocs, std::span<std::vector<uint32_t>> static_funcs_out, int delay_slot_depth = 0) {
    using namespace N64Recomp;

    const auto& section = context.sections[func.section_index];
    const auto& instr = instructions[instr_index];
    needs_link_branch = false;
    is_branch_likely = false;
    uint32_t instr_vram = instr.getVram();
    InstrId instr_id = instr.getUniqueId();

    auto print_indent = [&]() {
        fmt::print(output_file, "    ");
    };

    auto hook_find = func.function_hooks.find(instr_index);
    if (hook_find != func.function_hooks.end()) {
        fmt::print(output_file, "    {}\n", hook_find->second);
        if (indent) {
            print_indent();
        }
    }

    // Output a comment with the original instruction
    print_indent();
    if (instr.isBranch() || instr_id == InstrId::cpu_j) {
        generator.emit_comment(fmt::format("0x{:08X}: {}", instr_vram, instr.disassemble(0, fmt::format("L_{:08X}", (uint32_t)instr.getBranchVramGeneric()))));
    } else if (instr_id == InstrId::cpu_jal) {
        generator.emit_comment(fmt::format("0x{:08X}: {}", instr_vram, instr.disassemble(0, fmt::format("0x{:08X}", (uint32_t)instr.getBranchVramGeneric()))));
    } else {
        generator.emit_comment(fmt::format("0x{:08X}: {}", instr_vram, instr.disassemble(0)));
    }

    // Replace loads for jump table entries into addiu. This leaves the jump table entry's address in the output register
    // instead of the entry's value, which can then be used to determine the offset from the start of the jump table.
    if (jtbl_lw_instructions.contains(instr_vram)) {
        assert(instr_id == InstrId::cpu_lw);
        instr_id = InstrId::cpu_addiu;
    }

    N64Recomp::RelocType reloc_type = N64Recomp::RelocType::R_MIPS_NONE;
    bool has_reloc = false;
    uint32_t reloc_section = 0;
    uint32_t reloc_target_section_offset = 0;
    size_t reloc_reference_symbol = (size_t)-1;

    uint32_t func_vram_end = func.vram + func.words.size() * sizeof(func.words[0]);

    uint16_t imm = instr.Get_immediate();

    // Check if this instruction has a reloc.
    if (section.relocs.size() > 0 && section.relocs[reloc_index].address == instr_vram) {
        has_reloc = true;
        // Get the reloc data for this instruction
        const auto& reloc = section.relocs[reloc_index];
        reloc_section = reloc.target_section;

        // Check if the relocation references a relocatable section.
        bool target_relocatable = false;
        if (!reloc.reference_symbol && reloc_section != N64Recomp::SectionAbsolute) {
            const auto& target_section = context.sections[reloc_section];
            target_relocatable = target_section.relocatable;
        }

        // Only process this relocation if the target section is relocatable or if this relocation targets a reference symbol.
        if (target_relocatable || reloc.reference_symbol) {
            // Record the reloc's data.
            reloc_type = reloc.type;
            reloc_target_section_offset = reloc.target_section_offset;
            // Ignore all relocs that aren't MIPS_HI16, MIPS_LO16 or MIPS_26.
            if (reloc_type == N64Recomp::RelocType::R_MIPS_HI16 || reloc_type == N64Recomp::RelocType::R_MIPS_LO16 || reloc_type == N64Recomp::RelocType::R_MIPS_26) {
                if (reloc.reference_symbol) {
                    reloc_reference_symbol = reloc.symbol_index;
                    // Don't try to relocate special section symbols.
                    if (context.is_regular_reference_section(reloc.target_section) || reloc_section == N64Recomp::SectionAbsolute) {
                        // TODO this may not be needed anymore as HI16/LO16 relocs to non-relocatable sections is handled directly in elf parsing.
                        bool ref_section_relocatable = context.is_reference_section_relocatable(reloc.target_section);
                        // Resolve HI16 and LO16 reference symbol relocs to non-relocatable sections by patching the instruction immediate.
                        if (!ref_section_relocatable && (reloc_type == N64Recomp::RelocType::R_MIPS_HI16 || reloc_type == N64Recomp::RelocType::R_MIPS_LO16)) {
                            // The reloc has been processed, so set it to none to prevent it getting processed a second time during instruction code generation.
                            reloc_type = N64Recomp::RelocType::R_MIPS_NONE;
                            reloc_reference_symbol = (size_t)-1;
                        }
                    }
                }
            }

            // Repoint bss relocations at their non-bss counterpart section.
            auto find_bss_it = context.bss_section_to_section.find(reloc_section);
            if (find_bss_it != context.bss_section_to_section.end()) {
                reloc_section = find_bss_it->second;
            }
        }
    }

    auto process_delay_slot = [&](bool use_indent) {
        if (instr_index < instructions.size() - 1) {
            // Each branch/jump in a delay slot recurses process_instruction one level deeper. Real
            // code has at most a level or two of this; a run of branch-encoded words (data
            // misidentified as code) chains it hundreds deep until the host stack overflows,
            // killing the whole tool with no per-function error. Cap the depth generously so
            // genuine code keeps its historical output and runaway garbage fails attributably.
            if (delay_slot_depth >= 8) {
                fmt::print(stderr, "Runaway branch-in-delay-slot chain at 0x{:08X} in {} (depth {}; likely data misidentified as code)\n",
                    (uint32_t)instructions[instr_index + 1].getVram(), func.name, delay_slot_depth);
                return false;
            }
            bool dummy_needs_link_branch;
            bool dummy_is_branch_likely;
            size_t next_reloc_index = reloc_index;
            uint32_t next_vram = instr_vram + 4;
            if (reloc_index + 1 < section.relocs.size() && next_vram > section.relocs[reloc_index].address) {
                next_reloc_index++;
            }
            if (!process_instruction(generator, context, func, func_index, stats, jtbl_lw_instructions, jtbl_addends, instr_index + 1, instructions, output_file, use_indent, false, link_branch_index, next_reloc_index, dummy_needs_link_branch, dummy_is_branch_likely, tag_reference_relocs, static_funcs_out, delay_slot_depth + 1)) {
                return false;
            }
        }
        return true;
    };

    auto print_link_branch = [&]() {
        if (needs_link_branch) {
            print_indent();
            generator.emit_goto(fmt::format("after_{}", link_branch_index));
        }
    };

    auto print_return_with_delay_slot = [&]() {
        if (!process_delay_slot(false)) {
            return false;
        }
        print_indent();
        generator.emit_return(context, func_index);
        print_link_branch();
        return true;
    };

    auto print_goto_with_delay_slot = [&](const std::string& target) {
        if (!process_delay_slot(false)) {
            return false;
        }
        print_indent();
        generator.emit_goto(target);
        print_link_branch();
        return true;
    };

    auto print_func_call_by_register = [&](int reg) {
        if (!process_delay_slot(false)) {
            return false;
        }
        print_indent();
        generator.emit_function_call_by_register(reg);
        print_link_branch();
        return true;
    };

    auto print_func_call_by_address = [&generator, reloc_target_section_offset, has_reloc, reloc_section, reloc_reference_symbol, reloc_type, &context, &func, &static_funcs_out, &needs_link_branch, &print_indent, &process_delay_slot, &print_link_branch]
        (uint32_t target_func_vram, bool tail_call = false, bool indent = false)
    {
        bool call_by_lookup = false;
        bool call_by_name = false;
        // [coswitch] a direct call to a PURE saver (setjmp): the savepoint lives in THIS frame. The
        // callee's block register is captured after the delay slot (NBA Hangtime computes the block IN
        // the delay slot: `jal setjmp; addiu $a0, $a0, 0x20`), the savepoint is emitted after the call
        // and before the link-branch goto, so a resume flows straight into the caller's continuation.
        const CoswitchClass* cs_callee = (!tail_call && tl_coswitch_caller) ? coswitch_class_of(target_func_vram) : nullptr;
        const bool cs_saver_call = cs_callee != nullptr && cs_callee->saver && !cs_callee->switcher && !cs_callee->save_then_calls && cs_callee->save_base >= 0;
        // Event symbol, emit a call to the runtime to trigger this event.
        if (reloc_section == N64Recomp::SectionEvent) {
            needs_link_branch = !tail_call;
            if (indent) {
                print_indent();
            }
            if (!process_delay_slot(false)) {
                return false;
            }
            print_indent();
            generator.emit_trigger_event((uint32_t)reloc_reference_symbol);
            print_link_branch();
        }
        // Normal symbol or reference symbol, 
        else {
            std::string jal_target_name{};
            size_t matched_func_index = (size_t)-1;
            if (reloc_reference_symbol != (size_t)-1) {
                if (reloc_type != N64Recomp::RelocType::R_MIPS_26) {
                    N64Recomp::diag::hit({ .kind = "unsupported-reloc-type", .vaddr = target_func_vram, .func = func.name, .a = (uint32_t)reloc_type });
                    fmt::print(stderr, "Unsupported reloc type {} on jal instruction in {}\n", (int)reloc_type, func.name);
                    return false;
                }

                if (!context.skip_validating_reference_symbols) {
                    const auto& ref_symbol = context.get_reference_symbol(reloc_section, reloc_reference_symbol);
                    if (ref_symbol.section_offset != reloc_target_section_offset) {
                        N64Recomp::diag::hit({ .kind = "reloc-addend-mismatch", .vaddr = target_func_vram, .func = func.name, .a = reloc_target_section_offset, .b = ref_symbol.section_offset });
                        fmt::print(stderr, "Function {} uses a MIPS_R_26 addend, which is not supported yet\n", func.name);
                        return false;
                    }
                }
            }
            else {
                uint32_t target_section = func.section_index;
                // If this instruction has a reloc and the target section is a normal section, use the section of the reloc when searching for a matching target function. 
                if (has_reloc && reloc_section < 65500) {
                    target_section = reloc_section;
                }
                JalResolutionResult jal_result = resolve_jal(context, target_section, target_func_vram, matched_func_index);

                switch (jal_result) {
                    case JalResolutionResult::NoMatch:
                        // GENERAL FIX (cv64): a static jal whose target isn't a statically-resolvable
                        // function used to abort the ENTIRE recompilation (return false -> N64Recomp
                        // clears the output + exits 1), which forced hand-stubbing the caller (e.g.
                        // CV64's func_8002B4B4 player action-update jal'ing into the relocatable 0x803D
                        // player overlay; same class as cutscene_1C). Instead, fall back to runtime
                        // function-pointer resolution exactly like the Ambiguous case below:
                        // get_function() resolves it via func_map when the section is loaded, or emits
                        // a clear "no recompiled function at vaddr" error if genuinely missing. Since
                        // NoMatch was already a hard build failure, this can only turn an abort into a
                        // working (or cleanly-diagnosed) call — it cannot regress a previously-good build.
                        N64Recomp::diag::hit({ .kind = "jal-nomatch", .vaddr = target_func_vram, .func = func.name, .a = target_func_vram, .section_index = func.section_index });
                        fmt::print(stderr, "[Info] Unresolved jal target 0x{:08X} in {}, using runtime function lookup (was: hard abort)\n", target_func_vram, func.name);
                        call_by_lookup = true;
                        break;
                    case JalResolutionResult::Match:
                        jal_target_name = context.functions[matched_func_index].name;
                        break;
                    case JalResolutionResult::CreateStatic:
                        // Create a static function add it to the static function list for this section.
                        jal_target_name = fmt::format("static_{}_{:08X}", func.section_index, target_func_vram);
                        static_funcs_out[func.section_index].push_back(target_func_vram);
                        call_by_name = true;
                        break;
                    case JalResolutionResult::Ambiguous:
                        N64Recomp::diag::hit({ .kind = "jal-ambiguous", .vaddr = target_func_vram, .func = func.name, .a = target_func_vram });
                        // Print a warning if lookup isn't forced for all non-reloc function calls.
                        if (!context.use_lookup_for_all_function_calls) {
                            fmt::print(stderr, "[Info] Ambiguous jal target 0x{:08X} in function {}, falling back to function lookup\n", target_func_vram, func.name);
                        }
                        // Relocation isn't necessary for jumps inside a relocatable section, as this code path will never run if the target vram
                        // is in the current function's section (see the branch for `in_current_section` above).
                        // If a game ever needs to jump between multiple relocatable sections, relocation will be necessary here.
                        call_by_lookup = true;
                        break;
                    case JalResolutionResult::Error:
                        N64Recomp::diag::hit({ .kind = "jal-error", .vaddr = target_func_vram, .func = func.name, .a = target_func_vram });
                        fmt::print(stderr, "Internal error when resolving jal to address 0x{:08X} in function {}. Please report this issue.\n", target_func_vram, func.name);
                        return false;
                }
            }
            needs_link_branch = !tail_call;
            if (indent) {
                print_indent();
            }
            if (!process_delay_slot(false)) {
                return false;
            }
            if (cs_saver_call) {
                print_indent();
                if (cs_callee->save_base_is_const) {
                    generator.emit_coswitch_capture_const(cs_callee->save_base_const, true);
                }
                else {
                    generator.emit_coswitch_capture(cs_callee->save_base, true);
                }
            }
            print_indent();
            if (reloc_reference_symbol != (size_t)-1) {
                generator.emit_function_call_reference_symbol(context, reloc_section, reloc_reference_symbol, reloc_target_section_offset);
            }
            else if (call_by_lookup) {
                generator.emit_function_call_lookup(target_func_vram);
            }
            else if (call_by_name) {
                generator.emit_named_function_call(jal_target_name);
            }
            else {
                generator.emit_function_call(context, matched_func_index);
            }
            if (cs_saver_call) {
                print_indent();
                generator.emit_coswitch_savepoint(false);
            }
            print_link_branch();
        }
        return true;
    };

    auto print_branch = [&](uint32_t branch_target) {
        // If the branch target is outside the current function, check if it can be treated as a tail call.
        if (branch_target < func.vram || branch_target >= func_vram_end) {
            // If the branch target is the start of some known function, this can be handled as a tail call.
            // FIXME: how to deal with static functions?
            if (context.functions_by_vram.find(branch_target) != context.functions_by_vram.end()) {
                fmt::print("Tail call in {} to 0x{:08X}\n", func.name, branch_target);
                if (!print_func_call_by_address(branch_target, true, true)) {
                    return false;
                }
                print_indent();
                generator.emit_return(context, func_index);
                // TODO check if this branch close should exist.
                // print_indent();
                // generator.emit_branch_close();
                return true;
            }

            N64Recomp::diag::hit({ .kind = "branch-out-of-function", .vaddr = instr_vram, .func = func.name, .a = branch_target, .b = func.vram });
            fmt::print(stderr, "[Warn] Function {} is branching outside of the function (to 0x{:08X}) -> lookup tail-call\n", func.name, branch_target);
            // EMPTY-STUB FIX shape B (NC RUN-30/61, the silent-thread-death class): a conditional branch
            // to an out-of-function NON-ENTRY target. The old assumption — "data misread as code, never
            // taken in real exec" — is false for splat mis-splits: real code branches into the middle of
            // a neighbor (NC's audio loop head), and the old delay-slot + early-return emission made the
            // thread fall off its entry function and die silently when taken. Emit a tail call through
            // runtime lookup instead: get_function() resolves a real registered body, or routes through
            // the live-gap JIT (trustworthy post-dc07f9c), which itself fail-safes on genuine data. For
            // functions that never execute these paths (actual data), this is behaviorally identical.
            // Still no dangling `goto L_X` (the C2094 recomp_entrypoint concern), and both the C and
            // Live generators implement emit_function_call_lookup, so JIT'd gap code gets the same fix.
            if (!process_delay_slot(true)) {
                return false;
            }
            if (generator.speculative_code()) {
                // Live-gap JIT compiling speculative bytes: a branch-out here is usually garbage
                // decode — keep the early-return fail-safe (chaining it produced wild stores; PD boot).
                print_indent();
                print_indent();
                generator.emit_return(context, func_index);
                return true;
            }
            print_indent();
            print_indent();
            generator.emit_function_call_lookup(branch_target);
            print_indent();
            print_indent();
            generator.emit_return(context, func_index);
            return true;
        }

        if (!process_delay_slot(true)) {
            return false;
        }

        print_indent();
        print_indent();
        generator.emit_goto(fmt::format("L_{:08X}", branch_target));
        // TODO check if this link branch ever exists.
        if (needs_link_branch) {
            print_indent();
            print_indent();
            generator.emit_goto(fmt::format("after_{}", link_branch_index));
        }
        return true;
    };

    if (indent) {
        print_indent();
    }

    int rd = (int)instr.GetO32_rd();
    int rs = (int)instr.GetO32_rs();
    int rt = (int)instr.GetO32_rt();
    int sa = (int)instr.Get_sa();

    int fd = (int)instr.GetO32_fd();
    int fs = (int)instr.GetO32_fs();
    int ft = (int)instr.GetO32_ft();

    int cop1_cs = (int)instr.Get_cop1cs();

    bool handled = true;

    switch (instr_id) {
    case InstrId::cpu_nop:
        fmt::print(output_file, "\n");
        break;
    // Cop0 (Limited functionality)
    case InstrId::cpu_mfc0:
        {
            Cop0Reg reg = instr.Get_cop0d();
            switch (reg) {
            case Cop0Reg::COP0_Status:
                print_indent();
                generator.emit_cop0_status_read(rt);
                break;
            // TLB (LLE) cop0 registers
            case Cop0Reg::COP0_Index:    print_indent(); generator.emit_cop0_tlb_read(0, rt);  break;
            case Cop0Reg::COP0_Random:   print_indent(); generator.emit_cop0_tlb_read(1, rt);  break;
            case Cop0Reg::COP0_EntryLo0: print_indent(); generator.emit_cop0_tlb_read(2, rt);  break;
            case Cop0Reg::COP0_EntryLo1: print_indent(); generator.emit_cop0_tlb_read(3, rt);  break;
            case Cop0Reg::COP0_PageMask: print_indent(); generator.emit_cop0_tlb_read(5, rt);  break;
            case Cop0Reg::COP0_Wired:    print_indent(); generator.emit_cop0_tlb_read(6, rt);  break;
            case Cop0Reg::COP0_EntryHi:  print_indent(); generator.emit_cop0_tlb_read(10, rt); break;
            default:
                // Generic COP0 read: exception-state regs (EPC/Cause/BadVaddr/Context/...) are
                // meaningless in HLE (librecomp replaces the exception path). Recompile them as
                // reads of a dummy COP0 register file rather than erroring out the whole run.
                print_indent(); generator.emit_cop0_tlb_read((int)reg, rt);
                break;
            }
            break;
        }
    case InstrId::cpu_mtc0:
        {
            Cop0Reg reg = instr.Get_cop0d();
            switch (reg) {
            case Cop0Reg::COP0_Status:
                print_indent();
                generator.emit_cop0_status_write(rt);
                break;
            // TLB (LLE) cop0 registers
            case Cop0Reg::COP0_Index:    print_indent(); generator.emit_cop0_tlb_write(0, rt);  break;
            case Cop0Reg::COP0_Random:   print_indent(); generator.emit_cop0_tlb_write(1, rt);  break;
            case Cop0Reg::COP0_EntryLo0: print_indent(); generator.emit_cop0_tlb_write(2, rt);  break;
            case Cop0Reg::COP0_EntryLo1: print_indent(); generator.emit_cop0_tlb_write(3, rt);  break;
            case Cop0Reg::COP0_PageMask: print_indent(); generator.emit_cop0_tlb_write(5, rt);  break;
            case Cop0Reg::COP0_Wired:    print_indent(); generator.emit_cop0_tlb_write(6, rt);  break;
            case Cop0Reg::COP0_EntryHi:  print_indent(); generator.emit_cop0_tlb_write(10, rt); break;
            default:
                // Generic COP0 write (see mfc0 default above): dummy register file, never errors.
                print_indent(); generator.emit_cop0_tlb_write((int)reg, rt);
                break;
            }
            break;
        }
    // TLB (LLE) instructions
    case InstrId::cpu_tlbwi: print_indent(); generator.emit_tlb_op(0); fmt::print(output_file, "\n"); break;
    case InstrId::cpu_tlbwr: print_indent(); generator.emit_tlb_op(1); fmt::print(output_file, "\n"); break;
    case InstrId::cpu_tlbp:  print_indent(); generator.emit_tlb_op(2); fmt::print(output_file, "\n"); break;
    case InstrId::cpu_tlbr:  print_indent(); generator.emit_tlb_op(3); fmt::print(output_file, "\n"); break;
    // ERET: bare-metal cooperative-scheduler context switch (the "NC class"). A guest `eret` restores a
    // task and resumes it at its saved EPC; recomp_eret performs a fiber switch (librecomp/baremetal_sched.cpp).
    // libultra-HLE games never recompile a guest eret, so this is inert for them. `return` because eret
    // transfers control and never falls through to the following instruction.
    case InstrId::cpu_eret:  print_indent(); fmt::print(output_file, "recomp_eret(rdram, ctx); return;\n"); break;
    // Arithmetic
    case InstrId::cpu_add:
    case InstrId::cpu_addu:
        {
            // Check if this addu belongs to a jump table load
            auto find_result = std::find_if(stats.jump_tables.begin(), stats.jump_tables.end(),
                [instr_vram](const N64Recomp::JumpTable& jtbl) {
                return jtbl.addu_vram == instr_vram;
            });
            // If so, create a temp to preserve the addend register's value
            if (find_result != stats.jump_tables.end()) {
                const N64Recomp::JumpTable& cur_jtbl = *find_result;
                print_indent();
                // One definition per temp per function: see JtblAddendScopes.
                auto defined_it = jtbl_addends.defined_depth.find(cur_jtbl.jr_vram);
                if (defined_it != jtbl_addends.defined_depth.end() && defined_it->second == 0) {
                    generator.emit_jtbl_addend_assignment(cur_jtbl, cur_jtbl.addend_reg);
                }
                else {
                    jtbl_addends.defined_depth[cur_jtbl.jr_vram] = jtbl_addends.depth;
                    generator.emit_jtbl_addend_declaration(cur_jtbl, cur_jtbl.addend_reg);
                }
            }
        }
        break;
    case InstrId::cpu_mult:
    case InstrId::cpu_dmult:
    case InstrId::cpu_multu:
    case InstrId::cpu_dmultu:
    case InstrId::cpu_div:
    case InstrId::cpu_ddiv:
    case InstrId::cpu_divu:
    case InstrId::cpu_ddivu:
        print_indent();
        generator.emit_muldiv(instr_id, rs, rt);
        break;
    // Branches
    case InstrId::cpu_jal:
        // cv64 SESSION 42: VR4300 faithfulness — jal architecturally writes $ra = vram+8 BEFORE the
        // delay slot executes. The C call/return made the write look redundant, but games SHIP code
        // that reads stale $ra-derived stack residue (Castlevania 64's explosive_wall_spot reads an
        // uninitialized stack slot that on hardware always holds a dispatcher return address saved
        // by a callee prologue — zero here froze the game). Maintain $ra exactly like hardware.
        print_indent();
        fmt::print(output_file, "ctx->r31 = (gpr)(int32_t)0x{:08X}U;\n", instr_vram + 8);
        if (!print_func_call_by_address(instr.getBranchVramGeneric())) {
            return false;
        }
        break;
    case InstrId::cpu_jalr:
        // jalr can only be handled with $ra as the return address register. A non-$ra link reg is
        // essentially always data misdecoded as code (real games link through $ra) — emit a nop
        // instead of failing the whole function so real functions with trailing data islands still
        // recompile (the data is never executed). Data-heavy raw-hardware ports rely on this.
        if (rd != (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_ra) {
            break;
        }
        // cv64 SESSION 42: same $ra faithfulness as cpu_jal above.
        print_indent();
        fmt::print(output_file, "ctx->r31 = (gpr)(int32_t)0x{:08X}U;\n", instr_vram + 8);
        needs_link_branch = true;
        print_func_call_by_register(rs);
        break;
    case InstrId::cpu_j:
    case InstrId::cpu_b:
        {
            uint32_t branch_target = instr.getBranchVramGeneric();
            if (branch_target == instr_vram) {
                print_indent();
                generator.emit_pause_self(instr_vram);
            }
            // Check if the branch is within this function
            else if (branch_target >= func.vram && branch_target < func_vram_end) {
                // Cooperative-scheduler fidelity (general, game-agnostic): a BACKWARD unconditional
                // branch within the function is an infinite loop whose back edge has no
                // compiler-visible exit -- the idle/busy-wait shape. On real hardware an interrupt
                // (VI retrace, SP/DP done) preempts the spinner at ANY instruction boundary and the
                // OS scheduler then runs the ready higher-priority thread; the cooperative runtime
                // has no preemption, so without a yield on the back edge the spinner holds the
                // scheduler token forever and starves the interrupt/message pump. Doom 64's idle
                // thread func_8000567C is exactly this: `jal func_8003AC50; b L_800056F0` -> the
                // external SP-done/DP-done/VI-retrace messages are never delivered (they pump only
                // from a game thread's message primitive) -> the gfx thread never wakes -> one frame
                // then black. Hot inner loops (memcpy/rasterizers/audio mix) use CONDITIONAL (bne)
                // back edges and are handled by the guarded conditional path below (~L936), so an
                // unconditional b/j back edge is the right, narrow place for this. Mirror that path:
                // load-only body -> blocking poll guard; otherwise -> NON-BLOCKING yield (delivers
                // pending interrupts + reschedules, no wait), so a finite loop stays byte-identical
                // until the 100k-iteration threshold. The single-instruction self-branch (handled
                // above via emit_pause_self) is unaffected.
                if (is_load_only_poll_loop(func, instructions, instr_index, branch_target)) {
                    print_indent();
                    generator.emit_poll_yield_guard(instr_vram);
                }
                else if (is_calling_poll_loop(func, instructions, instr_index, branch_target)
                         || is_early_out_poll_loop(func, instructions, instr_index, branch_target)) {
                    // The NON-BLOCKING yield for both: an early-out poll may carry a store on its
                    // spin path (the iteration counter), so it is not provably side-effect free the
                    // way the load-only shape is. Delivering interrupts and rescheduling without a
                    // wait is enough to let the thread it is waiting on run.
                    print_indent();
                    generator.emit_calling_poll_yield_guard(func.vram, instr_vram);
                }
                else if (is_branching_load_only_poll_loop(func, instructions, instr_index, branch_target)) {
                    print_indent();
                    generator.emit_calling_poll_yield_guard(func.vram, instr_vram);
                }
                else if (is_unconditional_straightline_spin(func, instructions, instr_index, branch_target)) {
                    // A straight-line unconditional backward branch is a preemption-only infinite spin
                    // (idle/busy-wait). Deliver pending interrupts + reschedule on the back edge.
                    print_indent();
                    generator.emit_calling_poll_yield_guard(func.vram, instr_vram);
                }
                print_goto_with_delay_slot(fmt::format("L_{:08X}", branch_target));
            }
            // This may be a tail call in the middle of the control flow due to a previous check
            // For example:
            // ```c
            // void test() {
            //     if (SOME_CONDITION) {
            //         do_a();
            //     } else {
            //         do_b();
            //     }
            // }
            // ```
            // FIXME: how to deal with static functions?
            else if (context.functions_by_vram.find(branch_target) != context.functions_by_vram.end()) {
                fmt::print("[Info] Tail call in {} to 0x{:08X}\n", func.name, branch_target);
                if (!print_func_call_by_address(branch_target, true)) {
                    return false;
                }
                print_indent();
                generator.emit_return(context, func_index);
            }
            else {
                // GENERAL FIX (sweep 2026-06-15): an unconditional j/b whose target is neither in-function
                // nor a known function start. A hard `return false` here aborts the WHOLE recomp
                // ("Error recompiling recomp_entrypoint, clearing output file") = the single root behind ~11
                // sweep games mislabeled "segment_refine did not converge" (bam2/aidyn/battlezone/vigilante8
                // /vigilante82ndoffen/vrally/wwfwarzone/...).
                // EMPTY-STUB FIX shape B (NC RUN-30/61): same as the conditional-branch site above — the
                // target can be REAL CODE (splat mis-split), so a bare early return silently kills the
                // thread when executed. Tail-call through runtime lookup (live-gap JIT fail-safes on
                // genuine data / KSEG-mirror garbage, and these paths were unreachable-if-data anyway).
                N64Recomp::diag::hit({ .kind = "unconditional-branch-unhandled", .vaddr = instr_vram, .func = func.name, .a = branch_target, .b = func.vram, .section_index = func.section_index });
                fmt::print(stderr, "[Warn] Unhandled branch in {} at 0x{:08X} to 0x{:08X} -> lookup tail-call\n", func.name, instr_vram, branch_target);
                if (!process_delay_slot(true)) {
                    return false;
                }
                if (!generator.speculative_code()) {
                    // static recomp only — the live-gap JIT keeps the bare early-return fail-safe
                    print_indent();
                    generator.emit_function_call_lookup(branch_target);
                }
                print_indent();
                generator.emit_return(context, func_index);
            }
        }
        break;
    case InstrId::cpu_jr:
        {
            // [coswitch] Guest context save/switch (librecomp/src/coswitch.cpp). A jump-table jr is
            // never either (the switch below handles it).
            const bool is_ra_jr = (rs == (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_ra);
            const bool is_switch_jr = (tl_coswitch_func && (tl_coswitch_regs & (1u << rs)) != 0)
                                   || (tl_coswitch_starter && !is_ra_jr && coswitch_is_arg_reg(rs) && (tl_coswitch_regs & (1u << rs)) == 0);
            const bool is_jtbl_jr = std::find_if(stats.jump_tables.begin(), stats.jump_tables.end(),
                [instr_vram](const N64Recomp::JumpTable& jtbl) { return jtbl.jr_vram == instr_vram; }) != stats.jump_tables.end();
            const bool is_save_return = tl_coswitch_saver && tl_coswitch_func && is_ra_jr;   // pure savers: savepoint at the CALL SITE instead
            if (!is_jtbl_jr && (is_switch_jr || is_save_return)) {
                // Delay slot first (a switch routine's delay slot may still touch registers). Then:
                //  * a SAVE function's return carries the SAVEPOINT: a host setjmp in THIS frame, which
                //    a later resume of the saved context longjmps back to (the frame stays live on the
                //    context's fiber). `if (setjmp(...)) { return; }` — the return runs only on resume,
                //    with the registers the resumer's guest code loaded.
                //  * a SWITCH's jr hands the host stack to the entering context's fiber:
                //    `if (recomp_coswitch(...)) { return; }`. When the runtime declines (same context
                //    without a savepoint, bare-metal kernel, unknown block) fall through to the jr's
                //    ORIGINAL action, so a declined hook never changes what used to be emitted.
                if (!process_delay_slot(false)) {
                    return false;
                }
                if (is_save_return) {
                    print_indent();
                    generator.emit_coswitch_savepoint(true);
                }
                if (is_switch_jr) {
                    print_indent();
                    generator.emit_coswitch_jump(rs);
                    if (!is_ra_jr) {
                        print_indent();
                        generator.emit_function_call_by_register(rs);
                    }
                }
                print_indent();
                generator.emit_return(context, func_index);
                print_link_branch();
                break;
            }
        }
        if (rs == (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_ra) {
            print_return_with_delay_slot();
        } else {
            auto jtbl_find_result = std::find_if(stats.jump_tables.begin(), stats.jump_tables.end(),
                [instr_vram](const N64Recomp::JumpTable& jtbl) {
                    return jtbl.jr_vram == instr_vram;
                });

            if (jtbl_find_result != stats.jump_tables.end()) {
                const N64Recomp::JumpTable& cur_jtbl = *jtbl_find_result;
                if (!process_delay_slot(false)) {
                    return false;
                }
                print_indent();
                generator.emit_switch(context, cur_jtbl, rs);
                for (size_t entry_index = 0; entry_index < cur_jtbl.entries.size(); entry_index++) {
                    print_indent();
                    print_indent();
                    generator.emit_case(entry_index, fmt::format("L_{:08X}", cur_jtbl.entries[entry_index]));
                }
                print_indent();
                print_indent();
                generator.emit_switch_error(instr_vram, cur_jtbl.vram);
                print_indent();
                generator.emit_switch_close();
                break;
            }

            fmt::print("[Info] Indirect tail call in {}\n", func.name);
            print_func_call_by_register(rs);
            print_indent();
            generator.emit_return(context, func_index);
            break;
        }
        break;
    case InstrId::cpu_syscall:
        print_indent();
        generator.emit_syscall(instr_vram);
        // syscalls don't link, so treat it like a tail call
        print_indent();
        generator.emit_return(context, func_index);
        break;
    case InstrId::cpu_break:
        {
            // IDO emits `break 7` (divide-by-zero) and `break 6` (overflow, INT_MIN/-1) as SOFTWARE
            // guards right after a div/ddiv (`bne divisor,0,ok / nop / break 7 / ok:`). The VR4300
            // itself NEVER traps on div-by-zero or signed overflow — the div already produced a defined
            // LO/HI, which cpu_div/cpu_ddiv codegen reproduces faithfully. So on hardware-faithful
            // execution the guard break is a no-op. Emitting do_break (which PARKS the thread forever)
            // wrongly halts any game that legitimately reaches a zero/overflow divisor — e.g. DK64's
            // native global_asm at 0x80688050 parked its render thread => 1 gfx frame => black screen.
            // Skip the two IDO div-guard codes so execution falls through to the post-div handling;
            // EVERY other break code (asserts, the bare-metal main-must-not-return guard) still parks.
            // General completion of the div/0 faithfulness fix for IDO-compiled carts (most N64 games).
            // IDO encodes the guard code in the UPPER field: `break 7` = word 0x0007000D (div-by-zero),
            // `break 6` = 0x0006000D (overflow). Read the raw word and extract bits 25:16 directly
            // (getRaw never throws; Get_code_upper() throws when the operand alias is absent, and
            // Get_code() returns the full 20-bit value 7168/6144, not 7/6).
            uint32_t break_code = (instr.getRaw() >> 16) & 0x3FF;
            print_indent();
            if (break_code == 6 || break_code == 7) {
                generator.emit_comment(fmt::format("break {} (IDO div-by-zero/overflow guard) - no-op: VR4300 div never traps", break_code));
            } else {
                generator.emit_do_break(instr_vram);
            }
            break;
        }

    // Cop1 rounding mode
    case InstrId::cpu_ctc1:
        // Only FCR31 (control/status) is meaningful; any other FP control register is data
        // misdecoded as code — skip (nop) instead of failing the function.
        if (cop1_cs != 31) {
            break;
        }
        print_indent();
        generator.emit_cop1_cs_write(rt);
        break;
    case InstrId::cpu_cfc1:
        if (cop1_cs != 31) {
            break;
        }
        print_indent();
        generator.emit_cop1_cs_read(rt);
        break;
    // GENERAL FIX (sweep): conditional moves. movn $rd,$rs,$rt = if($rt!=0) $rd=$rs; movz = if($rt==0).
    // These are common MIPS-IV ops in compiled code; emitting them as nop (the old unhandled path)
    // silently miscompiled the program. *Surfaced: bombhero, courtside2, Re-Volt (class-E recomp).*
    case InstrId::cpu_movn:
        print_indent();
        generator.emit_conditional_move(rd, rs, rt, false);
        break;
    case InstrId::cpu_movz:
        print_indent();
        generator.emit_conditional_move(rd, rs, rt, true);
        break;
    default:
        handled = false;
        break;
    }

    InstructionContext instruction_context{};
    instruction_context.rd = rd;
    instruction_context.rs = rs;
    instruction_context.rt = rt;
    instruction_context.sa = sa;
    instruction_context.fd = fd;
    instruction_context.fs = fs;
    instruction_context.ft = ft;
    instruction_context.cop1_cs = cop1_cs;
    instruction_context.imm16 = imm;
    instruction_context.reloc_tag_as_reference = (reloc_reference_symbol != (size_t)-1) && tag_reference_relocs;
    instruction_context.reloc_type = reloc_type;
    instruction_context.reloc_section_index = reloc_section;
    instruction_context.reloc_target_section_offset = reloc_target_section_offset;

    // LL/SC/CACHE (2026-07-18, the drmario materialization wall): runtime-discovered functions
    // use these, and the unhandled->nop fallback made them silently wrong, which made the
    // data-vs-code veto carve JIT-proven code back to bin. Semantics for THIS engine: one
    // guest thread executes at a time and the scheduler never preempts straight-line guest
    // code between an ll and its sc, so the hardware LLbit would always still be set at the
    // sc -> ll behaves exactly as lw, sc as sw that always reports success. cache is a
    // hardware cache-management hint with nothing to manage here (a SEMANTIC no-op, unlike
    // the unhandled fallback). Same conclusion as the 07-01 WIP bank; implemented fresh,
    // generator-agnostic (both the C and the live generator emit through the op machinery).
    if (instr_id == InstrId::cpu_ll || instr_id == InstrId::cpu_sc ||
        instr_id == InstrId::cpu_lld || instr_id == InstrId::cpu_scd ||
        instr_id == InstrId::cpu_cache) {
        if (instr_id == InstrId::cpu_ll || instr_id == InstrId::cpu_lld) {
            const BinaryOp ll_op{ instr_id == InstrId::cpu_ll ? BinaryOpType::LW : BinaryOpType::LD, Operand::Rt,
                {{ UnaryOpType::None, UnaryOpType::None }, { Operand::Base, Operand::ImmS16 }} };
            print_indent();
            generator.process_binary_op(ll_op, instruction_context);
        }
        else if (instr_id == InstrId::cpu_sc || instr_id == InstrId::cpu_scd) {
            // The store half: a plain sw/sd of rt.
            const StoreOp sc_store{ instr_id == InstrId::cpu_sc ? StoreOpType::SW : StoreOpType::SD, Operand::Rt };
            print_indent();
            generator.process_store_op(sc_store, instruction_context);
            // The success half: rt = $zero + 1 through the normal binary-op machinery so both
            // generators emit it. Reloc state cleared — the sc's imm16 is its address offset.
            InstructionContext sc_success_ctx = instruction_context;
            sc_success_ctx.rs = 0; // $zero
            sc_success_ctx.imm16 = 1;
            sc_success_ctx.reloc_type = N64Recomp::RelocType::R_MIPS_NONE;
            const BinaryOp sc_success{ BinaryOpType::Add64, Operand::Rt,
                {{ UnaryOpType::None, UnaryOpType::None }, { Operand::Rs, Operand::ImmS16 }} };
            print_indent();
            generator.process_binary_op(sc_success, sc_success_ctx);
        }
        else {
            // [icache-ghost 2026-09-03] a cache op is NOT a no-op for this engine: the interpreter syncs
            // the I-cache ghost line on every CACHE (recomp_interp.cpp), but native code dropped it, so a
            // game whose own osInvalICache runs natively never told the ghost its code changed (1080:
            // the game relocates an overlay in place; the ghost kept serving the unlinked bytes).
            print_indent();
            fmt::print(output_file, "recomp_cache_op(rdram, ctx, {}, (uint32_t)({} + {}));\n",
                       (int)instr.GetO32_rt(),
                       (int)instr.GetO32_rs() == 0 ? std::string("0") : fmt::format("ctx->r{}", (int)instr.GetO32_rs()),
                       (int)(int16_t)instr.Get_immediate());
        }
        // Same contract as every handled instruction: close a pending link-branch's after_N
        // label (an ll/sc/cache in a delay slot must not leave a dangling goto).
        if (emit_link_branch) {
            print_indent();
            generator.emit_label(fmt::format("after_{}", link_branch_index));
        }
        return true;
    }
    
    auto do_check_fr = [](const GeneratorType& generator, const InstructionContext& ctx, Operand operand) {
        switch (operand) {
            case Operand::Fd:
            case Operand::FdDouble:
            case Operand::FdU32L:
            case Operand::FdU32H:
            case Operand::FdU64:
                generator.emit_check_fr(ctx.fd);
                break;
            case Operand::Fs:
            case Operand::FsDouble:
            case Operand::FsU32L:
            case Operand::FsU32H:
            case Operand::FsU64:
                generator.emit_check_fr(ctx.fs);
                break;
            case Operand::Ft:
            case Operand::FtDouble:
            case Operand::FtU32L:
            case Operand::FtU32H:
            case Operand::FtU64:
                generator.emit_check_fr(ctx.ft);
                break;
            default:
                // No MIPS3 float check needed for non-float operands.
                break;
        }
    };
    
    auto do_check_nan = [](const GeneratorType& generator, const InstructionContext& ctx, Operand operand) {
        switch (operand) {
            case Operand::Fd:
                generator.emit_check_nan(ctx.fd, false);
                break;
            case Operand::Fs:
                generator.emit_check_nan(ctx.fs, false);
                break;
            case Operand::Ft:
                generator.emit_check_nan(ctx.ft, false);
                break;
            case Operand::FdDouble:
                generator.emit_check_nan(ctx.fd, true);
                break;
            case Operand::FsDouble:
                generator.emit_check_nan(ctx.fs, true);
                break;
            case Operand::FtDouble:
                generator.emit_check_nan(ctx.ft, true);
                break;
            default:
                // No NaN checks needed for non-float operands.
                break;
        }
    };

    auto find_binary_it = binary_ops.find(instr_id);
    if (find_binary_it != binary_ops.end()) {
        print_indent();
        const BinaryOp& op = find_binary_it->second;
        
        if (op.check_fr) {
            do_check_fr(generator, instruction_context, op.output);
            do_check_fr(generator, instruction_context, op.operands.operands[0]);
            do_check_fr(generator, instruction_context, op.operands.operands[1]);
        }

        if (op.check_nan) {
            do_check_nan(generator, instruction_context, op.operands.operands[0]);
            do_check_nan(generator, instruction_context, op.operands.operands[1]);
            fmt::print(output_file, "\n");
            print_indent();
        }

        generator.process_binary_op(op, instruction_context);
        handled = true;
    }

    auto find_unary_it = unary_ops.find(instr_id);
    if (find_unary_it != unary_ops.end()) {
        print_indent();
        const UnaryOp& op = find_unary_it->second;
        
        if (op.check_fr) {
            do_check_fr(generator, instruction_context, op.output);
            do_check_fr(generator, instruction_context, op.input);
        }

        if (op.check_nan) {
            do_check_nan(generator, instruction_context, op.input);
            fmt::print(output_file, "\n");
            print_indent();
        }

        generator.process_unary_op(op, instruction_context);
        handled = true;
    }

    auto find_conditional_branch_it = conditional_branch_ops.find(instr_id);
    if (find_conditional_branch_it != conditional_branch_ops.end()) {
        print_indent();
        // TODO combining the branch condition and branch target into one generator call would allow better optimization in the runtime's JIT generator.
        // This would require splitting into a conditional jump method and conditional function call method.
        generator.emit_branch_condition(find_conditional_branch_it->second, instruction_context);
        jtbl_addends.depth++; // the branch body is a new C scope (its delay slot is emitted inside it)

        print_indent();
        if (find_conditional_branch_it->second.link) {
            if (!print_func_call_by_address(instr.getBranchVramGeneric())) {
                return false;
            }
        }
        else {
            uint32_t cond_branch_target = (uint32_t)instr.getBranchVramGeneric();
            // Load-only poll loop: emit the cooperative yield guard on the taken back edge
            // (inside the if-body, before the delay slot + goto). See is_load_only_poll_loop.
            if (is_load_only_poll_loop(func, instructions, instr_index, cond_branch_target)) {
                print_indent();
                print_indent();
                generator.emit_poll_yield_guard(instr_vram);
            }
            else if (is_calling_poll_loop(func, instructions, instr_index, cond_branch_target)
                     || is_early_out_poll_loop(func, instructions, instr_index, cond_branch_target)) {
                print_indent();
                print_indent();
                generator.emit_calling_poll_yield_guard(func.vram, instr_vram);
            }
            else if (is_branching_load_only_poll_loop(func, instructions, instr_index, cond_branch_target)) {
                print_indent();
                print_indent();
                generator.emit_calling_poll_yield_guard(func.vram, instr_vram);
            }
            if (!print_branch(cond_branch_target)) {
                return false;
            }
        }

        print_indent();
        generator.emit_branch_close();
        jtbl_addends.depth--;
        
        is_branch_likely = find_conditional_branch_it->second.likely;
        handled = true;
    }

    auto find_store_it = store_ops.find(instr_id);
    if (find_store_it != store_ops.end()) {
        print_indent();
        const StoreOp& op = find_store_it->second;

        if (op.type == StoreOpType::SDC1) {
            do_check_fr(generator, instruction_context, op.value_input);
        }

        generator.process_store_op(op, instruction_context);
        handled = true;
    }

    // [coswitch] context-block captures: the base register of a `sw $sp` / `lw $sp` off a non-frame
    // base IS the context block (setjmp buffer / process context). Captured right after the
    // instruction, in the emitted function's own locals, for the savepoint / switch hooks at its jr.
    if (handled && tl_coswitch_starter && coswitch_alu_writes_sp(instr)) {
        // the block of a started context is its stack: read $sp back AFTER the write
        print_indent();
        generator.emit_coswitch_capture((int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_sp, false);
    }
    if (handled && (tl_coswitch_saver || tl_coswitch_func)) {
        const int cs_sp = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_sp;
        const int cs_fp = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_fp;
        const int cs_base = (int)instr.GetO32_rs();
        const int cs_rt = (int)instr.GetO32_rt();
        if (cs_rt == cs_sp && cs_base != cs_sp && cs_base != cs_fp) {
            if (tl_coswitch_saver && tl_coswitch_func && (instr_id == InstrId::cpu_sw || instr_id == InstrId::cpu_sd)) {
                print_indent();
                generator.emit_coswitch_capture(cs_base, true);
            }
            // A pure saver that calls after this store hosts its OWN savepoint, right here: the
            // guest's context block is now written, and the call that follows switches away and
            // never comes back through a C return. On resume the savepoint returns from this
            // function, landing the guest at the $ra its caller pushed -- the resume pc the
            // switch is trying to reach.
            if (tl_coswitch_self_save && (instr_id == InstrId::cpu_sw || instr_id == InstrId::cpu_sd)) {
                print_indent();
                generator.emit_coswitch_capture(cs_base, true);
                print_indent();
                generator.emit_coswitch_savepoint(true);
            }
            if (tl_coswitch_func && (instr_id == InstrId::cpu_lw || instr_id == InstrId::cpu_ld)) {
                print_indent();
                generator.emit_coswitch_capture(cs_base, false);
            }
        }
    }

    if (!handled) {
        // Non-fatal: emit a nop (a comment) + warn, instead of aborting the ENTIRE recompilation.
        // A single unhandled opcode -- a benign `sync` memory barrier, or data misread as code in a
        // severed-function tail we extended -- should not kill the whole output. It just leaves that
        // one instruction as a no-op. (General robustness: the baseline hits zero of these.)
        N64Recomp::diag::hit({ .kind = "unhandled-opcode", .vaddr = instr_vram, .func = func.name, .detail = instr.getOpcodeName(), .section_index = func.section_index, .func_index = (uint32_t)func_index });
        fmt::print(stderr, "Unhandled instruction (emitting nop): {}\n", instr.getOpcodeName());
        print_indent();
        fmt::print(output_file, "// unhandled {} -> nop\n", instr.getOpcodeName());
        // GENERAL FIX (sweep): a pending link-branch already emitted `goto after_N` (this instruction is its
        // delay slot). We MUST still emit the matching `after_N:` label or the C won't compile (dangling goto).
        // Surfaced by branch-likely data statics whose delay slot is an INVALID word: e.g. courtside2
        // static_138_800FA40C (`bltzall` -> runtime LOOKUP_FUNC -> `goto after_0`, but the next op is INVALID,
        // so the early return below skipped `after_0:`). Without this the function recompiles but won't build.
        if (emit_link_branch) {
            print_indent();
            generator.emit_label(fmt::format("after_{}", link_branch_index));
        }
        return true;
    }

    // TODO is this used?
    if (emit_link_branch) {
        print_indent();
        generator.emit_label(fmt::format("after_{}", link_branch_index));
    }

    return true;
}

template <typename GeneratorType>
bool recompile_function_impl(GeneratorType& generator, const N64Recomp::Context& context, size_t func_index, std::ostream& output_file, std::span<std::vector<uint32_t>> static_funcs_out, bool tag_reference_relocs) {
    const N64Recomp::Function& func = context.functions[func_index];
    //fmt::print("Recompiling {}\n", func.name);
    std::vector<rabbitizer::InstructionCpu> instructions;

    generator.emit_function_start(func.name, func_index);

    if (context.trace_mode) {
        fmt::print(output_file,
            "    TRACE_ENTRY()\n",
            func.name);
    }

    // GAP-DISPATCH STUB (empty-static-stub class, NC RUN-30): an auto-created static_ whose words
    // failed to recompile used to become an EMPTY body — a silent no-op. When the target is real code
    // (a cross-function branch to a non-entry address, e.g. a splat mis-split loop head), the caller
    // tail-calls the stub and falls off its entry function = silent thread death. Emit a live-gap
    // dispatch instead (same shape as the analyze-fail path below): the trampoline JITs the CURRENT
    // RDRAM bytes at this vram with the same codegen as static recomp, preserving register state via
    // ctx, and returns to the caller. Fail-safe on genuine data (gap_function_length==0 -> no-op,
    // identical to the old empty stub). C generator only — the live generator never sets this flag.
    if (func.gap_dispatch) {
        fmt::print(output_file, "    recomp_live_gap_set_target(0x{:08X}u);\n", func.vram);
        fmt::print(output_file, "    recomp_live_gap_trampoline(rdram, ctx);\n");
        generator.emit_function_end();
        return true;
    }

    // Skip analysis and recompilation of this function is stubbed.
    if (!func.stubbed) {
        // Use a set to sort and deduplicate labels
        std::set<uint32_t> branch_labels;
        instructions.reserve(func.words.size());

        auto hook_find = func.function_hooks.find(-1);
        if (hook_find != func.function_hooks.end()) {
            fmt::print(output_file, "    {}\n", hook_find->second);
        }

        // First pass, disassemble each instruction and collect branch labels
        uint32_t vram = func.vram;
        for (uint32_t word : func.words) {
            const auto& instr = instructions.emplace_back(byteswap(word), vram);

            // If this is a branch or a direct jump, add it to the local label list
            if (instr.isBranch() || instr.getUniqueId() == rabbitizer::InstrId::UniqueId::cpu_j) {
                branch_labels.insert((uint32_t)instr.getBranchVramGeneric());
            }

            // Advance the vram address by the size of one instruction
            vram += 4;
        }

        // [coswitch] Does this function load (and store) $sp from memory? See tl_coswitch_func.
        tl_coswitch_func = false;
        tl_coswitch_saver = false;
        tl_coswitch_caller = false;
        tl_coswitch_regs = 0;
        tl_coswitch_starter = false;
        tl_coswitch_self_save = false;
        coswitch_classify(context);
        {
            using InstrIdCs = rabbitizer::InstrId::UniqueId;
            const int sp_reg = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_sp;
            const int fp_reg = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_fp;
            const int ra_reg = (int)rabbitizer::Registers::Cpu::GprO32::GPR_O32_ra;
            bool loads_sp = false;
            bool jr_on_loaded = false;
            bool sp_from_arg = false;   // starter half 1: $sp written from a non-frame, non-loaded register
            bool jr_on_arg = false;     // starter half 2: a later jr through an argument register
            // self-save halves, computed HERE rather than from the pre-pass because the pre-pass's
            // per-function extents can differ from what is actually being emitted (chopper: the
            // severed/static copies of the kernel are absent from the class map entirely).
            bool cs_saw_save = false; int cs_save_count = 0; bool cs_then_calls = false; int cs_spill_count = 0; bool cs_bad_store = false;
            for (const auto& ins : instructions) {
                const InstrIdCs id = ins.getUniqueId();
                if (id == InstrIdCs::cpu_jal && coswitch_is_pure_saver((uint32_t)ins.getBranchVramGeneric())) {
                    tl_coswitch_caller = true;
                }
                if (cs_saw_save && (id == InstrIdCs::cpu_jal || id == InstrIdCs::cpu_jalr)) {
                    cs_then_calls = true;
                }
                // How much machine state does this function spill INTO ITS OWN FRAME? A context-save
                // routine spills the whole register file (chopper's saves $a0-$a3, $s0-$s7, $gp,
                // $fp, $ra and all 32 FPRs = 48 frame stores). This also rejects data misread as
                // code in a severed tail, which stores to scattered random bases rather than $sp:
                // SOTE's func_8000C68C decodes `.word INVALID`, `ll`, `pref`, `sd $sp,0x4519($t7)`.
                if ((id == InstrIdCs::cpu_sw || id == InstrIdCs::cpu_sd
                     || id == InstrIdCs::cpu_swc1 || id == InstrIdCs::cpu_sdc1)
                    && (int)ins.GetO32_rs() == sp_reg) {
                    cs_spill_count++;
                }
                if (coswitch_alu_writes_sp(ins) && (tl_coswitch_regs & (1u << (int)ins.GetO32_rs())) == 0) {
                    sp_from_arg = true;
                }
                if (id == InstrIdCs::cpu_jr) {
                    const int jrs = (int)ins.GetO32_rs();
                    if (sp_from_arg && jrs != ra_reg && coswitch_is_arg_reg(jrs) && (tl_coswitch_regs & (1u << jrs)) == 0) {
                        jr_on_arg = true;
                    }
                    // The switch idiom proper: the jump register was itself loaded off a non-frame
                    // base (the entering context's saved PC). A `jr $ra` whose $ra came back from
                    // the stack is an ordinary return even inside a function that touched $sp.
                    if (tl_coswitch_regs & (1u << (int)ins.GetO32_rs())) {
                        jr_on_loaded = true;
                    }
                    continue;
                }
                // A context block is never addressed off the CURRENT frame: a load/store whose base
                // is $sp or $fp is ordinary prologue/epilogue traffic (SOTE's compiler reloads $sp
                // from its own frame in ~1370 functions, and data misread as code decodes to
                // anything), not a switch.
                const int base = (int)ins.GetO32_rs();
                if (base == sp_reg || base == fp_reg) {
                    // [coswitch 2026-09-03, chopper] After this function has loaded $sp from a context block
                    // (loads_sp), a load off the NEW $sp is the switch's resume register off the NEW $sp frame
                    // (Seta kernel: lw $sp,8($t2); lw $t9,0x3C($sp); jr $t9). Before that point $sp/$fp traffic
                    // is ordinary prologue/epilogue (SOTE's ~1370 frame reloads keep loads_sp false); a $ra
                    // loaded off the new frame stays an ordinary return.
                    const bool resume_load = loads_sp && base == sp_reg
                                          && (id == InstrIdCs::cpu_lw || id == InstrIdCs::cpu_ld)
                                          && (int)ins.GetO32_rt() != ra_reg && (int)ins.GetO32_rt() != sp_reg;
                    if (!resume_load) {
                        continue;
                    }
                }
                if (id == InstrIdCs::cpu_lw || id == InstrIdCs::cpu_ld) {
                    const int rt = (int)ins.GetO32_rt();
                    if (rt == sp_reg) {
                        loads_sp = true;
                    }
                    tl_coswitch_regs |= (1u << rt);
                }
                if ((id == InstrIdCs::cpu_sw || id == InstrIdCs::cpu_sd) && (int)ins.GetO32_rt() == sp_reg) {
                    tl_coswitch_saver = true;
                    // o32 keeps the stack pointer in 32 bits, so a context block is written with
                    // `sw`. An `sd $sp` is data misread as code (SOTE's two remaining severed
                    // tails: `sd $sp,0x4519($t7)`, `sd $sp,0x5000($ra)`), never a context save.
                    if (id == InstrIdCs::cpu_sw) { cs_saw_save = true; cs_save_count++; }
                    else { cs_bad_store = true; }
                }
            }
            tl_coswitch_func = loads_sp && jr_on_loaded;
            tl_coswitch_starter = sp_from_arg && jr_on_arg && !tl_coswitch_func;
            // A PURE saver that CALLS after its `sw $sp` never returns to its caller at the save
            // point -- the callee switches away from inside it -- so a savepoint emitted after the
            // C call would be registered too late to ever exist. Host it in this frame instead.
            // Exactly ONE such store: a context saver has one block, while ordinary code that
            // merely stores the stack pointer writes several different bases (SOTE's func_8002DAAC
            // has four) and is not a context save at all. And the call after the store must be a
            // direct jal to a SWITCHER -- that is what makes the store a context save rather than
            // incidental traffic. Without this, the rule fires all over SOTE (24 of 75 files) and
            // SOTE crashes 0xC0000005 reading 0x0, because an early savepoint's resume `return`s
            // out of an ordinary function.
            tl_coswitch_self_save = tl_coswitch_saver && !tl_coswitch_func && cs_then_calls
                                 && cs_save_count == 1 && cs_spill_count >= 16 && !cs_bad_store;
            (void)coswitch_is_switch_slot; (void)coswitch_is_switcher;
            if (tl_coswitch_func || tl_coswitch_saver || tl_coswitch_caller || tl_coswitch_starter) {
                fmt::print("[coswitch] {} (vram=0x{:08X} self_save={}): {}{}{}{}\n", func.name, func.vram, tl_coswitch_self_save ? 1 : 0,
                    tl_coswitch_saver ? (tl_coswitch_func ? "saves a context " : "PURE saver (savepoints at its call sites) ") : "",
                    tl_coswitch_func ? "switches (loads $sp off a non-frame base, jr through a loaded register) " : "",
                    tl_coswitch_caller ? "calls a pure saver " : "",
                    tl_coswitch_starter ? "STARTS a context (writes $sp from an argument, jr through an argument: fresh fiber)" : "");
                // a pure saver captures nothing itself; a saver+switcher captures its save block; a caller
                // of a pure saver captures the callee's block at the call site; a starter captures the new $sp.
                generator.emit_coswitch_prologue((tl_coswitch_saver && tl_coswitch_func) || tl_coswitch_caller || tl_coswitch_self_save, tl_coswitch_func || tl_coswitch_starter);
            }
        }

        // Analyze function
        N64Recomp::FunctionStats stats{};
        if (!N64Recomp::analyze_function(context, func, instructions, stats)) {
            // GENERAL FIX (sweep, class-C sub-case B): an unanalyzable function — invalid opcodes, i.e. data
            // misread as code, typically an auto-created static_ at a data jal-target — used to abort the
            // WHOLE recomp, and a static has no toml entry so recomp_autostub can't catch it. emit_function_start
            // already wrote the signature, locals, and '{', so close it as an empty stub and continue: a data
            // target is never genuinely executed as code, and the caller still links. (Companion to the
            // static forward-branch sizing fix in main.cpp.)
            N64Recomp::diag::hit({ .kind = "function-unanalyzable", .vaddr = func.vram, .func = func.name, .a = func.vram, .b = (uint32_t)func.words.size(), .section_index = func.section_index, .func_index = (uint32_t)func_index });
            // RUNTIME-LOADED CODE (Blast Corps & any decompress/overlay title): an "unanalyzable" function is
            // NOT always genuine data. Some are real functions whose CODE is decompressed/loaded into RDRAM at
            // runtime — the STATIC ROM holds a data table/placeholder there, so analysis (correctly) sees
            // invalid opcodes. An empty stub makes such a function a silent no-op (e.g. Blast Corps' main-thread
            // entry func_80244930 -> never creates the VI manager -> black screen). Instead, dispatch to the
            // live-gap JIT: at call time it fetches the CURRENT RDRAM bytes at this vram, self-sizes, and JITs
            // them with the SAME codegen as static recomp. Fail-safe for genuine data: gap_function_length
            // returns 0 and the trampoline is a no-op, exactly like the old empty stub. (General fix — helps any
            // title that loads code into a region the static ROM stores as data.)
            // LIVE GENERATOR (the 29-byte silent-no-op class, diagnosed 2026-07-18): the C-text
            // dispatch below goes to output_file, which the live path feeds a DUMMY ostream — the
            // text vanishes and sljit finishes an EMPTY body (~29 bytes) reported as success. The
            // runtime then calls a function that does NOTHING: the JIT-on-default 07-15 regression
            // (41 RENDERS->BLACK silent no-ops + downstream wild-state crashes). An unanalyzable
            // SPECULATIVE function must instead FAIL the JIT: recomp_live_gap's trampoline already
            // falls back to the faithful interpreter for real code and no-ops genuine data.
            if (generator.speculative_code()) {
                fmt::print(stderr, "[analyze-stub] {} unanalyzable under LIVE JIT -> fail (interpreter fallback)\n", func.name);
                return false;
            }
            fmt::print(stderr, "[analyze-stub] {} unanalyzable (data?) -> live-gap dispatch (runtime-loaded code)\n", func.name);
            fmt::print(output_file, "    recomp_live_gap_set_target(0x{:08X}u);\n", func.vram);
            fmt::print(output_file, "    recomp_live_gap_trampoline(rdram, ctx);\n");
            generator.emit_function_end();
            return true;
        }

        std::unordered_set<uint32_t> jtbl_lw_instructions{};
        JtblAddendScopes jtbl_addends{};

        // Add jump table labels into function
        for (const auto& jtbl : stats.jump_tables) {
            jtbl_lw_instructions.insert(jtbl.lw_vram);
            for (uint32_t jtbl_entry : jtbl.entries) {
                branch_labels.insert(jtbl_entry);
            }
        }

        // Second pass, emit code for each instruction and emit labels
        auto cur_label = branch_labels.cbegin();
        vram = func.vram;
        int num_link_branches = 0;
        int num_likely_branches = 0;
        bool needs_link_branch = false;
        bool in_likely_delay_slot = false;
        const auto& section = context.sections[func.section_index];
        size_t reloc_index = 0;
        for (size_t instr_index = 0; instr_index < instructions.size(); ++instr_index) {
            bool had_link_branch = needs_link_branch;
            bool is_branch_likely = false;
            // If we're in the delay slot of a likely instruction, emit a goto to skip the instruction before any labels
            if (in_likely_delay_slot) {
                generator.emit_goto(fmt::format("skip_{}", num_likely_branches));
            }
            // If there are any other branch labels to insert and we're at the next one, insert it
            if (cur_label != branch_labels.end() && vram >= *cur_label) {
                generator.emit_label(fmt::format("L_{:08X}", *cur_label));
                ++cur_label;
            }

            // Advance the reloc index until we reach the last one or until we get to/pass the current instruction
            while ((reloc_index + 1) < section.relocs.size() && section.relocs[reloc_index].address < vram) {
                reloc_index++;
            }

            // Process the current instruction and check for errors
            if (process_instruction(generator, context, func, func_index, stats, jtbl_lw_instructions, jtbl_addends, instr_index, instructions, output_file, false, needs_link_branch, num_link_branches, reloc_index, needs_link_branch, is_branch_likely, tag_reference_relocs, static_funcs_out) == false) {
                fmt::print(stderr, "Error in recompiling {}, clearing output file\n", func.name);
                output_file.clear();
                return false;
            }
            // If a link return branch was generated, advance the number of link return branches
            if (had_link_branch) {
                num_link_branches++;
            }
            // Now that the instruction has been processed, emit a skip label for the likely branch if needed
            if (in_likely_delay_slot) {
                fmt::print(output_file, "    ");
                generator.emit_label(fmt::format("skip_{}", num_likely_branches));
                num_likely_branches++;
            }
            // Mark the next instruction as being in a likely delay slot if the 
            in_likely_delay_slot = is_branch_likely;
            // Advance the vram address by the size of one instruction
            vram += 4;
        }
        // GENERAL FIX (sweep): if the function's LAST instruction was a jal/call it set needs_link_branch and
        // emitted `goto after_N`, but no following instruction remained to emit the matching `after_N:` label
        // (e.g. recomp_entrypoint ends right on a jal, its delay slot outside the dummy-sized function). Emit
        // the label here so the goto resolves — else a C2094 dangling label, fatal for the entrypoint (which
        // has no toml entry to stub). Companion to the print_branch out-of-function fix.
        if (needs_link_branch) {
            generator.emit_label(fmt::format("after_{}", num_link_branches));
        }

        // FALL-THROUGH FIX (general): a handwritten code blob that symbol-splitting / spimdisasm carved into
        // ADJACENT functions leaves a function whose execution implicitly FALLS THROUGH into the next function
        // (its final real instruction is a plain op, not an unconditional jump/return/eret). The recompiler emits
        // tail calls only for out-of-function JUMPS, so without this the fall-through edge is silently dropped and
        // the function just returns — e.g. Nightmare Creatures' exception handler, split at internal labels by
        // pinning it native, returned before reaching its MI-dispatch. Conservatively: only when the LAST TWO
        // instructions are both plain (no delay slot => not a branch/jump) and the last is not an eret — a
        // function that cannot terminate on its own — and the next vram is a known function, emit a fall-through
        // tail call into it. This never touches branch/jump-terminated functions, so baseline output is unchanged.
        {
            size_t _n = instructions.size();
            if (_n >= 1) {
                const auto& _last = instructions[_n - 1];
                // A single-instruction function (e.g. DK64 cos: `addiu $a0,$a0,0x400` then falls into sin)
                // has no preceding instruction; only a >=2-instruction function can end with a branch+delay
                // slot that already terminated it, so the delay-slot-owner guard only applies then.
                // The owner must be asked WHICH transfer it is, not merely that it owns the slot: anything
                // that links (jal/jalr/bgezal/bltzal) RETURNS to pc+8, and a conditional branch's not-taken
                // path continues — both leave the function still falling through past its last word. Only an
                // unconditional, non-linking transfer (j, b, jr — return or tail dispatch) terminates it.
                // Treating every delay-slot owner as a terminator dropped the fall-through edge on every
                // function ending `jal X` + slot (2,509 across the corpus, TRUNCATED_FUNC_SCAN_20260806;
                // proof case fifa func_800BE1A0: epilogue carved off as func_800BE290, callers returned
                // with sp off by 0x28 and s0/s1/ra clobbered).
                bool _prev_terminates = false;
                if (_n >= 2) {
                    const auto& _prev = instructions[_n - 2];
                    if (_prev.hasDelaySlot() && !_prev.doesLink()) {
                        rabbitizer::InstrId::UniqueId _prev_id = _prev.getUniqueId();
                        _prev_terminates = _prev_id == rabbitizer::InstrId::UniqueId::cpu_j
                                        || _prev_id == rabbitizer::InstrId::UniqueId::cpu_jr
                                        || _prev.isUnconditionalBranch();
                    }
                }
                bool _falls_through = !_last.hasDelaySlot() && !_prev_terminates
                                      && _last.getUniqueId() != rabbitizer::InstrId::UniqueId::cpu_eret;
                if (_falls_through) {
                    uint32_t next_vram = func.vram + (uint32_t)(instructions.size() * 4);
                    auto _ftit = context.functions_by_vram.find(next_vram);
                    if (next_vram != 0 && _ftit != context.functions_by_vram.end() && !_ftit->second.empty()) {
                        const auto& _tfunc = context.functions[_ftit->second[0]];
                        const std::string& _tname = _tfunc.name;
                        // Only fall through into a REAL defined CODE function — never a label (L_), data label
                        // (D_), included binary blob (_binary_*), or any symbol with no instruction body. Such a
                        // target sits in functions_by_vram but is emitted as data, not a callable function, so a
                        // call to it would be an unresolved-external / type link error (a func abutting a data
                        // blob genuinely ends there — drop the edge). The words.empty() guard catches any other
                        // data-section symbol the name prefixes miss.
                        if (!_tname.empty() && !_tfunc.words.empty()
                            && _tname.rfind("L_", 0) != 0 && _tname.rfind("D_", 0) != 0
                            && _tname.rfind("_binary_", 0) != 0) {
                            fmt::print("Fall-through tail call in {} to {} (0x{:08X})\n", func.name, _tname, next_vram);
                            fmt::print(output_file, "    ");
                            generator.emit_function_call(context, _ftit->second[0]);
                        }
                    }
                    else if (func.name.rfind("static_", 0) == 0) {
                        // A STATIC whose body falls through past its last word with NO function at the next
                        // vram was mis-sized (its true extent runs on). Falling off the C function silently
                        // returns to the caller mid-body — the silent-thread-death class. Continue execution
                        // at the fall-off vram through the live-gap trampoline instead (same net as the
                        // gap-dispatch stub): the JIT resumes from the CURRENT RDRAM bytes with full register
                        // state in ctx. Statics exist only in the static C recomp, so this raw-C emission
                        // never runs under the live/mod generators.
                        fmt::print("Fall-through continuation in {} to unmapped 0x{:08X} -> live-gap dispatch\n", func.name, next_vram);
                        fmt::print(output_file, "    recomp_live_gap_set_target(0x{:08X}u);\n", next_vram);
                        fmt::print(output_file, "    recomp_live_gap_trampoline(rdram, ctx);\n");
                    }
                }
            }
        }
    }

    // Terminate the function
    generator.emit_function_end();
    
    return true;
}

// Wrap the templated function with CGenerator as the template parameter.
bool N64Recomp::recompile_function(const N64Recomp::Context& context, size_t function_index, std::ostream& output_file, std::span<std::vector<uint32_t>> static_funcs_out, bool tag_reference_relocs) {
    // Emit into a local buffer and commit only on success. A mid-emission failure (e.g. the
    // delay-slot depth cap firing on data-as-code) used to leave a TORN function body — an
    // unclosed `if {` — in the shared batched output file ("clearing output file" at the error
    // site only resets the stream's iostate), and error-continue then appended the NEXT function
    // inside the open braces: uncompilable C with the failure correctly reported but the file
    // still poisoned (drmario fleet gate, 2026-07-19). Failure now leaves no trace in the output.
    std::ostringstream function_buffer;
    CGenerator generator{function_buffer};
    bool result = recompile_function_impl(generator, context, function_index, function_buffer, static_funcs_out, tag_reference_relocs);
    if (result) {
        output_file << function_buffer.str();
    }
    return result;
}

bool N64Recomp::recompile_function_custom(Generator& generator, const Context& context, size_t function_index, std::ostream& output_file, std::span<std::vector<uint32_t>> static_funcs_out, bool tag_reference_relocs) {
    return recompile_function_impl(generator, context, function_index, output_file, static_funcs_out, tag_reference_relocs);
}
