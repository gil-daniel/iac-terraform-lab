# 🖥️ Compute Module

This module provisions a Linux virtual machine in Azure along with its required resources: public IP, NIC, cloud-init configuration, and integration with monitoring.

---

## 📦 Resources Created

- `azurerm_public_ip` – Static public IP address for external access  
- `azurerm_network_interface` – NIC connected to subnet and linked to public IP  
- `azurerm_linux_virtual_machine` – Ubuntu VM (22.04 LTS) with SSH access and cloud-init  
- `azurerm_virtual_machine_extension` – Installs Azure Monitor Agent (AMA)  
- System-assigned Managed Identity – Enables secure integration with Azure services

---

## 📥 Input Variables

| Name                    | Type     | Description                                                  | Required |
|-------------------------|----------|--------------------------------------------------------------|----------|
| `vm_name`               | string   | Name of the virtual machine                                  | ✅ Yes   |
| `vm_size`               | string   | Azure VM size (e.g., `Standard_B1s`)                         | ✅ Yes   |
| `admin_username`        | string   | Admin username for SSH access                                | ✅ Yes   |
| `ssh_public_key_content`| string   | Content of your SSH public key                               | ✅ Yes   |
| `cloud_init_path`       | string   | Path to the cloud-init YAML file used to configure the VM    | ✅ Yes   |
| `location`              | string   | Azure region for deployment                                  | ✅ Yes   |
| `resource_group_name`   | string   | Resource group that holds the VM                             | ✅ Yes   |
| `subnet_id`             | string   | ID of the subnet where the NIC will be attached              | ✅ Yes   |
| `public_ip_name`        | string   | Name of the public IP resource                               | ✅ Yes   |
| `nic_name`              | string   | Name of the network interface                                | ✅ Yes   |
| `dcr_id`                | string   | ID of the Data Collection Rule (used to grant AMA access)    | ✅ Yes   |

---

## 📤 Outputs

| Name               | Description                                        |
|--------------------|----------------------------------------------------|
| `vm_private_ip`    | Internal IP address of the VM                      |
| `vm_public_ip`     | Public IP address for SSH and HTTP access          |
| `vm_id`            | Unique ID of the VM (used in monitoring module)    |
| `vm_name`          | Name of the VM                                     |
| `vm_principal_id`  | Principal ID of the VM’s system-assigned identity  |

---

## 🧪 Example Usage

```hcl
module "compute" {
  source                  = "./modules/compute"
  vm_name                 = "vm-demo"
  vm_size                 = "Standard_B1s"
  admin_username          = var.admin_username
  ssh_public_key_content  = var.ssh_public_key_content
  cloud_init_path         = "cloud-init.yaml"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  subnet_id               = module.network.subnet_id
  public_ip_name          = "public-ip-demo"
  nic_name                = "nic-demo"
  dcr_id                  = module.monitoring.dcr_id
}
```
---

## ⚙️ Notes
- The VM runs Ubuntu 22.04 LTS and is auto-configured via cloud-init
- NGINX is installed and started as part of VM initialization
- Azure Monitor Agent is installed to support performance and syslog collection
- Managed identity is enabled for future integration with services like Key Vault or Azure Monitor

---

## 🧑‍💻 Author

Daniel Gil