terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


resource "azurerm_eventhub" "hub" {
  name                = var.name
  namespace_name      = var.ehub_namespace
  resource_group_name = var.resource_group
  partition_count     = 1
  message_retention   = 1
}
