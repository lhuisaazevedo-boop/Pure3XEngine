#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"
ISO_DIR="$ROOT_DIR/qemu/isos"
LOG_DIR="$ROOT_DIR/qemu/logs"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                    REMOVER QEMU"
    echo "=============================================================="
    echo
    echo "1) 🪟 Remover máquinas Windows"
    echo "2) 🐧 Remover máquinas Linux"
    echo "3) 💾 Remover discos virtuais"
    echo "4) 💿 Remover ISOs"
    echo "5) 📝 Limpar logs"
    echo "6) 🧹 Limpeza completa"
    echo "0) ↩ Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            find "$VM_DIR" -type d -iname "*windows*" -exec rm -rf {} +
            sucesso "Máquinas Windows removidas!"
            pausa
        ;;

        2)
            find "$VM_DIR" -type d -iname "*linux*" -exec rm -rf {} +
            sucesso "Máquinas Linux removidas!"
            pausa
        ;;

        3)
            find "$VM_DIR" \( -iname "*.qcow2" -o -iname "*.img" -o -iname "*.vhd" -o -iname "*.vdi" \) -delete
            sucesso "Discos virtuais removidos!"
            pausa
        ;;

        4)
            rm -f "$ISO_DIR"/*.iso
            sucesso "ISOs removidas!"
            pausa
        ;;

        5)
            rm -f "$LOG_DIR"/*
            sucesso "Logs removidos!"
            pausa
        ;;

        6)
            rm -rf "$VM_DIR"/*
            rm -f "$ISO_DIR"/*.iso
            rm -f "$LOG_DIR"/*
            sucesso "Limpeza completa realizada!"
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
