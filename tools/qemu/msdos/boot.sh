#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
CONFIG_FILE="$VM_DIR/boot.conf"

[ ! -f "$CONFIG_FILE" ] && cat > "$CONFIG_FILE" <<EOF
BOOT=cdrom
ORDER=dc
MENU=on
EOF

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                     BOOT - MS-DOS"
    echo "=============================================================="
    echo

    echo "Configuração atual:"
    cat "$CONFIG_FILE"

    echo
    echo "--------------------------------------------------------------"
    echo "1) Boot pelo CD-ROM"
    echo "2) Boot pelo Disco"
    echo "3) Ordem CD -> Disco"
    echo "4) Ordem Disco -> CD"
    echo "5) Menu de Boot ON/OFF"
    echo "6) Restaurar padrão"
    echo "0) Voltar"
    echo

    read -p "Escolha uma opção: " op

    case "$op" in

        1)
            sed -i "s/^BOOT=.*/BOOT=cdrom/" "$CONFIG_FILE"
            sucesso "Boot pelo CD-ROM definido!"
            pausa
        ;;

        2)
            sed -i "s/^BOOT=.*/BOOT=disk/" "$CONFIG_FILE"
            sucesso "Boot pelo disco definido!"
            pausa
        ;;

        3)
            sed -i "s/^ORDER=.*/ORDER=dc/" "$CONFIG_FILE"
            sucesso "Ordem CD -> Disco definida!"
            pausa
        ;;

        4)
            sed -i "s/^ORDER=.*/ORDER=cd/" "$CONFIG_FILE"
            sucesso "Ordem Disco -> CD definida!"
            pausa
        ;;

        5)
            if grep -q "^MENU=on" "$CONFIG_FILE"; then
                sed -i "s/^MENU=.*/MENU=off/" "$CONFIG_FILE"
                sucesso "Menu de Boot desativado!"
            else
                sed -i "s/^MENU=.*/MENU=on/" "$CONFIG_FILE"
                sucesso "Menu de Boot ativado!"
            fi
            pausa
        ;;

        6)
            cat > "$CONFIG_FILE" <<EOF
BOOT=cdrom
ORDER=dc
MENU=on
EOF
            sucesso "Configuração restaurada!"
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
