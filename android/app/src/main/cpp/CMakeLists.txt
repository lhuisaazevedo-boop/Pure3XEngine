cmake_minimum_required(VERSION 3.22.1)

project(Pure3XAndroid)

add_subdirectory(
    ../../../../../CoreEmulation
    ${CMAKE_BINARY_DIR}/CoreEmulation
)

add_library(
    Pure3XAndroid
    SHARED
    NativeBridge.cpp
)

target_link_libraries(
    Pure3XAndroid
    CoreEmulation
    android
    log
)
