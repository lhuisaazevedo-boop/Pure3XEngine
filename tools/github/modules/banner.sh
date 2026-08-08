#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# 🖼 BANNER MANAGER — P3XE
# Pure3XEngine 0.2.6 Alpha
# ==========================================================

VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

# 📍 CAMINHOS FIXOS — NÃO MUDA!
IMAGES_DIR="$ROOT_DIR/assets/images"
ALPHA_DIR="$IMAGES_DIR/Alpha"
LOGO_DIR="$IMAGES_DIR/Logo"
BANNERS_DIR="$IMAGES_DIR/banners"

CUBO3D_BANNER="cubo3d_launcher.png"
P3XE_CAPA="Pure3XEngnie-0.2.6-Alpha.png"
QEMU_CAPA="qemu_center_banner.png"

CUBO3D_ALPHA="$ALPHA_DIR/$CUBO3D_BANNER"
CUBO3D_LOGO="$LOGO_DIR/$CUBO3D_BANNER"
P3XE_ALPHA="$ALPHA_DIR/$P3XE_CAPA"
P3XE_LOGO="$LOGO_DIR/$P3XE_CAPA"
QEMU_ALPHA="$ALPHA_DIR/$QEMU_CAPA"
QEMU_LOGO="$LOGO_DIR/$QEMU_CAPA"

P3XE_TELEFONE="/storage/emulated/0/P3XE"
DOWNLOADS_TELEFONE="/storage/emulated/0/Download"

BANNER_ORIGINAL=""
BANNER_NOME=""

pausa() {
    echo
    read -r -p "Pressione ENTER para continuar..."
}

cabecalho_banner() {
    clear
    echo "=============================================================="
    echo "          🖼 BANNER MANAGER — GitHub Center"
    echo "              Pure3XEngine 0.2.6 Alpha"
    echo "=============================================================="
    echo -e "📅 Data: $(date '+%d/%m/%Y')    🕒 Hora: $(date '+%H:%M:%S')"
    echo
    echo "🖼 BANNERS OFICIAIS DO PROJETO"
    echo "--------------------------------------------------------------"

    echo "🎮 Cubo3D Launcher"
    echo "   Arquivo.....: $CUBO3D_BANNER"
    if [ -f "$CUBO3D_ALPHA" ] || [ -f "$CUBO3D_LOGO" ]; then
        echo -e "   Status......: ${VERDE}✅ Encontrado${RESET}"
        [ -f "$CUBO3D_ALPHA" ] && echo "   Alpha.......: ✅ assets/images/Alpha/"
        [ -f "$CUBO3D_LOGO" ] && echo "   Logo........: ✅ assets/images/Logo/"
    else
        echo -e "   Status......: ${VERMELHO}❌ Não encontrado${RESET}"
        echo "   Local.......: assets/images/Alpha/  ou  assets/images/Logo/"
    fi

    echo
    echo "🏷 Capa Pure3XEngine"
    echo "   Arquivo.....: $P3XE_CAPA"
    if [ -f "$P3XE_ALPHA" ] || [ -f "$P3XE_LOGO" ]; then
        echo -e "   Status......: ${VERDE}✅ Encontrado${RESET}"
        [ -f "$P3XE_ALPHA" ] && echo "   Alpha.......: ✅ assets/images/Alpha/"
        [ -f "$P3XE_LOGO" ] && echo "   Logo........: ✅ assets/images/Logo/"
    else
        echo -e "   Status......: ${VERMELHO}❌ Não encontrado${RESET}"
        echo "   Local.......: assets/images/Alpha/  ou  assets/images/Logo/"
    fi

    echo
    echo "🖥 Capa QEMU Center"
    echo "   Arquivo.....: $QEMU_CAPA"
    if [ -f "$QEMU_ALPHA" ] || [ -f "$QEMU_LOGO" ]; then
        echo -e "   Status......: ${VERDE}✅ Encontrado${RESET}"
        [ -f "$QEMU_ALPHA" ] && echo "   Alpha.......: ✅ assets/images/Alpha/"
        [ -f "$QEMU_LOGO" ] && echo "   Logo........: ✅ assets/images/Logo/"
    else
        echo -e "   Status......: ${VERMELHO}❌ Não encontrado${RESET}"
        echo "   Local.......: assets/images/Alpha/  ou  assets/images/Logo/"
    fi

    echo "--------------------------------------------------------------"
}

