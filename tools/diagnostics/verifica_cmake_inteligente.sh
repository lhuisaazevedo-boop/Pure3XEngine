#!/data/data/com.termux/files/usr/bin/bash
# Diagnóstico somente leitura. Não grava compiladores fixos nem altera CMakeLists.
set -u
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
NDK_CAMINHO="$ROOT/Android/Sdk/ndk/29.0.14206865"
[ -d "$NDK_CAMINHO" ] || NDK_CAMINHO="$HOME/Android/Sdk/ndk/29.0.14206865"

for CAMINHO in "$ROOT/CMakeLists.txt" "$ROOT/Cubo3D/CMakeLists.txt" "$ROOT/CoreEmulator/CMakeLists.txt"; do
    echo "Verificando: $CAMINHO"
    [ -f "$CAMINHO" ] || { echo "ERRO: arquivo ausente"; continue; }
    grep -Eq 'CMAKE_CXX_STANDARD[[:space:]]+23' "$CAMINHO" && echo "OK: C++23" || echo "ERRO: C++23 ausente"
    if grep -Eq 'CMAKE_C_COMPILER|CMAKE_CXX_COMPILER' "$CAMINHO"; then
        echo "ERRO: compilador fixo encontrado; remova essas linhas"
    else
        echo "OK: compilador fornecido pelo toolchain"
    fi
done

echo "NDK esperado: $NDK_CAMINHO"
[ -f "$NDK_CAMINHO/build/cmake/android.toolchain.cmake" ] && echo "OK: NDK r29" || echo "ERRO: NDK r29 não encontrado"
