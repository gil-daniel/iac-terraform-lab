# Exposes the private IP address of the VM
# Useful for internal communication or debugging within the virtual network
output "vm_private_ip" {
  value = module.compute.vm_private_ip
}

# Exposes the public IP address of the VM
# Allows external access to the NGINX web server deployed on the VM
output "vm_public_ip" {
  value = module.compute.vm_public_ip
}
