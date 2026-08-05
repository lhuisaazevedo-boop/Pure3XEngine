#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# Utilities Center
# Módulo 11 - Informações / Diagnóstico do Projeto
#
# SOMENTE LEITURA
# ============================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

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
    echo "📂 INFORMAÇÕES DO PROJETO"
    echo "Pure3XEngine 0.2.6 Alpha"
    linha
    echo
    echo "Projeto : $ROOT_DIR"
    echo "Modo    : SOMENTE LEITURA"
    echo
}

# ============================================================
# 1 - CUBO3D
# ============================================================

cubo3d() {

    cabecalho

    echo "🧊 CUBO3D"
    linha
    echo

    DIR="$ROOT_DIR/Cubo3D"

    if [ ! -d "$DIR" ]; then
        echo "❌ Cubo3D não encontrado."
        pausa
        return
    fi

    echo "Diretório : $DIR"
    echo

    echo "📄 CMakeLists.txt:"
    find "$DIR" \
        -type f \
        -name "CMakeLists.txt" \
        ! -path "*/build/*" \
        ! -path "*/.cxx/*" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
    echo "🐘 Gradle:"
    find "$DIR" \
        -type f \
        \( -name "build.gradle" -o -name "build.gradle.kts" \) \
        ! -path "*/build/*" \
        ! -path "*/.gradle/*" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
    echo "🚩 Configurações C++ / NDK:"
    echo

    grep -RIn \
        --exclude-dir=build \
        --exclude-dir=.cxx \
        --exclude-dir=.gradle \
        --include='CMakeLists.txt' \
        --include='*.cmake' \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        -E \
        'CMAKE_CXX_STANDARD|CMAKE_CXX_FLAGS|cppFlags|ndkVersion|ANDROID_NDK|ANDROID_STL|std=(c|gnu)\+\+' \
        "$DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    pausa
}

# ============================================================
# 2 - CORE EMULATOR
# ============================================================

core_emulator() {

    cabecalho

    echo "🎮 CORE EMULATOR"
    linha
    echo

    DIR="$ROOT_DIR/CoreEmulator"

    if [ ! -d "$DIR" ]; then
        echo "❌ CoreEmulator não encontrado."
        pausa
        return
    fi

    echo "Diretório : $DIR"
    echo

    PPU="$(
        find "$DIR" -type f \
            \( -iname '*ppu*' -o -iname '*powerpc*' -o -iname '*ppc*' \) \
            2>/dev/null |
        wc -l
    )"

    SPU="$(
        find "$DIR" -type f \
            -iname '*spu*' \
            2>/dev/null |
        wc -l
    )"

    CELL="$(
        find "$DIR" -type f \
            -iname '*cell*' \
            2>/dev/null |
        wc -l
    )"

    MEMORY="$(
        find "$DIR" -type f \
            -iname '*memory*' \
            2>/dev/null |
        wc -l
    )"

    printf "%-20s : %s\n" "PPU / PowerPC" "$PPU"
    printf "%-20s : %s\n" "SPU" "$SPU"
    printf "%-20s : %s\n" "Cell" "$CELL"
    printf "%-20s : %s\n" "Memory" "$MEMORY"

    echo
    echo "📄 CMakeLists.txt:"
    echo

    find "$DIR" \
        -type f \
        -name "CMakeLists.txt" \
        ! -path "*/build/*" \
        ! -path "*/.cxx/*" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
    echo "🚩 Configurações de compilação:"
    echo

    grep -RIn \
        --exclude-dir=build \
        --exclude-dir=.cxx \
        --exclude-dir=.gradle \
        --include='CMakeLists.txt' \
        --include='*.cmake' \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        -E \
        'CMAKE_CXX_STANDARD|CMAKE_CXX_FLAGS|cppFlags|ndkVersion|std=(c|gnu)\+\+' \
        "$DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    pausa
}

# ============================================================
# 3 - CAÇADOR CMAKE / NDK / FLAGS
# ============================================================

