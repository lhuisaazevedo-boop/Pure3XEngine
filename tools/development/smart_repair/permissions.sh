#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

echo "=================================================="
echo "       🔐 P3XE - REPARO DE PERMISSÕES"
echo "=================================================="
echo
echo "Root: $ROOT_DIR"
echo

CORRIGIDOS=0
OK=0
ERROS=0

echo "[ 1/4 ] Scripts P3XE"

while IFS= read -r -d '' ARQ
do
    if [ -x "$ARQ" ]; then
        ((OK++))
    else
        if chmod +x "$ARQ" 2>/dev/null; then
            echo "🔧 Corrigido: ${ARQ#$ROOT_DIR/}"
            ((CORRIGIDOS++))
        else
            echo "❌ Falha: ${ARQ#$ROOT_DIR/}"
            ((ERROS++))
        fi
    fi
done < <(find "$ROOT_DIR/tools" -type f -name "*.sh" -print0 2>/dev/null)

echo
echo "[ 2/4 ] P3XE.sh"

if [ -f "$ROOT_DIR/P3XE.sh" ]; then
    if [ -x "$ROOT_DIR/P3XE.sh" ]; then
        echo "✅ P3XE.sh: OK"
        ((OK++))
    elif chmod +x "$ROOT_DIR/P3XE.sh"; then
        echo "🔧 P3XE.sh corrigido"
        ((CORRIGIDOS++))
    else
        echo "❌ Não foi possível corrigir P3XE.sh"
        ((ERROS++))
    fi
else
    echo "⚠ P3XE.sh não encontrado"
fi

echo
echo "[ 3/4 ] Gradle Wrapper"

while IFS= read -r -d '' GRADLEW
do
    NOME="${GRADLEW#$ROOT_DIR/}"

    if [ -x "$GRADLEW" ]; then
        echo "✅ $NOME"
        ((OK++))
    elif chmod +x "$GRADLEW"; then
        echo "🔧 Corrigido: $NOME"
        ((CORRIGIDOS++))
    else
        echo "❌ Falha: $NOME"
        ((ERROS++))
    fi
done < <(find "$ROOT_DIR" -type f -name "gradlew" -print0 2>/dev/null)

echo
echo "[ 4/4 ] Verificação final"

echo
echo "=================================================="
echo "              📊 RESULTADO"
echo "=================================================="
echo "✅ Já estavam corretos : $OK"
echo "🔧 Corrigidos           : $CORRIGIDOS"
echo "❌ Erros                : $ERROS"
echo

if [ "$ERROS" -eq 0 ]; then
    echo "✅ Permissões do P3XE verificadas."
else
    echo "⚠ Existem permissões que precisam de análise."
fi

echo
read -p "Pressione ENTER para voltar..."
