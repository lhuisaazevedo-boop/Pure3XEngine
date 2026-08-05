#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear

echo "=============================================================="
echo "🖥 P3XE - GPU / RSX MANAGER"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

echo "🎮 GPU / RSX DIAGNÓSTICO"
echo "--------------------------------------------------------------"

# --------------------------------------------------------------
# Módulos gráficos principais
# --------------------------------------------------------------

MODULES=(
    "$ROOT_DIR/Cubo3D"
    "$ROOT_DIR/CoreEmulator"
    "$ROOT_DIR/android"
)

for DIR in "${MODULES[@]}"; do

    NAME="$(basename "$DIR")"

    if [ -d "$DIR" ]; then
        echo "✅ $NAME encontrado"
    else
        echo "❌ $NAME ausente"
    fi

done

echo
echo "🧠 RSX / RENDERER"
echo "--------------------------------------------------------------"

RSX_FILES=$(find \
    "$ROOT_DIR/Cubo3D" \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/android" \
    -type f \
    \( -iname "*rsx*" -o \
       -iname "*renderer*" -o \
       -iname "*graphics*" \) \
    2>/dev/null)

RSX_COUNT=$(printf "%s\n" "$RSX_FILES" | sed '/^$/d' | wc -l)

echo "Arquivos RSX/Renderer : $RSX_COUNT"

if [ "$RSX_COUNT" -gt 0 ]; then
    echo "Status                : ✅ Encontrados"
else
    echo "Status                : ⚠ Nenhum encontrado"
fi

echo
echo "🎨 API GRÁFICA"
echo "--------------------------------------------------------------"

VULKAN=$(grep -Ril \
    --include="*.cpp" \
    --include="*.h" \
    --include="*.hpp" \
    --include="CMakeLists.txt" \
    "vulkan" \
    "$ROOT_DIR/Cubo3D" \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/android" \
    2>/dev/null | wc -l)

OPENGL=$(grep -Ril \
    --include="*.cpp" \
    --include="*.h" \
    --include="*.hpp" \
    --include="*.java" \
    --include="CMakeLists.txt" \
    -E "OpenGL|GLES|gl[A-Z]" \
    "$ROOT_DIR/Cubo3D" \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/android" \
    2>/dev/null | wc -l)

EGL=$(grep -Ril \
    --include="*.cpp" \
    --include="*.h" \
    --include="*.hpp" \
    --include="CMakeLists.txt" \
    "EGL" \
    "$ROOT_DIR/Cubo3D" \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/android" \
    2>/dev/null | wc -l)

printf "Vulkan referências : %s\n" "$VULKAN"
printf "OpenGL/GLES        : %s\n" "$OPENGL"
printf "EGL                : %s\n" "$EGL"

echo
echo "✨ SHADERS"
echo "--------------------------------------------------------------"

SHADERS=$(find "$ROOT_DIR" \
    -type f \
    \( -name "*.vert" \
       -o -name "*.frag" \
       -o -name "*.glsl" \
       -o -name "*.spv" \) \
    2>/dev/null | wc -l)

echo "Shaders encontrados : $SHADERS"

echo
echo "🔧 CMAKE GRÁFICO"
echo "--------------------------------------------------------------"

CMAKE_GPU=$(grep -Ril \
    --include="CMakeLists.txt" \
    -E "GLES|EGL|OpenGL|Vulkan" \
    "$ROOT_DIR/Cubo3D" \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/android" \
    2>/dev/null | wc -l)

echo "CMake com GPU/API : $CMAKE_GPU"

echo
echo "📊 RESUMO GPU / RSX"
echo "--------------------------------------------------------------"

ISSUES=0

if [ "$RSX_COUNT" -gt 0 ]; then
    echo "RSX / Renderer : ✅ Detectado"
else
    echo "RSX / Renderer : ❌ Ausente"
    ((ISSUES++))
fi

if [ "$VULKAN" -gt 0 ]; then
    echo "Vulkan         : ✅ Detectado"
else
    echo "Vulkan         : ⚠ Não detectado"
fi

if [ "$OPENGL" -gt 0 ]; then
    echo "OpenGL ES      : ✅ Detectado"
else
    echo "OpenGL ES      : ⚠ Não detectado"
fi

if [ "$EGL" -gt 0 ]; then
    echo "EGL            : ✅ Detectado"
else
    echo "EGL            : ⚠ Não detectado"
fi

if [ "$SHADERS" -gt 0 ]; then
    echo "Shaders        : ✅ $SHADERS arquivo(s)"
else
    echo "Shaders        : ⚠ Nenhum arquivo externo"
fi

echo
echo "=============================================================="

if [ "$ISSUES" -eq 0 ]; then
    echo "✅ STATUS GPU/RSX: SUBSISTEMA GRÁFICO DETECTADO"
else
    echo "❌ STATUS GPU/RSX: COMPONENTES AUSENTES"
fi

echo "=============================================================="
echo
echo "GPU / RSX Manager - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
