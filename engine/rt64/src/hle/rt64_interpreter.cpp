//
// RT64
//

#include "rt64_interpreter.h"

#include <cassert>
#include <cstdlib>

//#define DUMP_DISPLAY_LISTS

namespace RT64 {
    static FILE *displayListFp = nullptr;

    // Interpreter

    Interpreter::Interpreter() {
        state = nullptr;
        hleGBI = nullptr;
        extendedFunction = gbiManager.getExtendedFunction();
    }

    void Interpreter::setup(State *state) {
        this->state = state;
    }

    void Interpreter::loadUCodeGBI(uint32_t textAddress, uint32_t dataAddress, bool resetFromTask) {
        if (!resetFromTask) {
            state->flush();
        }

        const uint32_t AddressMask = 0xFFFFF8;
        const uint32_t maskedTextAddress = textAddress & AddressMask;
        const uint32_t maskedDataAddress = dataAddress & AddressMask;
        if ((UCode.textAddress != maskedTextAddress) || (UCode.dataAddress != maskedDataAddress)) {
            // cv64 SESSION 37: a ucode switch is RARE (CV64 ran one F3DEX2 for 4400+ frames until the
            // Renon-cutscene task carried a different pair). Log every change so the log shows WHO asked
            // for WHAT — task-level re-read (send_dl) vs in-DL G_LOAD_UCODE ([gbi_loaducode]) — before any
            // "no matching GBI" failure.
            static int _gbl = 0;
            if (_gbl++ < 64) {
                fprintf(stderr, "[gbiload] ucode change text 0x%08X->0x%08X data 0x%08X->0x%08X fromTask=%d\n",
                        UCode.textAddress, maskedTextAddress, UCode.dataAddress, maskedDataAddress, resetFromTask ? 1 : 0);
                fflush(stderr);
            }
            hleGBI = gbiManager.getGBIForUCode(state->RDRAM, maskedTextAddress, maskedDataAddress);
            if (hleGBI != nullptr) {
                state->rsp->setGBI(hleGBI);
            }
            else {
                // cv64 SESSION 37 [gbifail]: dump what actually lives at the addresses (byte-swizzled like
                // deduceGBIInformation) — discriminates a real-but-unknown microcode (plausible code/name
                // bytes) from a garbage pointer (the Renon crash printed NO "Detected name" => the data
                // address did not hold a ucode blob).
                static int _gbf = 0;
                if (_gbf++ < 16) {
                    fprintf(stderr, "[gbifail] text=0x%08X data=0x%08X | text bytes:", maskedTextAddress, maskedDataAddress);
                    for (uint32_t k = 0; k < 0x20; k++) fprintf(stderr, "%s%02X", (k % 4) ? "" : " ", state->RDRAM[(maskedTextAddress + k) ^ 3]);
                    fprintf(stderr, " | data bytes:");
                    for (uint32_t k = 0; k < 0x20; k++) fprintf(stderr, "%s%02X", (k % 4) ? "" : " ", state->RDRAM[(maskedDataAddress + k) ^ 3]);
                    fprintf(stderr, "\n");
                    fflush(stderr);
                }
            }

            UCode.textAddress = maskedTextAddress;
            UCode.dataAddress = maskedDataAddress;
        }

        if (hleGBI != nullptr) {
            GBIReset resetFunction = resetFromTask ? hleGBI->resetFromTask : hleGBI->resetFromLoad;
            if (resetFunction != nullptr) {
                resetFunction(state);
            }
        }
    }

