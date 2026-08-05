#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Pure3XEngine
# Configurações Globais do QEMU
# ==========================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$ROOT_DIR/tools/common/init.sh"

CONFIG_DIR="$ROOT_DIR/qemu/config"
CONFIG_FILE="$CONFIG_DIR/qemu.conf"

mkdir -p "$CONFIG_DIR"

# ==========================================================
# Configuração padrão
# ==========================================================

if [ ! -f "$CONFIG_FILE" ]; then

cat > "$CONFIG_FILE" <<EOF
RAM=2048
CPU=2
BOOT=cdrom
DISPLAY=sdl
NETWORK=user
AUDIO=on
EOF

fi

# ==========================================================
# Detecta informações do dispositivo
# ==========================================================

CPU_MAX=$(nproc 2>/dev/null)
[ -z "$CPU_MAX" ] && CPU_MAX=1

MEM_TOTAL=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)

[ -z "$MEM_TOTAL" ] && MEM_TOTAL=0

# ==========================================================
# Menu Principal
# ==========================================================

while true
do

    clear
    cabecalho

    # Carrega configurações atuais
    RAM_ATUAL=$(grep '^RAM=' "$CONFIG_FILE" | cut -d= -f2)
    CPU_ATUAL=$(grep '^CPU=' "$CONFIG_FILE" | cut -d= -f2)
    BOOT_ATUAL=$(grep '^BOOT=' "$CONFIG_FILE" | cut -d= -f2)
    DISPLAY_ATUAL=$(grep '^DISPLAY=' "$CONFIG_FILE" | cut -d= -f2)
    NETWORK_ATUAL=$(grep '^NETWORK=' "$CONFIG_FILE" | cut -d= -f2)
    AUDIO_ATUAL=$(grep '^AUDIO=' "$CONFIG_FILE" | cut -d= -f2)

    echo "=============================================================="
    echo "            CONFIGURAÇÕES GLOBAIS DO QEMU"
    echo "=============================================================="
    echo

    echo "RAM...............: ${RAM_ATUAL:-2048} MB"
    echo "CPU...............: ${CPU_ATUAL:-2} núcleo(s)"
    echo "Máximo de CPU.....: $CPU_MAX"
    echo "Memória do aparelho: ${MEM_TOTAL} MB"
    echo "Boot..............: ${BOOT_ATUAL:-cdrom}"
    echo "Display...........: ${DISPLAY_ATUAL:-sdl}"
    echo "Rede..............: ${NETWORK_ATUAL:-user}"
    echo "Áudio.............: ${AUDIO_ATUAL:-on}"
    echo

    echo "--------------------------------------------------------------"
    echo "               MENU DE CONFIGURAÇÕES"
    echo "--------------------------------------------------------------"
    echo
    echo " 1) 🧠 Memória RAM"
    echo " 2) ⚙️  Processador (CPU)"
    echo " 3) 💿 Inicialização (Boot)"
    echo " 4) 🖥️  Vídeo / Display"
    echo " 5) 🌐 Rede"
    echo " 6) 🔊 Áudio"
    echo " 7) ♻ Restaurar configurações padrão"
    echo " 8) 📄 Visualizar qemu.conf"
    echo " 9) 💾 Salvar configurações"
    echo "10) ℹ Informações do dispositivo"
    echo
    echo " 0) ⬅ Voltar"
    echo
    read -rp "Escolha uma opção: " op

    case "$op" in

        1)
            clear
            cabecalho

            echo "========================================================"
            echo "              CONFIGURAR MEMÓRIA RAM"
            echo "========================================================"
            echo
            echo "RAM Atual: ${RAM_ATUAL} MB"
            echo
            echo "1) 256 MB"
            echo "2) 512 MB"
            echo "3) 1024 MB (1 GB)"
            echo "4) 2048 MB (2 GB)"
            echo "5) 4096 MB (4 GB)"
            echo "6) 8192 MB (8 GB)"
            echo "7) Personalizado"
            echo "0) Voltar"
            echo

            read -rp "Escolha: " ram_op

            case "$ram_op" in
                1) valor=256 ;;
                2) valor=512 ;;
                3) valor=1024 ;;
                4) valor=2048 ;;
                5) valor=4096 ;;
                6) valor=8192 ;;
                7)
                    read -rp "Digite a RAM em MB: " valor
                    ;;
                0)
                    continue
                    ;;
                *)
                    erro "Opção inválida!"
                    pausa
                    continue
                    ;;
            esac

            if [[ "$valor" =~ ^[0-9]+$ ]] && [ "$valor" -gt 0 ]; then
                sed -i "s/^RAM=.*/RAM=$valor/" "$CONFIG_FILE"
                sucesso "RAM alterada para ${valor} MB!"
            else
                erro "Valor inválido!"
            fi

            pausa
            ;;
        2)
            clear
            cabecalho

            echo "========================================================"
            echo "              CONFIGURAR PROCESSADOR"
            echo "========================================================"
            echo
            echo "CPU Atual: ${CPU_ATUAL} núcleo(s)"
            echo "Máximo disponível: ${CPU_MAX}"
            echo

            for ((i=1; i<=CPU_MAX; i++)); do
                echo "$i) $i núcleo(s)"
            done

            echo
            echo "0) Voltar"
            echo

            read -rp "Escolha: " cpu_op

            if [ "$cpu_op" = "0" ]; then
                continue
            fi

            if [[ "$cpu_op" =~ ^[0-9]+$ ]] && [ "$cpu_op" -ge 1 ] && [ "$cpu_op" -le "$CPU_MAX" ]; then
                sed -i "s/^CPU=.*/CPU=$cpu_op/" "$CONFIG_FILE"
                sucesso "CPU alterada para $cpu_op núcleo(s)!"
            else
                erro "Valor inválido!"
            fi

            pausa
            ;;
        3)
            clear
            cabecalho

            echo "========================================================"
            echo "               CONFIGURAR BOOT"
            echo "========================================================"
            echo
            echo "Boot Atual: ${BOOT_ATUAL}"
            echo
            echo "1) Disco Rígido (disk)"
            echo "2) CD/DVD (cdrom)"
            echo "3) Rede PXE (network)"
            echo
            echo "0) Voltar"
            echo

            read -rp "Escolha: " boot_op

            case "$boot_op" in
                1) valor="disk" ;;
                2) valor="cdrom" ;;
                3) valor="network" ;;
                0) continue ;;
                *)
                    erro "Opção inválida!"
                    pausa
                    continue
                    ;;
            esac

            sed -i "s/^BOOT=.*/BOOT=$valor/" "$CONFIG_FILE"
            sucesso "Boot alterado para $valor!"

            pausa
            ;;
        4)
            clear
            cabecalho

            echo "========================================================"
            echo "              CONFIGURAR DISPLAY"
            echo "========================================================"
            echo
            echo "Display Atual: ${DISPLAY_ATUAL}"
            echo
            echo "1) SDL"
            echo "2) GTK"
            echo "3) VNC"
            echo "4) Cocoa (macOS)"
            echo "5) Nenhum (none)"
            echo
            echo "0) Voltar"
            echo

            read -rp "Escolha: " display_op

            case "$display_op" in
                1) valor="sdl" ;;
                2) valor="gtk" ;;
                3) valor="vnc" ;;
                4) valor="cocoa" ;;
                5) valor="none" ;;
                0) continue ;;
                *)
                    erro "Opção inválida!"
                    pausa
                    continue
                    ;;
            esac

            sed -i "s/^DISPLAY=.*/DISPLAY=$valor/" "$CONFIG_FILE"

            sucesso "Display alterado para $valor!"

            pausa
            ;;
        5)
            clear
            cabecalho

            echo "========================================================"
            echo "               CONFIGURAR REDE"
            echo "========================================================"
            echo
            echo "Rede Atual: ${NETWORK_ATUAL}"
            echo
            echo "1) User (NAT)"
            echo "2) Bridge"
            echo "3) TAP"
            echo "4) Socket"
            echo "5) Nenhuma"
            echo
            echo "0) Voltar"
            echo

            read -rp "Escolha: " rede_op

            case "$rede_op" in
                1) valor="user" ;;
                2) valor="bridge" ;;
                3) valor="tap" ;;
                4) valor="socket" ;;
                5) valor="none" ;;
                0) continue ;;
                *)
                    erro "Opção inválida!"
                    pausa
                    continue
                    ;;
            esac

            sed -i "s/^NETWORK=.*/NETWORK=$valor/" "$CONFIG_FILE"

            sucesso "Rede alterada para $valor!"

            pausa
            ;;
        6)
            clear
            cabecalho

            echo "========================================================"
            echo "               CONFIGURAR ÁUDIO"
            echo "========================================================"
            echo
            echo "Áudio Atual: ${AUDIO_ATUAL}"
            echo
            echo "1) Ligado (on)"
            echo "2) Desligado (off)"
            echo "3) SB16"
            echo "4) AC97"
            echo "5) ES1370"
            echo "6) Intel HDA"
            echo "0) Voltar"
            echo

            read -rp "Escolha: " audio_op

            case "$audio_op" in
                1) valor="on" ;;
                2) valor="off" ;;
                3) valor="sb16" ;;
                4) valor="ac97" ;;
                5) valor="es1370" ;;
                6) valor="intel-hda" ;;
                0) continue ;;
                *)
                    erro "Opção inválida!"
                    pausa
                    continue
                    ;;
            esac

            sed -i "s/^AUDIO=.*/AUDIO=$valor/" "$CONFIG_FILE"

            sucesso "Áudio alterado para $valor!"

            pausa
            ;;
        7)
            clear
            cabecalho

            echo "========================================================"
            echo "          ♻ RESTAURAR CONFIGURAÇÕES PADRÃO"
            echo "========================================================"
            echo
            echo "Esta ação irá restaurar todas as configurações"
            echo "para os valores originais do QEMU."
            echo
            echo "Configurações que serão restauradas:"
            echo
            echo "  • RAM..............: 2048 MB"
            echo "  • CPU..............: 2 núcleo(s)"
            echo "  • Boot.............: cdrom"
            echo "  • Display..........: sdl"
            echo "  • Rede.............: user"
            echo "  • Áudio............: on"
            echo
            echo -e "${AMARELO}⚠️  Todas as alterações atuais serão perdidas.${RESET}"
            echo
            read -rp "Confirma a restauração? (s/N): " resp

            if [[ "${resp,,}" =~ ^(s|sim)$ ]]; then
                cat > "$CONFIG_FILE" <<EOF
