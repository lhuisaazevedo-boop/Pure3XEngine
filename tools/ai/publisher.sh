#!/data/data/com.termux/files/usr/bin/bash

# ==============================================================
# P3XE - PUBLICADOR INTELIGENTE
# Pure3XEngine 0.2.6 Alpha
# ==============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
VERSION="0.2.6-Alpha"

if [ -f "$ROOT_DIR/tools/common/init.sh" ]; then
    source "$ROOT_DIR/tools/common/init.sh"
fi

clear

echo "=============================================================="
echo "📦 P3XE - PUBLICADOR INTELIGENTE"
echo "Pure3XEngine 0.2.6 Alpha"
echo "=============================================================="
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

OK=0
AVISOS=0
ERROS=0

status_ok() {
    echo "✅ $1"
    OK=$((OK + 1))
}

status_aviso() {
    echo "⚠ $1"
    AVISOS=$((AVISOS + 1))
}

status_erro() {
    echo "❌ $1"
    ERROS=$((ERROS + 1))
}

# --------------------------------------------------------------
# PROJETO
# --------------------------------------------------------------

echo "📁 PROJETO"
echo "--------------------------------------------------------------"

for MOD in CoreEmulator Cubo3D QEMUCenter Android; do
    if [ -d "$ROOT_DIR/$MOD" ]; then
        status_ok "$MOD detectado"
    else
        status_aviso "$MOD não encontrado"
    fi
done

echo

# --------------------------------------------------------------
# GIT
# --------------------------------------------------------------

echo "🌿 GIT"
echo "--------------------------------------------------------------"

if command -v git >/dev/null 2>&1 && \
   git -C "$ROOT_DIR" rev-parse --git-dir >/dev/null 2>&1; then

    BRANCH=$(git -C "$ROOT_DIR" branch --show-current 2>/dev/null)
    COMMIT=$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null)

    echo "Branch : ${BRANCH:-desconhecida}"
    echo "Commit : ${COMMIT:-desconhecido}"

    CHANGES=$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l)
    echo "Alterações locais : $CHANGES"

    status_ok "Repositório Git detectado"
else
    status_aviso "Git/repositório não detectado"
fi

echo

# --------------------------------------------------------------
# APK
# --------------------------------------------------------------

echo "📱 APK"
echo "--------------------------------------------------------------"

mapfile -t APK_FILES < <(
    find "$ROOT_DIR" \
        -type f \
        -name "*.apk" \
        ! -path "$ROOT_DIR/exports/releases/*" \
        2>/dev/null
)

