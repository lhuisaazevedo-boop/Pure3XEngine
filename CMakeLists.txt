cmake_minimum_required(VERSION 3.22.1)

project(
    Pure3XEngenie
    VERSION 0.2.5
    DESCRIPTION "PlayStation 3 Engine for Android"
    LANGUAGES CXX
)

# ============================================================
# Configuração C++
# ============================================================

# Padrão C++
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Biblioteca compartilhada (.so)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# STL do Android
set(CMAKE_ANDROID_STL_TYPE c++_shared)

# Tipo de build padrão
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

message(STATUS "========================================")
message(STATUS "   Pure3XEngenie v0.2.5 Alpha")
message(STATUS "========================================")
message(STATUS "Engine     : ${PROJECT_NAME}")
message(STATUS "Version    : ${PROJECT_VERSION}")
message(STATUS "Platform   : Android")
message(STATUS "C++        : C++20")
message(STATUS "Build Type : ${CMAKE_BUILD_TYPE}")
message(STATUS "========================================")

# ==========================================================
# Build Options
# ==========================================================

option(PURE3X_BUILD_ANDROID "Build Android backend" ON)
option(PURE3X_BUILD_VIEWER "Build Termux X11 Viewer" OFF)
# ==========================================================
# Android Library
# ==========================================================

add_library(
    lhuis.pure3x
    SHARED
)

# ==========================================================
# Include Directories
# ==========================================================

target_include_directories(
    lhuis.pure3x
    PRIVATE

    include
    src

    CoreEmulation/android/window
    CoreEmulation/android/surface
    CoreEmulation/android
    CoreEmulation/boot
    CoreEmulation/system
    CoreEmulation/graphics
    CoreEmulation/cell
    CoreEmulation/cell/Memory
    CoreEmulation/cell/PPU
    CoreEmulation/cell/SPU
)

# ==========================================================
# Source Files
# ==========================================================

target_sources(
    lhuis.pure3x
    PRIVATE

    # Main
    src/main.cpp

    # Core
    CoreEmulation/Engine.cpp

    # Android
    CoreEmulation/android/core/AndroidCore.cpp
    CoreEmulation/android/runtime/AndroidRuntime.cpp
    CoreEmulation/android/bridge/AndroidBridge.cpp
    CoreEmulation/android/window/AndroidNativeWindow.cpp
    CoreEmulation/android/surface/AndroidSurface.cpp
    CoreEmulation/android/jni/JNIBridge.cpp
    CoreEmulation/android/jni/NativeBridge.cpp
    CoreEmulation/android/filesystem/FileSystem.cpp
    CoreEmulation/android/logs/LogManager.cpp
    CoreEmulation/android/renderer/Renderer.cpp
    CoreEmulation/boot/BootPanel.cpp
    CoreEmulation/version/version.cpp
    CoreEmulation/android/input/InputManager.cpp
    CoreEmulation/android/display/DisplayManager.cpp
    CoreEmulation/menu/InputMenu.cpp

    # Android Managers
    CoreEmulation/android/config/AndroidConfig.cpp
    CoreEmulation/android/system/SystemManager.cpp
    CoreEmulation/android/device/DeviceManager.cpp
    CoreEmulation/android/graphics/GraphicsManager.cpp
    CoreEmulation/android/shaders/ShaderManager.cpp
    CoreEmulation/android/thread/ThreadManager.cpp
    CoreEmulation/android/network/NetworkManager.cpp
    CoreEmulation/android/services/ServiceManager.cpp
    CoreEmulation/android/debug/DebugManager.cpp

    # APK
    CoreEmulation/android/apk/APKLoader.cpp

    # Boot
    CoreEmulation/boot/Boot.cpp
    CoreEmulation/boot/BootMemory.cpp
    CoreEmulation/boot/BootSystem.cpp

    # Scheduler
    CoreEmulation/cell/Scheduler/CellScheduler.cpp

    # System
    CoreEmulation/system/System.cpp

    # Audio
    CoreEmulation/audio/AudioManager.cpp

    # Firmware
    CoreEmulation/firmware/FirmwareManager.cpp

    # Graphics
    CoreEmulation/rsx/Renderer.cpp
    CoreEmulation/graphics/CubeRenderer.cpp

    # Cell
    CoreEmulation/cell/CellSystem.cpp
    CoreEmulation/cell/DMA/DMAManager.cpp
    CoreEmulation/cell/Memory/CellMemory.cpp

    # Memory
    CoreEmulation/cell/Memory/MemoryManager.cpp
    CoreEmulation/cell/Memory/DMAController.cpp

    # PPU
    CoreEmulation/cell/PPU/PPUState.cpp
    CoreEmulation/cell/PPU/PPUInterpreter.cpp
    CoreEmulation/cell/PPU/InstructionDecoder.cpp
    CoreEmulation/cell/PPU/InstructionExecutor.cpp

    # SPU
    CoreEmulation/cell/SPU/SPUState.cpp
    CoreEmulation/cell/SPU/SPUInterpreter.cpp

    # Vulkan
    CoreEmulation/Graphics/Vulkan/VulkanContext.cpp
)

