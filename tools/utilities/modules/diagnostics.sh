#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# Utilities Center
# Módulo 13 - Diagnóstico Geral / Caçador de Conflitos
#
# Cubo3D + CoreEmulator + QEMU Center + Android + APP
# CMake + C++ + Gradle + NDK + SDK
#
# SOMENTE LEITURA
# NÃO REMOVE
# NÃO ALTERA
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
    echo "🧪 DIAGNÓSTICO UTILITIES"
    echo "Pure3XEngine 0.2.6 Alpha"
    linha
    echo
    echo "Projeto : $ROOT_DIR"
    echo "Modo    : SOMENTE LEITURA"
    echo
}

# ============================================================
# CONTADORES
# ============================================================

TOTAL_OK=0
TOTAL_AVISO=0
TOTAL_ERRO=0

ok() {
    echo "✅ $1"
    TOTAL_OK=$((TOTAL_OK + 1))
}

aviso() {
    echo "⚠️ $1"
    TOTAL_AVISO=$((TOTAL_AVISO + 1))
}

erro() {
    echo "❌ $1"
    TOTAL_ERRO=$((TOTAL_ERRO + 1))
}

# ============================================================
# 1 - ESTRUTURA
# ============================================================

diagnostico_estrutura() {

    cabecalho

    echo "📁 1 - ESTRUTURA DOS PROJETOS"
    linha
    echo

    for pasta in \
        "android" \
        "app" \
        "Cubo3D" \
        "CoreEmulator" \
        "QEMUCenter" \
        "tools"
    do

        if [ -d "$ROOT_DIR/$pasta" ]; then
            printf "✅ %-20s %s\n" \
                "$pasta" \
                "$ROOT_DIR/$pasta"
        else
            printf "⚠️ %-20s AUSENTE\n" "$pasta"
        fi

    done

    echo
    echo "📄 CMakeLists.txt encontrados:"
    sublinha
    echo

    find "$ROOT_DIR" \
        -type f \
        -name "CMakeLists.txt" \
        ! -path "*/build/*" \
        ! -path "*/.cxx/*" \
        ! -path "*/.gradle/*" \
        ! -path "*/backups/*" \
        ! -path "*/.git/*" \
        2>/dev/null |
        sort |
        sed "s|$ROOT_DIR/||"

    echo
    echo "🐘 build.gradle encontrados:"
    sublinha
    echo

    find "$ROOT_DIR" \
        -type f \
        \( \
            -name "build.gradle" \
            -o -name "build.gradle.kts" \
        \) \
        ! -path "*/build/*" \
        ! -path "*/.gradle/*" \
        ! -path "*/backups/*" \
        ! -path "*/.git/*" \
        2>/dev/null |
        sort |
        sed "s|$ROOT_DIR/||"

    pausa
}

# ============================================================
# 2 - C++ / CMAKE
# ============================================================

diagnostico_cpp() {

    cabecalho

    echo "🚩 2 - CMAKE / C++ STANDARD"
    linha
    echo

    echo "🔎 Todas as declarações encontradas:"
    sublinha
    echo

    RESULTADO="$(
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
            'CMAKE_CXX_STANDARD|CXX_STANDARD|CMAKE_CXX_FLAGS|cppFlags|std=(c|gnu)\+\+' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$RESULTADO" ]; then
        echo "$RESULTADO" |
            sed "s|$ROOT_DIR/||"
    else
        echo "Nenhuma configuração C++ encontrada."
    fi

    echo
    echo "🚨 Standards diferentes de C++20:"
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
            'CMAKE_CXX_STANDARD[[:space:]]+(11|14|17|23|26)|std=(c|gnu)\+\+(11|14|17|23|26)' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$DIFERENTES" ]; then

        aviso "Encontrado C++ diferente de C++20."
        echo
        echo "$DIFERENTES" |
            sed "s|$ROOT_DIR/||"

    else

        ok "Nenhum C++11/14/17/23/26 explícito encontrado."

    fi

    echo
    echo "🔁 C++20 declarado em CMake + Gradle:"
    sublinha
    echo

    grep -RIn \
        --exclude-dir=.git \
        --exclude-dir=build \
        --exclude-dir=.gradle \
        --exclude-dir=.cxx \
        --exclude-dir=backups \
        --include='CMakeLists.txt' \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        -E \
        'CMAKE_CXX_STANDARD[[:space:]]+20|std=(c|gnu)\+\+20' \
        "$ROOT_DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
    echo "OBS:"
    echo "CMAKE_CXX_STANDARD 20 + cppFlags -std=c++20"
    echo "não são standards diferentes."
    echo "Porém são duas fontes configurando o mesmo standard."

    pausa
}

