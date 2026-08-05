#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"
SDK="$HOME/Android/Sdk"
NDK="$HOME/android-ndk-r29"

OK=0
WARN=0
ERROR=0

ok() {
    echo "✅ $1"
    ((OK++))
}

warn() {
    echo "⚠ $1"
    ((WARN++))
}

error() {
    echo "❌ $1"
    ((ERROR++))
}

separator() {
    echo "------------------------------------------------------------"
}

clear

echo "============================================================"
echo "📦 P3XE - SDK / NDK DOCTOR"
echo "============================================================"
echo
echo "Root : $ROOT"
echo "SDK  : $SDK"
echo "NDK  : $NDK"
echo

# ============================================================
# 1. ANDROID SDK
# ============================================================

echo "[ 1/6 ] ANDROID SDK"
separator

if [ -d "$SDK" ]; then
    ok "Android SDK encontrado"
else
    error "Android SDK não encontrado"
fi

if [ -d "$SDK/platforms" ]; then
    ok "Platforms encontrada"

    echo
    echo "Platforms instaladas:"
    find "$SDK/platforms" \
        -maxdepth 1 \
        -type d \
        -name 'android-*' \
        -printf '   %f\n' 2>/dev/null | sort -V
else
    warn "Pasta platforms não encontrada"
fi

if [ -d "$SDK/build-tools" ]; then
    ok "Build Tools encontrado"

    echo
    echo "Build Tools instalados:"
    find "$SDK/build-tools" \
        -maxdepth 1 \
        -mindepth 1 \
        -type d \
        -printf '   %f\n' 2>/dev/null | sort -V
else
    error "Build Tools não encontrado"
fi

if [ -d "$SDK/platform-tools" ]; then
    ok "Platform Tools encontrado"
else
    warn "Platform Tools não encontrado"
fi

echo

# ============================================================
# 2. ANDROID NDK
# ============================================================

echo "[ 2/6 ] ANDROID NDK"
separator

NDK_VERSION=""

if [ -d "$NDK" ]; then
    ok "Android NDK r29 encontrado"
else
    error "Android NDK r29 não encontrado"
fi

if [ -f "$NDK/source.properties" ]; then
    ok "source.properties encontrado"

    NDK_VERSION=$(
        grep '^Pkg.Revision' "$NDK/source.properties" 2>/dev/null |
        cut -d= -f2- |
        xargs
    )

    if [ -n "$NDK_VERSION" ]; then
        echo "   Versão: $NDK_VERSION"

        case "$NDK_VERSION" in
            29.*)
                ok "Versão principal NDK 29 confirmada"
                ;;
            *)
                warn "Versão diferente de NDK 29: $NDK_VERSION"
                ;;
        esac
    else
        warn "Não foi possível detectar a versão do NDK"
    fi
else
    error "source.properties não encontrado"
fi

echo

# ============================================================
# 3. NDK TOOLCHAIN
# ============================================================

echo "[ 3/6 ] NDK TOOLCHAIN"
separator

TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64"
CMAKE_TOOLCHAIN="$NDK/build/cmake/android.toolchain.cmake"

if [ -d "$TOOLCHAIN" ]; then
    ok "LLVM Toolchain encontrado"
    echo "   $TOOLCHAIN"
else
    error "LLVM Toolchain não encontrado"
fi

if [ -f "$TOOLCHAIN/bin/clang" ]; then
    ok "NDK clang encontrado"
else
    error "NDK clang não encontrado"
fi

if [ -f "$TOOLCHAIN/bin/clang++" ]; then
    ok "NDK clang++ encontrado"
else
    error "NDK clang++ não encontrado"
fi

if [ -f "$CMAKE_TOOLCHAIN" ]; then
    ok "android.toolchain.cmake encontrado"
else
    error "android.toolchain.cmake não encontrado"
fi

if find "$TOOLCHAIN/sysroot/usr/lib" \
    -type d \
    -name 'aarch64-linux-android' \
    -print -quit 2>/dev/null |
    grep -q .
then
    ok "ABI arm64-v8a / aarch64 disponível"
else
    warn "Sysroot aarch64 não localizado"
fi

echo

# ============================================================
# 4. VARIÁVEIS DO AMBIENTE
# ============================================================

echo "[ 4/6 ] AMBIENTE ANDROID"
separator

if [ -n "$ANDROID_HOME" ]; then
    echo "ANDROID_HOME = $ANDROID_HOME"

    if [ "$ANDROID_HOME" = "$SDK" ]; then
        ok "ANDROID_HOME correto"
    else
        warn "ANDROID_HOME diferente do SDK esperado"
    fi
