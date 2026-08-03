#!/data/data/com.termux/files/usr/bin/bash

clear

# Caminhos absolutos do projeto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=================================================="
echo "        🩺 P3XE DOCTOR — DIAGNÓSTICO COMPLETO"
echo "=================================================="
echo "Data: $(date)"
echo "Pasta do projeto: $PROJETO_ROOT"
echo ""

STATUS_OK="✅"
STATUS_ERRO="❌"
STATUS_AVISO="⚠️"

# ==============================================
# 1. SISTEMA E ARQUITETURA
# ==============================================
echo "🔹 1. SISTEMA E ARQUITETURA"
if [ "$(uname -m)" = "aarch64" ]; then
    echo "   $STATUS_OK Arquitetura: $(uname -m)"
else
    echo "   $STATUS_ERRO Arquitetura incompatível: $(uname -m)"
fi
echo ""

# ==============================================
# 2. CAMINHOS SDK / NDK
# ==============================================
echo "🔹 2. SDK / NDK"
LOCAL_PROPS="$PROJETO_ROOT/local.properties"
if [ -f "$LOCAL_PROPS" ]; then
    source "$LOCAL_PROPS"
    [ -d "$sdk.dir" ] && echo "   $STATUS_OK SDK: $sdk.dir" || echo "   $STATUS_ERRO SDK não encontrado"
    [ -d "$ndk.dir" ] && echo "   $STATUS_OK NDK: $ndk.dir" || echo "   $STATUS_ERRO NDK não encontrado"
else
    echo "   $STATUS_ERRO Arquivo local.properties não encontrado!"
fi
echo ""

# ==============================================
# 3. FERRAMENTAS OBRIGATÓRIAS
# ==============================================
echo "🔹 3. FERRAMENTAS"
for FERR in gradle cmake ninja clang++; do
    command -v "$FERR" >/dev/null 2>&1 && echo "   $STATUS_OK $FERR" || echo "   $STATUS_ERRO $FERR não instalado"
done
echo ""

# ==============================================
# 4. ESTRUTURA DO PROJETO
# ==============================================
echo "🔹 4. ESTRUTURA DO PROJETO"
ARQUIVOS=(
    "$PROJETO_ROOT/app/build.gradle"
    "$PROJETO_ROOT/app/src/main/AndroidManifest.xml"
    "$PROJETO_ROOT/app/src/main/jniLibs/arm64-v8a/liblhuis.pure3x.so"
    "$PROJETO_ROOT/app/src/main/jniLibs/arm64-v8a/libCubo3D.so"
    "$PROJETO_ROOT/../../CMakeLists.txt"
)
for ARQ in "${ARQUIVOS[@]}"; do
    [ -f "$ARQ" ] && echo "   $STATUS_OK $ARQ" || echo "   $STATUS_ERRO $ARQ faltando"
done
echo ""

# ==============================================
# 5. CACHES E PASTAS TEMPORÁRIAS
# ==============================================
echo "🔹 5. CACHES"
if [ -d "$PROJETO_ROOT/app/.cxx" ] || [ -d "$PROJETO_ROOT/.gradle" ]; then
    echo "   $STATUS_AVISO Cache antigo encontrado — execute ./repair.sh"
else
    echo "   $STATUS_OK Cache limpo"
fi

echo "=================================================="
echo "   Use ./repair.sh para corrigir problemas"
echo "=================================================="

