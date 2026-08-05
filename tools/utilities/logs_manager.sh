#!/data/data/com.termux/files/usr/bin/bash

clear

############################################
# P3XE LOG CENTER
############################################

PROJETO_ROOT="/data/data/com.termux/files/home/Pure3XEngine"
LOGS="$PROJETO_ROOT/logs"
EXPORT="$HOME/storage/shared/Pure3XEngine/Logs"

mkdir -p "$LOGS"
mkdir -p "$EXPORT"

############################################
# CORES
############################################

VERDE="\033[1;32m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
AZUL="\033[1;34m"
CIANO="\033[1;36m"
RESET="\033[0m"

############################################
# PAUSA
############################################

pausa() {
    echo
    read -p "Pressione ENTER para continuar..."
}

############################################
# ÚLTIMO BUILD
############################################

ultimo_build() {

ls -t "$LOGS"/build_*.log 2>/dev/null | head -n1

}

############################################
# ÚLTIMO RELATÓRIO
############################################

ultimo_relatorio() {

ls -t "$LOGS"/relatorio_*.txt 2>/dev/null | head -n1

}

############################################
# CABEÇALHO
############################################

cabecalho(){

clear

TOTAL=$(find "$LOGS" -type f | wc -l)

BUILD=$(find "$LOGS" -name "build_*.log" | wc -l)

REL=$(find "$LOGS" -name "relatorio_*.txt" | wc -l)

TAM=$(du -sh "$LOGS" | cut -f1)

ULT=$(basename "$(ultimo_build)" 2>/dev/null)

RELATORIO=$(basename "$(ultimo_relatorio)" 2>/dev/null)

echo -e "${AZUL}"
echo "=========================================================="
echo "              📂 P3XE LOG CENTER"
echo "=========================================================="
echo -e "${RESET}"

echo "Projeto........: Pure3XEngine"
echo "Diretório......: $LOGS"
echo

echo "Logs Build.....: $BUILD"
echo "Relatórios.....: $REL"
echo "Total Arquivos.: $TOTAL"
echo "Espaço Usado...: $TAM"

echo

echo "Último Build...: ${ULT:-Nenhum}"

echo "Último Relatório: ${RELATORIO:-Nenhum}"

echo

echo "=========================================================="

echo

echo " 1) 📜 Listar todos os logs"
echo " 2) 🔍 Abrir último log"
echo " 3) ❌ Mostrar somente ERROS"
echo " 4) ⚠ Mostrar somente WARNINGS"
echo " 5) 📄 Abrir último relatório"
echo " 6) 🔎 Pesquisar texto"
echo " 7) 📊 Estatísticas do último Build"
echo " 8) 📈 Histórico dos Builds"
echo " 9) 📦 Compactar Logs"
echo "10) 📤 Exportar último Log"
echo "11) 🧹 Limpar logs antigos"
echo "12) 🗑 Limpar TODOS os Logs"
echo "13) 📂 Abrir pasta de Logs"

echo

echo "0) ↩ Voltar"

echo

echo -ne "${AMARELO}Escolha uma opção: ${RESET}"

}

############################################
# LOOP PRINCIPAL
############################################

while true
do

cabecalho

read OP

case "$OP" in

1)
    clear
    echo -e "${AZUL}========== TODOS OS LOGS ==========${RESET}"
    ls -lhtr "$LOGS"
    pausa
;;

2)
    clear

    ULTIMO=$(ultimo_build)

    if [ -f "$ULTIMO" ]; then
        echo -e "${AZUL}========== ÚLTIMO BUILD ==========${RESET}"
        echo
        cat "$ULTIMO" | less
    else
        echo -e "${VERMELHO}Nenhum log encontrado.${RESET}"
    fi

    pausa
;;

3)
    clear

    ULTIMO=$(ultimo_build)

    if [ -f "$ULTIMO" ]; then
        echo -e "${VERMELHO}========== ERROS ==========${RESET}"
        echo

        grep -niE \
        "error|failed|exception|fatal|undefined|cannot|not found|missing|AAPT2|CMake Error|FAIL" \
        "$ULTIMO"

    else
        echo "Nenhum log encontrado."
    fi

    pausa
