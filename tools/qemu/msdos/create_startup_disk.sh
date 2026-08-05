#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../../.." && pwd)"

FLOPPY_DIR="$ROOT_DIR/qemu/floppies"
STARTUP_IMG="$FLOPPY_DIR/startup.img"

mkdir -p "$FLOPPY_DIR"

echo "=============================================="
echo "        CRIAR DISQUETE STARTUP"
echo "=============================================="

if [ -f "$STARTUP_IMG" ]; then
    echo "[✓] startup.img já existe."
    ls -lh "$STARTUP_IMG"
    exit 0
fi

echo "[*] Criando disquete vazio de 1.44MB..."

qemu-img create -f raw "$STARTUP_IMG" 1440K

if [ $? -eq 0 ]; then
    echo
    echo "[✓] Disquete criado com sucesso!"
    ls -lh "$STARTUP_IMG"
else
    echo
    echo "[✗] Erro ao criar startup.img"
    exit 1
fi
