#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

echo "=================================================="
echo "          📦 P3XE - SDK / NDK DOCTOR"
echo "=================================================="
echo
echo "Root: $ROOT_DIR"
echo

OK=0
AVISOS=0
ERROS=0

echo "[ 1/5 ] Procurando Android SDK"
echo

SDK=""

for DIR in \
    "$ANDROID_SDK_ROOT" \
    "$ANDROID_HOME" \
    "$HOME/android-sdk" \
    "$HOME/Android/Sdk"
do
    [ -z "$DIR" ] && continue

    if [ -d "$DIR" ]; then
        SDK="$DIR"
        break
    fi
done

if [ -n "$SDK" ]; then
    echo "✅ SDK encontrado"
    echo "   $SDK"
    ((OK++))
else
    echo "⚠ SDK não encontrado nos caminhos conhecidos"
    ((AVISOS++))
fi

echo
echo "[ 2/5 ] Procurando Android NDK"
echo

NDK=""

for DIR in \
    "$ANDROID_NDK_HOME" \
    "$ANDROID_NDK_ROOT" \
    "$HOME/android-ndk-r29" \
    "$HOME/android-ndk-r29-beta3"
do
    [ -z "$DIR" ] && continue

    if [ -d "$DIR" ]; then
        NDK="$DIR"
        break
    fi
done

if [ -n "$NDK" ]; then
    echo "✅ NDK encontrado"
    echo "   $NDK"

    if [ -f "$NDK/source.properties" ]; then
        REVISION="$(grep '^Pkg.Revision' "$NDK/source.properties" | cut -d= -f2- | xargs)"
        [ -n "$REVISION" ] && echo "   Versão: $REVISION"
    fi

    ((OK++))
else
    echo "❌ Android NDK não encontrado"
    ((ERROS++))
fi

echo
echo "[ 3/5 ] Toolchain NDK"
echo

if [ -n "$NDK" ]; then

    TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64"

    if [ -d "$TOOLCHAIN" ]; then
        echo "✅ LLVM Toolchain"
        echo "   $TOOLCHAIN"
        ((OK++))
    else
        echo "❌ LLVM Toolchain não encontrado"
        ((ERROS++))
    fi

    CMAKE_TOOLCHAIN="$NDK/build/cmake/android.toolchain.cmake"

    if [ -f "$CMAKE_TOOLCHAIN" ]; then
        echo "✅ android.toolchain.cmake"
        ((OK++))
    else
        echo "❌ android.toolchain.cmake ausente"
        ((ERROS++))
    fi
fi

echo
echo "[ 4/5 ] Ferramentas do ambiente"
echo

for CMD in clang clang++ cmake ninja java git
do
    CAMINHO="$(command -v "$CMD" 2>/dev/null)"

    if [ -n "$CAMINHO" ]; then
        printf "✅ %-8s %s\n" "$CMD" "$CAMINHO"
        ((OK++))
    else
        printf "❌ %-8s NÃO ENCONTRADO\n" "$CMD"
        ((ERROS++))
    fi
done

echo
echo "[ 5/5 ] Android / Arquitetura"
echo

echo "Arquitetura : $(uname -m)"
echo "Android     : $(getprop ro.build.version.release 2>/dev/null)"
echo "API         : $(getprop ro.build.version.sdk 2>/dev/null)"

echo
echo "=================================================="
echo "                  📊 RESULTADO"
echo "=================================================="
echo "✅ OK      : $OK"
echo "⚠ Avisos  : $AVISOS"
echo "❌ Erros   : $ERROS"
echo

if [ "$ERROS" -eq 0 ]; then
    echo "✅ Toolchain principal pronta."
elif [ -n "$NDK" ]; then
    echo "⚠ NDK localizado, mas existem componentes a revisar."
else
    echo "❌ Ambiente Android precisa de reparo."
fi

echo
read -p "Pressione ENTER para voltar..."
