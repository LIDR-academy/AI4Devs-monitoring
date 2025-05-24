# Dashboard de monitoreo para LTI
resource "datadog_dashboard" "lti_monitoring" {
  title       = "${var.project_name}-monitoring-dashboard"
  description = "Dashboard for monitoring LTI infrastructure"
  layout_type = "ordered"
  
  # Usar restricted_roles en lugar de is_read_only
  restricted_roles = []

  widget {
    group_definition {
      layout_type = "ordered"
      title = "EC2 Metrics"
      show_title = true

      widget {
        timeseries_definition {
          title = "CPU Usage"
          request {
            q = "avg:system.cpu.user{$environment} by {host}"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Memory Usage"
          request {
            q = "avg:system.mem.used{$environment} by {host}"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Disk Usage"
          request {
            q = "avg:system.disk.in_use{$environment} by {host}"
          }
        }
      }
    }
  }

  widget {
    group_definition {
      layout_type = "ordered"
      title = "Apache Metrics"
      show_title = true

      widget {
        timeseries_definition {
          title = "Apache Requests"
          request {
            q = "sum:apache.net.hits{$environment} by {host}.as_count()"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Response Time"
          request {
            q = "avg:apache.net.request_per_s{$environment} by {host}"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Apache Status"
          request {
            q = "avg:apache.performance.busy_workers{$environment} by {host}"
          }
        }
      }
    }
  }

  widget {
    group_definition {
      layout_type = "ordered"
      title = "AWS CloudWatch Metrics"
      show_title = true

      widget {
        timeseries_definition {
          title = "EC2 CPU Utilization"
          request {
            q = "avg:aws.ec2.cpuutilization{$environment} by {instanceid}"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Network In/Out"
          request {
            q = "avg:aws.ec2.network_in{$environment} by {instanceid}, avg:aws.ec2.network_out{$environment} by {instanceid}"
          }
        }
      }
    }
  }

  widget {
    alert_graph_definition {
      title = "System Alerts"
      alert_id = "system"
      viz_type = "timeseries"
    }
  }
} 