#!/data/data/com.termux/files/usr/bin/bash
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
CONFIG_FILE="$VM_DIR/perifericos.conf"

# Cria arquivo padrão se não existir
[ ! -f "$CONFIG_FILE" ] && cat > "$CONFIG_FILE" <<EOF
MOUSE=ps2
KEYBOARD=us
TABLET=off
EOF

while true
do
    clear
    cabecalho
    echo "=================================================="
    echo "        🖱️ MOUSE E TECLADO — MS-DOS"
    echo "=================================================="
    echo
    echo "Configuração atual:"
    cat "$CONFIG_FILE"
    echo
    echo "--------------------------------------------------"
    echo "1) Mouse PS/2"
    echo "2) Mouse USB"
    echo "3) Layout US"
    echo "4) Layout ABNT2"
    echo "5) Alternar Tablet (LIGA/DESLIGA)"
    echo "6) Restaurar Padrão"
    echo "0) Voltar"
    echo

    read -p "Escolha uma opção: " op

    case "$op" in
        1)
            sed -i "s/^MOUSE=.*/MOUSE=ps2/" "$CONFIG_FILE"
            sucesso "Mouse PS/2 selecionado!"
            pausa
        ;;

        2)
            sed -i "s/^MOUSE=.*/MOUSE=usb/" "$CONFIG_FILE"
            sucesso "Mouse USB selecionado!"
            pausa
        ;;

        3)
            sed -i "s/^KEYBOARD=.*/KEYBOARD=us/" "$CONFIG_FILE"
            sucesso "Layout US selecionado!"
            pausa
        ;;

        4)
            sed -i "s/^KEYBOARD=.*/KEYBOARD=abnt2/" "$CONFIG_FILE"
            sucesso "Layout ABNT2 selecionado!"
            pausa
        ;;

        5)
            if grep -q "^TABLET=on" "$CONFIG_FILE"; then
                sed -i "s/^TABLET=.*/TABLET=off/" "$CONFIG_FILE"
                sucesso "Tablet desativado!"
            else
                sed -i "s/^TABLET=.*/TABLET=on/" "$CONFIG_FILE"
                sucesso "Tablet ativado!"
            fi
            pausa
        ;;

        6)
            cat > "$CONFIG_FILE" <<EOF
MOUSE=ps2
KEYBOARD=us
TABLET=off
EOF
            sucesso "Configurações restauradas!"
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
