#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# ⬇ PULL — GitHub Center
# Pure3XEngine 0.2.6 Alpha
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# ✅ ENTRA NA PASTA DO PROJETO — GARANTIA ABSOLUTA!
cd "$ROOT_DIR" || {
    echo -e "\033[1;31m❌ ERRO: Não foi possível entrar na pasta do projeto!\033[0m"
    echo -e "Caminho esperado: $ROOT_DIR"
    read -r -p "Pressione ENTER para sair..."
    exit 1
}

# Cores
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
CIANO="\033[1;36m"
RESET="\033[0m"

PULL_HISTORY_FILE=".git/.ultimo_pull"

pausa() {
    echo -e "\n${AMARELO}Pressione ENTER para voltar às opções...${RESET}"
    read -r
}

# ==========================================================
# FUNÇÕES DE STATUS
# ==========================================================
get_branch() { git branch --show-current 2>/dev/null || echo "---"; }
get_modified_count() { git status --porcelain 2>/dev/null | grep -v "^??" | wc -l; }
get_untracked_count() { git ls-files --others --exclude-standard 2>/dev/null | wc -l; }
get_commits_a_baixar() { git rev-list --count --right-only HEAD "@{u}" 2>/dev/null || echo 0; }
tem_alteracoes_locais() { [ "$(get_modified_count)" -gt 0 ] || [ "$(get_untracked_count)" -gt 0 ]; }

salvar_data_pull() {
    date +"%d/%m/%Y %H:%M:%S" > "$PULL_HISTORY_FILE"
}

get_ultima_sincronizacao() {
    if [ -f "$PULL_HISTORY_FILE" ]; then
        cat "$PULL_HISTORY_FILE"
    else
        echo "Nunca"
    fi
}

# ==========================================================
# VERIFICAÇÃO PRÉVIA — ALTERAÇÕES LOCAIS
# ==========================================================
verificar_alteracoes_locais() {
    local MODIF=$(get_modified_count)
    local NOVOS=$(get_untracked_count)

    if tem_alteracoes_locais; then
        echo
        echo -e "${AMARELO}⚠️ Existem alterações locais não commitadas!${RESET}"
        echo
        echo "Arquivos modificados : $MODIF"
        echo "Arquivos novos       : $NOVOS"
        echo
        echo -e "${CIANO}➡ Opções:${RESET}"
        echo "   1) 📦 Stash — guardar temporariamente e recuperar depois"
        echo "   2) 💾 Commit — salvar definitivamente"
        echo "   3) ❌ Cancelar"
        echo
        read -r -p "O que deseja fazer? (1/2/3): " escolha
        case "$escolha" in
            1)
                echo -e "${AZUL}📦 Guardando alterações com Stash...${RESET}"
                git stash push -m "Auto-stash antes do Pull $(date +%d/%m/%Y %H:%M)" >/dev/null 2>&1
                echo -e "${VERDE}✅ Alterações guardadas!${RESET}"
                echo -e "${CIANO}➡ Para recuperar depois: git stash pop${RESET}"
                return 0
                ;;
            2)
                echo -e "${AMARELO}➡ Vá primeiro em: 3) 💾 Commit${RESET}"
                echo -e "${AMARELO}   Depois volte aqui para o Pull.${RESET}"
                return 1
                ;;
            *)
                echo -e "${AMARELO}⏭️  Cancelado. Nada foi alterado.${RESET}"
                return 1
                ;;
        esac
    fi
    return 0
}

