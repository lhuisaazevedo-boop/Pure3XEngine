#include "GraphicsManager.h"
#include <iostream>

GraphicsManager::GraphicsManager()
    : mOpenGLES(false),
      mVulkan(false)
{
}

bool GraphicsManager::initialize()
{
    initializeOpenGLES();
    initializeVulkan();
    return true;
}

void GraphicsManager::initializeOpenGLES()
{
    std::cout << "[Graphics] Inicializando OpenGL ES..." << std::endl;
    mOpenGLES = true;
}

void GraphicsManager::initializeVulkan()
{
    std::cout << "[Graphics] Procurando suporte Vulkan..." << std::endl;

    // Por enquanto apenas marca como indisponível.
    mVulkan = false;
}

void GraphicsManager::renderFrame()
{
    // Aqui depois será chamado o CubeRenderer.
}
