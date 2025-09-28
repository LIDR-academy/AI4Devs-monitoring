# Terraform Outputs for AI4Devs Datadog-AWS Integration

output "backend_instance_id" {
  description = "ID of the backend EC2 instance"
  value       = aws_instance.backend.id
}

output "backend_public_ip" {
  description = "Public IP address of the backend instance"
  value       = aws_instance.backend.public_ip
}

output "backend_public_dns" {
  description = "Public DNS name of the backend instance"
  value       = aws_instance.backend.public_dns
}

output "frontend_instance_id" {
  description = "ID of the frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "frontend_public_ip" {
  description = "Public IP address of the frontend instance"
  value       = aws_instance.frontend.public_ip
}

output "frontend_public_dns" {
  description = "Public DNS name of the frontend instance"
  value       = aws_instance.frontend.public_dns
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for code storage"
  value       = aws_s3_bucket.code_bucket.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.code_bucket.arn
}

output "backend_security_group_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend_sg.id
}

output "frontend_security_group_id" {
  description = "ID of the frontend security group"
  value       = aws_security_group.frontend_sg.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role for EC2 instances"
  value       = aws_iam_role.ec2_role.arn
}

output "application_urls" {
  description = "URLs for accessing the applications"
  value = {
    frontend = "http://${aws_instance.frontend.public_ip}:3000"
    backend  = "http://${aws_instance.backend.public_ip}:8080"
  }
}

output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    region           = "us-east-1"
    backend_instance = aws_instance.backend.id
    frontend_instance = aws_instance.frontend.id
    s3_bucket       = aws_s3_bucket.code_bucket.bucket
    deployment_time = timestamp()
  }
}
