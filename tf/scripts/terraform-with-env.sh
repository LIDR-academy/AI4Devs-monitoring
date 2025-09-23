#!/bin/bash

# Terraform wrapper script that loads environment variables from .env
# Usage: ./terraform-with-env.sh [terraform-command] [options]

# Load environment variables from .env file
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    export $(cat .env | grep -v '^#' | xargs)
    echo "Environment variables loaded successfully!"
else
    echo "Error: .env file not found!"
    echo "Please create .env file from .env.template and fill in your actual values"
    exit 1
fi

# Set Terraform variables from environment
export TF_VAR_datadog_api_key="$DD_API_KEY"
export TF_VAR_datadog_app_key="$DD_APP_KEY"
export TF_VAR_aws_account_id="$AWS_ACCOUNT_ID"
export TF_VAR_aws_region="$AWS_REGION"

# Execute terraform with all arguments
echo "Executing: terraform $@"
terraform "$@"
