#ifndef __RSP_HPP__
#define __RSP_HPP__

#include <cstdint>

#include "ultra64.h"

namespace ultramodern {
    namespace rsp {
        struct callbacks_t {
            using init_t = void();
            using run_microcode_t = bool(RDRAM_ARG const OSTask* task);
            // CV64 Brick 3 (Option D): optional hook to run a graphics-ucode LLE pass over a gfx task
            // (capturing the faithful RDP command stream) ALONGSIDE the HLE renderer. Nullable.
            using capture_gfx_t = void(RDRAM_ARG const OSTask* task);

            init_t* init;

            /**
             * Executes the given RSP task.
             *
             * Returns true if task was executed successfully.
             */
            run_microcode_t* run_task;

            // CV64 Brick 3: run alongside the renderer for gfx tasks (capture-only). May be null.
            capture_gfx_t* capture_gfx_task = nullptr;
        };

        void set_callbacks(const callbacks_t& callbacks);

        void init();
        bool run_task(RDRAM_ARG const OSTask* task);
        // CV64 Brick 3: invokes the capture_gfx_task callback if one is registered (no-op otherwise).
        void capture_gfx_task(RDRAM_ARG const OSTask* task);
    };
} // namespace ultramodern

#endif
