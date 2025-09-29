````markdown
# datadog-aws-prompts-ASM.md
**Author:** ASM (Adrián Sendín)  
**Date:** 2025-09-29  
**Repo:** `adriansendin/AI4Devs-week15-monitoring`  
**Environment:** Windows 11 + Cursor IDE + Terraform + AWS CLI + Datadog (EU)

> This document captures the **prompt engineering** used to implement the AWS ↔ Datadog monitoring channel with Terraform, plus a concise **post-mortem** of issues encountered and how they were resolved. It is designed to be reusable and auditable.

---

## 1) Role & Constraints (to include at the top of every prompt)
**Role / Persona**
- *You are a Senior DevOps/SRE specialized in Terraform, AWS, and Datadog. You write production-grade, idempotent Terraform with minimal blast radius.*

**Global Constraints**
- No secrets in code. All secrets via environment variables (`TF_VAR_*`, `DD_*`) or variables.
- Datadog **EU** site → use `api_url = "https://api.${var.datadog_site}"` and `DD_SITE=datadoghq.eu`.
- Respect existing files. **Do not remove** working resources. Only extend safely.
- Output: **single, complete code blocks** per change; reference file names; explain where to paste.
- Avoid hard-coded IPs/IDs. Use **data sources**, variables, and outputs.

---

## 2) Inputs & Assumptions
- `AWS_PROFILE=ai4devs` (already configured).
- Region: `eu-north-1` (changeable via `TF_VAR_region`).
- Datadog keys exported as `DD_API_KEY` and `DD_APP_KEY`; mapped to Terraform as `TF_VAR_datadog_api_key`, `TF_VAR_datadog_app_key`, `TF_VAR_datadog_site`.
- Existing stack: EC2 backend (:8080), EC2 frontend (:80), S3 artifacts, SGs, SSM enabled.

---

## 3) Prompt Library (copy-paste ready)

### 3.1 Provider & Variables (Datadog EU + AWS)
**Prompt**
> **Role:** Senior DevOps Terraform.  
> **Task:** Update provider definitions for AWS and Datadog (EU) without breaking current infra.  
> **Context:** We already have `provider.tf` with `aws` and `datadog`. Keep `region` and `aws_profile` variables. Pin Datadog provider to a modern `~> 3.55`. Add `required_version >= 1.5.0`. Use `api_url = "https://api.${var.datadog_site}"`.  
> **Acceptance Criteria:**  
> - No secrets in code.  
> - Compatible with `TF_VAR_datadog_api_key`, `TF_VAR_datadog_app_key`, `TF_VAR_datadog_site`.  
> - Output one complete `provider.tf` block.  
> **Output format:** One HCL block only.

*(Assistant returns an updated `provider.tf` with `required_version`, `required_providers`, and EU `api_url`.)*

---

### 3.2 IAM Role for Datadog Integration (least-privilege read)
**Prompt**
> **Role:** Senior DevOps Terraform.  
> **Task:** Add a new IAM Role and inline policy so Datadog (EU) can assume the role and read CloudWatch/EC2/ELB/RDS/Lambda/Tags.  
> **Context:** Create resources at the end of `iam.tf`. Do not touch existing roles. Use Datadog EU principal (`arn:aws:iam::464622532012:root`).  
> **Acceptance Criteria:**  
> - Resource names: `aws_iam_role.datadog_integration`, `aws_iam_role_policy.datadog_integration`.  
> - AssumeRole policy to Datadog EU root.  
> - Read-only actions across CloudWatch/EC2/ELB/RDS/Lambda/Tagging.  
> - Output one complete HCL block to append to `iam.tf`.

---

### 3.3 Datadog ↔ AWS Account Integration
**Prompt**
> **Role:** Senior DevOps Terraform.  
> **Task:** Link the current AWS account to Datadog using Terraform.  
> **Context:** Use `datadog_integration_aws_account` (Datadog provider v3.x). Add `data "aws_caller_identity" "current"` if missing. Set `account_id` from the data source and `role_name` from the IAM role above.  
> **Acceptance Criteria:**  
> - Append to `main.tf` without removing existing `datadog_monitor`.  
> - Output a single HCL block with both the data source and the integration resource.  
> - No hard-coded IDs; everything derived.

