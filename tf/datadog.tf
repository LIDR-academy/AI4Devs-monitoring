# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}

# AWS Integration with Datadog
resource "datadog_integration_aws" "main" {
  account_id = data.aws_caller_identity.current.account_id
  role_name  = aws_iam_role.datadog_integration_role.name
}

