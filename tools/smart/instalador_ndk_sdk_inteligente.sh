#!/data/data/com.termux/files/usr/bin/bash
clear

# ==============================================
# CORES PADRÃO P3XE
# ==============================================
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
CIANO="\033[1;36m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

# ==============================================
# CONFIGURAÇÕES FIXAS DO SEU PROJETO
# ==============================================
ANDROID_HOME="$HOME/Android/Sdk"
NDK_ALVO="27.0.12077973"
NDK_VERSAO_EXIBIR="r27"
PLATFORM_ALVO="android-34"
BUILD_TOOLS_ALVO="34.0.0"
ROOT="$HOME/Pure3XEngine"

# ==============================================
# FUNÇÕES AUXILIARES
# ==============================================
status_ok() { echo -e "   ${VERDE}✅ $1${RESET}"; }
status_aviso() { echo -e "   ${AMARELO}⚠️ $1${RESET}"; }
status_erro() { echo -e "   ${VERMELHO}❌ $1${RESET}"; }
pausa() { echo; read -p "Pressione ENTER para continuar..."; }

# BARRA INTELIGENTE COM CORES + TEMPO
barra_progresso() {
    local PASSO=$1 TOTAL=$2 MENSAGEM="$3" INICIO=${4:-0}
    local PERCENT=$(( PASSO * 100 / TOTAL ))
    local COMP=$(( PERCENT / 5 )) VAZ=$(( 20 - COMP ))

    local COR="$AZUL"
    [ $PERCENT -ge 25 ] && COR="$CIANO"
    [ $PERCENT -ge 50 ] && COR="$AMARELO"
    [ $PERCENT -ge 75 ] && COR="$MAGENTA"
    [ $PERCENT -eq 100 ] && COR="$VERDE"

    local TEMPO_REST=""
    if [ $INICIO -gt 0 ] && [ $PERCENT -gt 0 ]; then
        local AGORA=$(date +%s)
        local DECORRIDO=$(( AGORA - INICIO ))
        local TOTAL_EST=$(( DECORRIDO * 100 / PERCENT ))
        local REST=$(( TOTAL_EST - DECORRIDO ))
        [ $REST -gt 60 ] && TEMPO_REST=" ⏱️ ~$((REST/60))min" || TEMPO_REST=" ⏱️ ~${REST}s"
    fi

    echo -ne " ${COR}["
    printf "%0.s█" $(seq 1 $COMP)
    printf "%0.s░" $(seq 1 $VAZ)
    echo -e "] ${PERCENT}% ${MENSAGEM}${TEMPO_REST}${RESET}"
}

# ==============================================
# FUNÇÕES DE VERIFICAÇÃO — MOSTRA VERSÃO
# ==============================================
verificar_compilador() {
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}            🔍 VERIFICAR COMPILADORES${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AMARELO}Versão recomendada: Clang 14+${RESET}"
    echo

    local TOTAL=2 PASSO=0
    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Verificando Clang..."
    if command -v clang &>/dev/null; then
        local VER=$(clang --version | head -n1 | awk '{print $3}')
        status_ok "Clang instalado: v$VER"
    else
        status_erro "Clang não encontrado"
    fi

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Verificando Clang++..."
    if command -v clang++ &>/dev/null; then
        local VER=$(clang++ --version | head -n1 | awk '{print $3}')
        status_ok "Clang++ instalado: v$VER"
    else
        status_erro "Clang++ não encontrado"
    fi
    pausa
}

verificar_sdk() {
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}               🔍 VERIFICAR ANDROID SDK${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AMARELO}Versão recomendada: API 34 / Build Tools $BUILD_TOOLS_ALVO${RESET}"
    echo

    local TOTAL=3 PASSO=0
    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Pasta SDK..."
    [ -d "$ANDROID_HOME" ] && status_ok "Pasta: $ANDROID_HOME" || status_erro "Pasta não existe"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Plataforma..."
    [ -d "$ANDROID_HOME/platforms/$PLATFORM_ALVO" ] && status_ok "Plataforma: $PLATFORM_ALVO" || status_aviso "Plataforma não instalada"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Build Tools..."
    [ -d "$ANDROID_HOME/build-tools/$BUILD_TOOLS_ALVO" ] && status_ok "Build Tools: $BUILD_TOOLS_ALVO" || status_aviso "Build Tools ausente"
    pausa
}

verificar_java() {
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}                 🔍 VERIFICAR JAVA${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AMARELO}Versão recomendada: OpenJDK 17${RESET}"
    echo

    local TOTAL=1 PASSO=0
    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Versão Java..."
    if command -v java &>/dev/null; then
        local VER=$(java -version 2>&1 | head -n1 | awk -F'"' '{print $2}')
        status_ok "Java instalado: OpenJDK $VER"
    else
        status_erro "Java não encontrado"
    fi
    pausa
}

