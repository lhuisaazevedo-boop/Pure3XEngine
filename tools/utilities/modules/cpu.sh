#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine - Utilities Center
# Módulo 7 - Informações da CPU
# Android + P3XE PS3 Core + QEMU Center
# ============================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

clear

linha() {
    echo "============================================================"
}

titulo() {
    linha
    echo "$1"
    linha
    echo
}

# ------------------------------------------------------------
# CABEÇALHO
# ------------------------------------------------------------

titulo "⚡ INFORMAÇÕES DA CPU"

echo "Projeto : $ROOT_DIR"
echo

# ------------------------------------------------------------
# CPU / ANDROID
# ------------------------------------------------------------

titulo "📱 CPU DO ANDROID"

ARCH="$(uname -m 2>/dev/null)"
KERNEL="$(uname -r 2>/dev/null)"

if command -v nproc >/dev/null 2>&1; then
    CORES="$(nproc 2>/dev/null)"
else
    CORES="$(grep -c '^processor' /proc/cpuinfo 2>/dev/null)"
fi

[ -z "$ARCH" ] && ARCH="N/D"
[ -z "$KERNEL" ] && KERNEL="N/D"
[ -z "$CORES" ] && CORES="N/D"

printf "%-22s %s\n" "Arquitetura:" "$ARCH"
printf "%-22s %s\n" "Núcleos disponíveis:" "$CORES"
printf "%-22s %s\n" "Kernel:" "$KERNEL"

if command -v getprop >/dev/null 2>&1; then

    SOC_MODEL="$(getprop ro.soc.model 2>/dev/null)"
    SOC_MANUFACTURER="$(getprop ro.soc.manufacturer 2>/dev/null)"
    HARDWARE="$(getprop ro.hardware 2>/dev/null)"
    ABI="$(getprop ro.product.cpu.abi 2>/dev/null)"
    ABI_LIST="$(getprop ro.product.cpu.abilist 2>/dev/null)"

    echo
    [ -n "$SOC_MODEL" ] &&
        printf "%-22s %s\n" "SoC:" "$SOC_MODEL"

    [ -n "$SOC_MANUFACTURER" ] &&
        printf "%-22s %s\n" "Fabricante SoC:" "$SOC_MANUFACTURER"

    [ -n "$HARDWARE" ] &&
        printf "%-22s %s\n" "Hardware:" "$HARDWARE"

    [ -n "$ABI" ] &&
        printf "%-22s %s\n" "ABI principal:" "$ABI"

    [ -n "$ABI_LIST" ] &&
        printf "%-22s %s\n" "ABIs:" "$ABI_LIST"
fi

echo

# ------------------------------------------------------------
# NÚCLEOS
# ------------------------------------------------------------

titulo "🧩 NÚCLEOS DA CPU"

CPU_PATH="/sys/devices/system/cpu"

for cpu in "$CPU_PATH"/cpu[0-9]*; do

    [ -d "$cpu" ] || continue

    nome="$(basename "$cpu")"
    online="1"

    if [ -f "$cpu/online" ]; then
        online="$(cat "$cpu/online" 2>/dev/null)"
    fi

    freq_atual=""
    freq_max=""

    if [ -r "$cpu/cpufreq/scaling_cur_freq" ]; then
        freq_atual="$(cat "$cpu/cpufreq/scaling_cur_freq" 2>/dev/null)"
    fi

    if [ -r "$cpu/cpufreq/cpuinfo_max_freq" ]; then
        freq_max="$(cat "$cpu/cpufreq/cpuinfo_max_freq" 2>/dev/null)"
    elif [ -r "$cpu/cpufreq/scaling_max_freq" ]; then
        freq_max="$(cat "$cpu/cpufreq/scaling_max_freq" 2>/dev/null)"
    fi

    if [ "$online" = "1" ]; then
        estado="ON"
    else
        estado="OFF"
    fi

    if [[ "$freq_atual" =~ ^[0-9]+$ ]]; then
        freq_atual="$(
            awk "BEGIN {printf \"%.0f MHz\", $freq_atual/1000}"
        )"
    else
        freq_atual="N/D"
    fi

    if [[ "$freq_max" =~ ^[0-9]+$ ]]; then
        freq_max="$(
            awk "BEGIN {printf \"%.0f MHz\", $freq_max/1000}"
        )"
    else
        freq_max="N/D"
    fi

    printf "%-6s Estado:%-5s Atual:%-11s Máx:%s\n" \
        "$nome" "$estado" "$freq_atual" "$freq_max"
done

echo

# ------------------------------------------------------------
# CPUINFO
# ------------------------------------------------------------

titulo "🔎 RECURSOS DA CPU"

