#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# ⬆ PUSH — GitHub Center
# Pure3XEngine 0.2.6 Alpha
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Cores
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
CIANO="\033[1;36m"
CINZA="\033[0;37m"
RESET="\033[0m"

pausa() {
    echo -e "\n${AMARELO}Pressione ENTER para continuar...${RESET}"
    read -r
}

# ==========================================================
# FUNÇÕES DE LEITURA DE STATUS
# ==========================================================
get_branch() { git -C "$ROOT_DIR" branch --show-current 2>/dev/null || echo "---"; }
get_remote_name() { git -C "$ROOT_DIR" remote show 2>/dev/null | head -1 || echo "---"; }
get_commits_a_enviar() { git -C "$ROOT_DIR" rev-list --count --left-only HEAD "@{u}" 2>/dev/null || echo 0; }
get_commits_remoto_a_baixar() { git -C "$ROOT_DIR" rev-list --count --right-only HEAD "@{u}" 2>/dev/null || echo 0; }
tem_remoto_configurado() { git -C "$ROOT_DIR" remote get-url origin >/dev/null 2>&1; }

# ==========================================================
# BARRA DE PROGRESSO — PASSO A PASSO
# ==========================================================
passo() {
    local NOME="$1"
    echo -ne " $NOME..................."
    sleep 0.35
    echo -e "${VERDE} OK${RESET}"
}

barra_progresso_push() {
    echo
    echo -e "${CIANO}Executando: git push origin $BRANCH${RESET}"
    echo
    passo "Preparando"
    passo "Verificando remoto"
    passo "Enviando commits"
    passo "Atualizando GitHub"
    echo
}

# ==========================================================
# TELA DE STATUS NO TOPO
# ==========================================================
mostrar_status() {
    BRANCH=$(get_branch)
    REMOTO=$(get_remote_name)
    QTD_ENVIAR=$(get_commits_a_enviar)
    QTD_BAIXAR=$(get_commits_remoto_a_baixar)

    echo -e "${CIANO}📊 Status do Repositório${RESET}"
    echo "--------------------------------------------------------------"
    printf " 📂 Projeto............. Pure3XEngine\n"
    printf " 🌿 Branch.............. %s\n" "$BRANCH"
    printf " 📤 Commits locais...... %s\n" "$QTD_ENVIAR"
    printf " 📥 Remoto à frente..... %s\n" "$QTD_BAIXAR"
    printf " ☁ Origem............... %s\n" "$REMOTO"
    printf " 🔗 Remoto.............. GitHub\n"
    echo "--------------------------------------------------------------"
    echo

    if [ "$QTD_BAIXAR" -gt 0 ]; then
        echo -e "${AMARELO}⚠️  O repositório remoto tem $QTD_BAIXAR alteração(ões) que você não tem localmente.${RESET}"
        echo -e "${CIANO}➡ Recomendado: Escolha a opção 6 primeiro — git pull --rebase${RESET}"
        echo
    fi
}

# ==========================================================
# CONFIRMAÇÃO PADRÃO ANTES DE ENVIAR
# ==========================================================
confirmar_push() {
    local BRANCH_ALVO="$1"
    local QTD="$2"

    echo
    echo -e "${AMARELO}⚠️  Você está prestes a enviar:${RESET}"
    echo "--------------------------------------------------------------"
    printf " 🌿 Branch  : %s\n" "$BRANCH_ALVO"
    printf " 📦 Destino  : origin/%s\n" "$BRANCH_ALVO"
    printf " 📤 Commits  : %s\n" "$QTD"
    echo "--------------------------------------------------------------"
    echo
    read -r -p "Continuar? (s/N): " resp
    [[ "$resp" == "s" || "$resp" == "S" ]] && return 0 || return 1
}

