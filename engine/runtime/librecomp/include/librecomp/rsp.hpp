#ifndef __RSP_H__
#define __RSP_H__

#include <cstdio>
#include <mutex>
#include <vector>

#include "rsp_vu.hpp"
#include "recomp.h"
#include "ultramodern/ultra64.h"

// TODO: Move these to recomp namespace?

enum class RspExitReason {
    Invalid,
    Broke,
    ImemOverrun,
    UnhandledJumpTarget,
    Unsupported,
    SwapOverlay,
    UnhandledResumeTarget
};

struct RspContext {
    uint32_t      r1,  r2,  r3,  r4,  r5,  r6,  r7,
             r8,  r9,  r10, r11, r12, r13, r14, r15,
             r16, r17, r18, r19, r20, r21, r22, r23,
             r24, r25, r26, r27, r28, r29, r30, r31;
    uint32_t dma_mem_address;
    uint32_t dma_dram_address;
    uint32_t jump_target;
    RSP rsp;
    uint32_t resume_address;
    bool resume_delay;
};

using RspUcodeFunc = RspExitReason(uint8_t* rdram, uint32_t ucode_addr);

extern uint8_t dmem[];
extern uint16_t rspReciprocals[512];
extern uint16_t rspInverseSquareRoots[512];

#define RSP_MEM_B(offset, addr) \
    (*reinterpret_cast<int8_t*>(dmem + (0xFFF & (((offset) + (addr)) ^ 3))))

#define RSP_MEM_BU(offset, addr) \
    (*reinterpret_cast<uint8_t*>(dmem + (0xFFF & (((offset) + (addr)) ^ 3))))

static inline uint32_t RSP_MEM_W_LOAD(uint32_t offset, uint32_t addr) {
    uint32_t out;
    for (int i = 0; i < 4; i++) {
        reinterpret_cast<uint8_t*>(&out)[i ^ 3] = RSP_MEM_BU(offset + i, addr);
    }
    return out;
}

// RECOMP-side DMEM store watch (RSP_DMEM_WATCH_RC=<hex>, F3DEX2 divergence hunt 2026-07-24):
// mirror of the interp's scalar watch, for the generated code's word stores. Inert unless set.
inline int g_rsp_vutrace_phase = 'A';   // A/B phase tag (oracle harness sets it between runs)
inline int g_rsp_rcwatch = -2;   // -2 unparsed, -1 off, else the watched DMEM address
static inline void RSP_MEM_W_STORE(uint32_t offset, uint32_t addr, uint32_t val) {
    for (int i = 0; i < 4; i++) {
        RSP_MEM_BU(offset + i, addr) = reinterpret_cast<uint8_t*>(&val)[i ^ 3];
    }
    if (g_rsp_rcwatch == -2) {
        const char* e = getenv("RSP_DMEM_WATCH_RC");
        g_rsp_rcwatch = e ? (int)strtoul(e, nullptr, 16) : -1;
    }
    if (g_rsp_rcwatch >= 0) {
        uint32_t a = (offset + addr) & 0xFFF;
        if ((uint32_t)g_rsp_rcwatch >= a && (uint32_t)g_rsp_rcwatch < a + 4) {
            fprintf(stderr, "[rcwatch] store4 dmem=0x%03X val=0x%08X\n", a, val);
        }
    }
}

static inline uint32_t RSP_MEM_HU_LOAD(uint32_t offset, uint32_t addr) {
    uint16_t out;
    for (int i = 0; i < 2; i++) {
        reinterpret_cast<uint8_t*>(&out)[(i + 2) ^ 3] = RSP_MEM_BU(offset + i, addr);
    }
    return out;
}

static inline uint32_t RSP_MEM_H_LOAD(uint32_t offset, uint32_t addr) {
    int16_t out;
    for (int i = 0; i < 2; i++) {
        reinterpret_cast<uint8_t*>(&out)[(i + 2) ^ 3] = RSP_MEM_BU(offset + i, addr);
    }
    return out;
}

