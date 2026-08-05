#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine - P3XE Error Analyzer
# Versão: 0.2.6 Alpha
# Analisa erros sem modificar o projeto
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR" || exit 1

VERSION="0.2.6 Alpha"

ERRORS=0
WARNINGS=0
OK=0

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

error() {
    echo "❌ $1"
    ERRORS=$((ERRORS + 1))
}

clear

separator
echo "🔎 P3XE - ANALISADOR INTELIGENTE DE ERROS"
echo "Pure3XEngine $VERSION"
separator
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
separator


# ============================================================
# 1. ESTRUTURA
# ============================================================

section "📁 ESTRUTURA DO PROJETO"

for DIR in CoreEmulator Cubo3D QEMUCenter Android Config tools; do
    if [ -d "$ROOT_DIR/$DIR" ]; then
        ok "$DIR encontrado"
    else
        error "$DIR não encontrado"
    fi
done


# ============================================================
# 2. SINTAXE BASH
# ============================================================

section "🧪 SINTAXE BASH"

BASH_OK=0
BASH_ERROR=0

while IFS= read -r FILE; do

    if bash -n "$FILE" 2>/dev/null; then
        BASH_OK=$((BASH_OK + 1))
    else
        echo
        error "Erro Bash: ${FILE#$ROOT_DIR/}"
        bash -n "$FILE" 2>&1 | sed 's/^/   /'
        BASH_ERROR=$((BASH_ERROR + 1))
    fi

done < <(
    find "$ROOT_DIR" \
        -type f -name "*.sh" \
        -not -path "*/.git/*" \
        -not -path "*/build/*" \
        -not -path "*/out/*" \
        2>/dev/null
)

echo
echo "Scripts OK       : $BASH_OK"
echo "Scripts com erro : $BASH_ERROR"

if [ "$BASH_ERROR" -eq 0 ]; then
    ok "Sintaxe Bash válida"
fi


# ============================================================
# 3. CMAKE
# ============================================================

section "🧩 CMAKE"

CMAKE_COUNT=$(
    find "$ROOT_DIR" \
        -type f -name "CMakeLists.txt" \
        -not -path "*/build/*" \
        -not -path "*/out/*" \
        2>/dev/null | wc -l
)

echo "CMakeLists encontrados : $CMAKE_COUNT"

if [ "$CMAKE_COUNT" -gt 0 ]; then
    ok "Configuração CMake encontrada"
else
    error "Nenhum CMakeLists.txt encontrado"
fi

CACHE_COUNT=$(
    find "$ROOT_DIR" \
        -type f -name "CMakeCache.txt" \
        2>/dev/null | wc -l
)

echo "Caches CMake           : $CACHE_COUNT"

if [ "$CACHE_COUNT" -gt 0 ]; then
    warn "$CACHE_COUNT cache(s) CMake encontrado(s)"

    find "$ROOT_DIR" \
        -type f -name "CMakeCache.txt" \
        2>/dev/null |
    while IFS= read -r CACHE; do
        echo "   • ${CACHE#$ROOT_DIR/}"
    done
else
    ok "Nenhum cache CMake residual"
fi


# ============================================================
# 4. VARIÁVEIS NOTFOUND DO CMAKE
# ============================================================

section "🔗 BIBLIOTECAS CMAKE"

NOTFOUND_COUNT=0

while IFS= read -r CACHE; do

    FOUND=$(
        grep -E '^[A-Za-z0-9_]+(:[^=]+)?=.*-NOTFOUND$' \
            "$CACHE" 2>/dev/null || true
    )

    if [ -n "$FOUND" ]; then

        warn "Bibliotecas NOTFOUND em ${CACHE#$ROOT_DIR/}"

        echo "$FOUND" | sed 's/^/   /'

        COUNT=$(printf '%s\n' "$FOUND" | wc -l)
        NOTFOUND_COUNT=$((NOTFOUND_COUNT + COUNT))
    fi

done < <(
    find "$ROOT_DIR" \
        -type f -name "CMakeCache.txt" \
        2>/dev/null
)

