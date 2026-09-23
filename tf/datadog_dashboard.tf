# Datadog Dashboard for AWS Infrastructure Monitoring
resource "datadog_dashboard" "aws_infrastructure" {
  title         = "AWS Infrastructure Monitoring - LTI Project"
  description   = "Dashboard para monitorear la infraestructura AWS del proyecto LTI"
  layout_type   = "ordered"
  is_read_only  = false

  widget {
    widget_layout {
      x      = 0
      y      = 0
      width  = 12
      height = 8
    }
    timeseries_definition {
      title = "CPU Utilization - EC2 Instances"
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
        min   = "0"
        max   = "100"
      }
    }
  }

  widget {
    widget_layout {
      x      = 0
      y      = 8
      width  = 12
      height = 8
    }
    timeseries_definition {
      title = "Memory Utilization - EC2 Instances"
      request {
        q = "avg:system.mem.used{*} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Memory %"
        scale = "linear"
        min   = "0"
        max   = "100"
      }
    }
  }

  widget {
    widget_layout {
      x      = 0
      y      = 16
      width  = 12
      height = 8
    }
    timeseries_definition {
      title = "Network Traffic - EC2 Instances"
      request {
        q = "avg:aws.ec2.networkin{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      request {
        q = "avg:aws.ec2.networkout{*} by {instance-id}"
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
    widget_layout {
      x      = 0
      y      = 24
      width  = 12
      height = 8
    }
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
    widget_layout {
      x      = 0
      y      = 32
      width  = 12
      height = 8
    }
    query_value_definition {
      title = "Total EC2 Instances"
      request {
        q = "sum:aws.ec2.instance_count{*}"
        aggregator = "sum"
      }
      autoscale = true
      precision = 0
    }
  }
}

# Datadog Monitor for High CPU Usage
resource "datadog_monitor" "high_cpu" {
  name               = "High CPU Usage - EC2 Instances"
  type               = "metric alert"
  message            = "CPU usage is high on EC2 instance {{instance-id.name}}"
  escalation_message = "CPU usage is critically high on EC2 instance {{instance-id.name}}"

  query = "avg(last_5m):avg:aws.ec2.cpuutilization{*} by {instance-id} > 80"

  monitor_thresholds {
    warning  = 70
    critical = 80
  }

  notify_no_data    = false
  renotify_interval = 0
  notify_audit      = false
  timeout_h         = 0
  include_tags      = true
  require_full_window = true
  new_group_delay   = 300
}

# Datadog Monitor for High Memory Usage
resource "datadog_monitor" "high_memory" {
  name               = "High Memory Usage - EC2 Instances"
  type               = "metric alert"
  message            = "Memory usage is high on host {{host.name}}"
  escalation_message = "Memory usage is critically high on host {{host.name}}"

  query = "avg(last_5m):avg:system.mem.used{*} by {host} > 80"

  monitor_thresholds {
    warning  = 70
    critical = 80
  }

  notify_no_data    = false
  renotify_interval = 0
  notify_audit      = false
  timeout_h         = 0
  include_tags      = true
  require_full_window = true
  new_group_delay   = 300
}