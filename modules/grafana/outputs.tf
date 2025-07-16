# Public IP address of the Grafana VM
output "grafana_public_ip" {
  description = "Public IP address of the Grafana VM"
  value       = azurerm_public_ip.grafana_ip.ip_address
}
