# Splunk UF Auto-Install Script ( Linux Version )

### What This Script Does:
This script automates the installation and configuration of **Splunk Universal Forwarder (UF)**. 
It includes:
✅ Installing and configuring `auditd`  
✅ Replacing `audit.rules` file  
✅ Installing Splunk UF and setting up necessary configurations  
✅ Applying `inputs.conf` and `outputs.conf` settings  
✅ Deploying `Splunk_TA_NIX` app (TGZ format)  
✅ Starting and verifying Splunk UF  

## 📌 **Prerequisites**
Before running the script, ensure you have:
- A **Linux server** (Debian/Ubuntu, CentOS, or RHEL)
- **Splunk Universal Forwarder (UF)** package (`splunkforwarder-<version>.tgz`)
- **Audit rules file (`audit.rules.txt`)**
- **Splunk TA for Unix & Linux (`Splunk_TA_NIX.tgz`)**


📌 **Ensure all required files are inside `/opt/Script_test/data/` before executing the script.**
---
## 🔹 **Step 1: Download Splunk Universal Forwarder**
1. Visit [Splunk's official website]
2. Download the **Linux `.tgz` package** for Splunk UF
3. Move the downloaded file into `/opt/Script_test/data/`
---
## 🔹 **Step 2: Set Up Required Directory**
Create the directory structure using:
```bash
sudo mkdir -p /opt/Script_test/data
