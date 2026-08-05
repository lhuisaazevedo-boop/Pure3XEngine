#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                 LOGS DO QEMU"
    echo "=============================================================="
    echo
    echo "1) Ver último log"
    echo "2) Limpar logs"
    echo "3) Diagnóstico do QEMU"
    echo "0) Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            clear
            echo "========== ÚLTIMO LOG =========="

            if [ -f "$ROOT_DIR/qemu/logs/qemu.log" ]; then
                cat "$ROOT_DIR/qemu/logs/qemu.log"
            else
                echo "Nenhum log encontrado."
            fi

            pausa
            ;;

        2)
            rm -f "$ROOT_DIR/qemu/logs/"*
            sucesso "Logs removidos."
            pausa
            ;;

        3)
            clear
            echo "========== DIAGNÓSTICO =========="

            if command -v qemu-system-aarch64 >/dev/null 2>&1; then
                echo "✔ QEMU instalado."
                qemu-system-aarch64 --version | head -n1
            else
                echo "✘ QEMU não instalado."
            fi

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
