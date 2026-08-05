#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

clear

echo "=============================================================="
echo "⚙ P3XE - CPU / PPU / SPU MANAGER"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

# ==============================================================
# Núcleo PS3
# ==============================================================

echo "🧠 CPU / CELL DIAGNÓSTICO"
echo "--------------------------------------------------------------"

for MOD in CoreEmulator Cubo3D; do
    if [ -d "$ROOT_DIR/$MOD" ]; then
        echo "✅ $MOD encontrado"
    else
        echo "❌ $MOD ausente"
    fi
done

# ==============================================================
# PPU
# ==============================================================

echo
echo "⚙ PPU"
echo "--------------------------------------------------------------"

PPU_FILES=$(find \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/Cubo3D" \
    -type f \( \
        -iname "*ppu*.cpp" -o \
        -iname "*ppu*.h" -o \
        -iname "*ppu*.hpp" \
    \) 2>/dev/null)

PPU_COUNT=$(printf "%s\n" "$PPU_FILES" | sed '/^$/d' | wc -l)

if [ "$PPU_COUNT" -gt 0 ]; then
    echo "✅ Subsistema PPU detectado"
    echo "Arquivos PPU : $PPU_COUNT"
else
    echo "⚠ Subsistema PPU ainda não encontrado"
    echo "Arquivos PPU : 0"
fi

# ==============================================================
# SPU
# ==============================================================

echo
echo "⚡ SPU"
echo "--------------------------------------------------------------"

SPU_FILES=$(find \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/Cubo3D" \
    -type f \( \
        -iname "*spu*.cpp" -o \
        -iname "*spu*.h" -o \
        -iname "*spu*.hpp" \
    \) 2>/dev/null)

SPU_COUNT=$(printf "%s\n" "$SPU_FILES" | sed '/^$/d' | wc -l)

if [ "$SPU_COUNT" -gt 0 ]; then
    echo "✅ Subsistema SPU detectado"
    echo "Arquivos SPU : $SPU_COUNT"
else
    echo "⚠ Subsistema SPU ainda não encontrado"
    echo "Arquivos SPU : 0"
fi

# ==============================================================
# CELL / CPU
# ==============================================================

echo
echo "🧩 CELL / CPU"
echo "--------------------------------------------------------------"

CELL_FILES=$(find \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/Cubo3D" \
    -type f \( \
        -iname "*cell*.cpp" -o \
        -iname "*cell*.h" -o \
        -iname "*cell*.hpp" -o \
        -iname "*cpu*.cpp" -o \
        -iname "*cpu*.h" -o \
        -iname "*cpu*.hpp" \
    \) 2>/dev/null)

CELL_COUNT=$(printf "%s\n" "$CELL_FILES" | sed '/^$/d' | wc -l)

if [ "$CELL_COUNT" -gt 0 ]; then
    echo "✅ CPU / Cell detectado"
    echo "Arquivos CPU : $CELL_COUNT"
else
    echo "⚠ CPU / Cell ainda não encontrado"
    echo "Arquivos CPU : 0"
fi

# ==============================================================
# Interpreter / Decoder
# ==============================================================

echo
echo "🔧 INTERPRETER / EXECUÇÃO"
echo "--------------------------------------------------------------"

INTERPRETER_FILES=$(find \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/Cubo3D" \
    -type f \( \
        -iname "*interpreter*.cpp" -o \
        -iname "*interpreter*.h" -o \
        -iname "*interpreter*.hpp" -o \
        -iname "*decoder*.cpp" -o \
        -iname "*decoder*.h" -o \
        -iname "*decoder*.hpp" \
    \) 2>/dev/null)

INTERPRETER_COUNT=$(printf "%s\n" "$INTERPRETER_FILES" | sed '/^$/d' | wc -l)

if [ "$INTERPRETER_COUNT" -gt 0 ]; then
    echo "✅ Interpreter / Decoder detectado"
    echo "Arquivos       : $INTERPRETER_COUNT"
else
    echo "⚠ Interpreter / Decoder ainda não detectado"
    echo "Arquivos       : 0"
fi

# ==============================================================
# CPU física do dispositivo
# ==============================================================

echo
echo "🧮 THREADS DO DISPOSITIVO"
echo "--------------------------------------------------------------"

THREADS=$(getconf _NPROCESSORS_ONLN 2>/dev/null)

if [ -z "$THREADS" ]; then
    THREADS=$(nproc 2>/dev/null)
fi

if [ -n "$THREADS" ]; then
    echo "CPU Threads disponíveis : $THREADS"
else
    echo "CPU Threads disponíveis : desconhecido"
fi

# ==============================================================
# Resumo
# ==============================================================

echo
echo "📊 RESUMO CPU / CELL"
echo "--------------------------------------------------------------"

printf "%-20s : %s\n" "PPU" "$PPU_COUNT arquivo(s)"
printf "%-20s : %s\n" "SPU" "$SPU_COUNT arquivo(s)"
printf "%-20s : %s\n" "CPU / Cell" "$CELL_COUNT arquivo(s)"
printf "%-20s : %s\n" "Interpreter" "$INTERPRETER_COUNT arquivo(s)"

echo
echo "=============================================================="

if [ "$PPU_COUNT" -gt 0 ] && \
   [ "$SPU_COUNT" -gt 0 ] && \
   [ "$CELL_COUNT" -gt 0 ]; then

    echo "✅ STATUS CPU: NÚCLEO CELL / PPU / SPU DETECTADO"

elif [ "$PPU_COUNT" -gt 0 ] || \
     [ "$SPU_COUNT" -gt 0 ] || \
     [ "$CELL_COUNT" -gt 0 ]; then

    echo "⚠ STATUS CPU: SUBSISTEMA PARCIAL"

else

    echo "⚠ STATUS CPU: PPU / SPU AINDA EM CONSTRUÇÃO"

fi

echo "=============================================================="
echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "CPU / PPU / SPU Manager - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
