# 🔐 Security Module

This module provisions a Network Security Group (NSG) with default inbound rules for SSH and HTTP, and can optionally associate it with a subnet.

---

## 📦 Resources Created

- `azurerm_network_security_group` – Defines inbound rules for ports 22 (SSH) and 80 (HTTP)  
- `azurerm_subnet_network_security_group_association` – Binds the NSG to a subnet **if enabled**

---

## 📥 Input Variables

| Name                   | Type   | Description                                                | Required |
|------------------------|--------|------------------------------------------------------------|----------|
| `nsg_name`             | string | Name of the Network Security Group                         | ✅ Yes   |
| `location`             | string | Azure region                                               | ✅ Yes   |
| `resource_group_name`  | string | Name of the resource group                                 | ✅ Yes   |
| `subnet_id`            | string | ID of the subnet for optional association with the NSG     | ✅ Yes   |
| `associate_with_subnet`| bool   | Whether to associate the NSG with the specified subnet      | ❌ No    |

---

## 🔐 Default Rules

This module creates two inbound rules:

- **Allow SSH (port 22)** from any source  
- **Allow HTTP (port 80)** from any source  

Priorities (`1001` and `1002`) are chosen to avoid conflicts with common policies or other custom NSGs.

---

## 📤 Outputs

| Name     | Description                                     |
|----------|-------------------------------------------------|
| `nsg_id` | ID of the created Network Security Group         |

---

## 🧪 Example Usage

```hcl
module "security" {
  source                 = "./modules/security"
  nsg_name               = "nsg-iac-lab"
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg.name
  subnet_id              = module.network.subnet_id
  associate_with_subnet  = true
}
```
---

## ⚙️ Notes

- The NSG allows SSH (port 22) and HTTP (port 80) access from any IP
- It's recommended to customize source address prefixes for stricter security
- NSG can be attached to a subnet or directly to NICs depending on architecture
- Rules follow custom priorities to ensure predictable evaluation order

---
## 🧑‍💻 Author

Daniel Gil