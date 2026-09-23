# ------------------------------------------------------------------------------
# AWS
# ------------------------------------------------------------------------------
variable "aws_region" {
  description = "Región AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "ID de la cuenta AWS (requerido para integración Datadog)"
  type        = string
}

variable "environment" {
  description = "Entorno (ej. staging, prod)"
  type        = string
  default     = "staging"
}

# ------------------------------------------------------------------------------
# Datadog
# ------------------------------------------------------------------------------
variable "datadog_api_key" {
  description = "API Key de Datadog (provider y agente en EC2)"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Application Key de Datadog (API completa del provider)"
  type        = string
  sensitive   = true
}

variable "datadog_site" {
  description = "Sitio Datadog (ej. datadoghq.com, datadoghq.eu)"
  type        = string
  default     = "datadoghq.com"
}

variable "datadog_integration_role_name" {
  description = "Nombre del IAM role para la integración AWS-Datadog"
  type        = string
  default     = "DatadogIntegrationRole"
}

# Cuenta AWS de Datadog que asumirá el role (según sitio: datadoghq.com=464622532012, datadoghq.eu=...)
variable "datadog_aws_principal_account_id" {
  description = "AWS Account ID de Datadog para la trust policy (464622532012 para US)"
  type        = string
  default     = "464622532012"
}
