# Name of the Resource Group where all resources will be deployed
variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

# Azure region used for resource deployment
# Default is set to West Europe for lab purposes
variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

# Username for SSH access to the virtual machine
# Used during VM provisioning
variable "admin_username" {
  type        = string
  description = "VM admin username"
}

# SSH public key content used to configure secure access to the VM
# Typically generated via ssh-keygen
variable "ssh_public_key_content" {
  type        = string
  description = "Content of the SSH public key"
}

# Azure Subscription ID used to scope resource creation
# Required for CLI-based operations and monitoring setup
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}
