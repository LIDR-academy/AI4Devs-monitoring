#!/bin/bash
sudo yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Instalar Datadog Agent
DD_API_KEY="${datadog_api_key}" DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configurar Datadog Agent para Docker
sudo tee /etc/datadog-agent/conf.d/docker.d/conf.yaml <<EOF
init_config:

instances:
  - url: "unix://var/run/docker.sock"
    new_tag_names: true
    collect_container_size: true
    collect_container_count: true
    collect_volume_count: true
    collect_images_stats: true
    collect_image_size: true
    collect_disk_stats: true
EOF

# Configurar logs de la aplicación
sudo tee /etc/datadog-agent/conf.d/logs.d/conf.yaml <<EOF
logs:
  - type: docker
    service: lti-frontend
    source: javascript
    log_processing_rules:
      - type: multi_line
        name: new_log_start_with_date
        pattern: \d{4}-\d{2}-\d{2}
EOF

# Reiniciar Datadog Agent
sudo systemctl restart datadog-agent

# Descargar y descomprimir el archivo frontend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/frontend.zip /home/ec2-user/frontend.zip
unzip /home/ec2-user/frontend.zip -d /home/ec2-user/

# Construir la imagen Docker para el frontend
cd /home/ec2-user/frontend
sudo docker build -t lti-frontend .

# Ejecutar el contenedor Docker con etiquetas para Datadog
sudo docker run -d -p 3000:3000 \
  --name lti-frontend \
  --label com.datadoghq.ad.logs='[{"source": "javascript", "service": "lti-frontend"}]' \
  --label com.datadoghq.ad.check_names='["openmetrics"]' \
  --label com.datadoghq.ad.init_configs='[{}]' \
  --label com.datadoghq.ad.instances='[{"prometheus_url": "http://%%host%%:3000/metrics", "namespace": "lti_frontend", "metrics": ["*"]}]' \
  lti-frontend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
