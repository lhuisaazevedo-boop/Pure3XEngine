#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine - Project Report
# P3XE AI Center
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR" || exit 1

VERSION="0.2.6 Alpha"
REPORT_DIR="$ROOT_DIR/reports"
DATE_NOW="$(date '+%d/%m/%Y')"
TIME_NOW="$(date '+%H:%M:%S')"
STAMP="$(date '+%Y%m%d_%H%M%S')"
REPORT="$REPORT_DIR/project_report_$STAMP.txt"

OK=0
WARN=0
ERROR=0

mkdir -p "$REPORT_DIR"

line() {
    printf '%*s\n' 63 '' | tr ' ' '='
}

dash() {
    printf '%*s\n' 63 '' | tr ' ' '-'
}

count_files() {
    local pattern="$1"
    find . \
        -path './.git' -prune -o \
        -path './out' -prune -o \
        -path '*/build' -prune -o \
        -path '*/.gradle' -prune -o \
        -type f -name "$pattern" -print 2>/dev/null | wc -l
}

count_dir_files() {
    local dir="$1"

    if [ -d "$dir" ]; then
        find "$dir" \
            -path '*/build' -prune -o \
            -path '*/.gradle' -prune -o \
            -type f -print 2>/dev/null | wc -l
    else
        echo 0
    fi
}

size_dir() {
    local dir="$1"

    if [ -d "$dir" ]; then
        du -sh "$dir" 2>/dev/null | awk '{print $1}'
    else
        echo "-"
    fi
}

