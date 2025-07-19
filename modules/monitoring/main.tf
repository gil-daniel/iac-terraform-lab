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
  metric {
    category = "AllMetrics"
    enabled  = true

    # NEW: retention_policy block controls local metric retention
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  # Optionally, enable collection of Linux syslog via Diagnostic Setting
  # Syslog is a valid log category for Linux VMs
  log {
    category = "Syslog"
    enabled  = true

    # NEW: retention_policy controls local log retention duration
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  # Ensures the workspace is created before applying diagnostics
  depends_on = [azurerm_log_analytics_workspace.law]

  # NEW: uses v3.x syntax (metric/log blocks) instead of deprecated enabled_log
}

# Creates a Data Collection Rule (DCR) for syslog monitoring
# This rule defines how logs are collected and routed to the Log Analytics Workspace
resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "${var.prefix}-dcr-linux-syslog"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"  # Specifies that this DCR is for Linux systems

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id  # Uses the workspace created in this module as the destination for syslog logs
      name                  = "centralLogAnalyticsWorkspace"
    }
  }

  data_sources {
    syslog {
      name           = "LinuxSyslogBase"
      facility_names = ["auth", "cron", "daemon", "syslog"]
      log_levels     = ["Error", "Warning", "Info"]                          # Log levels fix for compatibility
      streams        = ["Microsoft-InsightsSyslog"]                         # Stream fix according to documentation

      # NEW: ensure 'streams' matches exactly the supported DCR stream name
      # NEW: log_levels must be one of the accepted values by Azure DCR schema
    }
  }

  data_flow {
    streams     = ["Microsoft-InsightsSyslog"]                              # Aligned with valid stream name
    destinations = ["centralLogAnalyticsWorkspace"]                         # Destination defined in the destinations block

    # NEW: data_flow ties syslog stream to the Log Analytics destination
  }

  # Ensures the workspace is created before applying the DCR
  depends_on = [azurerm_log_analytics_workspace.law]
}

# Associates the Data Collection Rule with the VM
# This enables syslog collection from the VM to the Log Analytics Workspace
resource "azurerm_monitor_data_collection_rule_association" "dcr_assoc" {
  name                    = "${var.prefix}-dcr-assoc"
  target_resource_id      = var.vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id

  # Ensures the DCR is created before association
  depends_on = [azurerm_monitor_data_collection_rule.dcr]

  # NEW: this association links the Linux VM to the DCR for syslog ingestion
}
