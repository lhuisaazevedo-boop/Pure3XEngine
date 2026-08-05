#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "         CONFIGURAÇÕES DA CPU"
echo "========================================="
echo
echo "1) Modelo da CPU"
echo "   Atual: ${CPU:-486}"
echo
echo "2) Número de núcleos"
echo "   Atual: ${CORES:-1}"
echo
echo "3) Virtualização"
echo "   Atual: ${ACCEL:-tcg}"
echo
echo "4) Frequência"
echo "   Atual: ${CPU_FREQ:-Automática}"
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

echo "Modelos disponíveis:"
echo
echo "1) 486"
echo "2) pentium"
echo "3) pentium2"
echo "4) pentium3"
echo "5) core2duo"
echo "6) qemu32"
echo "7) qemu64"
echo

read -rp "Escolha: " c

case "$c" in
1) CPU="486" ;;
2) CPU="pentium" ;;
3) CPU="pentium2" ;;
4) CPU="pentium3" ;;
5) CPU="core2duo" ;;
6) CPU="qemu32" ;;
7) CPU="qemu64" ;;
esac
;;

2)
read -rp "Número de núcleos: " CORES
;;

3)

clear
cabecalho

echo "1) tcg (Emulação)"
echo "2) kvm (quando disponível)"
echo

read -rp "Escolha: " a

case "$a" in
1) ACCEL="tcg" ;;
2) ACCEL="kvm" ;;
esac
;;

4)
read -rp "Frequência da CPU: " CPU_FREQ
;;

5)

echo
echo "CPU.............: $CPU"
echo "Núcleos.........: $CORES"
echo "Aceleração......: $ACCEL"
echo "Frequência......: $CPU_FREQ"
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
