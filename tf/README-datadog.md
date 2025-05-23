# Integración de Datadog con AWS mediante Terraform

Este documento explica cómo configurar la integración de Datadog con AWS utilizando Terraform. La configuración crea automáticamente los recursos necesarios en AWS para permitir que Datadog recopile métricas y logs de tus recursos de AWS.

## Recursos creados

La configuración crea los siguientes recursos en AWS:

1. **Política IAM** (`datadog-integration-policy`): Otorga permisos de sólo lectura a Datadog para acceder a las métricas y logs de tus recursos de AWS.
2. **Rol IAM** (`DatadogAWSIntegrationRole`): Un rol que Datadog puede asumir para acceder a tus recursos de AWS.
3. **Attachments de política**: Adjunta la política creada y la política AWS managed `SecurityAudit` al rol para proporcionar los permisos necesarios.
4. **Integración con Datadog**: Configura automáticamente la integración en la plataforma de Datadog.
5. **Agente Datadog en EC2**: Instala y configura el agente de Datadog en las instancias EC2.
6. **Dashboard personalizado**: Crea un dashboard con métricas relevantes de tu infraestructura.
7. **Monitores y alertas**: Configura monitores para detectar problemas automáticamente.
8. **SLOs (Objetivos de Nivel de Servicio)**: Define SLOs para medir la disponibilidad y rendimiento.

## Prerrequisitos

- Tener acceso a una cuenta de AWS con permisos para crear recursos IAM.
- Tener una cuenta en Datadog.
- Terraform instalado en tu sistema.
- API Key y App Key de Datadog.

## Proceso de configuración

### Paso 1: Configurar las credenciales de Datadog

Crea un archivo `terraform.tfvars` con las credenciales de Datadog y otros valores necesarios:

```hcl
datadog_api_key = "tu_api_key_de_datadog"
datadog_app_key = "tu_app_key_de_datadog"
# Opcional: utiliza una API key diferente para los agentes (por defecto usa la misma que datadog_api_key)
datadog_agent_api_key = "tu_api_key_para_agentes"
```

Para obtener estas claves:
1. Inicia sesión en tu cuenta de Datadog.
2. Ve a **Integrations** > **APIs**.
3. En la sección "API Keys", copia tu API Key o crea una nueva.
4. En la sección "Application Keys", copia una Application Key existente o crea una nueva.

### Paso 2: Aplicar la configuración de Terraform

Ejecuta los siguientes comandos:

```bash
terraform init  # Para inicializar los proveedores de AWS y Datadog
terraform plan  # Para revisar los cambios que se realizarán
terraform apply # Para aplicar los cambios
```

Al aplicar la configuración, Terraform:
1. Creará el rol IAM y la política necesaria en AWS.
2. Configurará automáticamente la integración en Datadog.
3. Instalará y configurará el agente Datadog en las instancias EC2.
4. Creará el dashboard, monitores y SLOs en Datadog.

## Monitorización con el Agente Datadog

El agente Datadog se instala automáticamente en las instancias EC2 (frontend y backend) y proporciona:

### Características habilitadas:

1. **Recopilación de métricas del sistema**:
   - CPU, memoria, disco, red
   - Procesos en ejecución

2. **Integración con Docker**:
   - Monitorización de contenedores
   - Recopilación de logs de contenedores

3. **APM (Monitorización del rendimiento de aplicaciones)**:
   - Trazas de transacciones
   - Análisis de rendimiento

4. **Recopilación de logs**:
   - Logs del sistema
   - Logs de aplicaciones

### Etiquetas configuradas:

Cada instancia tiene etiquetas específicas para facilitar la filtración y organización:

- **Backend**: `service:backend`, `environment:production`, `managed-by:terraform`
- **Frontend**: `service:frontend`, `environment:production`, `managed-by:terraform`

### Puertos abiertos:

Los grupos de seguridad se han configurado para permitir:

- Puerto 8125 (UDP): Utilizado por StatsD para enviar métricas personalizadas
- Puerto 8126 (TCP): Utilizado por APM para enviar trazas de rendimiento

## Dashboard, Monitores y SLOs

### Dashboard personalizado

Se ha creado un dashboard completo que muestra las métricas más relevantes de tu infraestructura:

1. **Sección de EC2**:
   - Utilización de CPU por instancia
   - Uso de memoria por instancia
   - Tráfico de red entrante y saliente

