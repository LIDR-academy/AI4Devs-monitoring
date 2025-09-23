#!/bin/bash
set -euo pipefail

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/user-data.log
}

log "Starting frontend instance setup..."

# Update system
log "Updating system packages..."
yum update -y

# Install Docker and AWS CLI
log "Installing Docker and AWS CLI..."
yum install -y docker awscli

# Start Docker service
log "Starting Docker service..."
service docker start
systemctl enable docker

# Configure AWS CLI (using IAM role)
log "Configuring AWS CLI..."
aws configure set region us-east-1

# Download and extract frontend code from S3
log "Downloading frontend code from S3..."
BUCKET_NAME=$(aws s3 ls | grep ai4devs-project-code-bucket | awk '{print $3}' | head -1)
if [ -z "$BUCKET_NAME" ]; then
    log "ERROR: Could not find S3 bucket"
    exit 1
fi

aws s3 cp s3://$BUCKET_NAME/frontend.zip /home/ec2-user/frontend.zip
unzip /home/ec2-user/frontend.zip -d /home/ec2-user/

# Build Docker image
log "Building Docker image..."
cd /home/ec2-user/frontend
docker build -t lti-frontend .

# Run Docker container
log "Starting Docker container..."
docker run -d -p 3000:3000 --name lti-frontend-container lti-frontend

# Install Datadog Agent
log "Installing Datadog Agent..."
export DD_API_KEY="${datadog_api_key}"
export DD_SITE="${datadog_site}"
export DD_ENV="dev"
export DD_SERVICE="lti-frontend"
export DD_VERSION="1.0.0"
export DD_HOSTNAME="frontend-$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"

# Download and run Datadog Agent installation script
curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/main/cmd/agent/install_script.sh > /tmp/install_datadog.sh
chmod +x /tmp/install_datadog.sh
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY="$DD_API_KEY" DD_SITE="$DD_SITE" /tmp/install_datadog.sh

# Configure Datadog Agent for frontend
log "Configuring Datadog Agent for frontend..."
cat > /etc/datadog-agent/datadog.yaml << EOF
api_key: $DD_API_KEY
site: $DD_SITE
hostname: $DD_HOSTNAME

# Frontend-specific configuration
logs_enabled: true
apm_config:
  enabled: true
  env: dev
  service: lti-frontend
  version: 1.0.0

# Process monitoring for Docker containers
process_config:
  enabled: true

# Container monitoring
container_config:
  enabled: true

# Tags for frontend
tags:
  - env:dev
  - service:lti-frontend
  - component:frontend
  - free_tier:optimized
  - managed_by:terraform
EOF

# Configure Docker integration
log "Configuring Docker integration..."
cat > /etc/datadog-agent/conf.d/docker.d/docker.yaml << EOF
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

# Start Datadog Agent
log "Starting Datadog Agent..."
systemctl enable datadog-agent
systemctl start datadog-agent

# Create health check script
log "Creating health check script..."
cat > /usr/local/bin/frontend-health-check.sh << 'EOF'
#!/bin/bash
# Frontend Health Check Script

check_docker() {
    if docker ps | grep -q lti-frontend-container; then
        echo "✅ Frontend Docker container is running"
        return 0
    else
        echo "❌ Frontend Docker container is not running"
        return 1
    fi
}

check_application() {
    if curl -f http://localhost:3000 >/dev/null 2>&1; then
        echo "✅ Frontend application is responding"
        return 0
    else
        echo "❌ Frontend application is not responding"
        return 1
    fi
}

check_datadog() {
    if systemctl is-active --quiet datadog-agent; then
        echo "✅ Datadog Agent is running"
        return 0
    else
        echo "❌ Datadog Agent is not running"
        return 1
    fi
}

main() {
    echo "🔍 Frontend Health Check"
    echo "========================"
    
    check_docker
    check_application
    check_datadog
    
    echo "========================"
    echo "Health check completed"
}

main "$@"
EOF

chmod +x /usr/local/bin/frontend-health-check.sh

# Create systemd service for health monitoring
cat > /etc/systemd/system/frontend-health-monitor.service << EOF
[Unit]
Description=Frontend Health Monitor
After=datadog-agent.service
Requires=datadog-agent.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/frontend-health-check.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Create timer for periodic health checks
cat > /etc/systemd/system/frontend-health-monitor.timer << EOF
[Unit]
Description=Run Frontend Health Check every 2 minutes
Requires=frontend-health-monitor.service

[Timer]
OnBootSec=2min
OnUnitActiveSec=2min

[Install]
WantedBy=timers.target
EOF

# Enable and start health monitoring
systemctl daemon-reload
systemctl enable frontend-health-monitor.timer
systemctl start frontend-health-monitor.timer

# Final verification
log "Performing final verification..."
sleep 30

if /usr/local/bin/frontend-health-check.sh; then
    log "🎉 Frontend setup completed successfully!"
    log "📊 Datadog Agent is monitoring the frontend"
    log "🔍 Health monitoring is enabled"
else
    log "⚠️ Some components may need attention"
fi

# Timestamp to force update
echo "Timestamp: ${timestamp}"
log "Frontend instance setup completed"
