#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "     CONFIGURAÇÕES AVANÇADAS"
echo "========================================="
echo
echo "1) Aceleração"
echo "   Atual: ${ACCEL:-tcg}"
echo
echo "2) RTC"
echo "   Atual: ${RTC:-localtime}"
echo
echo "3) SMP (CPU)"
echo "   Atual: ${SMP:-1}"
echo
echo "4) VNC"
echo "   Atual: ${VNC:-on}"
echo
echo "5) Porta VNC"
echo "   Atual: ${PORT:-5900}"
echo
echo "6) Log"
echo "   Atual: ${LOG_LEVEL:-normal}"
echo
echo "7) Monitor QEMU"
echo "   Atual: ${MONITOR:-off}"
echo
echo "8) Mostrar configuração"
echo
echo "0) Voltar"
echo

read -rp "Escolha: " op

case "$op" in

1)

clear
cabecalho

echo "1) tcg"
echo "2) kvm"

read -rp "Escolha: " r

case "$r" in
1) ACCEL="tcg" ;;
2) ACCEL="kvm" ;;
esac
;;

2)

clear
cabecalho

echo "1) localtime"
echo "2) utc"

read -rp "Escolha: " r

case "$r" in
1) RTC="localtime" ;;
2) RTC="utc" ;;
esac
;;

3)
read -rp "Quantidade de CPUs: " SMP
;;

4)

clear
cabecalho

echo "1) Ativar"
echo "2) Desativar"

read -rp "Escolha: " r

case "$r" in
1) VNC="on" ;;
2) VNC="off" ;;
esac
;;

5)
read -rp "Porta VNC: " PORT
;;

6)

clear
cabecalho

echo "1) normal"
echo "2) debug"
echo "3) verbose"

read -rp "Escolha: " r

case "$r" in
1) LOG_LEVEL="normal" ;;
2) LOG_LEVEL="debug" ;;
3) LOG_LEVEL="verbose" ;;
esac
;;

7)

clear
cabecalho

echo "1) Ativar"
echo "2) Desativar"

read -rp "Escolha: " r

case "$r" in
1) MONITOR="on" ;;
2) MONITOR="off" ;;
esac
;;

8)

echo
echo "Aceleração....: $ACCEL"
echo "RTC...........: $RTC"
echo "SMP...........: $SMP"
echo "VNC...........: $VNC"
echo "Porta.........: $PORT"
echo "Log...........: $LOG_LEVEL"
echo "Monitor.......: $MONITOR"
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
