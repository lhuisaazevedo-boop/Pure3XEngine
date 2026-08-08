#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# 📝 README MANAGER — GitHub Center
# Pure3XEngine 0.2.6 Alpha
# ==========================================================

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

README_NAME="README.md"
README_DEST="$ROOT_DIR/$README_NAME"
PASTA_EXTERNA="/storage/emulated/0/P3XE"
README_SOURCE=""

VERSAO_ATUAL="0.2.6 Alpha"

BACKUP_DIR="$ROOT_DIR/.readme_backups"
mkdir -p "$BACKUP_DIR"

EXISTE=0
TAMANHO="--"
LINHAS="--"
ULTIMA_EDICAO="--"

# ==========================================================
# PERMISSÕES
# ==========================================================
verificar_permissoes() {
    local caminho="$1"
    local acao="${2:-acessar}"
    if [ ! -w "$caminho" ]; then
        echo -e "${AMARELO}🔒 Sem permissão de $acao em: $caminho${RESET}"
        chmod -R u+w "$caminho" 2>/dev/null
        if [ ! -w "$caminho" ]; then
            echo -e "${VERMELHO}❌ Falha — execute: chmod -R u+w $ROOT_DIR${RESET}"
            return 1
        fi
        echo -e "${VERDE}✅ Permissão corrigida!${RESET}"
    fi
    return 0
}

# ==========================================================
# INFO DO README
# ==========================================================
obter_info_readme() {
    EXISTE=0
    TAMANHO="--"
    LINHAS="--"
    ULTIMA_EDICAO="--"

    if [ -f "$README_DEST" ]; then
        EXISTE=1
        TAMANHO=$(du -h "$README_DEST" | cut -f1)
        LINHAS=$(wc -l < "$README_DEST" 2>/dev/null)
        ULTIMA_EDICAO=$(stat -c %y "$README_DEST" 2>/dev/null | cut -d' ' -f1)
    fi
}

# ==========================================================
# EXTRAIR VERSÃO DO README
# ==========================================================
extrair_versao() {
    [ ! -f "$README_DEST" ] && return
    local v
    v=$(grep -oE 'v[0-9]+\.[0-9]+(\.[0-9]+)?' "$README_DEST" | head -n1)
    [ -n "$v" ] && VERSAO_ATUAL="$v"
}

# ==========================================================
# MOSTRAR STATUS
# ==========================================================
mostrar_status() {
    obter_info_readme
    local DATA_ATUAL=$(date '+%d/%m/%Y')
    local HORA_ATUAL=$(date '+%H:%M:%S')

    clear
    cabecalho
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}📝 README MANAGER — GitHub Center${RESET}"
    echo -e "${AZUL}Pure3XEngine 0.2.6 Alpha${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo

    echo -e "${CIANO}README Atual${RESET}"
    echo -e "${AZUL}--------------------------------------------------${RESET}"
    echo -e "Arquivo......: $README_NAME"

    if [ $EXISTE -eq 1 ]; then
        echo -e "Status.......: ${VERDE}✅ Encontrado${RESET}"
        echo -e "Tamanho......: $TAMANHO"
        echo -e "Linhas.......: $LINHAS"
        echo -e "Última edição.: $ULTIMA_EDICAO"
    else
        echo -e "Status.......: ${VERMELHO}❌ Não encontrado${RESET}"
        echo -e "Tamanho......: --"
        echo -e "Linhas.......: --"
        echo -e "Última edição.: --"
        [ -n "$README_SOURCE" ] && echo -e "${AMARELO}⚠ Arquivo pronto: $README_SOURCE${RESET}"
    fi

    echo -e "${AZUL}--------------------------------------------------${RESET}"
    echo
}

