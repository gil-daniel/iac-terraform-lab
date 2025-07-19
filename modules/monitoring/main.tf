# modules/monitoring/main.tf

# Creates a Log Analytics Workspace for monitoring and diagnostics
# Stores logs and metrics collected from the VM
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  # This workspace serves as the central destination for metrics and logs via DCR.
}

# Enables diagnostic settings on the VM for metrics only
# Sends metrics to the Log Analytics Workspace
resource "azurerm_monitor_diagnostic_setting" "vm_diag" {
  name                       = "${var.prefix}-vm-diag"
  target_resource_id         = var.vm_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # Collect all available metrics
  enabled_metric {
    category = "AllMetrics"
    enabled  = true
  }

  # Note: Syslog logs are handled via the Data Collection Rule; no 'log' block is defined here.

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
      log_levels     = ["Error", "Warning", "Informational"]  # Use 'Informational' instead of 'Info'
      streams        = ["Microsoft-Syslog"]                  # Valid stream name for syslog

      # Ensure 'streams' matches the supported DCR stream name.
      # log_levels must be one of the accepted values by the Azure DCR schema.
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]                    # Matches data_sources.streams
    destinations = ["centralLogAnalyticsWorkspace"]         # Matches destinations.name

    # Data flow ties the Syslog stream to the Log Analytics destination.
  }

  depends_on = [azurerm_log_analytics_workspace.law]
}

# Associates the Data Collection Rule with the VM
# Enables syslog ingestion from the VM into the DCR
resource "azurerm_monitor_data_collection_rule_association" "dcr_assoc" {
  name                    = "${var.prefix}-dcr-assoc"
  target_resource_id      = var.vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id

  depends_on = [azurerm_monitor_data_collection_rule.dcr]
}
