resource "aws_security_group" "backend_sg" {
  name        = "lti-project-backend-sg"
  description = "Allow HTTP, SSH access and Datadog monitoring"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Backend API access"
  }

  # Esta regla permite la comunicación con Datadog
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic including Datadog (443/TCP for API, 123/UDP for NTP)"
  }

  tags = {
    Name = "lti-project-backend-sg"
    Service = "backend"
    Monitoring = "datadog"
  }
}

resource "aws_security_group" "frontend_sg" {
  name        = "lti-project-frontend-sg"
  description = "Allow HTTP, SSH access and Datadog monitoring"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Frontend application access"
  }

  # Esta regla permite la comunicación con Datadog
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic including Datadog (443/TCP for API, 123/UDP for NTP)"
  }

  tags = {
    Name = "lti-project-frontend-sg"
    Service = "frontend"
    Monitoring = "datadog"
  }
}
