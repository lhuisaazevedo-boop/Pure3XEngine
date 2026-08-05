#!/data/data/com.termux/files/usr/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

instalar_qemu() {
    clear
    cabecalho

    echo "=============================================================="
    echo "📦 INSTALANDO QEMU"
    echo "=============================================================="
    echo
    echo "Versão selecionada: $1"
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
        qemu-system-i386 --version | head -n 1
        qemu-system-aarch64 --version | head -n 1
    else
        erro "Falha na instalação."
    fi

    pausa
}

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "📦 INSTALAR / ATUALIZAR QEMU"
    echo "=============================================================="
    echo
    echo "1) QEMU 8.1.x  (Estável)"
    echo "2) QEMU 8.2.x  (Estável)"
    echo "3) QEMU 9.0.x"
    echo "4) QEMU 9.1.x"
    echo "5) QEMU 9.2.x"
    echo "6) QEMU 9.3.x"
    echo "7) QEMU 9.4.x"
    echo "8) QEMU 10.0.x"
    echo "9) Instalar versão disponível no Termux"
    echo
    echo "0) Voltar"
    echo

    read -p "Escolha uma opção: " op

    case "$op" in

        1) instalar_qemu "QEMU 8.1.x" ;;
        2) instalar_qemu "QEMU 8.2.x" ;;
        3) instalar_qemu "QEMU 9.0.x" ;;
        4) instalar_qemu "QEMU 9.1.x" ;;
        5) instalar_qemu "QEMU 9.2.x" ;;
        6) instalar_qemu "QEMU 9.3.x" ;;
        7) instalar_qemu "QEMU 9.4.x" ;;
        8) instalar_qemu "QEMU 10.0.x" ;;
        9) instalar_qemu "Versão disponível no Termux" ;;

        0)
            break
        ;;

        *)
            erro "Opção inválida!"
            pausa
        ;;

    esac
done
