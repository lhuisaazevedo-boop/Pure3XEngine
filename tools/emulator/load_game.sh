#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear

echo "=============================================================="
echo "💿 P3XE - CARREGAR JOGO"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

echo "🎮 P3XE GAME LOADER"
echo "--------------------------------------------------------------"
echo "Procurando jogos instalados..."
echo

# --------------------------------------------------------------
# Diretórios usados pelo P3XE para procurar jogos
# --------------------------------------------------------------

GAME_DIRS=(
    "$ROOT_DIR/flash0/game"
    "$ROOT_DIR/games"
    "$ROOT_DIR/dev_hdd0/game"
)

FOUND_GAMES=()

# --------------------------------------------------------------
# Procurar jogos
# --------------------------------------------------------------

for BASE in "${GAME_DIRS[@]}"; do

    [ -d "$BASE" ] || continue

    for GAME in "$BASE"/*; do

        [ -d "$GAME" ] || continue

        # Estrutura PS3
        if [ -f "$GAME/PS3_GAME/PARAM.SFO" ] || \
           [ -f "$GAME/PARAM.SFO" ] || \
           [ -f "$GAME/PS3_GAME/USRDIR/EBOOT.BIN" ] || \
           [ -f "$GAME/USRDIR/EBOOT.BIN" ]; then

            FOUND_GAMES+=("$GAME")

        fi

    done
done

# --------------------------------------------------------------
# Nenhum jogo encontrado
# --------------------------------------------------------------

if [ ${#FOUND_GAMES[@]} -eq 0 ]; then

    echo "⚠ Nenhum jogo PS3 encontrado."
    echo
    echo "Diretórios verificados:"
    echo
    echo "  📁 flash0/game"
    echo "  📁 games"
    echo "  📁 dev_hdd0/game"
    echo
    echo "Estrutura esperada:"
    echo
    echo "  MeuJogo/"
    echo "  └── PS3_GAME/"
    echo "      ├── PARAM.SFO"
    echo "      ├── ICON0.PNG"
    echo "      └── USRDIR/"
    echo "          └── EBOOT.BIN"
    echo
    echo "=============================================================="
    read -r -p "Pressione ENTER para voltar..."
    exit 0
fi

# --------------------------------------------------------------
# Mostrar jogos encontrados
# --------------------------------------------------------------

echo "📀 JOGOS ENCONTRADOS"
echo "--------------------------------------------------------------"

INDEX=1

for GAME in "${FOUND_GAMES[@]}"; do

    NAME="$(basename "$GAME")"

    if [ -f "$GAME/PS3_GAME/PARAM.SFO" ]; then
        PARAM="$GAME/PS3_GAME/PARAM.SFO"
    else
        PARAM="Não encontrado"
    fi

    echo
    echo "[$INDEX] $NAME"
    echo "    Caminho   : $GAME"
    echo "    PARAM.SFO : $PARAM"

    if [ -f "$GAME/PS3_GAME/USRDIR/EBOOT.BIN" ]; then
        echo "    EBOOT.BIN : ✅ Encontrado"
    else
        echo "    EBOOT.BIN : ❌ Não encontrado"
    fi

    INDEX=$((INDEX + 1))

done

echo
echo "=============================================================="
echo "Jogos encontrados : ${#FOUND_GAMES[@]}"
echo "=============================================================="
echo

read -r -p "Pressione ENTER para voltar..."
