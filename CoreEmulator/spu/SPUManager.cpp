#include "SPUManager.h"

namespace Pure3X {

bool SPUManager::initialize() {
    initialized_ = true;
    return true;
}

void SPUManager::reset() {
}

void SPUManager::shutdown() {
    initialized_ = false;
}

bool SPUManager::isInitialized() const {
    return initialized_;
}

}
