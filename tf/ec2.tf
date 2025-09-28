resource "aws_instance" "backend" {
  ami                    = "ami-074211ec8e88502be" # Amazon Linux 2 AMI para eu-north-1
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/backend_user_data.sh", { 
    timestamp = timestamp(),
    datadog_api_key = var.datadog_api_key,
    datadog_site = var.datadog_site,
    aws_region = var.aws_region
  })
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  
  tags = {
    Name        = "lti-project-backend"
    Environment = "production"
    Service     = "lti-backend"
    Project     = "lti-monitoring"
  }
}

resource "aws_instance" "frontend" {
  ami                    = "ami-074211ec8e88502be" # Amazon Linux 2 AMI para eu-north-1
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/frontend_user_data.sh", { 
    timestamp = timestamp(),
    datadog_api_key = var.datadog_api_key,
    datadog_site = var.datadog_site,
    aws_region = var.aws_region
  })
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  
  tags = {
    Name        = "lti-project-frontend"
    Environment = "production"
    Service     = "lti-frontend"
    Project     = "lti-monitoring"
  }
}
