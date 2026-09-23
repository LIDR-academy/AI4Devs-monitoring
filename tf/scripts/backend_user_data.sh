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

# ------------------------------------------------------------------------------
# Datadog Agent
# ------------------------------------------------------------------------------
if [ -n "${dd_api_key}" ]; then
  export DD_API_KEY="${dd_api_key}"
  export DD_SITE="${dd_site}"
  export DD_TAGS="env:${environment},role:backend"
  DD_APM_INSTRUMENTATION_ENABLED=host bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
  systemctl start datadog-agent
  systemctl enable datadog-agent
fi
