# Datadog APM Configuration para Aplicación LTI
# Configuración simplificada de Application Performance Monitoring

# APM Monitor para Backend Response Time
resource "datadog_monitor" "apm_backend_response_time" {
  name               = "Backend APM Response Time - LTI Application"
  type               = "metric alert"
  message            = "Backend response time is high for {{service.name}}. Current value: {{value}}ms. @slack-alerts"
  escalation_message = "Backend response time is critically high for {{service.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_10m):avg:trace.http.request.duration{service:lti-backend} by {resource_name} > 1000"

  monitor_thresholds {
    warning  = 500
    critical = 1000
  }

  notify_no_data    = false
  renotify_interval = 60
  timeout_h         = 0
  include_tags      = true
  priority          = 1

  tags = [
    "env:dev",
    "service:lti-backend",
    "team:devops",
    "severity:medium",
    "type:apm"
  ]
}

# APM Monitor para Frontend Response Time
resource "datadog_monitor" "apm_frontend_response_time" {
  name               = "Frontend APM Response Time - LTI Application"
  type               = "metric alert"
  message            = "Frontend response time is high for {{service.name}}. Current value: {{value}}ms. @slack-alerts"
  escalation_message = "Frontend response time is critically high for {{service.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_10m):avg:trace.http.request.duration{service:lti-frontend} by {resource_name} > 2000"

  monitor_thresholds {
    warning  = 1000
    critical = 2000
  }

  notify_no_data    = false
  renotify_interval = 60
  timeout_h         = 0
  include_tags      = true
  priority          = 1

  tags = [
    "env:dev",
    "service:lti-frontend",
    "team:devops",
    "severity:medium",
    "type:apm"
  ]
}

# APM Monitor para Error Rate
resource "datadog_monitor" "apm_error_rate" {
  name               = "APM Error Rate - LTI Application"
  type               = "metric alert"
  message            = "APM error rate is high for {{service.name}}. Current value: {{value}}%. @slack-alerts"
  escalation_message = "APM error rate is critically high for {{service.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_10m):avg:trace.http.request.errors{service:lti-*} by {service} > 3"

  monitor_thresholds {
    warning  = 1
    critical = 3
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
    "type:apm"
  ]
}
