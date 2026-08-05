#!/data/data/com.termux/files/usr/bin/bash

# ==============================================================
# P3XE - SMART BUILD
# Pure3XEngine 0.2.6 Alpha
# ==============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

if [ -f "$ROOT_DIR/tools/common/init.sh" ]; then
    source "$ROOT_DIR/tools/common/init.sh"
fi

clear

echo "=============================================================="
echo "🚀 P3XE - BUILD INTELIGENTE"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

OK=0
AVISOS=0
ERROS=0

# --------------------------------------------------------------
# FUNÇÕES
# --------------------------------------------------------------

status_ok() {
    echo "✅ $1"
    OK=$((OK + 1))
}

status_aviso() {
    echo "⚠ $1"
    AVISOS=$((AVISOS + 1))
}

status_erro() {
    echo "❌ $1"
    ERROS=$((ERROS + 1))
}

# --------------------------------------------------------------
# ESTRUTURA
# --------------------------------------------------------------

echo "📁 MÓDULOS DO PROJETO"
echo "--------------------------------------------------------------"

for MOD in CoreEmulator Cubo3D QEMUCenter Android; do
    if [ -d "$ROOT_DIR/$MOD" ]; then
        status_ok "$MOD detectado"
    else
        status_aviso "$MOD não encontrado"
    fi
done

echo

# --------------------------------------------------------------
# FERRAMENTAS
# --------------------------------------------------------------

echo "🔧 FERRAMENTAS DE BUILD"
echo "--------------------------------------------------------------"

for TOOL in clang clang++ cmake make git; do
    if command -v "$TOOL" >/dev/null 2>&1; then
        echo "✅ $TOOL : $(command -v "$TOOL")"
    else
        status_aviso "$TOOL não encontrado"
    fi
done

echo

# --------------------------------------------------------------
# CMAKE
# --------------------------------------------------------------

echo "🧩 CMAKE"
echo "--------------------------------------------------------------"

CMAKE_COUNT=$(find "$ROOT_DIR" \
    -type f -name "CMakeLists.txt" \
    2>/dev/null | wc -l)

echo "CMakeLists encontrados : $CMAKE_COUNT"

if [ "$CMAKE_COUNT" -gt 0 ]; then
    status_ok "Configuração CMake detectada"
else
    status_aviso "Nenhum CMakeLists.txt encontrado"
fi

echo

# --------------------------------------------------------------
# CORE EMULATOR
# --------------------------------------------------------------

echo "🧠 CORE EMULATOR"
echo "--------------------------------------------------------------"

if [ -d "$ROOT_DIR/CoreEmulator" ]; then

    CORE_CPP=$(find "$ROOT_DIR/CoreEmulator" \
        -type f \( -name "*.cpp" -o -name "*.c" \) \
        2>/dev/null | wc -l)

    CORE_HEADERS=$(find "$ROOT_DIR/CoreEmulator" \
        -type f \( -name "*.h" -o -name "*.hpp" \) \
        2>/dev/null | wc -l)

    echo "C/C++   : $CORE_CPP arquivo(s)"
    echo "Headers : $CORE_HEADERS arquivo(s)"

    status_ok "CoreEmulator pronto para análise"
else
    status_aviso "CoreEmulator ausente"
fi

echo

# --------------------------------------------------------------
# CUBO3D
# --------------------------------------------------------------

echo "🎮 CUBO3D"
echo "--------------------------------------------------------------"

if [ -d "$ROOT_DIR/Cubo3D" ]; then

    CUBO_CPP=$(find "$ROOT_DIR/Cubo3D" \
        -type f \( -name "*.cpp" -o -name "*.c" \) \
        2>/dev/null | wc -l)

    echo "C/C++ : $CUBO_CPP arquivo(s)"

    if [ -f "$ROOT_DIR/Cubo3D/CMakeLists.txt" ]; then
        status_ok "Cubo3D possui CMakeLists.txt"
    else
        status_aviso "Cubo3D sem CMakeLists.txt principal"
    fi
else
    status_aviso "Cubo3D ausente"
fi

echo

# --------------------------------------------------------------
# QEMU CENTER
# --------------------------------------------------------------

echo "🖥 QEMU CENTER"
echo "--------------------------------------------------------------"

if [ -d "$ROOT_DIR/QEMUCenter" ]; then

    QEMU_FILES=$(find "$ROOT_DIR/QEMUCenter" \
        -type f 2>/dev/null | wc -l)

    QEMU_CPP=$(find "$ROOT_DIR/QEMUCenter" \
        -type f \( -name "*.cpp" -o -name "*.c" \) \
        2>/dev/null | wc -l)

    echo "Arquivos : $QEMU_FILES"
    echo "C/C++    : $QEMU_CPP"

    if command -v qemu-system-x86_64 >/dev/null 2>&1 || \
       command -v qemu-system-aarch64 >/dev/null 2>&1; then
        status_ok "QEMU Runtime detectado"
    else
        status_aviso "QEMU Runtime não detectado no PATH"
    fi
