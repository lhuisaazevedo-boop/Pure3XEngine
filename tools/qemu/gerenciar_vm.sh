#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "🖥 GERENCIADOR DE MÁQUINAS VIRTUAIS"
    echo "=============================================================="
    echo

    echo "Máquinas disponíveis:"
    echo

    ls "$VM_DIR" 2>/dev/null || echo "Nenhuma máquina virtual encontrada."

    echo
    echo "--------------------------------------------------------------"
    echo "1) ▶ Iniciar Máquina"
    echo "2) 📄 Informações"
    echo "3) ✏ Renomear"
    echo "4) 📋 Duplicar"
    echo "5) 🗑 Excluir"
    echo "6) 💾 Backup"
    echo "7) 📥 Restaurar Backup"
    echo "8) 🔄 Atualizar Lista"
    echo
    echo "0) ⬅ Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            bash "$ROOT_DIR/tools/qemu/iniciar_qemu.sh"
            ;;

        2)
            bash "$ROOT_DIR/tools/qemu/info_vm.sh"
            ;;

        3)
            bash "$ROOT_DIR/tools/qemu/renomear_vm.sh"
            ;;

        4)
            bash "$ROOT_DIR/tools/qemu/duplicar_vm.sh"
            ;;

        5)
            bash "$ROOT_DIR/tools/qemu/excluir_vm.sh"
            ;;

        6)
            bash "$ROOT_DIR/tools/qemu/backup_vm.sh"
            ;;

        7)
            bash "$ROOT_DIR/tools/qemu/restaurar_vm.sh"
            ;;

        8)
            bash "$ROOT_DIR/tools/qemu/atualizar_vm.sh"
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
