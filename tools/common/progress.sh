#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# PROGRESS BAR P3XE
# ==========================================================

progress_bar() {

    local porcentagem=$1
    local texto="$2"

    local total=40
    local preenchido=$((porcentagem * total / 100))
    local vazio=$((total - preenchido))

    printf "\r${CIANO}["

    for ((i=0;i<preenchido;i++)); do
        printf "█"
    done

    for ((i=0;i<vazio;i++)); do
        printf "░"
    done

    printf "]${RESET} %3d%% %s" "$porcentagem" "$texto"
}

fim_progress() {
    echo
}
