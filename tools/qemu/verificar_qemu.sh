#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear
cabecalho

echo "=============================================================="
echo "🔍 VERIFICAR INSTALAÇÃO DO QEMU"
echo "=============================================================="
echo

if command -v qemu-system-aarch64 >/dev/null 2>&1; then

    echo "✅ QEMU instalado!"
    echo

    echo "Versão:"
    qemu-system-aarch64 --version | head -n 1
    echo

    echo "Executável:"
    command -v qemu-system-aarch64
    echo

else

    echo "❌ QEMU não está instalado."
    echo

fi

echo "--------------------------------------------------------------"
echo "📁 Pasta ISOs : $ROOT_DIR/qemu/isos"
echo "💾 Pasta VMs  : $ROOT_DIR/qemu/vms"
echo "📝 Pasta Logs : $ROOT_DIR/qemu/logs"
echo "--------------------------------------------------------------"

echo
pausa
