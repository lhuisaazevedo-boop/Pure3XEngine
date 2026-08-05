#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"
source "$ROOT_DIR/tools/qemu/config_global.sh"

while true; do

clear
cabecalho

echo "========================================="
echo "    CONFIGURAÇÕES DE ARMAZENAMENTO"
echo "========================================="
echo
echo "1) Disco rígido"
echo "   Atual: ${DISK:-Nenhum}"
echo
echo "2) Unidade de CD/DVD"
echo "   Atual: ${ISO:-Nenhuma}"
echo
echo "3) Interface do disco"
echo "   Atual: ${DISK_IF:-ide}"
echo
echo "4) Cache do disco"
echo "   Atual: ${CACHE:-writeback}"
echo
echo "5) Formato do disco"
echo "   Atual: ${DISK_FORMAT:-qcow2}"
echo
echo "6) Mostrar configuração"
echo
echo "0) Voltar"
echo

read -rp "Escolha: " op

case "$op" in

1)
read -rp "Caminho do disco: " DISK
;;

2)
read -rp "Caminho da ISO: " ISO
;;

3)

clear
cabecalho

echo "1) IDE"
echo "2) SATA"
echo "3) SCSI"
echo "4) VirtIO"
echo

read -rp "Escolha: " r

case "$r" in
1) DISK_IF="ide" ;;
2) DISK_IF="sata" ;;
3) DISK_IF="scsi" ;;
4) DISK_IF="virtio" ;;
esac
;;

4)

clear
cabecalho

echo "1) writeback"
echo "2) writethrough"
echo "3) none"
echo "4) unsafe"
echo

read -rp "Escolha: " r

case "$r" in
1) CACHE="writeback" ;;
2) CACHE="writethrough" ;;
3) CACHE="none" ;;
4) CACHE="unsafe" ;;
esac
;;

5)

clear
cabecalho

echo "1) qcow2"
echo "2) raw"
echo "3) vmdk"
echo "4) vdi"
echo

read -rp "Escolha: " r

case "$r" in
1) DISK_FORMAT="qcow2" ;;
2) DISK_FORMAT="raw" ;;
3) DISK_FORMAT="vmdk" ;;
4) DISK_FORMAT="vdi" ;;
esac
;;

6)

echo
echo "Disco..........: $DISK"
echo "ISO............: $ISO"
echo "Interface......: $DISK_IF"
echo "Cache..........: $CACHE"
echo "Formato........: $DISK_FORMAT"
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