;;

4)
    clear

    ULTIMO=$(ultimo_build)

    if [ -f "$ULTIMO" ]; then

        echo -e "${AMARELO}========== WARNINGS ==========${RESET}"
        echo

        grep -niE \
        "warning|deprecated|obsolete|note|ignored" \
        "$ULTIMO"

    else
        echo "Nenhum log encontrado."
    fi

    pausa
;;

5)
    clear

    RELATORIO=$(ultimo_relatorio)

    if [ -f "$RELATORIO" ]; then

        echo -e "${AZUL}========== ÚLTIMO RELATÓRIO ==========${RESET}"
        echo

        cat "$RELATORIO"

    else

        echo "Nenhum relatório encontrado."

    fi

    pausa
;;

6)
    clear

    echo "Pesquisar texto:"
    read TEXTO

    echo

    grep -Rni "$TEXTO" "$LOGS"

    pausa
;;

7)
    clear

    ULTIMO=$(ultimo_build)

    if [ -f "$ULTIMO" ]; then

        TOTAL=$(wc -l < "$ULTIMO")

        ERROS=$(grep -ic "error" "$ULTIMO")

        WARN=$(grep -ic "warning" "$ULTIMO")

        FAIL=$(grep -ic "failed" "$ULTIMO")

        echo -e "${CIANO}"
        echo "========== ESTATÍSTICAS =========="
        echo -e "${RESET}"

        echo "Arquivo........: $(basename "$ULTIMO")"
        echo
        echo "Linhas.........: $TOTAL"
        echo "Errors.........: $ERROS"
        echo "Warnings.......: $WARN"
        echo "Failed.........: $FAIL"

    else

        echo "Nenhum log encontrado."

    fi

    pausa
;;

8)
    clear

    echo -e "${AZUL}========== HISTÓRICO DE BUILDS ==========${RESET}"
    echo

    ls -lhtr "$LOGS"/build_*.log 2>/dev/null

    pausa
;;

9)
    clear

    echo -e "${AMARELO}Compactando logs...${RESET}"
    echo

    ARQUIVO="$LOGS/logs_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

    tar -czf "$ARQUIVO" "$LOGS"/*.log "$LOGS"/*.txt 2>/dev/null

    echo
    echo -e "${VERDE}Backup criado:${RESET}"
    echo "$ARQUIVO"

    pausa
;;

10)
    clear

    DESTINO="/storage/emulated/0/Pure3XEngine"

    mkdir -p "$DESTINO"

    cp "$LOGS"/*.log "$DESTINO" 2>/dev/null
    cp "$LOGS"/*.txt "$DESTINO" 2>/dev/null

    echo -e "${VERDE}Logs exportados para:${RESET}"
    echo "$DESTINO"

    pausa
;;

11)
    clear

    echo -e "${AMARELO}Removendo logs com mais de 7 dias...${RESET}"

    find "$LOGS" -type f -mtime +7 -delete

    echo
    echo -e "${VERDE}Limpeza concluída.${RESET}"

    pausa
;;

12)
    clear

    echo -e "${VERMELHO}ATENÇÃO!${RESET}"
    echo
    echo "Isso apagará TODOS os logs."
    echo
    read -p "Deseja continuar? (S/N): " RESP

    if [[ "$RESP" == "S" || "$RESP" == "s" ]]; then
        rm -f "$LOGS"/*.log
        rm -f "$LOGS"/*.txt

        echo
        echo -e "${VERDE}Todos os logs foram removidos.${RESET}"
    else
        echo
        echo -e "${AMARELO}Operação cancelada.${RESET}"
    fi

    pausa
;;

13)
    break
;;

*)

    echo
    echo -e "${VERMELHO}Opção inválida.${RESET}"
    sleep 1
;;

esac

done
