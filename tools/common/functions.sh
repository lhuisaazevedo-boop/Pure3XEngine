#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# FUNÇÕES P3XE
# ==========================================================

clear_screen() {
    clear
}

linha() {
    printf '%*s\n' "${COLUMNS:-60}" '' | tr ' ' '='
}

titulo() {
    linha
    echo -e "${CIANO}$1${RESET}"
    linha
}

sucesso() {
    echo -e "${VERDE}✔ $1${RESET}"
}

erro() {
    echo -e "${VERMELHO}✘ $1${RESET}"
}

aviso() {
    echo -e "${AMARELO}⚠ $1${RESET}"
}

info() {
    echo -e "${AZUL}ℹ $1${RESET}"
}

pausa() {
    echo
    read -p "Pressione ENTER para continuar..."
}
