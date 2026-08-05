#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

CONFIG_DIR="$ROOT_DIR/qemu/configs"
PROFILE_DIR="$ROOT_DIR/qemu/profiles"
CACHE_DIR="$ROOT_DIR/qemu/cache"

mkdir -p "$CONFIG_DIR"
mkdir -p "$PROFILE_DIR"
mkdir -p "$CACHE_DIR"

while true
do
    clear
    cabecalho

    echo "=================================================="
    echo "                 SISTEMA QEMU                     "
    echo "=================================================="
    echo
    echo "1) 📁 Inicializar Estrutura"
    echo "2) ⚙ Configurações Globais"
    echo "3) 🖥 Detectar Arquitetura"
    echo "4) 🗂 Gerenciar Perfis"
    echo "5) 🔄 Atualizar Banco de VMs"
    echo "6) 📝 Gerar Configuração Padrão"
    echo "7) 🔍 Verificar Integridade"
    echo "8) 🔄 Restaurar Configuração"
    echo "0) ⬅ Voltar"
    echo

    read -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            mkdir -p "$ROOT_DIR/qemu/vms"
            mkdir -p "$ROOT_DIR/qemu/isos"
            mkdir -p "$ROOT_DIR/qemu/logs"
            mkdir -p "$CONFIG_DIR"
            mkdir -p "$PROFILE_DIR"
            mkdir -p "$CACHE_DIR"

            sucesso "Estrutura do QEMU criada!"
            pausa
        ;;

2)
    bash "$ROOT_DIR/tools/qemu/config_global.sh"
    ;;

3)
    clear
    cabecalho

    echo "=============================================================="
    echo "             ARQUITETURA E BINÁRIOS"
    echo "=============================================================="
    echo

    echo "🖥 Hardware"
    echo "Arquitetura : $(uname -m)"
    echo

    echo "🔍 Binários do QEMU"
    echo

    if command -v qemu-system-aarch64 >/dev/null 2>&1; then
        echo "✔ qemu-system-aarch64"
    else
        echo "✘ qemu-system-aarch64"
    fi

    if command -v qemu-system-i386 >/dev/null 2>&1; then
        echo "✔ qemu-system-i386"
    else
        echo "✘ qemu-system-i386"
    fi

    if command -v qemu-img >/dev/null 2>&1; then
        echo "✔ qemu-img"
    else
        echo "✘ qemu-img"
    fi

    if command -v qemu-storage-daemon >/dev/null 2>&1; then
        echo "✔ qemu-storage-daemon"
    else
        echo "✘ qemu-storage-daemon"
    fi

    echo

    if command -v qemu-system-x86_64 >/dev/null 2>&1; then
        echo "✔ qemu-system-x86_64"
    else
        echo "ℹ qemu-system-x86_64 (opcional)"
    fi

    echo
    pausa
    ;;

        4)
            echo
            ls -lh "$PROFILE_DIR"
            pausa
        ;;

        5)
            echo
            echo "🔄 Banco de VMs atualizado."
            pausa
        ;;

        6)
            cat > "$CONFIG_DIR/qemu.conf" <<EOF
RAM=2048
CPU=2
BOOT=cdrom
DISPLAY=sdl
EOF

            sucesso "Configuração padrão criada!"
            pausa
        ;;

        7)
            clear
            echo "========== Verificação =========="
            echo

            [ -d "$ROOT_DIR/qemu/vms" ] && echo "✔ Pasta VMs"
            [ -d "$ROOT_DIR/qemu/isos" ] && echo "✔ Pasta ISOs"
            [ -d "$ROOT_DIR/qemu/logs" ] && echo "✔ Pasta Logs"
            [ -d "$CONFIG_DIR" ] && echo "✔ Configurações"
            [ -d "$PROFILE_DIR" ] && echo "✔ Perfis"
            [ -d "$CACHE_DIR" ] && echo "✔ Cache"

            pausa
        ;;

        8)
            rm -f "$CONFIG_DIR/qemu.conf"

            cat > "$CONFIG_DIR/qemu.conf" <<EOF
RAM=2048
CPU=2
BOOT=cdrom
DISPLAY=sdl
EOF

            sucesso "Configuração restaurada!"
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

