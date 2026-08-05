#!/data/data/com.termux/files/usr/bin/bash

# ==================================================
# 🩺 P3XE DOCTOR INTELIGENTE
# Pure3XEngine — Verifica, aponta e sugere correções
# ==================================================

# Cores
VERDE="\033[1;32m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

ERROS=0
AVISOS=0

echo -e "${AZUL}=================================================="
echo -e "           🩺 P3XE DOCTOR INTELIGENTE"
echo -e "==================================================${RESET}"
echo "Data : $(date)"
echo "Root : $ROOT"
echo ""

# ==================================================
# 1. SISTEMA E ARQUITETURA
# ==================================================

echo -e "${AZUL}🔹 1. SISTEMA E ARQUITETURA${RESET}"

ARQ=$(uname -m)

if [ "$ARQ" = "aarch64" ]; then
    echo -e "   ${VERDE}✅ Arquitetura: $ARQ${RESET}"
else
    echo -e "   ${VERMELHO}❌ Arquitetura incompatível: $ARQ${RESET}"
    ERROS=$((ERROS+1))
fi

echo "   Android : $(getprop ro.build.version.release)"
echo "   API     : $(getprop ro.build.version.sdk)"
echo "   Kernel  : $(uname -r)"
echo ""

# ==================================================
# 2. ESTRUTURA DO PROJETO
# ==================================================

echo -e "${AZUL}🔹 2. ESTRUTURA DO PROJETO${RESET}"

for PASTA in Cubo3D CoreEmulator tools logs
do
    if [ -d "$ROOT/$PASTA" ]; then
        echo -e "   ${VERDE}✅ $PASTA${RESET}"
    else
        echo -e "   ${AMARELO}⚠ $PASTA não encontrada - criando...${RESET}"
        mkdir -p "$ROOT/$PASTA"
        AVISOS=$((AVISOS+1))
    fi
done

echo ""

# ==================================================
# 3. SDK / NDK / CMAKE
# ==================================================

echo -e "${AZUL}🔹 3. FERRAMENTAS DE COMPILAÇÃO${RESET}"

SDK="$HOME/Android/Sdk"

NDK=$(find "$SDK/ndk" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | tail -n1)

CMAKE=$(find "$SDK/cmake" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | tail -n1)

if [ -d "$SDK" ]; then
    echo -e "   ${VERDE}✅ SDK encontrado${RESET}"
else
    echo -e "   ${VERMELHO}❌ SDK não encontrado${RESET}"
    ERROS=$((ERROS+1))
fi

if [ -n "$NDK" ] && [ -d "$NDK" ]; then
    echo -e "   ${VERDE}✅ NDK encontrado${RESET}"
else
    echo -e "   ${VERMELHO}❌ NDK não encontrado${RESET}"
    ERROS=$((ERROS+1))
fi

if [ -n "$CMAKE" ] && [ -f "$CMAKE/bin/cmake" ]; then
    echo -e "   ${VERDE}✅ CMake encontrado${RESET}"
else
    echo -e "   ${VERMELHO}❌ CMake não encontrado${RESET}"
    ERROS=$((ERROS+1))
fi

echo ""

# ==================================================
# 4. GRADLE E ARQUIVOS DO PROJETO
# ==================================================

echo -e "${AZUL}🔹 4. CONFIGURAÇÃO DOS PROJETOS${RESET}"

for MOD in Cubo3D CoreEmulator
do
    echo
    echo "📦 Projeto: $MOD"

    if [ ! -d "$ROOT/$MOD/android" ]; then
        echo -e "   ${AMARELO}⚠ Projeto não encontrado${RESET}"
        AVISOS=$((AVISOS+1))
        continue
    fi

    GRADLEW="$ROOT/$MOD/android/gradlew"

    if [ -f "$GRADLEW" ]; then
        chmod +x "$GRADLEW"
        echo -e "   ${VERDE}✅ Gradle Wrapper OK${RESET}"
    else
        echo -e "   ${VERMELHO}❌ gradlew não encontrado${RESET}"
        ERROS=$((ERROS+1))
    fi

    LOCALPROP="$ROOT/$MOD/android/local.properties"

    if [ -f "$LOCALPROP" ]; then
        echo -e "   ${VERDE}✅ local.properties encontrado${RESET}"
    else
        echo -e "   ${AMARELO}⚠ Criando local.properties...${RESET}"

