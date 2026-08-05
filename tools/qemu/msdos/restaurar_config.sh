#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"

clear
cabecalho

echo "=============================================================="
echo "             RESTAURAR CONFIGURAÇÃO DA VM"
echo "=============================================================="
echo
echo "Esta operação irá apagar as configurações da VM."
echo
echo "Serão removidos:"
echo " - config.conf"
echo " - boot.conf"
echo " - iso.conf"
echo " - perifericos.conf"
echo " - vnc.conf"
echo
echo "O disco virtual NÃO será apagado."
echo

read -rp "Deseja continuar? (s/N): " resp

case "$resp" in
    s|S)
        rm -f \
            "$VM_DIR/config.conf" \
            "$VM_DIR/boot.conf" \
            "$VM_DIR/iso.conf" \
            "$VM_DIR/perifericos.conf" \
            "$VM_DIR/vnc.conf"

        sucesso "Configuração restaurada com sucesso."
        ;;
    *)
        aviso "Operação cancelada."
        ;;
esac

echo
pausa
