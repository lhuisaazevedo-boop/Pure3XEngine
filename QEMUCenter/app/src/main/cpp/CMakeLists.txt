cmake_minimum_required(VERSION 3.22.1)

project(
    P3XE_QEMU_Center
    VERSION 0.1.0
    LANGUAGES C CXX
)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(
    p3xe_qemu_center
    SHARED
    native_bridge.cpp
)

find_library(
    log-lib
    log
)

find_library(
    android-lib
    android
)

target_link_libraries(
    p3xe_qemu_center
    PRIVATE
    ${log-lib}
    ${android-lib}
)
