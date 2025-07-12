variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vm_id" {
  description = "ID of the virtual machine to monitor"
  type        = string
}
