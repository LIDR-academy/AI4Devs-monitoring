# Terraform Configuration for AI4Devs Monitoring

Esta configuración de Terraform despliega la infraestructura completa para el proyecto AI4Devs Monitoring, incluyendo la integración con Datadog.

## 🔐 Configuración de Variables Sensibles

**IMPORTANTE**: Todas las credenciales sensibles se manejan a través de variables de entorno para mantener la seguridad.

### Configuración Inicial

1. **Copiar el archivo template:**
   ```bash
   cp .env.template .env
   ```

2. **Editar el archivo .env con tus credenciales:**
   ```bash
   # Datadog credentials
   DD_API_KEY=tu_api_key_de_datadog
   DD_APP_KEY=tu_app_key_de_datadog
   
   # AWS Account ID
   AWS_ACCOUNT_ID=tu_aws_account_id
   
   # AWS Region
   AWS_REGION=us-east-1
   ```

### Archivos de Configuración

- `.env` - Contiene las credenciales reales (NO se sube al repositorio)
- `.env.template` - Template con valores de ejemplo
- `terraform.tfvars` - Variables de Terraform (sin credenciales sensibles)
- `variables.tf` - Definición de variables de Terraform

## 🚀 Uso

### Opción 1: Script Automático (Recomendado)

```bash
# Inicializar Terraform
./terraform-with-env.sh init

# Planificar cambios
./terraform-with-env.sh plan

# Aplicar cambios
./terraform-with-env.sh apply

# Destruir infraestructura
./terraform-with-env.sh destroy
```

### Opción 2: Carga Manual de Variables

```bash
# Cargar variables de entorno
source load-env.sh

# Ejecutar comandos de Terraform normalmente
terraform plan
terraform apply
```

### Opción 3: Variables de Entorno Directas

```bash
# Establecer variables de entorno manualmente
export TF_VAR_datadog_api_key="tu_api_key"
export TF_VAR_datadog_app_key="tu_app_key"
export TF_VAR_aws_account_id="tu_account_id"
export TF_VAR_aws_region="us-east-1"

# Ejecutar Terraform
terraform plan
terraform apply
```

## 📁 Estructura de Archivos

```
tf/
├── .env                    # Credenciales (NO commitear)
├── .env.template          # Template de credenciales
├── load-env.sh            # Script para cargar variables
├── terraform-with-env.sh  # Script wrapper para Terraform
├── provider.tf            # Configuración de providers
├── variables.tf           # Variables de Terraform
├── terraform.tfvars       # Valores de variables
├── main.tf               # Recursos principales
├── vpc.tf                # Configuración de VPC
├── ec2.tf                # Instancias EC2
├── s3.tf                 # Bucket S3
├── security_groups.tf    # Security Groups
├── iam.tf                # Roles y políticas IAM
└── outputs.tf            # Outputs de Terraform
```

## 🏗️ Infraestructura Desplegada

- **VPC**: Red virtual personalizada con subnets públicas
- **EC2**: Instancias para backend y frontend
- **S3**: Bucket para almacenar código de aplicación
- **IAM**: Roles y políticas para Datadog y EC2
- **Security Groups**: Reglas de firewall
- **Datadog Integration**: Integración completa con AWS

## 🔍 Verificación

Después del despliegue, puedes verificar:

1. **Instancias EC2**: Acceder a las IPs públicas
2. **Bucket S3**: Verificar que los archivos se subieron
3. **Datadog**: Verificar la integración en tu dashboard

## ⚠️ Seguridad

- ✅ El archivo `.env` está en `.gitignore`
- ✅ No hay credenciales hardcodeadas en el código
- ✅ Todas las variables sensibles usan el prefijo `TF_VAR_`
- ✅ Los valores por defecto son seguros

## 🆘 Troubleshooting

### Error de autenticación con Datadog
- Verifica que las credenciales en `.env` sean correctas
- Asegúrate de usar la URL correcta (EU vs US) en `provider.tf`

### Variables de entorno no cargadas
- Verifica que el archivo `.env` existe
- Ejecuta `source load-env.sh` antes de usar Terraform

### Permisos de AWS
- Asegúrate de que tu usuario/rol de AWS tenga los permisos necesarios
- Verifica que la región sea correcta
