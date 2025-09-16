variable "aws_region" {
  description = "Región de AWS"
  default     = "us-west-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI de Amazon Linux 2"
  default     = "ami-0d9e15a8edf01ec21" // AMI Amazon Linux 2 para us-west-1, actualizada a septiembre 2025
}

variable "key_pair_name" {
  description = "Nombre del key pair SSH"
  default     = "ai4devs-monitoring-key"
}

variable "db_secret_name" {
  description = "Nombre del secreto en AWS Secrets Manager para la base de datos"
  default     = "ai4devs-monitoring-db-secret-v4"
}

variable "tags" {
  description = "Tags para los recursos"
  type        = map(string)
  default     = {
    Project = "AI4Devs-monitoring-JAPM"
  }
}