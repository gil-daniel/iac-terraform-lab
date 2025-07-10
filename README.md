# Terraform Azure Lab – Linux VM Provisioning

This project demonstrates how to provision a basic infrastructure on Microsoft Azure using [Terraform](https://www.terraform.io/). It includes the creation of a resource group, virtual network, subnet, network interface, and a Linux virtual machine with SSH access.

> ⚠️ This project is under active development and will be expanded with additional features such as public IP, NSG, cloud-init provisioning, and remote state backend.

---

## 🚀 What It Does

- Creates a resource group in Azure
- Provisions a virtual network and subnet
- Deploys a Linux VM (Ubuntu 22.04 LTS)
- Configures SSH access using your public key
- Outputs the VM's private IP address

---

## 📁 Project Structure

```plaintext
iac-terraform-lab/
├── main.tf                    # Main infrastructure definition
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── terraform.tfvars           # Variable values (excluded from Git)
├── .gitignore                 # Terraform specific exclusions
├── README.md                  # Project documentation
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

---

📌 Next Steps

*   Add a public IP and NSG to allow SSH/HTTP access
*   Install NGINX using cloud-init
*   Configure remote backend with Azure Storage
*   Modularize the infrastructure

---
🧑‍💻 Author

Daniel Gil github.com/gil-daniel

---
📄 License

This project is licensed under the MIT License.