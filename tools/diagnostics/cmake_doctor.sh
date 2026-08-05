#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE CMAKE DOCTOR
# Pure3XEngine Development Kit
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

TOTAL=0
OK=0
AVISOS=0
ERROS=0

linha() {
    echo "============================================================"
}

verificar_cmake() {
    local NOME="$1"
    local ARQ="$2"

    TOTAL=$((TOTAL + 1))

    echo
    linha
    echo "📦 $NOME"
    linha

    if [ ! -f "$ARQ" ]; then
        echo "❌ CMakeLists.txt NÃO ENCONTRADO"
        echo "   Esperado:"
        echo "   $ARQ"
        ERROS=$((ERROS + 1))
        return
    fi

    echo "✅ CMakeLists.txt encontrado"
    echo "   $ARQ"
    OK=$((OK + 1))

    echo
    echo "🔎 Verificando configuração..."

    if grep -Eq 'cmake_minimum_required[[:space:]]*\(' "$ARQ"; then
        echo "   ✅ cmake_minimum_required"
    else
        echo "   ⚠ cmake_minimum_required ausente"
        AVISOS=$((AVISOS + 1))
    fi

    if grep -Eq 'project[[:space:]]*\(' "$ARQ"; then
        echo "   ✅ project()"
    else
        echo "   ⚠ project() não encontrado"
        AVISOS=$((AVISOS + 1))
    fi

    if grep -Eq 'CMAKE_CXX_STANDARD[[:space:]]+20|cxx_std_20|-std=c\+\+20' "$ARQ"; then
        echo "   ✅ C++20 detectado"
    else
        echo "   ⚠ C++20 não detectado"
        AVISOS=$((AVISOS + 1))
    fi

    if grep -Eq 'add_library[[:space:]]*\(' "$ARQ"; then
        echo "   ✅ add_library() detectado"
    elif grep -Eq 'add_executable[[:space:]]*\(' "$ARQ"; then
        echo "   ✅ add_executable() detectado"
    else
        echo "   ⚠ Nenhum target add_library/add_executable detectado"
        AVISOS=$((AVISOS + 1))
    fi
}

clear

linha
echo "🔍 P3XE - CMAKE DOCTOR"
linha
echo
echo "Projeto : $PROJETO_ROOT"
echo "Doctor  : $SCRIPT_DIR/cmake_doctor.sh"

echo
echo "[ 1/4 ] CUBO3D PRINCIPAL"
verificar_cmake \
    "Cubo3D Principal" \
    "$PROJETO_ROOT/Cubo3D/CMakeLists.txt"

echo
echo "[ 2/4 ] CUBO3D ANDROID"
verificar_cmake \
    "Cubo3D Android" \
    "$PROJETO_ROOT/Cubo3D/android/CMakeLists.txt"

echo
echo "[ 3/4 ] COREEMULATOR"

# O CoreEmulator possui CMake principal.
verificar_cmake \
    "CoreEmulator Principal" \
    "$PROJETO_ROOT/CoreEmulator/CMakeLists.txt"

echo
echo "[ 4/4 ] QEMU CENTER"
verificar_cmake \
    "QEMU Center JNI" \
    "$PROJETO_ROOT/QEMUCenter/app/src/main/cpp/CMakeLists.txt"

echo
linha
echo "📊 RESULTADO CMAKE DOCTOR"
linha
echo
echo "Arquivos verificados : $TOTAL"
echo "✅ Encontrados       : $OK"
echo "⚠ Avisos             : $AVISOS"
echo "❌ Erros              : $ERROS"
echo

if [ "$ERROS" -gt 0 ]; then
    echo "❌ CMAKE: PROBLEMAS ENCONTRADOS"
elif [ "$AVISOS" -gt 0 ]; then
    echo "⚠ CMAKE: FUNCIONAL COM AVISOS"
else
    echo "✅ CMAKE: SAUDÁVEL"
fi

echo
linha
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Diagnostics Center"
linha
echo

read -r -p "Pressione ENTER para voltar..."
