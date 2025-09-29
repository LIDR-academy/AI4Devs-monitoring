# Monitor existente
resource "datadog_monitor" "cpu_utilization" {
  name    = "High CPU Utilization"
  type    = "metric alert"
  query   = "avg(last_5m):avg:aws.ec2.cpuutilization{*} > 80"
  message = "⚠️ CPU usage too high on EC2 instances"
}

# Obtenemos info de la cuenta AWS actual
data "aws_caller_identity" "current" {}

# Integra la cuenta AWS con Datadog (provider 3.x)
resource "datadog_integration_aws" "ai4devs" {
  account_id = data.aws_caller_identity.current.account_id
  role_name  = aws_iam_role.datadog_integration.name

  # Opcional: etiquetas para distinguir esta integración en Datadog
  host_tags = ["env:ai4devs", "team:monitoring"]
}

resource "datadog_dashboard_json" "ai4devs_overview" {
  dashboard = jsonencode({
    title       = "AI4Devs — AWS Overview"
    description = "Dashboard creado con Terraform"
    layout_type = "ordered"
    widgets = [
      {
        definition = {
          title    = "CPU Utilization"
          type     = "timeseries"
          requests = [{ q = "avg:aws.ec2.cpuutilization{*} by {host}" }]
        }
      },
      {
        definition = {
          title    = "Memory Used %"
          type     = "timeseries"
          requests = [{ q = "avg:system.mem.used_pct{*} by {host}" }]
        }
      },
      {
        definition = {
          title    = "Load (1m)"
          type     = "timeseries"
          requests = [{ q = "avg:system.load.1{*} by {host}" }]
        }
      }
    ]
  })
}
