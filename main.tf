provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
module "network" {
  source              = "./modules/network"
  vnet_name           = "vnet-iac-lab"
  address_space       = ["10.0.0.0/16"]
  subnet_name         = "subnet-iac-lab"
  subnet_prefixes     = ["10.0.1.0/24"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "security" {
  source              = "./modules/security"
  nsg_name            = "nsg-iac-lab"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id
}

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
}
