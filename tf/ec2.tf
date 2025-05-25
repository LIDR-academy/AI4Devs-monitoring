resource "aws_instance" "backend" {
  ami                    = "ami-00f34bf9aeacdf007" # Amazon Linux 2 AMI
  instance_type          = "t3.micro"
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/backend_user_data.sh", { timestamp = timestamp() })
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  tags = {
    Name = "${var.project_name}-backend"
    Environment = var.environment
  }
}

resource "aws_instance" "frontend" {
  ami                    = "ami-00f34bf9aeacdf007" # Amazon Linux 2 AMI
  instance_type          = "t3.micro"
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/frontend_user_data.sh", { timestamp = timestamp() })
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  tags = {
    Name = "${var.project_name}-frontend"
    Environment = var.environment
  }
}