else
    warn "ANDROID_HOME não definido"
fi

if [ -n "$ANDROID_NDK_HOME" ]; then
    echo "ANDROID_NDK_HOME = $ANDROID_NDK_HOME"

    if [ "$ANDROID_NDK_HOME" = "$NDK" ]; then
        ok "ANDROID_NDK_HOME correto"
    else
        warn "ANDROID_NDK_HOME diferente do NDK esperado"
    fi
else
    warn "ANDROID_NDK_HOME não definido"
fi

echo

# ============================================================
# 5. LOCAL.PROPERTIES
# ============================================================

echo "[ 5/6 ] PROJETOS P3XE"
separator

check_local_properties() {

    local NAME="$1"
    local DIR="$2"
    local FILE="$DIR/local.properties"

    echo
    echo "📦 $NAME"

    if [ ! -d "$DIR" ]; then
        error "Diretório não encontrado: $DIR"
        return
    fi

    ok "Diretório encontrado"

    if [ ! -f "$FILE" ]; then
        warn "local.properties não encontrado"
        return
    fi

    ok "local.properties encontrado"

    local SDK_DIR
    local NDK_DIR

    SDK_DIR=$(
        grep '^sdk.dir=' "$FILE" 2>/dev/null |
        head -n 1 |
        cut -d= -f2-
    )

    NDK_DIR=$(
        grep '^ndk.dir=' "$FILE" 2>/dev/null |
        head -n 1 |
        cut -d= -f2-
    )

    if [ -n "$SDK_DIR" ]; then
        echo "   sdk.dir: $SDK_DIR"

        if [ "$SDK_DIR" = "$SDK" ]; then
            ok "$NAME SDK correto"
        else
            warn "$NAME usa outro SDK"
        fi
    else
        warn "$NAME não possui sdk.dir"
    fi

    if [ -n "$NDK_DIR" ]; then
        echo "   ndk.dir: $NDK_DIR"

        if [ "$NDK_DIR" = "$NDK" ]; then
            ok "$NAME NDK correto"
        else
            warn "$NAME usa outro NDK"
        fi
    else
        warn "$NAME não possui ndk.dir"
    fi
}

check_local_properties \
    "Cubo3D" \
    "$ROOT/Cubo3D/android"

check_local_properties \
    "CoreEmulator" \
    "$ROOT/CoreEmulator/android"

check_local_properties \
    "QEMU Center" \
    "$ROOT/QEMUCenter"

echo

# ============================================================
# 6. CAÇA A CONFLITOS NDK
# ============================================================

echo "[ 6/6 ] CAÇA A CONFLITOS NDK"
separator

CONFLICT_FILE=$(mktemp)

grep -RniE \
    --include='*.gradle' \
    --include='*.gradle.kts' \
    --include='gradle.properties' \
    --include='local.properties' \
    --include='CMakeLists.txt' \
    'ndkVersion|ndk\.dir|android-ndk|27\.0\.12077973|29\.0\.14206865' \
    "$ROOT/Cubo3D" \
    "$ROOT/CoreEmulator" \
    "$ROOT/QEMUCenter" \
    > "$CONFLICT_FILE" 2>/dev/null

if [ -s "$CONFLICT_FILE" ]; then
    echo "Configurações NDK encontradas:"
    echo
    cat "$CONFLICT_FILE"
else
    warn "Nenhuma configuração explícita de NDK encontrada"
fi

echo
separator

if grep -q '27\.0\.12077973' "$CONFLICT_FILE"; then
    error "NDK 27.0.12077973 ainda está configurado em algum projeto"
    echo
    echo "   NDK instalado : ${NDK_VERSION:-29.x}"
    echo "   NDK conflitante: 27.0.12077973"
else
    ok "NDK 27.0.12077973 não encontrado nas configurações"
fi

if grep -q '29\.0\.14206865' "$CONFLICT_FILE"; then
    ok "Referência ao NDK 29.0.14206865 encontrada"
fi

rm -f "$CONFLICT_FILE"

echo
echo "============================================================"
echo "📊 RESULTADO SDK / NDK"
echo "============================================================"
echo
echo "✅ OK     : $OK"
echo "⚠ Avisos : $WARN"
echo "❌ Erros  : $ERROR"
echo

if [ "$ERROR" -eq 0 ]; then
    echo "✅ SDK / NDK: SAUDÁVEL"
elif [ "$ERROR" -le 2 ]; then
    echo "⚠ SDK / NDK: ATENÇÃO NECESSÁRIA"
else
    echo "❌ SDK / NDK: PROBLEMAS ENCONTRADOS"
fi

echo
read -r -p "Pressione ENTER para voltar..."
