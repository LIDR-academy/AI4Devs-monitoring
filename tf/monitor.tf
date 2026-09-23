# ------------------------------------------------------------------------------
# Monitor Datadog - Alerta CPU EC2
# Dispara cuando la CPU promedio supera 80% durante 5 minutos.
# ------------------------------------------------------------------------------

resource "datadog_monitor" "cpu_high" {
  name    = "[AWS EC2] CPU alta - LTI Project"
  type    = "metric alert"
  message = <<-EOT
    CPU en instancias EC2 por encima del 80% durante 5 minutos.
    Revisar instancias en AWS (backend/frontend).
    @notification
  EOT

  query = "avg(last_5m):avg:aws.ec2.cpu{*} > 80"

  monitor_thresholds {
    critical = 80
    warning  = 70
  }

  notify_no_data    = false
  renotify_interval = 60
  include_tags      = true

  tags = ["env:${var.environment}", "service:ec2", "terraform:true"]
}
