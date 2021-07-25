terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


resource "azurerm_function_app" "function_app" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  os_type = "linux"
  version = "~3"

  identity {
    type = "SystemAssigned"
  }
}