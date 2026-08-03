#!/data/data/com.termux/files/usr/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

mkdir -p "$PROJETO_ROOT/logs"

LOG="$PROJETO_ROOT/logs/build_$(date +%Y%m%d_%H%M%S).log"

echo
echo "======================================================"
echo "🚀 INICIANDO BUILD P3XE"
echo "======================================================"
echo "Data       : $(date)"
echo "Arquitetura: $(uname -m)"
echo "Projeto    : $PROJETO_ROOT"
echo "Log        : $LOG"
echo "======================================================"

# Procura automaticamente o Android
if [ -f "$PROJETO_ROOT/android/gradlew" ]; then
    ANDROID="$PROJETO_ROOT/android"

elif [ -f "$PROJETO_ROOT/Cubo3D/android/gradlew" ]; then
    ANDROID="$PROJETO_ROOT/Cubo3D/android"

elif [ -f "$PROJETO_ROOT/CoreEmuletoin/android/gradlew" ]; then
    ANDROID="$PROJETO_ROOT/CoreEmuletoin/android"

else
    echo
    echo "❌ Nenhum projeto Android encontrado."
    exit 1
fi

echo "Android : $ANDROID"
echo

cd "$ANDROID"

chmod +x gradlew

./gradlew clean assembleDebug --stacktrace --info 2>&1 | tee "$LOG"

STATUS=${PIPESTATUS[0]}

echo
echo "======================================================"

if [ "$STATUS" -eq 0 ]; then

    echo "✅ BUILD CONCLUÍDA COM SUCESSO!"
    echo
    echo "APK:"
    find . -name "*.apk"

    echo
    echo "Log salvo em:"
    echo "$LOG"

else

    echo "❌ BUILD FALHOU!"
    echo
    echo "Resumo dos erros:"
    grep -Ei "error:|failed|exception|unknown" "$LOG" | head -20

    echo
    echo "Log completo:"
    echo "$LOG"

fi

echo "======================================================"

read -p "Pressione ENTER para continuar..."
