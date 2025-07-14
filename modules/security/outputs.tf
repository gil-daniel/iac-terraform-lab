# Outputs the ID of the Network Security Group
# Useful for referencing in other modules or diagnostics
output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}
