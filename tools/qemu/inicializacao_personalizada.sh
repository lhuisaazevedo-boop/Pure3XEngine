#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"

while true
do
    clear
    cabecalho

    echo "============================================================"
    echo "             INICIALIZAÇÃO PERSONALIZADA"
    echo "============================================================"
    echo
    echo "1) ▶ Iniciar usando configuração padrão"
    echo "2) 💾 Escolher disco temporário"
    echo "3) 💿 Escolher ISO temporária"
    echo "4) 🧠 Alterar memória temporária"
    echo "5) ⚙ Alterar CPU temporária"
    echo "6) 📋 Mostrar configuração atual"
    echo
    echo "0) ↩ Voltar"
    echo
    read -p "Escolha uma opção: " OP

    case "$OP" in

       1)
            bash "$ROOT_DIR/tools/qemu/iniciar_msdos.sh"
            ;;
        2)
            bash "$ROOT_DIR/tools/qemu/msdos/selecionar_disco.sh"
            ;;

        3)
            bash "$ROOT_DIR/tools/qemu/msdos/selecionar_iso.sh"
            ;;

        4)
            bash "$ROOT_DIR/tools/qemu/config/memoria.sh"
            ;;

        5)
            bash "$ROOT_DIR/tools/qemu/config/cpu.sh"
            ;;

        6)
            clear
            cabecalho

            echo "============================================================"
            echo "             CONFIGURAÇÃO ATUAL"
            echo "============================================================"
            echo

            [ -f "$VM_DIR/config.conf" ] && cat "$VM_DIR/config.conf"
            [ -f "$VM_DIR/boot.conf" ] && cat "$VM_DIR/boot.conf"
            [ -f "$VM_DIR/disco.conf" ] && cat "$VM_DIR/disco.conf"
            [ -f "$VM_DIR/iso.conf" ] && cat "$VM_DIR/iso.conf"
            [ -f "$VM_DIR/memoria.conf" ] && cat "$VM_DIR/memoria.conf"
            [ -f "$VM_DIR/cpu.conf" ] && cat "$VM_DIR/cpu.conf"

            echo
            pausa
            ;;

        0)
            exit 0
            ;;

        *)
            erro "Opção inválida!"
            pausa
            ;;

    esac

done
