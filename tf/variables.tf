variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog APP Key"
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "Datadog API URL (https://api.datadoghq.com for US, https://api.datadoghq.eu for EU)"
  type        = string
  default     = "https://api.datadoghq.eu"
}
