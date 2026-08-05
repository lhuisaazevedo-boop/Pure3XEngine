#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

FLOPPY_DIR="$ROOT_DIR/qemu/floppies"
VM_DIR="$ROOT_DIR/qemu/vms/msdos"

mkdir -p "$FLOPPY_DIR"
mkdir -p "$VM_DIR"

DISK1=$(find "$FLOPPY_DIR" -iname "*disk1*.img" | head -n1)
DISK2=$(find "$FLOPPY_DIR" -iname "*disk2*.img" | head -n1)
DISK3=$(find "$FLOPPY_DIR" -iname "*disk3*.img" | head -n1)

HDD="$VM_DIR/msdos.qcow2"

for CMD in qemu-system-i386 qemu-img socat
do
    if ! command -v "$CMD" >/dev/null 2>&1; then
        erro "$CMD não encontrado."
        exit 1
    fi
done

for DISK in "$DISK1" "$DISK2" "$DISK3"
do
    if [ ! -f "$DISK" ]; then
        erro "Disquete não encontrado."
        echo "$DISK"
        exit 1
    fi
done

pkill -9 qemu-system-i386 2>/dev/null

find "$VM_DIR" -name "*.lck" -delete
find "$VM_DIR" -name "*.lock" -delete

if [ ! -f "$HDD" ]; then
    echo "Criando disco virtual..."
    qemu-img create -f qcow2 "$HDD" 64M
fi

MONITOR_SOCKET="$PREFIX/tmp/qemu-dos622-monitor"

rm -f "$MONITOR_SOCKET"

if [ -n "$DISPLAY" ]; then

    if qemu-system-i386 -display help | grep -qx "sdl"; then
        DISPLAY_MODE="-display sdl"
        BACKEND="SDL"

    elif qemu-system-i386 -display help | grep -qx "gtk"; then
        DISPLAY_MODE="-display gtk"
        BACKEND="GTK"

    else
        DISPLAY_MODE="-display curses"
        BACKEND="CURSES"
    fi

else

    DISPLAY_MODE="-display curses"
    BACKEND="CURSES"

fi

clear

echo "======================================================="
echo "           P3XE MS-DOS 6.22 INSTALLER"
echo "======================================================="
echo
echo "Disk 1 : $(basename "$DISK1")"
echo "Disk 2 : $(basename "$DISK2")"
echo "Disk 3 : $(basename "$DISK3")"
echo "HD      : $(basename "$HDD")"
echo "Backend : $BACKEND"
echo

qemu-system-i386 \
    -m 64 \
    -cpu 486 \
    -drive file="$HDD",format=qcow2,if=ide \
    -fda "$DISK1" \
    -boot a \
    -vga cirrus \
    $DISPLAY_MODE \
    -monitor unix:$MONITOR_SOCKET,server,nowait &

QEMU_PID=$!

sleep 3

if ! kill -0 "$QEMU_PID" 2>/dev/null; then

    erro "QEMU não iniciou."

    exit 1

fi

trocar_disquete() {

    local IMG="$1"

    echo
    echo "Inserindo $(basename "$IMG")..."

    printf "change floppy0 %s\n" "$IMG" \
        | socat - UNIX-CONNECT:$MONITOR_SOCKET

    sleep 2
}

echo
echo "======================================================="
echo " A instalação começou."
echo
echo " Quando o MS-DOS pedir:"
echo
echo "     Insert Disk 2"
echo
echo " pressione ENTER."
echo "======================================================="
read

trocar_disquete "$DISK2"

echo
echo "======================================================="
echo " Agora aguarde."
echo
echo " Quando pedir:"
echo
echo "     Insert Disk 3"
echo
echo " pressione ENTER."
echo "======================================================="
read

trocar_disquete "$DISK3"

echo
echo "======================================================="
echo " Instalação praticamente concluída."
echo
echo " Finalize normalmente dentro do MS-DOS."
echo
echo " Depois feche a janela do QEMU."
echo "======================================================="

wait "$QEMU_PID"

rm -f "$MONITOR_SOCKET"

echo
echo "======================================================="
echo " MS-DOS 6.22 instalado."
echo " Agora inicialize a VM pelo disco rígido."
echo "======================================================="
