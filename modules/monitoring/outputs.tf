# Outputs the ID of the Log Analytics Workspace
# Useful for referencing in other modules or CLI operations
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}
