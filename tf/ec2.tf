resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name               = var.key_name != "" ? var.key_name : null

  user_data = templatefile("${path.module}/scripts/backend_user_data.sh", {
    timestamp       = timestamp()
    s3_bucket       = var.s3_bucket_name
    datadog_api_key = var.datadog_api_key
    datadog_site    = var.datadog_site
    environment     = var.environment
    db_user         = var.db_user
    db_password     = var.db_password
    db_name         = var.db_name
    app_version     = var.app_version
  })

  tags = {
    Name        = "${var.project_name}-backend"
    Service     = "backend"
    Environment = var.environment
    Monitoring  = "datadog"
    Version     = var.app_version
  }
}

resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name               = var.key_name != "" ? var.key_name : null

  user_data = templatefile("${path.module}/scripts/frontend_user_data.sh", {
    timestamp         = timestamp()
    s3_bucket         = var.s3_bucket_name
    datadog_api_key   = var.datadog_api_key
    datadog_site      = var.datadog_site
    environment       = var.environment
    backend_private_ip = aws_instance.backend.private_ip
    app_version       = var.app_version
  })

  tags = {
    Name        = "${var.project_name}-frontend"
    Service     = "frontend"
    Environment = var.environment
    Monitoring  = "datadog"
    Version     = var.app_version
  }

  depends_on = [aws_instance.backend]
}

# ==========================================
# ECR Repositories
# ==========================================
resource "aws_ecr_repository" "backend" {
  name                 = "${var.ecr_repository_prefix}/backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-backend-ecr"
    Service     = "backend"
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${var.ecr_repository_prefix}/frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-frontend-ecr"
    Service     = "frontend"
    Environment = var.environment
  }
}

# ==========================================
# Outputs
# ==========================================
output "backend_public_ip" {
  description = "Public IP of the backend EC2 instance"
  value       = aws_instance.backend.public_ip
}

output "frontend_public_ip" {
  description = "Public IP of the frontend EC2 instance"
  value       = aws_instance.frontend.public_ip
}

output "backend_ecr_url" {
  description = "Backend ECR repository URL"
  value       = aws_ecr_repository.backend.repository_url
}

output "frontend_ecr_url" {
  description = "Frontend ECR repository URL"
  value       = aws_ecr_repository.frontend.repository_url
}
