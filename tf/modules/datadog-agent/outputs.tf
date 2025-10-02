# ============================================================================
# DATADOG AGENT MODULE - OUTPUTS
# ============================================================================

output "user_data" {
  description = "User data script for installing Datadog agent"
  value       = data.template_file.install_datadog_agent.rendered
}

output "user_data_base64" {
  description = "Base64-encoded user data script"
  value       = base64encode(data.template_file.install_datadog_agent.rendered)
}

output "datadog_tags" {
  description = "Tags applied to the Datadog agent"
  value       = local.all_tags
}

output "hostname" {
  description = "Hostname configured for Datadog agent"
  value       = var.hostname
}

