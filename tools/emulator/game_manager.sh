#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear

echo "=============================================================="
echo "🎮 P3XE - GERENCIADOR DE JOGOS"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

echo "🎮 BIBLIOTECA P3XE"
echo "--------------------------------------------------------------"

GAME_DIRS=(
    "$ROOT_DIR/flash0/game"
    "$ROOT_DIR/games"
    "$ROOT_DIR/dev_hdd0/game"
)

TOTAL=0
OK=0
INCOMPLETE=0

# --------------------------------------------------------------
# Mostrar diretórios da biblioteca
# --------------------------------------------------------------

echo "📂 DIRETÓRIOS DE JOGOS"
echo "--------------------------------------------------------------"

for BASE in "${GAME_DIRS[@]}"; do
    if [ -d "$BASE" ]; then
        echo "✅ $BASE"
    else
        echo "❌ $BASE"
    fi
done

echo
echo "🔎 VERIFICANDO JOGOS"
echo "--------------------------------------------------------------"

# --------------------------------------------------------------
# Procurar instalações
# --------------------------------------------------------------

for BASE in "${GAME_DIRS[@]}"; do

    [ -d "$BASE" ] || continue

    for GAME in "$BASE"/*; do

        [ -d "$GAME" ] || continue

        ((TOTAL++))

        NAME="$(basename "$GAME")"

        PARAM=""
        ICON=""
        EBOOT=""

        # ------------------------------------------------------
        # Detectar estrutura PS3_GAME
        # ------------------------------------------------------

        if [ -f "$GAME/PS3_GAME/PARAM.SFO" ]; then
            PARAM="$GAME/PS3_GAME/PARAM.SFO"
        elif [ -f "$GAME/PARAM.SFO" ]; then
            PARAM="$GAME/PARAM.SFO"
        fi

        if [ -f "$GAME/PS3_GAME/ICON0.PNG" ]; then
            ICON="$GAME/PS3_GAME/ICON0.PNG"
        elif [ -f "$GAME/ICON0.PNG" ]; then
            ICON="$GAME/ICON0.PNG"
        fi

        if [ -f "$GAME/PS3_GAME/USRDIR/EBOOT.BIN" ]; then
            EBOOT="$GAME/PS3_GAME/USRDIR/EBOOT.BIN"
        elif [ -f "$GAME/USRDIR/EBOOT.BIN" ]; then
            EBOOT="$GAME/USRDIR/EBOOT.BIN"
        fi

        echo
        echo "🎮 $NAME"
        echo "   Caminho : $GAME"

        if [ -n "$PARAM" ]; then
            echo "   ✅ PARAM.SFO"
        else
            echo "   ❌ PARAM.SFO"
        fi

        if [ -n "$ICON" ]; then
            echo "   ✅ ICON0.PNG"
        else
            echo "   ⚠ ICON0.PNG"
        fi

        if [ -n "$EBOOT" ]; then
            echo "   ✅ EBOOT.BIN"
        else
            echo "   ❌ EBOOT.BIN"
        fi

        # ------------------------------------------------------
        # Status
        # PARAM.SFO + EBOOT.BIN são essenciais neste diagnóstico
        # ICON0.PNG é tratado como capa opcional
        # ------------------------------------------------------

        if [ -n "$PARAM" ] && [ -n "$EBOOT" ]; then

            echo "   Status  : ✅ Estrutura reconhecida"
            ((OK++))

        else

            echo "   Status  : ⚠ Estrutura incompleta"
            ((INCOMPLETE++))

        fi

    done

done

echo

# --------------------------------------------------------------
# Nenhum jogo
# --------------------------------------------------------------

if [ "$TOTAL" -eq 0 ]; then

    echo "⚠ Nenhum jogo instalado."
    echo
    echo "Estrutura recomendada:"
    echo
    echo "games/"
    echo "└── MeuJogo/"
    echo "    └── PS3_GAME/"
    echo "        ├── PARAM.SFO"
    echo "        ├── ICON0.PNG"
    echo "        └── USRDIR/"
    echo "            └── EBOOT.BIN"
    echo

fi

# --------------------------------------------------------------
# Resumo
# --------------------------------------------------------------

echo "=============================================================="
echo "📊 RESUMO DA BIBLIOTECA"
echo "--------------------------------------------------------------"
echo "Jogos encontrados : $TOTAL"
echo "Estrutura OK       : $OK"
echo "Incompletos        : $INCOMPLETE"
echo

if [ "$TOTAL" -eq 0 ]; then

    echo "⚠ STATUS: BIBLIOTECA VAZIA"

elif [ "$INCOMPLETE" -gt 0 ]; then

    echo "⚠ STATUS: EXISTEM JOGOS COM ARQUIVOS AUSENTES"

else

    echo "✅ STATUS: BIBLIOTECA P3XE OK"

fi

echo "=============================================================="
echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "Game Manager - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