---

### 3.4 Install Datadog Agent via EC2 `user_data`
**Prompt**
> **Role:** Senior DevOps Terraform.  
> **Task:** Extend EC2 `user_data` scripts to install and start Datadog Agent on Amazon Linux 2, using `$DD_API_KEY` from environment or a template variable.  
> **Context:** Backend EC2 already installs Docker & app. Append Datadog install commands after Docker is running. Ensure service enabled, logs to confirm.  
> **Acceptance Criteria:**  
> - Non-interactive install with retries and exit on failure.  
> - Service enabled and started.  
> - No secrets committed.  
> - Provide the `user_data` snippet only; indicate insertion point.

---

### 3.5 Create a Datadog Dashboard (CPU, Memory, Load)
**Prompt**
> **Role:** Senior DevOps Terraform.  
> **Task:** Add a `datadog_dashboard_json` resource named `ai4devs_overview` with widgets for CPU (`aws.ec2.cpuutilization` or `system.cpu.user`), Memory (`system.mem.used_pct`), and Load (`system.load.1`).  
> **Context:** Append to `main.tf`, keep existing resources intact.  
> **Acceptance Criteria:**  
> - Layout `ordered`.  
> - No hostnames or IPs hard-coded.  
> - Output one HCL block ready to paste.

---

### 3.6 CPU Monitor (Alert)
**Prompt**
> **Role:** Senior DevOps Terraform.  
> **Task:** Keep existing CPU utilization monitor, or provide an updated `datadog_monitor` for CPU alerting (`avg(last_5m):avg:aws.ec2.cpuutilization{*} > 80`).  
> **Context:** Ensure compatibility with new provider.  
> **Acceptance Criteria:**  
> - No destructive changes.  
> - Output only the monitor resource.

---

### 3.7 Networking & SG Quick-Fix (Front :80, Back :8080)
**Prompt**
> **Role:** Senior DevOps Terraform + Networking.  
> **Task:** Verify/adjust Security Groups:  
> - Frontend SG must allow inbound 80/tcp from `0.0.0.0/0`.  
> - Backend SG must allow inbound 8080/tcp from `0.0.0.0/0` (course context).  
> **Acceptance Criteria:**  
> - Provide minimal HCL changes only, appended to existing SG definitions.  
> - No other ports opened inadvertently.

---

### 3.8 SSM Connectivity Troubleshooting
**Prompt**
> **Role:** SRE Troubleshooting.  
> **Task:** When SSM session hangs or shows `TargetNotConnected`, provide a checklist to:  
> - Confirm current InstanceId via filters/tags.  
> - Ensure `amazon-ssm-agent` is installed, enabled, and IAM role has `AmazonSSMManagedInstanceCore`.  
> - Reconnect using the **current** instance ID.  
> **Output:** A concise step list with AWS CLI examples.

---

### 3.9 AWS CLI on Windows PATH (Chocolatey install)
**Prompt**
> **Role:** Windows DevOps Support.  
> **Task:** If `aws --version` returns “not recognized” after `choco install awscli -y`, provide remediation steps:  
> - Re-open terminal  
> - Verify `C:\Program Files\Amazon\AWSCLIV2\aws.exe`  
> - `setx PATH "$($env:PATH);C:\Program Files\Amazon\AWSCLIV2"`  
> - Reopen terminal and test  
> **Output:** Exact PowerShell commands.

---

### 3.10 Frontend Packaging for Nginx (avoid CRA dev server)
**Prompt**
> **Role:** DevOps Build & Release.  
> **Task:** Provide steps to package frontend as static `build/` + `Dockerfile` (Nginx) instead of CRA dev server.  
> **Acceptance Criteria:**  
> - Show `Dockerfile` contents.  
> - Advise to upload only build artifacts (and verify ZIP with `7z l`).  
> - Keep Terraform intact.

---

