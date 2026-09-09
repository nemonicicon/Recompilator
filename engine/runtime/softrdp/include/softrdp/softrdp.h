// softrdp — THE RECOMPILATOR's software RDP (the GPU-free native renderer).
//
// Consumes the same RDP command stream ranges the LLE capture produces (DO_DP_END →
// rsp_process_rdp_commands), rasterizing into the game's own color image in RDRAM — exactly like
// the silicon: the framebuffer IS memory, the VI (or a PPM dump during bring-up) scans it out.
// Milestone A: fill/copy/1-cycle/2-cycle modes, edge-walked triangles with shade/texture/Z,
// generic combiner, honest blender core, TMEM with tiles/TLUT. No coverage/AA/dither yet.
//
// Enabled by env RECOMP_SOFT_RDP=1 (dumps frames to RECOMP_SOFT_RDP_DIR, default "softrdp_frames",
// every RECOMP_SOFT_RDP_DUMP_EVERY-th SyncFull, default 30). Plan: memory/project_pi_native_console.md.

#pragma once

#include <cstdint>

namespace softrdp {

// True when RECOMP_SOFT_RDP=1 (cached at first call).
bool enabled();

// Process one kicked DP FIFO range [start, end) of RDP commands living in RDRAM.
// Addresses are masked to RDRAM internally; bytes are read in N64 order (^3, same as the engine).
void process_commands(uint8_t* rdram, uint32_t start, uint32_t end);

}
