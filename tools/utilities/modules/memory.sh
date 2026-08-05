#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine - Utilities Center
# Módulo 6 - Informações de Memória
# ============================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

echo "============================================================"
echo "🧠 INFORMAÇÕES DE MEMÓRIA"
echo "============================================================"
echo
echo "Projeto : $ROOT_DIR"
echo

# ------------------------------------------------------------
# Memória RAM
# ------------------------------------------------------------

echo "============================================================"
echo "📊 MEMÓRIA RAM"
echo "============================================================"
echo

if command -v free >/dev/null 2>&1; then
    free -h
else
    echo "Comando 'free' não disponível."
fi

echo

# ------------------------------------------------------------
# Informações detalhadas do /proc/meminfo
# ------------------------------------------------------------

echo "============================================================"
echo "🔎 DETALHES DA MEMÓRIA"
echo "============================================================"
echo

if [ -r /proc/meminfo ]; then

    MEM_TOTAL="$(grep '^MemTotal:' /proc/meminfo | awk '{print $2}')"
    MEM_FREE="$(grep '^MemFree:' /proc/meminfo | awk '{print $2}')"
    MEM_AVAILABLE="$(grep '^MemAvailable:' /proc/meminfo | awk '{print $2}')"
    BUFFERS="$(grep '^Buffers:' /proc/meminfo | awk '{print $2}')"
    CACHED="$(grep '^Cached:' /proc/meminfo | awk '{print $2}')"
    SWAP_TOTAL="$(grep '^SwapTotal:' /proc/meminfo | awk '{print $2}')"
    SWAP_FREE="$(grep '^SwapFree:' /proc/meminfo | awk '{print $2}')"

    format_kb() {
        local kb="$1"

        if [ -z "$kb" ]; then
            echo "N/D"
        elif [ "$kb" -ge 1048576 ]; then
            awk "BEGIN {printf \"%.2f GB\", $kb/1048576}"
        elif [ "$kb" -ge 1024 ]; then
            awk "BEGIN {printf \"%.2f MB\", $kb/1024}"
        else
            printf "%s KB" "$kb"
        fi
    }

    printf "%-20s %s\n" "RAM total:" "$(format_kb "$MEM_TOTAL")"
    printf "%-20s %s\n" "RAM livre:" "$(format_kb "$MEM_FREE")"
    printf "%-20s %s\n" "RAM disponível:" "$(format_kb "$MEM_AVAILABLE")"
    printf "%-20s %s\n" "Buffers:" "$(format_kb "$BUFFERS")"
    printf "%-20s %s\n" "Cache:" "$(format_kb "$CACHED")"

    echo

    printf "%-20s %s\n" "Swap total:" "$(format_kb "$SWAP_TOTAL")"
    printf "%-20s %s\n" "Swap livre:" "$(format_kb "$SWAP_FREE")"

else
    echo "Não foi possível acessar /proc/meminfo."
fi

echo

# ------------------------------------------------------------
# Uso calculado
# ------------------------------------------------------------

echo "============================================================"
echo "📈 USO ATUAL DA RAM"
echo "============================================================"
echo

if [ -n "$MEM_TOTAL" ] &&
   [ -n "$MEM_AVAILABLE" ] &&
   [ "$MEM_TOTAL" -gt 0 ]; then

    MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))

    MEM_PERCENT="$(
        awk "BEGIN {
            printf \"%.1f\", ($MEM_USED/$MEM_TOTAL)*100
        }"
    )"

    printf "%-20s %s\n" "RAM usada:" "$(format_kb "$MEM_USED")"
    printf "%-20s %s%%\n" "Uso da RAM:" "$MEM_PERCENT"

else
    echo "Não foi possível calcular o uso da RAM."
fi

echo

# ------------------------------------------------------------
# Processos do Termux com maior consumo
# ------------------------------------------------------------

echo "============================================================"
echo "⚙️ PROCESSOS COM MAIOR USO DE MEMÓRIA"
echo "============================================================"
echo

if command -v ps >/dev/null 2>&1; then

    printf "%-8s %-8s %-8s %s\n" "PID" "%MEM" "RSS" "PROCESSO"
    echo "------------------------------------------------------------"

    ps -A -o PID,%MEM,RSS,NAME 2>/dev/null |
        tail -n +2 |
        sort -k3 -nr |
        head -10

else
    echo "Comando 'ps' não disponível."
fi

echo

# ------------------------------------------------------------
# Resumo
# ------------------------------------------------------------

echo "============================================================"
echo "📋 RESUMO"
echo "============================================================"
echo

printf "%-20s %s\n" "RAM total:" "$(format_kb "$MEM_TOTAL")"
printf "%-20s %s\n" "RAM disponível:" "$(format_kb "$MEM_AVAILABLE")"

if [ -n "$MEM_USED" ]; then
    printf "%-20s %s\n" "RAM usada:" "$(format_kb "$MEM_USED")"
fi

if [ -n "$MEM_PERCENT" ]; then
    printf "%-20s %s%%\n" "Uso:" "$MEM_PERCENT"
fi

printf "%-20s %s\n" "Swap total:" "$(format_kb "$SWAP_TOTAL")"
printf "%-20s %s\n" "Swap livre:" "$(format_kb "$SWAP_FREE")"

echo
echo "============================================================"
echo "Pressione ENTER para voltar ao Utilities Center..."
echo "============================================================"

# Lê diretamente do terminal para não perder a pausa.
read -r < /dev/tty
