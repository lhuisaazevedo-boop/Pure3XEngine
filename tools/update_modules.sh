#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE - Smart Modules
# Opção 2 - Atualizar módulos
# ============================================================

ROOT_DIR="${ROOT_DIR:-$HOME/Pure3XEngine}"

clear

DATA="$(date '+%d/%m/%Y')"
HORA="$(date '+%H:%M:%S')"

echo "============================================================"
echo "🔄 P3XE - ATUALIZAR MÓDULOS"
echo "============================================================"
echo "Projeto : $ROOT_DIR"
echo "Data    : $DATA"
echo "Hora    : $HORA"
echo

MODULES=(
    "CoreEmulator"
    "Cubo3D"
    "QEMUCenter"
    "android"
    "Config"
    "tools"
)

TOTAL=0
OK=0
ERROS=0

echo "📦 MÓDULOS DO PROJETO"
echo "------------------------------------------------------------"

for MODULE in "${MODULES[@]}"; do

    DIR="$ROOT_DIR/$MODULE"
    ((TOTAL++))

    if [ -d "$DIR" ]; then

        CPP=$(find "$DIR" -type f \
            \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
            2>/dev/null | wc -l)

        HEADERS=$(find "$DIR" -type f \
            \( -name "*.h" -o -name "*.hpp" \) \
            2>/dev/null | wc -l)

        CMAKE=$(find "$DIR" -type f \
            -name "CMakeLists.txt" \
            2>/dev/null | wc -l)

        echo "✅ $MODULE"
        echo "   C++     : $CPP"
        echo "   Headers : $HEADERS"
        echo "   CMake   : $CMAKE"
        echo

        ((OK++))

    else

        echo "❌ $MODULE"
        echo "   Diretório não encontrado"
        echo

        ((ERROS++))
    fi
done

echo "============================================================"
echo "📊 ATUALIZAÇÃO"
echo "------------------------------------------------------------"
echo "Módulos verificados : $TOTAL"
echo "Atualizados         : $OK"
echo "Com erro            : $ERROS"
echo

# ------------------------------------------------------------
# Git
# ------------------------------------------------------------

echo "🌿 GIT"
echo "------------------------------------------------------------"

if [ -d "$ROOT_DIR/.git" ]; then

    BRANCH=$(git -C "$ROOT_DIR" branch --show-current 2>/dev/null)
    COMMIT=$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null)

    MODIFICADOS=$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l)

    echo "Branch      : ${BRANCH:-desconhecida}"
    echo "Commit      : ${COMMIT:-desconhecido}"
    echo "Alterações  : $MODIFICADOS"

    if [ "$MODIFICADOS" -gt 0 ]; then
        echo "⚠️ Existem alterações locais."
    else
        echo "✅ Árvore Git limpa."
    fi

else
    echo "❌ Repositório Git não encontrado."
fi

echo
echo "============================================================"
echo "✅ ATUALIZAÇÃO CONCLUÍDA"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo "============================================================"
echo

read -r -p "Pressione ENTER para voltar..."
