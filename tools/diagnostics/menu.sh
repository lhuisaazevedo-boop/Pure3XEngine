#!/data/data/com.termux/files/usr/bin/bash

ROOT_DIR="$HOME/Pure3XEngine"

source "$ROOT_DIR/tools/common/init.sh"

run_diag() {
    local SCRIPT="$1"
    local NAME="$2"

    clear

    if [ -f "$SCRIPT" ]; then
        bash "$SCRIPT"
    else
        echo "======================================================="
        echo "❌ P3XE - MÓDULO NÃO ENCONTRADO"
        echo "======================================================="
        echo
        echo "Módulo : $NAME"
        echo "Arquivo: $SCRIPT"
        echo
        read -r -p "Pressione ENTER para voltar..."
    fi
}

while true; do
    clear

    cabecalho
    titulo "🔍 DIAGNOSTICS CENTER"
    echo "1) 🩺 Doctor Geral"
    echo "2) 🛠 CMake Doctor"
    echo "3) 📦 NDK Doctor"
    echo "4) 🔗 JNI Doctor"
    echo "5) ⚙ Gradle Doctor"
    echo "6) 📋 Relatório Inteligente"
    echo "7) 📄 Logs Manager"
    echo
    echo "0) ↩ Voltar"
    echo

    read -r -p "Escolha uma opção: " diag

    case "$diag" in

        1)
            run_diag \
                "$ROOT_DIR/tools/diagnostics/doctor_geral.sh" \
                "Doctor Geral"
            ;;

        2)
            run_diag \
                "$ROOT_DIR/tools/diagnostics/cmake_doctor.sh" \
                "CMake Doctor"
            ;;

        3)
            run_diag \
                "$ROOT_DIR/tools/diagnostics/ndk_doctor.sh" \
                "NDK Doctor"
            ;;

        4)
            run_diag \
                "$ROOT_DIR/tools/diagnostics/jni_doctor.sh" \
                "JNI Doctor"
            ;;

        5)
            run_diag \
                "$ROOT_DIR/tools/diagnostics/gradle_doctor.sh" \
                "Gradle Doctor"
            ;;

        6)
            run_diag \
                "$ROOT_DIR/tools/development/relatorio_inteligente.sh" \
                "Relatório Inteligente"
            ;;

        7)
            run_diag \
                "$ROOT_DIR/tools/diagnostics/logs_manager.sh" \
                "Logs Manager"
            ;;

        0)
            exit 0
            ;;

        *)
            echo
            echo "❌ Opção inválida: $diag"
            sleep 1
            ;;
    esac
done
