# Dashboard de Datadog
resource "datadog_dashboard" "aws_dashboard" {
  title        = "AWS Infrastructure Dashboard"
  description  = "Dashboard para monitorear la infraestructura AWS"
  layout_type  = "ordered"

  widget {
    widget_layout {
      x      = 0
      y      = 0
      width  = 6
      height = 8
    }
    timeseries_definition {
      title = "CPU Usage"
      request {
        q = "avg:aws.ec2.cpuutilization{instance-id:${aws_instance.ec2_instance.id}}"
      }
    }
  }

  widget {
    widget_layout {
      x      = 6
      y      = 0
      width  = 6
      height = 8
    }
    timeseries_definition {
      title = "Memory Usage"
      request {
        q = "avg:system.mem.used{instance-id:${aws_instance.ec2_instance.id}}"
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
      title = "Network Traffic"
      request {
        q = "avg:aws.ec2.networkin{instance-id:${aws_instance.ec2_instance.id}}"
      }
    }
  }
} 