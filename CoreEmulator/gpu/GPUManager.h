#pragma once

#include <cstdint>

namespace Pure3X {

class GPUManager {
public:
    bool initialize();
    void reset();
    void shutdown();

    void beginFrame();
    void endFrame();

    std::uint64_t frameCount() const;

private:
    bool initialized_ = false;
    std::uint64_t frameCount_ = 0;
};

}
