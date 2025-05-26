resource "aws_instance" "backend" {
  ami                    = "ami-075d39ebbca89ed55" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = templatefile("scripts/backend_user_data.sh", {
    timestamp                         = timestamp()
    datadog_secret_arn               = var.datadog_secret_arn
    datadog_site                     = var.datadog_site
    environment                      = var.environment
    enable_datadog_monitoring        = var.enable_datadog_monitoring
    datadog_agent_version           = var.datadog_agent_version
    datadog_metrics_collection_interval = var.datadog_metrics_collection_interval
    datadog_enable_log_collection    = var.datadog_enable_log_collection
    datadog_tags                     = var.datadog_tags
    account_id                       = data.aws_caller_identity.current.account_id
    aws_region                       = data.aws_region.current.name
  })
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  
  tags = merge(
    {
      Name = "lti-project-backend"
      Service = "backend"
    },
    var.datadog_tags
  )
}

resource "aws_instance" "frontend" {
  ami                    = "ami-075d39ebbca89ed55" # Amazon Linux 2 AMI
  instance_type          = "t2.medium"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = templatefile("scripts/frontend_user_data.sh", {
    timestamp                         = timestamp()
    datadog_secret_arn               = var.datadog_secret_arn
    datadog_site                     = var.datadog_site
    environment                      = var.environment
    enable_datadog_monitoring        = var.enable_datadog_monitoring
    datadog_agent_version           = var.datadog_agent_version
    datadog_metrics_collection_interval = var.datadog_metrics_collection_interval
    datadog_enable_log_collection    = var.datadog_enable_log_collection
    datadog_tags                     = var.datadog_tags
    account_id                       = data.aws_caller_identity.current.account_id
    aws_region                       = data.aws_region.current.name
  })
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  
  tags = merge(
    {
      Name = "lti-project-frontend"
      Service = "frontend"
    },
    var.datadog_tags
  )
}
