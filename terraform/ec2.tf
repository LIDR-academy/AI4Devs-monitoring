# Security Group para la instancia EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-datadog-sg"
  description = "Security group for EC2 instance with Datadog agent"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-datadog-sg"
  }
}

# Instancia EC2
resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c7217cdde317cfec"  # Amazon Linux 2023 AMI en us-east-1
  instance_type = "t2.micro"
  
  security_groups = [aws_security_group.ec2_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              # Instalar el agente de Datadog
              DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${var.datadog_api_key} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
              EOF

  tags = {
    Name = "ec2-datadog-instance"
  }
} 