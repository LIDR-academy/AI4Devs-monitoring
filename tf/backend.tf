# ============================================================================
# TERRAFORM BACKEND CONFIGURATION
# ============================================================================
# Remote state backend using S3 with DynamoDB for state locking.
#
# IMPORTANT: This configuration is COMMENTED OUT initially.
#
# Setup Instructions:
# 1. First apply state-backend.tf to create S3 bucket and DynamoDB table:
#    terraform apply -target=aws_s3_bucket.terraform_state -target=aws_dynamodb_table.terraform_locks
#
# 2. Uncomment the terraform block below
#
# 3. Update the bucket name with your actual AWS account ID:
#    aws sts get-caller-identity --query Account --output text
#
# 4. Initialize backend and migrate state:
#    terraform init -migrate-state
#
# 5. Verify state is in S3:
#    aws s3 ls s3://lti-project-terraform-state-<ACCOUNT-ID>/terraform/dev/
#
# 6. Delete local state files (AFTER verifying remote state works):
#    rm terraform.tfstate terraform.tfstate.backup
# ============================================================================

# UNCOMMENT AFTER CREATING STATE BACKEND RESOURCES
#
# terraform {
#   backend "s3" {
#     # Replace <ACCOUNT-ID> with your AWS account ID
#     bucket = "lti-project-terraform-state-<ACCOUNT-ID>"
#     
#     key            = "terraform/dev/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "lti-project-terraform-locks"
#     encrypt        = true
#     
#     # Optional: Enable additional safety features
#     # kms_key_id = "arn:aws:kms:us-east-1:ACCOUNT-ID:key/KEY-ID" # Use KMS instead of AES256
#   }
# }

# Backend configuration can also be provided via backend.hcl file:
# terraform init -backend-config=backend.hcl
#
# Example backend.hcl content:
# ---
# bucket         = "lti-project-terraform-state-123456789012"
# key            = "terraform/dev/terraform.tfstate"
# region         = "us-east-1"
# dynamodb_table = "lti-project-terraform-locks"
# encrypt        = true
# ---

