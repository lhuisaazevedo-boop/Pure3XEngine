#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

FLOPPY_DIR="$ROOT_DIR/qemu/floppies"
VM_DIR="$ROOT_DIR/qemu/vms/msdos"

clear

echo "=============================================================="
echo "               INSTALADOR MS-DOS 6.22"
echo "=============================================================="
echo

for i in 1 2 3
do
    if [ -f "$FLOPPY_DIR/dos-622-disk$i.img" ]; then
        echo "[✓] Disk $i encontrado"
    else
        echo "[✗] Disk $i não encontrado"
    fi
done

echo

if [ -f "$VM_DIR/msdos.qcow2" ]; then
    echo "[✓] Disco Virtual encontrado"
else
    echo "[!] Disco Virtual será criado"
fi

echo
echo "--------------------------------------------------------------"
echo "1) ▶ Iniciar Instalação"
echo "2) ✔ Verificar Disquetes"
echo "3) 💾 Recriar Disco Virtual"
echo "0) ↩ Voltar"
echo "--------------------------------------------------------------"
read -p "Escolha uma opção: " OP

case "$OP" in

1)
    bash "$ROOT_DIR/tools/qemu/install_dos_floppies.sh"
    ;;

2)
    echo
    ls -lh "$FLOPPY_DIR"
    read -p "ENTER para voltar..."
    exec "$0"
    ;;

3)
    rm -f "$VM_DIR/msdos.qcow2"
    qemu-img create -f qcow2 "$VM_DIR/msdos.qcow2" 64M
    echo
    echo "Disco virtual recriado."
    read -p "ENTER para voltar..."
    exec "$0"
    ;;

0)
    exit
    ;;

*)
    echo "Opção inválida."
    sleep 1
    exec "$0"
    ;;
esac
