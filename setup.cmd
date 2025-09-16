@echo off
echo Instalando dependencias del frontend...
cd frontend
npm install

echo Instalando dependencias del backend...
cd ..\backend
npm install

echo Levantando base de datos PostgreSQL con Docker Compose...
cd ..
docker-compose up -d

echo Ejecutando Prisma: generate, migrate y seed...
cd backend
npx prisma generate
npx prisma migrate dev
npx ts-node prisma/seed.ts

echo Backend y base de datos listos para arrancar.
pause