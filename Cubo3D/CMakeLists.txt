cmake_minimum_required(VERSION 3.22.1)

project(
    Cubo3D
    VERSION 0.2.6
    LANGUAGES CXX
)

option(PUREX_ANDROID "Build com suporte Android NDK" ON)
option(PUREX_ENGINE "Incluir Núcleo PS3 CoreEmulator" OFF)

# Padrão C++ único: C++23.
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

file(GLOB_RECURSE CUBO3D_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
)

if(NOT PUREX_ANDROID)
    list(FILTER CUBO3D_SOURCES EXCLUDE REGEX ".*/Android/AndroidBridge\\.cpp$")
endif()

set(CORE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../CoreEmulator")
set(CORE_SOURCES "")

if(PUREX_ENGINE)
    if(NOT EXISTS "${CORE_DIR}")
        message(FATAL_ERROR "CoreEmulator não encontrado no caminho: ${CORE_DIR}")
    endif()

    file(GLOB_RECURSE CORE_SOURCES CONFIGURE_DEPENDS
        "${CORE_DIR}/*.cpp"
    )
    list(FILTER CORE_SOURCES EXCLUDE REGEX ".*/build/[^/]+/")
    list(FILTER CORE_SOURCES EXCLUDE REGEX ".*/CMakeFiles/")
    list(FILTER CORE_SOURCES EXCLUDE REGEX "/\\.cxx/")

    if(NOT PUREX_ANDROID)
        list(FILTER CORE_SOURCES EXCLUDE REGEX ".*/android/")
    endif()
endif()

list(LENGTH CUBO3D_SOURCES CUBO3D_SOURCE_COUNT)
list(LENGTH CORE_SOURCES CORE_SOURCE_COUNT)
message(STATUS "Cubo3D: ${CUBO3D_SOURCE_COUNT} arquivos; CoreEmulator: ${CORE_SOURCE_COUNT} arquivos")
message(STATUS "C++ padrão: C++${CMAKE_CXX_STANDARD}")

if(PUREX_ENGINE)
    if(NOT CORE_SOURCES)
        message(FATAL_ERROR "CoreEmulator existe mas nenhum arquivo .cpp foi localizado!")
    endif()

    add_library(pure3x_core STATIC ${CORE_SOURCES})
    target_include_directories(pure3x_core PUBLIC "${CORE_DIR}" "${CORE_DIR}/include")
    target_compile_definitions(pure3x_core PUBLIC PUREX_ENGINE)
    target_compile_options(pure3x_core PRIVATE -fPIC -fexceptions -frtti)
endif()

if(NOT CUBO3D_SOURCES)
    message(FATAL_ERROR "Nenhum arquivo .cpp do Cubo3D foi encontrado!")
endif()

add_library(cubo3d SHARED ${CUBO3D_SOURCES})
target_include_directories(cubo3d PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_compile_options(cubo3d PRIVATE -fPIC -fexceptions -frtti)

target_compile_definitions(cubo3d PRIVATE PUREX_ANDROID CUBO3D_GLES_SUPPORT CUBO3D_VULKAN_SUPPORT)

if(TARGET pure3x_core)
    target_link_libraries(cubo3d PRIVATE pure3x_core)
    target_compile_definitions(cubo3d PRIVATE PUREX_ENGINE)
endif()

if(PUREX_ANDROID)
    if(NOT ANDROID)
        message(FATAL_ERROR "PUREX_ANDROID=ON exige uso do Android NDK Toolchain!")
    endif()

    if(NOT DEFINED ANDROID_SYSROOT)
        if(DEFINED CMAKE_ANDROID_NDK)
            set(ANDROID_SYSROOT
                "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
            )
        elseif(DEFINED ANDROID_NDK_ROOT)
            set(ANDROID_SYSROOT
                "${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
            )
        else()
            message(FATAL_ERROR
                "ANDROID_SYSROOT, CMAKE_ANDROID_NDK ou ANDROID_NDK_ROOT "
                "não definido pelo toolchain"
            )
        endif()
    endif()

    set(ANDROID_LIB_DIR
        "${ANDROID_SYSROOT}/usr/lib/aarch64-linux-android/29"
    )

    if(NOT EXISTS "${ANDROID_LIB_DIR}/liblog.so")
        message(FATAL_ERROR
            "liblog.so não encontrado no caminho testado: "
            "${ANDROID_LIB_DIR}/liblog.so"
        )
    endif()

    find_library(ANDROID_LIB
        NAMES android
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )
    find_library(LOG_LIB
        NAMES log
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )
    find_library(EGL_LIB
        NAMES EGL
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )
    find_library(GLES2_LIB
        NAMES GLESv2
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )
    find_library(GLES3_LIB
        NAMES GLESv3
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )
    find_library(JNIGRAPHICS_LIB
        NAMES jnigraphics
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )
    find_library(VULKAN_LIB
        NAMES vulkan
        PATHS "${ANDROID_LIB_DIR}"
        NO_DEFAULT_PATH
        REQUIRED
    )

    target_link_libraries(cubo3d PRIVATE ${ANDROID_LIB} ${LOG_LIB} ${EGL_LIB} ${GLES2_LIB} ${GLES3_LIB} ${JNIGRAPHICS_LIB} ${VULKAN_LIB})
endif()

if(ANDROID)
    target_link_options(cubo3d PRIVATE -Wl,--no-undefined)
endif()
