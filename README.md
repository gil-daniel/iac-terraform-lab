# 🚀 Terraform Azure Lab: Provisioning a Linux VM with Monitoring, Grafana Dashboards & CI/CD
![Terraform CI](https://github.com/gil-daniel/iac-terraform-lab/actions/workflows/terraform.yml/badge.svg)

Welcome to the **Terraform Azure Lab** — a hands-on project that shows how to provision a complete cloud infrastructure on Microsoft Azure using [Terraform](https://www.terraform.io/). This lab sets up two Linux virtual machines: one running NGINX, and another with Grafana for observability — including built-in dashboards exported as JSON templates.

> ✅ **Modularized infrastructure** with remote state storage in Azure Blob Storage  
> 🌐 **Public-facing VM** serving a web page via NGINX  
> 📊 **Built-in monitoring and dashboards** using Azure Monitor Agent, Log Analytics, and Grafana  
> ⚙️ **CI/CD automation** via GitHub Actions

---

## 🚀 What It Does

- Creates a resource group in Azure  
- Provisions a virtual network and subnet (`network` module)  
- Creates a Network Security Group with rules for SSH (22), HTTP (80), and Grafana (3000) (`security` module)  
- Deploys two Linux VMs (Ubuntu 22.04 LTS): one for NGINX (`compute` module) and one for Grafana (`grafana` module)  
- Installs and configures Grafana via cloud-init, accessible on port 3000  
- Installs NGINX and binds to public IP  
- Enables monitoring via Azure Monitor Agent and a Terraform-managed Data Collection Rule (`monitoring` module)  
- Stores Terraform state remotely in Azure Blob Storage  
- Displays both VM’s private and public IP addresses


---

## 📁 Project Structure

```plaintext
iac-terraform-lab/
├── backend.tf                  # Remote backend configuration (generated dynamically)
├── cloud-init.yaml             # Cloud-init script to install NGINX
├── main.tf                     # Root module calling all submodules
├── outputs.tf                  # Output values from modules
├── variables.tf                # Input variables
├── terraform.tfvars            # Sensitive values (ignored by Git)
├── modules/
│   ├── compute/                # VM, NIC, Public IP for NGINX
│   ├── grafana/                # Dedicated VM with Grafana and NSG
│   ├── monitoring/             # Log Analytics workspace, diagnostics, and DCR
│   ├── network/                # VNet and Subnet
│   └── security/               # NSG and optional subnet association
├── Makefile                    # CLI shortcuts for Terraform
├── .gitignore                  # Terraform-specific exclusions
├── README.md                   # Project documentation

```
---

## 📈 Grafana Dashboards (v1.2.0)
Starting from version `v1.2.0`, the project includes two dashboard templates for real-time monitoring and log analytics:
| Dashboard Template       | Description                              |
|--------------------------|------------------------------------------|
| `vm-demo-dashboard-template.json`| VM performance metrics (CPU, memory, disk, network) | 
| `lab-law-logs-dashboard-template.json` | Log Analytic via KQL with heartbeat and syslog insights |

 Available inside `modules/grafana` 📷 Screenshots in `modules/grafana/screenshots`

 >⚠️ Production dashboards with real identifiers are excluded via .gitignore

## 🧰 Requirements

Before you get started, make sure you have the following tools and access:

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) – for provisioning infrastructure  
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) – to authenticate and manage Azure resources  
- An active Azure subscription  
- An existing SSH key pair (e.g. `~/.ssh/id_ed25519.pub`) – used for secure access to the VM

---

## 🛠️ Usage

1. **Authenticate with Azure:**

   ```bash
   az login
   ```
2. **Initialize Terraform** Set up the working directory and download required providers:
   ```bash
   terraform init
   ```
3. **Review the execution plan** See what Terraform will do before applying changes:
   ```bash
    terraform plan
   ```
4. **Apply the configuration** Provision the infrastructure:
   ```bash
   terraform apply
   ```
5. After deployment, access the VM:
   * **SSH:**
    ```bash
    ssh <your-username>@<vm_public_ip>
   ```
   * **Web browser:**  
   Visit `http://<vm_public_ip>` to see the default NGINX welcome page.

---

## 📊 Monitoring Integration

This project includes built-in observability using **Azure Monitor Agent** and **Log Analytics**.

Monitoring is configured automatically through:

- A Terraform-managed Data Collection Rule (DCR) that defines syslog collection
- An association between the VM and the DCR
- A **Log Analytics Workspace** created within the `monitoring` module

