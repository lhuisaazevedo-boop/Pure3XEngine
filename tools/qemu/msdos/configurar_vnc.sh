#!/data/data/com.termux/files/usr/bin/bash
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
CONFIG_VNC="$VM_DIR/vnc.conf"

# Cria arquivo padrão se não existir
[ ! -f "$CONFIG_VNC" ] && cat > "$CONFIG_VNC" <<EOF
VNC=off
PORT=5900
PASSWORD=
EOF

while true
do
    clear
    cabecalho
    echo "=================================================="
    echo "        🖥️ CONFIGURAÇÃO VNC — MS-DOS"
    echo "=================================================="
    echo
    echo "Configuração atual:"
    cat "$CONFIG_VNC"
    echo
    echo "--------------------------------------------------"
    echo "1) Ativar VNC"
    echo "2) Desativar VNC"
    echo "3) Alterar Porta"
    echo "4) Definir Senha"
    echo "5) Restaurar Padrão"
    echo "0) Voltar"
    echo

    read -p "Escolha uma opção: " op

    case "$op" in
        1)
            sed -i "s/^VNC=.*/VNC=on/" "$CONFIG_VNC"
            sucesso "VNC ativado!"
            pausa
        ;;

        2)
            sed -i "s/^VNC=.*/VNC=off/" "$CONFIG_VNC"
            sucesso "VNC desativado!"
            pausa
        ;;

        3)
            read -p "Nova porta: " porta
            sed -i "s/^PORT=.*/PORT=$porta/" "$CONFIG_VNC"
            sucesso "Porta atualizada!"
            pausa
        ;;

        4)
            read -p "Senha do VNC: " senha
            sed -i "s/^PASSWORD=.*/PASSWORD=$senha/" "$CONFIG_VNC"
            sucesso "Senha atualizada!"
            pausa
        ;;

        5)
            cat > "$CONFIG_VNC" <<EOF
VNC=off
PORT=5900
PASSWORD=
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

