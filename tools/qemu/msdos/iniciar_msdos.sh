#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Pure3XEngine
# QEMU Center - Inicializador do MS-DOS
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"

while [ "$ROOT_DIR" != "/" ]; do
    if [ -d "$ROOT_DIR/tools" ] &&
       [ -d "$ROOT_DIR/qemu" ] &&
       [ -f "$ROOT_DIR/tools/common/init.sh" ]; then
        break
    fi

    ROOT_DIR="$(dirname "$ROOT_DIR")"
done

if [ ! -f "$ROOT_DIR/tools/common/init.sh" ]; then
    echo
    echo "=============================================="
    echo "Erro: Pure3XEngine não encontrado."
    echo "SCRIPT_DIR = $SCRIPT_DIR"
    echo "ROOT_DIR   = $ROOT_DIR"
    echo "=============================================="
    exit 1
fi

source "$ROOT_DIR/tools/common/init.sh"

MSDOS_DIR="$ROOT_DIR/tools/qemu/msdos"
VM_DIR="$ROOT_DIR/qemu/vms/msdos"

mkdir -p "$VM_DIR"

while true
do
    clear
    cabecalho

    echo "=============================================================="
    echo "                     INICIAR MS-DOS"
    echo "=============================================================="
    echo
    echo "📁 Máquina Virtual:"
    echo "   $VM_DIR"
    echo
    echo "1) ▶ Iniciar MS-DOS"
    echo "2) 📋 Ver Configuração"
    echo "3) 💿 Ver ISO Selecionada"
    echo "4) 💾 Ver Disco Virtual"
    echo "5) 🔎 Diagnóstico"
    echo "6) 💾 Instalar MS-DOS 6.22 (3 Disquetes)"

    echo "0) ↩ Voltar"
    echo

    read -rp "Escolha uma opção: " opcao

    case "$opcao" in

1)
    clear
    cabecalho

    echo "=========================================================="
    echo "                    INICIANDO MS-DOS"
    echo "=========================================================="
    echo

    EXECUTAR="$MSDOS_DIR/executar_msdos.sh"

    # Verifica se o inicializador existe
    if [ ! -f "$EXECUTAR" ]; then
        erro "Script executar_msdos.sh não encontrado."
        echo
        echo "Esperado em:"
        echo "$EXECUTAR"
        echo
        pausa
        continue
    fi

    # Garante permissão de execução
    if [ ! -x "$EXECUTAR" ]; then
        chmod +x "$EXECUTAR"
    fi

    echo "Verificando máquina virtual..."
    echo

    # Disco virtual
    DISCO=$(find "$VM_DIR" -maxdepth 1 -type f \
        \( -iname "*.qcow2" -o -iname "*.img" -o -iname "*.raw" \) \
        -print -quit 2>/dev/null)

    if [ -z "$DISCO" ] || [ ! -f "$DISCO" ]; then
        erro "Disco virtual não encontrado."
        echo
        pausa
        continue
    fi

    echo "[✓] Disco: $(basename "$DISCO")"

    # ISO
    ISO_CONF="$VM_DIR/iso.conf"
    ISO=""

    if [ -f "$ISO_CONF" ]; then
        source "$ISO_CONF"
    fi

    if [ -z "$ISO" ] || [ ! -f "$ISO" ]; then
        erro "ISO não configurada ou não encontrada."
        echo
        pausa
        continue
    fi

    echo "[✓] ISO:   $(basename "$ISO")"

    # Display
    if [ -n "${DISPLAY:-}" ]; then
        echo "[✓] Termux:X11: $DISPLAY"
        echo "[✓] Backend: SDL"
    else
        echo "[!] Termux:X11 não detectado."
        echo "[✓] Backend: curses"
    fi

    echo
    echo "=========================================================="
    echo "VM pronta."
    echo "=========================================================="
    echo

    read -rp "Deseja iniciar agora? (S/N): " resp

    if [[ "$resp" =~ ^[Ss]$ ]]; then
        echo
        "$EXECUTAR"

        echo
        pausa
    else
        aviso "Inicialização cancelada."
        echo
        pausa
    fi
    ;;

