#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
LOG_FILE="$VM_DIR/msdos.log"

mkdir -p "$VM_DIR"
touch "$LOG_FILE"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                  LOGS DA VM - MS-DOS"
    echo "=============================================================="
    echo

    echo "📄 Arquivo:"
    echo "   $LOG_FILE"
    echo

    echo "1) Ver Log"
    echo "2) Limpar Log"
    echo "3) Informações do Log"
    echo "0) Voltar"
    echo

    read -rp "Escolha uma opção: " op

    case "$op" in

        1)
            clear
            cabecalho

            echo "================= LOG ATUAL ================="
            echo

            if [ -s "$LOG_FILE" ]; then
                cat "$LOG_FILE"
            else
                echo "O log está vazio."
            fi

            echo
            pausa
        ;;

        2)
            > "$LOG_FILE"
            sucesso "Log apagado com sucesso!"
            pausa
        ;;

        3)
            clear
            cabecalho

            echo "============= INFORMAÇÕES DO LOG ============="
            echo

            ls -lh "$LOG_FILE"

            echo
            echo "Últimas 10 linhas:"
            echo

            tail -10 "$LOG_FILE"

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
