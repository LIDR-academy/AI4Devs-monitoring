output "backend_public_ip" {
  description = "Public IP address of the backend instance"
  value       = aws_instance.backend.public_ip
}

output "frontend_public_ip" {
  description = "Public IP address of the frontend instance"
  value       = aws_instance.frontend.public_ip
}

output "backend_public_dns" {
  description = "Public DNS name of the backend instance"
  value       = aws_instance.backend.public_dns
}

output "frontend_public_dns" {
  description = "Public DNS name of the frontend instance"
  value       = aws_instance.frontend.public_dns
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for code storage"
  value       = aws_s3_bucket.code_bucket.bucket
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}
