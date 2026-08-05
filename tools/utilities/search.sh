#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# Utilities Center - Procurar Arquivos
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

if [ -f "$ROOT_DIR/tools/common/init.sh" ]; then
    source "$ROOT_DIR/tools/common/init.sh"
fi

pausa() {
    echo
    read -r -p "Pressione ENTER para continuar..."
}

human_size() {
    local arquivo="$1"

    if [ -f "$arquivo" ]; then
        du -h "$arquivo" 2>/dev/null | awk '{print $1}'
    else
        echo "-"
    fi
}

while true
do
    clear

    echo "============================================================"
    echo "🔎 PROCURADOR INTELIGENTE DE ARQUIVOS"
    echo "============================================================"
    echo
    echo "Projeto : $ROOT_DIR"
    echo
    echo "1) 🔎 Procurar por nome"
    echo "2) 📄 Procurar por extensão"
    echo "3) 📦 Procurar arquivos grandes"
    echo "4) 🧩 Procurar bibliotecas .so"
    echo "5) 📱 Procurar APK"
    echo "6) 🧠 Procurar arquivos C/C++"
    echo "7) ☕ Procurar arquivos Java/Kotlin"
    echo "8) 🔧 Procurar scripts"
    echo "9) 📂 Procurar diretórios"
    echo "10) 📊 Estatísticas do projeto"
    echo
    echo "0) ← Voltar"
    echo

    read -r -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            clear
            echo "============================================================"
            echo "🔎 PROCURAR POR NOME"
            echo "============================================================"
            echo

            read -r -p "Nome ou parte do nome: " termo

            if [ -z "$termo" ]; then
                echo
                echo "❌ Pesquisa vazia."
                pausa
                continue
            fi

            echo
            echo "🔎 Procurando por: $termo"
            echo

            mapfile -t resultados < <(
                find "$ROOT_DIR" \
                    -path "$ROOT_DIR/.git" -prune -o \
                    -path "$ROOT_DIR/backups" -prune -o \
                    -iname "*$termo*" -print 2>/dev/null
            )

            total=${#resultados[@]}

            if [ "$total" -eq 0 ]; then
                echo "❌ Nenhum resultado encontrado."
            else
                echo "✅ Resultados encontrados: $total"
                echo

                contador=1

                for arquivo in "${resultados[@]}"; do
                    relativo="${arquivo#$ROOT_DIR/}"

                    printf "%4d) %s\n" "$contador" "$relativo"

                    if [ -f "$arquivo" ]; then
                        echo "      Tamanho: $(human_size "$arquivo")"
                    elif [ -d "$arquivo" ]; then
                        echo "      Tipo: diretório"
                    fi

                    ((contador++))
                done
            fi

            pausa
            ;;

        2)
            clear
            echo "============================================================"
            echo "📄 PROCURAR POR EXTENSÃO"
            echo "============================================================"
            echo

            read -r -p "Extensão (ex: cpp, h, sh, java): " ext

            ext="${ext#.}"

            if [ -z "$ext" ]; then
                echo
                echo "❌ Extensão vazia."
                pausa
                continue
            fi

            echo
            echo "🔎 Procurando *.$ext ..."
            echo

            mapfile -t resultados < <(
                find "$ROOT_DIR" \
                    -path "$ROOT_DIR/.git" -prune -o \
                    -path "$ROOT_DIR/backups" -prune -o \
                    -type f -iname "*.$ext" -print 2>/dev/null
            )

            echo "Arquivos encontrados: ${#resultados[@]}"
            echo

            for arquivo in "${resultados[@]}"; do
                echo "• ${arquivo#$ROOT_DIR/}"
            done

            pausa
            ;;

        3)
            clear
            echo "============================================================"
            echo "📦 ARQUIVOS GRANDES"
            echo "============================================================"
            echo

            read -r -p "Tamanho mínimo em MB [10]: " tamanho

            tamanho="${tamanho:-10}"

            if ! [[ "$tamanho" =~ ^[0-9]+$ ]]; then
                echo
                echo "❌ Tamanho inválido."
                pausa
                continue
            fi

            echo
            echo "Arquivos maiores que ${tamanho} MB:"
            echo

            find "$ROOT_DIR" \
                -path "$ROOT_DIR/.git" -prune -o \
                -path "$ROOT_DIR/backups" -prune -o \
                -type f -size +"${tamanho}"M \
                -exec du -h {} \; 2>/dev/null |
                sort -hr

            pausa
            ;;

        4)
            clear
            echo "============================================================"
            echo "🧩 BIBLIOTECAS NATIVAS"
            echo "============================================================"
            echo

            mapfile -t libs < <(
                find "$ROOT_DIR" \
                    -path "$ROOT_DIR/.git" -prune -o \
                    -path "$ROOT_DIR/backups" -prune -o \
                    -type f -name "*.so" -print 2>/dev/null
            )

            echo "Bibliotecas encontradas: ${#libs[@]}"
            echo

            for arquivo in "${libs[@]}"; do
                echo "• ${arquivo#$ROOT_DIR/}"
                echo "  Tamanho: $(human_size "$arquivo")"
            done

            pausa
            ;;

        5)
            clear
            echo "============================================================"
            echo "📱 APK DO PROJETO"
            echo "============================================================"
            echo

            mapfile -t apks < <(
                find "$ROOT_DIR" \
                    -path "$ROOT_DIR/.git" -prune -o \
                    -path "$ROOT_DIR/backups" -prune -o \
                    -type f -iname "*.apk" -print 2>/dev/null
            )

            echo "APK encontrados: ${#apks[@]}"
            echo

            for arquivo in "${apks[@]}"; do
                echo "• ${arquivo#$ROOT_DIR/}"
                echo "  Tamanho: $(human_size "$arquivo")"
                echo
            done

            pausa
            ;;

        6)
            clear
            echo "============================================================"
            echo "🧠 C / C++"
            echo "============================================================"
            echo

            mapfile -t codigo < <(
                find "$ROOT_DIR" \
                    -path "$ROOT_DIR/.git" -prune -o \
                    -path "$ROOT_DIR/backups" -prune -o \
                    -type f \( \
                        -iname "*.c" -o \
                        -iname "*.cc" -o \
                        -iname "*.cpp" -o \
                        -iname "*.cxx" -o \
                        -iname "*.h" -o \
                        -iname "*.hh" -o \
                        -iname "*.hpp" \
                    \) -print 2>/dev/null
            )

            echo "Arquivos C/C++ encontrados: ${#codigo[@]}"
            echo

            for arquivo in "${codigo[@]}"; do
                echo "• ${arquivo#$ROOT_DIR/}"
            done

            pausa
            ;;

        7)
            clear
            echo "============================================================"
            echo "☕ JAVA / KOTLIN"
            echo "============================================================"
            echo

            mapfile -t android_src < <(
                find "$ROOT_DIR" \
                    -path "$ROOT_DIR/.git" -prune -o \
                    -path "$ROOT_DIR/backups" -prune -o \
                    -type f \( \
                        -iname "*.java" -o \
                        -iname "*.kt" \
                    \) -print 2>/dev/null
            )

            echo "Arquivos encontrados: ${#android_src[@]}"
            echo

            for arquivo in "${android_src[@]}"; do
                echo "• ${arquivo#$ROOT_DIR/}"
            done

            pausa
            ;;

        8)
            clear
            echo "============================================================"
            echo "🔧 SCRIPTS"
            echo "============================================================"
            echo

            mapfile -t scripts < <(
                find "$ROOT_DIR" \
                    -path "$ROOT_DIR/.git" -prune -o \
                    -path "$ROOT_DIR/backups" -prune -o \
                    -type f -name "*.sh" -print 2>/dev/null
            )

            echo "Scripts encontrados: ${#scripts[@]}"
            echo

            for arquivo in "${scripts[@]}"; do
                echo "• ${arquivo#$ROOT_DIR/}"
            done

            pausa
            ;;

        9)
            clear
            echo "============================================================"
            echo "📂 DIRETÓRIOS"
            echo "============================================================"
            echo

            read -r -p "Nome do diretório: " termo

            if [ -z "$termo" ]; then
                echo
                echo "❌ Pesquisa vazia."
                pausa
                continue
            fi

            find "$ROOT_DIR" \
                -path "$ROOT_DIR/.git" -prune -o \
                -path "$ROOT_DIR/backups" -prune -o \
                -type d -iname "*$termo*" -print 2>/dev/null |
                sed "s|$ROOT_DIR/||"

            pausa
            ;;

        10)
            clear
            echo "============================================================"
            echo "📊 ESTATÍSTICAS DO PROJETO"
            echo "============================================================"
            echo

            arquivos=$(find "$ROOT_DIR" -type f 2>/dev/null | wc -l)
            diretorios=$(find "$ROOT_DIR" -type d 2>/dev/null | wc -l)

            cpp=$(find "$ROOT_DIR" -type f \
                \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
                2>/dev/null | wc -l)

            headers=$(find "$ROOT_DIR" -type f \
                \( -name "*.h" -o -name "*.hpp" -o -name "*.hh" \) \
                2>/dev/null | wc -l)

            scripts=$(find "$ROOT_DIR" -type f -name "*.sh" 2>/dev/null | wc -l)
            libs=$(find "$ROOT_DIR" -type f -name "*.so" 2>/dev/null | wc -l)
            apks=$(find "$ROOT_DIR" -type f -name "*.apk" 2>/dev/null | wc -l)

            tamanho=$(du -sh "$ROOT_DIR" 2>/dev/null | awk '{print $1}')

            echo "Tamanho total : $tamanho"
            echo "Arquivos      : $arquivos"
            echo "Diretórios    : $diretorios"
            echo
            echo "C/C++         : $cpp"
            echo "Headers       : $headers"
            echo "Scripts       : $scripts"
            echo "Bibliotecas   : $libs"
            echo "APK           : $apks"

            pausa
            ;;

        0)
            break
            ;;

        *)
            echo
            echo "❌ Opção inválida."
            pausa
            ;;
    esac
done
