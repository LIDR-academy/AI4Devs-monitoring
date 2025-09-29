terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws",  version = "~> 5.0" }
    datadog = { source = "DataDog/datadog", version = "~> 3.55" }
  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.${var.datadog_site}"
}
