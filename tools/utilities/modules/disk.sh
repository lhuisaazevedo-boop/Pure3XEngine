#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

clear
cabecalho

echo
titulo "💾 USO DE DISCO"
echo

echo "Projeto : $ROOT_DIR"
echo

echo "📊 Tamanho total do projeto:"
du -sh "$ROOT_DIR" 2>/dev/null
echo

echo "============================================================"
echo "📁 TAMANHO DOS DIRETÓRIOS PRINCIPAIS"
echo "============================================================"
echo

for dir in "$ROOT_DIR"/*; do
    [ -d "$dir" ] || continue

    tamanho="$(du -sh "$dir" 2>/dev/null | cut -f1)"
    nome="$(basename "$dir")"

    printf "%-12s %s\n" "$tamanho" "$nome"
done | sort -hr

echo
echo "============================================================"
echo "💽 ARMAZENAMENTO DO TERMUX"
echo "============================================================"
echo

df -h "$HOME" 2>/dev/null

echo
echo "============================================================"
echo "📦 MAIORES DIRETÓRIOS DO PROJETO"
echo "============================================================"
echo

du -h -d 2 "$ROOT_DIR" 2>/dev/null |
    sort -hr |
    head -20

echo
echo "============================================================"
echo "📄 MAIORES ARQUIVOS DO PROJETO"
echo "============================================================"
echo

# Lista os 20 maiores arquivos usando o tamanho em bytes.
# Evita executar "du" individualmente para cada arquivo.
find "$ROOT_DIR" -type f -printf '%s\t%p\n' 2>/dev/null |
sort -nr |
head -20 |
while IFS=$'\t' read -r bytes arquivo; do

    if [ "$bytes" -ge 1073741824 ]; then
        tamanho="$(awk "BEGIN {printf \"%.2fG\", $bytes/1073741824}")"

    elif [ "$bytes" -ge 1048576 ]; then
        tamanho="$(awk "BEGIN {printf \"%.1fM\", $bytes/1048576}")"

    elif [ "$bytes" -ge 1024 ]; then
        tamanho="$(awk "BEGIN {printf \"%.1fK\", $bytes/1024}")"

    else
        tamanho="${bytes}B"
    fi

    # Remove o caminho absoluto e mostra apenas o caminho dentro do projeto.
    arquivo="${arquivo#$ROOT_DIR/}"

    printf "%-10s %s\n" "$tamanho" "$arquivo"
done

echo
echo "============================================================"
echo "📊 RESUMO"
echo "============================================================"
echo

TOTAL_FILES="$(find "$ROOT_DIR" -type f 2>/dev/null | wc -l)"
TOTAL_DIRS="$(find "$ROOT_DIR" -type d 2>/dev/null | wc -l)"
TOTAL_SIZE="$(du -sh "$ROOT_DIR" 2>/dev/null | cut -f1)"

echo "Tamanho     : $TOTAL_SIZE"
echo "Arquivos    : $TOTAL_FILES"
echo "Diretórios  : $TOTAL_DIRS"

echo
echo "============================================================"
echo "Pressione ENTER para voltar ao Utilities Center..."
echo "============================================================"

# Lê diretamente do terminal para evitar stdin consumido pelos pipes acima
read -r < /dev/tty
