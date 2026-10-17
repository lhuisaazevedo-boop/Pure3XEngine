#include "CubeRenderer.h"

#include <GLES3/gl3.h>
#include <android/log.h>

#include <array>
#include <cmath>
#include <cstddef>

namespace {

constexpr char kTag[] = "Cubo3D-Native";

constexpr char kVertexShader[] = R"(#version 300 es
layout(location = 0) in vec3 aPosition;
layout(location = 1) in vec3 aColor;
uniform mat4 uMvp;
out vec3 vColor;
void main() {
    gl_Position = uMvp * vec4(aPosition, 1.0);
    vColor = aColor;
}
)";

constexpr char kFragmentShader[] = R"(#version 300 es
precision mediump float;
in vec3 vColor;
out vec4 fragColor;
void main() {
    fragColor = vec4(vColor, 1.0);
}
)";

constexpr GLfloat kVertices[] = {
    // Front
    -0.5f, -0.5f,  0.5f, 0.10f, 0.78f, 0.20f,
     0.5f, -0.5f,  0.5f, 0.10f, 0.78f, 0.20f,
     0.5f,  0.5f,  0.5f, 0.10f, 0.78f, 0.20f,
    -0.5f,  0.5f,  0.5f, 0.10f, 0.78f, 0.20f,
    // Back
     0.5f, -0.5f, -0.5f, 0.07f, 0.56f, 0.15f,
    -0.5f, -0.5f, -0.5f, 0.07f, 0.56f, 0.15f,
    -0.5f,  0.5f, -0.5f, 0.07f, 0.56f, 0.15f,
     0.5f,  0.5f, -0.5f, 0.07f, 0.56f, 0.15f,
    // Left
    -0.5f, -0.5f, -0.5f, 0.08f, 0.64f, 0.17f,
    -0.5f, -0.5f,  0.5f, 0.08f, 0.64f, 0.17f,
    -0.5f,  0.5f,  0.5f, 0.08f, 0.64f, 0.17f,
    -0.5f,  0.5f, -0.5f, 0.08f, 0.64f, 0.17f,
    // Right
     0.5f, -0.5f,  0.5f, 0.13f, 0.88f, 0.23f,
     0.5f, -0.5f, -0.5f, 0.13f, 0.88f, 0.23f,
     0.5f,  0.5f, -0.5f, 0.13f, 0.88f, 0.23f,
     0.5f,  0.5f,  0.5f, 0.13f, 0.88f, 0.23f,
    // Top
    -0.5f,  0.5f,  0.5f, 0.16f, 0.94f, 0.28f,
     0.5f,  0.5f,  0.5f, 0.16f, 0.94f, 0.28f,
     0.5f,  0.5f, -0.5f, 0.16f, 0.94f, 0.28f,
    -0.5f,  0.5f, -0.5f, 0.16f, 0.94f, 0.28f,
    // Bottom
    -0.5f, -0.5f, -0.5f, 0.05f, 0.46f, 0.12f,
     0.5f, -0.5f, -0.5f, 0.05f, 0.46f, 0.12f,
     0.5f, -0.5f,  0.5f, 0.05f, 0.46f, 0.12f,
    -0.5f, -0.5f,  0.5f, 0.05f, 0.46f, 0.12f
};

constexpr GLushort kIndices[] = {
     0,  1,  2,  0,  2,  3,
     4,  5,  6,  4,  6,  7,
     8,  9, 10,  8, 10, 11,
    12, 13, 14, 12, 14, 15,
    16, 17, 18, 16, 18, 19,
    20, 21, 22, 20, 22, 23
};

using Matrix = std::array<float, 16>;

Matrix multiply(const Matrix& left, const Matrix& right)
{
    Matrix result{};
    for (int column = 0; column < 4; ++column) {
        for (int row = 0; row < 4; ++row) {
            for (int index = 0; index < 4; ++index) {
                result[column * 4 + row] +=
                    left[index * 4 + row] * right[column * 4 + index];
            }
        }
    }
    return result;
}

GLuint compileShader(GLenum type, const char* source)
{
    const GLuint shader = glCreateShader(type);
    if (shader == 0) {
        __android_log_print(ANDROID_LOG_ERROR, kTag, "glCreateShader falhou.");
        return 0;
    }

    glShaderSource(shader, 1, &source, nullptr);
    glCompileShader(shader);

    GLint compiled = GL_FALSE;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (compiled != GL_TRUE) {
        GLchar log[1024]{};
        GLsizei length = 0;
        glGetShaderInfoLog(shader, sizeof(log), &length, log);
        __android_log_print(
            ANDROID_LOG_ERROR,
            kTag,
            "Falha compilando shader: %.*s",
            static_cast<int>(length),
            log
        );
        glDeleteShader(shader);
        return 0;
    }

    return shader;
}

} // namespace

CubeRenderer::CubeRenderer()
    : mRotation(0.0f),
      mWidth(0),
      mHeight(0),
      mProgram(0),
      mVertexArray(0),
      mVertexBuffer(0),
      mIndexBuffer(0),
      mMvpLocation(-1)
{
}

CubeRenderer::~CubeRenderer() = default;

