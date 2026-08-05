#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Pure3XEngine 0.2.6 Alpha
# P3XE Intelligent README Generator
# ============================================================

set -u

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
README="$ROOT_DIR/README.md"
TMP_README="$ROOT_DIR/.README.p3xe.tmp"

VERSION="0.2.6 Alpha"

OK=0
WARN=0
ERRORS=0

clear

echo "============================================================"
echo "📝 P3XE - README GENERATOR INTELIGENTE"
echo "Pure3XEngine $VERSION"
echo "============================================================"
echo "Projeto : $ROOT_DIR"
echo "Data    : $(date '+%d/%m/%Y')"
echo "Hora    : $(date '+%H:%M:%S')"
echo "============================================================"
echo

# ------------------------------------------------------------
# Funções
# ------------------------------------------------------------

count_files() {
    local DIR="$1"
    local PATTERN="$2"

    if [ -d "$DIR" ]; then
        find "$DIR" -type f -name "$PATTERN" 2>/dev/null | wc -l
    else
        echo 0
    fi
}

module_status() {
    if [ -d "$ROOT_DIR/$1" ]; then
        echo "Disponível"
    else
        echo "Não detectado"
    fi
}

tool_version() {
    local TOOL="$1"

    if command -v "$TOOL" >/dev/null 2>&1; then
        "$TOOL" --version 2>/dev/null | head -n 1
    else
        echo "Não instalado"
    fi
}

# ------------------------------------------------------------
# Análise do projeto
# ------------------------------------------------------------

echo "🔎 ANALISANDO PROJETO"
echo "------------------------------------------------------------"

MODULES=(
    "CoreEmulator"
    "Cubo3D"
    "QEMUCenter"
    "Android"
    "Config"
    "tools"
)

for MODULE in "${MODULES[@]}"; do
    if [ -d "$ROOT_DIR/$MODULE" ]; then
        echo "✅ $MODULE"
        OK=$((OK + 1))
    else
        echo "⚠ $MODULE não encontrado"
        WARN=$((WARN + 1))
    fi
done

# ------------------------------------------------------------
# Contadores
# ------------------------------------------------------------

echo
echo "📊 COLETANDO ESTATÍSTICAS"
echo "------------------------------------------------------------"

