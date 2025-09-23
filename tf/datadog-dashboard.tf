# Datadog Dashboard para Aplicación LTI
# Dashboard simplificado con métricas críticas

resource "datadog_dashboard" "lti_application_dashboard" {
  title         = "LTI Application - Infrastructure & Performance"
  description   = "Dashboard completo para monitoreo de la aplicación LTI"
  layout_type   = "ordered"
  is_read_only  = false

  # Widget 1: Memory Usage
  widget {
    widget_layout {
      x      = 0
      y      = 0
      width  = 6
      height = 3
    }
    
    timeseries_definition {
      title = "Memory Usage"
      request {
        q = "avg:system.mem.used{*} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      request {
        q = "avg:system.mem.free{*} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Memory (bytes)"
        scale = "linear"
      }
    }
  }

  # Widget 2: CPU Usage
  widget {
    widget_layout {
      x      = 6
      y      = 0
      width  = 6
      height = 3
    }
    
    timeseries_definition {
      title = "CPU Usage by Host"
      request {
        q = "avg:system.cpu.user{*} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      request {
        q = "avg:system.cpu.system{*} by {host}"
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
        min   = "0"
        max   = "100"
      }
    }
  }

  # Widget 3: Disk Usage
  widget {
    widget_layout {
      x      = 0
      y      = 3
      width  = 6
      height = 3
    }
    
    timeseries_definition {
      title = "Disk Usage"
      request {
        q = "avg:system.disk.in_use{*} by {host,device}"
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
        min   = "0"
        max   = "100"
      }
    }
  }

  # Widget 4: Network Traffic
  widget {
    widget_layout {
      x      = 6
      y      = 3
      width  = 6
      height = 3
    }
    
    timeseries_definition {
      title = "Network Traffic"
      request {
        q = "avg:system.net.bytes_sent{*} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      request {
        q = "avg:system.net.bytes_rcvd{*} by {host}"
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

  # Widget 5: Docker Container Status
  widget {
    widget_layout {
      x      = 0
      y      = 6
      width  = 6
      height = 3
    }
    
    timeseries_definition {
      title = "Docker Container Status"
      request {
        q = "avg:docker.containers.running{*} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Running Containers"
        scale = "linear"
      }
    }
  }

  # Widget 6: Application Health Status
  widget {
    widget_layout {
      x      = 6
      y      = 6
      width  = 6
      height = 3
    }
    
    check_status_definition {
      title = "Application Health Check"
      check = "datadog.agent.up"
      grouping = "check"
      group_by = ["host"]
      tags = ["env:dev"]
    }
  }

  # Tags para el dashboard
  tags = []
}
