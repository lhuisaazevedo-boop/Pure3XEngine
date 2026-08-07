#pragma once
#include <cstdint>

namespace Pure3X {

class RSXManager {
public:
    bool initialize();
    void reset();
    void shutdown();

    void submitCommand(std::uint32_t command);
    std::uint64_t commandCount() const;

private:
    bool initialized_ = false;
    std::uint64_t commandCount_ = 0;
};

}
