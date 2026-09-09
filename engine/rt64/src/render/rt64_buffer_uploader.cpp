//
// RT64
//

#include <algorithm>
#include <cstring>
#ifdef _WIN32
#include <windows.h>   // SEH (GetExceptionCode) for the corrupt-buffer upload guard
#endif

#include "common/rt64_thread.h"

#include "rt64_buffer_uploader.h"

namespace RT64 {
    // Common functions.

    static uint64_t roundUp(uint64_t value, uint64_t powerOf2Alignment) {
        return (value + powerOf2Alignment - 1) & ~(powerOf2Alignment - 1);
    }

    // War Gods #17 (2026-09-05): the async upload worker crashed inside RenderBuffer::map() with a
    // NON-NULL but garbage uploadBuffer pointer (crash RVA D3D12Buffer::map+0x6C, host heap already
    // corrupted upstream). threadUpload already guards null buffer + null map — the doctrine of this
    // file is "a dropped upload beats process death" (SM64PC S45 boot#6) — but a corrupt pointer sails
    // past a null check and faults inside the vtable call. Wrap the map/copy/unmap in an access-violation
    // guard, same pattern as rt64_interpreter's dl_dispatch_guarded. A standalone fn (no C++ objects
    // needing unwinding) so SEH compiles. Returns false on an AV → the upload is dropped. Host-side
    // error path only: on a healthy frame nothing changes.
#ifdef _WIN32
    static bool guarded_map_copy(RenderBuffer *uploadBuffer, size_t srcOffset, size_t srcSize,
                                 const void *srcData, const RenderRange *writtenRange) {
        __try {
            uint8_t *dstData = static_cast<uint8_t *>(uploadBuffer->map());
            if (dstData == nullptr) {
                return false;
            }
            memcpy(dstData + srcOffset, static_cast<const uint8_t *>(srcData) + srcOffset, srcSize);
            uploadBuffer->unmap(0, writtenRange);
            return true;
        }
        __except ((GetExceptionCode() == 0xC0000005u) ? 1 /*EXECUTE_HANDLER*/ : 0 /*CONTINUE_SEARCH*/) {
            return false;
        }
    }
#endif

    // BufferUploader::Upload

    bool BufferUploader::Upload::valid() const {
        return (srcData != nullptr) && (srcDataIndexRange.second > srcDataIndexRange.first);
    }

    // BufferUploader

    BufferUploader::BufferUploader(RenderDevice *device) {
        assert(device != nullptr);

        this->device = device;
        workAvailable = false;
        thread = new std::thread(&BufferUploader::threadLoop, this);
    }

    BufferUploader::~BufferUploader() {
        running = false;
        workCondition.notify_all();
        thread->join();
        delete thread;
    }

    void BufferUploader::threadLoop() {
        Thread::setCurrentThreadName("RT64 Buffer");

        running = true;

        while (running) {
            std::unique_lock<std::mutex> queueLock(workMutex);
            workCondition.wait(queueLock, [this]() {
                return !running || workAvailable;
            });
            
            if (running) {
                for (const Upload &u : pendingUploads) {
                    threadUpload(u);
                }
            }

            {
                std::unique_lock<std::mutex> readyLock(readyMutex);
                workAvailable = false;
            }

            readyCondition.notify_all();
        }
    }

    void BufferUploader::threadUpload(const Upload &upload) {
        if (!upload.valid()) {
            return;
        }

        assert(upload.dstPair != nullptr);
        // SM64PC S45 boot#6 (engine invariant): if buffer creation failed (corrupt workload sizes ->
        // CreateResource E_INVALIDARG) the upload buffer is null/unmappable; the memcpy below then
        // writes to null+srcOffset = the boot#6 process crash (WRITE at small absolute addresses).
        // A dropped upload (a glitchy frame) beats process death.
        if (upload.dstPair->uploadBuffer == nullptr) {
            static int _nub = 0;
            if (_nub++ < 16) {
                fprintf(stderr, "[bufupload] SKIP upload: null upload buffer (creation failed?) range=[%zu,%zu) stride=%zu\n",
                        upload.srcDataIndexRange.first, upload.srcDataIndexRange.second, upload.srcDataStride);
                fflush(stderr);
            }
            return;
        }
        const size_t srcOffset = upload.srcDataIndexRange.first * upload.srcDataStride;
        const size_t srcSize = (upload.srcDataIndexRange.second - upload.srcDataIndexRange.first) * upload.srcDataStride;
        const RenderRange writtenRange(srcOffset, srcOffset + srcSize);
#ifdef _WIN32
        // War Gods #17: a corrupt (non-null) uploadBuffer pointer faults INSIDE map(), past the null
        // check above. Guard the map/copy/unmap; on an AV drop the upload, per this file's doctrine.
        if (!guarded_map_copy(upload.dstPair->uploadBuffer.get(), srcOffset, srcSize, upload.srcData, &writtenRange)) {
            static int _gmc = 0;
            if (_gmc++ < 16) {
                fprintf(stderr, "[bufupload] SKIP upload: map/copy faulted or map() null (corrupt buffer). size=%zu offset=%zu\n", srcSize, srcOffset);
                fflush(stderr);
            }
            return;
        }
#else
        uint8_t *dstData = static_cast<uint8_t *>(upload.dstPair->uploadBuffer->map());
        if (dstData == nullptr) {
            static int _nmap = 0;
            if (_nmap++ < 16) {
                fprintf(stderr, "[bufupload] SKIP upload: map() returned null. size=%zu offset=%zu\n", srcSize, srcOffset);
                fflush(stderr);
            }
            return;
        }
        memcpy(dstData + srcOffset, static_cast<const uint8_t *>(upload.srcData) + srcOffset, srcSize);
        upload.dstPair->uploadBuffer->unmap(0, &writtenRange);
#endif
    }

