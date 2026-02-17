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
# Download and deploy backend
# ==========================================
aws s3 cp s3://${s3_bucket}/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Build the Docker image
cd /home/ec2-user/backend
docker build -t lti-backend .

# Run the backend container with Datadog env vars
docker run -d \
  --name lti-backend \
  --restart unless-stopped \
  -p 8080:8080 \
  -e DATABASE_URL="postgresql://${db_user}:${db_password}@localhost:5432/${db_name}" \
  -e NODE_ENV=production \
  -e DD_AGENT_HOST=localhost \
  -e DD_TRACE_AGENT_PORT=8126 \
  -e DD_SERVICE=lti-backend \
  -e DD_ENV=${environment} \
  -e DD_VERSION=${app_version} \
  -e DD_LOGS_INJECTION=true \
  -e DD_TRACE_ENABLED=true \
  lti-backend

# ==========================================
# Datadog Agent Installation
# ==========================================
DD_API_KEY="${datadog_api_key}" \
DD_SITE="${datadog_site}" \
DD_HOST_TAGS="env:${environment},service:backend,role:api,project:lti-recruiter" \
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
    service: lti-backend
    source: nodejs
EOF

# Configure HTTP health check for backend
mkdir -p /etc/datadog-agent/conf.d/http_check.d
cat <<EOF > /etc/datadog-agent/conf.d/http_check.d/conf.yaml
init_config:

instances:
  - name: backend_health
    url: http://localhost:8080/
    timeout: 5
    http_response_status_code: 200
    tags:
      - service:lti-backend
      - env:${environment}
EOF

# Add dd-agent to docker group for container monitoring
usermod -aG docker dd-agent

# Restart Datadog agent
systemctl restart datadog-agent

# Timestamp to force update
echo "Timestamp: ${timestamp}"
