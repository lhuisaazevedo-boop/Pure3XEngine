#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

MODULE_DIR="$ROOT_DIR/tools/utilities/modules"

executar_modulo() {
    local modulo="$1"
    local arquivo="$MODULE_DIR/$modulo"

    clear
    cabecalho

    if [[ ! -f "$arquivo" ]]; then
        erro "Módulo não encontrado:"
        echo "$arquivo"
        pausa
        return 1
    fi

    if [[ ! -r "$arquivo" ]]; then
        erro "Módulo sem permissão de leitura:"
        echo "$arquivo"
        pausa
        return 1
    fi

    bash "$arquivo"
}

while true; do
    clear
    cabecalho

    titulo "🛠 UTILITIES CENTER"

    echo "1) 🧹 Limpeza do Projeto"
    echo "2) 📁 Backup"
    echo "3) ♻️ Restaurar Backup"
    echo "4) 🔍 Procurar Arquivos"
    echo "5) 📊 Uso de Disco"
    echo "6) 💾 Informações de Memória"
    echo "7) ⚡ Informações da CPU"
    echo "8) 📦 Atualizar Pacotes"
    echo "9) 🔑 Corrigir Permissões"
    echo "10) 📋 Logs do Sistema"
    echo "11) 📂 Informações do Projeto"
    echo "12) 🔄 Reiniciar Ambiente"
    echo
    echo "13) 🧪 Diagnóstico Utilities"
    echo
    echo "0) ← Voltar"
    echo

    read -r -p "Escolha uma opção: " opcao

    case "$opcao" in
        1)  executar_modulo "clean.sh" ;;
        2)  executar_modulo "backup.sh" ;;
        3)  executar_modulo "restore.sh" ;;
        4)
           "$ROOT_DIR/tools/utilities/search.sh"
                                      ;;
        5)  executar_modulo "disk.sh" ;;
        6)  executar_modulo "memory.sh" ;;
        7)  executar_modulo "cpu.sh" ;;
        8)  executar_modulo "packages.sh" ;;
        9)  executar_modulo "permissions.sh" ;;
        10) executar_modulo "logs.sh" ;;
        11) executar_modulo "project_info.sh" ;;
        12) executar_modulo "restart.sh" ;;
        13) executar_modulo "diagnostics.sh" ;;

        0)
            break
            ;;

        *)
            erro "Opção inválida!"
            pausa
            ;;
    esac
done

