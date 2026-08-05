#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# Utilities Center
# Módulo 9 - Corrigir Permissões
# ============================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

echo "============================================================"
echo "🔑 CORRIGIR PERMISSÕES"
echo "============================================================"
echo
echo "Projeto : $ROOT_DIR"
echo

# ------------------------------------------------------------
# SEGURANÇA
# ------------------------------------------------------------

if [ ! -d "$ROOT_DIR" ]; then
    echo "ERRO: diretório do projeto não encontrado."
    read -r -p "Pressione ENTER para voltar..."
    exit 0
fi

if [ ! -d "$ROOT_DIR/tools" ]; then
    echo "ERRO: pasta tools não encontrada."
    read -r -p "Pressione ENTER para voltar..."
    exit 0
fi

echo "============================================================"
echo "🔎 VERIFICAÇÃO"
echo "============================================================"
echo

TOTAL_SH="$(
    find "$ROOT_DIR" \
        -path "$ROOT_DIR/.git" -prune -o \
        -path "$ROOT_DIR/backups" -prune -o \
        -path "$ROOT_DIR/exports" -prune -o \
        -type f -name "*.sh" -print 2>/dev/null |
        wc -l
)"

SEM_EXECUCAO="$(
    find "$ROOT_DIR" \
        -path "$ROOT_DIR/.git" -prune -o \
        -path "$ROOT_DIR/backups" -prune -o \
        -path "$ROOT_DIR/exports" -prune -o \
        -type f -name "*.sh" ! -perm -u+x -print 2>/dev/null |
        wc -l
)"

echo "Scripts .sh encontrados : $TOTAL_SH"
echo "Sem permissão de execução: $SEM_EXECUCAO"
echo

# ------------------------------------------------------------
# MOSTRAR PROBLEMAS
# ------------------------------------------------------------

if [ "$SEM_EXECUCAO" -gt 0 ]; then

    echo "============================================================"
    echo "⚠️ SCRIPTS SEM PERMISSÃO"
    echo "============================================================"
    echo

    find "$ROOT_DIR" \
        -path "$ROOT_DIR/.git" -prune -o \
        -path "$ROOT_DIR/backups" -prune -o \
        -path "$ROOT_DIR/exports" -prune -o \
        -type f -name "*.sh" ! -perm -u+x -print 2>/dev/null |
    while IFS= read -r arquivo; do
        echo "${arquivo#$ROOT_DIR/}"
    done

    echo

else

    echo "Todos os scripts .sh já possuem permissão de execução."
    echo

fi

# ------------------------------------------------------------
# CONFIRMAÇÃO
# ------------------------------------------------------------

echo "============================================================"
echo "🛡️ MODO SEGURO"
echo "============================================================"
echo
echo "A correção aplica somente:"
echo
echo "  chmod u+rx em arquivos .sh"
echo
echo "Não altera:"
echo "  código C/C++"
echo "  Kotlin/Java"
echo "  APK"
echo "  bibliotecas .so"
echo "  backups"
echo "  exports"
echo "  .git"
echo
echo "1) Corrigir permissões"
echo "0) Voltar sem alterar"
echo

read -r -p "Escolha: " escolha

case "$escolha" in

    1)
        echo
        echo "============================================================"
        echo "🔧 CORRIGINDO PERMISSÕES"
        echo "============================================================"
        echo

        CORRIGIDOS=0
        FALHAS=0

        while IFS= read -r -d '' arquivo; do

            if chmod u+rx "$arquivo" 2>/dev/null; then
                echo "OK  ${arquivo#$ROOT_DIR/}"
                ((CORRIGIDOS++))
            else
                echo "ERRO ${arquivo#$ROOT_DIR/}"
                ((FALHAS++))
            fi

        done < <(
            find "$ROOT_DIR" \
                -path "$ROOT_DIR/.git" -prune -o \
                -path "$ROOT_DIR/backups" -prune -o \
                -path "$ROOT_DIR/exports" -prune -o \
                -type f -name "*.sh" ! -perm -u+x -print0 2>/dev/null
        )

        ;;

    0)
        echo
        echo "Nenhuma permissão foi alterada."
        CORRIGIDOS=0
        FALHAS=0
        ;;

    *)
        echo
        echo "Opção inválida. Nenhuma alteração realizada."
        CORRIGIDOS=0
        FALHAS=0
        ;;

esac

# ------------------------------------------------------------
# VERIFICAÇÃO FINAL
# ------------------------------------------------------------

RESTANTES="$(
    find "$ROOT_DIR" \
        -path "$ROOT_DIR/.git" -prune -o \
        -path "$ROOT_DIR/backups" -prune -o \
        -path "$ROOT_DIR/exports" -prune -o \
        -type f -name "*.sh" ! -perm -u+x -print 2>/dev/null |
        wc -l
)"

echo
echo "============================================================"
echo "📊 RESUMO"
echo "============================================================"
echo

echo "Scripts encontrados : $TOTAL_SH"
echo "Corrigidos           : $CORRIGIDOS"
echo "Falhas               : $FALHAS"
echo "Ainda sem execução   : $RESTANTES"
echo
echo "Projeto preservado   : $ROOT_DIR"

if [ "$FALHAS" -eq 0 ] && [ "$RESTANTES" -eq 0 ]; then
    echo "Estado               : OK"
else
    echo "Estado               : ATENÇÃO"
fi

echo
echo "============================================================"
read -r -p "Pressione ENTER para voltar ao Utilities Center..."
echo "============================================================"
