# 📊 Monitoring Module

This module provisions the full monitoring pipeline for a Linux virtual machine in Azure using Azure Monitor Agent (AMA), Data Collection Rules (DCR), and Log Analytics.

---

## 🔧 Resources Created

- `azurerm_log_analytics_workspace`: Central workspace for metrics and logs
- `azurerm_monitor_data_collection_endpoint`: Ingestion endpoint used by AMA
- `azurerm_monitor_data_collection_rule`: Defines syslog and performance counter collection
- `azurerm_monitor_data_collection_rule_association`: Links the VM to the DCR
- `azurerm_monitor_diagnostic_setting`: Enables metric collection via Azure Monitor

---

## 🧰 Input Variables

| Name                  | Description                                 | Type    | Required |
|-----------------------|---------------------------------------------|---------|----------|
| `prefix`              | Prefix used for naming resources            | string  | yes      |
| `location`            | Azure region where resources are deployed   | string  | yes      |
| `resource_group_name` | Name of the resource group                  | string  | yes      |
| `vm_id`               | ID of the virtual machine to monitor        | string  | yes      |

---

## 🌐 Outputs

| Name                        | Description                                      |
|-----------------------------|--------------------------------------------------|
| `log_analytics_workspace_id`| Resource ID of the Log Analytics workspace       |
| `dcr_id`                    | Resource ID of the Data Collection Rule (DCR)    |

---
## 🔄 Monitoring Details

- **Syslog facilities collected**: `auth`, `cron`, `daemon`, `syslog`
- **Log levels**: `Error`, `Warning`, `Info`
- **Performance counters**:
  - CPU: `% Processor Time`
  - Memory: `Available MBytes`, `% Used Memory`
  - Disk: `% Free Space`, `Disk Read Bytes/sec`
  - Network: `Total Bytes Received`
  - System: `Uptime`
- **Streams used**: `Microsoft-Syslog`, `Microsoft-Perf`

---

## 🚀 Example Usage

```hcl
module "monitoring" {
  source              = "./modules/monitoring"
  prefix              = "lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_id               = module.compute.vm_id
}
```

---

## 📌 Notes
- The Data Collection Endpoint (DCE) is required for AMA to ingest data via DCR.
- This module handles everything: workspace, DCE, DCR, association, and diagnostics.
- You can query logs and metrics in Azure Monitor or visualize them in Grafana.