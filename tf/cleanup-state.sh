#!/bin/bash
# =============================================================================
# Terraform State Cleanup Script
# =============================================================================
# Purpose: Remove orphaned resources from Terraform State that were deleted
#          manually outside of Terraform (causing 403 errors).
# 
# Context: After manual deletion of AWS resources, the Terraform state still
#          references them, causing plan/apply failures. This script removes
#          those references to allow a fresh deployment.
#
# Usage:   
#   chmod +x cleanup-state.sh
#   ./cleanup-state.sh
#
# Author:  Architect Agent
# Date:    2026-02-17
# =============================================================================

set -e  # Exit on error

echo "=================================================="
echo "  Terraform State Cleanup - Removing Orphaned Resources"
echo "=================================================="
echo ""
echo "⚠️  WARNING: This will remove resources from Terraform State!"
echo "    They will be recreated on the next 'terraform apply'."
echo ""
read -p "Continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Aborted by user."
    exit 0
fi

echo ""
echo "🔍 Current state contains the following resources:"
terraform state list
echo ""

echo "🧹 Starting cleanup..."
echo ""

# Remove data sources (these don't create actual resources)
echo "📦 Removing data sources..."
terraform state rm 'data.aws_iam_policy_document.s3_access_policy' || true

# Remove IAM resources
echo "🔐 Removing IAM resources..."
terraform state rm 'aws_iam_instance_profile.ec2_instance_profile' || true
terraform state rm 'aws_iam_policy.s3_access_policy' || true
terraform state rm 'aws_iam_role_policy_attachment.attach_s3_access_policy' || true
terraform state rm 'aws_iam_role.ec2_role' || true

# Remove EC2 instances
echo "🖥️  Removing EC2 instances..."
terraform state rm 'aws_instance.backend' || true
terraform state rm 'aws_instance.frontend' || true

# Remove S3 resources
echo "🪣 Removing S3 resources..."
terraform state rm 'aws_s3_bucket_object.backend_zip' || true
terraform state rm 'aws_s3_bucket_object.frontend_zip' || true
terraform state rm 'aws_s3_bucket.code_bucket' || true

# Remove Security Groups
echo "🔒 Removing Security Groups..."
terraform state rm 'aws_security_group.backend_sg' || true
terraform state rm 'aws_security_group.frontend_sg' || true

# Remove null resources
echo "🗑️  Removing null resources..."
terraform state rm 'null_resource.generate_zip' || true

echo ""
echo "✅ State cleanup completed!"
echo ""
echo "📊 Remaining resources in state:"
terraform state list
echo ""
echo "🚀 Next steps:"
echo "   1. Verify: terraform plan"
echo "   2. Deploy: terraform apply"
echo ""
