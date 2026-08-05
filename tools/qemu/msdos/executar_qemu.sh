#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Pure3XEngine - Executor MS-DOS
# ==========================================================

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/msdos/carregar_config.sh"

# Detecta o QEMU
if command -v qemu-system-i386 >/dev/null 2>&1; then
    QEMU_BIN="qemu-system-i386"
elif command -v qemu-system-x86_64 >/dev/null 2>&1; then
    QEMU_BIN="qemu-system-x86_64"
elif command -v qemu-system-aarch64 >/dev/null 2>&1; then
    QEMU_BIN="qemu-system-aarch64"
else
    erro "QEMU não encontrado."
    pausa
    exit 1
fi

mkdir -p "$VM_DIR"

LOG_FILE="$VM_DIR/msdos.log"

# Verificações
if [ -n "$DISK" ] && [ ! -f "$DISK" ]; then
    erro "Disco virtual não encontrado."
    pausa
    exit 1
fi

if [ -n "$ISO" ] && [ ! -f "$ISO" ]; then
    erro "ISO não encontrada."
    pausa
    exit 1
fi

CMD="$QEMU_BIN"

# Recursos
[ -n "$RAM" ]  && CMD="$CMD -m $RAM"
[ -n "$CPU" ]  && CMD="$CMD -cpu $CPU"
[ -n "$VGA" ]  && CMD="$CMD -vga $VGA"

# Disco
[ -n "$DISK" ] && CMD="$CMD -hda \"$DISK\""

# ISO
[ -n "$ISO" ]  && CMD="$CMD -cdrom \"$ISO\""

# Boot
case "$BOOT" in
    cdrom)
        CMD="$CMD -boot d"
        ;;
    disk)
        CMD="$CMD -boot c"
        ;;
esac

# Mouse
case "$MOUSE" in
    ps2)
        ;;
    usb)
        CMD="$CMD -device usb-mouse"
        ;;
esac

# Teclado
case "$KEYBOARD" in
    us)
        CMD="$CMD -k en-us"
        ;;
    abnt2)
        CMD="$CMD -k pt-br"
        ;;
esac

# Tablet
[ "$TABLET" = "on" ] && CMD="$CMD -device usb-tablet"

# VNC
if [ "$VNC" = "on" ] && [ -n "$PORT" ]; then
    DISPLAY_VNC=$((PORT - 5900))
    CMD="$CMD -vnc :$DISPLAY_VNC"
else
    CMD="$CMD -display gtk"
fi

clear
cabecalho

echo "============================================================"
echo "          COMANDO GERADO PELO PURE3XENGINE"
echo "============================================================"
echo
echo "$CMD"
echo
echo "Arquivo de log:"
echo "$LOG_FILE"
echo
echo "============================================================"

read -rp "Deseja executar agora? (S/N): " resp

if [[ "$resp" =~ ^[Ss]$ ]]; then

    echo
    aviso "Iniciando MS-DOS..."

    {
        echo "========================================"
        date
        echo "$CMD"
        echo "========================================"
    } >> "$LOG_FILE"

    eval "$CMD" 2>&1 | tee -a "$LOG_FILE"

    echo
    sucesso "Execução finalizada."

else

    aviso "Execução cancelada."

fi

pausa
