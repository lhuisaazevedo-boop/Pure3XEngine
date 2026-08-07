#pragma once
#include <cstddef>

namespace Pure3X {

class SPUManager {
public:
    static constexpr std::size_t MaxSPUs = 6;

    bool initialize();
    void reset();
    void shutdown();

    bool isInitialized() const;

private:
    bool initialized_ = false;
};

}
