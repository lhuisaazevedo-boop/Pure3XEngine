#include "ConfigManager.h"

#include <fstream>
#include <iostream>

namespace Pure3X {

bool ConfigManager::LoadConfig(const std::string& path)
{
    std::ifstream file(path);

    if (!file.is_open())
    {
        std::cout << "[Config] config.ini nao encontrado: "
                  << path << std::endl;

        return false;
    }

    std::cout << "[Config] Carregando configuracoes..."
              << std::endl;

    std::string line;

    while (std::getline(file, line))
    {
        if (line.empty())
            continue;

        if (line[0] == '#')
            continue;

        std::cout << "[Config] " << line
                  << std::endl;
    }

    file.close();

    std::cout << "[Config] Configuracoes carregadas."
              << std::endl;

    return true;
}

void ConfigManager::SaveConfig(const std::string& path)
{
    std::ofstream file(path);

    if (!file.is_open())
    {
        std::cout << "[Config] Erro ao salvar config.ini"
                  << std::endl;

        return;
    }

    file << "# Pure3XEngine v0.1.9 Alpha\n";
    file << "\n";

    file << "[Engine]\n";
    file << "Version=0.1.9 Alpha\n";
    file << "Language=pt_BR\n";
    file << "Profile=Auto\n";

    file.close();

    std::cout << "[Config] Configuracoes salvas."
              << std::endl;
}

} // namespace Pure3X
