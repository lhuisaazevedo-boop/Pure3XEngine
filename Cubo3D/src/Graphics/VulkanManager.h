#pragma once

class VulkanManager {
public:
    VulkanManager();
    ~VulkanManager();

    bool initialize();
    void shutdown();

    bool isSupported() const;

private:
    bool mSupported;
};
