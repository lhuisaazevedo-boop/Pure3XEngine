#include "SystemManager.h"

namespace Pure3X {

bool SystemManager::initialize() {
    initialized_ = true;
    return true;
}

void SystemManager::reset() {
}

void SystemManager::shutdown() {
    initialized_ = false;
}

bool SystemManager::isInitialized() const {
    return initialized_;
}

}
