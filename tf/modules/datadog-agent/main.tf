# ============================================================================
# DATADOG AGENT MODULE
# ============================================================================
# This module generates user_data script for installing Datadog agent on EC2
# instances. It retrieves API key from SSM Parameter Store securely at runtime.
#
# Usage:
#   module "datadog_agent" {
#     source = "./modules/datadog-agent"
#     
#     hostname                   = "backend-server"
#     aws_region                 = "us-east-1"
#     datadog_site               = "datadoghq.com"
#     datadog_api_key_parameter  = "/lti-project/datadog/api-key"
#     environment                = "dev"
#     service_name               = "lti-backend"
#     additional_tags            = ["team:platform"]
#   }
# ============================================================================

# Generate user data script from template
data "template_file" "install_datadog_agent" {
  template = file("${path.module}/templates/install-datadog-agent.sh.tpl")

  vars = {
    aws_region                = var.aws_region
    datadog_site              = var.datadog_site
    datadog_api_key_parameter = var.datadog_api_key_parameter
    hostname                  = var.hostname
    tags                      = join(",", local.all_tags)
    enable_logs               = var.enable_logs
    enable_process_monitoring = var.enable_process_monitoring
  }
}

# Combine default and custom tags
locals {
  default_tags = [
    "env:${var.environment}",
    "service:${var.service_name}",
    "managed_by:terraform"
  ]

  all_tags = concat(local.default_tags, var.additional_tags)
}

