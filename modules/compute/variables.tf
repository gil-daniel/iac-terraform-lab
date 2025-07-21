# Name of the virtual machine to be created
variable "vm_name" {}

# Size of the VM (e.g., Standard_B1s for low-cost lab usage)
variable "vm_size" {}

# Username used for SSH access to the VM
variable "admin_username" {}

# SSH public key content used to configure secure access
# Typically generated via ssh-keygen
variable "ssh_public_key_content" {}

# Path to the cloud-init configuration file
# Used to automate VM setup (e.g., install NGINX)
variable "cloud_init_path" {}

# Azure region where the VM and related resources will be deployed
variable "location" {}

# Name of the Resource Group that will contain the VM
variable "resource_group_name" {}

# ID of the subnet where the VM will be placed
variable "subnet_id" {}

# Name of the public IP resource attached to the VM
variable "public_ip_name" {}

# Name of the network interface attached to the VM
variable "nic_name" {}

# ID of the VM, used for monitoring and diagnostics
variable "dcr_id" {
  description = "ID of the Azure Monitor Data Collection Rule to grant VM access"
  type        = string
}
