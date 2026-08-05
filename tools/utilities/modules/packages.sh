#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# Utilities Center
# Módulo 8 - Atualizar Pacotes
# ============================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

echo "============================================================"
echo "📦 ATUALIZAR PACOTES"
echo "============================================================"
echo
echo "Projeto : $ROOT_DIR"
echo

# ------------------------------------------------------------
# INFORMAÇÕES DO TERMUX
# ------------------------------------------------------------

echo "============================================================"
echo "📱 AMBIENTE TERMUX"
echo "============================================================"
echo

echo "Prefixo : ${PREFIX:-Não detectado}"

if command -v pkg >/dev/null 2>&1; then
    echo "pkg     : Detectado"
else
    echo "pkg     : Não encontrado"
fi

if command -v apt >/dev/null 2>&1; then
    echo "apt     : Detectado"
else
    echo "apt     : Não encontrado"
fi

echo

# ------------------------------------------------------------
# VERIFICAR PACOTES IMPORTANTES DO P3XE
# ------------------------------------------------------------

echo "============================================================"
echo "🔎 PACOTES IMPORTANTES DO P3XE"
echo "============================================================"
echo

PACOTES=(
    clang
    cmake
    ninja
    make
    git
    python
    openjdk-17
    gradle
    qemu-system-aarch64
)

for pacote in "${PACOTES[@]}"; do

    if dpkg -s "$pacote" >/dev/null 2>&1; then
        versao="$(dpkg-query -W -f='${Version}' "$pacote" 2>/dev/null)"
        printf "%-24s INSTALADO  %s\n" "$pacote" "$versao"
    else
        printf "%-24s NÃO INSTALADO\n" "$pacote"
    fi

done

echo

# ------------------------------------------------------------
# VERIFICAR ATUALIZAÇÕES
# ------------------------------------------------------------

echo "============================================================"
echo "🔄 VERIFICANDO ATUALIZAÇÕES"
echo "============================================================"
echo

if ! command -v apt >/dev/null 2>&1; then
    echo "ERRO: apt não foi encontrado."
    echo
    read -r -p "Pressione ENTER para voltar ao Utilities Center..."
    exit 0
fi

echo "Atualizando índice dos repositórios..."
echo

apt update

STATUS_UPDATE=$?

echo

if [ "$STATUS_UPDATE" -ne 0 ]; then

    echo "============================================================"
    echo "⚠️ FALHA AO CONSULTAR REPOSITÓRIOS"
    echo "============================================================"
    echo
    echo "apt update retornou código: $STATUS_UPDATE"
    echo
    echo "Nenhum pacote será atualizado automaticamente."
    echo

    read -r -p "Pressione ENTER para voltar ao Utilities Center..."
    exit 0

fi

# ------------------------------------------------------------
# LISTAR ATUALIZAÇÕES
# ------------------------------------------------------------

echo
echo "============================================================"
echo "📋 ATUALIZAÇÕES DISPONÍVEIS"
echo "============================================================"
echo

ATUALIZACOES="$(
    apt list --upgradable 2>/dev/null |
    sed '1d'
)"

if [ -z "$ATUALIZACOES" ]; then

    echo "Sistema já está atualizado."
    TOTAL_UPDATES=0

else

    echo "$ATUALIZACOES"
    TOTAL_UPDATES="$(
        printf '%s\n' "$ATUALIZACOES" |
        sed '/^[[:space:]]*$/d' |
        wc -l
    )"

fi

echo

# ------------------------------------------------------------
# CONFIRMAÇÃO
# ------------------------------------------------------------

if [ "$TOTAL_UPDATES" -gt 0 ]; then

    echo "============================================================"
    echo "⚠️ CONFIRMAÇÃO"
    echo "============================================================"
    echo
    echo "Pacotes com atualização disponível: $TOTAL_UPDATES"
    echo
    echo "1) Atualizar pacotes"
    echo "0) Não atualizar"
    echo

    read -r -p "Escolha: " escolha

    case "$escolha" in

        1)
            echo
            echo "============================================================"
            echo "⬆️ ATUALIZANDO PACOTES"
            echo "============================================================"
            echo

            apt upgrade

            STATUS_UPGRADE=$?
            ;;

        *)
            STATUS_UPGRADE=0
            echo
            echo "Atualização cancelada."
            ;;

    esac

else

    STATUS_UPGRADE=0

fi

# ------------------------------------------------------------
# RESUMO
# ------------------------------------------------------------

echo
echo "============================================================"
echo "📊 RESUMO"
echo "============================================================"
echo

echo "Repositórios       : OK"
echo "Atualizações       : $TOTAL_UPDATES"

if [ "$STATUS_UPGRADE" -eq 0 ]; then
    echo "Estado             : OK"
else
    echo "Estado             : ERRO ($STATUS_UPGRADE)"
fi

echo
echo "Projeto preservado : $ROOT_DIR"

echo
echo "============================================================"
read -r -p "Pressione ENTER para voltar ao Utilities Center..."
echo "============================================================"
