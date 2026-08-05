#!/data/data/com.termux/files/usr/bin/bash
set -e

# CORES
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"

# ==================================================
# INICIO — DATA, HORA E CONTADOR DE TEMPO
# ==================================================
DATA_INICIO=$(date "+%d/%m/%Y %H:%M:%S")
TEMPO_INICIO=$(date +%s)

echo -e "${AZUL}==================================================${RESET}"
echo -e "${AZUL}   🧰 INSTALADOR INTELIGENTE SDK / NDK P3XE${RESET}"
echo -e "${AZUL}==================================================${RESET}"
echo -e "📅 Data e Hora Início: ${VERDE}$DATA_INICIO${RESET}"
echo

# ==================================================
# CAMINHOS CORRETOS
# ==================================================
ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_HOME
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/cmdline-tools/bin:$PATH"

# ==================================================
# CORRIGE PASTA DUPLICADA
# ==================================================
echo -e "${AMARELO}🔹 Corrigindo estrutura do build-tools...${RESET}"
if [ -d "$ANDROID_HOME/build-tools/33.0.2/33.0.2" ]; then
    mv -f "$ANDROID_HOME/build-tools/33.0.2/33.0.2"/* "$ANDROID_HOME/build-tools/33.0.2/"
    rmdir "$ANDROID_HOME/build-tools/33.0.2/33.0.2" 2>/dev/null
    echo -e "${VERDE}✅ Estrutura corrigida!${RESET}"
fi
if [ -d "$ANDROID_HOME/build-tools/33.0.2-2" ]; then
    mv -f "$ANDROID_HOME/build-tools/33.0.2-2" "$ANDROID_HOME/build-tools/33.0.2"
    echo -e "${VERDE}✅ Pasta renomeada!${RESET}"
fi

# ==================================================
# VERIFICA SDKMANAGER
# ==================================================
echo -e "\n${AMARELO}🔹 Procurando sdkmanager...${RESET}"
if command -v sdkmanager &> /dev/null; then
    echo -e "${VERDE}✅ sdkmanager encontrado: $(which sdkmanager)${RESET}"
else
    echo -e "${VERMELHO}❌ Instalando cmdline-tools...${RESET}"
    pkg update && pkg upgrade -y
    pkg install wget unzip -y
    mkdir -p "$ANDROID_HOME/cmdline-tools"
    cd "$ANDROID_HOME/cmdline-tools"
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline.zip
    unzip -q cmdline.zip
    mv cmdline-tools latest
    rm cmdline.zip
    export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    echo -e "${VERDE}✅ cmdline-tools instalado!${RESET}"
fi

# ==================================================
# INSTALA COMPONENTES
# ==================================================
echo -e "\n${AMARELO}🔹 Instalando componentes necessários...${RESET}"
yes | sdkmanager --sdk_root="$ANDROID_HOME" \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    "ndk;27.0.12077973"

# ==================================================
# CALCULA TEMPO FINAL
# ==================================================
TEMPO_FIM=$(date +%s)
TEMPO_TOTAL=$(( TEMPO_FIM - TEMPO_INICIO ))
MINUTOS=$(( TEMPO_TOTAL / 60 ))
SEGUNDOS=$(( TEMPO_TOTAL % 60 ))
DATA_FIM=$(date "+%d/%m/%Y %H:%M:%S")

# ==================================================
# VALIDAÇÃO FINAL
# ==================================================
echo -e "\n${AZUL}==================================================${RESET}"
echo -e "${AZUL}   📊 VALIDAÇÃO FINAL${RESET}"
echo -e "${AZUL}==================================================${RESET}"

[ -d "$ANDROID_HOME" ] && echo -e "${VERDE}✅ Android SDK encontrado${RESET}" || echo -e "${VERMELHO}❌ Android SDK não encontrado${RESET}"
[ -d "$ANDROID_HOME/ndk/27.0.12077973" ] && echo -e "${VERDE}✅ Android NDK r27 encontrado${RESET}" || echo -e "${VERMELHO}❌ Android NDK não encontrado${RESET}"
command -v sdkmanager &> /dev/null && echo -e "${VERDE}✅ sdkmanager encontrado${RESET}" || echo -e "${VERMELHO}❌ sdkmanager não encontrado${RESET}"
command -v cmake &> /dev/null && echo -e "${VERDE}✅ CMake encontrado${RESET}" || echo -e "${VERMELHO}❌ CMake não encontrado${RESET}"
command -v clang &> /dev/null && echo -e "${VERDE}✅ Clang encontrado${RESET}" || echo -e "${VERMELHO}❌ Clang não encontrado${RESET}"
command -v clang++ &> /dev/null && echo -e "${VERDE}✅ Clang++ encontrado${RESET}" || echo -e "${VERMELHO}❌ Clang++ não encontrado${RESET}"

echo -e "\n${AZUL}==================================================${RESET}"
echo -e "${VERDE}🎉 INSTALAÇÃO CONCLUÍDA COM SUCESSO!${RESET}"
echo -e "📅 Data e Hora Término: $DATA_FIM"
echo -e "⏱️ Tempo Total Gasto: ${VERDE}${MINUTOS}m ${SEGUNDOS}s${RESET}"
echo -e "${AZUL}==================================================${RESET}"

echo -e "\nAgora você pode usar:"
echo "🔍 Verificador CMake Inteligente"
echo "🛠️ SDK / NDK Doctor"
echo "🚀 Build Inteligente Cubo3D"
echo "📦 Build Completa do P3XE"
echo

read -p "Pressione ENTER para voltar ao menu..."

