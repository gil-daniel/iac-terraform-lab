# Name of the Virtual Network to be created
variable "vnet_name" {}

# CIDR block defining the address space of the VNet
# Example: ["10.0.0.0/16"]
variable "address_space" {}

# Name of the subnet within the VNet
variable "subnet_name" {}

# CIDR block for the subnet
# Example: ["10.0.1.0/24"]
variable "subnet_prefixes" {}

# Azure region where the network resources will be deployed
variable "location" {}

# Name of the Resource Group that will contain the network resources
variable "resource_group_name" {}
