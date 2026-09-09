#ifndef __RECOMP_H__
#define __RECOMP_H__

#include <setjmp.h>   // [coswitch] savepoints in emitted frames
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <fenv.h>
#include <assert.h>

// Compiler definition to disable inter-procedural optimization, allowing multiple functions to be in a single file without breaking interposition.
#if defined(_MSC_VER) && !defined(__clang__) && !defined(__INTEL_COMPILER)
    // MSVC's __declspec(noinline) seems to disable inter-procedural optimization entirely, so it's all that's needed.
    #define RECOMP_FUNC __declspec(noinline)
    
    // Use MSVC's fenv_access pragma.
    #define SET_FENV_ACCESS() _Pragma("fenv_access(on)")
#elif defined(__clang__)
    // Clang has no dedicated IPO attribute, so we use a combination of other attributes to give the desired behavior.
    // The inline keyword allows multiple definitions during linking, and extern forces clang to emit an externally visible definition.
    // Weak forces Clang to not perform any IPO as the symbol can be interposed, which prevents actual inlining due to the inline keyword.
    // Add noinline on for good measure, which doesn't conflict with the inline keyword as they have different meanings.
    #define RECOMP_FUNC extern inline __attribute__((weak,noinline))

    // Use the standard STDC FENV_ACCESS pragma.
    #define SET_FENV_ACCESS() _Pragma("STDC FENV_ACCESS ON")
#elif defined(__GNUC__) && !defined(__INTEL_COMPILER)
    // Use GCC's attribute for disabling inter-procedural optimizations. Also enable the rounding-math compiler flag to disable
    // constant folding so that arithmetic respects the floating point environment. This is needed because gcc doesn't implement
    // any FENV_ACCESS pragma.
    #define RECOMP_FUNC __attribute__((noipa, optimize("rounding-math")))

    // There's no FENV_ACCESS pragma in gcc, so this can be empty.
    #define SET_FENV_ACCESS()
#else
    #error "No RECOMP_FUNC definition for this compiler"
#endif

// Implementation of 64-bit multiply and divide instructions
#if defined(__SIZEOF_INT128__)

static inline void DMULT(int64_t a, int64_t b, int64_t* lo64, int64_t* hi64) {
    __int128 full128 = ((__int128)a) * ((__int128)b);

    *hi64 = (int64_t)(full128 >> 64);
    *lo64 = (int64_t)(full128 >> 0);
}

static inline void DMULTU(uint64_t a, uint64_t b, uint64_t* lo64, uint64_t* hi64) {
    unsigned __int128 full128 = ((unsigned __int128)a) * ((unsigned __int128)b);

    *hi64 = (uint64_t)(full128 >> 64);
    *lo64 = (uint64_t)(full128 >> 0);
}

#elif defined(_MSC_VER)

#include <intrin.h>
#pragma intrinsic(_mul128)
#pragma intrinsic(_umul128)

static inline void DMULT(int64_t a, int64_t b, int64_t* lo64, int64_t* hi64) {
    *lo64 = _mul128(a, b, hi64);
}

static inline void DMULTU(uint64_t a, uint64_t b, uint64_t* lo64, uint64_t* hi64) {
    *lo64 = _umul128(a, b, hi64);
}

#else
#error "128-bit integer type not found"
#endif

static inline void DDIV(int64_t a, int64_t b, int64_t* quot, int64_t* rem) {
    // cv64 SESSION 38: VR4300 faithfulness — a zero divisor must NOT trap (hardware defines
    // the result: quot = a<0 ? 1 : -1, rem = a). Matches the cpu_div codegen fix in cgenerator.cpp.
    if (b == 0) {
        *quot = (a < 0) ? 1 : -1;
        *rem = a;
        return;
    }
    int overflow = ((uint64_t)a == 0x8000000000000000ull) && (b == -1ll);
    *quot = overflow ? a : (a / b);
    *rem = overflow ? 0 : (a % b);
}

static inline void DDIVU(uint64_t a, uint64_t b, uint64_t* quot, uint64_t* rem) {
    // cv64 SESSION 38: VR4300 zero-divisor semantics for DDIVU: quot = all ones, rem = a.
    if (b == 0) {
        *quot = ~0ull;
        *rem = a;
        return;
    }
    *quot = a / b;
    *rem = a % b;
}

typedef uint64_t gpr;

#define SIGNED(val) \
    ((int64_t)(val))

#define ADD32(a, b) \
    ((gpr)(int32_t)((a) + (b)))

#define SUB32(a, b) \
    ((gpr)(int32_t)((a) - (b)))

// CV64_PHYS: translate a virtual address to a physical RDRAM offset.
//   - KSEG0/KSEG1 (0x80000000-0xBFFFFFFF, high bit set): direct-mapped (VA & 0x1FFFFFFF),
//     fast-pathed inline here so the hot path takes no function call.
//   - KUSEG (0x00000000-0x7FFFFFFF, high bit clear): routed through the LLE TLB
//     (recomp_tlb_translate). While TLB mappings are identity this returns the same
//     physical as the old flat formula; unmapped KUSEG falls back to flat.
// recomp_tlb_translate is defined in runtime/librecomp/src/tlb.cpp; forward-declared
// here because inline helpers below (load_doubleword/do_lwl) expand CV64_PHYS.
#ifdef __cplusplus
extern "C"
#endif
uint32_t recomp_tlb_translate(uint32_t vaddr);