# ==========================================================
# LOOP PRINCIPAL
# ==========================================================
while true
do
    clear

    echo -e "${AZUL}==============================================================${RESET}"
    echo -e "${AZUL}⬆ PUSH — GitHub Center${RESET}"
    echo -e "${AZUL}Pure3XEngine 0.2.6 Alpha${RESET}"
    echo -e "${AZUL}==============================================================${RESET}"
    echo
    echo -e "📅 Data: $(date +%d/%m/%Y)   🕒 Hora: $(date +%H:%M:%S)"
    echo

    mostrar_status

    echo -e "${AMARELO}Opções Disponíveis${RESET}"
    echo
    echo "  1) ⬆ Enviar commits para o GitHub"
    echo "     git push origin $(get_branch)"
    echo
    echo "  2) 🚀 Push forçado — sobrescreve o remoto ⚠ AVANÇADO"
    echo "     git push --force origin $(get_branch)"
    echo
    echo "  3) 🌿 Escolher outra branch para enviar"
    echo
    echo "  4) 🔍 Testar conexão e autenticação com GitHub"
    echo "     ssh -T git@github.com"
    echo
    echo "  5) 📄 Ver quais commits serão enviados"
    echo "     git log --oneline --no-push origin/$(get_branch)..HEAD"
    echo
    echo "  6) 🔄 Buscar alterações antes de enviar"
    echo "     git pull --rebase origin $(get_branch)"
    echo
    echo "  0) ← Voltar ao GitHub Center"
    echo

    read -r -p "Escolha uma opção: " op

    BRANCH=$(get_branch)
    QTD_ENVIAR=$(get_commits_a_enviar)

    case "$op" in

    1)
        if ! tem_remoto_configurado; then
            echo
            echo -e "${VERMELHO}❌ Repositório remoto não configurado!${RESET}"
            echo -e "${CIANO}➡ Vá em: 10) Repositório Remoto${RESET}"
            pausa
            continue
        fi

        QTD_BAIXAR=$(get_commits_remoto_a_baixar)
        if [ "$QTD_BAIXAR" -gt 0 ]; then
            echo
            echo -e "${AMARELO}⚠️ O repositório remoto tem $QTD_BAIXAR alteração(ões) que você não tem localmente.${RESET}"
            echo -e "${CIANO}➡ Recomendado: Escolha a opção 6 — Buscar antes de enviar${RESET}"
            echo
            read -r -p "Deseja tentar enviar mesmo assim? (s/N): " resp
            case "$resp" in
                s|S) ;;
                *) pausa; continue ;;
            esac
        fi

        if [ "$QTD_ENVIAR" -eq 0 ]; then
            echo
            echo -e "${CIANO}ℹ Nada para enviar.${RESET}"
            echo
            echo "Seu repositório já está sincronizado com o GitHub."
            pausa
            continue
        fi

        # ✅ CONFIRMAÇÃO OBRIGATÓRIA ANTES DE ENVIAR
        confirmar_push "$BRANCH" "$QTD_ENVIAR" || { pausa; continue; }

        echo
        echo -e "${AZUL}Enviando commits...${RESET}"
        barra_progresso_push

        SAIDA=$(git -C "$ROOT_DIR" push origin "$BRANCH" 2>&1)
        CODIGO=$?

        if [ $CODIGO -eq 0 ]; then
            echo -e "${VERDE}==============================================================${RESET}"
            echo -e "${VERDE}✅ PUSH REALIZADO COM SUCESSO!${RESET}"
            echo -e "${VERDE}==============================================================${RESET}"
            echo -e " 🌿 Branch         : $BRANCH"
            echo -e " 📤 Commits enviados: $QTD_ENVIAR"
            echo -e " ☁ Repositório     : GitHub"
            echo
            echo "Repositório sincronizado com GitHub."
            echo
            echo -e "${CIANO}➡ Próximo passo:${RESET}"
            echo "   12) 🚀 Release Manager — criar versão"
            echo "   13) 📦 Publicador P3XE — publicar oficialmente"
        else
            if echo "$SAIDA" | grep -qi "permission\|denied\|authentication\|credential"; then
                echo -e "${VERMELHO}❌ Falha na autenticação.${RESET}"
                echo
                echo "Verifique:"
                echo "  ${VERDE}✓${RESET} Git configurado com nome e e-mail"
                echo "  ${VERDE}✓${RESET} Chave SSH criada e adicionada no GitHub"
                echo "  ${VERDE}✓${RESET} Permissões de escrita no repositório"
                echo "  ${VERDE}✓${RESET} Conexão com a Internet"
                echo
                echo -e "${CIANO}➡ Teste a opção 4 primeiro para diagnosticar${RESET}"
            elif echo "$SAIDA" | grep -qi "fetch first\|rejected\|behind"; then
                echo -e "${AMARELO}⚠️ Push rejeitado — remoto tem alterações que faltam aqui.${RESET}"
                echo
                echo -e "${CIANO}➡ Execute a opção 6: git pull --rebase${RESET}"
                echo "   Resolva possíveis conflitos e tente o Push novamente."
            else
                echo -e "${VERMELHO}❌ Falha ao enviar.${RESET}"
                echo
                echo "Detalhes do erro:"
                echo -e "${CINZA}$SAIDA${RESET}"
            fi
        fi
        pausa
        ;;

    2)
        echo
        echo -e "${VERMELHO}⚠️  ATENÇÃO: Push forçado PODE SOBRESCREVER commits no GitHub!${RESET}"
        echo "Isso afeta TODOS que já clonaram ou fizeram fork do repositório."
        echo
        read -r -p "DIGITE SIM para confirmar push FORÇADO em $BRANCH: " conf
        if [ "$conf" != "SIM" ]; then
            echo -e "${AMARELO}⏭️  Cancelado. Nada foi alterado.${RESET}"
            pausa
            continue
        fi

        confirmar_push "$BRANCH" "$QTD_ENVIAR" || { pausa; continue; }

        barra_progresso_push
        git -C "$ROOT_DIR" push --force origin "$BRANCH"
        if [ $? -eq 0 ]; then
            echo -e "${VERDE}✅ Push forçado concluído.${RESET}"
        else
            echo -e "${VERMELHO}❌ Falha no push forçado. Verifique conexão e permissões.${RESET}"
        fi
        pausa
        ;;

    3)
        echo
        echo -e "${AZUL}🌿 Branches disponíveis:${RESET}"
        git -C "$ROOT_DIR" branch --list | sed 's/^/  /'
        echo
        read -rp "Digite o nome da branch para enviar: " NOVA_BRANCH
        if [ -z "$NOVA_BRANCH" ]; then
            echo -e "${VERMELHO}❌ Nome vazio.${RESET}"
        elif ! git -C "$ROOT_DIR" show-ref --verify --quiet "refs/heads/$NOVA_BRANCH"; then
            echo -e "${VERMELHO}❌ Branch '$NOVA_BRANCH' não existe localmente.${RESET}"
        else
            QTD=$(git -C "$ROOT_DIR" rev-list --count --left-only "$NOVA_BRANCH" "@{u}" 2>/dev/null || echo 0)
            if [ "$QTD" -eq 0 ]; then
                echo
                echo -e "${CIANO}ℹ Nada para enviar em $NOVA_BRANCH.${RESET}"
            else
                confirmar_push "$NOVA_BRANCH" "$QTD" || { pausa; continue; }
                BRANCH="$NOVA_BRANCH"
                barra_progresso_push
                git -C "$ROOT_DIR" push origin "$BRANCH"
                [ $? -eq 0 ] && echo -e "${VERDE}✅ Enviado: $BRANCH${RESET}"
            fi
        fi
        pausa
        ;;

    4)
        clear
        echo -e "${AZUL}==============================================================${RESET}"
        echo -e "${AZUL}🔍 TESTE DE CONEXÃO — GitHub Center${RESET}"
        echo -e "${AZUL}Pure3XEngine 0.2.6 Alpha${RESET}"
        echo -e "${AZUL}==============================================================${RESET}"
        echo
        echo -e "📅 Data: $(date +%d/%m/%Y)   🕒 Hora: $(date +%H:%M:%S)"
        echo

        if REMOTO_URL=$(git -C "$ROOT_DIR" remote get-url origin 2>/dev/null); then
            echo -e "${CIANO}📦 Repositório Remoto${RESET}"
            echo "--------------------------------------------------------------"
            echo " $REMOTO_URL"
            echo
        else
            echo -e "${VERMELHO}❌ Remoto não configurado!${RESET}"
            echo -e "${CIANO}➡ Vá em: 10) Repositório Remoto${RESET}"
            pausa
            continue
        fi

        echo -e "${CIANO}🔑 Teste de Autenticação SSH${RESET}"
        echo "--------------------------------------------------------------"
        echo "Executando: ssh -T git@github.com"
        echo

        SAIDA_SSH=$(ssh -o BatchMode=yes -o ConnectTimeout=10 -T git@github.com 2>&1)
        CODIGO_SSH=$?

        echo -e "${CINZA}$SAIDA_SSH${RESET}"
        echo

        # ✅ CORREÇÃO: Mensagem de boas-vindas = SUCESSO GARANTIDO
        if echo "$SAIDA_SSH" | grep -qi "successfully authenticated\|Hi .*! You've successfully authenticated"; then
            echo -e "${VERDE}✅ AUTENTICAÇÃO CONFIRMADA${RESET}"
            echo
            echo "🔑 Sua chave SSH está funcionando perfeitamente."
            echo "💡 A mensagem 'GitHub does not provide shell access' é NORMAL e esperada."
            echo "   O GitHub não fornece terminal — só acesso a repositórios via Git."
            echo
            echo -e "${CIANO}➡ Agora você pode:${RESET}"
            echo "   1) ⬆ Enviar commits"
            echo "   6) 🔄 Buscar alterações"
            echo "   11) 🔄 Sincronizar Tudo"
        elif [ $CODIGO_SSH -eq 255 ] || echo "$SAIDA_SSH" | grep -qi "Connection refused\|timed out\|Could not resolve"; then
            echo -e "${AMARELO}⚠️ Sem conexão ou GitHub inacessível${RESET}"
            echo
            echo "Verifique:"
            echo "  • Internet funcionando"
            echo "  • Endereço do remoto está correto"
        elif echo "$SAIDA_SSH" | grep -qi "Permission denied"; then
            echo -e "${VERMELHO}❌ Chave SSH não encontrada ou sem permissão${RESET}"
            echo
            echo "Solução:"
            echo "  1. Gerar chave: ssh-keygen -t ed25519 -C \"seu@email.com\""
            echo "  2. Ler chave: cat ~/.ssh/id_ed25519.pub"
            echo "  3. Adicionar no GitHub → Settings → SSH and GPG keys"
        else
            echo -e "${VERMELHO}❌ Falha na autenticação${RESET}"
            echo
            echo "Código: $CODIGO_SSH"
            echo "Verifique sua chave SSH e configuração do remoto."
        fi
        pausa
        ;;

    5)
        echo
        echo -e "${AZUL}📄 Commits que serão enviados${RESET}"
        echo "--------------------------------------------------------------"
        CONTAGEM=$(git -C "$ROOT_DIR" rev-list --count --left-only HEAD "@{u}" 2>/dev/null || echo 0)
        if [ "$CONTAGEM" -eq 0 ]; then
            echo -e "${CIANO}ℹ Nenhum commit novo para enviar.${RESET}"
        else
            git -C "$ROOT_DIR" log --oneline --graph --decorate --stat --left-only HEAD "@{u}"
            echo
            echo -e "${VERDE}Total: $CONTAGEM commit(s)${RESET}"
        fi
        pausa
        ;;

    6)
        echo
        echo -e "${AZUL}🔄 Buscando e reaplicando commits locais...${RESET}"
        echo "git pull --rebase origin $BRANCH"
        echo
        if git -C "$ROOT_DIR" pull --rebase origin "$BRANCH"; then
            echo
            echo -e "${VERDE}✅ Atualizado com sucesso! Agora faça o Push.${RESET}"
        else
            echo
            echo -e "${AMARELO}⚠️ Conflitos encontrados.${RESET}"
            echo "Resolva os arquivos marcados como conflito, depois execute:"
            echo "  git add ."
            echo "  git rebase --continue"
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

