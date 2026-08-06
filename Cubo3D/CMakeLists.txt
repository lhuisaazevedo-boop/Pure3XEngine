cmake_minimum_required(VERSION 3.22.1)

if(ANDROID)
    set(CMAKE_C_COMPILER_WORKS 1 CACHE INTERNAL "")
    set(CMAKE_CXX_COMPILER_WORKS 1 CACHE INTERNAL "")
endif()

project(Cubo3D VERSION 0.2.6 LANGUAGES CXX)

option(PUREX_ANDROID "Build Cubo3D Android backend" ON)
option(PUREX_ENGINE "Inclui suporte ao núcleo Pure3X" ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ============================================================
# 1. CUBO3D — LABORATÓRIO GRÁFICO
# ============================================================

file(GLOB_RECURSE CUBO3D_SOURCES
    CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
)

# AndroidBridge somente no backend Android
if(NOT PUREX_ANDROID)
    list(FILTER CUBO3D_SOURCES
        EXCLUDE REGEX ".*/Android/AndroidBridge\\.cpp$"
    )
endif()

# ============================================================
# 2. PURE3X CORE / NÚCLEO PS3
# ============================================================

set(CORE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/../CoreEmulator"
)

set(CORE_SOURCES "")

if(PUREX_ENGINE AND EXISTS "${CORE_DIR}")

    file(GLOB_RECURSE CORE_SOURCES
        CONFIGURE_DEPENDS
        "${CORE_DIR}/*.cpp"
    )

    # Nunca incorporar artefatos de builds anteriores
    list(FILTER CORE_SOURCES EXCLUDE REGEX "/build[^/]*/")
    list(FILTER CORE_SOURCES EXCLUDE REGEX "/CMakeFiles/")
    list(FILTER CORE_SOURCES EXCLUDE REGEX "/out/")
    list(FILTER CORE_SOURCES EXCLUDE REGEX "/\\.cxx/")

    # Backend Android do Core somente no Android
    if(NOT PUREX_ANDROID)
        list(FILTER CORE_SOURCES
            EXCLUDE REGEX "/android/"
        )
    endif()

endif()

# ============================================================
# 3. DIAGNÓSTICO
# ============================================================

list(LENGTH CUBO3D_SOURCES CUBO3D_SOURCE_COUNT)
list(LENGTH CORE_SOURCES CORE_SOURCE_COUNT)

math(EXPR TOTAL_SOURCE_COUNT
    "${CUBO3D_SOURCE_COUNT} + ${CORE_SOURCE_COUNT}"
)

message(STATUS "==========================================")
message(STATUS "Cubo3D sources : ${CUBO3D_SOURCE_COUNT}")
message(STATUS "PS3 Core       : ${CORE_SOURCE_COUNT}")
message(STATUS "TOTAL          : ${TOTAL_SOURCE_COUNT}")
message(STATUS "PUREX_ENGINE   : ${PUREX_ENGINE}")
message(STATUS "PUREX_ANDROID  : ${PUREX_ANDROID}")
message(STATUS "ANDROID        : ${ANDROID}")
message(STATUS "==========================================")

foreach(SOURCE_FILE IN LISTS CORE_SOURCES)
    message(STATUS "PS3 CORE -> ${SOURCE_FILE}")
endforeach()

# ============================================================
# 4. NÚCLEO PS3
# ============================================================

if(PUREX_ENGINE AND CORE_SOURCES)

    add_library(pure3x_core STATIC
        ${CORE_SOURCES}
    )

    target_include_directories(pure3x_core PUBLIC
        "${CORE_DIR}"
        "${CORE_DIR}/include"
        "${CORE_DIR}/memory"
    )

    target_compile_definitions(pure3x_core PRIVATE
        PURE3X_ENGINE
    )

endif()

# ============================================================
# 5. CUBO3D
# ============================================================

if(NOT CUBO3D_SOURCES)
    message(FATAL_ERROR "Nenhum fonte do Cubo3D encontrado.")
endif()

add_library(cubo3d SHARED
    ${CUBO3D_SOURCES}
)

target_include_directories(cubo3d PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/include"

    "${CORE_DIR}"
    "${CORE_DIR}/include"
    "${CORE_DIR}/memory"
)

# ============================================================
# 6. CONECTA PURE3X CORE AO LABORATÓRIO
# ============================================================

if(TARGET pure3x_core)

    target_link_libraries(cubo3d PRIVATE
        pure3x_core
    )

    target_compile_definitions(cubo3d PRIVATE
        PURE3X_ENGINE
    )

endif()

# ============================================================
# 7. ANDROID
# ============================================================

if(PUREX_ANDROID)

    find_library(ANDROID_LIB android REQUIRED)
    find_library(LOG_LIB log REQUIRED)
    find_library(EGL_LIB EGL REQUIRED)
    find_library(GLES2_LIB GLESv2 REQUIRED)
    find_library(GLES3_LIB GLESv3 REQUIRED)
    find_library(JNIGRAPHICS_LIB jnigraphics REQUIRED)
    find_library(VULKAN_LIB vulkan REQUIRED)

    target_link_libraries(cubo3d PRIVATE
        ${ANDROID_LIB}
        ${LOG_LIB}
        ${EGL_LIB}
        ${GLES2_LIB}
        ${GLES3_LIB}
        ${JNIGRAPHICS_LIB}
        ${VULKAN_LIB}
    )

    target_compile_definitions(cubo3d PRIVATE
        PURE3X_ANDROID
        CUBO3D_GLES_SUPPORT
        CUBO3D_VULKAN_SUPPORT
    )

endif()

# ============================================================
# 8. FLAGS
# ============================================================

target_compile_options(cubo3d PRIVATE
    -fPIC
    -fexceptions
    -frtti
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    target_compile_options(cubo3d PRIVATE -O2)
endif()

if(ANDROID)
    target_link_options(cubo3d PRIVATE
        -Wl,--no-undefined
    )
endif()

# ============================================================
# 9. NOME FINAL
# ============================================================

set_target_properties(cubo3d PROPERTIES
    OUTPUT_NAME "cubo3d"
    PREFIX "lib"
    SUFFIX ".so"
)
