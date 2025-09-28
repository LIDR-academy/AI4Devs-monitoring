# AWS Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS Key Pair name"
  type        = string
  default     = "my-key-pair"
}

# Datadog Variables
variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog Application Key"
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "Datadog API URL"
  type        = string
  default     = "https://api.datadoghq.com/"
}

variable "datadog_external_id" {
  description = "External ID for Datadog AWS integration"
  type        = string
  default     = "datadog-external-id"
}

variable "datadog_forwarder_lambda_arn" {
  description = "ARN of the Datadog Forwarder Lambda function for log collection"
  type        = string
  default     = ""
}

variable "datadog_site" {
  description = "Datadog site (datadoghq.com or datadoghq.eu)"
  type        = string
  default     = "datadoghq.com"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ai4devs-monitoring"
}

variable "environment" {
  description = "Environment (dev, staging, production)"
  type        = string
  default     = "dev"
}

variable "enable_datadog_logs" {
  description = "Enable Datadog log collection"
  type        = bool
  default     = true
}