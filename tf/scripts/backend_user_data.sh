#!/bin/bash
yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Descargar y descomprimir el archivo backend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir la imagen Docker para el backend
cd /home/ec2-user/backend
sudo docker build -t lti-backend .

# Ejecutar el contenedor Docker con variables para APM
sudo docker run -d -p 8080:8080 \
  -e DD_AGENT_HOST=172.17.0.1 \
  -e DD_ENV=production \
  -e DD_SERVICE=lti-backend \
  -e DD_VERSION=1.0.0 \
  lti-backend

# -----------------------------------
# Instalación del Agente de Datadog
# -----------------------------------
DD_API_KEY="${datadog_api_key}" DD_SITE="datadoghq.com" DD_APM_ENABLED=true DD_APM_NON_LOCAL_TRAFFIC=true bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"


# Timestamp to force update
echo "Timestamp: ${timestamp}"