if [ -r /proc/cpuinfo ]; then

    FEATURES="$(
        grep -m1 -E '^(Features|flags)[[:space:]]*:' \
        /proc/cpuinfo 2>/dev/null |
        cut -d: -f2-
    )"

    if [ -n "$FEATURES" ]; then
        echo "$FEATURES" | fold -s -w 58
    else
        echo "Recursos detalhados não disponibilizados pelo Android."
    fi

else
    echo "/proc/cpuinfo não disponível."
fi

echo

# ------------------------------------------------------------
# P3XE - CORE PS3
# ------------------------------------------------------------

titulo "🎮 P3XE — CPU CORE PS3"

echo "CPU original do PS3:"
echo "Cell Broadband Engine"
echo
echo "Arquitetura emulada:"
echo "PowerPC / PPU + SPU"
echo

PPU_COUNT="$(
    find "$ROOT_DIR" -type f \
        \( -iname '*ppu*.cpp' -o \
           -iname '*ppu*.h' -o \
           -iname '*ppu*.hpp' \) \
        2>/dev/null |
        wc -l
)"

SPU_COUNT="$(
    find "$ROOT_DIR" -type f \
        \( -iname '*spu*.cpp' -o \
           -iname '*spu*.h' -o \
           -iname '*spu*.hpp' \) \
        2>/dev/null |
        wc -l
)"

printf "%-25s %s\n" "Arquivos PPU:" "$PPU_COUNT"
printf "%-25s %s\n" "Arquivos SPU:" "$SPU_COUNT"

echo
echo "Componentes encontrados:"
echo

find "$ROOT_DIR" -type f \
    \( -iname '*ppu*.cpp' -o \
       -iname '*ppu*.h' -o \
       -iname '*ppu*.hpp' -o \
       -iname '*spu*.cpp' -o \
       -iname '*spu*.h' -o \
       -iname '*spu*.hpp' -o \
       -iname '*cell*.cpp' -o \
       -iname '*cell*.h' \) \
    2>/dev/null |
    sed "s|$ROOT_DIR/||" |
    head -20

if [ "$PPU_COUNT" -eq 0 ] && [ "$SPU_COUNT" -eq 0 ]; then
    echo "Nenhum módulo PPU/SPU localizado."
fi

echo

# ------------------------------------------------------------
# QEMU CENTER
# ------------------------------------------------------------

titulo "🖥️ QEMU CENTER — CPU"

if command -v qemu-system-aarch64 >/dev/null 2>&1; then
    QEMU_BIN="$(command -v qemu-system-aarch64)"

elif command -v qemu-system-x86_64 >/dev/null 2>&1; then
    QEMU_BIN="$(command -v qemu-system-x86_64)"

elif command -v qemu-system-i386 >/dev/null 2>&1; then
    QEMU_BIN="$(command -v qemu-system-i386)"

else
    QEMU_BIN=""
fi

if [ -n "$QEMU_BIN" ]; then

    printf "%-20s %s\n" "QEMU:" "$QEMU_BIN"

    QEMU_VERSION="$("$QEMU_BIN" --version 2>/dev/null | head -1)"

    [ -n "$QEMU_VERSION" ] &&
        printf "%-20s %s\n" "Versão:" "$QEMU_VERSION"

else
    echo "QEMU system não encontrado no PATH atual."
fi

echo
echo "Configurações de CPU encontradas no projeto:"
echo

QEMU_CONFIG="$(
    grep -RIn \
        --include='*.sh' \
        --include='*.conf' \
        --include='*.cfg' \
        --include='*.ini' \
        -E '(^|[[:space:]])-cpu[[:space:]]|CPU_MODEL|cpu_model' \
        "$ROOT_DIR/tools/qemu" \
        "$ROOT_DIR/qemu" \
        "$ROOT_DIR/QEMUCenter" \
        2>/dev/null |
        head -15
)"

if [ -n "$QEMU_CONFIG" ]; then
    echo "$QEMU_CONFIG" |
        sed "s|$ROOT_DIR/||"
else
    echo "Nenhuma configuração -cpu localizada."
fi

echo

# ------------------------------------------------------------
# RESUMO
# ------------------------------------------------------------

titulo "📋 RESUMO DA CPU"

printf "%-22s %s\n" "CPU Android:" "${SOC_MODEL:-N/D}"
printf "%-22s %s\n" "Arquitetura:" "$ARCH"
printf "%-22s %s\n" "Núcleos:" "$CORES"
printf "%-22s %s\n" "ABI:" "${ABI:-N/D}"

echo
printf "%-22s %s\n" "P3XE PPU arquivos:" "$PPU_COUNT"
printf "%-22s %s\n" "P3XE SPU arquivos:" "$SPU_COUNT"

if [ -n "$QEMU_BIN" ]; then
    printf "%-22s %s\n" "QEMU:" "Detectado"
else
    printf "%-22s %s\n" "QEMU:" "Não detectado no PATH"
fi

echo
linha
echo "Pressione ENTER para voltar ao Utilities Center..."
linha

read -r < /dev/tty
