# Data source para obtener el ID de la cuenta de AWS actual
data "aws_caller_identity" "current" {}

# Recurso de integración de Datadog con AWS
# Este recurso configura la integración desde el lado de Datadog
resource "datadog_integration_aws" "integration" {
  account_id  = data.aws_caller_identity.current.account_id
  role_name   = aws_iam_role.datadog_aws_integration.name
  external_id = var.datadog_external_id

  # Recolección de métricas
  cspm_resource_collection_enabled               = true
  resource_collection_enabled                    = true
  excluded_regions                               = []
  filter_tags                                   = ["env:production"]
  host_tags                                     = ["env:${terraform.workspace}", "managed-by:terraform"]
  
  # Define los namespaces de CloudWatch que deseas monitorizar
  account_specific_namespace_rules = {
    ec2               = true
    s3                = true
    cloudwatch        = true
    lambda            = true
    cloudtrail        = true
    rds               = true
    elb               = true
    application_elb   = true
    sqs               = true
    route53           = true
    vpc               = true
    apigateway        = true
    ecs               = true
  }
  
  # Asegura que el rol IAM se cree antes de configurar la integración
  depends_on = [
    aws_iam_role.datadog_aws_integration,
    aws_iam_role_policy_attachment.datadog_aws_integration,
    aws_iam_role_policy_attachment.datadog_aws_integration_security_audit
  ]
} 