#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

while true
do
    cabecalho

    titulo "🤖 AI CENTER"

    echo "1) 🩺 Doctor Inteligente"
    echo "2) 🔧 Corrigir Projeto"
    echo "3) 🚀 Build Inteligente"
    echo "4) 📦 Publicador Inteligente"
    echo "5) 📝 Gerar README"
    echo "6) 📊 Relatório do Projeto"
    echo "7) 🔍 Analisar Erros"
    echo "8) 💡 Sugestões de Otimização"
    echo "9) ⚡ Executar Tudo"
    echo "10) 🖥 Terminal Avançado"
    echo
    echo
    echo "0) ← Voltar"
    echo

    read -r -p "Escolha uma opção: " opcao

    case "$opcao" in

    1)
        bash "$ROOT_DIR/tools/ai/doctor.sh"
        pausa
        ;;

    2)
        bash "$ROOT_DIR/tools/ai/fix_project.sh"
        pausa
        ;;

    3)
        bash "$ROOT_DIR/tools/ai/smart_build.sh"
        pausa
        ;;

    4)
        bash "$ROOT_DIR/tools/ai/publisher.sh"
        pausa
        ;;

    5)
        bash "$ROOT_DIR/tools/ai/readme_generator.sh"
        pausa
        ;;

    6)
        bash "$ROOT_DIR/tools/ai/project_report.sh"
        pausa
        ;;

    7)
        bash "$ROOT_DIR/tools/ai/error_analyzer.sh"
        pausa
        ;;

    8)
        bash "$ROOT_DIR/tools/ai/optimizer.sh"
        pausa
        ;;

    9)
        bash "$ROOT_DIR/tools/ai/run_all.sh"
        pausa
        ;;

    10)
        clear
        echo "=============================================================="
        echo "🖥 P3XE - TERMINAL AVANÇADO"
        echo "=============================================================="
        echo
        echo "Projeto : $ROOT_DIR"
        echo "Shell   : $SHELL"
        echo
        echo "Digite 'exit' para retornar ao AI Center."
        echo

        cd "$ROOT_DIR" || {
            erro "Não foi possível acessar o projeto."
            pausa
            continue
        }

        bash
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
