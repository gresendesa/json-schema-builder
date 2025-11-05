# Estágio 1: Build (Construção)
# Usamos Node 20, conforme visto na configuração de CI/CD
FROM node:20-alpine AS build

WORKDIR /app

# Instalar pnpm (usado pelo projeto)
RUN npm i -g pnpm

# Copiar arquivos de dependência e instalar
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Copiar o restante do código-fonte
COPY . .

# Executar o script de build
RUN pnpm run build

# Estágio 2: Runtime (Execução)
# Usar Nginx para servir os arquivos estáticos
FROM nginx:alpine AS runtime

# Copiar os arquivos estáticos gerados do estágio de build
COPY --from=build /app/dist /usr/share/nginx/html

# Expor a porta 80 (padrão do Nginx)
EXPOSE 80

# Comando para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]