2)
    clear
    cabecalho

    echo "=========================================================="
    echo "                    CONFIGURAÇÃO DA VM"
    echo "=========================================================="
    echo

    VM_NOME="$(basename "$VM_DIR")"

    # ------------------------------------------------------
    # Informações gerais
    # ------------------------------------------------------

    echo "📁 Máquina Virtual:"
    echo "   $VM_NOME"
    echo

    echo "📂 Diretório:"
    echo "   $VM_DIR"
    echo

    # ------------------------------------------------------
    # Função para exibir arquivos de configuração
    # ------------------------------------------------------

    mostrar_config() {
        local titulo="$1"
        local arquivo="$2"

        printf "%-18s : " "$titulo"

        if [ -f "$arquivo" ]; then
            if [ -s "$arquivo" ]; then
                local valor
                valor=$(grep -v '^[[:space:]]*#' "$arquivo" \
                    | grep -v '^[[:space:]]*$' \
                    | head -n 1)

                if [ -n "$valor" ]; then
                    echo "$valor"
                else
                    echo "configurado"
                fi
            else
                echo "arquivo vazio"
            fi
        else
            echo "não configurado"
        fi
    }

    echo "---------------- CONFIGURAÇÕES ----------------"
    echo

    mostrar_config "Sistema"        "$VM_DIR/msdos.conf"
    mostrar_config "CPU"            "$VM_DIR/cpu.conf"
    mostrar_config "Memória"        "$VM_DIR/memoria.conf"
    mostrar_config "Vídeo"          "$VM_DIR/video.conf"
    mostrar_config "Áudio"          "$VM_DIR/audio.conf"
    mostrar_config "Rede"           "$VM_DIR/rede.conf"
    mostrar_config "Boot"           "$VM_DIR/boot.conf"
    mostrar_config "Armazenamento"  "$VM_DIR/armazenamento.conf"
    mostrar_config "Periféricos"    "$VM_DIR/perifericos.conf"

    echo
    echo "---------------- ARMAZENAMENTO ----------------"
    echo

    # Disco
    DISCO_CONF="$VM_DIR/disco.conf"
    DISCO=""

    if [ -f "$DISCO_CONF" ]; then
        source "$DISCO_CONF"
    fi

    if [ -n "$DISCO" ] && [ -f "$DISCO" ]; then
        echo "💾 Disco:"
        echo "   $(basename "$DISCO")"
        echo "   Tamanho: $(du -h "$DISCO" | cut -f1)"
    else
        echo "💾 Disco: não configurado"
    fi

    echo

    # ISO
    ISO_CONF="$VM_DIR/iso.conf"
    ISO=""

    if [ -f "$ISO_CONF" ]; then
        source "$ISO_CONF"
    fi

    if [ -n "$ISO" ] && [ -f "$ISO" ]; then
        echo "💿 ISO:"
        echo "   $(basename "$ISO")"
    else
        echo "💿 ISO: não configurada"
    fi

    echo
    echo "---------------- DISPLAY ----------------"
    echo

    if [ -n "${DISPLAY:-}" ]; then
        echo "🖥️ Termux:X11 : ativo"
        echo "   DISPLAY     : $DISPLAY"
        echo "   Backend     : SDL/GTK"
    else
        echo "⌨️ Termux:X11 : não detectado"
        echo "   Backend     : curses"
    fi

    echo
    echo "=========================================================="
    echo

    pausa
    ;;

