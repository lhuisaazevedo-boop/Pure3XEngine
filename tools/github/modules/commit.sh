#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# 💾 COMMIT — GitHub Center
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
get_stage_count() { git -C "$ROOT_DIR" status --porcelain 2>/dev/null | grep "^[A-Z]" | wc -l; }
get_modified_count() { git -C "$ROOT_DIR" status --porcelain 2>/dev/null | grep "^ M\|^ M\|^D " | wc -l; }
get_untracked_count() { git -C "$ROOT_DIR" ls-files --others --exclude-standard 2>/dev/null | wc -l; }

list_stage_files() {
    git -C "$ROOT_DIR" status --porcelain 2>/dev/null | grep "^[A-Z]" | head -8 | sed 's/^.../ • /'
    local TOTAL=$(get_stage_count)
    if [ "$TOTAL" -gt 8 ]; then
        echo " • ... e mais $(( TOTAL - 8 )) arquivos"
    fi
}

# ==========================================================
# TELA QUANDO NÃO TEM NADA EM STAGE
# ==========================================================
tela_sem_stage() {
    local STAGE=$(get_stage_count)
    local MODIF=$(get_modified_count)
    local UNTR=$(get_untracked_count)

    echo
    echo -e "${AMARELO}📊 Status do Repositório${RESET}"
    echo "--------------------------------------------------------------"
    printf " 📦 Arquivos em Stage   : %s\n" "$STAGE"
    printf " 📝 Arquivos modificados : %s\n" "$MODIF"
    printf " ❔ Não rastreados       : %s\n" "$UNTR"
    echo "--------------------------------------------------------------"
    echo
    echo -e "${AMARELO}⚠️  Nenhum arquivo preparado para commit.${RESET}"
    echo
    echo -e "${CIANO}➡ Sequência recomendada:${RESET}"
    echo "   GitHub Center"
    echo "      ↓"
    echo "   2) ➕ Adicionar Arquivos"
    echo "      ↓"
    echo "   3) 💾 Commit ← você está aqui"
    echo "      ↓"
    echo "   4) ⬆ Push"
    echo
    echo -e "${CIANO}Comando necessário:${RESET}"
    echo "   git add .       → adiciona TUDO"
    echo "   git add arquivo → adiciona um arquivo específico"
    pausa
}

# ==========================================================
# VALIDADOR
# ==========================================================
verificar_stage() {
    local STAGE=$(get_stage_count)
    if [ "$STAGE" -eq 0 ]; then
        tela_sem_stage
        return 1
    fi
    return 0
}

# ==========================================================
# TELA DE SUCESSO APÓS COMMIT
# ==========================================================
tela_sucesso_commit() {
    local MSG="$1"
    local QTD="$2"
    local HASH=$(git -C "$ROOT_DIR" rev-parse --short HEAD)
    local BRANCH=$(get_branch)

    echo
    echo -e "${VERDE}==============================================================${RESET}"
    echo -e "${VERDE}✅ COMMIT REALIZADO COM SUCESSO${RESET}"
    echo -e "${VERDE}==============================================================${RESET}"
    echo -e " 🔑 Hash     : $HASH"
    echo -e " 🌿 Branch   : $BRANCH"
    echo -e " 📦 Arquivos : $QTD"
    echo
    echo -e "${CIANO}📝 Mensagem:${RESET}"
    echo "  $MSG"
    echo
    echo -e "${CIANO}➡ Próximo passo:${RESET}"
    echo "   4) ⬆ Push — enviar para o GitHub"
    pausa
}

