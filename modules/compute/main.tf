# Creates a public IP address for the VM
# Enables external access to services like NGINX
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"     # IP remains fixed after creation
  sku                 = "Basic"      # Basic tier is sufficient for lab/demo
}

# Creates a network interface and attaches the public IP
# Connects the VM to the subnet and enables external access
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"              # IP assigned automatically
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Provisions a Linux VM with Ubuntu 22.04 LTS
# Uses cloud-init for automated configuration and installs NGINX
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username

  # Encodes and injects the cloud-init script for VM setup
  custom_data           = filebase64(var.cloud_init_path)

  # Attaches the NIC to the VM
  network_interface_ids = [azurerm_network_interface.nic.id]

  # Configures SSH access using the provided public key
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key_content
  }

  # Defines the OS disk settings
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Specifies the Ubuntu image to use for the VM
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  identity {
    type = "SystemAssigned"  # Enables system-assigned managed identity for the VM
  }
}

# Installs the Azure Monitor Agent on the Linux VM
# Enables collection of performance counters via DCR
resource "azurerm_virtual_machine_extension" "monitor_agent" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  depends_on = [azurerm_linux_virtual_machine.vm]
}
resource "azurerm_role_assignment" "dcr_metrics_publisher" {
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
  scope                = var.dcr_id  # Scope is the Data Collection Rule (DCR) ID
  role_definition_name = "Monitoring Metrics Publisher"  # Role that allows publishing metrics
  # This role allows the VM's managed identity to send metrics to the DCR
  # Assigns the VM's managed identity the role to publish metrics to the DCR
  depends_on = [
    azurerm_virtual_machine_extension.monitor_agent, #Ensures the agent is installed before role assignment
    ] 

}