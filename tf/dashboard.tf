# dashboard.tf

resource "datadog_dashboard" "infrastructure_observability" {
  title       = "AWS Infrastructure Observability - EC2"
  description = "Monitorización avanzada del Frontend (t2.medium) y Backend (t2.micro)"
  layout_type = "ordered"

  # Widget 1: Uso de CPU promedio por instancia
  widget {
    timeseries_definition {
      title = "🔥 Uso de CPU (%)"
      
      request {
        # Promedio del CPU por Tipo de Instancia (Agregado desde los agentes y la integración)
        q            = "avg:system.cpu.system{*} by {host,instance-type} + avg:system.cpu.user{*} by {host,instance-type}"
        display_type = "line"
        
        style {
          palette    = "dog_classic"
          line_type  = "solid"
          line_width = "normal"
        }
      }
    }
  }

  # Widget 2: Tráfico de Red (Tasa de Entrada/Salida en Bytes)
  widget {
    timeseries_definition {
      title = "🌐 Tráfico de Red (In/Out Rates)"
      
      request {
        q            = "avg:system.net.bytes_rcvd{*} by {host}"
        display_type = "bars"
      }
      
      request {
        q            = "avg:system.net.bytes_sent{*} by {host}"
        display_type = "bars"
      }
    }
  }

  # Widget 3: Estado de Salud del Agente de Datadog
  widget {
    check_status_definition {
      title    = "🛡️ Estado del Agente de Datadog"
      check    = "datadog.agent.up"
      grouping = "check"
      group_by = ["host"]
      tags     = ["*"]
    }
  }

  # Soporte para filtrar instancias fácilmente en la UI del dashboard
  template_variable {
    name    = "host"
    prefix  = "host"
    default = "*"
  }
}
