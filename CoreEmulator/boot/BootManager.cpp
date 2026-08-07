#include "BootManager.h"

namespace Pure3X {

bool BootManager::initialize() {
    initialized_ = true;
    running_ = false;
    return true;
}

bool BootManager::boot(const std::string& executablePath) {
    if (!initialized_ || executablePath.empty())
        return false;

    running_ = true;
    return true;
}

void BootManager::reset() {
    running_ = false;
}

void BootManager::shutdown() {
    running_ = false;
    initialized_ = false;
}

bool BootManager::isRunning() const {
    return running_;
}

}
