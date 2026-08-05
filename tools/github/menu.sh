#!/data/data/com.termux/files/usr/bin/bash

# ==========================================================
# Pure3XEngine - GitHub Center
# ==========================================================

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
INIT_FILE="$ROOT_DIR/tools/common/init.sh"

if [ ! -f "$INIT_FILE" ]; then
    echo "[x] init.sh não encontrado:"
    echo "    $INIT_FILE"
    exit 1
fi

source "$INIT_FILE"

cd "$ROOT_DIR" || exit 1

# ==========================================================
# FUNÇÕES LOCAIS
# ==========================================================

github_header() {
    cabecalho
    echo "🌿 GITHUB CENTER"
    echo "============================================================"
}

release_header() {
    cabecalho
    echo "🚀 RELEASE MANAGER"
    echo "============================================================"
}

git_repo_check() {
    if [ ! -d "$ROOT_DIR/.git" ]; then
        erro "Este projeto não é um repositório Git."
        return 1
    fi

    return 0
}

git_branch_atual() {
    git branch --show-current 2>/dev/null
}

git_remote_check() {
    if ! git remote get-url origin >/dev/null 2>&1; then
        erro "Remote 'origin' não configurado."
        return 1
    fi

    return 0
}

# ==========================================================
# MENU PRINCIPAL
# ==========================================================

