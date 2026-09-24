cmake_minimum_required(VERSION 3.22.1)

# Toolchain Android ARM64 nativo para Termux/aarch64.
# Usa o clang/clang++ nativo do Termux e o sysroot Android do NDK.
# Não usa o android.toolchain.cmake oficial, que exige binários host x86_64.

set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION 29)
set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)
set(CMAKE_ANDROID_API 29)

if(NOT DEFINED ENV{PREFIX})
    message(FATAL_ERROR "PREFIX do Termux não está definido")
endif()

if(NOT DEFINED ANDROID_NDK_ROOT)
    if(DEFINED ENV{ANDROID_NDK_ROOT})
        set(ANDROID_NDK_ROOT "$ENV{ANDROID_NDK_ROOT}")
    elseif(DEFINED ENV{ANDROID_NDK_HOME})
        set(ANDROID_NDK_ROOT "$ENV{ANDROID_NDK_HOME}")
    else()
        set(ANDROID_NDK_ROOT "$ENV{HOME}/Android/Sdk/ndk/29.0.14206865")
    endif()
endif()

set(TERMUX_PREFIX "$ENV{PREFIX}")
set(ANDROID_SYSROOT "${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/sysroot")
set(ANDROID_TRIPLE "aarch64-linux-android")
set(ANDROID_API_TRIPLE "${ANDROID_TRIPLE}29")

if(NOT EXISTS "${ANDROID_SYSROOT}")
    message(FATAL_ERROR
        "Sysroot Android não encontrado: ${ANDROID_SYSROOT}\n"
        "Defina ANDROID_NDK_ROOT apontando para o NDK instalado."
    )
endif()

if(NOT EXISTS "${TERMUX_PREFIX}/bin/clang")
    message(FATAL_ERROR "clang nativo do Termux não encontrado: ${TERMUX_PREFIX}/bin/clang")
endif()

if(NOT EXISTS "${TERMUX_PREFIX}/bin/clang++")
    message(FATAL_ERROR "clang++ nativo do Termux não encontrado: ${TERMUX_PREFIX}/bin/clang++")
endif()

set(CMAKE_C_COMPILER "${TERMUX_PREFIX}/bin/clang" CACHE FILEPATH "Termux C compiler" FORCE)
set(CMAKE_CXX_COMPILER "${TERMUX_PREFIX}/bin/clang++" CACHE FILEPATH "Termux CXX compiler" FORCE)
set(CMAKE_AR "${TERMUX_PREFIX}/bin/llvm-ar" CACHE FILEPATH "Termux archiver" FORCE)
set(CMAKE_RANLIB "${TERMUX_PREFIX}/bin/llvm-ranlib" CACHE FILEPATH "Termux ranlib" FORCE)
set(CMAKE_STRIP "${TERMUX_PREFIX}/bin/llvm-strip" CACHE FILEPATH "Termux strip" FORCE)

set(ANDROID_TARGET_FLAGS
    "--target=${ANDROID_API_TRIPLE}"
    "--sysroot=${ANDROID_SYSROOT}"
)

set(CMAKE_C_FLAGS_INIT "${ANDROID_TARGET_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${ANDROID_TARGET_FLAGS} -stdlib=libc++")
set(CMAKE_EXE_LINKER_FLAGS_INIT "${ANDROID_TARGET_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS_INIT "${ANDROID_TARGET_FLAGS}")
set(CMAKE_MODULE_LINKER_FLAGS_INIT "${ANDROID_TARGET_FLAGS}")

set(CMAKE_SYSROOT "${ANDROID_SYSROOT}" CACHE PATH "Android sysroot" FORCE)
set(CMAKE_FIND_ROOT_PATH "${ANDROID_SYSROOT}" CACHE PATH "Android root path" FORCE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Evita que o try_compile tente executar um binário Android no Termux.
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

message(STATUS "Termux Android ARM64 toolchain")
message(STATUS "Termux prefix: ${TERMUX_PREFIX}")
message(STATUS "NDK root: ${ANDROID_NDK_ROOT}")
message(STATUS "Android sysroot: ${ANDROID_SYSROOT}")
message(STATUS "Target: ${ANDROID_API_TRIPLE}")
