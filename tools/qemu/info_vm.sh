#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"

clear
cabecalho

echo "============================================================"
echo "📄 INFORMAÇÕES DA MÁQUINA VIRTUAL"
echo "============================================================"
echo

if [ ! -d "$VM_DIR" ]; then
    echo "Nenhuma máquina virtual encontrada."
    pausa
    exit 0
fi

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

clear
cabecalho

echo "============================================================"
echo "📄 INFORMAÇÕES DA MÁQUINA"
echo "============================================================"
echo

echo "Nome.............: $VM"
echo "Diretório........: $VM_DIR/$VM"
echo

echo "Arquivos:"
echo "------------------------------"
ls -lh "$VM_DIR/$VM"

echo
pausa
