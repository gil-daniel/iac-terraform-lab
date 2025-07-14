# Creates a Log Analytics Workspace for monitoring and diagnostics
# Stores logs and metrics collected from the VM
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"           # Workspace name with prefix
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"                   # Pay-as-you-go pricing model
  retention_in_days   = 30                            # Retains logs for 30 days
}

# Enables diagnostic settings on the VM
# Sends metrics and logs to the Log Analytics Workspace
resource "azurerm_monitor_diagnostic_setting" "vm_diag" {
  name                       = "${var.prefix}-vm-diag" # Diagnostic setting name
  target_resource_id         = var.vm_id               # VM to be monitored
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # Enables collection of all available metrics
  enabled_metric {
    category = "AllMetrics"
  }

  # Ensures the workspace is created before applying diagnostics
  depends_on = [azurerm_log_analytics_workspace.law]
}
