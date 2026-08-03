#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# P3XE CONTROL PANEL
# Pure3XEngenie Development Kit
# ==========================================================

# Caminho da raiz do projeto
ROOT="$(cd "$(dirname "$0")" && pwd)"

TOOLS="$ROOT/tools"
LOGS="$ROOT/logs"

# Módulos Android
P3XE_ANDROID="$ROOT/android"
CUBO3D_ANDROID="$ROOT/Cubo3D/android"
CORE_ANDROID="$ROOT/CoreEmuletoin/android"

# Cores
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"

# ==========================================================
# CABEÇALHO
# ==========================================================

cabecalho() {

    clear

    echo -e "${AZUL}"
    echo "============================================================"
    echo "                 🎮 PAINEL DE CONTROLE P3XE"
    echo "          Pure3XEngenie • Cubo3D • CoreEmuletoin"
    echo "============================================================"
    echo -e "${RESET}"

    echo "Versão : 0.2.5 Alpha"
    echo "Data   : $(date '+%d/%m/%Y %H:%M')"
    echo "Projeto: $ROOT"
    echo
}

# ==========================================================
# PAUSA
# ==========================================================

pausa() {

    echo
    echo -e "${AMARELO}Pressione ENTER para continuar...${RESET}"
    read -r

}

# ==========================================================
# MENU PRINCIPAL
# ==========================================================

while true
do

cabecalho

echo -e "${VERDE}DESENVOLVIMENTO${RESET}"
echo " 1) 🩺 Doctor"
echo " 2) 🔧 Repair"
echo " 3) 🧹 Clean"
echo " 4) 📊 Health Report"

echo

echo -e "${VERDE}BUILD${RESET}"
echo " 5) 🏗️ Build Cubo3D"
echo " 6) ⚙️ Build CoreEmuletoin"
echo " 7) 📦 Build Completa"
echo " 8) 📋 Build com Log"

echo

echo -e "${VERDE}DIAGNÓSTICOS${RESET}"
echo " 9)  🔍 CMake Doctor"
echo "10) 🔍 Gradle Doctor"
echo "11) 🔍 SDK / NDK Doctor"
echo "12) 🔍 JNI Doctor"

echo

echo -e "${VERDE}UTILITÁRIOS${RESET}"
echo "13) 📂 Abrir Logs"
echo "14) 📱 Instalar APK"
echo "15) 📚 Gerar Relatório"
echo "16) 🗑️ Limpar Logs"

echo

echo -e "${VERDE}GITHUB${RESET}"
echo "17) 🌿 Git Status"
echo "18) 💾 Git Commit"
echo "19) 🚀 Git Push"

echo
echo " 0) 👋 Sair"
echo

echo -ne "${AMARELO}Escolha uma opção: ${RESET}"
read -r OPCAO

case "$OPCAO" in

1)
    "$TOOLS/doctor.sh"
    pausa
;;

2)
    "$TOOLS/repair.sh"
    pausa
;;

3)

    clear

    echo "🧹 LIMPANDO TODOS OS ARQUIVOS TEMPORÁRIOS..."
    echo "===================================================="

    echo
    echo "🧹 Limpando Cubo3D..."

    rm -rf "$ROOT/Cubo3D/android/.gradle"
    rm -rf "$ROOT/Cubo3D/android/.cxx"
    rm -rf "$ROOT/Cubo3D/android/app/build"
    rm -rf "$ROOT/Cubo3D/android/build"
    rm -rf "$ROOT/Cubo3D/android/logs"

    echo
    echo "🧹 Limpando CoreEmuletoin..."

    rm -rf "$ROOT/CoreEmuletoin/android/.gradle"
    rm -rf "$ROOT/CoreEmuletoin/android/.cxx"
    rm -rf "$ROOT/CoreEmuletoin/android/app/build"
    rm -rf "$ROOT/CoreEmuletoin/android/build"
    rm -rf "$ROOT/CoreEmuletoin/android/logs"

    echo
    echo "🧹 Limpando cache global..."

    rm -rf ~/.gradle/caches/build-cache-*

    echo
    echo "✅ LIMPEZA CONCLUÍDA COM SUCESSO!"
    echo
    echo "📌 Próximos passos:"
    echo "  1) Doctor"
    echo "  2) Build Cubo3D ou CoreEmuletoin"

    pausa
;;

4)
    "$TOOLS/report.sh"
    pausa
;;

5)
    echo
    echo -e "${AZUL}▶ Compilando Cubo3D...${RESET}"
    "$TOOLS/build_com_log.sh" "Cubo3D/android"
    pausa
;;

6)
    echo
    echo -e "${AZUL}▶ Compilando CoreEmuletoin...${RESET}"
    "$TOOLS/build_com_log.sh" "CoreEmuletoin/android"
    pausa
;;

7)
    echo
    echo -e "${AZUL}▶ Build Completa dos dois módulos...${RESET}"

    "$TOOLS/build_com_log.sh" "Cubo3D/android"

    echo

    "$TOOLS/build_com_log.sh" "CoreEmuletoin/android"

    pausa
;;

8)
    echo
    echo -e "${AZUL}▶ Build com Log Detalhado...${RESET}"
    "$TOOLS/build_com_log.sh"
    pausa
;;

9)
    "$TOOLS/cmake_doctor.sh"
    pausa
;;

10)
    "$TOOLS/gradle_doctor.sh"
    pausa
;;

11)
    clear
    echo
    echo -e "${AZUL}🔍 Executando SDK / NDK Doctor...${RESET}"
    echo

    if [ -f "$TOOLS/ndk_doctor.sh" ]; then
        chmod +x "$TOOLS/ndk_doctor.sh"
        "$TOOLS/ndk_doctor.sh"
    else
        echo -e "${VERMELHO}❌ Arquivo não encontrado:${RESET}"
        echo "$TOOLS/ndk_doctor.sh"
    fi

    pausa
;;

12)
    "$TOOLS/jni_doctor.sh"
    pausa
;;

13)
    clear
    echo "================ LOGS ================"

    mkdir -p "$LOGS"

    ls -lh "$LOGS"

    echo
    echo "Local:"
    echo "$LOGS"

    pausa
;;

14)

    APK="$ROOT/app/build/outputs/apk/debug/app-debug.apk"

    if [ -f "$APK" ]; then

        mkdir -p /storage/emulated/0/Pure3XEngenie

        cp "$APK" /storage/emulated/0/Pure3XEngenie/

        echo -e "${VERDE}✅ APK copiado com sucesso!${RESET}"

    else

        echo -e "${VERMELHO}❌ APK não encontrado.${RESET}"

    fi

    pausa
;;

15)

    "$TOOLS/report.sh"

    pausa
;;

16)

    mkdir -p "$LOGS"

    rm -f "$LOGS"/*

    echo -e "${VERDE}✅ Logs removidos.${RESET}"

    pausa
;;

17)

    git status

    pausa
;;

18)

    echo
    read -p "Mensagem do Commit: " MSG

    git add .
    git commit -m "$MSG"

    pausa
;;

19)

    git push

    pausa
;;

0)

    clear

    echo
    echo -e "${VERDE}Obrigado por utilizar o P3XE Development Kit.${RESET}"
    echo

    exit 0
;;

*)

    echo
    echo -e "${VERMELHO}❌ Opção inválida!${RESET}"

    pausa
;;

esac

done
