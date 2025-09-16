resource "aws_instance" "ai4devs_monitoring" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_key_pair.key_name
  security_groups = [aws_security_group.ai4devs_monitoring_sg.name]
  tags          = var.tags

  user_data = file("${path.module}/scripts/bootstrap.sh")
}