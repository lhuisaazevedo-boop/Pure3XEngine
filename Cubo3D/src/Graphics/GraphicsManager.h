#pragma once

class GraphicsManager {
public:
    GraphicsManager();

    bool initialize();
    void initializeOpenGLES();
    void initializeVulkan();

    void renderFrame();

private:
    bool mOpenGLES;
    bool mVulkan;
};
