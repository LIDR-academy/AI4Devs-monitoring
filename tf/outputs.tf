# ============================================================================
# TERRAFORM OUTPUTS
# ============================================================================
# Expose important values for reference and integration with other systems.
# Sensitive outputs are marked to prevent exposure in logs.
# ============================================================================

# ------------------------------------------------------------------------------
# EC2 Instance Outputs
# ------------------------------------------------------------------------------

output "backend_instance_id" {
  description = "ID of the backend EC2 instance"
  value       = aws_instance.backend.id
}

output "backend_instance_public_ip" {
  description = "Public IP address of the backend EC2 instance"
  value       = aws_instance.backend.public_ip
}

output "frontend_instance_id" {
  description = "ID of the frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "frontend_instance_public_ip" {
  description = "Public IP address of the frontend EC2 instance"
  value       = aws_instance.frontend.public_ip
}

# ------------------------------------------------------------------------------
# IAM Outputs
# ------------------------------------------------------------------------------

output "ec2_instance_profile_arn" {
  description = "ARN of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.arn
}

output "datadog_integration_role_arn" {
  description = "ARN of the Datadog AWS integration IAM role"
  value       = try(aws_iam_role.datadog_integration_role.arn, "Not created yet")
}

# ------------------------------------------------------------------------------
# Datadog Integration Outputs
# ------------------------------------------------------------------------------

output "datadog_external_id" {
  description = "External ID for Datadog AWS integration (sensitive)"
  value       = try(random_uuid.datadog_external_id.result, "Not generated yet")
  sensitive   = true
}

output "datadog_aws_account_id" {
  description = "Datadog AWS account ID for trust relationship"
  value       = "464622532012" # Official Datadog AWS account
}

# ------------------------------------------------------------------------------
# SSM Parameter Outputs
# ------------------------------------------------------------------------------

output "datadog_api_key_parameter_name" {
  description = "SSM Parameter Store path for Datadog API key"
  value       = var.datadog_api_key_ssm_parameter
}

output "datadog_app_key_parameter_name" {
  description = "SSM Parameter Store path for Datadog APP key"
  value       = var.datadog_app_key_ssm_parameter
}

# ------------------------------------------------------------------------------
# Monitoring Outputs
# ------------------------------------------------------------------------------

output "datadog_dashboard_url" {
  description = "URL to the Datadog dashboard"
  value       = try(datadog_dashboard.main.url, "Dashboard not created yet")
}

# ------------------------------------------------------------------------------
# Quick Reference Commands
# ------------------------------------------------------------------------------

output "quick_reference" {
  description = "Quick reference commands for common operations"
  value = <<-EOT
    
    ╔══════════════════════════════════════════════════════════════════════╗
    ║                     QUICK REFERENCE COMMANDS                          ║
    ╚══════════════════════════════════════════════════════════════════════╝
    
    📦 Access Backend Instance:
       ssh ec2-user@${aws_instance.backend.public_ip}
    
    📦 Access Frontend Instance:
       ssh ec2-user@${aws_instance.frontend.public_ip}
    
    🔐 Store Datadog API Key in SSM:
       aws ssm put-parameter \
         --name "${var.datadog_api_key_ssm_parameter}" \
         --type "SecureString" \
         --value "YOUR_DATADOG_API_KEY"
    
    🔐 Store Datadog APP Key in SSM:
       aws ssm put-parameter \
         --name "${var.datadog_app_key_ssm_parameter}" \
         --type "SecureString" \
         --value "YOUR_DATADOG_APP_KEY"
    
    🔍 Verify Datadog Agent Status (on EC2):
       sudo datadog-agent status
    
    📊 View Datadog Dashboard:
       ${try(datadog_dashboard.main.url, "Dashboard not created yet")}
    
    🔄 Refresh Terraform State:
       terraform refresh
    
    🧹 Format Terraform Files:
       terraform fmt -recursive
    
    ✅ Validate Configuration:
       terraform validate
    
  EOT
}

