#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE - Smart Modules
# Opção 3 - Criar módulo
# ============================================================

ROOT_DIR="${ROOT_DIR:-$HOME/Pure3XEngine}"

clear

echo "============================================================"
echo "➕ P3XE - CRIAR MÓDULO"
echo "============================================================"
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo
echo "------------------------------------------------------------"

read -r -p "Nome do novo módulo: " MODULE

# Remove espaços no começo/fim
MODULE="$(echo "$MODULE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

if [ -z "$MODULE" ]; then
    echo
    echo "❌ Nome do módulo não pode ficar vazio."
    echo
    read -r -p "Pressione ENTER para voltar..."
    exit 1
fi

# Segurança: somente nome simples
if [[ ! "$MODULE" =~ ^[A-Za-z][A-Za-z0-9_-]*$ ]]; then
    echo
    echo "❌ Nome inválido."
    echo "Use apenas letras, números, _ ou -."
    echo "O primeiro caractere deve ser uma letra."
    echo
    read -r -p "Pressione ENTER para voltar..."
    exit 1
fi

MODULE_DIR="$ROOT_DIR/$MODULE"

if [ -e "$MODULE_DIR" ]; then
    echo
    echo "⚠️ O módulo já existe:"
    echo "$MODULE_DIR"
    echo
    read -r -p "Pressione ENTER para voltar..."
    exit 1
fi

echo
echo "📦 NOVO MÓDULO"
echo "------------------------------------------------------------"
echo "Nome    : $MODULE"
echo "Caminho : $MODULE_DIR"
echo

read -r -p "Criar este módulo? [s/N]: " CONFIRM

case "$CONFIRM" in
    s|S|sim|SIM|Sim)
        ;;
    *)
        echo
        echo "↩️ Criação cancelada."
        echo
        read -r -p "Pressione ENTER para voltar..."
        exit 0
        ;;
esac

# Estrutura padrão
mkdir -p \
    "$MODULE_DIR/src" \
    "$MODULE_DIR/include"

if [ $? -ne 0 ]; then
    echo
    echo "❌ Erro ao criar diretórios."
    read -r -p "Pressione ENTER para voltar..."
    exit 1
fi

# Arquivo C++ inicial
cat > "$MODULE_DIR/src/${MODULE}.cpp" <<EOF
// Pure3XEngine
// Module: $MODULE

#include "${MODULE}.h"

namespace Pure3X {

void ${MODULE}::initialize()
{
}

void ${MODULE}::shutdown()
{
}

}
EOF

# Header inicial
cat > "$MODULE_DIR/include/${MODULE}.h" <<EOF
#pragma once

namespace Pure3X {

class ${MODULE}
{
public:
    void initialize();
    void shutdown();
};

}
EOF

# CMake independente
cat > "$MODULE_DIR/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.16)

project(${MODULE} LANGUAGES CXX)

add_library(${MODULE} STATIC
    src/${MODULE}.cpp
)

target_include_directories(${MODULE}
    PUBLIC
        \${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_compile_features(${MODULE}
    PUBLIC
        cxx_std_20
)
EOF

echo
echo "============================================================"
echo "✅ MÓDULO CRIADO"
echo "============================================================"
echo "Nome    : $MODULE"
echo "Caminho : $MODULE_DIR"
echo
echo "Estrutura:"
echo
echo "$MODULE/"
echo "├── CMakeLists.txt"
echo "├── include/"
echo "│   └── ${MODULE}.h"
echo "└── src/"
echo "    └── ${MODULE}.cpp"
echo
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo "============================================================"
echo

read -r -p "Pressione ENTER para voltar..."
