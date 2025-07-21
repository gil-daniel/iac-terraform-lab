# Outputs the ID of the Log Analytics Workspace
# Useful for referencing in other modules or CLI operations
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}
# Outputs the ID of the Data Collection Rule (DCR)
output "dcr_id" {
  description = "ID of the Data Collection Rule for performance counters"
  value       = azurerm_monitor_data_collection_rule.dcr.id
}
