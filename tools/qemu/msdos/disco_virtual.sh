#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
ls -l "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"

cabecalho

echo "=============================="
echo "       DISCO VIRTUAL"
echo "=============================="
echo

DISCOS=$(find "$VM_DIR" -maxdepth 1 \( -name "*.qcow2" -o -name "*.img" \))

if [ -n "$DISCOS" ]; then
    sucesso "Discos encontrados:"
    echo
    echo "$DISCOS"
else
    aviso "Nenhum disco virtual encontrado."
fi

echo
pausa
