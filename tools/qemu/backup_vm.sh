#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"
BACKUP_DIR="$ROOT_DIR/qemu/backups"

mkdir -p "$BACKUP_DIR"

clear
cabecalho

echo "============================================================"
echo "💾 BACKUP DA MÁQUINA VIRTUAL"
echo "============================================================"
echo

echo "Máquinas disponíveis:"
echo
ls "$VM_DIR"
echo

read -p "Digite o nome da máquina: " VM

if [ ! -d "$VM_DIR/$VM" ]; then
    erro "Máquina não encontrada."
    pausa
    exit 1
fi

ARQUIVO="$BACKUP_DIR/${VM}_$(date +%Y%m%d_%H%M%S).tar.gz"

echo
echo "Criando backup..."
echo

tar -czf "$ARQUIVO" -C "$VM_DIR" "$VM"

echo
echo "✅ Backup concluído!"
echo
echo "Arquivo:"
echo "$ARQUIVO"

pausa
