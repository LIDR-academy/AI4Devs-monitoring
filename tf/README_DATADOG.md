# Integración de Datadog con AI4Devs Monitoring

Este directorio contiene la configuración de Terraform para integrar Datadog con la aplicación AI4Devs, proporcionando monitoreo completo de infraestructura, aplicaciones y logs.

## 🚀 Características Implementadas

### 1. **Integración AWS-Datadog**
- ✅ Rol IAM con permisos completos para Datadog
- ✅ Integración automática con servicios AWS (EC2, S3, CloudWatch, etc.)
- ✅ Recopilación de métricas de infraestructura
- ✅ Monitoreo de logs de AWS

### 2. **Agente Datadog en EC2**
- ✅ Instalación automática del agente en instancias backend y frontend
- ✅ Configuración de Docker para monitoreo de contenedores
- ✅ Recopilación de logs de aplicaciones
- ✅ Métricas de sistema y aplicación

### 3. **Dashboards y Monitoreo**
- ✅ Dashboard principal de la aplicación
- ✅ Dashboard de infraestructura AWS
- ✅ Monitores de salud para backend y frontend
- ✅ Alertas de CPU, memoria y contenedores
- ✅ Monitoreo de logs de error

### 4. **APM y Trazabilidad**
- ✅ Configuración de APM para Node.js (backend)
- ✅ Configuración de APM para React (frontend)
- ✅ Definición de servicios con metadatos
- ✅ Pipelines de procesamiento de logs

### 5. **Synthetics y Health Checks**
- ✅ Tests sintéticos para endpoints de salud
- ✅ Monitoreo proactivo de disponibilidad
- ✅ Alertas automáticas en caso de fallos

## 📋 Prerrequisitos

1. **Cuenta de Datadog**
   - Crea una cuenta en [Datadog](https://www.datadoghq.com/)
   - Obtén tu API Key y App Key desde la configuración de la organización

2. **AWS CLI configurado**
   - Configura tus credenciales de AWS
   - Obtén tu AWS Account ID

3. **Terraform instalado**
   - Versión 1.0 o superior

## 🛠️ Configuración

### 1. Configurar Variables

```bash
# Copia el archivo de ejemplo
cp terraform.tfvars.example terraform.tfvars

# Edita las variables con tus valores reales
nano terraform.tfvars
```

### 2. Configurar Datadog

```bash
# Obtén tu API Key desde Datadog
# https://app.datadoghq.com/organization-settings/application-keys

# Obtén tu App Key desde Datadog
# https://app.datadoghq.com/organization-settings/application-keys

# Obtén tu AWS Account ID
aws sts get-caller-identity --query Account --output text
```

### 3. Aplicar la Configuración

```bash
# Inicializar Terraform
terraform init

# Planificar los cambios
terraform plan

# Aplicar la configuración
terraform apply
```

## 📊 Dashboards Disponibles

### Dashboard Principal
- **URL**: `https://app.datadoghq.com/dashboard/lists`
- **Contenido**:
  - Estado de salud de backend y frontend
  - Métricas de CPU de EC2
  - Métricas de contenedores Docker
  - Tiempo de respuesta de aplicaciones
  - Logs de aplicación en tiempo real

### Dashboard de Infraestructura AWS
- **URL**: `https://app.datadoghq.com/dashboard/lists`
- **Contenido**:
  - Estado de instancias EC2
  - Tráfico de red
  - Uso de disco
  - Métricas de AWS CloudWatch

## 🚨 Monitores y Alertas

### Monitores Configurados
1. **Backend Health Check** - Verifica que el backend responda
2. **Frontend Health Check** - Verifica que el frontend responda
3. **High CPU Usage** - Alerta cuando CPU > 80%
4. **High Memory Usage** - Alerta cuando memoria < 20%
5. **Docker Container Status** - Verifica que los contenedores estén ejecutándose
6. **Application Error Logs** - Detecta errores en los logs

### Canales de Notificación
- **Slack**: `#ai4devs-alerts`
- **Email**: `alerts@ai4devs.com`
- **Webhooks**: Configurables para integraciones adicionales

## 🔧 Configuración Avanzada

### Personalizar Alertas

```hcl
# Ejemplo: Modificar umbrales de CPU
resource "datadog_monitor" "high_cpu" {
  # ... configuración existente ...
  monitor_thresholds {
    warning  = 60  # Cambiar de 70 a 60
    critical = 75  # Cambiar de 80 a 75
  }
}
```

### Agregar Nuevos Servicios

```hcl
# Ejemplo: Agregar monitoreo para una base de datos
resource "datadog_service_definition" "database_service" {
  service_name = "lti-database"
  schema_version = "v2.1"
  
  dd_service = "lti-database"
  team = "ai4devs-team"
  tags = ["env:production", "service:database", "language:postgresql"]
}
```

## 📈 Métricas Personalizadas

### Métricas de Aplicación
- `ai4devs.application.requests` - Número de requests procesados
- `ai4devs.application.response_time` - Tiempo de respuesta
- `ai4devs.application.errors` - Número de errores

### Métricas de Infraestructura
- `aws.ec2.cpuutilization` - Uso de CPU
- `aws.ec2.network_in/out` - Tráfico de red
- `docker.containers.running` - Contenedores ejecutándose

## 🔍 Troubleshooting

### Problemas Comunes

1. **Agente no se conecta**
   ```bash
   # Verificar estado del agente
   sudo systemctl status datadog-agent
   
   # Verificar logs
   sudo tail -f /var/log/datadog/agent.log
   ```

2. **Métricas no aparecen**
   - Verificar que las variables de entorno estén configuradas
   - Comprobar que el rol IAM tenga los permisos correctos
   - Revisar la configuración de la integración AWS

3. **Alertas no funcionan**
   - Verificar la configuración de canales de notificación
   - Comprobar que los monitores estén activos
   - Revisar los umbrales de alerta

### Comandos Útiles

```bash
# Verificar estado de la integración AWS
terraform show | grep datadog_integration_aws_account

# Verificar monitores activos
terraform show | grep datadog_monitor

# Verificar dashboards
terraform show | grep datadog_dashboard
```

## 📚 Recursos Adicionales

- [Documentación de Datadog](https://docs.datadoghq.com/)
- [Terraform Provider para Datadog](https://registry.terraform.io/providers/DataDog/datadog/latest/docs)
- [Guía de Integración AWS-Datadog](https://docs.datadoghq.com/es/integrations/guide/aws-terraform-setup/)
- [Mejores Prácticas de Monitoreo](https://docs.datadoghq.com/monitors/)

## 🤝 Soporte

Para soporte técnico o preguntas sobre la implementación:
- **Slack**: `#ai4devs-devops`
- **Email**: `devops@ai4devs.com`
- **Documentación**: [Wiki del Proyecto](https://github.com/ai4devs/monitoring/wiki)
