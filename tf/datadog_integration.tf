# ------------------------------------------------------------------------------
# Integración AWS - Datadog
# Permite a Datadog recopilar métricas, logs y trazas desde AWS.
# Requiere el IAM role y policies definidos en iam.tf (datadog_aws_integration_*).
# ------------------------------------------------------------------------------

data "datadog_integration_aws_iam_permissions" "datadog_permissions" {}

resource "datadog_integration_aws_account" "datadog_integration" {
  account_tags   = ["env:${var.environment}"]
  aws_account_id = var.aws_account_id
  aws_partition  = "aws"

  aws_regions {
    include_all = true
  }

  auth_config {
    aws_auth_config_role {
      role_name = var.datadog_integration_role_name
    }
  }

  resources_config {
    cloud_security_posture_management_collection = false
    extended_collection                          = true
  }

  metrics_config {
    namespace_filters {
      # Incluir todos los namespaces; opcionalmente excluir con namespace_exclusions
    }
  }

  logs_config {
    lambda_forwarder {
      # Opcional: configurar ARN del Lambda forwarder si se habilita recolección de logs
    }
  }

  traces_config {
    xray_services {
      # Opcional: servicios X-Ray si se usa tracing
    }
  }
}
