#!/bin/bash
yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Instalar el agente de Datadog
DD_API_KEY="${datadog_api_key}" DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configurar el agente de Datadog para Docker
sudo tee /etc/datadog-agent/conf.d/docker.d/conf.yaml <<EOF
init_config:

instances:
  - url: "unix://var/run/docker.sock"
    new_tag_names: true
    collect_container_size: true
    collect_container_size_frequency: 5
    collect_volume_count: true
    collect_images_stats: true
    collect_image_size: true
    collect_disk_stats: true
EOF

# Configurar tags para el agente
sudo tee -a /etc/datadog-agent/datadog.yaml <<EOF

tags:
  - env:production
  - service:backend
  - instance_type:backend
EOF

# Reiniciar el agente de Datadog
sudo systemctl restart datadog-agent

# Descargar y descomprimir el archivo backend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir la imagen Docker para el backend
cd /home/ec2-user/backend
sudo docker build -t lti-backend .

# Ejecutar el contenedor Docker con logging para Datadog
sudo docker run -d -p 8081:8081 \
  --log-driver=json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  --name lti-backend \
  lti-backend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
