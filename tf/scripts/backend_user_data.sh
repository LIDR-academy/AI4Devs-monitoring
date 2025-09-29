#!/bin/bash
# Redirigir toda la salida a /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -xe

# Esperar a que yum libere el lock (evita errores de cloud-init)
until yum list > /dev/null 2>&1; do
  echo "Esperando a yum..."
  sleep 5
done

# Paquetes necesarios
yum update -y
yum install -y docker curl unzip awscli

# Iniciar y habilitar Docker
systemctl enable docker
systemctl start docker

# Descargar y descomprimir backend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket-adriansendin-20250928/backend.zip /home/ec2-user/backend.zip
unzip -o /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir y levantar backend en Docker
cd /home/ec2-user/backend
docker build -t lti-backend .
docker run -d -p 8080:8080 --name lti-backend lti-backend

# Instalar Datadog Agent
DD_AGENT_MAJOR_VERSION=7
DD_API_KEY=5e1c3ee139755eb6c3e168c52d679656
DD_SITE="datadoghq.eu"

curl -s https://install.datadoghq.com/scripts/install_script.sh \
  | DD_AGENT_MAJOR_VERSION=$DD_AGENT_MAJOR_VERSION \
    DD_API_KEY=$DD_API_KEY \
    DD_SITE=$DD_SITE bash

# Instalar y habilitar SSM Agent
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent

# Marca de tiempo (para forzar recreación si cambia)
echo "Timestamp: ${timestamp}"
