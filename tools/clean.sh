#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "🧹 LIMPANDO TODOS OS ARQUIVOS TEMPORÁRIOS..."
echo

# Remove caches do projeto
rm -rf ../app/.cxx
rm -rf ../build
rm -rf ../.gradle
rm -rf ../../out
rm -rf ../logs

# Remove cache do Gradle do usuário
rm -rf ~/.gradle/caches/build-cache-*

echo
echo "✅ Limpeza concluída!"
echo "Agora execute:"
echo "  ./doctor.sh"
echo "Depois:"
echo "  ./build_com_log.sh"