if [ "$NOTFOUND_COUNT" -eq 0 ]; then
    ok "Nenhuma variável CMake NOTFOUND detectada"
else
    error "$NOTFOUND_COUNT variável(is) CMake NOTFOUND"
fi


# ============================================================
# 5. ANDROID
# ============================================================

section "🤖 ANDROID"

if [ -d "$ROOT_DIR/Android" ]; then
    ok "Backend Android encontrado"
else
    error "Diretório Android ausente"
fi

MANIFEST=$(
    find "$ROOT_DIR" \
        -type f -name "AndroidManifest.xml" \
        -not -path "*/build/*" \
        2>/dev/null | head -n 1
)

if [ -n "$MANIFEST" ]; then
    ok "AndroidManifest.xml: ${MANIFEST#$ROOT_DIR/}"
else
    warn "AndroidManifest.xml não encontrado"
fi

GRADLE=$(
    find "$ROOT_DIR" \
        -type f \( \
            -name "gradlew" -o \
            -name "build.gradle" -o \
            -name "build.gradle.kts" \
        \) \
        -not -path "*/build/*" \
        2>/dev/null | head -n 1
)

if [ -n "$GRADLE" ]; then
    ok "Gradle detectado: ${GRADLE#$ROOT_DIR/}"
else
    warn "Gradle não detectado"
fi


# ============================================================
# 6. C/C++
# ============================================================

section "🧠 C / C++"

CPP_COUNT=$(
    find "$ROOT_DIR" \
        -type f \( \
            -name "*.cpp" -o \
            -name "*.cc" -o \
            -name "*.cxx" -o \
            -name "*.c" \
        \) \
        -not -path "*/build/*" \
        -not -path "*/out/*" \
        2>/dev/null | wc -l
)

HEADER_COUNT=$(
    find "$ROOT_DIR" \
        -type f \( \
            -name "*.h" -o \
            -name "*.hpp" \
        \) \
        -not -path "*/build/*" \
        -not -path "*/out/*" \
        2>/dev/null | wc -l
)

echo "Código C/C++ : $CPP_COUNT"
echo "Headers      : $HEADER_COUNT"

if [ "$CPP_COUNT" -gt 0 ]; then
    ok "Código nativo detectado"
else
    warn "Nenhum código C/C++ detectado"
fi


# ============================================================
# 7. JNI
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

echo "Arquivos JNI detectados : $JNI_COUNT"

if [ "$JNI_COUNT" -gt 0 ]; then
    ok "Integração JNI encontrada"
else
    warn "Nenhuma implementação JNI detectada"
fi


# ============================================================
# 8. GRÁFICOS
# ============================================================

section "🎮 RENDERIZAÇÃO"

if grep -Rqs \
    --include="*.cpp" \
    --include="*.h" \
    --include="CMakeLists.txt" \
    "vulkan\|Vulkan\|VK_" \
    "$ROOT_DIR/Cubo3D" \
    "$ROOT_DIR/CoreEmulator" 2>/dev/null; then

    ok "Vulkan detectado"
else
    warn "Vulkan não detectado no código"
fi

if grep -Rqs \
    --include="*.cpp" \
    --include="*.h" \
    --include="CMakeLists.txt" \
    "GLES\|OpenGL ES\|eglCreate\|eglSwapBuffers\|glClear" \
    "$ROOT_DIR/Cubo3D" \
    "$ROOT_DIR/CoreEmulator" 2>/dev/null; then

    ok "OpenGL ES / EGL detectado"
else
    warn "OpenGL ES / EGL não detectado"
fi


# ============================================================
# 9. INVESTIGAÇÃO DE TELA PRETA
# ============================================================

section "🖥️ DIAGNÓSTICO DE TELA PRETA"

if grep -Rqs \
    --include="*.cpp" \
    --include="*.c" \
    "eglSwapBuffers" \
    "$ROOT_DIR" 2>/dev/null; then

    ok "eglSwapBuffers encontrado"
else
    warn "eglSwapBuffers não encontrado"
fi

if grep -Rqs \
    --include="*.cpp" \
    --include="*.c" \
    "glClear(" \
    "$ROOT_DIR" 2>/dev/null; then

    ok "glClear encontrado"
