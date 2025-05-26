variable "datadog_secret_arn" {
  description = "ARN del secreto en AWS Secrets Manager que contiene las claves de API de Datadog"
  type        = string
  default     = "datadog/ai4devs/secret"
}

variable "datadog_site" {
  description = "URL del sitio de Datadog"
  type        = string
  default     = "datadoghq.eu"
}

variable "environment" {
  description = "Ambiente de despliegue (production, staging, development)"
  type        = string
  default     = "production"
}

variable "datadog_tags" {
  description = "Tags globales para todos los recursos monitoreados por Datadog"
  type        = map(string)
  default     = {
    project     = "ai4devs"
    managed_by  = "terraform"
    environment = "production"
  }
}

variable "enable_datadog_monitoring" {
  description = "Habilita o deshabilita el monitoreo de Datadog"
  type        = bool
  default     = true
}

variable "datadog_agent_version" {
  description = "Versión del agente de Datadog a instalar"
  type        = string
  default     = "7"  # Versión 7 es la más reciente y estable
}

# Variables para configuración de métricas
variable "datadog_metrics_collection_interval" {
  description = "Intervalo de recolección de métricas en segundos"
  type        = number
  default     = 15
}

# Variables para configuración de logs
variable "datadog_enable_log_collection" {
  description = "Habilita o deshabilita la recolección de logs"
  type        = bool
  default     = true
}

variable "datadog_log_collection_config" {
  description = "Configuración para la recolección de logs"
  type        = map(string)
  default     = {
    docker_logs = "true"
    system_logs = "true"
  }
}
