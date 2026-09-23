#!/bin/bash
yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Descargar y descomprimir el archivo backend.zip desde S3
aws s3 cp s3://${bucket_name}/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir la imagen Docker para el backend
cd /home/ec2-user/backend
sudo docker build -t lti-backend .

# Ejecutar el contenedor Docker
sudo docker run -d -p 8080:8080 lti-backend

# Install Datadog Agent with EU region and custom tags
DD_API_KEY=${datadog_api_key} \
DD_SITE="datadoghq.eu" \
DD_TAGS="project:lti-monitoring,env:dev,service:backend,component:api" \
DD_HOSTNAME="lti-backend-prod" \
bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

# Timestamp to force update
echo "Timestamp: ${timestamp}"
