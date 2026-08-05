#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"

OK=0
WARN=0
ERR=0

ok() {
    echo "✅ $1"
    OK=$((OK + 1))
}

warn() {
    echo "⚠ $1"
    WARN=$((WARN + 1))
}

err() {
    echo "❌ $1"
    ERR=$((ERR + 1))
}

line() {
    echo "------------------------------------------------------------"
}

clear

echo "============================================================"
echo "🔧 P3XE - CMAKE / JNI DOCTOR"
echo "============================================================"
echo
echo "Root : $ROOT"

# ============================================================
# 1. CMAKE
# ============================================================

echo
echo "[ 1/7 ] CMAKE"
line

if command -v cmake >/dev/null 2>&1; then
    ok "CMake encontrado: $(command -v cmake)"

    CMAKE_VERSION="$(cmake --version 2>/dev/null | head -n1)"
    echo "   $CMAKE_VERSION"
else
    err "CMake não encontrado"
fi

if command -v ninja >/dev/null 2>&1; then
    ok "Ninja encontrado: $(command -v ninja)"
else
    warn "Ninja não encontrado"
fi

# ============================================================
# 2. COMPILADORES
# ============================================================

echo
echo "[ 2/7 ] COMPILADORES"
line

if command -v clang >/dev/null 2>&1; then
    ok "clang encontrado: $(command -v clang)"
    clang --version 2>/dev/null | head -n1
else
    err "clang não encontrado"
fi

if command -v clang++ >/dev/null 2>&1; then
    ok "clang++ encontrado: $(command -v clang++)"
else
    err "clang++ não encontrado"
fi

# ============================================================
# 3. ANDROID NDK / TOOLCHAIN
# ============================================================

echo
echo "[ 3/7 ] ANDROID NDK / TOOLCHAIN"
line

NDK="$HOME/android-ndk-r29"

if [ -d "$NDK" ]; then
    ok "Android NDK r29 encontrado"
    echo "   $NDK"
else
    err "Android NDK r29 não encontrado"
fi

TOOLCHAIN="$NDK/build/cmake/android.toolchain.cmake"

if [ -f "$TOOLCHAIN" ]; then
    ok "android.toolchain.cmake encontrado"
    echo "   $TOOLCHAIN"
else
    err "android.toolchain.cmake não encontrado"
fi

LLVM="$NDK/toolchains/llvm/prebuilt/linux-x86_64"

if [ -d "$LLVM" ]; then
    ok "LLVM Toolchain encontrado"
    echo "   $LLVM"
else
    err "LLVM Toolchain não encontrado"
fi

# ============================================================
# 4. CUBO3D
# ============================================================

echo
echo "[ 4/7 ] CUBO3D"
line

CUBO="$ROOT/Cubo3D"

if [ -d "$CUBO" ]; then
    ok "Diretório Cubo3D encontrado"
else
    err "Diretório Cubo3D não encontrado"
fi

CUBO_CMAKE="$(find "$CUBO" -name CMakeLists.txt -type f 2>/dev/null | head -n1)"

if [ -n "$CUBO_CMAKE" ]; then
    ok "CMakeLists.txt encontrado"
    echo "   $CUBO_CMAKE"

    if grep -q "CXX_STANDARD.*20\|cxx_std_20\|-std=c++20" \
        "$CUBO_CMAKE" 2>/dev/null
    then
        ok "C++20 detectado"
    else
        warn "C++20 não detectado diretamente no CMakeLists"
    fi
else
    warn "CMakeLists.txt não encontrado no Cubo3D"
fi

JNI_COUNT="$(find "$CUBO" \
    \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
    -type f -exec grep -l "JNIEXPORT\|JNIEnv\|jni.h" {} \; \
    2>/dev/null | wc -l)"

if [ "$JNI_COUNT" -gt 0 ]; then
    ok "JNI encontrado no Cubo3D"
    echo "   Arquivos JNI: $JNI_COUNT"
