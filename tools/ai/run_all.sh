#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# P3XE AI Center - Executar Tudo
# tools/ai/run_all.sh
# ============================================================

set +e

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
AI_DIR="$ROOT_DIR/tools/ai"

VERSION="0.2.6 Alpha"

OK=0
WARN=0
ERRORS=0
TOTAL=0

START_TIME="$(date +%s)"
LOG_DIR="$ROOT_DIR/logs/ai"
LOG_FILE="$LOG_DIR/run_all_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$LOG_DIR"

# ------------------------------------------------------------
# CORES
# ------------------------------------------------------------

RESET="\033[0m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
CYAN="\033[1;36m"
BLUE="\033[1;34m"

# ------------------------------------------------------------
# FUNÇÕES
# ------------------------------------------------------------

line() {
    printf '%*s\n' 66 '' | tr ' ' '='
}

separator() {
    printf '%*s\n' 66 '' | tr ' ' '-'
}

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

success() {
    OK=$((OK + 1))
    log "${GREEN}✅ $1${RESET}"
}

warning() {
    WARN=$((WARN + 1))
    log "${YELLOW}⚠️ $1${RESET}"
}

error() {
    ERRORS=$((ERRORS + 1))
    log "${RED}❌ $1${RESET}"
}

section() {
    echo
    log "${CYAN}$1${RESET}"
    separator | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------
# EXECUTOR
# ------------------------------------------------------------

run_tool() {

    local NAME="$1"
    local SCRIPT="$2"
    local CRITICAL="${3:-no}"

    TOTAL=$((TOTAL + 1))

    section "⚙️ $NAME"

    if [ ! -f "$SCRIPT" ]; then
        error "Script não encontrado: $SCRIPT"

        if [ "$CRITICAL" = "yes" ]; then
            warning "Etapa crítica ausente"
        fi

        return 1
    fi

    if [ ! -x "$SCRIPT" ]; then
        chmod +x "$SCRIPT" 2>/dev/null
    fi

    log "Executando: ${SCRIPT#$ROOT_DIR/}"
    echo

    bash "$SCRIPT"
    STATUS=$?

    echo

    if [ "$STATUS" -eq 0 ]; then
        success "$NAME concluído"
        return 0
    fi

    if [ "$STATUS" -eq 1 ]; then
        warning "$NAME terminou com avisos"
        return 1
    fi

    error "$NAME terminou com código $STATUS"

    if [ "$CRITICAL" = "yes" ]; then
        warning "Problema crítico detectado em $NAME"
    fi

    return "$STATUS"
}

# ------------------------------------------------------------
# CABEÇALHO
# ------------------------------------------------------------

clear

line
echo "⚡ P3XE - EXECUTAR TUDO"
echo "Pure3XEngine $VERSION"
line

echo
echo "📅 Data    : $(date '+%d/%m/%Y')"
echo "🕒 Hora    : $(date '+%H:%M:%S')"
echo "📂 Projeto : $ROOT_DIR"
echo "📝 Log     : $LOG_FILE"

# ------------------------------------------------------------
# VERIFICAÇÃO DO AI CENTER
# ------------------------------------------------------------

section "🤖 AI CENTER"

TOOLS_FOUND=0

for SCRIPT in \
    doctor.sh \
    fixer.sh \
    builder.sh \
    publisher.sh \
    readme_generator.sh \
    project_report.sh \
    error_analyzer.sh \
    optimizer.sh
do
    if [ -f "$AI_DIR/$SCRIPT" ]; then
        success "$SCRIPT"
        TOOLS_FOUND=$((TOOLS_FOUND + 1))
    else
        warning "$SCRIPT não encontrado"
    fi
done

echo
log "Ferramentas encontradas: $TOOLS_FOUND / 8"

# ------------------------------------------------------------
# ETAPA 1 - DOCTOR
# ------------------------------------------------------------

run_tool \
    "1/8 - Doctor Inteligente" \
    "$AI_DIR/doctor.sh"

# ------------------------------------------------------------
# ETAPA 2 - ANALISADOR
# ------------------------------------------------------------

run_tool \
    "2/8 - Analisador de Erros" \
    "$AI_DIR/error_analyzer.sh"

# ------------------------------------------------------------
# ETAPA 3 - RELATÓRIO
# ------------------------------------------------------------

run_tool \
    "3/8 - Relatório do Projeto" \
    "$AI_DIR/project_report.sh"

# ------------------------------------------------------------
# ETAPA 4 - OPTIMIZER
# ------------------------------------------------------------

run_tool \
    "4/8 - Sugestões de Otimização" \
    "$AI_DIR/optimizer.sh"

# ------------------------------------------------------------
# SEGURANÇA ANTES DE CORRIGIR
# ------------------------------------------------------------

section "🛡️ VERIFICAÇÃO DE SEGURANÇA"

if command -v git >/dev/null 2>&1 &&
   git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    CHANGES="$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l)"

    echo "Alterações locais: $CHANGES"

    if [ "$CHANGES" -gt 0 ]; then
        warning "Existem $CHANGES alterações locais"
        warning "Fixer será executado, mas alterações devem ser revisadas"
    else
        success "Árvore Git limpa"
    fi

else
    warning "Git não disponível para verificação"
fi

# ------------------------------------------------------------
# ETAPA 5 - FIXER
# ------------------------------------------------------------

run_tool \
    "5/8 - Corrigir Projeto" \
    "$AI_DIR/fixer.sh"

# ------------------------------------------------------------
# ETAPA 6 - BUILD
# ------------------------------------------------------------

run_tool \
    "6/8 - Build Inteligente" \
    "$AI_DIR/builder.sh" \
    "yes"

BUILD_STATUS=$?

# ------------------------------------------------------------
# ETAPA 7 - README
# ------------------------------------------------------------

run_tool \
    "7/8 - Gerar README" \
    "$AI_DIR/readme_generator.sh"

# ------------------------------------------------------------
# ETAPA 8 - PUBLICADOR
# Só publica se o build não retornar erro grave.
# ------------------------------------------------------------

if [ "$BUILD_STATUS" -le 1 ]; then

    run_tool \
        "8/8 - Publicador Inteligente" \
        "$AI_DIR/publisher.sh"

else

    section "📦 PUBLICADOR"

    warning "Publicação bloqueada porque o build apresentou erro"

fi

# ------------------------------------------------------------
# DIAGNÓSTICO FINAL
# ------------------------------------------------------------

section "🧠 DIAGNÓSTICO FINAL"

CMAKE_NOTFOUND=0

while IFS= read -r CACHE; do

    [ -f "$CACHE" ] || continue

    COUNT="$(grep -c 'NOTFOUND' "$CACHE" 2>/dev/null)"

    if [ "$COUNT" -gt 0 ]; then
        CMAKE_NOTFOUND=$((CMAKE_NOTFOUND + COUNT))
    fi

done < <(
    find "$ROOT_DIR" \
        -type f \
        -name "CMakeCache.txt" \
        2>/dev/null
)

if [ "$CMAKE_NOTFOUND" -gt 0 ]; then
    error "$CMAKE_NOTFOUND entrada(s) CMake NOTFOUND detectada(s)"
else
    success "Nenhuma dependência CMake NOTFOUND"
fi

# ------------------------------------------------------------
# ARTEFATOS
# ------------------------------------------------------------

section "📦 ARTEFATOS"

APK_COUNT="$(
    find "$ROOT_DIR" \
        -type f \
        -name "*.apk" \
        2>/dev/null |
    wc -l
)"