2. **Sección de Backend**:
   - Tiempo de respuesta de las solicitudes
   - Tasa de errores en porcentaje
   - Solicitudes por minuto

3. **Sección de Frontend**:
   - Tiempo de carga de página
   - Número de usuarios activos
   - Errores JavaScript

4. **Sección de Contenedores Docker**:
   - Uso de CPU por contenedor
   - Uso de memoria por contenedor

5. **Sección de S3**:
   - Operaciones en el bucket (GET/PUT)
   - Tamaño total del bucket

6. **Sección de disponibilidad**:
   - SLO de disponibilidad del backend
   - Gráficos de alertas activas
   - Mapa de hosts

### Monitores configurados

1. **Monitor de disponibilidad del backend**:
   - Verifica que el servicio backend esté accesible
   - Envía alertas si el servicio no responde

2. **Monitor de uso de CPU**:
   - Detecta cuando la utilización de CPU supera el 80% durante 15 minutos
   - Envía una alerta cuando se alcanza el umbral

### SLO (Objetivo de Nivel de Servicio)

Se ha definido un SLO para medir la disponibilidad del backend:
   - Objetivo de disponibilidad: 99.9%
   - Nivel de advertencia: 99.95% - 99.99% (según el período)
   - Períodos de evaluación: 7 días, 30 días y 90 días

## Personalización

### Servicios de AWS a monitorizar

Puedes personalizar los servicios de AWS que deseas monitorizar modificando el campo `account_specific_namespace_rules` en el archivo `datadog_integration.tf`. Por defecto, se monitorean los siguientes servicios:

- EC2
- S3
- CloudWatch
- Lambda
- CloudTrail
- RDS
- ELB (Classic Load Balancer)
- ALB (Application Load Balancer)
- SQS
- Route53
- VPC
- API Gateway
- ECS

### Configuración del agente Datadog

Para personalizar la configuración del agente, modifica los scripts de usuario:

- `scripts/backend_user_data.sh` para la instancia backend
- `scripts/frontend_user_data.sh` para la instancia frontend

### Personalización del dashboard

Para modificar el dashboard, edita el archivo `datadog_dashboard.tf` y añade o modifica widgets según tus necesidades.

### Personalización de monitores y SLOs

Para ajustar los monitores o SLOs, modifica las secciones correspondientes en el archivo `datadog_dashboard.tf`:
- Modifica los umbrales en `datadog_monitor` para ajustar la sensibilidad de las alertas
- Ajusta los objetivos de disponibilidad en `datadog_service_level_objective`

## Solución de problemas

- **Error de autenticación**: Verifica que las API Key y App Key de Datadog sean correctas.
- **Error "AccessDenied"**: Asegúrate de que el rol IAM tenga los permisos correctos.
- **No se ven métricas en Datadog**: La recopilación de métricas puede tardar hasta 10 minutos en comenzar a aparecer en Datadog.
- **Problemas con el agente**: Puedes verificar el estado del agente en las instancias con:
  ```bash
  sudo datadog-agent status
  ```
- **Logs del agente**: Verifica los logs para diagnosticar problemas:
  ```bash
  sudo less /var/log/datadog/agent.log
  ```
- **Dashboard no muestra datos**: Verifica que las métricas estén disponibles en Datadog y que los nombres de las métricas en las consultas sean correctos.
- **Permisos insuficientes**: Si estás utilizando servicios de AWS específicos que no se ven en Datadog, puede que necesites añadir permisos adicionales a la política IAM.

## Actualización de la integración

Si necesitas actualizar la integración en el futuro, simplemente modifica los archivos de Terraform según sea necesario y vuelve a ejecutar `terraform apply`.

## Referencias

- [Documentación oficial de Datadog para la integración con AWS](https://docs.datadoghq.com/es/integrations/amazon_web_services/)
- [Configuración de AWS con Terraform para Datadog](https://docs.datadoghq.com/es/integrations/guide/aws-terraform-setup/)
- [Proveedor de Terraform para Datadog](https://registry.terraform.io/providers/datadog/datadog/latest/docs)
- [Documentación del agente Datadog](https://docs.datadoghq.com/es/agent/)
- [Documentación de Dashboards en Datadog](https://docs.datadoghq.com/es/dashboards/)
- [Documentación de Monitores en Datadog](https://docs.datadoghq.com/es/monitors/) 