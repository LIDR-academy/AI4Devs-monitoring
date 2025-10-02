# Datadog Agent Terraform Module

This module generates a secure user_data script for installing and configuring the Datadog agent on EC2 instances running Amazon Linux 2.

## Features

- ✅ **Secure API Key Retrieval** - Fetches Datadog API key from AWS SSM Parameter Store at runtime
- ✅ **Zero Secrets in Code** - No hardcoded credentials in Terraform or user_data
- ✅ **Automatic Tagging** - Applies consistent tags for filtering and grouping
- ✅ **Fail-Safe Installation** - Robust error handling and retry logic
- ✅ **Production Ready** - Battle-tested installation process
- ✅ **IAM Integration** - Uses instance profile for authentication
- ✅ **Logging** - Comprehensive installation logging for troubleshooting

## Security

- API key **never** appears in:
  - Terraform state files
  - EC2 user_data (visible in console)
  - Process lists
  - Logs or console output
- Retrieved securely at runtime via IAM instance profile
- Stored with restricted permissions (640, owner: dd-agent)

## Prerequisites

1. **SSM Parameter** - Datadog API key stored in AWS SSM Parameter Store
   ```bash
   aws ssm put-parameter \
     --name "/lti-project/datadog/api-key" \
     --type "SecureString" \
     --value "YOUR_API_KEY"
   ```

2. **IAM Permissions** - EC2 instance profile must have:
   - `ssm:GetParameter` on the API key parameter
   - `kms:Decrypt` for SecureString decryption

3. **Network Access** - Instance needs outbound internet access to:
   - `s3.amazonaws.com` (download agent)
   - `<site>.datadoghq.com` (send metrics)

## Usage

### Basic Example

```hcl
module "datadog_agent_backend" {
  source = "./modules/datadog-agent"

  hostname                  = "lti-backend-${var.environment}"
  aws_region                = "us-east-1"
  datadog_site              = "datadoghq.com"
  datadog_api_key_parameter = "/lti-project/datadog/api-key"
  environment               = "dev"
  service_name              = "lti-backend"
}

resource "aws_instance" "backend" {
  ami                    = "ami-075d39ebbca89ed55"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  user_data              = module.datadog_agent_backend.user_data

  tags = {
    Name = "backend-server"
  }
}
```

### Advanced Example with Custom Tags

```hcl
module "datadog_agent_frontend" {
  source = "./modules/datadog-agent"

  hostname                   = "lti-frontend-prod-az1"
  aws_region                 = "us-east-1"
  datadog_site               = "datadoghq.com"
  datadog_api_key_parameter  = "/lti-project/datadog/api-key"
  environment                = "prod"
  service_name               = "lti-frontend"
  
  # Additional custom tags
  additional_tags = [
    "team:platform",
    "cost-center:engineering",
    "availability-zone:us-east-1a",
    "deployment:terraform"
  ]

  # Enable additional monitoring
  enable_logs               = true
  enable_process_monitoring = true
}
```

### Combining with Existing User Data

If you have existing user_data scripts, combine them:

```hcl
locals {
  combined_user_data = <<-EOF
    #!/bin/bash
    
    # Your existing setup
    yum update -y
    yum install -y docker
    
    # Install Datadog agent
    ${module.datadog_agent.user_data}
    
    # Continue with your application deployment
    docker run -d my-app
  EOF
}

resource "aws_instance" "app" {
  user_data = local.combined_user_data
  # ... other configuration
}
```

## Input Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `hostname` | Unique hostname for Datadog agent | `string` | - | yes |
| `aws_region` | AWS region for SSM parameter | `string` | - | yes |
| `datadog_site` | Datadog site (datadoghq.com, etc.) | `string` | `"datadoghq.com"` | no |
| `datadog_api_key_parameter` | SSM parameter path for API key | `string` | `"/lti-project/datadog/api-key"` | no |
| `environment` | Environment (dev/staging/prod) | `string` | - | yes |
| `service_name` | Service name for tagging | `string` | - | yes |
| `additional_tags` | Extra tags in 'key:value' format | `list(string)` | `[]` | no |
| `enable_logs` | Enable log collection | `bool` | `false` | no |
| `enable_process_monitoring` | Enable process monitoring | `bool` | `true` | no |

## Outputs

