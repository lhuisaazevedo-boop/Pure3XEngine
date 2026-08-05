#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Pure3XEngine
# QEMU Center - Validação da VM MS-DOS
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"

while [ "$ROOT_DIR" != "/" ]; do
    if [ -d "$ROOT_DIR/tools" ] &&
       [ -d "$ROOT_DIR/qemu" ] &&
       [ -f "$ROOT_DIR/tools/common/init.sh" ]; then
        break
    fi

    ROOT_DIR="$(dirname "$ROOT_DIR")"
done

if [ ! -f "$ROOT_DIR/tools/common/init.sh" ]; then
    echo "Erro: Pure3XEngine não encontrado."
    exit 1
fi

source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"

ERROS=0

clear
cabecalho

echo "=============================="
echo "      VALIDANDO MS-DOS"
echo "=============================="
echo

# QEMU
if command -v qemu-system-i386 >/dev/null 2>&1 ||
   command -v qemu-system-x86_64 >/dev/null 2>&1 ||
   command -v qemu-system-aarch64 >/dev/null 2>&1; then
    echo "✓ QEMU encontrado"
else
    echo "✗ QEMU não instalado"
    ERROS=$((ERROS+1))
fi

# Disco
if find "$VM_DIR" -maxdepth 1 \( -name "*.qcow2" -o -name "*.img" \) | grep -q .; then
    echo "✓ Disco virtual encontrado"
else
    echo "✗ Disco virtual não encontrado"
    ERROS=$((ERROS+1))
fi

# Configuração
if [ -f "$VM_DIR/msdos.conf" ]; then
    echo "✓ Configuração encontrada"
else
    echo "✗ msdos.conf não encontrado"
    ERROS=$((ERROS+1))
fi

# Boot
if [ -f "$VM_DIR/boot.conf" ]; then
    echo "✓ Boot configurado"
else
    echo "✗ boot.conf não encontrado"
    ERROS=$((ERROS+1))
fi

# Periféricos
if [ -f "$VM_DIR/perifericos.conf" ]; then
    echo "✓ Periféricos configurados"
else
    echo "✗ perifericos.conf não encontrado"
    ERROS=$((ERROS+1))
fi

# VNC
if [ -f "$VM_DIR/vnc.conf" ]; then
    echo "✓ VNC configurado"
else
    echo "✗ vnc.conf não encontrado"
    ERROS=$((ERROS+1))
fi

# ISO
if [ -f "$VM_DIR/iso.conf" ]; then
    source "$VM_DIR/iso.conf"

    if [ -n "$iso" ] && [ -f "$iso" ]; then
        echo "✓ ISO configurada"
    else
        echo "✗ ISO inválida"
        ERROS=$((ERROS+1))
    fi
else
    echo "• Nenhuma ISO selecionada"
fi

echo

if [ "$ERROS" -eq 0 ]; then
    sucesso "Validação concluída. VM pronta para iniciar."
    exit 0
else
    erro "Existem $ERROS problema(s) na configuração da VM."
    exit 1
fi