// store-watch diagnostic (paired with cgenerator's RECOMP_EMIT_WATCH recomp-time flag +
// RECOMP_SWATCH_ADDR/RECOMP_SWATCH_LOG runtime). recomp_func_mark records the current guest func vram at
// entry; recomp_store_watch_h, emitted AFTER each store in a watch build, attributes a watched write to
// its writer. Defined in librecomp/src/recomp.cpp; no-op unless RECOMP_SWATCH_ADDR is set at runtime.
#ifdef __cplusplus
extern "C" {
#endif
void recomp_func_mark(uint32_t vram);
void recomp_store_watch_h(uint8_t* rdram, uint64_t addr, uint32_t val);
void recomp_mtx_probe(uint8_t* rdram, uint32_t dest, uint32_t src);
#ifdef __cplusplus
}
#endif
// Correct VR4300 translation: direct-map ONLY KSEG0/KSEG1 (0x80000000-0xBFFFFFFF, bits 31-30 == 10);
// KUSEG (bit31=0) AND KSEG2/KSEG3 (0xC0000000-0xFFFFFFFF, bits 31-30 == 11) are TLB-mapped. The old test
// `addr & 0x80000000` wrongly direct-mapped KSEG2/3 to RDRAM offset 0, breaking games that TLB-map a
// custom device there (Nightmare Creatures' 0xC0000000 RCP device; 1080's 0xC0000000 map).
// [rdram-wrap r3 2026-08-26] KSEG0/1 decode, minimal and month-proven:
//   phys < 0x10000000  -> FLAT, exactly the pre-08-26 behavior (RDRAM + devices + slack-zero
//                         probe space; r1/r2's 8MB wrapping broke the BOOT — the license screen
//                         hung because device-absent probe reads started aliasing RDRAM garbage).
//   phys >= 0x10000000 -> cart domain: within the ROM mirror (engine copies ROM to
//                         rdram+0x10000000) flat; PAST it -> the junk cell at 0x03E00000
//                         (hardware: ROM-domain writes are dropped, past-ROM reads are open-bus;
//                         previously these host-AV'd — SOTE reload-era crashes RVA 0x396393 WRITE
//                         and RVA 0xCBF24A READ, both cart-domain offsets past the mirror).
#define CV64_PHYS_KSEG(addr)     (((uint32_t)(addr) & 0x1FFFFFFFu) < 0x10000000u ? ((uint32_t)(addr) & 0x1FFFFFFFu)      : (((uint32_t)(addr) & 0x1FFFFFFFu) - 0x10000000u) < 0x00C00000u ? ((uint32_t)(addr) & 0x1FFFFFFFu)      : 0x03E00000u)
#define CV64_PHYS(addr)     ((((uint32_t)(addr) & 0xC0000000u) == 0x80000000u) ? CV64_PHYS_KSEG(addr)                                       : recomp_tlb_translate((uint32_t)(addr)))

#define MEM_W(offset, reg) \
    (*(int32_t*)(rdram + CV64_PHYS((reg) + (offset))))

// lwu: load word UNSIGNED (zero-extend to 64-bit), vs MEM_W/lw which sign-extends. A valid
// vr4300 (MIPS-III) op; emitted by N64Recomp as MEM_WU. (General runtime gap — first hit by
// Wave Race 64's overlay code.)
#define MEM_WU(offset, reg) \
    (*(uint32_t*)(rdram + CV64_PHYS((reg) + (offset))))

#define MEM_H(offset, reg) \
    (*(int16_t*)(rdram + (CV64_PHYS((reg) + (offset)) ^ 2)))

#define MEM_B(offset, reg) \
    (*(int8_t*)(rdram + (CV64_PHYS((reg) + (offset)) ^ 3)))

#define MEM_HU(offset, reg) \
    (*(uint16_t*)(rdram + (CV64_PHYS((reg) + (offset)) ^ 2)))

#define MEM_BU(offset, reg) \
    (*(uint8_t*)(rdram + (CV64_PHYS((reg) + (offset)) ^ 3)))

// ---------------------------------------------------------------------------------------------
// Raw hardware-register (MMIO) store routing.
//
// Most N64 games touch hardware only through libultra, which we replace with HLE natives. But
// some games (e.g. Robotron 64 — a rushed PSX->N64 port with a hand-rolled cartridge-DMA driver)
// hit the memory-mapped device registers DIRECTLY (PI at 0xA4600000, etc.), bypassing libultra.
// Our recompiler maps those virtual addresses straight into RDRAM, so a write/read of e.g.
// PI_STATUS just touches plain memory and the device semantics are lost (the game writes
// PI_STATUS = RESET|CLR_INTR and then polls it forever expecting hardware to clear the busy
// bits). STORE_W routes word stores whose address lands in the device-register window
// (0xA4000000-0xA4FFFFFF) to a handler that emulates the device (PI DMA engine, etc.); every
// other store falls through to a plain RDRAM write with zero overhead on the common path.
// Loads need no routing: the handler keeps the readable register state correct in RDRAM.
#ifdef __cplusplus
extern "C" {
#endif
void recomp_mmio_store_w(uint8_t* rdram, uint32_t vaddr, uint32_t value);
uint32_t recomp_mmio_load_w(uint8_t* rdram, uint32_t vaddr);
#ifdef __cplusplus
}
#endif

