# 📊 Grafana Module

This module provisions a Linux virtual machine with Grafana installed and exposed via port 3000. It includes supporting resources such as a public IP, NIC, NSG, and automated setup using cloud-init.

---

## 📦 Resources Created

- `azurerm_public_ip` – Static public IP address  
- `azurerm_network_interface` – NIC attached to the subnet  
- `azurerm_network_security_group` – NSG with rules for SSH and Grafana  
- `azurerm_linux_virtual_machine` – Ubuntu VM with Grafana installed via cloud-init  
- `azurerm_network_interface_security_group_association` – NSG bound to NIC

---

## 📥 Input Variables

| Name                  | Type     | Description                                      | Required |
|-----------------------|----------|--------------------------------------------------|----------|
| `admin_username`      | string   | Admin username for the VM                        | ✅ Yes   |
| `ssh_public_key`      | string   | SSH public key content                           | ✅ Yes   |
| `location`            | string   | Azure region                                     | ✅ Yes   |
| `resource_group_name` | string   | Name of the resource group                       | ✅ Yes   |
| `subnet_id`           | string   | ID of the subnet where the NIC will be attached  | ✅ Yes   |

---

## 📤 Outputs

| Name               | Description                          |
|--------------------|--------------------------------------|
| `grafana_vm_id`    | ID of the Grafana VM                 |
| `grafana_public_ip`| Public IP address of the Grafana VM  |

---

## 🧪 Example Usage

```hcl
module "grafana" {
  source              = "./modules/grafana"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key_content
  subnet_id           = module.network.subnet_id
}
```

---

## ⚙️ Notes

- The VM is provisioned with Ubuntu 22.04 LTS
- Grafana is installed and configured via cloud-init
- Port 3000 is exposed for external access to the Grafana web UI
- NSG is applied directly to the NIC to avoid subnet-level conflicts
- SSH access is enabled using your provided public key