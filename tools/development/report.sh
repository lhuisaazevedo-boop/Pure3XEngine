#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

CUBO3D="$ROOT_DIR/Cubo3D"
CORE="$ROOT_DIR/CoreEmulator"
ANDROID="$CUBO3D/android"
JNI="$ANDROID/app/src/main/jniLibs/arm64-v8a"

SDK_DIR="${ANDROID_SDK_ROOT:-$HOME/android-sdk}"
NDK_DIR="${ANDROID_NDK_ROOT:-$HOME/android-ndk-r29}"

clear

echo "============================================================"
echo "                 P3XE HEALTH REPORT"
echo "============================================================"
echo
echo "Data        : $(date)"
echo "Projeto     : Pure3XEngine"
echo "Versão      : 0.2.6 Alpha"
echo "Root        : $ROOT_DIR"
echo "Arquitetura : $(uname -m)"
echo "Android     : $(getprop ro.build.version.release 2>/dev/null)"
echo "API         : $(getprop ro.build.version.sdk 2>/dev/null)"
echo "Kernel      : $(uname -r)"
echo

echo "============================================================"
echo " [ ESTRUTURA DO PROJETO ]"
echo "============================================================"

for item in Cubo3D CoreEmulator tools; do
    if [ -d "$ROOT_DIR/$item" ]; then
        echo "OK   $item"
    else
        echo "ERRO $item não encontrado"
    fi
done

echo
echo "============================================================"
echo " [ TOOLCHAIN ]"
echo "============================================================"

if [ -d "$SDK_DIR" ]; then
    echo "SDK    : OK ($SDK_DIR)"
else
    echo "SDK    : NÃO ENCONTRADO ($SDK_DIR)"
fi

if [ -d "$NDK_DIR" ]; then
    echo "NDK    : OK ($NDK_DIR)"
else
    echo "NDK    : NÃO ENCONTRADO ($NDK_DIR)"
fi

for cmd in clang clang++ cmake ninja java git; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd : $(command -v "$cmd")"
    else
        echo "$cmd : NÃO ENCONTRADO"
    fi
done

echo
echo "Clang:"
clang --version 2>/dev/null | head -1

echo
echo "CMake:"
cmake --version 2>/dev/null | head -1

echo
echo "Java:"
java -version 2>&1 | head -1

echo
echo "============================================================"
echo " [ CUBO3D ]"
echo "============================================================"

if [ -f "$CUBO3D/CMakeLists.txt" ]; then
    echo "CMakeLists.txt : OK"
else
    echo "CMakeLists.txt : NÃO ENCONTRADO"
fi

if [ -d "$ANDROID" ]; then
    echo "Android       : OK"
else
    echo "Android       : NÃO ENCONTRADO"
fi

if [ -f "$ANDROID/app/build.gradle" ]; then
    echo "build.gradle  : OK"
else
    echo "build.gradle  : NÃO ENCONTRADO"
fi

if [ -f "$ANDROID/gradlew" ]; then
    echo "Gradle Wrapper: OK"
else
    echo "Gradle Wrapper: NÃO ENCONTRADO"
fi

echo
echo "============================================================"
echo " [ JNI ARM64 ]"
echo "============================================================"

if [ -d "$JNI" ]; then
    echo "Diretório: $JNI"
    echo

    if find "$JNI" -maxdepth 1 -type f -name '*.so' | grep -q .; then
        for lib in "$JNI"/*.so; do
            [ -f "$lib" ] || continue
            echo "$(basename "$lib")"
            echo "  Tamanho: $(du -h "$lib" | cut -f1)"
            file "$lib" 2>/dev/null | sed 's/^/  /'
        done
    else
        echo "Nenhuma biblioteca .so encontrada."
    fi
else
    echo "JNI arm64-v8a não encontrado."
fi

echo
echo "============================================================"
echo " [ APK ]"
echo "============================================================"

APK_COUNT=$(find "$ANDROID/app/build/outputs/apk" \
    -type f -name '*.apk' 2>/dev/null | wc -l)

echo "APKs encontrados: $APK_COUNT"

find "$ANDROID/app/build/outputs/apk" \
    -type f -name '*.apk' -print 2>/dev/null

echo
echo "============================================================"
echo " [ CÓDIGO DO PROJETO ]"
echo "============================================================"

CPP_COUNT=$(find "$CUBO3D" "$CORE" \
    -type f \( -name '*.cpp' -o -name '*.cc' -o -name '*.c' \) \
    2>/dev/null | wc -l)

HEADER_COUNT=$(find "$CUBO3D" "$CORE" \
    -type f \( -name '*.h' -o -name '*.hpp' \) \
    2>/dev/null | wc -l)

SH_COUNT=$(find "$ROOT_DIR/tools" \
    -type f -name '*.sh' 2>/dev/null | wc -l)

echo "C/C++       : $CPP_COUNT"
echo "Headers     : $HEADER_COUNT"
echo "Scripts P3XE: $SH_COUNT"

echo
echo "============================================================"
echo " [ ARMAZENAMENTO ]"
echo "============================================================"

echo "Projeto:"
du -sh "$ROOT_DIR" 2>/dev/null

echo
echo "Disco:"
df -h "$HOME" 2>/dev/null | tail -1

echo
echo "============================================================"
echo " [ STATUS ]"
echo "============================================================"

ERROS=0

[ -d "$CUBO3D" ] || ERROS=$((ERROS + 1))
[ -d "$CORE" ] || ERROS=$((ERROS + 1))
[ -f "$CUBO3D/CMakeLists.txt" ] || ERROS=$((ERROS + 1))
[ -f "$ANDROID/app/build.gradle" ] || ERROS=$((ERROS + 1))
command -v cmake >/dev/null 2>&1 || ERROS=$((ERROS + 1))
command -v clang++ >/dev/null 2>&1 || ERROS=$((ERROS + 1))

if [ "$ERROS" -eq 0 ]; then
    echo "STATUS: ESTRUTURA PRINCIPAL OK"
else
    echo "STATUS: $ERROS problema(s) encontrado(s)"
fi

echo
echo "============================================================"
echo " P3XE Development Kit - Health Report concluído"
echo "============================================================"
echo
read -r -p "Pressione ENTER para voltar..."
