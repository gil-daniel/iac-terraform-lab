# Configures the Azure provider and sets the subscription context
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Creates the resource group that will contain all infrastructure components
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Deploys the virtual network and subnet using the network module
module "network" {
  source              = "./modules/network"
  vnet_name           = "vnet-iac-lab"                    # Name of the virtual network
  address_space       = ["10.0.0.0/16"]                   # CIDR block for the VNet
  subnet_name         = "subnet-iac-lab"                  # Name of the subnet
  subnet_prefixes     = ["10.0.1.0/24"]                   # CIDR block for the subnet
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Creates a Network Security Group and associates it with the subnet
module "security" {
  source              = "./modules/security"
  nsg_name            = "nsg-iac-lab"                     # Name of the NSG
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.subnet_id          # Links NSG to the subnet
}

# Provisions a Linux VM with public IP, NIC, and cloud-init configuration
module "compute" {
  source                  = "./modules/compute"
  vm_name                 = "vm-demo"                      # Name of the virtual machine
  vm_size                 = "Standard_B1s"                 # VM size (low-cost for lab)
  admin_username          = var.admin_username            # SSH username
  ssh_public_key_content  = var.ssh_public_key_content    # SSH public key for access
  cloud_init_path         = "cloud-init.yaml"             # Path to cloud-init script
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  subnet_id               = module.network.subnet_id
  public_ip_name          = "public-ip-demo"              # Name of the public IP resource
  nic_name                = "nic-demo"                    # Name of the network interface
}

# Sets up monitoring resources: Log Analytics workspace and diagnostic settings
module "monitoring" {
  source              = "./modules/monitoring"
  prefix              = "lab"                             # Prefix for naming resources
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_id               = module.compute.vm_id              # VM ID used for diagnostics
}

# Assigns a managed identity to the VM and configures Azure Monitor via CLI
# This block uses local-exec to apply a Data Collection Rule (DCR) and associate it with the VM
resource "null_resource" "monitoring_setup" {
  provisioner "local-exec" {
    command = <<EOT
      # Assigns a system-managed identity to the VM
      az vm identity assign \
        --name ${module.compute.vm_name} \
        --resource-group ${azurerm_resource_group.rg.name}

      # Creates a Data Collection Rule for syslog monitoring
      az monitor data-collection rule create \
        --name dcr-linux-syslog \
        --resource-group ${azurerm_resource_group.rg.name} \
        --location ${var.location} \
        --rule-file dcr.json

      # Associates the DCR with the VM to enable log collection
      az monitor data-collection rule association create \
        --name dcrAssoc \
        --rule-id "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Insights/dataCollectionRules/dcr-linux-syslog" \
        --resource "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Compute/virtualMachines/${module.compute.vm_name}"
    EOT
  }

  # Ensures monitoring setup runs only after VM and monitoring resources are ready
  depends_on = [module.compute, module.monitoring]
}
