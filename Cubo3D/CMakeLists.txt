cmake_minimum_required(VERSION 3.22.1)

project(
    Cubo3D
    VERSION 0.1.0
    LANGUAGES C CXX
)

# ============================================================
# C++ Configuration
# ============================================================

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ============================================================
# Android Defaults
# ============================================================

if(ANDROID)

    if(NOT ANDROID_ABI)
        set(ANDROID_ABI arm64-v8a)
    endif()

    if(NOT ANDROID_PLATFORM)
        set(ANDROID_PLATFORM android-29)
    endif()

endif()

# ============================================================
# Cubo3D Library
# ============================================================

add_library(Cubo3D SHARED)

target_sources(Cubo3D PRIVATE

    src/main.cpp
    src/Engine.cpp
    src/Renderer.cpp
    src/Camera.cpp
    src/Cube.cpp
    src/Mesh.cpp
    src/Shader.cpp
    src/Texture.cpp
    src/Material.cpp
    src/Transform.cpp
    src/Scene.cpp
    src/ResourceManager.cpp
    src/FPSCounter.cpp
    src/Logger.cpp

    src/Graphics/GraphicsManager.cpp
    src/Graphics/OpenGLESManager.cpp
    src/Graphics/VulkanManager.cpp
    src/Graphics/CubeRenderer.cpp

)

target_include_directories(Cubo3D PRIVATE

    include
    src
    src/Graphics

)

# ============================================================
# Compile Options
# ============================================================

target_compile_options(Cubo3D PRIVATE

    -Wall
    -Wextra
    -O2

)

# ============================================================
# Threads
# ============================================================

find_package(Threads REQUIRED)

target_link_libraries(Cubo3D PRIVATE
    Threads::Threads
)

# ============================================================
# Android Libraries
# ============================================================

if(ANDROID)

    find_library(LOG_LIB log)
    find_library(ANDROID_LIB android)
    find_library(EGL_LIB EGL)
    find_library(GLES3_LIB GLESv3)

    target_link_libraries(Cubo3D PRIVATE

        ${LOG_LIB}
        ${ANDROID_LIB}
        ${EGL_LIB}
        ${GLES3_LIB}

    )

endif()

# ============================================================
# Build Information
# ============================================================

message(STATUS "")
message(STATUS "========================================")
message(STATUS "          Cubo3D Engine")
message(STATUS "========================================")
message(STATUS "Version      : ${PROJECT_VERSION}")
message(STATUS "Platform     : ${CMAKE_SYSTEM_NAME}")
message(STATUS "ABI          : ${ANDROID_ABI}")
message(STATUS "API Level    : ${ANDROID_PLATFORM}")
message(STATUS "Compiler     : ${CMAKE_CXX_COMPILER}")
message(STATUS "Output       : libCubo3D.so")
message(STATUS "========================================")
message(STATUS "")
