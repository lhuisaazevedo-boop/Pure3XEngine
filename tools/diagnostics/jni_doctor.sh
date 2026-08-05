#!/data/data/com.termux/files/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

clear

echo "=============================================================="
echo "🔗 P3XE - JNI DOCTOR"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo

echo "[ ARM64-v8a ]"
echo "--------------------------------------------------------------"

PASTAS=0
BIBLIOTECAS=0

while IFS= read -r DIR; do
    [ -z "$DIR" ] && continue

    PASTAS=$((PASTAS + 1))

    echo "✅ ARM64-v8a encontrada"
    echo "   $DIR"

    SO_COUNT=0

    while IFS= read -r SO; do
        [ -z "$SO" ] && continue

        SO_COUNT=$((SO_COUNT + 1))
        BIBLIOTECAS=$((BIBLIOTECAS + 1))

        echo "   📦 $(basename "$SO")"
    done < <(find "$DIR" -maxdepth 1 -type f -name '*.so' 2>/dev/null)

    if [ "$SO_COUNT" -eq 0 ]; then
        echo "   ⚠ Nenhuma biblioteca .so nesta pasta"
    fi

    echo

done < <(
    find "$ROOT_DIR" \
        -type d \
        -name "arm64-v8a" \
        2>/dev/null
)

echo "=============================================================="
echo "📊 RESULTADO JNI DOCTOR"
echo "=============================================================="
echo "Pastas ARM64-v8a : $PASTAS"
echo "Bibliotecas .so  : $BIBLIOTECAS"
echo

if [ "$PASTAS" -eq 0 ]; then
    echo "⚠ Nenhuma pasta ARM64-v8a encontrada."
elif [ "$BIBLIOTECAS" -eq 0 ]; then
    echo "⚠ ARM64-v8a encontrada, mas sem bibliotecas .so."
else
    echo "✅ Bibliotecas nativas ARM64-v8a encontradas."
fi

echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Diagnostics Center"
echo "=============================================================="
echo
read -r -p "Pressione ENTER para voltar..."