cmake_ndk_flags() {

    cabecalho

    echo "🔧 CMAKE / NDK / FLAGS"
    linha
    echo

    echo "🔎 Procurando configurações de compilação..."
    echo

    # --------------------------------------------------------
    # NDK INSTALADO
    # --------------------------------------------------------

    echo "🤖 NDK INSTALADO"
    sublinha

    NDK_REAL=""
    NDK_REV=""

    for candidato in \
        "$HOME/android-ndk-r29" \
        "$ANDROID_NDK_HOME" \
        "$ANDROID_NDK_ROOT" \
        "$NDK_HOME" \
        "$HOME/Android/Sdk/ndk/29.0.13846066"
    do
        if [ -n "$candidato" ] && [ -d "$candidato" ]; then
            NDK_REAL="$candidato"
            break
        fi
    done

    if [ -n "$NDK_REAL" ]; then

        echo "Caminho : $NDK_REAL"

        if [ -f "$NDK_REAL/source.properties" ]; then
            NDK_REV="$(
                grep '^Pkg.Revision' \
                    "$NDK_REAL/source.properties" |
                cut -d= -f2- |
                xargs
            )"

            echo "Versão  : ${NDK_REV:-N/D}"
        else
            echo "Versão  : N/D"
        fi

    else
        echo "⚠️ NDK não localizado."
    fi

    echo

    # --------------------------------------------------------
    # MAPA DE FLAGS
    # --------------------------------------------------------

    echo "🚩 MAPA DE FLAGS"
    sublinha
    echo

    grep -RIn \
        --exclude-dir=.git \
        --exclude-dir=build \
        --exclude-dir=.gradle \
        --exclude-dir=.cxx \
        --exclude-dir=backups \
        --include='CMakeLists.txt' \
        --include='*.cmake' \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        -E \
        'CMAKE_CXX_STANDARD|CMAKE_CXX_FLAGS|cppFlags|ndkVersion|ANDROID_NDK|ANDROID_STL|ANDROID_ABI|ANDROID_PLATFORM|std=(c|gnu)\+\+|-fexceptions|-fno-exceptions|-frtti|-fno-rtti' \
        "$ROOT_DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo

    # --------------------------------------------------------
    # C++ DIFERENTE DE 20
    # --------------------------------------------------------

    echo "🚨 C++ DIFERENTE DE C++20"
    sublinha
    echo

    DIFERENTES="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --exclude-dir=backups \
            --include='CMakeLists.txt' \
            --include='*.cmake' \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            'std=(c|gnu)\+\+(11|14|17|23|26)|CMAKE_CXX_STANDARD[[:space:]]+(11|14|17|23|26)' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$DIFERENTES" ]; then

        echo "⚠️ Encontrado:"
        echo

        echo "$DIFERENTES" |
            sed "s|$ROOT_DIR/||"

    else
        echo "✅ Nenhum padrão explícito diferente de C++20."
    fi

    echo

    # --------------------------------------------------------
    # FLAGS PERIGOSAS
    # --------------------------------------------------------

    echo "🚨 FLAGS SUSPEITAS"
    sublinha
    echo

    SUSPEITAS="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --exclude-dir=backups \
            --include='CMakeLists.txt' \
            --include='*.cmake' \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            '\-fno-exceptions|\-fno-rtti' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$SUSPEITAS" ]; then

        echo "$SUSPEITAS" |
            sed "s|$ROOT_DIR/||"

    else
        echo "✅ Nenhuma -fno-exceptions ou -fno-rtti encontrada."
    fi

    echo

    # --------------------------------------------------------
    # NDKVERSION
    # --------------------------------------------------------

    echo "🤖 NDK SOLICITADO PELO GRADLE"
    sublinha
    echo

    NDK_GRADLE="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            'ndkVersion' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$NDK_GRADLE" ]; then

        echo "$NDK_GRADLE" |
            sed "s|$ROOT_DIR/||"

    else
        echo "Nenhum ndkVersion explícito."
    fi

    echo

    # --------------------------------------------------------
    # RESUMO
    # --------------------------------------------------------

    linha
    echo "📊 DIAGNÓSTICO"
    linha
    echo

    echo "O resultado acima mostra:"
    echo
    echo "  arquivo"
    echo "  linha"
    echo "  flag"
    echo "  C++ Standard"
    echo "  NDK solicitado"
    echo "  NDK instalado"
    echo
    echo "Projeto : PRESERVADO"
    echo "Modo    : SOMENTE LEITURA"

    pausa
}

# ============================================================
# 4 - QEMU CENTER
# ============================================================

