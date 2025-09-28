# 🐶 Datadog-AWS Integration with Terraform

Esta carpeta contiene la configuración de Terraform para implementar una integración completa entre AWS y Datadog para el proyecto LTI.

## 📋 Requisitos Previos

1. **Cuenta AWS** configurada con credenciales
2. **Terraform** v1.0+ instalado
3. **Cuenta Datadog** con API Key y App Key
4. **Permisos AWS** para crear recursos IAM, EC2, etc.

## 🚀 Configuración Rápida

### 1. Clonar y Configurar

```bash
# Navegar al directorio de Terraform
cd tf/

# Copiar archivo de variables de ejemplo
cp terraform.tfvars.example terraform.tfvars
```

### 2. Configurar Variables

Editar `terraform.tfvars` con tus credenciales:

```hcl
# Credenciales AWS (configurar via AWS CLI o variables de entorno)
aws_region = "us-east-1"

# Credenciales Datadog
datadog_api_key = "tu_api_key_datadog"
datadog_app_key = "tu_app_key_datadog"
datadog_site    = "datadoghq.com"  # o "datadoghq.eu" para EU

# Configuración del proyecto
datadog_external_id = "lti-datadog-external-id-123"
```

### 3. Desplegar Infraestructura

```bash
# Inicializar Terraform
terraform init

# Verificar plan de ejecución
terraform plan

# Aplicar configuración
terraform apply
```

## 📊 Recursos Creados

### AWS Resources:

- **IAM Role**: `DatadogIntegrationRole` con permisos para monitorización
- **EC2 Instances**: Backend y Frontend con agente Datadog instalado
- **Security Groups**: Configuración de red segura
- **S3 Bucket**: Para código de aplicación

### Datadog Resources:

- **AWS Integration**: Conexión automática AWS ↔ Datadog
- **Dashboard**: "LTI AWS Infrastructure Monitoring" con 10+ widgets
- **Monitors**: 4 alertas críticas (CPU, Memory, Disk, Health)
- **SLO**: Objetivo de nivel de servicio para uptime

## 📈 Monitorización Incluida

### Métricas AWS:

- ✅ EC2: CPU, Memory, Network, Disk I/O
- ✅ CloudWatch: Métricas nativas
- ✅ Application Traces: APM para Node.js y React
- ✅ Logs: Recolección automática desde contenedores
- ✅ Docker: Estados y métricas de contenedores

### Alertas Configuradas:

- 🚨 **CPU Alto**: >80% crítico, >70% warning
- ⚠️ **Memoria Alta**: <15% disponible crítico, <20% warning
- 💾 **Disco Lleno**: <20% espacio crítico, <30% warning
- 🔥 **Health Check**: Fallos de conectividad de aplicación

### Dashboard Widgets:

1. CPU Utilization por host
2. Memory Usage por host
3. Network In/Out traffic
4. Disk I/O operations
5. Total EC2 instances count
6. Top instances por CPU
7. Application Response Time
8. Error Rate percentage
9. Request Latency Distribution
10. Docker Container Status

## 🔐 Seguridad

### Mejores Prácticas Implementadas:

- **External ID** para autenticación segura
- **Least Privilege**: Permisos mínimos necesarios
- **Encrypted Variables**: Credenciales marcadas como sensitive
- **Resource Tagging**: Tags consistentes para compliance
- **Validation**: Validación automática de configuración

### Variables Sensibles:

```hcl
variable "datadog_api_key" {
  sensitive = true  # ✅ Protegida en logs y state
}

variable "datadog_app_key" {
  sensitive = true  # ✅ Protegida en logs y state
}
```

## 🎯 Configuración Avanzada

### Habilitar Logs Forwarder (Opcional):

1. **Desplegar Datadog Forwarder Lambda** usando CloudFormation
2. **Añadir ARN** en terraform.tfvars:

```hcl
datadog_forwarder_lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:datadog-forwarder"
```

### Multi-Region Setup:

```hcl
# Configurar múltiples regiones
aws_region = "us-west-2"
# El código automáticamente ajusta las configuraciones
```

### Entornos Diferentes:

```hcl
# Cambiar tags de entorno
# En variables.tf, modifica los default tags
```

## 🔧 Comandos Útiles

```bash
# Ver estado actual
terraform show

# Ver outputs
terraform output

# Destruir infraestructura (¡CUIDADO!)
terraform destroy

# Formatear código
terraform fmt

# Validar configuración
terraform validate

# Importar recursos existentes
terraform import datadog_dashboard.aws_infrastructure xyz-123-abc
```

## 📱 Acceso Post-Despliegue

### URLs Importantes:

- **Datadog Dashboard**: `https://app.datadoghq.com/dashboard/{dashboard_id}`
- **Backend App**: `http://{backend_ip}:8080`
- **Frontend App**: `http://{frontend_ip}:3000`
- **AWS Console**: Revisar recursos creados

### Verificación:

1. ✅ **AWS Integration** activa en Datadog
2. ✅ **Hosts** aparecen en Infrastructure List
3. ✅ **Métricas** fluyendo en dashboard
4. ✅ **Logs** aparecen en Log Explorer
5. ✅ **APM traces** en APM service map

## 🛠️ Troubleshooting

### Problemas Comunes:

**Error: Invalid API Key**

```bash
# Verificar credenciales
export DD_API_KEY="tu_api_key"
datadog validate
```

**Error: Permission Denied AWS**

```bash
# Verificar permisos AWS
aws sts get-caller-identity
aws iam list-attached-user-policies --user-name tu-usuario
```

**Métricas no aparecen**

- Verificar tags en EC2 instances
- Confirmar que el agente está corriendo: `sudo systemctl status datadog-agent`
- Revisar logs del agente: `sudo tail -f /var/log/datadog/agent.log`

### Logs Útiles:

```bash
# En instancias EC2
sudo datadog-agent status
sudo datadog-agent configcheck
sudo journalctl -u datadog-agent -f
```

## 📚 Referencias

- [Datadog Terraform Provider](https://registry.terraform.io/providers/DataDog/datadog/latest/docs)
- [AWS Integration Setup Guide](https://docs.datadoghq.com/es/integrations/guide/aws-terraform-setup/)
- [Managing Datadog with Terraform](http://datadoghq.com/blog/managing-datadog-with-terraform/)

---

_Configuración creada con ❤️ para el proyecto LTI_  
_Última actualización: Septiembre 2025_
