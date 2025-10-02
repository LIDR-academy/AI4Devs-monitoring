# ============================================================================
# TERRAFORM STATE BACKEND INFRASTRUCTURE
# ============================================================================
# This file creates the S3 bucket and DynamoDB table required for remote
# state management. This must be applied FIRST before migrating to remote backend.
#
# Usage:
#   1. Apply this file: terraform apply -target=aws_s3_bucket.terraform_state
#   2. Then configure backend.tf and run: terraform init -migrate-state
# ============================================================================

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "lti-project-terraform-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "Terraform State Backend"
    Purpose     = "terraform-state"
    ManagedBy   = "terraform"
    Project     = "lti-project"
    Environment = "shared"
  }
}

# Enable Versioning (CRITICAL for state recovery)
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server-Side Encryption with AWS-managed keys
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access (SECURITY CRITICAL)
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable lifecycle policy to manage old versions
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  rule {
    id     = "abort-incomplete-uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "lti-project-terraform-locks"
  billing_mode = "PAY_PER_REQUEST" # Free tier eligible, scales automatically
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Locks"
    Purpose     = "terraform-state-locking"
    ManagedBy   = "terraform"
    Project     = "lti-project"
    Environment = "shared"
  }
}

# Outputs for reference
output "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "state_backend_config" {
  description = "Backend configuration for terraform init"
  value = <<-EOT
    
    Add this to your backend.tf and run: terraform init -migrate-state
    
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.terraform_state.id}"
        key            = "terraform/dev/terraform.tfstate"
        region         = "${data.aws_region.current.name}"
        dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
        encrypt        = true
      }
    }
  EOT
}

