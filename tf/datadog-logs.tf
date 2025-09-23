# Datadog Log Configuration para Aplicación LTI
# Configuración simplificada de logs para monitoreo de aplicaciones

# Log Index para búsqueda optimizada
resource "datadog_logs_index" "lti_application_index" {
  name = "lti-application-logs"
  filter {
    query = "env:dev service:lti-*"
  }
  
  exclusion_filter {
    name       = "exclude_debug_logs"
    is_enabled = true
    filter {
      query = "status:debug"
    }
  }
  
  exclusion_filter {
    name       = "exclude_health_check_logs"
    is_enabled = true
    filter {
      query = "message:health"
    }
  }
}

# Log Monitor para Error Detection
resource "datadog_monitor" "log_error_detection" {
  name               = "Application Error Logs Detected - LTI"
  type               = "log alert"
  message            = "Error logs detected in LTI application. Please investigate. @slack-alerts"
  escalation_message = "Multiple error logs detected in LTI application. Please investigate immediately. @slack-alerts"

  query = "logs(\"source:lti-* status:error\").index(\"*\").rollup(\"count\").by(\"service\").last(\"5m\") > 5"

  monitor_thresholds {
    warning  = 3
    critical = 5
  }

  notify_no_data    = false
  renotify_interval = 60
  timeout_h         = 0
  include_tags      = true
  priority          = 1

  tags = [
    "env:dev",
    "service:lti-application",
    "team:devops",
    "severity:high",
    "type:logs"
  ]
}

# Log Monitor para Performance Issues
resource "datadog_monitor" "log_performance_issues" {
  name               = "Application Performance Issues Detected - LTI"
  type               = "log alert"
  message            = "Performance issues detected in LTI application logs. Please investigate. @slack-alerts"
  escalation_message = "Multiple performance issues detected in LTI application logs. Please investigate immediately. @slack-alerts"

  query = "logs(\"source:lti-* message:*slow* OR message:*timeout*\").index(\"*\").rollup(\"count\").by(\"service\").last(\"10m\") > 3"

  monitor_thresholds {
    warning  = 2
    critical = 3
  }

  notify_no_data    = false
  renotify_interval = 60
  timeout_h         = 0
  include_tags      = true
  priority          = 2

  tags = [
    "env:dev",
    "service:lti-application",
    "team:devops",
    "severity:medium",
    "type:logs"
  ]
}