{
clear

line
echo "📊 P3XE - RELATÓRIO INTELIGENTE DO PROJETO"
echo "Pure3XEngine $VERSION"
line
echo "Projeto : $ROOT_DIR"
echo "Data    : $DATE_NOW"
echo "Hora    : $TIME_NOW"
line
echo

# ============================================================
# MÓDULOS
# ============================================================

echo "📁 MÓDULOS"
dash

MODULES=(
    "CoreEmulator"
    "Cubo3D"
    "QEMUCenter"
    "Android"
    "Config"
    "tools"
)

for module in "${MODULES[@]}"; do
    if [ -d "$module" ]; then
        FILES="$(count_dir_files "$module")"
        SIZE="$(size_dir "$module")"

        echo "✅ $module"
        echo "   Arquivos : $FILES"
        echo "   Tamanho  : $SIZE"

        ((OK++))
    else
        echo "⚠️ $module não encontrado"
        ((WARN++))
    fi
done

echo

# ============================================================
# ESTATÍSTICAS
# ============================================================

echo "📈 ESTATÍSTICAS DO CÓDIGO"
dash

CPP=$(( $(count_files "*.cpp") + $(count_files "*.cc") + $(count_files "*.cxx") + $(count_files "*.c") ))
HEADERS=$(( $(count_files "*.h") + $(count_files "*.hpp") ))
JAVA="$(count_files "*.java")"
KOTLIN="$(count_files "*.kt")"
CMAKE="$(count_files "CMakeLists.txt")"
BASH="$(count_files "*.sh")"
GLSL=$(( $(count_files "*.vert") + $(count_files "*.frag") + $(count_files "*.glsl") ))
XML="$(count_files "*.xml")"

printf "%-18s : %s\n" "C/C++" "$CPP"
printf "%-18s : %s\n" "Headers" "$HEADERS"
printf "%-18s : %s\n" "Java" "$JAVA"
printf "%-18s : %s\n" "Kotlin" "$KOTLIN"
printf "%-18s : %s\n" "CMakeLists" "$CMAKE"
printf "%-18s : %s\n" "Scripts Bash" "$BASH"
printf "%-18s : %s\n" "Shaders" "$GLSL"
printf "%-18s : %s\n" "XML" "$XML"

echo

# ============================================================
# GRÁFICOS
# ============================================================

echo "🎮 SISTEMA GRÁFICO"
dash

if grep -Rqs \
    --exclude-dir=.git \
    --exclude-dir=build \
    --exclude-dir=out \
    -E 'Vulkan|vulkan|VK_' \
    CoreEmulator Cubo3D Android 2>/dev/null; then

    echo "✅ Vulkan detectado"
    ((OK++))
else
    echo "⚠️ Vulkan não detectado no código"
    ((WARN++))
fi

if grep -Rqs \
    --exclude-dir=.git \
    --exclude-dir=build \
    --exclude-dir=out \
    -E 'OpenGL|GLES|gl[A-Z]|EGL' \
    CoreEmulator Cubo3D Android 2>/dev/null; then

    echo "✅ OpenGL ES / EGL detectado"
    ((OK++))
else
    echo "⚠️ OpenGL ES / EGL não detectado"
    ((WARN++))
fi

echo

# ============================================================
# QEMU
# ============================================================

echo "🖥️ QEMU"
dash

if [ -d "QEMUCenter" ]; then
    echo "✅ QEMUCenter detectado"
    ((OK++))
else
    echo "❌ QEMUCenter ausente"
    ((ERROR++))
fi

if find QEMUCenter tools \
    -type f 2>/dev/null |
    grep -qi 'qemu'; then

    echo "✅ Arquivos QEMU detectados"
    ((OK++))
else
    echo "⚠️ Runtime QEMU não identificado"
    ((WARN++))
fi

echo

# ============================================================
# ANDROID
# ============================================================

echo "🤖 ANDROID"
dash

if [ -d "Android" ]; then
    echo "✅ Backend Android detectado"
    ((OK++))

    MANIFEST="$(find Android -name AndroidManifest.xml -type f 2>/dev/null | head -1)"

    if [ -n "$MANIFEST" ]; then
        echo "✅ AndroidManifest.xml"
        echo "   $MANIFEST"
        ((OK++))
    else
        echo "⚠️ AndroidManifest.xml não encontrado"
        ((WARN++))
    fi
else
    echo "❌ Android não encontrado"
    ((ERROR++))
fi

GRADLE="$(find Android -type f \
    \( -name gradlew -o -name build.gradle -o -name build.gradle.kts \) \
    2>/dev/null | head -1)"

if [ -n "$GRADLE" ]; then
    echo "✅ Sistema Gradle detectado"
else
    echo "⚠️ Gradle não detectado dentro de Android"
    ((WARN++))
fi

echo

# ============================================================
# BUILD / CACHE
# ============================================================

echo "🔧 BUILD / CACHE"
dash

CACHE_COUNT="$(find . \
    -path './.git' -prune -o \
    -name CMakeCache.txt -type f -print 2>/dev/null | wc -l)"

echo "Caches CMake : $CACHE_COUNT"

if [ "$CACHE_COUNT" -gt 0 ]; then
    find . \
        -path './.git' -prune -o \
        -name CMakeCache.txt -type f -print 2>/dev/null |
    sed 's|^\./| • |'
fi

echo

# ============================================================
# BINÁRIOS
# ============================================================

echo "📦 ARTEFATOS"
dash

APK_COUNT="$(find exports Android Cubo3D \
    -type f -name "*.apk" 2>/dev/null | wc -l)"

SO_COUNT="$(find . \
    -path './.git' -prune -o \
    -type f -name "*.so" -print 2>/dev/null | wc -l)"

RELEASE_COUNT=0

if [ -d "exports/releases" ]; then
    RELEASE_COUNT="$(find exports/releases \
        -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)"
fi

echo "APK encontrados       : $APK_COUNT"
echo "Bibliotecas .so       : $SO_COUNT"
echo "Releases              : $RELEASE_COUNT"

if [ "$APK_COUNT" -gt 0 ]; then
    ((OK++))
else
    ((WARN++))
fi

echo

# ============================================================
# GIT
# ============================================================

echo "🌿 GIT"
dash

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    BRANCH="$(git branch --show-current 2>/dev/null)"
    COMMIT="$(git rev-parse --short HEAD 2>/dev/null)"
    CHANGES="$(git status --porcelain 2>/dev/null | wc -l)"

    echo "Branch     : ${BRANCH:-desconhecida}"
    echo "Commit     : ${COMMIT:-desconhecido}"
    echo "Alterações : $CHANGES"

    ((OK++))

    if [ "$CHANGES" -gt 0 ]; then
        echo "⚠️ Existem alterações locais não commitadas"
        ((WARN++))
    else
        echo "✅ Árvore Git limpa"
        ((OK++))
    fi

else
    echo "⚠️ Repositório Git não detectado"
    ((WARN++))
fi

echo

# ============================================================
# SINTAXE DOS SCRIPTS
# ============================================================

echo "🔍 SINTAXE BASH"
dash

SCRIPT_OK=0
SCRIPT_ERROR=0

while IFS= read -r script; do
    if bash -n "$script" 2>/dev/null; then
        ((SCRIPT_OK++))
    else
        echo "❌ $script"
        ((SCRIPT_ERROR++))
    fi
done < <(
    find tools -type f -name "*.sh" 2>/dev/null | sort
)

echo "Scripts OK       : $SCRIPT_OK"
echo "Scripts com erro : $SCRIPT_ERROR"

if [ "$SCRIPT_ERROR" -eq 0 ]; then
    echo "✅ Todos os scripts analisados possuem sintaxe válida"
    ((OK++))
else
    ((ERROR+=SCRIPT_ERROR))
fi

echo

# ============================================================
# FERRAMENTAS
# ============================================================

echo "🧰 FERRAMENTAS"
dash

for tool in clang clang++ cmake git make; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf "✅ %-8s : %s\n" "$tool" "$(command -v "$tool")"
        ((OK++))
    else
        printf "⚠️ %-8s : não encontrado\n" "$tool"
        ((WARN++))
    fi
done

echo

# ============================================================
# DIAGNÓSTICO
# ============================================================

echo "🧠 DIAGNÓSTICO AUTOMÁTICO"
dash

if [ "$ERROR" -gt 0 ]; then
    echo "❌ Estado: existem erros que precisam ser corrigidos"
elif [ "$WARN" -gt 0 ]; then
    echo "⚠️ Estado: projeto funcional com avisos"
else
    echo "✅ Estado: nenhuma anomalia detectada"
fi

echo
echo "Código C/C++     : $CPP"
echo "Headers          : $HEADERS"
echo "Scripts          : $BASH"
echo "APK              : $APK_COUNT"
echo "Bibliotecas      : $SO_COUNT"
echo "Caches CMake     : $CACHE_COUNT"

echo

# ============================================================
# RESUMO
# ============================================================

line
echo "📊 RESUMO DO RELATÓRIO"
line

printf "%-18s : %s\n" "OK" "$OK"
printf "%-18s : %s\n" "Avisos" "$WARN"
printf "%-18s : %s\n" "Erros" "$ERROR"

line

if [ "$ERROR" -gt 0 ]; then
    echo "❌ PROJECT REPORT: ERROS DETECTADOS"
elif [ "$WARN" -gt 0 ]; then
    echo "⚠️ PROJECT REPORT: CONCLUÍDO COM AVISOS"
else
    echo "✅ PROJECT REPORT: PROJETO SAUDÁVEL"
fi

line
echo
echo "Pure3XEngine $VERSION"
echo "P3XE Project Report - Development / Alpha"
echo "Data : $DATE_NOW"
echo "Hora : $TIME_NOW"
echo
echo "Relatório salvo:"
echo "$REPORT"

} | tee "$REPORT"

echo
read -r -p "Pressione ENTER para voltar..."
