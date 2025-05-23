resource "datadog_dashboard" "aws_infrastructure_dashboard" {
  title         = "Infraestructura AWS - Monitorización"
  description   = "Dashboard para monitorizar la infraestructura AWS desplegada con Terraform"
  layout_type   = "ordered"
  is_read_only  = false
  
  widget {
    group_definition {
      title = "Instancias EC2"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title = "Utilización de CPU por instancia"
          request {
            q    = "avg:aws.ec2.cpuutilization{*} by {host}"
            display_type = "line"
          }
          yaxis {
            max = "100"
            min = "0"
          }
        }
      }
      
      widget {
        timeseries_definition {
          title = "Uso de memoria por instancia"
          request {
            q    = "avg:system.mem.used{*} by {host}"
            display_type = "line"
          }
        }
      }
      
      widget {
        timeseries_definition {
          title = "Tráfico de red por instancia"
          request {
            q    = "avg:aws.ec2.network_in{*} by {host}"
            display_type = "area"
          }
          request {
            q    = "avg:aws.ec2.network_out{*} by {host}"
            display_type = "area"
          }
        }
      }
    }
  }
  
  widget {
    group_definition {
      title = "Aplicación Backend"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title = "Tiempo de respuesta"
          request {
            q    = "avg:trace.http.request{service:backend,env:production}*1000"
            display_type = "line"
          }
        }
      }
      
      widget {
        query_value_definition {
          title = "Tasa de errores (%)"
          precision = 2
          request {
            q    = "100 * sum:trace.http.request.errors{service:backend} / sum:trace.http.request.hits{service:backend}"
            aggregator = "avg"
            conditional_formats {
              comparator = ">"
              value = "5"
              palette = "red"
            }
            conditional_formats {
              comparator = ">"
              value = "2"
              palette = "yellow"
            }
            conditional_formats {
              comparator = "<="
              value = "2"
              palette = "green"
            }
          }
        }
      }
      
      widget {
        timeseries_definition {
          title = "Solicitudes por minuto"
          request {
            q    = "sum:trace.http.request.hits{service:backend}.as_rate()"
            display_type = "bars"
          }
        }
      }
    }
  }
  
  widget {
    group_definition {
      title = "Aplicación Frontend"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title = "Tiempo de carga de página"
          request {
            q    = "avg:rum.performance.timing.dom_interactive{service:frontend}"
            display_type = "line"
          }
        }
      }
      
      widget {
        timeseries_definition {
          title = "Usuarios activos"
          request {
            q    = "sum:rum.session_count{service:frontend}.as_count()"
            display_type = "area"
          }
        }
      }
      
      widget {
        query_value_definition {
          title = "Errores JavaScript"
          precision = 0
          request {
            q    = "sum:rum.error_count{service:frontend}.as_count()"
            aggregator = "sum"
            conditional_formats {
              comparator = ">"
              value = "10"
              palette = "red"
            }
            conditional_formats {
              comparator = "<="
              value = "10"
              palette = "green"
            }
          }
        }
      }
    }
  }
  
  widget {
    group_definition {
      title = "Contenedores Docker"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title = "Uso de CPU por contenedor"
          request {
            q    = "avg:docker.cpu.usage{*} by {container_name}"
            display_type = "line"
          }
        }
      }
      
      widget {
        timeseries_definition {
          title = "Uso de memoria por contenedor"
          request {
            q    = "avg:docker.mem.rss{*} by {container_name}"
            display_type = "line"
          }
        }
      }
    }
  }
  
  widget {
    group_definition {
      title = "S3"
      layout_type = "ordered"
      
      widget {
        timeseries_definition {
          title = "Operaciones en bucket S3"
          request {
            q    = "sum:aws.s3.get_requests{bucket_name:ai4devs-project-code-bucket}"
            display_type = "bars"
          }
          request {
            q    = "sum:aws.s3.put_requests{bucket_name:ai4devs-project-code-bucket}"
            display_type = "bars"
          }
        }
      }
      
      widget {
        query_value_definition {
          title = "Tamaño total del bucket (bytes)"
          precision = 2
          request {
            q    = "sum:aws.s3.bucket_size_bytes{bucket_name:ai4devs-project-code-bucket}"
            aggregator = "last"
          }
        }
      }
    }
  }
  
  widget {
    service_level_objective_definition {
      title = "SLO - Disponibilidad del Backend"
      view_type = "detail"
      view_mode = "overall"
      slo_id = datadog_service_level_objective.backend_availability_slo.id
      show_error_budget = true
      time_windows = ["7d", "30d", "90d"]
    }
  }
  
  widget {
    alert_graph_definition {
      title = "Alertas activas"
      alert_id = datadog_monitor.high_cpu_usage.id
      viz_type = "timeseries"
    }
  }
  
  widget {
    hostmap_definition {
      title = "Mapa de hosts"
      request {
        fill {
          q = "avg:system.cpu.user{*} by {host}"
        }
      }
      style {
        palette = "green_to_orange"
        palette_flip = false
      }
    }
  }
}

# Definición del SLO para la disponibilidad del backend
resource "datadog_service_level_objective" "backend_availability_slo" {
  name        = "Backend Availability"
  type        = "monitor"
  description = "SLO para la disponibilidad del servicio backend"
  monitor_ids = [datadog_monitor.backend_availability.id]
  
  thresholds {
    timeframe = "7d"
    target    = 99.9
    warning   = 99.99
  }

  thresholds {
    timeframe = "30d"
    target    = 99.9
    warning   = 99.95
  }
  
  thresholds {
    timeframe = "90d"
    target    = 99.9
    warning   = 99.95
  }
  
  tags = ["service:backend", "env:production", "managed-by:terraform"]
}

# Monitor para verificar la disponibilidad del backend
resource "datadog_monitor" "backend_availability" {
  name               = "Backend Availability"
  type               = "service check"
  query              = "\"http.can_connect\".over(\"instance:backend_status_check\").by(\"host\",\"instance\").last(2).count_by_status()"
  message            = "El backend está experimentando problemas de disponibilidad. Por favor, investiga.\n\n{{#is_alert}}\n@slack-equipo-infraestructura\n{{/is_alert}}"
  tags               = ["service:backend", "env:production", "managed-by:terraform"]

  monitor_thresholds {
    ok       = 1
    critical = 1
    warning  = 1
  }
}

# Monitor para alerta de uso elevado de CPU
resource "datadog_monitor" "high_cpu_usage" {
  name               = "Alta utilización de CPU"
  type               = "metric alert"
  query              = "avg(last_15m):avg:aws.ec2.cpuutilization{*} by {host} > 80"
  message            = "La utilización de CPU ha estado por encima del 80% durante los últimos 15 minutos.\n\n{{#is_alert}}\n@slack-equipo-infraestructura\n{{/is_alert}}"
  tags               = ["env:production", "managed-by:terraform"]

  monitor_thresholds {
    critical = 80
    warning  = 70
  }
} 