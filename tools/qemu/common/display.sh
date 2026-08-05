#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine / QEMuCenter
# Display Manager comum para QEMU
# ============================================================

P3XE_DISPLAY_BACKEND=""
P3XE_DISPLAY_MODE=()

p3xe_display_init() {

    # --------------------------------------------------------
    # Termux:X11
    # --------------------------------------------------------

    if [ -z "${DISPLAY:-}" ]; then
        export DISPLAY=:0
    fi

    echo "[DisplayManager] DISPLAY=$DISPLAY"

    # --------------------------------------------------------
    # SDL
    # --------------------------------------------------------

    if qemu-system-i386 -display help 2>&1 | grep -q '^sdl$'; then

        export SDL_RENDER_DRIVER=software

        P3XE_DISPLAY_BACKEND="SDL"
        P3XE_DISPLAY_MODE=(-display sdl)

        echo "[DisplayManager] Backend: SDL"
        return 0
    fi

    # --------------------------------------------------------
    # GTK
    # --------------------------------------------------------

    if qemu-system-i386 -display help 2>&1 | grep -q '^gtk$'; then

        P3XE_DISPLAY_BACKEND="GTK"
        P3XE_DISPLAY_MODE=(-display gtk)

        echo "[DisplayManager] Backend: GTK"
        return 0
    fi

    # --------------------------------------------------------
    # Fallback terminal
    # --------------------------------------------------------

    P3XE_DISPLAY_BACKEND="curses"
    P3XE_DISPLAY_MODE=(-display curses)

    echo "[DisplayManager] Backend: curses"
    return 0
}

p3xe_display_info() {

    echo
    echo "=============================================="
    echo " Pure3XEngine QEMuCenter - Display"
    echo "=============================================="
    echo " DISPLAY : ${DISPLAY:-não definido}"
    echo " Backend : ${P3XE_DISPLAY_BACKEND:-não iniciado}"
    echo "=============================================="
}
