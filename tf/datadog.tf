# Data source to get AWS account ID
data "aws_caller_identity" "current" {}

# Get the current AWS region
data "aws_region" "current" {}

# IAM Role for Datadog AWS Integration
resource "aws_iam_role" "datadog_integration_role" {
  name = "DatadogIntegrationRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.datadog_external_id
          }
        }
      }
    ]
  })

  tags = {
    Name        = "DatadogIntegrationRole"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "datadog-aws-integration"
  }
}

# Attach AWS managed policy for Datadog core permissions
# Comentado porque la política AWS no existe o no está disponible
# resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
#   role       = aws_iam_role.datadog_integration_role.name
#   policy_arn = "arn:aws:iam::aws:policy/DatadogAWSIntegrationPolicy"
# }

# Additional IAM Policy for enhanced Datadog monitoring
resource "aws_iam_role_policy" "datadog_integration_policy" {
  name = "DatadogIntegrationPolicyCustom"
  role = aws_iam_role.datadog_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "apigateway:GET",
          "autoscaling:Describe*",
          "budgets:ViewBudget",
          "cloudfront:GetDistributionConfig",
          "cloudfront:ListDistributions",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus",
          "cloudtrail:LookupEvents",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "codedeploy:List*",
          "codedeploy:BatchGet*",
          "directconnect:Describe*",
          "dynamodb:List*",
          "dynamodb:Describe*",
          "ec2:Describe*",
          "ecs:Describe*",
          "ecs:List*",
          "elasticache:Describe*",
          "elasticache:List*",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeTags",
          "elasticloadbalancing:Describe*",
          "elasticmapreduce:List*",
          "elasticmapreduce:Describe*",
          "es:ListTags",
          "es:ListDomainNames",
          "es:DescribeElasticsearchDomains",
          "health:DescribeEvents",
          "health:DescribeEventDetails",
          "health:DescribeAffectedEntities",
          "kinesis:List*",
          "kinesis:Describe*",
          "lambda:AddPermission",
          "lambda:GetPolicy",
          "lambda:List*",
          "lambda:RemovePermission",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DeleteLogGroup",
          "logs:DeleteLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents",
          "logs:PutLogEvents",
          "logs:TestMetricFilter",
          "organizations:DescribeOrganization",
          "rds:Describe*",
          "rds:List*",
          "redshift:DescribeClusters",
          "redshift:DescribeLoggingStatus",
          "route53:List*",
          "s3:GetBucketLogging",
          "s3:GetBucketLocation",
          "s3:GetBucketNotification",
          "s3:GetBucketTagging",
          "s3:ListAllMyBuckets",
          "s3:PutBucketNotification",
          "ses:Get*",
          "sns:List*",
          "sns:Publish",
          "sqs:ListQueues",
          "support:*",
          "tag:GetResources",
          "tag:GetTagKeys",
          "tag:GetTagValues",
          "xray:BatchGetTraces",
          "xray:GetTraceSummaries"
        ]
        Resource = "*"
      }
    ]
  })
}

# Datadog AWS Integration with enhanced configuration
resource "datadog_integration_aws" "main" {
  account_id                           = data.aws_caller_identity.current.account_id
  role_name                           = aws_iam_role.datadog_integration_role.name
  filter_tags                         = ["env:production", "project:lti-monitoring"]
  host_tags                          = ["env:production", "project:lti-monitoring", "region:${data.aws_region.current.name}"]
  excluded_regions                   = ["ap-northeast-1", "ap-northeast-2", "ap-south-1"]
  
  # Configure which AWS services to collect metrics from
  account_specific_namespace_rules = {
    auto_scaling                = true
    billing                    = true
    cloudfront                 = true
    cloudwatch_logs           = true
    dynamodb                  = true
    ec2                       = true
    ec2api                    = true
    ecs                       = true
    elb                       = true
    lambda                    = true
    rds                       = true
    route53                   = true
    s3                        = true
    ses                       = true
    sns                       = true
    sqs                       = true
    # Disable unused services
    opsworks                  = false
    workspaces               = false
  }

  # Enable AWS resource collection - using new parameter name
  extended_resource_collection_enabled = true

  depends_on = [
    aws_iam_role.datadog_integration_role,
    aws_iam_role_policy.datadog_integration_policy
  ]
}

