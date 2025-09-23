# Datadog Monitors para Aplicación LTI
# Alertas críticas para monitoreo proactivo de la infraestructura y aplicación

# Monitor 1: EC2 High CPU Usage
resource "datadog_monitor" "ec2_high_cpu" {
  name               = "EC2 High CPU Usage - LTI Application"
  type               = "metric alert"
  message            = "CPU usage is high on EC2 instance {{host.name}}. Current value: {{value}}%. @slack-alerts"
  escalation_message = "CPU usage is critically high on {{host.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_5m):avg:system.cpu.user{env:dev} by {host} > 80"

  monitor_thresholds {
    warning  = 70
    critical = 80
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
    "severity:high"
  ]
}

# Monitor 2: EC2 High Memory Usage
resource "datadog_monitor" "ec2_high_memory" {
  name               = "EC2 High Memory Usage - LTI Application"
  type               = "metric alert"
  message            = "Memory usage is high on EC2 instance {{host.name}}. Current value: {{value}}%. @slack-alerts"
  escalation_message = "Memory usage is critically high on {{host.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_5m):avg:system.mem.pct_usable{env:dev} by {host} < 20"

  monitor_thresholds {
    warning  = 30
    critical = 20
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
    "severity:high"
  ]
}

# Monitor 3: EC2 High Disk Usage
resource "datadog_monitor" "ec2_high_disk" {
  name               = "EC2 High Disk Usage - LTI Application"
  type               = "metric alert"
  message            = "Disk usage is high on EC2 instance {{host.name}}. Current value: {{value}}%. @slack-alerts"
  escalation_message = "Disk usage is critically high on {{host.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_5m):avg:system.disk.in_use{env:dev} by {host,device} > 85"

  monitor_thresholds {
    warning  = 75
    critical = 85
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
    "severity:high"
  ]
}

# Monitor 4: Datadog Agent Down
resource "datadog_monitor" "datadog_agent_down" {
  name               = "Datadog Agent Down - LTI Application"
  type               = "service check"
  message            = "Datadog Agent is down on {{host.name}}. Please check the agent status. @slack-alerts"
  escalation_message = "Datadog Agent is still down on {{host.name}}. Please investigate immediately. @slack-alerts"

  query = "\"datadog.agent.up\".over(\"env:dev\").by(\"host\").last(2).count_by_status()"

  monitor_thresholds {
    warning  = 1
    critical = 1
  }

  notify_no_data    = true
  renotify_interval = 60
  timeout_h         = 0
  include_tags      = true
  priority          = 2

  tags = [
    "env:dev",
    "service:lti-application",
    "team:devops",
    "severity:critical"
  ]
}

# Monitor 5: EC2 Instance Status Check Failed
resource "datadog_monitor" "ec2_status_check_failed" {
  name               = "EC2 Status Check Failed - LTI Application"
  type               = "service check"
  message            = "EC2 Status Check failed for {{host.name}}. Please check instance health. @slack-alerts"
  escalation_message = "EC2 Status Check is still failing for {{host.name}}. Please investigate immediately. @slack-alerts"

  query = "\"aws.ec2.status_check_failed\".over(\"env:dev\").by(\"host\").last(2).count_by_status()"

  monitor_thresholds {
    warning  = 1
    critical = 1
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
    "severity:critical"
  ]
}

# Monitor 6: Docker Container Down
resource "datadog_monitor" "docker_container_down" {
  name               = "Docker Container Down - LTI Application"
  type               = "metric alert"
  message            = "Docker container is down on {{host.name}}. Please check container status. @slack-alerts"
  escalation_message = "Docker container is still down on {{host.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_5m):avg:docker.containers.running{env:dev} by {host} < 1"

  monitor_thresholds {
    warning  = 1
    critical = 1
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
    "severity:high"
  ]
}

# Monitor 7: Application High Response Time
resource "datadog_monitor" "app_high_response_time" {
  name               = "Application High Response Time - LTI Application"
  type               = "metric alert"
  message            = "Application response time is high for {{service.name}}. Current value: {{value}}ms. @slack-alerts"
  escalation_message = "Application response time is critically high for {{service.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_10m):avg:trace.http.request.duration{env:dev} by {service} > 2000"

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
    "service:lti-application",
    "team:devops",
    "severity:medium"
  ]
}

# Monitor 8: Application High Error Rate
resource "datadog_monitor" "app_high_error_rate" {
  name               = "Application High Error Rate - LTI Application"
  type               = "metric alert"
  message            = "Application error rate is high for {{service.name}}. Current value: {{value}}%. @slack-alerts"
  escalation_message = "Application error rate is critically high for {{service.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_10m):avg:trace.http.request.errors{env:dev} by {service} > 5"

  monitor_thresholds {
    warning  = 2
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
    "severity:medium"
  ]
}

# Monitor 9: Network Connectivity Issues
resource "datadog_monitor" "network_connectivity" {
  name               = "Network Connectivity Issues - LTI Application"
  type               = "metric alert"
  message            = "Network connectivity issues detected on {{host.name}}. Please check network status. @slack-alerts"
  escalation_message = "Network connectivity is still failing on {{host.name}}. Please investigate immediately. @slack-alerts"

  query = "avg(last_5m):avg:system.net.bytes_sent{env:dev} by {host} < 1000"

  monitor_thresholds {
    warning  = 5000
    critical = 1000
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
    "severity:medium"
  ]
}

# Monitor 10: Free Tier Usage Warning
resource "datadog_monitor" "free_tier_usage_warning" {
  name               = "Free Tier Usage Warning - LTI Application"
  type               = "metric alert"
  message            = "Free tier usage is approaching limits. Please review usage patterns. @slack-alerts"
  escalation_message = "Free tier usage has exceeded limits. Please upgrade plan or optimize usage. @slack-alerts"

  query = "avg(last_1h):avg:datadog.agent.metrics{env:dev} by {host} > 1000"

  monitor_thresholds {
    warning  = 800
    critical = 1000
  }

  notify_no_data    = false
  renotify_interval = 1440  # 24 hours
  timeout_h         = 0
  include_tags      = true
  priority          = 3

  tags = [
    "env:dev",
    "service:lti-application",
    "team:devops",
    "severity:low",
    "free_tier:optimized"
  ]
}
