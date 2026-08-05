#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "   CONFIGURAÇÕES DE PERIFÉRICOS"
echo "========================================="
echo
echo "1) Mouse"
echo "   Atual: ${MOUSE:-ps2}"
echo
echo "2) Teclado"
echo "   Atual: ${KEYBOARD:-abnt2}"
echo
echo "3) Tablet USB"
echo "   Atual: ${TABLET:-off}"
echo
echo "4) Joystick"
echo "   Atual: ${JOYSTICK:-off}"
echo
echo "5) Mostrar configuração"
echo
echo "0) Voltar"
echo

read -rp "Escolha: " op

case "$op" in

1)

clear
cabecalho

echo "1) PS/2"
echo "2) USB"
echo "3) VirtIO"
echo

read -rp "Escolha: " r

case "$r" in
1) MOUSE="ps2" ;;
2) MOUSE="usb" ;;
3) MOUSE="virtio" ;;
esac
;;

2)

clear
cabecalho

echo "1) ABNT2"
echo "2) US"
echo "3) UK"
echo "4) ES"
echo

read -rp "Escolha: " r

case "$r" in
1) KEYBOARD="abnt2" ;;
2) KEYBOARD="us" ;;
3) KEYBOARD="uk" ;;
4) KEYBOARD="es" ;;
esac
;;

3)

clear
cabecalho

echo "1) Ativar"
echo "2) Desativar"

read -rp "Escolha: " r

case "$r" in
1) TABLET="on" ;;
2) TABLET="off" ;;
esac
;;

4)

clear
cabecalho

echo "1) Ativar"
echo "2) Desativar"

read -rp "Escolha: " r

case "$r" in
1) JOYSTICK="on" ;;
2) JOYSTICK="off" ;;
esac
;;

5)

echo
echo "Mouse........: $MOUSE"
echo "Teclado......: $KEYBOARD"
echo "Tablet.......: $TABLET"
echo "Joystick.....: $JOYSTICK"
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
