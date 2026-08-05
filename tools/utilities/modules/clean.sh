#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear
cabecalho
titulo "🧹 LIMPEZA INTELIGENTE DO PROJETO"

echo "Projeto: $ROOT_DIR"
echo

# --------------------------------------------------
# Calcula tamanho antes
# --------------------------------------------------

ANTES="$(du -sh "$ROOT_DIR" 2>/dev/null | awk '{print $1}')"

echo "📊 Tamanho atual: ${ANTES:-desconhecido}"
echo

# --------------------------------------------------
# Itens que podem ser limpos com segurança
# --------------------------------------------------

echo "🔍 Procurando arquivos temporários..."
echo

TEMP_COUNT="$(
    find "$ROOT_DIR" \
        -type f \
        \( \
            -name "*.tmp" \
            -o -name "*.temp" \
            -o -name "*.bak" \
            -o -name "*~" \
            -o -name "*.swp" \
            -o -name "*.swo" \
        \) 2>/dev/null | wc -l
)"

echo "Arquivos temporários encontrados: $TEMP_COUNT"

# --------------------------------------------------
# Caches CMake
# --------------------------------------------------

CMAKE_COUNT="$(
    find "$ROOT_DIR" \
        -type f \
        -name "CMakeCache.txt" \
        2>/dev/null | wc -l
)"

echo "Caches CMake encontrados: $CMAKE_COUNT"

# --------------------------------------------------
# Diretórios de cache conhecidos
# --------------------------------------------------

CACHE_DIRS=(
    "$ROOT_DIR/.cache"
    "$ROOT_DIR/out/smart-build"
)

echo
echo "Diretórios de cache detectados:"

CACHE_FOUND=0

for dir in "${CACHE_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        echo "  • ${dir#$ROOT_DIR/}"
        ((CACHE_FOUND++))
    fi
done

if (( CACHE_FOUND == 0 )); then
    echo "  Nenhum cache conhecido encontrado."
fi

echo
echo "------------------------------------------------"
echo "⚠️ Esta limpeza NÃO remove:"
echo "  • código-fonte"
echo "  • APK"
echo "  • bibliotecas .so"
echo "  • releases"
echo "  • backups"
echo "  • arquivos Git"
echo "------------------------------------------------"
echo

read -r -p "Executar limpeza? [s/N]: " resposta

case "$resposta" in
    s|S|sim|SIM|Sim)
        ;;
    *)
        echo
        echo "❎ Limpeza cancelada."
        pausa
        exit 0
        ;;
esac

echo
echo "🧹 Limpando..."
echo

REMOVIDOS=0

# --------------------------------------------------
# Remove temporários
# --------------------------------------------------

while IFS= read -r -d '' arquivo; do
    echo "Removendo: ${arquivo#$ROOT_DIR/}"

    if rm -f -- "$arquivo"; then
        ((REMOVIDOS++))
    fi

done < <(
    find "$ROOT_DIR" \
        -type f \
        \( \
            -name "*.tmp" \
            -o -name "*.temp" \
            -o -name "*.bak" \
            -o -name "*~" \
            -o -name "*.swp" \
            -o -name "*.swo" \
        \) \
        -print0 2>/dev/null
)

# --------------------------------------------------
# Limpa cache CMake antigo
# --------------------------------------------------

while IFS= read -r -d '' cache; do

    echo "Removendo CMake cache:"
    echo "  ${cache#$ROOT_DIR/}"

    if rm -f -- "$cache"; then
        ((REMOVIDOS++))
    fi

    cmake_dir="$(dirname "$cache")"

    if [[ -d "$cmake_dir/CMakeFiles" ]]; then
        echo "  Removendo CMakeFiles/"
        rm -rf -- "$cmake_dir/CMakeFiles"
    fi

done < <(
    find "$ROOT_DIR" \
        -type f \
        -name "CMakeCache.txt" \
        -print0 2>/dev/null
)

# --------------------------------------------------
# Cache interno
# --------------------------------------------------

if [[ -d "$ROOT_DIR/.cache" ]]; then
    echo "Removendo .cache/"
    rm -rf -- "$ROOT_DIR/.cache"
fi

# --------------------------------------------------
# Resultado
# --------------------------------------------------

DEPOIS="$(du -sh "$ROOT_DIR" 2>/dev/null | awk '{print $1}')"

echo
echo "================================================"
echo "📊 RESUMO DA LIMPEZA"
echo "================================================"
echo
echo "Antes       : ${ANTES:-?}"
echo "Depois      : ${DEPOIS:-?}"
echo "Temporários : $TEMP_COUNT"
echo "CMake cache : $CMAKE_COUNT"
echo "Removidos   : $REMOVIDOS"
echo

echo "✅ Limpeza concluída."
echo
pausa
