#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE - TERMINAL AVANCADO
# Pure3XEngine 0.2.6 Alpha
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
VERSION="0.2.6 Alpha"

cd "$ROOT_DIR" || exit 1

# ------------------------------------------------------------
# CORES
# ------------------------------------------------------------

RESET="\033[0m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
BLUE="\033[1;34m"
GRAY="\033[0;37m"

# ------------------------------------------------------------
# DIRETORIOS
# ------------------------------------------------------------

LOG_DIR="$ROOT_DIR/logs/ai"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/terminal_$(date +%Y%m%d_%H%M%S).log"

# ------------------------------------------------------------
# FUNCOES
# ------------------------------------------------------------

linha() {
    printf '%*s\n' 64 '' | tr ' ' '='
}

linha2() {
    printf '%*s\n' 64 '' | tr ' ' '-'
}

pausa() {
    echo
    read -r -p "Pressione ENTER para continuar..."
}

cabecalho() {
    clear

    linha
    echo "🖥  P3XE - TERMINAL AVANCADO"
    echo "Pure3XEngine $VERSION"
    linha

    echo
    echo "Projeto : $ROOT_DIR"
    echo "Data    : $(date '+%d/%m/%Y')"
    echo "Hora    : $(date '+%H:%M:%S')"
    echo "PWD     : $(pwd)"

    linha
}

# ------------------------------------------------------------
# STATUS
# ------------------------------------------------------------

status_projeto() {

    echo
    echo "📁 MODULOS"
    linha2

    for dir in CoreEmulator Cubo3D QEMUCenter Android Config tools
    do
        if [ -d "$ROOT_DIR/$dir" ]; then
            echo "✅ $dir"
        else
            echo "⚠️  $dir nao encontrado"
        fi
    done

    echo
    echo "🔧 FERRAMENTAS"
    linha2

    for tool in clang clang++ cmake git make
    do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "✅ $tool: $(command -v "$tool")"
        else
            echo "❌ $tool nao encontrado"
        fi
    done
}

# ------------------------------------------------------------
# GIT
# ------------------------------------------------------------

git_status() {

    echo
    echo "🌿 GIT"
    linha2

    if [ -d "$ROOT_DIR/.git" ]; then

        echo "Branch      : $(git branch --show-current 2>/dev/null)"
        echo "Commit      : $(git rev-parse --short HEAD 2>/dev/null)"

        CHANGES="$(git status --porcelain 2>/dev/null | wc -l)"

        echo "Alteracoes  : $CHANGES"

        if [ "$CHANGES" -gt 0 ]; then
            echo "⚠️ Existem alteracoes locais"
        else
            echo "✅ Repositorio limpo"
        fi

    else
        echo "⚠️ Repositorio Git nao detectado"
    fi
}

# ------------------------------------------------------------
# ARTEFATOS
# ------------------------------------------------------------

artefatos() {

    echo
    echo "📦 ARTEFATOS"
    linha2

    APK_COUNT="$(find "$ROOT_DIR" -type f -name "*.apk" 2>/dev/null | wc -l)"
    SO_COUNT="$(find "$ROOT_DIR" -type f -name "*.so" 2>/dev/null | wc -l)"
    CACHE_COUNT="$(find "$ROOT_DIR" -type f -name "CMakeCache.txt" 2>/dev/null | wc -l)"

    echo "APK             : $APK_COUNT"
    echo "Bibliotecas .so : $SO_COUNT"
    echo "Caches CMake    : $CACHE_COUNT"
}

# ------------------------------------------------------------
# PROTECAO DE COMANDOS
# ------------------------------------------------------------

comando_perigoso() {

    local CMD="$1"

    case "$CMD" in

        *"rm -rf /"*|\
        *"rm -rf ~"*|\
        *"rm -rf \$HOME"*|\
        *"rm -rf $ROOT_DIR"*|\
        *"rm -fr /"*|\
        *"mkfs"*|\
        *"dd if="*|\
        *":(){ :|"*|\
        *"chmod -R 777 /"*|\
        *"git clean -fdx"*|\
        *"git reset --hard"*)

            return 0
            ;;

    esac

    return 1
}

# ------------------------------------------------------------
# EXECUTAR COMANDO
# ------------------------------------------------------------

