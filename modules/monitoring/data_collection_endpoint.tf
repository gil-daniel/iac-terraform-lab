# Creates a Data Collection Endpoint (DCE) for the monitoring pipeline
# This endpoint acts as the ingestion point for Data Collection Rules (DCRs)
resource "azurerm_monitor_data_collection_endpoint" "dce" {
  # Name uses the module prefix to keep resource names consistent
  name                = "${var.prefix}-dce"

  # Place the endpoint in the same location as your other monitoring resources
  location            = var.location

  # Link the endpoint to the central monitoring resource group
  resource_group_name = var.resource_group_name
}
