cmake_minimum_required(VERSION 3.22.1)

project(
    CoreEmulator
    VERSION 0.2.5
    LANGUAGES CXX
)

# Configuração Padrão C++
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Opções de Build
option(PURE3X_BUILD_ANDROID "Compilar Backend Android" ON)
option(PURE3X_BUILD_VIEWER "Compilar Viewer Termux X11" OFF)

# ============================================================
# BUSCA AUTOMÁTICA DE TODOS OS ARQUIVOS FONTE
# ============================================================
file(GLOB_RECURSE TODOS_ARQUIVOS
    CONFIGURE_DEPENDS
    "*.cpp"
    "*.c"
)

list(LENGTH TODOS_ARQUIVOS TOTAL_SOURCES)

message(STATUS "Arquivos encontrados: ${TOTAL_SOURCES}")

if(TOTAL_SOURCES EQUAL 0)
    message(FATAL_ERROR "Nenhum arquivo .cpp encontrado em ${CMAKE_CURRENT_SOURCE_DIR}")
endif()
# ============================================================
# BIBLIOTECA PRINCIPAL
# ============================================================
add_library(lhuis.pure3x SHARED ${TODOS_ARQUIVOS})

# ============================================================
# DIRETÓRIOS DE CABEÇALHOS
# ============================================================
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

# ============================================================
# DEFINIÇÕES DE COMPILAÇÃO
# ============================================================
target_compile_definitions(lhuis.pure3x PRIVATE
    PURE3X_ENGINE
    PURE3X_ANDROID
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(lhuis.pure3x PRIVATE DEBUG_BUILD=1)
else()
    target_compile_definitions(lhuis.pure3x PRIVATE RELEASE_BUILD=1)
endif()

# ============================================================
# BIBLIOTECAS DO ANDROID
# ============================================================
if(ANDROID)
    link_directories(/system/lib64)   # <--- A linha que faltava
    find_library(LOG_LIB          log)
    find_library(ANDROID_LIB      android)
    # ... resto das bibliotecas
    target_link_libraries(
        lhuis.pure3x
        PRIVATE
            ${LOG_LIB}
            ${ANDROID_LIB}
            # ...
    )
endif()
# ============================================================
# NOME DA BIBLIOTECA
# ============================================================
set_target_properties(
    lhuis.pure3x
    PROPERTIES
    OUTPUT_NAME "lhuis.pure3x"
)

# ============================================================
# RESUMO DA CONFIGURAÇÃO
# ============================================================
message(STATUS "")
message(STATUS "========================================================")
message(STATUS "  Pure3XEngine v${PROJECT_VERSION}")
message(STATUS "========================================================")
message(STATUS "Projeto             : ${PROJECT_NAME}")
message(STATUS "Biblioteca          : lhuis.pure3x")
message(STATUS "Arquivo             : liblhuis.pure3x.so")
message(STATUS "Compilador          : ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "Padrão C++          : C++${CMAKE_CXX_STANDARD}")
message(STATUS "Tipo de Build       : ${CMAKE_BUILD_TYPE}")
message(STATUS "Sistema             : ${CMAKE_SYSTEM_NAME}")
message(STATUS "Processador         : ${CMAKE_SYSTEM_PROCESSOR}")
if(ANDROID)
    message(STATUS "Backend Android     : ATIVADO")
else()
    message(STATUS "Backend Android     : DESATIVADO")
endif()
if(PURE3X_BUILD_VIEWER)
    message(STATUS "Viewer Termux       : ATIVADO")
else()
    message(STATUS "Viewer Termux       : DESATIVADO")
endif()
message(STATUS "========================================================")
message(STATUS "Configuração concluída com sucesso!")
message(STATUS "========================================================")
