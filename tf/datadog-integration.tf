# ============================================================================
# DATADOG AWS INTEGRATION
# ============================================================================
# Creates IAM role and policies for Datadog to read AWS metrics and resources.
# Uses external ID for secure trust relationship.
#
# Security Notes:
# - Read-only access to AWS metrics (no write permissions)
# - External ID prevents confused deputy problem
# - Trust relationship limited to Datadog AWS account only
# ============================================================================

# Generate External ID for Datadog integration (or use provided one)
resource "random_uuid" "datadog_external_id" {
  keepers = {
    project = var.project_name
  }
}

locals {
  datadog_external_id = coalesce(var.datadog_external_id, random_uuid.datadog_external_id.result)
  datadog_aws_account_id = "464622532012" # Official Datadog AWS account
}

# ------------------------------------------------------------------------------
# IAM Role for Datadog AWS Integration
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "datadog_assume_role" {
  statement {
    sid    = "DatadogAWSIntegrationAssumeRole"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.datadog_aws_account_id}:root"]
    }

    actions = ["sts:AssumeRole"]

    # External ID prevents confused deputy attacks
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [local.datadog_external_id]
    }
  }
}

resource "aws_iam_role" "datadog_integration_role" {
  name               = "${local.name_prefix}-datadog-integration"
  description        = "Role for Datadog AWS integration - read-only access to metrics and resources"
  assume_role_policy = data.aws_iam_policy_document.datadog_assume_role.json

  tags = {
    Name    = "${local.name_prefix}-datadog-integration-role"
    Purpose = "datadog-aws-integration"
  }
}

