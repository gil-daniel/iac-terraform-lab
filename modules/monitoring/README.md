# Monitoring Module

This module provisions the necessary resources to enable monitoring for a Linux virtual machine in Azure using Azure Monitor Agent (AMA) and Log Analytics.

## Resources Created

- `azurerm_log_analytics_workspace`: Log Analytics workspace for metrics and log ingestion
- `azurerm_monitor_diagnostic_setting`: Diagnostic setting that links the VM to the workspace for metric collection

## Input Variables

| Name                 | Description                                 | Type   | Required |
|----------------------|---------------------------------------------|--------|----------|
| `prefix`             | Prefix used for naming resources            | string | yes      |
| `location`           | Azure region where resources are deployed   | string | yes      |
| `resource_group_name`| Name of the resource group                  | string | yes      |
| `vm_id`              | ID of the virtual machine to monitor        | string | yes      |

## Outputs

| Name                        | Description                                  |
|-----------------------------|----------------------------------------------|
| `log_analytics_workspace_id`| Resource ID of the Log Analytics workspace   |

## Notes

- This module **does not create the Data Collection Rule (DCR)** or associate it with the VM. That is handled in the root `main.tf` using a `null_resource` and `local-exec`.
- The workspace created here can be used for ingesting logs via AMA, including Syslog and performance metrics.

## Example Usage

```hcl
module "monitoring" {
  source              = "./modules/monitoring"
  prefix              = "lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_id               = module.compute.vm_id
}
