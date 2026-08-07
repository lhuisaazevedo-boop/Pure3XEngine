#pragma once

#include <string>

namespace Pure3X {

class FirmwareManager {
public:
    FirmwareManager() = default;
    ~FirmwareManager() = default;

    bool initialize();
    bool load(const std::string& path);

    void unload();
    void reset();
    void shutdown();

    bool isInitialized() const;
    bool isLoaded() const;

    const std::string& firmwarePath() const;

private:
    bool initialized_ = false;
    bool loaded_ = false;
    std::string firmwarePath_;
};

} // namespace Pure3X
