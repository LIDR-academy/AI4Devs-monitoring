#!/bin/bash
exec > >(tee -a /var/log/cloud-init-output.log) 2>&1
set -e

echo "[AI4DEVS-USERDATA] Iniciando script de arranque..."

echo "[AI4DEVS-USERDATA] Actualizando e instalando dependencias..."
yum update -y
yum install -y git docker jq

echo "[AI4DEVS-USERDATA] Agregando ec2-user al grupo docker..."
sudo usermod -aG docker ec2-user
systemctl start docker
systemctl enable docker
sleep 5

echo "[AI4DEVS-USERDATA] Instalando Node.js y npm..."
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

echo "[AI4DEVS-USERDATA] Instalando AWS CLI v2..."
yum install -y aws-cli

echo "[AI4DEVS-USERDATA] Clonando el repositorio..."
cd /home/ec2-user
git clone https://github.com/rockeroicantonidev/AI4Devs-monitoring.git
cd AI4Devs-monitoring

echo "[AI4DEVS-USERDATA] Creando archivo .env con valores para desarrollo..."
cat > .env << ENVFILE
DB_PASSWORD=D1ymf8wyQEGthFR1E9xhCq
DB_USER=LTIdbUser
DB_NAME=LTIdb
DB_PORT=5432
DATABASE_URL=postgresql://LTIdbUser:D1ymf8wyQEGthFR1E9xhCq@localhost:5432/LTIdb
ENVFILE

echo "[AI4DEVS-USERDATA] Mostrando contenido del archivo .env:"
cat .env

echo "[AI4DEVS-USERDATA] Levantando base de datos PostgreSQL en Docker con valores explícitos..."
sudo docker run -d --name ai4devs-postgres \
  -e POSTGRES_PASSWORD=D1ymf8wyQEGthFR1E9xhCq \
  -e POSTGRES_USER=LTIdbUser \
  -e POSTGRES_DB=LTIdb \
  -p 5432:5432 \
  postgres:latest

echo "[AI4DEVS-USERDATA] Esperando a que la base de datos esté lista (10 intentos)..."
for i in {1..10}; do
  echo "[AI4DEVS-USERDATA] Intento $i de 10..."
  if sudo docker exec ai4devs-postgres pg_isready -U LTIdbUser; then
    echo "[AI4DEVS-USERDATA] PostgreSQL está listo."
    break
  else
    if sudo docker ps -a | grep -q ai4devs-postgres; then
      echo "[AI4DEVS-USERDATA] Contenedor existe pero no está listo. Verificando logs:"
      sudo docker logs ai4devs-postgres
      sleep 5
    else
      echo "[AI4DEVS-USERDATA] Contenedor no existe. Intentando reiniciar:"
      sudo docker run -d --name ai4devs-postgres \
        -e POSTGRES_PASSWORD=D1ymf8wyQEGthFR1E9xhCq \
        -e POSTGRES_USER=LTIdbUser \
        -e POSTGRES_DB=LTIdb \
        -p 5432:5432 \
        postgres:latest
      sleep 10
    fi
  fi
done

# Verificar si el contenedor está corriendo después de los intentos
if ! sudo docker ps | grep -q ai4devs-postgres; then
  echo "[AI4DEVS-USERDATA] ERROR: El contenedor de PostgreSQL no está corriendo después de varios intentos."
  echo "[AI4DEVS-USERDATA] Logs del contenedor:"
  sudo docker logs ai4devs-postgres
  exit 1
fi

echo "[AI4DEVS-USERDATA] Copiando .env al directorio del backend..."
cp .env backend/

echo "[AI4DEVS-USERDATA] Instalando dependencias del backend..."
cd backend
npm install
  
echo "[AI4DEVS-USERDATA] Construyendo backend..."
npm run build

echo "[AI4DEVS-USERDATA] Ejecutando migraciones..."
npx prisma generate
npx prisma migrate deploy

# En lugar de usar ts-node directamente, usamos script pre-compilado o lo incluimos en package.json
echo "[AI4DEVS-USERDATA] Creando script de seed temporal para evitar problemas con ts-node..."
cat > prisma/seed.js << EOF
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  try {
    console.log("Iniciando seed de datos...");
    
    // Crear compañía
    const company = await prisma.company.create({
      data: {
        name: 'LTI'
      }
    });
    console.log("Compañía creada:", company.id);

    // Crear posición
    const position = await prisma.position.create({
      data: {
        title: 'Senior Developer',
        description: 'Senior developer position',
        status: 'Open',
        isVisible: true,
        companyId: company.id,
        requirements: 'Node.js, TypeScript, React'
      }
    });
    console.log("Posición creada:", position.id);

    // Crear candidato
    const candidate = await prisma.candidate.create({
      data: {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phone: '1234567890'
      }
    });
    console.log("Candidato creado:", candidate.id);

    console.log("Seed completado exitosamente");
  } catch (error) {
    console.error("Error durante el seed:", error);
  }
}

main()
  .then(async () => {
    console.log("Seed ejecutado correctamente");
    await prisma.\$disconnect();
  })
  .catch(async (e) => {
    console.error("Error en seed:", e);
    await prisma.\$disconnect();
    process.exit(1);
  });
EOF

echo "[AI4DEVS-USERDATA] Ejecutando seed..."
node prisma/seed.js || echo "[AI4DEVS-USERDATA] ERROR: Falló la ejecución del seed, pero el despliegue continúa."

echo "[AI4DEVS-USERDATA] Iniciando backend..."
nohup npm start &
echo "[AI4DEVS-USERDATA] Backend iniciado en puerto 3010"

echo "[AI4DEVS-USERDATA] Instalando dependencias del frontend..."
cd ../frontend
npm install
  
echo "[AI4DEVS-USERDATA] Iniciando frontend..."
export PORT=3000
nohup npm start &
echo "[AI4DEVS-USERDATA] Frontend iniciado en puerto 3000"

echo "[AI4DEVS-USERDATA] Despliegue completo"