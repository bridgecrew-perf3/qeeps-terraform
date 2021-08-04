terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_eventhub_namespace" "namespace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku
  capacity            = 1
}

resource "azurerm_eventhub" "hub" {
  name                = var.name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "rule" {
  name                = "ad-authorization"
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.hub.name
  resource_group_name = var.resource_group
  listen              = true
  send                = true
  manage              = false
}