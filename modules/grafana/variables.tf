# Resource group where the Grafana VM will be deployed
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

# Azure region for deployment (e.g., westeurope)
variable "location" {
  type        = string
  description = "Azure region"
}

# Admin username for SSH access to the VM
variable "admin_username" {
  type        = string
  description = "Admin username for SSH access"
}

# SSH public key used to access the VM
variable "ssh_public_key" {
  type        = string
  description = "SSH public key content"
}

# Subnet ID where the Grafana VM will be connected
variable "subnet_id" {
  type        = string
  description = "Subnet ID for Grafana NIC"
}