# ============================================================
# 3 - FLAGS SUSPEITAS
# ============================================================

diagnostico_flags() {

    cabecalho

    echo "🚨 3 - FLAGS SUSPEITAS"
    linha
    echo

    FLAGS="$(
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
            '\-fno-exceptions|\-fno-rtti|\-fexceptions|\-frtti|CMAKE_CXX_FLAGS|add_compile_options|target_compile_options' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$FLAGS" ]; then

        echo "$FLAGS" |
            sed "s|$ROOT_DIR/||"

    else

        ok "Nenhuma flag suspeita explícita encontrada."

    fi

    echo
    echo "🔎 Flags -std encontradas:"
    sublinha
    echo

    STD="$(
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
            -- '-std=(c|gnu)\+\+[0-9]+' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$STD" ]; then
        echo "$STD" |
            sed "s|$ROOT_DIR/||"
    else
        echo "Nenhuma flag -std explícita."
    fi

    pausa
}

# ============================================================
# 4 - NDK
# ============================================================

diagnostico_ndk() {

    cabecalho

    echo "🤖 4 - COMPARAÇÃO NDK"
    linha
    echo

    NDK_PRINCIPAL="$HOME/android-ndk-r29"
    NDK_REV=""

    if [ -d "$NDK_PRINCIPAL" ]; then

        ok "NDK principal encontrado."

        echo "Caminho:"
        echo "$NDK_PRINCIPAL"
        echo

        if [ -f "$NDK_PRINCIPAL/source.properties" ]; then

            NDK_REV="$(
                grep '^Pkg.Revision' \
                    "$NDK_PRINCIPAL/source.properties" \
                    2>/dev/null |
                cut -d= -f2- |
                xargs
            )"

            echo "Versão:"
            echo "${NDK_REV:-N/D}"

        fi

    else

        erro "NDK principal não encontrado."

    fi

    echo
    echo "🔎 Todas as referências NDK:"
    sublinha
    echo

    NDK_REFERENCIAS="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --exclude-dir=backups \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            --include='local.properties' \
            --include='CMakeLists.txt' \
            --include='*.cmake' \
            -E \
            'ndkVersion|ndk\.dir|ANDROID_NDK|NDK_HOME|android-ndk|/ndk/' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$NDK_REFERENCIAS" ]; then

        echo "$NDK_REFERENCIAS" |
            sed "s|$ROOT_DIR/||"

    else

        aviso "Nenhuma referência NDK encontrada."

    fi

    echo
    echo "🚨 REFERÊNCIAS NDK 27:"
    sublinha
    echo

    NDK27="$(
        echo "$NDK_REFERENCIAS" |
        grep -E \
            'ndkVersion[^0-9]*"?27\.|/ndk/27\.|android-ndk-r27' \
            2>/dev/null
    )"

    if [ -n "$NDK27" ]; then

        erro "Referência antiga ao NDK 27 encontrada."
        echo
        echo "$NDK27" |
            sed "s|$ROOT_DIR/||"

    else

        ok "Nenhuma referência explícita ao NDK 27."

    fi

    echo
    echo "📊 ndkVersion diferentes:"
    sublinha
    echo

    VERSOES_NDK="$(
        grep -Rih \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --exclude-dir=backups \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            '^[[:space:]]*ndkVersion[[:space:]]+["'\''][0-9]+\.[0-9]+\.[0-9]+["'\'']' \
            "$ROOT_DIR" \
            2>/dev/null |
        grep -Eo \
            '[0-9]+\.[0-9]+\.[0-9]+' |
        sort -u
    )"

    if [ -n "$VERSOES_NDK" ]; then
        echo "$VERSOES_NDK"
    else
        echo "Nenhum ndkVersion ativo detectado."
    fi

    TOTAL_NDK="$(
        printf "%s\n" "$VERSOES_NDK" |
        sed '/^[[:space:]]*$/d' |
        wc -l
    )"

    echo

    if [ "$TOTAL_NDK" -gt 1 ]; then
        erro "Existem múltiplas versões ndkVersion ativas."
    elif [ "$TOTAL_NDK" -eq 1 ]; then
        ok "Uma única versão ndkVersion ativa foi detectada."
    fi

    pausa
}

# ============================================================
# 5 - SDK
# ============================================================