validar_imagem() {
    local arq="$1"
    if [ ! -f "$arq" ]; then
        echo -e "${VERMELHO}❌ Arquivo não existe${RESET}"
        return 1
    fi
    tipo=$(file -b --mime-type "$arq")
    case "$tipo" in
        image/png|image/jpeg|image/jpg|image/gif|image/webp)
            echo -e "${VERDE}✅ Imagem VÁLIDA — $tipo — $(du -h "$arq" | cut -f1)${RESET}"
            return 0
            ;;
        *)
            echo -e "${VERMELHO}❌ Não é uma imagem válida — tipo: $tipo${RESET}"
            return 1
            ;;
    esac
}

instalar_banner() {
    local CAMINHO_FINAL="$1"
    local NOME_EXIBICAO="$2"
    local PASTA_EXIBICAO="$3"

    if [ -z "$BANNER_ORIGINAL" ] || [ ! -f "$BANNER_ORIGINAL" ]; then
        echo -e "${VERMELHO}❌ Nenhum banner selecionado${RESET}"
        return 1
    fi

    mkdir -p "$(dirname "$CAMINHO_FINAL")"
    cp "$BANNER_ORIGINAL" "$CAMINHO_FINAL"

    echo
    echo -e "${VERDE}==============================================================${RESET}"
    echo -e "${VERDE}✅ INSTALADO COM SUCESSO!${RESET}"
    echo -e "${VERDE}   Nome.........: $(basename "$CAMINHO_FINAL")${RESET}"
    echo -e "${VERDE}   Tipo.........: $NOME_EXIBICAO${RESET}"
    echo -e "${VERDE}   Pasta........: $PASTA_EXIBICAO${RESET}"
    echo -e "${VERDE}==============================================================${RESET}"
    return 0
}

abrir_pasta_telefone() {
    local PASTA="$1"
    local NOME="$2"

    echo
    echo "📂 $NOME"
    echo "Caminho: $PASTA"
    echo "--------------------------------------------------------------"

    if [ ! -d "$PASTA" ]; then
        echo -e "${VERMELHO}❌ Pasta não encontrada!${RESET}"
        echo -e "${AMARELO}⚠ Execute: termux-setup-storage${RESET}"
        return 1
    fi

    arquivos=()
    while IFS= read -r -d '' f; do
        arquivos+=("$f")
    done < <(find "$PASTA" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) -print0 2>/dev/null | sort -z)

    if [ ${#arquivos[@]} -eq 0 ]; then
        echo "Nenhuma imagem encontrada nessa pasta"
        return 0
    fi

    echo "Imagens encontradas: ${#arquivos[@]}"
    echo
    for i in "${!arquivos[@]}"; do
        echo "  $((i+1))) 🖼 $(basename "${arquivos[$i]}")"
    done
    echo

    read -r -p "Digite o NÚMERO do arquivo: " escolha

    if [[ "$escolha" =~ ^[0-9]+$ ]] && [ "$escolha" -ge 1 ] && [ "$escolha" -le ${#arquivos[@]} ]; then
        SELECIONADO="${arquivos[$((escolha-1))]}"
    else
        echo -e "${VERMELHO}❌ Número inválido${RESET}"
        return 1
    fi

    NOME_ARQ=$(basename "$SELECIONADO")
    echo
    echo "📋 Avaliando: $NOME_ARQ"

    if validar_imagem "$SELECIONADO"; then
        mkdir -p "$BANNERS_DIR"
        cp "$SELECIONADO" "$BANNERS_DIR/"
        BANNER_ORIGINAL="$BANNERS_DIR/$NOME_ARQ"
        BANNER_NOME="$NOME_ARQ"

        echo
        echo -e "${VERDE}==============================================================${RESET}"
        echo -e "${VERDE}✅ Arquivo copiado: $BANNER_NOME${RESET}"
        echo -e "${VERDE}   Disponível em: assets/images/banners/${RESET}"
        echo -e "${VERDE}==============================================================${RESET}"

        echo
        echo "📦 Onde deseja INSTALAR este banner?"
        echo
        echo "   🎮 Cubo3D Launcher"
        echo "  1) → assets/images/Alpha/"
        echo "  2) → assets/images/Logo/"
        echo
        echo "   🏷 Capa Pure3XEngine"
        echo "  3) → assets/images/Alpha/"
        echo "  4) → assets/images/Logo/"
        echo
        echo "   🖥 Capa QEMU Center"
        echo "  5) → assets/images/Alpha/"
        echo "  6) → assets/images/Logo/"
        echo
        echo "  0) ↩ Voltar sem instalar"
        echo
        read -r -p "Escolha o número: " qual_instalar
        case "$qual_instalar" in
            1) instalar_banner "$CUBO3D_ALPHA" "Cubo3D Launcher" "assets/images/Alpha/" ;;
            2) instalar_banner "$CUBO3D_LOGO" "Cubo3D Launcher" "assets/images/Logo/" ;;
            3) instalar_banner "$P3XE_ALPHA" "Capa Pure3XEngine" "assets/images/Alpha/" ;;
            4) instalar_banner "$P3XE_LOGO" "Capa Pure3XEngine" "assets/images/Logo/" ;;
            5) instalar_banner "$QEMU_ALPHA" "Capa QEMU Center" "assets/images/Alpha/" ;;
            6) instalar_banner "$QEMU_LOGO" "Capa QEMU Center" "assets/images/Logo/" ;;
            0) echo -e "${AMARELO}⚠ Voltando...${RESET}" ;;
            *) echo -e "${VERMELHO}❌ Opção inválida. Arquivo salvo em banners/.${RESET}" ;;
        esac
    fi
}

