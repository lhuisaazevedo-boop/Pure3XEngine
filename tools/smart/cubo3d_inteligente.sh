#!/data/data/com.termux/files/usr/bin/bash
# ==================================================
# 🧩 CUBO3D SMART DOCTOR — VERIFICAÇÃO EXCLUSIVA
# Pure3XEngine · Motor Gráfico Cubo3D
# ==================================================

# Cores
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"

# Caminhos fixos do Cubo3D
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CUBO3D="$ROOT/Cubo3D"
ANDROID_DIR="$CUBO3D/android"
SRC_DIR="$CUBO3D/src"
INC_DIR="$CUBO3D/include"
SHADERS_DIR="$CUBO3D/shaders"

ERROS=0
AVISOS=0

# ==============================================
# FUNÇÃO AUXILIAR
# ==============================================
verifica_item() {
    local TIPO="$1"
    local CAMINHO="$2"
    local NOME="$3"

    echo -ne "🔍 $NOME... "
    if [ "$TIPO" = "arquivo" ] && [ -f "$CAMINHO" ]; then
        echo -e "${VERDE}✅ OK${RESET}"
    elif [ "$TIPO" = "pasta" ] && [ -d "$CAMINHO" ]; then
        echo -e "${VERDE}✅ OK${RESET}"
    else
        echo -e "${VERMELHO}❌ FALTA${RESET}"
        ERROS=$((ERROS+1))
    fi
}

# ==============================================
# INÍCIO
# ==============================================
clear
echo -e "${AZUL}=================================================="
echo -e "      🧩 CUBO3D SMART DOCTOR"
echo -e "      Verificação completa do motor gráfico"
echo -e "==================================================${RESET}"
echo "Data: $(date)"
echo "Caminho: $CUBO3D"
echo ""

# ==============================================
# 1. ESTRUTURA BÁSICA
# ==============================================
echo -e "${AZUL}🔹 1. ESTRUTURA DO PROJETO${RESET}"
verifica_item "pasta" "$CUBO3D" "Pasta raiz Cubo3D"
verifica_item "pasta" "$ANDROID_DIR" "Pasta Android"
verifica_item "pasta" "$SRC_DIR" "Código fonte (.cpp)"
verifica_item "pasta" "$INC_DIR" "Cabeçalhos (.h)"
verifica_item "pasta" "$SHADERS_DIR" "Arquivos de shader"
verifica_item "arquivo" "$CUBO3D/CMakeLists.txt" "CMakeLists.txt do Cubo3D"
verifica_item "arquivo" "$ANDROID_DIR/build.gradle" "build.gradle do módulo"
echo ""

# ==============================================
# 2. CÓDIGO E CONFIGURAÇÃO
# ==============================================
echo -e "${AZUL}🔹 2. CÓDIGO E COMPILAÇÃO${RESET}"

# Verifica C++20
echo -ne "🔍 C++20 configurado... "
if grep -q "CMAKE_CXX_STANDARD 20" "$CUBO3D/CMakeLists.txt"; then
    echo -e "${VERDE}✅ OK${RESET}"
else
    echo -e "${VERMELHO}❌ Faltando${RESET}"
    ERROS=$((ERROS+1))
fi

# Verifica compiladores
echo -ne "🔍 Caminhos dos compiladores... "
if grep -q "CMAKE_C_COMPILER" "$CUBO3D/CMakeLists.txt" && grep -q "CMAKE_CXX_COMPILER" "$CUBO3D/CMakeLists.txt"; then
    echo -e "${VERDE}✅ OK${RESET}"
else
    echo -e "${VERMELHO}❌ Faltando${RESET}"
    ERROS=$((ERROS+1))
fi

