#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
CONFIG="$VM_DIR/video.conf"

mkdir -p "$VM_DIR"

# Valores padrão
[ -f "$CONFIG" ] && source "$CONFIG"

VGA="${VGA:-cirrus}"
VRAM="${VRAM:-4}"
ACCEL3D="${ACCEL3D:-off}"

while true; do

    clear
    cabecalho

    echo "=============================================================="
    echo "              CONFIGURAÇÕES DE VÍDEO"
    echo "=============================================================="
    echo
    echo "1) Adaptador VGA"
    echo "   Atual: $VGA"
    echo
    echo "2) Memória de Vídeo"
    echo "   Atual: ${VRAM} MB"
    echo
    echo "3) Aceleração 3D"
    echo "   Atual: $ACCEL3D"
    echo
    echo "4) Mostrar configuração"
    echo
    echo "0) Voltar"
    echo

    read -rp "Escolha: " op

    case "$op" in

        1)

            clear
            cabecalho

            echo "Adaptador de vídeo"
            echo
            echo "1) cirrus"
            echo "2) std"
            echo "3) vmware"
            echo "4) virtio-vga"
            echo

            read -rp "Escolha: " v

            case "$v" in
                1) VGA="cirrus" ;;
                2) VGA="std" ;;
                3) VGA="vmware" ;;
                4) VGA="virtio-vga" ;;
            esac
            ;;

        2)

            clear
            cabecalho

            echo "Memória de vídeo"
            echo
            echo "1) 2 MB"
            echo "2) 4 MB"
            echo "3) 8 MB"
            echo "4) 16 MB"
            echo "5) 32 MB"
            echo

            read -rp "Escolha: " m

            case "$m" in
                1) VRAM=2 ;;
                2) VRAM=4 ;;
                3) VRAM=8 ;;
                4) VRAM=16 ;;
                5) VRAM=32 ;;
            esac
            ;;

        3)

            if [ "$ACCEL3D" = "on" ]; then
                ACCEL3D="off"
            else
                ACCEL3D="on"
            fi
            ;;

        4)

            clear
            cabecalho

            echo "===================================="
            echo "CONFIGURAÇÃO DE VÍDEO"
            echo "===================================="
            echo
            echo "VGA        : $VGA"
            echo "VRAM       : ${VRAM} MB"
            echo "3D         : $ACCEL3D"
            echo

            pausa
            ;;

        0)

            break
            ;;

    esac

    cat > "$CONFIG" <<EOF
VGA="$VGA"
VRAM="$VRAM"
ACCEL3D="$ACCEL3D"
EOF

done
