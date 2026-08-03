#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# P3XE JNI DOCTOR
# Verificação das bibliotecas nativas (.so)
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

clear

echo
echo "=============================================="
echo "🔍 JNI DOCTOR — BIBLIOTECAS NATIVAS"
echo "=============================================="
echo "Projeto : $PROJETO_ROOT"
echo

PASTAS_LIBS=(
    "$PROJETO_ROOT/app/src/main/jniLibs/arm64-v8a"
    "$PROJETO_ROOT/Cubo3D/android/app/src/main/jniLibs/arm64-v8a"
    "$PROJETO_ROOT/CoreEmuletoin/android/app/src/main/jniLibs/arm64-v8a"
)

TOTAL=0
ENCONTRADAS=0

for PASTA in "${PASTAS_LIBS[@]}"; do

    TOTAL=$((TOTAL+1))

    echo "----------------------------------------------"

    if [ -d "$PASTA" ]; then

        echo "✅ Pasta encontrada:"
        echo "   $PASTA"

        SO_COUNT=$(find "$PASTA" -maxdepth 1 -name "*.so" | wc -l)

        if [ "$SO_COUNT" -gt 0 ]; then
            echo "📦 Bibliotecas:"
            find "$PASTA" -maxdepth 1 -name "*.so" -exec basename {} \;

            ENCONTRADAS=$((ENCONTRADAS+SO_COUNT))

        else
            echo "⚠ Nenhuma biblioteca .so encontrada."
        fi

    else

        echo "❌ Pasta inexistente:"
        echo "   $PASTA"

    fi

    echo

done

echo "=============================================="
echo "RESUMO"
echo "=============================================="
echo "Pastas verificadas : $TOTAL"
echo "Bibliotecas (.so)  : $ENCONTRADAS"
echo "=============================================="

if [ "$ENCONTRADAS" -gt 0 ]; then
    echo "✅ JNI aparentemente configurado."
else
    echo "⚠ Nenhuma biblioteca nativa encontrada."
fi

echo
read -p "Pressione ENTER para continuar..."
