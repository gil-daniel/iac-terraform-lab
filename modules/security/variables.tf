# Name of the Network Security Group to be created
variable "nsg_name" {}

# Azure region where the NSG will be deployed
variable "location" {}

# Name of the Resource Group that will contain the NSG
variable "resource_group_name" {}

# ID of the subnet to associate with the NSG
# Ensures that security rules apply to resources within the subnet
variable "subnet_id" {}
