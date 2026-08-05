#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

while true
do
    cabecalho

    titulo "🧩 SMART MODULES"

    echo "1) 📂 Listar módulos"
    echo "2) 🔄 Atualizar módulos"
    echo "3) ➕ Criar módulo"
    echo "4) ❌ Remover módulo"
    echo "5) 📊 Status dos módulos"
    echo
    echo "0) ⬅ Voltar"
    echo

    read -p "Escolha uma opção: " modulo

    case "$modulo" in

        1)
            bash "$ROOT_DIR/tools/list_modules.sh"
            pausa
            ;;

        2)
            bash "$ROOT_DIR/tools/update_modules.sh"
            pausa
            ;;

        3)
            bash "$ROOT_DIR/tools/create_module.sh"
            pausa
            ;;

        4)
            bash "$ROOT_DIR/tools/remove_module.sh"
            pausa
            ;;

        5)
            bash "$ROOT_DIR/tools/module_status.sh"
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
