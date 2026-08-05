#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "        CONFIGURAÇÕES DE REDE"
echo "========================================="
echo
echo "1) Modelo da placa"
echo "   Atual: ${NET_MODEL:-ne2k_pci}"
echo
echo "2) Tipo de rede"
echo "   Atual: ${NET_TYPE:-user}"
echo
echo
echo "3) MAC Address"
echo "   Atual: ${MAC_ADDRESS:-Automático}"
echo
echo
echo "4) DHCP"
echo "   Atual: ${DHCP:-on}"
echo
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

echo "1) ne2k_pci"
echo "2) rtl8139"
echo "3) e1000"
echo "4) virtio-net"
echo

read -rp "Escolha: " r

case "$r" in
1) NET_MODEL="ne2k_pci" ;;
2) NET_MODEL="rtl8139" ;;
3) NET_MODEL="e1000" ;;
4) NET_MODEL="virtio-net" ;;
esac
;;

2)

clear
cabecalho

echo "1) user (NAT)"
echo "2) bridge"
echo "3) none"
echo

read -rp "Escolha: " r

case "$r" in
1) NET_TYPE="user" ;;
2) NET_TYPE="bridge" ;;
3) NET_TYPE="none" ;;
esac
;;

3)
read -rp "MAC Address: " MAC_ADDRESS
;;

4)

clear
cabecalho

echo "1) Ativar DHCP"
echo "2) Desativar DHCP"
echo

read -rp "Escolha: " r

case "$r" in
1) DHCP="on" ;;
2) DHCP="off" ;;
esac
;;

5)

echo
echo "Modelo.......: $NET_MODEL"
echo "Rede.........: $NET_TYPE"
echo "MAC..........: $MAC_ADDRESS"
echo "DHCP.........: $DHCP"
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
