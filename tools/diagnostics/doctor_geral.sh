#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"
SDK="$HOME/Android/Sdk"
NDK="$HOME/android-ndk-r29"

OK=0
WARN=0
ERR=0

linha() {
    echo "=============================================================="
}

ok() {
    echo "✅ $1"
    ((OK++))
}

warn() {
    echo "⚠ $1"
    ((WARN++))
}

erro() {
    echo "❌ $1"
    ((ERR++))
}

check_cmd() {
    local CMD="$1"

    if command -v "$CMD" >/dev/null 2>&1; then
        ok "$CMD: $(command -v "$CMD")"
    else
        erro "$CMD não encontrado"
    fi
}

check_dir() {
    local DIR="$1"
    local NAME="$2"

    if [ -d "$DIR" ]; then
        ok "$NAME"
    else
        erro "$NAME não encontrado: $DIR"
    fi
}

clear

linha
echo "🩺 P3XE - DOCTOR GERAL"
linha
echo
echo "Root : $ROOT"
echo "Data : $(date)"
echo

echo "[ 1/7 ] ESTRUTURA P3XE"
linha

check_dir "$ROOT/Cubo3D" "Cubo3D"
check_dir "$ROOT/CoreEmulator" "CoreEmulator"
check_dir "$ROOT/QEMUCenter" "QEMUCenter"
check_dir "$ROOT/tools" "tools"
check_dir "$ROOT/logs" "logs"

echo
echo "[ 2/7 ] FERRAMENTAS"
linha

check_cmd java
check_cmd gradle
check_cmd cmake
check_cmd ninja
check_cmd clang
check_cmd clang++

echo
echo "[ 3/7 ] ANDROID SDK"
linha

if [ -d "$SDK" ]; then
    ok "Android SDK encontrado"
    echo "   $SDK"

    [ -d "$SDK/platforms" ] \
        && ok "SDK platforms encontrado" \
        || warn "SDK platforms não encontrado"

    [ -d "$SDK/build-tools" ] \
        && ok "SDK build-tools encontrado" \
        || warn "SDK build-tools não encontrado"
else
    erro "Android SDK não encontrado"
fi

echo
echo "[ 4/7 ] ANDROID NDK"
linha

if [ -d "$NDK" ]; then
    ok "Android NDK r29 encontrado"
    echo "   $NDK"

    if [ -f "$NDK/source.properties" ]; then
        VERSION="$(grep '^Pkg.Revision' "$NDK/source.properties" |
            cut -d= -f2- |
            xargs)"

        ok "source.properties encontrado"
        echo "   Versão NDK: $VERSION"
    else
        warn "source.properties não encontrado"
    fi

    TOOLCHAIN="$NDK/build/cmake/android.toolchain.cmake"

    if [ -f "$TOOLCHAIN" ]; then
        ok "android.toolchain.cmake encontrado"
    else
        erro "android.toolchain.cmake não encontrado"
    fi
else
    erro "Android NDK r29 não encontrado"
fi

echo
echo "[ 5/7 ] PROJETOS"
linha

for PROJECT in Cubo3D CoreEmulator QEMUCenter; do

    echo
    echo "📦 $PROJECT"

    DIR="$ROOT/$PROJECT"

    if [ ! -d "$DIR" ]; then
        erro "$PROJECT não encontrado"
        continue
    fi

    CMCOUNT="$(find "$DIR" -name CMakeLists.txt \
        -type f 2>/dev/null | wc -l)"

    JNICOUNT="$(grep -RIl \
        -E 'JNIEXPORT|JNIEnv|#include[[:space:]]*<jni.h>' \
        "$DIR" \
        --include='*.cpp' \
        --include='*.cc' \
        --include='*.c' \
        --include='*.h' \
        2>/dev/null | wc -l)"

    echo "   CMakeLists : $CMCOUNT"
    echo "   JNI        : $JNICOUNT"

    if [ "$CMCOUNT" -gt 0 ]; then
        ok "$PROJECT possui configuração CMake"
    else
        warn "$PROJECT não possui CMakeLists.txt"
    fi

    if [ "$JNICOUNT" -gt 0 ]; then
        ok "$PROJECT possui JNI"
    else
        warn "$PROJECT sem JNI detectado"
    fi
done

echo
echo "[ 6/7 ] MÓDULOS DIAGNOSTICS"
linha

for MODULE in \
    cmake_doctor.sh \
    ndk_doctor.sh \
    jni_doctor.sh \
    gradle_doctor.sh
do
    FILE="$ROOT/tools/diagnostics/$MODULE"

    if [ -f "$FILE" ]; then
        if bash -n "$FILE" >/dev/null 2>&1; then
            ok "$MODULE válido"
        else
            erro "$MODULE possui erro de sintaxe"
        fi
    else
        erro "$MODULE não encontrado"
    fi
done

REPORT="$ROOT/tools/development/relatorio_inteligente.sh"

if [ -f "$REPORT" ]; then
    if bash -n "$REPORT" >/dev/null 2>&1; then
        ok "relatorio_inteligente.sh válido"
    else
        erro "relatorio_inteligente.sh possui erro de sintaxe"
    fi
else
    warn "relatorio_inteligente.sh não encontrado"
fi

echo
echo "[ 7/7 ] RESULTADO"
linha

echo
echo "📊 RESULTADO DO DOCTOR GERAL"
linha
echo
echo "✅ OK     : $OK"
echo "⚠ Avisos : $WARN"
echo "❌ Erros  : $ERR"
echo

if [ "$ERR" -eq 0 ] && [ "$WARN" -eq 0 ]; then
    echo "✅ P3XE: SISTEMA SAUDÁVEL"

elif [ "$ERR" -eq 0 ]; then
    echo "⚠ P3XE: FUNCIONAL COM AVISOS"

else
    echo "❌ P3XE: PROBLEMAS ENCONTRADOS"
fi

echo
linha
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Diagnostics Center"
linha
echo

read -r -p "Pressione ENTER para voltar..."
