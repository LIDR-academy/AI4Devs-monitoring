output "instance_id" {
  description = "ID de la instancia EC2 simulada"
  value       = aws_instance.app_server.id
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = aws_security_group.ec2_sg.id
}