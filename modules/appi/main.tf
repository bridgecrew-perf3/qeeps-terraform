terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_application_insights" "appi" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  application_type    = "web"
  retention_in_days = var.retention
}