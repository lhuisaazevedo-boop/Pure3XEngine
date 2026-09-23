cmake_minimum_required(VERSION 3.22.1)

project(
    Pure3XEngine
    VERSION 0.2.6
    LANGUAGES CXX
)

# Padrão único do projeto Android: C++23.
# O compilador e o NDK são fornecidos pelo Android Gradle Plugin/CMake.
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_subdirectory(CoreEmulator)
add_subdirectory(Cubo3D)