# Verifica bibliotecas gráficas
echo -ne "🔍 Suporte a OpenGL ES... "
if grep -qE "GLESv3|EGL" "$CUBO3D/CMakeLists.txt" "$SRC_DIR"/* 2>/dev/null; then
    echo -e "${VERDE}✅ OK${RESET}"
else
    echo -e "${AMARELO}⚠ Não detectado${RESET}"
    AVISOS=$((AVISOS+1))
fi

echo -ne "🔍 Suporte a Vulkan... "
if grep -q "vulkan" "$CUBO3D/CMakeLists.txt" "$SRC_DIR"/* 2>/dev/null; then
    echo -e "${VERDE}✅ OK${RESET}"
else
    echo -e "${AMARELO}⚠ Ainda não configurado${RESET}"
    AVISOS=$((AVISOS+1))
fi
echo ""

# ==============================================
# 3. ARQUIVOS FONTE E SHADERS
# ==============================================
echo -e "${AZUL}🔹 3. ARQUIVOS DO MOTOR${RESET}"
QTD_CPP=$(find "$SRC_DIR" -name "*.cpp" | wc -l)
QTD_H=$(find "$INC_DIR" -name "*.h" | wc -l)
QTD_SHADER=$(find "$SHADERS_DIR" -name "*.vert" -o -name "*.frag" -o -name "*.spv" | wc -l)

echo "   📄 Arquivos .cpp: $QTD_CPP"
echo "   📄 Arquivos .h: $QTD_H"
echo "   📄 Shaders: $QTD_SHADER"

if [ "$QTD_CPP" -eq 0 ]; then
    echo -e "   ${VERMELHO}❌ Nenhum código fonte encontrado!${RESET}"
    ERROS=$((ERROS+1))
fi
echo ""

# ==============================================
# 4. BUILD E SAÍDA
# ==============================================
echo -e "${AZUL}🔹 4. SAÍDA DE COMPILAÇÃO${RESET}"
SAIDA_LIB="$ANDROID_DIR/app/build/intermediates/cmake/debug/obj/arm64-v8a/libcubo3d.so"
if [ -f "$SAIDA_LIB" ]; then
    echo -e "   ${VERDE}✅ Biblioteca Cubo3D.so já gerada${RESET}"
    echo "   Tamanho: $(du -h "$SAIDA_LIB" | cut -f1)"
else
    echo -e "   ${AMARELO}⚠ Biblioteca ainda não compilada${RESET}"
    AVISOS=$((AVISOS+1))
fi
echo ""

# ==============================================
# 5. SMART SCAN
# ==============================================
echo -e "${AZUL}🔹 5. SMART SCAN${RESET}"

echo -ne "🔍 Procurando arquivos órfãos... "

ORFAOS=$(find "$CUBO3D" -type f \( -name "*.cpp" -o -name "*.h" \) | while read A; do
    grep -qr "$(basename "$A")" "$CUBO3D" 2>/dev/null || echo "$A"
done)

if [ -z "$ORFAOS" ]; then
    echo -e "${VERDE}✅ Nenhum encontrado${RESET}"
else
    echo -e "${AMARELO}⚠ Arquivos sem referência${RESET}"
    echo "$ORFAOS"
    AVISOS=$((AVISOS+1))
fi

echo ""

# ==============================================
# 6. VERIFICAÇÃO DOS INCLUDES
# ==============================================
echo -e "${AZUL}🔹 6. VERIFICAÇÃO DOS INCLUDES${RESET}"

echo -ne "🔍 Procurando #include quebrados... "

INCLUDES=$(grep -R '^#include "' "$SRC_DIR" "$INC_DIR" 2>/dev/null)

if [ -z "$INCLUDES" ]; then
    echo -e "${AMARELO}⚠ Nenhum include encontrado${RESET}"
    AVISOS=$((AVISOS+1))
else
    FALHAS=0

    echo "$INCLUDES" | while IFS=: read -r ARQ LINHA INCLUDE
    do
        ARQUIVO=$(echo "$INCLUDE" | cut -d'"' -f2)

        if ! find "$INC_DIR" -name "$ARQUIVO" | grep -q .; then
            echo -e "${VERMELHO}❌ Include não encontrado:${RESET} $ARQUIVO"
            FALHAS=$((FALHAS+1))
        fi
    done

    if [ "$FALHAS" -eq 0 ]; then
        echo -e "${VERDE}✅ Todos os includes encontrados${RESET}"
    else
        ERROS=$((ERROS+FALHAS))
    fi
fi

echo ""
# ==============================================
# 7. VERIFICAÇÃO DO CMakeLists
# ==============================================
echo -e "${AZUL}🔹 7. VERIFICANDO CMakeLists${RESET}"

CMAKE="$CUBO3D/CMakeLists.txt"

if [ -f "$CMAKE" ]; then

    echo -ne "🔍 Arquivos .cpp fora do CMake... "

    FALTANDO=0

    while IFS= read -r ARQ
    do
        NOME=$(basename "$ARQ")

        if ! grep -q "$NOME" "$CMAKE"; then
            echo -e "\n${AMARELO}⚠ Não listado:${RESET} $NOME"
            FALTANDO=$((FALTANDO+1))
        fi

    done < <(find "$SRC_DIR" -name "*.cpp")

    if [ "$FALTANDO" -eq 0 ]; then
        echo -e "${VERDE}✅ Todos os .cpp estão no CMake${RESET}"
    else
        AVISOS=$((AVISOS+FALTANDO))
    fi

else
    echo -e "${VERMELHO}❌ CMakeLists.txt não encontrado${RESET}"
    ERROS=$((ERROS+1))
fi

echo ""

# ==============================================
# 8. VERIFICAÇÃO DAS BIBLIOTECAS
# ==============================================
echo -e "${AZUL}🔹 8. BIBLIOTECAS${RESET}"

echo -ne "🔍 EGL... "

grep -R "EGL" "$SRC_DIR" "$INC_DIR" >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${VERDE}✅ OK${RESET}"
else
    echo -e "${AMARELO}⚠ Não encontrado${RESET}"
fi

echo -ne "🔍 GLES3... "

grep -R "GLES3" "$SRC_DIR" "$INC_DIR" >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${VERDE}✅ OK${RESET}"
else
    echo -e "${AMARELO}⚠ Não encontrado${RESET}"
fi

echo -ne "🔍 Vulkan... "

grep -R "vulkan" "$SRC_DIR" "$INC_DIR" >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${VERDE}✅ OK${RESET}"
else
    echo -e "${AMARELO}⚠ Ainda não implementado${RESET}"
fi

echo ""

# ==================================================
# 9. RECOMENDAÇÕES INTELIGENTES
# ==================================================

echo -e "${AZUL}🔹 9. RECOMENDAÇÕES${RESET}"
echo ""

if [ "$ERROS" -eq 0 ] && [ "$AVISOS" -eq 0 ]; then

    echo -e "${VERDE}🎉 Cubo3D totalmente saudável.${RESET}"
    echo "➡ Pronto para Build."

else

    echo "Próximos passos:"

    if [ ! -f "$CUBO3D/CMakeLists.txt" ]; then
        echo " • Criar CMakeLists.txt"
    fi

    if [ ! -d "$SRC_DIR" ]; then
        echo " • Criar pasta src"
    fi

    if [ ! -d "$INC_DIR" ]; then
        echo " • Criar pasta include"
    fi

    if [ ! -d "$SHADERS_DIR" ]; then
        echo " • Criar pasta shaders"
    fi

    if [ ! -f "$ANDROID_DIR/build.gradle" ]; then
        echo " • Corrigir build.gradle"
    fi

    if [ ! -f "$ANDROID_DIR/local.properties" ]; then
        echo " • Gerar local.properties"
    fi

    if [ "$QTD_CPP" -eq 0 ]; then
        echo " • Adicionar arquivos .cpp"
    fi

    if [ "$QTD_H" -eq 0 ]; then
        echo " • Adicionar arquivos .h"
    fi

    if [ "$QTD_SHADER" -eq 0 ]; then
        echo " • Criar shaders"
    fi

fi

echo ""
echo -e "${AZUL}==================================================${RESET}"

echo ""
echo "Pressione ENTER para voltar..."
read -r
# ==============================================
# RESUMO FINAL
# ==============================================
echo -e "${AZUL}=================================================="
echo -e "📊 RESUMO DO CUBO3D"
echo -e "==================================================${RESET}"
echo -e "🔴 Erros críticos: $ERROS"
echo -e "🟡 Avisos: $AVISOS"
echo ""

if [ "$ERROS" -eq 0 ]; then
    echo -e "${VERDE}🎉 MOTOR CUBO3D ESTÁ PRONTO PARA USO!${RESET}"
    echo "✅ Tudo configurado corretamente, pode compilar."
else
    echo -e "${VERMELHO}⚠ CORRIJA OS ERROS ACIMA ANTES DE COMPILAR${RESET}"
    echo "💡 Dica: use o Verificador CMake Inteligente primeiro."
fi

echo -e "${AZUL}==================================================${RESET}"
echo ""
echo "Pressione ENTER para voltar..."
read -r

