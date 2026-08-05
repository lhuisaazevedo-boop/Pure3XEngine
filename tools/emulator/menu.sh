#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE - Emulator Center
# Pure3XEngine 0.2.6 Alpha
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

while true
do
    cabecalho

    titulo "🖥 EMULATOR CENTER"

    echo "1) ▶ Iniciar Emulador"
    echo "2) 💿 Carregar Jogo"
    echo "3) 📀 Firmware"
    echo "4) 🎮 Gerenciar Jogos"
    echo "5) 🖥 GPU / RSX"
    echo "6) ⚙ CPU / PPU / SPU"
    echo "7) 📊 Status do Emulador"
    echo
    echo "0) ⬅ Voltar"
    echo

    read -r -p "Escolha uma opção: " emu

    case "$emu" in

        1)
            bash "$ROOT_DIR/tools/emulator/start_emulator.sh"
            pausa
            ;;

        2)
            bash "$ROOT_DIR/tools/emulator/load_game.sh"
            pausa
            ;;

        3)
            bash "$ROOT_DIR/tools/emulator/firmware_manager.sh"
            pausa
            ;;

        4)
            bash "$ROOT_DIR/tools/emulator/game_manager.sh"
            pausa
            ;;

        5)
            bash "$ROOT_DIR/tools/emulator/rsx_manager.sh"
            pausa
            ;;

        6)
            bash "$ROOT_DIR/tools/emulator/cpu_manager.sh"
            pausa
            ;;

        7)
            bash "$ROOT_DIR/tools/emulator/emulator_status.sh"
            pausa
            ;;

        0)
            break
            ;;

        *)
            erro "Opção inválida!"
            pausa
            ;;
    esac

done
