#!/data/data/com.termux/files/usr/bin/bash

clear

echo "=================================================="
echo "       DIAGNÓSTICO COMPLETO — P3XE / Cubo3D"
echo "=================================================="
echo "Data/Hora: $(date)"
echo "Pasta atual: $(pwd)"
echo ""

# ==================================================
# 1. SISTEMA
# ==================================================
echo "🔍 1. SISTEMA E ARQUITETURA"

echo "   Arquitetura: $(uname -m)"

if command -v termux-info >/dev/null 2>&1; then
    echo "   Termux: OK"
else
    echo "   Termux: NÃO DETECTADO"
fi

echo ""

# ==================================================
# 2. SDK / NDK
# ==================================================
echo "🔍 2. CAMINHOS DO SDK E NDK"

if [ ! -f local.properties ]; then
    echo "   ❌ local.properties não encontrado!"
else

    sdk_dir=$(grep '^sdk.dir=' local.properties | cut -d= -f2-)
    ndk_dir=$(grep '^ndk.dir=' local.properties | cut -d= -f2-)

    echo "   SDK: $sdk_dir"

    if [ -d "$sdk_dir" ]; then
        echo "   ✅ Pasta SDK existe"
    else
        echo "   ❌ Pasta SDK NÃO EXISTE"
    fi

    echo ""

    echo "   NDK: $ndk_dir"

    if [ -d "$ndk_dir" ]; then
        echo "   ✅ Pasta NDK existe"
    else
        echo "   ❌ Pasta NDK NÃO EXISTE"
    fi

    echo "   Versão NDK: $(basename "$ndk_dir")"

fi

echo ""

# ==================================================
# 3. FERRAMENTAS
# ==================================================
echo "🔍 3. FERRAMENTAS OBRIGATÓRIAS"

ferramentas=("cmake" "ninja" "clang" "clang++" "gradlew")

for ferr in "${ferramentas[@]}"; do

    if [ "$ferr" = "gradlew" ]; then

        if [ -f "./gradlew" ]; then
            echo "   ✅ gradlew existe"
        else
            echo "   ❌ gradlew NÃO EXISTE"
        fi

        if [ -x "./gradlew" ]; then
            echo "      Permissão execução: OK"
        else
            echo "      ⚠️ Sem permissão de execução"
        fi

    else

        if command -v "$ferr" >/dev/null 2>&1; then
            echo "   ✅ $ferr instalado"
        else
            echo "   ❌ $ferr NÃO INSTALADO"
        fi

    fi

done

echo ""

# ==================================================
# 4. ESTRUTURA DO PROJETO
# ==================================================
echo "🔍 4. ESTRUTURA DO PROJETO"

arquivos=(
"app/build.gradle"
"app/src/main/AndroidManifest.xml"
"app/src/main/jniLibs/arm64-v8a/libCubo3D.so"
"app/src/main/jniLibs/arm64-v8a/liblhuis.pure3x.so"
"app/src/main/jniLibs/arm64-v8a/libc++_shared.so"
"../../CMakeLists.txt"
)

for arq in "${arquivos[@]}"; do

    if [ -f "$arq" ]; then
        echo "   ✅ $arq"
    else
        echo "   ❌ $arq NÃO ENCONTRADO"
    fi

done

echo ""

# ==================================================
# 5. VERSÕES
# ==================================================
echo "🔍 5. ALINHAMENTO DE VERSÕES"

echo "   minSdk: 29"
echo "   targetSdk: 33"
echo "   Plataforma NDK: android-33"
echo "   C++: C++20"

echo ""

# ==================================================
# 6. CACHE
# ==================================================
echo "🔍 6. CACHES E PASTAS QUEBRADAS"

pastas=(
"app/.cxx"
"build"
"out/build"
)

for pasta in "${pastas[@]}"; do

    if [ -d "$pasta" ]; then
        echo "   ⚠️ Cache encontrado: $pasta"
    fi

done

echo ""

# ==================================================
# RESUMO
# ==================================================
echo "=================================================="
echo "✅ DIAGNÓSTICO FINALIZADO!"
echo "Corrija os itens marcados com ❌ antes do build."
echo "Execute:"
echo "   ./build_com_log.sh"
echo "=================================================="
