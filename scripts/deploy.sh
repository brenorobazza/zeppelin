#!/bin/bash
# deploy.sh - Script de deploy automatizado para ambiente de producao
set -e

# Define o diretorio do projeto baseado no home do usuario atual
PROJECT_DIR="$HOME/zeppelin"
COMPOSE_FILE="docker-compose.prod.yml"

echo "[INFO] Iniciando processo de deploy..."

cd "$PROJECT_DIR"

echo "[INFO] Atualizando código fonte..."
export DOCKER_BUILDKIT=1
# Força o Git a usar a chave de deploy específica se ela existir, senao usa a padrao
if [ -f "$HOME/.ssh/id_ed25519_deploy" ]; then
    export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_ed25519_deploy -o IdentitiesOnly=yes"
fi

git reset --hard HEAD
git pull origin main

echo "[INFO] Reconstruindo imagens e reiniciando containers..."
# Detecta se deve usar 'docker compose' (V2) ou 'docker-compose' (V1)
DOCKER_CMD="docker-compose"
if docker compose version >/dev/null 2>&1; then
    DOCKER_CMD="docker compose"
fi

echo "[INFO] Utilizando comando: $DOCKER_CMD"

# Para evitar o erro 'KeyError: ContainerConfig', primeiro derrubamos o ambiente
$DOCKER_CMD -f "$COMPOSE_FILE" down --remove-orphans

# Sobe novamente com build
$DOCKER_CMD -f "$COMPOSE_FILE" up -d --build

echo "[INFO] Executando migrações de banco de dados..."
$DOCKER_CMD -f "$COMPOSE_FILE" exec -T app python manage.py migrate --noinput

echo "[INFO] Coletando arquivos estáticos..."
$DOCKER_CMD -f "$COMPOSE_FILE" exec -T app python manage.py collectstatic --noinput

echo "[INFO] Limpando recursos de container não utilizados..."
docker system prune -f

echo "[INFO] Deploy finalizado com sucesso."
