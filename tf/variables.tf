variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  sensitive   = true
  default     = null
}

variable "datadog_app_key" {
  description = "Datadog Application Key"
  type        = string
  sensitive   = true
  default     = null
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = null
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