diagnostico_sdk() {

    cabecalho

    echo "📦 5 - COMPARAÇÃO ANDROID SDK"
    linha
    echo

    SDK="$HOME/Android/Sdk"

    if [ -d "$SDK" ]; then
        ok "Android SDK encontrado."
        echo "Caminho:"
        echo "$SDK"
    else
        erro "Android SDK não encontrado em $SDK"
    fi

    echo
    echo "🔎 sdk.dir encontrados:"
    sublinha
    echo

    grep -RIn \
        --exclude-dir=.git \
        --exclude-dir=build \
        --exclude-dir=.gradle \
        --exclude-dir=.cxx \
        --exclude-dir=backups \
        --include='local.properties' \
        -E \
        '^sdk\.dir=' \
        "$ROOT_DIR" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
    echo "🔎 compileSdk / targetSdk / minSdk:"
    sublinha
    echo

    SDK_CONFIG="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --exclude-dir=backups \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            'compileSdk|targetSdk|minSdk' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    echo "$SDK_CONFIG" |
        sed "s|$ROOT_DIR/||"

    echo
    echo "🚨 compileSdk diferente de 36:"
    sublinha
    echo

    COMPILE_DIF="$(
        echo "$SDK_CONFIG" |
        grep -E \
            'compileSdk[^0-9]*([0-9]+)' |
        grep -Ev \
            'compileSdk[^0-9]*36([^0-9]|$)' \
            2>/dev/null
    )"

    if [ -n "$COMPILE_DIF" ]; then

        erro "compileSdk diferente de 36 encontrado."
        echo
        echo "$COMPILE_DIF" |
            sed "s|$ROOT_DIR/||"

    else

        ok "Todos os compileSdk detectados usam 36."

    fi

    echo
    echo "🚨 targetSdk diferente de 36:"
    sublinha
    echo

    TARGET_DIF="$(
        echo "$SDK_CONFIG" |
        grep -E \
            'targetSdk[^0-9]*([0-9]+)' |
        grep -Ev \
            'targetSdk[^0-9]*36([^0-9]|$)' \
            2>/dev/null
    )"

    if [ -n "$TARGET_DIF" ]; then

        erro "targetSdk diferente de 36 encontrado."
        echo
        echo "$TARGET_DIF" |
            sed "s|$ROOT_DIR/||"

    else

        ok "Todos os targetSdk detectados usam 36."

    fi

    echo
    echo "ℹ️ minSdk:"
    sublinha

    echo "$SDK_CONFIG" |
        grep 'minSdk' |
        sed "s|$ROOT_DIR/||"

    pausa
}

# ============================================================
# 6 - LOCAL.PROPERTIES
# ============================================================

diagnostico_local_properties() {

    cabecalho

    echo "📄 6 - LOCAL.PROPERTIES"
    linha
    echo

    mapfile -t LOCALS < <(
        find "$ROOT_DIR" \
            -type f \
            -name "local.properties" \
            ! -path "*/build/*" \
            ! -path "*/.gradle/*" \
            ! -path "*/backups/*" \
            2>/dev/null |
        sort
    )

    echo "Arquivos encontrados: ${#LOCALS[@]}"
    echo

    for arquivo in "${LOCALS[@]}"; do

        echo "📄 ${arquivo#$ROOT_DIR/}"
        sublinha

        grep -nE \
            '^(sdk\.dir|ndk\.dir)=' \
            "$arquivo" \
            2>/dev/null

        echo

    done

    pausa
}

# ============================================================
# 7 - CACHE CMAKE / GRADLE
# ============================================================

diagnostico_cache() {

    cabecalho

    echo "🧹 7 - CACHE / BUILDS ANTIGOS"
    linha
    echo

    echo "🔎 CMakeCache.txt:"
    sublinha
    echo

    mapfile -t CACHE_CMAKE < <(
        find "$ROOT_DIR" \
            -type f \
            -name "CMakeCache.txt" \
            2>/dev/null |
        sort
    )

    if [ "${#CACHE_CMAKE[@]}" -gt 0 ]; then

        for arquivo in "${CACHE_CMAKE[@]}"; do
            echo "${arquivo#$ROOT_DIR/}"
        done

        echo
        aviso "Caches CMake existem e podem guardar configuração antiga."

    else

        ok "Nenhum CMakeCache.txt encontrado."

    fi

    echo
    echo "🔎 Diretórios .cxx:"
    sublinha
    echo

    mapfile -t CXX_DIRS < <(
        find "$ROOT_DIR" \
            -type d \
            -name ".cxx" \
            2>/dev/null |
        sort
    )

    if [ "${#CXX_DIRS[@]}" -gt 0 ]; then

        for pasta in "${CXX_DIRS[@]}"; do
            echo "${pasta#$ROOT_DIR/}"
        done

        echo
        aviso "Diretórios .cxx podem conter configuração CMake anterior."

    else

        ok "Nenhum diretório .cxx encontrado."

    fi

    echo
    echo "🔎 Diretórios build:"
    sublinha
    echo

    find "$ROOT_DIR" \
        -type d \
        -name "build" \
        ! -path "*/.gradle/*" \
        2>/dev/null |
        sort |
        sed "s|$ROOT_DIR/||" |
        head -40

    echo
    echo "OBS:"
    echo "Esta opção apenas localiza caches."
    echo "Nada foi removido."

    pausa
}

