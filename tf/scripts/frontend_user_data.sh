#!/bin/bash
set -e  # Detener el script si hay algún error

# Configurar la región AWS
echo "Configurando región AWS ${aws_region}..."
export AWS_DEFAULT_REGION=${aws_region}
mkdir -p ~/.aws
cat > ~/.aws/config << EOF
[default]
region = ${aws_region}
output = json
EOF

# Instalar dependencias
echo "Actualizando e instalando dependencias..."
sudo yum update -y
sudo yum install -y docker jq aws-cli

# Verificar configuración de AWS
echo "Verificando configuración de AWS..."
aws configure list
aws sts get-caller-identity

# Obtener las claves de API de Datadog desde Secrets Manager con mejor manejo de errores
echo "Obteniendo secretos de Datadog..."
DD_API_KEYS=$(aws secretsmanager get-secret-value --secret-id ${datadog_secret_arn} --query SecretString --output text)
if [ $? -ne 0 ]; then
    echo "Error obteniendo secretos de Datadog"
    exit 1
fi

DD_API_KEY_SECRET=$(echo $DD_API_KEYS | jq -r '.DATADOG_API_KEY_SECRET')
if [ -z "$DD_API_KEY_SECRET" ]; then
    echo "Error: No se pudo obtener DATADOG_API_KEY_SECRET"
    exit 1
fi

# Exportar la API key como variable de entorno
export DD_API_KEY=$DD_API_KEY_SECRET

# Instalar el agente de Datadog con mejor manejo de errores
echo "Instalando agente de Datadog..."
DD_SITE="${datadog_site}" DD_AGENT_MAJOR_VERSION=${datadog_agent_version} bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

# Asegurar que el directorio de configuración existe
echo "Creando directorios de configuración..."
sudo mkdir -p /etc/datadog-agent/conf.d/docker.d/
sudo mkdir -p /etc/datadog-agent/conf.d/logs.d/

# Configurar tags específicos para el frontend
echo "Configurando tags de Datadog..."
sudo tee /etc/datadog-agent/conf.d/docker.d/conf.yaml << EOF
init_config:

instances:
  - url: 'unix://var/run/docker.sock'
    new_tag_names: true
    tags:
      - 'service:frontend'
      - 'env:${environment}'
      - 'project:${datadog_tags["project"]}'
      - 'managed_by:${datadog_tags["managed_by"]}'
EOF

# Configurar la recolección de logs si está habilitada
if [ "${datadog_enable_log_collection}" = "true" ]; then
    echo "Configurando recolección de logs..."
    sudo tee /etc/datadog-agent/conf.d/logs.d/conf.yaml << EOF
logs:
  - type: docker
    service: frontend
    source: docker
  - type: file
    path: /var/log/messages
    service: system-frontend
    source: syslog
EOF
fi

# Configurar el intervalo de recolección de métricas
echo "Configurando intervalo de métricas..."
sudo tee -a /etc/datadog-agent/datadog.yaml << EOF
collection_interval: ${datadog_metrics_collection_interval}
EOF

# Iniciar los servicios
echo "Iniciando servicios..."
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start datadog-agent
sudo systemctl enable datadog-agent

# Verificar el estado del agente de Datadog
echo "Verificando estado del agente de Datadog..."
sudo datadog-agent status

# Descargar y descomprimir el archivo frontend.zip desde S3
echo "Descargando código desde S3..."
aws s3 cp s3://ai4devs-project-code-${account_id}/frontend.zip /home/ec2-user/frontend.zip
unzip -o /home/ec2-user/frontend.zip -d /home/ec2-user/

# Construir la imagen Docker para el frontend
echo "Construyendo imagen Docker..."
cd /home/ec2-user/frontend
sudo docker build -t lti-frontend .

# Ejecutar el contenedor Docker
echo "Ejecutando contenedor..."
sudo docker run -d -p 80:80 lti-frontend

# Timestamp to force update
echo "Script completado. Timestamp: ${timestamp}"
