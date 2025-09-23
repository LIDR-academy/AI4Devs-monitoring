#!/bin/bash
# Datadog Agent Installation Script for Backend Instance
# Execute this script directly on the backend EC2 instance

set -euo pipefail

# Configuration
DATADOG_API_KEY="YOUR_DATADOG_API_KEY"
DATADOG_SITE="datadoghq.eu"
SERVER_NAME="backend"
SERVICE_NAME="lti-backend"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Main installation function
main() {
    log "Starting Datadog Agent installation on Backend..."
    
    # Step 1: Update system
    log "Updating system packages..."
    sudo yum update -y
    
    # Step 2: Install required packages
    log "Installing required packages..."
    sudo yum install -y curl wget
    
    # Step 3: Download and install Datadog Agent
    log "Downloading and installing Datadog Agent..."
    DD_AGENT_MAJOR_VERSION=7 DD_API_KEY="$DATADOG_API_KEY" DD_SITE="$DATADOG_SITE" \
        sudo bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
    
    # Step 4: Get instance ID for hostname
    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    HOSTNAME="${SERVER_NAME}-${INSTANCE_ID}"
    
    # Step 5: Configure Datadog Agent
    log "Configuring Datadog Agent..."
    sudo tee /etc/datadog-agent/datadog.yaml > /dev/null << EOF
api_key: $DATADOG_API_KEY
site: $DATADOG_SITE
hostname: $HOSTNAME

# Backend-specific configuration
logs_enabled: true
apm_config:
  enabled: true
  env: dev
  service: $SERVICE_NAME
  version: 1.0.0

# Process monitoring for Docker containers
process_config:
  enabled: true

# Container monitoring
container_config:
  enabled: true

# Tags for backend
tags:
  - env:dev
  - service:$SERVICE_NAME
  - component:$SERVER_NAME
  - free_tier:optimized
  - managed_by:terraform
EOF

    # Step 6: Configure Docker integration
    log "Configuring Docker integration..."
    sudo mkdir -p /etc/datadog-agent/conf.d/docker.d
    sudo tee /etc/datadog-agent/conf.d/docker.d/docker.yaml > /dev/null << EOF
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

    # Step 7: Set proper permissions
    log "Setting proper permissions..."
    sudo chown -R dd-agent:dd-agent /etc/datadog-agent/
    sudo chmod -R 755 /etc/datadog-agent/

    # Step 8: Start Datadog Agent
    log "Starting Datadog Agent..."
    sudo systemctl enable datadog-agent
    sudo systemctl start datadog-agent

    # Step 9: Wait for agent to start
    log "Waiting for Datadog Agent to start..."
    sleep 15

    # Step 10: Check agent status
    if sudo systemctl is-active --quiet datadog-agent; then
        success "Datadog Agent started successfully"
    else
        error "Failed to start Datadog Agent"
        sudo systemctl status datadog-agent
        exit 1
    fi

    # Step 11: Create health check script
    log "Creating health check script..."
    sudo tee /usr/local/bin/backend-health-check.sh > /dev/null << 'EOF'
#!/bin/bash
# Backend Health Check Script

check_docker() {
    if docker ps | grep -q lti-backend-container; then
        echo "✅ Backend Docker container is running"
        return 0
    else
        echo "❌ Backend Docker container is not running"
        return 1
    fi
}

check_application() {
    if curl -f http://localhost:8080 >/dev/null 2>&1; then
        echo "✅ Backend application is responding on port 8080"
        return 0
    else
        echo "❌ Backend application is not responding on port 8080"
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
    echo "🔍 Backend Health Check"
    echo "======================="
    
    check_docker
    check_application
    check_datadog
    
    echo "======================="
    echo "Health check completed"
}

main "$@"
EOF

    sudo chmod +x /usr/local/bin/backend-health-check.sh

    # Step 12: Create systemd service for health monitoring
    log "Creating health monitoring service..."
    sudo tee /etc/systemd/system/backend-health-monitor.service > /dev/null << EOF
[Unit]
Description=Backend Health Monitor
After=datadog-agent.service
Requires=datadog-agent.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backend-health-check.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    # Step 13: Create timer for periodic health checks
    sudo tee /etc/systemd/system/backend-health-monitor.timer > /dev/null << EOF
[Unit]
Description=Run Backend Health Check every 2 minutes
Requires=backend-health-monitor.service

[Timer]
OnBootSec=2min
OnUnitActiveSec=2min

[Install]
WantedBy=timers.target
EOF

    # Step 14: Enable and start health monitoring
    sudo systemctl daemon-reload
    sudo systemctl enable backend-health-monitor.timer
    sudo systemctl start backend-health-monitor.timer

    # Step 15: Final verification
    log "Performing final verification..."
    sleep 30

    if /usr/local/bin/backend-health-check.sh; then
        success "🎉 Backend setup completed successfully!"
        success "📊 Datadog Agent is monitoring the backend"
        success "🔍 Health monitoring is enabled"
    else
        warning "⚠️ Some components may need attention"
    fi

    # Step 16: Show status
    log "Datadog Agent status:"
    sudo systemctl status datadog-agent --no-pager -l

    success "Backend Datadog Agent installation completed!"
    log "You can run health checks with: /usr/local/bin/backend-health-check.sh"
}

# Run main function
main "$@"
