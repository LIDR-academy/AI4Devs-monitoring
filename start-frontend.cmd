@echo off
cd frontend
echo Construyendo frontend...
npm run build

echo Iniciando frontend en puerto 3000...
npm start
pause