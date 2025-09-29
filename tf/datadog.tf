# Datadog AWS Integration
# Configuración del rol IAM para la integración de Datadog con AWS

# Política de asunción de rol para Datadog
data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::412381753143:root"] # Datadog's AWS account
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        "datadog-external-id-${var.aws_account_id}" # Usar un external_id fijo
      ]
    }
  }
}

# Política IAM para permisos de Datadog en AWS
data "aws_iam_policy_document" "datadog_aws_integration" {
  statement {
    actions = [
      "apigateway:GET",
      "autoscaling:Describe*",
      "budgets:ViewBudget",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codedeploy:List*",
      "codedeploy:BatchGet*",
      "directconnect:Describe*",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "ec2:Describe*",
      "ec2:Get*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:Describe*",
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
      "logs:TestMetricFilter",
      "logs:PutSubscriptionFilter",
      "logs:DeleteSubscriptionFilter",
      "logs:DescribeSubscriptionFilters",
      "rds:Describe*",
      "rds:List*",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "route53:List*",
      "route53:Get*",
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
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "support:*",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries"
    ]
    resources = ["*"]
  }
}

# Política IAM para Datadog
resource "aws_iam_policy" "datadog_aws_integration" {
  name        = "DatadogAWSIntegrationPolicy"
  description = "Política para la integración de Datadog con AWS"
  policy      = data.aws_iam_policy_document.datadog_aws_integration.json
}

# Rol IAM para Datadog
resource "aws_iam_role" "datadog_aws_integration" {
  name                 = "DatadogIntegrationRole"
  description          = "Rol para la integración de Datadog con AWS"
  assume_role_policy   = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
  max_session_duration = 3600
}

# Adjuntar política personalizada al rol
resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
  role       = aws_iam_role.datadog_aws_integration.name
  policy_arn = aws_iam_policy.datadog_aws_integration.arn
}

# Adjuntar política de SecurityAudit (requerida por Datadog)
resource "aws_iam_role_policy_attachment" "datadog_aws_integration_security_audit" {
  role       = aws_iam_role.datadog_aws_integration.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# Integración de Datadog con AWS
resource "datadog_integration_aws_account" "datadog_integration" {
  account_tags = ["env:production", "project:ai4devs-monitoring"]
  aws_account_id = var.aws_account_id
  aws_partition  = "aws"
  
  aws_regions {
    include_all = true
  }
  
  auth_config {
    aws_auth_config_role {
      role_name = aws_iam_role.datadog_aws_integration.name
      external_id = "datadog-external-id-${var.aws_account_id}"
    }
  }
  
  resources_config {
    cloud_security_posture_management_collection = true
    extended_collection = true
  }
  
  traces_config {
    xray_services {
    }
  }
  
  logs_config {
    lambda_forwarder {
    }
  }
  
  metrics_config {
    namespace_filters {
    }
  }
}

# Nota: Los agentes de Datadog se instalan automáticamente
# en las instancias EC2 mediante los scripts de user_data
