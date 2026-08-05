#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE - Smart Modules
# Opção 1 - Listar módulos
# ============================================================

ROOT_DIR="${ROOT_DIR:-$HOME/Pure3XEngine}"

clear

echo "=============================================================="
echo "📦 P3XE - LISTAR MÓDULOS"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo

# ------------------------------------------------------------
# Diretórios considerados módulos do projeto
# ------------------------------------------------------------

MODULES=(
    "CoreEmulator"
    "Cubo3D"
    "QEMUCenter"
    "android"
    "Config"
    "tools"
)

TOTAL=0
FOUND=0
MISSING=0

echo "📂 MÓDULOS PRINCIPAIS"
echo "--------------------------------------------------------------"

for MODULE in "${MODULES[@]}"; do

    DIR="$ROOT_DIR/$MODULE"
    ((TOTAL++))

    if [ -d "$DIR" ]; then

        ((FOUND++))

        CPP=$(find "$DIR" -type f -name "*.cpp" 2>/dev/null | wc -l)
        H=$(find "$DIR" -type f \( -name "*.h" -o -name "*.hpp" \) 2>/dev/null | wc -l)
        CMAKE=$(find "$DIR" -type f -name "CMakeLists.txt" 2>/dev/null | wc -l)

        echo "✅ $MODULE"
        echo "   Caminho : $DIR"
        echo "   C++     : $CPP"
        echo "   Headers : $H"
        echo "   CMake   : $CMAKE"
        echo

    else

        ((MISSING++))

        echo "❌ $MODULE"
        echo "   Diretório não encontrado"
        echo
    fi

done

echo "=============================================================="
echo "📊 RESUMO"
echo "--------------------------------------------------------------"
echo "Módulos verificados : $TOTAL"
echo "Encontrados         : $FOUND"
echo "Ausentes            : $MISSING"
echo "=============================================================="

echo
read -r -p "Pressione ENTER para voltar..."
