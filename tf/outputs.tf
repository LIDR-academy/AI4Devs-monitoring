# Outputs for LTI Infrastructure
output "backend_instance_id" {
  description = "ID of the backend EC2 instance"
  value       = aws_instance.backend.id
}

output "frontend_instance_id" {
  description = "ID of the frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "backend_public_ip" {
  description = "Public IP of the backend instance"
  value       = aws_instance.backend.public_ip
}

output "frontend_public_ip" {
  description = "Public IP of the frontend instance"
  value       = aws_instance.frontend.public_ip
}

output "backend_url" {
  description = "Backend application URL"
  value       = "http://${aws_instance.backend.public_ip}:8080"
}

output "frontend_url" {
  description = "Frontend application URL"
  value       = "http://${aws_instance.frontend.public_ip}:3000"
}