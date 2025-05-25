variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "lti-ats"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change this to your IP for better security
}

variable "backend_port" {
  description = "Port for backend application"
  type        = number
  default     = 8080
}

variable "frontend_port" {
  description = "Port for frontend application"
  type        = number
  default     = 3000
}

variable "key_name" {
  description = "Name of the AWS key pair to use for EC2 instances"
  type        = string
  default     = "David ed2"
}

variable "datadog_api_key" {
  description = "Datadog API key for agent configuration"
  type        = string
  default     = ""  # Set this to your actual Datadog API key
  sensitive   = true
}

variable "datadog_site" {
  description = "Datadog site (datadoghq.com, datadoghq.eu, etc.)"
  type        = string
  default     = "datadoghq.eu"  # Change to datadoghq.eu if you're using EU
}