bool CubeRenderer::initialize()
{
    while (glGetError() != GL_NO_ERROR) {
    }

    const GLuint vertexShader = compileShader(GL_VERTEX_SHADER, kVertexShader);
    if (vertexShader == 0) {
        return false;
    }

    const GLuint fragmentShader = compileShader(GL_FRAGMENT_SHADER, kFragmentShader);
    if (fragmentShader == 0) {
        glDeleteShader(vertexShader);
        return false;
    }

    mProgram = glCreateProgram();
    if (mProgram == 0) {
        __android_log_print(ANDROID_LOG_ERROR, kTag, "glCreateProgram falhou.");
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return false;
    }

    glAttachShader(mProgram, vertexShader);
    glAttachShader(mProgram, fragmentShader);
    glLinkProgram(mProgram);
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    GLint linked = GL_FALSE;
    glGetProgramiv(mProgram, GL_LINK_STATUS, &linked);
    if (linked != GL_TRUE) {
        GLchar log[1024]{};
        GLsizei length = 0;
        glGetProgramInfoLog(mProgram, sizeof(log), &length, log);
        __android_log_print(
            ANDROID_LOG_ERROR,
            kTag,
            "Falha vinculando programa: %.*s",
            static_cast<int>(length),
            log
        );
        glDeleteProgram(mProgram);
        mProgram = 0;
        return false;
    }

    mMvpLocation = glGetUniformLocation(mProgram, "uMvp");
    glGenVertexArrays(1, &mVertexArray);
    glGenBuffers(1, &mVertexBuffer);
    glGenBuffers(1, &mIndexBuffer);

    glBindVertexArray(mVertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(kVertices), kVertices, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(kIndices), kIndices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), nullptr);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(
        1,
        3,
        GL_FLOAT,
        GL_FALSE,
        6 * sizeof(GLfloat),
        reinterpret_cast<const void*>(3 * sizeof(GLfloat))
    );
    glBindVertexArray(0);

    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);

    const GLenum error = glGetError();
    if (error != GL_NO_ERROR || mVertexArray == 0 ||
        mVertexBuffer == 0 || mIndexBuffer == 0 || mMvpLocation < 0) {
        __android_log_print(
            ANDROID_LOG_ERROR,
            kTag,
            "Inicialização GLES falhou: erro=0x%x",
            error
        );
        shutdown();
        return false;
    }

    return true;
}

void CubeRenderer::resize(int width, int height)
{
    mWidth = width;
    mHeight = height;
    if (width > 0 && height > 0) {
        glViewport(0, 0, width, height);
    }
}

void CubeRenderer::update(float deltaTime)
{
    if (std::isfinite(deltaTime) && deltaTime > 0.0f) {
        mRotation = std::fmod(mRotation + deltaTime * 90.0f, 360.0f);
    }
}

void CubeRenderer::render()
{
    if (mProgram == 0 || mVertexArray == 0 || mWidth <= 0 || mHeight <= 0) {
        return;
    }

    glClearColor(0.05f, 0.12f, 0.22f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    const float radians = mRotation * 0.01745329251994329577f;
    const float cosineX = std::cos(radians * 0.7f);
    const float sineX = std::sin(radians * 0.7f);
    const float cosineY = std::cos(radians);
    const float sineY = std::sin(radians);

    const Matrix rotationX = {
        1, 0, 0, 0,
        0, cosineX, sineX, 0,
        0, -sineX, cosineX, 0,
        0, 0, 0, 1
    };
    const Matrix rotationY = {
        cosineY, 0, -sineY, 0,
        0, 1, 0, 0,
        sineY, 0, cosineY, 0,
        0, 0, 0, 1
    };
    const Matrix view = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, -4, 1
    };

    constexpr float nearPlane = 0.1f;
    constexpr float farPlane = 100.0f;
    constexpr float fieldOfView = 1.04719755119659774615f;
    const float focalLength = 1.0f / std::tan(fieldOfView * 0.5f);
    const float aspect = static_cast<float>(mWidth) / static_cast<float>(mHeight);
    const Matrix projection = {
        focalLength / aspect, 0, 0, 0,
        0, focalLength, 0, 0,
        0, 0, (farPlane + nearPlane) / (nearPlane - farPlane), -1,
        0, 0, (2.0f * farPlane * nearPlane) / (nearPlane - farPlane), 0
    };
    const Matrix model = multiply(rotationY, rotationX);
    const Matrix mvp = multiply(projection, multiply(view, model));

    glUseProgram(mProgram);
    glUniformMatrix4fv(mMvpLocation, 1, GL_FALSE, mvp.data());
    glBindVertexArray(mVertexArray);
    glDrawElements(
        GL_TRIANGLES,
        static_cast<GLsizei>(sizeof(kIndices) / sizeof(kIndices[0])),
        GL_UNSIGNED_SHORT,
        nullptr
    );
    glBindVertexArray(0);
}

void CubeRenderer::shutdown()
{
    if (mIndexBuffer != 0) {
        glDeleteBuffers(1, &mIndexBuffer);
        mIndexBuffer = 0;
    }
    if (mVertexBuffer != 0) {
        glDeleteBuffers(1, &mVertexBuffer);
        mVertexBuffer = 0;
    }
    if (mVertexArray != 0) {
        glDeleteVertexArrays(1, &mVertexArray);
        mVertexArray = 0;
    }
    if (mProgram != 0) {
        glDeleteProgram(mProgram);
        mProgram = 0;
    }
    mMvpLocation = -1;
}