RAM=2048
CPU=2
BOOT=cdrom
DISPLAY=sdl
NETWORK=user
AUDIO=on
EOF
                sucesso "Configurações restauradas para o padrão!"
            else
                aviso "Operação cancelada pelo usuário."
            fi
            pausa
            ;;

        8)
            clear
            cabecalho

            echo "========================================================"
            echo "             CONFIGURAÇÃO ATUAL DO QEMU"
            echo "========================================================"
            echo

            while IFS='=' read -r chave valor
            do
                printf "%-15s : %s\n" "$chave" "$valor"
            done < "$CONFIG_FILE"

            echo
            echo "--------------------------------------------------------"
            echo "Arquivo: $CONFIG_FILE"
            echo

            pausa
            ;;
        9)
            clear
            cabecalho

            BACKUP_DIR="$CONFIG_DIR/backups"
            mkdir -p "$BACKUP_DIR"

            BACKUP_FILE="$BACKUP_DIR/qemu_$(date +%Y%m%d_%H%M%S).conf"

            cp "$CONFIG_FILE" "$BACKUP_FILE"

            sync

            echo "========================================================"
            echo "             CONFIGURAÇÕES SALVAS"
            echo "========================================================"
            echo
            echo "Arquivo atual:"
            echo "  $CONFIG_FILE"
            echo
            echo "Backup criado:"
            echo "  $BACKUP_FILE"
            echo

            sucesso "Configurações salvas com sucesso!"

            pausa
            ;;

        10)
            clear
            cabecalho

            echo "========================================================"
            echo "             INFORMAÇÕES DO DISPOSITIVO"
            echo "========================================================"
            echo
            echo "CPU Máxima.......: $CPU_MAX núcleo(s)"
            echo "Memória Total....: ${MEM_TOTAL} MB"
            echo "Diretório........: $ROOT_DIR"
            echo "Arquivo..........: $CONFIG_FILE"
            echo
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
