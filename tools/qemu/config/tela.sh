#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "        CONFIGURAÇÕES DE TELA"
echo "========================================="
echo
echo "1) Driver de vídeo"
echo "   Atual: ${VIDEO_DRIVER:-VNC}"
echo
echo "2) Resolução"
echo "   Atual: ${RESOLUTION:-Automática}"
echo
echo "3) Profundidade de cor"
echo "   Atual: ${COLOR_DEPTH:-32}"
echo
echo "4) Tela cheia"
echo "   Atual: ${FULLSCREEN:-off}"
echo
echo "5) Escala"
echo "   Atual: ${SCALE:-100}"
echo
echo "6) Atualização da tela"
echo "   Atual: ${REFRESH:-Automático}"
echo
echo "7) Cursor do mouse"
echo "   Atual: ${CURSOR:-Visível}"
echo
echo "8) Mostrar configuração atual"
echo
echo "0) Voltar"
echo
read -rp "Escolha uma opção: " op

case "$op" in

1)
    read -rp "Driver (vnc/sdl/gtk/curses): " VIDEO_DRIVER
    ;;

2)
    read -rp "Resolução (auto,640x480,800x600,1024x768,1280x720): " RESOLUTION
    ;;

3)
    read -rp "Profundidade (16,24,32,64): " COLOR_DEPTH
    ;;

4)
    read -rp "Tela cheia (on/off): " FULLSCREEN
    ;;

5)
    read -rp "Escala (%): " SCALE
    ;;

6)
    read -rp "Atualização (auto,30,60,120): " REFRESH
    ;;

7)
    read -rp "Cursor (Visível/Oculto): " CURSOR
    ;;

8)
    echo
    echo "Driver........: $VIDEO_DRIVER"
    echo "Resolução.....: $RESOLUTION"
    echo "Cor...........: $COLOR_DEPTH bits"
    echo "Tela cheia....: $FULLSCREEN"
    echo "Escala........: $SCALE%"
    echo "Atualização...: $REFRESH"
    echo "Cursor........: $CURSOR"
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
