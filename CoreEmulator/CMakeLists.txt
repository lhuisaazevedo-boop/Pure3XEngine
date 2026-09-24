cmake_minimum_required(VERSION 3.22.1)

project(
    CoreEmulator
    VERSION 0.2.5
    LANGUAGES CXX
)

# Padrão C++ único: C++23.
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

option(PURE3X_BUILD_ANDROID "Compilar Backend Android" ON)
option(PURE3X_BUILD_VIEWER "Compilar Viewer Termux X11" OFF)

file(GLOB_RECURSE TODOS_ARQUIVOS CONFIGURE_DEPENDS "*.cpp" "*.c")
list(LENGTH TODOS_ARQUIVOS TOTAL_SOURCES)
message(STATUS "CoreEmulator: ${TOTAL_SOURCES} arquivos; C++${CMAKE_CXX_STANDARD}")

if(TOTAL_SOURCES EQUAL 0)
    message(FATAL_ERROR "Nenhum arquivo .cpp encontrado em ${CMAKE_CURRENT_SOURCE_DIR}")
endif()

add_library(lhuis.pure3x SHARED ${TODOS_ARQUIVOS})

target_include_directories(lhuis.pure3x PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/android
    ${CMAKE_CURRENT_SOURCE_DIR}/android/core
    ${CMAKE_CURRENT_SOURCE_DIR}/android/runtime
    ${CMAKE_CURRENT_SOURCE_DIR}/android/bridge
    ${CMAKE_CURRENT_SOURCE_DIR}/android/window
    ${CMAKE_CURRENT_SOURCE_DIR}/android/jni
    ${CMAKE_CURRENT_SOURCE_DIR}/android/filesystem
    ${CMAKE_CURRENT_SOURCE_DIR}/android/logs
    ${CMAKE_CURRENT_SOURCE_DIR}/android/renderer
    ${CMAKE_CURRENT_SOURCE_DIR}/android/input
    ${CMAKE_CURRENT_SOURCE_DIR}/android/config
    ${CMAKE_CURRENT_SOURCE_DIR}/android/system
    ${CMAKE_CURRENT_SOURCE_DIR}/android/device
    ${CMAKE_CURRENT_SOURCE_DIR}/android/display
    ${CMAKE_CURRENT_SOURCE_DIR}/android/menu
    ${CMAKE_CURRENT_SOURCE_DIR}/android/graphics
    ${CMAKE_CURRENT_SOURCE_DIR}/android/shaders
    ${CMAKE_CURRENT_SOURCE_DIR}/android/thread
    ${CMAKE_CURRENT_SOURCE_DIR}/android/network
    ${CMAKE_CURRENT_SOURCE_DIR}/android/services
    ${CMAKE_CURRENT_SOURCE_DIR}/android/debug
    ${CMAKE_CURRENT_SOURCE_DIR}/android/apk
    ${CMAKE_CURRENT_SOURCE_DIR}/boot
    ${CMAKE_CURRENT_SOURCE_DIR}/system
    ${CMAKE_CURRENT_SOURCE_DIR}/audio
    ${CMAKE_CURRENT_SOURCE_DIR}/firmware
    ${CMAKE_CURRENT_SOURCE_DIR}/graphics
    ${CMAKE_CURRENT_SOURCE_DIR}/graphics/rsx
    ${CMAKE_CURRENT_SOURCE_DIR}/graphics/Vulkan
    ${CMAKE_CURRENT_SOURCE_DIR}/cell/Scheduler
    ${CMAKE_CURRENT_SOURCE_DIR}/cell/Memory
    ${CMAKE_CURRENT_SOURCE_DIR}/cell/PPU
    ${CMAKE_CURRENT_SOURCE_DIR}/cell/SPU
    ${CMAKE_CURRENT_SOURCE_DIR}/cell
)

target_compile_definitions(lhuis.pure3x PRIVATE PURE3X_ENGINE PURE3X_ANDROID)
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(lhuis.pure3x PRIVATE DEBUG_BUILD=1)
else()
    target_compile_definitions(lhuis.pure3x PRIVATE RELEASE_BUILD=1)
endif()

target_compile_options(lhuis.pure3x PRIVATE -fPIC -fexceptions -frtti)

if(ANDROID)
    if(DEFINED ANDROID_SYSROOT)
        set(ANDROID_LIB_DIR
            "${ANDROID_SYSROOT}/usr/lib/aarch64-linux-android/29"
        )
    elseif(DEFINED ANDROID_NDK_ROOT)
        set(ANDROID_LIB_DIR
            "${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/aarch64-linux-android/29"
        )
    else()
        message(FATAL_ERROR
            "ANDROID_SYSROOT ou ANDROID_NDK_ROOT não definido pelo toolchain"
        )
    endif()

    find_library(LOG_LIB
        NAMES log
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )
    find_library(ANDROID_LIB
        NAMES android
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )

    target_link_libraries(lhuis.pure3x PRIVATE ${LOG_LIB} ${ANDROID_LIB})
endif()

set_target_properties(lhuis.pure3x PROPERTIES OUTPUT_NAME "lhuis.pure3x")
