# 🚀 Guía de Configuración para Datadog + AWS

## ⚠️ IMPORTANTE: Antes de ejecutar Terraform

### 1. Configurar Credenciales de AWS

**Opción A: AWS CLI (Recomendado)**
```bash
aws configure
```
Necesitarás:
- AWS Access Key ID
- AWS Secret Access Key  
- Default region: `us-east-1`
- Default output format: `json`

**Opción B: Variables de entorno**
```bash
export AWS_ACCESS_KEY_ID="tu_access_key"
export AWS_SECRET_ACCESS_KEY="tu_secret_key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 2. Configurar Credenciales de Datadog

1. **Obtener API Key**:
   - Ve a [Datadog](https://app.datadoghq.com/)
   - Organization Settings → API Keys
   - Crea una nueva API Key

2. **Obtener Application Key**:
   - Organization Settings → Application Keys  
   - Crea una nueva Application Key

3. **Obtener External ID**:
   - Integrations → AWS → Configuration → Manual
   - Copia el External ID generado

4. **Actualizar terraform.tfvars**:
   ```hcl
   datadog_api_key     = "tu_api_key_real"
   datadog_app_key     = "tu_app_key_real"  
   datadog_external_id = "tu_external_id_real"
   ```

### 3. Ejecutar Terraform

```bash
# Desde el directorio tf/
terraform init
terraform plan
terraform apply
```

## 📊 Recursos que se crearán

### AWS Resources:
- ✅ S3 Bucket para código
- ✅ IAM Role para Datadog
- ✅ Security Groups (Backend: 8081, Frontend: 3000)
- ✅ EC2 Instances con agentes Datadog

### Datadog Resources:
- ✅ Integración AWS automática
- ✅ Dashboard "AI4Devs AWS Monitoring Dashboard"
- ✅ Monitores de CPU y Status Check
- ✅ Alertas automáticas

## 🔍 Verificación

Después del despliegue:
1. Ve a tu dashboard de Datadog
2. Busca "AI4Devs AWS Monitoring Dashboard"
3. Verifica que aparezcan las instancias EC2
4. Revisa los monitores activos

## 🆘 Troubleshooting

**Error 401 Unauthorized**: Verifica las credenciales de Datadog
**Error AWS credentials**: Configura AWS CLI o variables de entorno
**No aparecen métricas**: Espera 5-10 minutos para que se sincronicen
