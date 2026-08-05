cmake_minimum_required(VERSION 3.22.1)

project(Cubo3D LANGUAGES CXX)

# ============================================================
# C++ CONFIGURATION
# ============================================================

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ============================================================
# FONTES DO CUBO3D
# ============================================================

file(GLOB_RECURSE CUBO3D_SOURCES
    CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
)

if(NOT CUBO3D_SOURCES)
    message(FATAL_ERROR
        "Nenhum arquivo .cpp encontrado em Cubo3D/src"
    )
endif()

# ============================================================
# BIBLIOTECA NATIVA
# ============================================================

add_library(cubo3d SHARED
    src/Android/AndroidBridge.cpp
    ${CUBO3D_SOURCES}
)

# ============================================================
# HEADERS
# ============================================================

target_include_directories(cubo3d PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

# ============================================================
# BIBLIOTECAS DO ANDROID NDK
# ============================================================

if(ANDROID)

    find_library(ANDROID_LIB android)
    find_library(LOG_LIB log)
    find_library(EGL_LIB EGL)
    find_library(GLES3_LIB GLESv3)
    find_library(JNIGRAPHICS_LIB jnigraphics)
    find_library(VULKAN_LIB vulkan)

    target_link_libraries(cubo3d PRIVATE
        ${ANDROID_LIB}
        ${LOG_LIB}
        ${EGL_LIB}
        ${GLES3_LIB}
        ${JNIGRAPHICS_LIB}
        ${VULKAN_LIB}
    )

endif()

# ============================================================
# DEFINIÇÕES DO CUBO3D
# ============================================================

target_compile_definitions(cubo3d PRIVATE
    PURE3X_ENGINE
    PURE3X_ANDROID
)

# ============================================================
# NOME DA BIBLIOTECA
# ============================================================

set_target_properties(cubo3d PROPERTIES
    OUTPUT_NAME "cubo3d"
)