CPP_COUNT=$(find "$ROOT_DIR" -type f \
    \( -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" \) \
    ! -path "$ROOT_DIR/.git/*" \
    ! -path "$ROOT_DIR/out/*" \
    ! -path "*/build/*" \
    ! -path "*/build-*/*" \
    ! -path "$ROOT_DIR/exports/*" \
    2>/dev/null | wc -l)

C_COUNT=$(find "$ROOT_DIR" -type f \
    -name "*.c" \
    ! -path "$ROOT_DIR/.git/*" \
    ! -path "$ROOT_DIR/out/*" \
    ! -path "*/build/*" \
    ! -path "*/build-*/*" \
    ! -path "$ROOT_DIR/exports/*" \
    2>/dev/null | wc -l)

HEADER_COUNT=$(find "$ROOT_DIR" -type f \
    \( -name "*.h" -o -name "*.hpp" \) \
    ! -path "$ROOT_DIR/.git/*" \
    ! -path "$ROOT_DIR/out/*" \
    ! -path "*/build/*" \
    ! -path "*/build-*/*" \
    ! -path "$ROOT_DIR/exports/*" \
    2>/dev/null | wc -l)

JAVA_COUNT=$(count_files "$ROOT_DIR/Android" "*.java")
KOTLIN_COUNT=$(count_files "$ROOT_DIR/Android" "*.kt")
SHADER_COUNT=$(find "$ROOT_DIR/Cubo3D" -type f \
    \( -name "*.vert" -o -name "*.frag" -o -name "*.glsl" \) \
    2>/dev/null | wc -l)

CMAKE_COUNT=$(find "$ROOT_DIR" -type f \
    -name "CMakeLists.txt" \
    ! -path "$ROOT_DIR/out/*" \
    ! -path "*/build-*/*" \
    2>/dev/null | wc -l)

SCRIPT_COUNT=$(find "$ROOT_DIR/tools" -type f \
    -name "*.sh" 2>/dev/null | wc -l)

APK_COUNT=$(find "$ROOT_DIR/exports/apk" -type f \
    -name "*.apk" 2>/dev/null | wc -l)

SO_COUNT=$(find "$ROOT_DIR" -type f \
    -name "*.so" \
    ! -path "$ROOT_DIR/.git/*" \
    2>/dev/null | wc -l)

RELEASE_COUNT=$(find "$ROOT_DIR/exports/releases" \
    -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)

echo "C/C++       : $((CPP_COUNT + C_COUNT))"
echo "Headers     : $HEADER_COUNT"
echo "Java        : $JAVA_COUNT"
echo "Kotlin      : $KOTLIN_COUNT"
echo "Shaders     : $SHADER_COUNT"
echo "CMakeLists  : $CMAKE_COUNT"
echo "Scripts     : $SCRIPT_COUNT"
echo "APK         : $APK_COUNT"
echo "Bibliotecas : $SO_COUNT"
echo "Releases    : $RELEASE_COUNT"

# ------------------------------------------------------------
# Git
# ------------------------------------------------------------

echo
echo "🌿 ANALISANDO GIT"
echo "------------------------------------------------------------"

if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree \
    >/dev/null 2>&1; then

    GIT_BRANCH=$(git -C "$ROOT_DIR" branch \
        --show-current 2>/dev/null)

    GIT_COMMIT=$(git -C "$ROOT_DIR" rev-parse \
        --short HEAD 2>/dev/null)

    GIT_CHANGES=$(git -C "$ROOT_DIR" status \
        --porcelain 2>/dev/null | wc -l)

    [ -z "$GIT_BRANCH" ] && GIT_BRANCH="desconhecida"
    [ -z "$GIT_COMMIT" ] && GIT_COMMIT="desconhecido"

    echo "Branch     : $GIT_BRANCH"
    echo "Commit     : $GIT_COMMIT"
    echo "Alterações : $GIT_CHANGES"

    OK=$((OK + 1))
else
    GIT_BRANCH="Não detectado"
    GIT_COMMIT="Não detectado"
    GIT_CHANGES=0

    echo "⚠ Repositório Git não detectado"
    WARN=$((WARN + 1))
fi

# ------------------------------------------------------------
# Detectar componentes gráficos
# ------------------------------------------------------------

echo
echo "🎮 GRÁFICOS"
echo "------------------------------------------------------------"

if grep -Rqi "vulkan" "$ROOT_DIR/Cubo3D" \
    --include="*.cpp" \
    --include="*.h" \
    --include="*.hpp" \
    --include="CMakeLists.txt" 2>/dev/null; then

    VULKAN_STATUS="Referências detectadas"
    echo "✅ Vulkan"
else
    VULKAN_STATUS="Não detectado"
    echo "⚠ Vulkan não detectado"
fi

if grep -RqiE "GLES|OpenGL ES|gl[A-Z]" "$ROOT_DIR/Cubo3D" \
    --include="*.cpp" \
    --include="*.h" \
    --include="*.hpp" \
    --include="CMakeLists.txt" 2>/dev/null; then

    GLES_STATUS="Referências detectadas"
    echo "✅ OpenGL ES"
else
    GLES_STATUS="Não detectado"
    echo "⚠ OpenGL ES não detectado"
fi

# ------------------------------------------------------------
# QEMU
# ------------------------------------------------------------

echo
echo "🖥 QEMU"
echo "------------------------------------------------------------"

if command -v qemu-system-x86_64 >/dev/null 2>&1 || \
   command -v qemu-system-aarch64 >/dev/null 2>&1 || \
   command -v qemu-system-i386 >/dev/null 2>&1; then

    QEMU_STATUS="Runtime disponível"
    echo "✅ QEMU Runtime detectado"
else
    QEMU_STATUS="Runtime não detectado"
    echo "⚠ QEMU Runtime não detectado"
fi

# ------------------------------------------------------------
# Ferramentas
# ------------------------------------------------------------

CLANG_VERSION=$(tool_version clang)
CMAKE_VERSION=$(tool_version cmake)
GIT_VERSION=$(tool_version git)

# ------------------------------------------------------------
# Backup do README existente
# ------------------------------------------------------------

echo
echo "💾 README"
echo "------------------------------------------------------------"

if [ -f "$README" ]; then
    cp "$README" "$ROOT_DIR/README.md.backup"

    if [ $? -eq 0 ]; then
        echo "✅ Backup: README.md.backup"
    else
        echo "⚠ Não foi possível criar backup"
        WARN=$((WARN + 1))
    fi
fi

# ------------------------------------------------------------
# Gerar README
# ------------------------------------------------------------

cat > "$TMP_README" <<EOF
# Pure3XEngine

**Versão:** $VERSION

Pure3XEngine é um projeto experimental de emulação e desenvolvimento
voltado para arquitetura modular, Android, renderização gráfica e
integração com ambientes de virtualização.

> Projeto em estágio Alpha. Recursos e estruturas podem mudar durante
> o desenvolvimento.

## Estado atual

| Componente | Estado |
|---|---|
| CoreEmulator | $(module_status CoreEmulator) |
| Cubo3D | $(module_status Cubo3D) |
| QEMUCenter | $(module_status QEMUCenter) |
| Android | $(module_status Android) |
| Config | $(module_status Config) |
| Ferramentas P3XE | $(module_status tools) |

## Arquitetura

### CoreEmulator

Núcleo principal do Pure3XEngine.

Responsável pela infraestrutura central utilizada pelo projeto e pela
evolução dos componentes de emulação.

### Cubo3D

Subsistema gráfico e de renderização.

Estado detectado automaticamente:

- Vulkan: $VULKAN_STATUS
- OpenGL ES: $GLES_STATUS
- Shaders encontrados: $SHADER_COUNT

### QEMUCenter

Centro de integração com QEMU e máquinas virtuais.

Estado:

- QEMUCenter: $(module_status QEMUCenter)
- QEMU Runtime: $QEMU_STATUS

O QEMUCenter também faz parte da proposta de fornecer comandos e
operações simplificadas para usuários que não dominam diretamente
o terminal.

### Android

Camada destinada à integração do Pure3XEngine com Android.

Arquivos detectados:

- Java: $JAVA_COUNT
- Kotlin: $KOTLIN_COUNT

## P3XE Development Kit

O diretório \`tools/\` contém ferramentas de desenvolvimento e
automação do projeto.

Scripts Shell detectados: **$SCRIPT_COUNT**

O AI Center inclui ferramentas para diagnóstico, correção,
build, publicação, geração de documentação e análise do projeto.

## Estatísticas do projeto

| Tipo | Quantidade |
|---|---:|
| C/C++ | $((CPP_COUNT + C_COUNT)) |
| Headers | $HEADER_COUNT |
| Java | $JAVA_COUNT |
| Kotlin | $KOTLIN_COUNT |
| Shaders | $SHADER_COUNT |
| CMakeLists.txt | $CMAKE_COUNT |
| Scripts Shell | $SCRIPT_COUNT |
| APK encontrados | $APK_COUNT |
| Bibliotecas .so | $SO_COUNT |
| Releases | $RELEASE_COUNT |

## Sistema de Build

O projeto utiliza CMake e Clang para os componentes nativos.

Ambiente detectado durante a geração deste README:

\`\`\`text
$CLANG_VERSION
$CMAKE_VERSION
$GIT_VERSION
\`\`\`

O padrão principal do código nativo é **C++20**.

## Estrutura principal

\`\`\`text
Pure3XEngine/
├── CoreEmulator/
├── Cubo3D/
├── QEMUCenter/
├── Android/
├── Config/
├── tools/
│   ├── ai/
│   ├── common/
│   └── emulator/
├── exports/
│   ├── apk/
│   └── releases/
└── README.md
\`\`\`

## Git

Estado no momento da geração:

\`\`\`text
Branch: $GIT_BRANCH
Commit: $GIT_COMMIT
Alterações locais: $GIT_CHANGES
\`\`\`

## Build e desenvolvimento

Antes de compilar, recomenda-se verificar o projeto com as ferramentas
do P3XE Development Kit.

Exemplo:

\`\`\`bash
cd ~/Pure3XEngine
bash tools/ai/menu.sh
\`\`\`

O AI Center centraliza as principais operações de desenvolvimento.

## Status

Pure3XEngine encontra-se atualmente em:

**Development / Alpha**

Versão atual:

**$VERSION**

O projeto ainda está em desenvolvimento e não representa uma
implementação completa de um sistema PlayStation 3.

## Licença

Este projeto utiliza a licença **GNU General Public License v3.0
(GPL-3.0)**.

Consulte o arquivo \`LICENSE\` do repositório para os termos completos.

---

README gerado automaticamente pelo **P3XE Intelligent README Generator**.

Última geração: $(date '+%d/%m/%Y %H:%M:%S')
EOF

# ------------------------------------------------------------
# Validar geração
# ------------------------------------------------------------

if [ -s "$TMP_README" ]; then
    mv "$TMP_README" "$README"

    README_LINES=$(wc -l < "$README")
    README_SIZE=$(du -h "$README" | cut -f1)

    OK=$((OK + 1))

    echo "✅ README.md gerado"
    echo "Linhas  : $README_LINES"
    echo "Tamanho : $README_SIZE"
else
    echo "❌ Falha ao gerar README.md"
    rm -f "$TMP_README"

    ERRORS=$((ERRORS + 1))
fi

# ------------------------------------------------------------
# Resultado
# ------------------------------------------------------------

echo
echo "============================================================"
echo "📊 RESUMO README GENERATOR"
echo "============================================================"
echo "OK       : $OK"
echo "Avisos   : $WARN"
echo "Erros    : $ERRORS"
echo "C/C++    : $((CPP_COUNT + C_COUNT))"
echo "Scripts  : $SCRIPT_COUNT"
echo "APK      : $APK_COUNT"
echo "Releases : $RELEASE_COUNT"
echo "============================================================"

if [ "$ERRORS" -eq 0 ]; then
    echo "✅ README GENERATOR: CONCLUÍDO"
else
    echo "❌ README GENERATOR: FALHOU"
fi

echo "============================================================"
echo
echo "Pure3XEngine $VERSION"
echo "P3XE README Generator - Development / Alpha"
echo "Data : $(date '+%d/%m/%Y')"
echo "Hora : $(date '+%H:%M:%S')"
echo

read -r -p "Pressione ENTER para voltar..."