    void Interpreter::processRDPLists(uint32_t dlStartAdddress, DisplayList *dlStart, DisplayList *dlEnd) {
        state->dlCpuProfiler.start();

        // Update the state with the current display list address.
        state->displayListAddress = dlStartAdddress;
        state->displayListCounter++;

        // Check RDRAM if required.
        state->checkRDRAM();

        GBI *rdpGBI = state->rdp->gbi;
        constexpr unsigned int opCodeMask = 0x3F;

        // Run the command interpreter.
        assert(rdpGBI != nullptr);
        DisplayList *dl = dlStart;
        uint8_t opCode;
        GBIFunction func;
        uint32_t cmdLength;
        size_t pendingCommandRemainingBytes = state->rdp->pendingCommandRemainingBytes;

        if (dlStart >= dlEnd) {
            state->dlCpuProfiler.end();
            return;
        }

        if (pendingCommandRemainingBytes != 0) {
            // Copy the remaining command bytes from the current displaylist
            uint32_t toCopy = (uint32_t)std::min(pendingCommandRemainingBytes, (uintptr_t)dlEnd - (uintptr_t)dl);
            memcpy(state->rdp->pendingCommandBuffer.data() + state->rdp->pendingCommandCurrentBytes, dl, toCopy);

            // Modify start to skip the copied bytes
            dl = (DisplayList *)(toCopy + (uintptr_t)dl);

            // Check if we've copied all of the bytes of the command into the buffer
            if (pendingCommandRemainingBytes == toCopy) {
                // All bytes have been copied, so run the completed command
                DisplayList *pendingCommand = (DisplayList *)state->rdp->pendingCommandBuffer.data();
                opCode = (pendingCommand->w0 >> 24) & opCodeMask;
                func = rdpGBI->map[opCode];

                if (func != nullptr) {
                    func(state, &pendingCommand);
                }
                else {
                    RT64_LOG_PRINTF("DL Parser ran into an unknown RDP opCode: %u / 0x%X", opCode, opCode);
                }

                state->rdp->pendingCommandCurrentBytes = 0;
                state->rdp->pendingCommandRemainingBytes = 0;
            }
            // Not all of the bytes were copied, so adjust RDP state accordingly and exit.
            else {
                state->rdp->pendingCommandCurrentBytes += toCopy;
                state->rdp->pendingCommandRemainingBytes -= toCopy;
                state->dlCpuProfiler.end();
                return;
            }
        }

        // Create a dummy pointer and pass that, since displaylist pointer incrementing is handled differently in LLE.
        DisplayList *dummy;
        while ((dl != nullptr) && ((dlEnd == nullptr) || (dl < dlEnd))) {
            opCode = (dl->w0 >> 24) & opCodeMask;

            if ((extendedOpCode != 0) && (opCode == extendedOpCode)) {
                dummy = dl;
                extendedFunction(state, &dl);
                cmdLength = 1;
            }
            else {
                func = rdpGBI->map[opCode];
                cmdLength = state->rdp->commandWordLengths[opCode];

#       ifdef DUMP_DISPLAY_LISTS
                RT64_LOG_PRINTF("0x%08X 0x%08X", dl->w0, dl->w1);
#       endif

                // Check if this command is unfinished and store the partial contents if so.
                if (dl + cmdLength > dlEnd) {
                    uint32_t toCopy = (uint32_t)((uintptr_t)dlEnd - (uintptr_t)dl);
                    memcpy(state->rdp->pendingCommandBuffer.data(), dl, toCopy);
                    state->rdp->pendingCommandCurrentBytes = toCopy;
                    state->rdp->pendingCommandRemainingBytes = cmdLength * sizeof(DisplayList) - toCopy;
                    break;
                }

                if (func != nullptr) {
                    dummy = dl;
                    func(state, &dummy);
                }
                else {
                    RT64_LOG_PRINTF("DL Parser ran into an unknown RDP opCode: %u / 0x%X", opCode, opCode);
                }
            }

            if (dl != nullptr) {
                dl += cmdLength;
            }
        }

        state->dlCpuProfiler.end();
    }

    // cont.13: physical address of the DL command RT64 is currently walking; read by RSP::fromSegmentedMasked
    // to resolve 0x0F refs against the overlay buffer that owns this DL (see tlb.cpp recomp_overlay_base_for).
    extern "C" volatile uint32_t g_cv64_cur_dl_phys;
    // cv64 S39 [fire]: seg-5 patch ring (defined in rt64_rsp.cpp setSegment).
    extern "C" uint32_t g_cv64_seg5_ring[8];
    extern "C" uint32_t g_cv64_seg5_ring_idx;

