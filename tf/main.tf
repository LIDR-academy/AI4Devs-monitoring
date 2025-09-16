resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Permite SSH, Backend y Frontend"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-12345678" # AMI dummy para LocalStack
  instance_type          = var.instance_type
  security_groups        = [aws_security_group.ec2_sg.name]
  tags = {
    Name = "AI4Devs-monitoring-sim"
  }
}