else
    warn "Nenhuma implementação JNI detectada no Cubo3D"
fi

# ============================================================
# 5. COREEMULATOR
# ============================================================

echo
echo "[ 5/7 ] COREEMULATOR"
line

CORE="$ROOT/CoreEmulator"

if [ -d "$CORE" ]; then
    ok "Diretório CoreEmulator encontrado"
else
    err "Diretório CoreEmulator não encontrado"
fi

CORE_CMAKE="$(find "$CORE" -name CMakeLists.txt -type f 2>/dev/null | head -n1)"

if [ -n "$CORE_CMAKE" ]; then
    ok "CMakeLists.txt encontrado"
    echo "   $CORE_CMAKE"
else
    warn "CMakeLists.txt não encontrado no CoreEmulator"
fi

CORE_JNI="$(find "$CORE" \
    \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
    -type f -exec grep -l "JNIEXPORT\|JNIEnv\|jni.h" {} \; \
    2>/dev/null | wc -l)"

if [ "$CORE_JNI" -gt 0 ]; then
    ok "JNI encontrado no CoreEmulator"
    echo "   Arquivos JNI: $CORE_JNI"
else
    warn "Nenhum JNI detectado no CoreEmulator"
fi

# ============================================================
# 6. QEMU CENTER
# ============================================================

echo
echo "[ 6/7 ] QEMU CENTER"
line

QEMU="$ROOT/QEMUCenter"

if [ -d "$QEMU" ]; then
    ok "Diretório QEMU Center encontrado"
else
    err "Diretório QEMU Center não encontrado"
fi

QEMU_CMAKE="$(find "$QEMU" -name CMakeLists.txt -type f 2>/dev/null | head -n1)"

if [ -n "$QEMU_CMAKE" ]; then
    ok "CMakeLists.txt encontrado"
    echo "   $QEMU_CMAKE"
else
    warn "CMakeLists.txt não encontrado no QEMU Center"
fi

QEMU_JNI="$(find "$QEMU" \
    \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
    -type f -exec grep -l "JNIEXPORT\|JNIEnv\|jni.h" {} \; \
    2>/dev/null | wc -l)"

if [ "$QEMU_JNI" -gt 0 ]; then
    ok "JNI encontrado no QEMU Center"
    echo "   Arquivos JNI: $QEMU_JNI"
else
    warn "Nenhum JNI detectado no QEMU Center"
fi

# ============================================================
# 7. CAÇA A JNI / CMAKE
# ============================================================

echo
echo "[ 7/7 ] CAÇA A CONFIGURAÇÕES"
line

echo "CMakeLists encontrados:"
echo

find \
    "$ROOT/Cubo3D" \
    "$ROOT/CoreEmulator" \
    "$ROOT/QEMUCenter" \
    -name CMakeLists.txt \
    -type f \
    2>/dev/null

echo
echo "Referências JNI encontradas:"
echo

grep -RniE \
    --include="*.cpp" \
    --include="*.cc" \
    --include="*.cxx" \
    --include="*.h" \
    --include="*.hpp" \
    'JNIEXPORT|JNIEnv|jni\.h|Java_' \
    "$ROOT/Cubo3D" \
    "$ROOT/CoreEmulator" \
    "$ROOT/QEMUCenter" \
    2>/dev/null | head -n 60

echo
echo "============================================================"
echo "📊 RESULTADO CMAKE / JNI"
echo "============================================================"
echo
echo "✅ OK     : $OK"
echo "⚠ Avisos : $WARN"
echo "❌ Erros  : $ERR"
echo

if [ "$ERR" -gt 0 ]; then
    echo "❌ CMAKE / JNI: PROBLEMAS ENCONTRADOS"
elif [ "$WARN" -gt 0 ]; then
    echo "⚠ CMAKE / JNI: FUNCIONAL COM AVISOS"
else
    echo "✅ CMAKE / JNI: SAUDÁVEL"
fi

echo
read -r -p "Pressione ENTER para voltar..."
