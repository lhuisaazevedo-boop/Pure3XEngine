#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"
DOCTOR="$ROOT/tools/doctor"

clear

echo "============================================================"
echo "📊 P3XE - DIAGNÓSTICO COMPLETO"
echo "============================================================"
echo
echo "Root : $ROOT"
echo "Data : $(date)"
echo

TOTAL=0
OK=0
FAIL=0

run_doctor() {
    local NAME="$1"
    local FILE="$2"

    TOTAL=$((TOTAL + 1))

    echo
    echo "============================================================"
    echo "▶ $NAME"
    echo "============================================================"

    if [ ! -f "$FILE" ]; then
        echo "❌ Módulo não encontrado:"
        echo "   $FILE"
        FAIL=$((FAIL + 1))
        return
    fi

    if bash -n "$FILE" >/dev/null 2>&1; then
        echo "✅ Script válido"
    else
        echo "❌ Erro de sintaxe no script"
        FAIL=$((FAIL + 1))
        return
    fi

    echo "📄 Arquivo: $FILE"
    OK=$((OK + 1))
}

echo "[ 1/5 ] VERIFICANDO MÓDULOS"
echo "------------------------------------------------------------"

run_doctor \
    "Doctor Inteligente" \
    "$DOCTOR/doctor_inteligente.sh"

run_doctor \
    "SDK / NDK Doctor" \
    "$DOCTOR/sdk_ndk_doctor.sh"

run_doctor \
    "Gradle Doctor" \
    "$DOCTOR/gradle_doctor.sh"

run_doctor \
    "CMake / JNI Doctor" \
    "$DOCTOR/cmake_jni_doctor.sh"

echo
echo "[ 2/5 ] ESTRUTURA P3XE"
echo "------------------------------------------------------------"

for DIR in Cubo3D CoreEmulator QEMUCenter tools logs; do
    if [ -d "$ROOT/$DIR" ]; then
        echo "✅ $DIR"
    else
        echo "❌ $DIR"
        FAIL=$((FAIL + 1))
    fi
done

echo
echo "[ 3/5 ] ANDROID"
echo "------------------------------------------------------------"

SDK="$HOME/Android/Sdk"
NDK="$HOME/android-ndk-r29"

if [ -d "$SDK" ]; then
    echo "✅ Android SDK"
    echo "   $SDK"
else
    echo "❌ Android SDK não encontrado"
    FAIL=$((FAIL + 1))
fi

if [ -d "$NDK" ]; then
    echo "✅ Android NDK r29"
    echo "   $NDK"
else
    echo "❌ Android NDK r29 não encontrado"
    FAIL=$((FAIL + 1))
fi

if [ -f "$NDK/source.properties" ]; then
    NDK_VERSION="$(
        grep '^Pkg.Revision' "$NDK/source.properties" |
        cut -d= -f2 |
        xargs
    )"

    echo "✅ Versão NDK: $NDK_VERSION"
fi

echo
echo "[ 4/5 ] FERRAMENTAS"
echo "------------------------------------------------------------"

for TOOL in java gradle cmake ninja clang clang++; do
    if command -v "$TOOL" >/dev/null 2>&1; then
        echo "✅ $TOOL: $(command -v "$TOOL")"
    else
        echo "❌ $TOOL não encontrado"
        FAIL=$((FAIL + 1))
    fi
done

echo
echo "[ 5/5 ] PROJETOS"
echo "------------------------------------------------------------"

for PROJECT in Cubo3D CoreEmulator QEMUCenter; do

    echo
    echo "📦 $PROJECT"

    DIR="$ROOT/$PROJECT"

    if [ ! -d "$DIR" ]; then
        echo "❌ Projeto não encontrado"
        continue
    fi

    CMAKE_COUNT="$(
        find "$DIR" -name CMakeLists.txt -type f 2>/dev/null |
        wc -l
    )"

    JNI_COUNT="$(
        find "$DIR" \
        \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
        -type f \
        -exec grep -l 'JNIEXPORT\|JNIEnv\|jni.h' {} \; \
        2>/dev/null |
        wc -l
    )"

    echo "   CMakeLists : $CMAKE_COUNT"
    echo "   JNI        : $JNI_COUNT"

    if [ -f "$DIR/local.properties" ]; then
        echo "✅ local.properties"
    else
        echo "⚠ local.properties não encontrado na raiz"
    fi

    if [ -x "$DIR/gradlew" ]; then
        echo "✅ Gradle Wrapper"
    elif [ -x "$DIR/android/gradlew" ]; then
        echo "✅ Gradle Wrapper (android)"
    else
        echo "⚠ Gradle Wrapper não aplicável/encontrado"
    fi
done

echo
echo "============================================================"
echo "📊 RESULTADO GERAL P3XE"
echo "============================================================"
echo
echo "Módulos verificados : $TOTAL"
echo "✅ Scripts válidos  : $OK"
echo "❌ Falhas críticas  : $FAIL"
echo

if [ "$FAIL" -eq 0 ]; then
    echo "✅ P3XE: SISTEMA SAUDÁVEL"
    echo
    echo "Doctor Inteligente : PRONTO"
    echo "SDK / NDK Doctor   : PRONTO"
    echo "Gradle Doctor      : PRONTO"
    echo "CMake / JNI Doctor : PRONTO"
else
    echo "⚠ P3XE: PROBLEMAS ENCONTRADOS"
fi

echo
echo "============================================================"
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Development Kit"
echo "============================================================"
echo

read -r -p "Pressione ENTER para voltar..."
