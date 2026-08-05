#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine - P3XE Optimizer
# Versão: 0.2.6 Alpha
#
# Analisa:
#   - estrutura
#   - C/C++
#   - CMake
#   - caches
#   - Android
#   - JNI
#   - Vulkan/OpenGL ES
#   - bibliotecas
#   - APK
#   - scripts
#   - arquivos grandes
#   - Git
#
# IMPORTANTE:
# Apenas sugere otimizações.
# Não altera código-fonte.
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR" || exit 1

VERSION="0.2.6 Alpha"

OK=0
WARNINGS=0
SUGGESTIONS=0
CRITICAL=0

separator() {
    echo "============================================================"
}

section() {
    echo
    echo "$1"
    echo "------------------------------------------------------------"
}

ok() {
    echo "✅ $1"
    OK=$((OK + 1))
}

warn() {
    echo "⚠️ $1"
    WARNINGS=$((WARNINGS + 1))
}

suggest() {
    echo "💡 $1"
    SUGGESTIONS=$((SUGGESTIONS + 1))
}

critical() {
    echo "❌ $1"
    CRITICAL=$((CRITICAL + 1))
}


clear

separator
echo "💡 P3XE - OTIMIZADOR INTELIGENTE"
echo "Pure3XEngine $VERSION"
separator

echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"

separator


# ============================================================
# ESTRUTURA
# ============================================================

section "📁 ESTRUTURA"

for DIR in CoreEmulator Cubo3D QEMUCenter Android Config tools; do

    if [ -d "$ROOT_DIR/$DIR" ]; then
        ok "$DIR"
    else
        warn "$DIR não encontrado"
    fi

done


# ============================================================
# ESTATÍSTICAS
# ============================================================

section "📊 ESTATÍSTICAS DO PROJETO"