# ==========================================================
# MENU PRINCIPAL
# ==========================================================
while true
do
    mostrar_status

    echo -e "${CIANO}Opções Disponíveis${RESET}"
    echo

    echo "  1) 📂 Selecionar README"
    [ $EXISTE -eq 1 ] && echo "  2) 📖 Visualizar README"
    [ $EXISTE -eq 1 ] && echo "  3) 🔍 Validar README"
    [ $EXISTE -eq 1 ] && echo "  4) ✏ Editar README"
    [ $EXISTE -eq 1 ] && [ -f "$ROOT_DIR/assets/images/cubo3d_laucher.png" ] && echo "  5) 🖼 Inserir Banner"
    [ $EXISTE -eq 1 ] && echo "  6) 🏷 Atualizar Versão"
    [ $EXISTE -eq 1 ] && echo "  7) 📊 Atualizar Estatísticas"
    [ $EXISTE -eq 1 ] && echo "  8) 🧹 Formatar Markdown"
    [ $EXISTE -eq 1 ] && echo "  9) 👁 Pré-visualizar"
    [ $EXISTE -eq 1 ] && echo " 10) 🚀 Publicar no GitHub"
    [ $EXISTE -eq 1 ] && echo " 11) 💾 Fazer Backup"
    [ -n "$(ls -1 "$BACKUP_DIR"/README_*.md 2>/dev/null)" ] && echo " 12) ♻ Restaurar Backup"
    echo " 13) 📄 Gerar README Padrão"
    echo " 14) 🔄 Substituir README"
    [ $EXISTE -eq 1 ] && echo " 15) 🗑 Remover README"
    echo
    echo "  0) ↩ Voltar"
    echo

    read -r -p "Escolha uma opção: " op

    case "$op" in

        # ==================================================
        # 1) 📂 SELECIONAR README
        # ==================================================
        1)
            clear; cabecalho; echo "📂 SELECIONAR README"; echo "=================================================="; echo
            README_SOURCE=""
            # SEM local aqui — array declarado sem local
            caminhos=(
                "$ROOT_DIR/$README_NAME"
                "$PASTA_EXTERNA/$README_NAME"
                "/storage/emulated/0/Pure3XEngine/$README_NAME"
            )
            for caminho in "${caminhos[@]}"; do
                if [ -f "$caminho" ]; then
                    README_SOURCE="$caminho"
                    echo -e "${VERDE}✅ Encontrado: $caminho${RESET}"
                    break
                fi
            done
            if [ -z "$README_SOURCE" ]; then
                echo -e "${AMARELO}⚠ Não encontrado automaticamente${RESET}"
                read -r -p "Caminho completo: " README_SOURCE
            fi
            if [ -f "$README_SOURCE" ]; then
                sucesso "Selecionado!"
                echo -e "   $README_SOURCE"
            else
                erro "Arquivo não encontrado"
                README_SOURCE=""
            fi
            pausa
            ;;

        # ==================================================
        # 2) 📖 VISUALIZAR README
        # ==================================================
        2)
            clear; cabecalho; echo "📖 VISUALIZAR README"; echo "=================================================="; echo
            echo -e "${CIANO}Exibindo: $README_DEST${RESET}"
            echo
            less "$README_DEST"
            pausa
            ;;

        # ==================================================
        # 3) 🔍 VALIDAR README
        # ==================================================
        3)
            clear; cabecalho; echo "🔍 VALIDAR README"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "README não existe"; pausa; continue; }

            OK=0

            if grep -qE "^# .+" "$README_DEST"; then
                echo -e "📌 Título principal............ ${VERDE}✅ Encontrado${RESET}"
            else
                echo -e "📌 Título principal............ ${VERMELHO}❌ Faltando '# Nome do Projeto'${RESET}"
                OK=1
            fi

            if grep -qE "!\[.*\]\(.*\.(png|jpg|jpeg|gif)\)" "$README_DEST"; then
                echo -e "🖼 Imagem/Banner............... ${VERDE}✅ Presente${RESET}"
            else
                echo -e "🖼 Imagem/Banner............... ${AMARELO}⚠ Recomendado — use opção 5${RESET}"
            fi

            if grep -qE "## (Instalação|Uso|Como usar)" "$README_DEST"; then
                echo -e "📘 Seção de Instruções......... ${VERDE}✅ Encontrada${RESET}"
            else
                echo -e "📘 Seção de Instruções......... ${AMARELO}⚠ Recomendado${RESET}"
            fi

            if grep -qE "git\s+clone|github\.com" "$README_DEST"; then
                echo -e "🔗 Link do GitHub.............. ${VERDE}✅ Encontrado${RESET}"
            else
                echo -e "🔗 Link do GitHub.............. ${AMARELO}⚠ Recomendado${RESET}"
            fi

            if grep -qE "Licen[çc]a|MIT|GPL|Apache" "$README_DEST"; then
                echo -e "⚖ Licença...................... ${VERDE}✅ Encontrada${RESET}"
            else
                echo -e "⚖ Licença...................... ${AMARELO}⚠ Recomendado${RESET}"
            fi

            LINHAS_ARQ=$(wc -l < "$README_DEST")
            if [ "$LINHAS_ARQ" -ge 50 ]; then
                echo -e "📄 Tamanho adequado............ ${VERDE}✅ ${LINHAS_ARQ} linhas${RESET}"
            elif [ "$LINHAS_ARQ" -ge 20 ]; then
                echo -e "📄 Tamanho adequado............ ${AMARELO}⚠ ${LINHAS_ARQ} linhas — pode expandir${RESET}"
            else
                echo -e "📄 Tamanho adequado............ ${VERMELHO}❌ Apenas ${LINHAS_ARQ} linhas — muito curto${RESET}"
                OK=1
            fi

            echo
            if [ $OK -eq 0 ]; then
                echo -e "${VERDE}✅ VALIDAÇÃO CONCLUÍDA — pronto para GitHub!${RESET}"
            else
                echo -e "${AMARELO}⚠ VALIDAÇÃO concluída — corrija os itens marcados${RESET}"
            fi
            pausa
            ;;

        # ==================================================
        # 4) ✏ EDITAR README
        # ==================================================
        4)
            clear; cabecalho; echo "✏ EDITAR README"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "Crie ou selecione um README primeiro"; pausa; continue; }
            echo -e "${CIANO}Abrindo no Nano...${RESET}"
            sleep 0.5
            nano "$README_DEST"
            obter_info_readme
            echo
            sucesso "Salvo! Agora tem $LINHAS linhas e $TAMANHO"
            pausa
            ;;

        # ==================================================
        # 5) 🖼 INSERIR BANNER
        # ==================================================
        5)
            clear; cabecalho; echo "🖼 INSERIR BANNER"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "README não existe"; pausa; continue; }

            BANNER_CAMINHO="$ROOT_DIR/assets/images/cubo3d_laucher.png"
            if [ ! -f "$BANNER_CAMINHO" ]; then
                echo -e "${VERMELHO}❌ Banner não encontrado${RESET}"
                echo -e "${CIANO}💡 Instale o banner primeiro no Banner Manager${RESET}"
                pausa
                continue
            fi

            BANNER_MD="![Capa do Projeto](assets/images/cubo3d_laucher.png)"

            if grep -q "cubo3d_laucher.png" "$README_DEST"; then
                echo -e "${AMARELO}⚠ Banner já está inserido no README${RESET}"
                echo -e "${CIANO}Localização:${RESET}"
                grep -n "cubo3d_laucher.png" "$README_DEST"
                pausa
                continue
            fi

            echo -e "${CIANO}Banner que será inserido:${RESET}"
            echo "$BANNER_MD"
            echo
            read -r -p "Inserir logo abaixo do título principal? [S/n]: " resp
            if [[ "$resp" =~ ^[sS]$ ]] || [ -z "$resp" ]; then
                sed -i "/^# .*/a \\
