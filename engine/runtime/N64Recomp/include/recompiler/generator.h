#ifndef __GENERATOR_H__
#define __GENERATOR_H__

#include "recompiler/context.h"
#include "operations.h"

namespace N64Recomp {
    struct InstructionContext {
        int rd;
        int rs;
        int rt;
        int sa;

        int fd;
        int fs;
        int ft;

        int cop1_cs;

        uint16_t imm16;

        bool reloc_tag_as_reference;
        RelocType reloc_type;
        uint32_t reloc_section_index;
        uint32_t reloc_target_section_offset;
    };

    class Generator {
    public:
        // True when this generator compiles SPECULATIVE code — bytes at a runtime-jumped address that
        // were never statically identified as a function (the live-gap JIT). Branch-out-of-function
        // there is usually garbage decode, so the emitter must keep the early-return fail-safe instead
        // of chaining through runtime lookup (the empty-stub shape-B fix applies to static recomp only;
        // chaining speculative garbage produced wild stores — Perfect Dark boot crash, 2026-07-03).
        virtual bool speculative_code() const { return false; }
        virtual void process_binary_op(const BinaryOp& op, const InstructionContext& ctx) const = 0;
        virtual void process_unary_op(const UnaryOp& op, const InstructionContext& ctx) const = 0;
        virtual void process_store_op(const StoreOp& op, const InstructionContext& ctx) const = 0;
        virtual void emit_function_start(const std::string& function_name, size_t func_index) const = 0;
        virtual void emit_function_end() const = 0;
        virtual void emit_function_call_lookup(uint32_t addr) const = 0;
        virtual void emit_function_call_by_register(int reg) const = 0;
        // target_section_offset can each be deduced from symbol_index if the full context is available,
        // but for live recompilation the reference symbol list is unavailable so it's still provided.
        virtual void emit_function_call_reference_symbol(const Context& context, uint16_t section_index, size_t symbol_index, uint32_t target_section_offset) const = 0;
        virtual void emit_function_call(const Context& context, size_t function_index) const = 0;
        virtual void emit_named_function_call(const std::string& function_name) const = 0;
        virtual void emit_goto(const std::string& target) const = 0;
        virtual void emit_label(const std::string& label_name) const = 0;
        virtual void emit_jtbl_addend_declaration(const JumpTable& jtbl, int reg) const = 0;
        // GENERAL FIX (sweep, Wipeout 64): a jump-table addend temp is DEFINED at its `addu` and read at
        // the `jr`'s switch. Every delay-slot instruction is emitted twice (once on the branch-taken path,
        // once at its in-order position so anything branching to it still runs it), so an `addu` that sits
        // in a delay slot defined the same temp twice in one scope (MSVC C2374, the emission cannot build).
        // The recompiler calls this instead of the declaration for every later emission whose definition is
        // already in scope. Default = the declaration, so a generator with no declaration/assignment
        // distinction (the live JIT, whose declaration is a no-op) keeps its exact previous behavior.
        virtual void emit_jtbl_addend_assignment(const JumpTable& jtbl, int reg) const { emit_jtbl_addend_declaration(jtbl, reg); }
        virtual void emit_branch_condition(const ConditionalBranchOp& op, const InstructionContext& ctx) const = 0;
        virtual void emit_branch_close() const = 0;
        virtual void emit_switch(const Context& recompiler_context, const JumpTable& jtbl, int reg) const = 0;
        virtual void emit_case(int case_index, const std::string& target_label) const = 0;
        virtual void emit_switch_error(uint32_t instr_vram, uint32_t jtbl_vram) const = 0;
        virtual void emit_switch_close() const = 0;
        virtual void emit_return(const Context& context, size_t func_index) const = 0;
        virtual void emit_check_fr(int fpr) const = 0;
        virtual void emit_check_nan(int fpr, bool is_double) const = 0;
        virtual void emit_cop0_status_read(int reg) const = 0;
        virtual void emit_cop0_status_write(int reg) const = 0;
        // TLB (LLE). Non-pure defaults so generators that don't support TLB ops
        // (e.g. the live recompiler used for runtime mods) inherit a no-op.
        virtual void emit_cop0_tlb_read(int cop0_reg, int dest_gpr) const { (void)cop0_reg; (void)dest_gpr; }
        virtual void emit_cop0_tlb_write(int cop0_reg, int src_gpr) const { (void)cop0_reg; (void)src_gpr; }
        virtual void emit_tlb_op(int op) const { (void)op; } // 0=tlbwi 1=tlbwr 2=tlbp 3=tlbr
        virtual void emit_cop1_cs_read(int reg) const = 0;
        virtual void emit_cop1_cs_write(int reg) const = 0;
        // Conditional move: movn (eq_zero=false) = if($rt!=0) $rd=$rs; movz (eq_zero=true) = if($rt==0).
        // Non-pure no-op default so the live recompiler inherits it (same pattern as the TLB ops above).
        virtual void emit_conditional_move(int rd, int rs, int rt, bool eq_zero) const { (void)rd; (void)rs; (void)rt; (void)eq_zero; }
        virtual void emit_muldiv(InstrId instr_id, int reg1, int reg2) const = 0;
        virtual void emit_syscall(uint32_t instr_vram) const = 0;
        virtual void emit_do_break(uint32_t instr_vram) const = 0;
        virtual void emit_pause_self(uint32_t pc_vram) const = 0;
        // SM64PC S45 (engine, game-agnostic): emitted on the taken back edge of a detected
        // load-only memory-poll loop (see is_load_only_poll_loop in recompilation.cpp). On
        // hardware such loops exit when an interrupt-driven thread changes the polled value;
        // recompiled threads are cooperative, so the spinner must yield or it starves the whole
        // scheduler. Non-pure default no-op so the live recompiler is unaffected.
        virtual void emit_poll_yield_guard(uint32_t pc_vram) const { (void)pc_vram; }
        // Same cooperative-yield guard for a CALLING poll-loop (body = a single function call +
        // backward branch — the work-list-drain idiom the load-only guard misses). Uses the
        // non-blocking yield so a real >100k-iteration calling work loop is unaffected.
        virtual void emit_calling_poll_yield_guard(uint32_t func_vram, uint32_t pc_vram) const { (void)func_vram; (void)pc_vram; }
        // 2026-09-01 guest coroutine switch (coswitch.cpp): a function that LOADS $sp from memory is a
        // context switch; its `jr` becomes a runtime fiber switch instead of a C return. Default no-op:
        // the live/JIT generator keeps the plain return.
        virtual void emit_coswitch_prologue(bool saver, bool switcher) const { (void)saver; (void)switcher; }
        virtual void emit_coswitch_capture(int base_reg, bool save) const { (void)base_reg; (void)save; }
        // 2026-09-03 (MK4): a pure saver whose block base is materialized INSIDE the saver from an
        // immediate (lui/addiu of a fixed address) has no meaningful value in that register at its
        // call site. Capture the constant instead of the stale caller register.
        virtual void emit_coswitch_capture_const(uint32_t block, bool save) const { (void)block; (void)save; }
        virtual void emit_coswitch_savepoint(bool return_on_resume) const { (void)return_on_resume; }
        virtual void emit_coswitch_jump(int reg) const { (void)reg; }
        virtual void emit_trigger_event(uint32_t event_index) const = 0;
        virtual void emit_comment(const std::string& comment) const = 0;
    };

