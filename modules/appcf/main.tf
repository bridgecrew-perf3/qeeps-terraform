terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


resource "azurerm_app_configuration" "app_configuration" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  sku = var.sku

  identity {
    type = "SystemAssigned"
  }
}