while true; do
    cabecalho_banner
    echo
    echo "=============================================================="
    echo "Opções Disponíveis"
    echo
    echo "  0) ← Voltar ao GitHub Center"
    echo
    echo "  1) 📂 Selecionar Banner"
    echo "  2) 👀 Visualizar Informações"
    echo "  3) ✔ Verificar Dimensões e Validar Imagem"
    echo "  4) 📋 Instalar Banner no Projeto"
    echo "  5) 🚀 Preparar para GitHub"
    echo "  6) 🗑 Remover Banner"
    echo "  7) 📂 Selecionar Arquivo do Telefone"
    echo
    read -r -p "Escolha uma opção: " op

    case "$op" in
        0)
            echo -e "\n${VERDE}✅ Voltando ao GitHub Center...${RESET}"
            sleep 0.8
            exit 0
            ;;

        1)
            clear
            cabecalho_banner
            echo
            echo "📂 Selecionar Banner"
            echo "--------------------------------------------------------------"
            mkdir -p "$BANNERS_DIR"
            echo "Arquivos em assets/images/banners/:"
            ls -1 "$BANNERS_DIR/"*.png "$BANNERS_DIR/"*.jpg "$BANNERS_DIR/"*.jpeg "$BANNERS_DIR/"*.gif "$BANNERS_DIR/"*.webp 2>/dev/null | sed "s|.*/||" || echo "Nenhum arquivo"
            echo
            read -r -p "Nome do arquivo: " nome
            caminho="$BANNERS_DIR/$nome"
            if [ -f "$caminho" ]; then
                BANNER_ORIGINAL="$caminho"
                BANNER_NOME="$nome"
                echo -e "${VERDE}✅ Selecionado: $BANNER_NOME${RESET}"
                echo
                echo "📦 Onde deseja INSTALAR este banner?"
                echo
                echo "   🎮 Cubo3D Launcher"
                echo "  1) → assets/images/Alpha/"
                echo "  2) → assets/images/Logo/"
                echo
                echo "   🏷 Capa Pure3XEngine"
                echo "  3) → assets/images/Alpha/"
                echo "  4) → assets/images/Logo/"
                echo
                echo "   🖥 Capa QEMU Center"
                echo "  5) → assets/images/Alpha/"
                echo "  6) → assets/images/Logo/"
                echo
                echo "  0) ↩ Voltar sem instalar"
                echo
                read -r -p "Escolha o número: " qual
                case "$qual" in
                    1) instalar_banner "$CUBO3D_ALPHA" "Cubo3D Launcher" "assets/images/Alpha/" ;;
                    2) instalar_banner "$CUBO3D_LOGO" "Cubo3D Launcher" "assets/images/Logo/" ;;
                    3) instalar_banner "$P3XE_ALPHA" "Capa Pure3XEngine" "assets/images/Alpha/" ;;
                    4) instalar_banner "$P3XE_LOGO" "Capa Pure3XEngine" "assets/images/Logo/" ;;
                    5) instalar_banner "$QEMU_ALPHA" "Capa QEMU Center" "assets/images/Alpha/" ;;
                    6) instalar_banner "$QEMU_LOGO" "Capa QEMU Center" "assets/images/Logo/" ;;
                    0) ;;
                esac
            else
                echo -e "${VERMELHO}❌ Não encontrado${RESET}"
            fi
            pausa
            ;;

        2)
            clear
            cabecalho_banner
            echo
            echo "👀 Visualizar Informações"
            echo "--------------------------------------------------------------"
            if [ -n "$BANNER_ORIGINAL" ] && [ -f "$BANNER_ORIGINAL" ]; then
                echo "Arquivo selecionado: $(basename "$BANNER_ORIGINAL")"
                echo "Caminho completo....: $BANNER_ORIGINAL"
                echo "Tamanho.............: $(du -h "$BANNER_ORIGINAL" | cut -f1)"
            else
                echo "🎮 Cubo3D Launcher:"
                [ -f "$CUBO3D_ALPHA" ] && echo "   ✅ Alpha: $(du -h "$CUBO3D_ALPHA" | cut -f1)" || echo "   ❌ Alpha: não existe"
                [ -f "$CUBO3D_LOGO" ] && echo "   ✅ Logo:  $(du -h "$CUBO3D_LOGO" | cut -f1)" || echo "   ❌ Logo:  não existe"
                echo
                echo "🏷 Capa Pure3XEngine:"
                [ -f "$P3XE_ALPHA" ] && echo "   ✅ Alpha: $(du -h "$P3XE_ALPHA" | cut -f1)" || echo "   ❌ Alpha: não existe"
                [ -f "$P3XE_LOGO" ] && echo "   ✅ Logo:  $(du -h "$P3XE_LOGO" | cut -f1)" || echo "   ❌ Logo:  não existe"
                echo
                echo "🖥 Capa QEMU Center:"
                [ -f "$QEMU_ALPHA" ] && echo "   ✅ Alpha: $(du -h "$QEMU_ALPHA" | cut -f1)" || echo "   ❌ Alpha: não existe"
                [ -f "$QEMU_LOGO" ] && echo "   ✅ Logo:  $(du -h "$QEMU_LOGO" | cut -f1)" || echo "   ❌ Logo:  não existe"
            fi
            pausa
            ;;

        3)
            clear
            cabecalho_banner
            echo
            echo "✔ Verificar Dimensões e Validar Imagem"
            echo "--------------------------------------------------------------"
            alvo="$BANNER_ORIGINAL"
            if [ -z "$alvo" ] || [ ! -f "$alvo" ]; then
                echo -e "${VERMELHO}❌ Nenhum arquivo selecionado${RESET}"
                pausa
                continue
            fi
            echo "Arquivo: $(basename "$alvo")"
            validar_imagem "$alvo"
            echo
            if command -v identify &>/dev/null; then
                identify "$alvo" | awk '{print "📐 Largura: "$3"\n   Altura: "$4}' FS=x
            else
                echo -e "${AMARELO}⚠ Para ver dimensões: pkg install imagemagick${RESET}"
            fi
            pausa
            ;;

        4)
            clear
            cabecalho_banner
            echo
            echo "📋 Instalar Banner no Projeto"
            echo "--------------------------------------------------------------"
            if [ -z "$BANNER_ORIGINAL" ] || [ ! -f "$BANNER_ORIGINAL" ]; then
                echo -e "${VERMELHO}❌ Selecione primeiro (opção 1 ou 7)${RESET}"
            else
                echo "Arquivo selecionado: $BANNER_NOME"
                echo
                echo "📦 Onde deseja INSTALAR este banner?"
                echo
                echo "   🎮 Cubo3D Launcher"
                echo "  1) → assets/images/Alpha/"
                echo "  2) → assets/images/Logo/"
                echo
                echo "   🏷 Capa Pure3XEngine"
                echo "  3) → assets/images/Alpha/"
                echo "  4) → assets/images/Logo/"
                echo
                echo "   🖥 Capa QEMU Center"
                echo "  5) → assets/images/Alpha/"
                echo "  6) → assets/images/Logo/"
                echo
                read -r -p "Escolha o número: " qual
                case "$qual" in
                    1) instalar_banner "$CUBO3D_ALPHA" "Cubo3D Launcher" "assets/images/Alpha/" ;;
                    2) instalar_banner "$CUBO3D_LOGO" "Cubo3D Launcher" "assets/images/Logo/" ;;
                    3) instalar_banner "$P3XE_ALPHA" "Capa Pure3XEngine" "assets/images/Alpha/" ;;
                    4) instalar_banner "$P3XE_LOGO" "Capa Pure3XEngine" "assets/images/Logo/" ;;
                    5) instalar_banner "$QEMU_ALPHA" "Capa QEMU Center" "assets/images/Alpha/" ;;
                    6) instalar_banner "$QEMU_LOGO" "Capa QEMU Center" "assets/images/Logo/" ;;
                    *) echo -e "${VERMELHO}❌ Opção inválida${RESET}" ;;
                esac
            fi
            pausa
            ;;

        5)
            clear
            cabecalho_banner
            echo
            echo "🚀 Preparar para GitHub"
            echo "--------------------------------------------------------------"
            TEM_ALGO=0
            cd "$ROOT_DIR"
            for arq in "$CUBO3D_ALPHA" "$CUBO3D_LOGO" "$P3XE_ALPHA" "$P3XE_LOGO" "$QEMU_ALPHA" "$QEMU_LOGO"; do
                if [ -f "$arq" ]; then
                    echo "✅ $(basename "$arq") — pronto para envio"
                    git add "$arq" 2>/dev/null
                    TEM_ALGO=1
                fi
            done
            if [ $TEM_ALGO -eq 0 ]; then
                echo -e "${VERMELHO}❌ Nenhum banner instalado ainda${RESET}"
            else
                echo
                echo -e "${VERDE}✅ Arquivos preparados — faça Commit e Push pelo GitHub Center${RESET}"
            fi
            pausa
            ;;

        6)
            clear
            cabecalho_banner
            echo
            echo "🗑 Remover Banner"
            echo "--------------------------------------------------------------"
            echo "  1) 🎮 Cubo3D Launcher — Alpha"
            echo "  2) 🎮 Cubo3D Launcher — Logo"
            echo "  3) 🏷 Capa Pure3XEngine — Alpha"
            echo "  4) 🏷 Capa Pure3XEngine — Logo"
            echo "  5) 🖥 Capa QEMU Center — Alpha"
            echo "  6) 🖥 Capa QEMU Center — Logo"
            echo "  7) 🗑 Remover TODOS os banners"
            echo "  0) ↩ Voltar"
            echo
            read -r -p "Escolha: " qual
            case "$qual" in
                1) [ -f "$CUBO3D_ALPHA" ] && rm -f "$CUBO3D_ALPHA" && echo -e "${VERDE}✅ Removido${RESET}" || echo -e "${AMARELO}⚠ Não existe${RESET}" ;;
                2) [ -f "$CUBO3D_LOGO" ] && rm -f "$CUBO3D_LOGO" && echo -e "${VERDE}✅ Removido${RESET}" || echo -e "${AMARELO}⚠ Não existe${RESET}" ;;
                3) [ -f "$P3XE_ALPHA" ] && rm -f "$P3XE_ALPHA" && echo -e "${VERDE}✅ Removido${RESET}" || echo -e "${AMARELO}⚠ Não existe${RESET}" ;;
                4) [ -f "$P3XE_LOGO" ] && rm -f "$P3XE_LOGO" && echo -e "${VERDE}✅ Removido${RESET}" || echo -e "${AMARELO}⚠ Não existe${RESET}" ;;
                5) [ -f "$QEMU_ALPHA" ] && rm -f "$QEMU_ALPHA" && echo -e "${VERDE}✅ Removido${RESET}" || echo -e "${AMARELO}⚠ Não existe${RESET}" ;;
                6) [ -f "$QEMU_LOGO" ] && rm -f "$QEMU_LOGO" && echo -e "${VERDE}✅ Removido${RESET}" || echo -e "${AMARELO}⚠ Não existe${RESET}" ;;
                7)
                    read -r -p "Remover TODOS os banners? (s/N): " resp
                    if [[ "$resp" =~ ^[sS]$ ]]; then
                        rm -f "$CUBO3D_ALPHA" "$CUBO3D_LOGO" "$P3XE_ALPHA" "$P3XE_LOGO" "$QEMU_ALPHA" "$QEMU_LOGO" 2>/dev/null
                        BANNER_ORIGINAL=""
                        BANNER_NOME=""
                        echo -e "${VERDE}✅ TODOS removidos${RESET}"
                    fi
                    ;;
                0) ;;
            esac
            pausa
            ;;

        7)
            while true; do
                clear
                cabecalho_banner
                echo
                echo "📂 Selecionar Arquivo do Telefone"
                echo "--------------------------------------------------------------"
                echo
                echo "  0) ↩ Voltar"
                echo
                echo "  1) 📱 Pasta P3XE — do TELEFONE"
                echo "  2) 📥 Downloads — do TELEFONE"
                echo
                read -r -p "Escolha: " sub7

                if [ "$sub7" = "0" ]; then
                    break
                elif [ "$sub7" = "1" ]; then
                    clear
                    cabecalho_banner
                    abrir_pasta_telefone "$P3XE_TELEFONE" "📱 PASTA P3XE — TELEFONE"
                    pausa
                elif [ "$sub7" = "2" ]; then
                    clear
                    cabecalho_banner
                    abrir_pasta_telefone "$DOWNLOADS_TELEFONE" "📥 DOWNLOADS — TELEFONE"
                    pausa
                fi
            done
            ;;

        *)
            echo -e "\n${VERMELHO}❌ Opção inválida! Tente novamente.${RESET}"
            sleep 1.2
            ;;
    esac
done

# ✅ Sai do Banner Manager e retorna ao GitHub Center
exit 0