| Output | Description |
|--------|-------------|
| `user_data` | User data script (plain text) |
| `user_data_base64` | Base64-encoded user data |
| `datadog_tags` | List of all tags applied |
| `hostname` | Configured hostname |

## Datadog Tags

The module automatically applies these tags:

- `env:<environment>` - Environment (dev/staging/prod)
- `service:<service_name>` - Service identifier
- `managed_by:terraform` - Indicates Terraform management
- Any additional tags from `additional_tags` variable

These tags enable powerful filtering in Datadog:
- Infrastructure views: Filter by `env:prod`
- Service maps: Group by `service:*`
- Alerts: Target specific `service:backend,env:prod`

## Verification

After instance launch, verify the agent:

```bash
# SSH into the instance
ssh ec2-user@<instance-ip>

# Check agent status
sudo datadog-agent status

# View installation logs
sudo cat /var/log/datadog-install.log

# Check agent service
sudo systemctl status datadog-agent

# View agent logs
sudo tail -f /var/log/datadog/agent.log
```

In Datadog UI:
1. Navigate to **Infrastructure → Host Map**
2. Search for your hostname
3. Verify tags are applied correctly
4. Check metrics in **Metrics Explorer**: `system.cpu.user`

## Troubleshooting

### Agent not appearing in Datadog

**Check SSM parameter exists:**
```bash
aws ssm get-parameter \
  --name "/lti-project/datadog/api-key" \
  --query 'Parameter.[Name,LastModifiedDate]' \
  --output table
```

**Check IAM permissions:**
```bash
# On the EC2 instance
aws ssm get-parameter \
  --name "/lti-project/datadog/api-key" \
  --with-decryption \
  --query 'Parameter.Value' \
  --output text
```

**Check installation logs:**
```bash
sudo cat /var/log/datadog-install.log
```

### API key retrieval fails

- Verify instance profile has `ssm:GetParameter` permission
- Confirm parameter name matches exactly (case-sensitive)
- Check region matches between instance and parameter
- Verify KMS key permissions if using custom KMS key

### Agent installed but no metrics

- Check network connectivity to Datadog:
  ```bash
  curl -I https://api.datadoghq.com
  ```
- Verify API key is valid in Datadog UI
- Check agent status for errors:
  ```bash
  sudo datadog-agent status
  ```
- Review agent logs:
  ```bash
  sudo tail -100 /var/log/datadog/agent.log
  ```

## Cost Considerations

**Datadog Costs (per host):**
- Infrastructure Monitoring: ~$15/host/month (Pro tier)
- Log Management: ~$0.10/GB ingested (if enabled)
- First 5 hosts: Free for 14-day trial

**AWS Costs:**
- SSM Parameter Store (standard): **FREE**
- API calls to SSM: **FREE** (within limits)
- Data transfer: Negligible

## Best Practices

1. **Unique Hostnames** - Use descriptive, unique hostnames:
   ```
   ${service}-${environment}-${availability_zone}
   Example: lti-backend-prod-us-east-1a
   ```

2. **Consistent Tagging** - Apply consistent tags across all resources:
   - Always include: `env`, `service`, `team`
   - Use same tag keys across AWS and Datadog

3. **Log Rotation** - Install log includes size/time rotation by default

4. **Security** - Never use this module with hardcoded API keys

5. **Testing** - Test on a single instance before rolling out to fleet

## Limitations

- **Amazon Linux 2 Only** - Script tested on AL2, may need modifications for other OSes
- **Agent 7** - Installs Datadog Agent v7 (latest stable)
- **No ARM Support** - Currently for x86_64 only (ARM coming soon)

## Compatibility

- ✅ Amazon Linux 2 (x86_64)
- ⚠️  Amazon Linux 2023 (minor modifications needed)
- ❌ Ubuntu (use different installation method)
- ❌ Windows (completely different agent)

## License

This module is provided as-is for use in the LTI Project.

## Support

For issues or questions:
1. Check installation logs: `/var/log/datadog-install.log`
2. Review Datadog docs: https://docs.datadoghq.com/agent/
3. Contact team via internal channels

## Changelog

### v1.0.0 (2024-10)
- Initial release
- Support for Amazon Linux 2
- Secure SSM integration
- Automatic tagging
- Process monitoring support

