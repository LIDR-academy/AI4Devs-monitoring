#!/bin/bash
# No need for sudo; user-data script runs as root
yum update -y
yum install -y docker

# Iniciar el servicio de Docker
service docker start

# Install Datadog Agent (if API key is provided)
if [ "${datadog_api_key}" != "" ]; then
    DD_API_KEY="${datadog_api_key}" DD_SITE="${datadog_site}" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

    # Configure Datadog agent for Docker monitoring
    echo "logs_enabled: true" >> /etc/datadog-agent/datadog.yaml
    echo "process_config:" >> /etc/datadog-agent/datadog.yaml
    echo "  enabled: 'true'" >> /etc/datadog-agent/datadog.yaml

    # Enable Docker integration
    cp /etc/datadog-agent/conf.d/docker.d/conf.yaml.example /etc/datadog-agent/conf.d/docker.d/conf.yaml

    # Add ec2-user to docker group for Datadog agent to monitor Docker
    usermod -a -G docker dd-agent

    # Restart Datadog agent
    systemctl restart datadog-agent
    systemctl enable datadog-agent
fi

# Descargar y descomprimir el archivo frontend.zip desde S3
aws s3 cp s3://${s3_bucket_name}/frontend.zip /home/ec2-user/frontend.zip
unzip /home/ec2-user/frontend.zip -d /home/ec2-user/

# Construir la imagen Docker para el frontend
cd /home/ec2-user/frontend
docker build -t lti-frontend .

# Ejecutar el contenedor Docker
docker run -d -p 3000:3000 lti-frontend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
