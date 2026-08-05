#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

ISO_DIR="$ROOT_DIR/qemu/isos"
VM_DIR="$ROOT_DIR/qemu/vms"
LOG_DIR="$ROOT_DIR/qemu/logs"

clear
cabecalho

echo "=============================================================="
echo "📊 INFORMAÇÕES DO SISTEMA"
echo "=============================================================="
echo

echo "📱 Android"
echo "• Versão : $(getprop ro.build.version.release)"
echo "• SDK    : $(getprop ro.build.version.sdk)"
echo "• Kernel : $(uname -r)"
echo "• Arquitetura : $(uname -m)"
echo

echo "📦 Termux"
echo "• Prefixo : $PREFIX"
echo "• Home    : $HOME"
echo

echo "💻 QEMU"

if command -v qemu-system-aarch64 >/dev/null 2>&1; then
    echo "• Status  : Instalado"
    echo "• Versão  : $(qemu-system-aarch64 --version | head -n1)"
    echo "• Binário : $(command -v qemu-system-aarch64)"
else
    echo "• Status  : Não instalado"
fi

echo
echo "🖥 Máquinas Virtuais"

if [ -d "$VM_DIR" ]; then
    TOTAL_VM=$(find "$VM_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
else
    TOTAL_VM=0
fi

echo "• Total de VMs : $TOTAL_VM"

echo
echo "💾 Memória"

free -h 2>/dev/null || cat /proc/meminfo | head -5

echo
echo "📂 Armazenamento"

df -h "$HOME" | tail -1

echo
echo "📁 Diretórios"

echo "• ISOs : $ISO_DIR"
echo "• VMs  : $VM_DIR"
echo "• Logs : $LOG_DIR"

echo
echo "⚙ CPU"

echo "• Núcleos : $(nproc)"
echo "• Modelo  : $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2)"

echo
echo "=============================================================="

read -p "Pressione ENTER para continuar..."
