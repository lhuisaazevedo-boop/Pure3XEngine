#include "RSXManager.h"

namespace Pure3X {

bool RSXManager::initialize() {
    commandCount_ = 0;
    initialized_ = true;
    return true;
}

void RSXManager::reset() {
    commandCount_ = 0;
}

void RSXManager::shutdown() {
    initialized_ = false;
}

void RSXManager::submitCommand(std::uint32_t) {
    if (initialized_)
        ++commandCount_;
}

std::uint64_t RSXManager::commandCount() const {
    return commandCount_;
}

}
