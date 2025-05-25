output "backend_public_ip" {
  description = "Public IP address of the backend instance"
  value       = aws_instance.backend.public_ip
}

output "frontend_public_ip" {
  description = "Public IP address of the frontend instance"
  value       = aws_instance.frontend.public_ip
}

output "backend_url" {
  description = "URL to access the backend application"
  value       = "http://${aws_instance.backend.public_ip}:${var.backend_port}"
}

output "frontend_url" {
  description = "URL to access the frontend application"
  value       = "http://${aws_instance.frontend.public_ip}:${var.frontend_port}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket containing the code"
  value       = aws_s3_bucket.code_bucket.bucket
}

output "ssh_commands" {
  description = "SSH commands to connect to the instances (make sure SSH key is loaded in your ssh agent)"
  value = {
    backend  = "ssh ec2-user@${aws_instance.backend.public_ip}"
    frontend = "ssh ec2-user@${aws_instance.frontend.public_ip}"
  }
}
