#pragma once

#include <memory>
#include "ultramodern/renderer_context.hpp"

namespace RT64 { struct Application; }

namespace launcher {
namespace renderer {

/// RT64-backed RendererContext for the launcher. Identical in shape to a port's (the engine-proven
/// wrapper) — the launcher IS a port, it just never starts a game. The one addition is ui_attach():
/// once RT64's Application is up, the launcher's ImGui overlay hooks RT64's present.
class RT64Context final : public ultramodern::renderer::RendererContext {
public:
    RT64Context(uint8_t* rdram,
                ultramodern::renderer::WindowHandle window_handle,
                bool developer_mode);
    ~RT64Context() override;

    bool valid() override;
    bool update_config(
        const ultramodern::renderer::GraphicsConfig& old_config,
        const ultramodern::renderer::GraphicsConfig& new_config) override;

    void enable_instant_present() override;
    void send_dl(const OSTask* task) override;
    void update_screen() override;
    void shutdown() override;
    uint32_t get_display_framerate() const override;
    float get_resolution_scale() const override;

private:
    std::unique_ptr<RT64::Application> app_;
};

std::unique_ptr<ultramodern::renderer::RendererContext>
create_render_context(uint8_t* rdram,
                      ultramodern::renderer::WindowHandle window_handle,
                      bool developer_mode);

} // namespace renderer
} // namespace launcher
