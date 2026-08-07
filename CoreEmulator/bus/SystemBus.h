#pragma once
#include <cstdint>

namespace Pure3X {

class SystemBus {
public:
    bool initialize();
    void shutdown();

    std::uint64_t read64(std::uint64_t address) const;
    void write64(std::uint64_t address, std::uint64_t value);

    bool isInitialized() const;

private:
    bool initialized_ = false;
};

}
