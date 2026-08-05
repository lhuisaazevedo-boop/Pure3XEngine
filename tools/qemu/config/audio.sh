#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "        CONFIGURAÇÕES DE ÁUDIO"
echo "========================================="
echo
echo "1) Placa de som"
echo "   Atual: ${SOUND:-Nenhuma}"
echo
echo "2) Ativar áudio"
echo "   Atual: ${AUDIO_ENABLED:-on}"
echo
echo "3) Volume"
echo "   Atual: ${VOLUME:-100}%"
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

    echo "=============================="
    echo "      PLACA DE SOM"
    echo "=============================="
    echo
    echo "1) Nenhuma"
    echo "2) Sound Blaster 16 (sb16)"
    echo "3) AC97"
    echo "4) ES1370"
    echo "5) Intel HDA"
    echo

    read -rp "Escolha: " s

    case "$s" in
        1) SOUND="" ;;
        2) SOUND="sb16" ;;
        3) SOUND="ac97" ;;
        4) SOUND="es1370" ;;
        5) SOUND="intel-hda" ;;
    esac
    ;;

2)
    read -rp "Ativar áudio (on/off): " AUDIO_ENABLED
    ;;

3)
    read -rp "Volume (0-100): " VOLUME
    ;;

4)
    echo
    echo "Placa.......: ${SOUND:-Nenhuma}"
    echo "Áudio.......: $AUDIO_ENABLED"
    echo "Volume......: $VOLUME%"
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
