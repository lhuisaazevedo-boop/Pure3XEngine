#!/data/data/com.termux/files/usr/bin/bash

clear

# ============================================================
# P3XE - LOGS MANAGER
# Pure3XEngine 0.2.6 Alpha
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_DIR="$ROOT_DIR/logs"

mkdir -p "$LOG_DIR"

while true; do
    clear

    echo "============================================================"
    echo "📄 P3XE - LOGS MANAGER"
    echo "============================================================"
    echo "Projeto : $ROOT_DIR"
    echo "Logs    : $LOG_DIR"
    echo

    # --------------------------------------------------------
    # ESTATÍSTICAS
    # --------------------------------------------------------

    TOTAL_LOGS=$(find "$LOG_DIR" -maxdepth 1 -type f 2>/dev/null | wc -l)
    TOTAL_TXT=$(find "$LOG_DIR" -maxdepth 1 -type f -name "*.txt" 2>/dev/null | wc -l)
    TOTAL_LOG=$(find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" 2>/dev/null | wc -l)

    TAMANHO=$(du -sh "$LOG_DIR" 2>/dev/null | awk '{print $1}')
    [ -z "$TAMANHO" ] && TAMANHO="0"

    echo "📊 ESTATÍSTICAS"
    echo "------------------------------------------------------------"
    echo "Arquivos       : $TOTAL_LOGS"
    echo "Relatórios TXT : $TOTAL_TXT"
    echo "Logs .log      : $TOTAL_LOG"
    echo "Tamanho        : $TAMANHO"
    echo

    # --------------------------------------------------------
    # ÚLTIMOS LOGS
    # --------------------------------------------------------

    echo "📂 LOGS RECENTES"
    echo "------------------------------------------------------------"

    if [ "$TOTAL_LOGS" -eq 0 ]; then
        echo "⚠ Nenhum log encontrado."
    else
        find "$LOG_DIR" \
            -maxdepth 1 \
            -type f \
            -printf '%T@ %f\n' 2>/dev/null |
            sort -nr |
            head -10 |
            cut -d' ' -f2-
    fi

    echo
    echo "============================================================"
    echo "1) 📖 Abrir log"
    echo "2) 📋 Listar todos"
    echo "3) 🔎 Ver último log"
    echo "4) 🧹 Limpar logs"
    echo "5) 📊 Atualizar"
    echo
    echo "0) ↩ Voltar"
    echo "============================================================"
    echo

    read -r -p "Escolha uma opção: " OPCAO

    case "$OPCAO" in

        # ====================================================
        # ABRIR LOG
        # ====================================================

        1)
            clear

            echo "============================================================"
            echo "📖 ABRIR LOG"
            echo "============================================================"
            echo

            mapfile -t LOGS < <(
                find "$LOG_DIR" \
                    -maxdepth 1 \
                    -type f \
                    -printf '%T@ %p\n' 2>/dev/null |
                    sort -nr |
                    cut -d' ' -f2-
            )

            if [ "${#LOGS[@]}" -eq 0 ]; then
                echo "⚠ Nenhum log encontrado."
                echo
                read -r -p "Pressione ENTER para voltar..."
                continue
            fi

            for i in "${!LOGS[@]}"; do
                printf "%2d) %s\n" \
                    "$((i + 1))" \
                    "$(basename "${LOGS[$i]}")"
            done

            echo
            read -r -p "Número do log (0 para voltar): " NUM

            [ "$NUM" = "0" ] && continue

            if [[ "$NUM" =~ ^[0-9]+$ ]] &&
               [ "$NUM" -ge 1 ] &&
               [ "$NUM" -le "${#LOGS[@]}" ]; then

                LOG="${LOGS[$((NUM - 1))]}"

                clear
                echo "============================================================"
                echo "📄 $(basename "$LOG")"
                echo "============================================================"
                echo

                if command -v less >/dev/null 2>&1; then
                    less "$LOG"
                else
                    cat "$LOG"
                    echo
                    read -r -p "Pressione ENTER para voltar..."
                fi
            else
                echo
                echo "❌ Opção inválida."
                sleep 1
            fi
            ;;

        # ====================================================
        # LISTAR TODOS
        # ====================================================

        2)
            clear

            echo "============================================================"
            echo "📋 TODOS OS LOGS"
            echo "============================================================"
            echo

            find "$LOG_DIR" \
                -maxdepth 1 \
                -type f \
                -printf '%TY-%Tm-%Td %TH:%TM  %f\n' 2>/dev/null |
                sort -r

            echo
            read -r -p "Pressione ENTER para voltar..."
            ;;

        # ====================================================
        # ÚLTIMO LOG
        # ====================================================

        3)
            ULTIMO=$(
                find "$LOG_DIR" \
                    -maxdepth 1 \
                    -type f \
                    -printf '%T@ %p\n' 2>/dev/null |
                    sort -nr |
                    head -1 |
                    cut -d' ' -f2-
            )

            clear

            if [ -n "$ULTIMO" ] && [ -f "$ULTIMO" ]; then
                echo "============================================================"
                echo "🔎 ÚLTIMO LOG"
                echo "============================================================"
                echo "Arquivo: $(basename "$ULTIMO")"
                echo

                if command -v less >/dev/null 2>&1; then
                    less "$ULTIMO"
                else
                    cat "$ULTIMO"
                    echo
                    read -r -p "Pressione ENTER para voltar..."
                fi
            else
                echo "⚠ Nenhum log encontrado."
                echo
                read -r -p "Pressione ENTER para voltar..."
            fi
            ;;

        # ====================================================
        # LIMPAR
        # ====================================================

        4)
            clear

            echo "============================================================"
            echo "🧹 LIMPAR LOGS"
            echo "============================================================"
            echo
            echo "Arquivos encontrados: $TOTAL_LOGS"
            echo

            if [ "$TOTAL_LOGS" -eq 0 ]; then
                echo "⚠ Não existem logs para remover."
                echo
                read -r -p "Pressione ENTER para voltar..."
                continue
            fi

            read -r -p "Remover todos os logs? [s/N]: " CONFIRMA

            case "$CONFIRMA" in
                s|S|sim|SIM)
                    find "$LOG_DIR" -maxdepth 1 -type f -delete
                    echo
                    echo "✅ Logs removidos."
                    sleep 1
                    ;;
                *)
                    echo
                    echo "Operação cancelada."
                    sleep 1
                    ;;
            esac
            ;;

        # ====================================================
        # ATUALIZAR
        # ====================================================

        5)
            continue
            ;;

        # ====================================================
        # VOLTAR
        # ====================================================

        0)
            clear
            exit 0
            ;;

        *)
            echo
            echo "❌ Opção inválida."
            sleep 1
            ;;
    esac
done
