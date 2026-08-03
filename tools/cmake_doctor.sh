#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# P3XE CMAKE DOCTOR
# Pure3XEngenie Development Kit
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo
echo "=============================================="
echo "🔍 CMAKE DOCTOR — VERIFICAÇÃO COMPLETA"
echo "=============================================="
echo "Projeto : $PROJETO_ROOT"
echo

ARQUIVOS=(
    "$PROJETO_ROOT/CMakeLists.txt"
    "$PROJETO_ROOT/Cubo3D/android/CMakeLists.txt"
    "$PROJETO_ROOT/CoreEmuletoin/android/CMakeLists.txt"
)

TOTAL=0
OK=0
ERROS=0

for ARQ in "${ARQUIVOS[@]}"; do
    TOTAL=$((TOTAL+1))

    if [ -f "$ARQ" ]; then
        echo "✅ Encontrado:"
        echo "   $ARQ"

        if grep -q "CMAKE_CXX_STANDARD 20" "$ARQ"; then
            echo "   ✔ C++20: OK"
        else
            echo "   ⚠ C++20 não definido"
        fi

        if grep -q "project(" "$ARQ"; then
            echo "   ✔ Projeto definido"
        else
            echo "   ⚠ project() não encontrado"
        fi

        if grep -q "cmake_minimum_required" "$ARQ"; then
            echo "   ✔ cmake_minimum_required OK"
        else
            echo "   ⚠ cmake_minimum_required ausente"
        fi

        OK=$((OK+1))

    else
        echo "❌ Faltando:"
        echo "   $ARQ"
        ERROS=$((ERROS+1))
    fi

    echo
done

echo "=============================================="
echo "RESUMO"
echo "=============================================="
echo "Arquivos verificados : $TOTAL"
echo "Encontrados          : $OK"
echo "Faltando             : $ERROS"
echo "=============================================="

if [ "$ERROS" -eq 0 ]; then
    echo "✅ Estrutura CMake OK"
else
    echo "⚠ Corrija os arquivos acima."
fi

echo
read -p "Pressione ENTER para continuar..."
