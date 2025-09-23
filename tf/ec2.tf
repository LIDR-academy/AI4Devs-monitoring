resource "aws_instance" "backend" {
  ami                    = "ami-075d39ebbca89ed55" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/backend_user_data.sh", { 
    timestamp = timestamp(),
    datadog_api_key = var.datadog_api_key,
    datadog_site = var.datadog_site
  })
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  subnet_id              = aws_subnet.public.id
  
  tags = {
    Name = "lti-project-backend"
    Environment = var.environment
    Project = var.project_name
    Component = "backend"
    ManagedBy = "terraform"
    DatadogMonitoring = "enabled"
    FreeTierOptimized = var.free_tier_optimized ? "true" : "false"
  }
}

resource "aws_instance" "frontend" {
  ami                    = "ami-075d39ebbca89ed55" # Amazon Linux 2 AMI
  instance_type          = "t2.medium"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/frontend_user_data.sh", { 
    timestamp = timestamp(),
    datadog_api_key = var.datadog_api_key,
    datadog_site = var.datadog_site
  })
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  subnet_id              = aws_subnet.public.id
  
  tags = {
    Name = "lti-project-frontend"
    Environment = var.environment
    Project = var.project_name
    Component = "frontend"
    ManagedBy = "terraform"
    DatadogMonitoring = "enabled"
    FreeTierOptimized = var.free_tier_optimized ? "true" : "false"
  }
}
