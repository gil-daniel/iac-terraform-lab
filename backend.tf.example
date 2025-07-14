// backend.tf.example
// This file defines the remote backend configuration for Terraform state storage in Azure.
// Replace the placeholder values with your actual resource names before running `terraform init`.

terraform {
  backend "azurerm" {
    resource_group_name  = "<your-resource-group>"       // e.g. rg-tfstate
    storage_account_name = "<your-storage-account-name>" // e.g. tfstate12345
    container_name       = "<your-container-name>"       // e.g. tfstate
    key                  = "<your-tfstate-key>"          // e.g. terraform.tfstate
  }
}