else
    status_aviso "QEMUCenter ausente"
fi

echo

# --------------------------------------------------------------
# ANDROID
# --------------------------------------------------------------

echo "🤖 ANDROID"
echo "--------------------------------------------------------------"

if [ -d "$ROOT_DIR/Android" ]; then

    JAVA_COUNT=$(find "$ROOT_DIR/Android" \
        -type f -name "*.java" 2>/dev/null | wc -l)

    KOTLIN_COUNT=$(find "$ROOT_DIR/Android" \
        -type f -name "*.kt" 2>/dev/null | wc -l)

    NATIVE_COUNT=$(find "$ROOT_DIR/Android" \
        -type f \( -name "*.cpp" -o -name "*.c" \) \
        2>/dev/null | wc -l)

    echo "Java       : $JAVA_COUNT arquivo(s)"
    echo "Kotlin     : $KOTLIN_COUNT arquivo(s)"
    echo "Native C++ : $NATIVE_COUNT arquivo(s)"

    GRADLEW=$(find "$ROOT_DIR/Android" \
        -type f -name "gradlew" 2>/dev/null | head -n 1)

    if [ -n "$GRADLEW" ]; then
        chmod +x "$GRADLEW" 2>/dev/null
        status_ok "Gradle Wrapper detectado"
    else
        status_aviso "Gradle Wrapper não encontrado dentro de Android"
    fi
else
    status_aviso "Módulo Android ausente"
fi

echo

# --------------------------------------------------------------
# BUILD AUTOMÁTICO
# --------------------------------------------------------------

echo "🏗 BUILD AUTOMÁTICO"
echo "--------------------------------------------------------------"

BUILD_EXECUTADO=0
BUILD_OK=0

# Primeiro tenta Gradle Android
if [ -n "${GRADLEW:-}" ] && [ -f "$GRADLEW" ]; then

    GRADLE_DIR="$(dirname "$GRADLEW")"

    echo "Sistema selecionado : Gradle"
    echo "Diretório           : $GRADLE_DIR"
    echo
    echo "Iniciando assembleDebug..."
    echo

    cd "$GRADLE_DIR" || exit 1

    if ./gradlew assembleDebug --no-daemon; then
        BUILD_OK=1
        status_ok "Build Android concluído"
    else
        status_erro "Build Android falhou"
    fi

    BUILD_EXECUTADO=1

# Caso não exista Gradle, procura CMake principal
elif [ -f "$ROOT_DIR/CMakeLists.txt" ]; then

    echo "Sistema selecionado : CMake"
    echo "Build               : $ROOT_DIR/out/smart-build"
    echo

    mkdir -p "$ROOT_DIR/out/smart-build"

    if cmake \
        -S "$ROOT_DIR" \
        -B "$ROOT_DIR/out/smart-build"; then

        if cmake \
            --build "$ROOT_DIR/out/smart-build" \
            -j "$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"; then

            BUILD_OK=1
            status_ok "Build CMake concluído"
        else
            status_erro "Compilação CMake falhou"
        fi

    else
        status_erro "Configuração CMake falhou"
    fi

    BUILD_EXECUTADO=1
fi

if [ "$BUILD_EXECUTADO" -eq 0 ]; then
    status_aviso "Nenhum sistema automático de build selecionado"
fi

cd "$ROOT_DIR" || exit 1

echo

# --------------------------------------------------------------
# APK
# --------------------------------------------------------------

echo "📦 RESULTADOS"
echo "--------------------------------------------------------------"

APK_COUNT=$(find "$ROOT_DIR" \
    -type f -name "*.apk" \
    2>/dev/null | wc -l)

SO_COUNT=$(find "$ROOT_DIR" \
    -type f -name "*.so" \
    2>/dev/null | wc -l)

echo "APK encontrados        : $APK_COUNT"
echo "Bibliotecas .so        : $SO_COUNT"

if [ "$APK_COUNT" -gt 0 ]; then
    echo
    echo "APK:"
    find "$ROOT_DIR" -type f -name "*.apk" 2>/dev/null
fi

echo
echo "=============================================================="
echo "📊 RESUMO SMART BUILD"
echo "=============================================================="
echo "OK       : $OK"
echo "Avisos   : $AVISOS"
echo "Erros    : $ERROS"
echo

if [ "$BUILD_OK" -eq 1 ] && [ "$ERROS" -eq 0 ]; then
    echo "✅ SMART BUILD: CONCLUÍDO"
elif [ "$ERROS" -gt 0 ]; then
    echo "❌ SMART BUILD: FALHOU"
else
    echo "⚠ SMART BUILD: CONCLUÍDO COM AVISOS"
fi

echo "=============================================================="
echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Smart Build - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
