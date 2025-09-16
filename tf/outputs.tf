output "ec2_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.ai4devs_monitoring.public_ip
}

output "ssh_key_pair_name" {
  description = "Nombre del key pair SSH"
  value       = aws_key_pair.ec2_key_pair.key_name
}

output "ssh_private_key_path" {
  description = "Ruta local del archivo PEM para SSH"
  value       = local_file.private_key_pem.filename
}

output "secrets_manager_db_secret_arn" {
  description = "ARN del secreto de la base de datos en AWS Secrets Manager"
  value       = aws_secretsmanager_secret.db_secret.arn
}