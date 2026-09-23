# ============================================================================
# Datadog Dashboard - LTI Monitoring System
# ============================================================================
# Visualización de métricas de infraestructura AWS para el proyecto LTI
# Incluye: CPU, Memoria, Disco, y métricas de sistema operativo
# ============================================================================

resource "datadog_dashboard" "lti_monitoring" {
  title       = "LTI Monitoring - AWS Infrastructure"
  description = "Dashboard de monitorización para instancias EC2 del proyecto LTI (Backend + Frontend). Métricas filtradas por project:lti-monitoring y env:dev."
  layout_type = "ordered"

  # ============================================================================
  # SECCIÓN 1: CPU Metrics
  # ============================================================================
  
  widget {
    group_definition {
      title       = "🖥️ CPU Performance"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title       = "CPU Usage by Mode"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          legend_size = "auto"
          
          request {
            q            = "avg:system.cpu.user{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          
          request {
            q            = "avg:system.cpu.system{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "warm"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          
          request {
            q            = "avg:system.cpu.idle{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "cool"
              line_type  = "dashed"
              line_width = "thin"
            }
          }
        }
      }
      
      widget {
        query_value_definition {
          title       = "CPU User - Current Average"
          title_size  = "16"
          title_align = "left"
          autoscale   = true
          precision   = 2
          
          request {
            q          = "avg:system.cpu.user{project:lti-monitoring}"
            aggregator = "avg"
          }
        }
      }
    }
  }

  # ============================================================================
  # SECCIÓN 2: Memory Metrics
  # ============================================================================
  
  widget {
    group_definition {
      title       = "💾 Memory Usage"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title       = "Memory Used vs Total"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
          request {
            q            = "avg:system.mem.used{project:lti-monitoring} by {host}"
            display_type = "area"
            style {
              palette = "warm"
            }
          }
          
          request {
            q            = "avg:system.mem.total{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "grey"
              line_type  = "dashed"
              line_width = "thin"
            }
          }
        }
      }
      
      widget {
        query_value_definition {
          title       = "Memory Used - Current (Bytes)"
          title_size  = "16"
          title_align = "left"
          autoscale   = true
          precision   = 0
          
          request {
            q          = "avg:system.mem.used{project:lti-monitoring}"
            aggregator = "avg"
          }
        }
      }
      
      widget {
        query_value_definition {
          title       = "Memory Usage - Percentage"
          title_size  = "16"
          title_align = "left"
          autoscale   = false
          precision   = 2
          custom_unit = "%"
          
          request {
            q          = "(avg:system.mem.used{project:lti-monitoring} / avg:system.mem.total{project:lti-monitoring}) * 100"
            aggregator = "avg"
          }
        }
      }
    }
  }

  # ============================================================================
  # SECCIÓN 3: Disk I/O Metrics
  # ============================================================================
  
  widget {
    group_definition {
      title       = "💿 Disk I/O Performance"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title       = "Disk Read Time (ms)"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
          request {
            q            = "avg:system.io.r_await{project:lti-monitoring} by {host,device}"
            display_type = "line"
            style {
              palette    = "blue"
              line_type  = "solid"
              line_width = "normal"
            }
          }
        }
      }
      
      widget {
        timeseries_definition {
          title       = "Disk Write Time (ms)"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
          request {
            q            = "avg:system.io.w_await{project:lti-monitoring} by {host,device}"
            display_type = "line"
            style {
              palette    = "orange"
              line_type  = "solid"
              line_width = "normal"
            }
          }
        }
      }
      
      widget {
        timeseries_definition {
          title       = "Disk Usage Percentage"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
          request {
            q            = "avg:system.disk.in_use{project:lti-monitoring} by {host,device}"
            display_type = "area"
            style {
              palette = "warm"
            }
          }
        }
      }
    }
  }

  # ============================================================================
  # SECCIÓN 4: Network Metrics
  # ============================================================================
  
  widget {
    group_definition {
      title       = "🌐 Network Traffic"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title       = "Network Bytes Sent/Received"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
          request {
            q            = "avg:system.net.bytes_rcvd{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "green"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          
          request {
            q            = "avg:system.net.bytes_sent{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "purple"
              line_type  = "solid"
              line_width = "normal"
            }
          }
        }
      }
    }
  }

  # ============================================================================
  # SECCIÓN 5: System Load
  # ============================================================================
  
  widget {
    group_definition {
      title       = "⚖️ System Load Average"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title       = "Load Average (1m, 5m, 15m)"
          title_size  = "16"
          title_align = "left"
          show_legend = true
          
          request {
            q            = "avg:system.load.1{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "thick"
            }
          }
          
          request {
            q            = "avg:system.load.5{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "warm"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          
          request {
            q            = "avg:system.load.15{project:lti-monitoring} by {host}"
            display_type = "line"
            style {
              palette    = "cool"
              line_type  = "dashed"
              line_width = "normal"
            }
          }
        }
      }
    }
  }

  # ============================================================================
  # SECCIÓN 6: Host Overview
  # ============================================================================
  
  widget {
    group_definition {
      title       = "📊 Hosts Overview"
      layout_type = "ordered"
      
      widget {
        hostmap_definition {
          title       = "Hosts Status by Service"
          title_size  = "16"
          title_align = "left"
          
          request {
            fill {
              q = "avg:system.cpu.user{project:lti-monitoring} by {host}"
            }
          }
          
          node_type = "host"
          
          scope = ["project:lti-monitoring"]
          
          group = ["service"]
          
          style {
            palette      = "hostmap_blues"
            palette_flip = false
          }
        }
      }
    }
  }
}

# ============================================================================
# Output: Dashboard URL
# ============================================================================

output "dashboard_url" {
  description = "URL del Dashboard de Datadog en la región EU"
  value       = "https://app.datadoghq.eu/dashboard/${datadog_dashboard.lti_monitoring.id}"
}
