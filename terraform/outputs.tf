output "ec2_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.ec2_instance.public_ip
}

output "datadog_dashboard_url" {
  description = "URL del dashboard de Datadog"
  value       = "https://app.datadoghq.com/dashboard/${datadog_dashboard.aws_dashboard.id}"
} 