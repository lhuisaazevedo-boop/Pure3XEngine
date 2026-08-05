#!/data/data/com.termux/files/usr/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/init.sh"
#!/data/data/com.termux/files/usr/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/init.sh"

# Diretórios
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
VM_DIR="$ROOT_DIR/qemu/vms"
mkdir -p "$VM_DIR"

# ==========================================================
# MENU DE CRIAÇÃO RÁPIDA
# ==========================================================
while true; do
    clear
    cabecalho
    echo -e "${AZUL}==========================================================${RESET}"
    echo -e "${AZUL}       💿 CRIADOR RÁPIDO DE DISCO VIRTUAL — QEMU${RESET}"
    echo -e "${AZUL}==========================================================${RESET}"
    echo

    echo "1) 🖥️ MS-DOS 6.31        → 500MB"
    echo "2) 🪟 Windows 95        → 2GB"
    echo "3) 🪟 Windows 98 SE     → 4GB"
    echo "4) 🪟 Windows 2000      → 8GB"
    echo "5) 🪟 Windows XP        → 16GB"
    echo "6) 🪟 Windows 7         → 32GB"
    echo "7) 🐧 Ubuntu            → 40GB"
    echo "8) 🐧 Debian            → 20GB"
    echo "9) 🐧 Arch Linux        → 20GB"
    echo "10) 🐧 Fedora           → 30GB"
    echo "11) ✏️  Definir nome e tamanho manualmente"
    echo "0) ⬅️ Voltar ao Menu Anterior"
    echo

    read -p "Escolha uma opção: " op_disco

    case "$op_disco" in
        1)
            NOME="msdos631.qcow2"
            TAM="500M"
            SISTEMA="MS-DOS 6.31"
            ;;
        2)
            NOME="windows95.qcow2"
            TAM="2G"
            SISTEMA="Windows 95"
            ;;
        3)
            NOME="windows98.qcow2"
            TAM="4G"
            SISTEMA="Windows 98 SE"
            ;;
        4)
            NOME="windows2000.qcow2"
            TAM="8G"
            SISTEMA="Windows 2000"
            ;;
        5)
            NOME="windowsxp.qcow2"
            TAM="16G"
            SISTEMA="Windows XP"
            ;;
        6)
            NOME="windows7.qcow2"
            TAM="32G"
            SISTEMA="Windows 7"
            ;;
        7)
            NOME="ubuntu.qcow2"
            TAM="40G"
            SISTEMA="Ubuntu"
            ;;
        8)
            NOME="debian.qcow2"
            TAM="20G"
            SISTEMA="Debian"
            ;;
        9)
            NOME="archlinux.qcow2"
            TAM="20G"
            SISTEMA="Arch Linux"
            ;;
        10)
            NOME="fedora.qcow2"
            TAM="30G"
            SISTEMA="Fedora"
            ;;
        11)
            read -p "Digite o nome do arquivo (ex: meu_sistema.qcow2): " NOME
            read -p "Digite o tamanho (ex: 2G, 8G, 512M): " TAM
            SISTEMA="Personalizado: $NOME"
            ;;
        0)
            echo -e "${VERDE}Voltando...${RESET}"
            sleep 0.5
            exit 0
            ;;
        *)
            erro "Opção inválida!"
            pausa
            continue
            ;;
    esac

    # Confirmação antes de criar
    echo
    echo -e "${AMARELO}📌 Configuração escolhida:${RESET}"
    echo "   Sistema:   $SISTEMA"
    echo "   Arquivo:   $VM_DIR/$NOME"
    echo "   Tamanho:   $TAM"
    echo
    read -p "✅ Confirmar criação? (S/N): " confirma

    if [[ "$confirma" =~ ^[Ss]$ ]]; then
        if [ -f "$VM_DIR/$NOME" ]; then
            echo
            echo -e "${VERMELHO}⚠️ Arquivo já existe!${RESET}"
            read -p "Deseja sobrescrever? Isso apaga o existente! (s/N): " sobrescreve
            if [[ ! "$sobrescreve" =~ ^[Ss]$ ]]; then
                echo "Operação cancelada."
                pausa
                continue
            fi
            rm -f "$VM_DIR/$NOME"
        fi

        echo
        echo -e "${AMARELO}🔨 Criando disco...${RESET}"
        qemu-img create -f qcow2 "$VM_DIR/$NOME" "$TAM"

        if [ $? -eq 0 ]; then
            echo
            sucesso "✅ Disco criado com sucesso!"
            echo -e "${VERDE}📍 Local: $VM_DIR/$NOME${RESET}"
        else
            erro "❌ Falha ao criar o disco! Verifique se o QEMU está instalado."
        fi
    else
        echo "Operação cancelada pelo usuário."
    fi

    pausa
done