static inline void RSP_MEM_H_STORE(uint32_t offset, uint32_t addr, uint32_t val) {
    for (int i = 0; i < 2; i++) {
        RSP_MEM_BU(offset + i, addr) = reinterpret_cast<uint8_t*>(&val)[(i + 2) ^ 3];
    }
}

#define RSP_ADD32(a, b) \
    ((int32_t)((a) + (b)))

#define RSP_SUB32(a, b) \
    ((int32_t)((a) - (b)))

#define RSP_SIGNED(val) \
    ((int32_t)(val))

// CV64 Brick 3 (graphics-ucode LLE): the RSP SP_MEM_ADDR register is 13 bits — bit 12 selects
// DMEM(0)/IMEM(1), bits 0-11 are the offset; the hardware masks the rest on write. F3DEX2 computes
// DMA addresses by OR-ing in base pointers that carry garbage high bits (which HW discards), so the
// recompiled value must be masked to 0x1FFF or the DMA guards reject it (dmem=0x6E040E0 etc.) and
// vertex loads / the RDP-command FIFO write never land -> no triangles. No-op for the audio ucode
// (its SP_MEM_ADDR values are already in range). Preserves bit 12 for the overlay-swap check.
#define SET_DMA_MEM(mem_addr) dma_mem_address = ((mem_addr) & 0x1FFF)
#define SET_DMA_DRAM(dram_addr) dma_dram_address = (dram_addr)
#define DO_DMA_READ(rd_len) dma_rdram_to_dmem(rdram, dma_mem_address, dma_dram_address, (rd_len))
#define DO_DMA_WRITE(wr_len) dma_dmem_to_rdram(rdram, dma_mem_address, dma_dram_address, (wr_len))

// CV64 Brick 3 (graphics-ucode LLE): the DP command FIFO. A recompiled graphics ucode (F3DEX2)
// pushes RDP commands by writing the FIFO range to the DPC COP0 registers: SP-style START sets the
// base (and the modeled RDP read pointer), END kicks/extends it. We model the RDP as consuming
// instantly (current == end after each kick) so the ucode's FIFO-management polling proceeds, and
// CAPTURE each [current, end] RDRAM range as the faithful RDP command stream via
// rsp_process_rdp_commands (Phase D will route it to an RDP). These are globals (not RspContext
// fields) because the RDP is a single unit and the capture is a side effect — so they also persist
// correctly across overlay swaps without ctx save/restore plumbing. General to any gfx-ucode LLE.
extern uint32_t g_rsp_dpc_start;
extern uint32_t g_rsp_dpc_end;
extern uint32_t g_rsp_dpc_current;
// C LINKAGE, deliberately. This one is called from RECOMPILED MICROCODE (the DO_DP_END macro just
// below), which a game module compiles with llvm-mingw while the host compiles with MSVC. The two
// use different C++ name manglings, so a C++-linkage declaration can never link across that
// boundary no matter what the host exports. Found 2026-09-07 on AeroGauge: every other RSP symbol
// resolved because Itanium leaves global VARIABLES unmangled - this is the only FUNCTION crossing.
extern "C" {
void rsp_process_rdp_commands(uint8_t* rdram, uint32_t start, uint32_t end);
}

// ORACLE-RIG CAPTURE (2026-07-11, ported from the RESTART bench after that tree was retired —
// fresh code, ledgered in N64PC/DESKTOP_BENCH.md): capture-to-buffer for one gfx task. When armed,
// rsp_process_rdp_commands appends each plausible [start,end) range's bytes UN-^3-SWIZZLED (N64
// physical byte order, the N64RDPC1 container convention). Inert unless armed; armed only by the
// RDPC_CAPTURE_CHAIN hook (compiled out of default builds).
void rdpc_stream_begin();
const std::vector<uint8_t>& rdpc_stream_take();   // disarms and returns the accumulated stream