qemu_center() {

    cabecalho

    echo "🖥️ QEMU CENTER"
    linha
    echo

    DIR="$ROOT_DIR/QEMUCenter"

    if [ ! -d "$DIR" ]; then
        echo "❌ QEMUCenter não encontrado."
        pausa
        return
    fi

    echo "Diretório : $DIR"
    echo

    # --------------------------------------------------------
    # CMAKELISTS
    # --------------------------------------------------------

    echo "📄 CMakeLists.txt:"
    echo

    find "$DIR" \
        -type f \
        -name "CMakeLists.txt" \
        ! -path "*/build/*" \
        ! -path "*/.cxx/*" \
        ! -path "*/.gradle/*" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo

    # --------------------------------------------------------
    # GRADLE
    # --------------------------------------------------------

    echo "🐘 Gradle:"
    echo

    find "$DIR" \
        -type f \
        \( -name "build.gradle" -o -name "build.gradle.kts" \) \
        ! -path "*/build/*" \
        ! -path "*/.gradle/*" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo

    # --------------------------------------------------------
    # C++ / NDK
    # --------------------------------------------------------

    echo "🚩 Configurações C++ / NDK:"
    echo

    grep -RIn \
        --exclude-dir=build \
        --exclude-dir=.cxx \
        --exclude-dir=.gradle \
        --include='CMakeLists.txt' \
        --include='*.cmake' \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        -E \
        'CMAKE_CXX_STANDARD|CMAKE_CXX_FLAGS|CXX_STANDARD|cppFlags|ndkVersion|ANDROID_NDK|ANDROID_STL|ANDROID_ABI|ANDROID_PLATFORM|std=(c|gnu)\+\+' \
        "$DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo

    # --------------------------------------------------------
    # C++ DIFERENTE DE C++20
    # --------------------------------------------------------

    echo "🚨 C++ DIFERENTE DE C++20"
    sublinha
    echo

    QEMU_STD_ERRADO="$(
        grep -RIn \
            --exclude-dir=build \
            --exclude-dir=.cxx \
            --exclude-dir=.gradle \
            --include='CMakeLists.txt' \
            --include='*.cmake' \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            'std=(c|gnu)\+\+(11|14|17|23|26)|CMAKE_CXX_STANDARD[[:space:]]+(11|14|17|23|26)' \
            "$DIR" \
            2>/dev/null
    )"

    if [ -n "$QEMU_STD_ERRADO" ]; then

        echo "⚠️ Padrão diferente de C++20 encontrado:"
        echo

        echo "$QEMU_STD_ERRADO" |
            sed "s|$ROOT_DIR/||"

    else
        echo "✅ Nenhum padrão explícito diferente de C++20."
    fi

    echo

    # --------------------------------------------------------
    # FLAGS SUSPEITAS
    # --------------------------------------------------------

    echo "🚨 FLAGS SUSPEITAS"
    sublinha
    echo

    QEMU_FLAGS="$(
        grep -RIn \
            --exclude-dir=build \
            --exclude-dir=.cxx \
            --exclude-dir=.gradle \
            --include='CMakeLists.txt' \
            --include='*.cmake' \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            '\-fno-exceptions|\-fno-rtti|\-nostdlib|\-nodefaultlibs' \
            "$DIR" \
            2>/dev/null
    )"

    if [ -n "$QEMU_FLAGS" ]; then

        echo "⚠️ Encontradas:"
        echo

        echo "$QEMU_FLAGS" |
            sed "s|$ROOT_DIR/||"

    else
        echo "✅ Nenhuma flag suspeita encontrada."
    fi

    echo

    # --------------------------------------------------------
    # NDK
    # --------------------------------------------------------

    echo "🤖 NDK SOLICITADO PELO QEMU CENTER"
    sublinha
    echo

    QEMU_NDK="$(
        grep -RIn \
            --exclude-dir=build \
            --exclude-dir=.cxx \
            --exclude-dir=.gradle \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            --include='local.properties' \
            --include='*.cmake' \
            --include='*.sh' \
            -E \
            'ndkVersion|ndk\.dir|ANDROID_NDK|ANDROID_NDK_HOME|NDK_HOME|android-ndk|Sdk/ndk/' \
            "$DIR" \
            2>/dev/null
    )"

    if [ -n "$QEMU_NDK" ]; then

        echo "$QEMU_NDK" |
            sed "s|$ROOT_DIR/||"

    else
        echo "Nenhuma configuração explícita de NDK encontrada."
    fi

    echo

    # --------------------------------------------------------
    # LINKER / BIBLIOTECAS
    # --------------------------------------------------------

    echo "🔗 LINKER / BIBLIOTECAS"
    sublinha
    echo

    QEMU_LINKER="$(
        grep -RIn \
            --exclude-dir=build \
            --exclude-dir=.cxx \
            --exclude-dir=.gradle \
            --include='CMakeLists.txt' \
            --include='*.cmake' \
            --include='build.gradle' \
            --include='*.sh' \
            -E \
            'target_link_libraries|find_library|libunwind|crtend_android|unwind|libc\+\+' \
            "$DIR" \
            2>/dev/null |
        head -50
    )"

    if [ -n "$QEMU_LINKER" ]; then

        echo "$QEMU_LINKER" |
            sed "s|$ROOT_DIR/||"

    else
        echo "Nenhuma configuração suspeita de linker encontrada."
    fi

    echo

    # --------------------------------------------------------
    # RESUMO
    # --------------------------------------------------------

    linha
    echo "📊 DIAGNÓSTICO QEMU CENTER"
    linha
    echo

    echo "O resultado acima mostra:"
    echo
    echo "  CMakeLists.txt"
    echo "  Gradle"
    echo "  C++ Standard"
    echo "  cppFlags"
    echo "  ndkVersion"
    echo "  caminhos NDK"
    echo "  flags suspeitas"
    echo "  linker / bibliotecas"
    echo
    echo "Projeto : PRESERVADO"
    echo "Modo    : SOMENTE LEITURA"

    pausa
}

# ============================================================
# MENU PRINCIPAL DO MÓDULO 11
# ============================================================

while true
do
    cabecalho

    echo "1) 🧊 Cubo3D"
    echo "2) 🎮 CoreEmulator"
    echo "3) 🔧 CMake / NDK / Flags"
    echo "4) 🖥️ QEMU Center"
    echo
    echo "0) ← Voltar"
    echo

    read -r -p "Escolha uma opção: " OPCAO

    case "$OPCAO" in

        1)
            cubo3d
            ;;

        2)
            core_emulator
            ;;

        3)
            cmake_ndk_flags
            ;;

        4)
            qemu_center
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
