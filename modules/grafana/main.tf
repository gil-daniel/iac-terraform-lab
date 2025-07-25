# Create a public IP address for the Grafana VM
resource "azurerm_public_ip" "grafana_ip" {
  name                = "grafana-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"
}

# Create a network interface and attach the public IP
resource "azurerm_network_interface" "grafana_nic" {
  name                = "grafana-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "grafana-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.grafana_ip.id
  }
}

# Provision a Linux VM and install Grafana using cloud-init
resource "azurerm_linux_virtual_machine" "grafana_vm" {
# Ensure NSG is attached before VM boots and cloud-init runs
  depends_on = [
  azurerm_network_interface_security_group_association.grafana_nic_nsg
]
  name                = "grafana-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.grafana_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Load the cloud-init script to install and start Grafana
  custom_data = filebase64("${path.module}/cloud-init.yaml")
}

# Create a Network Security Group for the Grafana VM
resource "azurerm_network_security_group" "grafana_nsg" {
  name                = "grafana-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Allow inbound SSH access on port 22
resource "azurerm_network_security_rule" "grafana_ssh" {
  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"                          # Allow from any IP (can be restricted later)
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.grafana_nsg.name
}

# Allow inbound traffic on port 3000 (Grafana web UI)
resource "azurerm_network_security_rule" "grafana_port" {
  name                        = "AllowGrafanaPort"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3000"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.grafana_nsg.name
}

# Associate the NSG with the Grafana NIC
resource "azurerm_network_interface_security_group_association" "grafana_nic_nsg" {
  network_interface_id      = azurerm_network_interface.grafana_nic.id
  network_security_group_id = azurerm_network_security_group.grafana_nsg.id
}

# Installs the Azure Monitor Agent on the Grafana VM
# Enables collection of CPU and memory performance counters via DCR
resource "azurerm_virtual_machine_extension" "monitor_agent_grafana" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.grafana_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  depends_on = [azurerm_linux_virtual_machine.grafana_vm]
}