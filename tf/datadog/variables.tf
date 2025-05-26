variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog Application key"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "datadog_aws_account_id" {
  description = "AWS account ID for Datadog integration"
  type        = string
  default     = "464622532012" # Datadog's AWS account ID for integration
}

variable "external_id" {
  description = "External ID for Datadog AWS IAM role"
  type        = string
  sensitive   = true
} 