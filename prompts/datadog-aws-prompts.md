# Prompt 1 (claude-3.7-sonnet)
En tu rol asistente experto en DevOps y desarrollo de infraestructura como código, con especialización en Terraform, analiza y explícame toda la configuración de infraestructura en la carpeta @tf 
___
# Prompt 2 (claude-3.7-sonnet)
Eres un asistente experto en DevOps y desarrollo de infraestructura como código, con especialización en Terraform y la integración de servicios de monitorización como Datadog con AWS.

Contexto:
En este proyecto se utiliza Terraform para gestionar la infraestructura en AWS. Ya tenemos configurados varios recursos de AWS (que ya conoces en este chat, como S3, EC2...). Quiero integrar Datadog para monitorizar nuestros recursos de AWS. Necesito configurar la integración principal de Datadog con AWS, lo que implica crear un rol IAM en AWS que Datadog pueda asumir para recopilar métricas y logs.

Objetivo:
Necesito que me proporciones el código Terraform necesario para:
1. Crear una política IAM (aws_iam_policy) que otorgue los permisos mínimos necesarios para que Datadog recopile métricas y logs de los servicios de AWS que estamos utilizando. Idealmente, esta política debería seguir las recomendaciones oficiales de Datadog (@https://docs.datadoghq.com/es/integrations/guide/aws-terraform-setup/ ).
2. Crear un rol IAM (aws_iam_role) que Datadog pueda asumir. Este rol debe:
    - Confiar en la cuenta de AWS de Datadog (el Datadog AWS Account ID es 464622532012 a menos que haya cambiado, por favor, verifica esto si es posible).
    - Requerir un External ID para mayor seguridad. Genera un placeholder seguro para este External ID o indícame cómo generarlo.
    - Tener adjunta la política IAM creada en el paso anterior.
3. Mostrar cómo obtener el External ID desde la interfaz de Datadog una vez que la configuración inicial esté lista para ser aplicada.
4. Proporcionar cualquier output de Terraform relevante, como el ARN del rol IAM creado, que necesitaré para configurar la integración en la consola de Datadog.

Consideraciones Adicionales:
 - Asegúrate de que el código sigue las mejores prácticas de Terraform (nombres de recursos claros, uso de variables donde sea apropiado, etc.).
 - Indica si hay variables que debería definir (por ejemplo, para el External ID o para un prefijo de nombre para los recursos).
 - Si hay diferentes formas de configurar la integración (por ejemplo, para diferentes conjuntos de permisos o servicios), menciónalas brevemente o proporciona la más común/recomendada.
 - El código debe ser compatible con la versión actual utilizada de Terraform en este proyecto.
 - Modifica los fichero de configuración existentes en @tf , o crea nuevos si lo necesitas.
 ___
# Prompt 3 (claude-3.7-sonnet)
¿debo añadir el proveedor Datadog a la configuración de Terraform o eso ya está hecho?
___
# Prompt 4 (claude-3.7-sonnet)
Modifica el script de usuario de la instancia EC2 para instalar y configurar el agente Datadog
___
# Prompt 5 (claude-3.7-sonnet)
Utiliza Terraform para definir un dashboard en Datadog que muestre métricas relevantes de la infraestructura AWS.
___
# Prompt 6 (claude-3.7-sonnet)
con todo esto, indícame detalladamente qué debo hacer para ejecutarlo. ¿Dónde debo poner las credenciales de AWS y DataDog?
___
# Prompt 7
Tengo los siguientes warnings y errores al ejecutar 'terraform plan'. Ayúdame a corregirlos:
Warning: Deprecated Resource
?
?   with datadog_integration_aws.integration,
?   on datadog_integration.tf line 3, in resource "datadog_integration_aws" "integration":
?    3: resource "datadog_integration_aws" "integration" {
?
? **This resource is deprecated - use the `datadog_integration_aws_account`        
? resource instead**:
? https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_account
?
? (and 2 more similar warnings elsewhere)
?
?
? Warning: Argument is deprecated
?
?   with datadog_integration_aws.integration,
?   on datadog_integration.tf line 10, in resource "datadog_integration_aws" "integration":
?   10:   resource_collection_enabled = true
?
? Deprecated in favor of `extended_resource_collection_enabled`.
?
? (and 3 more similar warnings elsewhere)
?
?
? Error: Unsupported argument
?
?   on datadog_dashboard.tf line 282, in resource "datadog_monitor" "backend_availability":
?  282:   thresholds = {
?
? An argument named "thresholds" is not expected here.
?
?
? Error: Unsupported argument
?
?   on datadog_dashboard.tf line 297, in resource "datadog_monitor" "high_cpu_usage":
?  297:   thresholds = {
?
? An argument named "thresholds" is not expected here.
___
# Prompt 8
Ahora tengo los siguientes errores:

 Warning: Argument is deprecated
?
?   with datadog_dashboard.aws_infrastructure_dashboard,
?   on datadog_dashboard.tf line 5, in resource "datadog_dashboard" "aws_infrastructure_dashboard":
?    5:   is_read_only  = false
?
? This field is deprecated and non-functional. Use `restricted_roles` instead to define 
? which roles are required to edit the dashboard.
?
? (and one more similar warning elsewhere)
?
?
? Warning: Deprecated Resource
?
?   with datadog_integration_aws.integration,
?   on datadog_integration.tf line 6, in resource "datadog_integration_aws" "integration":
?    6: resource "datadog_integration_aws" "integration" {
?
? **This resource is deprecated - use the `datadog_integration_aws_account` resource    
? instead**:
? https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_account
?
?
? Error: Value for unconfigurable attribute
?
?   with datadog_integration_aws.integration,
?   on datadog_integration.tf line 9, in resource "datadog_integration_aws" "integration":
?    9:   external_id = var.datadog_external_id
?
? Can't configure a value for "external_id": its value will be decided automatically    
? based on the result of applying this configuration.
