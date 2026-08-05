#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"

clear
cabecalho

echo "============================================================"
echo "🗑️ EXCLUIR MÁQUINA VIRTUAL"
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

echo
read -p "Tem certeza que deseja excluir '$VM'? (s/N): " RESP

case "$RESP" in
    s|S|sim|SIM)
        rm -rf "$VM_DIR/$VM"
        echo
        echo "✅ Máquina removida com sucesso!"
        ;;
    *)
        echo
        echo "Operação cancelada."
        ;;
esac

pausa