executar() {

    local CMD="$1"

    echo
    linha2

    echo "P3XE > $CMD"

    linha2

    echo "[$(date '+%d/%m/%Y %H:%M:%S')] $CMD" >> "$LOG_FILE"

    if comando_perigoso "$CMD"; then

        echo
        echo -e "${RED}❌ COMANDO BLOQUEADO${RESET}"
        echo
        echo "O Terminal P3XE detectou um comando potencialmente destrutivo."
        echo "Comando:"
        echo "$CMD"

        echo "[BLOQUEADO] $CMD" >> "$LOG_FILE"

        return
    fi

    bash -c "$CMD" 2>&1 | tee -a "$LOG_FILE"

    STATUS=${PIPESTATUS[0]}

    echo

    if [ "$STATUS" -eq 0 ]; then
        echo -e "${GREEN}✅ Comando concluido${RESET}"
    else
        echo -e "${RED}❌ Comando retornou codigo: $STATUS${RESET}"
    fi
}

# ------------------------------------------------------------
# ATALHOS
# ------------------------------------------------------------

atalhos() {

    cabecalho

    echo
    echo "⚡ ATALHOS P3XE"
    linha2

    echo "1) Listar projeto"
    echo "2) Git status"
    echo "3) Procurar CMakeCache"
    echo "4) Procurar CMake NOTFOUND"
    echo "5) Listar APK"
    echo "6) Listar bibliotecas .so"
    echo "7) Ver ultimos logs"
    echo "8) Sintaxe dos scripts AI"
    echo "9) Abrir AI Center"
    echo "0) Voltar"

    echo
    read -r -p "Opcao: " OP

    case "$OP" in

        1)
            executar "ls -lah"
            pausa
            ;;

        2)
            executar "git status --short"
            pausa
            ;;

        3)
            executar "find . -name CMakeCache.txt -type f"
            pausa
            ;;

        4)
            executar "find . -name CMakeCache.txt -type f -exec grep -H 'NOTFOUND' {} \\;"
            pausa
            ;;

        5)
            executar "find . -type f -name '*.apk' -print"
            pausa
            ;;

        6)
            executar "find . -type f -name '*.so' -print"
            pausa
            ;;

        7)
            executar "find logs -type f 2>/dev/null | tail -20"
            pausa
            ;;

        8)
            executar "find tools/ai -type f -name '*.sh' -exec bash -n {} \\;"
            pausa
            ;;

        9)
            if [ -f "$ROOT_DIR/tools/ai/ai_center.sh" ]; then
                bash "$ROOT_DIR/tools/ai/ai_center.sh"
            else
                echo "❌ ai_center.sh nao encontrado"
                pausa
            fi
            ;;

        0)
            return
            ;;

    esac
}

# ------------------------------------------------------------
# TERMINAL INTERATIVO
# ------------------------------------------------------------

terminal_interativo() {

    while true
    do

        echo
        echo -ne "${CYAN}P3XE${RESET}:${BLUE}$(pwd)${RESET}\$ "

        IFS= read -r CMD

        [ -z "$CMD" ] && continue

        case "$CMD" in

            exit|quit|voltar)
                break
                ;;

            clear|cls)
                cabecalho
                continue
                ;;

            help)
                echo
                echo "Comandos especiais:"
                echo "  help       ajuda"
                echo "  status     status do projeto"
                echo "  git        status Git"
                echo "  artifacts  artefatos"
                echo "  atalhos    menu de atalhos"
                echo "  root       voltar para raiz Pure3XEngine"
                echo "  logs       mostrar log atual"
                echo "  exit       voltar ao AI Center"
                continue
                ;;

            status)
                status_projeto
                continue
                ;;

            git)
                git_status
                continue
                ;;

            artifacts)
                artefatos
                continue
                ;;

            atalhos)
                atalhos
                cabecalho
                continue
                ;;

            root)
                cd "$ROOT_DIR" || continue
                continue
                ;;

            logs)
                echo "$LOG_FILE"
                continue
                ;;

            cd)
                cd "$ROOT_DIR" || continue
                continue
                ;;

            cd\ *)
                DEST="${CMD#cd }"

                if cd "$DEST" 2>/dev/null; then
                    :
                else
                    echo "❌ Diretorio nao encontrado: $DEST"
                fi

                continue
                ;;

        esac

        executar "$CMD"

    done
}

# ------------------------------------------------------------
# INICIO
# ------------------------------------------------------------

cabecalho

echo
echo "🔍 VERIFICANDO AMBIENTE"
linha2

status_projeto
git_status
artefatos

echo
linha

echo "Terminal P3XE iniciado."
echo
echo "Digite:"
echo "  help     → comandos internos"
echo "  atalhos  → ferramentas rapidas"
echo "  exit     → retornar ao AI Center"

linha

terminal_interativo

echo
linha
echo "✅ P3XE Terminal finalizado"
linha

echo
echo "Log:"
echo "$LOG_FILE"

echo
read -r -p "Pressione ENTER para voltar..."
