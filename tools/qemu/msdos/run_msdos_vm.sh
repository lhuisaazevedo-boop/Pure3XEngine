#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"

VM_DIR="$ROOT/qemu/vms/msdos"
FLOPPY_DIR="$ROOT/qemu/floppies"

HDD="$VM_DIR/msdos.qcow2"
MONITOR="$VM_DIR/qemu-monitor.sock"

DISK="${1:-1}"
FLOPPY="$FLOPPY_DIR/dos-622-disk${DISK}.img"

mkdir -p "$VM_DIR"
rm -f "$MONITOR"

if [ ! -f "$HDD" ]; then
    echo "[ERRO] HD não encontrado:"
    echo "$HDD"
    exit 1
fi

if [ ! -f "$FLOPPY" ]; then
    echo "[ERRO] Disquete $DISK não encontrado:"
    echo "$FLOPPY"
    exit 1
fi

echo "========================================"
echo " P3XE - MS-DOS Virtual Machine"
echo "========================================"
echo "HD      : $HDD"
echo "Floppy  : $FLOPPY"
echo "Monitor : $MONITOR"
echo

qemu-system-i386 \
    -m 64 \
    -cpu 486 \
    -drive file="$HDD",format=qcow2,if=ide \
    -drive file="$FLOPPY",format=raw,if=floppy \
    -boot a \
    -vga cirrus \
    -display sdl \
    -monitor unix:"$MONITOR",server=on,wait=off
