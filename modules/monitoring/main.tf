resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "vm_diag" {
  name                       = "${var.prefix}-vm-diag"
  target_resource_id         = var.vm_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_log_analytics_workspace.law]
}

