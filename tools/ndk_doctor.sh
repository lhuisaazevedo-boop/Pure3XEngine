#!/data/data/com.termux/files/usr/bin/bash

clear

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "==========================================================="
echo "🔎 SDK / NDK DOCTOR — VERIFICAÇÃO COMPLETA"
echo "==========================================================="
echo "Projeto: $PROJETO_ROOT"
echo

LOCAL_PROPERTIES="$PROJETO_ROOT/android/local.properties"

if [ ! -f "$LOCAL_PROPERTIES" ]; then
    echo "❌ local.properties não encontrado:"
    echo "   $LOCAL_PROPERTIES"
    echo
    read -r -p "Pressione ENTER para voltar..."
    exit 1
fi

SDK_DIR=$(grep "^sdk.dir=" "$LOCAL_PROPERTIES" | cut -d= -f2-)
NDK_DIR=$(grep "^ndk.dir=" "$LOCAL_PROPERTIES" | cut -d= -f2-)

echo "📂 CAMINHOS CONFIGURADOS"
echo "-----------------------------------------------------------"
echo "SDK : $SDK_DIR"
echo "NDK : $NDK_DIR"
echo

echo "📦 VERIFICANDO PASTAS"
echo "-----------------------------------------------------------"

if [ -d "$SDK_DIR" ]; then
    echo "✅ SDK encontrado"
else
    echo "❌ SDK não encontrado"
fi

if [ -d "$NDK_DIR" ]; then
    echo "✅ NDK encontrado"
else
    echo "❌ NDK não encontrado"
fi

echo

echo "🛠 VERIFICANDO FERRAMENTAS"
echo "-----------------------------------------------------------"

[ -f "$NDK_DIR/build/cmake/android.toolchain.cmake" ] \
&& echo "✅ android.toolchain.cmake" \
|| echo "❌ android.toolchain.cmake"

[ -f "$NDK_DIR/source.properties" ] \
&& echo "✅ source.properties" \
|| echo "❌ source.properties"

[ -f "$NDK_DIR/toolchains/llvm/prebuilt/linux-x86_64/bin/clang" ] \
&& echo "✅ clang" \
|| echo "❌ clang"

[ -f "$NDK_DIR/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++" ] \
&& echo "✅ clang++" \
|| echo "❌ clang++"

echo

echo "📋 VERSÕES"
echo "-----------------------------------------------------------"

if [ -f "$NDK_DIR/source.properties" ]; then
    grep "Pkg.Revision" "$NDK_DIR/source.properties"
fi

echo

if [ -x "$PROJETO_ROOT/gradlew" ]; then
    "$PROJETO_ROOT/gradlew" --version | grep Gradle
else
    echo "⚠ gradlew não encontrado"
fi

echo

echo "📊 RESUMO"
echo "==========================================================="

if [ -d "$SDK_DIR" ] && \
   [ -d "$NDK_DIR" ] && \
   [ -f "$NDK_DIR/build/cmake/android.toolchain.cmake" ]; then
    echo "✅ SDK / NDK aparentemente configurados."
else
    echo "❌ Existem problemas na configuração do SDK/NDK."
fi

echo
read -r -p "Pressione ENTER para voltar..."
