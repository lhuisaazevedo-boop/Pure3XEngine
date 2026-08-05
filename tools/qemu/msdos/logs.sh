#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"

clear
cabecalho

echo "============================================================"
echo "📄 LOGS DA MÁQUINA VIRTUAL"
echo "============================================================"
echo

echo "Máquinas disponíveis:"
echo
ls "$VM_DIR"
echo

read -p "Digite o nome da máquina: " VM

LOG="$VM_DIR/$VM/msdos.log"

if [ ! -f "$LOG" ]; then
    erro "Nenhum log encontrado."
    pausa
    exit 1
fi

clear
cabecalho

echo "============================================================"
echo "📄 LOG DA VM: $VM"
echo "============================================================"
echo

cat "$LOG"

echo
pausa
