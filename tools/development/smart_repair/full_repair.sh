#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
REPAIR_DIR="$ROOT_DIR/tools/development/smart_repair"

clear

echo "=================================================="
echo "          🧠 P3XE - REPARO COMPLETO"
echo "=================================================="
echo
echo "Root: $ROOT_DIR"
echo
echo "Este modo executará todos os módulos do Smart Repair."
echo

OK=0
ERROS=0
AUSENTES=0
TOTAL=5

executar_modulo() {
    local NUM="$1"
    local NOME="$2"
    local SCRIPT="$3"

    echo
    echo "=================================================="
    echo "[ $NUM/$TOTAL ] $NOME"
    echo "=================================================="
    echo

    if [ ! -f "$SCRIPT" ]; then
        echo "❌ Módulo não encontrado:"
        echo "   $SCRIPT"
        ((AUSENTES++))
        ((ERROS++))
        return
    fi

    if ! bash -n "$SCRIPT"; then
        echo
        echo "❌ Erro de sintaxe em:"
        echo "   $SCRIPT"
        ((ERROS++))
        return
    fi

    chmod +x "$SCRIPT" 2>/dev/null

    # Remove as pausas dos módulos durante o reparo completo.
    #
    # O módulo recebe stdin de /dev/null. Assim um
    # read -p existente simplesmente continua sem
    # bloquear o reparo completo.

    bash "$SCRIPT" </dev/null
    STATUS=$?

    echo

    if [ "$STATUS" -eq 0 ]; then
        echo "✅ $NOME concluído"
        ((OK++))
    else
        echo "❌ $NOME retornou código $STATUS"
        ((ERROS++))
    fi
}

echo "Iniciando diagnóstico e reparação automática..."

executar_modulo \
    "1" \
    "Reparo de Permissões" \
    "$REPAIR_DIR/permissions.sh"

executar_modulo \
    "2" \
    "SDK / NDK Doctor" \
    "$REPAIR_DIR/sdk_ndk_doctor.sh"

executar_modulo \
    "3" \
    "Cache Cleaner" \
    "$REPAIR_DIR/cache_cleaner.sh"

executar_modulo \
    "4" \
    "Local.properties Repair" \
    "$REPAIR_DIR/local_properties.sh"

executar_modulo \
    "5" \
    "Gradle Doctor" \
    "$REPAIR_DIR/gradle_doctor.sh"

clear

echo "=================================================="
echo "       📊 P3XE - RELATÓRIO DO REPARO COMPLETO"
echo "=================================================="
echo
echo "Root    : $ROOT_DIR"
echo "Data    : $(date)"
echo
echo "Módulos previstos : $TOTAL"
echo "✅ Concluídos      : $OK"
echo "❌ Erros           : $ERROS"
echo "📂 Ausentes        : $AUSENTES"
echo

echo "--------------------------------------------------"
echo "Verificação rápida"
echo "--------------------------------------------------"
echo

# SDK
if [ -d "$HOME/Android/Sdk" ]; then
    echo "✅ Android SDK"
else
    echo "⚠ Android SDK"
fi

# NDK
if [ -d "$HOME/android-ndk-r29" ]; then
    echo "✅ Android NDK r29"
else
    echo "⚠ Android NDK r29"
fi

# Cubo3D
if [ -d "$ROOT_DIR/Cubo3D" ]; then
    echo "✅ Cubo3D"
else
    echo "⚠ Cubo3D"
fi

# CoreEmulator
if [ -d "$ROOT_DIR/CoreEmulator" ]; then
    echo "✅ CoreEmulator"
else
    echo "⚠ CoreEmulator"
fi

# QEMU
if [ -d "$ROOT_DIR/QEMUCenter" ]; then
    echo "✅ QEMU Center"
else
    echo "⚠ QEMU Center"
fi

echo

if [ "$ERROS" -eq 0 ]; then
    echo "=================================================="
    echo "       ✅ P3XE SMART REPAIR CONCLUÍDO"
    echo "=================================================="
    echo
    echo "Todos os módulos foram executados."
    echo "Ambiente principal pronto."
else
    echo "=================================================="
    echo "       ⚠ P3XE SMART REPAIR FINALIZADO"
    echo "=================================================="
    echo
    echo "Alguns módulos precisam de atenção."
fi

echo
read -p "Pressione ENTER para voltar..."
