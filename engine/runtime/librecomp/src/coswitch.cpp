// coswitch.cpp — guest-level coroutine ("swap-context" / setjmp-longjmp) support for statically
// recompiled code. 2026-09-01, Mortal Kombat Trilogy and NBA Hangtime (the Williams/Midway
// arcade-port class): those games run a PROCESS kernel on top of one libultra thread. Each process
// has its own guest stack inside its node; a save routine stores ra/sp/fp/gp/s0-s7 into a context
// BLOCK and a switch routine loads them from another block and `jr`s into that context's saved PC
// (a function entry on the first run, a mid-function return address afterwards). MKT does both in
// one routine (func_800808B8); NBA Hangtime uses a setjmp/longjmp pair called from DIFFERENT frames.
// N64Recomp emits every `jr $ra` as a C `return`, so the switch never jumped: the process never ran,
// the caller continued with the process's registers loaded, nothing freed a node, the pool drained
// and the game halted (MKT: sampler RIP in its own HALT loop under the allocator).
//
// A plain call cannot model a resume at a mid-function PC (it nests forever) and a longjmp unwinds
// the C frames the suspended context still needs — the same argument as baremetal_sched.cpp for
// `eret` kernels. The fit is ONE HOST FIBER PER GUEST STACK plus a SAVEPOINT per context block:
//   * The recompiler recognises a SAVE function (stores $sp off a non-frame base — compiled code never
//     does; only context saves and setjmp do) and emits, at its return, a host `setjmp` in that very
//     frame: `{ jmp_buf* jb = recomp_coswitch_savepoint(rdram, ctx, block); if (jb && setjmp(*jb)) return; }`.
//     The frame stays live on the context's fiber while it is suspended, so the savepoint is valid
//     exactly as long as the guest's saved registers are.
//   * It recognises a SWITCH function (loads $sp off a non-frame base and jr's through a register
//     loaded the same way) and emits at that jr `if (recomp_coswitch(rdram, ctx, block, target)) return;`
//     followed by the jr's ORIGINAL action (a declined hook changes nothing).
//   * Blocks are the identity: a resume of block B switches to the fiber that last saved B and longjmps
//     to B's savepoint — which unwinds any frames the guest longjmp'd across (NBA's longjmp sits in a
//     callee of the frame that setjmp'd), and lands the emitted `return` where the guest expects it,
//     with the registers the resumer's guest code loaded. A target at a FUNCTION ENTRY is a fresh
//     context on that block (a fiber still registered there is stale — its owner was killed and its
//     node recycled — and is retired). A longjmp to a block saved by the RUNNING context is a real
//     setjmp/longjmp within one context and is honoured by the same host longjmp. Nothing registered
//     under the block and no entry ⇒ decline. An eret-scheduled bare-metal kernel owns its thread's
//     fibers (baremetal_sched.cpp) ⇒ decline. Fibers are thread-affine: all state is thread_local.
//     libultra-HLE games never execute such routines, so this file is inert for them.
// Env RECOMP_COSWITCH_LOG=1 prints every event (default: the first 24 switches only).

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <csetjmp>
#include <unordered_map>
#include <vector>

#ifdef _WIN32
#include <Windows.h>
#include <intrin.h>   // _AddressOfReturnAddress
#endif

#include "recomp.h"

extern "C" recomp_func_t* recomp_lookup_native(uint32_t addr);   // overlays.cpp: exact function-entry lookup, no fallbacks
extern "C" int recomp_baremetal_enabled();                        // baremetal_sched.cpp: an eret-scheduled kernel owns the fibers

// RAW-CODE COROUTINE ENTRY (2026-09-05, Off Road Challenge #274 and the Midway module class).
// A cart may DMA a whole second program module into high RDRAM and start one of its routines as a
// process: the context block's saved $ra points at code the front-end never declared, so
// recomp_lookup_native/get_function both miss and the switch was DECLINED forever (the process
// never ran; the game submitted nothing but its frame clear). overlays.cpp already resolves exactly
// this case for a CALL — an unresolved in-RAM KSEG0 target whose first word looks like MIPS is run
// through the interpreter ("kseg0-raw-overlay", the LoD class) rather than fataled. A coroutine
// entry is the same unresolved target reached through a different mechanism, so it gets the same
// policy: start the fiber and interpret. Declines are unchanged for anything that is not plausible
// in-RAM code, so every previously-working switch behaves exactly as before.
extern "C" void recomp_interpret(uint8_t* rdram, recomp_context* ctx, uint32_t start_vaddr);
extern "C" int  recomp_interp_is_code(uint8_t* rdram, uint32_t addr);
// recomp_interpret ends its session when the guest pc reaches the $ra it was entered with. A context
// restore ends `lw $ra,0x0(block); jr $ra`, so a coroutine's $ra IS its entry pc and that sentinel is
// degenerate — the session would end before its first instruction. Same situation as an eret entry
// (no native caller to return to), so use the same suppressor.
extern "C" void recomp_interpret_mark_eret_entry(void);
// Fibers share one host thread, so the interpreter's thread_local nesting state must ride with the
// fiber (same reason and same triple as baremetal_sched.cpp's fiber switches).
extern "C" int      recomp_interp_swap_depth(int new_depth);
extern "C" int      recomp_interp_swap_native(int new_depth);
extern "C" uint32_t recomp_interp_swap_live_pc(uint32_t new_pc);

