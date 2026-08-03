#!/data/data/com.termux/files/usr/bin/bash

clear

# Caminhos automáticos
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=========================================="
echo "🔧 P3XE REPAIR — REPARO AUTOMÁTICO"
echo "=========================================="
echo ""

# Limpeza
echo "🧹 Removendo caches..."

rm -rf "$PROJETO_ROOT/app/.cxx"
rm -rf "$PROJETO_ROOT/build"
rm -rf "$PROJETO_ROOT/.gradle"
rm -rf "$PROJETO_ROOT/logs"
rm -rf "$HOME/.gradle/caches/build-cache-*"

echo "✅ Caches removidos."
echo ""

# Permissões
echo "🔐 Ajustando permissões..."

if [ -f "$PROJETO_ROOT/gradlew" ]; then
    chmod +x "$PROJETO_ROOT/gradlew"
    echo "✅ gradlew OK"
else
    echo "❌ gradlew não encontrado!"
fi

chmod +x "$SCRIPT_DIR"/*.sh
chmod +x "$PROJETO_ROOT/P3XE.sh"

echo "✅ Permissões ajustadas."
echo ""

# local.properties
echo "📄 Verificando local.properties..."

if [ -f "$PROJETO_ROOT/local.properties" ]; then
    echo "✅ local.properties encontrado."
else
    echo "❌ local.properties não encontrado."
fi

echo ""
echo "========================================"
echo "✅ REPARO CONCLUÍDO!"
echo "========================================"
echo "Projeto : $PROJETO_ROOT"
echo ""
echo "Próximos passos:"
echo "1. ./tools/doctor.sh"
echo "2. ./tools/build_com_log.sh"
echo "========================================"
echo ""
echo "Pressione ENTER para continuar..."
read -r
