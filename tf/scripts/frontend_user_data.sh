#!/bin/bash
sudo yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Instalar el agente de Datadog
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=7aa91b67b0886385adfac62960019b85 DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configurar el agente de Datadog
cat > /etc/datadog-agent/datadog.yaml << EOL
api_key: 7aa91b67b0886385adfac62960019b85
site: datadoghq.com
tags:
  - env:dev
  - project:lti-project
logs:
  enabled: true
EOL

# Reiniciar el agente de Datadog
systemctl restart datadog-agent

# Descargar y descomprimir el archivo frontend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/frontend.zip /home/ec2-user/frontend.zip
unzip /home/ec2-user/frontend.zip -d /home/ec2-user/

# Construir la imagen Docker para el frontend
cd /home/ec2-user/frontend
sudo docker build -t lti-frontend .

# Ejecutar el contenedor Docker
sudo docker run -d -p 3000:3000 lti-frontend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