namespace {

struct CoFiber {
    void*           handle = nullptr;
    uint32_t        entry  = 0;        // guest PC a fresh fiber starts at (function entry)
    uint8_t*        rdram  = nullptr;
    recomp_context* ctx    = nullptr;
    bool            root   = false;    // the host thread's original stack (never deleted)
    unsigned        id     = 0;
    uint32_t        resume_block = 0;  // set by the switcher: which block this fiber is being resumed through
    int             interp_depth = 0;  // parked interpreter nesting state (see the swap triple above)
    int             native_depth = 0;
    uint32_t        live_pc      = 0;
    int             interp_noprogress = 0;  // consecutive interpreter returns that advanced nothing
    bool            raw    = false;     // started at a target with no recompiled body: runs interpreted
};

struct Block {
    CoFiber* fiber  = nullptr;         // the context that last saved this block
    bool     has_jb = false;           // a savepoint frame is live on that fiber
    jmp_buf  jb;
};

thread_local std::unordered_map<uint32_t, Block> tl_blocks;   // context block address -> owner
thread_local CoFiber*              tl_cur  = nullptr;
thread_local CoFiber*              tl_root = nullptr;
thread_local std::vector<CoFiber*> tl_dead;                    // abandoned fibers, retired from another fiber
thread_local unsigned              tl_next_id = 1;
long g_switches = 0;
long g_created  = 0;

// MSVC x64 jmp_buf = _JUMP_BUFFER {Frame, Rbx, Rsp, Rbp, ...}. A savepoint is only a valid longjmp
// target while its frame is still on the fiber's stack: on the SAME fiber that means its Rsp must be
// numerically above the current stack pointer (an ancestor frame). A longjmp into a frame that has
// already returned is exactly the STATUS_BAD_STACK NBA Hangtime hit; refuse it and decline instead.
// Frame is zeroed before every host longjmp so the CRT restores registers directly instead of
// unwinding with RtlUnwindEx through recompiled frames (no destructors live in them).
static uintptr_t jb_rsp(const jmp_buf& jb) {
    return (uintptr_t)reinterpret_cast<const _JUMP_BUFFER*>(&jb)->Rsp;
}
static void host_longjmp(jmp_buf& jb) {
    reinterpret_cast<_JUMP_BUFFER*>(&jb)->Frame = 0;
    longjmp(jb, 1);
}
static uintptr_t current_rsp() {
    // A live address in the CURRENT frame (the return-address slot); coarse "where is the stack now"
    // for the ancestor check. Not &local (that returns a dead-frame address -> C4172/UB).
    return (uintptr_t)_AddressOfReturnAddress();
}
// Frames below (deeper than) a longjmp target die with the jump: their savepoints are void.
static void invalidate_savepoints_below(const void* fiber_handle_owner, uintptr_t target_rsp);

bool log_on() {
    static const bool on = [] { const char* e = std::getenv("RECOMP_COSWITCH_LOG"); return e != nullptr && *e != '\0' && *e != '0'; }();
    return on;
}
bool log_now() {
    static long _n = 0;
    return log_on() || _n++ < 24;
}
static void invalidate_savepoints_below(const void* owner, uintptr_t target_rsp) {
    for (auto& kv : tl_blocks) {
        if (kv.second.has_jb && (const void*)kv.second.fiber == owner && jb_rsp(kv.second.jb) < target_rsp) {
            kv.second.has_jb = false;
        }
    }
}

#ifdef _WIN32
bool is_registered(const CoFiber* f) {
    for (const auto& kv : tl_blocks) {
        if (kv.second.fiber == f) return true;
    }
    return false;
}
void unregister(const CoFiber* f) {
    for (auto& kv : tl_blocks) {
        if (kv.second.fiber == f) { kv.second.fiber = nullptr; kv.second.has_jb = false; }
    }
}
void retire(CoFiber* f) {
    if (f == nullptr || f->root || f == tl_cur) return;
    unregister(f);
    DeleteFiber(f->handle);
    delete f;
}
void reap_dead() {
    if (tl_dead.empty()) return;
    std::vector<CoFiber*> keep;
    for (CoFiber* d : tl_dead) {
        if (d == tl_cur) { keep.push_back(d); continue; }
        retire(d);
    }
    tl_dead.swap(keep);
}
void ensure_fiber(uint8_t* rdram, recomp_context* ctx) {
    if (!IsThreadAFiber()) {
        ConvertThreadToFiber(nullptr);
    }
    if (tl_cur == nullptr) {
        tl_root = new CoFiber();
        tl_root->root = true;
        tl_root->rdram = rdram;
        tl_root->ctx = ctx;
        tl_root->id = tl_next_id++;
        tl_cur = tl_root;
    }
    if (tl_root->handle == nullptr) {
        tl_root->handle = GetCurrentFiber();
    }
}

// An unresolved coroutine target that is plausible MIPS sitting in RDRAM: a routine of a module the
// cart DMA'd in and the front-end never declared. Same predicate and same range as the kseg0 raw
// overlay net in overlays.cpp, so the two mechanisms agree on what "runnable but unrecompiled" means.
bool is_raw_code_target(uint8_t* rdram, uint32_t target) {
    if (rdram == nullptr) return false;
    if (target < 0x80000000u || target >= 0x80800000u) return false;
    return recomp_interp_is_code(rdram, target) != 0;
}

void CALLBACK co_fiber_proc(void* p) {
    CoFiber* f = static_cast<CoFiber*>(p);
    uint32_t pc = f->entry;
    for (;;) {
        recomp_func_t* fn = recomp_lookup_native(pc);
        if (fn == nullptr && f->raw && is_raw_code_target(f->rdram, pc)) {
            // This fiber exists only because the target had no recompiled body. Interpret it HERE
            // rather than through get_function's gap trampoline: that trampoline enters
            // recomp_interpret with the default stop sentinel ($ra), and a context restore ends
            // `lw $ra,0x0(block); jr $ra`, so $ra IS the entry pc and the session would end before
            // its first instruction (measured: ginstr never moved off 63).
            const uint32_t before = pc;
            if ((uint32_t)f->ctx->r31 == pc) {
                recomp_interpret_mark_eret_entry();   // no native caller to return to
            }
            static int _ri = 0;
            if (_ri++ < 8) {
                fprintf(stderr, "[coswitch] fiber #%u: interpreting raw in-RAM module at 0x%08X "
                                "(declare it in the front-end for speed)\n", f->id, pc);
                fflush(stderr);
            }
            recomp_interpret(f->rdram, f->ctx, pc);
            pc = (uint32_t)f->ctx->r31;
            if (pc == before && ++f->interp_noprogress > 64) {
                fprintf(stderr, "[coswitch] fiber #%u: interpreter made no progress at 0x%08X — abandoning\n", f->id, pc);
                break;
            }
            if (pc != before) f->interp_noprogress = 0;
            continue;
        }
        if (fn == nullptr) {
            fn = get_function((int32_t)pc);   // a continuation inside a function: the gap/interp net
        }
        if (fn == nullptr) {
            // No recompiled body anywhere: raw in-RAM code (an undeclared module) runs interpreted,
            // exactly as an unresolved CALL to the same address would. The interpreter returns when
            // the routine `jr $ra`s back to the pc it was entered at, which is the same "the context's
            // function RETURNED" event the native arm below handles, so the loop is shared.
            if (!is_raw_code_target(f->rdram, pc)) {
                break;
            }
            static int _ri = 0;
            if (_ri++ < 24) {
                fprintf(stderr, "[coswitch] fiber #%u: no recompiled body at 0x%08X — interpreting "
                                "(raw in-RAM module; declare it in the front-end for speed)\n", f->id, pc);
                fflush(stderr);
            }
            const uint32_t before = pc;
            if ((uint32_t)f->ctx->r31 == pc) {
                recomp_interpret_mark_eret_entry();   // degenerate sentinel: run until the guest switches away
            }
            recomp_interpret(f->rdram, f->ctx, pc);
            pc = (uint32_t)f->ctx->r31;
            // recomp_interpret can decline outright (depth cap): re-entering the same pc with no
            // guest progress would be a hot spin on this fiber, so bound it and abandon the stack.
            if (pc == before && ++f->interp_noprogress > 64) {
                fprintf(stderr, "[coswitch] fiber #%u: interpreter made no progress at 0x%08X — abandoning\n", f->id, pc);
                break;
            }
            if (pc != before) f->interp_noprogress = 0;
            continue;
        }
        fn(f->rdram, f->ctx);
        // The context's function RETURNED. Hardware would `jr $ra` with whatever $ra holds now
        // (for a process whose handler returns, that is the handler itself: it restarts). Follow it.
        pc = (uint32_t)f->ctx->r31;
        if (log_now()) {
            fprintf(stderr, "[coswitch] fiber #%u: function returned; continuing at ra=0x%08X\n", f->id, pc);
            fflush(stderr);
        }
    }
    // Nothing left to run on this stack. Abandon it and hand the CPU to the root context.
    fprintf(stderr, "[coswitch] fiber #%u: no continuation at 0x%08X - abandoning to the root context\n", f->id, pc);
    fflush(stderr);
    unregister(f);
    tl_dead.push_back(f);
    recomp_interp_swap_depth(tl_root->interp_depth);     // this stack is gone; adopt the root's nesting state
    recomp_interp_swap_native(tl_root->native_depth);
    recomp_interp_swap_live_pc(tl_root->live_pc);
    tl_cur = tl_root;
    SwitchToFiber(tl_root->handle);
}
#endif

} // namespace

