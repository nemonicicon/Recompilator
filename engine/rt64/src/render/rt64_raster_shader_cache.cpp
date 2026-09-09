//
// RT64
//

#include "rt64_raster_shader_cache.h"

#include "common/rt64_thread.h"

#include <cstdio>
#include <cstdlib>

#define ENABLE_OPTIMIZED_SHADER_GENERATION

namespace RT64 {
    // ── Material-census pipeline PREWARM (kill the runtime shader-compile stutter) ──────────
    // The shader-compile stutter (P0-measured: 126-136ms hitches) = RT64 compiling an OPTIMIZED per-material pipeline
    // on-demand the first time each material appears (~33 over an sm64 run). RT64_SHADER_CENSUS=<file>:
    //   • during a run, every UNIQUE material's ShaderDescription is appended to <file> (the capture);
    //   • at setup(), if <file> exists, ALL of them are compiled UP FRONT (a bounded boot cost) so no
    //     optimized-shader compile ever happens mid-gameplay.
    // ShaderDescription is a #pragma pack(1) POD (combiner+othermode+flags) → raw fread/fwrite. This same
    // census IS the static material enumeration — the prewarm and the enumeration build one artifact, not two.
    static const char *shaderCensusPath() {
        static const char *p = getenv("RT64_SHADER_CENSUS");
        return (p && p[0]) ? p : nullptr;
    }

    // RasterShaderCache::CompilationThread
    
    RasterShaderCache::CompilationThread::CompilationThread(RasterShaderCache *shaderCache) {
        assert(shaderCache != nullptr);

        this->shaderCache = shaderCache;

        thread = std::make_unique<std::thread>(&CompilationThread::loop, this);
        threadRunning = false;
    }

    RasterShaderCache::CompilationThread::~CompilationThread() {
        threadRunning = false;
        shaderCache->descQueueChanged.notify_all();
        thread->join();
        thread.reset(nullptr);
    }

    void RasterShaderCache::CompilationThread::loop() {
        Thread::setCurrentThreadName("RT64 Shader");

        // The shader compilation thread should have idle priority by default as the application can use the ubershader in the meantime.
        Thread::setCurrentThreadPriority(Thread::Priority::Idle);

        threadRunning = true;

        while (threadRunning) {
            ShaderDescription shaderDesc;
            bool fromPriorityQueue = false;
            
            // Check the top of the queue or wait if it's empty.
            {
                std::unique_lock<std::mutex> queueLock(shaderCache->descQueueMutex);
                shaderCache->descQueueActiveCount--;
                shaderCache->descQueueChanged.wait(queueLock, [this]() {
                    return !threadRunning || !shaderCache->descQueue.empty();
                });

                shaderCache->descQueueActiveCount++;
                if (!shaderCache->descQueue.empty()) {
                    shaderDesc = shaderCache->descQueue.front();
                    shaderCache->descQueue.pop();
                    fromPriorityQueue = true;
                }
            }
            
            // Compile the shader at the top of the queue.
            if (fromPriorityQueue) {
                assert((shaderCache->shaderUber != nullptr) && "Ubershader should've been created by the time a new shader is submitted to the cache.");
                const RenderPipelineLayout *uberPipelineLayout = shaderCache->shaderUber->pipelineLayout.get();
                const RenderMultisampling multisampling = shaderCache->multisampling;
                std::unique_ptr<RasterShader> newShader = std::make_unique<RasterShader>(shaderCache->device, shaderDesc, uberPipelineLayout, shaderCache->shaderFormat, multisampling, shaderCache->shaderCompiler.get(), &shaderCache->optimizerCacheSPIRV);

                {
                    const std::unique_lock<std::mutex> lock(shaderCache->GPUShadersMutex);
                    shaderCache->GPUShaders[shaderDesc.hash()] = std::move(newShader);
                }
            }
        }
    }

    // RasterShaderCache

    RasterShaderCache::RasterShaderCache(uint32_t threadCount, uint32_t ubershaderThreadCount) {
        assert(threadCount > 0);

        this->threadCount = threadCount;
        this->ubershaderThreadCount = ubershaderThreadCount;

#ifdef ENABLE_OPTIMIZED_SHADER_GENERATION
#   ifdef _WIN32
        shaderCompiler = std::make_unique<ShaderCompiler>();
#   endif

        descQueueActiveCount = threadCount;

        for (uint32_t t = 0; t < threadCount; t++) {
            compilationThreads.push_back(std::make_unique<CompilationThread>(this));
        }
#endif
    }

    RasterShaderCache::~RasterShaderCache() {
        compilationThreads.clear();
    }

