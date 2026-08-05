#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")"/../.. && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

while true
do
    cabecalho

    titulo "❤️ ABOUT CENTER"

    echo "1) 📖 Sobre o Pure3XEngine"
    echo "2) 🚀 Versão do Projeto"
    echo "3) 👨‍💻 Desenvolvedor"
    echo "4) 📜 Licença"
    echo "5) 🙏 Créditos"
    echo "6) 🛠 Tecnologias"
    echo "7) 🌿 GitHub"
    echo "8) 🗺 Roadmap"
    echo "9) 📋 Informações do Sistema"
    echo
    echo "0) ⬅ Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            echo "Pure3XEngine é um projeto de emulação de PS3 para Android."
            pausa
            ;;

        2)
            echo "Versão:"
            echo "Pure3XEngine 0.2.6 Alpha"
            pausa
            ;;

        3)
            echo "Desenvolvedor:"
            echo "Lhuis Azevedo"
            pausa
            ;;

        4)
            echo "Licença GNU GPL v3"
            pausa
            ;;

        5)
            echo "Agradecimentos à comunidade Open Source."
            pausa
            ;;

        6)
            echo "Tecnologias utilizadas:"
            echo "- C++20"
            echo "- Android NDK"
            echo "- CMake"
            echo "- Vulkan"
            echo "- OpenGL ES"
            echo "- Git"
            echo "- Termux"
            pausa
            ;;

        7)
            git remote -v
            pausa
            ;;

        8)
            echo "Roadmap:"
            echo "[✔] Development Kit"
            echo "[✔] Build Center"
            echo "[✔] Diagnostics"
            echo "[✔] GitHub Center"
            echo "[✔] QEMU Center"
            echo "[ ] Interface Android"
            echo "[ ] Núcleo do Emulador"
            pausa
            ;;

        9)
            uname -a
            echo
            termux-info
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
