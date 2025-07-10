# 🔐 Security Module

This module provisions a Network Security Group (NSG) and associates it with a subnet in Microsoft Azure.

---

## 📦 Resources Created

- `azurerm_network_security_group` – Defines inbound security rules  
- `azurerm_subnet_network_security_group_association` – Binds the NSG to a subnet  

---

## 📥 Input Variables

| Name                  | Type     | Description                          | Required |
|-----------------------|----------|--------------------------------------|----------|
| `nsg_name`            | string   | Name of the Network Security Group   | ✅ Yes   |
| `location`            | string   | Azure region                         | ✅ Yes   |
| `resource_group_name` | string   | Name of the resource group           | ✅ Yes   |
| `subnet_id`           | string   | ID of the subnet to associate NSG    | ✅ Yes   |

---

## 🔐 Default Rules

This module creates two inbound rules:

- **Allow SSH (port 22)** from any source  
- **Allow HTTP (port 80)** from any source  

---

## 📤 Outputs

| Name     | Description                          |
|----------|--------------------------------------|
| `nsg_id` | The ID of the created NSG            |

---

## 🧪 Example Usage

```hcl
module "security" {
  source              = "./modules/security"
  nsg_name            = "nsg-iac-lab"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id
}
```
---
## 🧑‍💻 Author

Daniel Gil