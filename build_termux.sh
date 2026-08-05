#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "=================================================="
echo "        Pure3XEngine Build v0.2.5 Alpha"
echo "=================================================="

cd "$(dirname "$0")"

mkdir -p build
cd build

echo "[1/3] Configurando CMake..."
cmake .. \
    -DCMAKE_BUILD_TYPE=Release

echo "[2/3] Compilando..."
cmake --build . -j$(nproc)

echo "[3/3] Copiando biblioteca..."

mkdir -p ../app/src/main/jniLibs/arm64-v8a

if [ -f liblhuis_pure3x.so ]; then
    cp liblhuis_pure3x.so ../app/src/main/jniLibs/arm64-v8a/
elif [ -f lib/liblhuis_pure3x.so ]; then
    cp lib/liblhuis_pure3x.so ../app/src/main/jniLibs/arm64-v8a/
else
    echo "[ERRO] Biblioteca liblhuis_pure3x.so não encontrada."
    exit 1
fi

echo
echo "[OK] Biblioteca copiada para:"
echo "     app/src/main/jniLibs/arm64-v8a/"
echo
echo "[OK] Build concluído com sucesso!"
