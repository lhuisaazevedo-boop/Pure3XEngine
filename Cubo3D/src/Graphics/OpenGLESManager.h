#pragma once

class OpenGLESManager {
public:
    OpenGLESManager();
    ~OpenGLESManager();

    bool initialize();
    void shutdown();

    void beginFrame();
    void endFrame();

private:
    bool mInitialized;
};
