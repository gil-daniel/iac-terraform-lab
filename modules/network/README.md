# 📡 Network Module

This module provisions a Virtual Network (VNet) and a Subnet in Microsoft Azure.

---

## 📦 Resources Created

- `azurerm_virtual_network` – Azure Virtual Network  
- `azurerm_subnet` – Subnet within the VNet  

---

## 📥 Input Variables

| Name                  | Type     | Description                          | Required |
|-----------------------|----------|--------------------------------------|----------|
| `vnet_name`           | string   | Name of the virtual network          | ✅ Yes   |
| `address_space`       | list     | Address space for the VNet           | ✅ Yes   |
| `subnet_name`         | string   | Name of the subnet                   | ✅ Yes   |
| `subnet_prefixes`     | list     | Address prefixes for the subnet      | ✅ Yes   |
| `location`            | string   | Azure region                         | ✅ Yes   |
| `resource_group_name` | string   | Name of the resource group           | ✅ Yes   |

---

## 📤 Outputs

| Name         | Description                          |
|--------------|--------------------------------------|
| `vnet_name`  | The name of the created VNet         |
| `subnet_id`  | The ID of the created subnet         |

---

## 🧪 Example Usage

```hcl
module "network" {
  source              = "./modules/network"
  vnet_name           = "vnet-iac-lab"
  address_space       = ["10.0.0.0/16"]
  subnet_name         = "subnet-iac-lab"
  subnet_prefixes     = ["10.0.1.0/24"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}
```
---
## 🧑‍💻 Author

Daniel Gil