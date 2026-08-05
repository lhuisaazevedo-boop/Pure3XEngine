#!/data/data/com.termux/files/usr/bin/bash

montar_qemu() {

    CMD="$QEMU_BIN"

    # Memória
    [ -n "$RAM" ] && CMD="$CMD -m $RAM"

    # CPU
    [ -n "$CPU" ] && CMD="$CMD -cpu $CPU"

    # Vídeo
    [ -n "$VGA" ] && CMD="$CMD -vga $VGA"

    # Disco
    [ -n "$DISK" ] && CMD="$CMD -hda \"$DISK\""

    # ISO
    [ -n "$ISO" ] && CMD="$CMD -cdrom \"$ISO\""

    # Boot
    case "$BOOT" in
        cdrom)
            CMD="$CMD -boot d"
            ;;
        disk)
            CMD="$CMD -boot c"
            ;;
    esac

    # Aceleração
    CMD="$CMD -accel tcg"

    # Relógio
    CMD="$CMD -rtc base=localtime"

    # Rede
    CMD="$CMD -net nic,model=ne2k_pci"
    CMD="$CMD -net user"

    # Áudio
    case "$SOUND" in
        sb16)
            CMD="$CMD -machine pcspk-audiodev=speaker"
            CMD="$CMD -audiodev none,id=speaker"
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
        CMD="$CMD -display sdl"
    fi

    echo "$CMD"
}
