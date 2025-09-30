resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  key_name              = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.frontend.id]
  user_data             = file("${path.module}/scripts/frontend_user_data.sh")

  tags = {
    Name        = "${var.environment}-frontend"
    Environment = var.environment
  }
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[1].id
  key_name              = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.backend.id]
  user_data             = file("${path.module}/scripts/backend_user_data.sh")

  tags = {
    Name        = "${var.environment}-backend"
    Environment = var.environment
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
