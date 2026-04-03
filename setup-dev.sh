#!/bin/bash
set -e

echo "🔧 Instalando dependências Python..."
pip install -r backend/requirements-dev.txt

echo "🔗 Instalando pre-commit hooks..."
pre-commit install

echo "📦 Instalando dependências do frontend..."
cd frontend && npm install && cd ..

echo "✅ Ambiente configurado! Rode 'make up' para subir o backend."