# ============================================================
# 8 - QUEM USA APP/ DA RAIZ?
# ============================================================

diagnostico_app_raiz() {

    cabecalho

    echo "🕵️ 8 - QUEM USA app/ DA RAIZ?"
    linha
    echo

    if [ ! -d "$ROOT_DIR/app" ]; then
        aviso "Diretório app/ da raiz não existe."
        pausa
        return
    fi

    echo "Diretório suspeito:"
    echo "$ROOT_DIR/app"
    echo

    echo "📄 Arquivos principais:"
    sublinha
    echo

    find "$ROOT_DIR/app" \
        -maxdepth 3 \
        -type f \
        \( \
            -name "build.gradle" \
            -o -name "build.gradle.kts" \
            -o -name "CMakeLists.txt" \
            -o -name "AndroidManifest.xml" \
            -o -name "local.properties" \
        \) \
        2>/dev/null |
        sort |
        sed "s|$ROOT_DIR/||"

    echo
    echo "🔗 Referências a ':app' / include app:"
    sublinha
    echo

    REFERENCIAS="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --exclude-dir=backups \
            --include='settings.gradle' \
            --include='settings.gradle.kts' \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            "include[[:space:]]*['\"]?:app|include[[:space:]]*\([[:space:]]*['\"]:app|project[[:space:]]*\([[:space:]]*['\"]:app" \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$REFERENCIAS" ]; then

        echo "$REFERENCIAS" |
            sed "s|$ROOT_DIR/||"

    else

        aviso "Nenhuma referência direta ao módulo :app encontrada."

    fi

    echo
    echo "🚩 Configuração do app/ da raiz:"
    sublinha
    echo

    grep -RIn \
        --exclude-dir=build \
        --exclude-dir=.gradle \
        --exclude-dir=.cxx \
        --include='build.gradle' \
        --include='build.gradle.kts' \
        --include='CMakeLists.txt' \
        --include='local.properties' \
        -E \
        'compileSdk|targetSdk|minSdk|ndkVersion|ndk\.dir|CMAKE_CXX_STANDARD|cppFlags|std=(c|gnu)\+\+' \
        "$ROOT_DIR/app" \
        2>/dev/null |
        sed "s|$ROOT_DIR/||"

    echo
    echo "Esta opção ajuda a descobrir se app/ é:"
    echo
    echo "  módulo ativo"
    echo "  cópia antiga"
    echo "  projeto legado"
    echo "  configuração duplicada"
    echo
    echo "Nada será removido."

    pausa
}

# ============================================================
# 9 - DIAGNÓSTICO COMPLETO
# ============================================================

diagnostico_completo() {

    cabecalho

    echo "🔬 9 - DIAGNÓSTICO COMPLETO"
    linha
    echo

    TOTAL_OK=0
    TOTAL_AVISO=0
    TOTAL_ERRO=0

    # --------------------------------------------------------
    # C++ STANDARD
    # --------------------------------------------------------

    echo "🚩 C++ STANDARD"
    sublinha

    CPP_DIF="$(
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
            'CMAKE_CXX_STANDARD[[:space:]]+(11|14|17|23|26)|std=(c|gnu)\+\+(11|14|17|23|26)' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$CPP_DIF" ]; then
        erro "Existe standard C++ diferente de C++20."
    else
        ok "C++20 sem standard explicitamente conflitante."
    fi

    echo

    # --------------------------------------------------------
    # NDK PRINCIPAL
    # --------------------------------------------------------

    echo "🤖 NDK"
    sublinha

    if [ -d "$HOME/android-ndk-r29" ]; then

        NDK_REAL="$(
            grep '^Pkg.Revision' \
                "$HOME/android-ndk-r29/source.properties" \
                2>/dev/null |
            cut -d= -f2- |
            xargs
        )"

        ok "NDK principal: ${NDK_REAL:-r29}"

    else

        erro "NDK principal r29 não encontrado."

    fi

    NDK27="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --exclude-dir=backups \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            --include='local.properties' \
            -E \
            'ndkVersion[^0-9]*"?27\.|/ndk/27\.|android-ndk-r27' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$NDK27" ]; then

        erro "Configuração antiga NDK 27 encontrada."

        echo "$NDK27" |
            sed "s|$ROOT_DIR/||"

    else

        ok "Nenhuma configuração NDK 27 encontrada."

    fi

    echo

    # --------------------------------------------------------
    # SDK
    # --------------------------------------------------------

    echo "📦 SDK"
    sublinha

    SDK35="$(
        grep -RIn \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude-dir=.gradle \
            --exclude-dir=.cxx \
            --exclude-dir=backups \
            --include='build.gradle' \
            --include='build.gradle.kts' \
            -E \
            'compileSdk[^0-9]*35|targetSdk[^0-9]*35' \
            "$ROOT_DIR" \
            2>/dev/null
    )"

    if [ -n "$SDK35" ]; then

        erro "SDK 35 encontrado enquanto o padrão atual é 36."

        echo "$SDK35" |
            sed "s|$ROOT_DIR/||"

    else

        ok "Nenhum compileSdk/targetSdk 35 encontrado."

    fi

    echo

    # --------------------------------------------------------
    # CACHE
    # --------------------------------------------------------

    echo "🧹 CACHE"
    sublinha

    CACHE_TOTAL="$(
        find "$ROOT_DIR" \
            -type f \
            -name "CMakeCache.txt" \
            2>/dev/null |
        wc -l
    )"

    CXX_TOTAL="$(
        find "$ROOT_DIR" \
            -type d \
            -name ".cxx" \
            2>/dev/null |
        wc -l
    )"

    echo "CMakeCache.txt : $CACHE_TOTAL"
    echo ".cxx           : $CXX_TOTAL"

    if [ "$CACHE_TOTAL" -gt 0 ] ||
       [ "$CXX_TOTAL" -gt 0 ]; then

        aviso "Existem caches capazes de manter configuração antiga."

    else

        ok "Nenhum cache CMake/.cxx detectado."

    fi

    echo

    # --------------------------------------------------------
    # RESULTADO
    # --------------------------------------------------------

    linha
    echo "📊 RESULTADO FINAL"
    linha
    echo

    echo "OK     : $TOTAL_OK"
    echo "Avisos : $TOTAL_AVISO"
    echo "Erros  : $TOTAL_ERRO"
    echo

    if [ "$TOTAL_ERRO" -gt 0 ]; then

        echo "Estado : ❌ CONFLITOS ENCONTRADOS"

    elif [ "$TOTAL_AVISO" -gt 0 ]; then

        echo "Estado : ⚠️ REQUER ATENÇÃO"

    else

        echo "Estado : ✅ AMBIENTE CONSISTENTE"

    fi

    echo
    echo "Projeto : PRESERVADO"
    echo "Modo    : SOMENTE LEITURA"
    echo
    echo "O diagnóstico não alterou nenhum arquivo."

    pausa
}

# ============================================================
# MENU PRINCIPAL
# ============================================================

while true
do

    cabecalho

    echo "1) 📁 Estrutura dos Projetos"
    echo "2) 🚩 CMake / C++ Standard"
    echo "3) 🚨 Flags Suspeitas"
    echo "4) 🤖 Comparar NDK"
    echo "5) 📦 Comparar Android SDK"
    echo "6) 📄 Comparar local.properties"
    echo "7) 🧹 Procurar Caches CMake / Gradle"
    echo "8) 🕵️ Investigar app/ da Raiz"
    echo
    echo "9) 🔬 Diagnóstico Completo"
    echo
    echo "0) ← Voltar"
    echo

    read -r -p "Escolha uma opção: " OPCAO

    case "$OPCAO" in

        1)
            diagnostico_estrutura
            ;;

        2)
            diagnostico_cpp
            ;;

        3)
            diagnostico_flags
            ;;

        4)
            diagnostico_ndk
            ;;

        5)
            diagnostico_sdk
            ;;

        6)
            diagnostico_local_properties
            ;;

        7)
            diagnostico_cache
            ;;

        8)
            diagnostico_app_raiz
            ;;

        9)
            diagnostico_completo
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