SO_COUNT="$(
    find "$ROOT_DIR" \
        -type f \
        -name "*.so" \
        2>/dev/null |
    wc -l
)"

RELEASE_COUNT=0

if [ -d "$ROOT_DIR/exports/releases" ]; then
    RELEASE_COUNT="$(
        find "$ROOT_DIR/exports/releases" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
            2>/dev/null |
        wc -l
    )"
fi

echo "APK        : $APK_COUNT"
echo "Bibliotecas: $SO_COUNT"
echo "Releases   : $RELEASE_COUNT"

# ------------------------------------------------------------
# TEMPO
# ------------------------------------------------------------

END_TIME="$(date +%s)"
ELAPSED=$((END_TIME - START_TIME))

MINUTES=$((ELAPSED / 60))
SECONDS=$((ELAPSED % 60))

# ------------------------------------------------------------
# RESUMO
# ------------------------------------------------------------

echo
line
echo "📊 RESUMO EXECUTAR TUDO"
line

echo
echo "Etapas executadas : $TOTAL"
echo "OK                : $OK"
echo "Avisos            : $WARN"
echo "Erros             : $ERRORS"
echo "CMake NOTFOUND    : $CMAKE_NOTFOUND"
echo
echo "APK               : $APK_COUNT"
echo "Bibliotecas .so   : $SO_COUNT"
echo "Releases          : $RELEASE_COUNT"
echo
echo "Tempo             : ${MINUTES}m ${SECONDS}s"

echo

if [ "$ERRORS" -gt 0 ] || [ "$CMAKE_NOTFOUND" -gt 0 ]; then

    echo -e "${RED}❌ ESTADO: PROBLEMAS ENCONTRADOS${RESET}"

    echo
    echo "Prioridade:"
    echo "1) Corrigir dependências CMake NOTFOUND"
    echo "2) Limpar caches CMake antigos"
    echo "3) Gerar build limpo"
    echo "4) Validar bibliotecas Android/NDK"
    echo "5) Testar APK no Android"

elif [ "$WARN" -gt 0 ]; then

    echo -e "${YELLOW}⚠️ ESTADO: FUNCIONAL COM AVISOS${RESET}"

else

    echo -e "${GREEN}✅ ESTADO: TODAS AS ETAPAS CONCLUÍDAS${RESET}"

fi

echo
line
echo "⚡ EXECUTAR TUDO: FINALIZADO"
line

echo
echo "Pure3XEngine $VERSION"
echo "P3XE AI Center - Run All"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo
echo "Log:"
echo "$LOG_FILE"
echo
read -rp "Pressione ENTER para voltar..."