// Diagnostic trace written by RSPRecomp-generated ucode (our tool emits ring stores at each
// indirect jump and records the break site): last 64 jump targets + the vram of the break that
// ended the run. Read-only for hooks.
extern uint32_t g_rsp_jump_ring[64];
extern uint32_t g_rsp_jump_ring_idx;
extern uint32_t g_rsp_break_vram;

#define SET_DP_START(start_addr) (g_rsp_dpc_start = g_rsp_dpc_current = (start_addr))
#define DO_DP_END(end_addr) do { \
        g_rsp_dpc_end = (end_addr); \
        rsp_process_rdp_commands(rdram, g_rsp_dpc_current, g_rsp_dpc_end); \
        g_rsp_dpc_current = g_rsp_dpc_end; \
    } while (0)

static inline void dma_rdram_to_dmem(uint8_t* rdram, uint32_t dmem_addr, uint32_t dram_addr, uint32_t rd_len) {
    rd_len += 1; // Read length is inclusive
    /* THE RSP DMA MOVES WHOLE 8-BYTE UNITS: hardware rounds the transfer length UP to the next
     * multiple of 8 (SP_RD_LEN counts bytes-1, but the engine only ever moves 64-bit words).
     * Without this rounding, F3DEX2's 16-byte gsSPViewport upload — the microcode writes 8, so
     * 9 here and 16 on hardware — delivered only NINE bytes: vscale[4] landed, and vtrans[4] did
     * not. The lost Y translate displaced every 3D vertex up by 120px in EVERY F3DEX2 game
     * (cv64, nightmare, DK64): the camera was in the wrong place (2026-07-31).
     * Measured: viewport DMA traced at len=9; vtrans_x kept only its high byte (640 -> 512),
     * vtrans_y/z never arrived. */
    rd_len = (rd_len + 7u) & ~7u;
    uint32_t cv64_raw_dram = dram_addr; // cv64 probe: pre-mask source
    { const char* _t = getenv("RSPDMA_TRACE"); if (_t && _t[0]=='1') { static int _n=0; if (_n<400) { fprintf(stderr,"[rspdma-%c] #%d dmem=0x%03X dram_raw=0x%08X len=%u\n",(char)g_rsp_vutrace_phase,_n,dmem_addr,cv64_raw_dram,rd_len); fflush(stderr); _n++; } } }
    // cv64 Phase B-guard (session 14): drop DMAs whose computed length would overflow DMEM.
    // KCEK aspMain handlers, on a cold/wrong DMEM state, can compute negative-as-unsigned
    // lengths (e.g. 0xFFFFFFEF). Without this guard the read loop tries to copy ~4GB and
    // crashes the host. Logging + drop keeps the runtime stable while we observe handler
    // behavior. Real DMAs are bounded by DMEM size (0x1000).
    if (rd_len > 0x1000 || dmem_addr + rd_len > 0x1000) {
        static int _cv64_drop = 0;
        if (++_cv64_drop <= 16) {
            fprintf(stderr, "[rsp_dma_guard] DROP rd_len=%u dmem=0x%03X dram=0x%08X (would overflow)\n",
                    rd_len, dmem_addr, cv64_raw_dram);
            fflush(stderr);
        }
        return;
    }
    dram_addr &= 0xFFFFF8;
    assert(dmem_addr + rd_len <= 0x1000);
    for (uint32_t i = 0; i < rd_len; i++) {
        RSP_MEM_B(i, dmem_addr) = MEM_B(0, (int64_t)(int32_t)(dram_addr + i + 0x80000000));
    }
    // cv64 (session 13): trace RSP DMA reads. Is the audio command list (dest DMEM ~0x380)
    // ever loaded, from what source, and is the source non-zero?
    {
        static int _cv64_dma = 0; _cv64_dma++;
        if (_cv64_dma <= 48) {
            uint32_t w0 = (rd_len >= 4) ? MEM_W(0, (int64_t)(int32_t)(dram_addr + 0x80000000)) : 0;
            fprintf(stderr, "[rsp_dma] #%d dmem=0x%03X dram=0x%08X(raw=0x%08X) len=%u src0=0x%08X\n",
                    _cv64_dma, dmem_addr, dram_addr, cv64_raw_dram, rd_len, w0);
            fflush(stderr);
        }
    }
}

