# Obtener la identidad actual de AWS
data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# Crear el rol IAM para Datadog
resource "aws_iam_role" "datadog" {
  name = "DatadogIntegrationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root" # Cuenta oficial de Datadog
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Adjuntar la política de permisos necesaria para Datadog
resource "aws_iam_role_policy_attachment" "datadog" {
  role       = aws_iam_role.datadog.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Crear la integración AWS-Datadog
resource "datadog_integration_aws_account" "integration" {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_partition  = "aws"
  auth_config {
    aws_auth_config_role {
      role_name = "aws_iam_role.datadog.name"
    }
  }
  aws_regions {
    include_all = true
  }
  account_tags = ["env:${var.environment}"]
  logs_config {
    lambda_forwarder {}
  }
  metrics_config {
    namespace_filters {}
  }
  resources_config {}
  traces_config {
    xray_services {}
  }
}



# Create Datadog monitors for EC2 instances
resource "datadog_monitor" "ec2_cpu" {
  name                = "EC2 High CPU Usage"
  type                = "metric alert"
  message             = "CPU usage is high on {{host.name}} ({{value}}%)"
  query               = "avg(last_5m):avg:aws.ec2.cpuutilization{*} by {host} > 80"
  include_tags        = true
  require_full_window = false

  monitor_thresholds {
    critical = 80
    warning  = 70
  }

  notify_no_data     = true
  renotify_interval  = 60

  tags = ["env:${var.environment}", "service:ec2"]
}

resource "datadog_monitor" "ec2_memory" {
  name                = "EC2 High Memory Usage"
  type                = "metric alert"
  message             = "Memory usage is high on {{host.name}} ({{value}}%)"
  query               = "avg(last_5m):avg:system.mem.used{*} by {host} > 80"
  include_tags        = true
  require_full_window = false

  monitor_thresholds {
    critical = 80
    warning  = 70
  }

  notify_no_data     = true
  renotify_interval  = 60

  tags = ["env:${var.environment}", "service:ec2"]
}

# Create Datadog dashboard
resource "datadog_dashboard" "ec2_dashboard" {
  title       = "EC2 Instances Overview"
  description = "Dashboard for monitoring EC2 instances"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "CPU Usage"
      request {
        q            = "avg:aws.ec2.cpuutilization{*} by {host}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Memory Usage"
      request {
        q            = "avg:system.mem.used{*} by {host}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Network In/Out"
      request {
        q            = "avg:aws.ec2.network_in{*} by {host}"
        display_type = "line"
      }
      request {
        q            = "avg:aws.ec2.network_out{*} by {host}"
        display_type = "line"
      }
    }
  }
}

# Configurar el agente de Datadog en las instancias EC2
resource "aws_ssm_association" "datadog_agent" {
  name = "AWS-ConfigureAWSPackage"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.frontend.id, aws_instance.backend.id]
  }

  parameters = {
    Action = "Install"
    Name   = "datadog-agent"
  }
}

# Modify the user data scripts to install Datadog agent
locals {
  datadog_agent_config = <<-EOF
    DD_API_KEY=${var.datadog_api_key}
    DD_SITE="datadoghq.eu"
    DD_TAGS="env:${var.environment}"
  EOF
}