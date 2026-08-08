#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# 🖼 BANNER MANAGER — GitHub Center
# Pure3XEngine 0.2.6 Alpha — TUDO DENTRO DO PROJETO!
# ==========================================================

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT_DIR/tools/common/init.sh"

ASSETS_DIR="$ROOT_DIR/assets"
IMAGES_DIR="$ASSETS_DIR/images"
BANNER_DEST="$IMAGES_DIR/cubo3d_laucher.png"

# 📂 TUDO DENTRO DO PROJETO — nenhum caminho externo!
BANNERES_DIR="$ASSETS_DIR/banners"
[ ! -d "$BANNERES_DIR" ] && mkdir -p "$BANNERES_DIR"

BANNER_ORIGINAL=""
BANNER_NOME=""

cabecalho_banner() {
    clear
    echo "=================================================="
    echo "🖼 BANNER MANAGER — GitHub Center"
    echo "Pure3XEngine 0.2.6 Alpha"
    echo "=================================================="
    echo "📅 Data: $(date '+%d/%m/%Y')    ⏰ Hora: $(date '+%H:%M:%S')"
    echo "📂 Projeto: $ROOT_DIR"
    echo "=================================================="
}

verificar_banner() {
    EXISTE=0
    TAMANHO="--"
    DIMENSOES="--"
    FORMATO="--"
    VALIDACAO="${VERMELHO}❌ Não verificado${RESET}"
    if [ -f "$BANNER_DEST" ]; then
        EXISTE=1
        TAMANHO=$(du -h "$BANNER_DEST" | cut -f1)
        FORMATO=$(file -b --mime-type "$BANNER_DEST")
        DIMENSOES=$(identify -format "%w × %h" "$BANNER_DEST" 2>/dev/null || echo "desconhecidas")
        [[ "$FORMATO" == "image/png" ]] && VALIDACAO="${VERDE}✅ Aprovado — pronto para GitHub!${RESET}"
    fi
}

mostrar_status() {
    verificar_banner
    cabecalho_banner
    echo "🖼 Banner Atual"
    echo "--------------------------------------------------"
    echo "Arquivo.......: cubo3d_laucher.png"
    if [ $EXISTE -eq 1 ]; then
        echo "Status.......: ${VERDE}✅ Instalado${RESET}"
        echo "Local........: assets/images/"
        echo "Formato......: PNG"
        echo "Dimensões....: $DIMENSOES"
        echo "Tamanho......: $TAMANHO"
        echo "Validação....: $VALIDACAO"
    else
        echo "Status.......: ${VERMELHO}❌ Não instalado${RESET}"
        echo "Local........: --"
        echo "Formato......: --"
        echo "Dimensões....: --"
        echo "Tamanho......: --"
        echo "Validação....: ${AMARELO}⚠ Selecione uma imagem${RESET}"
    fi
    echo "--------------------------------------------------"
}

