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

    titulo "🖥️ EMULATOR CENTER"

    echo "1) ▶ Iniciar Emulador"
    echo "2) 🚀 Boot Flash PS3"
    echo "3) ⚙ Iniciar Runtime"
    echo "4) 💿 Carregar Jogo"
    echo "5) 📀 Firmware"
    echo "6) 🎮 Gerenciar Jogos"
    echo "7) 🖥 GPU / RSX"
    echo "8) ⚙ CPU / PPU / SPU"
    echo "9) 📊 Status do Emulador"
    echo
    echo "0) ← Voltar"

    read -r -p "Escolha uma opção: " emu

    case "$emu" in

        1)
            bash "$ROOT_DIR/tools/emulator/start_emulator.sh"
            pausa
            ;;

        2)
            bash "$ROOT_DIR/tools/emulator/boot_flash.sh"
            pausa
            ;;

        3)
            bash "$ROOT_DIR/tools/emulator/runtime_manager.sh"
            pausa
            ;;

        4)
            bash "$ROOT_DIR/tools/emulator/load_game.sh"
            pausa
            ;;

        5)
            bash "$ROOT_DIR/tools/emulator/firmware_manager.sh"
            pausa
            ;;

        6)
            bash "$ROOT_DIR/tools/emulator/game_manager.sh"
            pausa
            ;;

        7)
            bash "$ROOT_DIR/tools/emulator/rsx_manager.sh"
            pausa
            ;;

        8)
            bash "$ROOT_DIR/tools/emulator/cpu_manager.sh"
            pausa
            ;;

        9)
            bash "$ROOT_DIR/tools/emulator/status.sh"
            pausa
            ;;

        0)
            break
            ;;

        *)
            echo "Opção inválida."
            pausa
            ;;

    esac

done
