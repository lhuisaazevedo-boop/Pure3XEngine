#include "FirmwareManager.h"

namespace Pure3X {

bool FirmwareManager::initialize() {
    if (initialized_)
        return true;

    initialized_ = true;
    loaded_ = false;
    firmwarePath_.clear();

    return true;
}

bool FirmwareManager::load(const std::string& path) {
    if (!initialized_)
        return false;

    if (path.empty())
        return false;

    firmwarePath_ = path;
    loaded_ = true;

    return true;
}

void FirmwareManager::unload() {
    loaded_ = false;
    firmwarePath_.clear();
}

void FirmwareManager::reset() {
    unload();
}

void FirmwareManager::shutdown() {
    unload();
    initialized_ = false;
}

bool FirmwareManager::isInitialized() const {
    return initialized_;
}

bool FirmwareManager::isLoaded() const {
    return loaded_;
}

const std::string& FirmwareManager::firmwarePath() const {
    return firmwarePath_;
}

} // namespace Pure3X