verificar_ndk() {
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}                🔍 VERIFICAR ANDROID NDK${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AMARELO}Versão obrigatória para P3XE: $NDK_VERSAO_EXIBIR ($NDK_ALVO)${RESET}"
    echo

    local TOTAL=2 PASSO=0
    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Pasta NDK..."
    if [ -d "$ANDROID_HOME/ndk/$NDK_ALVO" ]; then
        status_ok "NDK encontrado: $NDK_ALVO"
    else
        status_erro "NDK $NDK_VERSAO_EXIBIR não instalado"
    fi

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Arquivo configuração..."
    grep -q "ndk.dir=$ANDROID_HOME/ndk/$NDK_ALVO" "$ROOT/android/local.properties" 2>/dev/null && status_ok "Caminho correto no projeto" || status_aviso "Caminho não definido"
    pausa
}

verificar_sdkmanager() {
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}               🔍 VERIFICAR SDK MANAGER${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AMARELO}Versão recomendada: commandlinetools mais recente${RESET}"
    echo

    local TOTAL=2 PASSO=0
    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Comando..."
    if command -v sdkmanager &>/dev/null; then
        status_ok "sdkmanager disponível"
    else
        status_erro "sdkmanager não configurado"
    fi

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Caminho no PATH..."
    echo "$PATH" | grep -q "cmdline-tools/latest/bin" && status_ok "Caminho incluído" || status_aviso "Caminho pode estar faltando"
    pausa
}

verificar_pastas() {
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}            📂 VERIFICAR ESTRUTURA DO PROJETO${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AMARELO}Estrutura esperada: CoreEmulation + Cubo3D + android${RESET}"
    echo

    local TOTAL=4 PASSO=0
    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "CoreEmulation..."
    [ -d "$ROOT/CoreEmulation" ] && status_ok "Pasta CoreEmulation OK" || status_erro "CoreEmulation ausente"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Cubo3D..."
    [ -d "$ROOT/Cubo3D" ] && status_ok "Pasta Cubo3D OK" || status_erro "Cubo3D ausente"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Pasta Android..."
    [ -d "$ROOT/android" ] && status_ok "Pasta android OK" || status_erro "Pasta android ausente"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Pasta Build..."
    mkdir -p "$ROOT/CoreEmulation/build" "$ROOT/Cubo3D/build" && status_ok "Pastas de build prontas"
    pausa
}

# ==============================================
# FUNÇÕES DE INSTALAÇÃO — COM CONFIRMAÇÃO + BARRA
# ==============================================
instalar_cubo_core() {
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}       🧩 PREPARAR CUBO3D + COREEMULATION${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AMARELO}Ação: Criar pastas, ajustar permissões e organizar arquivos${RESET}"
    echo -e "${VERDE}Prosseguir com essa preparação? (S/N)${RESET}"
    read -r CONF
    [ "$CONF" != "S" ] && [ "$CONF" != "s" ] && { echo -e "${AMARELO}Cancelado.${RESET}"; pausa; return; }

    local TOTAL=4 PASSO=0
    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Criando pastas..."
    mkdir -p "$ROOT/CoreEmulation/build" "$ROOT/Cubo3D/build" "$ROOT/android/app/src/main/jniLibs/arm64-v8a"
    status_ok "Pastas criadas"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Ajustando permissões..."
    chmod -R 755 "$ROOT/CoreEmulation" "$ROOT/Cubo3D" "$ROOT/android"
    status_ok "Permissões corrigidas"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Verificando CMakeLists..."
    [ -f "$ROOT/CoreEmulation/CMakeLists.txt" ] && status_ok "CMake CoreEmulation OK" || status_aviso "Revise CMakeLists CoreEmulation"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Finalizando..."
    status_ok "✅ Estrutura pronta para compilação"
    pausa
}

