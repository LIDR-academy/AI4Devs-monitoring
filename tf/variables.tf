variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.datadog_api_key == null || length(var.datadog_api_key) == 32
    error_message = "Datadog API key must be exactly 32 characters."
  }
}

variable "datadog_app_key" {
  description = "Datadog Application Key"
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.datadog_app_key == null || length(var.datadog_app_key) == 40
    error_message = "Datadog App key must be exactly 40 characters."
  }
}

variable "datadog_site" {
  description = "Datadog site (datadoghq.com, datadoghq.eu, etc.)"
  type        = string
  default     = "datadoghq.eu"
  validation {
    condition     = contains(["datadoghq.com", "datadoghq.eu", "us3.datadoghq.com", "us5.datadoghq.com", "ddog-gov.com"], var.datadog_site)
    error_message = "Datadog site must be one of the valid Datadog sites."
  }
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "AWS region must be in the format 'region-zone-number' (e.g., us-east-1)."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "ai4devs-monitoring"
}

variable "free_tier_optimized" {
  description = "Enable optimizations for AWS Free Tier and Datadog Free Plan"
  type        = bool
  default     = true
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
