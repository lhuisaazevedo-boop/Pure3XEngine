#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

ISO_DIR="$ROOT_DIR/qemu/isos"
VM_DIR="$ROOT_DIR/qemu/vms"
LOG_DIR="$ROOT_DIR/qemu/logs"

# Função de verificação
qemu_instalado() {
    command -v qemu-system-aarch64 >/dev/null 2>&1 || \
    command -v qemu-system-i386 >/dev/null 2>&1
}

while true
do
    clear
    cabecalho
    echo "=================================================="
    echo "           💻 QEMU CENTER — PURE3XENGINE"
    echo "=================================================="
    echo

    echo "1) ▶ Iniciar QEMU"
    echo "2) 📦 Instalar QEMU"
    echo "3) 🔄 Atualizar QEMU"
    echo "4) 🔍 Verificar Instalação"
    echo "5) 🖥 Gerenciar Máquinas Virtuais"
    echo "6) 💽 Criar Disco Virtual"
    echo "7) 📥 Importador de ISO"
    echo "8) ⚙ Configurações"
    echo "9) 📊 Informações do Sistema"
    echo "10) 📄 Logs do QEMU"
    echo "11) ❌ Remover QEMU"
    echo "12) 🧩 Sistema QEMU"
    echo "0) ⬅ Voltar ao Menu Principal"
    echo

    read -rp "Escolha uma opção: " opcao

    case "$opcao" in
        1) bash "$ROOT_DIR/tools/qemu/iniciar_qemu.sh"; pausa ;;
        2) bash "$ROOT_DIR/tools/qemu/instalar_qemu.sh"; pausa ;;
        3) bash "$ROOT_DIR/tools/qemu/instalar_atualizar.sh"; pausa ;;
        4) bash "$ROOT_DIR/tools/qemu/verificar_qemu.sh"; pausa ;;
        5) bash "$ROOT_DIR/tools/qemu/gerenciar_vm.sh"; pausa ;;
        6) bash "$ROOT_DIR/tools/qemu/criar_disco.sh"; pausa ;;
        7) bash "$ROOT_DIR/tools/qemu/importador_iso.sh"; pausa ;;
        8) bash "$ROOT_DIR/tools/qemu/configuracoes.sh"; pausa ;;
        9) bash "$ROOT_DIR/tools/qemu/info_sistema.sh"; pausa ;;
        10) bash "$ROOT_DIR/tools/qemu/logs.sh"; pausa ;;
        11) bash "$ROOT_DIR/tools/qemu/remover_qemu.sh"; pausa ;;
        12) bash "$ROOT_DIR/tools/qemu/sistema_qemu.sh"; pausa ;;
        0) break ;;
        *) erro "Opção inválida!"; pausa ;;
    esac
done

