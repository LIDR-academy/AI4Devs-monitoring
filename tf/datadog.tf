# Documento de política para el rol IAM que asumirá Datadog
data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.datadog_aws_account_id}:root"]
    }
    
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.datadog_external_id]
    }
  }
}

# Documento de política con los permisos que necesita Datadog para monitorizar AWS
data "aws_iam_policy_document" "datadog_aws_integration_policy" {
  # Permisos de lectura básicos para CloudWatch
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "cloudwatch:Describe*",
      "ec2:Describe*",
      "support:*",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues"
    ]
    resources = ["*"]
  }

  # Permisos para CloudWatch Logs
  statement {
    effect = "Allow"
    actions = [
      "logs:Get*",
      "logs:List*",
      "logs:StartQuery",
      "logs:StopQuery",
      "logs:Describe*",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }

  # Permisos para S3 (solo necesarios si quieres monitorizar S3)
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLogging",
      "s3:GetBucketLocation",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:PutBucketNotification"
    ]
    resources = ["*"]
  }

  # Permisos para monitorizar instancias EC2
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeReservedInstances",
      "ec2:DescribeSpotFleetRequests",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSpotPriceHistory"
    ]
    resources = ["*"]
  }
}

# Recurso de política IAM para Datadog
resource "aws_iam_policy" "datadog_aws_integration" {
  name        = "${var.datadog_aws_resources_prefix}-integration-policy"
  description = "Política para la integración de Datadog con AWS"
  policy      = data.aws_iam_policy_document.datadog_aws_integration_policy.json
}

# Recurso de rol IAM para Datadog
resource "aws_iam_role" "datadog_aws_integration" {
  name               = var.datadog_integration_role_name
  description        = "Rol para la integración de Datadog con AWS"
  assume_role_policy = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
  tags = {
    Name        = var.datadog_integration_role_name
    Environment = "all"
    Service     = "datadog"
  }
}

# Adjuntamos la política al rol
resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
  role       = aws_iam_role.datadog_aws_integration.name
  policy_arn = aws_iam_policy.datadog_aws_integration.arn
}

# También adjuntamos la política SecurityAudit que proporciona acceso de solo lectura 
# a recursos adicionales (recomendado por Datadog)
resource "aws_iam_role_policy_attachment" "datadog_aws_integration_security_audit" {
  role       = aws_iam_role.datadog_aws_integration.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
} 