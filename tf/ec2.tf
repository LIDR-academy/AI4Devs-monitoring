# EC2 Instance for Backend
resource "aws_instance" "backend" {
  ami                    = "ami-0c7217cdde317cfec" # Amazon Linux 2 AMI en us-east-1
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/backend_user_data.sh", { timestamp = timestamp() })
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name               = aws_key_pair.lti_project_key.key_name

  tags = {
    Name = "lti-project-backend"
  }
}

# EC2 Instance for Frontend
resource "aws_instance" "frontend" {
  ami                    = "ami-0c7217cdde317cfec" # Amazon Linux 2 AMI en us-east-1
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/frontend_user_data.sh", { timestamp = timestamp() })
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name               = aws_key_pair.lti_project_key.key_name

  tags = {
    Name = "lti-project-frontend"
  }
}

resource "aws_key_pair" "lti_project_key" {
  key_name   = "lti-project-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5rrxF3pj/fiIfQGUJupwgLs9m3tf/GCb7HalgSwDQ5mG8N+r7ZtS8ZvoY9mm3TQIe1gqxk9WkruhA5T7vND2+X1nYZMl2g4hh7nP3UrCrR9WIkLyzrlWoKl0c6L/KSaC7D4AIHdQg9pR/o9fo8X6vnx6zgHzhFspZ1/Ip0npuTS2vOyGRX43ifCxRAFhZnI0XpkIoIgwoJqc5IFQufkTeiDV9AwtcMRBtyloIhkueUXPad0f7ReGJBapZOBCQTSFlh37fpeqLaMhhkdDXIMhWXbaSSMMtM33g+gD5ww4Y3/wlT65ix2V90XWbzKJ2r8M3dfps1i8PF+dNusbHI0TZ xavierfernandez@Xaviers-MacBook-Pro.loca"
}
