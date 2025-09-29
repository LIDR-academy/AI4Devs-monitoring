resource "datadog_monitor" "cpu_utilization" {
  name    = "High CPU Utilization"
  type    = "metric alert"
  query   = "avg(last_5m):avg:aws.ec2.cpuutilization{*} > 80"
  message = "⚠️ CPU usage too high on EC2 instances"
}
