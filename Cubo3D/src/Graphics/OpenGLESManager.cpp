#include "OpenGLESManager.h"
#include <iostream>

OpenGLESManager::OpenGLESManager()
    : mInitialized(false)
{
}

OpenGLESManager::~OpenGLESManager()
{
}

bool OpenGLESManager::initialize()
{
    std::cout << "[OpenGL ES] Inicializando contexto..." << std::endl;

    mInitialized = true;
    return true;
}

void OpenGLESManager::shutdown()
{
    std::cout << "[OpenGL ES] Finalizando..." << std::endl;

    mInitialized = false;
}

void OpenGLESManager::beginFrame()
{
    if (!mInitialized)
        return;

    // Aqui depois ficará glClear().
}

void OpenGLESManager::endFrame()
{
    if (!mInitialized)
        return;

    // Aqui depois ficará eglSwapBuffers().
}
