#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

echo "=================================================="
echo "       📝 P3XE - LOCAL.PROPERTIES REPAIR"
echo "=================================================="
echo
echo "Root: $ROOT_DIR"
echo

OK=0
CORRIGIDOS=0
AVISOS=0
ERROS=0

# --------------------------------------------------
# 1. Detectar SDK
# --------------------------------------------------

echo "[ 1/4 ] Detectando Android SDK"
echo

SDK_DIR=""

for DIR in \
    "$HOME/Android/Sdk" \
    "$HOME/android-sdk" \
    "$ANDROID_SDK_ROOT" \
    "$ANDROID_HOME"
do
    if [ -n "$DIR" ] && [ -d "$DIR" ]; then
        SDK_DIR="$DIR"
        break
    fi
done

if [ -n "$SDK_DIR" ]; then
    echo "✅ SDK: $SDK_DIR"
    ((OK++))
else
    echo "❌ Android SDK não encontrado"
    ((ERROS++))
fi

echo

# --------------------------------------------------
# 2. Detectar NDK
# --------------------------------------------------

echo "[ 2/4 ] Detectando Android NDK"
echo

NDK_DIR=""

for DIR in \
    "$HOME/android-ndk-r29" \
    "$ANDROID_NDK_ROOT" \
    "$ANDROID_NDK_HOME"
do
    if [ -n "$DIR" ] && [ -d "$DIR" ]; then
        NDK_DIR="$DIR"
        break
    fi
done

if [ -n "$NDK_DIR" ]; then
    echo "✅ NDK: $NDK_DIR"

    if [ -f "$NDK_DIR/source.properties" ]; then
        NDK_VERSION=$(
            grep '^Pkg.Revision' "$NDK_DIR/source.properties" |
            cut -d= -f2- |
            xargs
        )

        [ -n "$NDK_VERSION" ] &&
            echo "   Versão: $NDK_VERSION"
    fi

    ((OK++))
else
    echo "❌ Android NDK não encontrado"
    ((ERROS++))
fi

echo

# --------------------------------------------------
# 3. Reparar projeto
# --------------------------------------------------

reparar_projeto() {

    local NOME="$1"
    local ANDROID_DIR="$2"
    local FILE="$ANDROID_DIR/local.properties"

    echo "📦 $NOME"

    if [ ! -d "$ANDROID_DIR" ]; then
        echo "   ➖ Projeto Android não encontrado"
        ((AVISOS++))
        echo
        return
    fi

    if [ -z "$SDK_DIR" ]; then
        echo "   ❌ SDK indisponível"
        ((ERROS++))
        echo
        return
    fi

    # Verifica se já está correto
    SDK_ATUAL=""
    NDK_ATUAL=""

    if [ -f "$FILE" ]; then
        SDK_ATUAL=$(grep '^sdk.dir=' "$FILE" | head -1 | cut -d= -f2-)
        NDK_ATUAL=$(grep '^ndk.dir=' "$FILE" | head -1 | cut -d= -f2-)
    fi

    if [ "$SDK_ATUAL" = "$SDK_DIR" ] &&
       { [ -z "$NDK_DIR" ] || [ "$NDK_ATUAL" = "$NDK_DIR" ]; }
    then
        echo "   ✅ local.properties já correto"
        ((OK++))
        echo
        return
    fi

    # Backup
    if [ -f "$FILE" ]; then
        cp "$FILE" "$FILE.p3xe-backup"

        if [ $? -eq 0 ]; then
            echo "   📋 Backup criado"
        else
            echo "   ❌ Falha ao criar backup"
            ((ERROS++))
            echo
            return
        fi
    fi

    # Cria novo arquivo
    {
        echo "# Gerado pelo P3XE Smart Repair"
        echo "# Não editar caminhos manualmente"
        echo
        echo "sdk.dir=$SDK_DIR"

        if [ -n "$NDK_DIR" ]; then
            echo "ndk.dir=$NDK_DIR"
        fi
    } > "$FILE"

    if [ $? -eq 0 ]; then
        echo "   🔧 local.properties reparado"
        echo "   SDK = $SDK_DIR"

        [ -n "$NDK_DIR" ] &&
            echo "   NDK = $NDK_DIR"

        ((CORRIGIDOS++))
    else
        echo "   ❌ Falha ao escrever local.properties"
        ((ERROS++))
    fi

    echo
}

echo "[ 3/4 ] Verificando projetos"
echo

reparar_projeto \
    "Cubo3D" \
    "$ROOT_DIR/Cubo3D/android"

reparar_projeto \
    "CoreEmulator" \
    "$ROOT_DIR/CoreEmulator/android"

reparar_projeto \
    "QEMU Center" \
    "$ROOT_DIR/QEMUCenter"

# --------------------------------------------------
# 4. Resultado
# --------------------------------------------------

echo "[ 4/4 ] Verificação final"
echo
echo "=================================================="
echo "                   📊 RESULTADO"
echo "=================================================="
echo
echo "✅ Corretos    : $OK"
echo "🔧 Reparados   : $CORRIGIDOS"
echo "⚠ Avisos       : $AVISOS"
echo "❌ Erros       : $ERROS"
echo

if [ "$ERROS" -eq 0 ]; then
    echo "✅ Configuração Android pronta."
else
    echo "❌ Existem problemas no ambiente Android."
fi

echo
echo "SDK : ${SDK_DIR:-NÃO ENCONTRADO}"
echo "NDK : ${NDK_DIR:-NÃO ENCONTRADO}"

echo
read -p "Pressione ENTER para voltar..."
