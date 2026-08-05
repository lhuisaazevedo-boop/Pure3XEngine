#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Pure3XEngine - Carregar Configuração da VM
# ==========================================================

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

VM_DIR="$ROOT_DIR/qemu/vms/msdos"

# Configurações padrão
RAM=""
CPU=""
VGA=""
BOOT=""
MOUSE=""
SOUND=""
KEYBOARD=""
TABLET=""
VNC=""
PORT=""
PASSWORD=""
ISO=""
DISK=""
ORDER=""
MENU=""

# Carrega arquivos de configuração
[ -f "$VM_DIR/msdos.conf" ]        && source "$VM_DIR/msdos.conf"
[ -f "$VM_DIR/boot.conf" ]         && source "$VM_DIR/boot.conf"
[ -f "$VM_DIR/perifericos.conf" ]  && source "$VM_DIR/perifericos.conf"
[ -f "$VM_DIR/vnc.conf" ]          && source "$VM_DIR/vnc.conf"
[ -f "$VM_DIR/iso.conf" ]          && source "$VM_DIR/iso.conf"

# Localiza o disco virtual automaticamente
DISK="$(find "$VM_DIR" -maxdepth 1 \( -name "*.img" -o -name "*.qcow2" \) | head -n1)"

export RAM
export CPU
export VGA
export BOOT
export MOUSE
export SOUND
export KEYBOARD
export TABLET
export VNC
export PORT
export PASSWORD
export ISO
export DISK
export ORDER
export MENU
export VM_DIR
