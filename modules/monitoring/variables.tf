# Prefix used to name monitoring resources (e.g., workspace and diagnostic settings)
variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

# Azure region where monitoring resources will be deployed
variable "location" {
  description = "Azure region"
  type        = string
}

# Name of the Resource Group that will contain the monitoring resources
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# ID of the virtual machine to be monitored
# Used to attach diagnostic settings to the correct VM
variable "vm_id" {
  description = "ID of the virtual machine to monitor"
  type        = string
}
