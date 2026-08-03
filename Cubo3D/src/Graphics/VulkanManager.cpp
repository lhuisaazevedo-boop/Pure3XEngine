#include "VulkanManager.h"
#include <iostream>

VulkanManager::VulkanManager()
    : mSupported(false)
{
}

VulkanManager::~VulkanManager()
{
}

bool VulkanManager::initialize()
{
    std::cout << "[Vulkan] Verificando suporte..." << std::endl;

    // Futuramente será feita a criação do VkInstance.
    mSupported = false;

    return mSupported;
}

void VulkanManager::shutdown()
{
    std::cout << "[Vulkan] Finalizando..." << std::endl;
}

bool VulkanManager::isSupported() const
{
    return mSupported;
}
