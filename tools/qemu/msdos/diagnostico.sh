#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"

clear
cabecalho

echo "=============================================================="
echo "                  DIAGNÓSTICO DA VM"
echo "=============================================================="
echo

ERROS=0

verificar() {
    if [ -e "$2" ]; then
        echo "[✓] $1"
    else
        echo "[✗] $1"
        ERROS=$((ERROS+1))
    fi
}

# QEMU
if command -v qemu-system-i386 >/dev/null 2>&1; then
    echo "[✓] QEMU encontrado"
else
    echo "[✗] QEMU não encontrado"
    ERROS=$((ERROS+1))
fi

# Arquivos principais
verificar "Configuração encontrada" "$VM_DIR/config.conf"
verificar "Boot configurado" "$VM_DIR/boot.conf"
verificar "Periféricos configurados" "$VM_DIR/perifericos.conf"
verificar "VNC configurado" "$VM_DIR/vnc.conf"

# ISO
if [ -f "$VM_DIR/iso.conf" ]; then
    source "$VM_DIR/iso.conf" 2>/dev/null

    if [ -n "$ISO" ] && [ -f "$ISO" ]; then
        echo "[✓] ISO encontrada"
    else
        echo "[✗] ISO não encontrada"
        ERROS=$((ERROS+1))
    fi
else
    echo "[✗] ISO não configurada"
    ERROS=$((ERROS+1))
fi

# Disco Virtual
if [ -f "$VM_DIR/disco.conf" ]; then
    source "$VM_DIR/disco.conf" 2>/dev/null

    if [ -n "$DISCO" ] && [ -f "$DISCO" ]; then
        echo "[✓] Disco virtual encontrado"
        echo "    $(basename "$DISCO")"
    else
        echo "[✗] Disco virtual não encontrado"
        ERROS=$((ERROS+1))
    fi
else
    echo "[✗] Disco não configurado"
    ERROS=$((ERROS+1))
fi

echo

if [ "$ERROS" -eq 0 ]; then
    sucesso "VM pronta para iniciar."
else
    erro "Foram encontrados $ERROS problema(s)."
fi

echo
pausa
