# Etapa 1: construir la app
FROM node:22.14.0-alpine3.21 AS build

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa 2: servir la app con un servidor web ligero
FROM nginx:alpine

# Copiar la build de React a la carpeta de nginx
COPY --from=build /usr/src/app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