cat > "$LOCALPROP" <<EOF
sdk.dir=$SDK
ndk.dir=$NDK
cmake.dir=$CMAKE
EOF

        AVISOS=$((AVISOS+1))
        echo -e "   ${VERDE}✅ local.properties criado${RESET}"
    fi
done

echo ""

# ==================================================
# 5. CMAKE E CÓDIGO NATIVO
# ==================================================

echo -e "${AZUL}🔹 5. CMAKE E JNI${RESET}"

for MOD in Cubo3D CoreEmulator
do
    echo
    echo "📦 Verificando $MOD"

    if [ ! -d "$ROOT/$MOD" ]; then
        echo -e "   ${AMARELO}⚠ Projeto inexistente${RESET}"
        AVISOS=$((AVISOS+1))
        continue
    fi

    CMAKEFILE="$ROOT/$MOD/CMakeLists.txt"

    if [ -f "$CMAKEFILE" ]; then
        echo -e "   ${VERDE}✅ CMakeLists encontrado${RESET}"

        if grep -q "CMAKE_CXX_STANDARD 20" "$CMAKEFILE"; then
            echo -e "      ${VERDE}✅ C++20 configurado${RESET}"
        else
            echo -e "      ${AMARELO}⚠ C++20 não configurado${RESET}"
            AVISOS=$((AVISOS+1))
        fi

    else
        echo -e "   ${VERMELHO}❌ CMakeLists.txt inexistente${RESET}"
        ERROS=$((ERROS+1))
    fi

    JNI="$ROOT/$MOD/android/app/src/main/jni"

    if [ -d "$JNI" ]; then
        echo -e "   ${VERDE}✅ Pasta JNI encontrada${RESET}"
    else
        echo -e "   ${AMARELO}⚠ Pasta JNI inexistente${RESET}"
        AVISOS=$((AVISOS+1))
    fi

done

echo ""

# ==================================================
# 6. RESUMO FINAL
# ==================================================

TOTAL_TESTES=10
SAUDE=$((100 - (ERROS*10) - (AVISOS*2)))

if [ "$SAUDE" -lt 0 ]; then
    SAUDE=0
fi

echo -e "${AZUL}=================================================="
echo "📊 RESUMO DO DIAGNÓSTICO"
echo -e "==================================================${RESET}"

echo
echo "✔ Testes executados : $TOTAL_TESTES"
echo "❌ Erros encontrados : $ERROS"
echo "⚠ Avisos encontrados: $AVISOS"

echo

echo "=============================================="
echo "📈 SAÚDE DO PROJETO"
echo "=============================================="

if [ "$SAUDE" -ge 95 ]; then
    echo -e "${VERDE}🟢 Projeto: ${SAUDE}%${RESET}"
elif [ "$SAUDE" -ge 80 ]; then
    echo -e "${AMARELO}🟡 Projeto: ${SAUDE}%${RESET}"
else
    echo -e "${VERMELHO}🔴 Projeto: ${SAUDE}%${RESET}"
fi

echo

echo "=============================================="
echo "💡 PRÓXIMOS PASSOS"
echo "=============================================="

if [ "$ERROS" -eq 0 ]; then
    echo "1. Executar Build Cubo3D"
    echo "2. Executar Build Completa"
    echo "3. Gerar APK"
else
    echo "1. Executar Smart Repair"
    echo "2. Executar CMake Doctor"
    echo "3. Executar Doctor novamente"
fi

echo

echo "=============================================="

if [ "$ERROS" -eq 0 ]; then
    echo -e "${VERDE}🎉 P3XE PRONTO PARA COMPILAR!${RESET}"
else
    echo -e "${VERMELHO}⚠ EXISTEM PROBLEMAS A SEREM CORRIGIDOS.${RESET}"
fi

echo "=============================================="

echo
echo "Pressione ENTER para voltar..."
read -r