# ==========================================================
# LOOP PRINCIPAL — SEMPRE LIMPA E MOSTRA O MENU NOVAMENTE!
# ==========================================================
while true
do
    clear

    echo -e "${AZUL}==============================================================${RESET}"
    echo -e "${AZUL}⬇ PULL — GitHub Center${RESET}"
    echo -e "${AZUL}Pure3XEngine 0.2.6 Alpha${RESET}"
    echo -e "${AZUL}==============================================================${RESET}"
    echo
    echo -e "📅 Data: $(date +%d/%m/%Y)   🕒 Hora: $(date +%H:%M:%S)"
    echo -e "📂 Pasta ativa: $(pwd)"
    echo

    BRANCH=$(get_branch)
    QTD_BAIXAR=$(get_commits_a_baixar)
    ULTIMA_SYNC=$(get_ultima_sincronizacao)

    echo -e "${CIANO}📥 Sincronizar Repositório${RESET}"
    echo "--------------------------------------------------------------"
    echo " 📂 Projeto............. Pure3XEngine"
    echo " 🌿 Branch.............. $BRANCH"
    echo " 📥 Commits no remoto... $QTD_BAIXAR"
    echo " 🕐 Última sincronização: $ULTIMA_SYNC"
    echo "--------------------------------------------------------------"

    if [ "$QTD_BAIXAR" -eq 0 ]; then
        echo -e "${VERDE}✔ Repositório já está atualizado!${RESET}"
    fi
    echo

    echo -e "${AMARELO}Opções Disponíveis${RESET}"
    echo
    echo "  1) ⬇ Buscar alterações do GitHub"
    echo "     git pull --rebase origin $BRANCH"
    echo
    echo "  2) 👀 Ver o que será baixado antes de receber"
    echo "     git fetch"
    echo "     git log HEAD..origin/$BRANCH --oneline"
    echo
    echo "  3) 🔄 Atualizar informações do remoto"
    echo "     git fetch --all --prune"
    echo
    echo "  0) ← Voltar ao GitHub Center"
    echo

    read -r -p "Escolha uma opção: " op

    case "$op" in

    1)
        if ! verificar_alteracoes_locais; then
            pausa
            continue
        fi

        QTD_BAIXAR=$(get_commits_a_baixar)
        if [ "$QTD_BAIXAR" -eq 0 ]; then
            echo
            echo -e "${VERDE}✔ Nada para baixar — já está tudo sincronizado!${RESET}"
            pausa
            continue
        fi

        echo
        echo -e "${AZUL}⬇ Baixando alterações...${RESET}"
        echo "git pull --rebase origin $BRANCH"
        echo

        SAIDA=$(git pull --rebase origin "$BRANCH" 2>&1)
        CODIGO=$?

        if [ $CODIGO -eq 0 ]; then
            salvar_data_pull
            echo
            echo -e "${VERDE}==============================================================${RESET}"
            echo -e "${VERDE}✅ PULL CONCLUÍDO COM SUCESSO!${RESET}"
            echo -e "${VERDE}==============================================================${RESET}"
            echo -e " 📥 $QTD_BAIXAR commit(s) baixado(s) e aplicado(s)"
            echo -e " 🌿 Branch: $BRANCH"
            echo -e " 🕐 Sincronizado em: $(get_ultima_sincronizacao)"
            echo
            echo -e "${CIANO}➡ Próximo passo:${RESET}"
            echo "   1) ⬆ Push — se tiver commits locais para enviar"
        else
            if echo "$SAIDA" | grep -qi "unstaged changes\|You have changes\|Please commit or stash"; then
                echo
                echo -e "${AMARELO}⚠️ Alterações locais não preparadas!${RESET}"
                echo
                echo "O git pull --rebase precisa de um ambiente limpo."
                echo
                echo -e "${CIANO}Como resolver agora:${RESET}"
                echo "   Opção A — Guardar temporariamente:"
                echo "      git stash"
                echo "      → Depois do Pull: git stash pop"
                echo
                echo "   Opção B — Salvar definitivamente:"
                echo "      Vá em: 3) 💾 Commit"
                echo "      → Depois volte aqui para o Pull"
            elif echo "$SAIDA" | grep -qi "conflict\|Merge conflict"; then
                echo
                echo -e "${VERMELHO}❌ CONFLITOS ENCONTRADOS durante o Pull!${RESET}"
                echo
                echo -e "${CIANO}Como resolver:${RESET}"
                echo "   1. Abra os arquivos marcados e escolha qual versão manter"
                echo "   2. Marque como resolvido: git add ."
                echo "   3. Continue o processo: git rebase --continue"
                echo
                echo -e "${AMARELO}Para desfazer tudo e voltar como estava:${RESET}"
                echo "   git rebase --abort"
            else
                echo -e "${VERMELHO}❌ Falha ao buscar alterações.${RESET}"
                echo
                echo "Detalhes:"
                echo -e "\033[0;37m$SAIDA${RESET}"
            fi
        fi
        pausa
        ;;

    2)
        echo
        echo -e "${AZUL}👀 Buscando e listando alterações...${RESET}"
        echo

        git fetch origin "$BRANCH" >/dev/null 2>&1

        QTD_BAIXAR=$(get_commits_a_baixar)
        if [ "$QTD_BAIXAR" -eq 0 ]; then
            echo -e "${VERDE}✔ Nenhum commit novo no GitHub.${RESET}"
        else
            echo -e "${CIANO}📋 Commits que serão baixados ($QTD_BAIXAR):${RESET}"
            echo "--------------------------------------------------------------"

            if [ "$QTD_BAIXAR" -le 10 ]; then
                git log --oneline --no-decorate HEAD.."origin/$BRANCH" | sed 's/^/ • /'
            else
                echo "Mostrando os 10 mais recentes..."
                git log --oneline --no-decorate -n 10 HEAD.."origin/$BRANCH" | sed 's/^/ • /'
                echo " • ... e mais $(( QTD_BAIXAR - 10 )) commits."
            fi

            echo "--------------------------------------------------------------"
            echo -e "${VERDE}Total: $QTD_BAIXAR commit(s)${RESET}"
        fi
        pausa
        ;;

    3)
        echo
        echo -e "${AZUL}🔄 Atualizando todas as branches e limpando referências antigas...${RESET}"
        echo "git fetch --all --prune"
        echo

        if git fetch --all --prune; then
            echo
            echo -e "${VERDE}✅ Informações do remoto atualizadas!${RESET}"
            echo "Branches excluídas no GitHub foram removidas localmente."
        else
            echo -e "${VERMELHO}❌ Falha ao buscar do remoto. Verifique conexão.${RESET}"
        fi
        pausa
        ;;

    0)
        echo -e "\n${VERDE}✅ Voltando ao GitHub Center...${RESET}"
        sleep 0.5
        exit 0
        ;;

    *)
        echo -e "\n${VERMELHO}❌ Opção inválida! Tente novamente.${RESET}"
        sleep 1.2
        ;;
    esac
done
