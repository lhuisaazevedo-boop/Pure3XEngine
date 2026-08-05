#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

clear

# ==============================================================
# Funções
# ==============================================================

count_files() {
    find "$@" -type f 2>/dev/null | wc -l
}

count_name() {
    local pattern="$1"
    shift

    find "$@" -type f \( \
        -iname "*${pattern}*.cpp" -o \
        -iname "*${pattern}*.h" -o \
        -iname "*${pattern}*.hpp" \
    \) 2>/dev/null | wc -l
}

status_dir() {
    if [ -d "$1" ]; then
        echo "✅ Detectado"
    else
        echo "❌ Ausente"
    fi
}

# ==============================================================
# Caminhos principais
# ==============================================================

CORE="$ROOT_DIR/CoreEmulator"
CUBE="$ROOT_DIR/Cubo3D"
ANDROID="$ROOT_DIR/android"
FLASH0="$ROOT_DIR/flash0"

# ==============================================================
# Contadores CPU
# ==============================================================

PPU_COUNT=$(count_name "ppu" "$CORE" "$CUBE")
SPU_COUNT=$(count_name "spu" "$CORE" "$CUBE")
CPU_COUNT=$(count_name "cpu" "$CORE" "$CUBE")
CELL_COUNT=$(count_name "cell" "$CORE" "$CUBE")
RSX_COUNT=$(count_name "rsx" "$CORE" "$CUBE")

INTERPRETER_COUNT=$(find "$CORE" "$CUBE" \
    -type f \( \
        -iname "*interpreter*.cpp" -o \
        -iname "*interpreter*.h" -o \
        -iname "*interpreter*.hpp" -o \
        -iname "*decoder*.cpp" -o \
        -iname "*decoder*.h" -o \
        -iname "*decoder*.hpp" \
    \) 2>/dev/null | wc -l)

# ==============================================================
# Gráficos
# ==============================================================

RENDER_COUNT=$(find "$CUBE" "$CORE" \
    -type f \( \
        -iname "*renderer*.cpp" -o \
        -iname "*renderer*.h" -o \
        -iname "*renderer*.hpp" \
    \) 2>/dev/null | wc -l)

SHADER_COUNT=$(find "$CUBE" "$CORE" \
    -type f \( \
        -iname "*.vert" -o \
        -iname "*.frag" -o \
        -iname "*.glsl" \
    \) 2>/dev/null | wc -l)

VULKAN_COUNT=$(grep -Ril "vulkan" "$CUBE" "$CORE" "$ANDROID" \
    2>/dev/null | wc -l)

GLES_COUNT=$(grep -RilE "OpenGL|GLES|gl[A-Z]" \
    "$CUBE" "$CORE" "$ANDROID" 2>/dev/null | wc -l)

EGL_COUNT=$(grep -Ril "EGL" \
    "$CUBE" "$CORE" "$ANDROID" 2>/dev/null | wc -l)

# ==============================================================
# Android
# ==============================================================

JAVA_COUNT=$(find "$ANDROID" \
    -type f -name "*.java" 2>/dev/null | wc -l)

KOTLIN_COUNT=$(find "$ANDROID" \
    -type f -name "*.kt" 2>/dev/null | wc -l)

NATIVE_COUNT=$(find "$ANDROID" \
    -type f \( -name "*.cpp" -o -name "*.c" \) \
    2>/dev/null | wc -l)

SO_COUNT=$(find "$ANDROID" "$ROOT_DIR" \
    -type f -name "*.so" 2>/dev/null | wc -l)

APK_COUNT=$(find "$ANDROID" "$ROOT_DIR" \
    -type f -name "*.apk" 2>/dev/null | wc -l)

# ==============================================================
# Hardware Android / Termux
# ==============================================================

THREADS=$(getconf _NPROCESSORS_ONLN 2>/dev/null)

[ -z "$THREADS" ] && THREADS=$(nproc 2>/dev/null)
[ -z "$THREADS" ] && THREADS="?"

ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null)
ANDROID_SDK=$(getprop ro.build.version.sdk 2>/dev/null)
DEVICE=$(getprop ro.product.model 2>/dev/null)
ABI=$(getprop ro.product.cpu.abi 2>/dev/null)

[ -z "$ANDROID_VERSION" ] && ANDROID_VERSION="?"
[ -z "$ANDROID_SDK" ] && ANDROID_SDK="?"
[ -z "$DEVICE" ] && DEVICE="?"
[ -z "$ABI" ] && ABI="?"

# ==============================================================
# Resolução Android
# ==============================================================

RESOLUTION=$(wm size 2>/dev/null | \
    awk -F': ' '/Override size/ {v=$2} /Physical size/ && !v {v=$2} END {print v}')

[ -z "$RESOLUTION" ] && RESOLUTION="Não disponível"

DENSITY=$(wm density 2>/dev/null | \
    awk -F': ' '/Override density/ {v=$2} /Physical density/ && !v {v=$2} END {print v}')

[ -z "$DENSITY" ] && DENSITY="Não disponível"

# ==============================================================
# Cabeçalho
# ==============================================================

echo "=============================================================="
echo "📊 P3XE - STATUS DO EMULADOR"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

# ==============================================================
# Core
# ==============================================================

