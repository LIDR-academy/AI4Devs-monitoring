# =====================================================
# Datadog Monitors for LTI Recruiter Infrastructure
# =====================================================

# =====================================================
# CPU Monitors
# =====================================================
resource "datadog_monitor" "backend_cpu_high" {
  name    = "[${var.environment}] Backend - High CPU Usage"
  type    = "metric alert"
  message = <<-EOT
    ## High CPU on Backend Server

    CPU usage is above {{threshold}}% on the backend instance.

    **Host:** {{host.name}}
    **Current Value:** {{value}}%

    ${var.notification_slack_channel} ${var.notification_email != "" ? var.notification_email : ""}
  EOT

  query = "avg(last_5m):avg:system.cpu.user{service:backend,env:${var.environment}} by {host} > 80"

  monitor_thresholds {
    critical          = 80
    critical_recovery = 70
    warning           = 60
    warning_recovery  = 50
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30

  tags = ["env:${var.environment}", "service:backend", "project:lti-recruiter"]
}

resource "datadog_monitor" "frontend_cpu_high" {
  name    = "[${var.environment}] Frontend - High CPU Usage"
  type    = "metric alert"
  message = <<-EOT
    ## High CPU on Frontend Server

    CPU usage is above {{threshold}}% on the frontend instance.

    **Host:** {{host.name}}
    **Current Value:** {{value}}%

    ${var.notification_slack_channel} ${var.notification_email != "" ? var.notification_email : ""}
  EOT

  query = "avg(last_5m):avg:system.cpu.user{service:frontend,env:${var.environment}} by {host} > 80"

  monitor_thresholds {
    critical          = 80
    critical_recovery = 70
    warning           = 60
    warning_recovery  = 50
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30

  tags = ["env:${var.environment}", "service:frontend", "project:lti-recruiter"]
}

# =====================================================
# Memory Monitors
# =====================================================
resource "datadog_monitor" "backend_memory_high" {
  name    = "[${var.environment}] Backend - High Memory Usage"
  type    = "metric alert"
  message = <<-EOT
    ## High Memory Usage on Backend

    Memory usage is critically high on the backend instance.

    **Host:** {{host.name}}

    ${var.notification_slack_channel}
  EOT

  query = "avg(last_5m):avg:system.mem.pct_usable{service:backend,env:${var.environment}} by {host} < 0.15"

  monitor_thresholds {
    critical          = 0.10
    critical_recovery = 0.15
    warning           = 0.15
    warning_recovery  = 0.20
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = ["env:${var.environment}", "service:backend", "project:lti-recruiter"]
}

resource "datadog_monitor" "frontend_memory_high" {
  name    = "[${var.environment}] Frontend - High Memory Usage"
  type    = "metric alert"
  message = <<-EOT
    ## High Memory Usage on Frontend

    Memory usage is critically high on the frontend instance.

    **Host:** {{host.name}}

    ${var.notification_slack_channel}
  EOT

  query = "avg(last_5m):avg:system.mem.pct_usable{service:frontend,env:${var.environment}} by {host} < 0.15"

  monitor_thresholds {
    critical          = 0.10
    critical_recovery = 0.15
    warning           = 0.15
    warning_recovery  = 0.20
  }

  notify_no_data    = true
  no_data_timeframe = 10

  tags = ["env:${var.environment}", "service:frontend", "project:lti-recruiter"]
}

# =====================================================
# Disk Usage Monitor
# =====================================================
resource "datadog_monitor" "disk_usage_high" {
  name    = "[${var.environment}] High Disk Usage"
  type    = "metric alert"
  message = <<-EOT
    ## High Disk Usage

    Disk usage is above {{threshold}}%.

    **Host:** {{host.name}}
    **Device:** {{device.name}}

    ${var.notification_slack_channel}
  EOT

  query = "avg(last_5m):avg:system.disk.in_use{env:${var.environment}} by {host,device} > 0.85"

  monitor_thresholds {
    critical = 0.90
    warning  = 0.85
  }

  notify_no_data    = false
  renotify_interval = 60

  tags = ["env:${var.environment}", "project:lti-recruiter"]
}

# =====================================================
# HTTP Health Check Monitors
# =====================================================
resource "datadog_monitor" "backend_health_check" {
  name    = "[${var.environment}] Backend - Health Check Failed"
  type    = "service check"
  message = <<-EOT
    ## Backend Health Check Failed

    The backend service at port 8080 is not responding.

    ${var.notification_slack_channel} ${var.notification_email != "" ? var.notification_email : ""}
  EOT

  query = "\"http.can_connect\".over(\"instance:backend_health\",\"env:${var.environment}\").by(\"host\",\"instance\").last(3).count_by_status()"

  monitor_thresholds {
    critical = 3
    warning  = 1
    ok       = 1
  }

  notify_no_data    = true
  no_data_timeframe = 5
  renotify_interval = 5

  tags = ["env:${var.environment}", "service:backend", "check:health", "project:lti-recruiter"]
}

resource "datadog_monitor" "frontend_health_check" {
  name    = "[${var.environment}] Frontend - Health Check Failed"
  type    = "service check"
  message = <<-EOT
    ## Frontend Health Check Failed

    The frontend service at port 3000 is not responding.

    ${var.notification_slack_channel} ${var.notification_email != "" ? var.notification_email : ""}
  EOT

  query = "\"http.can_connect\".over(\"instance:frontend_health\",\"env:${var.environment}\").by(\"host\",\"instance\").last(3).count_by_status()"

  monitor_thresholds {
    critical = 3
    warning  = 1
    ok       = 1
  }

  notify_no_data    = true
  no_data_timeframe = 5
  renotify_interval = 5

  tags = ["env:${var.environment}", "service:frontend", "check:health", "project:lti-recruiter"]
}

# =====================================================
# Docker Container Monitor
# =====================================================
resource "datadog_monitor" "docker_container_stopped" {
  name    = "[${var.environment}] Docker Container Stopped"
  type    = "service check"
  message = <<-EOT
    ## Docker Container Stopped

    A Docker container has stopped unexpectedly.

    **Host:** {{host.name}}

    ${var.notification_slack_channel}
  EOT

  query = "\"docker.container_health\".over(\"env:${var.environment}\").by(\"container_name\",\"host\").last(3).count_by_status()"

  monitor_thresholds {
    critical = 3
    warning  = 1
    ok       = 1
  }

  notify_no_data    = true
  no_data_timeframe = 5

  tags = ["env:${var.environment}", "check:docker", "project:lti-recruiter"]
}

# =====================================================
# Host Alive Monitor
# =====================================================
resource "datadog_monitor" "host_not_reporting" {
  name    = "[${var.environment}] Host Not Reporting"
  type    = "service check"
  message = <<-EOT
    ## Host Not Reporting

    A host in the ${var.environment} environment has stopped reporting to Datadog.

    ${var.notification_slack_channel} ${var.notification_email != "" ? var.notification_email : ""}
  EOT

  query = "\"datadog.agent.up\".over(\"env:${var.environment}\").by(\"host\").last(3).count_by_status()"

  monitor_thresholds {
    critical = 3
    ok       = 1
  }

  notify_no_data    = true
  no_data_timeframe = 5
  renotify_interval = 10

  tags = ["env:${var.environment}", "check:host-alive", "project:lti-recruiter"]
}