// Called at the RETURN of a save function (setjmp / the save half of a swap routine) with the block
// its `sw $sp` addressed. Registers the running context as the block's owner and hands back the
// block's jmp_buf for the emitted frame to setjmp() into. NULL = declined (no savepoint recorded).
extern "C" jmp_buf* recomp_coswitch_savepoint(uint8_t* rdram, recomp_context* ctx, uint32_t block) {
#ifndef _WIN32
    (void)rdram; (void)ctx; (void)block;
    return nullptr;
#else
    if (block == 0 || recomp_baremetal_enabled()) {
        return nullptr;
    }
    // Never convert the thread here: recording a savepoint must not pre-empt a bare-metal
    // scheduler that arms later on this thread (it converts the thread itself). The root context
    // record is created without a fiber handle; the handle is filled in at the first real switch.
    if (tl_cur == nullptr) {
        tl_root = new CoFiber();
        tl_root->root = true;
        tl_root->rdram = rdram;
        tl_root->ctx = ctx;
        tl_root->id = tl_next_id++;
        tl_cur = tl_root;
    }
    Block& b = tl_blocks[block];
    if (b.fiber != nullptr && b.fiber != tl_cur) {
        // The block changed hands (a recycled process node): its previous owner is stale unless it
        // still owns another block.
        CoFiber* prev = b.fiber;
        b.fiber = tl_cur;
        if (!is_registered(prev)) retire(prev);
    }
    b.fiber = tl_cur;
    b.has_jb = true;
    if (log_on()) {
        fprintf(stderr, "[coswitch] savepoint block=0x%08X by fiber #%u\n", block, tl_cur->id);
        fflush(stderr);
    }
    return &b.jb;
#endif
}

