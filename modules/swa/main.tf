terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_static_site" "static_web_app" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
}