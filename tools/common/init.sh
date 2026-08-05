#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE - INICIALIZAÇÃO GLOBAL
# ============================================================

COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$COMMON_DIR/../.." && pwd)"

# ------------------------------------------------------------
# Módulos comuns
# ------------------------------------------------------------

[ -f "$COMMON_DIR/colors.sh" ] && \
    source "$COMMON_DIR/colors.sh"

[ -f "$COMMON_DIR/variables.sh" ] && \
    source "$COMMON_DIR/variables.sh"

[ -f "$COMMON_DIR/functions.sh" ] && \
    source "$COMMON_DIR/functions.sh"

[ -f "$COMMON_DIR/version.sh" ] && \
    source "$COMMON_DIR/version.sh"

# ------------------------------------------------------------
# Cabeçalho padrão P3XE
# ------------------------------------------------------------

cabecalho() {
    clear

    echo "============================================================"
    echo "🎮 PAINEL DE CONTROLE P3XE"

    if [ -n "${P3XE_VERSION:-}" ]; then
        echo "Pure3XEngine $P3XE_VERSION"
    else
        echo "Pure3XEngine 0.2.6 Alpha"
    fi

    echo "============================================================"
    echo
    echo "📅 Data: $(date '+%d/%m/%Y')"
    echo "🕒 Hora: $(date '+%H:%M:%S')"
    echo "📂 Projeto: $ROOT_DIR"
    echo
}