// Two device-register windows route here:
//   0xA4000000-0xA4FFFFFF  — the RCP MMIO registers (PI/SP/VI/AI/SI/MI/DPC), KSEG1.
//   0xC0000000-0xC000FFFF  — the cartridge GIO / RDB device window (KSEG2, TLB-mapped). Bare-metal
//                            ports that drive a custom RCP/command device there (Nightmare Creatures'
//                            0xC0000000 GIO command processor) need the device-completion handshake.
//                            The handler write-throughs every access via the real TLB, so games that
//                            merely TLB-map this window as plain memory (1080's 0xC0000000 map) are
//                            byte-for-byte unaffected; only device side effects (ACK -> deassert the
//                            RDB interrupt line) are layered on, and only when the GIO device is enabled.
// RDRAM SIZE MODEL: the N64 has 8MB of RDRAM (4MB base + 4MB Expansion Pak); the physical RDRAM
// region spans 0x00000000-0x03EFFFFF but only the installed 0x000000-0x7FFFFF is real RAM — accesses
// ABOVE it are OPEN BUS (writes vanish, reads return a non-data value). Our engine maps a flat 512MB so
// without this every write "sticks" and every read mirrors it back, which makes a game's raw RDRAM
// size-detection probe (write a test pattern up memory until the readback differs at the RAM edge) loop
// FOREVER (it never finds the edge) — e.g. Army Men: Sarge's Heroes' func_80089070, the same probe that
// stalls F-Zero. Model the edge: in the RDRAM region (phys < 0x04000000) above 8MB, drop word writes and
// read 0, so the probe terminates at exactly 8MB. General "fix the N64" hardware correctness; well-behaved
// 8MB titles never touch this range (osGetMemSize reports 8MB) so they are byte-for-byte unaffected.
#define RDRAM_OPEN_BUS(phys) ((uint32_t)(phys) >= 0x00800000u && (uint32_t)(phys) < 0x04000000u)
// [cart-ro 2026-09-06, A Bug's Life #97] THE CART IS MASK ROM: the CPU may read it, and a CPU store
// into the cart (PI domain 1) window is ignored by the cartridge — the image can never change. The
// CV64_PHYS_KSEG fence above already states that rule ("hardware: ROM-domain writes are dropped")
// but only applies it PAST the mirror; INSIDE the 12MB window it returns the flat physical, so a
// guest store lands in the engine's own copy of the ROM. Same failure shape as the RDRAM edge
// modelled just above: memory that is too permissive turns a bounded guest routine into fiction.
// MEASURED on bugslifea: a pointer-fixup walk that starts at the wavetable ROM base 0xB08D1800
// wrote 417,405 words over ROM 0x8D1818..0xC00000 — its own wavetable sample data and every asset
// after it — so every later PI DMA reads a corrupted image; and the walk only appeared to TERMINATE
// because one of its own stores landed on its loop-bound word at ROM 0x8D1800 and turned it
// negative, i.e. the writable mirror manufactured a control flow the hardware does not have.
// Redirect a STORE whose translated physical lands in the cart window to the junk cell, which is
// already inert (it sits inside RDRAM_OPEN_BUS: writes vanish, reads return 0). LOADS are untouched
// — the ROM must still read as the ROM. Cart domain 2 (SRAM/FlashRAM/64DD saves, phys 0x06000000 /
// 0x08000000) is below 0x10000000 and is byte-for-byte unaffected.
#define CART_ROM_PHYS(phys)  ((uint32_t)(phys) >= 0x10000000u)
#define STORE_PHYS(phys)     (CART_ROM_PHYS(phys) ? 0x03E00000u : (uint32_t)(phys))
// [openbus-phys 2026-09-05, Rage Wars #152 / the Acclaim window class] The open-bus edge is a
// property of the PHYSICAL address (the installed 8MB of RDRAM), so the test must run on the
// translated address. It used to run on `vaddr & 0x1FFFFFFF`, which is the physical address only
// for KSEG0/1; for a TLB-mapped KUSEG page it is meaningless. Rage Wars' pager maps its heap at
// virtual 0x00800000+ onto physical 0x0014C000 (a 4 KB page it had just DMA'd from ROM 0x28B264)
// and every `lw` from that page returned 0 while every `sw` into it vanished - the game's pointer
// chain went into garbage, its fatal handler waited 2 s and rebooted through 0x80000400 forever.
// MEASURED: trigger at 0x00257428 after the retried load: v0=0x00800000, v1=0 while the physical
// page held 2871 nonzero bytes and TLB idx 1 mapped it (lo0=0x0000531F). KSEG0/1 behaviour is
// byte-identical (their physical IS vaddr & 0x1FFFFFFF); unmapped KUSEG still falls to the flat
// fence and reads open bus above 8MB exactly as before.
#define STORE_W(offset, reg, val) do { \
        uint32_t _stw_vaddr = (uint32_t)((reg) + (offset)); \
        if (((_stw_vaddr) & 0xFF000000u) == 0xA4000000u || ((_stw_vaddr) & 0xFFFF0000u) == 0xC0000000u) { \
            recomp_mmio_store_w(rdram, _stw_vaddr, (uint32_t)(val)); \
        } else { \
            uint32_t _stw_phys = STORE_PHYS(CV64_PHYS(_stw_vaddr)); /* [cart-ro] mask ROM ignores CPU stores */ \
            if (!RDRAM_OPEN_BUS(_stw_phys)) { /* open bus above installed 8MB: the write vanishes */ \
                *(int32_t*)(rdram + _stw_phys) = (val); \
            } \
        } \
    } while (0)

// Symmetric to STORE_W: word loads whose address lands in the device-register window read the
// live device register (status/current regs the games poll) instead of stale RDRAM. Ordinary
// RDRAM loads take the cheap, branch-predicted-not-taken fast path identical to MEM_W. Reads from the
// RDRAM region above installed 8MB return 0 (open bus) so size-detection probes terminate at the RAM edge.
static inline int32_t recomp_load_w_impl(uint8_t* rdram, uint32_t vaddr) {
    if ((vaddr & 0xFF000000u) == 0xA4000000u) return (int32_t)recomp_mmio_load_w(rdram, vaddr);
    uint32_t phys = CV64_PHYS(vaddr);          /* [openbus-phys] one translation, then the edge test on it */
    if (RDRAM_OPEN_BUS(phys)) return 0;         /* open bus above installed 8MB: reads a non-data value */
    return *(int32_t*)(rdram + phys);
}
#define LOAD_W(offset, reg) \
    ((gpr)recomp_load_w_impl(rdram, (uint32_t)((reg) + (offset))))

// SD/LD must honor the same device-register window as STORE_W/LOAD_W. A bare-metal title's exception handler
// saves/restores context AND reads the RCP registers (MI_INTR etc.) through $k0 with sd/ld; without this routing
// each doubleword half goes to fake RDRAM (phys 0x0430xxxx) instead of the live device, so the handler reads the
// pending-interrupt register as 0 and never dispatches. The RDRAM fast path stays branch-predicted-not-taken;
// baseline titles never sd/ld to 0xA4xxxxxx so they are unaffected.
#define SD(val, offset, reg) do { \
    uint32_t _sd_hi = (uint32_t)((reg) + (offset) + 0); \
    uint32_t _sd_lo = (uint32_t)((reg) + (offset) + 4); \
    if (((_sd_lo) & 0xFF000000u) == 0xA4000000u) recomp_mmio_store_w(rdram, _sd_lo, (uint32_t)((gpr)(val) >> 0)); \
    else *(uint32_t*)(rdram + STORE_PHYS(CV64_PHYS((reg) + (offset) + 4))) = (uint32_t)((gpr)(val) >> 0); \
    if (((_sd_hi) & 0xFF000000u) == 0xA4000000u) recomp_mmio_store_w(rdram, _sd_hi, (uint32_t)((gpr)(val) >> 32)); \
    else *(uint32_t*)(rdram + STORE_PHYS(CV64_PHYS((reg) + (offset) + 0))) = (uint32_t)((gpr)(val) >> 32); \
} while (0)

