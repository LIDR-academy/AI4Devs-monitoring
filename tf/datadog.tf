# Datadog AWS Integration Configuration
resource "datadog_integration_aws_account" "main" {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_partition  = "aws"
  
  aws_regions {
  }
  
  auth_config {
    aws_auth_config_role {
      role_name = "datadog-integration-role"
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
  
  traces_config {
    xray_services {
    }
  }
  
  resources_config {
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# IAM Role for Datadog Integration
resource "aws_iam_role" "datadog_role" {
  name = "datadog-integration-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root"  # Datadog's AWS account ID
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "datadog-external-id"
          }
        }
      }
    ]
  })
}

# Custom policy for Datadog integration
resource "aws_iam_role_policy" "datadog_policy" {
  name = "datadog-integration-policy"
  role = aws_iam_role.datadog_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "logs:GetLogEvents",
          "logs:GetLogGroups",
          "logs:GetLogStreams",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeTags",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "s3:GetBucketLocation",
          "s3:GetBucketTagging",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}