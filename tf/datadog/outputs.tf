output "datadog_dashboard_url" {
  description = "URL of the LTI project overview dashboard"
  value       = datadog_dashboard.overview_dashboard.url
} 