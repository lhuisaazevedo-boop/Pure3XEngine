#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# Utilities Center
# Módulo 12 - Reiniciar / Reparar Ambiente
#
# Cubo3D + CoreEmulator + QEMU Center + NDK + SDK
# ALTERA SOMENTE COM CONFIRMAÇÃO S/N
# ============================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# ============================================================
# INTERFACE
# ============================================================

linha() {
    echo "============================================================"
}

sublinha() {
    echo "------------------------------------------------------------"
}

pausa() {
    echo
    linha
    echo "Pressione ENTER para voltar..."
    linha
    read -r < /dev/tty
}

cabecalho() {
    clear
    linha
    echo "♻️ REINICIAR / REPARAR AMBIENTE"
    echo "Pure3XEngine 0.2.6 Alpha"
    linha
    echo
    echo "Projeto : $ROOT_DIR"
    echo "Modo    : REPARO CONTROLADO"
    echo
}

# ============================================================
# BACKUP
# ============================================================

criar_backup() {

    local ARQUIVO="$1"

    if [ ! -f "$ARQUIVO" ]; then
        echo "❌ Arquivo não existe:"
        echo "$ARQUIVO"
        return 1
    fi

    local BACKUP="${ARQUIVO}.p3xe.bak"

    if [ -f "$BACKUP" ]; then
        echo "ℹ️ Backup já existe:"
        echo "${BACKUP#$ROOT_DIR/}"
        return 0
    fi

    cp -p "$ARQUIVO" "$BACKUP"

    if [ $? -eq 0 ]; then
        echo "✅ Backup criado:"
        echo "${BACKUP#$ROOT_DIR/}"
        return 0
    fi

    echo "❌ Falha ao criar backup."
    return 1
}

# ============================================================
# MOSTRAR LINHA SUSPEITA
# ============================================================

mostrar_problema() {

    local ARQUIVO="$1"
    local NUMERO="$2"
    local CONTEUDO="$3"
    local MOTIVO="$4"

    echo
    echo "🚨 POSSÍVEL CONFIGURAÇÃO INCORRETA"
    sublinha
    echo
    echo "Arquivo:"
    echo "${ARQUIVO#$ROOT_DIR/}"
    echo
    echo "Linha:"
    echo "$NUMERO"
    echo
    echo "Conteúdo:"
    echo "$CONTEUDO"
    echo
    echo "Motivo:"
    echo "$MOTIVO"
    echo
}

# ============================================================
# REMOVER LINHA COM CONFIRMAÇÃO
# ============================================================

remover_linha() {

    local ARQUIVO="$1"
    local NUMERO="$2"

    echo
    read -r -p "Deseja remover ESTA linha? [S/N]: " RESPOSTA

    case "$RESPOSTA" in

        s|S|sim|SIM|Sim)

            criar_backup "$ARQUIVO" || return

            sed -i "${NUMERO}d" "$ARQUIVO"

            if [ $? -eq 0 ]; then
                echo
                echo "✅ Linha removida."
                echo "Backup preservado em:"
                echo "${ARQUIVO#$ROOT_DIR/}.p3xe.bak"
            else
                echo
                echo "❌ Não foi possível alterar o arquivo."
            fi
            ;;

        *)
            echo
            echo "⏭️ Linha preservada."
            ;;
    esac
}

# ============================================================
# ANALISAR C++ DE UM PROJETO
# ============================================================

