data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.code_bucket.arn}/*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name   = "s3-access-policy"
  policy = data.aws_iam_policy_document.s3_access_policy.json
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

# Adjunta política gestionada de AWS para SSM
resource "aws_iam_role_policy_attachment" "attach_ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "lti-project-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Rol IAM que Datadog usará para integrarse con AWS
resource "aws_iam_role" "datadog_integration" {
  name = "datadog-integration-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          # Cuenta oficial de Datadog EU
          AWS = "arn:aws:iam::464622532012:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "datadog_integration" {
  name = "datadog-integration-policy"
  role = aws_iam_role.datadog_integration.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "cloudwatch:*",
          "ec2:Describe*",
          "elasticloadbalancing:Describe*",
          "rds:Describe*",
          "lambda:List*",
          "lambda:Get*",
          "tag:GetResources",
          "tag:GetTagKeys",
          "tag:GetTagValues"
        ],
        Resource = "*"
      }
    ]
  })
}
