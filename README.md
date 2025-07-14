# 🚀 Terraform Azure Lab: Provisioning a Linux VM with Monitoring & CI/CD
![Terraform CI](https://github.com/gil-daniel/iac-terraform-lab/actions/workflows/terraform.yml/badge.svg)

Welcome to the **Terraform Azure Lab** — a hands-on project that shows how to provision a complete cloud infrastructure on Microsoft Azure using [Terraform](https://www.terraform.io/). This lab sets up a Linux virtual machine with NGINX, full networking, monitoring, and CI/CD integration.

> ✅ **Modularized infrastructure** with remote state storage in Azure Blob Storage  
> 🌐 **Public-facing VM** serving a web page via NGINX  
> 📊 **Built-in monitoring** using Azure Monitor Agent and Data Collection Rules (DCR)  
> ⚙️ **CI/CD automation** via GitHub Actions

---

## 🚀 What It Does

- Creates a resource group in Azure  
- Provisions a virtual network and subnet (`network` module)  
- Creates a Network Security Group with rules for SSH (22) and HTTP (80) (`security` module)  
- Deploys a Linux VM (Ubuntu 22.04 LTS) with public IP and NIC (`compute` module)  
- Configures SSH access using your public key  
- Installs and starts NGINX using `cloud-init`  
- Enables monitoring via Azure Monitor Agent and DCR (`monitoring` module + `null_resource`)  
- Stores Terraform state remotely in Azure Blob Storage  
- Outputs the VM's private and public IP addresses  

---

## 📁 Project Structure

```plaintext
iac-terraform-lab/
├── backend.tf                  # Remote backend configuration (Azure Storage)
├── cloud-init.yaml             # Cloud-init script to install NGINX
├── main.tf                     # Root module calling all submodules
├── outputs.tf                  # Output values from modules
├── variables.tf                # Input variables
├── terraform.tfvars            # Sensitive values (ignored by Git)
├── dcr.json                    # Static Data Collection Rule (ignored by Git)
├── modules/
│   ├── compute/                # VM, NIC, Public IP
│   ├── network/                # VNet and Subnet
│   ├── security/               # NSG and subnet association
│   └── monitoring/             # Log Analytics workspace and diagnostics
├── Makefile                    # CLI shortcuts for Terraform
├── .gitignore                  # Terraform-specific exclusions
├── README.md                   # Project documentation
```
---

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
   * SSH:
    ```bash
    ssh <your-username>@<vm_public_ip>
   ```
   * Web browser: Visit `http://<vm_public_ip>` to see the default NGINX welcome page.

---

## 📊 Monitoring Integration

This project includes built-in observability using **Azure Monitor Agent** and **Log Analytics**.

Monitoring is configured automatically through:

- A static `dcr.json` file that defines syslog collection rules
- A `null_resource` block that:
  - Assigns a managed identity to the VM
  - Creates the **Data Collection Rule (DCR)**
  - Associates the DCR with the VM

📥 Logs are sent to the **Log Analytics Workspace** created by the `monitoring` module.

---

## ⚙️ CI/CD with GitHub Actions

This project includes a GitHub Actions workflow that automates Terraform operations — making infrastructure deployment smoother and safer.

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
| `monitoring`| Sets up Log Analytics Workspace and diagnostic settings for VM monitoring |

---

## 📌 Next Steps

This lab already covers the essentials — but here’s what’s planned or in progress:

* [x] Add a public IP and NSG to allow SSH/HTTP access  
* [x] Install NGINX using cloud-init  
* [x] Configure remote backend with Azure Storage  
* [x] Modularize the infrastructure (vnet, vm, nsg, etc.)  
* [x] Integrate with CI/CD (GitHub Actions or Azure DevOps)  
* [x] Add monitoring and alerting with Azure Monitor  
* [ ] Add alert rules and dashboards (planned Grafana integration)

---

## 🧑‍💻 Author

**Daniel Gil**

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
