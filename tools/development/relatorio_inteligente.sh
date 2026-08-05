#!/data/data/com.termux/files/usr/bin/bash

clear

# ============================================================
# Pure3XEngine - Relatório Inteligente
# P3XE Diagnostics Center
# ============================================================

ROOT="/data/data/com.termux/files/home/Pure3XEngine"
LOGS="$ROOT/logs"

mkdir -p "$LOGS"

ARQUIVO="$LOGS/relatorio_$(date +%Y%m%d_%H%M%S).txt"

linha() {
    echo "============================================================" | tee -a "$ARQUIVO"
}

secao() {
    echo "" | tee -a "$ARQUIVO"
    echo "$1" | tee -a "$ARQUIVO"
}

# ============================================================
# CABEÇALHO
# ============================================================

linha
echo "📊 RELATÓRIO INTELIGENTE - Pure3XEngine" | tee -a "$ARQUIVO"
linha

echo "Projeto : $ROOT" | tee -a "$ARQUIVO"
echo "Versão  : 0.2.6 Alpha" | tee -a "$ARQUIVO"
echo "Data    : $(date)" | tee -a "$ARQUIVO"

# ============================================================
# SISTEMA
# ============================================================

secao "🖥 SISTEMA"

echo "Arquitetura : $(uname -m)" | tee -a "$ARQUIVO"
echo "Kernel      : $(uname -r)" | tee -a "$ARQUIVO"
echo "Android     : $(getprop ro.build.version.release 2>/dev/null)" | tee -a "$ARQUIVO"
echo "API         : $(getprop ro.build.version.sdk 2>/dev/null)" | tee -a "$ARQUIVO"

# ============================================================
# FERRAMENTAS
# ============================================================

secao "🛠 FERRAMENTAS"

for CMD in git java javac cmake ninja clang clang++ gradle; do
    if command -v "$CMD" >/dev/null 2>&1; then
        echo "✅ $CMD" | tee -a "$ARQUIVO"
    else
        echo "❌ $CMD" | tee -a "$ARQUIVO"
    fi
done

# ============================================================
# SDK / NDK
# ============================================================

secao "📦 SDK / NDK"

SDK="$HOME/Android/Sdk"

if [ -d "$SDK" ]; then
    echo "✅ SDK encontrado" | tee -a "$ARQUIVO"
    echo "   $SDK" | tee -a "$ARQUIVO"
else
    echo "❌ SDK não encontrado" | tee -a "$ARQUIVO"
fi

NDK=""

# Primeiro procura NDK standalone
if [ -d "$HOME/android-ndk-r29" ]; then
    NDK="$HOME/android-ndk-r29"

# Depois procura dentro do SDK
elif [ -d "$SDK/ndk" ]; then
    NDK=$(find "$SDK/ndk" \
        -mindepth 1 -maxdepth 1 \
        -type d 2>/dev/null |
        sort -V |
        tail -n 1)
fi

if [ -n "$NDK" ] && [ -d "$NDK" ]; then
    echo "✅ NDK encontrado" | tee -a "$ARQUIVO"
    echo "   $NDK" | tee -a "$ARQUIVO"

    if [ -f "$NDK/source.properties" ]; then
        NDK_VERSION=$(grep "Pkg.Revision" \
            "$NDK/source.properties" |
            cut -d= -f2 |
            xargs)

        echo "   Versão: $NDK_VERSION" | tee -a "$ARQUIVO"
    fi
else
    echo "❌ NDK não encontrado" | tee -a "$ARQUIVO"
fi

# ============================================================
# PROJETOS
# ============================================================

secao "📁 PROJETOS"

PROJETOS=(
    "$ROOT"
    "$ROOT/Cubo3D"
    "$ROOT/CoreEmulator"
    "$ROOT/QEMUCenter"
)

for DIR in "${PROJETOS[@]}"; do
    if [ -d "$DIR" ]; then
        echo "✅ $(basename "$DIR")" | tee -a "$ARQUIVO"
    else
        echo "❌ $(basename "$DIR")" | tee -a "$ARQUIVO"
    fi
done

# ============================================================
# BIBLIOTECAS JNI ARM64-v8a
# ============================================================

secao "📚 BIBLIOTECAS JNI ARM64-v8a"

JNI_COUNT=0

while IFS= read -r SO; do
    [ -z "$SO" ] && continue

    echo "✅ $(basename "$SO")" | tee -a "$ARQUIVO"
    JNI_COUNT=$((JNI_COUNT + 1))

done < <(
    find "$ROOT" \
        -type f \
        -path "*/jniLibs/arm64-v8a/*.so" \
        2>/dev/null |
        sort -u
)

