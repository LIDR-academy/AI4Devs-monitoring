#!/bin/bash
yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Install Datadog Agent
DD_API_KEY="${datadog_api_key}" DD_SITE="${datadog_site}" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configure Datadog Agent
cat <<EOF > /etc/datadog-agent/datadog.yaml
api_key: ${datadog_api_key}
site: ${datadog_site}
tags:
  - env:production
  - service:lti-backend
  - project:lti-monitoring
  - instance_type:backend
  - region:${aws_region}
logs_enabled: true
log_level: INFO
process_config:
  enabled: "true"
apm_config:
  enabled: true
  env: production
  service: lti-backend
  apm_non_local_traffic: true
system_probe_config:
  enabled: true
  network_config:
    enabled: true
EOF

# Configure Docker integration
cat <<EOF > /etc/datadog-agent/conf.d/docker.d/conf.yaml
init_config:
instances:
  - url: "unix://var/run/docker.sock"
    collect_containers_count: true
    collect_volume_count: true
    collect_images_stats: true
    collect_image_size: true
    collect_container_size: true
    collect_events: true
    collect_ecs_tags: false
EOF

# Start Datadog Agent
sudo systemctl enable datadog-agent
sudo systemctl start datadog-agent

# Descargar y descomprimir el archivo backend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir la imagen Docker para el backend
cd /home/ec2-user/backend
sudo docker build -t lti-backend .

# Ejecutar el contenedor Docker con etiquetas para Datadog
sudo docker run -d -p 8080:8080 \
  --label "com.datadoghq.ad.logs"='[{"source": "nodejs", "service": "lti-backend"}]' \
  --label "com.datadoghq.ad.tags"='["env:production", "service:lti-backend"]' \
  lti-backend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