### 3.11 Git Hygiene & README
**Prompt**
> **Role:** Senior DevEx.  
> **Task:** Provide a clean commit procedure and a professional README structure.  
> **Acceptance Criteria:**  
> - `.gitignore` for `.terraform`, `*.tfstate`, `node_modules`, `*.zip`, `*.log`.  
> - Commands for `git add`, `commit`, `push`, branch creation, and PR checklist.  
> - README sections: Context, Prereqs, Deployment, Validation, Troubleshooting, Prompts, Delivery.

---

## 4) Execution Checklist (what we actually did)
- [x] Fix AWS CLI PATH on Windows; confirm `aws --version`.
- [x] Configure `AWS_PROFILE=ai4devs`; validate with `aws sts get-caller-identity`.
- [x] Export Datadog env vars (`DD_*`) and map to Terraform (`TF_VAR_*`).
- [x] Update Datadog provider to EU (`api_url`) and modern version.
- [x] Add IAM Role & Policy for Datadog EU assume-role.
- [x] Add `datadog_integration_aws_account` linked to current AWS account.
- [x] Install Datadog Agent in backend EC2 via `user_data`.
- [x] Ensure SGs: frontend :80, backend :8080; NACL/IGW/Routes OK.
- [x] Create CPU monitor and a 3-widget dashboard via Terraform.
- [x] Validate Datadog dashboard + AWS integration page.
- [x] Prepare README with screenshots and delivery instructions.

---

## 5) Troubleshooting Log (issues & fixes)

| Issue | Symptom | Root Cause | Fix |
|---|---|---|---|
| AWS CLI not recognized | `aws` command not found | PATH not updated | `setx PATH "...;C:\Program Files\Amazon\AWSCLIV2"` + new terminal |
| SSM `TargetNotConnected` | Session hangs or fails | Stale InstanceId / agent not ready | List running instances by tag; use current ID; ensure `amazon-ssm-agent` enabled |
| Frontend unreachable | `iwr http://<ip>/` fails | SG missing 80/tcp | Add SG ingress 80/tcp and apply Terraform |
| Backend intermittent | `iwr :8080` fails | `user_data` sequence / container not up yet | Recreate instance, check `docker ps/logs`, ensure `user_data` finishes |
| No metrics in dashboard | Empty charts | Agent not running or EU API URL mismatch | Start agent; confirm `api_url` for EU; verify keys |
| `terraform init` empty dir | Init message | Ran in wrong folder | Run from `tf/` (where `.tf` files live) |
| ZIP artifact issues | Container exits or build errors | Packaged dev project instead of build + Dockerfile | Package only `build/` + Nginx `Dockerfile`; verify with `7z l` |

---

## 6) Validation Commands (used during the exercise)
```powershell
# AWS identity
aws sts get-caller-identity --profile ai4devs

# Terraform deploy
terraform init -upgrade
terraform plan
terraform apply -auto-approve

# Quick reachability checks (PowerShell)
iwr http://<frontend_ip> -UseBasicParsing
iwr http://<backend_ip>:8080/ -UseBasicParsing

# (On instance via SSM) – Datadog agent status
sudo systemctl status datadog-agent
sudo journalctl -u datadog-agent --no-pager | tail -n 100
````

---

## 7) Final Summary

* Provisioned **AWS ↔ Datadog integration** (EU) via Terraform with a dedicated **assumable IAM role**.
* Installed and validated **Datadog Agent** on EC2 (backend).
* Created a **CPU monitor** and a **dashboard** (CPU, memory, load) with Terraform.
* Resolved Windows PATH, networking (SGs), SSM connectivity, packaging, and EU API nuances.
* Produced a clean, reproducible workflow with **prompts**, **checklists**, and **README** suitable for course delivery.

> **Deliverables produced:**
>
> * Terraform changes: provider/iam/main (integration + dashboard + monitor).
> * `README.md` (English) with screenshots and instructions.
> * This prompt log: `prompts/datadog-aws-prompts-ASM.md`.

---

```
::contentReference[oaicite:0]{index=0}
```