CPP_COUNT=$(
    find "$ROOT_DIR" \
        -type f \
        \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" -o -name "*.c" \) \
        -not -path "*/build/*" \
        -not -path "*/out/*" \
        2>/dev/null | wc -l
)

HEADER_COUNT=$(
    find "$ROOT_DIR" \
        -type f \
        \( -name "*.h" -o -name "*.hpp" \) \
        -not -path "*/build/*" \
        -not -path "*/out/*" \
        2>/dev/null | wc -l
)

SCRIPT_COUNT=$(
    find "$ROOT_DIR" \
        -type f -name "*.sh" \
        -not -path "*/.git/*" \
        2>/dev/null | wc -l
)

CMAKE_COUNT=$(
    find "$ROOT_DIR" \
        -type f -name "CMakeLists.txt" \
        -not -path "*/build/*" \
        -not -path "*/out/*" \
        2>/dev/null | wc -l
)

echo "C/C++      : $CPP_COUNT"
echo "Headers    : $HEADER_COUNT"
echo "Scripts    : $SCRIPT_COUNT"
echo "CMakeLists : $CMAKE_COUNT"


# ============================================================
# CMAKE CACHE
# ============================================================

section "🧩 CMAKE / CACHE"

CACHE_COUNT=$(
    find "$ROOT_DIR" \
        -type f -name "CMakeCache.txt" \
        2>/dev/null | wc -l
)

echo "Caches encontrados : $CACHE_COUNT"

if [ "$CACHE_COUNT" -eq 0 ]; then

    ok "Nenhum cache CMake residual"

else

    warn "$CACHE_COUNT cache(s) CMake encontrado(s)"

    find "$ROOT_DIR" \
        -type f -name "CMakeCache.txt" \
        2>/dev/null |
    while IFS= read -r CACHE; do

        echo "   • ${CACHE#$ROOT_DIR/}"

    done

    suggest "Remover caches antigos antes de trocar toolchain/NDK"

fi


# ============================================================
# CMAKE NOTFOUND
# ============================================================

section "🔗 DEPENDÊNCIAS CMAKE"

NOTFOUND_TOTAL=0

while IFS= read -r CACHE; do

    FOUND=$(
        grep -E \
        '^[A-Za-z0-9_]+(:[^=]+)?=.*-NOTFOUND$' \
        "$CACHE" 2>/dev/null || true
    )

    if [ -n "$FOUND" ]; then

        echo "⚠️ ${CACHE#$ROOT_DIR/}"

        echo "$FOUND" |
        sed 's/^/   /'

        COUNT=$(printf '%s\n' "$FOUND" | wc -l)

        NOTFOUND_TOTAL=$((NOTFOUND_TOTAL + COUNT))

    fi

done < <(
    find "$ROOT_DIR" \
        -type f -name "CMakeCache.txt" \
        2>/dev/null
)

if [ "$NOTFOUND_TOTAL" -eq 0 ]; then

    ok "Nenhuma biblioteca NOTFOUND"

else

    critical "$NOTFOUND_TOTAL dependência(s) NOTFOUND"

    suggest "Corrigir find_library() para bibliotecas Android/NDK"

    suggest "Não reutilizar CMakeCache criado com toolchain diferente"

fi


# ============================================================
# VERIFICAR ERROS QUE JÁ ENCONTRAMOS
# ============================================================

section "🧠 PRIORIDADES DETECTADAS"

FOUND_PRIORITY=0

for VAR in \
    ANDROID_LIB \
    GLES3_LIB \
    JNIGRAPHICS_LIB \
    LOG_LIB \
    CMAKE_TAPI
do

    RESULT=$(
        grep -R \
            --include="CMakeCache.txt" \
            "${VAR}.*NOTFOUND" \
            "$ROOT_DIR" \
            2>/dev/null |
        head -n 1
    )

    if [ -n "$RESULT" ]; then

        echo "❌ $VAR = NOTFOUND"

        FOUND_PRIORITY=$((FOUND_PRIORITY + 1))

    fi

done

if [ "$FOUND_PRIORITY" -gt 0 ]; then

    echo
    echo "Prioridade alta : $FOUND_PRIORITY"

    suggest "Resolver essas dependências antes de confiar no build"

else

    ok "Nenhuma dependência prioritária NOTFOUND"

fi


# ============================================================
# C++ STANDARD
# ============================================================

section "⚙️ C++"

if grep -Rqs \
    --include="CMakeLists.txt" \
    "CXX_STANDARD 20\|cxx_std_20\|-std=c++20" \
    "$ROOT_DIR" 2>/dev/null; then

    ok "C++20 detectado"

else

    warn "C++20 não detectado explicitamente"

    suggest "Usar CMAKE_CXX_STANDARD 20"

fi


# ============================================================
# BUILD TYPE
# ============================================================

section "🏗️ BUILD"

if grep -Rqs \
    --include="CMakeLists.txt" \
    "Release\|RelWithDebInfo" \
    "$ROOT_DIR" 2>/dev/null; then

    ok "Configuração de build otimizada encontrada"

else

    suggest "Usar Release ou RelWithDebInfo para builds de desempenho"

fi


# ============================================================
# COMPILER FLAGS
# ============================================================

section "🚀 FLAGS DE COMPILAÇÃO"

if grep -Rqs \
    --include="CMakeLists.txt" \
    -- "-O2\|-O3" \
    "$ROOT_DIR" 2>/dev/null; then

    ok "Flags de otimização detectadas"

else

    suggest "Avaliar -O2 para builds Release"

fi

if grep -Rqs \
    --include="CMakeLists.txt" \
    "march=native" \
    "$ROOT_DIR" 2>/dev/null; then

    warn "-march=native encontrado"

    suggest "Evitar -march=native em APK Android distribuível"

fi


# ============================================================
# JNI
# ============================================================

section "🔌 JNI"

JNI_COUNT=$(
    grep -RIl \
        --include="*.cpp" \
        --include="*.c" \
        --include="*.h" \
        "JNIEXPORT\|JNI_OnLoad\|Java_" \
        "$ROOT_DIR" \
        2>/dev/null |
    grep -v "/build/" |
    grep -v "/out/" |
    wc -l
)

echo "Arquivos JNI : $JNI_COUNT"

if [ "$JNI_COUNT" -gt 0 ]; then

    ok "JNI detectado"

    suggest "Evitar chamadas JNI repetitivas dentro do frame de renderização"

else

    warn "JNI não detectado"

fi


# ============================================================
# RENDERIZAÇÃO
# ============================================================

section "🎮 RENDERIZAÇÃO"

VULKAN=0
OPENGL=0
SWAP=0

if grep -Rqs \
    --include="*.cpp" \
    --include="*.h" \
    "Vulkan\|VK_\|vulkan" \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/Cubo3D" 2>/dev/null; then

    VULKAN=1
    ok "Vulkan detectado"

fi

if grep -Rqs \
    --include="*.cpp" \
    --include="*.h" \
    "GLES\|eglCreateContext\|glClear" \
    "$ROOT_DIR/CoreEmulator" \
    "$ROOT_DIR/Cubo3D" 2>/dev/null; then

    OPENGL=1
    ok "OpenGL ES / EGL detectado"

fi

if grep -Rqs \
    --include="*.cpp" \
    --include="*.c" \
    "eglSwapBuffers" \
    "$ROOT_DIR" 2>/dev/null; then

    SWAP=1
    ok "eglSwapBuffers detectado"

else

    warn "eglSwapBuffers não encontrado"

fi

if [ "$VULKAN" -eq 1 ] && [ "$OPENGL" -eq 1 ]; then

    suggest "Manter Vulkan e OpenGL ES separados por backend"

fi


# ============================================================
# TELA PRETA / FRAME
# ============================================================

section "🖥️ PIPELINE DE FRAME"

PIPELINE=0

for SYMBOL in \
    eglCreateContext \
    eglCreateWindowSurface \
    glClear \
    eglSwapBuffers
do

    if grep -Rqs \
        --include="*.cpp" \
        --include="*.c" \
        "$SYMBOL" \
        "$ROOT_DIR" 2>/dev/null; then

        echo "✅ $SYMBOL"
        PIPELINE=$((PIPELINE + 1))

    else

        echo "⚠️ $SYMBOL ausente"

    fi

done

echo
echo "Pipeline EGL : $PIPELINE/4"

if [ "$PIPELINE" -eq 4 ]; then

    ok "Pipeline EGL básico completo"

else

    warn "Pipeline EGL básico incompleto"

    suggest "Completar Context → Surface → Clear → SwapBuffers"

fi


# ============================================================
# SHADERS
# ============================================================

section "✨ SHADERS"

SHADER_COUNT=$(
    find "$ROOT_DIR" \
        -type f \
        \( \
            -name "*.vert" -o \
            -name "*.frag" -o \
            -name "*.glsl" -o \
            -name "*.spv" \
        \) \
        2>/dev/null | wc -l
)

echo "Shaders encontrados : $SHADER_COUNT"

if [ "$SHADER_COUNT" -gt 0 ]; then

    ok "Shaders detectados"

else

    warn "Nenhum shader externo encontrado"

    suggest "Shaders podem estar embutidos no C++; verificar compilação e logs"

fi


# ============================================================
# ANDROID
# ============================================================

section "🤖 ANDROID"

MANIFEST=$(
    find "$ROOT_DIR" \
        -type f -name "AndroidManifest.xml" \
        -not -path "*/build/*" \
        2>/dev/null | head -n 1
)

if [ -n "$MANIFEST" ]; then

    ok "Manifest: ${MANIFEST#$ROOT_DIR/}"

else

    warn "AndroidManifest.xml não encontrado"

fi

GRADLE=$(
    find "$ROOT_DIR" \
        -type f \
        \( -name "build.gradle" -o -name "build.gradle.kts" \) \
        -not -path "*/build/*" \
        2>/dev/null | head -n 1
)

if [ -n "$GRADLE" ]; then

    ok "Gradle: ${GRADLE#$ROOT_DIR/}"

else

    warn "Gradle não encontrado"

fi


# ============================================================
# BIBLIOTECAS
# ============================================================

section "📦 BIBLIOTECAS NATIVAS"

SO_COUNT=$(
    find "$ROOT_DIR" \
        -type f -name "*.so" \
        2>/dev/null | wc -l
)

echo "Bibliotecas .so : $SO_COUNT"

if [ "$SO_COUNT" -gt 0 ]; then

    ok "$SO_COUNT biblioteca(s) encontrada(s)"

else

    warn "Nenhuma biblioteca .so encontrada"

fi


# ============================================================
# APK
# ============================================================

section "📱 APK"

APK_COUNT=$(
    find "$ROOT_DIR" \
        -type f -name "*.apk" \
        2>/dev/null | wc -l
)

echo "APK encontrados : $APK_COUNT"

if [ "$APK_COUNT" -gt 0 ]; then

    ok "$APK_COUNT APK(s) encontrado(s)"

else

    warn "Nenhum APK encontrado"

fi


# ============================================================
# ARQUIVOS GRANDES
# ============================================================

section "💾 ARQUIVOS GRANDES"

LARGE_COUNT=0

while IFS= read -r FILE; do

    [ -z "$FILE" ] && continue

    SIZE=$(du -h "$FILE" 2>/dev/null | awk '{print $1}')

    echo "⚠️ $SIZE  ${FILE#$ROOT_DIR/}"

    LARGE_COUNT=$((LARGE_COUNT + 1))

done < <(
    find "$ROOT_DIR" \
        -type f \
        -size +50M \
        -not -path "*/.git/*" \
        2>/dev/null
)

if [ "$LARGE_COUNT" -eq 0 ]; then

    ok "Nenhum arquivo acima de 50 MB"

else

    suggest "Revisar arquivos grandes desnecessários no projeto"

fi


# ============================================================
# SINTAXE DOS SCRIPTS
# ============================================================

section "🧪 SCRIPTS"

SCRIPT_ERRORS=0
SCRIPT_OK=0

while IFS= read -r FILE; do

    if bash -n "$FILE" 2>/dev/null; then

        SCRIPT_OK=$((SCRIPT_OK + 1))

    else

        echo "❌ ${FILE#$ROOT_DIR/}"
        SCRIPT_ERRORS=$((SCRIPT_ERRORS + 1))

    fi

done < <(
    find "$ROOT_DIR" \
        -type f -name "*.sh" \
        -not -path "*/.git/*" \
        -not -path "*/build/*" \
        -not -path "*/out/*" \
        2>/dev/null
)

echo "Scripts OK   : $SCRIPT_OK"
echo "Scripts erro : $SCRIPT_ERRORS"

if [ "$SCRIPT_ERRORS" -eq 0 ]; then

    ok "Todos os scripts possuem sintaxe válida"

else

    critical "$SCRIPT_ERRORS script(s) com erro"

fi


# ============================================================
# GIT
# ============================================================

section "🌿 GIT"

if [ -d "$ROOT_DIR/.git" ]; then

    BRANCH=$(git -C "$ROOT_DIR" branch --show-current 2>/dev/null)
    COMMIT=$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null)
    CHANGES=$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l)

    echo "Branch     : ${BRANCH:-?}"
    echo "Commit     : ${COMMIT:-?}"
    echo "Alterações : $CHANGES"

    if [ "$CHANGES" -gt 100 ]; then

        warn "Muitas alterações locais: $CHANGES"

        suggest "Criar commit de segurança antes das correções estruturais"

    elif [ "$CHANGES" -gt 0 ]; then

        warn "$CHANGES alteração(ões) local(is)"

    else

        ok "Git limpo"

    fi

else

    warn "Git não detectado"

fi


# ============================================================
# SUGESTÕES FINAIS
# ============================================================

section "🧠 PLANO DE OTIMIZAÇÃO"

echo "Prioridade recomendada:"
echo

PRIORITY=1

if [ "$NOTFOUND_TOTAL" -gt 0 ]; then

    echo "$PRIORITY) Corrigir bibliotecas CMake NOTFOUND"
    PRIORITY=$((PRIORITY + 1))

fi

if [ "$CACHE_COUNT" -gt 0 ]; then

    echo "$PRIORITY) Limpar caches CMake antigos"
    PRIORITY=$((PRIORITY + 1))

fi

if [ "$PIPELINE" -lt 4 ]; then

    echo "$PRIORITY) Corrigir pipeline EGL/renderização"
    PRIORITY=$((PRIORITY + 1))

fi

if [ "$SCRIPT_ERRORS" -gt 0 ]; then

    echo "$PRIORITY) Corrigir scripts Bash"
    PRIORITY=$((PRIORITY + 1))

fi

echo "$PRIORITY) Validar build limpo"
PRIORITY=$((PRIORITY + 1))

echo "$PRIORITY) Testar APK no Android"
PRIORITY=$((PRIORITY + 1))

echo "$PRIORITY) Medir desempenho antes de novas otimizações"


# ============================================================
# RESUMO
# ============================================================

echo
separator
echo "📊 RESUMO DO OPTIMIZER"
separator

echo "OK          : $OK"
echo "Avisos      : $WARNINGS"
echo "Críticos    : $CRITICAL"
echo "Sugestões   : $SUGGESTIONS"
echo
echo "C/C++       : $CPP_COUNT"
echo "Headers     : $HEADER_COUNT"
echo "Scripts     : $SCRIPT_COUNT"
echo "APK         : $APK_COUNT"
echo ".so         : $SO_COUNT"
echo "CMake cache : $CACHE_COUNT"
echo "NOTFOUND    : $NOTFOUND_TOTAL"
echo "EGL         : $PIPELINE/4"

echo

if [ "$CRITICAL" -gt 0 ]; then

    echo "❌ OTIMIZAÇÃO BLOQUEADA POR PROBLEMAS PRIORITÁRIOS"

elif [ "$WARNINGS" -gt 0 ]; then

    echo "⚠️ PROJETO OTIMIZÁVEL COM AVISOS"

else

    echo "✅ PROJETO PRONTO PARA OTIMIZAÇÃO"

fi

separator

echo
echo "Pure3XEngine $VERSION"
echo "P3XE Optimizer - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
