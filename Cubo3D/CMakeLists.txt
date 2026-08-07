cmake_minimum_required(VERSION 3.22.1)

project(
    Cubo3D
    VERSION 0.2.6
    LANGUAGES CXX
)

# ============================================================
# PURE3XENGINE 0.2.6 | CUBO3D + NÚCLEO PS3 COREEMULATOR
# ============================================================

option(PUREX_ANDROID  "Build com suporte Android NDK" ON)
option(PUREX_ENGINE   "Incluir Núcleo PS3 CoreEmulator" ON)

# ============================================================
# CONFIGURAÇÃO PADRÃO C++
# ============================================================
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ============================================================
# 1. FONTES CUBO3D
# ============================================================
file(GLOB_RECURSE CUBO3D_SOURCES
    CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
)

# Exclui ponte Android quando não estiver compilando para Android
if(NOT PUREX_ANDROID)
    list(FILTER CUBO3D_SOURCES EXCLUDE REGEX ".*/Android/AndroidBridge\\.cpp$")
endif()

# ============================================================
# 2. NÚCLEO PS3 COREEMULATOR
# ============================================================
set(CORE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../CoreEmulator")
set(CORE_SOURCES "")

if(PUREX_ENGINE)
    if(NOT EXISTS "${CORE_DIR}")
        message(FATAL_ERROR "❌ CoreEmulator não encontrado no caminho: ${CORE_DIR}")
    endif()

    file(GLOB_RECURSE CORE_SOURCES
        CONFIGURE_DEPENDS
        "${CORE_DIR}/*.cpp"
    )

    # Exclui arquivos de compilação e cache
    list(FILTER CORE_SOURCES EXCLUDE REGEX ".*/build/[^/]+/")
    list(FILTER CORE_SOURCES EXCLUDE REGEX ".*/CMakeFiles/")
    list(FILTER CORE_SOURCES EXCLUDE REGEX "/\\.cxx/")

    # Exclui arquivos específicos Android quando compilando fora do Android
    if(NOT PUREX_ANDROID)
        list(FILTER CORE_SOURCES EXCLUDE REGEX ".*/android/")
    endif()
endif()

# ============================================================
# 3. DIAGNÓSTICO E STATUS
# ============================================================
list(LENGTH CUBO3D_SOURCES CUBO3D_SOURCE_COUNT)
list(LENGTH CORE_SOURCES CORE_SOURCE_COUNT)
math(EXPR TOTAL_SOURCE_COUNT "${CUBO3D_SOURCE_COUNT} + ${CORE_SOURCE_COUNT}")

message(STATUS "")
message(STATUS "==========================================================")
message(STATUS "  Pure3XEngine 0.2.6 Alpha")
message(STATUS "  🧩 Biblioteca: Cubo3D")
message(STATUS "  🧠 Módulo: Núcleo PS3 CoreEmulator")
message(STATUS "  📱 Plataforma: Android")
message(STATUS "  🎨 Renderização: OpenGL ES + Vulkan Ativo")
message(STATUS "==========================================================")
message(STATUS "  Arquivos Cubo3D      : ${CUBO3D_SOURCE_COUNT}")
message(STATUS "  Arquivos CoreEmulator: ${CORE_SOURCE_COUNT}")
message(STATUS "  Total de arquivos    : ${TOTAL_SOURCE_COUNT}")
message(STATUS "  PUREX_ENGINE         : ${PUREX_ENGINE}")
message(STATUS "  PUREX_ANDROID        : ${PUREX_ANDROID}")
message(STATUS "==========================================================")
message(STATUS "")

# ============================================================
# 4. BIBLIOTECA ESTÁTICA DO NÚCLEO
# ============================================================
if(PUREX_ENGINE)
    if(NOT CORE_SOURCES)
        message(FATAL_ERROR "❌ CoreEmulator existe mas nenhum arquivo .cpp foi localizado!")
    endif()

    add_library(pure3x_core STATIC ${CORE_SOURCES})

    target_include_directories(pure3x_core PUBLIC
        "${CORE_DIR}"
        "${CORE_DIR}/include"
    )

    target_compile_definitions(pure3x_core PUBLIC PUREX_ENGINE)

    target_compile_options(pure3x_core PRIVATE
        -fPIC
        -fexceptions
        -frtti
    )
endif()

# ============================================================
# 5. BIBLIOTECA PRINCIPAL COMPARTILHADA
# ============================================================
if(NOT CUBO3D_SOURCES)
    message(FATAL_ERROR "❌ Nenhum arquivo .cpp do Cubo3D foi encontrado!")
endif()

add_library(cubo3d SHARED ${CUBO3D_SOURCES})

target_include_directories(cubo3d PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
    "${CORE_DIR}"
    "${CORE_DIR}/include"
)

# Liga o núcleo PS3 garantindo que todos símbolos sejam incluídos
if(TARGET pure3x_core)
    target_link_libraries(cubo3d PRIVATE
        "-Wl,--whole-archive"
        pure3x_core
        "-Wl,--no-whole-archive"
    )
    target_compile_definitions(cubo3d PRIVATE PUREX_ENGINE)
endif()

# ============================================================
# 6. BIBLIOTECAS DO ANDROID
# ============================================================
if(PUREX_ANDROID)
    if(NOT ANDROID)
        message(FATAL_ERROR "❌ PUREX_ANDROID=ON exige uso do Android NDK Toolchain!")
    endif()

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
        PUREX_ANDROID
        CUBO3D_GLES_SUPPORT
        CUBO3D_VULKAN_SUPPORT
    )
endif()

# ============================================================
# 7. OPÇÕES DE COMPILAÇÃO
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
    target_link_options(cubo3d PRIVATE -Wl,--no-undefined)
endif()

