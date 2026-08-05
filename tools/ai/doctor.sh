#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear

OK=0
WARN=0
ERROR=0

check_dir() {
    local nome="$1"
    local caminho="$2"

    if [ -d "$caminho" ]; then
        echo "✅ $nome encontrado"
        OK=$((OK + 1))
    else
        echo "❌ $nome ausente"
        ERROR=$((ERROR + 1))
    fi
}

check_file() {
    local nome="$1"
    local caminho="$2"

    if [ -f "$caminho" ]; then
        echo "✅ $nome"
        OK=$((OK + 1))
    else
        echo "⚠ $nome não encontrado"
        WARN=$((WARN + 1))
    fi
}

echo "=============================================================="
echo "🩺 P3XE - DOCTOR INTELIGENTE"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

echo "🧠 MÓDULOS PRINCIPAIS"
echo "--------------------------------------------------------------"

check_dir "CoreEmulator" "$ROOT_DIR/CoreEmulator"
check_dir "Cubo3D"       "$ROOT_DIR/Cubo3D"
check_dir "QEMUCenter"   "$ROOT_DIR/QEMUCenter"
check_dir "Android"      "$ROOT_DIR/android"
check_dir "Config"       "$ROOT_DIR/Config"
check_dir "Tools"        "$ROOT_DIR/tools"

echo
echo "🎮 CORE / PS3"
echo "--------------------------------------------------------------"

PPU=$(find "$ROOT_DIR/CoreEmulator" "$ROOT_DIR/Cubo3D" \
    -type f \( -iname "*ppu*.cpp" -o -iname "*ppu*.h" -o -iname "*ppu*.hpp" \) \
    2>/dev/null | wc -l)

SPU=$(find "$ROOT_DIR/CoreEmulator" "$ROOT_DIR/Cubo3D" \
    -type f \( -iname "*spu*.cpp" -o -iname "*spu*.h" -o -iname "*spu*.hpp" \) \
    2>/dev/null | wc -l)

RSX=$(find "$ROOT_DIR/CoreEmulator" "$ROOT_DIR/Cubo3D" \
    -type f \( -iname "*rsx*.cpp" -o -iname "*rsx*.h" -o -iname "*rsx*.hpp" \) \
    2>/dev/null | wc -l)

RENDERER=$(find "$ROOT_DIR/Cubo3D" "$ROOT_DIR/CoreEmulator" \
    -type f \( -iname "*renderer*.cpp" -o -iname "*renderer*.h" -o -iname "*renderer*.hpp" \) \
    2>/dev/null | wc -l)

printf "%-18s : %s arquivo(s)\n" "PPU" "$PPU"
printf "%-18s : %s arquivo(s)\n" "SPU" "$SPU"
printf "%-18s : %s arquivo(s)\n" "RSX" "$RSX"
printf "%-18s : %s arquivo(s)\n" "Renderer" "$RENDERER"

echo
echo "🖥 CUBO3D / GRÁFICOS"
echo "--------------------------------------------------------------"

SHADERS=$(find "$ROOT_DIR/Cubo3D" \
    -type f \( \
        -iname "*.vert" -o \
        -iname "*.frag" -o \
        -iname "*.glsl" \
    \) 2>/dev/null | wc -l)

echo "Shaders          : $SHADERS arquivo(s)"

if grep -Rqi "vulkan" "$ROOT_DIR/Cubo3D" 2>/dev/null; then
    echo "Vulkan           : ✅ Referências detectadas"
else
    echo "Vulkan           : ⚠ Não detectado"
fi

if grep -RqiE "OpenGL|GLES|gl[A-Z]" "$ROOT_DIR/Cubo3D" 2>/dev/null; then
    echo "OpenGL ES        : ✅ Referências detectadas"
else
    echo "OpenGL ES        : ⚠ Não detectado"
fi

echo
echo "🖥 QEMU CENTER"
echo "--------------------------------------------------------------"

