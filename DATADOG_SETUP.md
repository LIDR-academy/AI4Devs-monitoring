# 📊 Datadog + AWS Integration Guide

## **Phase 1: Datadog Account Setup**

### Step 1: **Prepare Datadog Account** ✅
1. **Sign up/Login** to [Datadog](https://app.datadoghq.com)
2. **Get your API Key**:
   - Go to `Organization Settings` → `API Keys`
   - Copy your API key
3. **Determine your Datadog site**:
   - US: `datadoghq.com` (default)
   - EU: `datadoghq.eu`
   - Other regions: check Datadog docs

---

## **Phase 2: AWS Integration Setup**

### Step 2: **Get Your Datadog Keys**
1. **In Datadog Console**:
   - Go to `Organization Settings` → `API Keys` 
   - Copy your API key
   - Go to `Organization Settings` → `Application Keys`
   - Create/copy your Application key
   - **No External ID needed!** (Generated automatically)

### Step 3: **Set Environment Variables**
1. **Set your Datadog API key**:
   ```bash
   export TF_VAR_datadog_api_key="your-datadog-api-key-here"
   ```

2. **Set your Datadog Application key**:
   ```bash
   export TF_VAR_datadog_app_key="your-datadog-app-key-here"
   ```

3. **That's it!** (EU site already configured in variables.tf):
   ```bash
   # Already configured: datadoghq.eu
   # External ID generated automatically by OpenTofu
   ```

### Step 4: **Deploy the Updated Infrastructure**
```bash
cd tf
tofu plan
tofu apply
```

### Step 5: **Integration Completes Automatically! 🎉**
1. **OpenTofu handles everything**:
   - ✅ Creates the IAM role in AWS
   - ✅ Configures the integration in Datadog
   - ✅ Sets up proper permissions
   - ✅ No manual steps needed!

2. **Check the outputs** for confirmation:
   - `datadog_role_arn` - The AWS role created
   - `datadog_integration_details` - Integration info

3. **Wait 5-10 minutes** for data to start flowing

---

## **Phase 3: Verify Integration**

### Step 6: **Check AWS Metrics**
1. **In Datadog**:
   - Go to `Infrastructure` → `Host Map`
   - You should see your EC2 instances
   - Go to `Metrics` → `Explorer`
   - Search for `aws.ec2.cpuutilization`

### Step 7: **Check Application Monitoring**
1. **Host-level monitoring**:
   - CPU, Memory, Disk, Network metrics
   - Process monitoring (Docker containers)
2. **Application logs** (if configured):
   - Docker container logs
   - System logs

---

## **Phase 4: Enhanced Monitoring (Optional)**

### Step 8: **Add Custom Dashboards**
1. **Create dashboards for**:
   - EC2 instance health
   - Application performance
   - Docker container metrics
   - S3 bucket usage

### Step 9: **Set Up Alerts**
1. **Recommended alerts**:
   - High CPU usage (>80%)
   - High memory usage (>90%)
   - Application downtime
   - Disk space low (<10%)

---

## **Environment Variables Summary**

```bash
# Required
export TF_VAR_datadog_api_key="your-datadog-api-key"
export TF_VAR_datadog_app_key="your-datadog-app-key"

# Optional (already configured for EU)
# TF_VAR_datadog_site is set to "datadoghq.eu" in variables.tf
# External ID is generated automatically - no manual setup needed!
```

---

## **What Gets Monitored**

### **AWS Resources**:
- ✅ EC2 instances (CPU, memory, disk, network)
- ✅ S3 buckets (requests, storage)
- ✅ Security groups
- ✅ IAM roles

### **Application Level**:
- ✅ Docker containers
- ✅ Process monitoring
- ✅ System logs
- ✅ Application logs (if configured)

### **Custom Metrics**:
- ✅ Backend application on port 8080
- ✅ Frontend application on port 3000

---

## **Troubleshooting**

### **No data in Datadog?**
1. Check External ID matches
2. Verify Role ARN is correct
3. Wait 10-15 minutes for initial data
4. Check IAM role permissions

### **Agent not installing?**
1. SSH into instances and check:
   ```bash
   sudo systemctl status datadog-agent
   sudo tail -f /var/log/datadog/agent.log
   ```

### **Missing Docker metrics?**
1. Verify Docker integration is enabled:
   ```bash
   sudo cat /etc/datadog-agent/conf.d/docker.d/conf.yaml
   ```

---

## **Next Steps**
- Set up custom dashboards
- Configure alerting rules
- Add APM (Application Performance Monitoring) for deeper insights
- Set up log aggregation for your applications 