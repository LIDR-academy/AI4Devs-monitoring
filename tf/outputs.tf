# Outputs para la integración de Datadog con AWS

output "datadog_aws_integration_role_arn" {
  description = "ARN del rol IAM creado para la integración de Datadog con AWS"
  value       = aws_iam_role.datadog_aws_integration.arn
}

output "datadog_aws_integration_role_name" {
  description = "Nombre del rol IAM creado para la integración de Datadog con AWS"
  value       = aws_iam_role.datadog_aws_integration.name
}

output "datadog_aws_account_id" {
  description = "ID de la cuenta de AWS de Datadog utilizada para la integración"
  value       = var.datadog_aws_account_id
}

output "datadog_integration_setup_instructions" {
  description = "Instrucciones para completar la configuración de la integración de Datadog con AWS"
  value       = <<EOT
INSTRUCCIONES PARA COMPLETAR LA CONFIGURACIÓN DE DATADOG CON AWS:

1. Crea un archivo terraform.tfvars con las siguientes variables:

   # API Key y App Key de Datadog
   datadog_api_key = "tu_api_key_de_datadog"
   datadog_app_key = "tu_app_key_de_datadog"
   
   # External ID para el rol de AWS
   datadog_external_id = "un_valor_temporal_para_external_id"

2. Aplica la configuración de Terraform:
   terraform apply

3. Ve a la consola de Datadog (https://app.datadoghq.com/account/settings#integrations/amazon-web-services)

4. Haz clic en "Añadir cuenta AWS" y selecciona "Rol delegado"

5. Rellena los siguientes campos:
   - ID de cuenta de AWS: Tu ID de cuenta de AWS
   - Nombre del rol: ${aws_iam_role.datadog_aws_integration.name}
   - ARN del rol: ${aws_iam_role.datadog_aws_integration.arn}

6. Copia el External ID generado por Datadog y actualiza la variable datadog_external_id en tu archivo terraform.tfvars.

7. Vuelve a aplicar la configuración para actualizar el rol con el External ID correcto:
   terraform apply

8. Finaliza la configuración en la consola de Datadog seleccionando qué métricas quieres recopilar.

9. Verifica que el dashboard "Infraestructura AWS - Monitorización" se ha creado correctamente en Datadog.
EOT
} 