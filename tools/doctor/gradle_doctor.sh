#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"

OK=0
WARN=0
ERR=0

ok() {
    echo "✅ $1"
    OK=$((OK + 1))
}

warn() {
    echo "⚠ $1"
    WARN=$((WARN + 1))
}

err() {
    echo "❌ $1"
    ERR=$((ERR + 1))
}

line() {
    echo "------------------------------------------------------------"
}

check_project() {
    NAME="$1"
    DIR="$2"

    echo
    echo "📦 $NAME"
    line

    if [ ! -d "$DIR" ]; then
        err "Diretório não encontrado"
        return
    fi

    ok "Diretório encontrado"

    if [ -f "$DIR/gradlew" ]; then
        ok "Gradle Wrapper encontrado"

        if [ -x "$DIR/gradlew" ]; then
            ok "gradlew executável"
        else
            warn "gradlew sem permissão de execução"
        fi
    else
        warn "Gradle Wrapper não encontrado"
    fi

    if [ -f "$DIR/settings.gradle" ]; then
        ok "settings.gradle encontrado"
    elif [ -f "$DIR/settings.gradle.kts" ]; then
        ok "settings.gradle.kts encontrado"
    else
        warn "settings.gradle não encontrado"
    fi

    if [ -f "$DIR/build.gradle" ]; then
        ok "build.gradle raiz encontrado"
    elif [ -f "$DIR/build.gradle.kts" ]; then
        ok "build.gradle.kts raiz encontrado"
    else
        warn "build.gradle raiz não encontrado"
    fi

    if [ -f "$DIR/app/build.gradle" ]; then
        ok "app/build.gradle encontrado"
    elif [ -f "$DIR/app/build.gradle.kts" ]; then
        ok "app/build.gradle.kts encontrado"
    else
        warn "app/build.gradle não encontrado"
    fi

    if [ -f "$DIR/gradle/wrapper/gradle-wrapper.properties" ]; then
        ok "gradle-wrapper.properties encontrado"

        DIST=$(grep '^distributionUrl=' \
            "$DIR/gradle/wrapper/gradle-wrapper.properties" \
            2>/dev/null | tail -n 1)

        if [ -n "$DIST" ]; then
            echo "   $DIST"
        fi
    else
        warn "gradle-wrapper.properties não encontrado"
    fi

    if [ -f "$DIR/gradle.properties" ]; then
        ok "gradle.properties encontrado"
    else
        warn "gradle.properties não encontrado"
    fi

    if [ -f "$DIR/local.properties" ]; then
        ok "local.properties encontrado"
    else
        warn "local.properties não encontrado"
    fi
}

clear

echo "============================================================"
echo "🐘 P3XE - GRADLE DOCTOR"
echo "============================================================"
echo
echo "Root: $ROOT"

echo
echo "[ 1/6 ] JAVA"
line

if command -v java >/dev/null 2>&1; then
    ok "Java encontrado: $(command -v java)"
    java -version 2>&1 | head -n 3
else
    err "Java não encontrado"
fi

echo
echo "[ 2/6 ] GRADLE GLOBAL"
line

if command -v gradle >/dev/null 2>&1; then
    ok "Gradle encontrado: $(command -v gradle)"

    GRADLE_VERSION=$(
        gradle --version 2>/dev/null |
        awk '/^Gradle / {print $2; exit}'
    )

    [ -n "$GRADLE_VERSION" ] &&
        echo "Gradle global: $GRADLE_VERSION"
else
    warn "Gradle global não encontrado"
fi

echo
echo "[ 3/6 ] CUBO3D"
line

check_project \
    "Cubo3D" \
    "$ROOT/Cubo3D/android"

echo
echo "[ 4/6 ] COREEMULATOR"
line

check_project \
    "CoreEmulator" \
    "$ROOT/CoreEmulator/android"

echo
echo "[ 5/6 ] QEMU CENTER"
line

check_project \
    "QEMU Center" \
    "$ROOT/QEMUCenter"

echo
echo "[ 6/6 ] CAÇA A CONFLITOS"
line

echo "Configurações Gradle encontradas:"
echo

grep -RniE \
    --include="*.gradle" \
    --include="*.gradle.kts" \
    --include="gradle-wrapper.properties" \
    'gradle-[0-9]+\.[0-9]+|com.android.application|com.android.tools.build:gradle' \
    "$ROOT/Cubo3D/android" \
    "$ROOT/CoreEmulator/android" \
    "$ROOT/QEMUCenter" \
    2>/dev/null | head -n 80

echo

if grep -Rqi \
    --include="gradle-wrapper.properties" \
    'gradle-' \
    "$ROOT/Cubo3D/android" \
    "$ROOT/QEMUCenter" \
    2>/dev/null
then
    ok "Gradle Wrapper configurado nos projetos Android"
else
    warn "Nenhuma configuração de Wrapper detectada"
fi

echo
echo "============================================================"
echo "📊 RESULTADO GRADLE"
echo "============================================================"
echo
echo "✅ OK     : $OK"
echo "⚠ Avisos : $WARN"
echo "❌ Erros  : $ERR"
echo

if [ "$ERR" -gt 0 ]; then
    echo "❌ GRADLE: PROBLEMAS ENCONTRADOS"
elif [ "$WARN" -gt 0 ]; then
    echo "⚠ GRADLE: FUNCIONAL COM AVISOS"
else
    echo "✅ GRADLE: SAUDÁVEL"
fi

echo
read -r -p "Pressione ENTER para voltar..."
