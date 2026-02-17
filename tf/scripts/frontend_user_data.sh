#!/bin/bash
set -e

# ==========================================
# System Setup
# ==========================================
yum update -y
yum install -y docker unzip aws-cli

# Start Docker service
systemctl start docker
systemctl enable docker

# ==========================================
# Download and deploy frontend
# ==========================================
aws s3 cp s3://${s3_bucket}/frontend.zip /home/ec2-user/frontend.zip
unzip /home/ec2-user/frontend.zip -d /home/ec2-user/

# Build the Docker image
cd /home/ec2-user/frontend
docker build -t lti-frontend .

# Run the frontend container with Datadog env vars
docker run -d \
  --name lti-frontend \
  --restart unless-stopped \
  -p 3000:3000 \
  -e NODE_ENV=production \
  -e REACT_APP_BACKEND_URL=http://${backend_private_ip}:8080 \
  -e DD_SERVICE=lti-frontend \
  -e DD_ENV=${environment} \
  -e DD_VERSION=${app_version} \
  lti-frontend

# ==========================================
# Datadog Agent Installation
# ==========================================
DD_API_KEY="${datadog_api_key}" \
DD_SITE="${datadog_site}" \
DD_HOST_TAGS="env:${environment},service:frontend,role:web,project:lti-recruiter" \
DD_APM_ENABLED=true \
DD_LOGS_ENABLED=true \
DD_PROCESS_AGENT_ENABLED=true \
bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"

# Configure Docker log collection
mkdir -p /etc/datadog-agent/conf.d/docker.d
cat <<EOF > /etc/datadog-agent/conf.d/docker.d/conf.yaml
init_config:

instances: []

logs:
  - type: docker
    service: lti-frontend
    source: nodejs
EOF

# Configure HTTP health check for frontend
mkdir -p /etc/datadog-agent/conf.d/http_check.d
cat <<EOF > /etc/datadog-agent/conf.d/http_check.d/conf.yaml
init_config:

instances:
  - name: frontend_health
    url: http://localhost:3000/
    timeout: 5
    http_response_status_code: 200
    tags:
      - service:lti-frontend
      - env:${environment}
EOF

# Add dd-agent to docker group for container monitoring
usermod -aG docker dd-agent

# Restart Datadog agent
systemctl restart datadog-agent

# Timestamp to force update
echo "Timestamp: ${timestamp}"