echo "" | tee -a "$ARQUIVO"
echo "Bibliotecas ARM64-v8a: $JNI_COUNT" | tee -a "$ARQUIVO"

# ============================================================
# ARQUIVOS IMPORTANTES
# ============================================================

secao "📄 ARQUIVOS IMPORTANTES"

FILES=(
    "$ROOT/CMakeLists.txt"
    "$ROOT/android/app/build.gradle"
    "$ROOT/android/build.gradle"
    "$ROOT/android/settings.gradle"
    "$ROOT/android/gradle.properties"
    "$ROOT/android/local.properties"
)

for FILE in "${FILES[@]}"; do
    if [ -f "$FILE" ]; then
        echo "✅ ${FILE#$ROOT/}" | tee -a "$ARQUIVO"
    else
        echo "❌ ${FILE#$ROOT/}" | tee -a "$ARQUIVO"
    fi
done

# ============================================================
# LOGS
# ============================================================

secao "📂 LOGS"

TOTAL=$(find "$LOGS" -type f 2>/dev/null | wc -l)

echo "Logs encontrados: $TOTAL" | tee -a "$ARQUIVO"

# ============================================================
# GIT / GITHUB
# ============================================================

secao "💾 GIT / GITHUB"

if git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    echo "✅ Repositório Git" | tee -a "$ARQUIVO"

    BRANCH=$(git -C "$ROOT" branch --show-current 2>/dev/null)
    REMOTE=$(git -C "$ROOT" remote get-url origin 2>/dev/null)
    COMMIT=$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null)
    COMMIT_MSG=$(git -C "$ROOT" log -1 --pretty=format:'%s' 2>/dev/null)

    [ -n "$BRANCH" ] &&
        echo "🌿 Branch : $BRANCH" | tee -a "$ARQUIVO"

    if [ -n "$REMOTE" ]; then
        echo "🔗 GitHub : $REMOTE" | tee -a "$ARQUIVO"
    else
        echo "⚠️ GitHub : origin não configurado" | tee -a "$ARQUIVO"
    fi

    if [ -n "$COMMIT" ]; then
        echo "📦 Commit : $COMMIT" | tee -a "$ARQUIVO"
        echo "   $COMMIT_MSG" | tee -a "$ARQUIVO"
    fi

    # --------------------------------------------------------
    # RESUMO DAS ALTERAÇÕES
    # Não despeja todos os CPP/H na tela
    # --------------------------------------------------------

    STATUS=$(git -C "$ROOT" status --porcelain 2>/dev/null)

    TOTAL_GIT=$(printf "%s\n" "$STATUS" |
        sed '/^$/d' |
        wc -l)

    MODIFICADOS=$(printf "%s\n" "$STATUS" |
        grep -cE '^ ?M|^M' || true)

    NOVOS=$(printf "%s\n" "$STATUS" |
        grep -cE '^\?\?|^A |^ A' || true)

    REMOVIDOS=$(printf "%s\n" "$STATUS" |
        grep -cE '^ ?D|^D' || true)

    echo "" | tee -a "$ARQUIVO"
    echo "📊 ESTADO DO PROJETO" | tee -a "$ARQUIVO"

    echo "   Modificados : $MODIFICADOS" | tee -a "$ARQUIVO"
    echo "   Novos       : $NOVOS"       | tee -a "$ARQUIVO"
    echo "   Removidos   : $REMOVIDOS"   | tee -a "$ARQUIVO"
    echo "   Total       : $TOTAL_GIT"   | tee -a "$ARQUIVO"

    if [ "$TOTAL_GIT" -eq 0 ]; then
        echo "" | tee -a "$ARQUIVO"
        echo "✅ Árvore Git limpa" | tee -a "$ARQUIVO"
    else
        echo "" | tee -a "$ARQUIVO"
        echo "⚠️ Projeto possui alterações locais" | tee -a "$ARQUIVO"
        echo "   Arquivos individuais ocultados neste relatório." |
            tee -a "$ARQUIVO"
    fi

else
    echo "❌ Repositório Git não encontrado" | tee -a "$ARQUIVO"
fi

# ============================================================
# FINAL
# ============================================================

echo "" | tee -a "$ARQUIVO"

linha
echo "✅ Relatório finalizado." | tee -a "$ARQUIVO"
echo "Pure3XEngine 0.2.6 Alpha" | tee -a "$ARQUIVO"
echo "P3XE Diagnostics Center" | tee -a "$ARQUIVO"
echo "Arquivo: $ARQUIVO" | tee -a "$ARQUIVO"
linha

echo
read -r -p "Pressione ENTER para voltar..."
