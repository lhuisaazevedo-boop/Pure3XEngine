#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"

clear

echo "============================================================"
echo "↪ P3XE SMART REPAIR - GRADLE"
echo "============================================================"
echo
echo "Root: $ROOT"
echo

OK=0
WARN=0
ERROR=0

check_project() {
    local NAME="$1"
    local DIR="$2"

    echo
    echo "------------------------------------------------------------"
    echo "📦 $NAME"
    echo "------------------------------------------------------------"

    if [ ! -d "$DIR" ]; then
        echo "❌ Diretório não encontrado: $DIR"
        ERROR=$((ERROR + 1))
        return
    fi

    echo "✅ Diretório encontrado"
    OK=$((OK + 1))

    # Procura o diretório Android real
    local ANDROID_DIR="$DIR"

    if [ -d "$DIR/android" ]; then
        ANDROID_DIR="$DIR/android"
    fi

    echo "📁 Gradle root: $ANDROID_DIR"

    # gradlew
    if [ -f "$ANDROID_DIR/gradlew" ]; then
        chmod +x "$ANDROID_DIR/gradlew" 2>/dev/null

        if [ -x "$ANDROID_DIR/gradlew" ]; then
            echo "✅ gradlew executável"
            OK=$((OK + 1))
        else
            echo "⚠ Não foi possível tornar gradlew executável"
            WARN=$((WARN + 1))
        fi
    else
        echo "⚠ gradlew não encontrado"
        WARN=$((WARN + 1))
    fi

    # settings.gradle
    if [ -f "$ANDROID_DIR/settings.gradle" ] || \
       [ -f "$ANDROID_DIR/settings.gradle.kts" ]; then
        echo "✅ settings.gradle encontrado"
        OK=$((OK + 1))
    else
        echo "⚠ settings.gradle não encontrado"
        WARN=$((WARN + 1))
    fi

    # build.gradle raiz
    if [ -f "$ANDROID_DIR/build.gradle" ] || \
       [ -f "$ANDROID_DIR/build.gradle.kts" ]; then
        echo "✅ build.gradle raiz encontrado"
        OK=$((OK + 1))
    else
        echo "⚠ build.gradle raiz não encontrado"
        WARN=$((WARN + 1))
    fi

    # app/build.gradle
    if [ -f "$ANDROID_DIR/app/build.gradle" ] || \
       [ -f "$ANDROID_DIR/app/build.gradle.kts" ]; then
        echo "✅ app/build.gradle encontrado"
        OK=$((OK + 1))
    else
        echo "⚠ app/build.gradle não encontrado"
        WARN=$((WARN + 1))
    fi

    # Wrapper
    WRAPPER="$ANDROID_DIR/gradle/wrapper/gradle-wrapper.properties"

    if [ -f "$WRAPPER" ]; then
        echo "✅ gradle-wrapper.properties encontrado"
        OK=$((OK + 1))

        DIST=$(grep '^distributionUrl=' "$WRAPPER" 2>/dev/null | head -n1)

        if [ -n "$DIST" ]; then
            echo "   $DIST"
        fi
    else
        echo "⚠ gradle-wrapper.properties não encontrado"
        WARN=$((WARN + 1))
    fi

    # local.properties
    if [ -f "$ANDROID_DIR/local.properties" ]; then
        echo "✅ local.properties encontrado"
        OK=$((OK + 1))
    elif [ -f "$DIR/local.properties" ]; then
        echo "✅ local.properties encontrado na raiz do projeto"
        OK=$((OK + 1))
    else
        echo "⚠ local.properties não encontrado"
        WARN=$((WARN + 1))
    fi

    # Remove caches somente do projeto
    echo
    echo "🧹 Limpando caches locais..."

    if [ -d "$ANDROID_DIR/.gradle" ]; then
        rm -rf "$ANDROID_DIR/.gradle"

        if [ ! -d "$ANDROID_DIR/.gradle" ]; then
            echo "✅ .gradle removido"
            OK=$((OK + 1))
        else
            echo "❌ Falha removendo .gradle"
            ERROR=$((ERROR + 1))
        fi
    else
        echo "✅ .gradle já estava limpo"
        OK=$((OK + 1))
    fi

    if [ -d "$ANDROID_DIR/app/build" ]; then
        rm -rf "$ANDROID_DIR/app/build"
        echo "✅ app/build removido"
        OK=$((OK + 1))
    else
        echo "✅ app/build já estava limpo"
        OK=$((OK + 1))
    fi

    if [ -d "$ANDROID_DIR/build" ]; then
        rm -rf "$ANDROID_DIR/build"
        echo "✅ build removido"
        OK=$((OK + 1))
    else
        echo "✅ build já estava limpo"
        OK=$((OK + 1))
    fi
}

echo "[ 1/4 ] GRADLE GLOBAL"
echo "------------------------------------------------------------"

if command -v gradle >/dev/null 2>&1; then
    echo "✅ Gradle: $(command -v gradle)"
    gradle --version 2>/dev/null | grep -m1 '^Gradle '
    OK=$((OK + 1))
else
    echo "⚠ Gradle global não encontrado"
    WARN=$((WARN + 1))
fi

echo
echo "[ 2/4 ] CUBO3D"
check_project "Cubo3D" "$ROOT/Cubo3D"

echo
echo "[ 3/4 ] COREEMULATOR"
check_project "CoreEmulator" "$ROOT/CoreEmulator"

echo
echo "[ 4/4 ] QEMU CENTER"
check_project "QEMU Center" "$ROOT/QEMUCenter"

echo
echo "============================================================"
echo "📊 RESULTADO SMART REPAIR - GRADLE"
echo "============================================================"
echo
echo "✅ OK     : $OK"
echo "⚠ Avisos : $WARN"
echo "❌ Erros  : $ERROR"
echo

if [ "$ERROR" -eq 0 ]; then
    echo "✅ Reparo Gradle concluído."
else
    echo "❌ Reparo Gradle encontrou problemas."
fi

echo
echo "🔒 Código-fonte preservado."
echo "🔒 Android SDK / NDK preservados."
echo "🔒 Gradle Wrapper preservado."
echo "🔒 local.properties preservado."
echo

read -r -p "Pressione ENTER para voltar..."
