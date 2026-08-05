#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
ISO_DIR="$ROOT_DIR/qemu/isos"

while true
do
    clear
    cabecalho

    echo "============================================================"
    echo "                     INICIAR MS-DOS"
    echo "============================================================"
    echo
    echo "1) ▶ MS-DOS 6.22 (Recomendado)"
    echo "2) ▶ MS-DOS 6.0"
    echo "3) ▶ MS-DOS 5.0"
    echo "4) ▶ FreeDOS"
    echo
    echo "0) ↩ Voltar"
    echo

    read -p "Escolha uma opção: " OP

    case "$OP" in

        1)
            ISO="$ISO_DIR/MS-DOS 6.22.iso"
            ;;

        2)
            ISO="$ISO_DIR/MS-DOS 6.0.iso"
            ;;

        3)
            ISO="$ISO_DIR/MS-DOS 5.0.iso"
            ;;

        4)
            ISO="$ISO_DIR/FreeDOS.iso"
            ;;

        0)
            exit 0
            ;;

        *)
            erro "Opção inválida!"
            pausa
            continue
            ;;
    esac

# Carrega a ISO salva
ISO_CONF="$VM_DIR/iso.conf"

unset ISO
unset iso

if [ -f "$ISO_CONF" ]; then
    source "$ISO_CONF"
fi

# Compatibilidade: aceita "iso=" ou "ISO="
[ -n "$iso" ] && ISO="$iso"

# Procura automaticamente se necessário
if [ -z "$ISO" ] || [ ! -f "$ISO" ]; then
    ISO=$(find "$ROOT_DIR/qemu/isos" -type f -iname "*.iso" | head -n 1)

    if [ -n "$ISO" ]; then
        echo "ISO=$ISO" > "$ISO_CONF"
    else
        erro "ISO não encontrada:"
        pausa
        continue
    fi
fi

echo "ISO=$ISO" > "$ISO_CONF"

sucesso "Iniciando..."

bash "$ROOT_DIR/tools/qemu/iniciar_qemu.sh"

exit 0

done
