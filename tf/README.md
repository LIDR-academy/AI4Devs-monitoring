# 🐶 Implementación de Monitorización Datadog con Terraform en AWS

Este proyecto implementa una solución completa de monitorización usando Datadog integrado con AWS a través de Terraform, como parte del proyecto LTI (Learning Technology Integration).

## 📋 Resumen de Cambios Realizados

### 🏗️ Infraestructura Implementada

1. **Integración AWS-Datadog**
   - Configuración del proveedor Datadog en Terraform
   - Creación de rol IAM con permisos necesarios para Datadog
   - Establecimiento de integración bidireccional AWS ↔ Datadog

2. **Instancia EC2 Monitoreada**
   - Despliegue de instancia t3.micro con Amazon Linux 2
   - Instalación automática del agente Datadog via user-data script
   - Configuración de servidor web Apache para generar métricas
   - Aplicación de tags consistentes para filtrado y organización

3. **Dashboard de Monitorización**
   - Dashboard personalizado "LTI Monitoring" en Datadog
   - Visualización de métricas de EC2 (CPU, Memory, Disk)
   - Métricas de Apache (Requests, Response Time, Status)
   - Métricas de AWS CloudWatch integradas

4. **Configuración de Seguridad**
   - Grupo de seguridad configurado para HTTP (puerto 80) y SSH (puerto 22)
   - Políticas IAM con principio de menor privilegio
   - External ID para autenticación segura entre AWS y Datadog

### 📁 Estructura de Archivos

```
tf/
├── datadog/
│   ├── main.tf              # Configuración principal de recursos
│   ├── variables.tf         # Definición de variables
│   ├── terraform.tfvars     # Valores de variables (contiene credenciales)
│   ├── outputs.tf           # Outputs del proyecto
│   └── providers.tf         # Configuración de proveedores
├── Screenshots/             # Capturas de pantalla del resultado
└── README.md               # Esta documentación
```

### 🔧 Recursos de Terraform Creados

- `datadog_integration_aws_account.integration` - Integración principal AWS-Datadog
- `aws_iam_role.datadog_integration_role` - Rol IAM para Datadog
- `aws_iam_role_policy_attachment` - Políticas adjuntas al rol
- `aws_instance.datadog_monitored_server` - Instancia EC2 monitoreada
- `aws_security_group.datadog_monitored_sg` - Grupo de seguridad
- `datadog_dashboard.lti_monitoring` - Dashboard personalizado
- `time_sleep` resources - Recursos de espera para dependencias

## 📸 Capturas de Pantalla

### Dashboard Datadog
Visualización completa del dashboard LTI Monitoring con métricas en tiempo real:
- @001_Dashboard.png

### Mapa de Hosts
Vista del host map mostrando la infraestructura monitoreada:
- @002_HostMap.png

### Métricas AWS
Métricas de CloudWatch integradas mostrando datos de EC2:
- @003_Metrics.png

### CloudFormation AWS
Estado de los recursos creados en AWS CloudFormation:
- @004_AWS_CloudFormation.png

## 🚀 Comandos de Despliegue

```bash
# 1. Inicializar Terraform
terraform init

# 2. Configurar credenciales AWS (en PowerShell)
$env:AWS_ACCESS_KEY_ID="[VALOR_DESDE_TERRAFORM.TFVARS]"
$env:AWS_SECRET_ACCESS_KEY="[VALOR_DESDE_TERRAFORM.TFVARS]"
$env:AWS_DEFAULT_REGION="us-east-1"

# 3. Validar configuración
terraform validate

# 4. Planificar despliegue
terraform plan

# 5. Aplicar cambios
terraform apply
```

## 🔐 Configuración de Credenciales

Las credenciales sensibles se almacenan en `terraform.tfvars` (no incluido en el repositorio):

- **Datadog API Key**: Configurada como `datadog_api_key`
- **Datadog App Key**: Configurada como `datadog_app_key`
- **AWS Credentials**: Configuradas como variables de entorno
- **External ID**: Generado automáticamente para seguridad adicional

> ⚠️ **Importante**: El archivo `terraform.tfvars` contiene información sensible y debe mantenerse fuera del control de versiones.

## 📚 Documentación de Prompts

Todo el proceso de desarrollo asistido por IA está documentado en:
- @datadog-aws-prompts.md

Este archivo contiene los 15 prompts utilizados durante el desarrollo, desde la configuración inicial hasta la resolución de problemas específicos.

## 🚧 Desafíos Encontrados y Soluciones

### 1. **Complejidad Multi-Entorno**
**Problema**: Trabajar simultáneamente con múltiples plataformas (AWS Console, Datadog UI, Terraform CLI, PowerShell) requirió coordinación cuidadosa y sincronización de estados.

**Solución**: Implementación de checks de dependencias explícitos usando `depends_on` y recursos `time_sleep` para asegurar el orden correcto de creación.

### 2. **Problema Cíclico en Terraform Apply (Desafío Principal)**
**Problema**: El mayor desafío fue un problema cíclico durante el despliegue donde:
- La integración AWS-Datadog ya existía en Datadog
- Terraform intentaba crearla nuevamente
- Los comandos de import fallaban por incompatibilidades de sintaxis
- Los cambios de configuración generaban nuevos errores de validación

**Solución Implementada**:
1. **Método Destructivo**: Eliminación manual de la integración existente en Datadog UI
2. **Limpieza de Estado**: Remoción del recurso del estado de Terraform
3. **Simplificación de Configuración**: Reducción de parámetros complejos a configuración mínima funcional
4. **Validación Incremental**: Aplicación de cambios paso a paso con validación continua

### 3. **Sintaxis Deprecada del Provider**
**Problema**: Varios parámetros de configuración estaban usando sintaxis deprecada o incorrecta según la documentación más reciente.

**Solución**: Consulta de documentación actualizada y simplificación de la configuración del recurso `datadog_integration_aws_account`.

### 4. **Timing de Métricas**
**Problema**: Las métricas del agente Datadog tardaron más tiempo del esperado en aparecer.

**Solución**: Implementación de períodos de espera apropiados y explicación clara de que las métricas AWS CloudWatch aparecen antes que las métricas del agente local.

## ✅ Verificación del Resultado

### Estado Final Exitoso:
- ✅ Integración AWS-Datadog funcional
- ✅ Dashboard creado y accesible
- ✅ Métricas AWS CloudWatch llegando correctamente
- ✅ Host visible en Datadog Host Map
- ✅ Instancia EC2 ejecutándose con agente Datadog instalado
- ✅ Servidor web Apache respondiendo en puerto 80

### Métricas Confirmadas:
- `aws.ec2.cpuutilization` - Uso de CPU
- `aws.ec2.network_packets_in/out` - Tráfico de red
- `aws.ec2.status_check_failed` - Estado de health checks
