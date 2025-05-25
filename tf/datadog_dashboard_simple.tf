# Simple Datadog Dashboard for EC2 Infrastructure Monitoring
# This dashboard uses basic queries that should work immediately

resource "datadog_dashboard" "simple_monitoring" {
  title       = "${var.project_name} Simple Monitoring"
  description = "Simple monitoring dashboard for ${var.project_name} infrastructure"
  layout_type = "ordered"

  # System Metrics (from Datadog Agent)
  widget {
    timeseries_definition {
      title = "System CPU Usage"
      request {
        q = "avg:system.cpu.user{*} by {host}"
        display_type = "line"
      }
      request {
        q = "avg:system.cpu.system{*} by {host}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "System Memory Usage"
      request {
        q = "avg:system.mem.used{*} by {host}"
        display_type = "line"
      }
      request {
        q = "avg:system.mem.free{*} by {host}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "System Load Average"
      request {
        q = "avg:system.load.1{*} by {host}"
        display_type = "line"
      }
      request {
        q = "avg:system.load.5{*} by {host}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Disk Usage"
      request {
        q = "avg:system.disk.used{*} by {host,device}"
        display_type = "line"
      }
    }
  }

  # Docker Metrics (if available)
  widget {
    timeseries_definition {
      title = "Docker Containers"
      request {
        q = "avg:docker.containers.running{*} by {host}"
        display_type = "line"
      }
    }
  }

  # Network Connections
  widget {
    timeseries_definition {
      title = "Network Connections"
      request {
        q = "avg:system.net.tcp.established{*} by {host}"
        display_type = "line"
      }
    }
  }

  template_variable {
    name     = "host"
    prefix   = "host"
    defaults = ["*"]
  }
}

# Output the simple dashboard URL
output "datadog_simple_dashboard_url" {
  description = "URL to the simple Datadog dashboard"
  value       = "https://app.${var.datadog_site}/dashboard/${datadog_dashboard.simple_monitoring.id}"
} 