# ==========================================================
# Link Libraries
# ==========================================================

find_package(Threads REQUIRED)

if(PURE3X_BUILD_ANDROID)

    # Bibliotecas nativas do Android
    find_library(LOG_LIB log)
    if(NOT LOG_LIB)
        set(LOG_LIB log)
    endif()

    find_library(ANDROID_LIB android)
    if(NOT ANDROID_LIB)
        set(ANDROID_LIB android)
    endif()

    find_library(JNIGRAPHICS_LIB jnigraphics)
    if(NOT JNIGRAPHICS_LIB)
        set(JNIGRAPHICS_LIB jnigraphics)
    endif()

    if(ANDROID)
    set(VULKAN_LIB vulkan)
    else()
    find_library(VULKAN_LIB vulkan)
    endif()

    target_link_libraries(
        lhuis.pure3x
        PRIVATE
        Threads::Threads
        ${LOG_LIB}
        ${ANDROID_LIB}
        ${JNIGRAPHICS_LIB}
        ${VULKAN_LIB}
    )

endif()
# ==========================================================
# Compiler Options
# ==========================================================

target_compile_options(
    lhuis.pure3x
    PRIVATE
        -Wall
        -Wextra
        -Wno-unused-parameter
        -fexceptions
        -frtti
)

# ==========================================================
# Build Configuration
# ==========================================================

target_compile_definitions(
    lhuis.pure3x
    PRIVATE
        PURE3X_ENGINE
        PURE3X_ANDROID
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(
        lhuis.pure3x
        PRIVATE
            DEBUG_BUILD=1
    )
else()
    target_compile_definitions(
        lhuis.pure3x
        PRIVATE
            RELEASE_BUILD=1
            NDEBUG
    )
endif()

# ==========================================================
# Output Properties
# ==========================================================

set_target_properties(
    lhuis.pure3x
    PROPERTIES
        OUTPUT_NAME "lhuis.pure3x"
)

# ==========================================================
# Build Summary
# ==========================================================

message(STATUS "")
message(STATUS "==========================================")
message(STATUS "      Pure3XEngenie v0.2.5 Alpha")
message(STATUS "==========================================")
message(STATUS "Engine      : Pure3XEngenie")
message(STATUS "Library     : lhuis.pure3x")
message(STATUS "Platform    : Android")
message(STATUS "C++         : C++20")
message(STATUS "Build Type  : ${CMAKE_BUILD_TYPE}")

if(VULKAN_LIB)
    message(STATUS "Graphics    : Vulkan Enabled")
else()
    message(STATUS "Graphics    : Vulkan Disabled")
endif()

message(STATUS "==========================================")
message(STATUS "Configuration completed successfully.")
message(STATUS "==========================================")

# ==========================================================
# Termux X11 Viewer (Development)
# ==========================================================

if(PURE3X_BUILD_VIEWER)

    add_executable(Pure3XViewer
        viewer/main.cpp

        # Núcleo
        viewer/Application.cpp
        viewer/RenderLoop.cpp
        viewer/Scene.cpp
        viewer/Window.cpp

        # Renderização
        viewer/Renderer.cpp
        viewer/RendererGL.cpp
        viewer/EGLContext.cpp
        viewer/Pure3XEGLContext.cpp

        # Android
        CoreEmulation/android/window/AndroidNativeWindow.cpp
        CoreEmulation/android/surface/AndroidSurface.cpp

        # Câmera e Objetos
        viewer/Camera.cpp
        viewer/Cube.cpp
        viewer/Model.cpp
        viewer/Mesh.cpp
        viewer/Transform.cpp

        # Buffers
        viewer/VertexBuffer.cpp
        viewer/IndexBuffer.cpp
        viewer/VertexArray.cpp

        # Shaders
        viewer/Shader.cpp
        viewer/Texture.cpp
        viewer/Material.cpp

        # Matemática
        viewer/Vector3.cpp
        viewer/Matrix4.cpp

        # Sistema
        viewer/Engine.cpp
        viewer/Logger.cpp
        viewer/Input.cpp
        viewer/FPSCounter.cpp
        viewer/ResourceManager.cpp
    )

    target_compile_features(Pure3XViewer PRIVATE cxx_std_20)

    target_include_directories(
        Pure3XViewer
        PRIVATE
            ${CMAKE_SOURCE_DIR}/viewer
            ${CMAKE_SOURCE_DIR}
            ${CMAKE_SOURCE_DIR}/CoreEmulation
            ${CMAKE_SOURCE_DIR}/CoreEmulation/android
            /data/data/com.termux/files/usr/include
    )

    target_link_libraries(
        Pure3XViewer
        PRIVATE
            EGL
            GLESv2
            X11
            pthread
            dl
            m
    )

endif()
