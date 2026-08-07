#include "DiscManager.h"

namespace Pure3X {

bool DiscManager::mount(const std::string& path) {
    if (path.empty())
        return false;

    path_ = path;
    mounted_ = true;
    return true;
}

void DiscManager::unmount() {
    mounted_ = false;
    path_.clear();
}

bool DiscManager::isMounted() const {
    return mounted_;
}

const std::string& DiscManager::path() const {
    return path_;
}

}