# Datadog Log Management - CloudWatch Logs Integration (optional)
resource "datadog_integration_aws_lambda_arn" "cloudwatch_logs_forwarder" {
  count      = var.datadog_forwarder_lambda_arn != "" ? 1 : 0
  account_id = data.aws_caller_identity.current.account_id
  lambda_arn = var.datadog_forwarder_lambda_arn
}

# Datadog Dashboard for AWS Infrastructure Monitoring
resource "datadog_dashboard" "aws_infrastructure" {
  title       = "LTI AWS Infrastructure Monitoring"
  description = "Dashboard for monitoring LTI project AWS infrastructure including EC2, RDS, and application metrics"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "EC2 CPU Utilization"
      request {
        q = "avg:aws.ec2.cpuutilization{env:production} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      yaxis {
        min = "0"
        max = "100"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "EC2 Memory Utilization"
      request {
        q = "avg:system.mem.pct_usable{env:production} by {host}"
        display_type = "line"
        style {
          palette = "dog_classic"
        }
      }
      yaxis {
        min = "0"
        max = "100"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Network In/Out"
      request {
        q = "avg:aws.ec2.network_in{env:production} by {host}"
        display_type = "line"
        style {
          palette = "blue"
        }
      }
      request {
        q = "avg:aws.ec2.network_out{env:production} by {host}"
        display_type = "line"
        style {
          palette = "orange"
        }
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Disk I/O"
      request {
        q = "avg:system.io.r_s{env:production} by {host}"
        display_type = "line"
        style {
          palette = "green"
        }
      }
      request {
        q = "avg:system.io.w_s{env:production} by {host}"
        display_type = "line"
        style {
          palette = "red"
        }
      }
    }
  }

  widget {
    query_value_definition {
      title = "Total EC2 Instances"
      request {
        q = "count:aws.ec2.host{env:production}"
        aggregator = "last"
      }
      autoscale = true
    }
  }

  widget {
    toplist_definition {
      title = "Top EC2 Instances by CPU"
      request {
        q = "top(avg:aws.ec2.cpuutilization{env:production} by {host}, 10, 'mean', 'desc')"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Application Response Time"
      request {
        q = "avg:trace.express.request.duration{env:production} by {service}"
        display_type = "line"
        style {
          palette = "purple"
        }
      }
    }
  }

  widget {
    query_value_definition {
      title = "Error Rate %"
      request {
        q = "sum:trace.express.request.errors{env:production}.as_rate()"
        aggregator = "avg"
        conditional_formats {
          comparator = ">"
          value      = 5
          palette    = "red_on_white"
        }
        conditional_formats {
          comparator = ">"
          value      = 1
          palette    = "yellow_on_white"
        }
      }
      precision = 2
    }
  }

  widget {
    heatmap_definition {
      title = "Request Latency Distribution"
      request {
        q = "avg:trace.express.request.duration{env:production} by {host}"
      }
      yaxis {
        min = "0"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Docker Container Status"
      request {
        q = "avg:docker.containers.running{env:production} by {host}"
        display_type = "bars"
        style {
          palette = "green"
        }
      }
      request {
        q = "avg:docker.containers.stopped{env:production} by {host}"
        display_type = "bars"
        style {
          palette = "red"
        }
      }
    }
  }

  # tags = ["env:production", "project:lti-monitoring", "created-by:terraform", "team:devops-team"]
}

# Datadog Monitor for High CPU Usage
resource "datadog_monitor" "high_cpu" {
  name    = "LTI High CPU Usage Alert"
  type    = "metric alert"
  message = "🚨 CPU usage is above 80% on {{host.name}}. Please investigate. @slack-alerts"

  query = "avg(last_5m):avg:aws.ec2.cpuutilization{env:production} by {host} > 80"

  monitor_thresholds {
    warning           = 70
    critical          = 80
    warning_recovery  = 65
    critical_recovery = 75
  }

  notify_audit        = false
  timeout_h          = 24
  include_tags       = true
  notify_no_data     = true
  no_data_timeframe  = 20
  
  tags = ["env:production", "project:lti-monitoring", "alert:cpu", "severity:high"]
}

# Datadog Monitor for High Memory Usage
resource "datadog_monitor" "high_memory" {
  name    = "LTI High Memory Usage Alert"
  type    = "metric alert"
  message = "⚠️ Memory usage is above 85% on {{host.name}}. Available memory: {{value}}% @slack-alerts"

  query = "avg(last_5m):avg:system.mem.pct_usable{env:production} by {host} < 15"

  monitor_thresholds {
    warning           = 20
    critical          = 15
    warning_recovery  = 25
    critical_recovery = 20
  }

  notify_audit        = false
  timeout_h          = 24
  include_tags       = true
  notify_no_data     = true
  no_data_timeframe  = 20

  tags = ["env:production", "project:lti-monitoring", "alert:memory", "severity:high"]
}

# Datadog Monitor for Disk Space
resource "datadog_monitor" "disk_space" {
  name    = "LTI Disk Space Alert"
  type    = "metric alert"
  message = "💾 Disk space is running low on {{host.name}}. Available: {{value}}% @slack-alerts"

  query = "avg(last_5m):avg:system.disk.free{env:production} by {host,device} / avg:system.disk.total{env:production} by {host,device} * 100 < 20"

  monitor_thresholds {
    warning           = 30
    critical          = 20
    warning_recovery  = 35
    critical_recovery = 25
  }

  notify_audit        = false
  timeout_h          = 24
  include_tags       = true
  notify_no_data     = true
  no_data_timeframe  = 20

  tags = ["env:production", "project:lti-monitoring", "alert:disk", "severity:critical"]
}

# Datadog Monitor for Application Health
resource "datadog_monitor" "app_health" {
  name    = "LTI Application Health Check"
  type    = "service check"
  message = "🔥 Application health check failed on {{host.name}} for service {{check}}. @slack-alerts @pagerduty"

  query = "\"http.can_connect\".over(\"env:production\").by(\"host\",\"instance\").last(2).count_by_status()"

  monitor_thresholds {
    critical = 1
    warning  = 1
  }

  notify_audit        = false
  timeout_h          = 24
  include_tags       = true
  notify_no_data     = true
  no_data_timeframe  = 10

  tags = ["env:production", "project:lti-monitoring", "alert:health", "severity:critical"]
}

# SLO for Application Uptime
resource "datadog_service_level_objective" "app_uptime" {
  name        = "LTI Application Uptime SLO"
  type        = "monitor"
  description = "99.9% uptime target for LTI application"
  monitor_ids = [datadog_monitor.app_health.id]

  thresholds {
    timeframe = "7d"
    target    = 99.9
    warning   = 99.95
  }

  thresholds {
    timeframe = "30d"
    target    = 99.9
    warning   = 99.95
  }

  tags = ["env:production", "project:lti-monitoring", "slo:uptime"]
}

# Output important values
output "datadog_external_id" {
  description = "External ID for Datadog AWS integration"
  value       = var.datadog_external_id
}

output "datadog_role_arn" {
  description = "ARN of the Datadog integration role"
  value       = aws_iam_role.datadog_integration_role.arn
}

output "datadog_dashboard_url" {
  description = "URL of the Datadog dashboard"
  value       = "https://app.datadoghq.com/dashboard/${datadog_dashboard.aws_infrastructure.id}"
}