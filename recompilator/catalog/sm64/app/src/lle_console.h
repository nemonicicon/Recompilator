// lle_console — THE PRESERVATION-CORE RENDERER (PLAN_V2 P3, 2026-07-12).
// RDPC_LLE_CONSOLE=1 replaces RT64 entirely: gfx tasks render through the capture chain
// (recompiled f3d ucode -> RDP stream -> rdpcore workers, zero-copy into engine RDRAM) and the
// VI scans the color image out of RDRAM via softrdp::present::present_argb into the game's SDL
// window (software blit, no GPU API). Compiled ONLY under -DRDPC_CAPTURE=ON like the rest of the
// chain; default builds contain none of this.
#pragma once
#ifdef RDPC_CAPTURE_CHAIN

#include <cstdint>
#include <memory>

#include "ultramodern/renderer_context.hpp"

struct SDL_Window;

namespace sm64 {
namespace lleconsole {

// True when env RDPC_LLE_CONSOLE=1 (cached at first call).
bool active();

// The RendererContext that stands in for RT64 (see rt64_renderer.cpp for the switch).
std::unique_ptr<ultramodern::renderer::RendererContext> create_console_context(uint8_t* rdram);

// Main-thread present pump: called from main.cpp's update_gfx (~1ms tick, the thread that owns
// the window). Blits the latest VI frame into the window surface. No-op unless active + dirty.
void blit_tick(SDL_Window* window);

// Rendered-origin registry (RT64's structural protection, adapted): the LLE render path
// reports every SET_COLOR_IMAGE address it actually rendered to; the VI only scans those.
// A never-rendered buffer presents BLACK — kills the boot-time stale-memory flash (real
// RT64 gets this for free by only presenting its own outputs). Events-thread only.
void note_rendered_ci(uint32_t ci);

} // namespace lleconsole
} // namespace sm64

#endif // RDPC_CAPTURE_CHAIN
