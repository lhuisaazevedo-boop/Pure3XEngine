#!/data/data/com.termux/files/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

clear

echo "=============================================================="
echo "⚙ P3XE - GRADLE DOCTOR"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo

OK=0
AVISOS=0

# ============================================================
# 1. GRADLE TERMUX
# ============================================================

echo "[ 1/4 ] GRADLE TERMUX"
echo "--------------------------------------------------------------"

if command -v gradle >/dev/null 2>&1; then
    GRADLE_BIN="$(command -v gradle)"
    echo "✅ Gradle encontrado"
    echo "   $GRADLE_BIN"

    GRADLE_VERSION="$(gradle --version 2>/dev/null | \
        sed -n 's/^Gradle //p' | head -n1)"

    [ -n "$GRADLE_VERSION" ] && echo "   Versão: $GRADLE_VERSION"

    OK=$((OK + 1))
else
    echo "⚠ Gradle do Termux não encontrado"
    AVISOS=$((AVISOS + 1))
fi

echo

# ============================================================
# 2. GRADLE WRAPPERS
# ============================================================

echo "[ 2/4 ] GRADLE WRAPPERS"
echo "--------------------------------------------------------------"

WRAPPERS=0

while IFS= read -r FILE; do
    [ -z "$FILE" ] && continue

    WRAPPERS=$((WRAPPERS + 1))

    echo "✅ gradlew"
    echo "   $FILE"

done < <(
    find "$ROOT_DIR" \
        -type f \
        -name "gradlew" \
        2>/dev/null
)

echo
echo "Gradle Wrappers encontrados: $WRAPPERS"

if [ "$WRAPPERS" -gt 0 ]; then
    OK=$((OK + 1))
else
    AVISOS=$((AVISOS + 1))
fi

echo

# ============================================================
# 3. BUILD.GRADLE
# ============================================================

echo "[ 3/4 ] BUILD.GRADLE"
echo "--------------------------------------------------------------"

BUILDS=0

while IFS= read -r FILE; do
    [ -z "$FILE" ] && continue

    BUILDS=$((BUILDS + 1))

    echo "✅ $(realpath --relative-to="$ROOT_DIR" "$FILE" 2>/dev/null || echo "$FILE")"

    grep -q "compileSdk" "$FILE" &&
        echo "   ✓ compileSdk"

    grep -q "minSdk" "$FILE" &&
        echo "   ✓ minSdk"

    grep -q "targetSdk" "$FILE" &&
        echo "   ✓ targetSdk"

    grep -q "ndkVersion" "$FILE" &&
        echo "   ✓ ndkVersion"

    grep -q "arm64-v8a" "$FILE" &&
        echo "   ✓ arm64-v8a"

    echo

done < <(
    find "$ROOT_DIR" \
        -type f \
        \( -name "build.gradle" -o -name "build.gradle.kts" \) \
        2>/dev/null
)

echo "Build Gradle encontrados: $BUILDS"

if [ "$BUILDS" -gt 0 ]; then
    OK=$((OK + 1))
else
    AVISOS=$((AVISOS + 1))
fi

echo

# ============================================================
# 4. GRADLE WRAPPER
# ============================================================

echo "[ 4/4 ] WRAPPER PROPERTIES"
echo "--------------------------------------------------------------"

PROPERTIES=0

while IFS= read -r FILE; do
    [ -z "$FILE" ] && continue

    PROPERTIES=$((PROPERTIES + 1))

    echo "✅ gradle-wrapper.properties"
    echo "   $FILE"

    VERSION="$(grep '^distributionUrl=' "$FILE" 2>/dev/null |
        sed -n 's/.*gradle-\([0-9][0-9.]*\)-.*/\1/p')"

    [ -n "$VERSION" ] &&
        echo "   Gradle Wrapper: $VERSION"

    echo

done < <(
    find "$ROOT_DIR" \
        -type f \
        -name "gradle-wrapper.properties" \
        2>/dev/null
)

echo "Wrapper properties encontrados: $PROPERTIES"

if [ "$PROPERTIES" -gt 0 ]; then
    OK=$((OK + 1))
else
    AVISOS=$((AVISOS + 1))
fi

echo

# ============================================================
# RESULTADO
# ============================================================

echo "=============================================================="
echo "📊 RESULTADO GRADLE DOCTOR"
echo "=============================================================="
echo "✅ OK     : $OK"
echo "⚠ Avisos : $AVISOS"
echo

if [ "$AVISOS" -eq 0 ]; then
    echo "✅ GRADLE: SAUDÁVEL"
else
    echo "⚠ GRADLE: FUNCIONAL COM AVISOS"
fi

echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Diagnostics Center"
echo "=============================================================="
echo
read -r -p "Pressione ENTER para voltar..."