    // CV64 cont.34 (Bug C crash guard): a corrupt overlay DL (the 0x0F collision) can make a GBI handler
    // dereference a near-null/garbage RESOLVED pointer (boss-fight crash: READ 0x210 inside func(state,&dl),
    // RVA processDisplayLists+0x442). The existing null-DL / garbage-branch guards catch corrupt POINTERS in
    // the DL stream, not a handler faulting on resolved DATA. Wrap the dispatch in an access-violation guard
    // so an AV bails the DL instead of crashing the process. Standalone fn (only a fn-ptr call in the __try)
    // so SEH compiles without C++ unwinding. Band-aid for playability; the corruption ROOT is the real fix.
#ifdef _WIN32
    static bool dl_dispatch_guarded(GBIFunction fn, State *state, DisplayList **dl) {
        __try {
            fn(state, dl);
            return true;
        }
        __except ((GetExceptionCode() == 0xC0000005u) ? 1 /*EXECUTE_HANDLER*/ : 0 /*CONTINUE_SEARCH*/) {
            return false;
        }
    }
#endif

    // ── [dlop] DISPLAY-LIST OPCODE CENSUS (SOTE, 2026-08-26) — instrument only, env-gated ────────
    // WHY THIS EXISTS: RT64_LOG_PRINTF is compiled to NOTHING under NDEBUG (rt64_common.h:42), so
    // the walker's "DL Parser ran into an unknown opCode" message does not exist in any Release
    // build. A GBI whose map has no handler for one of a game's opcodes therefore drops those
    // commands SILENTLY, every frame, forever — and from the outside that is indistinguishable
    // from a game that simply drew nothing. This counts what the walker actually dispatched on and
    // which opcodes it had no handler for, so "the display list arrived" can be told apart from
    // "the display list was understood". Motivating case: SOTE resolves to F3D_SOTE, which is
    // declared GBIUCode::F3D — i.e. the STOCK F3D opcode map — but SOTE's microcode predates the
    // retail SDK (developed on SGI before LucasArts had a dev kit), so its opcode assignments are
    // not guaranteed to match. ~1,500 display lists reach RT64 and only a clear rectangle comes out.
    // RECOMP_DL_CENSUS=1 enables it. Unset ⇒ no counting, no output, byte-identical behaviour.
    static bool dlCensusEnabled() {
        static const bool on = [] { const char *e = std::getenv("RECOMP_DL_CENSUS"); return (e != nullptr) && (e[0] == '1'); }();
        return on;
    }

    static uint64_t g_dlopSeen[256] = {};    // every opcode the walker dispatched on
    static uint64_t g_dlopNoMap[256] = {};   // ...of those, the ones with map[op] == nullptr (DROPPED)
    static uint64_t g_dlopCmds = 0;          // total commands walked
    static uint64_t g_dlopLists = 0;         // total display lists walked

    static void dlCensusReport() {
        // Report on the 1st list and every 500th after, so a long run stays readable while still
        // showing whether the opcode MIX changes between the boot burst and steady state.
        if ((g_dlopLists != 1) && ((g_dlopLists % 500) != 0)) {
            return;
        }

        uint64_t droppedTotal = 0;
        for (int i = 0; i < 256; i++) {
            droppedTotal += g_dlopNoMap[i];
        }

        fprintf(stderr, "[dlop] after %llu lists / %llu cmds — DROPPED(no handler)=%llu\n",
                (unsigned long long)(g_dlopLists), (unsigned long long)(g_dlopCmds),
                (unsigned long long)(droppedTotal));
        fprintf(stderr, "[dlop]   seen:");
        for (int i = 0; i < 256; i++) {
            if (g_dlopSeen[i] != 0) {
                fprintf(stderr, " %02X=%llu", i, (unsigned long long)(g_dlopSeen[i]));
            }
        }
        fprintf(stderr, "\n[dlop]   NO HANDLER:");
        bool any = false;
        for (int i = 0; i < 256; i++) {
            if (g_dlopNoMap[i] != 0) {
                fprintf(stderr, " %02X=%llu", i, (unsigned long long)(g_dlopNoMap[i]));
                any = true;
            }
        }
        if (!any) {
            fprintf(stderr, " (none — every opcode the walker saw had a handler)");
        }
        fprintf(stderr, "\n");
        fflush(stderr);
    }

