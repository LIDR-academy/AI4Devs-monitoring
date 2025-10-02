# ============================================================================
# EC2 INSTANCES WITH DATADOG AGENT
# ============================================================================
# This file defines EC2 instances with integrated Datadog monitoring.
# The Datadog agent is installed via user_data during instance launch.
# ============================================================================

# ------------------------------------------------------------------------------
# Datadog Agent Module - Backend Instance
# ------------------------------------------------------------------------------

module "datadog_agent_backend" {
  source = "./modules/datadog-agent"

  hostname                  = "${local.name_prefix}-backend"
  aws_region                = var.aws_region
  datadog_site              = var.datadog_site
  datadog_api_key_parameter = var.datadog_api_key_ssm_parameter
  environment               = var.environment
  service_name              = "${var.project_name}-backend"
  
  additional_tags = [
    "team:${var.team_name}",
    "instance_type:backend",
    "port:8080"
  ]

  enable_logs               = var.enable_datadog_logs
  enable_process_monitoring = true
}

# ------------------------------------------------------------------------------
# Datadog Agent Module - Frontend Instance
# ------------------------------------------------------------------------------

module "datadog_agent_frontend" {
  source = "./modules/datadog-agent"

  hostname                  = "${local.name_prefix}-frontend"
  aws_region                = var.aws_region
  datadog_site              = var.datadog_site
  datadog_api_key_parameter = var.datadog_api_key_ssm_parameter
  environment               = var.environment
  service_name              = "${var.project_name}-frontend"
  
  additional_tags = [
    "team:${var.team_name}",
    "instance_type:frontend",
    "port:3000"
  ]

  enable_logs               = var.enable_datadog_logs
  enable_process_monitoring = true
}

# ------------------------------------------------------------------------------
# Combined User Data Scripts
# ------------------------------------------------------------------------------

locals {
  # Backend user data - combines application deployment + Datadog agent
  backend_user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    
    # Update system
    yum update -y
    sudo yum install -y docker unzip
    
    # Start Docker service
    sudo service docker start
    
    # Download and deploy application
    aws s3 cp s3://ai4devs-project-code-bucket/backend.zip /home/ec2-user/backend.zip
    unzip /home/ec2-user/backend.zip -d /home/ec2-user/
    
    # Build and run Docker container
    cd /home/ec2-user/backend
    sudo docker build -t lti-backend .
    sudo docker run -d -p 8080:8080 --name lti-backend lti-backend
    
    # Install Datadog agent (retrieved from module)
    ${module.datadog_agent_backend.user_data}
    
    # Timestamp for tracking deployments
    echo "Deployment completed at: $(date)" | tee -a /var/log/deployment.log
  EOF

  # Frontend user data - combines application deployment + Datadog agent  
  frontend_user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    
    # Update system
    yum update -y
    sudo yum install -y docker unzip
    
    # Start Docker service
    sudo service docker start
    
    # Download and deploy application
    aws s3 cp s3://ai4devs-project-code-bucket/frontend.zip /home/ec2-user/frontend.zip
    unzip /home/ec2-user/frontend.zip -d /home/ec2-user/
    
    # Build and run Docker container
    cd /home/ec2-user/frontend
    sudo docker build -t lti-frontend .
    sudo docker run -d -p 3000:3000 --name lti-frontend lti-frontend
    
    # Install Datadog agent (retrieved from module)
    ${module.datadog_agent_frontend.user_data}
    
    # Timestamp for tracking deployments
    echo "Deployment completed at: $(date)" | tee -a /var/log/deployment.log
  EOF
}

# ------------------------------------------------------------------------------
# EC2 Instances (Updated to use Datadog-enabled user_data)
# ------------------------------------------------------------------------------

resource "aws_instance" "backend_with_datadog" {
  count = var.enable_datadog_agent ? 1 : 0

  ami                    = var.ami_id
  instance_type          = var.backend_instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  
  user_data = local.backend_user_data

  # Use the module's user_data_base64 if you need base64 encoding
  # user_data_base64 = module.datadog_agent_backend.user_data_base64

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.name_prefix}-backend"
      Service = "backend"
      Port    = "8080"
      Monitor = "datadog"
    }
  )

  # Prevent accidental destruction
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "frontend_with_datadog" {
  count = var.enable_datadog_agent ? 1 : 0

  ami                    = var.ami_id
  instance_type          = var.frontend_instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  
  user_data = local.frontend_user_data

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.name_prefix}-frontend"
      Service = "frontend"
      Port    = "3000"
      Monitor = "datadog"
    }
  )

  # Prevent accidental destruction
  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# Outputs for New Instances
# ------------------------------------------------------------------------------

output "backend_with_datadog_ip" {
  description = "Public IP of backend instance with Datadog agent"
  value       = var.enable_datadog_agent ? try(aws_instance.backend_with_datadog[0].public_ip, "Not created") : "Datadog agent disabled"
}

output "frontend_with_datadog_ip" {
  description = "Public IP of frontend instance with Datadog agent"
  value       = var.enable_datadog_agent ? try(aws_instance.frontend_with_datadog[0].public_ip, "Not created") : "Datadog agent disabled"
}

output "datadog_agent_info" {
  description = "Information about Datadog agents deployed"
  value = var.enable_datadog_agent ? {
    backend_hostname  = module.datadog_agent_backend.hostname
    backend_tags      = module.datadog_agent_backend.datadog_tags
    frontend_hostname = module.datadog_agent_frontend.hostname
    frontend_tags     = module.datadog_agent_frontend.datadog_tags
    datadog_site      = var.datadog_site
    datadog_url       = "https://app.${var.datadog_site}/infrastructure"
  } : "Datadog agent disabled"
}

