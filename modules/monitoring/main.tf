# modules/monitoring/main.tf

# Creates a Log Analytics Workspace for monitoring and diagnostics
# Stores logs and metrics collected from the VM
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  # This workspace is the central destination for all metrics and logs via DCR.
}

# Enables diagnostic settings on the VM for metrics only
# Logs (like syslog) on Linux must be collected via DCR
resource "azurerm_monitor_diagnostic_setting" "vm_diag" {
  name                       = "${var.prefix}-vm-diag"
  target_resource_id         = var.vm_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  metric {
    category = "AllMetrics"     # Collect all available VM metrics
    retention_policy {          # Optional: controls local retention
      enabled = false
      days    = 0
    }
  }

  depends_on = [azurerm_log_analytics_workspace.law]
}

# Creates a Data Collection Rule (DCR) for syslog monitoring  
# Defines how syslog logs are collected and routed to the Log Analytics Workspace
resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "${var.prefix}-dcr-linux-syslog"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"

  destinations {
    log_analytics {
      name                  = "centralLogAnalyticsWorkspace"
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
    }
  }

  data_sources {
    syslog {
      name           = "LinuxSyslogBase"
      facility_names = ["auth", "cron", "daemon", "syslog"]
      log_levels     = ["Error", "Warning", "Info"]   # Valid levels for Linux syslog
      streams        = ["Microsoft-Syslog"]           # Correct stream name for DCR
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]               # Must match data_sources.streams
    destinations = ["centralLogAnalyticsWorkspace"]   # Must match destinations.name
  }

  depends_on = [azurerm_log_analytics_workspace.law]
}

# Associates the Data Collection Rule with the VM
# Enables syslog ingestion from the VM into the Log Analytics Workspace
resource "azurerm_monitor_data_collection_rule_association" "dcr_assoc" {
  name                    = "${var.prefix}-dcr-assoc"
  target_resource_id      = var.vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id

  depends_on = [azurerm_monitor_data_collection_rule.dcr]
}
