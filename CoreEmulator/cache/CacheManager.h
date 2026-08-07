#pragma once

#include <cstddef>

namespace Pure3X {

class CacheManager {
public:
    bool initialize();
    void clear();
    void shutdown();

    std::size_t entryCount() const;

private:
    bool initialized_ = false;
    std::size_t entries_ = 0;
};

}
