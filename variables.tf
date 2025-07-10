variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "admin_username" {
  type        = string
  description = "VM admin username"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key"
}
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}