# ============================================================================
# PROVIDER CONFIGURATION
# ============================================================================
# AWS and Datadog providers with secure configuration.
#
# Security Notes:
# - AWS credentials via AWS CLI profile or IAM role (never hardcoded)
# - Datadog credentials via environment variables DD_API_KEY and DD_APP_KEY
# - Default tags applied to ALL AWS resources automatically
# ============================================================================

provider "aws" {
  region = var.aws_region

  # Default tags applied to ALL AWS resources
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Repository  = "AI4Devs-monitoring"
      Team        = var.team_name
    }
  }
}

# Datadog Provider Configuration
# Credentials must be set via environment variables:
#   export DD_API_KEY="your-api-key"
#   export DD_APP_KEY="your-app-key"
#
# Alternative: Use terraform.tfvars (NOT RECOMMENDED for security)
provider "datadog" {
  api_url = var.datadog_api_url # Derived from datadog_site variable
  
  # API and APP keys retrieved from environment variables
  # DO NOT hardcode these values
  api_key = var.datadog_api_key # Will be empty, forces env var usage
  app_key = var.datadog_app_key # Will be empty, forces env var usage
}