while true
do
    github_header

    echo "1) 📊 Status"
    echo "2) ➕ Add Arquivos"
    echo "3) 💾 Commit"
    echo "4) ↑ Push"
    echo "5) ↓ Pull"
    echo "6) 🌿 Branches"
    echo "7) 🏷 Tags"
    echo "8) 📜 Histórico"
    echo "9) ⚙ Configurar Git"
    echo "10) 🔗 Repositório Remoto"
    echo "11) 🔄 Sincronizar Tudo"
    echo "12) 🚀 Release Manager"
    echo "13) 📦 Publicador P3XE"
    echo
    echo "0) ← Voltar"
    echo

    read -r -p "Escolha uma opção: " opcao

    case "$opcao" in

        1)
            cabecalho
            echo "📊 STATUS DO REPOSITÓRIO"
            echo "============================================================"

            if git_repo_check; then
                echo "Branch : $(git_branch_atual)"
                echo
                git status
            fi

            pausa
            ;;

        2)
            cabecalho
            echo "➕ ADICIONAR ARQUIVOS"
            echo "============================================================"

            if git_repo_check; then
                git status --short
                echo

                read -r -p "Adicionar alterações ao stage? [s/N]: " resp

                if [[ "$resp" =~ ^[sS]$ ]]; then
                    git add -A

                    if [ $? -eq 0 ]; then
                        sucesso "Arquivos adicionados."
                        git status --short
                    else
                        erro "Falha ao adicionar arquivos."
                    fi
                fi
            fi

            pausa
            ;;

        3)
            cabecalho
            echo "💾 COMMIT"
            echo "============================================================"

            if git_repo_check; then

                if git diff --cached --quiet; then
                    erro "Não existem alterações preparadas para commit."
                else
                    git status --short
                    echo

                    read -r -p "Mensagem do commit: " msg

                    if [ -z "$msg" ]; then
                        erro "Mensagem do commit não pode ficar vazia."
                    elif git commit -m "$msg"; then
                        sucesso "Commit criado."
                    else
                        erro "Falha ao criar commit."
                    fi
                fi
            fi

            pausa
            ;;

        4)
            cabecalho
            echo "↑ PUSH"
            echo "============================================================"

            if git_repo_check && git_remote_check; then
                branch="$(git_branch_atual)"

                if [ -z "$branch" ]; then
                    erro "Não foi possível detectar a branch atual."
                else
                    echo "Branch: $branch"
                    echo

                    if git push origin "$branch"; then
                        sucesso "Push concluído."
                    else
                        erro "Falha no push."
                    fi
                fi
            fi

            pausa
            ;;

        5)
            cabecalho
            echo "↓ PULL"
            echo "============================================================"

            if git_repo_check && git_remote_check; then
                branch="$(git_branch_atual)"

                if [ -z "$branch" ]; then
                    erro "Não foi possível detectar a branch atual."
                elif git pull --rebase origin "$branch"; then
                    sucesso "Repositório atualizado."
                else
                    erro "Falha no pull."
                fi
            fi

            pausa
            ;;

        6)
            cabecalho
            echo "🌿 BRANCHES"
            echo "============================================================"

            if git_repo_check; then
                git branch -a
            fi

            pausa
            ;;

        7)
            cabecalho
            echo "🏷 TAGS"
            echo "============================================================"

            if git_repo_check; then
                git tag --sort=-version:refname
            fi

            pausa
            ;;

        8)
            cabecalho
            echo "📜 HISTÓRICO"
            echo "============================================================"

            if git_repo_check; then
                git log --oneline --graph --decorate -20
            fi

            pausa
            ;;

        9)
            cabecalho
            echo "⚙ CONFIGURAÇÃO GIT"
            echo "============================================================"

            git config --list
            pausa
            ;;

        10)
            cabecalho
            echo "🔗 REPOSITÓRIO REMOTO"
            echo "============================================================"

            if git_repo_check; then
                git remote -v
            fi

            pausa
            ;;

        11)
            cabecalho
            echo "🔄 SINCRONIZAR P3XE"
            echo "============================================================"

            if ! git_repo_check; then
                pausa
                continue
            fi

            if ! git_remote_check; then
                pausa
                continue
            fi

            echo "Alterações encontradas:"
            echo
            git status --short
            echo

            if [ -z "$(git status --porcelain)" ]; then
                sucesso "Nenhuma alteração local para publicar."
                pausa
                continue
            fi

            read -r -p "Mensagem do commit: " msg

            if [ -z "$msg" ]; then
                erro "Mensagem vazia. Sincronização cancelada."
                pausa
                continue
            fi

            read -r -p "Adicionar, commit e enviar para GitHub? [s/N]: " resp

            if [[ ! "$resp" =~ ^[sS]$ ]]; then
                echo "Operação cancelada."
                pausa
                continue
            fi

            git add -A || {
                erro "Falha no git add."
                pausa
                continue
            }

            if git diff --cached --quiet; then
                erro "Nenhuma alteração preparada para commit."
                pausa
                continue
            fi

            git commit -m "$msg" || {
                erro "Falha no commit."
                pausa
                continue
            }

            branch="$(git_branch_atual)"

            git push origin "$branch"

            if [ $? -eq 0 ]; then
                sucesso "P3XE sincronizado com o GitHub."
            else
                erro "Commit criado, mas o push falhou."
            fi

            pausa
            ;;

        12)
            while true
            do
                release_header

                echo "1) Criar Tag"
                echo "2) Listar Tags"
                echo "3) Remover Tag"
                echo "4) Gerar CHANGELOG"
                echo "5) Preparar Nova Release"
                echo
                echo "0) Voltar"
                echo

                read -r -p "Escolha: " rel

                case "$rel" in

                    1)
                        read -r -p "Versão (ex: v0.2.6-alpha): " versao

                        if [ -z "$versao" ]; then
                            erro "Versão vazia."
                        elif git rev-parse "$versao" >/dev/null 2>&1; then
                            erro "A tag '$versao' já existe."
                        elif git tag -a "$versao" -m "Pure3XEngine $versao"; then
                            sucesso "Tag $versao criada."
                        else
                            erro "Falha ao criar tag."
                        fi

                        pausa
                        ;;

                    2)
                        git tag --sort=-version:refname
                        pausa
                        ;;

                    3)
                        read -r -p "Tag para remover: " tag

                        if [ -z "$tag" ]; then
                            erro "Tag vazia."
                        elif git tag -d "$tag"; then
                            sucesso "Tag local removida."
                        else
                            erro "Tag não encontrada."
                        fi

                        pausa
                        ;;

                    4)
                        {
                            echo "# Pure3XEngine - CHANGELOG"
                            echo
                            git log --pretty=format:'- %h %s'
                            echo
                        } > "$ROOT_DIR/CHANGELOG.md"

                        sucesso "CHANGELOG.md criado."
                        pausa
                        ;;

                    5)
                        cabecalho
                        echo "🚀 PREPARAR NOVA RELEASE"
                        echo "============================================================"
                        echo
                        echo "Branch : $(git_branch_atual)"
                        echo
                        echo "Status:"
                        git status --short
                        echo
                        echo "Últimas tags:"
                        git tag --sort=-version:refname | head -n 10
                        echo
                        echo "A preparação não publica automaticamente."
                        pausa
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
            ;;

        13)
            cabecalho
            echo "📦 PUBLICADOR P3XE"
            echo "============================================================"

            cd "$ROOT_DIR" || {
                erro "Não foi possível acessar ROOT_DIR."
                pausa
                continue
            }

            if ! git_repo_check; then
                pausa
                continue
            fi

            if ! git_remote_check; then
                pausa
                continue
            fi

            if [ -f "README.md" ]; then
                echo "✓ README.md encontrado"
            else
                echo "△ README.md não encontrado"
            fi

            if [ -f "cubo3d_launcher.png" ]; then
                echo "✓ Capa encontrada"
            else
                echo "△ Capa não encontrada"
            fi

            echo
            echo "Arquivos modificados:"
            echo "------------------------------------------------------------"
            git status --short
            echo "------------------------------------------------------------"
            echo

            if [ -z "$(git status --porcelain)" ]; then
                sucesso "Projeto já está atualizado localmente."
                pausa
                continue
            fi

            read -r -p "Mensagem do commit: " msg

            if [ -z "$msg" ]; then
                erro "Mensagem vazia. Publicação cancelada."
                pausa
                continue
            fi

            read -r -p "Publicar estas alterações? [s/N]: " resp

            if [[ ! "$resp" =~ ^[sS]$ ]]; then
                echo "Publicação cancelada."
                pausa
                continue
            fi

            git add -A || {
                erro "Falha ao adicionar arquivos."
                pausa
                continue
            }

            if git diff --cached --quiet; then
                erro "Nenhuma alteração preparada."
                pausa
                continue
            fi

            git commit -m "$msg" || {
                erro "Falha ao criar commit."
                pausa
                continue
            }

            branch="$(git_branch_atual)"

            if git push origin "$branch"; then
                sucesso "Projeto publicado com sucesso!"
            else
                erro "Commit criado, mas o GitHub não recebeu o push."
            fi

            pausa
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