static inline uint64_t load_doubleword(uint8_t* rdram, gpr reg, gpr offset) {
    uint32_t _ld_hi = (uint32_t)((reg) + (offset) + 0);
    uint32_t _ld_lo = (uint32_t)((reg) + (offset) + 4);
    uint64_t hi = (((_ld_hi) & 0xFF000000u) == 0xA4000000u)
        ? (uint64_t)(uint32_t)recomp_mmio_load_w(rdram, _ld_hi) : (uint64_t)(uint32_t)MEM_W(reg, offset + 0);
    uint64_t lo = (((_ld_lo) & 0xFF000000u) == 0xA4000000u)
        ? (uint64_t)(uint32_t)recomp_mmio_load_w(rdram, _ld_lo) : (uint64_t)(uint32_t)MEM_W(reg, offset + 4);
    return (lo << 0) | (hi << 32);
}

#define LD(offset, reg) \
    load_doubleword(rdram, offset, reg)

static inline gpr do_lwl(uint8_t* rdram, gpr initial_value, gpr offset, gpr reg) {
    // Calculate the overall address
    gpr address = (offset + reg);

    // Load the aligned word
    gpr word_address = address & ~0x3;
    uint32_t loaded_value = MEM_W(0, word_address);

    // Mask the existing value and shift the loaded value appropriately
    gpr misalignment = address & 0x3;
    gpr masked_value = initial_value & (gpr)(uint32_t)~(0xFFFFFFFFu << (misalignment * 8));
    loaded_value <<= (misalignment * 8);

    // Cast to int32_t to sign extend first
    return (gpr)(int32_t)(masked_value | loaded_value);
}

static inline gpr do_lwr(uint8_t* rdram, gpr initial_value, gpr offset, gpr reg) {
    // Calculate the overall address
    gpr address = (offset + reg);
    
    // Load the aligned word
    gpr word_address = address & ~0x3;
    uint32_t loaded_value = MEM_W(0, word_address);

    // Mask the existing value and shift the loaded value appropriately
    gpr misalignment = address & 0x3;
    gpr masked_value = initial_value & (gpr)(uint32_t)~(0xFFFFFFFFu >> (24 - misalignment * 8));
    loaded_value >>= (24 - misalignment * 8);

    // Cast to int32_t to sign extend first
    return (gpr)(int32_t)(masked_value | loaded_value);
}

static inline void do_swl(uint8_t* rdram, gpr offset, gpr reg, gpr val) {
    // Calculate the overall address
    gpr address = (offset + reg);

    // Get the initial value of the aligned word
    gpr word_address = address & ~0x3;
    uint32_t initial_value = MEM_W(0, word_address);

    // Mask the initial value and shift the input value appropriately
    gpr misalignment = address & 0x3;
    uint32_t masked_initial_value = initial_value & ~(0xFFFFFFFFu >> (misalignment * 8));
    uint32_t shifted_input_value = ((uint32_t)val) >> (misalignment * 8);
    MEM_W(0, word_address) = masked_initial_value | shifted_input_value;
}

static inline void do_swr(uint8_t* rdram, gpr offset, gpr reg, gpr val) {
    // Calculate the overall address
    gpr address = (offset + reg);

    // Get the initial value of the aligned word
    gpr word_address = address & ~0x3;
    uint32_t initial_value = MEM_W(0, word_address);

    // Mask the initial value and shift the input value appropriately
    gpr misalignment = address & 0x3;
    uint32_t masked_initial_value = initial_value & ~(0xFFFFFFFFu << (24 - misalignment * 8));
    uint32_t shifted_input_value = ((uint32_t)val) << (24 - misalignment * 8);
    MEM_W(0, word_address) = masked_initial_value | shifted_input_value;
}

static inline gpr do_ldl(uint8_t* rdram, gpr initial_value, gpr offset, gpr reg) {
    // Calculate the overall address
    gpr address = (offset + reg);

    // Load the aligned dword
    gpr dword_address = address & ~0x7;
    uint64_t loaded_value = load_doubleword(rdram, 0, dword_address);

    // Mask the existing value and shift the loaded value appropriately
    gpr misalignment = address & 0x7;
    gpr masked_value = initial_value & ~(0xFFFFFFFFFFFFFFFFu << (misalignment * 8));
    loaded_value <<= (misalignment * 8);

    return masked_value | loaded_value;
}

static inline gpr do_ldr(uint8_t* rdram, gpr initial_value, gpr offset, gpr reg) {
    // Calculate the overall address
    gpr address = (offset + reg);
    
    // Load the aligned dword
    gpr dword_address = address & ~0x7;
    uint64_t loaded_value = load_doubleword(rdram, 0, dword_address);

    // Mask the existing value and shift the loaded value appropriately
    gpr misalignment = address & 0x7;
    gpr masked_value = initial_value & ~(0xFFFFFFFFFFFFFFFFu >> (56 - misalignment * 8));
    loaded_value >>= (56 - misalignment * 8);

    return masked_value | loaded_value;
}

static inline void do_sdl(uint8_t* rdram, gpr offset, gpr reg, gpr val) {
    // Calculate the overall address
    gpr address = (offset + reg);

    // Get the initial value of the aligned dword
    gpr dword_address = address & ~0x7;
    uint64_t initial_value = load_doubleword(rdram, 0, dword_address);

    // Mask the initial value and shift the input value appropriately
    gpr misalignment = address & 0x7;
    uint64_t masked_initial_value = initial_value & ~(0xFFFFFFFFFFFFFFFFu >> (misalignment * 8));
    uint64_t shifted_input_value = val >> (misalignment * 8);

    uint64_t ret = masked_initial_value | shifted_input_value;
    uint32_t lo = (uint32_t)ret;
    uint32_t hi = (uint32_t)(ret >> 32);

    MEM_W(0, dword_address + 4) = lo;
    MEM_W(0, dword_address + 0) = hi;
}

static inline void do_sdr(uint8_t* rdram, gpr offset, gpr reg, gpr val) {
    // Calculate the overall address
    gpr address = (offset + reg);

    // Get the initial value of the aligned dword
    gpr dword_address = address & ~0x7;
    uint64_t initial_value = load_doubleword(rdram, 0, dword_address);

    // Mask the initial value and shift the input value appropriately
    gpr misalignment = address & 0x7;
    uint64_t masked_initial_value = initial_value & ~(0xFFFFFFFFFFFFFFFFu << (56 - misalignment * 8));
    uint64_t shifted_input_value = val << (56 - misalignment * 8);
    
    uint64_t ret = masked_initial_value | shifted_input_value;
    uint32_t lo = (uint32_t)ret;
    uint32_t hi = (uint32_t)(ret >> 32);

    MEM_W(0, dword_address + 4) = lo;
    MEM_W(0, dword_address + 0) = hi;
}

