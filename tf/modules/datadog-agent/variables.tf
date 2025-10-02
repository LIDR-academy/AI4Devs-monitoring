# ============================================================================
# DATADOG AGENT MODULE - VARIABLES
# ============================================================================

variable "hostname" {
  description = "Hostname for the Datadog agent (must be unique)"
  type        = string

  validation {
    condition     = length(var.hostname) > 0 && length(var.hostname) <= 255
    error_message = "Hostname must be between 1 and 255 characters"
  }
}

variable "aws_region" {
  description = "AWS region where the instance is deployed"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "Must be a valid AWS region format"
  }
}

variable "datadog_site" {
  description = "Datadog site URL (e.g., datadoghq.com, datadoghq.eu)"
  type        = string
  default     = "datadoghq.com"

  validation {
    condition = contains([
      "datadoghq.com",
      "datadoghq.eu",
      "us3.datadoghq.com",
      "us5.datadoghq.com",
      "ap1.datadoghq.com",
      "ddog-gov.com"
    ], var.datadog_site)
    error_message = "Invalid Datadog site"
  }
}

variable "datadog_api_key_parameter" {
  description = "SSM Parameter Store path for Datadog API key"
  type        = string
  default     = "/lti-project/datadog/api-key"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "service_name" {
  description = "Service name for tagging (e.g., lti-backend, lti-frontend)"
  type        = string

  validation {
    condition     = length(var.service_name) > 0
    error_message = "Service name cannot be empty"
  }
}

variable "additional_tags" {
  description = "Additional Datadog tags in 'key:value' format"
  type        = list(string)
  default     = []
}

variable "enable_logs" {
  description = "Enable Datadog log collection"
  type        = bool
  default     = false
}

variable "enable_process_monitoring" {
  description = "Enable Datadog process monitoring"
  type        = bool
  default     = true
}

