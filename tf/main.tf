

resource "datadog_monitor" "ec2_cpu_monitor" {
  name               = "EC2 CPU Utilization Alert (Frontend/Backend)"
  type               = "metric alert"
  query              = "avg(last_5m):avg:aws.ec2.cpuutilization{*} by {host,instance-type} >= 80"
  message            = <<EOF
  ¡Alerta de CPU alta detectada! 
  
  Instancia: {{host.name}} ({{instance-type.name}})
  Uso actual: {{value}}%
  
  Por favor, revisa si es el servidor Frontend (t2.medium) o Backend (t2.micro) y toma las medidas necesarias.
  @team-devops
  EOF

  monitor_thresholds {
    critical = 80.0
    warning  = 70.0
  }

  notify_no_data      = false
  require_full_window = true
  
  tags = ["env:production", "service:ec2", "team:devops"]
}