\\
$BANNER_MD\\
" "$README_DEST"
                sucesso "Banner inserido após o título!"
            fi
            pausa
            ;;

        # ==================================================
        # 6) 🏷 ATUALIZAR VERSÃO
        # ==================================================
        6)
            clear; cabecalho; echo "🏷 ATUALIZAR VERSÃO"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "README não existe"; pausa; continue; }

            extrair_versao
            echo -e "Versão atual detectada: ${VERDE}$VERSAO_ATUAL${RESET}"
            echo
            read -r -p "Nova versão (ex: 0.2.7): " NOVA_VERSAO
            [[ ! "$NOVA_VERSAO" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]] && { echo -e "${VERMELHO}❌ Formato inválido${RESET}"; pausa; continue; }

            sed -i "s/$VERSAO_ATUAL/$NOVA_VERSAO/g" "$README_DEST"
            VERSAO_ATUAL="$NOVA_VERSAO"
            sucesso "Versão atualizada para $NOVA_VERSAO em todo o README!"
            pausa
            ;;

        # ==================================================
        # 7) 📊 ATUALIZAR ESTATÍSTICAS
        # ==================================================
        7)
            clear; cabecalho; echo "📊 ATUALIZAR ESTATÍSTICAS"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "README não existe"; pausa; continue; }

            echo -e "${CIANO}📂 Contando arquivos do projeto...${RESET}"
            TOTAL_CPP=$(find "$ROOT_DIR" -name '*.cpp' -type f 2>/dev/null | wc -l)
            TOTAL_H=$(find "$ROOT_DIR" -name '*.h' -o -name '*.hpp' -type f 2>/dev/null | wc -l)
            TOTAL_SH=$(find "$ROOT_DIR" -name '*.sh' -type f 2>/dev/null | wc -l)
            TOTAL_CMAKE=$(find "$ROOT_DIR" -name 'CMakeLists.txt' -type f 2>/dev/null | wc -l)
            LINHAS_TOTAIS=$(find "$ROOT_DIR" -name '*.cpp' -o -name '*.h' -o -name '*.hpp' -type f -exec cat {} + 2>/dev/null | wc -l)

            echo -e "   📄 Arquivos C++....: $TOTAL_CPP"
            echo -e "   📄 Arquivos Header..: $TOTAL_H"
            echo -e "   📄 Scripts Shell....: $TOTAL_SH"
            echo -e "   📄 CMake...........: $TOTAL_CMAKE"
            echo -e "   📊 Linhas de código: $LINHAS_TOTAIS"
            echo

            read -r -p "Inserir/Atualizar no README? [S/n]: " resp
            if [[ "$resp" =~ ^[sS]$ ]]; then
                ESTATISTICA="\n## 📊 Estatísticas\n\n- 📄 Arquivos C++: **$TOTAL_CPP**\n- 📄 Arquivos Header: **$TOTAL_H**\n- 📄 Scripts Shell: **$TOTAL_SH**\n- 📄 CMake: **$TOTAL_CMAKE**\n- 📊 Linhas de código: **$LINHAS_TOTAIS**\n"
                if grep -q "## 📊 Estatísticas" "$README_DEST"; then
                    sed -i '/## 📊 Estatísticas/,/^## /{ /## 📊 Estatísticas/!{ /^## /!d; }; }' "$README_DEST"
                    sed -i "s/## 📊 Estatísticas.*/$ESTATISTICA/" "$README_DEST"
                else
                    echo -e "$ESTATISTICA" >> "$README_DEST"
                fi
                sucesso "Estatísticas atualizadas!"
            fi
            pausa
            ;;

        # ==================================================
        # 8) 🧹 FORMATAR MARKDOWN
        # ==================================================
        8)
            clear; cabecalho; echo "🧹 FORMATAR MARKDOWN"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "README não existe"; pausa; continue; }

            BACKUP="$BACKUP_DIR/formatar_$(date +%Y%m%d_%H%M%S).md"
            cp "$README_DEST" "$BACKUP"
            echo -e "💾 Backup criado: $(basename "$BACKUP")"
            echo

            echo -e "${CIANO}🧹 Aplicando formatação...${RESET}"
            sed -i 's/[ \t]*$//' "$README_DEST"
            sed -i '/^$/N;/^\n$/d' "$README_DEST"
            echo -e "${VERDE}✅ Espaços em branco removidos${RESET}"
            echo -e "${VERDE}✅ Linhas vazias duplicadas limpas${RESET}"
            echo
            sucesso "Formatação concluída!"
            pausa
            ;;

        # ==================================================
        # 9) 👁 PRÉ-VISUALIZAR
        # ==================================================
        9)
            clear; cabecalho; echo "👁 PRÉ-VISUALIZAR"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "README não existe"; pausa; continue; }

            echo -e "${CIANO}📋 Versão formatada para visualização${RESET}"
            echo -e "${AMARELO}ⓘ Isso é apenas texto — não é renderização real${RESET}"
            echo
            head -80 "$README_DEST"
            echo
            echo -e "${CIANO}... (mostradas as primeiras 80 linhas)${RESET}"
            pausa
            ;;

        # ==================================================
        # 10) 🚀 PUBLICAR NO GITHUB
        # ==================================================
        10)
            clear; cabecalho; echo "🚀 PUBLICAR NO GITHUB"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "README não existe"; pausa; continue; }

            cd "$ROOT_DIR"
            if [ ! -d ".git" ]; then
                echo -e "${AMARELO}⚠ Repositório Git não inicializado${RESET}"
                read -r -p "Inicializar agora? [S/n]: " resp
                if [[ "$resp" =~ ^[sS]$ ]]; then
                    git init
                    git config user.name "P3XE Developer"
                    git config user.email "dev@p3xe.local"
                fi
            fi

            echo -e "${CIANO}📋 Próximos passos:${RESET}"
            echo "   git add README.md"
            echo "   git commit -m 'Atualizar README'"
            echo "   git push origin main"
            echo
            read -r -p "Adicionar e commitar agora? [S/n]: " resp
            if [[ "$resp" =~ ^[sS]$ ]]; then
                git add README.md
                git commit -m "docs: atualizar README $(date +%d/%m/%Y)"
                sucesso "Commit criado!"
                echo -e "${AMARELO}⚠ Não esqueça: git push origin main${RESET}"
            fi
            pausa
            ;;

        # ==================================================
        # 11) 💾 FAZER BACKUP
        # ==================================================
        11)
            clear; cabecalho; echo "💾 FAZER BACKUP"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { erro "README não existe"; pausa; continue; }

            NOME_BACKUP="$BACKUP_DIR/README_$(date +%Y%m%d_%H%M%S).md"
            cp "$README_DEST" "$NOME_BACKUP"
            echo -e "💾 Salvo em: $(basename "$NOME_BACKUP")"
            echo -e "📦 Tamanho: $(du -h "$NOME_BACKUP" | cut -f1)"
            echo
            echo -e "${CIANO}📂 Backups disponíveis: $(ls -1 "$BACKUP_DIR"/README_*.md 2>/dev/null | wc -l)${RESET}"
            sucesso "Backup concluído!"
            pausa
            ;;

        # ==================================================
        # 12) ♻ RESTAURAR BACKUP
        # ==================================================
        12)
            clear; cabecalho; echo "♻ RESTAURAR BACKUP"; echo "=================================================="; echo

            BACKUPS=($(ls -1t "$BACKUP_DIR"/README_*.md 2>/dev/null))
            QTD=${#BACKUPS[@]}

            if [ $QTD -eq 0 ]; then
                echo -e "${AMARELO}⚠ Nenhum backup encontrado${RESET}"
                pausa
                continue
            fi

            echo -e "${CIANO}📦 $QTD backups encontrados (mais recente primeiro):${RESET}"
            echo
            for i in "${!BACKUPS[@]}"; do
                echo "   $((i+1))) $(basename "${BACKUPS[$i]}")  —  $(du -h "${BACKUPS[$i]}" | cut -f1)"
            done
            echo
            read -r -p "Número para restaurar (0=cancelar): " escolha

            if [[ "$escolha" =~ ^[0-9]+$ ]] && [ "$escolha" -ge 1 ] && [ "$escolha" -le $QTD ]; then
                IDX=$((escolha-1))
                ARQ_REST="${BACKUPS[$IDX]}"
                echo -e "${AMARELO}⚠ O README atual será substituído${RESET}"
                read -r -p "Confirmar restauração? [s/N]: " resp
                if [[ "$resp" =~ ^[sS]$ ]]; then
                    cp "$ARQ_REST" "$README_DEST"
                    sucesso "Restaurado: $(basename "$ARQ_REST")"
                fi
            else
                echo "Cancelado."
            fi
            pausa
            ;;

        # ==================================================
        # 13) 📄 GERAR README PADRÃO
        # ==================================================
        13)
            clear; cabecalho; echo "📄 GERAR README PADRÃO"; echo "=================================================="; echo

            if [ -f "$README_DEST" ]; then
                echo -e "${AMARELO}⚠ README já existe — isso irá criar um NOVO${RESET}"
                read -r -p "Fazer backup e criar novo? [S/n]: " resp
                if [[ "$resp" =~ ^[sS]$ ]]; then
                    cp "$README_DEST" "$BACKUP_DIR/README_antes_gerar_$(date +%Y%m%d_%H%M%S).md"
                    echo -e "💾 Backup do atual criado"
                else
                    pausa
                    continue
                fi
            fi

            echo -e "${CIANO}📋 Gerando README padrão...${RESET}"
            cat > "$README_DEST" <<ENDREADME
