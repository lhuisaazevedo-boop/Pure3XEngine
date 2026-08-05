#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"

clear
cabecalho

echo "============================================================"
echo "📋 DUPLICAR MÁQUINA VIRTUAL"
echo "============================================================"
echo

echo "Máquinas disponíveis:"
echo
ls "$VM_DIR"
echo

read -p "Máquina de origem: " VM_ORIGEM

if [ ! -d "$VM_DIR/$VM_ORIGEM" ]; then
    erro "Máquina não encontrada."
    pausa
    exit 1
fi

read -p "Nome da nova máquina: " VM_DESTINO

if [ -z "$VM_DESTINO" ]; then
    erro "Nome inválido."
    pausa
    exit 1
fi

if [ -d "$VM_DIR/$VM_DESTINO" ]; then
    erro "Já existe uma máquina com esse nome."
    pausa
    exit 1
fi

cp -a "$VM_DIR/$VM_ORIGEM" "$VM_DIR/$VM_DESTINO"

echo
echo "✅ Máquina duplicada com sucesso!"
echo
echo "Origem : $VM_ORIGEM"
echo "Cópia  : $VM_DESTINO"

pausa
