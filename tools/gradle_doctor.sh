#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# P3XE GRADLE DOCTOR
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo
echo "=============================================="
echo "🔍 GRADLE DOCTOR — VERIFICAÇÃO COMPLETA"
echo "=============================================="
echo "Projeto : $PROJETO_ROOT"
echo

# ----------------------------------------------------------
# Gradle
# ----------------------------------------------------------

if [ -f "$PROJETO_ROOT/gradlew" ]; then
    chmod +x "$PROJETO_ROOT/gradlew"

    echo "✅ gradlew encontrado"

    "$PROJETO_ROOT/gradlew" --version 2>/dev/null | grep "Gradle "

else
    echo "❌ gradlew não encontrado"
fi

echo

# ----------------------------------------------------------
# build.gradle
# ----------------------------------------------------------

BUILD_GRADLE="$PROJETO_ROOT/app/build.gradle"

echo "📦 Verificando build.gradle..."

if [ -f "$BUILD_GRADLE" ]; then

    echo "✅ build.gradle encontrado"

    grep -q "ndkVersion" "$BUILD_GRADLE" \
        && echo "✔ ndkVersion"

    grep -q "abiFilters" "$BUILD_GRADLE" \
        && echo "✔ abiFilters"

    grep -q "arm64-v8a" "$BUILD_GRADLE" \
        && echo "✔ arm64-v8a"

    grep -q "compileSdk" "$BUILD_GRADLE" \
        && echo "✔ compileSdk"

    grep -q "minSdk" "$BUILD_GRADLE" \
        && echo "✔ minSdk"

    grep -q "targetSdk" "$BUILD_GRADLE" \
        && echo "✔ targetSdk"

else

    echo "❌ app/build.gradle não encontrado"

fi

echo

# ----------------------------------------------------------
# Wrapper
# ----------------------------------------------------------

if [ -d "$PROJETO_ROOT/gradle/wrapper" ]; then
    echo "✅ gradle/wrapper encontrado"
else
    echo "❌ gradle/wrapper não encontrado"
fi

echo

echo "=============================================="
echo "Gradle Doctor finalizado."
echo "=============================================="

read -p "Pressione ENTER para continuar..."
