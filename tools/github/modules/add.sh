#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# GITHUB CENTER — P3XE
# Pure3XEngine 0.2.6 Alpha
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
MODULES_DIR="$ROOT_DIR/tools/github/modules"

# Cores padrão do Kit
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
CIANO="\033[1;36m"
RESET="\033[0m"

pausa() {
    echo -e "\n${AMARELO}Pressione ENTER para continuar...${RESET}"
    read -r
}

# Função: mostra status atual do repositório
mostrar_status_repo() {
    cd "$ROOT_DIR" || return

    local BRANCH=$(git branch --show-current 2>/dev/null || echo "---")
    local ALTERADOS=$(git status --porcelain 2>/dev/null | grep -v "^??" | wc -l)
    local EM_STAGE=$(git status --porcelain 2>/dev/null | grep "^[A-Z]" | wc -l)
    local_NAO_RASTREADOS=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)

    echo -e "${CIANO}📊 Status Atual do Repositório${RESET}"
    echo "--------------------------------------------------------------"
    printf " 📂 Projeto        : %s\n" "Pure3XEngine"
    printf " 🌿 Branch atual   : %s\n" "$BRANCH"
    printf " 📝 Modificados    : %s\n" "$ALTERADOS"
    printf " ➕ Em Stage       : %s\n" "$EM_STAGE"
    printf " ❔ Não rastreados : %s\n" "$NAO_RASTREADOS"
    echo "--------------------------------------------------------------"
    echo
}

while true
do
    clear

    echo -e "${AZUL}==============================================================${RESET}"
    echo -e "${AZUL}➕ ADICIONAR ARQUIVOS — GitHub Center${RESET}"
    echo -e "${AZUL}Pure3XEngine 0.2.6 Alpha${RESET}"
    echo -e "${AZUL}==============================================================${RESET}"
    echo
    echo -e "📅 Data: $(date +%d/%m/%Y)  🕒 Hora: $(date +%H:%M:%S)"
    echo

    mostrar_status_repo

    echo -e "${AMARELO}Opções Disponíveis${RESET}"
    echo

    echo "  1) 📄 Adicionar um arquivo específico"
    echo "     git add <caminho_do_arquivo>"
    echo
    echo "  2) 📁 Adicionar uma pasta inteira"
    echo "     git add <caminho_da_pasta>/"
    echo
    echo "  3) ⭐ Adicionar TODO o projeto de uma vez"
    echo "     git add ."
    echo
    echo "  4) 🔄 Atualizar arquivos modificados/removidos"
    echo "     git add -u"
    echo
    echo "  5) 👀 Ver o que está preparado (Stage)"
    echo "     git status"
    echo
    echo "  6) 🗑️ Limpar tudo do Stage — desfaz os git add"
    echo "     git restore --staged ."
    echo
    echo "  7) ❔ Listar arquivos novos que ainda NÃO foram adicionados"
    echo "     git ls-files --others --exclude-standard"
    echo
    echo "  0) ← Voltar ao GitHub Center"
    echo

    read -r -p "Escolha uma opção: " op

    case "$op" in

    1)
        echo
        read -rp "📄 Caminho do arquivo: " arquivo
        if [ -z "$arquivo" ]; then
            echo -e "${VERMELHO}❌ Nenhum arquivo informado.${RESET}"
        elif [ ! -f "$ROOT_DIR/$arquivo" ]; then
            echo -e "${VERMELHO}❌ Arquivo não encontrado: $arquivo${RESET}"
        else
            git -C "$ROOT_DIR" add "$arquivo"
            echo -e "${VERDE}✅ Arquivo adicionado: $arquivo${RESET}"
        fi
        pausa
        ;;

    2)
        echo
        read -rp "📁 Caminho da pasta: " pasta
        if [ -z "$pasta" ]; then
            echo -e "${VERMELHO}❌ Nenhuma pasta informada.${RESET}"
        elif [ ! -d "$ROOT_DIR/$pasta" ]; then
            echo -e "${VERMELHO}❌ Pasta não encontrada: $pasta${RESET}"
        else
            git -C "$ROOT_DIR" add "$pasta/"
            echo -e "${VERDE}✅ Pasta adicionada: $pasta/${RESET}"
        fi
        pausa
        ;;

    3)
        git -C "$ROOT_DIR" add .
        echo -e "${VERDE}✅ Todos os arquivos do projeto foram adicionados.${RESET}"
        pausa
        ;;

    4)
        git -C "$ROOT_DIR" add -u
        echo -e "${VERDE}✅ Arquivos modificados e removidos atualizados no Stage.${RESET}"
        pausa
        ;;

    5)
        echo
        echo -e "${AZUL}📋 Status completo:${RESET}"
        echo "----------------------------------------"
        git -C "$ROOT_DIR" status
        pausa
        ;;

    6)
        git -C "$ROOT_DIR" restore --staged .
        echo -e "${VERDE}✅ Stage limpo — nenhum arquivo preparado.${RESET}"
        pausa
        ;;

    7)
        echo
        echo -e "${AZUL}❔ Arquivos novos ainda não rastreados:${RESET}"
        echo "----------------------------------------"
        local NAO_RAST=$(git -C "$ROOT_DIR" ls-files --others --exclude-standard)
        if [ -z "$NAO_RAST" ]; then
            echo -e "${VERDE}✅ Nenhum arquivo novo — tudo já está rastreado!${RESET}"
        else
            echo "$NAO_RAST"
        fi
        pausa
        ;;

    0)
        echo -e "\n${VERDE}✅ Voltando ao GitHub Center...${RESET}"
        sleep 0.5
        break
        ;;

    *)
        echo -e "\n${VERMELHO}❌ Opção inválida! Tente novamente.${RESET}"
        sleep 1.2
        ;;
    esac
done

