#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                      INICIAR QEMU"
    echo "=============================================================="
    echo
    echo "1) 🪟 Windows"
    echo "2) 🐧 Linux"
    echo "3) 💽 MS-DOS"
    echo "4) 📋 Listar Máquinas Virtuais"
    echo "5) ⚙ Inicialização Personalizada"
    echo "6) 🔍 Diagnóstico do QEMU"
    echo "0) ↩ Voltar"
    echo

    read -rp "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            clear
            cabecalho

            echo "=============================================================="
            echo "                  MÁQUINAS WINDOWS"
            echo "=============================================================="
            echo

            find "$VM_DIR" -maxdepth 1 -type d -iname "*windows*"

            echo
            pausa
        ;;

        2)
            clear
            cabecalho

            echo "=============================================================="
            echo "                   MÁQUINAS LINUX"
            echo "=============================================================="
            echo

            find "$VM_DIR" -maxdepth 1 -type d -iname "*linux*"

            echo
            pausa
        ;;

        3)
            bash "$ROOT_DIR/tools/qemu/msdos/menu.sh"
        ;;

        4)
            clear
            cabecalho

            echo "=============================================================="
            echo "              MÁQUINAS VIRTUAIS"
            echo "=============================================================="
            echo

            find "$VM_DIR" -maxdepth 1 -mindepth 1 -type d

            echo
            pausa
        ;;
       5)
            bash "$ROOT_DIR/tools/qemu/inicializacao_personalizada.sh"
        ;;

  6)
    clear
    cabecalho

    echo "============================================================"
    echo "                  DIAGNÓSTICO DO QEMU"
    echo "============================================================"
    echo

    if command -v qemu-system-i386 >/dev/null 2>&1; then
        echo "✔ QEMU i386 encontrado"
    elif command -v qemu-system-x86_64 >/dev/null 2>&1; then
        echo "✔ QEMU x86_64 encontrado"
    elif command -v qemu-system-aarch64 >/dev/null 2>&1; then
        echo "✔ QEMU ARM64 encontrado"
    else
        echo "✘ QEMU não encontrado"
    fi

    if [ -d "$VM_DIR" ]; then
        echo "✔ Pasta de máquinas virtuais encontrada"
    else
        echo "✘ Pasta de máquinas virtuais não encontrada"
    fi

    if [ -d "$VM_DIR/msdos" ]; then
        echo "✔ VM MS-DOS encontrada"
    else
        echo "• VM MS-DOS não cadastrada"
    fi

    DISCO=$(find "$VM_DIR/msdos" -type f \( -name "*.qcow2" -o -name "*.img" -o -name "*.vhd" -o -name "*.vmdk" -o -name "*.raw" \) | head -n1)

    if [ -n "$DISCO" ]; then
        echo "✔ Disco virtual encontrado"
        echo "   $(basename "$DISCO")"
    else
        echo "• Disco virtual não encontrado"
    fi

    if [ -f "$VM_DIR/msdos/iso.conf" ]; then
        echo "✔ ISO configurada"
    else
        echo "• ISO não configurada"
    fi

    echo
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
