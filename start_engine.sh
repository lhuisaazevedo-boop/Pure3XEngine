#!/data/data/com.termux/files/usr/bin/bash

echo "=============================================="
echo "      Pure3XEngine Runtime v0.2.5 Alpha"
echo "=============================================="

# ============================================================
# Display
# ============================================================

export DISPLAY=:0
export XDG_RUNTIME_DIR="$TMPDIR"

# ============================================================
# Audio
# ============================================================

export PULSE_SERVER=127.0.0.1:4713

# ============================================================
# Mesa / VirGL
# ============================================================

export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLSL_VERSION_OVERRIDE=460

# ============================================================
# Vulkan
# ============================================================

export VK_ICD_FILENAMES="$PREFIX/share/vulkan/icd.d"
export VK_LAYER_PATH="$PREFIX/share/vulkan/explicit_layer.d"

echo "[OK] Display configurado."
echo "[OK] Áudio configurado."
echo "[OK] Mesa/VirGL configurado."
echo "[OK] Vulkan configurado."
echo "[OK] Ambiente pronto."

# ============================================================
# Inicialização
# ============================================================

cd "$HOME/Pure3XEngine/build" || {
    echo "[ERRO] Pasta build não encontrada."
    exit 1
}

./Pure3XEngine
