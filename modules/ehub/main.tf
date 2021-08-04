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


resource "azurerm_eventhub_namespace_authorization_rule" "nsrule" {
  name                = "auth"
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group
  listen              = true
  send                = true
  manage              = false
}

resource "azurerm_eventhub" "hub" {
  name                = var.name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group
  partition_count     = 1
  message_retention   = 1
}
