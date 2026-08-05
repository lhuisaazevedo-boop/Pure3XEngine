#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

echo "=================================================="
echo "           🧹 P3XE - CACHE CLEANER"
echo "=================================================="
echo
echo "Root: $ROOT_DIR"
echo

LIMPOS=0
IGNORADOS=0
ERROS=0

limpar_dir() {
    local DIR="$1"
    local NOME="$2"

    printf "%-28s " "$NOME"

    if [ ! -e "$DIR" ]; then
        echo "➖ não existe"
        ((IGNORADOS++))
        return
    fi

    # Proteção contra caminho perigoso
    case "$DIR" in
        "$ROOT_DIR"/*)
            ;;
        *)
            echo "❌ caminho bloqueado"
            ((ERROS++))
            return
            ;;
    esac

    if rm -rf -- "$DIR"; then
        echo "✅ limpo"
        ((LIMPOS++))
    else
        echo "❌ erro"
        ((ERROS++))
    fi
}

echo "[ 1/4 ] Cubo3D"
echo

limpar_dir "$ROOT_DIR/Cubo3D/build" "build/"
limpar_dir "$ROOT_DIR/Cubo3D/.cxx" ".cxx/"
limpar_dir "$ROOT_DIR/Cubo3D/android/.gradle" "android/.gradle"
limpar_dir "$ROOT_DIR/Cubo3D/android/app/.cxx" "android/app/.cxx"
limpar_dir "$ROOT_DIR/Cubo3D/android/app/build/intermediates" "Gradle intermediates"

echo
echo "[ 2/4 ] CoreEmulator"
echo

limpar_dir "$ROOT_DIR/CoreEmulator/build" "build/"
limpar_dir "$ROOT_DIR/CoreEmulator/.cxx" ".cxx/"
limpar_dir "$ROOT_DIR/CoreEmulator/android/.gradle" "android/.gradle"
limpar_dir "$ROOT_DIR/CoreEmulator/android/app/.cxx" "android/app/.cxx"

echo
echo "[ 3/4 ] QEMU Center"
echo

limpar_dir "$ROOT_DIR/QEMUCenter/build" "build/"
limpar_dir "$ROOT_DIR/QEMUCenter/.cxx" ".cxx/"
limpar_dir "$ROOT_DIR/QEMUCenter/android/.gradle" "android/.gradle"
limpar_dir "$ROOT_DIR/QEMUCenter/android/app/.cxx" "android/app/.cxx"

echo
echo "[ 4/4 ] Arquivos temporários P3XE"
echo

TEMP_COUNT=0

while IFS= read -r -d '' FILE
do
    if rm -f -- "$FILE"; then
        ((TEMP_COUNT++))
    else
        ((ERROS++))
    fi
done < <(
    find "$ROOT_DIR" \
        -type f \
        \( -name '*.tmp' -o -name '*.bak' -o -name '*~' \) \
        -print0 2>/dev/null
)

echo "Temporários removidos: $TEMP_COUNT"

echo
echo "=================================================="
echo "                   📊 RESULTADO"
echo "=================================================="
echo
echo "🧹 Caches limpos : $LIMPOS"
echo "➖ Não existentes: $IGNORADOS"
echo "❌ Erros         : $ERROS"
echo "🗑 Temporários   : $TEMP_COUNT"
echo

if [ "$ERROS" -eq 0 ]; then
    echo "✅ Limpeza concluída com segurança."
else
    echo "⚠ Limpeza concluída com $ERROS erro(s)."
fi

echo
echo "Código-fonte preservado."
echo "SDK/NDK preservados."
echo "jniLibs preservadas."
echo "APKs preservados."

echo
read -p "Pressione ENTER para voltar..."
