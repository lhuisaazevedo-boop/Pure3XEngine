#include "CubeRenderer.h"
#include <iostream>

CubeRenderer::CubeRenderer()
    : mRotation(0.0f)
{
}

CubeRenderer::~CubeRenderer()
{
}

bool CubeRenderer::initialize()
{
    std::cout << "[CubeRenderer] Inicializando Cubo 3D..." << std::endl;

    return true;
}

void CubeRenderer::update(float deltaTime)
{
    mRotation += deltaTime * 90.0f;

    if (mRotation >= 360.0f)
        mRotation -= 360.0f;
}

void CubeRenderer::render()
{
    std::cout << "[CubeRenderer] Renderizando Cubo Verde..." << std::endl;

    // Em breve:
    // glClear()
    // Shader
    // VBO
    // VAO
    // glDrawArrays()
}

void CubeRenderer::shutdown()
{
    std::cout << "[CubeRenderer] Finalizando..." << std::endl;
}
