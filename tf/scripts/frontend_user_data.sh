#!/bin/bash
sudo yum update -y
sudo yum install -y docker

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

# Timestamp to force update
echo "Timestamp: ${timestamp}"

# ------------------------------------------------------------------------------
# Datadog Agent
# ------------------------------------------------------------------------------
if [ -n "${dd_api_key}" ]; then
  export DD_API_KEY="${dd_api_key}"
  export DD_SITE="${dd_site}"
  export DD_TAGS="env:${environment},role:frontend"
  DD_APM_INSTRUMENTATION_ENABLED=host bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
  systemctl start datadog-agent
  systemctl enable datadog-agent
fi
