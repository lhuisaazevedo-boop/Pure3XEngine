#pragma once

class CubeRenderer {
public:
    CubeRenderer();
    ~CubeRenderer();

    bool initialize();

    void resize(int width, int height);
    void update(float deltaTime);
    void render();

    void shutdown();

private:
    float mRotation;
    int mWidth;
    int mHeight;
    unsigned int mProgram;
    unsigned int mVertexArray;
    unsigned int mVertexBuffer;
    unsigned int mIndexBuffer;
    int mMvpLocation;
};
