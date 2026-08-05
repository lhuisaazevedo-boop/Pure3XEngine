#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# P3XE Cleaner Inteligente
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

OK=0
AVISOS=0
ERROS=0
REMOVIDOS=0

clear

echo "============================================================"
echo "🧹 P3XE - CLEANER INTELIGENTE"
echo "Pure3XEngine 0.2.6 Alpha"
echo "============================================================"
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo "============================================================"
echo

# ------------------------------------------------------------
# Segurança
# ------------------------------------------------------------

if [ ! -d "$ROOT_DIR" ]; then
    echo "❌ Diretório do projeto não encontrado."
    exit 1
fi

if [ ! -d "$ROOT_DIR/CoreEmulator" ]; then
    echo "⚠ CoreEmulator não encontrado."
    AVISOS=$((AVISOS + 1))
else
    echo "✅ CoreEmulator protegido"
    OK=$((OK + 1))
fi

if [ -d "$ROOT_DIR/Cubo3D" ]; then
    echo "✅ Cubo3D protegido"
    OK=$((OK + 1))
fi

if [ -d "$ROOT_DIR/QEMUCenter" ]; then
    echo "✅ QEMUCenter protegido"
    OK=$((OK + 1))
fi

if [ -d "$ROOT_DIR/Android" ]; then
    echo "✅ Android protegido"
    OK=$((OK + 1))
fi

echo
echo "🔒 ÁREAS PROTEGIDAS"
echo "------------------------------------------------------------"
echo "• CoreEmulator"
echo "• Cubo3D código-fonte"
echo "• QEMUCenter código-fonte"
echo "• Android código-fonte"
echo "• Config"
echo "• tools"
echo "• exports/apk"
echo "• exports/releases"
echo "• arquivos .so publicados"
echo

# ------------------------------------------------------------
# Função de limpeza
# ------------------------------------------------------------

limpar_dir() {
    local DIR="$1"
    local NOME="$2"

    if [ -d "$DIR" ]; then
        rm -rf -- "$DIR"

        if [ ! -e "$DIR" ]; then
            echo "✅ Removido: $NOME"
            REMOVIDOS=$((REMOVIDOS + 1))
            OK=$((OK + 1))
        else
            echo "❌ Falha ao remover: $NOME"
            ERROS=$((ERROS + 1))
        fi
    fi
}

# ------------------------------------------------------------
# Procurar caches CMake
# ------------------------------------------------------------

echo "🔎 CACHE CMAKE"
echo "------------------------------------------------------------"

CACHE_COUNT=0

while IFS= read -r CACHE; do
    [ -z "$CACHE" ] && continue

    echo "⚠ $CACHE"
    CACHE_COUNT=$((CACHE_COUNT + 1))
done < <(
    find "$ROOT_DIR" \
        -type f \
        -name "CMakeCache.txt" \
        ! -path "$ROOT_DIR/exports/*" \
        2>/dev/null
)

echo
echo "Caches encontrados : $CACHE_COUNT"
echo

# ------------------------------------------------------------
# Limpeza de builds conhecidos
# ------------------------------------------------------------

echo "🧹 BUILD / TEMPORÁRIOS"
echo "------------------------------------------------------------"

limpar_dir "$ROOT_DIR/out/smart-build" "out/smart-build"
limpar_dir "$ROOT_DIR/out/build" "out/build"

limpar_dir "$ROOT_DIR/Cubo3D/build-termux-r29" \
    "Cubo3D/build-termux-r29"

limpar_dir "$ROOT_DIR/Cubo3D/build-termux-native" \
    "Cubo3D/build-termux-native"

limpar_dir "$ROOT_DIR/Cubo3D/build-check-r29" \
    "Cubo3D/build-check-r29"

# ------------------------------------------------------------
# Android / Gradle
# ------------------------------------------------------------

echo
echo "🤖 ANDROID / GRADLE"
echo "------------------------------------------------------------"

if [ -d "$ROOT_DIR/Android/.gradle" ]; then
    limpar_dir "$ROOT_DIR/Android/.gradle" "Android/.gradle"
else
    echo "ℹ Android/.gradle não encontrado"
fi

if [ -d "$ROOT_DIR/Android/app/build" ]; then
    limpar_dir "$ROOT_DIR/Android/app/build" "Android/app/build"
else
    echo "ℹ Android/app/build não encontrado"
fi

if [ -d "$ROOT_DIR/Android/build" ]; then
    limpar_dir "$ROOT_DIR/Android/build" "Android/build"
fi

# ------------------------------------------------------------
# Arquivos temporários
# ------------------------------------------------------------

echo
echo "🗑 ARQUIVOS TEMPORÁRIOS"
echo "------------------------------------------------------------"

TEMP_COUNT=0

while IFS= read -r FILE; do
    [ -z "$FILE" ] && continue

    rm -f -- "$FILE"

    if [ ! -e "$FILE" ]; then
        echo "✅ $(basename "$FILE")"
        TEMP_COUNT=$((TEMP_COUNT + 1))
    fi
done < <(
    find "$ROOT_DIR" -type f \
        \( -name "*.tmp" \
        -o -name "*.bak" \
        -o -name "*~" \
        -o -name "*.swp" \) \
        ! -path "$ROOT_DIR/.git/*" \
        ! -path "$ROOT_DIR/exports/*" \
        2>/dev/null
)

REMOVIDOS=$((REMOVIDOS + TEMP_COUNT))

echo
echo "Temporários removidos : $TEMP_COUNT"

# ------------------------------------------------------------
# Verificação das exports
# ------------------------------------------------------------

echo
echo "📦 EXPORTS"
echo "------------------------------------------------------------"

if [ -d "$ROOT_DIR/exports/apk" ]; then
    APK_COUNT=$(find "$ROOT_DIR/exports/apk" \
        -type f -name "*.apk" 2>/dev/null | wc -l)
    echo "✅ APK preservados      : $APK_COUNT"
    OK=$((OK + 1))
else
    echo "ℹ exports/apk ainda não existe"
fi

if [ -d "$ROOT_DIR/exports/releases" ]; then
    RELEASE_COUNT=$(find "$ROOT_DIR/exports/releases" \
        -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    echo "✅ Releases preservadas : $RELEASE_COUNT"
    OK=$((OK + 1))
else
    echo "ℹ exports/releases ainda não existe"
fi

# ------------------------------------------------------------
# Resultado
# ------------------------------------------------------------

echo
echo "============================================================"
echo "📊 RESUMO CLEANER"
echo "============================================================"
echo "Itens removidos : $REMOVIDOS"
echo "OK              : $OK"
echo "Avisos          : $AVISOS"
echo "Erros           : $ERROS"
echo "============================================================"

if [ "$ERROS" -eq 0 ]; then
    echo "✅ CLEANER: LIMPEZA CONCLUÍDA"
else
    echo "❌ CLEANER: LIMPEZA CONCLUÍDA COM ERROS"
fi

echo "============================================================"
echo
echo "Pure3XEngine 0.2.6 Alpha"
echo "P3XE Cleaner - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
