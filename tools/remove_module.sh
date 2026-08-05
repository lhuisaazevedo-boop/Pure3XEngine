#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# P3XE - Smart Modules
# Opção 4 - Remover módulo
# ============================================================

ROOT_DIR="${ROOT_DIR:-$HOME/Pure3XEngine}"

clear

echo "============================================================"
echo "❌ P3XE - REMOVER MÓDULO"
echo "============================================================"
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo

# ------------------------------------------------------------
# Diretórios que NUNCA podem ser removidos por este utilitário
# ------------------------------------------------------------

PROTECTED=(
    "CoreEmulator"
    "Cubo3D"
    "QEMUCenter"
    "android"
    "Config"
    "tools"
    ".git"
    "logs"
)

echo "🛡️ PROTEÇÃO"
echo "------------------------------------------------------------"
echo "Módulos principais do P3XE não podem ser removidos."
echo

# ------------------------------------------------------------
# Descobrir módulos removíveis
# ------------------------------------------------------------

AVAILABLE=()

while IFS= read -r DIR; do

    NAME="$(basename "$DIR")"
    IS_PROTECTED=0

    for ITEM in "${PROTECTED[@]}"; do
        if [ "$NAME" = "$ITEM" ]; then
            IS_PROTECTED=1
            break
        fi
    done

    if [ "$IS_PROTECTED" -eq 0 ]; then

        # Só considera módulo se possuir estrutura conhecida.
        if [ -f "$DIR/CMakeLists.txt" ] || \
           [ -d "$DIR/src" ] || \
           [ -d "$DIR/include" ]; then

            AVAILABLE+=("$NAME")
        fi
    fi

done < <(find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)

echo "📦 MÓDULOS REMOVÍVEIS"
echo "------------------------------------------------------------"

if [ "${#AVAILABLE[@]}" -eq 0 ]; then
    echo "Nenhum módulo removível encontrado."
    echo
    echo "============================================================"
    echo "✅ Nenhuma alteração realizada."
    echo "============================================================"
    echo
    read -r -p "Pressione ENTER para voltar..."
    exit 0
fi

for ((i=0; i<${#AVAILABLE[@]}; i++)); do
    printf "%d) %s\n" "$((i + 1))" "${AVAILABLE[$i]}"
done

echo
echo "0) ↩ Voltar"
echo
echo "------------------------------------------------------------"

read -r -p "Número do módulo: " OPTION

if [ "$OPTION" = "0" ]; then
    exit 0
fi

# Somente números
if [[ ! "$OPTION" =~ ^[0-9]+$ ]]; then
    echo
    echo "❌ Opção inválida."
    echo
    read -r -p "Pressione ENTER para voltar..."
    exit 1
fi

INDEX=$((OPTION - 1))

if [ "$INDEX" -lt 0 ] || [ "$INDEX" -ge "${#AVAILABLE[@]}" ]; then
    echo
    echo "❌ Módulo inexistente."
    echo
    read -r -p "Pressione ENTER para voltar..."
    exit 1
fi

MODULE="${AVAILABLE[$INDEX]}"
MODULE_DIR="$ROOT_DIR/$MODULE"

echo
echo "⚠️ CONFIRMAÇÃO DE SEGURANÇA"
echo "------------------------------------------------------------"
echo "Módulo  : $MODULE"
echo "Caminho : $MODULE_DIR"

CPP=$(find "$MODULE_DIR" -type f \
    \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
    2>/dev/null | wc -l)

HEADERS=$(find "$MODULE_DIR" -type f \
    \( -name "*.h" -o -name "*.hpp" \) \
    2>/dev/null | wc -l)

FILES=$(find "$MODULE_DIR" -type f 2>/dev/null | wc -l)

SIZE=$(du -sh "$MODULE_DIR" 2>/dev/null | awk '{print $1}')

echo
echo "C++      : $CPP"
echo "Headers  : $HEADERS"
echo "Arquivos : $FILES"
echo "Tamanho  : ${SIZE:-0}"
echo

echo "⚠️ Esta operação apagará o diretório inteiro."
echo

read -r -p "Digite o nome '$MODULE' para confirmar: " CONFIRM

if [ "$CONFIRM" != "$MODULE" ]; then
    echo
    echo "↩️ Remoção cancelada."
    echo "Nenhum arquivo foi alterado."
    echo
    read -r -p "Pressione ENTER para voltar..."
    exit 0
fi

# ------------------------------------------------------------
# Última verificação antes do rm
# ------------------------------------------------------------

for ITEM in "${PROTECTED[@]}"; do
    if [ "$MODULE" = "$ITEM" ]; then
        echo
        echo "🛡️ BLOQUEADO: módulo protegido."
        echo
        read -r -p "Pressione ENTER para voltar..."
        exit 1
    fi
done

# Garante que o caminho continua dentro da raiz do projeto.
case "$MODULE_DIR" in
    "$ROOT_DIR"/*)
        ;;
    *)
        echo
        echo "❌ Caminho inseguro detectado."
        echo "Remoção bloqueada."
        echo
        read -r -p "Pressione ENTER para voltar..."
        exit 1
        ;;
esac

rm -rf -- "$MODULE_DIR"

if [ -e "$MODULE_DIR" ]; then

    echo
    echo "❌ Falha ao remover o módulo."

else

    echo
    echo "============================================================"
    echo "✅ MÓDULO REMOVIDO"
    echo "============================================================"
    echo "Nome : $MODULE"
    echo "Data : $(date '+%d/%m/%Y')"
    echo "Hora : $(date '+%H:%M:%S')"
    echo "============================================================"

fi

echo
read -r -p "Pressione ENTER para voltar..."
