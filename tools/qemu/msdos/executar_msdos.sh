#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Pure3XEngine - Executor MS-DOS
# QEMuCenter
# ==========================================================

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
INIT_FILE="$ROOT_DIR/tools/common/init.sh"
DISPLAY_MANAGER="$ROOT_DIR/tools/qemu/common/display.sh"

# ==========================================================
# INIT DO PURE3XENGINE
# ==========================================================

if [ ! -f "$INIT_FILE" ]; then
    echo "[x] Erro interno:"
    echo "    init.sh não encontrado."
    echo
    echo "Esperado:"
    echo "$INIT_FILE"
    exit 1
fi

source "$INIT_FILE"

# ==========================================================
# DIRETÓRIOS / CONFIGURAÇÃO
# ==========================================================

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
ISO_CONF="$VM_DIR/iso.conf"
DISCO_CONF="$VM_DIR/disco.conf"
LOG_FILE="$VM_DIR/msdos.log"

mkdir -p "$VM_DIR"

# ==========================================================
# CARREGA ISO E DISCO CONFIGURADOS
# ==========================================================

ISO=""
DISCO=""

[ -f "$ISO_CONF" ] && source "$ISO_CONF"
[ -f "$DISCO_CONF" ] && source "$DISCO_CONF"

# ----------------------------------------------------------
# Procura automaticamente um disco caso disco.conf falhe
# ----------------------------------------------------------

if [ -z "$DISCO" ] || [ ! -f "$DISCO" ]; then
    DISCO=$(
        find "$VM_DIR" -maxdepth 1 -type f \
            \( -iname "*.qcow2" -o -iname "*.img" -o -iname "*.raw" \) \
            -print -quit 2>/dev/null
    )
fi

# ==========================================================
# VALIDAÇÃO
# ==========================================================

if [ -z "$DISCO" ] || [ ! -f "$DISCO" ]; then
    erro "Disco virtual não encontrado em: $VM_DIR"
    exit 1
fi

if [ -z "$ISO" ] || [ ! -f "$ISO" ]; then
    erro "ISO não encontrada ou não configurada."
    exit 1
fi

if ! command -v qemu-system-i386 >/dev/null 2>&1; then
    erro "qemu-system-i386 não encontrado."
    exit 1
fi

echo
echo -e "${VERDE}✓ Preparando MS-DOS...${RESET}"
echo "Disco : $(basename "$DISCO")"
echo "ISO   : $(basename "$ISO")"

# ==========================================================
# DISPLAY - QEMuCenter DisplayManager
# ==========================================================

if [ ! -f "$DISPLAY_MANAGER" ]; then
    erro "DisplayManager não encontrado."
    echo "Esperado:"
    echo "$DISPLAY_MANAGER"
    exit 1
fi

source "$DISPLAY_MANAGER"

p3xe_display_init

DISPLAY_MODE=("${P3XE_DISPLAY_MODE[@]}")
DISPLAY_BACKEND="$P3XE_DISPLAY_BACKEND"

p3xe_display_info

# ==========================================================
# COMANDO QEMU
# ==========================================================

QEMU_CMD=(
    qemu-system-i386
    -m 64
    -cpu 486
    -hda "$DISCO"
    -cdrom "$ISO"
    -boot order=c
    "${DISPLAY_MODE[@]}"
    -vga cirrus
)

# ==========================================================
# INFORMAÇÕES
# ==========================================================

echo
echo "------------------------------------------"
echo "Configuração de execução"
echo "------------------------------------------"
echo "CPU      : 486"
echo "RAM      : 64 MiB"
echo "VGA      : cirrus"
echo "Boot     : disco"
echo "Display  : $DISPLAY_BACKEND"
echo

# ==========================================================
# EXECUÇÃO
# ==========================================================

if [ "$DISPLAY_BACKEND" = "SDL" ] || \
   [ "$DISPLAY_BACKEND" = "GTK" ]; then

    echo -e "${VERDE}✓ Iniciando QEMU...${RESET}"

    : > "$LOG_FILE"

    nohup "${QEMU_CMD[@]}" \
        >> "$LOG_FILE" 2>&1 &

    QEMU_PID=$!

    # Dá tempo para detectar erro imediato.
    sleep 1

    if kill -0 "$QEMU_PID" 2>/dev/null; then

        echo
        echo -e "${VERDE}✓ QEMU iniciado com sucesso.${RESET}"
        echo "PID : $QEMU_PID"
        echo "Log : $LOG_FILE"

    else

        echo
        erro "O QEMU encerrou durante a inicialização."
        echo
        echo "Últimas linhas do log:"
        echo "------------------------------------------"
        tail -n 15 "$LOG_FILE" 2>/dev/null
        echo "------------------------------------------"

        exit 1
    fi

else

    # curses precisa permanecer conectado ao terminal.
    echo -e "${VERDE}✓ Iniciando QEMU em modo terminal...${RESET}"
    echo

    "${QEMU_CMD[@]}"

fi