static inline uint32_t get_cop1_cs() {
    uint32_t rounding_mode = 0;
    switch (fegetround()) {
        // round to nearest value
        case FE_TONEAREST:
        default:
            rounding_mode = 0;
            break;
        // round to zero (truncate)
        case FE_TOWARDZERO:
            rounding_mode = 1;
            break;
        // round to positive infinity (ceil)
        case FE_UPWARD:
            rounding_mode = 2;
            break;
        // round to negative infinity (floor)
        case FE_DOWNWARD:
            rounding_mode = 3;
            break;
    }
    return rounding_mode;
}

static inline void set_cop1_cs(uint32_t val) {
    uint32_t rounding_mode = val & 0x3;
    int round = FE_TONEAREST;
    switch (rounding_mode) {
        case 0: // round to nearest value
            round = FE_TONEAREST;
            break;
        case 1: // round to zero (truncate)
            round = FE_TOWARDZERO;
            break;
        case 2: // round to positive infinity (ceil)
            round = FE_UPWARD;
            break;
        case 3: // round to negative infinity (floor)
            round = FE_DOWNWARD;
            break;
    }
    fesetround(round);
}

#define S32(val) \
    ((int32_t)(val))
    
#define U32(val) \
    ((uint32_t)(val))

#define S64(val) \
    ((int64_t)(val))

#define U64(val) \
    ((uint64_t)(val))

#define MUL_S(val1, val2) \
    ((val1) * (val2))

#define MUL_D(val1, val2) \
    ((val1) * (val2))

#define DIV_S(val1, val2) \
    ((val1) / (val2))

#define DIV_D(val1, val2) \
    ((val1) / (val2))

#define CVT_S_W(val) \
    ((float)((int32_t)(val)))

#define CVT_D_W(val) \
    ((double)((int32_t)(val)))

#define CVT_D_L(val) \
    ((double)((int64_t)(val)))

#define CVT_S_L(val) \
    ((float)((int64_t)(val)))

#define CVT_D_S(val) \
    ((double)(val))

#define CVT_S_D(val) \
    ((float)(val))

#define TRUNC_W_S(val) \
    ((int32_t)(val))

#define TRUNC_W_D(val) \
    ((int32_t)(val))

#define TRUNC_L_S(val) \
    ((int64_t)(val))

#define TRUNC_L_D(val) \
    ((int64_t)(val))

#define DEFAULT_ROUNDING_MODE 0

static inline int32_t do_cvt_w_s(float val) {
    // Rounding mode aware float to 32-bit int conversion.
    return (int32_t)lrintf(val);
}

#define CVT_W_S(val) \
    do_cvt_w_s(val)

static inline int64_t do_cvt_l_s(float val) {
    // Rounding mode aware float to 64-bit int conversion.
    return (int64_t)llrintf(val);
}

#define CVT_L_S(val) \
    do_cvt_l_s(val);

static inline int32_t do_cvt_w_d(double val) {
    // Rounding mode aware double to 32-bit int conversion.
    return (int32_t)lrint(val);
}

#define CVT_W_D(val) \
    do_cvt_w_d(val)

static inline int64_t do_cvt_l_d(double val) {
    // Rounding mode aware double to 64-bit int conversion.
    return (int64_t)llrint(val);
}

#define CVT_L_D(val) \
    do_cvt_l_d(val)

#define NAN_CHECK(val) \
    assert(val == val)

//#define NAN_CHECK(val)

typedef union {
    double d;
    struct {
        float fl;
        float fh;
    };
    struct {
        uint32_t u32l;
        uint32_t u32h;
    };
    uint64_t u64;
} fpr;

typedef struct {
    gpr r0,  r1,  r2,  r3,  r4,  r5,  r6,  r7,
        r8,  r9,  r10, r11, r12, r13, r14, r15,
        r16, r17, r18, r19, r20, r21, r22, r23,
        r24, r25, r26, r27, r28, r29, r30, r31;
    fpr f0,  f1,  f2,  f3,  f4,  f5,  f6,  f7,
        f8,  f9,  f10, f11, f12, f13, f14, f15,
        f16, f17, f18, f19, f20, f21, f22, f23,
        f24, f25, f26, f27, f28, f29, f30, f31;
    uint64_t hi, lo;
    uint32_t* f_odd;
    uint32_t status_reg;
    uint8_t mips3_float_mode;
    // COP1 condition code (FCR31 bit 23). MUST live in the context, not in a function-local.
    // (2026-08-28, KI Gold.) cgenerator used to emit `int c1cs = 0;` at the top of every function,
    // so the condition could not survive a call — and the interpreter kept its own thread-local,
    // so native and interpreted disagreed as well. Real code DOES flow a condition across a
    // boundary: KI Gold's func_80040440 is nothing but `c.lt.d $f2,$f12`, existing purely to set
    // the condition that the code at +4 tests with `bc1fl`. With a per-function local that test
    // always read 0, took the wrong branch, and hung the FP normalise loop at 0x800404C4.
    // Holding it here makes it behave like every other register: it persists across calls and is
    // shared by both execution tiers. Placed last so the field is purely additive.
    uint32_t c1cs;
} recomp_context;

// Checks if the target is an even float register or that mips3 float mode is enabled
#define CHECK_FR(ctx, idx) \
    assert(((idx) & 1) == 0 || (ctx)->mips3_float_mode)