analisar_cpp() {

    local NOME="$1"
    local DIR="$2"

    echo
    echo "🔎 Analisando CMake / C++..."
    echo

    if [ ! -d "$DIR" ]; then
        echo "❌ Diretório não encontrado:"
        echo "$DIR"
        return
    fi

    mapfile -t ARQUIVOS < <(
        find "$DIR" \
            -type f \
            \( \
                -name "CMakeLists.txt" \
                -o -name "*.cmake" \
                -o -name "build.gradle" \
                -o -name "build.gradle.kts" \
            \) \
            ! -path "*/build/*" \
            ! -path "*/.cxx/*" \
            ! -path "*/.gradle/*" \
            2>/dev/null |
        sort
    )

    echo "Arquivos encontrados: ${#ARQUIVOS[@]}"
    echo

    PROBLEMAS=0

    for ARQUIVO in "${ARQUIVOS[@]}"
    do

        # ----------------------------------------------------
        # C++11 / C++14 / C++17 / C++23 / C++26
        # ----------------------------------------------------

        while IFS=: read -r NUMERO CONTEUDO
        do
            [ -z "$NUMERO" ] && continue

            mostrar_problema \
                "$ARQUIVO" \
                "$NUMERO" \
                "$CONTEUDO" \
                "$NOME usa C++20. Esta configuração declara outro padrão C++."

            PROBLEMAS=$((PROBLEMAS + 1))

            remover_linha "$ARQUIVO" "$NUMERO"

        done < <(
            grep -En \
                'std=(c|gnu)\+\+(11|14|17|23|26)|CMAKE_CXX_STANDARD[[:space:]]+(11|14|17|23|26)' \
                "$ARQUIVO" \
                2>/dev/null
        )

        # ----------------------------------------------------
        # -fno-exceptions
        # ----------------------------------------------------

        while IFS=: read -r NUMERO CONTEUDO
        do
            [ -z "$NUMERO" ] && continue

            mostrar_problema \
                "$ARQUIVO" \
                "$NUMERO" \
                "$CONTEUDO" \
                "-fno-exceptions desativa exceções C++ e pode interferir no Core."

            PROBLEMAS=$((PROBLEMAS + 1))

            remover_linha "$ARQUIVO" "$NUMERO"

        done < <(
            grep -En \
                -- '-fno-exceptions' \
                "$ARQUIVO" \
                2>/dev/null
        )

        # ----------------------------------------------------
        # -fno-rtti
        # ----------------------------------------------------

        while IFS=: read -r NUMERO CONTEUDO
        do
            [ -z "$NUMERO" ] && continue

            mostrar_problema \
                "$ARQUIVO" \
                "$NUMERO" \
                "$CONTEUDO" \
                "-fno-rtti desativa RTTI e pode causar conflito no código C++."

            PROBLEMAS=$((PROBLEMAS + 1))

            remover_linha "$ARQUIVO" "$NUMERO"

        done < <(
            grep -En \
                -- '-fno-rtti' \
                "$ARQUIVO" \
                2>/dev/null
        )

    done

    echo
    sublinha

    if [ "$PROBLEMAS" -eq 0 ]; then
        echo "✅ Nenhuma flag C++ claramente conflitante encontrada."
    else
        echo "⚠️ Ocorrências analisadas: $PROBLEMAS"
    fi
}

# ============================================================
# MOSTRAR CONFIGURAÇÕES C++20
# ============================================================

mostrar_cpp20() {

    local DIR="$1"

    echo
    echo "📋 CONFIGURAÇÕES C++20 ATUAIS"
    sublinha
    echo

    grep -RIn \
        --exclude-dir=.git \
        --exclude-dir=build \
        --exclude-dir=.gradle \
        --exclude-dir=.cxx \
        --include='CMakeLists.txt' \
        --include='*.cmake' \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        -E \
        'CMAKE_CXX_STANDARD|std=(c|gnu)\+\+20|cppFlags' \
        "$DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
}

# ============================================================
# 1 - REPARAR CUBO3D
# ============================================================

reparar_cubo3d() {

    cabecalho

    echo "🧊 REPARAR CUBO3D"
    linha

    DIR="$ROOT_DIR/Cubo3D"

    if [ ! -d "$DIR" ]; then
        echo
        echo "❌ Cubo3D não encontrado."
        pausa
        return
    fi

    echo
    echo "Diretório:"
    echo "$DIR"

    mostrar_cpp20 "$DIR"
    analisar_cpp "Cubo3D" "$DIR"

    pausa
}

# ============================================================
# 2 - REPARAR CORE EMULATOR
# ============================================================

reparar_core() {

    cabecalho

    echo "🎮 REPARAR CORE EMULATOR"
    linha

    DIR="$ROOT_DIR/CoreEmulator"

    if [ ! -d "$DIR" ]; then
        echo
        echo "❌ CoreEmulator não encontrado."
        pausa
        return
    fi

    echo
    echo "Diretório:"
    echo "$DIR"

    mostrar_cpp20 "$DIR"
    analisar_cpp "CoreEmulator" "$DIR"

    pausa
}

# ============================================================
# 3 - REPARAR QEMU CENTER
# ============================================================

reparar_qemu() {

    cabecalho

    echo "🖥️ REPARAR QEMU CENTER"
    linha

    DIR="$ROOT_DIR/QEMUCenter"

    if [ ! -d "$DIR" ]; then
        echo
        echo "❌ QEMUCenter não encontrado."
        pausa
        return
    fi

    echo
    echo "Diretório:"
    echo "$DIR"

    mostrar_cpp20 "$DIR"
    analisar_cpp "QEMU Center" "$DIR"

    echo
    echo "🤖 CONFIGURAÇÕES NDK DO QEMU CENTER"
    sublinha
    echo

    grep -RIn \
        --exclude-dir=build \
        --exclude-dir=.gradle \
        --exclude-dir=.cxx \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        --include='local.properties' \
        -E \
        'ndkVersion|ndk.dir' \
        "$DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    pausa
}

