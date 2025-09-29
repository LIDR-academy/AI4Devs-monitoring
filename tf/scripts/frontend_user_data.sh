#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -xe

# Instalar dependencias
yum update -y
yum install -y docker curl unzip awscli amazon-ssm-agent

# Iniciar servicios
systemctl enable docker
systemctl start docker
systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent

# Descargar artefacto frontend desde S3
aws s3 cp ${ARTIFACT_S3} /home/ec2-user/frontend.zip
unzip -o /home/ec2-user/frontend.zip -d /home/ec2-user/

# Construir y ejecutar contenedor con Nginx
cd /home/ec2-user
docker build -t lti-frontend .
docker rm -f lti-frontend || true
docker run -d -p 80:80 --name lti-frontend lti-frontend

echo "Frontend desplegado con build local y Nginx"
