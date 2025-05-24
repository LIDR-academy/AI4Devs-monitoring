# Obtener información de la cuenta AWS actual
data "aws_caller_identity" "current" {}

# Política de confianza que permite a Datadog asumir el rol
data "aws_iam_policy_document" "datadog_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::464622532012:root"]
    }
    
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }
  }
}

# Rol IAM que Datadog usará para acceder a AWS
resource "aws_iam_role" "datadog_integration_role" {
  name               = "${var.project_name}-datadog-role"
  assume_role_policy = data.aws_iam_policy_document.datadog_assume_role.json
  
  tags = {
    Name        = "DatadogIntegrationRole"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Adjuntar política de solo lectura a Datadog
resource "aws_iam_role_policy_attachment" "datadog_readonly_policy" {
  role       = aws_iam_role.datadog_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Política adicional para CloudWatch Logs
resource "aws_iam_role_policy_attachment" "datadog_cloudwatch_policy" {
  role       = aws_iam_role.datadog_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}

# Esperar a que el rol IAM esté listo
resource "time_sleep" "wait_for_iam_role" {
  depends_on = [
    aws_iam_role.datadog_integration_role,
    aws_iam_role_policy_attachment.datadog_readonly_policy,
    aws_iam_role_policy_attachment.datadog_cloudwatch_policy
  ]
  create_duration = "10s"
}

# Esperar a que la integración esté lista
resource "time_sleep" "wait_for_integration" {
  depends_on = [datadog_integration_aws_account.integration]
  create_duration = "30s"
}

# ===============================================
# CONFIGURACIÓN EC2 CON AGENTE DATADOG
# ===============================================

# Obtener la AMI más reciente de Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "state"
    values = ["available"]
  }
}

# Script de inicialización para instalar el agente Datadog
locals {
  userdata_script = <<-EOF
    #!/bin/bash
    
    # Log de inicialización
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    echo "Iniciando configuración de instancia con Datadog..."
    
    # Actualizar sistema
    yum update -y
    
    # Instalar dependencias básicas
    yum install -y curl wget htop
    
    # Instalar agente Datadog
    echo "Instalando agente Datadog..."
    DD_AGENT_MAJOR_VERSION=7 \
    DD_API_KEY=${var.datadog_api_key} \
    DD_SITE="us5.datadoghq.com" \
    bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
    
    # Configurar hostname personalizado
    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    echo "hostname: $INSTANCE_ID" >> /etc/datadog-agent/datadog.yaml
    
    # Configurar tags personalizados
    echo "tags:" >> /etc/datadog-agent/datadog.yaml
    echo "  - env:${var.environment}" >> /etc/datadog-agent/datadog.yaml
    echo "  - project:${var.project_name}" >> /etc/datadog-agent/datadog.yaml
    echo "  - service:web-server" >> /etc/datadog-agent/datadog.yaml
    echo "  - region:${var.aws_region}" >> /etc/datadog-agent/datadog.yaml
    
    # Habilitar logs de sistema
    echo "logs_enabled: true" >> /etc/datadog-agent/datadog.yaml
    
    # Reiniciar y habilitar agente Datadog
    systemctl restart datadog-agent
    systemctl enable datadog-agent
    
    # Verificar estado del agente
    sleep 10
    systemctl status datadog-agent
    
    # Instalar servidor web Apache para generar métricas
    echo "Instalando servidor web..."
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    
    # Crear página web de prueba
    cat > /var/www/html/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>LTI Monitoring Server</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .status { background: #e8f5e8; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 LTI Monitoring Server</h1>
        <div class="status">
            <h3>✅ Servidor activo y monitoreado por Datadog</h3>
        </div>
        <p>Este servidor está siendo monitoreado por Datadog US5.</p>
    </div>
</body>
</html>
HTML
    
    echo "✅ Configuración completada exitosamente"
  EOF
}

# Grupo de seguridad para la instancia EC2
resource "aws_security_group" "datadog_monitored_sg" {
  name_prefix = "${var.project_name}-monitored-"
  description = "Security group for Datadog monitored instance"
  
  # Permitir HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Permitir SSH (opcional, para troubleshooting)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Permitir todo el tráfico saliente
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.project_name}-monitored-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Instancia EC2 con agente Datadog
resource "aws_instance" "datadog_monitored_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  
  vpc_security_group_ids = [aws_security_group.datadog_monitored_sg.id]
  user_data              = base64encode(local.userdata_script)
  
  # Esperar a que la integración Datadog esté lista
  depends_on = [time_sleep.wait_for_integration]
  
  tags = {
    Name        = "${var.project_name}-monitored-server"
    Environment = var.environment
    Project     = var.project_name
    MonitoredBy = "Datadog"
  }
}

# Nota: Si necesitas acceso SSH, descomenta y configura tu clave pública:# resource "aws_key_pair" "datadog_key" {#   key_name   = "${var.project_name}-key"#   public_key = "ssh-rsa TU_CLAVE_PUBLICA_AQUI"#   tags = {#     Name = "${var.project_name}-ssh-key"#   }# } 

# Integración AWS en Datadog
resource "datadog_integration_aws_account" "integration" {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_partition  = "aws"

  # Configuración de regiones
  aws_regions {
    include_all = true
  }

  # Configuración de autenticación
  auth_config {
    aws_auth_config_role {
      role_name   = aws_iam_role.datadog_integration_role.name
      external_id = var.external_id
    }
  }

  # Configuración de recursos (simplificada)
  resources_config {
    cloud_security_posture_management_collection = true
    extended_collection                          = true
  }

  # Configuración de trazas
  traces_config {
    xray_services {}
  }

  # Configuración de logs
  logs_config {
    lambda_forwarder {}
  }

  # Configuración de métricas (simplificada)
  metrics_config {
    namespace_filters {}
  }

  depends_on = [time_sleep.wait_for_iam_role]
} 