while true
do
    mostrar_status
    echo
    echo "Opções Disponíveis"
    echo
    echo "  1) 📂 Selecionar Banner"
    echo "  2) 📋 Informações do Banner"
    echo "  3) 📂 Navegar e Selecionar Imagem"
    [ $EXISTE -eq 1 ] && echo "  4) 📦 Instalar no Projeto"
    [ $EXISTE -eq 1 ] && echo "  5) 🚀 Publicar no GitHub"
    [ $EXISTE -eq 1 ] && echo "  6) 🗑 Remover Banner"
    [ $EXISTE -eq 1 ] && echo "  7) 📦 Assets — Mover para Capa / Logo"
    [ $EXISTE -eq 1 ] && echo "  8) 👁 Visualizar Banner"
    [ $EXISTE -eq 1 ] && echo "  9) 🪄 Otimizar Banner"
    [ -n "$BANNER_ORIGINAL" ] && echo " 10) 🔁 Substituir Banner"
    echo
    echo "  0) ↩ Voltar"
    echo
    read -r -p "Escolha uma opção: " op

    case "$op" in
        1)
            cabecalho_banner
            echo "📂 SELECIONAR BANNER — DENTRO DO PROJETO"
            echo "=================================================="
            echo
            caminhos=(
                "$BANNERES_DIR/*.png"
                "$IMAGES_DIR/*.png"
                "$ROOT_DIR/*.png"
            )
            ENCONTRADO=0
            for caminho in "${BANNERES_DIR}"/*.png; do
                if [ -f "$caminho" ]; then
                    BANNER_ORIGINAL="$caminho"
                    BANNER_NOME=$(basename "$caminho")
                    echo -e "${VERDE}✅ Encontrado: $BANNER_NOME${RESET}"
                    echo -e "   assets/banners/$BANNER_NOME"
                    ENCONTRADO=1
                    break
                fi
            done
            if [ $ENCONTRADO -eq 0 ]; then
                echo -e "${AMARELO}⚠ Nenhum banner encontrado em assets/banners/${RESET}"
                echo -e "${CIANO}💡 Use a opção 3 para navegar e importar${RESET}"
                read -r -p "Ou digite o nome do arquivo dentro do projeto: " nome
                if [ -n "$nome" ] && [ -f "$ROOT_DIR/$nome" ]; then
                    BANNER_ORIGINAL="$ROOT_DIR/$nome"
                    BANNER_NOME=$(basename "$nome")
                    echo -e "${VERDE}✅ Selecionado: $BANNER_NOME${RESET}"
                else
                    echo -e "${VERMELHO}❌ Arquivo não encontrado dentro do projeto${RESET}"
                    BANNER_ORIGINAL=""
                    BANNER_NOME=""
                fi
            fi
            pausa
            ;;

        2)
            [ ! -f "$BANNER_DEST" ] && { erro "Banner não instalado"; pausa; continue; }
            cabecalho_banner
            echo "📋 INFORMAÇÕES DO BANNER"
            echo "=================================================="
            echo
            echo -e "📄 Arquivo......: cubo3d_laucher.png"
            echo -e "📂 Caminho......: $BANNER_DEST"
            echo -e "📦 Tamanho.....: $(du -h "$BANNER_DEST" | cut -f1)"
            echo -e "📐 Dimensões...: $(identify -format "%w × %h pixels" "$BANNER_DEST" 2>/dev/null || echo "Indisponível")"
            echo -e "🖼 Formato.....: $(file -b --mime-type "$BANNER_DEST")"
            echo -e "📅 Modificado..: $(stat -c %y "$BANNER_DEST" 2>/dev/null | cut -d' ' -f1)"
            pausa
            ;;

        3)
            clear
            echo "=================================================="
            echo "📂 NAVEGAR E SELECIONAR IMAGEM — SÓ DENTRO DO PROJETO"
            echo "=================================================="
            echo
            DIR_ATUAL="$ROOT_DIR"
            BANNER_ORIGINAL=""
            BANNER_NOME=""

            echo "📁 Pasta inicial: $ROOT_DIR"
            echo -e "${CIANO}💡 Tudo dentro de Pure3XEngine — sem arquivos externos!${RESET}"
            echo

            while true
            do
                clear
                echo "=================================================="
                echo "📂 NAVEGAR E SELECIONAR IMAGEM — DENTRO DO PROJETO"
                echo "=================================================="
                echo -e "${CIANO}📁 Pasta: $DIR_ATUAL${RESET}"
                echo
                echo "  0) ⬆ Voltar uma pasta"
                echo "  -) 🏠 Raiz do Projeto"
                echo "  <) ⬅ Voltar ao menu"
                echo
                echo "Arquivos e pastas:"
                echo "--------------------------------------------------"

                itens=()
                while IFS= read -r -d '' item; do
                    itens+=("$item")
                done < <(ls -1dt "$DIR_ATUAL"/* 2>/dev/null)

                num=1
                for item in "${itens[@]}"; do
                    nome=$(basename "$item")
                    if [ -d "$item" ]; then
                        echo "  $num) 📂 $nome/"
                    elif [[ "$nome" =~ \.(png|jpg|jpeg|gif|webp)$ ]]; then
                        echo "  $num) 🖼 $nome"
                    fi
                    num=$((num+1))
                done
                echo

                read -r -p "Escolha número ou digite nome: " escolha

                case "$escolha" in
                    0)
                        DIR_ATUAL=$(dirname "$DIR_ATUAL")
                        [[ "$DIR_ATUAL" == "/" ]] && DIR_ATUAL="$ROOT_DIR"
                        continue
                        ;;
                    -)
                        DIR_ATUAL="$ROOT_DIR"
                        continue
                        ;;
                    \<)
                        break 2
                        ;;
                    "")
                        continue
                        ;;
                    *)
                        if [[ "$escolha" =~ ^[0-9]+$ ]] && [ "$escolha" -ge 1 ] && [ "$escolha" -le ${#itens[@]} ]; then
                            IDX=$((escolha-1))
                            ALVO="${itens[$IDX]}"
                            if [ -d "$ALVO" ]; then
                                DIR_ATUAL="$ALVO"
                            elif [ -f "$ALVO" ] && [[ "$ALVO" =~ \.(png|jpg|jpeg|gif|webp)$ ]]; then
                                BANNER_ORIGINAL="$ALVO"
                                BANNER_NOME=$(basename "$ALVO")
                                echo
                                echo -e "${VERDE}✅ Imagem selecionada!${RESET}"
                                echo -e "📄 Arquivo: $BANNER_NOME"
                                echo -e "📂 Caminho: ${ALVO#$ROOT_DIR/}"
                                pausa
                                break 2
                            fi
                        fi
                        ;;
                esac
            done
            pausa
            ;;

        4)
            [ -z "$BANNER_ORIGINAL" ] || [ ! -f "$BANNER_ORIGINAL" ] && { erro "Selecione uma imagem primeiro — opção 1 ou 3"; pausa; continue; }
            mkdir -p "$IMAGES_DIR"
            cp "$BANNER_ORIGINAL" "$BANNER_DEST"
            sucesso "Banner instalado!"
            echo -e "📂 Destino: assets/images/cubo3d_laucher.png"
            pausa
            ;;

        5)
            [ ! -f "$BANNER_DEST" ] && { erro "Banner não instalado"; pausa; continue; }
            cd "$ROOT_DIR"
            [ ! -d ".git" ] && { echo -e "${AMARELO}⚠ Repositório Git não inicializado${RESET}"; pausa; continue; }
            git add "$BANNER_DEST"
            git commit -m "Add: banner do projeto — cubo3d_laucher.png"
            sucesso "Commit criado! Faça: git push origin main"
            pausa
            ;;

        6)
            [ ! -f "$BANNER_DEST" ] && { erro "Nenhum banner para remover"; pausa; continue; }
            echo -e "${AMARELO}⚠ Será removido: cubo3d_laucher.png${RESET}"
            read -r -p "Confirmar? [s/N]: " resp
            [[ "$resp" =~ ^[sS]$ ]] && { rm -f "$BANNER_DEST"; BANNER_ORIGINAL=""; BANNER_NOME=""; sucesso "Banner removido!"; }
            pausa
            ;;

        7)
            [ ! -f "$BANNER_DEST" ] && { erro "Banner não instalado"; pausa; continue; }
            cp "$BANNER_DEST" "$ASSETS_DIR/capa.png"
            cp "$BANNER_DEST" "$ASSETS_DIR/logo.png"
            sucesso "Copiado como capa.png e logo.png em assets/"
            pausa
            ;;

        8)
            [ ! -f "$BANNER_DEST" ] && { erro "Banner não instalado"; pausa; continue; }
            echo -e "${CIANO}📄 Arquivo: $BANNER_DEST${RESET}"
            ls -lh "$BANNER_DEST"
            pausa
            ;;

        9)
            [ ! -f "$BANNER_DEST" ] && { erro "Banner não instalado"; pausa; continue; }
            if command -v optipng &>/dev/null; then
                optipng -o2 "$BANNER_DEST"
                sucesso "Otimizado com optipng!"
            else
                echo -e "${AMARELO}⚠ Instale: pkg install optipng${RESET}"
            fi
            pausa
            ;;

        10)
            [ -z "$BANNER_ORIGINAL" ] && { erro "Selecione imagem primeiro — opção 1 ou 3"; pausa; continue; }
            read -r -p "Substituir banner atual por $BANNER_NOME? [S/n]: " resp
            { [[ "$resp" =~ ^[sS]$ ]] || [ -z "$resp" ]; } && { cp "$BANNER_ORIGINAL" "$BANNER_DEST"; sucesso "Banner substituído!"; }
            pausa
            ;;

        0) echo -e "\n${VERDE}✅ Voltando...${RESET}"; sleep 0.5; exit 0 ;;
        *) echo -e "\n${VERMELHO}❌ Opção inválida!${RESET}"; sleep 1.2 ;;
    esac
done