📥 Logs are sent to the workspace and can be queried via Azure Monitor or Kusto.

---
## 🔄 How Monitoring Works

- Azure Monitor Agent (AMA) is installed on the VM
- AMA downloads the Data Collection Rule (DCR) via the Data Collection Endpoint (DCE)
- The DCR defines which syslog facilities and performance counters to collect
- AMA sends logs and metrics to the Log Analytics Workspace
- You can query the data using KQL or visualize it in Grafana
---
## ⚙️ CI/CD with GitHub Actions

This project includes a GitHub Actions workflow that automates Terraform operations, making infrastructure deployment smoother and safer.

### 🔄 CI/CD Workflow Overview

- Runs `terraform fmt`, `validate`, and `plan` on every push or pull request  
- Allows manual execution of `terraform apply` via the Actions tab  
- Uses **GitHub Secrets** to securely inject sensitive variables  
- Authenticates with Azure using a **Service Principal**

---

## 🔐 Required GitHub Secrets

To enable secure and automated deployments via GitHub Actions, you'll need to configure the following secrets in your repository settings:

| Secret Name              | Description                              |
|--------------------------|------------------------------------------|
| `AZURE_CREDENTIALS`      | JSON credentials for Azure login (Service Principal) |
| `AZURE_TENANT_KEY`       | Your Azure Tenant Key                    |
| `BACKEND_RG_NAME`        | Resource Group that contains the backend storage|
| `STORAGE_ACCOUNT_NAME`   | Azure Storage Account Name for remote state |
| `RESOURCE_GROUP_NAME`    | Name of the resource group to deploy into |
| `ADMIN_USERNAME`         | Username for SSH access to the VM         |
| `SSH_PUBLIC_KEY_CONTENT` | Content of your SSH public key            |
| `SUBSCRIPTION_ID`        | Your Azure Subscription ID                |
| `LOCATION`               | Azure region (e.g. `westeurope`)          |

## ▶️ How to Use

Once your GitHub Secrets are configured, here’s how the CI/CD workflow behaves:

- **Push changes to any branch** → automatically runs `terraform plan`  
- **Manual trigger via Actions tab** → runs `terraform apply` on demand

This setup ensures safe, traceable infrastructure changes with minimal manual effort.

---

## ⚙️ Using the Makefile (optional)

To streamline your workflow, this project includes a `Makefile` with shortcuts for common Terraform commands:

```bash
make init       # Initialize Terraform
make plan       # Show execution plan
make apply      # Apply the configuration
make destroy    # Destroy all resources
make output     # Show output values
make validate   # Validate Terraform files
make format     # Format code with terraform fmt
```
>You can still run Terraform manually if you prefer, the Makefile just makes things faster and cleaner.

---

## 🌐 Outputs

After a successful `terraform apply`, you'll see the following output values — useful for accessing and managing your VM:

| Output Name     | Description                              |
|-----------------|------------------------------------------|
| `grafana_public_ip`| Public address of Grafana, accessible via port 3000 |
| `vm_private_ip` | Internal IP address of the VM            |
| `vm_public_ip`  | Public IP address for SSH and HTTP access |

---

## 📦 Modules

This project is fully modularized for clarity and reusability. Each module handles a specific part of the infrastructure:

| Module      | Description                                         |
|-------------|-----------------------------------------------------|
| `network`   | Creates the Virtual Network (VNet) and Subnet       |
| `security`  | Creates the Network Security Group (NSG) and associates it with the Subnet |
| `compute`   | Provisions the Public IP, Network Interface (NIC), and Linux VM |
| `monitoring`| Sets up Log Analytics Workspace, diagnostic settings and DCR for syslog monitoring |
| `grafana`   | Provisions a dedicated VM with Grafana installed and exposed via port 3000 |

---

## 📌 Next Steps

Project goals already covered ✅ But if you want to explore further:
- Automated dashboard provisioning
- Alerts via Grafana
- Integrate container monitoring
- Expand with Ansible or Kubernetes (coming soon!)

---

## 🛡️ Security Notice

> ⚠️ On **2025-07-14**, the Git history of this repository was rewritten to permanently remove a previously committed `backend.tf` file.  
> This was done to protect infrastructure details and follow best practices for open source projects.  
> If you cloned this repository before that date, it's recommended to do a fresh clone to avoid inconsistencies:

```bash
git clone git@github.com:gil-daniel/iac-terraform-lab.git
```
---

## 🧑‍💻 Author

**Daniel Gil**

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
