#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Pure3XEngine Development Kit
# P3XE Launcher
# ==========================================================

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

while true
do
    clear
    cabecalho

    echo "=================================================="
    echo "      🚀 P3XE DEVELOPMENT KIT"
    echo "=================================================="
    echo

    echo "1) 🔧 Development Center"
    echo "2) 🚀 Build Center"
    echo "3) 🔍 Diagnostics Center"
    echo "4) 🧩 Smart Modules"
    echo "5) 🖥 Emulator Center"
    echo "6) 💻 QEMU Center"
    echo "7) 🤖 AI Center"
    echo "8) 🛠 Utilities Center"
    echo "9) 🌿 GitHub Center"
    echo "10) ⚙ Settings"
    echo "11) ❤️ About"
    echo
    echo "0) ❌ Sair"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in
        1)
            bash "$ROOT_DIR/tools/development/menu.sh"
            pausa
            ;;

        2)
            bash "$ROOT_DIR/tools/build/menu.sh"
            pausa
            ;;

        3)
            bash "$ROOT_DIR/tools/diagnostics/menu.sh"
            pausa
            ;;

        4)
            bash "$ROOT_DIR/tools/modules/menu.sh"
            pausa
            ;;

        5)
            bash "$ROOT_DIR/tools/emulator/menu.sh"
            pausa
            ;;

        6)
            bash "$ROOT_DIR/tools/qemu/menu.sh"
            pausa
            ;;

        7)
            bash "$ROOT_DIR/tools/ai/menu.sh"
            pausa
            ;;

        8)
            bash "$ROOT_DIR/tools/utilities/menu.sh"
            pausa
            ;;

        9)
            bash "$ROOT_DIR/tools/github/menu.sh"
            pausa
            ;;

        10)
            bash "$ROOT_DIR/tools/settings/menu.sh"
            pausa
            ;;

        11)
            bash "$ROOT_DIR/tools/about/menu.sh"
            pausa
            ;;

        0)
            clear
            echo "✅ Saindo do P3XE Development Kit... Até logo!"
            exit 0
            ;;

        *)
            erro "Opção inválida! Tente novamente."
            pausa
            ;;
    esac
done

