# 🔐 AWS Systems Manager Parameter Store Setup

This guide explains how to securely store Datadog credentials in AWS Systems Manager (SSM) Parameter Store.

## Why SSM Parameter Store?

- ✅ **FREE** for standard parameters (vs AWS Secrets Manager at $0.40/secret/month)
- ✅ **Encrypted at rest** using AWS KMS
- ✅ **IAM-controlled access** with fine-grained permissions
- ✅ **Audit trail** via CloudTrail
- ✅ **Version history** for parameter changes
- ✅ **No secrets in Terraform state** - retrieved at runtime by EC2 instances

## Prerequisites

Before setting up SSM parameters, you need:

1. **Datadog Account** - Sign up at https://www.datadoghq.com
2. **Datadog API Key** - For sending metrics/logs
3. **Datadog Application Key** - For Terraform provider authentication
4. **AWS CLI configured** with appropriate permissions

---

## 📚 Step 1: Get Your Datadog Keys

### Get Datadog API Key

1. Log into your Datadog account
2. Navigate to: **Organization Settings → API Keys**
   - Direct link: https://app.datadoghq.com/organization-settings/api-keys
3. Click **"New Key"** or use an existing key
4. Copy the API key (starts with a long alphanumeric string)

### Get Datadog Application Key

1. In Datadog, navigate to: **Organization Settings → Application Keys**
   - Direct link: https://app.datadoghq.com/organization-settings/application-keys
2. Click **"New Key"**
3. Give it a name (e.g., "terraform-integration")
4. Copy the Application key

### Important Security Note

⚠️ **NEVER commit these keys to version control!**
⚠️ **DO NOT hardcode them in Terraform files!**

---

## 📦 Step 2: Store Keys in AWS SSM Parameter Store

### Option A: Using AWS CLI (Recommended)

```bash
# Store Datadog API Key
aws ssm put-parameter \
  --name "/lti-project/datadog/api-key" \
  --type "SecureString" \
  --value "YOUR_ACTUAL_API_KEY_HERE" \
  --description "Datadog API key for LTI Project monitoring" \
  --tags "Key=Project,Value=lti-project" "Key=Environment,Value=dev" "Key=ManagedBy,Value=manual" \
  --region us-east-1

# Store Datadog Application Key
aws ssm put-parameter \
  --name "/lti-project/datadog/app-key" \
  --type "SecureString" \
  --value "YOUR_ACTUAL_APP_KEY_HERE" \
  --description "Datadog Application key for Terraform provider" \
  --tags "Key=Project,Value=lti-project" "Key=Environment,Value=dev" "Key=ManagedBy,Value=manual" \
  --region us-east-1
```

### Option B: Using AWS Console

1. Open AWS Console → **Systems Manager → Parameter Store**
2. Click **"Create parameter"**

**For API Key:**
- **Name:** `/lti-project/datadog/api-key`
- **Description:** `Datadog API key for LTI Project monitoring`
- **Tier:** `Standard`
- **Type:** `SecureString`
- **KMS Key:** `alias/aws/ssm` (default, FREE)
- **Value:** Paste your Datadog API key
- Click **"Create parameter"**

**For Application Key:**
- Repeat with name: `/lti-project/datadog/app-key`
- Value: Paste your Datadog Application key

---

## ✅ Step 3: Verify Parameters

```bash
# List all Datadog parameters
aws ssm describe-parameters \
  --parameter-filters "Key=Name,Values=/lti-project/datadog" \
  --region us-east-1

# Verify API key exists (without showing value)
aws ssm get-parameter \
  --name "/lti-project/datadog/api-key" \
  --region us-east-1 \
  --query 'Parameter.[Name,Type,LastModifiedDate]' \
  --output table

# Verify APP key exists (without showing value)
aws ssm get-parameter \
  --name "/lti-project/datadog/app-key" \
  --region us-east-1 \
  --query 'Parameter.[Name,Type,LastModifiedDate]' \
  --output table
```

Expected output:
```
Parameter Name                       Type          Last Modified
/lti-project/datadog/api-key        SecureString  2024-XX-XX
/lti-project/datadog/app-key        SecureString  2024-XX-XX
```

---

## 🔄 Step 4: Set Environment Variables for Terraform

The Terraform Datadog provider needs these keys at runtime. Set them as environment variables:

```bash
# Retrieve from SSM and set as environment variables
export DD_API_KEY=$(aws ssm get-parameter \
  --name "/lti-project/datadog/api-key" \
  --with-decryption \
  --region us-east-1 \
  --query 'Parameter.Value' \
  --output text)

export DD_APP_KEY=$(aws ssm get-parameter \
  --name "/lti-project/datadog/app-key" \
  --with-decryption \
  --region us-east-1 \
  --query 'Parameter.Value' \
  --output text)

# Verify they're set (without exposing values)
echo "DD_API_KEY is set: $([ -n "$DD_API_KEY" ] && echo 'YES' || echo 'NO')"
echo "DD_APP_KEY is set: $([ -n "$DD_APP_KEY" ] && echo 'YES' || echo 'NO')"
```

