#include <cassert>
#include <cstring>

#include "ultramodern/rsp.hpp"

static ultramodern::rsp::callbacks_t rsp_callbacks {};

void ultramodern::rsp::set_callbacks(const callbacks_t& callbacks) {
    rsp_callbacks = callbacks;
}

void ultramodern::rsp::init() {
    if (rsp_callbacks.init != nullptr) {
        rsp_callbacks.init();
    }
}

bool ultramodern::rsp::run_task(RDRAM_ARG const OSTask* task) {
    assert(rsp_callbacks.run_task != nullptr);

    return rsp_callbacks.run_task(PASS_RDRAM task);
}

// CV64 Brick 3 (Option D): run the registered gfx-ucode LLE capture (if any) for a gfx task.
void ultramodern::rsp::capture_gfx_task(RDRAM_ARG const OSTask* task) {
    if (rsp_callbacks.capture_gfx_task != nullptr) {
        rsp_callbacks.capture_gfx_task(PASS_RDRAM task);
    }
}
