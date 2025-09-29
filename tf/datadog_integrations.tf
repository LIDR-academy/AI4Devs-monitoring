# Integraciones específicas de Datadog para la aplicación AI4Devs

# Nota: Las integraciones específicas de Node.js y React se configuran automáticamente
# cuando el agente de Datadog detecta las aplicaciones en las instancias EC2

# Nota: Las definiciones de servicios se configurarán automáticamente
# cuando el agente de Datadog detecte las aplicaciones en las instancias EC2

# Configuración de logs para el backend
resource "datadog_logs_custom_pipeline" "backend_logs_pipeline" {
  name       = "Backend Logs Pipeline"
  filter {
    query = "service:lti-backend"
  }
  
  processor {
    grok_parser {
      name       = "Parse Backend Logs"
      is_enabled = true
      source     = "message"
      grok {
        support_rules = ""
        match_rules   = "%%{date:timestamp} %%{word:level} %%{data:message}"
      }
    }
  }
  
  processor {
    status_remapper {
      name       = "Map Status"
      is_enabled = true
      sources    = ["status", "http.status_code"]
    }
  }
  
  processor {
    attribute_remapper {
      name       = "Map Service"
      is_enabled = true
      sources    = ["service"]
      target     = "service"
      target_type = "attribute"
      source_type = "attribute"
    }
  }
}

# Configuración de logs para el frontend
resource "datadog_logs_custom_pipeline" "frontend_logs_pipeline" {
  name       = "Frontend Logs Pipeline"
  filter {
    query = "service:lti-frontend"
  }
  
  processor {
    grok_parser {
      name       = "Parse Frontend Logs"
      is_enabled = true
      source     = "message"
      grok {
        support_rules = ""
        match_rules   = "%%{date:timestamp} %%{word:level} %%{data:message}"
      }
    }
  }
  
  processor {
    status_remapper {
      name       = "Map Status"
      is_enabled = true
      sources    = ["status", "http.status_code"]
    }
  }
  
  processor {
    attribute_remapper {
      name       = "Map Service"
      is_enabled = true
      sources    = ["service"]
      target     = "service"
      target_type = "attribute"
      source_type = "attribute"
    }
  }
}

# Nota: Las métricas personalizadas, integraciones de email y webhooks
# se configuran directamente en la interfaz de Datadog o mediante la API
# para mayor flexibilidad y facilidad de mantenimiento

# Configuración de synthetics para monitoreo de endpoints
# Nota: Los tests sintéticos se configurarán después del despliegue
# cuando tengamos las IPs públicas de las instancias EC2
