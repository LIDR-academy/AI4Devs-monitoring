#!/bin/bash
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${datadog_api_key} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Configure the agent
cat > /etc/datadog-agent/datadog.yaml << EOL
api_key: ${datadog_api_key}
site: datadoghq.com
tags:
  - env:${environment}
  - project:${project_name}
logs:
  enabled: true
EOL

# Restart the agent
systemctl restart datadog-agent 