#ifdef __cplusplus
extern "C" {
#endif

void cop0_status_write(recomp_context* ctx, gpr value);
gpr cop0_status_read(recomp_context* ctx);
// Count (cop0 reg 9): VR4300 cycle counter, read/written inline for timing/RNG (game-agnostic).
gpr cop0_count_read(recomp_context* ctx);
void cop0_count_write(recomp_context* ctx, gpr value);
// TLB (LLE) — cop0 TLB-register access + TLB instructions emitted by the recompiler.
void recomp_cop0_tlb_write(int reg, uint32_t value);
uint32_t recomp_cop0_tlb_read(int reg);
// ERET context switch for bare-metal cooperative schedulers (the NC class); see librecomp/baremetal_sched.cpp.
void recomp_eret(uint8_t* rdram, recomp_context* ctx);
void recomp_tlbwi(void);
void recomp_tlbwr(void);
void recomp_tlbp(void);
void recomp_tlbr(void);
void recomp_tlb_map(uint32_t vaddr, uint32_t paddr, uint32_t size);
uint32_t recomp_tlb_translate(uint32_t vaddr);
void switch_error(const char* func, uint32_t vram, uint32_t jtbl);
void do_break(uint32_t vram);

// The function signature for all recompiler output functions.
typedef void (recomp_func_t)(uint8_t* rdram, recomp_context* ctx);
// The function signature for special functions that need a third argument.
// These get called via generated shims to allow providing some information about the caller, such as mod id.
typedef void (recomp_func_ext_t)(uint8_t* rdram, recomp_context* ctx, uintptr_t arg);

recomp_func_t* get_function(int32_t vram);

#define LOOKUP_FUNC(val) \
    get_function((int32_t)(val))

// Live-gap dispatch (recomp_live_gap.cpp): JIT + run code that lives in RDRAM at a vram at runtime.
// Used by analyze-stub functions whose STATIC bytes are data but whose real code is decompressed/loaded
// into RDRAM at runtime (e.g. Blast Corps' main-thread entry func_80244930 — the static ROM holds a data
// table there, the game loads code over it before jumping). Fail-safe: gap_function_length returns 0 and
// the trampoline is a silent no-op if the runtime bytes aren't a valid function (identical to an empty stub).
#ifdef __cplusplus
extern "C" {
#endif
void recomp_live_gap_set_target(uint32_t vaddr);
void recomp_live_gap_trampoline(uint8_t* rdram, recomp_context* ctx);

// Runtime-provided natives that generated code may call without a funcs.h declaration (from-ROM
// ports whose symbol lists HLE these; definitions live in librecomp ultra_stubs.cpp +
// ultra_optional_natives.cpp — the latter is app-overridable via static-lib pull semantics).
void osMapTLB_recomp(uint8_t* rdram, recomp_context* ctx);
void osUnmapTLBAll_recomp(uint8_t* rdram, recomp_context* ctx);
void __osProbeTLB_recomp(uint8_t* rdram, recomp_context* ctx);   // impl: librecomp/src/ultra_translation.cpp (Pilotwings is the first of our recomps to call it; gcc errors on the missing prototype where MSVC only warns)
// PI / EPI WORD IO AND DMA (impl: librecomp/src/pi.cpp, added 2026-09-02 as an engine capability).
// These were defined and never declared, which is the same trap as __osProbeTLB above and cost the
// same way: MSVC only warns on an implicit declaration, so every exe build was fine, while the
// MODULE build uses the bundled clang, where "ISO C99 and later do not support implicit function
// declarations" is a hard error. Legend of the Dragoon's module failed to compile on
// osPiRawWriteIo_recomp alone (the 09-08 playtest). An implicitly declared call also gets an
// assumed signature, so the ones that "worked" under MSVC were only working by x64 register luck.
// If you add a *_recomp entry point to librecomp, declare it HERE in the same commit.
void osPiRawStartDma_recomp(uint8_t* rdram, recomp_context* ctx);
void osPiStartDma_recomp(uint8_t* rdram, recomp_context* ctx);
void osPiGetStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void osPiReadIo_recomp(uint8_t* rdram, recomp_context* ctx);
void osPiWriteIo_recomp(uint8_t* rdram, recomp_context* ctx);
void osPiRawReadIo_recomp(uint8_t* rdram, recomp_context* ctx);
void osPiRawWriteIo_recomp(uint8_t* rdram, recomp_context* ctx);
void osEPiRawStartDma_recomp(uint8_t* rdram, recomp_context* ctx);
void osEPiStartDma_recomp(uint8_t* rdram, recomp_context* ctx);
void osEPiReadIo_recomp(uint8_t* rdram, recomp_context* ctx);
void osEPiWriteIo_recomp(uint8_t* rdram, recomp_context* ctx);
void osLeoDiskInit_recomp(uint8_t* rdram, recomp_context* ctx);

void __checkHardware_isv_recomp(uint8_t* rdram, recomp_context* ctx);
void __checkHardware_kmc_recomp(uint8_t* rdram, recomp_context* ctx);
void __checkHardware_msp_recomp(uint8_t* rdram, recomp_context* ctx);
void __divdi3_recomp(uint8_t* rdram, recomp_context* ctx);
void __f_to_ll_recomp(uint8_t* rdram, recomp_context* ctx);
void __ll_div_recomp(uint8_t* rdram, recomp_context* ctx);
void __ll_mul_recomp(uint8_t* rdram, recomp_context* ctx);
void __ll_to_d_recomp(uint8_t* rdram, recomp_context* ctx);
void __ll_to_f_recomp(uint8_t* rdram, recomp_context* ctx);
void __osCheckId_recomp(uint8_t* rdram, recomp_context* ctx);
void __osCheckPackId_recomp(uint8_t* rdram, recomp_context* ctx);
void __osContRamRead_recomp(uint8_t* rdram, recomp_context* ctx);
void __osContRamWrite_recomp(uint8_t* rdram, recomp_context* ctx);
void __osDisableInt_recomp(uint8_t* rdram, recomp_context* ctx);
void __osInitialize_common_recomp(uint8_t* rdram, recomp_context* ctx);
void __osInitialize_isv_recomp(uint8_t* rdram, recomp_context* ctx);
void __osInitialize_kmc_recomp(uint8_t* rdram, recomp_context* ctx);
void __osInitialize_msp_recomp(uint8_t* rdram, recomp_context* ctx);
void __osMotorAccess_recomp(uint8_t* rdram, recomp_context* ctx);
void __osPfsGetStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void __osPfsRWInode_recomp(uint8_t* rdram, recomp_context* ctx);
void __osPfsSelectBank_recomp(uint8_t* rdram, recomp_context* ctx);
void __osPiGetAccess_recomp(uint8_t* rdram, recomp_context* ctx);
void __osPiRelAccess_recomp(uint8_t* rdram, recomp_context* ctx);
void __osRdbSend_recomp(uint8_t* rdram, recomp_context* ctx);
void __osRepairPackId_recomp(uint8_t* rdram, recomp_context* ctx);
void __osRestoreInt_recomp(uint8_t* rdram, recomp_context* ctx);
void __osSetCompare_recomp(uint8_t* rdram, recomp_context* ctx);
void __osSetFpcCsr_recomp(uint8_t* rdram, recomp_context* ctx);
void __osSiGetAccess_recomp(uint8_t* rdram, recomp_context* ctx);
void __osSiRelAccess_recomp(uint8_t* rdram, recomp_context* ctx);
void __osSpGetStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void __osSpSetPc_recomp(uint8_t* rdram, recomp_context* ctx);
void __osSpSetStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void __udivdi3_recomp(uint8_t* rdram, recomp_context* ctx);
void __ull_div_recomp(uint8_t* rdram, recomp_context* ctx);
void __ull_rem_recomp(uint8_t* rdram, recomp_context* ctx);
void __ull_rshift_recomp(uint8_t* rdram, recomp_context* ctx);
void __ull_to_d_recomp(uint8_t* rdram, recomp_context* ctx);
void __ull_to_f_recomp(uint8_t* rdram, recomp_context* ctx);
void __umoddi3_recomp(uint8_t* rdram, recomp_context* ctx);
void isPrintfInit_recomp(uint8_t* rdram, recomp_context* ctx);
void is_proutSyncPrintf_recomp(uint8_t* rdram, recomp_context* ctx);
void longjmp_recomp(uint8_t* rdram, recomp_context* ctx);
void osAiGetLength_recomp(uint8_t* rdram, recomp_context* ctx);
void osAiGetStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void osAiSetFrequency_recomp(uint8_t* rdram, recomp_context* ctx);
void osAiSetNextBuffer_recomp(uint8_t* rdram, recomp_context* ctx);
void osCartRomInit_recomp(uint8_t* rdram, recomp_context* ctx);
void osContGetQuery_recomp(uint8_t* rdram, recomp_context* ctx);
void osContGetReadData_recomp(uint8_t* rdram, recomp_context* ctx);
void osContInit_recomp(uint8_t* rdram, recomp_context* ctx);
void osContReset_recomp(uint8_t* rdram, recomp_context* ctx);
void osContSetCh_recomp(uint8_t* rdram, recomp_context* ctx);
void osContStartQuery_recomp(uint8_t* rdram, recomp_context* ctx);
void osContStartReadData_recomp(uint8_t* rdram, recomp_context* ctx);
void osCreateMesgQueue_recomp(uint8_t* rdram, recomp_context* ctx);
void osCreatePiManager_recomp(uint8_t* rdram, recomp_context* ctx);
void osCreateThread_recomp(uint8_t* rdram, recomp_context* ctx);
void osCreateViManager_recomp(uint8_t* rdram, recomp_context* ctx);
void osDestroyThread_recomp(uint8_t* rdram, recomp_context* ctx);
void osDpGetCounters_recomp(uint8_t* rdram, recomp_context* ctx);
void osDpGetStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void osDpSetNextBuffer_recomp(uint8_t* rdram, recomp_context* ctx);
void osDpSetStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void osDriveRomInit_recomp(uint8_t* rdram, recomp_context* ctx);
void osEepromLongRead_recomp(uint8_t* rdram, recomp_context* ctx);
void osEepromLongWrite_recomp(uint8_t* rdram, recomp_context* ctx);
void osEepromProbe_recomp(uint8_t* rdram, recomp_context* ctx);
void osEepromRead_recomp(uint8_t* rdram, recomp_context* ctx);
void osEepromWrite_recomp(uint8_t* rdram, recomp_context* ctx);
void osExQueueDisplaylistEvent_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashAllEraseThrough_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashAllErase_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashChange_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashCheckEraseEnd_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashClearStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashInit_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashReadArray_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashReadId_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashReadStatus_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashSectorEraseThrough_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashSectorErase_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashWriteArray_recomp(uint8_t* rdram, recomp_context* ctx);
void osFlashWriteBuffer_recomp(uint8_t* rdram, recomp_context* ctx);
void osGetCount_recomp(uint8_t* rdram, recomp_context* ctx);
void osGetMemSize_recomp(uint8_t* rdram, recomp_context* ctx);
void osGetThreadId_recomp(uint8_t* rdram, recomp_context* ctx);
void osGetThreadPri_recomp(uint8_t* rdram, recomp_context* ctx);
void osGetTime_recomp(uint8_t* rdram, recomp_context* ctx);
void osInitialize_recomp(uint8_t* rdram, recomp_context* ctx);
void osInvalDCache_recomp(uint8_t* rdram, recomp_context* ctx);
void osInvalICache_recomp(uint8_t* rdram, recomp_context* ctx);
void osJamMesg_recomp(uint8_t* rdram, recomp_context* ctx);
void osMotorInit_recomp(uint8_t* rdram, recomp_context* ctx);
void osMotorStart_recomp(uint8_t* rdram, recomp_context* ctx);
void osMotorStop_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsAllocateFile_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsChecker_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsDeleteFile_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsFileState_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsFindFile_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsFreeBlocks_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsInitPak_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsInit_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsIsPlug_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsNumFiles_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsReadWriteFile_recomp(uint8_t* rdram, recomp_context* ctx);
void osPfsRepairId_recomp(uint8_t* rdram, recomp_context* ctx);
void osRecvMesg_recomp(uint8_t* rdram, recomp_context* ctx);
void osSendMesg_recomp(uint8_t* rdram, recomp_context* ctx);
void osSetCount_recomp(uint8_t* rdram, recomp_context* ctx);
void osSetEventMesg_recomp(uint8_t* rdram, recomp_context* ctx);
void osSetIntMask_recomp(uint8_t* rdram, recomp_context* ctx);
void osSetThreadPri_recomp(uint8_t* rdram, recomp_context* ctx);
void osSetTime_recomp(uint8_t* rdram, recomp_context* ctx);
void osSetTimer_recomp(uint8_t* rdram, recomp_context* ctx);
void osSpTaskLoad_recomp(uint8_t* rdram, recomp_context* ctx);
void osSpTaskStartGo_recomp(uint8_t* rdram, recomp_context* ctx);
void osSpTaskYield_recomp(uint8_t* rdram, recomp_context* ctx);
void osSpTaskYielded_recomp(uint8_t* rdram, recomp_context* ctx);
void osStartThread_recomp(uint8_t* rdram, recomp_context* ctx);
void osStopThread_recomp(uint8_t* rdram, recomp_context* ctx);
void osStopTimer_recomp(uint8_t* rdram, recomp_context* ctx);
void osViBlack_recomp(uint8_t* rdram, recomp_context* ctx);
void osViGetCurrentFramebuffer_recomp(uint8_t* rdram, recomp_context* ctx);
void osViGetNextFramebuffer_recomp(uint8_t* rdram, recomp_context* ctx);
void osViRepeatLine_recomp(uint8_t* rdram, recomp_context* ctx);
void osViSetEvent_recomp(uint8_t* rdram, recomp_context* ctx);
void osViSetMode_recomp(uint8_t* rdram, recomp_context* ctx);
void osViSetSpecialFeatures_recomp(uint8_t* rdram, recomp_context* ctx);
void osViSetXScale_recomp(uint8_t* rdram, recomp_context* ctx);
void osViSetYScale_recomp(uint8_t* rdram, recomp_context* ctx);
void osViSwapBuffer_recomp(uint8_t* rdram, recomp_context* ctx);
void osVirtualToPhysical_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceCheckWord_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceClearDictionary_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceControlGain_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceGetReadData_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceInit_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceMaskDictionary_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceSetWord_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceStartReadData_recomp(uint8_t* rdram, recomp_context* ctx);
void osVoiceStopReadData_recomp(uint8_t* rdram, recomp_context* ctx);
void osWritebackDCacheAll_recomp(uint8_t* rdram, recomp_context* ctx);
void osWritebackDCache_recomp(uint8_t* rdram, recomp_context* ctx);
void osYieldThread_recomp(uint8_t* rdram, recomp_context* ctx);
void send_recomp(uint8_t* rdram, recomp_context* ctx);
void setjmp_recomp(uint8_t* rdram, recomp_context* ctx);
void string_to_u32_recomp(uint8_t* rdram, recomp_context* ctx);
void __osGetCause_recomp(uint8_t* rdram, recomp_context* ctx);
void __osSiRawStartDma_recomp(uint8_t* rdram, recomp_context* ctx);
void __d_to_ull_recomp(uint8_t* rdram, recomp_context* ctx);
void __ll_lshift_recomp(uint8_t* rdram, recomp_context* ctx);
#ifdef __cplusplus
}
#endif

extern int32_t* section_addresses;

#define LO16(x) \
    ((x) & 0xFFFF)

#define HI16(x) \
    (((x) >> 16) + (((x) >> 15) & 1))

#define RELOC_HI16(section_index, offset) \
    HI16(section_addresses[section_index] + (offset))

#define RELOC_LO16(section_index, offset) \
    LO16(section_addresses[section_index] + (offset))

void recomp_syscall_handler(uint8_t* rdram, recomp_context* ctx, int32_t instruction_vram);

void pause_self(uint8_t *rdram, uint32_t pc_vram);   // pc_vram = the guest halt-loop (`b .`) instruction, latched as EPC for bare-metal drains
void yield_self_1ms(uint8_t *rdram, uint32_t pc_vram);   // pc_vram = the guard's back-edge instruction, latched as EPC for bare-metal drains
void yield_self_poll(uint8_t *rdram, uint32_t func_vram, uint32_t ra, uint32_t pc_vram);   // non-blocking cooperative yield; func_vram + caller ra for [yieldpoll]; pc_vram as above
// [legacy-arity 2026-09-02] Emissions that predate the ra / pc_vram parameters (hand-curated Rare overlay_funcs, the
// 2026-07 RecompiledFuncsRAM merges of Banjo/DK64, anything emitted by an older N64Recomp.exe) call the SHORT forms.
// The engine accepts every arity so one header keeps every emission linking; a short form behaves exactly as it did
// before the parameter existed (no EPC latch, no [yieldpoll] pc). Dispatch is by argument count, C files only.
void yield_self_poll_legacy3(uint8_t *rdram, uint32_t func_vram, uint32_t ra);
void yield_self_1ms_legacy1(uint8_t *rdram);
void pause_self_legacy1(uint8_t *rdram);
#ifndef __cplusplus
#define RECOMP_ARITY_EXPAND(x) x
#define RECOMP_ARITY_PICK4(_1,_2,_3,_4,NAME,...) NAME
#define yield_self_poll(...) RECOMP_ARITY_EXPAND(RECOMP_ARITY_PICK4(__VA_ARGS__, yield_self_poll, yield_self_poll_legacy3, yield_self_poll_legacy3, yield_self_poll_legacy3, 0)(__VA_ARGS__))
#define yield_self_1ms(...)  RECOMP_ARITY_EXPAND(RECOMP_ARITY_PICK4(__VA_ARGS__, yield_self_1ms, yield_self_1ms, yield_self_1ms, yield_self_1ms_legacy1, 0)(__VA_ARGS__))
#define pause_self(...)      RECOMP_ARITY_EXPAND(RECOMP_ARITY_PICK4(__VA_ARGS__, pause_self, pause_self, pause_self, pause_self_legacy1, 0)(__VA_ARGS__))
#endif
// [coswitch 2026-09-01] guest coroutine switch (librecomp/src/coswitch.cpp): emitted for the `jr` of a function that loads $sp from memory.
jmp_buf* recomp_coswitch_savepoint(uint8_t* rdram, recomp_context* ctx, uint32_t block);   // registers the running context under its block; the emitted frame then setjmp()s into the returned buffer (NULL = declined)
void recomp_cache_op(uint8_t* rdram, recomp_context* ctx, uint32_t op, uint32_t vaddr);   // [icache-ghost 2026-09-03] native CACHE instruction -> ghost line sync (recomp_interp.cpp)
int recomp_coswitch(uint8_t* rdram, recomp_context* ctx, uint32_t block, uint32_t target);   // switch to the context saved under `block` (or a fresh one at a function entry); 1 = resumed here without a savepoint (return now); 0 = declined (do the jr's original action)
// [pollguard 2026-08-26] live count of RCP interrupts the game thread still owes a drain;
// the emitted poll guard consults it (peek only, never clears).
int recomp_baremetal_peek_pending(void);
void recomp_dbg_trace(uint8_t* rdram, uint32_t id);   // [fn] PD wedge probe (temporary) — logs entry of an instrumented func for the running thread
void recomp_dbg_val(uint8_t* rdram, uint32_t a, uint32_t b, uint32_t c);   // [val] PD logo-loop probe (temporary)

#ifdef __cplusplus
}
#endif

#endif
