#!/bin/bash
# ============================================================================
# DATADOG AGENT INSTALLATION SCRIPT
# ============================================================================
# This script securely installs and configures the Datadog agent on Amazon Linux 2
# It retrieves the API key from AWS SSM Parameter Store at runtime (never hardcoded)
#
# Security Features:
# - API key retrieved securely from SSM via IAM instance profile
# - Fail-fast mode (set -euo pipefail)
# - API key never exposed in logs or process list
# - Restricted file permissions on API key file
# ============================================================================

set -euo pipefail

# Configuration from Terraform variables
export AWS_REGION="${aws_region}"
export DD_SITE="${datadog_site}"
export DD_API_KEY_SSM_PARAM="${datadog_api_key_parameter}"
export DD_AGENT_MAJOR_VERSION=7
export DD_INSTALL_ONLY=false
export DD_HOSTNAME="${hostname}"

# Datadog tags (for resource grouping and filtering)
export DD_TAGS="${tags}"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/datadog-install.log
}

log "=========================================="
log "Starting Datadog Agent Installation"
log "=========================================="
log "Hostname: $DD_HOSTNAME"
log "Datadog Site: $DD_SITE"
log "AWS Region: $AWS_REGION"
log "Tags: $DD_TAGS"

# ------------------------------------------------------------------------------
# Step 1: Retrieve Datadog API Key from SSM Parameter Store
# ------------------------------------------------------------------------------

log "Retrieving Datadog API key from SSM Parameter Store..."

# Check if AWS CLI is available
if ! command -v aws &> /dev/null; then
    log "ERROR: AWS CLI not found. Installing..."
    yum install -y aws-cli
fi

# Retrieve API key with retry logic
MAX_RETRIES=5
RETRY_COUNT=0
DD_API_KEY=""

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if DD_API_KEY=$(aws ssm get-parameter \
        --name "$DD_API_KEY_SSM_PARAM" \
        --with-decryption \
        --region "$AWS_REGION" \
        --query 'Parameter.Value' \
        --output text 2>/dev/null); then
        log "✓ Successfully retrieved API key from SSM"
        break
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        log "⚠ Attempt $RETRY_COUNT/$MAX_RETRIES failed. Retrying in 5 seconds..."
        sleep 5
    fi
done

if [ -z "$DD_API_KEY" ]; then
    log "ERROR: Failed to retrieve Datadog API key from SSM after $MAX_RETRIES attempts"
    log "Please verify:"
    log "  1. SSM parameter exists: $DD_API_KEY_SSM_PARAM"
    log "  2. IAM instance profile has ssm:GetParameter permission"
    log "  3. Parameter is in region: $AWS_REGION"
    exit 1
fi

# Validate API key format (basic check)
if [ ${#DD_API_KEY} -lt 32 ]; then
    log "ERROR: Retrieved API key appears invalid (too short)"
    exit 1
fi

log "✓ API key validated"

# ------------------------------------------------------------------------------
# Step 2: Download and Install Datadog Agent
# ------------------------------------------------------------------------------

log "Downloading Datadog Agent installation script..."

# Download official Datadog installation script
if ! curl -fsSL https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh -o /tmp/install_datadog.sh; then
    log "ERROR: Failed to download Datadog installation script"
    exit 1
fi

log "✓ Installation script downloaded"
log "Installing Datadog Agent (this may take a few minutes)..."

# Run installation script
if bash /tmp/install_datadog.sh; then
    log "✓ Datadog Agent installed successfully"
else
    log "ERROR: Datadog Agent installation failed"
    exit 1
fi

# ------------------------------------------------------------------------------
# Step 3: Configure Datadog Agent
# ------------------------------------------------------------------------------

log "Configuring Datadog Agent..."

# Create API key file with restricted permissions
log "Setting API key..."
install -m 0640 -o dd-agent -g dd-agent /dev/null /etc/datadog-agent/datadog.yaml.tmp

# Write minimal configuration
cat > /etc/datadog-agent/datadog.yaml.tmp <<EOF
# Datadog Agent Configuration
# Managed by Terraform - Do not edit manually

api_key: $DD_API_KEY
site: $DD_SITE
hostname: $DD_HOSTNAME

# Tags for this host
tags:
  - $DD_TAGS

# Log collection (${enable_logs ? "enabled" : "disabled"})
logs_enabled: ${enable_logs ? "true" : "false"}

# APM (disabled by default)
apm_config:
  enabled: false

# Process monitoring
process_config:
  enabled: ${enable_process_monitoring ? "true" : "false"}

# Network monitoring (disabled by default)
network_config:
  enabled: false

# System probe (disabled by default)
system_probe_config:
  enabled: false
EOF

# Move config to final location
mv /etc/datadog-agent/datadog.yaml.tmp /etc/datadog-agent/datadog.yaml
chown dd-agent:dd-agent /etc/datadog-agent/datadog.yaml
chmod 640 /etc/datadog-agent/datadog.yaml

log "✓ Configuration file created"

# ------------------------------------------------------------------------------
# Step 4: Enable and Start Datadog Agent Service
# ------------------------------------------------------------------------------

log "Starting Datadog Agent service..."

# Enable service to start on boot
if systemctl enable datadog-agent; then
    log "✓ Datadog Agent enabled for auto-start"
else
    log "ERROR: Failed to enable Datadog Agent service"
    exit 1
fi

# Start the service
if systemctl start datadog-agent; then
    log "✓ Datadog Agent service started"
else
    log "ERROR: Failed to start Datadog Agent service"
    systemctl status datadog-agent --no-pager
    exit 1
fi

# Wait for agent to initialize
log "Waiting for agent to initialize (10 seconds)..."
sleep 10

# ------------------------------------------------------------------------------
# Step 5: Verify Installation
# ------------------------------------------------------------------------------

log "Verifying Datadog Agent installation..."

# Check service status
if systemctl is-active --quiet datadog-agent; then
    log "✓ Datadog Agent service is running"
else
    log "ERROR: Datadog Agent service is not running"
    systemctl status datadog-agent --no-pager
    exit 1
fi

# Check agent status
if datadog-agent status &> /tmp/dd-agent-status.txt; then
    log "✓ Datadog Agent is operational"
    
    # Log key information (without exposing API key)
    grep -i "Running Checks" /tmp/dd-agent-status.txt | head -5 >> /var/log/datadog-install.log || true
    
    log "Agent status saved to: /tmp/dd-agent-status.txt"
else
    log "⚠ Warning: Agent status check returned non-zero exit code"
    log "This may be normal during initial startup. Check /var/log/datadog/agent.log"
fi

# ------------------------------------------------------------------------------
# Step 6: Clean Up
# ------------------------------------------------------------------------------

log "Cleaning up..."

# Remove installation script
rm -f /tmp/install_datadog.sh

# Clear API key from environment (security)
unset DD_API_KEY

# Ensure API key is not in process list or logs
log "✓ API key cleared from memory"

log "=========================================="
log "Datadog Agent Installation Complete!"
log "=========================================="
log ""
log "Next Steps:"
log "  1. Verify host appears in Datadog: https://app.$DD_SITE/infrastructure"
log "  2. Check metrics: https://app.$DD_SITE/metric/explorer"
log "  3. View agent status: sudo datadog-agent status"
log "  4. Check agent logs: sudo tail -f /var/log/datadog/agent.log"
log ""
log "Installation log saved to: /var/log/datadog-install.log"
log "=========================================="

exit 0