# ============================================================
# 4 - REPARAR / VERIFICAR NDK
# ============================================================

reparar_ndk() {

    cabecalho

    echo "🤖 REPARAR / VERIFICAR NDK"
    linha
    echo

    NDK_REAL=""

    for candidato in \
        "$HOME/android-ndk-r29" \
        "$ANDROID_NDK_HOME" \
        "$ANDROID_NDK_ROOT" \
        "$NDK_HOME" \
        "$HOME/Android/Sdk/ndk/29.0.14206865" \
        "$HOME/Android/Sdk/ndk/29.0.13846066"
    do
        if [ -n "$candidato" ] &&
           [ -d "$candidato" ]; then

            NDK_REAL="$candidato"
            break
        fi
    done

    if [ -z "$NDK_REAL" ]; then
        echo "❌ NDK não encontrado."
        pausa
        return
    fi

    echo "✅ NDK encontrado"
    echo
    echo "Caminho:"
    echo "$NDK_REAL"
    echo

    if [ -f "$NDK_REAL/source.properties" ]; then

        NDK_REV="$(
            grep '^Pkg.Revision' \
                "$NDK_REAL/source.properties" \
                2>/dev/null |
            cut -d= -f2- |
            xargs
        )"

        echo "Versão:"
        echo "${NDK_REV:-N/D}"
    fi

    echo
    echo "🔎 NDK solicitado pelos projetos:"
    sublinha
    echo

    grep -RIn \
        --exclude-dir=.git \
        --exclude-dir=build \
        --exclude-dir=.gradle \
        --exclude-dir=.cxx \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        --include='local.properties' \
        -E \
        'ndkVersion|ndk.dir' \
        "$ROOT_DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
    echo "ℹ️ Esta opção apenas verifica o NDK."
    echo "Nenhum NDK será apagado automaticamente."

    pausa
}

# ============================================================
# 5 - REPARAR / VERIFICAR SDK
# ============================================================

reparar_sdk() {

    cabecalho

    echo "📦 REPARAR / VERIFICAR ANDROID SDK"
    linha
    echo

    SDK_REAL=""

    for candidato in \
        "$ANDROID_HOME" \
        "$ANDROID_SDK_ROOT" \
        "$HOME/Android/Sdk" \
        "$HOME/android-sdk"
    do
        if [ -n "$candidato" ] &&
           [ -d "$candidato" ]; then

            SDK_REAL="$candidato"
            break
        fi
    done

    if [ -n "$SDK_REAL" ]; then

        echo "✅ Android SDK encontrado"
        echo
        echo "Caminho:"
        echo "$SDK_REAL"

    else

        echo "⚠️ Android SDK não localizado pelas variáveis padrão."

    fi

    echo
    echo "🔎 sdk.dir encontrados:"
    sublinha
    echo

    SDK_CONFIG="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --include='local.properties' \
            -E \
            '^sdk\.dir=' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$SDK_CONFIG" ]; then

        echo "$SDK_CONFIG" |
            sed "s|$ROOT_DIR/||"

    else

        echo "Nenhum sdk.dir encontrado."

    fi

    echo
    echo "🔎 compileSdk / targetSdk / minSdk:"
    sublinha
    echo

    grep -RIn \
        --exclude-dir=.git \
        --exclude-dir=build \
        --exclude-dir=.gradle \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        -E \
        'compileSdk|targetSdk|minSdk' \
        "$ROOT_DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
    echo "ℹ️ Esta opção apenas verifica o SDK."
    echo "Nenhum SDK será apagado automaticamente."

    pausa
}

# ============================================================
# MENU PRINCIPAL
# ============================================================

while true
do

    cabecalho

    echo "1) 🧊 Reparar Cubo3D"
    echo "2) 🎮 Reparar CoreEmulator"
    echo "3) 🖥️ Reparar QEMU Center"
    echo "4) 🤖 Reparar / Verificar NDK"
    echo "5) 📦 Reparar / Verificar Android SDK"
    echo
    echo "0) ← Voltar"
    echo

    read -r -p "Escolha uma opção: " OPCAO

    case "$OPCAO" in

        1)
            reparar_cubo3d
            ;;

        2)
            reparar_core
            ;;

        3)
            reparar_qemu
            ;;

        4)
            reparar_ndk
            ;;

        5)
            reparar_sdk
            ;;

        0)
            exit 0
            ;;

        *)
            echo
            echo "Opção inválida."
            sleep 1
            ;;
    esac

done
