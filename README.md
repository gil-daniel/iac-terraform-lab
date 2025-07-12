# Terraform Azure Lab – Linux VM Provisioning

This project demonstrates how to provision a complete infrastructure on Microsoft Azure using [Terraform](https://www.terraform.io/). It includes the creation of a resource group, virtual network, subnet, network interface, public IP, network security group (NSG), and a Linux virtual machine with NGINX installed automatically via `cloud-init`.

> ✅ This project is fully modularized and uses a remote backend with Azure Storage.  
> 🌐 The VM serves a web page via NGINX on a public IP.  
> 🛠️ It is under continuous development and now includes CI/CD integration via GitHub Actions.

---

## 🚀 What It Does

- Creates a resource group in Azure  
- Provisions a virtual network and subnet (via `network` module)  
- Creates a Network Security Group with rules for SSH (22) and HTTP (80) (via `security` module)  
- Deploys a Linux VM (Ubuntu 22.04 LTS) with public IP and NIC (via `compute` module)  
- Configures SSH access using your public key  
- Installs and starts NGINX using `cloud-init`  
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
├── modules/
│   ├── compute/                # VM, NIC, Public IP
│   ├── network/                # VNet and Subnet
│   └── security/               # NSG and subnet association
├── .gitignore                  # Terraform-specific exclusions
├── README.md                   # Project documentation

```

---

## 🧰 Requirements

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)  
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
- An Azure subscription  
- An existing SSH key pair (e.g. `~/.ssh/id_ed25519.pub`)  

---

## 🛠️ Usage

1. Authenticate with Azure:

   ```bash
   az login
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review the execution plan:
   ```bash
    terraform plan
   ```
4. Apply the configuration 
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

## ⚙️ CI/CD with GitHub Actions

This project includes a GitHub Actions workflow that automates Terraform operations:

## 🔄 What It Does

   * Runs terraform fmt, validate, and plan on every push or pull request

   * Allows manual execution of terraform apply via the Actions tab

   * Uses GitHub Secrets to securely inject sensitive variables

   * Authenticates with Azure using a Service Principal

## 🔐 Required GitHub Secrets

| Secret Name | Description |
| ----------- | ----------- |
|`AZURE_CREDENTIALS`| JSON credentials for Azure login |
|`RESOURCE_GROUP_NAME`| Name of the Resource group |
|`ADMIN_USERNAME`| Username for the VM | 
|`SSH_PUBLIC_KEY_CONTENT`| Content of your SSH Public Key |   
|`SUBSCRIPTION_ID`| Azure Subscription ID |
|`LOCATION`| Azure region (e.g `westeurope`) |

## ▶️ How to Use

   * Push changes to any branch → triggers `terraform plan`

   * Go to Actions → Terraform CI → Run workflow → triggers `terraform apply`

---

## ⚙️ Using the Makefile (optional)

This project includes a `Makefile` to simplify common Terraform commands:
```bash
make init       # Initialize Terraform
make plan       # Show execution plan
make apply      # Apply the configuration
make destroy    # Destroy all resources
make output     # Show output values
make validate   # Validate Terraform files
make format     # Format code with terraform fmt
```
>You can still run Terraform manually if you prefer

---

## 🌐 Outputs

After a successful apply, Terraform will output:

   * vm_private_ip: Internal IP address of the VM

   * vm_public_ip: Public IP address to access the VM via SSH and HTTP

---

## 📦 Modules
| Module | Description|
| ------ | -----------|
| network | Creates VNet and Subnet |
| security| Creates NSG and associates with Subnet |
|compute | Creates Public IP, NIC, and Linux VM |

---

📌 Next Steps

* [x] Add a public IP and NSG to allow SSH/HTTP access
* [x] Install NGINX using cloud-init
* [x] Configure remote backend with Azure Storage
* [x] Modularize the infrastructure (vnet, vm, nsg, etc.)
* [x] Integrate with CI/CD (GitHub Actions or Azure DevOps)
* [ ] Create multiple environments (dev, staging, prod)
* [ ] Add monitoring and alerting with Azure Monitor

---

🧑‍💻 Author

Daniel Gil

---
📄 License

This project is licensed under the MIT License.