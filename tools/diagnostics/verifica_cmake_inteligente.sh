#!/data/data/com.termux/files/usr/bin/bash
# ==================================================
# 🧠 VERIFICADOR INTELIGENTE DE CMAKELISTS.TXT
# Pure3XEngine · Cubo3D · CoreEmulator
# Verifica, valida e aponta erros em todos os arquivos
# ==================================================

# Cores
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"

# Caminhos automáticos
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
NDK_CAMINHO="$HOME/Android/Sdk/ndk/27.0.12077973"
COMPILADOR_C="$NDK_CAMINHO/toolchains/llvm/prebuilt/linux-x86_64/bin/clang"
COMPILADOR_CXX="$NDK_CAMINHO/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++"

ARQUIVOS_CMAKE=(
    "$ROOT/CMakeLists.txt"
    "$ROOT/Cubo3D/CMakeLists.txt"
    "$ROOT/CoreEmulator/CMakeLists.txt"
)

ERROS_GERAIS=0

# ==============================================
# FUNÇÃO AUXILIAR
# ==============================================
verifica_arquivo() {
    local CAMINHO="$1"
    echo -e "\n${AZUL}🔍 Verificando: $CAMINHO${RESET}"

    if [ ! -f "$CAMINHO" ]; then
        echo -e "${VERMELHO}❌ Arquivo NÃO EXISTE!${RESET}"
        ERROS_GERAIS=$((ERROS_GERAIS+1))
        return 1
    fi

    echo -e "${VERDE}✅ Arquivo encontrado${RESET}"

    # Verifica versão mínima do CMake
    if ! grep -q "cmake_minimum_required" "$CAMINHO"; then
        echo -e "${VERMELHO}❌ Falta definir cmake_minimum_required!${RESET}"
        ERROS_GERAIS=$((ERROS_GERAIS+1))
    else
        echo -e "${VERDE}✅ Versão mínima do CMake definida${RESET}"
    fi

    # Verifica C++20
    if ! grep -q "CMAKE_CXX_STANDARD 20" "$CAMINHO"; then
        echo -e "${AMARELO}⚠ C++20 não definido — será adicionado${RESET}"
        ERROS_GERAIS=$((ERROS_GERAIS+1))
    else
        echo -e "${VERDE}✅ C++20 configurado${RESET}"
    fi

    # Verifica caminhos dos compiladores
    if ! grep -q "CMAKE_C_COMPILER" "$CAMINHO" || ! grep -q "CMAKE_CXX_COMPILER" "$CAMINHO"; then
        echo -e "${VERMELHO}❌ Caminho dos compiladores NÃO DEFINIDO — esse é o erro principal!${RESET}"
        ERROS_GERAIS=$((ERROS_GERAIS+1))
    else
        echo -e "${VERDE}✅ Compiladores configurados${RESET}"
    fi

    # Verifica bibliotecas essenciais
    if ! grep -qE "android|log" "$CAMINHO"; then
        echo -e "${AMARELO}⚠ Bibliotecas essenciais (android/log) não verificadas${RESET}"
    else
        echo -e "${VERDE}✅ Bibliotecas do sistema presentes${RESET}"
    fi
}

# ==============================================
# INÍCIO
# ==============================================
clear
echo -e "${AZUL}=================================================="
echo -e "      🧠 VERIFICADOR INTELIGENTE CMAKELISTS"
echo -e "==================================================${RESET}"
echo "Data: $(date)"
echo "Projeto raiz: $ROOT"
echo ""

# Verifica se NDK existe
echo -e "${AZUL}🔹 1. VERIFICANDO FERRAMENTAS${RESET}"
if [ ! -d "$NDK_CAMINHO" ]; then
    echo -e "${VERMELHO}❌ NDK não encontrado em: $NDK_CAMINHO${RESET}"
    ERROS_GERAIS=$((ERROS_GERAIS+1))
else
    echo -e "${VERDE}✅ NDK encontrado${RESET}"
fi

if [ ! -f "$COMPILADOR_C" ] || [ ! -f "$COMPILADOR_CXX" ]; then
    echo -e "${VERMELHO}❌ Compiladores Clang não encontrados no NDK!${RESET}"
    ERROS_GERAIS=$((ERROS_GERAIS+1))
else
    echo -e "${VERDE}✅ Compiladores C/C++ existem${RESET}"
fi

# ==============================================
# VERIFICA TODOS OS ARQUIVOS
# ==============================================
echo -e "\n${AZUL}🔹 2. ANALISANDO ARQUIVOS CMAKELISTS${RESET}"
for ARQ in "${ARQUIVOS_CMAKE[@]}"; do
    verifica_arquivo "$ARQ"
done

# ==============================================
# RESUMO E CORREÇÃO AUTOMÁTICA
# ==============================================

echo
echo -e "${AZUL}==================================================${RESET}"
echo -e "📊 RESUMO GERAL"
echo -e "${AZUL}==================================================${RESET}"
echo "Erros encontrados: $ERROS_GERAIS"
echo

if [ "$ERROS_GERAIS" -gt 0 ]; then

    echo -e "${AMARELO}🔧 Quer corrigir automaticamente os erros principais? (S/N)${RESET}"
    read -r RESPOSTA

    if [ "$RESPOSTA" = "S" ] || [ "$RESPOSTA" = "s" ]; then

        echo
        echo "🔧 Aplicando correções..."

        {
            echo ""
            echo "# Configuração automática adicionada pelo P3XE"
            echo "set(CMAKE_C_COMPILER \"$COMPILADOR_C\" CACHE FILEPATH \"\" FORCE)"
            echo "set(CMAKE_CXX_COMPILER \"$COMPILADOR_CXX\" CACHE FILEPATH \"\" FORCE)"
            echo "set(CMAKE_CXX_STANDARD 20)"
            echo "set(CMAKE_CXX_STANDARD_REQUIRED ON)"
        } >> "$ROOT/CMakeLists.txt"

        echo -e "${VERDE}✅ Correções aplicadas!${RESET}"

    else

        echo "Nenhuma alteração foi realizada."

    fi

else

    echo -e "${VERDE}✅ TODOS OS ARQUIVOS ESTÃO CORRETOS! PRONTO PARA COMPILAR!${RESET}"

fi

echo
echo -e "${AZUL}==================================================${RESET}"
echo "Pressione ENTER para voltar..."
read -r
