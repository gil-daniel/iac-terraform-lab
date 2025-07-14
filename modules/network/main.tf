# Creates a Virtual Network (VNet) to host the infrastructure
# Defines the address space and associates it with the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name              # Name of the VNet
  address_space       = var.address_space          # CIDR block for the VNet
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Creates a Subnet within the VNet
# Used to host the VM and associate with NSG and other resources
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name           # Name of the subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefixes       # CIDR block for the subnet
}
