# Archivo de ejemplo para las variables de Terraform
# Copia este archivo como terraform.tfvars y configura tus valores

# Datadog API Keys
# Obtén estos valores desde tu cuenta de Datadog:
# - API Key: https://app.datadoghq.com/organization-settings/application-keys
# - App Key: https://app.datadoghq.com/organization-settings/application-keys
datadog_api_key = "4a84550c3d7cab2eef7a3d3b566a8c71"
datadog_app_key = "a72f916703807a3a125d2bdef4d6beb8fac98e83"

# AWS Account ID
# Puedes obtenerlo ejecutando: aws sts get-caller-identity --query Account --output text
aws_account_id = "273995959520"
