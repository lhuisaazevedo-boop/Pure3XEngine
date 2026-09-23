#!/data/data/com.termux/files/usr/bin/bash
set -e

VERDE="\033[1;32m"; AZUL="\033[1;34m"; AMARELO="\033[1;33m"; VERMELHO="\033[1;31m"; RESET="\033[0m"
ANDROID_HOME="$HOME/Android/Sdk"
NDK_BASE="$ANDROID_HOME/ndk"
ABI="arm64-v8a"
API="29"
BUILD_TYPE="Debug"
CXX_STANDARD="23"

[ -d "$NDK_BASE" ] || { echo -e "${VERMELHO}NDK não encontrado.${RESET}"; exit 1; }
VERSOES=()
for pasta in "$NDK_BASE"/*/; do
    [ -d "$pasta" ] && VERSOES+=("$(basename "$pasta")")
done
IFS=$'\n' VERSOES=($(printf '%s\n' "${VERSOES[@]}" | sort -Vr)); unset IFS
[ ${#VERSOES[@]} -gt 0 ] || { echo -e "${VERMELHO}Nenhum NDK instalado.${RESET}"; exit 1; }

echo -e "${AZUL}P3XE Android Build — C++${CXX_STANDARD}${RESET}"
for i in "${!VERSOES[@]}"; do printf " %2d) %s\n" "$((i+1))" "${VERSOES[$i]}"; done
read -r -p "Escolha a versão [1]: " ESC
if ! [[ "$ESC" =~ ^[0-9]+$ ]] || [ "$ESC" -lt 1 ] || [ "$ESC" -gt "${#VERSOES[@]}" ]; then ESC=1; fi

NDK_VERSAO="${VERSOES[$((ESC-1))]}"
NDK="$NDK_BASE/$NDK_VERSAO"
TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64"
CC="$TOOLCHAIN/bin/clang"
CXX="$TOOLCHAIN/bin/clang++"
[ -x "$CC" ] && [ -x "$CXX" ] || { echo -e "${VERMELHO}Clang não encontrado.${RESET}"; exit 1; }
[ -f "$NDK/build/cmake/android.toolchain.cmake" ] || { echo -e "${VERMELHO}Toolchain CMake não encontrado.${RESET}"; exit 1; }

export PATH="$TOOLCHAIN/bin:$PATH" CC CXX
export AR="$TOOLCHAIN/bin/llvm-ar" RANLIB="$TOOLCHAIN/bin/llvm-ranlib" STRIP="$TOOLCHAIN/bin/llvm-strip"
rm -rf out/build
cmake -S . -B out/build -G Ninja --fresh \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" \
    -DANDROID_NDK="$NDK" -DCMAKE_ANDROID_NDK="$NDK" \
    -DANDROID_ABI="$ABI" -DANDROID_PLATFORM="android-$API" \
    -DCMAKE_CXX_STANDARD="$CXX_STANDARD" \
    -DCMAKE_CXX_STANDARD_REQUIRED=ON \
    -DPUREX_ANDROID=ON -DPUREX_ENGINE=ON
cmake --build out/build -j"$(nproc)"
echo -e "${VERDE}BUILD CONCLUÍDO — NDK $NDK_VERSAO — C++${CXX_STANDARD}${RESET}"
