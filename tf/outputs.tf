# ------------------------------------------------------------------------------
# Integración Datadog
# ------------------------------------------------------------------------------
output "datadog_integration_external_id" {
  description = "External ID generado por la integración AWS-Datadog (para inspección)"
  value       = try(datadog_integration_aws_account.datadog_integration.auth_config.aws_auth_config_role.external_id, null)
  sensitive   = true
}

# ------------------------------------------------------------------------------
# Dashboard y Monitor (ver dashboard.tf y monitor.tf)
# ------------------------------------------------------------------------------
output "datadog_dashboard_url" {
  description = "URL del dashboard en Datadog"
  value       = try("https://app.${var.datadog_site}/dashboard/${datadog_dashboard.aws_ec2.id}", null)
}

output "datadog_dashboard_id" {
  description = "ID del dashboard creado en Datadog"
  value       = try(datadog_dashboard.aws_ec2.id, null)
}

output "datadog_monitor_id" {
  description = "ID del monitor de CPU en Datadog"
  value       = try(datadog_monitor.cpu_high.id, null)
}
