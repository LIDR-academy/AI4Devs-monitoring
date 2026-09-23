terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.40.0"  # Usar una versión reciente estable
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Uses AWS CLI V2 credentials from:
  #   - Environment variables (AWS_PROFILE, AWS_ACCESS_KEY_ID, etc.)
  #   - Shared credentials file (~/.aws/credentials)
  #   - AWS SSO (via 'aws sso login')
  # Uncomment 'profile' to use a specific named profile:
  # profile = "default"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}
