resource "aws_instance" "backend" {
  ami                    = "ami-074211ec8e88502be"
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data              = templatefile("scripts/backend_user_data.sh", { timestamp = timestamp() })
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  associate_public_ip_address = true   # 👈 aseguramos IP pública
  tags = {
    Name = "lti-project-backend"
  }
}

resource "aws_instance" "frontend" {
  ami                    = "ami-074211ec8e88502be"
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = templatefile("scripts/frontend_user_data.sh", {
    timestamp   = timestamp()
    ARTIFACT_S3 = "s3://ai4devs-project-code-bucket-adriansendin-20250928/frontend.zip"
  })
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  associate_public_ip_address = true   # 👈 aseguramos IP pública
  tags = {
    Name = "lti-project-frontend"
  }
}
