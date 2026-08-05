#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INIT="$ROOT_DIR/tools/common/init.sh"
REPAIR_DIR="$ROOT_DIR/tools/development/smart_repair"

if [ -f "$INIT" ]; then
    source "$INIT"
fi

executar() {
    local script="$REPAIR_DIR/$1"

    if [ ! -f "$script" ]; then
        echo
        echo "❌ Módulo não encontrado:"
        echo "$script"
        echo
        read -p "Pressione ENTER para continuar..."
        return
    fi

    bash "$script"
}

while true
do
    clear

    echo "=================================================="
    echo "              🧠 P3XE SMART REPAIR"
    echo "=================================================="
    echo
    echo "1) 🔐 Corrigir Permissões"
    echo "2) 📦 Verificar SDK / NDK"
    echo "3) 🧹 Limpar Caches"
    echo "4) 📝 Reparar local.properties"
    echo "5) 🔄 Verificar Gradle"
    echo "6) 🧠 Reparo Completo"
    echo
    echo "0) ↩ Voltar"
    echo

    read -p "Escolha: " opcao

    case "$opcao" in
        1) executar "permissions.sh" ;;
        2) executar "sdk.sh" ;;
        3) executar "cache.sh" ;;
        4) executar "local_properties.sh" ;;
        5) executar "gradle.sh" ;;
        6) executar "full_repair.sh" ;;
        0) break ;;
        *)
            echo "⚠ Opção inválida: $opcao"
            sleep 1
            ;;
    esac
done
