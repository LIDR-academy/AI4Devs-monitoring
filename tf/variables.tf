# ============================================================================
# TERRAFORM VARIABLES WITH VALIDATION
# ============================================================================
# All variables include descriptions, types, and validation where applicable.
# Sensitive variables are marked to prevent exposure in logs.
# ============================================================================

# ------------------------------------------------------------------------------
# AWS Configuration
# ------------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "AWS region must be valid format (e.g., us-east-1, eu-west-1)"
  }
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "lti-project"

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 32
    error_message = "Project name must be between 1 and 32 characters"
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "team_name" {
  description = "Team name for resource tagging and cost allocation"
  type        = string
  default     = "platform-engineering"
}

# ------------------------------------------------------------------------------
# Datadog Configuration
# ------------------------------------------------------------------------------

variable "datadog_site" {
  description = "Datadog site URL (datadoghq.com, datadoghq.eu, us3.datadoghq.com, etc.)"
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
    error_message = "Invalid Datadog site. Must be one of the official Datadog sites"
  }
}

variable "datadog_api_url" {
  description = "Datadog API URL (derived from datadog_site)"
  type        = string
  default     = "https://api.datadoghq.com"
}

variable "datadog_api_key" {
  description = "Datadog API key (use environment variable DD_API_KEY instead)"
  type        = string
  default     = "" # Empty by default, forces env var usage
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog Application key (use environment variable DD_APP_KEY instead)"
  type        = string
  default     = "" # Empty by default, forces env var usage
  sensitive   = true
}

variable "datadog_external_id" {
  description = "External ID for Datadog AWS integration (auto-generated if not provided)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_datadog_logs" {
  description = "Enable log collection in Datadog (increases costs)"
  type        = bool
  default     = false
}

variable "enable_datadog_cspm" {
  description = "Enable Cloud Security Posture Management in Datadog"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# SSM Parameter Store Configuration
# ------------------------------------------------------------------------------

variable "datadog_api_key_ssm_parameter" {
  description = "SSM Parameter Store path for Datadog API key"
  type        = string
  default     = "/lti-project/datadog/api-key"
}

variable "datadog_app_key_ssm_parameter" {
  description = "SSM Parameter Store path for Datadog APP key"
  type        = string
  default     = "/lti-project/datadog/app-key"
}

# ------------------------------------------------------------------------------
# EC2 Configuration
# ------------------------------------------------------------------------------

variable "backend_instance_type" {
  description = "EC2 instance type for backend service"
  type        = string
  default     = "t2.micro"
}

variable "frontend_instance_type" {
  description = "EC2 instance type for frontend service"
  type        = string
  default     = "t2.medium"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Amazon Linux 2)"
  type        = string
  default     = "ami-075d39ebbca89ed55" # Amazon Linux 2 in us-east-1
}

variable "enable_datadog_agent" {
  description = "Install Datadog agent on EC2 instances via user_data"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# Monitoring Configuration
# ------------------------------------------------------------------------------

variable "datadog_tags" {
  description = "Additional tags to apply to Datadog resources"
  type        = map(string)
  default = {
    service = "lti-project"
  }
}

variable "create_datadog_dashboard" {
  description = "Create Datadog dashboard for infrastructure monitoring"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# Computed/Derived Variables
# ------------------------------------------------------------------------------

locals {
  # Common resource naming prefix
  name_prefix = "${var.project_name}-${var.environment}"

  # Datadog tags in "key:value" format
  datadog_tags_list = concat(
    [
      "env:${var.environment}",
      "project:${var.project_name}",
      "team:${var.team_name}",
      "managed_by:terraform"
    ],
    [for k, v in var.datadog_tags : "${k}:${v}"]
  )

  # AWS account and region data
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Team        = var.team_name
  }
}

