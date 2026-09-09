/**
 * rt64_renderer.cpp — the launcher's RT64Context.
 *
 * The same wrapper every port uses (cv64blindpc/src/rt64_renderer.cpp), with the game-specific
 * probes removed. send_dl() can never be called here: the launcher registers no game, so no
 * display list is ever submitted. update_screen() still runs ~60 times a second because the VI
 * thread pushes a dummy VI when no game is started — that is what drives the launcher's present,
 * and therefore its ImGui frame.
 */

#include "rt64_renderer.hpp"
#include "launcher_app.hpp"

#ifdef _WIN32
#  include <unknwn.h>
#  include <wtypes.h>
#endif

#include "rt64_application.h"

#include "ultramodern/ultramodern.hpp"
#include "librecomp/rsp.hpp"   // extern uint8_t dmem[]

#include <cstdio>
#include <atomic>

#ifdef _WIN32
#  include <Windows.h>
#endif

namespace launcher {
namespace renderer {

static uint8_t IMEM[0x1000] = {};

static uint32_t MI_INTR_REG      = 0;
static uint32_t DPC_START_REG    = 0;
static uint32_t DPC_END_REG      = 0;
static uint32_t DPC_CURRENT_REG  = 0;
static uint32_t DPC_STATUS_REG   = 0;
static uint32_t DPC_CLOCK_REG    = 0;
static uint32_t DPC_BUFBUSY_REG  = 0;
static uint32_t DPC_PIPEBUSY_REG = 0;
static uint32_t DPC_TMEM_REG     = 0;

static void dummy_check_interrupts() {}

static ultramodern::renderer::SetupResult
map_setup_result(RT64::Application::SetupResult r) {
    using RT = RT64::Application::SetupResult;
    using UM = ultramodern::renderer::SetupResult;
    switch (r) {
        case RT::DynamicLibrariesNotFound: return UM::DynamicLibrariesNotFound;
        case RT::InvalidGraphicsAPI:       return UM::InvalidGraphicsAPI;
        case RT::GraphicsAPINotFound:      return UM::GraphicsAPINotFound;
        case RT::GraphicsDeviceNotFound:   return UM::GraphicsDeviceNotFound;
        default:                           return UM::Success;
    }
}

RT64Context::RT64Context(uint8_t* rdram,
                         ultramodern::renderer::WindowHandle window_handle,
                         bool /*developer_mode*/)
{
    RT64::Application::Core core{};

#ifdef _WIN32
    core.window = window_handle.window;
#else
    core.window = window_handle;
#endif
    core.checkInterrupts = dummy_check_interrupts;

    core.RDRAM = rdram;
    core.DMEM  = dmem;
    core.IMEM  = IMEM;

    core.MI_INTR_REG      = &MI_INTR_REG;
    core.DPC_START_REG    = &DPC_START_REG;
    core.DPC_END_REG      = &DPC_END_REG;
    core.DPC_CURRENT_REG  = &DPC_CURRENT_REG;
    core.DPC_STATUS_REG   = &DPC_STATUS_REG;
    core.DPC_CLOCK_REG    = &DPC_CLOCK_REG;
    core.DPC_BUFBUSY_REG  = &DPC_BUFBUSY_REG;
    core.DPC_PIPEBUSY_REG = &DPC_PIPEBUSY_REG;
    core.DPC_TMEM_REG     = &DPC_TMEM_REG;

    auto* vi = ultramodern::renderer::get_vi_regs();
    core.VI_STATUS_REG         = &vi->VI_STATUS_REG;
    core.VI_ORIGIN_REG         = &vi->VI_ORIGIN_REG;
    core.VI_WIDTH_REG          = &vi->VI_WIDTH_REG;
    core.VI_INTR_REG           = &vi->VI_INTR_REG;
    core.VI_V_CURRENT_LINE_REG = &vi->VI_V_CURRENT_LINE_REG;
    core.VI_TIMING_REG         = &vi->VI_TIMING_REG;
    core.VI_V_SYNC_REG         = &vi->VI_V_SYNC_REG;
    core.VI_H_SYNC_REG         = &vi->VI_H_SYNC_REG;
    core.VI_LEAP_REG           = &vi->VI_LEAP_REG;
    core.VI_H_START_REG        = &vi->VI_H_START_REG;
    core.VI_V_START_REG        = &vi->VI_V_START_REG;
    core.VI_V_BURST_REG        = &vi->VI_V_BURST_REG;
    core.VI_X_SCALE_REG        = &vi->VI_X_SCALE_REG;
    core.VI_Y_SCALE_REG        = &vi->VI_Y_SCALE_REG;

    RT64::ApplicationConfiguration appConfig;
    appConfig.useConfigurationFile = true;
    appConfig.appId = "recompilator";

    app_ = std::make_unique<RT64::Application>(core, appConfig);
    app_->enhancementConfig.textureLOD.scale = true;

#ifdef _WIN32
    DWORD thread_id = GetCurrentThreadId();
#else
    uint32_t thread_id = 0;
#endif

    setup_result = map_setup_result(app_->setup(thread_id));
    fprintf(stderr, "[rt64] launcher RT64Context setup: %s (code=%d)\n",
        setup_result == ultramodern::renderer::SetupResult::Success ? "SUCCESS" : "FAILED",
        static_cast<int>(setup_result));
    fflush(stderr);

    if (setup_result == ultramodern::renderer::SetupResult::Success) {
        launcher::ui_attach(app_.get());
    }
}

RT64Context::~RT64Context() {
    launcher::ui_detach();
    if (app_) {
        app_->end();
    }
}

bool RT64Context::valid() {
    return static_cast<bool>(app_) && (setup_result == ultramodern::renderer::SetupResult::Success);
}

bool RT64Context::update_config(
    const ultramodern::renderer::GraphicsConfig& /*old_config*/,
    const ultramodern::renderer::GraphicsConfig& /*new_config*/)
{
    if (!app_) return false;
    app_->updateUserConfig(false);
    return true;
}

void RT64Context::enable_instant_present() {
    if (app_) {
        app_->enhancementConfig.presentation.mode =
            RT64::EnhancementConfiguration::Presentation::Mode::PresentEarly;
    }
}

void RT64Context::send_dl(const OSTask* task) {
    // No game is registered in the launcher, so nothing can submit a display list. Kept so the
    // RendererContext contract is complete and step 3 (in-process modules) has the hook in place.
    if (!app_ || task == nullptr) return;
    app_->interpreter->loadUCodeGBI(
        task->t.ucode      & 0x3FFFFFF,
        task->t.ucode_data & 0x3FFFFFF,
        /*resetFromTask=*/false);
    app_->processDisplayLists(
        app_->core.RDRAM,
        task->t.data_ptr & 0x3FFFFFF,
        /*dlEndAddress=*/0,
        /*isHLE=*/true);
}

void RT64Context::update_screen() {
    if (app_) {
        app_->updateScreen();
    }
}

void RT64Context::shutdown() {
    launcher::ui_detach();
    if (app_) {
        app_->end();
        // Same rule as every port (cv64pc cont.33): leak the Application on exit rather than race
        // the still-running threads into a use-after-free.
        (void)app_.release();
    }
}

uint32_t RT64Context::get_display_framerate() const {
    if (!app_ || !app_->swapChain) return 60;
    return app_->swapChain->getRefreshRate();
}

float RT64Context::get_resolution_scale() const {
    if (!app_ || !app_->sharedQueueResources) return 1.0f;
    return app_->sharedQueueResources->resolutionScale.x;
}

std::unique_ptr<ultramodern::renderer::RendererContext>
create_render_context(uint8_t* rdram,
                      ultramodern::renderer::WindowHandle window_handle,
                      bool developer_mode)
{
    return std::make_unique<RT64Context>(rdram, window_handle, developer_mode);
}

} // namespace renderer
} // namespace launcher
