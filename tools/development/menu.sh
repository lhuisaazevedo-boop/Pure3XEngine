#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

while true
do
    cabecalho
    titulo "🔧 DEVELOPMENT CENTER"

    echo "1) 🩺 Doctor Inteligente"
    echo "2) 🔧 Smart Repair"
    echo "3) 🧹 Clean Project"
    echo "4) 📋 Health Report"
    echo "5) 📦 Informações do Projeto"
    echo
    echo "0) ↩ Voltar"
    echo

    read -r -p "Escolha uma opção: " opcao

    case "$opcao" in

1)
    SCRIPT="$ROOT_DIR/tools/doctor/menu.sh"

    if [ -f "$SCRIPT" ]; then
        bash "$SCRIPT"
    else
        echo "❌ Doctor Center não encontrado:"
        echo "$SCRIPT"
        read -r -p "Pressione ENTER para continuar..."
    fi
    ;;
        2)
            SCRIPT="$ROOT_DIR/tools/development/smart_repair.sh"

            if [ -f "$SCRIPT" ]; then
                bash "$SCRIPT"
            else
                erro "Smart Repair não encontrado:"
                echo "$SCRIPT"
                pausa
            fi
            ;;

        3)
            SCRIPT="$ROOT_DIR/tools/development/clean.sh"

            if [ -f "$SCRIPT" ]; then
                bash "$SCRIPT"
            else
                erro "Clean Project não encontrado:"
                echo "$SCRIPT"
                pausa
            fi
            ;;

        4)
            SCRIPT="$ROOT_DIR/tools/development/report.sh"

            if [ -f "$SCRIPT" ]; then
                bash "$SCRIPT"
            else
                erro "Health Report não encontrado:"
                echo "$SCRIPT"
                pausa
            fi
            ;;

        5)
            echo
            titulo "📦 INFORMAÇÕES DO PROJETO"

            echo "Projeto : Pure3XEngine"
            echo "Versão  : ${P3XE_VERSION:-0.2.6 Alpha}"
            echo "Root    : $ROOT_DIR"
            echo
            echo "Arquivos C/C++:"
            find "$ROOT_DIR" \
                -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.h" -o -name "*.hpp" \) \
                2>/dev/null | wc -l

            echo
            echo "Scripts:"
            find "$ROOT_DIR/tools" \
                -type f -name "*.sh" \
                2>/dev/null | wc -l

            pausa
            ;;

        0)
            break
            ;;

        *)
            aviso "Opção inválida: $opcao"
            pausa
            ;;
    esac
done
