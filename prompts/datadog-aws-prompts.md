# Documentación de Prompts para Integración Datadog - AWS

### Prompt 1: Configuración de Providers y Variables
**Prompt:**
> "Actuando como un ingeniero Cloud/DevOps, necesito que prepares la configuración inicial de Terraform para integrar AWS y Datadog. En el archivo `variables.tf`, define las variables sensibles `datadog_api_key` y `datadog_app_key`. En el archivo `provider.tf`, define los bloques `required_providers` (con aws versión ~> 5.0 y datadog versión ~> 3.0) y configura el provider de datadog usando las variables definidas previamente para inyectar las credenciales correspondientes."

### Prompt 2: Creación del IAM Role y la Integración AWS-Datadog
**Prompt:**
> "Crea un archivo llamado `integration.tf`. Necesito que crees la integración core de AWS en la cuenta de Datadog usando el recurso `datadog_integration_aws`. A su vez, genera en AWS la política de confianza (Trust Policy) y un `aws_iam_role` llamado `DatadogAWSIntegrationRole` que permita la acción `sts:AssumeRole` a la cuenta principal de AWS de Datadog (`arn:aws:iam::464622532012:root`) condicionado al `ExternalId` generado dinámicamente. Adjunta a este rol la policy administrada de AWS `SecurityAudit` para permitir al agente recolectar el inventario."

### Prompt 3: Creación de un Dashboard de Datadog por Código
**Prompt:**
> "En un archivo `dashboard.tf`, crea un recurso `datadog_dashboard` titulado 'AWS Infrastructure Observability - EC2'. El layout debe ser de tipo 'ordered'. Necesito que contenga 3 widgets principales:
> 1. Una gráfica de serie de tiempo (Timeseries) de líneas mostrando el uso promedio de CPU (una sumatoria de origen `system.cpu.system` y `system.cpu.user`) agrupada por host y tipo de instancia.
> 2. Una gráfica de barras mostrando paralelamente el tráfico de red de bajada (`system.net.bytes_rcvd`) y subida (`system.net.bytes_sent`) por host.
> 3. Un check_status widget agrupado por host para verificar que el Agente EC2 (`datadog.agent.up`) reporta estar sano.
> Además, agrega una template_variable de `host` para permitir filtrado global en la UI."

### Prompt 4: Creación de Alertas/Monitores
**Prompt:**
> "En tu archivo principal de terraform (`main.tf`), agrega un monitor de Datadog (`datadog_monitor`) de tipo `metric alert` que detecte un uso anómalo de la CPU de AWS EC2. La query debe medir si el promedio de uso (`aws.ec2.cpuutilization`) en una ventana de 5 minutos sobrepasa el 80%.
> El mensaje de la alerta debe listar el nombre de host, tipo de instancia, su carga porcentual actual, y mencionar al handle `@team-devops`. Los umbrales deben ser Critical al 80% y Warning al 70%. Asígnale etiquetas (tags): `env:production`, `service:ec2`, `team:devops`."

### Prompt 5: Instalación del Agente de Host desde User-Data y APM
**Prompt:**
> "Necesito que actualices mis scripts de aprovisionamiento de instancia en `tf/scripts/backend_user_data.sh`. Al final del script quiero que incluyas el comando de bash de instalación oficial de linux del Datadog Agent (Agent 7). Debes insertarle la variable nativa `datadog_api_key`. También requiero que el contenedor backend de Docker quede instrumentado para Application Performance Monitoring (APM): Pásale al `docker run` la IP interna predeterminada del puente docker (`172.17.0.1`) como variable `DD_AGENT_HOST`, y habilita la recepción de tráfico no local (`DD_APM_NON_LOCAL_TRAFFIC=true` y `DD_APM_ENABLED=true`) al momento de inicializar el agente en EC2.
>
> Por último, en nuestro backend de express escrito en TypeScript (`backend/src/index.ts`), inyecta en la primera línea de código la inicialización de la librería `dd-trace` (`tracer.init();`) para conectar las solicitudes web de la app a Datadog."
