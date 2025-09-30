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

# Ejecutar el contenedor Docker
sudo docker run -d -p 8080:8080 lti-backend

# Timestamp to force update
echo "Timestamp: ${timestamp}"

#!/bin/bash
# ... existing code ...

# Instalar el agente de Datadog
DD_API_KEY=${datadog_api_key} DD_SITE="us5.datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configurar tags para el agente
echo "tags:" >> /etc/datadog-agent/datadog.yaml
echo "  - service:backend" >> /etc/datadog-agent/datadog.yaml
echo "  - env:production" >> /etc/datadog-agent/datadog.yaml

# Reiniciar el agente
sudo service datadog-agent restart

# ... rest of existing code ...