#include "CacheManager.h"

namespace Pure3X {

bool CacheManager::initialize() {
    initialized_ = true;
    entries_ = 0;
    return true;
}

void CacheManager::clear() {
    entries_ = 0;
}

void CacheManager::shutdown() {
    clear();
    initialized_ = false;
}

std::size_t CacheManager::entryCount() const {
    return entries_;
}

}
