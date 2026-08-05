#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
CONFIG_FILE="$VM_DIR/msdos.conf"

mkdir -p "$VM_DIR"

[ ! -f "$CONFIG_FILE" ] && cat > "$CONFIG_FILE" <<EOF
RAM=64
CPU=486
VGA=cirrus
BOOT=cdrom
MOUSE=ps2
SOUND=sb16
EOF

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                 CONFIGURAR MS-DOS"
    echo "=============================================================="
    echo

    cat "$CONFIG_FILE"

    echo
    echo "--------------------------------------------------------------"
    echo "1) Alterar RAM"
    echo "2) Alterar CPU"
    echo "3) Alterar VGA"
    echo "4) Alterar Boot"
    echo "5) Alterar Mouse"
    echo "6) Alterar Som"
    echo "7) Restaurar padrão"
    echo "0) Voltar"
    echo

    read -p "Escolha uma opção: " op

    case "$op" in

        1)
            read -p "RAM (MB): " valor
            sed -i "s/^RAM=.*/RAM=$valor/" "$CONFIG_FILE"
            sucesso "RAM atualizada!"
            pausa
        ;;

        2)
            read -p "CPU (486,pentium,pentium2): " valor
            sed -i "s/^CPU=.*/CPU=$valor/" "$CONFIG_FILE"
            sucesso "CPU atualizada!"
            pausa
        ;;

        3)
            read -p "VGA (cirrus,std,vmware): " valor
            sed -i "s/^VGA=.*/VGA=$valor/" "$CONFIG_FILE"
            sucesso "VGA atualizada!"
            pausa
        ;;

        4)
            read -p "Boot (cdrom,disk): " valor
            sed -i "s/^BOOT=.*/BOOT=$valor/" "$CONFIG_FILE"
            sucesso "Boot atualizado!"
            pausa
        ;;

        5)
            read -p "Mouse (ps2,usb): " valor
            sed -i "s/^MOUSE=.*/MOUSE=$valor/" "$CONFIG_FILE"
            sucesso "Mouse atualizado!"
            pausa
        ;;

        6)
            read -p "Som (sb16,ac97,none): " valor
            sed -i "s/^SOUND=.*/SOUND=$valor/" "$CONFIG_FILE"
            sucesso "Som atualizado!"
            pausa
        ;;

        7)
            cat > "$CONFIG_FILE" <<EOF
RAM=64
CPU=486
VGA=cirrus
BOOT=cdrom
MOUSE=ps2
SOUND=sb16
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
