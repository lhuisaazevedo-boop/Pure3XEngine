#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine - Utilities Center
# Módulo 10 - Informações de Log
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

clear

linha() {
    echo "============================================================"
}

pausar_logs() {
    linha
    echo "Pressione ENTER para voltar ao Utilities Center..."
    linha
    read -r
}

linha
echo "📋 INFORMAÇÕES DE LOG"
linha
echo
echo "Projeto : $ROOT_DIR"
echo

# ============================================================
# ARQUIVOS DE LOG
# ============================================================

linha
echo "🔎 LOGS ENCONTRADOS"
linha
echo

LOG_FILES=()

while IFS= read -r -d '' arquivo; do
    LOG_FILES+=("$arquivo")
done < <(
    find "$ROOT_DIR" -type f \
        \( \
            -iname "*.log" \
            -o -iname "*.err" \
            -o -iname "*.out" \
            -o -iname "*log*.txt" \
            -o -iname "*error*.txt" \
        \) \
        -not -path "$ROOT_DIR/.git/*" \
        -print0 2>/dev/null
)

TOTAL_LOGS="${#LOG_FILES[@]}"

echo "Arquivos de log encontrados : $TOTAL_LOGS"
echo

if [ "$TOTAL_LOGS" -gt 0 ]; then
    for arquivo in "${LOG_FILES[@]}"; do
        tamanho="$(du -h "$arquivo" 2>/dev/null | cut -f1)"
        [ -z "$tamanho" ] && tamanho="?"

        relativo="${arquivo#$ROOT_DIR/}"

        printf "%-8s %s\n" "$tamanho" "$relativo"
    done
else
    echo "Nenhum arquivo de log encontrado."
fi

echo

# ============================================================
# CONTAGEM DE ERROS E AVISOS
# ============================================================

TOTAL_ERRORS=0
TOTAL_WARNINGS=0

if [ "$TOTAL_LOGS" -gt 0 ]; then

    for arquivo in "${LOG_FILES[@]}"; do

        erros="$(
            grep -Eic \
            'error|fatal|failed|failure|exception|segmentation fault|abort|undefined reference|cannot|denied' \
            "$arquivo" 2>/dev/null
        )"

        avisos="$(
            grep -Eic \
            'warning|warn|deprecated' \
            "$arquivo" 2>/dev/null
        )"

        [ -z "$erros" ] && erros=0
        [ -z "$avisos" ] && avisos=0

        TOTAL_ERRORS=$((TOTAL_ERRORS + erros))
        TOTAL_WARNINGS=$((TOTAL_WARNINGS + avisos))

    done
fi

linha
echo "🚨 DIAGNÓSTICO DOS LOGS"
linha
echo

echo "Erros encontrados  : $TOTAL_ERRORS"
echo "Avisos encontrados : $TOTAL_WARNINGS"
echo

# ============================================================
# FUNÇÃO PARA MOSTRAR ERROS
# ============================================================

mostrar_erros() {

    local titulo="$1"
    local filtro="$2"

    linha
    echo "$titulo"
    linha
    echo

    local encontrou=0

    for arquivo in "${LOG_FILES[@]}"; do

        relativo="${arquivo#$ROOT_DIR/}"

        if echo "$relativo" | grep -Eqi "$filtro"; then

            resultado="$(
                grep -Ein \
                'error|fatal|failed|failure|exception|segmentation fault|abort|undefined reference|cannot|denied' \
                "$arquivo" 2>/dev/null |
                tail -10
            )"

            if [ -n "$resultado" ]; then

                echo "Arquivo:"
                echo "$relativo"
                echo

                echo "$resultado"
                echo

                encontrou=1
            fi
        fi

    done

    if [ "$encontrou" -eq 0 ]; then
        echo "Nenhum erro registrado nesta categoria."
    fi

    echo
}

# ============================================================
# P3XE
# ============================================================

mostrar_erros \
    "🎮 P3XE EMULADOR" \
    'p3xe|pure3x|coreemulator|emulator|renderer|rsx|ppu|spu'

# ============================================================
# ANDROID / GRADLE / CMAKE
# ============================================================

mostrar_erros \
    "🤖 ANDROID / GRADLE / CMAKE" \
    'android|gradle|cmake|build|apk|jni|ndk'

# ============================================================
# QEMU CENTER
# ============================================================

mostrar_erros \
    "🖥️ QEMU CENTER" \
    'qemu|qemucenter|msdos|vm'

# ============================================================
# ÚLTIMOS ERROS GERAIS
# ============================================================

linha
echo "🔬 ÚLTIMOS ERROS GERAIS"
linha
echo

ERROS_EXIBIDOS=0

for arquivo in "${LOG_FILES[@]}"; do

    resultado="$(
        grep -Ein \
        'error|fatal|failed|failure|exception|segmentation fault|abort|undefined reference|cannot|denied' \
        "$arquivo" 2>/dev/null |
        tail -5
    )"

    if [ -n "$resultado" ]; then

        relativo="${arquivo#$ROOT_DIR/}"

        echo "[$relativo]"
        echo "$resultado"
        echo

        ERROS_EXIBIDOS=$((ERROS_EXIBIDOS + 1))

        # Evita despejar centenas de logs na tela.
        if [ "$ERROS_EXIBIDOS" -ge 10 ]; then
            break
        fi
    fi

done

if [ "$ERROS_EXIBIDOS" -eq 0 ]; then
    echo "Nenhum erro encontrado nos logs."
    echo
fi

# ============================================================
# RESUMO
# ============================================================

linha
echo "📊 RESUMO"
linha
echo

echo "Arquivos de log : $TOTAL_LOGS"
echo "Erros           : $TOTAL_ERRORS"
echo "Avisos          : $TOTAL_WARNINGS"
echo

if [ "$TOTAL_ERRORS" -eq 0 ]; then
    ESTADO="OK"
else
    ESTADO="ATENÇÃO"
fi

echo "P3XE / Projeto   : Preservado"
echo "Logs             : Somente leitura"
echo "Estado           : $ESTADO"
echo

linha
echo "Pressione ENTER para voltar ao Utilities Center..."
linha
read -r

exit 0
