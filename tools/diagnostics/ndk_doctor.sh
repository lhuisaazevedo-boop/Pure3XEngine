#!/data/data/com.termux/files/usr/bin/bash

clear

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

OK=0
AVISOS=0
ERROS=0

echo "============================================================"
echo "🔧 P3XE - SDK / NDK DOCTOR"
echo "============================================================"
echo "Projeto : $ROOT_DIR"
echo "Doctor  : $SCRIPT_DIR/ndk_doctor.sh"
echo

# ============================================================
# 1/6 - ANDROID SDK
# ============================================================

echo "[ 1/6 ] ANDROID SDK"
echo "------------------------------------------------------------"

SDK_DIR=""

if [ -n "${ANDROID_SDK_ROOT:-}" ] && [ -d "$ANDROID_SDK_ROOT" ]; then
    SDK_DIR="$ANDROID_SDK_ROOT"
elif [ -n "${ANDROID_HOME:-}" ] && [ -d "$ANDROID_HOME" ]; then
    SDK_DIR="$ANDROID_HOME"
elif [ -d "$HOME/Android/Sdk" ]; then
    SDK_DIR="$HOME/Android/Sdk"
fi

if [ -n "$SDK_DIR" ]; then
    echo "✅ SDK encontrado"
    echo "   $SDK_DIR"
    OK=$((OK+1))
else
    echo "❌ Android SDK não encontrado"
    ERROS=$((ERROS+1))
fi

echo

# ============================================================
# 2/6 - ANDROID NDK
# ============================================================

echo "[ 2/6 ] ANDROID NDK"
echo "------------------------------------------------------------"

NDK_DIR=""

# Prioridade 1: NDK r29 independente usado pelo P3XE
if [ -d "$HOME/android-ndk-r29" ]; then
    NDK_DIR="$HOME/android-ndk-r29"

# Prioridade 2: NDK instalado dentro do SDK
elif [ -n "$SDK_DIR" ] && [ -d "$SDK_DIR/ndk" ]; then
    NDK_DIR="$(
        find "$SDK_DIR/ndk" \
            -mindepth 1 -maxdepth 1 \
            -type d 2>/dev/null |
        sort -V |
        tail -n 1
    )"
fi

if [ -n "$NDK_DIR" ] && [ -d "$NDK_DIR" ]; then
    echo "✅ NDK encontrado"
    echo "   $NDK_DIR"
    OK=$((OK+1))

    if [ -f "$NDK_DIR/source.properties" ]; then
        NDK_VERSION="$(
            grep '^Pkg.Revision' "$NDK_DIR/source.properties" |
            cut -d= -f2- |
            xargs
        )"

        echo "✅ source.properties encontrado"
        echo "   Versão: ${NDK_VERSION:-desconhecida}"
        OK=$((OK+1))
    else
        echo "⚠ source.properties não encontrado"
        AVISOS=$((AVISOS+1))
    fi
else
    echo "❌ Android NDK não encontrado"
    ERROS=$((ERROS+1))
fi

echo

# ============================================================
# 3/6 - TOOLCHAIN
# ============================================================

echo "[ 3/6 ] NDK TOOLCHAIN"
echo "------------------------------------------------------------"

if [ -n "$NDK_DIR" ]; then

    TOOLCHAIN="$NDK_DIR/build/cmake/android.toolchain.cmake"

    if [ -f "$TOOLCHAIN" ]; then
        echo "✅ android.toolchain.cmake"
        echo "   $TOOLCHAIN"
        OK=$((OK+1))
    else
        echo "❌ android.toolchain.cmake ausente"
        ERROS=$((ERROS+1))
    fi

    PREBUILT="$NDK_DIR/toolchains/llvm/prebuilt/linux-x86_64/bin"

    if [ -f "$PREBUILT/clang" ]; then
        echo "✅ clang encontrado no NDK"
        OK=$((OK+1))
    else
        echo "⚠ clang x86_64 não encontrado"
        AVISOS=$((AVISOS+1))
    fi

    if [ -f "$PREBUILT/clang++" ]; then
        echo "✅ clang++ encontrado no NDK"
        OK=$((OK+1))
    else
        echo "⚠ clang++ x86_64 não encontrado"
        AVISOS=$((AVISOS+1))
    fi
fi

echo

# ============================================================
# 4/6 - LOCAL.PROPERTIES
# ============================================================

echo "[ 4/6 ] LOCAL.PROPERTIES"
echo "------------------------------------------------------------"

LOCAL_COUNT=0

while IFS= read -r PROP; do
    [ -z "$PROP" ] && continue

    echo "✅ Encontrado:"
    echo "   $PROP"

    grep -E '^(sdk.dir|ndk.dir)=' "$PROP" 2>/dev/null |
        sed 's/^/   /'

    LOCAL_COUNT=$((LOCAL_COUNT+1))
done < <(
    find "$ROOT_DIR" \
        -maxdepth 4 \
        -type f \
        -name "local.properties" \
        2>/dev/null
)

if [ "$LOCAL_COUNT" -eq 0 ]; then
    echo "⚠ Nenhum local.properties encontrado"
    AVISOS=$((AVISOS+1))
else
    echo
    echo "✅ local.properties encontrados: $LOCAL_COUNT"
    OK=$((OK+1))
fi

echo

# ============================================================
# 5/6 - GRADLE WRAPPER
# ============================================================

echo "[ 5/6 ] GRADLE WRAPPER"
echo "------------------------------------------------------------"

GRADLE_COUNT=0

while IFS= read -r WRAPPER; do
    [ -z "$WRAPPER" ] && continue

    echo "✅ Gradle Wrapper:"
    echo "   $WRAPPER"

    GRADLE_COUNT=$((GRADLE_COUNT+1))
done < <(
    find "$ROOT_DIR" \
        -maxdepth 5 \
        -type f \
        -name "gradlew" \
        2>/dev/null
)

if [ "$GRADLE_COUNT" -eq 0 ]; then
    echo "⚠ Nenhum Gradle Wrapper encontrado"
    AVISOS=$((AVISOS+1))
else
    echo
    echo "✅ Gradle Wrappers encontrados: $GRADLE_COUNT"
    OK=$((OK+1))
fi

echo

# ============================================================
# 6/6 - AMBIENTE TERMUX
# ============================================================

echo "[ 6/6 ] AMBIENTE TERMUX"
echo "------------------------------------------------------------"

for CMD in java gradle cmake ninja clang clang++; do
    if command -v "$CMD" >/dev/null 2>&1; then
        echo "✅ $CMD: $(command -v "$CMD")"
        OK=$((OK+1))
    else
        echo "⚠ $CMD não encontrado no PATH"
        AVISOS=$((AVISOS+1))
    fi
done

echo
echo "============================================================"
echo "📊 RESULTADO SDK / NDK DOCTOR"
echo "============================================================"
echo
echo "✅ OK     : $OK"
echo "⚠ Avisos : $AVISOS"
echo "❌ Erros  : $ERROS"
echo

if [ "$ERROS" -eq 0 ] && [ "$AVISOS" -eq 0 ]; then
    echo "✅ SDK / NDK: SAUDÁVEL"
elif [ "$ERROS" -eq 0 ]; then
    echo "⚠ SDK / NDK: FUNCIONAL COM AVISOS"
else
    echo "❌ SDK / NDK: PROBLEMAS DETECTADOS"
fi

echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Diagnostics Center"
echo "============================================================"
echo

read -r -p "Pressione ENTER para voltar..."
