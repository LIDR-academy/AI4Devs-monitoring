# ============================================================================
# EC2 IAM POLICIES
# ============================================================================

# S3 Access Policy (existing - for code deployment)
data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    sid       = "AllowS3GetObject"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.code_bucket.arn}/*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "${local.name_prefix}-s3-access-policy"
  description = "Allow EC2 instances to read deployment artifacts from S3"
  policy      = data.aws_iam_policy_document.s3_access_policy.json

  tags = {
    Name    = "${local.name_prefix}-s3-access-policy"
    Purpose = "code-deployment"
  }
}

# SSM Parameter Store Access Policy (NEW - for Datadog API key retrieval)
data "aws_iam_policy_document" "ssm_datadog_access_policy" {
  statement {
    sid    = "AllowSSMGetDatadogAPIKey"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.datadog_api_key_ssm_parameter}"
    ]
  }

  # Allow decryption of SecureString parameters
  statement {
    sid    = "AllowKMSDecryptForSSM"
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = ["*"]
    
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ssm.${var.aws_region}.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ssm_datadog_access_policy" {
  name        = "${local.name_prefix}-ssm-datadog-access"
  description = "Allow EC2 instances to retrieve Datadog API key from SSM Parameter Store"
  policy      = data.aws_iam_policy_document.ssm_datadog_access_policy.json

  tags = {
    Name    = "${local.name_prefix}-ssm-datadog-policy"
    Purpose = "datadog-agent-authentication"
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "lti-project-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Attach SSM Datadog access policy to EC2 role (NEW)
resource "aws_iam_role_policy_attachment" "attach_ssm_datadog_access_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_datadog_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "lti-project-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
