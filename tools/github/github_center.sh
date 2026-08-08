#!/data/data/com.termux/files/usr/bin/bash

VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

pausa() {
    echo
    read -r -p "Pressione ENTER para continuar..."
}

while true; do
    clear
    echo "============================================================"
    echo "          PAINEL DE CONTROLE P3XE"
    echo "          Pure3XEngine 0.2.6 Alpha"
    echo "============================================================"
    echo
    echo "📅 Data: $(date '+%d/%m/%Y')    ⏰ Hora: $(date '+%H:%M:%S')"
    echo "📂 Projeto: $ROOT_DIR"
    echo
    echo -e "${VERDE}GITHUB CENTER${RESET}"
    echo "============================================================"
    echo
    echo "  1) 📊 Status"
    echo "  2) ➕ Adicionar Arquivos"
    echo "  3) 📝 Commit"
    echo "  4) 📤 Push"
    echo "  5) 📥 Pull"
    echo "  6) 🌿 Branches"
    echo "  7) 🏷 Tags"
    echo "  8) 📜 Histórico"
    echo "  9) ⚙ Configurar Git"
    echo " 10) 🔗 Repositório Remoto"
    echo " 11) 🔄 Sincronizar Tudo"
    echo " 12) 🚀 Release Manager"
    echo " 13) 📦 Publicador P3XE"
    echo " 14) 🖼 Banner Manager"
    echo " 15) 📄 README Manager"
    echo
    echo "  0) ← Voltar"
    echo
    read -r -p "Escolha uma opção: " op

    case "$op" in
        1)
            clear
            echo -e "${AMARELO}📊 STATUS${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git status
            pausa
            ;;

        2)
            clear
            echo -e "${AMARELO}➕ ADICIONAR ARQUIVOS${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git add .
            echo -e "${VERDE}✅ Todos os arquivos adicionados${RESET}"
            pausa
            ;;

        3)
            clear
            echo -e "${AMARELO}📝 COMMIT${RESET}"
            echo "============================================================"
            echo
            echo "  1) 📥 Downloads — do telefone"
            echo "  2) 📂 P3XE — pasta do projeto"
            echo
            read -r -p "Escolha: " sub3

            if [ "$sub3" = "1" ]; then
                clear
                echo -e "${AMARELO}📥 DOWNLOADS — Arquivos do telefone${RESET}"
                echo "============================================================"
                echo
                echo "📂 Caminho: /storage/emulated/0/Download/"
                echo
                ls -lh /storage/emulated/0/Download/*.png /storage/emulated/0/Download/*.jpg /storage/emulated/0/Download/*.jpeg 2>/dev/null
                echo
                read -r -p "Copiar arquivo para a pasta do projeto? (s/N): " resp
                if [[ "$resp" =~ ^[sS]$ ]]; then
                    read -r -p "Nome do arquivo: " arq
                    if [ -f "/storage/emulated/0/Download/$arq" ]; then
                        mkdir -p "$ROOT_DIR/assets/banners"
                        cp "/storage/emulated/0/Download/$arq" "$ROOT_DIR/assets/banners/"
                        echo -e "${VERDE}✅ Copiado para assets/banners/${RESET}"
                    else
                        echo -e "${VERMELHO}❌ Arquivo não encontrado${RESET}"
                    fi
                fi
                pausa
            elif [ "$sub3" = "2" ]; then
                clear
                echo -e "${AMARELO}📂 P3XE — Navegar nas pastas do projeto${RESET}"
                echo "============================================================"
                DIR_ATUAL="$ROOT_DIR"
                while true; do
                    echo
                    echo "📁 Pasta: ${DIR_ATUAL#$ROOT_DIR/}"
                    echo
                    echo "  0) ⬆ Voltar pasta"
                    echo "  -) 🏠 Voltar raiz"
                    echo "  <) ↩ Sair da navegação"
                    echo
                    for item in "$DIR_ATUAL"/*; do
                        [ -e "$item" ] || continue
                        nome=$(basename "$item")
                        if [ -d "$item" ]; then
                            echo "   📂 $nome/"
                        elif [[ "$nome" =~ \.(png|jpg|jpeg|gif|webp)$ ]]; then
                            echo "   🖼 $nome"
                        fi
                    done
                    echo
                    read -r -p "Digite nome da pasta ou arquivo: " escolha
                    case "$escolha" in
                        0) DIR_ATUAL=$(dirname "$DIR_ATUAL"); [ "$DIR_ATUAL" = "/" ] && DIR_ATUAL="$ROOT_DIR" ;;
                        -) DIR_ATUAL="$ROOT_DIR" ;;
                        \<) break ;;
                        *)
                            caminho="$DIR_ATUAL/$escolha"
                            if [ -d "$caminho" ]; then
                                DIR_ATUAL="$caminho"
                            elif [ -f "$caminho" ] && [[ "$escolha" =~ \.(png|jpg|jpeg|gif|webp)$ ]]; then
                                echo
                                read -r -p "Selecionar '$escolha' como banner? (S/n): " resp_arq
                                if [[ "$resp_arq" =~ ^[sS]$ ]] || [ -z "$resp_arq" ]; then
                                    mkdir -p "$ROOT_DIR/assets/banners"
                                    cp "$caminho" "$ROOT_DIR/assets/banners/"
                                    echo -e "${VERDE}✅ Selecionado: $escolha${RESET}"
                                fi
                                break
                            fi
                            ;;
                    esac
                done
                pausa
            fi
            ;;

        4)
            clear
            echo -e "${AMARELO}📤 PUSH${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git push
            echo -e "${VERDE}✅ Enviado${RESET}"
            pausa
            ;;

        5)
            clear
            echo -e "${AMARELO}📥 PULL${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git pull
            echo -e "${VERDE}✅ Atualizado${RESET}"
            pausa
            ;;

        6)
            clear
            echo -e "${AMARELO}🌿 BRANCHES${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git branch
            pausa
            ;;

        7)
            clear
            echo -e "${AMARELO}🏷 TAGS${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git tag
            pausa
            ;;

        8)
            clear
            echo -e "${AMARELO}📜 HISTÓRICO${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git log --oneline -20
            pausa
            ;;

        9)
            clear
            echo -e "${AMARELO}⚙ CONFIGURAR GIT${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git config --local --list
            pausa
            ;;

        10)
            clear
            echo -e "${AMARELO}🔗 REPOSITÓRIO REMOTO${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git remote -v
            pausa
            ;;

        11)
            clear
            echo -e "${AMARELO}🔄 SINCRONIZAR TUDO${RESET}"
            echo "============================================================"
            cd "$ROOT_DIR"
            git add .
            read -r -p "Mensagem do commit: " msg
            git commit -m "$msg"
            git push
            echo -e "${VERDE}✅ Sincronizado!${RESET}"
            pausa
            ;;

        12)
            clear
            echo -e "${AMARELO}🚀 RELEASE MANAGER${RESET}"
            echo "============================================================"
            echo "Função em desenvolvimento..."
            pausa
            ;;

        13)
            clear
            echo -e "${AMARELO}📦 PUBLICADOR P3XE${RESET}"
            echo "============================================================"
            echo "Função em desenvolvimento..."
            pausa
            ;;

        14)
            bash "$ROOT_DIR/tools/github/modules/banner.sh"
            echo
            echo -e "${VERDE}✅ Retornando ao GitHub Center...${RESET}"
            sleep 0.8
            ;;

        15)
            clear
            echo -e "${AMARELO}📄 README MANAGER${RESET}"
            echo "============================================================"
            echo "Função em desenvolvimento..."
            pausa
            ;;

        0)
            echo -e "\n${VERDE}✅ Voltando...${RESET}"
            sleep 0.5
            exit 0
            ;;

        *)
            echo -e "\n${VERMELHO}❌ Opção inválida!${RESET}"
            sleep 1.2
            ;;
    esac
done
