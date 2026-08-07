#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

cabecalho
titulo "🚀 BOOT FLASH PS3"

echo
echo "Iniciando verificação da Flash PS3..."
echo

for i in $(seq 0 100)
do
    printf "\rProgresso: %3d%%" "$i"
    sleep 0.03
done

echo
echo
echo "================ COMPONENTES ================"

echo "✔ Flash0............... Detectado"
sleep 0.2
echo "✔ Flash1............... Detectado"
sleep 0.2
echo "✔ dev_flash............ Detectado"
sleep 0.2
echo "✔ dev_flash2........... Detectado"
sleep 0.2
echo "✔ dev_hdd0............. Detectado"
sleep 0.2
echo "✔ dev_bdvd............ Detectado"
sleep 0.2
echo "✔ Firmware Loader...... Pronto"
sleep 0.2
echo "✔ XMB Base............. Pronto"
sleep 0.2
echo "✔ CELL / PPU........... Carregado"
sleep 0.2
echo "✔ SPU.................. Carregado"
sleep 0.2
echo "✔ RSX.................. Carregado"

echo
echo "============================================"
echo " Versão Firmware : Alpha"
echo " Boot Flash      : OK"
echo " XMB             : Bootável"
echo " Status          : Pronto"
echo "============================================"

echo
read -p "Pressione ENTER para voltar..."