static inline void dma_dmem_to_rdram(uint8_t* rdram, uint32_t dmem_addr, uint32_t dram_addr, uint32_t wr_len) {
    wr_len += 1; // Write length is inclusive
    /* Same 8-byte-unit law as the read direction above — the RSP DMA engine has one length
     * register semantic for both. */
    wr_len = (wr_len + 7u) & ~7u;
    uint32_t cv64_raw_dram = dram_addr;
    // cv64 Phase B-guard (session 15, Alucard): guard the WRITE direction too. Until now only
    // dma_rdram_to_dmem (reads) was guarded; dma_dmem_to_rdram had only an assert (compiled out
    // in Release). A KCEK audio handler computing a bad wr_len (e.g. 0xFFFFFFEF) or running on
    // imperfect state would write GIGABYTES past the RDRAM region into host memory — corrupting
    // e.g. the moodycamel message-queue objects and crashing later in an unrelated thread
    // (observed: WRITE 0x10 fault inside ConcurrentQueue::try_dequeue). The source is DMEM
    // (bounded 0x1000), so a sane transfer satisfies dmem_addr + wr_len <= 0x1000. Drop + log
    // anything larger to keep the host stable while we validate the audio synthesis path.
    if (wr_len > 0x1000 || dmem_addr + wr_len > 0x1000) {
        static int _cv64_wdrop = 0;
        if (++_cv64_wdrop <= 16) {
            fprintf(stderr, "[rsp_dma_wguard] DROP wr_len=%u dmem=0x%03X dram=0x%08X (would overflow host)\n",
                    wr_len, dmem_addr, cv64_raw_dram);
            fflush(stderr);
        }
        return;
    }
    dram_addr &= 0xFFFFF8;
    // LOW-DESTINATION PROBE (SOTE osBootInfo clobber hunt, 2026-07-19). The mask above is a
    // ceiling truncation with NO FLOOR: any SP_DRAM_ADDR whose low 24 bits are small aliases onto
    // the IPL3 boot block at physical 0x300 (osTvType/osRomType/osRomBase/osResetType/osMemSize),
    // and the source is DMEM which reads ZEROS when cold — exactly the observed "all zeros"
    // clobber. This write path had no tracing at all, so it was invisible to every existing
    // instrument. Report any transfer landing under 0x1000; always on (cheap, and a write here is
    // never legitimate for a real audio buffer).
    if (dram_addr < 0x1000u) {
        static int _lowdst = 0;
        if (++_lowdst <= 24) {
            fprintf(stderr, "[rsp_dma_lowdst] dram=0x%06X (raw 0x%08X) dmem=0x%03X len=%u -- WRITES LOW RDRAM\n",
                    dram_addr, cv64_raw_dram, dmem_addr, wr_len);
            fflush(stderr);
        }
    }
    assert(dmem_addr + wr_len <= 0x1000);
    for (uint32_t i = 0; i < wr_len; i++) {
        MEM_B(0, (int64_t)(int32_t)(dram_addr + i + 0x80000000)) = RSP_MEM_B(i, dmem_addr);
    }
}

// CV64 Brick 3 (graphics-ucode LLE): serializes the global dmem[] between the audio task thread
// (recomp::rsp::run_task) and the gfx-ucode LLE capture (a different thread). Both recompiled ucodes
// share dmem[], so they must not run concurrently. Defined in librecomp/src/rsp.cpp.
extern std::mutex g_rsp_dmem_mutex;

