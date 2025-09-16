variable "aws_region" {
  description = "Región de AWS simulada"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}

variable "allowed_ports" {
  description = "Puertos abiertos en el Security Group"
  type        = list(number)
  default     = [22, 8080, 3000]
}