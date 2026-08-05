#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"

clear
cabecalho

echo "=============================================================="
echo "                INFORMAÇÕES DA VM - MS-DOS"
echo "=============================================================="
echo

echo "📁 Diretório da VM:"
echo "   $VM_DIR"
echo

echo "📀 ISO:"
if [ -f "$VM_DIR/iso.conf" ]; then
    cat "$VM_DIR/iso.conf"
else
    echo "Não configurada."
fi

echo
echo "💾 Configuração:"
if [ -f "$VM_DIR/config.conf" ]; then
    cat "$VM_DIR/config.conf"
else
    echo "Não encontrada."
fi

echo
echo "🖱 Periféricos:"
if [ -f "$VM_DIR/perifericos.conf" ]; then
    cat "$VM_DIR/perifericos.conf"
else
    echo "Não configurados."
fi

echo
echo "🌐 VNC:"
if [ -f "$VM_DIR/vnc.conf" ]; then
    cat "$VM_DIR/vnc.conf"
else
    echo "Não configurado."
fi

echo
echo "💿 Boot:"
if [ -f "$VM_DIR/boot.conf" ]; then
    cat "$VM_DIR/boot.conf"
else
    echo "Não configurado."
fi

echo
echo "📂 Arquivos da VM:"
if [ -d "$VM_DIR" ]; then
    ls -lh "$VM_DIR"
else
    echo "Diretório da VM não encontrado."
fi

echo
pausa