# Pure3XEngine

> Emulador de PS3 nativo para Android — desenvolvido no Termux sem dependência de PC

![Capa do Projeto](assets/images/cubo3d_laucher.png)

## 📌 Sobre o Projeto

Pure3XEngine é um projeto de emulação original, do zero, sem derivação de código existente. Desenvolvido e compilado diretamente no Android via Termux, sem necessidade de máquina externa.

- 🎯 **Arquitetura modular**: CoreEmulator (núcleo PS3) + Cubo3D (motor gráfico/ laboratório)
- 📱 **Compilação nativa**: Android NDK r27 + CMake + Ninja
- 🖥 **QEMU integrado**: Ambiente de virtualização incluso no kit
- 🧰 **Kit P3XE**: Ferramentas inteligentes de build, diagnóstico e publicação

## 🚀 Começando

### Pré-requisitos
- Android 10+
- Termux instalado
- 8GB RAM recomendado

### Instalação
\`\`\`bash
git clone https://github.com/SEU_USUARIO/Pure3XEngine.git
cd Pure3XEngine
./P3XE.sh
\`\`\`

## 📂 Estrutura

| Pasta | Descrição |
|---|---|
| CoreEmulator | Núcleo de emulação PS3 |
| Cubo3D | Motor gráfico e laboratório de testes |
| tools | Kit P3XE — scripts inteligentes |
| qemu | Máquinas virtuais QEMU |
| assets | Recursos visuais |

## 📊 Estatísticas

- 📄 Arquivos C++: **--**
- 📄 Arquivos Header: **--**
- 📄 Scripts Shell: **--**
- 📊 Linhas de código: **--**

## 🤝 Contribuindo

Este é um projeto pessoal em desenvolvimento ativo. Pull requests e sugestões são bem-vindas!

## 📝 Versão

**0.2.6 Alpha** — em desenvolvimento

## ⚖ Licença

Este projeto é para fins de estudo e pesquisa. Todos os componentes originais são criados do zero.

---

*Desenvolvido com 💜 no Termux*
ENDREADME

            sucesso "README padrão criado!"
            echo -e "${CIANO}💡 Edite com a opção 4 para preencher seus dados${RESET}"
            pausa
            ;;

        # ==================================================
        # 14) 🔄 SUBSTITUIR README
        # ==================================================
        14)
            clear; cabecalho; echo "🔄 SUBSTITUIR README"; echo "=================================================="; echo

            BACKUP_SUBST=""
            if [ -f "$README_DEST" ]; then
                echo -e "${CIANO}📌 Atual: $README_NAME ($(du -h "$README_DEST" | cut -f1), $LINHAS linhas)${RESET}"
                BACKUP_SUBST="$BACKUP_DIR/README_anterior_$(date +%Y%m%d_%H%M%S).md"
                cp "$README_DEST" "$BACKUP_SUBST"
                echo -e "💾 Salvo como: $(basename "$BACKUP_SUBST")"
                echo
            fi

            echo "Origem do novo README:"
            echo "  1) 📂 Escolher da pasta padrão"
            echo "  2) 📝 Caminho manual"
            echo "  3) 🔍 Buscar no projeto"
            echo "  0) ↩ Cancelar"
            echo
            read -r -p "Opção: " op_subst

            NOVO_README=""
            case "$op_subst" in
                1)
                    if [ -f "$PASTA_EXTERNA/$README_NAME" ]; then
                        NOVO_README="$PASTA_EXTERNA/$README_NAME"
                        echo -e "${VERDE}✅ Encontrado${RESET}"
                    else
                        echo -e "${AMARELO}⚠ Não encontrado${RESET}"
                    fi
                    ;;
                2)
                    read -r -p "Caminho completo: " NOVO_README
                    ;;
                3)
                    NOVO_README=$(find "$ROOT_DIR" "$PASTA_EXTERNA" -maxdepth 3 -name "README.md" -type f 2>/dev/null | grep -v "$ROOT_DIR/$README_NAME" | head -n1)
                    [ -n "$NOVO_README" ] && echo -e "${VERDE}✅ Encontrado: $NOVO_README${RESET}" || echo -e "${AMARELO}⚠ Nenhum encontrado${RESET}"
                    ;;
                0) echo "Cancelado."; pausa; continue ;;
            esac

            [ -z "$NOVO_README" ] || [ ! -f "$NOVO_README" ] && { echo -e "${VERMELHO}❌ Arquivo inválido${RESET}"; pausa; continue; }

            echo -e "📄 Novo: $(basename "$NOVO_README") — $(du -h "$NOVO_README" | cut -f1)"
            read -r -p "Substituir? [S/n]: " resp
            if [[ "$resp" =~ ^[sS]$ ]]; then
                cp "$NOVO_README" "$README_DEST"
                sucesso "README substituído!"
            fi
            pausa
            ;;

        # ==================================================
        # 15) 🗑 REMOVER README
        # ==================================================
        15)
            clear; cabecalho; echo "🗑 REMOVER README"; echo "=================================================="; echo
            [ ! -f "$README_DEST" ] && { echo -e "${AMARELO}⚠ Nenhum README para remover${RESET}"; pausa; continue; }

            echo -e "Arquivo: $README_NAME"
            echo -e "Tamanho: $TAMANHO — $LINHAS linhas"
            echo
            read -r -p "Tem CERTEZA? Digite SIM para confirmar: " resp
            if [ "$resp" = "SIM" ]; then
                cp "$README_DEST" "$BACKUP_DIR/README_removido_$(date +%Y%m%d_%H%M%S).md"
                rm -f "$README_DEST"
                sucesso "Removido! Backup salvo na pasta de backups"
            else
                echo "Cancelado."
            fi
            pausa
            ;;

        0) echo -e "\n${VERDE}✅ Voltando...${RESET}"; sleep 0.5; exit 0 ;;
        *) echo -e "\n${VERMELHO}❌ Opção inválida!${RESET}"; sleep 1.2 ;;
    esac
done
