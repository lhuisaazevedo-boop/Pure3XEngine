#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE - Smart Modules
# Opção 5 - Status dos módulos
# ============================================================

ROOT_DIR="${ROOT_DIR:-$HOME/Pure3XEngine}"

clear

echo "============================================================"
echo "📊 P3XE - STATUS DOS MÓDULOS"
echo "============================================================"
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
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
WARN=0
MISSING=0

TOTAL_CPP=0
TOTAL_HEADERS=0
TOTAL_CMAKE=0

echo "📦 MÓDULOS PRINCIPAIS"
echo "------------------------------------------------------------"

for MODULE in "${MODULES[@]}"; do

    DIR="$ROOT_DIR/$MODULE"
    ((TOTAL++))

    if [ ! -d "$DIR" ]; then
        echo "❌ $MODULE"
        echo "   Status  : AUSENTE"
        echo

        ((MISSING++))
        continue
    fi

    CPP=$(find "$DIR" -type f \
        \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
        2>/dev/null | wc -l)

    HEADERS=$(find "$DIR" -type f \
        \( -name "*.h" -o -name "*.hpp" \) \
        2>/dev/null | wc -l)

    CMAKE=$(find "$DIR" -type f \
        -name "CMakeLists.txt" \
        2>/dev/null | wc -l)

    FILES=$(find "$DIR" -type f 2>/dev/null | wc -l)
    SIZE=$(du -sh "$DIR" 2>/dev/null | awk '{print $1}')

    ((TOTAL_CPP+=CPP))
    ((TOTAL_HEADERS+=HEADERS))
    ((TOTAL_CMAKE+=CMAKE))

    STATUS="OK"

    # Módulos de código sem CMake recebem aviso.
    case "$MODULE" in
        CoreEmulator|Cubo3D|QEMUCenter|android)
            if [ "$CMAKE" -eq 0 ]; then
                STATUS="ATENÇÃO"
            fi
            ;;
    esac

    if [ "$STATUS" = "OK" ]; then
        echo "✅ $MODULE"
        ((OK++))
    else
        echo "⚠️ $MODULE"
        ((WARN++))
    fi

    echo "   Status  : $STATUS"
    echo "   C++     : $CPP"
    echo "   Headers : $HEADERS"
    echo "   CMake   : $CMAKE"
    echo "   Arquivos: $FILES"
    echo "   Tamanho : ${SIZE:-0}"
    echo
done

echo "============================================================"
echo "🧩 RESUMO DOS MÓDULOS"
echo "------------------------------------------------------------"
echo "Verificados : $TOTAL"
echo "OK          : $OK"
echo "Atenção     : $WARN"
echo "Ausentes    : $MISSING"
echo
echo "C++ total   : $TOTAL_CPP"
echo "Headers     : $TOTAL_HEADERS"
echo "CMake       : $TOTAL_CMAKE"
echo

echo "🌿 GIT / PROJETO"
echo "------------------------------------------------------------"

if [ -d "$ROOT_DIR/.git" ]; then

    BRANCH=$(git -C "$ROOT_DIR" branch --show-current 2>/dev/null)
    COMMIT=$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null)
    CHANGES=$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l)

    echo "Branch     : ${BRANCH:-desconhecida}"
    echo "Commit     : ${COMMIT:-desconhecido}"
    echo "Alterações : $CHANGES"

    if [ "$CHANGES" -eq 0 ]; then
        echo "Status Git : ✅ Limpo"
    else
        echo "Status Git : ⚠️ Alterações locais"
    fi

else
    echo "Git        : ❌ Não encontrado"
fi

echo
echo "============================================================"

if [ "$MISSING" -gt 0 ]; then
    echo "❌ STATUS GERAL: MÓDULOS AUSENTES"
elif [ "$WARN" -gt 0 ]; then
    echo "⚠️ STATUS GERAL: REQUER ATENÇÃO"
else
    echo "✅ STATUS GERAL: SISTEMA MODULAR OK"
fi

echo "============================================================"
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Smart Modules"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo "============================================================"
echo

read -r -p "Pressione ENTER para voltar..."