    class CGenerator final : Generator {
    public:
        CGenerator(std::ostream& output_file) : output_file(output_file) {};
        // Public re-expose (the base is privately inherited): static recomp is never speculative.
        bool speculative_code() const final { return false; }
        void process_binary_op(const BinaryOp& op, const InstructionContext& ctx) const final;
        void process_unary_op(const UnaryOp& op, const InstructionContext& ctx) const final;
        void process_store_op(const StoreOp& op, const InstructionContext& ctx) const final;
        void emit_function_start(const std::string& function_name, size_t func_index) const final;
        void emit_function_end() const final;
        void emit_function_call_lookup(uint32_t addr) const final;
        void emit_function_call_by_register(int reg) const final;
        void emit_function_call_reference_symbol(const Context& context, uint16_t section_index, size_t symbol_index, uint32_t target_section_offset) const final;
        void emit_function_call(const Context& context, size_t function_index) const final;
        void emit_named_function_call(const std::string& function_name) const final;
        void emit_func_remark() const; // RECOMP_EMIT_WATCH diagnostic: restore func-mark after a call (no-op when unset)
        void emit_goto(const std::string& target) const final;
        void emit_label(const std::string& label_name) const final;
        void emit_jtbl_addend_declaration(const JumpTable& jtbl, int reg) const final;
        void emit_jtbl_addend_assignment(const JumpTable& jtbl, int reg) const final;
        void emit_branch_condition(const ConditionalBranchOp& op, const InstructionContext& ctx) const final;
        void emit_branch_close() const final;
        void emit_switch(const Context& recompiler_context, const JumpTable& jtbl, int reg) const final;
        void emit_case(int case_index, const std::string& target_label) const final;
        void emit_switch_error(uint32_t instr_vram, uint32_t jtbl_vram) const final;
        void emit_switch_close() const final;
        void emit_return(const Context& context, size_t func_index) const final;
        void emit_check_fr(int fpr) const final;
        void emit_check_nan(int fpr, bool is_double) const final;
        void emit_cop0_status_read(int reg) const final;
        void emit_cop0_status_write(int reg) const final;
        void emit_cop0_tlb_read(int cop0_reg, int dest_gpr) const final;
        void emit_cop0_tlb_write(int cop0_reg, int src_gpr) const final;
        void emit_tlb_op(int op) const final;
        void emit_cop1_cs_read(int reg) const final;
        void emit_cop1_cs_write(int reg) const final;
        void emit_conditional_move(int rd, int rs, int rt, bool eq_zero) const final;
        void emit_muldiv(InstrId instr_id, int reg1, int reg2) const final;
        void emit_syscall(uint32_t instr_vram) const final;
        void emit_do_break(uint32_t instr_vram) const final;
        void emit_pause_self(uint32_t pc_vram) const final;
        void emit_poll_yield_guard(uint32_t pc_vram) const final;
        void emit_calling_poll_yield_guard(uint32_t func_vram, uint32_t pc_vram) const final;
        void emit_coswitch_prologue(bool saver, bool switcher) const final;
        void emit_coswitch_capture(int base_reg, bool save) const final;
        void emit_coswitch_capture_const(uint32_t block, bool save) const final;
        void emit_coswitch_savepoint(bool return_on_resume) const final;
        void emit_coswitch_jump(int reg) const final;
        void emit_trigger_event(uint32_t event_index) const final;
        void emit_comment(const std::string& comment) const final;
    private:
        void get_operand_string(Operand operand, UnaryOpType operation, const InstructionContext& context, std::string& operand_string) const;
        void get_binary_expr_string(BinaryOpType type, const BinaryOperands& operands, const InstructionContext& ctx, const std::string& output, std::string& expr_string) const;
        void get_notation(BinaryOpType op_type, std::string& func_string, std::string& infix_string) const;
        std::ostream& output_file;
    };
}

#endif
