# 📊 Grafana Module

This module provisions a Linux VM running Grafana using `cloud-init`, and exposes it publicly on port `3000`. It also installs the Azure Monitor Agent to collect performance metrics via DCR.

---

## 📦 Resources Created

- `azurerm_public_ip` – Static public IP address for external access  
- `azurerm_network_interface` – NIC linked to subnet and public IP  
- `azurerm_network_security_group` – NSG with rules for SSH and Grafana  
- `azurerm_network_security_rule` – Allows inbound traffic on ports `22` and `3000`  
- `azurerm_network_interface_security_group_association` – Binds NSG to NIC  
- `azurerm_linux_virtual_machine` – Ubuntu VM with Grafana installed via cloud-init  
- `azurerm_virtual_machine_extension` – Installs Azure Monitor Agent (AMA)

---

## 📥 Input Variables

| Name                  | Type    | Description                                      | Required |
|-----------------------|---------|--------------------------------------------------|----------|
| `resource_group_name` | string  | Name of the resource group                       | ✅ Yes   |
| `location`            | string  | Azure region for deployment                      | ✅ Yes   |
| `admin_username`      | string  | SSH username to access the VM                    | ✅ Yes   |
| `ssh_public_key`      | string  | Public key content for secure SSH access         | ✅ Yes   |
| `subnet_id`           | string  | Subnet ID used to connect the NIC                | ✅ Yes   |

---

## 📤 Outputs

| Name               | Description                                      |
|--------------------|--------------------------------------------------|
| `grafana_public_ip`| Public IP address of the Grafana VM              |

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
- The VM runs Ubuntu 22.04 LTS
- Grafana is installed via cloud-init using the official APT repository
- Custom configuration is injected into `/etc/grafana/grafana.ini` to bind it to port `3000` and `0.0.0.0`
- Port `3000` is exposed via NSG for external access to the Grafana dashboard
- Azure Monitor Agent is installed to enable VM performance collection (via DCR in the `monitoring` module)
- SSH access is enabled using your provided public key

---

## 🧑‍💻 Author

Daniel Gil