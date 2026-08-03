#pragma once

class CubeRenderer {
public:
    CubeRenderer();
    ~CubeRenderer();

    bool initialize();

    void update(float deltaTime);
    void render();

    void shutdown();

private:
    float mRotation;
};
