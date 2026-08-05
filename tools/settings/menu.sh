#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")"/../.. && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

while true
do
    cabecalho

    titulo "⚙ SETTINGS CENTER"

    echo "1) 🎨 Alterar Tema"
    echo "2) 🧹 Limpar Cache"
    echo "3) 📦 Atualizar P3XE Kit"
    echo "4) 📁 Configurar Caminhos"
    echo "5) 🤖 Configurar Android NDK"
    echo "6) 📱 Configurar Android SDK"
    echo "7) 🌿 Configurar Git"
    echo "8) ♻ Restaurar Configurações"
    echo "9) 📊 Informações do Ambiente"
    echo
    echo "0) ⬅ Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            echo "Alteração de tema em desenvolvimento."
            pausa
            ;;

        2)
            echo "Limpando cache..."
            rm -rf ~/.cache/*
            pausa
            ;;

        3)
            echo "Atualizando P3XE Kit..."
            git pull
            pausa
            ;;

        4)
            echo "Projeto:"
            echo "$ROOT_DIR"
            pausa
            ;;

        5)
            echo "NDK:"
            echo "$ANDROID_NDK_HOME"
            pausa
            ;;

        6)
            echo "SDK:"
            echo "$ANDROID_HOME"
            pausa
            ;;

        7)
            git config --list
            pausa
            ;;

        8)
            echo "Restaurando configurações padrão..."
            pausa
            ;;

        9)
            echo "===== Ambiente ====="
            uname -a
            echo
            termux-info
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
