# ============================================================================
# DATADOG DASHBOARDS
# ============================================================================
# This file creates Datadog dashboards for monitoring AWS infrastructure
# and application performance.
# ============================================================================

resource "datadog_dashboard" "main" {
  count = var.create_datadog_dashboard ? 1 : 0

  title       = "${var.project_name} - ${upper(var.environment)} Infrastructure Overview"
  description = "Comprehensive monitoring dashboard for LTI Project infrastructure including EC2, system metrics, and application health"
  layout_type = "ordered"

  # Dashboard-level template variables for filtering
  template_variable {
    name    = "environment"
    prefix  = "env"
    default = var.environment
  }

  template_variable {
    name   = "service"
    prefix = "service"
    default = "*"
  }

  # ============================================================================
  # SECTION 1: Overall Status & Health
  # ============================================================================

  widget {
    group_definition {
      title       = "🚦 System Health Overview"
      layout_type = "ordered"

      # Host Count
      widget {
        query_value_definition {
          title       = "Active Hosts"
          title_size  = "16"
          title_align = "left"

          request {
            q          = "sum:system.uptime{env:$environment.value}"
            aggregator = "last"
          }

          autoscale   = true
          precision   = 0
          text_align  = "center"
        }
      }

      # Average CPU across all hosts
      widget {
        query_value_definition {
          title       = "Avg CPU Usage"
          title_size  = "16"
          title_align = "left"

          request {
            q          = "avg:system.cpu.user{env:$environment.value}+avg:system.cpu.system{env:$environment.value}"
            aggregator = "avg"
          }

          autoscale   = true
          precision   = 1
          text_align  = "center"
          custom_unit = "%"

          conditional_formats {
            comparator = ">"
            value      = 80
            palette    = "white_on_red"
          }

          conditional_formats {
            comparator = ">="
            value      = 50
            palette    = "white_on_yellow"
          }

          conditional_formats {
            comparator = "<"
            value      = 50
            palette    = "white_on_green"
          }
        }
      }

      # Memory Usage
      widget {
        query_value_definition {
          title       = "Avg Memory Usage"
          title_size  = "16"
          title_align = "left"

          request {
            q          = "avg:system.mem.used{env:$environment.value}/avg:system.mem.total{env:$environment.value}*100"
            aggregator = "avg"
          }

          autoscale   = true
          precision   = 1
          text_align  = "center"
          custom_unit = "%"

          conditional_formats {
            comparator = ">"
            value      = 85
            palette    = "white_on_red"
          }

          conditional_formats {
            comparator = ">="
            value      = 70
            palette    = "white_on_yellow"
          }

          conditional_formats {
            comparator = "<"
            value      = 70
            palette    = "white_on_green"
          }
        }
      }
    }
  }

  # ============================================================================
  # SECTION 2: EC2 Instance Metrics
  # ============================================================================

  widget {
    group_definition {
      title       = "💻 EC2 Instance Metrics"
      layout_type = "ordered"

      # CPU Utilization by Host
      widget {
        timeseries_definition {
          title       = "CPU Usage by Instance"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          legend_size = "0"

          request {
            q            = "avg:system.cpu.user{env:$environment.value,$service} by {host}"
            display_type = "line"
            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          request {
            q            = "avg:system.cpu.system{env:$environment.value,$service} by {host}"
            display_type = "line"
            style {
              palette    = "cool"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            min   = "0"
            max   = "100"
            label = "CPU %"
          }

          marker {
            value        = "y = 80"
            display_type = "error dashed"
            label        = "Critical Threshold"
          }

          marker {
            value        = "y = 50"
            display_type = "warning dashed"
            label        = "Warning Threshold"
          }
        }
      }

      # Memory Usage by Host
      widget {
        timeseries_definition {
          title       = "Memory Usage by Instance"
          title_size  = "16"
          title_align = "left"
          show_legend = true

          request {
            q            = "(avg:system.mem.used{env:$environment.value,$service} by {host}/avg:system.mem.total{env:$environment.value,$service} by {host})*100"
            display_type = "line"
            style {
              palette    = "purple"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            min   = "0"
            max   = "100"
            label = "Memory %"
          }

          marker {
            value        = "y = 85"
            display_type = "error dashed"
            label        = "Critical"
          }
        }
      }

      # Load Average
      widget {
        timeseries_definition {
          title       = "System Load Average"
          title_size  = "16"
          title_align = "left"

          request {
            q            = "avg:system.load.1{env:$environment.value,$service} by {host}"
            display_type = "line"
            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          request {
            q            = "avg:system.load.5{env:$environment.value,$service} by {host}"
            display_type = "line"
            style {
              palette    = "cool"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            label = "Load"
            min   = "0"
          }
        }
      }
    }
  }

  # ============================================================================
  # SECTION 3: Network & Disk I/O
  # ============================================================================

  widget {
    group_definition {
      title       = "📡 Network & Disk I/O"
      layout_type = "ordered"

      # Network In/Out
      widget {
        timeseries_definition {
          title       = "Network Traffic"
          title_size  = "16"
          title_align = "left"

          request {
            q            = "avg:system.net.bytes_rcvd{env:$environment.value,$service} by {host}"
            display_type = "area"
            style {
              palette    = "green"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          request {
            q            = "-avg:system.net.bytes_sent{env:$environment.value,$service} by {host}"
            display_type = "area"
            style {
              palette    = "blue"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            label = "Bytes/s"
          }
        }
      }

      # Disk Usage
      widget {
        timeseries_definition {
          title       = "Disk Usage by Device"
          title_size  = "16"
          title_align = "left"

          request {
            q            = "(avg:system.disk.used{env:$environment.value,$service} by {host,device}/avg:system.disk.total{env:$environment.value,$service} by {host,device})*100"
            display_type = "line"
            style {
              palette    = "orange"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            min   = "0"
            max   = "100"
            label = "Disk Usage %"
          }

          marker {
            value        = "y = 90"
            display_type = "error dashed"
            label        = "Critical"
          }
        }
      }

      # Disk I/O Operations
      widget {
        timeseries_definition {
          title       = "Disk I/O Operations"
          title_size  = "16"
          title_align = "left"

          request {
            q            = "avg:system.io.rkb_s{env:$environment.value,$service} by {host}"
            display_type = "line"
            style {
              palette    = "green"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          request {
            q            = "avg:system.io.wkb_s{env:$environment.value,$service} by {host}"
            display_type = "line"
            style {
              palette    = "purple"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            label = "KB/s"
          }
        }
      }
    }
  }

  # ============================================================================
  # SECTION 4: AWS-Specific Metrics
  # ============================================================================

  widget {
    group_definition {
      title       = "☁️ AWS Metrics"
      layout_type = "ordered"

      # EC2 Status Checks
      widget {
        timeseries_definition {
          title       = "EC2 Status Checks"
          title_size  = "16"
          title_align = "left"

          request {
            q            = "avg:aws.ec2.status_check_failed{env:$environment.value} by {instance_id}"
            display_type = "bars"
            style {
              palette    = "semantic"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          request {
            q            = "avg:aws.ec2.status_check_failed_system{env:$environment.value} by {instance_id}"
            display_type = "bars"
            style {
              palette    = "warm"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          request {
            q            = "avg:aws.ec2.status_check_failed_instance{env:$environment.value} by {instance_id}"
            display_type = "bars"
            style {
              palette    = "cool"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            label = "Failed Checks"
            min   = "0"
          }
        }
      }

      # EC2 CPU Credit Balance (for T-series instances)
      widget {
        timeseries_definition {
          title       = "EC2 CPU Credit Balance (T-series)"
          title_size  = "16"
          title_align = "left"

          request {
            q            = "avg:aws.ec2.cpucredit_balance{env:$environment.value} by {instance_id}"
            display_type = "line"
            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            label = "CPU Credits"
            min   = "0"
          }

          marker {
            value        = "y = 20"
            display_type = "warning dashed"
            label        = "Low Credits"
          }
        }
      }
    }
  }

  # ============================================================================
  # SECTION 5: Process Monitoring
  # ============================================================================

  widget {
    group_definition {
      title       = "🔄 Process Monitoring"
      layout_type = "ordered"

      # Process Count
      widget {
        timeseries_definition {
          title       = "Running Processes"
          title_size  = "16"
          title_align = "left"

          request {
            q            = "sum:system.processes.number{env:$environment.value} by {host}"
            display_type = "line"
            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            label = "Process Count"
            min   = "0"
          }
        }
      }

      # Docker Container Metrics (if available)
      widget {
        timeseries_definition {
          title       = "Docker Container CPU"
          title_size  = "16"
          title_align = "left"

          request {
            q            = "avg:docker.cpu.usage{env:$environment.value} by {container_name}"
            display_type = "line"
            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }
          }

          yaxis {
            label = "CPU %"
          }
        }
      }
    }
  }

  # ============================================================================
  # SECTION 6: Host Map
  # ============================================================================

  widget {
    hostmap_definition {
      title       = "🗺️ Infrastructure Host Map"
      title_size  = "16"
      title_align = "left"

      request {
        fill {
          q = "avg:system.cpu.user{env:$environment.value} by {host}"
        }
        size {
          q = "avg:system.mem.used{env:$environment.value} by {host}"
        }
      }

      node_type       = "host"
      no_metric_hosts = true
      no_group_hosts  = true

      group = ["service", "env"]

      style {
        palette      = "hostmap_blues"
        palette_flip = false
      }
    }
  }

  # Dashboard tags
  tags = concat(
    ["terraform:true", "environment:${var.environment}", "project:${var.project_name}"],
    [for k, v in var.datadog_tags : "${k}:${v}"]
  )
}

# ============================================================================
# Outputs
# ============================================================================

output "datadog_dashboard_url" {
  description = "URL to view the Datadog dashboard"
  value       = var.create_datadog_dashboard ? try(datadog_dashboard.main[0].url, "Dashboard not created") : "Dashboard creation disabled"
}

output "datadog_dashboard_id" {
  description = "ID of the created Datadog dashboard"
  value       = var.create_datadog_dashboard ? try(datadog_dashboard.main[0].id, "Dashboard not created") : "Dashboard creation disabled"
}

