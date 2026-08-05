#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "⚙ CONFIGURAÇÕES DO QEMU"
    echo "=============================================================="
    echo
    echo "1) 🖥 Configurações de Vídeo"
    echo "2) 🔊 Configurações de Áudio"
    echo "3) 💾 Memória RAM"
    echo "4) ⚙ CPU"
    echo "5) 💿 Boot"
    echo "6) 🌐 Rede"
    echo "7) 🖱 Mouse e Teclado"
    echo "8) 📺 Tela"
    echo "9) 💽 Armazenamento"
    echo "10) 🔧 Configurações Avançadas"
    echo
    echo "0) ⬅ Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

    1)
        bash "$ROOT_DIR/tools/qemu/config/video.sh"
        ;;

    2)
        bash "$ROOT_DIR/tools/qemu/config/audio.sh"
        ;;

    3)
        bash "$ROOT_DIR/tools/qemu/config/memoria.sh"
        ;;

    4)
        bash "$ROOT_DIR/tools/qemu/config/cpu.sh"
        ;;

    5)
        bash "$ROOT_DIR/tools/qemu/config/boot.sh"
        ;;

    6)
        bash "$ROOT_DIR/tools/qemu/config/rede.sh"
        ;;

    7)
        bash "$ROOT_DIR/tools/qemu/config/perifericos.sh"
        ;;

    8)
        bash "$ROOT_DIR/tools/qemu/config/tela.sh"
        ;;

    9)
        bash "$ROOT_DIR/tools/qemu/config/armazenamento.sh"
        ;;

    10)
        bash "$ROOT_DIR/tools/qemu/config/avancado.sh"
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
