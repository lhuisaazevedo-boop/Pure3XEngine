#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "         CONFIGURAÇÕES DE MEMÓRIA"
echo "========================================="
echo
echo "1) Memória RAM"
echo "   Atual: ${RAM:-64} MB"
echo
echo "2) Memória máxima"
echo "   Atual: ${MAX_RAM:-256} MB"
echo
echo "3) Pré-alocação"
echo "   Atual: ${PREALLOC:-off}"
echo
echo "4) Mostrar configuração atual"
echo
echo "0) Voltar"
echo

read -rp "Escolha uma opção: " op

case "$op" in

1)
    clear
    cabecalho

    echo "=========== MEMÓRIA RAM ==========="
    echo
    echo "1) 16 MB"
    echo "2) 32 MB"
    echo "3) 64 MB (Recomendado)"
    echo "4) 128 MB"
    echo "5) 256 MB"
    echo "6) 512 MB"
    echo "7) 1024 MB"
    echo "8) Personalizada"
    echo

    read -rp "Escolha: " r

    case "$r" in
        1) RAM=16 ;;
        2) RAM=32 ;;
        3) RAM=64 ;;
        4) RAM=128 ;;
        5) RAM=256 ;;
        6) RAM=512 ;;
        7) RAM=1024 ;;
        8) read -rp "Digite a RAM em MB: " RAM ;;
    esac
    ;;

2)
    read -rp "Memória máxima (MB): " MAX_RAM
    ;;

3)
    read -rp "Pré-alocação (on/off): " PREALLOC
    ;;

4)
    echo
    echo "RAM.............: ${RAM} MB"
    echo "RAM Máxima......: ${MAX_RAM} MB"
    echo "Pré-alocação....: ${PREALLOC}"
    pausa
    ;;

0)
    break
    ;;

*)
    erro "Opção inválida!"
    pausa
    ;;

esac
done
