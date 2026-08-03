#!/data/data/com.termux/files/usr/bin/bash
set -e

mkdir -p logs

LOG_FILE="logs/build_$(date +%Y%m%d_%H%M%S).log"

echo "======================================"
echo " Pure3XEngenie Build Analyzer"
echo "======================================"

./gradlew clean assembleDebug --stacktrace --info 2>&1 | tee "$LOG_FILE"

echo
echo "=============================="
echo " ANÁLISE DO BUILD"
echo "=============================="

echo
echo "[FAILURE]"
grep -n "FAILURE:" "$LOG_FILE"

echo
echo "[Exception]"
grep -n "Exception" "$LOG_FILE"

echo
echo "[CMake Error]"
grep -n "CMake Error" "$LOG_FILE"

echo
echo "[CXX]"
grep -n "CXX" "$LOG_FILE"

echo
echo "[Compiler]"
grep -n "compiler" "$LOG_FILE"

echo
echo "[clang]"
grep -n "clang" "$LOG_FILE"

echo
echo "[NDK]"
grep -n "NDK" "$LOG_FILE"

echo
echo "[Gradle]"
grep -n "Execution failed" "$LOG_FILE"

echo
echo "Log completo:"
echo "$LOG_FILE"
