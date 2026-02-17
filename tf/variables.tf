# ==========================================
# AWS Configuration
# ==========================================
variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-075d39ebbca89ed55" # Amazon Linux 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name for EC2 instances (optional)"
  type        = string
  default     = ""
}

# ==========================================
# Application Configuration
# ==========================================
variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "lti-recruiter"
}

variable "app_version" {
  description = "Application version for tagging"
  type        = string
  default     = "1.0.0"
}

# ==========================================
# Database Configuration
# ==========================================
variable "db_user" {
  description = "Database username"
  type        = string
  default     = "LTIdbUser"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "LTIdb"
}

# ==========================================
# Datadog Configuration
# ==========================================
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

variable "datadog_site" {
  description = "Datadog site (e.g., datadoghq.com or datadoghq.eu)"
  type        = string
  default     = "datadoghq.com"
}

# ==========================================
# Notification Configuration
# ==========================================
variable "notification_slack_channel" {
  description = "Slack channel for alerts (e.g., @slack-devops-alerts)"
  type        = string
  default     = "@slack-devops-alerts"
}

variable "notification_email" {
  description = "Email for alert notifications"
  type        = string
  default     = ""
}

# ==========================================
# S3 Configuration
# ==========================================
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for code artifacts"
  type        = string
  default     = "ai4devs-project-code-bucket"
}

# ==========================================
# ECR Configuration
# ==========================================
variable "ecr_repository_prefix" {
  description = "Prefix for ECR repository names"
  type        = string
  default     = "lti-recruiter"
}
