#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"

REMOVED=0
SKIPPED=0
ERRORS=0

clear

echo "============================================================"
echo "🧹 P3XE - CLEAN PROJECT"
echo "============================================================"
echo
echo "Root: $ROOT"
echo
echo "Este módulo remove SOMENTE arquivos de compilação."
echo "Código-fonte e configurações serão preservados."
echo

clean_dir() {
    local LABEL="$1"
    local DIR="$2"

    if [ -e "$DIR" ]; then
        echo "🧹 Removendo: $LABEL"
        echo "   $DIR"

        if rm -rf -- "$DIR"; then
            echo "✅ Removido"
            REMOVED=$((REMOVED + 1))
        else
            echo "❌ Falha ao remover"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo "➖ Não existe: $LABEL"
        SKIPPED=$((SKIPPED + 1))
    fi
}

clean_project() {
    local NAME="$1"
    local DIR="$2"

    echo
    echo "============================================================"
    echo "📦 $NAME"
    echo "============================================================"

    if [ ! -d "$DIR" ]; then
        echo "⚠ Projeto não encontrado:"
        echo "   $DIR"
        SKIPPED=$((SKIPPED + 1))
        return
    fi

    echo "📁 $DIR"
    echo

    clean_dir "$NAME/build" \
        "$DIR/build"

    clean_dir "$NAME/.gradle" \
        "$DIR/.gradle"

    clean_dir "$NAME/.cxx" \
        "$DIR/.cxx"

    clean_dir "$NAME/app/build" \
        "$DIR/app/build"

    clean_dir "$NAME/app/.cxx" \
        "$DIR/app/.cxx"

    if [ -d "$DIR/android" ]; then

        clean_dir "$NAME/android/build" \
            "$DIR/android/build"

        clean_dir "$NAME/android/.gradle" \
            "$DIR/android/.gradle"

        clean_dir "$NAME/android/.cxx" \
            "$DIR/android/.cxx"

        clean_dir "$NAME/android/app/build" \
            "$DIR/android/app/build"

        clean_dir "$NAME/android/app/.cxx" \
            "$DIR/android/app/.cxx"
    fi
}

echo "============================================================"
echo "[ 1/4 ] Cubo3D"
echo "============================================================"

clean_project \
    "Cubo3D" \
    "$ROOT/Cubo3D"

echo
echo "============================================================"
echo "[ 2/4 ] CoreEmulator"
echo "============================================================"

clean_project \
    "CoreEmulator" \
    "$ROOT/CoreEmulator"

echo
echo "============================================================"
echo "[ 3/4 ] QEMU Center"
echo "============================================================"

clean_project \
    "QEMU Center" \
    "$ROOT/QEMUCenter"

echo
echo "============================================================"
echo "[ 4/4 ] VERIFICAÇÃO"
echo "============================================================"
echo
echo "🔒 Preservados:"
echo "   Código-fonte"
echo "   AndroidManifest.xml"
echo "   CMakeLists.txt"
echo "   build.gradle"
echo "   settings.gradle"
echo "   gradlew"
echo "   Gradle Wrapper"
echo "   gradle.properties"
echo "   local.properties"
echo "   Android SDK"
echo "   Android NDK"
echo "   jniLibs"
echo

echo "============================================================"
echo "📊 RESULTADO CLEAN PROJECT"
echo "============================================================"
echo
echo "🧹 Diretórios removidos : $REMOVED"
echo "➖ Não existentes       : $SKIPPED"
echo "❌ Erros                : $ERRORS"
echo

if [ "$ERRORS" -eq 0 ]; then
    echo "✅ Clean Project concluído com segurança."
else
    echo "⚠ Clean Project terminou com erros."
fi

echo
read -r -p "Pressione ENTER para voltar..."
