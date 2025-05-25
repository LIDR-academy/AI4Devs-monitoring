# Datadog AWS Integration
# This creates the necessary IAM role and policies for Datadog to monitor your AWS resources

# External ID for Datadog (you'll get this from Datadog console)
variable "datadog_external_id" {
  description = "External ID provided by Datadog for AWS integration"
  type        = string
  default     = ""  # You'll need to update this with the actual external ID from Datadog
}

# IAM policy document for Datadog monitoring
data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::464622532012:root"] # Datadog's AWS account
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.datadog_external_id]
    }
  }
}

# IAM role for Datadog
resource "aws_iam_role" "datadog_integration_role" {
  name               = "${var.project_name}-datadog-integration-role"
  assume_role_policy = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
}

# Attach AWS managed policy for Datadog
resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
  role       = aws_iam_role.datadog_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/DatadogAWSIntegrationPolicy"
}

# Additional policy for enhanced monitoring (optional but recommended)
resource "aws_iam_role_policy_attachment" "datadog_aws_integration_enhanced" {
  role       = aws_iam_role.datadog_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# Output the role ARN for Datadog configuration
output "datadog_role_arn" {
  description = "ARN of the IAM role for Datadog integration"
  value       = aws_iam_role.datadog_integration_role.arn
} 