// Called at the jr of a switch function with the block its `lw $sp` addressed and the jump target.
extern "C" int recomp_coswitch(uint8_t* rdram, recomp_context* ctx, uint32_t block, uint32_t target) {
#ifndef _WIN32
    (void)rdram; (void)ctx; (void)block; (void)target;
    static int _once = 0;
    if (_once++ == 0) { fprintf(stderr, "[coswitch] guest context switch reached but fibers are Win32-only - declined\n"); fflush(stderr); }
    return 0;
#else
    if (block == 0 || recomp_baremetal_enabled()) {
        static int _dec = 0;
        if (_dec++ < 4) { fprintf(stderr, "[coswitch] declined (block=0x%08X target=0x%08X bare-metal=%d)\n", block, target, recomp_baremetal_enabled()); fflush(stderr); }
        return 0;
    }
    ensure_fiber(rdram, ctx);
    CoFiber* self = tl_cur;
    auto it = tl_blocks.find(block);
    Block* b = (it != tl_blocks.end()) ? &it->second : nullptr;
    CoFiber* owner = b ? b->fiber : nullptr;
    recomp_func_t* entry_fn = recomp_lookup_native(target);

    if (owner == self && entry_fn == nullptr) {
        // A longjmp to a block this very context saved: a real setjmp/longjmp inside one context.
        // Valid only while the savepoint's frame is an ANCESTOR of this one (its Rsp above ours);
        // a frame that already returned (NBA Hangtime: the process ran as a nested call and its
        // sleep frame was unwound by an earlier longjmp) cannot be re-entered: decline.
        if (b->has_jb && jb_rsp(b->jb) > current_rsp()) {
            if (log_now()) { fprintf(stderr, "[coswitch] longjmp within fiber #%u to block=0x%08X target=0x%08X\n", self->id, block, target); fflush(stderr); }
            const uintptr_t tgt_rsp = jb_rsp(b->jb);
            b->has_jb = false;
            invalidate_savepoints_below(self, tgt_rsp);
            host_longjmp(b->jb);
        }
        static int _dead = 0;
        if (_dead++ < 24) {
            fprintf(stderr, "[coswitch] longjmp within fiber #%u to block=0x%08X target=0x%08X: savepoint %s - declined\n",
                    self->id, block, target, b->has_jb ? "frame already returned" : "absent");
            fflush(stderr);
        }
        return 0;
    }

    CoFiber* tgt = nullptr;
    const char* how = "";
    // A first run of a context whose saved pc is in an undeclared in-RAM module: no native entry and
    // nothing parked under the block. This used to be the "UNKNOWN continuation - declined" dead end;
    // it is a fresh context like any other, and its stack runs interpreted (see co_fiber_proc).
    const bool raw_entry = (entry_fn == nullptr) && (owner == nullptr) && is_raw_code_target(rdram, target);
    if (entry_fn != nullptr || raw_entry) {
        // Fresh context at a function entry on this block. Whatever fiber is still registered under
        // the block was killed while suspended (node recycled): retire it.
        if (owner != nullptr && owner != self) {
            b->fiber = nullptr; b->has_jb = false;
            if (!is_registered(owner)) retire(owner);
        }
        tgt = new CoFiber();
        tgt->raw   = raw_entry;
        tgt->entry = target;
        tgt->rdram = rdram;
        tgt->ctx = ctx;
        tgt->id = tl_next_id++;
        tgt->handle = CreateFiber(0, &co_fiber_proc, tgt);
        if (tgt->handle == nullptr) {
            fprintf(stderr, "[coswitch] CreateFiber FAILED for entry 0x%08X - declined\n", target);
            fflush(stderr);
            delete tgt;
            return 0;
        }
        Block& nb = tl_blocks[block];
        nb.fiber = tgt;
        nb.has_jb = false;
        g_created++;
        how = raw_entry ? "NEW-INTERP" : "NEW";
    }
    else if (owner != nullptr) {
        tgt = owner;
        how = "RESUME";
    }
    else {
        static int _unk = 0;
        if (_unk++ < 24) {
            fprintf(stderr, "[coswitch] UNKNOWN continuation block=0x%08X target=0x%08X - declined\n", block, target);
            fflush(stderr);
        }
        return 0;
    }

    // Leaving. A context that owns no block any more (it left through a no-save switch and was not
    // re-saved) can never be resumed: retire its stack from the next context.
    if (!self->root && !is_registered(self)) {
        tl_dead.push_back(self);
    }
    g_switches++;
    if (log_now()) {
        fprintf(stderr, "[coswitch] #%ld %s fiber #%u -> #%u block=0x%08X target=0x%08X blocks=%zu created=%ld\n",
                g_switches, how, self->id, tgt->id, block, target, tl_blocks.size(), g_created);
        fflush(stderr);
    }
    tgt->resume_block = block;
    // Park our interpreter nesting state and install the target's (all zero for a fiber that never
    // interprets, so this is inert for every game that only runs recompiled bodies).
    self->interp_depth = recomp_interp_swap_depth(tgt->interp_depth);
    self->native_depth = recomp_interp_swap_native(tgt->native_depth);
    self->live_pc      = recomp_interp_swap_live_pc(tgt->live_pc);
    tl_cur = tgt;
    SwitchToFiber(tgt->handle);

    // Resumed: another context switched to us through self->resume_block. Its guest routine loaded
    // our registers. If that block has a live savepoint on this fiber, unwind to it (the guest's own
    // resume point); otherwise continue from here (the single-routine swap idiom).
    tl_cur = self;
    reap_dead();
    const uint32_t rb = self->resume_block;
    self->resume_block = 0;
    auto rit = tl_blocks.find(rb);
    if (rit != tl_blocks.end() && rit->second.fiber == self && rit->second.has_jb && jb_rsp(rit->second.jb) > current_rsp()) {
        const uintptr_t tgt_rsp = jb_rsp(rit->second.jb);
        rit->second.has_jb = false;
        invalidate_savepoints_below(self, tgt_rsp);
        host_longjmp(rit->second.jb);
    }
    return 1;
#endif
}
