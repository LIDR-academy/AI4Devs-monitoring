# ------------------------------------------------------------------------------
# Dashboard Datadog - AWS EC2 LTI Project
# Métricas de utilización CPU, red y estado de instancias.
# ------------------------------------------------------------------------------

resource "datadog_dashboard" "aws_ec2" {
  title        = "AWS EC2 - LTI Project"
  layout_type  = "ordered"
  description  = "Métricas clave de instancias EC2 (backend y frontend) - generado por Terraform"
  widget {
    timeseries_definition {
      title = "EC2 CPU Utilization"
      request {
        q            = "avg:aws.ec2.cpu{*} by {name}"
        display_type = "line"
      }
      live_span = "1h"
    }
  }

  widget {
    timeseries_definition {
      title = "EC2 Network In"
      request {
        q            = "avg:aws.ec2.network_in{*} by {name}"
        display_type = "line"
      }
      live_span = "1h"
    }
  }

  widget {
    timeseries_definition {
      title = "EC2 Network Out"
      request {
        q            = "avg:aws.ec2.network_out{*} by {name}"
        display_type = "line"
      }
      live_span = "1h"
    }
  }

  widget {
    query_value_definition {
      title = "EC2 Instance Count"
      request {
        q          = "sum:aws.ec2.status_check_failed{*}.as_count()"
        aggregator = "last"
      }
      live_span = "1h"
      custom_unit = "instances"
    }
  }

  widget {
    timeseries_definition {
      title = "System Memory (Agent)"
      request {
        q            = "avg:system.mem.used{*} by {host}"
        display_type = "area"
      }
      live_span = "1h"
    }
  }

  widget {
    timeseries_definition {
      title = "System CPU (Agent)"
      request {
        q            = "avg:system.cpu.user{*} by {host}"
        display_type = "line"
      }
      live_span = "1h"
    }
  }
}