    void Interpreter::processDisplayLists(uint32_t dlStartAdddress, DisplayList *dlStart) {
        assert(hleGBI != nullptr);

        // cv64 SESSION 37 (the Renon-cutscene crash): if the GBI lookup failed (unknown/garbage ucode),
        // hleGBI is null and the Release build sailed past the assert into hleGBI->map[opCode] => AV
        // READ 0x18 on the render thread => permanent render freeze ("Renon does not appear"). A real
        // N64 never process-crashes on a microcode it doesn't recognize — the HLE equivalent is to drop
        // THIS task (same proven-safe semantics as the dlguard bail: send_dl returns, dp_complete fires)
        // and recover on the next task, whose differing addresses re-trigger the GBI hash.
        if (hleGBI == nullptr) {
            static int _ng = 0;
            if (_ng++ < 32) {
                fprintf(stderr, "[gbinull] dropping task dl=0x%08X — no GBI for the current ucode (see [gbifail])\n",
                        dlStartAdddress);
                fflush(stderr);
            }
            return;
        }

        state->dlCpuProfiler.start();

        // Update the state with the current display list address.
        state->displayListAddress = dlStartAdddress;
        state->displayListCounter++;

        // Check RDRAM if required.
        state->checkRDRAM();

        // Run the command interpreter.
        DisplayList *dl = dlStart;
        // cont.13: rdram base (host) = dlStart host - its physical address (dlStartAdddress). Lets us
        // compute the physical address of any DL command — even after branching into another buffer —
        // for the overlay-range lookup that resolves this DL's 0x0F refs to the right overlay buffer.
        const uint8_t* dl_rdram_base = reinterpret_cast<const uint8_t*>(dlStart) - dlStartAdddress;
        uint8_t opCode;
        GBIFunction func;
        // cv64 (session 10): guard against infinite DL loops. CV64 uses KCEK custom microcode;
        // a corrupted sub-DL/branch pointer (e.g. from the title_screen/gondola overlay collision
        // at segment 0x0F) or an unrecognized custom opcode that fails to terminate makes this
        // loop run forever -> send_dl() never returns -> dp_complete() never fires -> the game's
        // scheduler/graphics threads deadlock (whole game freezes ~frame 213 of the intro).
        // Bail after a generous limit so the game keeps running, and log the offending command.
        uint64_t dl_cmdCount = 0;
        // RECOMP_DL_CMD_LIMIT overrides the runaway-DL bail threshold (default 1,000,000; real
        // frames are << this, ~10-30k). Made tunable 2026-08-29 to answer a specific question on
        // KI Gold: the guard fires twice per run, and walking a MILLION garbage commands is real
        // wall-time on the submitting thread. Lowering it separates "RT64 burning time is the
        // stall" from "the game is stuck for its own reasons" — a diagnostic knob, not a fix.
        // Setting it too low will bail on legitimate heavy frames; only lower it deliberately.
        static const uint64_t RECOMP_DL_CMD_LIMIT = [] {
            const char* e = std::getenv("RECOMP_DL_CMD_LIMIT");
            uint64_t v = (e != nullptr) ? strtoull(e, nullptr, 0) : 0ULL;
            if (v == 0ULL) return 1000000ULL;
            fprintf(stderr, "[rt64_dlguard] limit overridden to %llu cmds (RECOMP_DL_CMD_LIMIT)\n",
                    (unsigned long long)v);
            fflush(stderr);
            return v;
        }();
        // cv64 (session 11 diagnostic): ring buffers of recent commands AND recent DL branches.
        // On BAIL, dump both — tells us EXACTLY which gSPDisplayList (opcode 0xDE) jumped into
        // corrupted memory, so we can identify the specific overlay collision (Bat? Opening?
        // title_screen?) and design a structural fix rather than another skip.
        struct DLCmdRec { uint64_t cmd; uint32_t w0, w1; void *dl; };
        struct DLBranchRec { uint64_t cmd; uint32_t segAddr, rdramAddr, w0; void *fromDl, *toDl; uint8_t isBranch; };
        static const int RECOMP_DL_HIST_SIZE = 32;
        static const int RECOMP_DL_BRANCH_SIZE = 16;
        DLCmdRec dl_cmdHist[RECOMP_DL_HIST_SIZE] = {};
        DLBranchRec dl_brHist[RECOMP_DL_BRANCH_SIZE] = {};
        int dl_cmdHistIdx = 0;
        int dl_brHistIdx = 0;
        int dl_brCount = 0;
        while (dl != nullptr) {
            // SESSION 28 cont.11+ (Reinhardt): the per-figure seg0x0F fix (funcs_157.c func_80005AD8)
            // makes overlay actors resolve to their own buffers, but for some figure it can yield a
            // bad DL pointer that this loop then followed and crashed dereferencing (UNHANDLED READ
            // near-null in processDisplayLists). Guard it: a real DL lives in RDRAM, well above the
            // low pages. On a near-null/garbage dl, BAIL + dump the segment table (esp. seg 0xF) and
            // the recent command history so we can see EXACTLY what resolved wrong — instead of
            // crashing the process. Keeps the build playable while we refine the fix.
            if ((uintptr_t)dl < 0x10000ULL) {
                static int _ndl = 0;
                if (_ndl++ < 16) {
                    fprintf(stderr, "[rt64_nullDL] BAIL dl=%p cmd=%llu seg:",
                            (void*)dl, (unsigned long long)dl_cmdCount);
                    for (int s = 0; s < 16; s++) fprintf(stderr, " %X=%08X", s, state->rsp->segments[s]);
                    fprintf(stderr, " | recent w0:w1:");
                    for (int k = 1; k <= 6; k++) {
                        DLCmdRec &r = dl_cmdHist[(dl_cmdHistIdx - k + RECOMP_DL_HIST_SIZE) % RECOMP_DL_HIST_SIZE];
                        fprintf(stderr, " %08X:%08X", r.w0, r.w1);
                    }
                    fprintf(stderr, "\n");
                }
                break;
            }
            // cont.13: publish the physical address of the command we're about to process so the RSP
            // resolver maps this DL's 0x0F refs to the overlay buffer that owns it (not the shared slot).
            g_cv64_cur_dl_phys = (uint32_t)(reinterpret_cast<const uint8_t*>(dl) - dl_rdram_base);
            // cv64 S39 [firewalk]: does the GPU walker EXECUTE the fire's slice of the frame DL?
            // The CPU writes the complete flame sequence at ~0x3765F0-0x376900 / 0x3645F0-0x364900
            // ([fire3] WROTE dumps), yet the seg5 ring/push probes never see it. Log every command the
            // walker executes in that window — absent = region skipped; present-but-different = bytes
            // overwritten between write and walk.
            {
                uint32_t _p = g_cv64_cur_dl_phys & 0x1FFFFFFFu;
                if ((_p >= 0x364500u && _p < 0x364A00u) || (_p >= 0x376500u && _p < 0x376A00u)) {
                    static int _fwn = 0;
                    if (_fwn++ < 100) {
                        fprintf(stderr, "[firewalk] phys=0x%08X w0=0x%08X w1=0x%08X\n", _p, dl->w0, dl->w1);
                        fflush(stderr);
                    }
                }
            }
            opCode = (dl->w0 >> 24);
            // Ring-buffer record of every command (overwrites oldest)
            dl_cmdHist[dl_cmdHistIdx % RECOMP_DL_HIST_SIZE] = { dl_cmdCount, dl->w0, dl->w1, (void*)dl };
            dl_cmdHistIdx++;
            if (++dl_cmdCount > RECOMP_DL_CMD_LIMIT) {
                fprintf(stderr, "[rt64_dlguard] BAIL: DL exceeded %llu cmds (looping/corrupt DL). "
                        "dl=%p w0=0x%08X w1=0x%08X opCode=0x%02X ucode=%u dlStart=0x%08X\n",
                        (unsigned long long)RECOMP_DL_CMD_LIMIT, (void*)dl, dl->w0, dl->w1,
                        (unsigned)(dl->w0 >> 24), (unsigned)hleGBI->ucode, dlStartAdddress);
                // Dump segment table state (only segments 0xC-0xF since that's where overlays live)
                fprintf(stderr, "[rt64_dlguard] segments[C..F]=");
                for (int s = 0xC; s <= 0xF; s++) {
                    fprintf(stderr, " seg%X=0x%08X", s, state->rsp->segments[s]);
                }
                fprintf(stderr, "\n");
                // Dump recent BRANCH history — these are the gSPDisplayList jumps
                fprintf(stderr, "[rt64_dlguard] --- last %d DL branches (total=%d) ---\n",
                        RECOMP_DL_BRANCH_SIZE, dl_brCount);
                for (int i = 0; i < RECOMP_DL_BRANCH_SIZE; i++) {
                    int idx = (dl_brHistIdx + i) % RECOMP_DL_BRANCH_SIZE;
                    DLBranchRec &b = dl_brHist[idx];
                    if (b.cmd == 0) continue;
                    fprintf(stderr, "  br#%d cmd=%llu %s segAddr=0x%08X -> rdram=0x%08X from=%p to=%p w0=0x%08X\n",
                            i, (unsigned long long)b.cmd, b.isBranch ? "BRANCH" : "DLPUSH",
                            b.segAddr, b.rdramAddr, b.fromDl, b.toDl, b.w0);
                }
                // Dump recent COMMAND history (last 32 commands)
                fprintf(stderr, "[rt64_dlguard] --- last %d commands ---\n", RECOMP_DL_HIST_SIZE);
                for (int i = 0; i < RECOMP_DL_HIST_SIZE; i++) {
                    int idx = (dl_cmdHistIdx + i) % RECOMP_DL_HIST_SIZE;
                    DLCmdRec &c = dl_cmdHist[idx];
                    if (c.cmd == 0) continue;
                    fprintf(stderr, "  cmd#%llu opCode=0x%02X w0=0x%08X w1=0x%08X dl=%p\n",
                            (unsigned long long)c.cmd, (unsigned)(c.w0 >> 24), c.w0, c.w1, c.dl);
                }
                fflush(stderr);
                break;   // abandon this DL -> send_dl returns -> dp_complete fires -> no deadlock
            }
            else if ((dl_cmdCount % 250000ULL) == 0) {
                // Periodic sample: if the loop is cyclic these will repeat, revealing the culprit.
                fprintf(stderr, "[rt64_dlguard] #%lluk cmds dl=%p w0=0x%08X w1=0x%08X opCode=0x%02X\n",
                        (unsigned long long)(dl_cmdCount / 1000ULL), (void*)dl, dl->w0, dl->w1,
                        (unsigned)(dl->w0 >> 24));
                fflush(stderr);
            }
            // Capture DL branches BEFORE dispatch so we know where we jumped from.
            // F3DEX2: opcode 0xDE = G_DL (gSPDisplayList=push&jump, gSPBranchList=replace).
            // The branch-or-push distinction is bit 16 of w0 in F3DEX2.
            if (opCode == 0xDE) {
                uint32_t segAddr = dl->w1;
                uint32_t rdramAddr = state->rsp->fromSegmentedMasked(segAddr);
                uint8_t isBranch = ((dl->w0 >> 16) & 1) ? 1 : 0;  // F3DEX2 p0(16,1): 0=DL push, 1=Branch
                // cv64 SESSION 38f [fire] — the tree-torch flame probe (cont.38 parked plan).
                // FIRE_DLIST = seg6:0x031F28 (cv64 fire.c, asset NI file 0x38). The flame model is
                // created (its point-light glow works) but draws nothing visible. Discriminate the two
                // halves: if this NEVER logs, the flame DL is culled/skipped game-side before the GPU;
                // if it logs, the dumped words show whether the DL content is intact (real commands)
                // and what state it sets — render-side from there.
                // cv64 S39 [fire] RE-KEYED: 0x031F28 is a variable-texture DESCRIPTOR, not the DL — its
                // first word 0x06031E50 is the REAL flame DL ([fire3] proof: the figure builder runs and
                // emits every frame; the S38g "zero pushes" was this probe keyed on the descriptor =
                // FALSE NEGATIVE). Match the real DL + a window around it, and dump segments[5] (the
                // per-frame variable-TEXTURE patch the builder installs) + segments[6]: if the flame IS
                // pushed, the texture patch values are the remaining suspect (invisible flame).
                // cv64 S39 iter5: EXACT-match the flame's two DLs (0x031E50 + 0x031D70). The earlier
                // range probe's cap was consumed at level start (pre-strike) by a constant effect
                // (0x031980) — its "no flame pushes" statistic was VOID. This cap only counts flames.
                if ((segAddr >> 24) == 0x06u &&
                    ((segAddr & 0x00FFFFFFu) == 0x031E50u || (segAddr & 0x00FFFFFFu) == 0x031D70u)) {
                    static int _fire = 0;
                    if (_fire++ < 24) {
                        const uint32_t* fw = reinterpret_cast<const uint32_t*>(state->fromRDRAM(rdramAddr));
                        fprintf(stderr, "[fire] flame-range push: seg=0x%08X rdram=0x%08X seg5=0x%08X seg6=0x%08X words:",
                                segAddr, rdramAddr, state->rsp->segments[5], state->rsp->segments[6]);
                        if (fw != nullptr) for (int k = 0; k < 12; k++) fprintf(stderr, " %08X", fw[k]);
                        fprintf(stderr, "\n[fire]   seg5 ring (oldest..newest):");
                        for (uint32_t k = 0; k < 8; k++) fprintf(stderr, " %08X", g_cv64_seg5_ring[(g_cv64_seg5_ring_idx + k) & 7u]);
                        fprintf(stderr, "\n");
                        fflush(stderr);
                    }
                }
                DLCmdRec *targetCmd = (DLCmdRec *)state->fromRDRAM(rdramAddr);
                dl_brHist[dl_brHistIdx % RECOMP_DL_BRANCH_SIZE] = {
                    dl_cmdCount, segAddr, rdramAddr, dl->w0, (void*)dl, (void*)targetCmd, isBranch
                };
                dl_brHistIdx++;
                dl_brCount++;
                // cv64 (session 20): catch a GARBAGE branch target the instant it appears, instead of
                // waiting for the 1M-NOOP bail. Valid w1 top-nibbles are 0 (segmented 0x00..0x0F) or
                // 8/9/A/B (KSEG0/KSEG1 direct). Anything else (e.g. 0xF2000000) is corrupt data.
                // Dump the full segment table + the raw DL words around the source command so we can
                // tell a localized decompressor output shift from an unset segment base.
                {
                    uint32_t dl_topNib = segAddr >> 28;
                    static int dl_badDumped = 0;
                    bool dl_garbage = !(dl_topNib == 0x0 || (dl_topNib >= 0x8 && dl_topNib <= 0xB));
                    if (dl_garbage && dl_badDumped < 16) {
                        dl_badDumped++;
                        fprintf(stderr, "[rt64_badbranch] segAddr=0x%08X (top=0x%X) rdram=0x%08X srcDL=%p w0=0x%08X w1=0x%08X cmd#%llu\n",
                                segAddr, dl_topNib, rdramAddr, (void*)dl, dl->w0, dl->w1, (unsigned long long)dl_cmdCount);
                        fprintf(stderr, "[rt64_badbranch] segtable:");
                        for (int s = 0; s < 16; s++) fprintf(stderr, " %X=0x%08X", s, state->rsp->segments[s]);
                        fprintf(stderr, "\n[rt64_badbranch] srcDL context (offset: w0 w1):\n");
                        for (int k = -6; k <= 4; k++) {
                            const DisplayList* c = dl + k;
                            fprintf(stderr, "    [%+d] %p: 0x%08X 0x%08X\n", k, (const void*)c, c->w0, c->w1);
                        }
                        fflush(stderr);
                    }
                    if (dl_garbage) {
                        static int dl_skipDumped = 0;
                        if (dl_skipDumped++ < 32) {
                            fprintf(stderr, "[rt64_badbranch_skip] skipped invalid G_DL target 0x%08X from %p\n",
                                    segAddr, (void*)dl);
                            fflush(stderr);
                        }
                        dl++;
                        continue;
                    }
                }
            }

            // [dlop] census the command BEFORE dispatch — see dlCensusReport() above for why the
            // stock "unknown opCode" path is invisible in Release. Counting only; no dispatch change.
            if (dlCensusEnabled()) {
                g_dlopCmds++;
                g_dlopSeen[opCode]++;
                const bool censusExt = (extendedOpCode != 0) && (opCode == extendedOpCode);
                if (!censusExt && (hleGBI->map[opCode] == nullptr)) {
                    g_dlopNoMap[opCode]++;
                }
            }

#ifdef _WIN32
            bool _cv64_dispatchOk = true;
#endif
            if ((extendedOpCode != 0) && (opCode == extendedOpCode)) {
#ifdef _WIN32
                _cv64_dispatchOk = dl_dispatch_guarded(extendedFunction, state, &dl);
#else
                extendedFunction(state, &dl);
#endif
            }
            else {
                func = hleGBI->map[opCode];

#       ifdef DUMP_DISPLAY_LISTS
                RT64_LOG_PRINTF("0x%08X 0x%08X", dl->w0, dl->w1);
#       endif

                if (func != nullptr) {
#ifdef _WIN32
                    _cv64_dispatchOk = dl_dispatch_guarded(func, state, &dl);
#else
                    func(state, &dl);
#endif
                }
                else {
                    RT64_LOG_PRINTF("DL Parser ran into an unknown opCode (GBI %u): %u / 0x%X", uint32_t(hleGBI->ucode), opCode, opCode);
                }
            }
#ifdef _WIN32
            if (!_cv64_dispatchOk) {
                static int _dlc = 0;
                if (_dlc++ < 32) {
                    fprintf(stderr, "[rt64_dlcrash] caught access-violation in GBI handler opCode=0x%02X (corrupt overlay DL, Bug C) — bailed DL at cmd#%llu\n",
                            opCode, (unsigned long long)dl_cmdCount);
                    fflush(stderr);
                }
                break; // abandon this corrupt DL; send_dl returns, dp_complete fires, no crash/deadlock
            }
#endif

            // cv64 SESSION 37b: an in-DL G_LOAD_UCODE whose GBI lookup fails nulls hleGBI MID-LOOP —
            // the entry guard can't see that, and the next iteration's hleGBI->map[opCode] is the same
            // null+0x18 AV (second Renon crash, RVA processDisplayLists+0x4BA). Bail the rest of this
            // DL; the next task's differing addresses re-trigger the hash and recover.
            // The fake G_LOAD_UCODE (w1=0xA9522656, half1=0, target bytes all zero) proves the walker
            // diverged into non-DL data — Bug-C: a figure DL ref resolved into the wrong buffer on the
            // first frame after obj 0x20B2 (Renon) joins. Dump the branch/command history: WHICH branch
            // from WHICH buffer led into the garbage = the per-figure keying data the Bug-C cure needs.
            if (hleGBI == nullptr) {
                static int _ngm = 0;
                if (_ngm++ < 8) {
                    fprintf(stderr, "[gbinull] mid-DL ucode switch failed at cmd#%llu — bailing this DL (see [gbifail])\n",
                            (unsigned long long)dl_cmdCount);
                    fprintf(stderr, "[gbinull] --- last %d DL branches (total=%d) ---\n", RECOMP_DL_BRANCH_SIZE, dl_brCount);
                    for (int i = 0; i < RECOMP_DL_BRANCH_SIZE; i++) {
                        int idx = (dl_brHistIdx + i) % RECOMP_DL_BRANCH_SIZE;
                        DLBranchRec &b = dl_brHist[idx];
                        if (b.cmd == 0) continue;
                        fprintf(stderr, "  br#%d cmd=%llu %s segAddr=0x%08X -> rdram=0x%08X from=%p to=%p w0=0x%08X\n",
                                i, (unsigned long long)b.cmd, b.isBranch ? "BRANCH" : "DLPUSH",
                                b.segAddr, b.rdramAddr, b.fromDl, b.toDl, b.w0);
                    }
                    fprintf(stderr, "[gbinull] --- last %d commands ---\n", RECOMP_DL_HIST_SIZE);
                    for (int i = 0; i < RECOMP_DL_HIST_SIZE; i++) {
                        int idx = (dl_cmdHistIdx + i) % RECOMP_DL_HIST_SIZE;
                        DLCmdRec &c = dl_cmdHist[idx];
                        if (c.cmd == 0) continue;
                        fprintf(stderr, "  cmd#%llu opCode=0x%02X w0=0x%08X w1=0x%08X dl=%p\n",
                                (unsigned long long)c.cmd, (unsigned)(c.w0 >> 24), c.w0, c.w1, c.dl);
                    }
                    fflush(stderr);
                }
                break;
            }

            if (dl != nullptr) {
                dl++;
            }
        }

        if (dlCensusEnabled()) {
            g_dlopLists++;
            dlCensusReport();
        }

        state->dlCpuProfiler.end();
    }
};
