# Name of the Resource Group used for lab infrastructure
# This group will contain all resources provisioned by Terraform
variable "resource_group_name" {
  type        = string
  description = "Resource Group name for lab infrastructure"
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
# Required for provider configuration and CLI-based operations
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

# Used to configure syslog monitoring via Data Collection Rule (DCR)
# This should be the full Azure resource ID of an existing Log Analytics Workspace
# Example format: /subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>
variable "workspace_resource_id" {
  type        = string
  description = "Full Azure resource ID of the Log Analytics Workspace"
}

