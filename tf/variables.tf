# Terraform Variables for AI4Devs Datadog-AWS Integration

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ai4devs-monitoring"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "backend_instance_type" {
  description = "EC2 instance type for backend"
  type        = string
  default     = "t2.micro"
}

variable "frontend_instance_type" {
  description = "EC2 instance type for frontend"
  type        = string
  default     = "t2.medium"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "backend_port" {
  description = "Port for the backend application"
  type        = number
  default     = 8080
}

variable "frontend_port" {
  description = "Port for the frontend application"
  type        = number
  default     = 3000
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "AI4Devs-Monitoring"
    Environment = "Development"
    ManagedBy   = "Terraform"
    Owner       = "MG"
  }
}