if [ -d "$ROOT_DIR/QEMUCenter" ]; then

    QEMU_FILES=$(find "$ROOT_DIR/QEMUCenter" -type f 2>/dev/null | wc -l)
    QEMU_CPP=$(find "$ROOT_DIR/QEMUCenter" \
        -type f \( -iname "*.cpp" -o -iname "*.cc" -o -iname "*.c" \) \
        2>/dev/null | wc -l)

    echo "Status           : ✅ Detectado"
    echo "Arquivos         : $QEMU_FILES"
    echo "C/C++            : $QEMU_CPP"

    if command -v qemu-system-x86_64 >/dev/null 2>&1 || \
       command -v qemu-system-aarch64 >/dev/null 2>&1; then
        echo "QEMU Runtime     : ✅ Instalado"
    else
        echo "QEMU Runtime     : ⚠ Não encontrado no PATH"
    fi

else
    echo "Status           : ❌ QEMUCenter ausente"
fi

echo
echo "🤖 ANDROID"
echo "--------------------------------------------------------------"

if [ -d "$ROOT_DIR/android" ]; then

    JAVA=$(find "$ROOT_DIR/android" -type f -iname "*.java" 2>/dev/null | wc -l)
    KOTLIN=$(find "$ROOT_DIR/android" -type f -iname "*.kt" 2>/dev/null | wc -l)
    NATIVE=$(find "$ROOT_DIR/android" \
        -type f \( -iname "*.cpp" -o -iname "*.c" \) \
        2>/dev/null | wc -l)

    echo "Módulo Android   : ✅ Detectado"
    echo "Java             : $JAVA arquivo(s)"
    echo "Kotlin           : $KOTLIN arquivo(s)"
    echo "Native C/C++     : $NATIVE arquivo(s)"

else
    echo "Módulo Android   : ❌ Ausente"
fi

echo
echo "🔧 BUILD / CMAKE"
echo "--------------------------------------------------------------"

CMAKE_COUNT=$(find "$ROOT_DIR" \
    -type f -name "CMakeLists.txt" \
    2>/dev/null | wc -l)

echo "CMakeLists       : $CMAKE_COUNT"

check_file "Gradle Wrapper" "$ROOT_DIR/android/gradlew"
check_file "Android Manifest" "$ROOT_DIR/android/app/src/main/AndroidManifest.xml"

echo
echo "📦 FERRAMENTAS"
echo "--------------------------------------------------------------"

for CMD in clang clang++ cmake git make; do
    if command -v "$CMD" >/dev/null 2>&1; then
        printf "✅ %-12s : %s\n" "$CMD" "$(command -v "$CMD")"
    else
        printf "❌ %-12s : ausente\n" "$CMD"
        ERROR=$((ERROR + 1))
    fi
done

echo
echo "🌿 GIT"
echo "--------------------------------------------------------------"

if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    BRANCH=$(git -C "$ROOT_DIR" branch --show-current 2>/dev/null)
    COMMIT=$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null)
    CHANGES=$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l)

    echo "Branch           : $BRANCH"
    echo "Commit           : $COMMIT"
    echo "Alterações       : $CHANGES"

else
    echo "⚠ Repositório Git não detectado"
fi

echo
echo "=============================================================="
echo "📊 DIAGNÓSTICO P3XE"
echo "=============================================================="

echo "Verificações OK  : $OK"
echo "Avisos            : $WARN"
echo "Erros             : $ERROR"

echo

if [ "$ERROR" -gt 0 ]; then
    echo "❌ DOCTOR: PROBLEMAS ENCONTRADOS"
elif [ "$WARN" -gt 0 ]; then
    echo "⚠ DOCTOR: PROJETO FUNCIONAL COM AVISOS"
else
    echo "✅ DOCTOR: PROJETO SAUDÁVEL"
fi

echo "=============================================================="
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Doctor Inteligente - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo "=============================================================="
echo

read -r -p "Pressione ENTER para voltar..."
