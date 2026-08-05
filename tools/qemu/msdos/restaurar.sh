#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear
cabecalho

echo "============================================================"
echo "🔄 RESTAURAR CONFIGURAÇÃO"
echo "============================================================"
echo

echo "Restaurando configurações padrão do MS-DOS..."

bash "$ROOT_DIR/tools/qemu/msdos/configurar_msdos.sh"

echo
echo "✅ Configuração restaurada."

pausa
