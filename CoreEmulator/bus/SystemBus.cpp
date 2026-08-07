#include "SystemBus.h"

namespace Pure3X {

bool SystemBus::initialize() {
    initialized_ = true;
    return true;
}

void SystemBus::shutdown() {
    initialized_ = false;
}

std::uint64_t SystemBus::read64(std::uint64_t) const {
    return 0;
}

void SystemBus::write64(std::uint64_t, std::uint64_t) {
}

bool SystemBus::isInitialized() const {
    return initialized_;
}

}
