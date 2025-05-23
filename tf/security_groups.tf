resource "aws_security_group" "backend_sg" {
  name        = "lti-project-backend-sg"
  description = "Allow HTTP and SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Puertos adicionales para que el agente Datadog pueda comunicarse con el servicio Datadog
  ingress {
    from_port   = 8125
    to_port     = 8125
    protocol    = "udp"
    description = "Datadog StatsD port"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8126
    to_port     = 8126
    protocol    = "tcp"
    description = "Datadog APM port"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lti-project-backend-sg"
    Service = "backend"
    Environment = "production"
    Monitoring = "datadog"
  }
}

resource "aws_security_group" "frontend_sg" {
  name        = "lti-project-frontend-sg"
  description = "Allow HTTP and SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Puertos adicionales para que el agente Datadog pueda comunicarse con el servicio Datadog
  ingress {
    from_port   = 8125
    to_port     = 8125
    protocol    = "udp"
    description = "Datadog StatsD port"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8126
    to_port     = 8126
    protocol    = "tcp"
    description = "Datadog APM port"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lti-project-frontend-sg"
    Service = "frontend"
    Environment = "production"
    Monitoring = "datadog"
  }
}
