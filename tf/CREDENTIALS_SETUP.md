# 🔑 Configuración de Credenciales Requeridas

## AWS Credentials

### Opción 1: AWS CLI
```bash
aws configure
```
Ingresa:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: us-east-1
- Default output format: json

### Opción 2: Variables de Entorno
```bash
export AWS_ACCESS_KEY_ID="tu_access_key"
export AWS_SECRET_ACCESS_KEY="tu_secret_key"
export AWS_DEFAULT_REGION="us-east-1"
```

## Datadog Credentials

1. **Obtener API Key:**
   - Ve a [Datadog](https://app.datadoghq.com/)
   - Organization Settings → API Keys
   - Crea una nueva API Key

2. **Obtener Application Key:**
   - Organization Settings → Application Keys
   - Crea una nueva Application Key

3. **Obtener External ID:**
   - Integrations → AWS → Configuration → Manual
   - Copia el External ID generado

4. **Actualizar terraform.tfvars:**
   ```hcl
   datadog_api_key     = "tu_api_key_real"
   datadog_app_key     = "tu_app_key_real"
   datadog_external_id = "tu_external_id_real"
   ```

## Desplegar

Una vez configuradas las credenciales:
```bash
cd tf
terraform init
terraform plan
terraform apply
```
