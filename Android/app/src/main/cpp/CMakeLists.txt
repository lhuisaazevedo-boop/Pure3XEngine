cmake_minimum_required(VERSION 3.22)

project(Pure3XEngineAPK)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Compila o projeto principal
add_subdirectory(
    ${CMAKE_SOURCE_DIR}/..
    ${CMAKE_BINARY_DIR}/Pure3XBuild
)

# Biblioteca de log do Android
find_library(
    log-lib
    log
)

# Vincula a biblioteca principal ao log
target_link_libraries(
    lhuis.pure3x
    PRIVATE
    ${log-lib}
)
