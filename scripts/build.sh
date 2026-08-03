#!/data/data/com.termux/files/usr/bin/bash
set -e

# Caminho do Android NDK
NDK="$HOME/Android/Sdk/ndk/27.0.12077973"
TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64"

# Verifica se o Toolchain existe
if [ ! -d "$TOOLCHAIN" ]; then
    echo "Erro: Toolchain não encontrado:"
    echo "$TOOLCHAIN"
    exit 1
fi

export PATH="$TOOLCHAIN/bin:$PATH"

export CC="$TOOLCHAIN/bin/clang"
export CXX="$TOOLCHAIN/bin/clang++"
export AR="$TOOLCHAIN/bin/llvm-ar"
export RANLIB="$TOOLCHAIN/bin/llvm-ranlib"
export STRIP="$TOOLCHAIN/bin/llvm-strip"

rm -rf out/build
mkdir -p out/build

cmake \
    -S . \
    -B out/build \
    -G Ninja \
    --fresh \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER="$CC" \
    -DCMAKE_CXX_COMPILER="$CXX" \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_CXX_STANDARD_REQUIRED=ON

cmake --build out/build -j$(nproc)