# ==========================================================
# LOOP PRINCIPAL
# ==========================================================
while true
do
    clear

    echo -e "${AZUL}==============================================================${RESET}"
    echo -e "${AZUL}💾 COMMIT — GitHub Center${RESET}"
    echo -e "${AZUL}Pure3XEngine 0.2.6 Alpha${RESET}"
    echo -e "${AZUL}==============================================================${RESET}"
    echo
    echo -e "📅 Data: $(date +%d/%m/%Y)   🕒 Hora: $(date +%H:%M:%S)"
    echo

    # Status no topo sempre visível
    STAGE=$(get_stage_count)
    MODIF=$(get_modified_count)
    UNTR=$(get_untracked_count)
    BRANCH=$(get_branch)

    echo -e "${CIANO}📊 Status do Repositório${RESET}"
    echo "--------------------------------------------------------------"
    printf " 📂 Projeto              : Pure3XEngine\n"
    printf " 🌿 Branch               : %s\n" "$BRANCH"
    printf " 📦 Arquivos em Stage   : %s\n" "$STAGE"
    printf " 📝 Arquivos modificados : %s\n" "$MODIF"
    printf " ❔ Não rastreados       : %s\n" "$UNTR"
    echo "--------------------------------------------------------------"
    echo

    echo -e "${AMARELO}Opções Disponíveis${RESET}"
    echo
    echo "  1) 💾 Commit personalizado — escreva sua própria mensagem"
    echo "     git commit -m \"sua mensagem\""
    echo
    echo "  2) ⚡ Commit rápido — mensagem com data e hora automática"
    echo "     git commit -m \"Atualização: $(date +%d/%m/%Y) $(date +%H:%M)\""
    echo
    echo "  3) 📋 Ver histórico completo de todos os commits"
    echo "     git log --oneline --graph --all --decorate"
    echo
    echo "  4) 🔍 Ver exatamente o que mudou antes de confirmar"
    echo "     git diff --cached"
    echo
    echo "  5) ❌ Desfazer último commit (mantém arquivos alterados)"
    echo "     git reset --soft HEAD~1"
    echo
    echo "  0) ← Voltar ao GitHub Center"
    echo

    read -r -p "Escolha uma opção: " op

    case "$op" in

    1)
        verificar_stage || continue

        QTD_STAGE=$(get_stage_count)
        echo
        echo -e "${VERDE}✔ ${QTD_STAGE} arquivos preparados${RESET}"
        echo
        echo -e "${CIANO}Arquivos:${RESET}"
        list_stage_files
        echo
        read -rp "📝 Digite a mensagem do commit: " msg
        if [ -z "$msg" ]; then
            echo -e "${VERMELHO}❌ Mensagem não pode ser vazia!${RESET}"
            pausa
            continue
        fi

        git -C "$ROOT_DIR" commit -m "$msg" >/dev/null 2>&1
        tela_sucesso_commit "$msg" "$QTD_STAGE"
        ;;

    2)
        verificar_stage || continue

        QTD_STAGE=$(get_stage_count)
        msg="Atualização: $(date +%d/%m/%Y) — $(date +%H:%M:%S)"

        echo
        echo -e "${VERDE}✔ ${QTD_STAGE} arquivos preparados${RESET}"
        echo
        echo -e "${CIANO}Mensagem automática:${RESET}"
        echo "  $msg"
        echo
        git -C "$ROOT_DIR" commit -m "$msg" >/dev/null 2>&1
        tela_sucesso_commit "$msg" "$QTD_STAGE"
        ;;

    3)
        clear
        echo -e "${AZUL}==============================================================${RESET}"
        echo -e "${AZUL}📋 HISTÓRICO COMPLETO DE COMMITS${RESET}"
        echo -e "${AZUL}Pure3XEngine 0.2.6 Alpha${RESET}"
        echo -e "${AZUL}==============================================================${RESET}"
        echo
        echo -e "${CIANO}Legenda:${RESET}"
        echo -e "  ${VERDE}●${RESET} = commit  ·  ${AMARELO}→${RESET} = branch  ·  ${AZUL}*${RESET} = merge"
        echo
        echo "--------------------------------------------------------------"
        git -C "$ROOT_DIR" log --oneline --graph --all --decorate --stat --color=never
        echo "--------------------------------------------------------------"
        echo
        echo -e "${VERDE}Total de commits: $(git -C "$ROOT_DIR" rev-list --count HEAD 2>/dev/null || echo 0)${RESET}"
        pausa
        ;;

    4)
        verificar_stage || continue
        echo
        echo -e "${AZUL}🔍 Diferenças que serão commitadas:${RESET}"
        echo "--------------------------------------------------------------"
        git -C "$ROOT_DIR" diff --cached
        pausa
        ;;

    5)
        echo
        read -rp "${AMARELO}Tem certeza? Desfaz o último commit mantendo os arquivos alterados. (s/N): " resp
        case "$resp" in
            s|S)
                if git -C "$ROOT_DIR" reset --soft HEAD~1 2>/dev/null; then
                    echo -e "${VERDE}✅ Último commit desfeito — arquivos continuam preparados.${RESET}"
                else
                    echo -e "${VERMELHO}❌ Não existe commit para desfazer!${RESET}"
                fi
                ;;
            *)
                echo -e "${AMARELO}⏭️  Cancelado. Nada foi alterado.${RESET}"
                ;;
        esac
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

