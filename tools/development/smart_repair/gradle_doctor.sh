#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

echo "=================================================="
echo "          🔄 P3XE - GRADLE DOCTOR"
echo "=================================================="
echo
echo "Root: $ROOT_DIR"
echo

OK=0
AVISOS=0
ERROS=0
CORRIGIDOS=0

verificar_gradle() {

    local NOME="$1"
    local DIR="$2"

    echo "📦 $NOME"
    echo "   Diretório: $DIR"

    if [ ! -d "$DIR" ]; then
        echo "   ⚠ Projeto não encontrado"
        ((AVISOS++))
        echo
        return
    fi

    # ----------------------------------------------
    # gradlew
    # ----------------------------------------------

    if [ -f "$DIR/gradlew" ]; then

        if [ ! -x "$DIR/gradlew" ]; then
            chmod +x "$DIR/gradlew"

            if [ -x "$DIR/gradlew" ]; then
                echo "   🔧 permissão gradlew corrigida"
                ((CORRIGIDOS++))
            else
                echo "   ❌ não foi possível corrigir gradlew"
                ((ERROS++))
            fi
        else
            echo "   ✅ gradlew executável"
            ((OK++))
        fi

    else
        echo "   ⚠ gradlew não encontrado"
        ((AVISOS++))
    fi

    # ----------------------------------------------
    # build.gradle / build.gradle.kts
    # ----------------------------------------------

    if [ -f "$DIR/build.gradle" ]; then
        echo "   ✅ build.gradle"
        ((OK++))
    elif [ -f "$DIR/build.gradle.kts" ]; then
        echo "   ✅ build.gradle.kts"
        ((OK++))
    else
        echo "   ⚠ build.gradle não encontrado"
        ((AVISOS++))
    fi

    # ----------------------------------------------
    # settings.gradle
    # ----------------------------------------------

    if [ -f "$DIR/settings.gradle" ]; then
        echo "   ✅ settings.gradle"
        ((OK++))
    elif [ -f "$DIR/settings.gradle.kts" ]; then
        echo "   ✅ settings.gradle.kts"
        ((OK++))
    else
        echo "   ⚠ settings.gradle não encontrado"
        ((AVISOS++))
    fi

    # ----------------------------------------------
    # Gradle Wrapper JAR
    # ----------------------------------------------

    WRAPPER_JAR="$DIR/gradle/wrapper/gradle-wrapper.jar"

    if [ -f "$WRAPPER_JAR" ]; then
        echo "   ✅ gradle-wrapper.jar"
        ((OK++))
    else
        echo "   ⚠ gradle-wrapper.jar ausente"
        ((AVISOS++))
    fi

    # ----------------------------------------------
    # Wrapper properties
    # ----------------------------------------------

    WRAPPER_PROP="$DIR/gradle/wrapper/gradle-wrapper.properties"

    if [ -f "$WRAPPER_PROP" ]; then

        echo "   ✅ gradle-wrapper.properties"
        ((OK++))

        DIST=$(
            grep '^distributionUrl=' "$WRAPPER_PROP" |
            head -1 |
            cut -d= -f2-
        )

        if [ -n "$DIST" ]; then
            VERSION=$(
                echo "$DIST" |
                sed -n 's/.*gradle-\([0-9][0-9.]*\)-.*/\1/p'
            )

            if [ -n "$VERSION" ]; then
                echo "      Gradle Wrapper: $VERSION"
            fi
        fi

    else
        echo "   ⚠ gradle-wrapper.properties ausente"
        ((AVISOS++))
    fi

    # ----------------------------------------------
    # Teste real do wrapper
    # ----------------------------------------------

    if [ -x "$DIR/gradlew" ]; then

        echo
        echo "   Testando Gradle Wrapper..."

        RESULTADO=$(
            cd "$DIR" &&
            ./gradlew --version --no-daemon 2>&1
        )

        STATUS=$?

        if [ "$STATUS" -eq 0 ]; then

            GRADLE_VERSION=$(
                printf '%s\n' "$RESULTADO" |
                grep '^Gradle ' |
                head -1
            )

            echo "   ✅ Wrapper funcionando"

            [ -n "$GRADLE_VERSION" ] &&
                echo "      $GRADLE_VERSION"

            ((OK++))

        else
            echo "   ❌ Wrapper retornou erro"
            ((ERROS++))

            printf '%s\n' "$RESULTADO" |
                tail -5 |
                sed 's/^/      /'
        fi

    fi

    echo
}

echo "[ 1/4 ] Gradle do sistema"
echo

if command -v gradle >/dev/null 2>&1; then
    echo "✅ gradle: $(command -v gradle)"

    gradle --version 2>/dev/null |
        grep '^Gradle ' |
        head -1

    ((OK++))
else
    echo "⚠ Gradle global não encontrado"
    echo "  O Gradle Wrapper ainda pode funcionar normalmente."
    ((AVISOS++))
fi

echo
echo "[ 2/4 ] Cubo3D"
echo

verificar_gradle \
    "Cubo3D Android" \
    "$ROOT_DIR/Cubo3D/android"

echo "[ 3/4 ] CoreEmulator"
echo

verificar_gradle \
    "CoreEmulator Android" \
    "$ROOT_DIR/CoreEmulator/android"

echo "[ 4/4 ] QEMU Center"
echo

verificar_gradle \
    "QEMU Center" \
    "$ROOT_DIR/QEMUCenter"

echo "=================================================="
echo "                   📊 RESULTADO"
echo "=================================================="
echo
echo "✅ OK          : $OK"
echo "🔧 Corrigidos  : $CORRIGIDOS"
echo "⚠ Avisos       : $AVISOS"
echo "❌ Erros       : $ERROS"
echo

if [ "$ERROS" -eq 0 ]; then
    echo "✅ Gradle principal operacional."
else
    echo "❌ Foram encontrados problemas no Gradle."
fi

echo
read -p "Pressione ENTER para voltar..."
