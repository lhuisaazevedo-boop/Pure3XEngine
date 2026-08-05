#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"
CONF="$VM_DIR/disco.conf"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                    DISCO VIRTUAL"
    echo "=============================================================="
    echo

    mapfile -t DISCOS < <(
        find "$VM_DIR" -maxdepth 1 \( -name "*.qcow2" -o -name "*.img" \) | sort
    )

    if [ -f "$CONF" ]; then
        source "$CONF"
        echo "Disco atual:"
        echo "  $(basename "$DISCO")"
    else
        echo "Disco atual: Nenhum"
    fi

    echo
    echo "1) Criar novo disco"
    echo "2) Selecionar disco"
    echo "3) Informações do disco"
    echo "4) Excluir disco"
    echo "0) Voltar"
    echo

    read -p "Escolha uma opção: " OP

    case "$OP" in

    1)
        echo
        read -p "Nome do disco (sem extensão): " NOME

        [ -z "$NOME" ] && continue

        echo
        echo "Tamanho:"
        echo "1) 64 MB"
        echo "2) 128 MB"
        echo "3) 256 MB"
        echo "4) 512 MB"
        echo "5) 1 GB"
        echo "6) Personalizado"
        echo

        read -p "Escolha: " TAM

        case "$TAM" in
            1) SIZE="64M" ;;
            2) SIZE="128M" ;;
            3) SIZE="256M" ;;
            4) SIZE="512M" ;;
            5) SIZE="1G" ;;
            6)
                read -p "Digite o tamanho (ex: 2G, 700M): " SIZE
                ;;
            *)
                erro "Opção inválida!"
                pausa
                continue
                ;;
        esac

        qemu-img create -f qcow2 "$VM_DIR/$NOME.qcow2" "$SIZE"

        cat > "$CONF" <<EOF
DISCO=$VM_DIR/$NOME.qcow2
EOF

        sucesso "Disco criado com sucesso!"
        pausa
        ;;

    2)

        if [ "${#DISCOS[@]}" -eq 0 ]; then
            aviso "Nenhum disco encontrado."
            pausa
            continue
        fi

        echo

        for i in "${!DISCOS[@]}"; do
            echo "$((i+1))) $(basename "${DISCOS[$i]}")"
        done

        echo
        read -p "Escolha: " IDX

        IDX=$((IDX-1))

        if [ "$IDX" -ge 0 ] && [ "$IDX" -lt "${#DISCOS[@]}" ]; then

            cat > "$CONF" <<EOF
DISCO=${DISCOS[$IDX]}
EOF

            sucesso "Disco selecionado!"
        else
            erro "Opção inválida!"
        fi

        pausa
        ;;

    3)

        if [ ! -f "$CONF" ]; then
            aviso "Nenhum disco selecionado."
            pausa
            continue
        fi

        source "$CONF"

        echo
        echo "Nome: $(basename "$DISCO")"
        echo "Caminho:"
        echo "$DISCO"

        if [ -f "$DISCO" ]; then
            echo
            ls -lh "$DISCO"
            echo
            qemu-img info "$DISCO"
        fi

        pausa
        ;;

    4)

        if [ "${#DISCOS[@]}" -eq 0 ]; then
            aviso "Nenhum disco encontrado."
            pausa
            continue
        fi

        echo

        for i in "${!DISCOS[@]}"; do
            echo "$((i+1))) $(basename "${DISCOS[$i]}")"
        done

        echo
        read -p "Excluir qual disco: " IDX

        IDX=$((IDX-1))

        if [ "$IDX" -ge 0 ] && [ "$IDX" -lt "${#DISCOS[@]}" ]; then

            rm -f "${DISCOS[$IDX]}"

            sucesso "Disco removido."

            [ -f "$CONF" ] && rm -f "$CONF"

        else
            erro "Opção inválida!"
        fi

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
