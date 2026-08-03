#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# P3XE BUILD COMPLETO
# Pure3XEngenie Android + Cubo3D + CoreEmuletoin
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

clear

echo
echo "======================================================"
echo "📦 BUILD COMPLETO — PURE3XENGENIE ANDROID"
echo "======================================================"
echo "Projeto : $PROJETO_ROOT"
echo

COMPILADOS=0
ERROS=0

build_projeto() {

    NOME="$1"
    PASTA="$2"

    echo "🔨 Compilando $NOME..."

    if [ ! -d "$PASTA" ]; then
        echo "❌ Pasta não encontrada:"
        echo "   $PASTA"
        ERROS=$((ERROS+1))
        echo
        return
    fi

    cd "$PASTA" || {
        echo "❌ Não foi possível entrar em $PASTA"
        ERROS=$((ERROS+1))
        return
    }

    if [ ! -f "./gradlew" ]; then
        echo "❌ gradlew não encontrado."
        ERROS=$((ERROS+1))
        cd "$PROJETO_ROOT"
        echo
        return
    fi

    chmod +x ./gradlew

    if ./gradlew clean assembleDebug; then
        echo "✅ $NOME compilado com sucesso."
        COMPILADOS=$((COMPILADOS+1))
    else
        echo "❌ Erro na compilação de $NOME."
        ERROS=$((ERROS+1))
    fi

    cd "$PROJETO_ROOT"
    echo
}

# ==========================================================
# BUILD DOS PROJETOS
# ==========================================================

build_projeto "Pure3XEngenie Android" "$PROJETO_ROOT/android"

build_projeto "Cubo3D Android" "$PROJETO_ROOT/Cubo3D/android"

build_projeto "CoreEmuletoin Android" "$PROJETO_ROOT/CoreEmuletoin/android"

echo "======================================================"
echo "RESUMO"
echo "======================================================"
echo "Projetos compilados : $COMPILADOS"
echo "Erros encontrados   : $ERROS"
echo "======================================================"

if [ "$ERROS" -eq 0 ]; then
    echo "✅ BUILD COMPLETO FINALIZADO COM SUCESSO!"
else
    echo "⚠ BUILD FINALIZADO COM ALGUNS ERROS."
fi

echo
read -p "Pressione ENTER para continuar..."
