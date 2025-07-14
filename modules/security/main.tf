# Creates a Network Security Group (NSG) to control inbound traffic
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allows SSH access to the VM (port 22)
  # Useful for remote administration and debugging
  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"       # Accepts any source port
    destination_port_range     = "22"      # SSH port
    source_address_prefix      = "*"       # Accepts traffic from any IP
    destination_address_prefix = "*"       # Applies to all destination IPs
  }

  # Allows HTTP access to the VM (port 80)
  # Enables public access to the NGINX web server
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"      # HTTP port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associates the NSG with the subnet
# Ensures that the defined rules apply to all resources within the subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
