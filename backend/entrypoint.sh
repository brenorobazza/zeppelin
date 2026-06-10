#!/bin/bash
set -e

echo "Aguardando PostgreSQL..."
while ! nc -z db_zeppelin 5432; do
  sleep 1
done
echo "PostgreSQL está pronto!"


echo "Executando migrations..."
python manage.py migrate

echo "Carregando dados iniciais do questionário..."
python manage.py load_initial_questionnaire_data

echo "Iniciando aplicação..."
exec "$@"
