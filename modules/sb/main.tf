terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_servicebus_namespace" "sb_ns" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku
  capacity = var.capacity
}

resource "azurerm_servicebus_queue" "notifications_queue" {
  name                = "notifications"
  resource_group_name = azurerm_servicebus_namespace.sb_ns.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sb_ns.name
  enable_partitioning = true
}