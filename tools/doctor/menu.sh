#!/data/data/com.termux/files/usr/bin/bash

ROOT="$HOME/Pure3XEngine"
DOCTOR_DIR="$ROOT/tools/doctor"

run_module() {
    local FILE="$1"
    local NAME="$2"

    clear

    if [ -f "$FILE" ]; then
        bash "$FILE"
    else
        echo "============================================================"
        echo "❌ P3XE - MÓDULO NÃO ENCONTRADO"
        echo "============================================================"
        echo
        echo "Módulo : $NAME"
        echo "Arquivo: $FILE"
        echo
        read -r -p "Pressione ENTER para voltar..."
    fi
}

while true; do
    clear

    echo "============================================================"
    echo "🩺 P3XE - DOCTOR CENTER"
    echo "============================================================"
    echo
    echo "1) 🩺 Doctor Inteligente"
    echo "2) 📦 SDK / NDK Doctor"
    echo "3) 🐘 Gradle Doctor"
    echo "4) 🔧 CMake / JNI Doctor"
    echo "5) 📊 Diagnóstico Completo"
    echo
    echo "0) ↩ Voltar"
    echo

    read -r -p "Escolha uma opção: " OP

    case "$OP" in
        1)
            run_module \
                "$DOCTOR_DIR/doctor_inteligente.sh" \
                "Doctor Inteligente"
            ;;

        2)
            run_module \
                "$DOCTOR_DIR/sdk_ndk_doctor.sh" \
                "SDK / NDK Doctor"
            ;;

        3)
            run_module \
                "$DOCTOR_DIR/gradle_doctor.sh" \
                "Gradle Doctor"
            ;;

        4)
            run_module \
                "$DOCTOR_DIR/cmake_jni_doctor.sh" \
                "CMake / JNI Doctor"
            ;;

        5)
            run_module \
                "$DOCTOR_DIR/diagnostico_completo.sh" \
                "Diagnóstico Completo"
            ;;

        0)
            exit 0
            ;;

        *)
            echo
            echo "❌ Opção inválida: $OP"
            sleep 1
            ;;
    esac
done
