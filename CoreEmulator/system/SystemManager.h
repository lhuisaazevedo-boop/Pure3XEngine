#pragma once

namespace Pure3X {

class SystemManager {
public:
    bool initialize();
    void reset();
    void shutdown();

    bool isInitialized() const;

private:
    bool initialized_ = false;
};

}
