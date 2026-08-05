#include "MemoryManager.h"
#include <iostream>

namespace Pure3X {

void MemoryManager::ShowInfo()
{
    std::cout << "\n===== MEMORY MANAGER =====\n";
    std::cout << "RAM Total     : 8 GB\n";
    std::cout << "RAM Livre     : Disponivel\n";
    std::cout << "Cache         : Ready\n";
    std::cout << "Memory Map    : Ready\n";
    std::cout << "Allocator     : Ready\n";
    std::cout << "Status        : Online\n";
    std::cout << "==========================\n";
}

}
