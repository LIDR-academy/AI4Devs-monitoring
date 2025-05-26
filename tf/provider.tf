provider "aws" {
  region = var.aws_region
}

provider "datadog" {
  validate = false
  api_key  = var.datadog_api_key
  app_key  = var.datadog_app_key
}