APK_COUNT=${#APK_FILES[@]}

echo "APK encontrados : $APK_COUNT"

if [ "$APK_COUNT" -gt 0 ]; then

    INDEX=1

    for APK in "${APK_FILES[@]}"; do
        SIZE=$(du -h "$APK" 2>/dev/null | awk '{print $1}')

        echo
        echo "[$INDEX] $(basename "$APK")"
        echo "    Tamanho : ${SIZE:-?}"
        echo "    Caminho : $APK"

        INDEX=$((INDEX + 1))
    done

    status_ok "$APK_COUNT APK(s) disponível(is)"
else
    status_aviso "Nenhum APK encontrado"
fi

echo

# --------------------------------------------------------------
# BIBLIOTECAS NATIVAS
# --------------------------------------------------------------

echo "🧩 BIBLIOTECAS NATIVAS"
echo "--------------------------------------------------------------"

mapfile -t SO_FILES < <(
    find "$ROOT_DIR" \
        -type f \
        -name "*.so" \
        ! -path "$ROOT_DIR/exports/releases/*" \
        2>/dev/null
)

SO_COUNT=${#SO_FILES[@]}

echo "Bibliotecas .so : $SO_COUNT"

if [ "$SO_COUNT" -gt 0 ]; then

    declare -A SO_NAMES

    for SO in "${SO_FILES[@]}"; do
        NAME=$(basename "$SO")

        if [ -z "${SO_NAMES[$NAME]+x}" ]; then
            echo "  • $NAME"
            SO_NAMES["$NAME"]=1
        fi
    done

    status_ok "Bibliotecas nativas detectadas"
else
    status_aviso "Nenhuma biblioteca .so encontrada"
fi

echo

# --------------------------------------------------------------
# DIRETÓRIO DA RELEASE
# --------------------------------------------------------------

echo "📦 PREPARANDO RELEASE"
echo "--------------------------------------------------------------"

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

RELEASE_NAME="Pure3XEngine-${VERSION}-${TIMESTAMP}"
RELEASE_DIR="$ROOT_DIR/exports/releases/$RELEASE_NAME"

mkdir -p "$RELEASE_DIR/apk"
mkdir -p "$RELEASE_DIR/lib"

if [ -d "$RELEASE_DIR" ]; then
    status_ok "Diretório da release criado"
else
    status_erro "Não foi possível criar a release"
fi

echo "Release:"
echo "$RELEASE_DIR"
echo

# --------------------------------------------------------------
# COPIAR APK
# --------------------------------------------------------------

echo "📱 PUBLICANDO APK"
echo "--------------------------------------------------------------"

APK_COPIED=0

for APK in "${APK_FILES[@]}"; do

    NAME=$(basename "$APK")

    if cp -f "$APK" "$RELEASE_DIR/apk/$NAME"; then
        echo "✅ $NAME"
        APK_COPIED=$((APK_COPIED + 1))
    else
        status_erro "Falha copiando $NAME"
    fi

done

echo
echo "APK publicados : $APK_COPIED"
echo

# --------------------------------------------------------------
# COPIAR .SO
# --------------------------------------------------------------

echo "🧩 PUBLICANDO BIBLIOTECAS"
echo "--------------------------------------------------------------"

SO_COPIED=0

for SO in "${SO_FILES[@]}"; do

    NAME=$(basename "$SO")

    # Evita substituir silenciosamente bibliotecas
    # diferentes que tenham exatamente o mesmo nome.

    DEST="$RELEASE_DIR/lib/$NAME"

    if [ -f "$DEST" ]; then
        continue
    fi

    if cp "$SO" "$DEST"; then
        echo "✅ $NAME"
        SO_COPIED=$((SO_COPIED + 1))
    else
        status_erro "Falha copiando $NAME"
    fi

done

echo
echo "Bibliotecas publicadas : $SO_COPIED"
echo

# --------------------------------------------------------------
# INFORMAÇÕES DA RELEASE
# --------------------------------------------------------------

echo "📝 GERANDO INFORMAÇÕES"
echo "--------------------------------------------------------------"

INFO_FILE="$RELEASE_DIR/RELEASE_INFO.txt"

{
    echo "Pure3XEngine"
    echo "Version: 0.2.6 Alpha"
    echo
    echo "Release: $RELEASE_NAME"
    echo "Date: $(date '+%d/%m/%Y')"
    echo "Time: $(date '+%H:%M:%S')"
    echo
    echo "Project:"
    echo "$ROOT_DIR"
    echo
    echo "Git Branch:"
    echo "${BRANCH:-N/A}"
    echo
    echo "Git Commit:"
    echo "${COMMIT:-N/A}"
    echo
    echo "APK:"
    echo "$APK_COPIED"
    echo
    echo "Native Libraries:"
    echo "$SO_COPIED"
    echo
    echo "Modules:"
    echo "CoreEmulator"
    echo "Cubo3D"
    echo "QEMUCenter"
    echo "Android"
} > "$INFO_FILE"

status_ok "RELEASE_INFO.txt criado"

echo

# --------------------------------------------------------------
# SHA256
# --------------------------------------------------------------

echo "🔐 SHA-256"
echo "--------------------------------------------------------------"

CHECKSUM_FILE="$RELEASE_DIR/SHA256SUMS.txt"

if command -v sha256sum >/dev/null 2>&1; then

    (
        cd "$RELEASE_DIR" || exit 1

        find apk lib \
            -type f \
            -print0 2>/dev/null |
            sort -z |
            xargs -0 -r sha256sum

    ) > "$CHECKSUM_FILE"

    if [ -s "$CHECKSUM_FILE" ]; then
        status_ok "SHA256SUMS.txt criado"
    else
        status_aviso "Nenhum arquivo disponível para checksum"
    fi

else
    status_aviso "sha256sum não disponível"
fi

echo

# --------------------------------------------------------------
# TAMANHO
# --------------------------------------------------------------

echo "💾 RELEASE"
echo "--------------------------------------------------------------"

RELEASE_SIZE=$(du -sh "$RELEASE_DIR" 2>/dev/null | awk '{print $1}')

echo "Nome    : $RELEASE_NAME"
echo "Versão  : 0.2.6 Alpha"
echo "Tamanho : ${RELEASE_SIZE:-desconhecido}"
echo
echo "Local:"
echo "$RELEASE_DIR"

echo

# --------------------------------------------------------------
# RESULTADO
# --------------------------------------------------------------

echo "=============================================================="
echo "📊 RESUMO DO PUBLICADOR"
echo "=============================================================="
echo "APK encontrados       : $APK_COUNT"
echo "APK publicados        : $APK_COPIED"
echo "Bibliotecas detectadas: $SO_COUNT"
echo "Bibliotecas publicadas: $SO_COPIED"
echo
echo "OK      : $OK"
echo "Avisos  : $AVISOS"
echo "Erros   : $ERROS"
echo

if [ "$ERROS" -gt 0 ]; then
    echo "❌ PUBLISHER: PUBLICAÇÃO COM ERROS"
elif [ "$APK_COPIED" -gt 0 ]; then
    echo "✅ PUBLISHER: RELEASE CRIADA"
else
    echo "⚠ PUBLISHER: RELEASE CRIADA SEM APK"
fi

echo "=============================================================="
echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Publisher - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
