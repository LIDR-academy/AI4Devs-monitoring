# ============================================================================
# TERRAFORM AND PROVIDER VERSION CONSTRAINTS
# ============================================================================
# This file pins Terraform and provider versions to ensure consistent
# behavior across all environments and team members.
#
# Version Strategy:
# - Use pessimistic constraint operator (~>) to allow patch updates
# - Lock major and minor versions to prevent breaking changes
# ============================================================================

terraform {
  # Require Terraform 1.6.x or higher (but < 2.0)
  required_version = "~> 1.6"

  required_providers {
    # AWS Provider - Infrastructure management
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Allow 5.x updates, block 6.0
    }

    # Datadog Provider - Monitoring and observability
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.40" # Stable version with AWS integration support
    }

    # Random Provider - For generating unique IDs (external ID, etc.)
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