else
    warn "glClear não encontrado"
fi

if grep -Rqs \
    --include="*.cpp" \
    --include="*.c" \
    "eglCreateContext" \
    "$ROOT_DIR" 2>/dev/null; then

    ok "Criação de EGLContext encontrada"
else
    warn "eglCreateContext não encontrado"
fi

if grep -Rqs \
    --include="*.cpp" \
    --include="*.c" \
    "eglCreateWindowSurface" \
    "$ROOT_DIR" 2>/dev/null; then

    ok "EGL Window Surface encontrada"
else
    warn "eglCreateWindowSurface não encontrada"
fi


# ============================================================
# 10. BIBLIOTECAS NATIVAS
# ============================================================

section "📦 BIBLIOTECAS .SO"

SO_COUNT=$(
    find "$ROOT_DIR" \
        -type f -name "*.so" \
        2>/dev/null | wc -l
)

echo "Bibliotecas encontradas : $SO_COUNT"

if [ "$SO_COUNT" -gt 0 ]; then
    ok "$SO_COUNT biblioteca(s) nativa(s) encontrada(s)"
else
    warn "Nenhuma biblioteca .so encontrada"
fi

find "$ROOT_DIR" \
    -type f -name "liblhuis*.so" \
    2>/dev/null |
while IFS= read -r LIB; do
    echo "   • ${LIB#$ROOT_DIR/}"
done


# ============================================================
# 11. APK
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
# 12. QEMU
# ============================================================

section "🖥️ QEMU"

if [ -d "$ROOT_DIR/QEMUCenter" ]; then
    ok "QEMUCenter encontrado"
else
    warn "QEMUCenter não encontrado"
fi

QEMU_COUNT=$(
    find "$ROOT_DIR/QEMUCenter" \
        -type f 2>/dev/null | wc -l
)

echo "Arquivos QEMU : $QEMU_COUNT"


# ============================================================
# 13. GIT
# ============================================================

section "🌿 GIT"

if [ -d "$ROOT_DIR/.git" ]; then

    BRANCH=$(git -C "$ROOT_DIR" branch --show-current 2>/dev/null)
    COMMIT=$(git -C "$ROOT_DIR" rev-parse --short HEAD 2>/dev/null)
    CHANGES=$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l)

    echo "Branch     : ${BRANCH:-desconhecida}"
    echo "Commit     : ${COMMIT:-desconhecido}"
    echo "Alterações : $CHANGES"

    if [ "$CHANGES" -gt 0 ]; then
        warn "$CHANGES alteração(ões) local(is) não commitada(s)"
    else
        ok "Árvore Git limpa"
    fi

else
    warn "Repositório Git não encontrado"
fi


# ============================================================
# 14. FERRAMENTAS
# ============================================================

section "🧰 FERRAMENTAS"

for TOOL in clang clang++ cmake git make; do

    if command -v "$TOOL" >/dev/null 2>&1; then
        ok "$TOOL: $(command -v "$TOOL")"
    else
        error "$TOOL não encontrado"
    fi

done


# ============================================================
# RESULTADO
# ============================================================

echo
separator
echo "📊 RESUMO DO ANALISADOR"
separator

echo "OK       : $OK"
echo "Avisos   : $WARNINGS"
echo "Erros    : $ERRORS"
echo "Bash OK  : $BASH_OK"
echo "Bash erro: $BASH_ERROR"
echo "C/C++    : $CPP_COUNT"
echo "Headers  : $HEADER_COUNT"
echo "APK      : $APK_COUNT"
echo ".so      : $SO_COUNT"
echo

if [ "$ERRORS" -gt 0 ]; then
    echo "❌ ESTADO: ERROS ENCONTRADOS"
elif [ "$WARNINGS" -gt 0 ]; then
    echo "⚠️ ESTADO: FUNCIONAL COM AVISOS"
else
    echo "✅ ESTADO: NENHUM ERRO DETECTADO"
fi

separator
echo
echo "Pure3XEngine $VERSION"
echo "P3XE Error Analyzer - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
