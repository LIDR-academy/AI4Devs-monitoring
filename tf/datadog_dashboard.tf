resource "datadog_dashboard" "aws_monitoring_dashboard" {
  title       = "AWS & App Monitoring Dashboard"
  description = "Dashboard para monitoreo de EC2, logs backend/frontend y alertas clave"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "CPU Utilization (EC2)"
      request {
        q = "avg:aws.ec2.cpuutilization{*}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Memoria Libre (EC2)"
      request {
        q = "avg:aws.ec2.mem_free{*}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Network In/Out (EC2)"
      request {
        q = "avg:aws.ec2.network_in{*}, avg:aws.ec2.network_out{*}"
        display_type = "line"
      }
    }
  }

  widget {
    log_stream_definition {
      title = "Logs Backend"
      indexes = ["main"]
      query = "service:backend"
    }
  }

  widget {
    log_stream_definition {
      title = "Logs Frontend"
      indexes = ["main"]
      query = "service:frontend"
    }
  }
}

resource "datadog_monitor" "ec2_high_cpu" {
  name               = "EC2 High CPU Usage"
  type               = "metric alert"
  query              = "avg(last_5m):avg:aws.ec2.cpuutilization{*} > 80"
  message            = "Alerta: Uso de CPU en EC2 > 80%. Notificar a: antonio@tucorreo.com"
  escalation_message = "CPU sigue alta después de 15 minutos."
  notify_no_data     = true
  no_data_timeframe  = 10
  evaluation_delay   = 300

  notify_audit       = false
  renotify_interval  = 10
}