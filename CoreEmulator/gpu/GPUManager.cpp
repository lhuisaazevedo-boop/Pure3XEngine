#include "GPUManager.h"

namespace Pure3X {

bool GPUManager::initialize() {
    initialized_ = true;
    frameCount_ = 0;
    return true;
}

void GPUManager::reset() {
    frameCount_ = 0;
}

void GPUManager::shutdown() {
    initialized_ = false;
}

void GPUManager::beginFrame() {
}

void GPUManager::endFrame() {
    if (initialized_)
        ++frameCount_;
}

std::uint64_t GPUManager::frameCount() const {
    return frameCount_;
}

}
