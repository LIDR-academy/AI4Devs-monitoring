output "datadog_integration_external_id" {
  description = "External ID used for the Datadog-AWS integration"
  value       = var.external_id
  sensitive   = true
}

output "iam_role_arn" {
  description = "ARN of the IAM role created for Datadog"
  value       = aws_iam_role.datadog_integration_role.arn
}

output "environment" {
  description = "Environment where the monitoring is deployed"
  value       = var.environment
}

output "datadog_dashboard_id" {
  description = "ID of the created Datadog dashboard"
  value       = datadog_dashboard.lti_monitoring.id
}

output "datadog_dashboard_url" {
  description = "URL of the created Datadog dashboard"
  value       = "https://us5.datadoghq.com/dashboard/${datadog_dashboard.lti_monitoring.id}"
}