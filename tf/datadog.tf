# Configure the Datadog Provider
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# Datadog AWS Integration
resource "datadog_integration_aws" "main" {
  account_id                       = data.aws_caller_identity.current.account_id
  role_name                        = aws_iam_role.datadog_role.name
  filter_tags                      = ["env:production"]
  host_tags                        = ["account:production"]
  account_specific_namespace_rules = {
    auto_scaling = false
    opsworks     = false
  }
  excluded_regions = []
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# IAM Role for Datadog AWS Integration
resource "aws_iam_role" "datadog_role" {
  name = "datadog-integration-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root" # Datadog's AWS account
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.datadog_external_id
          }
        }
      }
    ]
  })
}

# Attach Datadog AWS Integration Policy
resource "aws_iam_role_policy_attachment" "datadog_policy" {
  role       = aws_iam_role.datadog_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Datadog Dashboard for AWS Metrics
resource "datadog_dashboard" "aws_monitoring" {
  title         = "AI4Devs AWS Monitoring Dashboard"
  description   = "Dashboard for monitoring AWS infrastructure metrics"
  layout_type   = "ordered"

  widget {
    widget_layout {
      x      = 0
      y      = 0
      width  = 47
      height = 15
    }
    timeseries_definition {
      title = "EC2 CPU Utilization"
      request {
        q = "avg:aws.ec2.cpuutilization{*}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      yaxis {
        label = "CPU %"
        scale = "linear"
      }
    }
  }

  widget {
    widget_layout {
      x      = 47
      y      = 0
      width  = 47
      height = 15
    }
    timeseries_definition {
      title = "EC2 Network In/Out"
      request {
        q = "avg:aws.ec2.networkin{*}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      request {
        q = "avg:aws.ec2.networkout{*}"
        display_type = "line"
        style {
          palette = "warm"
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
      y      = 15
      width  = 47
      height = 15
    }
    timeseries_definition {
      title = "EC2 Disk Read/Write"
      request {
        q = "avg:aws.ec2.diskreadbytes{*}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      request {
        q = "avg:aws.ec2.diskwritebytes{*}"
        display_type = "line"
        style {
          palette = "warm"
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
      x      = 47
      y      = 15
      width  = 47
      height = 15
    }
    query_value_definition {
      title = "Total EC2 Instances"
      request {
        q = "sum:aws.ec2.status_check_failed{*}"
        aggregator = "sum"
      }
      autoscale = true
      precision = 0
    }
  }

  widget {
    widget_layout {
      x      = 0
      y      = 30
      width  = 94
      height = 15
    }
    log_stream_definition {
      title = "Application Logs"
      query = "source:docker"
      columns = ["timestamp", "status", "service", "message"]
      show_date_column = true
      show_message_column = true
      message_display = "expanded-md"
    }
  }
}

# Datadog Monitor for High CPU Usage
resource "datadog_monitor" "high_cpu" {
  name               = "High CPU Usage Alert"
  type               = "metric alert"
  message            = "CPU usage is high on EC2 instances"
  escalation_message = "CPU usage is critically high"

  query = "avg(last_5m):avg:aws.ec2.cpuutilization{*} > 80"

  monitor_thresholds {
    warning  = 70
    critical = 80
  }

  notify_no_data    = false
  renotify_interval = 60
  include_tags      = true
  tags              = ["env:production", "service:ai4devs"]
}

# Datadog Monitor for Instance Status Checks
resource "datadog_monitor" "instance_status" {
  name               = "EC2 Instance Status Check Failed"
  type               = "metric alert"
  message            = "EC2 instance status check failed"
  escalation_message = "EC2 instance is experiencing issues"

  query = "avg(last_5m):avg:aws.ec2.status_check_failed{*} > 0"

  monitor_thresholds {
    warning  = 0
    critical = 1
  }

  notify_no_data    = false
  renotify_interval = 60
  include_tags      = true
  tags              = ["env:production", "service:ai4devs"]
}