# ------------------------------------------------------------------------------
# IAM Policy: Core Datadog Permissions (Read-Only)
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "datadog_core_permissions" {
  # CloudWatch Metrics - Read Only
  statement {
    sid    = "DatadogCloudWatchReadOnly"
    effect = "Allow"
    actions = [
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "cloudwatch:Describe*"
    ]
    resources = ["*"]
  }

  # EC2 - Read Only (for instance metadata and tags)
  statement {
    sid    = "DatadogEC2ReadOnly"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "ec2:Get*"
    ]
    resources = ["*"]
  }

  # Auto Scaling - Read Only
  statement {
    sid    = "DatadogAutoScalingReadOnly"
    effect = "Allow"
    actions = [
      "autoscaling:Describe*"
    ]
    resources = ["*"]
  }

  # Elastic Load Balancing - Read Only
  statement {
    sid    = "DatadogELBReadOnly"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:Describe*"
    ]
    resources = ["*"]
  }

  # S3 - Read Only (for bucket metrics)
  statement {
    sid    = "DatadogS3ReadOnly"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:ListBucket"
    ]
    resources = ["*"]
  }

  # RDS - Read Only
  statement {
    sid    = "DatadogRDSReadOnly"
    effect = "Allow"
    actions = [
      "rds:Describe*",
      "rds:List*"
    ]
    resources = ["*"]
  }

  # Lambda - Read Only
  statement {
    sid    = "DatadogLambdaReadOnly"
    effect = "Allow"
    actions = [
      "lambda:Get*",
      "lambda:List*"
    ]
    resources = ["*"]
  }

  # DynamoDB - Read Only
  statement {
    sid    = "DatadogDynamoDBReadOnly"
    effect = "Allow"
    actions = [
      "dynamodb:List*",
      "dynamodb:Describe*"
    ]
    resources = ["*"]
  }

  # SNS/SQS - Read Only
  statement {
    sid    = "DatadogSNSSQSReadOnly"
    effect = "Allow"
    actions = [
      "sns:List*",
      "sns:Get*",
      "sqs:List*",
      "sqs:Get*"
    ]
    resources = ["*"]
  }

  # ECS/EKS - Read Only
  statement {
    sid    = "DatadogContainerReadOnly"
    effect = "Allow"
    actions = [
      "ecs:Describe*",
      "ecs:List*",
      "eks:Describe*",
      "eks:List*"
    ]
    resources = ["*"]
  }

  # CloudTrail - Read Only
  statement {
    sid    = "DatadogCloudTrailReadOnly"
    effect = "Allow"
    actions = [
      "cloudtrail:LookupEvents"
    ]
    resources = ["*"]
  }

  # Tag Editor - Read Only (for resource tagging)
  statement {
    sid    = "DatadogTagReadOnly"
    effect = "Allow"
    actions = [
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "datadog_core_permissions" {
  name        = "${local.name_prefix}-datadog-core-permissions"
  description = "Core read-only permissions for Datadog AWS integration"
  policy      = data.aws_iam_policy_document.datadog_core_permissions.json

  tags = {
    Name    = "${local.name_prefix}-datadog-core-policy"
    Purpose = "datadog-monitoring"
  }
}

# Attach core policy to Datadog role
resource "aws_iam_role_policy_attachment" "datadog_core_permissions" {
  role       = aws_iam_role.datadog_integration_role.name
  policy_arn = aws_iam_policy.datadog_core_permissions.arn
}

# ------------------------------------------------------------------------------
# Optional: CloudWatch Logs (if enabled)
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "datadog_logs_permissions" {
  count = var.enable_datadog_logs ? 1 : 0

  statement {
    sid    = "DatadogLogsReadOnly"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "datadog_logs_permissions" {
  count = var.enable_datadog_logs ? 1 : 0

  name        = "${local.name_prefix}-datadog-logs-permissions"
  description = "Permissions for Datadog to read CloudWatch Logs"
  policy      = data.aws_iam_policy_document.datadog_logs_permissions[0].json

  tags = {
    Name    = "${local.name_prefix}-datadog-logs-policy"
    Purpose = "datadog-log-collection"
  }
}

resource "aws_iam_role_policy_attachment" "datadog_logs_permissions" {
  count = var.enable_datadog_logs ? 1 : 0

  role       = aws_iam_role.datadog_integration_role.name
  policy_arn = aws_iam_policy.datadog_logs_permissions[0].arn
}

# ------------------------------------------------------------------------------
# Optional: Cloud Security Posture Management (CSPM)
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "datadog_security_audit" {
  count = var.enable_datadog_cspm ? 1 : 0

  role       = aws_iam_role.datadog_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# ------------------------------------------------------------------------------
# Datadog AWS Integration Resource
# ------------------------------------------------------------------------------

resource "datadog_integration_aws" "main" {
  account_id = data.aws_caller_identity.current.account_id
  role_name  = aws_iam_role.datadog_integration_role.name

  # External ID for secure integration
  external_id = local.datadog_external_id

  # Filter by tags (optional - can limit which resources Datadog monitors)
  # account_specific_namespace_rules = {
  #   auto_scaling = false
  #   opsworks     = false
  # }

  # Optional: Exclude specific namespaces to reduce costs
  excluded_regions = [
    # Uncomment regions you don't use to reduce API calls
    # "ap-south-1",
    # "ap-northeast-1",
    # "sa-east-1",
  ]

  # Host tags (applied to all AWS resources)
  host_tags = local.datadog_tags_list

  depends_on = [
    aws_iam_role_policy_attachment.datadog_core_permissions
  ]
}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "datadog_integration_instructions" {
  description = "Instructions for verifying Datadog integration"
  value = <<-EOT
    
    ╔══════════════════════════════════════════════════════════════════════╗
    ║              DATADOG AWS INTEGRATION CONFIGURED                       ║
    ╚══════════════════════════════════════════════════════════════════════╝
    
    ✅ IAM Role Created: ${aws_iam_role.datadog_integration_role.arn}
    ✅ External ID: ${local.datadog_external_id}
    ✅ AWS Account: ${data.aws_caller_identity.current.account_id}
    
    📋 VERIFICATION STEPS:
    
    1. Log into Datadog: https://app.${var.datadog_site}
    
    2. Navigate to: Integrations → AWS
       Direct: https://app.${var.datadog_site}/integrations/amazon-web-services
    
    3. You should see your AWS account listed with:
       - Account ID: ${data.aws_caller_identity.current.account_id}
       - Status: ✓ Active
    
    4. Check AWS Metrics Explorer:
       https://app.${var.datadog_site}/metric/explorer
       Search for: aws.ec2.cpuutilization
    
    5. Wait 5-10 minutes for initial metrics to appear
    
    🔐 SECURITY VALIDATION:
    
    - IAM Role uses external ID: ✓
    - Read-only permissions: ✓
    - No write access: ✓
    - Scoped to Datadog AWS account: ✓
    
  EOT
}

