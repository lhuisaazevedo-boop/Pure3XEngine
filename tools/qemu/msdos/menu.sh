#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                    MS-DOS MANAGER"
    echo "=============================================================="
    echo
    echo "1) ▶ Iniciar MS-DOS"
    echo "2) ⚙ Configurar MS-DOS"
    echo "3) 💿 Selecionar ISO"
    echo "4) 💾 Selecionar Disco"
    echo "5) 🖥 Configurar VNC"
    echo "6) 🖱 Mouse e Teclado"
    echo "7) 💽 Boot"
    echo "8) 📋 Informações da VM"
    echo "9) 📝 Logs da VM"
    echo "10) 🔄 Restaurar Configuração"
    echo
    echo "0) ↩ Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            bash "$ROOT_DIR/tools/qemu/msdos/iniciar_msdos.sh"
            ;;

        2)
            bash "$ROOT_DIR/tools/qemu/msdos/configurar_msdos.sh"
            ;;

        3)
            bash "$ROOT_DIR/tools/qemu/msdos/selecionar_iso.sh"
            ;;

        4)
            bash "$ROOT_DIR/tools/qemu/msdos/selecionar_disco.sh"
            ;;

        5)
            bash "$ROOT_DIR/tools/qemu/msdos/configurar_vnc.sh"
            ;;

        6)
            bash "$ROOT_DIR/tools/qemu/msdos/perifericos.sh"
            ;;

        7)
            bash "$ROOT_DIR/tools/qemu/msdos/boot.sh"
            ;;

        8)
           bash "$ROOT_DIR/tools/qemu/msdos/info_vm.sh"
           ;;

       9)
           bash "$ROOT_DIR/tools/qemu/msdos/logs_vm.sh"
           ;;

       10)
          bash "$ROOT_DIR/tools/qemu/msdos/restaurar.sh"
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
