#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

clear

echo "=============================================================="
echo "🔧 P3XE - CORRIGIR PROJETO"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

CORRECOES=0
AVISOS=0
ERROS=0

echo "📁 ESTRUTURA DO PROJETO"
echo "--------------------------------------------------------------"

DIRS=(
    "CoreEmulator"
    "Cubo3D"
    "QEMUCenter"
    "Android"
    "Config"
    "tools"
    "tools/ai"
    "tools/common"
    "tools/emulator"
)

for DIR in "${DIRS[@]}"; do
    if [ -d "$ROOT_DIR/$DIR" ]; then
        echo "✅ $DIR"
    else
        echo "⚠ Criando $DIR"
        mkdir -p "$ROOT_DIR/$DIR"

        if [ $? -eq 0 ]; then
            echo "   ✅ Diretório criado"
            ((CORRECOES++))
        else
            echo "   ❌ Falha ao criar"
            ((ERROS++))
        fi
    fi
done

echo
echo "🔧 PERMISSÕES DOS SCRIPTS"
echo "--------------------------------------------------------------"

SCRIPT_COUNT=0

while IFS= read -r -d '' SCRIPT; do
    ((SCRIPT_COUNT++))

    if [ ! -x "$SCRIPT" ]; then
        chmod +x "$SCRIPT"

        if [ -x "$SCRIPT" ]; then
            echo "✅ Corrigido: ${SCRIPT#$ROOT_DIR/}"
            ((CORRECOES++))
        else
            echo "❌ Falha: ${SCRIPT#$ROOT_DIR/}"
            ((ERROS++))
        fi
    fi
done < <(find "$ROOT_DIR/tools" -type f -name "*.sh" -print0 2>/dev/null)

echo "Scripts verificados : $SCRIPT_COUNT"

echo
echo "🧪 SINTAXE BASH"
echo "--------------------------------------------------------------"

BASH_OK=0
BASH_ERROR=0

while IFS= read -r -d '' SCRIPT; do

    if bash -n "$SCRIPT" 2>/dev/null; then
        ((BASH_OK++))
    else
        echo "❌ Erro de sintaxe: ${SCRIPT#$ROOT_DIR/}"
        ((BASH_ERROR++))
        ((ERROS++))
    fi

done < <(find "$ROOT_DIR/tools" -type f -name "*.sh" -print0 2>/dev/null)

echo "Scripts OK          : $BASH_OK"
echo "Scripts com erro    : $BASH_ERROR"

echo
echo "🧹 CACHE / BUILD"
echo "--------------------------------------------------------------"

CACHE_COUNT=0

while IFS= read -r -d '' CACHE; do
    echo "⚠ Cache CMake encontrado:"
    echo "   ${CACHE#$ROOT_DIR/}"
    ((CACHE_COUNT++))
done < <(find "$ROOT_DIR" -type f -name "CMakeCache.txt" -print0 2>/dev/null)

if [ "$CACHE_COUNT" -eq 0 ]; then
    echo "✅ Nenhum CMakeCache problemático detectado"
else
    echo "⚠ $CACHE_COUNT cache(s) encontrado(s)"
    ((AVISOS++))
fi

echo
echo "🤖 ANDROID"
echo "--------------------------------------------------------------"

if [ -f "$ROOT_DIR/Android/gradlew" ]; then
    chmod +x "$ROOT_DIR/Android/gradlew"
    echo "✅ Gradle Wrapper pronto"
elif [ -f "$ROOT_DIR/gradlew" ]; then
    chmod +x "$ROOT_DIR/gradlew"
    echo "✅ Gradle Wrapper pronto"
else
    echo "⚠ Gradle Wrapper não encontrado"
    ((AVISOS++))
fi

if find "$ROOT_DIR" -type f -name "AndroidManifest.xml" -print -quit 2>/dev/null | grep -q .; then
    echo "✅ AndroidManifest.xml encontrado"
else
    echo "⚠ AndroidManifest.xml não encontrado"
    ((AVISOS++))
fi

echo
echo "🧰 FERRAMENTAS"
echo "--------------------------------------------------------------"

for TOOL in clang clang++ cmake git make; do
    if command -v "$TOOL" >/dev/null 2>&1; then
        echo "✅ $TOOL"
    else
        echo "❌ $TOOL não encontrado"
        ((ERROS++))
    fi
done

echo
echo "📊 RESULTADO"
echo "=============================================================="
echo "Correções realizadas : $CORRECOES"
echo "Avisos               : $AVISOS"
echo "Erros                : $ERROS"
echo "=============================================================="

if [ "$ERROS" -gt 0 ]; then
    echo "❌ FIX PROJECT: EXISTEM ERROS PARA CORRIGIR"
elif [ "$AVISOS" -gt 0 ]; then
    echo "⚠ FIX PROJECT: CONCLUÍDO COM AVISOS"
else
    echo "✅ FIX PROJECT: PROJETO ORGANIZADO"
fi

echo "=============================================================="
echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Fix Project - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
