#!/bin/bash
# Actualizar paquetes e instalar dependencias
yum update -y
sudo yum install -y docker wget

# Iniciar el servicio de Docker
sudo service docker start

# Descargar y descomprimir el archivo backend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir la imagen Docker para el backend
cd /home/ec2-user/backend
sudo docker build -t lti-backend .

# Ejecutar el contenedor Docker
sudo docker run -d -p 8080:8080 lti-backend

# Instalaci�n del agente Datadog
DD_API_KEY=${datadog_api_key} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configuraci�n para detectar autom�ticamente servicios
sudo sh -c "echo 'logs_enabled: true' >> /etc/datadog-agent/datadog.yaml"
sudo sh -c "echo 'process_config:' >> /etc/datadog-agent/datadog.yaml"
sudo sh -c "echo '  enabled: true' >> /etc/datadog-agent/datadog.yaml"
sudo sh -c "echo 'apm_config:' >> /etc/datadog-agent/datadog.yaml"
sudo sh -c "echo '  enabled: true' >> /etc/datadog-agent/datadog.yaml"

# Configurar la integraci�n con Docker
sudo sh -c "echo -e '\nauto_conf:\n  exclude:\n    images: []\n  include:\n    images: [.*]' >> /etc/datadog-agent/datadog.yaml"

# A�adir etiquetas para identificar el servicio
sudo sh -c "echo -e '\ntags:\n  - service:backend\n  - environment:production\n  - managed-by:terraform' >> /etc/datadog-agent/datadog.yaml"

# Reiniciar el agente para aplicar los cambios
sudo systemctl restart datadog-agent

# Timestamp to force update
echo "Timestamp: ${timestamp}"
