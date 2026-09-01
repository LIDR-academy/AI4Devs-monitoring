# integration.tf

# 1. Obtener información de la cuenta AWS actual para enlazarla con Datadog
data "aws_caller_identity" "current" {}

# 2. Configurar la Integración de AWS en Datadog
resource "datadog_integration_aws" "aws_integration" {
  account_id = data.aws_caller_identity.current.account_id
  role_name  = "DatadogAWSIntegrationRole"
}

# 3. Política de Confianza (Trust Policy) para que Datadog asuma el rol en tu cuenta
data "aws_iam_policy_document" "datadog_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      # ARN oficial y fijo de la cuenta principal de Datadog
      identifiers = ["arn:aws:iam::464622532012:root"] 
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      # Security Best Practice: Usamos el External ID único generado por el recurso de integración
      values   = [datadog_integration_aws.aws_integration.external_id]
    }
  }
}

# 4. Crear el Rol de IAM que Datadog utilizará para leer las métricas de CloudWatch
resource "aws_iam_role" "datadog_integration_role" {
  name               = "DatadogAWSIntegrationRole"
  assume_role_policy = data.aws_iam_policy_document.datadog_assume_role.json
}

# 5. Adjuntar política de lectura básica al Rol (Permite a Datadog leer el inventario y métricas)
# NOTA: Para producción formal se recomienda usar policy específica de Datadog, pero SecurityAudit basta para comenzar.
resource "aws_iam_role_policy_attachment" "datadog_aws_policy" {
  role       = aws_iam_role.datadog_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}
