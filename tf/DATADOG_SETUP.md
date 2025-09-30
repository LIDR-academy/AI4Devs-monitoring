# Datadog Integration Setup

Este documento explica cómo configurar la integración de Datadog con AWS usando Terraform.

## Prerrequisitos

1. **Cuenta de Datadog**: Necesitas una cuenta activa en Datadog
2. **API Keys de Datadog**: 
   - API Key
   - Application Key
   - External ID para la integración con AWS

## Configuración de Datadog

### 1. Obtener las credenciales de Datadog

1. Ve a [Datadog](https://app.datadoghq.com/)
2. Navega a **Organization Settings** > **API Keys**
3. Crea una nueva API Key si no tienes una
4. Ve a **Organization Settings** > **Application Keys**
5. Crea una nueva Application Key si no tienes una

### 2. Configurar la integración AWS en Datadog

1. En Datadog, ve a **Integrations** > **AWS**
2. Haz clic en **Configuration** > **Manual**
3. Copia el **External ID** que se genera

### 3. Configurar las variables de Terraform

1. Copia el archivo de ejemplo:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edita `terraform.tfvars` con tus credenciales:
   ```hcl
   datadog_api_key     = "tu_api_key_aqui"
   datadog_app_key     = "tu_app_key_aqui"
   datadog_external_id = "tu_external_id_aqui"
   ```

## Despliegue

### 1. Inicializar Terraform
```bash
terraform init
```

### 2. Revisar el plan
```bash
terraform plan
```

### 3. Aplicar la configuración
```bash
terraform apply
```

## Recursos creados

### AWS Resources
- **IAM Role**: `datadog-integration-role` con permisos de solo lectura
- **IAM Policy Attachment**: Permisos ReadOnlyAccess para Datadog
- **EC2 Instances**: Con agentes de Datadog instalados y configurados

### Datadog Resources
- **AWS Integration**: Integración automática con AWS
- **Dashboard**: Dashboard de monitoreo con métricas clave
- **Monitors**: Alertas para CPU alto y fallos de instancia

## Dashboard de Monitoreo

El dashboard incluye:

1. **CPU Utilization**: Uso de CPU de las instancias EC2
2. **Network In/Out**: Tráfico de red de entrada y salida
3. **Disk Read/Write**: Operaciones de lectura/escritura de disco
4. **Total EC2 Instances**: Contador de instancias
5. **Application Logs**: Logs de las aplicaciones Docker

## Monitores y Alertas

### High CPU Usage Alert
- **Trigger**: CPU > 80% durante 5 minutos
- **Warning**: CPU > 70%
- **Critical**: CPU > 80%

### Instance Status Check Failed
- **Trigger**: Fallo en status check de instancia
- **Critical**: Cualquier fallo detectado

## Verificación

Después del despliegue:

1. Ve a tu dashboard de Datadog
2. Verifica que aparezcan las instancias EC2
3. Revisa las métricas en el dashboard "AI4Devs AWS Monitoring Dashboard"
4. Confirma que los monitores estén activos

## Troubleshooting

### El agente no se conecta
- Verifica que la API key sea correcta
- Revisa los logs del agente: `sudo journalctl -u datadog-agent`

### No aparecen métricas AWS
- Verifica que la integración AWS esté configurada correctamente
- Revisa que el External ID sea correcto
- Confirma que el IAM role tenga los permisos necesarios

### Dashboard vacío
- Espera unos minutos para que las métricas aparezcan
- Verifica que las instancias estén ejecutándose
- Revisa los tags de las instancias