instalar_completamente() {
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}           ⚙️ INSTALAÇÃO COMPLETA${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AMARELO}Será instalado/configurado:${RESET}"
    echo -e " ✓ Termux atualizado"
    echo -e " ✓ Java 17 + Clang + CMake + Ninja"
    echo -e " ✓ SDK Manager + Platform $PLATFORM_ALVO"
    echo -e " ✓ Build Tools $BUILD_TOOLS_ALVO"
    echo -e " ✓ NDK $NDK_VERSAO_EXIBIR"
    echo -e " ✓ Configurações do projeto"
    echo
    echo -e "${VERDE}Prosseguir com instalação completa? (S/N)${RESET}"
    read -r CONF
    [ "$CONF" != "S" ] && [ "$CONF" != "s" ] && { echo -e "${AMARELO}Cancelado.${RESET}"; pausa; return; }

    local TOTAL=7 PASSO=0 ERRO=0 INICIO_GERAL=$(date +%s)

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Atualizando Termux..." $INICIO_GERAL
    pkg update -y && pkg upgrade -y >/dev/null 2>&1 && status_ok "Sistema atualizado" || status_erro "Falha"; ERRO=$((ERRO + ($? != 0 ? 1 : 0)))

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Instalando ferramentas..." $INICIO_GERAL
    pkg install -y openjdk-17 clang cmake ninja wget unzip >/dev/null 2>&1 && status_ok "Ferramentas OK" || status_erro "Falha"; ERRO=$((ERRO + ($? != 0 ? 1 : 0)))

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Configurando SDK Manager..." $INICIO_GERAL
    mkdir -p "$ANDROID_HOME/cmdline-tools"
    cd "$ANDROID_HOME" || return 1
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip
    unzip -q tools.zip && rm tools.zip && mv cmdline-tools cmdline-tools/latest
    export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
    command -v sdkmanager &>/dev/null && status_ok "SDK Manager pronto" || status_erro "Falha"; ERRO=$((ERRO + ($? != 0 ? 1 : 0)))
    cd "$ROOT" || return 1

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Instalando componentes SDK..." $INICIO_GERAL
    yes | sdkmanager --sdk_root="$ANDROID_HOME" "platform-tools" "platforms;$PLATFORM_ALVO" "build-tools;$BUILD_TOOLS_ALVO" >/dev/null 2>&1 && status_ok "Componentes OK" || status_erro "Falha"; ERRO=$((ERRO + ($? != 0 ? 1 : 0)))

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Instalando NDK $NDK_VERSAO_EXIBIR..." $INICIO_GERAL
    [ ! -d "$ANDROID_HOME/ndk/$NDK_ALVO" ] && yes | sdkmanager --sdk_root="$ANDROID_HOME" "ndk;$NDK_ALVO" >/dev/null 2>&1
    [ -d "$ANDROID_HOME/ndk/$NDK_ALVO" ] && status_ok "NDK instalado" || status_erro "Falha"; ERRO=$((ERRO + ($? != 0 ? 1 : 0)))

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Aceitando licenças..." $INICIO_GERAL
    yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses >/dev/null 2>&1 && status_ok "Licenças aceitas"

    PASSO=$((PASSO+1)); barra_progresso $PASSO $TOTAL "Salvando configurações..." $INICIO_GERAL
    mkdir -p "$ROOT/android"
    cat > "$ROOT/android/local.properties" << EOF
sdk.dir=$ANDROID_HOME
ndk.dir=$ANDROID_HOME/ndk/$NDK_ALVO
EOF
    status_ok "local.properties atualizado"

    echo
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}               📊 RESUMO FINAL${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${VERDE}✅ Itens concluídos: $((TOTAL - ERRO))${RESET}"
    echo -e "${VERMELHO}❌ Itens com falha: $ERRO${RESET}"
    echo -e "${AMARELO}⏱️ Tempo total: $(( $(date +%s) - INICIO_GERAL )) segundos${RESET}"
    echo
    [ $ERRO -eq 0 ] && echo -e "${VERDE}🎉 AMBIENTE 100% PRONTO PARA O P3XE!${RESET}" || echo -e "${VERMELHO}⚠️ Verifique os itens com falha acima${RESET}"
    pausa
}

# ==============================================
# MENU PRINCIPAL — EXATAMENTE COMO PEDIU
# ==============================================
while true; do
    clear
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${AZUL}      📦 INSTALADOR INTELIGENTE SDK / NDK${RESET}"
    echo -e "${AZUL}==================================================${RESET}"
    echo -e "${CIANO}1) 🔍 Verificar Compilador${RESET}"
    echo -e "${CIANO}2) 🔍 Verificar SDK${RESET}"
    echo -e "${CIANO}3) 🔍 Verificar Java${RESET}"
    echo -e "${CIANO}4) 🔍 Verificar NDK${RESET}"
    echo -e "${CIANO}5) 🔍 Verificar Sdkmanager${RESET}"
    echo -e "${CIANO}6) 🧩 Modo Instalação Cubo3D + CoreEmulator${RESET}"
    echo -e "${CIANO}7) 📂 Verificar Pastas Corrigidas${RESET}"
    echo -e "${CIANO}8) ⚙️ Instalação Completa${RESET}"
    echo -e "${VERDE}0) ⬅️ Sair${RESET}"
    echo
    read -rp "Escolha uma opção: " OPCAO

    case "$OPCAO" in
        1) verificar_compilador ;;
        2) verificar_sdk ;;
        3) verificar_java ;;
        4) verificar_ndk ;;
        5) verificar_sdkmanager ;;
        6) instalar_cubo_core ;;
        7) verificar_pastas ;;
        8) instalar_completamente ;;
        0)
            clear
            echo -e "${VERDE}==================================================${RESET}"
            echo -e "${VERDE}            ⬅️ SAINDO DO INSTALADOR${RESET}"
            echo -e "${VERDE}==================================================${RESET}"
            echo -e "${AMARELO}📅 Data/Hora: $(date "+%d/%m/%Y %H:%M:%S")${RESET}"
            echo
            echo -e "${VERDE}Pressione ENTER para voltar ao Menu Principal P3XE...${RESET}"
            read -r
            exit 0
            ;;
        *)
            echo -e "${VERMELHO}❌ Opção inválida!${RESET}"
            pausa
            ;;
    esac
done

