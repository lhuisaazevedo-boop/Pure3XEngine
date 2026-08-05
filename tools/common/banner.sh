 #!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# BANNERS P3XE
# ==========================================================

banner() {
    clear

    linha
    echo -e "${AZUL_CLARO}🎮 PAINEL DE CONTROLE P3XE${RESET}"
    echo -e "${CIANO}${P3XE_NAME} ${P3XE_VERSION}${RESET}"
    linha

    echo
    echo -e "${VERDE}📅 Data:${RESET} $(date +"%d/%m/%Y")"
    echo -e "${VERDE}🕒 Hora:${RESET} $(date +"%H:%M:%S")"
    echo -e "${VERDE}📂 Projeto:${RESET} ${PROJECT_DIR}"
    echo
}

cabecalho() {
    banner
}

titulo_menu() {
    echo
    linha
    echo -e "${AMARELO}$1${RESET}"
    linha
    echo
}
