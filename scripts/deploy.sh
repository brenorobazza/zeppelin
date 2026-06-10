#!/bin/bash
# deploy.sh - Script de deploy automatizado para ambiente de producao
set -e

PROJECT_DIR="/home/ubuntu/zeppelin"
COMPOSE_FILE="docker-compose.prod.yml"

echo "[INFO] Iniciando processo de deploy..."

cd "$PROJECT_DIR"

echo "[INFO] Atualizando código fonte..."
git pull origin main

echo "[INFO] Reconstruindo imagens e reiniciando containers..."
docker-compose -f "$COMPOSE_FILE" up -d --build --remove-orphans

echo "[INFO] Executando migrações de banco de dados..."
docker-compose -f "$COMPOSE_FILE" exec -T app python manage.py migrate --noinput

echo "[INFO] Coletando arquivos estáticos..."
docker-compose -f "$COMPOSE_FILE" exec -T app python manage.py collectstatic --noinput

echo "[INFO] Limpando recursos de container não utilizados..."
docker system prune -f

echo "[INFO] Deploy finalizado com sucesso."
