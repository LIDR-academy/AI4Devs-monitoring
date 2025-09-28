terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.42"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = "production"
      Project     = "lti-monitoring"
      ManagedBy   = "terraform"
      Owner       = "devops-team"
    }
  }
}

provider "datadog" {
  api_key               = var.datadog_api_key
  app_key               = var.datadog_app_key
  api_url               = var.datadog_api_url
  validate              = true
  
  # Enable HTTP request/response debugging
  # http_client_retry_enabled = true
  # http_client_retry_timeout = 60
}
