#!/bin/bash

# Para evitar problemas de conversão de caminho no Windows, desabilitamos a conversão automática de caminhos do MSYS2
export MSYS_NO_PATHCONV=1

# Nome do container Django
CONTAINER_NAME="zeppelin"

# Caminho do script Python dentro do container
SCRIPT_PATH="/app/create_superuser.py"

echo "Executando criação de superusuário no container $CONTAINER_NAME..."

docker exec -it "$CONTAINER_NAME" python "$SCRIPT_PATH"
