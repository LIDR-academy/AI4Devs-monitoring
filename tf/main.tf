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

resource "aws_iam_role" "ec2_datadog_role" {
  name = "ec2_datadog_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "datadog_policy" {
  name = "datadog_policy"
  role = aws_iam_role.ec2_datadog_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "ec2:DescribeInstances",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Ajusta según LocalStack
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    DD_AGENT_MAJOR_VERSION=7
    DD_API_KEY=${var.datadog_api_key}
    DD_SITE="datadoghq.com"
    DD_LOGS_ENABLED=true
    DD_PROCESS_AGENT_ENABLED=true

    # Instalar el agente DataDog
    curl -sSL https://s3.amazonaws.com/dd-agent/scripts/install_script.sh | bash

    # Configurar logs de la aplicación (ejemplo para Node.js backend)
    echo "
    logs:
      - type: file
        path: /var/log/app.log
        service: backend
        source: nodejs
      - type: file
        path: /var/log/nginx/access.log
        service: frontend
        source: nginx
    " >> /etc/datadog-agent/conf.d/logs.yaml

    systemctl restart datadog-agent
  EOF

  # ...otros parámetros...
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_datadog_role.name
}