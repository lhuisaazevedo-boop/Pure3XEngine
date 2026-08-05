#!/data/data/com.termux/files/usr/bin/bash
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

ISO_DIR="$ROOT_DIR/qemu/isos"
VM_DIR="$ROOT_DIR/qemu/vms/msdos"
CONFIG_ISO="$VM_DIR/iso.conf"

mkdir -p "$ISO_DIR"
mkdir -p "$VM_DIR"

while true
do
    clear
    cabecalho
    echo "=================================================="
    echo "        💿 SELECIONAR ISO — MS-DOS"
    echo "=================================================="
    echo

    # Lista ISOs numeradas
    mapfile -t LISTA_ISOS < <(ls -1 "$ISO_DIR"/*.iso 2>/dev/null)

    if [ ${#LISTA_ISOS[@]} -eq 0 ]; then
        echo -e "${AMARELO}⚠️ Nenhuma ISO encontrada em: $ISO_DIR${RESET}"
        echo "   Coloque o arquivo .iso na pasta e tente novamente."
        echo
        echo "0) Voltar"
        read -p "Escolha: " op
        [ "$op" = "0" ] && break
        pausa
        continue
    fi

    echo "ISOs disponíveis:"
    for i in "${!LISTA_ISOS[@]}"; do
        echo " $((i+1))) $(basename "${LISTA_ISOS[$i]}")"
    done
    echo
    echo "0) Voltar"
    echo

    read -p "Digite o número da ISO desejada: " op

    [ "$op" = "0" ] && break

    # Valida e pega o arquivo
    INDICE=$((op - 1))
    if [ -n "${LISTA_ISOS[$INDICE]}" ]; then
        echo "iso=${LISTA_ISOS[$INDICE]}" > "$CONFIG_ISO"
        sucesso "ISO selecionada com sucesso!"
        echo -e "${VERDE}✅ Arquivo: $(basename "${LISTA_ISOS[$INDICE]}")${RESET}"
    else
        erro "Número inválido! Tente novamente."
    fi

    pausa
done

