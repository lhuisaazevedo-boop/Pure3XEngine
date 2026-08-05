#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

BACKUP_ROOT="$ROOT_DIR/backups"

clear
cabecalho
titulo "📁 BACKUP INTELIGENTE DO PROJETO"

mkdir -p "$BACKUP_ROOT"

DATA="$(date +%Y%m%d_%H%M%S)"
BACKUP_NAME="Pure3XEngine_backup_$DATA"
BACKUP_FILE="$BACKUP_ROOT/$BACKUP_NAME.tar.gz"

echo "Projeto : $ROOT_DIR"
echo "Destino : $BACKUP_FILE"
echo

# --------------------------------------------------
# Informações
# --------------------------------------------------

TAMANHO="$(du -sh "$ROOT_DIR" 2>/dev/null | awk '{print $1}')"

echo "📊 Tamanho atual do projeto: ${TAMANHO:-?}"
echo

echo "O backup incluirá:"
echo "  • CoreEmulator"
echo "  • Cubo3D"
echo "  • QEMUCenter"
echo "  • Android"
echo "  • Config"
echo "  • tools"
echo "  • arquivos principais"
echo

echo "Não serão incluídos:"
echo "  • backups antigos"
echo "  • .git"
echo "  • caches CMake"
echo "  • diretórios build temporários"
echo "  • arquivos temporários"
echo

read -r -p "Criar backup? [s/N]: " resposta

case "$resposta" in
    s|S|sim|Sim|SIM)
        ;;
    *)
        echo
        echo "❎ Backup cancelado."
        pausa
        exit 0
        ;;
esac

echo
echo "📦 Criando backup..."
echo

cd "$ROOT_DIR" || {
    erro "Não foi possível acessar o projeto."
    pausa
    exit 1
}

# --------------------------------------------------
# Criação segura
# --------------------------------------------------

tar \
    --exclude="./backups" \
    --exclude="./.git" \
    --exclude="./.gradle" \
    --exclude="./.cache" \
    --exclude="./out/smart-build" \
    --exclude="*/CMakeFiles" \
    --exclude="*/CMakeCache.txt" \
    --exclude="*/build" \
    --exclude="*.tmp" \
    --exclude="*.temp" \
    --exclude="*.swp" \
    --exclude="*.swo" \
    --exclude="*~" \
    -czf "$BACKUP_FILE" \
    . 2>/dev/null

STATUS=$?

echo

if [[ $STATUS -ne 0 || ! -f "$BACKUP_FILE" ]]; then
    erro "Falha ao criar backup."

    rm -f "$BACKUP_FILE" 2>/dev/null

    pausa
    exit 1
fi

# --------------------------------------------------
# Validação
# --------------------------------------------------

echo "🔍 Validando arquivo..."

if ! tar -tzf "$BACKUP_FILE" >/dev/null 2>&1; then
    erro "Backup criado, mas o arquivo está corrompido."

    rm -f "$BACKUP_FILE"

    pausa
    exit 1
fi

echo "✅ Integridade TAR/GZIP válida"

# --------------------------------------------------
# Estatísticas
# --------------------------------------------------

BACKUP_SIZE="$(du -sh "$BACKUP_FILE" 2>/dev/null | awk '{print $1}')"

ARQUIVOS="$(
    tar -tzf "$BACKUP_FILE" 2>/dev/null |
    grep -v '/$' |
    wc -l
)"

TOTAL_BACKUPS="$(
    find "$BACKUP_ROOT" \
        -maxdepth 1 \
        -type f \
        -name 'Pure3XEngine_backup_*.tar.gz' \
        2>/dev/null |
    wc -l
)"

# --------------------------------------------------
# Checksum
# --------------------------------------------------

SHA_FILE="$BACKUP_FILE.sha256"

if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$BACKUP_FILE" > "$SHA_FILE"
    SHA="$(awk '{print $1}' "$SHA_FILE")"
else
    SHA="sha256sum não disponível"
fi

echo
echo "================================================"
echo "📊 RESUMO DO BACKUP"
echo "================================================"
echo
echo "Nome     : $BACKUP_NAME"
echo "Tamanho  : ${BACKUP_SIZE:-?}"
echo "Arquivos : $ARQUIVOS"
echo "Backups  : $TOTAL_BACKUPS"
echo
echo "Local:"
echo "$BACKUP_FILE"
echo
echo "SHA-256:"
echo "$SHA"
echo
echo "✅ Backup criado e validado com sucesso."
echo

pausa