3)
    clear
    cabecalho

    echo "=========================================================="
    echo "                    ISO SELECIONADA"
    echo "=========================================================="
    echo

    ISO_CONF="$VM_DIR/iso.conf"
    ISO=""

    # ------------------------------------------------------
    # Carrega a ISO configurada
    # ------------------------------------------------------
    if [ -f "$ISO_CONF" ]; then
        source "$ISO_CONF"
    fi

    if [ -z "$ISO" ]; then
        aviso "Nenhuma ISO configurada para esta máquina."
        echo
        pausa
        continue
    fi

    if [ ! -f "$ISO" ]; then
        erro "A ISO configurada não existe."
        echo
        echo "Caminho salvo:"
        echo "$ISO"
        echo
        pausa
        continue
    fi

    # ------------------------------------------------------
    # Informações reais do arquivo
    # ------------------------------------------------------

    VM_NOME="$(basename "$VM_DIR")"
    ISO_NOME="$(basename "$ISO")"

    TAMANHO="$(du -h "$ISO" 2>/dev/null | cut -f1)"
    TAMANHO_BYTES="$(stat -c %s "$ISO" 2>/dev/null)"
    MODIFICADO="$(date -r "$ISO" "+%d/%m/%Y às %H:%M:%S" 2>/dev/null)"

    # Tipo real detectado pelo sistema
    if command -v file >/dev/null 2>&1; then
        TIPO="$(file -b "$ISO" 2>/dev/null)"
    else
        TIPO="comando 'file' não instalado"
    fi

    # ------------------------------------------------------
    # Status
    # ------------------------------------------------------

    echo "✓ ISO encontrada e acessível."
    echo

    printf "%-18s : %s\n" "Máquina" "$VM_NOME"
    printf "%-18s : %s\n" "Arquivo" "$ISO_NOME"
    printf "%-18s : %s\n" "Tamanho" "$TAMANHO"
    printf "%-18s : %s bytes\n" "Tamanho real" "$TAMANHO_BYTES"
    printf "%-18s : %s\n" "Modificado" "$MODIFICADO"

    echo
    echo "---------------- CAMINHO ----------------"
    echo
    echo "$ISO"

    echo
    echo "---------------- TIPO DETECTADO ----------------"
    echo
    echo "$TIPO"

    # ------------------------------------------------------
    # Informações ISO 9660
    # ------------------------------------------------------

    echo
    echo "---------------- SISTEMA DE ARQUIVOS ----------------"
    echo

    if command -v isoinfo >/dev/null 2>&1; then

        VOLUME_ID="$(
            isoinfo -d -i "$ISO" 2>/dev/null |
            sed -n 's/^Volume id: //p' |
            head -n1
        )"

        SYSTEM_ID="$(
            isoinfo -d -i "$ISO" 2>/dev/null |
            sed -n 's/^System id: //p' |
            head -n1
        )"

        BOOTABLE="$(
            isoinfo -d -i "$ISO" 2>/dev/null |
            grep -i "El Torito" |
            head -n1
        )"

        [ -n "$VOLUME_ID" ] &&
            printf "%-18s : %s\n" "Volume" "$VOLUME_ID"

        [ -n "$SYSTEM_ID" ] &&
            printf "%-18s : %s\n" "Sistema" "$SYSTEM_ID"

        if [ -n "$BOOTABLE" ]; then
            printf "%-18s : %s\n" "Boot" "ISO inicializável"
        else
            printf "%-18s : %s\n" "Boot" "não detectado"
        fi

    else
        echo "isoinfo não instalado."
        echo "Informações ISO 9660 avançadas indisponíveis."
    fi

    # ------------------------------------------------------
    # Hash SHA-256
    # ------------------------------------------------------

    echo
    echo "---------------- INTEGRIDADE ----------------"
    echo

    if command -v sha256sum >/dev/null 2>&1; then
        echo "SHA-256:"
        sha256sum "$ISO" | awk '{print $1}'
    else
        echo "SHA-256 indisponível."
    fi

    echo
    echo "=========================================================="
    echo "✓ ISO pronta para uso pelo QEMU."
    echo "=========================================================="
    echo

    pausa
    ;;

