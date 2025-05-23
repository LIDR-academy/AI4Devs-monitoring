variable "datadog_aws_account_id" {
  description = "ID de cuenta de AWS de Datadog para la integraci�n"
  type        = string
  default     = "464622532012"
}

variable "datadog_integration_role_name" {
  description = "Nombre del rol IAM para la integraci�n con Datadog"
  type        = string
  default     = "DatadogAWSIntegrationRole"
}

variable "datadog_external_id" {
  description = "External ID proporcionado por Datadog para la integraci�n con AWS"
  type        = string
  sensitive   = true
  # El valor real debe proporcionarse durante la aplicaci�n o definirse en un archivo terraform.tfvars
  # Nota: Este valor se obtendr� de la consola de Datadog durante la configuraci�n de la integraci�n
}

variable "datadog_aws_resources_prefix" {
  description = "Prefijo para los recursos AWS creados para Datadog"
  type        = string
  default     = "datadog"
}

variable "datadog_api_key" {
  description = "API key de Datadog para la autenticaci�n"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Application key de Datadog para la autenticaci�n"
  type        = string
  sensitive   = true
}

variable "datadog_agent_api_key" {
  description = "API key de Datadog para el agente instalado en las instancias EC2"
  type        = string
  sensitive   = true
  # Por defecto usamos la misma API key que para la integraci�n general
  default     = ""
}
