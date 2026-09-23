# Infraestructura Terraform y monitoreo Datadog

Este directorio contiene la Infraestructura como Código (Terraform) para desplegar el proyecto en AWS y el canal de monitoreo con Datadog.

## Cambios realizados (integración Datadog)

- **provider.tf:** Añadido provider Datadog y bloque `terraform { required_providers }` con AWS (~> 5.0) y Datadog (~> 3.50). La región AWS se toma de `var.aws_region`.
- **variables.tf:** Nuevo. Variables para `aws_region`, `aws_account_id`, `environment`, `datadog_api_key`, `datadog_app_key`, `datadog_site`, `datadog_integration_role_name` y `datadog_aws_principal_account_id`.
- **outputs.tf:** Nuevo. Outputs para `datadog_integration_external_id`, `datadog_dashboard_url`, `datadog_dashboard_id` y `datadog_monitor_id`.
- **datadog_integration.tf:** Integración AWS–Datadog (`datadog_integration_aws_account`) y data source `datadog_integration_aws_iam_permissions`.
- **datadog_iam.tf:** IAM role, trust policy (con external_id de la integración) y políticas fragmentadas para que Datadog asuma el role y lea métricas de AWS.
- **ec2.tf:** Modificado el `templatefile()` de ambas instancias para pasar `dd_api_key`, `dd_site` y `environment` a los scripts de user_data.
- **scripts/backend_user_data.sh y frontend_user_data.sh:** Añadido bloque final que instala el agente Datadog (script oficial), configura API Key y tags, e inicia el servicio.
- **dashboard.tf:** Dashboard en Datadog "AWS EC2 - LTI Project" con widgets de CPU, red, memoria y estado.
- **monitor.tf:** Monitor de alerta cuando CPU EC2 > 80% durante 5 minutos.

## Requisitos

- Terraform >= 1.0
- Cuentas activas en AWS y Datadog

## Credenciales necesarias

| Origen  | Variable de entorno     | Uso                              |
| ------- | ----------------------- | --------------------------------- |
| AWS     | `AWS_ACCESS_KEY_ID`     | Provider AWS (Terraform)          |
| AWS     | `AWS_SECRET_ACCESS_KEY` | Provider AWS (Terraform)          |
| Datadog | `DATADOG_API_KEY`       | Provider Datadog y agente en EC2  |
| Datadog | `DATADOG_APP_KEY`       | Provider Datadog (API completa)  |

### Cómo obtener las credenciales

**AWS (IAM):**

1. IAM → Users → tu usuario → Security credentials.
2. Access keys → Create access key → elegir "Command Line Interface (CLI)" o "Application running outside AWS".
3. Guardar **Access Key ID** y **Secret Access Key** (el secret solo se muestra una vez).

**Datadog:**

1. Organization Settings → Application Keys: crear una key (ej. "Terraform") y copiar el valor (Application Key).
2. Organization Settings → API Keys: usar la existente o crear una y copiar el valor (API Key).

### Exportar como variables de entorno

**PowerShell:**

```powershell
$env:AWS_ACCESS_KEY_ID="..."
$env:AWS_SECRET_ACCESS_KEY="..."
$env:DATADOG_API_KEY="..."
$env:DATADOG_APP_KEY="..."
```

**Bash:**

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export DATADOG_API_KEY=...
export DATADOG_APP_KEY=...
```

Para no exponer secretos en la línea de comandos, usa un archivo `terraform.tfvars` (no commitearlo; está en `.gitignore`) o un backend remoto. Ver `terraform.tfvars.example`.

## Pasos para ejecutar

1. Entrar al directorio de Terraform:
   ```bash
   cd tf
   ```

2. Inicializar y descargar providers:
   ```bash
   terraform init
   ```

3. Crear `terraform.tfvars` a partir de `terraform.tfvars.example` y rellenar `aws_account_id`. Para API Key y App Key puedes usar variables de entorno o pasarlas con `-var` (no recomendado en consola compartida).

4. Revisar el plan:
   ```bash
   terraform plan -var-file=terraform.tfvars
   ```
   Si usas variables de entorno para Datadog, el provider las puede leer si están definidas en el provider (en este proyecto se usan variables Terraform; pásalas con `-var` o en `terraform.tfvars`).

5. Aplicar:
   ```bash
   terraform apply -var-file=terraform.tfvars
   ```

Ejemplo pasando solo las variables sensibles por entorno y el resto en tfvars:

```bash
# En PowerShell, definir env vars para Datadog, luego:
terraform plan -var-file=terraform.tfvars -var="datadog_api_key=$env:DATADOG_API_KEY" -var="datadog_app_key=$env:DATADOG_APP_KEY"
terraform apply -var-file=terraform.tfvars -var="datadog_api_key=$env:DATADOG_API_KEY" -var="datadog_app_key=$env:DATADOG_APP_KEY"
```

## Dónde ver el dashboard y la alerta

- **Dashboard:** En Datadog: **Dashboards** → buscar "AWS EC2 - LTI Project". También puedes usar el output `datadog_dashboard_url` tras `terraform apply` (ej. `terraform output datadog_dashboard_url`).
- **Monitor (alerta):** En Datadog: **Monitors** → buscar "[AWS EC2] CPU alta - LTI Project". Puedes configurar notificaciones (email, Slack, etc.) en el monitor.

Recomendación: hacer capturas del dashboard y del monitor una vez aplicado y con datos llegando (tras unos minutos con la integración AWS y el agente en EC2).

## Problemas frecuentes y soluciones

- **Error de external_id / trust policy:** Si cambias la integración o el role, asegúrate de que el `external_id` en la trust policy coincida con el que muestra Datadog para esa integración. Tras un `terraform apply` el external_id lo genera la integración; si recreas el role en AWS sin recrear la integración, puede haber desincronización. Solución: aplicar todo con Terraform de forma consistente o revisar en la consola de Datadog (Integrations → AWS) el external_id y el nombre del role.

- **El agente no reporta en Datadog:** Comprobar que la API Key es correcta y que la instancia tiene salida a internet (HTTPS). Revisar en la instancia: `sudo systemctl status datadog-agent` y logs en `/var/log/datadog/`.

- **Límite de tamaño de policy IAM (6144 bytes):** El código ya divide los permisos en varias policies (chunking). Si añades más permisos en el data source y falla, revisar que el tamaño por policy no supere el límite.

- **Región o sitio Datadog incorrecto:** Si usas Datadog EU (`datadoghq.eu`), configura `datadog_site = "datadoghq.eu"` y el `datadog_aws_principal_account_id` correspondiente a ese sitio (consultar documentación de Datadog).

- **Terraform plan pide variables:** Asegúrate de pasar `aws_account_id`, `datadog_api_key` y `datadog_app_key` (por tfvars o `-var`). Las variables sensibles no deben commitearse.
