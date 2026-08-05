#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms"

clear
cabecalho

echo "============================================================"
echo "🔧 ATUALIZAR / REPARAR MÁQUINA VIRTUAL"
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
echo "Verificando estrutura da máquina..."
echo

ARQUIVOS=(
    "config.conf"
    "boot.conf"
    "video.conf"
    "audio.conf"
    "cpu.conf"
    "memoria.conf"
    "armazenamento.conf"
    "perifericos.conf"
    "rede.conf"
    "vnc.conf"
)

for ARQ in "${ARQUIVOS[@]}"; do
    if [ ! -f "$VM_DIR/$VM/$ARQ" ]; then
        touch "$VM_DIR/$VM/$ARQ"
        echo "✔ Criado: $ARQ"
    else
        echo "✓ OK: $ARQ"
    fi
done

echo
echo "✅ Verificação concluída."
echo "A estrutura da máquina está íntegra."

pausa
