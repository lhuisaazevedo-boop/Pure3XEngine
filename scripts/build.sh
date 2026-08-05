#!/data/data/com.termux/files/usr/bin/bash
set -e

# ==================================================
# P3XE ANDROID BUILD
# ==================================================

# CORES
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"

# ==================================================
# CAMINHOS
# ==================================================
ANDROID_HOME="$HOME/Android/Sdk"
NDK_BASE="$ANDROID_HOME/ndk"

ABI="arm64-v8a"
API="29"
BUILD_TYPE="Debug"

# ==================================================
# PROCURA NDK
# ==================================================
if [ ! -d "$NDK_BASE" ]; then
    echo -e "${VERMELHO}❌ Pasta NDK não encontrada.${RESET}"
    exit 1
fi

# Lista versões de forma compatível
VERSOES=""
for pasta in "$NDK_BASE"/*/; do
    [ -d "$pasta" ] && VERSOES="$VERSOES $(basename "$pasta")"
done
VERSOES=($(echo $VERSOES | tr ' ' '\n' | sort -Vr))

if [ ${#VERSOES[@]} -eq 0 ]; then
    echo -e "${VERMELHO}❌ Nenhuma versão do Android NDK instalada.${RESET}"
    exit 1
fi

clear

echo -e "${AZUL}==============================================${RESET}"
echo -e "${AZUL}        🛠️ P3XE ANDROID BUILD${RESET}"
echo -e "${AZUL}==============================================${RESET}"
echo
echo "SDK : $ANDROID_HOME"
echo

echo "NDKs encontrados:"
for i in "${!VERSOES[@]}"; do
    printf " %2d) %s\n" "$((i+1))" "${VERSOES[$i]}"
done

echo
echo -ne "${AMARELO}Escolha a versão [1]: ${RESET}"
read ESC

# Validação simples compatível
if [ -z "$ESC" ] || ! echo "$ESC" | grep -qE '^[0-9]+$' || [ "$ESC" -lt 1 ] || [ "$ESC" -gt ${#VERSOES[@]} ]; then
    ESC=1
fi

NDK_VERSAO="${VERSOES[$((ESC-1))]}"
NDK="$NDK_BASE/$NDK_VERSAO"
TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64"

CC="$TOOLCHAIN/bin/clang"
CXX="$TOOLCHAIN/bin/clang++"

# ==================================================
# VERIFICAÇÕES
# ==================================================
if [ ! -d "$TOOLCHAIN" ]; then
    echo -e "${VERMELHO}❌ Toolchain não encontrado.${RESET}"
    exit 1
fi
if [ ! -f "$CC" ]; then
    echo -e "${VERMELHO}❌ clang não encontrado.${RESET}"
    exit 1
fi
if [ ! -f "$CXX" ]; then
    echo -e "${VERMELHO}❌ clang++ não encontrado.${RESET}"
    exit 1
fi
if [ ! -f "$NDK/build/cmake/android.toolchain.cmake" ]; then
    echo -e "${VERMELHO}❌ android.toolchain.cmake não encontrado.${RESET}"
    exit 1
fi

# ==================================================
# AMBIENTE
# ==================================================
export PATH="$TOOLCHAIN/bin:$PATH"
export CC
export CXX
export AR="$TOOLCHAIN/bin/llvm-ar"
export RANLIB="$TOOLCHAIN/bin/llvm-ranlib"
export STRIP="$TOOLCHAIN/bin/llvm-strip"

echo
echo -e "${VERDE}✓ SDK : $ANDROID_HOME${RESET}"
echo -e "${VERDE}✓ NDK : $NDK_VERSAO${RESET}"
echo -e "${VERDE}✓ ABI : $ABI${RESET}"
echo -e "${VERDE}✓ API : android-$API${RESET}"
echo

echo "CMake:"
cmake --version | head -1

echo "Ninja:"
ninja --version
echo

# ==================================================
# BUILD
# ==================================================
rm -rf out/build
mkdir -p out/build

INICIO=$(date +%s)

cmake \
    -S . \
    -B out/build \
    -G Ninja \
    --fresh \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$ABI" \
    -DANDROID_PLATFORM="android-$API" \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_CXX_STANDARD_REQUIRED=ON \
    -DCMAKE_HOST_SYSTEM_PROCESSOR=aarch64

# ✅ Comando que executa a compilação
cmake --build out/build -j"$(nproc)"

FIM=$(date +%s)

echo
echo -e "${VERDE}==============================================${RESET}"
echo -e "${VERDE}🎉 BUILD CONCLUÍDO${RESET}"
echo -e "${VERDE}==============================================${RESET}"
echo "NDK : $NDK_VERSAO"
echo "ABI : $ABI"
echo "API : android-$API"
echo "Tempo : $((FIM-INICIO)) segundos"
echo "Saída : out/build"
echo

