#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "         CONFIGURAÇÕES DE BOOT"
echo "========================================="
echo
echo "1) Dispositivo de boot"
echo "   Atual: ${BOOT:-disk}"
echo
echo "2) BIOS"
echo "   Atual: ${BIOS:-SeaBIOS}"
echo
echo "3) Menu de boot"
echo "   Atual: ${BOOT_MENU:-off}"
echo
echo "4) Tempo de espera"
echo "   Atual: ${BOOT_TIMEOUT:-3} s"
echo
echo "5) Mostrar configuração atual"
echo
echo "0) Voltar"
echo

read -rp "Escolha uma opção: " op

case "$op" in

1)

clear
cabecalho

echo "1) Disco rígido"
echo "2) CD/DVD"
echo "3) Rede (PXE)"
echo

read -rp "Escolha: " b

case "$b" in
1) BOOT="disk" ;;
2) BOOT="cdrom" ;;
3) BOOT="network" ;;
esac
;;

2)

clear
cabecalho

echo "1) SeaBIOS"
echo "2) OVMF (UEFI)"
echo

read -rp "Escolha: " b

case "$b" in
1) BIOS="SeaBIOS" ;;
2) BIOS="OVMF" ;;
esac
;;

3)

clear
cabecalho

echo "1) Ativar"
echo "2) Desativar"
echo

read -rp "Escolha: " b

case "$b" in
1) BOOT_MENU="on" ;;
2) BOOT_MENU="off" ;;
esac
;;

4)
read -rp "Tempo (segundos): " BOOT_TIMEOUT
;;

5)

echo
echo "Boot...........: $BOOT"
echo "BIOS...........: $BIOS"
echo "Menu...........: $BOOT_MENU"
echo "Timeout........: $BOOT_TIMEOUT s"
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
