# 🖥️ Compute Module

This module provisions a Linux virtual machine in Azure, along with its supporting resources: public IP, network interface, and cloud-init configuration.

---

## 📦 Resources Created

- `azurerm_public_ip` – Static public IP address  
- `azurerm_network_interface` – NIC attached to the subnet  
- `azurerm_linux_virtual_machine` – Ubuntu VM with SSH and cloud-init  

---

## 📥 Input Variables

| Name                  | Type     | Description                                      | Required |
|-----------------------|----------|--------------------------------------------------|----------|
| `vm_name`             | string   | Name of the virtual machine                      | ✅ Yes   |
| `vm_size`             | string   | Azure VM size (e.g., `Standard_B1s`)             | ✅ Yes   |
| `admin_username`      | string   | Admin username for the VM                        | ✅ Yes   |
| `ssh_public_key_path` | string   | Path to your SSH public key                      | ✅ Yes   |
| `cloud_init_path`     | string   | Path to the cloud-init YAML file                 | ✅ Yes   |
| `location`            | string   | Azure region                                     | ✅ Yes   |
| `resource_group_name` | string   | Name of the resource group                       | ✅ Yes   |
| `subnet_id`           | string   | ID of the subnet where the NIC will be attached  | ✅ Yes   |
| `public_ip_name`      | string   | Name of the public IP resource                   | ✅ Yes   |
| `nic_name`            | string   | Name of the network interface                    | ✅ Yes   |

---

## 📤 Outputs

| Name            | Description                          |
|-----------------|--------------------------------------|
| `vm_public_ip`  | Public IP address of the VM          |
| `vm_private_ip` | Private IP address of the VM         |

---

## 🧪 Example Usage

```hcl
module "compute" {
  source                = "./modules/compute"
  vm_name               = "vm-demo"
  vm_size               = "Standard_B1s"
  admin_username        = var.admin_username
  ssh_public_key_path   = var.ssh_public_key_path
  cloud_init_path       = "cloud-init.yaml"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  subnet_id             = module.network.subnet_id
  public_ip_name        = "public-ip-demo"
  nic_name              = "nic-demo"
}
```
---
## ⚙️ Notes
* The VM is provisioned with Ubuntu 22.04 LTS
* NGINX is installed and started via `cloud-init`
* SSH access is enabled using your provided public key
---
## 🧑‍💻 Author

Daniel Gil