#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
ISO_DIR="$ROOT_DIR/qemu/isos"

mkdir -p "$VM_DIR"

clear
cabecalho

echo "==============================================================="
echo "                    DIAGNÓSTICO DA VM"
echo "==============================================================="
echo

ERROS=0

#-------------------------------------------------
# QEMU
#-------------------------------------------------

if command -v qemu-system-i386 >/dev/null 2>&1; then
    echo "[✓] QEMU encontrado"
else
    echo "[x] QEMU não encontrado"
    ERROS=$((ERROS+1))
fi

#-------------------------------------------------
# ISO
#-------------------------------------------------

ISO_CONF="$VM_DIR/iso.conf"
iso=""

# Lê o caminho salvo da ISO (agora com -i para ignorar maiúsculas/minúsculas)
if [ -f "$ISO_CONF" ]; then
    iso=$(grep -i '^ISO=' "$ISO_CONF" | cut -d= -f2-)
fi

# Se o caminho salvo existir
if [ -n "$iso" ] && [ -f "$iso" ]; then
    echo "[✓] ISO encontrada"
else
    # Procura automaticamente qualquer ISO (garante apenas 1 arquivo com head)
    ISO=$(find "$ISO_DIR" -maxdepth 1 -type f \( -iname "*.iso" -o -iname "*.img" -o -iname "*.bin" \) | head -n 1)

    if [ -n "$ISO" ]; then
        # Salva com a chave em maiúsculas para manter padrão
        echo "ISO=$ISO" > "$ISO_CONF"
        echo "[✓] ISO encontrada automaticamente"
    else
        echo "[x] ISO não encontrada"
        ERROS=$((ERROS+1))
    fi
fi

#-------------------------------------------------
# Disco virtual
#-------------------------------------------------

DISCO="$VM_DIR/msdos.qcow2"

if [ ! -f "$DISCO" ]; then

    echo
    echo "Criando disco virtual..."

    qemu-img create -f qcow2 "$DISCO" 2G >/dev/null 2>&1

    if [ -f "$DISCO" ]; then

        cat > "$VM_DIR/disco.conf" <<EOF
DISCO=$DISCO
FORMATO=qcow2
TAMANHO=2G
EOF

        echo "[✓] Disco virtual criado"

    else

        echo "[x] Falha ao criar disco virtual"
        ERROS=$((ERROS+1))

    fi

else

    echo "[✓] Disco virtual encontrado"

fi

#-------------------------------------------------
# Boot
#-------------------------------------------------

if [ -f "$VM_DIR/boot.conf" ]; then
    echo "[✓] Boot configurado"
else
    echo "[x] Boot não configurado"
    ERROS=$((ERROS+1))
fi

#-------------------------------------------------
# Periféricos
#-------------------------------------------------

if [ -f "$VM_DIR/perifericos.conf" ]; then
    echo "[✓] Periféricos configurados"
else
    echo "[x] Periféricos não configurados"
    ERROS=$((ERROS+1))
fi

#-------------------------------------------------
# DISPLAY GRÁFICO (Termux:X11)
#-------------------------------------------------

echo "Verificando ambiente gráfico..."

if [ -z "${DISPLAY:-}" ]; then
    echo "[✗] DISPLAY não configurado."
    echo "    Abra o Termux:X11 e execute:"
    echo "    export DISPLAY=:0"
    ERROS=$((ERROS+1))

else
    echo "[✓] DISPLAY configurado: $DISPLAY"

    # Verifica se existe comunicação com o servidor X11
    if command -v xdpyinfo >/dev/null 2>&1; then
        if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
            echo "[✓] Termux:X11 respondendo corretamente."
        else
            echo "[✗] DISPLAY existe, mas o Termux:X11 não está respondendo."
            ERROS=$((ERROS+1))
        fi
    else
        echo "[!] xdpyinfo não instalado; teste X11 avançado ignorado."
    fi
fi

echo
echo "=========================================================="

if [ "$ERROS" -eq 0 ]; then
    echo "✓ Nenhum problema encontrado."
    echo "✓ Ambiente gráfico pronto."
    echo "✓ VM pronta para iniciar."
else
    echo "✗ Foram encontrados $ERROS problema(s)."
    echo "✗ Corrija os problemas antes de iniciar a VM."
fi

echo
pausa
