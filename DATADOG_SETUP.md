# 📊 Datadog + AWS Integration Guide

## **Phase 1: Datadog Account Setup**

### Step 1: **Prepare Datadog Account**
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

### Step 2: **Configure AWS Integration in Datadog**
1. **In Datadog Console**:
   - Go to `Integrations` → `AWS`
   - Click `Add AWS Account`
   - Choose `Role Delegation` (recommended)
   - **Copy the External ID** (you'll need this!)

### Step 3: **Update OpenTofu Configuration**
1. **Set your Datadog API key**:
   ```bash
   export TF_VAR_datadog_api_key="your-datadog-api-key-here"
   ```

2. **Set the External ID** (from Step 2):
   ```bash
   export TF_VAR_datadog_external_id="external-id-from-datadog"
   ```

3. **If using EU Datadog**:
   ```bash
   export TF_VAR_datadog_site="datadoghq.eu"
   ```

### Step 4: **Deploy the Updated Infrastructure**
```bash
cd tf
tofu plan
tofu apply
```

### Step 5: **Complete Datadog AWS Integration**
1. **After OpenTofu completes**, copy the `datadog_role_arn` from the output
2. **Back in Datadog Console**:
   - Paste the Role ARN
   - Enter the External ID (same as Step 3)
   - Click `Install Integration`
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
export TF_VAR_datadog_external_id="external-id-from-datadog"

# Optional (defaults shown)
export TF_VAR_datadog_site="datadoghq.com"  # or "datadoghq.eu"
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