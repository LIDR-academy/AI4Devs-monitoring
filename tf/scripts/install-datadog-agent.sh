#!/bin/bash
# Datadog Agent Installation Script - Optimized for Free Tier
# This script installs and configures the Datadog Agent with minimal resource usage

set -euo pipefail

# Configuration variables
DD_API_KEY="${DD_API_KEY:-}"
DD_SITE="${DD_SITE:-datadoghq.eu}"
DD_ENV="${DD_ENV:-dev}"
DD_SERVICE="${DD_SERVICE:-aws-ec2}"
DD_VERSION="${DD_VERSION:-1.0.0}"
DD_HOSTNAME="${DD_HOSTNAME:-$(hostname)}"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a /var/log/datadog-install.log
}

# Error handling
error_exit() {
    log "ERROR: $1"
    exit 1
}

# Check if API key is provided
if [ -z "$DD_API_KEY" ]; then
    error_exit "DD_API_KEY environment variable is required"
fi

log "Starting Datadog Agent installation for Free Tier optimization..."

# Update system packages
log "Updating system packages..."
yum update -y

# Install required packages
log "Installing required packages..."
yum install -y curl wget

# Download and install Datadog Agent
log "Downloading Datadog Agent..."
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY="$DD_API_KEY" DD_SITE="$DD_SITE" \
    bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configure Datadog Agent for Free Tier
log "Configuring Datadog Agent for Free Tier..."

# Create custom configuration file
cat > /etc/datadog-agent/datadog.yaml << EOF
# Datadog Agent Configuration - Optimized for Free Tier
api_key: $DD_API_KEY
site: $DD_SITE
hostname: $DD_HOSTNAME

# Basic configuration
dd_url: https://app.$DD_SITE
logs_enabled: false
apm_config:
  enabled: false
  env: $DD_ENV
  service: $DD_SERVICE
  version: $DD_VERSION

# Process monitoring - minimal for Free Tier
process_config:
  enabled: false

# Network monitoring - minimal for Free Tier
network_config:
  enabled: false

# Container monitoring - disabled for Free Tier
container_config:
  enabled: false

# Log collection - minimal for Free Tier
logs_config:
  auto_multi_line_detection: false

# Metrics - only essential ones
dogstatsd_metrics_stats_enable: false
dogstatsd_original_metrics: false

# Performance optimization for Free Tier
check_runners: 1
check_frequency: 30
forwarder_timeout: 20
forwarder_retry_queue_max_size: 10

# Resource limits
max_connections: 5
max_memory_usage: 256

# Tags for identification
tags:
  - env:$DD_ENV
  - service:$DD_SERVICE
  - version:$DD_VERSION
  - free_tier:optimized
  - managed_by:terraform
EOF

# Create minimal check configuration
log "Creating minimal check configuration..."
mkdir -p /etc/datadog-agent/conf.d

# Basic system check
cat > /etc/datadog-agent/conf.d/system_check.yaml << EOF
# Basic system monitoring for Free Tier
init_config:

instances:
  - cpu_check_interval: 30
    disk_check_interval: 60
    load_check_interval: 30
    memory_check_interval: 30
    network_check_interval: 60
    process_check_interval: 60
    io_check_interval: 60
EOF

# Configure log collection - minimal for Free Tier
log "Configuring minimal log collection..."
cat > /etc/datadog-agent/conf.d/log_collection.yaml << EOF
# Minimal log collection for Free Tier
logs:
  - type: file
    path: /var/log/messages
    service: system
    source: syslog
    log_processing_rules:
      - type: exclude_at_match
        name: exclude_debug
        pattern: ".*DEBUG.*"
  
  - type: file
    path: /var/log/secure
    service: system
    source: auth
    log_processing_rules:
      - type: exclude_at_match
        name: exclude_debug
        pattern: ".*DEBUG.*"
EOF

# Set proper permissions
log "Setting proper permissions..."
chown -R dd-agent:dd-agent /etc/datadog-agent/
chmod -R 755 /etc/datadog-agent/

# Enable and start Datadog Agent
log "Enabling and starting Datadog Agent..."
systemctl enable datadog-agent
systemctl start datadog-agent

# Wait for agent to start
log "Waiting for Datadog Agent to start..."
sleep 10

# Check agent status
if systemctl is-active --quiet datadog-agent; then
    log "✅ Datadog Agent started successfully"
else
    error_exit "❌ Failed to start Datadog Agent"
fi

# Verify agent configuration
log "Verifying agent configuration..."
if /opt/datadog-agent/bin/agent/agent status | grep -q "Agent (v7"; then
    log "✅ Datadog Agent is running and configured"
else
    error_exit "❌ Datadog Agent configuration verification failed"
fi

# Create health check script
log "Creating health check script..."
cat > /usr/local/bin/datadog-health-check.sh << 'EOF'
#!/bin/bash
# Datadog Agent Health Check Script

check_agent_status() {
    if systemctl is-active --quiet datadog-agent; then
        echo "✅ Datadog Agent is running"
        return 0
    else
        echo "❌ Datadog Agent is not running"
        return 1
    fi
}

check_agent_config() {
    if /opt/datadog-agent/bin/agent/agent status >/dev/null 2>&1; then
        echo "✅ Datadog Agent configuration is valid"
        return 0
    else
        echo "❌ Datadog Agent configuration is invalid"
        return 1
    fi
}

check_agent_connectivity() {
    if /opt/datadog-agent/bin/agent/agent status | grep -q "Forwarder"; then
        echo "✅ Datadog Agent can connect to Datadog"
        return 0
    else
        echo "❌ Datadog Agent cannot connect to Datadog"
        return 1
    fi
}

main() {
    echo "🔍 Datadog Agent Health Check"
    echo "=============================="
    
    check_agent_status
    check_agent_config
    check_agent_connectivity
    
    echo "=============================="
    echo "Health check completed"
}

main "$@"
EOF

chmod +x /usr/local/bin/datadog-health-check.sh

# Create systemd service for health monitoring
log "Creating health monitoring service..."
cat > /etc/systemd/system/datadog-health-monitor.service << EOF
[Unit]
Description=Datadog Agent Health Monitor
After=datadog-agent.service
Requires=datadog-agent.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/datadog-health-check.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Create timer for periodic health checks
cat > /etc/systemd/system/datadog-health-monitor.timer << EOF
[Unit]
Description=Run Datadog Agent Health Check every 5 minutes
Requires=datadog-health-monitor.service

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
EOF

# Enable and start health monitoring
systemctl daemon-reload
systemctl enable datadog-health-monitor.timer
systemctl start datadog-health-monitor.timer

# Final verification
log "Performing final verification..."
if /usr/local/bin/datadog-health-check.sh; then
    log "🎉 Datadog Agent installation completed successfully!"
    log "📊 Agent is optimized for Free Tier usage"
    log "🔍 Health monitoring is enabled"
    log "📝 Logs are available at /var/log/datadog-install.log"
else
    error_exit "❌ Final verification failed"
fi

log "Datadog Agent installation completed successfully!"
