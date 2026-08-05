#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"
BACKUP_DIR="$ROOT_DIR/qemu/backups"

clear
cabecalho

echo "============================================================"
echo "♻️ RESTAURAR BACKUP"
echo "============================================================"
echo

if [ ! -d "$BACKUP_DIR" ]; then
    erro "Nenhum diretório de backup encontrado."
    pausa
    exit 1
fi

echo "Backups disponíveis:"
echo
ls "$BACKUP_DIR"/*.tar.gz 2>/dev/null | xargs -n1 basename

echo

read -p "Nome do arquivo de backup: " BACKUP

if [ ! -f "$BACKUP_DIR/$BACKUP" ]; then
    erro "Backup não encontrado."
    pausa
    exit 1
fi

echo
echo "Restaurando backup..."
echo

tar -xzf "$BACKUP_DIR/$BACKUP" -C "$VM_DIR"

echo
echo "✅ Backup restaurado com sucesso!"

pausa