    void RasterShaderCache::setup(RenderDevice *device, RenderShaderFormat shaderFormat, const ShaderLibrary *shaderLibrary, const RenderMultisampling &multisampling) {
        assert(device != nullptr);

        this->device = device;
        this->shaderFormat = shaderFormat;
        this->multisampling = multisampling;

        shaderUber = std::make_unique<RasterShaderUber>(device, shaderFormat, multisampling, shaderLibrary, ubershaderThreadCount);
        usesHDR = shaderLibrary->usesHDR;

        // Initialize the re-spirv optimizer cache.
        if (shaderFormat == RenderShaderFormat::SPIRV) {
            optimizerCacheSPIRV.initialize();
        }

        // PREWARM: if a census exists, compile every recorded material NOW (synchronously,
        // mirroring CompilationThread::loop) so no optimized-shader compile happens mid-gameplay. The
        // uber's pipelineLayout + the SPIRV optimizer cache are both ready above, which is all the
        // RasterShader constructor needs (shaderCompiler is Windows-dxc-only; the SPIRV/re-spirv path
        // used on ARM doesn't need it). Bounded boot cost; zero runtime hitches after.
        if (const char *cp = shaderCensusPath()) {
            std::ifstream f(cp, std::ios::binary);
            if (f) {
                f.seekg(0, std::ios::end);
                const std::streamoff sz = f.tellg();
                f.seekg(0, std::ios::beg);
                if (sz > 0 && (static_cast<size_t>(sz) % sizeof(ShaderDescription)) == 0) {
                    const size_t n = static_cast<size_t>(sz) / sizeof(ShaderDescription);
                    const RenderPipelineLayout *uberPipelineLayout = shaderUber->pipelineLayout.get();
                    size_t built = 0;
                    for (size_t i = 0; i < n; i++) {
                        ShaderDescription d{};
                        if (!f.read(reinterpret_cast<char *>(&d), sizeof(ShaderDescription))) break;
                        const uint64_t h = d.hash();
                        if (shaderHashes[h]) continue;              // already known (dup in census)
                        shaderHashes[h] = true;                     // mark so gameplay submit() won't re-queue it
                        auto sh = std::make_unique<RasterShader>(device, d, uberPipelineLayout, shaderFormat,
                            multisampling, shaderCompiler.get(), &optimizerCacheSPIRV);
                        GPUShaders[h] = std::move(sh);
                        built++;
                    }
                    fprintf(stderr, "[shadercensus] prewarmed %zu/%zu pipelines from %s\n", built, n, cp);
                    fflush(stderr);
                }
                else if (sz > 0) {
                    fprintf(stderr, "[shadercensus] IGNORED %s (size %lld not a multiple of ShaderDescription=%zu — stale/corrupt)\n",
                        cp, (long long)sz, sizeof(ShaderDescription));
                    fflush(stderr);
                }
            }
        }
    }

    void RasterShaderCache::submit(const ShaderDescription &desc) {
        {
            std::unique_lock<std::mutex> queueLock(submissionMutex);

            // Verify if an entry with the same hash was already submitted before.
            const uint64_t shaderHash = desc.hash();
            bool &found = shaderHashes[shaderHash];
            if (found) {
                return;
            }

            found = true;

            // Census capture: record this new unique material so a later boot can prewarm it (P1/P2).
            if (const char *cp = shaderCensusPath()) {
                std::ofstream f(cp, std::ios::binary | std::ios::app);
                if (f) f.write(reinterpret_cast<const char *>(&desc), sizeof(ShaderDescription));
            }
        }

        // Push a new shader compilation to the queue.
        {
            const std::unique_lock<std::mutex> queueLock(descQueueMutex);
            descQueue.push(desc);
        }

        descQueueChanged.notify_all();
    }
    
    void RasterShaderCache::waitForAll() {
        {
            std::unique_lock<std::mutex> queueLock(descQueueMutex);
            descQueue = std::queue<ShaderDescription>();
        }

        bool keepWaiting = false;
        do {
            std::unique_lock<std::mutex> queueLock(descQueueMutex);
            keepWaiting = (descQueueActiveCount > 0);
        } while (keepWaiting);
    }

    void RasterShaderCache::destroyAll() {
        {
            std::unique_lock<std::mutex> lock(GPUShadersMutex);
            GPUShaders.clear();
        }

        {
            std::unique_lock<std::mutex> queueLock(submissionMutex);
            shaderHashes.clear();
        }
    }

    RasterShader *RasterShaderCache::getGPUShader(const ShaderDescription &desc) {
        const uint64_t shaderHash = desc.hash();

        const std::unique_lock<std::mutex> lock(GPUShadersMutex);
        auto shaderIt = GPUShaders.find(shaderHash);
        if (shaderIt == GPUShaders.end()) {
            return nullptr;
        }

        return shaderIt->second.get();
    }

    RasterShaderUber *RasterShaderCache::getGPUShaderUber() const {
        return shaderUber.get();
    }

    uint32_t RasterShaderCache::shaderCount() {
        std::unique_lock<std::mutex> lock(GPUShadersMutex);
        return GPUShaders.size();
    }
};