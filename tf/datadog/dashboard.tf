resource "datadog_dashboard" "overview_dashboard" {
  title        = "LTI Project Overview Dashboard"
  description  = "Dashboard with key metrics for the LTI project."
  layout_type  = "ordered"
  is_read_only = true

  widget {
    definition {
      type = "note"
      content = "Work In Progress - LTI Dashboard. More widgets to be added."
      background_color = "yellow"
      font_size = "36"
      text_align = "center"
      show_tick = true
      tick_edge = "bottom"
      tick_pos = "50%"
    }
  }

  # Example: CPU Utilization per host
  widget {
    definition {
      title      = "Avg CPU Utilization by Host"
      title_size = "16"
      title_align = "left"
      type       = "timeseries"
      request {
        q    = "avg:aws.ec2.cpuutilization{*} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      time {
        live_span = "1h"
      }
    }
  }

 # Example: Network In per host
  widget {
    definition {
      title      = "Network In by Host"
      title_size = "16"
      title_align = "left"
      type       = "timeseries"
      request {
        q    = "avg:aws.ec2.network_in{*} by {host}"
        display_type = "bars"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      time {
        live_span = "1h"
      }
    }
  }
} 