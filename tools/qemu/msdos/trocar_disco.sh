#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"

VM_DIR="$ROOT/qemu/vms/msdos"
FLOPPY_DIR="$ROOT/qemu/floppies"
MONITOR="$VM_DIR/qemu-monitor.sock"

DISK="$1"

echo "========================================"
echo "       P3XE - TROCAR DISQUETE"
echo "========================================"

# Aceita somente os discos 1, 2 ou 3
case "$DISK" in
    1|2|3)
        ;;
    *)
        echo "[ERRO] Escolha o disco 1, 2 ou 3."
        echo
        echo "Uso:"
        echo "  $0 1"
        echo "  $0 2"
        echo "  $0 3"
        exit 1
        ;;
esac

IMAGE="$FLOPPY_DIR/dos-622-disk${DISK}.img"

if [ ! -f "$IMAGE" ]; then
    echo "[ERRO] Disquete não encontrado:"
    echo "$IMAGE"
    exit 1
fi

if [ ! -S "$MONITOR" ]; then
    echo "[ERRO] Monitor QEMU não encontrado:"
    echo "$MONITOR"
    echo
    echo "A máquina virtual precisa estar aberta."
    exit 1
fi

echo "[*] Trocando para MS-DOS Setup Disk #$DISK..."
echo "[*] $IMAGE"

{
    echo "eject floppy0"
    sleep 1
    echo "change floppy0 $IMAGE raw"
    sleep 1
    echo "info block"
} | socat - UNIX-CONNECT:"$MONITOR"

echo
echo "[OK] Comando de troca enviado."
echo "Volte ao MS-DOS e pressione ENTER."
