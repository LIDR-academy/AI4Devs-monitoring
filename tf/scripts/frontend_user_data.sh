#!/bin/bash
# Actualizar paquetes e instalar dependencias
sudo yum update -y
sudo yum install -y docker wget

# Iniciar el servicio de Docker
sudo service docker start

# Descargar y descomprimir el archivo frontend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/frontend.zip /home/ec2-user/frontend.zip
unzip /home/ec2-user/frontend.zip -d /home/ec2-user/

# Construir la imagen Docker para el frontend
cd /home/ec2-user/frontend
sudo docker build -t lti-frontend .

# Ejecutar el contenedor Docker
sudo docker run -d -p 3000:3000 lti-frontend

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
sudo sh -c "echo -e '\ntags:\n  - service:frontend\n  - environment:production\n  - managed-by:terraform' >> /etc/datadog-agent/datadog.yaml"

# Habilitar la recopilaci�n de m�tricas del sistema y procesos
sudo sh -c "echo -e '\nsystem_probe_config:\n  enabled: true' >> /etc/datadog-agent/datadog.yaml"

# Configurar la recopilaci�n de logs (espec�fico para aplicaciones de frontend)
sudo mkdir -p /etc/datadog-agent/conf.d/frontend.d
sudo tee /etc/datadog-agent/conf.d/frontend.d/conf.yaml > /dev/null <<EOF
logs:
  - type: docker
    source: nodejs
    service: frontend
    sourcecategory: sourcecode
EOF

# Reiniciar el agente para aplicar los cambios
sudo systemctl restart datadog-agent

# Timestamp to force update
echo "Timestamp: ${timestamp}"
