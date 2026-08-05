#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

FLOPPY_DIR="$ROOT_DIR/qemu/floppies"
VM_DIR="$ROOT_DIR/qemu/vms/msdos"

HDD="$VM_DIR/msdos.qcow2"
DISK1="$FLOPPY_DIR/dos-622-disk1.img"
DISK2="$FLOPPY_DIR/dos-622-disk2.img"
DISK3="$FLOPPY_DIR/dos-622-disk3.img"

MONITOR="$VM_DIR/qemu-monitor.sock"

rm -f "$MONITOR"

echo "========================================"
echo " P3XE - INSTALAÇÃO MS-DOS 6.22"
echo "========================================"
echo
echo "HD:     $HDD"
echo "Disk 1: $DISK1"
echo "Disk 2: $DISK2"
echo "Disk 3: $DISK3"
echo
echo "Iniciando com Setup Disk #1..."
echo

qemu-system-i386 \
    -m 64 \
    -cpu 486 \
    -drive file="$HDD",format=qcow2,if=ide \
    -drive file="$DISK1",format=raw,if=floppy \
    -boot a \
    -vga cirrus \
    -display sdl \
    -monitor unix:"$MONITOR",server=on,wait=off