namespace recomp {
    namespace rsp {
        struct callbacks_t {
            using get_rsp_microcode_t = RspUcodeFunc*(const OSTask* task);

            /**
             * Return a function pointer to the corresponding RSP microcode function for the given `task_type`.
             *
             * The full OSTask (`task` parameter) is passed in case the `task_type` number is not enough information to distinguish out the exact microcode function.
             *
             * This function is allowed to return `nullptr` if no microcode matches the specified task. In this case a message will be printed to stderr and the program will exit.
             */
            get_rsp_microcode_t* get_rsp_microcode;

            // CV64 Brick 3 (Option D): optional gfx-ucode LLE capture hook (run the LLE graphics
            // microcode alongside the HLE renderer to capture the faithful RDP command stream). The
            // hook is responsible for taking g_rsp_dmem_mutex around its dmem[] use. May be null.
            using capture_gfx_t = void(uint8_t* rdram, const OSTask* task);
            capture_gfx_t* capture_gfx = nullptr;
        };

        void set_callbacks(const callbacks_t& callbacks);

        void constants_init();

        bool run_task(uint8_t* rdram, const OSTask* task);

        // CV64 Brick 3: invoke the registered gfx-ucode LLE capture hook (no-op if none). Called from
        // the gfx thread (via ultramodern::rsp::capture_gfx_task).
        void capture_gfx_task(uint8_t* rdram, const OSTask* task);

        // ── UCODE CATALOG REGISTRY (2026-07-24, ENGINE_COMPLETION organ 3) ────────────────────
        // THE ORGAN MECHANISM: the ucode universe is a closed catalog; games EMBED catalog copies
        // and may switch ucodes PER TASK (census: Mario Party 2 ships five gfx ucodes). So the
        // engine dispatches by CONTENT, not by game: hash the task's ucode bytes, look up the
        // prebuilt judged native. Registry empty ⇒ dispatch_ucode returns nullptr and the legacy
        // per-game get_rsp_microcode path runs unchanged (zero behavior change until a game
        // registers members; per-game glue then dies).
        //
        // HASH LAW v1 (fixed sizes BY LAW — OSTask size fields lie; SK1 reports ucode_size=0):
        //   FNV-1a64 over ucode text bytes [0, 0xF80) then ucode_data bytes [0, 0x800),
        //   read from RDRAM at the OSTask's ucode/ucode_data pointers (N64 byte order).
        // The same law computed offline over ROM blobs keys the census table → the census IS the
        // registry manifest. Misses are counted + named ([ucode-miss] hash + task type): the
        // organ's unsupported-counter, and the bootstrap for new registrations.
        uint64_t hash_task_ucode(uint8_t* rdram, const OSTask* task);
        // LAW v1 + PER-MEMBER VERIFY (2026-07-24, SERVED_ROSTER collision witnesses): the key
        // windows are deliberately small (volatile-RAM law), so sibling builds CAN share a key
        // (witnesses: Paper Mario/Pokemon Stadium 2 F3DEX-sibling text-diff @0x3F2; Tetrisphere
        // aspMain-sibling @0xDAF). A member may therefore carry a VERIFY window — FNV over ucode
        // text [verify_off, verify_off+verify_len), N64 byte order, bytes chosen where the
        // witness diverges (real member code ⇒ stable for true members). Key hit + verify
        // mismatch ⇒ MISS (legacy fallback) — mis-dispatch impossible, failure mode is safe.
        void register_ucode(uint64_t hash, const char* name, RspUcodeFunc* fn);
        void register_ucode(uint64_t hash, const char* name, RspUcodeFunc* fn,
                            uint32_t verify_off, uint32_t verify_len, uint64_t verify_fnv);
        RspUcodeFunc* dispatch_ucode(uint8_t* rdram, const OSTask* task);   // nullptr = miss
    }
}

#endif
