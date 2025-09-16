@echo off
cd backend
echo Construyendo backend...
npm run build

echo Iniciando backend en puerto 3010...
npm start
pause