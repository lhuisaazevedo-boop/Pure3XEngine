#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

ISO_DIR="$ROOT_DIR/qemu/isos"

mkdir -p "$ISO_DIR"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "💿 IMPORTADOR DE ISOs"
    echo "=============================================================="
    echo

    echo "ISOs disponíveis:"
    echo

    ls "$ISO_DIR" 2>/dev/null || echo "Nenhuma ISO encontrada."

    echo
    echo "--------------------------------------------------------------"
    echo "1) 📥 Importar ISO"
    echo "2) 📂 Listar ISOs"
    echo "3) 🗑 Remover ISO"
    echo "4) 📋 Informações da ISO"
    echo
    echo "0) ⬅ Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            echo
            read -p "Digite o caminho completo da ISO: " ORIGEM

            if [ -f "$ORIGEM" ]; then
                cp "$ORIGEM" "$ISO_DIR/"
                sucesso "ISO importada com sucesso!"
            else
                erro "Arquivo não encontrado!"
            fi

            pausa
            ;;

        2)
            echo
            ls -lh "$ISO_DIR"
            pausa
            ;;

        3)
            echo
            ls "$ISO_DIR"

            echo
            read -p "Nome da ISO para remover: " ISO

            rm -f "$ISO_DIR/$ISO"

            sucesso "ISO removida."
            pausa
            ;;

        4)
            echo
            ls -lh "$ISO_DIR"
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
