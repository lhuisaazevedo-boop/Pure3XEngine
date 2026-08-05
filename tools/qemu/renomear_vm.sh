#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"

clear
cabecalho

echo "============================================================"
echo "✏️ RENOMEAR MÁQUINA VIRTUAL"
echo "============================================================"
echo

echo "Máquinas disponíveis:"
echo
ls "$VM_DIR"
echo

read -p "Nome atual: " VM_ANTIGA

if [ ! -d "$VM_DIR/$VM_ANTIGA" ]; then
    erro "Máquina não encontrada."
    pausa
    exit 1
fi

read -p "Novo nome: " VM_NOVA

if [ -z "$VM_NOVA" ]; then
    erro "Nome inválido."
    pausa
    exit 1
fi

if [ -d "$VM_DIR/$VM_NOVA" ]; then
    erro "Já existe uma máquina com esse nome."
    pausa
    exit 1
fi

mv "$VM_DIR/$VM_ANTIGA" "$VM_DIR/$VM_NOVA"

echo
echo "✅ Máquina renomeada com sucesso!"
echo
echo "Antes : $VM_ANTIGA"
echo "Agora : $VM_NOVA"

pausa
