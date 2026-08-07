#pragma once
#include <cstdint>

namespace Pure3X {

class PPUInterpreter {
public:
    bool initialize();
    void reset();
    void shutdown();

    bool step();
    std::uint64_t programCounter() const;

private:
    bool initialized_ = false;
    std::uint64_t pc_ = 0;
};

}
