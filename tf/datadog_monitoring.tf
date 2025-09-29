# Dashboards y Monitores de Datadog para la aplicación AI4Devs

# Dashboard principal de la aplicación
resource "datadog_dashboard" "ai4devs_main_dashboard" {
  title         = "AI4Devs Monitoring - Main Dashboard"
  description   = "Dashboard principal para monitorear la aplicación AI4Devs"
  layout_type   = "ordered"
  is_read_only  = false

  widget {
    alert_graph_definition {
      alert_id = datadog_monitor.backend_health.id
      viz_type = "timeseries"
      title    = "Backend Health Status"
    }
  }

  widget {
    alert_graph_definition {
      alert_id = datadog_monitor.frontend_health.id
      viz_type = "timeseries"
      title    = "Frontend Health Status"
    }
  }

  widget {
    timeseries_definition {
      title = "EC2 CPU Usage"
      request {
        q = "avg:aws.ec2.cpuutilization{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "CPU %"
        scale = "linear"
        min = "0"
        max = "100"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Docker Container Metrics"
      request {
        q = "avg:docker.containers.running{*} by {container_name}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Containers"
        scale = "linear"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Application Response Time"
      request {
        q = "avg:http.response_time{*} by {service}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Response Time (ms)"
        scale = "linear"
      }
    }
  }

  widget {
    log_stream_definition {
      title = "Application Logs"
      query = "service:lti-backend OR service:lti-frontend"
      columns = ["timestamp", "service", "status", "message"]
      show_date_column = true
      show_message_column = true
      message_display = "expanded-md"
      sort {
        column = "timestamp"
        order = "desc"
      }
    }
  }
}

# Dashboard de infraestructura AWS
resource "datadog_dashboard" "aws_infrastructure_dashboard" {
  title         = "AI4Devs - AWS Infrastructure"
  description   = "Dashboard para monitorear la infraestructura AWS"
  layout_type   = "ordered"
  is_read_only  = false

  widget {
    timeseries_definition {
      title = "EC2 Instance Status"
      request {
        q = "avg:aws.ec2.status_check_failed{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Failed Checks"
        scale = "linear"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Network Traffic"
      request {
        q = "avg:aws.ec2.network_in{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Bytes/sec"
        scale = "linear"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Disk Usage"
      request {
        q = "avg:aws.ec2.disk_used{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Disk Usage %"
        scale = "linear"
      }
    }
  }
}

# Monitores de salud de la aplicación

# Monitor para el backend
resource "datadog_monitor" "backend_health" {
  name               = "Backend Health Check"
  type               = "service check"
  query              = "\"http.can_connect\".over(\"instance:lti-backend\",\"url:http://localhost:8080/health\").by(\"*\").last(2).count_by_status()"
  message            = <<EOF
Backend service is not responding!

@slack-alerts
@webhook-alerts
EOF
  tags               = ["service:backend", "env:production"]
  priority           = 1
  notify_audit       = false
  restricted_roles   = []
  timeout_h          = 0
  include_tags       = true
  require_full_window = true
  new_host_delay     = 300
  notify_no_data     = false
  renotify_interval  = 0
  escalation_message = ""
  evaluation_delay   = 900
  no_data_timeframe  = null
  monitor_thresholds {
    warning  = 1
    critical = 1
  }
}

# Monitor para el frontend
resource "datadog_monitor" "frontend_health" {
  name               = "Frontend Health Check"
  type               = "service check"
  query              = "\"http.can_connect\".over(\"instance:lti-frontend\",\"url:http://localhost:3000\").by(\"*\").last(2).count_by_status()"
  message            = <<EOF
Frontend service is not responding!

@slack-alerts
@webhook-alerts
EOF
  tags               = ["service:frontend", "env:production"]
  priority           = 1
  notify_audit       = false
  restricted_roles   = []
  timeout_h          = 0
  include_tags       = true
  require_full_window = true
  new_host_delay     = 300
  notify_no_data     = false
  renotify_interval  = 0
  escalation_message = ""
  evaluation_delay   = 900
  no_data_timeframe  = null
  monitor_thresholds {
    warning  = 1
    critical = 1
  }
}

# Monitor de CPU alta
resource "datadog_monitor" "high_cpu" {
  name               = "High CPU Usage"
  type               = "metric alert"
  query              = "avg(last_5m):avg:aws.ec2.cpuutilization{*} > 80"
  message            = <<EOF
CPU usage is high on EC2 instances!

@slack-alerts
EOF
  tags               = ["env:production", "alert:performance"]
  priority           = 2
  notify_audit       = false
  restricted_roles   = []
  timeout_h          = 0
  include_tags       = true
  require_full_window = true
  new_host_delay     = 300
  notify_no_data     = false
  renotify_interval  = 0
  escalation_message = ""
  evaluation_delay   = 900
  no_data_timeframe  = null
  monitor_thresholds {
    warning  = 70
    critical = 80
  }
}

# Monitor de memoria alta
resource "datadog_monitor" "high_memory" {
  name               = "High Memory Usage"
  type               = "metric alert"
  query              = "avg(last_5m):avg:system.mem.pct_usable{*} < 0.2"
  message            = <<EOF
Memory usage is high on EC2 instances!

@slack-alerts
EOF
  tags               = ["env:production", "alert:performance"]
  priority           = 2
  notify_audit       = false
  restricted_roles   = []
  timeout_h          = 0
  include_tags       = true
  require_full_window = true
  new_host_delay     = 300
  notify_no_data     = false
  renotify_interval  = 0
  escalation_message = ""
  evaluation_delay   = 900
  no_data_timeframe  = null
  monitor_thresholds {
    warning  = 0.3
    critical = 0.2
  }
}

# Monitor de contenedores Docker
resource "datadog_monitor" "docker_containers" {
  name               = "Docker Container Status"
  type               = "metric alert"
  query              = "avg(last_5m):avg:docker.containers.running{*} < 2"
  message            = <<EOF
Docker containers are not running properly!

Expected: 2 containers (backend + frontend)
Current: {{value}}

@slack-alerts
EOF
  tags               = ["env:production", "alert:infrastructure"]
  priority           = 1
  notify_audit       = false
  restricted_roles   = []
  timeout_h          = 0
  include_tags       = true
  require_full_window = true
  new_host_delay     = 300
  notify_no_data     = false
  renotify_interval  = 0
  escalation_message = ""
  evaluation_delay   = 900
  no_data_timeframe  = null
  monitor_thresholds {
    warning  = 2
    critical = 1
  }
}

# Monitor de logs de error
resource "datadog_monitor" "error_logs" {
  name               = "Application Error Logs"
  type               = "log alert"
  query              = "status:error service:lti-backend OR status:error service:lti-frontend"
  message            = <<EOF
Application errors detected in logs!

@slack-alerts
EOF
  tags               = ["env:production", "alert:application"]
  priority           = 1
  notify_audit       = false
  restricted_roles   = []
  timeout_h          = 0
  include_tags       = true
  require_full_window = true
  new_host_delay     = 300
  notify_no_data     = false
  renotify_interval  = 0
  escalation_message = ""
  evaluation_delay   = 900
  no_data_timeframe  = null
  monitor_thresholds {
    warning  = 5
    critical = 10
  }
}

# Nota: Los SLOs se configurarán después del despliegue
# cuando tengamos métricas disponibles en Datadog
