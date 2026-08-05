#!/data/data/com.termux/files/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../common/init.sh"

clear
cabecalho

echo "=============================================================="
echo "📦 INSTALAR QEMU"
echo "=============================================================="
echo
echo "Versões recomendadas para Termux:"
echo
echo " • QEMU 8.1.x / 8.2.x"
echo "   ✔ Muito estável"
echo "   ✔ Compatível com i386 e x86_64"
echo
echo " • QEMU 9.x"
echo "   ✔ Mais recente"
echo "   ✔ Melhor desempenho"
echo "   ✔ Correções recentes"
echo
echo "Pacotes que serão instalados:"
echo
echo " ✓ qemu-system-aarch64"
echo " ✓ qemu-system-i386"
echo " ✓ qemu-utils"
echo " ✓ qemu-common"
echo
echo "=============================================================="
echo
echo "1) 📦 Instalar"
echo "0) ↩ Voltar"
echo

read -p "Escolha uma opção: " op

case "$op" in

1)
    clear
    cabecalho

    echo "=============================================================="
    echo "📦 INSTALANDO QEMU..."
    echo "=============================================================="
    echo

    pkg update -y
    pkg upgrade -y

    pkg install -y \
        qemu-system-aarch64 \
        qemu-system-i386 \
        qemu-utils \
        qemu-common

    echo

    if command -v qemu-system-i386 >/dev/null 2>&1; then
        sucesso "QEMU instalado com sucesso!"
        echo
        echo "Versões instaladas:"
        echo
        qemu-system-i386 --version | head -n 1
        qemu-system-aarch64 --version | head -n 1
    else
        erro "Falha na instalação do QEMU."
    fi

    pausa
;;

0)
    exit 0
;;

*)
    erro "Opção inválida!"
    pausa
;;

esac
