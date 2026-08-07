#pragma once

#include <string>

namespace Pure3X {

class BootManager {
public:
    bool initialize();
    bool boot(const std::string& executablePath);
    void reset();
    void shutdown();

    bool isRunning() const;

private:
    bool initialized_ = false;
    bool running_ = false;
};

}