echo "🧠 CORE EMULATOR"
echo "--------------------------------------------------------------"
echo "CoreEmulator : $(status_dir "$CORE")"
echo "Cubo3D       : $(status_dir "$CUBE")"
echo

# ==============================================================
# CELL
# ==============================================================

echo "⚙ CELL / CPU"
echo "--------------------------------------------------------------"
printf "%-15s : %s\n" "PPU" "$PPU_COUNT arquivo(s)"
printf "%-15s : %s\n" "SPU" "$SPU_COUNT arquivo(s)"
printf "%-15s : %s\n" "CPU" "$CPU_COUNT arquivo(s)"
printf "%-15s : %s\n" "Cell" "$CELL_COUNT arquivo(s)"
printf "%-15s : %s\n" "Interpreter" "$INTERPRETER_COUNT arquivo(s)"
printf "%-15s : %s\n" "Threads host" "$THREADS"
echo

# ==============================================================
# RSX
# ==============================================================

echo "🖥 RSX / GPU"
echo "--------------------------------------------------------------"
printf "%-15s : %s\n" "RSX" "$RSX_COUNT arquivo(s)"
printf "%-15s : %s\n" "Renderer" "$RENDER_COUNT arquivo(s)"
printf "%-15s : %s\n" "Shaders" "$SHADER_COUNT arquivo(s)"

if [ "$VULKAN_COUNT" -gt 0 ]; then
    echo "Vulkan          : ✅ Referências detectadas"
else
    echo "Vulkan          : ⚠ Não detectado"
fi

if [ "$GLES_COUNT" -gt 0 ]; then
    echo "OpenGL ES       : ✅ Referências detectadas"
else
    echo "OpenGL ES       : ⚠ Não detectado"
fi

if [ "$EGL_COUNT" -gt 0 ]; then
    echo "EGL             : ✅ Referências detectadas"
else
    echo "EGL             : ⚠ Não detectado"
fi

echo

# ==============================================================
# Cubo3D Runtime
# ==============================================================

echo "🎮 CUBO3D"
echo "--------------------------------------------------------------"

if [ -d "$CUBE" ]; then
    echo "Engine gráfica  : ✅ Detectada"
else
    echo "Engine gráfica  : ❌ Ausente"
fi

echo "Renderer        : $RENDER_COUNT arquivo(s)"
echo "Shaders         : $SHADER_COUNT arquivo(s)"
echo "FPS             : ⏳ Aguardando Runtime"
echo "Frame Time      : ⏳ Aguardando Runtime"
echo

# ==============================================================
# Android
# ==============================================================

echo "🤖 ANDROID"
echo "--------------------------------------------------------------"
echo "Módulo Android  : $(status_dir "$ANDROID")"
echo "Dispositivo     : $DEVICE"
echo "Android         : $ANDROID_VERSION"
echo "SDK             : $ANDROID_SDK"
echo "ABI             : $ABI"
echo "Resolução       : $RESOLUTION"
echo "Densidade       : $DENSITY"
echo
echo "Java            : $JAVA_COUNT arquivo(s)"
echo "Kotlin          : $KOTLIN_COUNT arquivo(s)"
echo "Native C/C++    : $NATIVE_COUNT arquivo(s)"
echo "Bibliotecas .so : $SO_COUNT"
echo "APK             : $APK_COUNT"
echo

# ==============================================================
# Firmware
# ==============================================================

echo "💿 PS3 FIRMWARE"
echo "--------------------------------------------------------------"

if [ -d "$FLASH0" ]; then
    echo "flash0          : ✅ Detectada"
else
    echo "flash0          : ❌ Não instalada"
fi

for DIR in \
    dev_flash \
    dev_flash/sys \
    dev_flash/vsh \
    dev_flash/vsh/module \
    dev_hdd0 \
    dev_hdd0/game
do
    if [ -d "$FLASH0/$DIR" ]; then
        echo "$DIR : ✅"
    else
        echo "$DIR : ❌"
    fi
done

echo

# ==============================================================
# Status geral
# ==============================================================

echo "=============================================================="
echo "📋 RESUMO P3XE"
echo "=============================================================="

[ -d "$CORE" ] \
    && echo "CoreEmulator    : ✅ Detectado" \
    || echo "CoreEmulator    : ❌ Ausente"

[ -d "$CUBE" ] \
    && echo "Cubo3D          : ✅ Detectado" \
    || echo "Cubo3D          : ❌ Ausente"

if [ "$PPU_COUNT" -gt 0 ]; then
    echo "PPU             : ✅ Detectado"
else
    echo "PPU             : ⚠ Em construção"
fi

if [ "$SPU_COUNT" -gt 0 ]; then
    echo "SPU             : ✅ Detectado"
else
    echo "SPU             : ⚠ Em construção"
fi

if [ "$RENDER_COUNT" -gt 0 ]; then
    echo "RSX / Renderer  : ✅ Detectado"
else
    echo "RSX / Renderer  : ⚠ Em construção"
fi

[ -d "$ANDROID" ] \
    && echo "Android         : ✅ Detectado" \
    || echo "Android         : ❌ Ausente"

[ -d "$FLASH0" ] \
    && echo "Firmware        : ✅ Detectado" \
    || echo "Firmware        : ⚠ Não instalado"

echo
echo "=============================================================="
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Emulator Status - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo "=============================================================="
echo

read -r -p "Pressione ENTER para voltar..."