**For persistence, add to your shell profile (~/.zshrc or ~/.bashrc):**

```bash
# Datadog credentials for Terraform (add to ~/.zshrc)
export DD_API_KEY=$(aws ssm get-parameter --name "/lti-project/datadog/api-key" --with-decryption --region us-east-1 --query 'Parameter.Value' --output text 2>/dev/null)
export DD_APP_KEY=$(aws ssm get-parameter --name "/lti-project/datadog/app-key" --with-decryption --region us-east-1 --query 'Parameter.Value' --output text 2>/dev/null)
```

---

## 🔐 Step 5: IAM Permissions

### For Your AWS User/Role (Terraform execution)

Ensure you have permissions to read SSM parameters:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:DescribeParameters"
      ],
      "Resource": "arn:aws:ssm:us-east-1:*:parameter/lti-project/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": "arn:aws:kms:us-east-1:*:key/*",
      "Condition": {
        "StringEquals": {
          "kms:ViaService": "ssm.us-east-1.amazonaws.com"
        }
      }
    }
  ]
}
```

### For EC2 Instances (Runtime retrieval)

This is already handled in the Terraform IAM configuration - EC2 instances will have permission to read only the Datadog API key parameter.

---

## 🧪 Step 6: Test Terraform Access

```bash
# Test Terraform can initialize with Datadog provider
cd /Users/williansnieves/Documents/practices/lidr-projects/AI4Devs-monitoring/tf
terraform init

# Test provider can authenticate
terraform plan -target=datadog_integration_aws.main
```

If successful, you should see:
```
Terraform has been successfully initialized!
```

---

## 🔄 Updating Keys

To rotate or update keys:

```bash
# Update API key
aws ssm put-parameter \
  --name "/lti-project/datadog/api-key" \
  --type "SecureString" \
  --value "NEW_API_KEY_HERE" \
  --overwrite \
  --region us-east-1

# Update APP key
aws ssm put-parameter \
  --name "/lti-project/datadog/app-key" \
  --type "SecureString" \
  --value "NEW_APP_KEY_HERE" \
  --overwrite \
  --region us-east-1

# Refresh environment variables
export DD_API_KEY=$(aws ssm get-parameter --name "/lti-project/datadog/api-key" --with-decryption --region us-east-1 --query 'Parameter.Value' --output text)
export DD_APP_KEY=$(aws ssm get-parameter --name "/lti-project/datadog/app-key" --with-decryption --region us-east-1 --query 'Parameter.Value' --output text)
```

---

## 🗑️ Deleting Parameters (if needed)

```bash
# Delete API key parameter
aws ssm delete-parameter \
  --name "/lti-project/datadog/api-key" \
  --region us-east-1

# Delete APP key parameter
aws ssm delete-parameter \
  --name "/lti-project/datadog/app-key" \
  --region us-east-1
```

---

## 📊 Cost Analysis

**SSM Parameter Store (Standard Parameters):**
- ✅ **Storage:** FREE (up to 10,000 parameters)
- ✅ **API calls:** FREE (standard throughput: 40 TPS)
- ✅ **Encryption:** FREE (using AWS managed KMS key `alias/aws/ssm`)

**Optional: AWS Secrets Manager Alternative**
- ❌ **Storage:** $0.40 per secret per month
- ❌ **API calls:** $0.05 per 10,000 API calls
- ✅ **Automatic rotation:** Built-in support

**Recommendation:** Use SSM Parameter Store unless you need automatic rotation.

---

## ❓ Troubleshooting

### "AccessDenied" when reading parameters

- Check IAM permissions include `ssm:GetParameter` and `kms:Decrypt`
- Verify you're in the correct AWS region
- Confirm parameter names match exactly (case-sensitive)

### Environment variables not persisting

- Add export commands to `~/.zshrc` or `~/.bashrc`
- Run `source ~/.zshrc` to reload

### Terraform can't authenticate with Datadog

- Verify environment variables: `echo $DD_API_KEY | cut -c1-10` (shows first 10 chars)
- Check Datadog site matches (datadoghq.com vs datadoghq.eu)
- Verify keys are valid in Datadog UI

---

## 🔗 Additional Resources

- [AWS SSM Parameter Store Documentation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)
- [Datadog API Keys Guide](https://docs.datadoghq.com/account_management/api-app-keys/)
- [Datadog Terraform Provider](https://registry.terraform.io/providers/DataDog/datadog/latest/docs)

---

**Next Steps:** Once parameters are created, proceed with `terraform init` and `terraform plan` to begin deploying Datadog integration! 🚀