4)
    clear
    cabecalho

    echo "=========================================================="
    echo "                     DISCO VIRTUAL"
    echo "=========================================================="
    echo

    VM_NOME="$(basename "$VM_DIR")"

    DISCO_CONF="$VM_DIR/disco.conf"
    DISCO=""

    # ------------------------------------------------------
    # Carrega disco configurado
    # ------------------------------------------------------
    if [ -f "$DISCO_CONF" ]; then
        source "$DISCO_CONF"
    fi

    # Se disco.conf não possuir um caminho válido,
    # tenta localizar automaticamente
    if [ -z "$DISCO" ] || [ ! -f "$DISCO" ]; then
        DISCO=$(find "$VM_DIR" -maxdepth 1 -type f \
            \( -iname "*.qcow2" \
            -o -iname "*.img" \
            -o -iname "*.raw" \) \
            -print -quit 2>/dev/null)
    fi

    # ------------------------------------------------------
    # Verifica existência
    # ------------------------------------------------------
    if [ -z "$DISCO" ]; then
        aviso "Nenhum disco virtual configurado."
        echo
        pausa
        continue
    fi

    if [ ! -f "$DISCO" ]; then
        erro "O disco virtual configurado não existe."
        echo
        echo "Caminho salvo:"
        echo "$DISCO"
        echo
        pausa
        continue
    fi

    # ------------------------------------------------------
    # Informações básicas reais
    # ------------------------------------------------------
    DISCO_NOME="$(basename "$DISCO")"
    TAMANHO_ARQUIVO="$(du -h "$DISCO" 2>/dev/null | cut -f1)"
    BYTES="$(stat -c %s "$DISCO" 2>/dev/null)"
    MODIFICADO="$(date -r "$DISCO" "+%d/%m/%Y às %H:%M:%S" 2>/dev/null)"
    PERMISSOES="$(stat -c %A "$DISCO" 2>/dev/null)"

    if command -v file >/dev/null 2>&1; then
        TIPO="$(file -b "$DISCO" 2>/dev/null)"
    else
        TIPO="detecção indisponível"
    fi

    echo "✓ Disco virtual encontrado."
    echo

    printf "%-18s : %s\n" "Máquina" "$VM_NOME"
    printf "%-18s : %s\n" "Arquivo" "$DISCO_NOME"
    printf "%-18s : %s\n" "Espaço ocupado" "$TAMANHO_ARQUIVO"
    printf "%-18s : %s bytes\n" "Arquivo real" "$BYTES"
    printf "%-18s : %s\n" "Modificado" "$MODIFICADO"
    printf "%-18s : %s\n" "Permissões" "$PERMISSOES"

    echo
    echo "---------------- CAMINHO ----------------"
    echo
    echo "$DISCO"

    echo
    echo "---------------- TIPO DETECTADO ----------------"
    echo
    echo "$TIPO"

    # ------------------------------------------------------
    # Informações fornecidas pelo QEMU
    # ------------------------------------------------------
    echo
    echo "---------------- QEMU-IMG ----------------"
    echo

    if command -v qemu-img >/dev/null 2>&1; then

        QEMU_INFO="$(qemu-img info "$DISCO" 2>/dev/null)"

        if [ -n "$QEMU_INFO" ]; then

            FORMATO="$(
                echo "$QEMU_INFO" |
                sed -n 's/^file format: //p' |
                head -n1
            )"

            TAMANHO_VIRTUAL="$(
                echo "$QEMU_INFO" |
                sed -n 's/^virtual size: //p' |
                head -n1
            )"

            TAMANHO_DISCO="$(
                echo "$QEMU_INFO" |
                sed -n 's/^disk size: //p' |
                head -n1
            )"

            CLUSTER="$(
                echo "$QEMU_INFO" |
                sed -n 's/^cluster_size: //p' |
                head -n1
            )"

            printf "%-18s : %s\n" \
                "Formato" "${FORMATO:-desconhecido}"

            printf "%-18s : %s\n" \
                "Capacidade virtual" "${TAMANHO_VIRTUAL:-desconhecida}"

            printf "%-18s : %s\n" \
                "Uso real" "${TAMANHO_DISCO:-desconhecido}"

            if [ -n "$CLUSTER" ]; then
                printf "%-18s : %s bytes\n" \
                    "Cluster" "$CLUSTER"
            fi

        else
            echo "Não foi possível consultar o disco com qemu-img."
        fi

    else
        echo "qemu-img não encontrado."
    fi

    # ------------------------------------------------------
    # Verificação estrutural QCOW2
    # ------------------------------------------------------
    echo
    echo "---------------- INTEGRIDADE ----------------"
    echo

    if command -v qemu-img >/dev/null 2>&1; then

        FORMATO_REAL="$(
            qemu-img info "$DISCO" 2>/dev/null |
            sed -n 's/^file format: //p' |
            head -n1
        )"

        if [ "$FORMATO_REAL" = "qcow2" ]; then

            CHECK_OUTPUT="$(qemu-img check "$DISCO" 2>&1)"
            CHECK_STATUS=$?

            if [ "$CHECK_STATUS" -eq 0 ]; then
                echo "✓ Estrutura QCOW2 íntegra."
            else
                echo "⚠ qemu-img encontrou inconsistências:"
                echo
                echo "$CHECK_OUTPUT"
            fi

        else
            echo "Verificação estrutural específica não necessária."
            echo "Formato detectado: ${FORMATO_REAL:-desconhecido}"
        fi

    else
        echo "Verificação indisponível."
    fi

    # ------------------------------------------------------
    # Status final
    # ------------------------------------------------------
    echo
    echo "=========================================================="
    echo "✓ Disco virtual pronto para uso pelo QEMU."
    echo "=========================================================="
    echo

    pausa
    ;;

