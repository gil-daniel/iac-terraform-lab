# Outputs the private IP address of the VM
# Useful for internal communication within the virtual network
output "vm_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}

# Outputs the public IP address of the VM
# Enables external access to services running on the VM
output "vm_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

# Outputs the unique ID of the VM
# Can be used for monitoring, tagging, or resource associations
output "vm_id" {
  description = "The ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

# Outputs the name of the VM
# Useful for logging or referencing in other modules
output "vm_name" {
  description = "The name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

# Outputs the resource group name where the VM is located
output "vm_principal_id" {
  description = "The principal ID of the VM's system-assigned identity"
  value       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}
