# Outputs the name of the Virtual Network
# Useful for referencing or logging purposes
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

# Outputs the ID of the subnet
# Required for associating resources like NSGs or NICs
output "subnet_id" {
  value = azurerm_subnet.subnet.id
}