5)
    clear
    cabecalho

    echo "=========================================================="
    echo "              VARREDURA DO SISTEMA MS-DOS"
    echo "=========================================================="
    echo

    ERROS=0
    AVISOS=0

    print_status() {
        local status="$1"
        local label="$2"
        local info="$3"
        printf "%-4s %-20s %s\n" "$status" "$label" "$info"
    }

    # ======================================================
    # QEMU
    # ======================================================
    echo "---------------- EMULADOR ----------------"
    echo

    if command -v qemu-system-i386 >/dev/null 2>&1; then
        QEMU_BIN="$(command -v qemu-system-i386)"
        QEMU_VERSION="$(qemu-system-i386 --version 2>/dev/null | head -n1)"

        print_status "[✓]" "QEMU" "encontrado"
        print_status "   " "Executável" "$QEMU_BIN"
        print_status "   " "Versão" "$QEMU_VERSION"
    else
        print_status "[x]" "QEMU" "não encontrado"
        ERROS=$((ERROS + 1))
    fi

    echo

    # ======================================================
    # DISCO DO MS-DOS
    # ======================================================
    echo "---------------- DISCO MS-DOS ----------------"
    echo

    DISCO_CONF="$VM_DIR/disco.conf"
    DISCO=""

    [ -f "$DISCO_CONF" ] && source "$DISCO_CONF"

    if [ -z "$DISCO" ] || [ ! -f "$DISCO" ]; then
        DISCO=$(find "$VM_DIR" -maxdepth 1 -type f \
            \( -iname "*.qcow2" \
            -o -iname "*.img" \
            -o -iname "*.raw" \) \
            -print -quit 2>/dev/null)
    fi

    if [ -n "$DISCO" ] && [ -f "$DISCO" ]; then
        print_status "[✓]" "Disco" "$(basename "$DISCO")"

        if command -v qemu-img >/dev/null 2>&1; then
            FORMATO="$(
                qemu-img info "$DISCO" 2>/dev/null |
                sed -n 's/^file format: //p' |
                head -n1
            )"

            VIRTUAL="$(
                qemu-img info "$DISCO" 2>/dev/null |
                sed -n 's/^virtual size: //p' |
                head -n1
            )"

            print_status "   " "Formato" "${FORMATO:-desconhecido}"
            print_status "   " "Capacidade" "${VIRTUAL:-desconhecida}"

            if [ "$FORMATO" = "qcow2" ]; then
                if qemu-img check "$DISCO" >/dev/null 2>&1; then
                    print_status "[✓]" "Integridade" "QCOW2 válida"
                else
                    print_status "[x]" "Integridade" "problema detectado"
                    ERROS=$((ERROS + 1))
                fi
            fi
        fi
    else
        print_status "[x]" "Disco" "não encontrado"
        ERROS=$((ERROS + 1))
    fi

    echo

    # ======================================================
    # ISO DO MS-DOS
    # ======================================================
    echo "---------------- MÍDIA MS-DOS ----------------"
    echo

    ISO_CONF="$VM_DIR/iso.conf"
    ISO=""

    [ -f "$ISO_CONF" ] && source "$ISO_CONF"

    ISO="${ISO:-${iso:-}}"

    if [ -z "$ISO" ] || [ ! -f "$ISO" ]; then
        ISO=$(find "$ROOT_DIR/qemu/isos" \
            -maxdepth 1 \
            -type f \
            -iname "*.iso" \
            -print -quit 2>/dev/null)
    fi

    if [ -n "$ISO" ] && [ -f "$ISO" ]; then
        print_status "[✓]" "ISO" "$(basename "$ISO")"
        print_status "   " "Tamanho" "$(du -h "$ISO" | cut -f1)"

        if command -v file >/dev/null 2>&1; then
            ISO_TIPO="$(file -b "$ISO" 2>/dev/null)"
            print_status "   " "Tipo" "$ISO_TIPO"
        fi
    else
        print_status "[!]" "ISO" "não encontrada"
        AVISOS=$((AVISOS + 1))
    fi

    echo

    # ======================================================
    # ARQUIVOS DE CONFIGURAÇÃO DA VM MS-DOS
    # ======================================================
    echo "---------------- CONFIGURAÇÃO MS-DOS ----------------"
    echo

    verificar_conf() {
        local arquivo="$1"
        local nome="$2"

        if [ -f "$VM_DIR/$arquivo" ]; then
            if [ -s "$VM_DIR/$arquivo" ]; then
                print_status "[✓]" "$nome" "$arquivo"
            else
                print_status "[!]" "$nome" "$arquivo vazio"
                AVISOS=$((AVISOS + 1))
            fi
        else
            print_status "[x]" "$nome" "$arquivo ausente"
            ERROS=$((ERROS + 1))
        fi
    }

    verificar_conf "msdos.conf"       "Sistema"
    verificar_conf "boot.conf"        "Boot"
    verificar_conf "cpu.conf"         "CPU"
    verificar_conf "memoria.conf"     "Memória"
    verificar_conf "video.conf"       "Vídeo"
    verificar_conf "audio.conf"       "Áudio"
    verificar_conf "rede.conf"        "Rede"
    verificar_conf "perifericos.conf" "Periféricos"

    echo

    # ======================================================
    # DISPLAY COMPATÍVEL COM TERMUX 11
    # ======================================================
    echo "---------------- DISPLAY ----------------"
    echo

    if [ -n "$DISPLAY" ]; then
        print_status "[✓]" "Termux:X11" "DISPLAY=$DISPLAY"

        if qemu-system-i386 -display help 2>/dev/null |
           grep -qx "gtk"; then
            print_status "[✓]" "GTK" "disponível"
        else
            print_status "[!]" "GTK" "não disponível"
            AVISOS=$((AVISOS + 1))
        fi
    else
        print_status "[!]" "Termux:X11" "não detectado"

        if qemu-system-i386 -display help 2>/dev/null |
           grep -qx "curses"; then
            print_status "[✓]" "Fallback" "curses disponível"
        else
            print_status "[x]" "Fallback" "curses indisponível"
            ERROS=$((ERROS + 1))
        fi
    fi

    echo

    # ======================================================
    # VARREDURA APENAS DOS ARQUIVOS DA VM
    # ======================================================
    echo "---------------- ARQUIVOS DA VM ----------------"
    echo

    printf "%-24s %-10s %s\n" "ARQUIVO" "TAMANHO" "STATUS"
    printf "%-24s %-10s %s\n" "------------------------" "----------" "------"

    while IFS= read -r ARQ; do
        NOME="$(basename "$ARQ")"
        TAM="$(du -h "$ARQ" 2>/dev/null | cut -f1)"

        if [ -s "$ARQ" ]; then
            STATUS="OK"
        else
            STATUS="VAZIO"
        fi

        printf "%-24s %-10s %s\n" "$NOME" "$TAM" "$STATUS"

    done < <(
        find "$VM_DIR" -maxdepth 1 -type f \
            \( -name "*.conf" \
            -o -name "*.qcow2" \
            -o -name "*.img" \
            -o -name "*.raw" \
            -o -name "*.log" \
            -o -name "*.info" \) \
            | sort
    )

    echo

    # ======================================================
    # RESULTADO FINAL
    # ======================================================
    echo "=========================================================="
    echo "                 RESULTADO DA VARREDURA"
    echo "=========================================================="
    echo

    if [ "$ERROS" -eq 0 ] && [ "$AVISOS" -eq 0 ]; then

        echo "✓ Sistema MS-DOS íntegro."
        echo "✓ Disco virtual válido."
        echo "✓ Configuração completa."
        echo "✓ VM pronta para iniciar."

    elif [ "$ERROS" -eq 0 ]; then

        echo "✓ Nenhum erro crítico encontrado."
        echo "⚠ Avisos encontrados: $AVISOS"
        echo "✓ A VM pode ser iniciada."

    else

        echo "✗ Erros encontrados : $ERROS"
        echo "⚠ Avisos encontrados: $AVISOS"
        echo
        echo "✗ A VM precisa de correções antes de iniciar."

    fi

    echo
    pausa
    ;;

6)
    bash "$ROOT_DIR/tools/qemu/msdos/install_menu.sh"
    ;;

        0)
            break
        ;;

        *)
            erro "Opção inválida!"
            pausa
        ;;

    esac
done
