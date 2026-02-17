data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.code_bucket.arn}/*"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "ecr_access_policy" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name   = "${var.project_name}-s3-access-policy"
  policy = data.aws_iam_policy_document.s3_access_policy.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_policy" "ecr_access_policy" {
  name   = "${var.project_name}-ecr-access-policy"
  policy = data.aws_iam_policy_document.ecr_access_policy.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
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

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ecr_access_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Environment = var.environment
  }
}
