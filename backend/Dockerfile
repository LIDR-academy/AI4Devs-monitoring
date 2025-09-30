# Usar una imagen base de Node.js
FROM node:23.8.0-alpine3.21

# Establecer el directorio de trabajo
WORKDIR /usr/src/app

# Instalar OpenSSL y otras dependencias necesarias para Prisma
RUN apk add --no-cache openssl openssl-dev libc6-compat

# Copiar los archivos de package.json y package-lock.json
COPY package*.json ./

# Instalar las dependencias
RUN npm install

# Copiar el resto del código de la aplicación
COPY . .

# Construir la aplicación
RUN npm run build

RUN npm run prisma:generate

# Exponer el puerto 8081
EXPOSE 8081

# Comando para ejecutar la aplicación
CMD ["npm", "run", "start:prod"]