    void BufferUploader::updateResources(RenderWorker *worker, std::vector<Upload> &blankUploads) {
        for (Upload &u : blankUploads) {
            // Ignore the reallocation of the buffer if the required size is already enough. We always create a buffer if it hasn't been created yet.
            const size_t requiredSize = u.srcDataIndexRange.second * u.srcDataStride;
            BufferPair &bufferPair = *u.dstPair;
            if ((bufferPair.defaultBuffer != nullptr) && (!u.valid() || (bufferPair.allocatedSize >= requiredSize))) {
                continue;
            }

            bufferPair.defaultViews.clear();

            // Recreate the buffer pair.
            const uint64_t BlockAlignment = 256;
            bufferPair.allocatedSize = std::max(uint64_t((requiredSize * 3) / 2), BlockAlignment);
            bufferPair.allocatedSize = roundUp(bufferPair.allocatedSize, BlockAlignment);
            bufferPair.uploadBuffer = worker->device->createBuffer(RenderBufferDesc::UploadBuffer(bufferPair.allocatedSize));
            bufferPair.defaultBuffer = worker->device->createBuffer(RenderBufferDesc::DefaultBuffer(bufferPair.allocatedSize, u.bufferFlags));

            // SM64PC S45 boot#6 (engine invariant): a corrupt workload (boot#6: a 26MB vertex range
            // from a misparsed DL) can make creation fail — mark this upload invalid so every
            // downstream consumer (threadUpload/barriers/copy) skips it instead of dereferencing null.
            if (bufferPair.uploadBuffer == nullptr || bufferPair.defaultBuffer == nullptr) {
                static int _bcf = 0;
                if (_bcf++ < 16) {
                    fprintf(stderr, "[bufupload] buffer creation FAILED for size=%llu (required=%zu) — dropping upload\n",
                            (unsigned long long)bufferPair.allocatedSize, requiredSize);
                    fflush(stderr);
                }
                bufferPair.uploadBuffer.reset();
                bufferPair.defaultBuffer.reset();
                bufferPair.allocatedSize = 0;
                u.srcDataIndexRange = { 0, 0 };
                continue;
            }

            bufferPair.defaultViews.reserve(u.formatViews.size());
            for (RenderFormat format : u.formatViews) {
                bufferPair.defaultViews.emplace_back(bufferPair.defaultBuffer->createBufferFormattedView(format));
            }

            // Since the buffers had to be recreated, reupload all the data by modifying the source upload.
            u.srcDataIndexRange.first = 0;
        }
    }

    void BufferUploader::submit(RenderWorker *worker, const std::vector<Upload> &uploads) {
        {
            std::unique_lock<std::mutex> queueLock(workMutex);
            pendingUploads = uploads;
            updateResources(worker, pendingUploads);
            workAvailable = true;
        }

        workCondition.notify_all();
    }

    void BufferUploader::commandListBeforeBarriers(RenderWorker *worker) {
        thread_local std::vector<RenderBufferBarrier> beforeBarriers;
        beforeBarriers.clear();

        for (const Upload &u : pendingUploads) {
            if (!u.valid()) {
                continue;
            }

            auto &defaultBuffer = u.dstPair->defaultBuffer;
            beforeBarriers.push_back(RenderBufferBarrier(defaultBuffer.get(), RenderBufferAccess::WRITE));
        }

        if (!beforeBarriers.empty()) {
            worker->commandList->barriers(RenderBarrierStage::COPY, beforeBarriers);
        }
    }

    void BufferUploader::commandListCopyResources(RenderWorker *worker) {
        for (const Upload &u : pendingUploads) {
            if (!u.valid()) {
                continue;
            }

            const uint64_t srcOffset = u.srcDataIndexRange.first * u.srcDataStride;
            const uint64_t srcSize = (u.srcDataIndexRange.second - u.srcDataIndexRange.first) * u.srcDataStride;
            worker->commandList->copyBufferRegion(u.dstPair->defaultBuffer->at(srcOffset), u.dstPair->uploadBuffer->at(srcOffset), srcSize);
        }
    }

    void BufferUploader::commandListAfterBarriers(RenderWorker *worker) {
        thread_local std::vector<RenderBufferBarrier> afterBarriers;
        afterBarriers.clear();

        for (const Upload &u : pendingUploads) {
            if (!u.valid()) {
                continue;
            }

            auto &defaultBuffer = u.dstPair->defaultBuffer;
            afterBarriers.push_back(RenderBufferBarrier(defaultBuffer.get(), RenderBufferAccess::READ));
        }

        if (!afterBarriers.empty()) {
            worker->commandList->barriers(RenderBarrierStage::ALL, afterBarriers);
        }
    }
    
    void BufferUploader::wait() {
        std::unique_lock<std::mutex> readyLock(readyMutex);
        readyCondition.wait(readyLock, [this]() {
            return !workAvailable;
        });
    }
};