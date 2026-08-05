#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"

OK=0
WARN=0
ERROR=0

check_ok() {
    echo "✅ $1"
    ((OK++))
}

check_warn() {
    echo "⚠ $1"
    ((WARN++))
}

check_error() {
    echo "❌ $1"
    ((ERROR++))
}

clear

echo "============================================================"
echo "🩺 P3XE - DOCTOR INTELIGENTE"
echo "============================================================"
echo
echo "Root: $ROOT"
echo

echo "[ 1/6 ] SISTEMA"
echo "------------------------------------------------------------"

echo "Arquitetura : $(uname -m)"
echo "Kernel      : $(uname -r)"
echo "Android API : $(getprop ro.build.version.sdk)"
echo "Android     : $(getprop ro.build.version.release)"
echo

echo "[ 2/6 ] ESTRUTURA P3XE"
echo "------------------------------------------------------------"

for DIR in \
    "$ROOT/Cubo3D" \
    "$ROOT/CoreEmulator" \
    "$ROOT/QEMUCenter" \
    "$ROOT/tools" \
    "$ROOT/logs"
do
    if [ -d "$DIR" ]; then
        check_ok "$(basename "$DIR")"
    else
        check_error "$(basename "$DIR") não encontrado"
    fi
done

echo
echo "[ 3/6 ] FERRAMENTAS"
echo "------------------------------------------------------------"

for TOOL in java gradle cmake ninja clang clang++; do
    if command -v "$TOOL" >/dev/null 2>&1; then
        check_ok "$TOOL: $(command -v "$TOOL")"
    else
        check_error "$TOOL não encontrado"
    fi
done

echo
echo "[ 4/6 ] ANDROID SDK / NDK"
echo "------------------------------------------------------------"

SDK="$HOME/Android/Sdk"
NDK="$HOME/android-ndk-r29"

if [ -d "$SDK" ]; then
    check_ok "Android SDK: $SDK"
else
    check_error "Android SDK não encontrado"
fi

if [ -d "$NDK" ]; then
    check_ok "Android NDK: $NDK"

    if [ -f "$NDK/source.properties" ]; then
        NDK_VERSION=$(grep "Pkg.Revision" "$NDK/source.properties" | cut -d= -f2 | xargs)
        echo "   Versão NDK: $NDK_VERSION"
    fi
else
    check_error "Android NDK não encontrado"
fi

echo
echo "[ 5/6 ] PROJETOS ANDROID"
echo "------------------------------------------------------------"

check_project() {
    NAME="$1"
    DIR="$2"

    echo
    echo "📦 $NAME"

    if [ ! -d "$DIR" ]; then
        check_error "Diretório não encontrado: $DIR"
        return
    fi

    check_ok "Diretório encontrado"

    if [ -f "$DIR/gradlew" ]; then
        check_ok "Gradle Wrapper encontrado"
    else
        check_warn "Gradle Wrapper não encontrado"
    fi

    if [ -f "$DIR/build.gradle" ] || [ -f "$DIR/build.gradle.kts" ]; then
        check_ok "Build Gradle encontrado"
    else
        check_warn "Build Gradle não encontrado"
    fi

    if [ -f "$DIR/local.properties" ]; then
        check_ok "local.properties encontrado"

        NDK_DIR=$(grep '^ndk.dir=' "$DIR/local.properties" 2>/dev/null | cut -d= -f2-)

        if [ -n "$NDK_DIR" ]; then
            echo "   ndk.dir: $NDK_DIR"
        fi
    else
        check_warn "local.properties não encontrado"
    fi
}

check_project "Cubo3D" "$ROOT/Cubo3D/android"
check_project "CoreEmulator" "$ROOT/CoreEmulator/android"
check_project "QEMU Center" "$ROOT/QEMUCenter"

echo
echo "[ 6/6 ] ANÁLISE INTELIGENTE"
echo "------------------------------------------------------------"

QEMU_LOCAL="$ROOT/QEMUCenter/local.properties"

if [ -f "$QEMU_LOCAL" ]; then

    QEMU_NDK=$(grep '^ndk.dir=' "$QEMU_LOCAL" 2>/dev/null | cut -d= -f2-)

    if [ -n "$QEMU_NDK" ]; then
        if [[ "$QEMU_NDK" == *"android-ndk-r29"* ]]; then
            check_ok "QEMU Center usa NDK r29 em local.properties"
        else
            check_warn "QEMU Center aponta para outro NDK: $QEMU_NDK"
        fi
    fi
fi

if grep -Rqs 'ndkVersion.*27\.0\.12077973' \
    "$ROOT/QEMUCenter" \
    --include='*.gradle' \
    --include='*.gradle.kts' 2>/dev/null
then
    check_error "QEMU Center ainda exige NDK 27.0.12077973"
    echo "   Detectado conflito conhecido:"
    echo "   Instalado : NDK r29 / 29.0.14206865"
    echo "   Projeto   : NDK 27.0.12077973"
else
    check_ok "Nenhum conflito conhecido de ndkVersion detectado"
fi

echo
echo "============================================================"
echo "📊 RESULTADO DO DOCTOR"
echo "============================================================"
echo
echo "✅ OK     : $OK"
echo "⚠ Avisos : $WARN"
echo "❌ Erros  : $ERROR"
echo

if [ "$ERROR" -eq 0 ]; then
    echo "✅ Estado geral: SAUDÁVEL"
elif [ "$ERROR" -le 2 ]; then
    echo "⚠ Estado geral: ATENÇÃO"
else
    echo "❌ Estado geral: PROBLEMAS ENCONTRADOS"
fi

echo
read -r -p "Pressione ENTER para voltar..."
