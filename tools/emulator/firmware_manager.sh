#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear

echo "=============================================================="
echo "📀 P3XE - FIRMWARE MANAGER"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

echo "🧠 PS3 FIRMWARE / FLASH0"
echo "--------------------------------------------------------------"

# --------------------------------------------------------------
# Estrutura virtual do firmware P3XE
# --------------------------------------------------------------

FLASH0="$ROOT_DIR/flash0"

DIRS=(
    "dev_flash"
    "dev_flash/sys"
    "dev_flash/vsh"
    "dev_flash/vsh/module"
    "dev_flash/vsh/resource"
    "dev_hdd0"
    "dev_hdd0/game"
    "dev_hdd0/home"
)

FOUND=0
MISSING=0

# --------------------------------------------------------------
# Verificar flash0
# --------------------------------------------------------------

if [ -d "$FLASH0" ]; then

    echo "✅ flash0 encontrada"
    echo "   Caminho : $FLASH0"

else

    echo "⚠ flash0 não encontrada"
    echo "   Caminho esperado:"
    echo "   $FLASH0"
    echo
    echo "   Status : Firmware ainda não instalado"

fi

echo
echo "📂 ESTRUTURA DO FIRMWARE"
echo "--------------------------------------------------------------"

for ITEM in "${DIRS[@]}"; do

    TARGET="$FLASH0/$ITEM"

    if [ -d "$TARGET" ]; then

        echo "✅ $ITEM"
        ((FOUND++))

    else

        echo "❌ $ITEM"
        ((MISSING++))

    fi

done

echo
echo "📊 DIAGNÓSTICO"
echo "--------------------------------------------------------------"
echo "Diretórios OK       : $FOUND"
echo "Diretórios ausentes : $MISSING"
echo

# --------------------------------------------------------------
# Informações de armazenamento
# --------------------------------------------------------------

if [ -d "$FLASH0" ]; then

    FILES=$(find "$FLASH0" -type f 2>/dev/null | wc -l)
    SIZE=$(du -sh "$FLASH0" 2>/dev/null | awk '{print $1}')

    [ -z "$SIZE" ] && SIZE="0"

    echo "📦 FLASH0"
    echo "--------------------------------------------------------------"
    echo "Arquivos : $FILES"
    echo "Tamanho  : $SIZE"
    echo

fi

# --------------------------------------------------------------
# Estado geral
# --------------------------------------------------------------

echo "=============================================================="

if [ "$MISSING" -eq 0 ] && [ -d "$FLASH0" ]; then

    echo "✅ FIRMWARE: ESTRUTURA OK"
    echo "P3XE pode utilizar a estrutura virtual do firmware."

elif [ -d "$FLASH0" ]; then

    echo "⚠ FIRMWARE: INCOMPLETO"
    echo "$MISSING diretório(s) esperado(s) estão ausentes."

else

    echo "❌ FIRMWARE: NÃO INSTALADO"
    echo "flash0 ainda não existe."

fi

echo "=============================================================="
echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "Firmware Manager - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
