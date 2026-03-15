FROM node:20-alpine

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos de dependências primeiro (aproveita cache de build do docker)
COPY package.json package-lock.json* ./

# Instala as dependências
RUN npm install

# Copia o restante do projeto (embora as pastas montadas localmente no docker-compose vão sobrepor isso em tempo de dev)
COPY . .

# Expõe a porta que o Vite utiliza
EXPOSE 5173

# Inicia o servidor de desenvolvimento
CMD ["npm", "run", "dev"]