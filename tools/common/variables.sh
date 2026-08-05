#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# VARIÁVEIS GLOBAIS P3XE
# ==========================================================

P3XE_NAME="Pure3XEngine"
P3XE_VERSION="0.2.6 Alpha"

# Diretório do projeto
COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$COMMON_DIR/../.." && pwd)"

TOOLS_DIR="$PROJECT_DIR/tools"
BUILD_DIR="$TOOLS_DIR/build"
DEV_DIR="$TOOLS_DIR/development"
DIAG_DIR="$TOOLS_DIR/diagnostics"
SMART_DIR="$TOOLS_DIR/smart"
UTILS_DIR="$TOOLS_DIR/utilities"

LOG_DIR="$PROJECT_DIR/logs"
DOCS_DIR="$PROJECT_DIR/docs"

DATE_NOW="$(date +"%d/%m/%Y")"
TIME_NOW="$(date +"%H:%M:%S")"
DATE_TIME="$(date +"%d/%m/%Y %H:%M:%S")"

TERMUX_PREFIX="$PREFIX"
ANDROID_HOME="$HOME/AndroidSDK"
ANDROID_NDK_HOME="$HOME/android-ndk-r29"

export PROJECT_DIR
export TOOLS_DIR
export LOG_DIR
export DOCS_DIR
